Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA89763838
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 16:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjGZOAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 10:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbjGZOAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 10:00:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E881982
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 07:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690380000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hI+xZjnjOx6iQYY+/HFIgbw6khCjngJ7Cxx7Odmq6DI=;
        b=UujQctMtMaRBOjOSmqMvk6LYEtjlsPh7M1OD4I/UugyJaGWzAajX99xGMz/jED9Gok/URE
        4vX1Sno2Jy5bN4300DaYsmE4DYYsbC6UmQqmFKlre+X4jwDMpfTlH9eBLPZBEXM2PTivVN
        I+gCb90aGcZomu9L/DRxK0UZOuJhtbs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-02aUmBj3PxCnqC9BrYH_Dw-1; Wed, 26 Jul 2023 09:59:56 -0400
X-MC-Unique: 02aUmBj3PxCnqC9BrYH_Dw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF4EF8028B2;
        Wed, 26 Jul 2023 13:59:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2265840C2063;
        Wed, 26 Jul 2023 13:59:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/3] Fix 'Spurious APIC interrupt (vector 0xFF) on CPU#n' issue
Date:   Wed, 26 Jul 2023 16:59:42 +0300
Message-Id: <20230726135945.260841-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently we found an issue which causes these error messages=0D
to be sometimes logged if the guest has VFIO device attached:=0D
=0D
'Spurious APIC interrupt (vector 0xFF) on CPU#0, should never happen'=0D
=0D
It was traced to the incorrect APICv inhibition bug which started with=0D
'KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base'=0D
(All these issues are now fixed)=0D
=0D
However, there are valid cases for the APICv to be inhibited and it should =
not=0D
cause spurious interrupts to be injected to the guest.=0D
=0D
After some debug, the root cause was found and it is that __kvm_apic_update=
_irr=0D
doesn't set irr_pending which later triggers a int->unsigned char conversio=
n=0D
bug which leads to the wrong 0xFF injection.=0D
=0D
This also leads to an unbounded delay in injecting the interrupt and hurts=
=0D
performance.=0D
=0D
In addition to that, I also noticed that __kvm_apic_update_irr is not atomi=
c=0D
in regard to IRR, which can lead to an even harder to debug bug.=0D
=0D
V2: applied Paolo's feedback for the patch 1.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: x86: VMX: __kvm_apic_update_irr must update the IRR atomically=0D
  KVM: x86: VMX: set irr_pending in kvm_apic_update_irr=0D
  KVM: x86: check the kvm_cpu_get_interrupt result before using it=0D
=0D
 arch/x86/kvm/lapic.c | 25 +++++++++++++++++--------=0D
 arch/x86/kvm/x86.c   | 10 +++++++---=0D
 2 files changed, 24 insertions(+), 11 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

