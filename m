Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDC9588FA7
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiHCPuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiHCPuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:50:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A460D262B
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659541821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/BrQz+CyfVcc2k2vo2CUTQfHHEz6+03jB7eKZ/pazJY=;
        b=CCMVAYOScJitjppS0TLVBXpqN25jlY499umtVOWGOb9cw27GB7iTsa9/Wc5KABICw1kw0c
        KaoWUW+igEjbJ+NirCWHK6DyI7hl/6dfk/ps6Q8AhvYnx+MmBmWAHaVqzVyP/z0q/Gz5+f
        0qD1xda3nc3MjgG0uqCEiIXL4xQ2p4g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-3w-6go72NbWtFWzI4ESLZQ-1; Wed, 03 Aug 2022 11:50:17 -0400
X-MC-Unique: 3w-6go72NbWtFWzI4ESLZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BDCD2919EAE;
        Wed,  3 Aug 2022 15:50:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 877F01121314;
        Wed,  3 Aug 2022 15:50:12 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 00/13] SMM emulation and interrupt shadow fixes
Date:   Wed,  3 Aug 2022 18:49:58 +0300
Message-Id: <20220803155011.43721-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
V3: addressed most of the review feedback from Sean (thanks!)=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (13):=0D
  bug: introduce ASSERT_STRUCT_OFFSET=0D
  KVM: x86: emulator: em_sysexit should update ctxt->mode=0D
  KVM: x86: emulator: introduce emulator_recalc_and_set_mode=0D
  KVM: x86: emulator: update the emulation mode after rsm=0D
  KVM: x86: emulator: update the emulation mode after CR0 write=0D
  KVM: x86: emulator/smm: number of GPRs in the SMRAM image depends on=0D
    the image format=0D
  KVM: x86: emulator/smm: add structs for KVM's smram layout=0D
  KVM: x86: emulator/smm: use smram structs in the common code=0D
  KVM: x86: emulator/smm: use smram struct for 32 bit smram load/restore=0D
  KVM: x86: emulator/smm: use smram struct for 64 bit smram load/restore=0D
  KVM: x86: SVM: use smram structs=0D
  KVM: x86: SVM: don't save SVM state to SMRAM when VM is not long mode=0D
    capable=0D
  KVM: x86: emulator/smm: preserve interrupt shadow in SMRAM=0D
=0D
 arch/x86/include/asm/kvm_host.h |  11 +-=0D
 arch/x86/kvm/emulate.c          | 305 +++++++++++++++++---------------=0D
 arch/x86/kvm/kvm_emulate.h      | 223 ++++++++++++++++++++++-=0D
 arch/x86/kvm/svm/svm.c          |  30 ++--=0D
 arch/x86/kvm/vmx/vmcs12.h       |   5 +-=0D
 arch/x86/kvm/vmx/vmx.c          |   4 +-=0D
 arch/x86/kvm/x86.c              | 175 +++++++++---------=0D
 include/linux/build_bug.h       |   9 +=0D
 8 files changed, 497 insertions(+), 265 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

