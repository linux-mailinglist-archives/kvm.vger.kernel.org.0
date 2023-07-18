Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318E9757788
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 11:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjGRJOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 05:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjGRJOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 05:14:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8F310F5
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 02:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689671599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lrWIzsgWi5PVFNBjLu8rbxMEA2rXGKqAaheIHU+uz9Y=;
        b=V+L52Io5BuZJYUVJDYZF5e92iYOTyIdRvWWu4R5LqOYQJqWVf6IfMunwKkYGwVv4s23GmC
        7k0ZFFcia9wbHFbwC9jHQTj35ZZA79x5jDlm2W1wwPVlW2FYgtgIAVikC4e2quaG7P9zRL
        Bce+irksmoTdEw1UfS/ocRWKunHUHaA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-GdB-necKNRWkHIwBndRTSw-1; Tue, 18 Jul 2023 05:13:16 -0400
X-MC-Unique: GdB-necKNRWkHIwBndRTSw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 940B68D1685;
        Tue, 18 Jul 2023 09:13:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 048FB1454142;
        Tue, 18 Jul 2023 09:13:11 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/3] Fix 'Spurious APIC interrupt (vector 0xFF) on CPU#n' issue
Date:   Tue, 18 Jul 2023 12:13:07 +0300
Message-Id: <20230718091310.119672-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: x86: VMX: __kvm_apic_update_irr must update the IRR atomically=0D
  KVM: x86: VMX: set irr_pending in kvm_apic_update_irr=0D
  KVM: x86: check the kvm_cpu_get_interrupt result before using it=0D
=0D
 arch/x86/kvm/lapic.c | 23 +++++++++++++++--------=0D
 arch/x86/kvm/x86.c   | 10 +++++++---=0D
 2 files changed, 22 insertions(+), 11 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

