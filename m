Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E27E55353E
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiFUPJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352232AbiFUPJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:09:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E9551C10F
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=v6i2sWSli48GTHsEDuVBdZ0meIchicF21PFUgvtM/2Q=;
        b=BDx8/RQFWl+l9pgQUBrMNCooRlfrZv87vZjh2mrZQ/BTNPwunIW3WBN6Rhq/RjW9PE83og
        toUPo/YrnN55/Wknqp1joygWg5LiYVc9GZxfvk1Noityp5oIJZLsvDTXRuyMkhIU/Bvzwx
        cLxglG/R6T386Jtopl/AIDLl4/zuPsU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-D6fPNifgP9eHTJqlob27rQ-1; Tue, 21 Jun 2022 11:09:08 -0400
X-MC-Unique: D6fPNifgP9eHTJqlob27rQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4C30803520;
        Tue, 21 Jun 2022 15:09:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 679EB9D7F;
        Tue, 21 Jun 2022 15:09:03 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 00/11] SMM emulation and interrupt shadow fixes
Date:   Tue, 21 Jun 2022 18:08:51 +0300
Message-Id: <20220621150902.46126-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is a result of long debug work to find out why=0D
sometimes guests with win11 secure boot=0D
were failing during boot.=0D
=0D
During writing a unit test I found another bug, turns out=0D
that on rsm emulation, if the rsm instruction was done in real=0D
or 32 bit mode, KVM would truncate the restored RIP to 32 bit.=0D
=0D
I also refactored the way we write SMRAM so it is easier=0D
now to understand what is going on.=0D
=0D
The main bug in this series which I fixed is that we=0D
allowed #SMI to happen during the STI interrupt shadow,=0D
and we did nothing to both reset it on #SMI handler=0D
entry and restore it on RSM.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (11):=0D
  KVM: x86: emulator: em_sysexit should update ctxt->mode=0D
  KVM: x86: emulator: introduce update_emulation_mode=0D
  KVM: x86: emulator: remove assign_eip_near/far=0D
  KVM: x86: emulator: update the emulation mode after rsm=0D
  KVM: x86: emulator: update the emulation mode after CR0 write=0D
  KVM: x86: emulator/smm: number of GPRs in the SMRAM image depends on=0D
    the image format=0D
  KVM: x86: emulator/smm: add structs for KVM's smram layout=0D
  KVM: x86: emulator/smm: use smram struct for 32 bit smram load/restore=0D
  KVM: x86: emulator/smm: use smram struct for 64 bit smram load/restore=0D
  KVM: x86: SVM: use smram structs=0D
  KVM: x86: emulator/smm: preserve interrupt shadow in SMRAM=0D
=0D
 arch/x86/include/asm/kvm_host.h |   6 -=0D
 arch/x86/kvm/emulate.c          | 305 ++++++++++++++++----------------=0D
 arch/x86/kvm/kvm_emulate.h      | 146 +++++++++++++++=0D
 arch/x86/kvm/svm/svm.c          |  28 +--=0D
 arch/x86/kvm/x86.c              | 162 ++++++++---------=0D
 5 files changed, 394 insertions(+), 253 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

