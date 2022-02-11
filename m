Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF72D4B1E31
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 07:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243059AbiBKGIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 01:08:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237990AbiBKGIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 01:08:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37900F28
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 22:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644559698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wWsa088H+m61GloikKboHI/NqK+TRVd8yPN6et7DuH4=;
        b=cJ/Lv+dLvg0JSdmK8P1bFvodtCmiiP/2HKRvk9yrkiK0EcJZVasFv2uVCiEN8Og3qu76CG
        VEqJ8mLkMCdA6NUV7kNNIt+UV+24UTuKv9xLqDI5lCgM7mh04fximr/CACqfUSTJFuHqmP
        RXECh5ZdnVc1npmdJnpHi4FBdBy9NiA=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-2yyFEA0sP06J0ZqFZdwvcg-1; Fri, 11 Feb 2022 01:08:16 -0500
X-MC-Unique: 2yyFEA0sP06J0ZqFZdwvcg-1
Received: by mail-oi1-f200.google.com with SMTP id ay31-20020a056808301f00b002d06e828c00so2166676oib.2
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 22:08:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wWsa088H+m61GloikKboHI/NqK+TRVd8yPN6et7DuH4=;
        b=ArdDZxxPf8uACOtSR/GiU2f9DtP2IREdZHc0Wb5boCpp72LdcWXedLeddAl3m5WR3Y
         xirquS26IiaMlKHNimMY6fmqO5A2ioMtR4fw3j5CNkN/JTJyVdl9mZtEA03uYX9jIYCK
         xsrl4TKqw98xNWzf8eW8APCC9HGnyQGPb3+Y9/PG63JqO9USCbrtefc52GQ24naL4p5N
         matHA5KHtwz7qAXWskP4YJlcWE8BMc6oY3spDn4vNu0eri/9nMBxJEk2V/40S+QJ2B8d
         8w9+ncqbvzJiG1QRYNOupDmfDtSN7olKSjQ84Jw4KkSo/QhZaI2195fgSV4z7Suuu32k
         t+gg==
X-Gm-Message-State: AOAM532AfjiMJM5PxG7j56+4rCIOdP/MTI/f9G1sXhZ8KHRIqSSna1NI
        9YKXVsxn8mf5keuZq4eCD0fKrOKD4vGwuwvpXLnq4XT2i+ekPrbGQIJusJ+gCG/1IHDpZgiUFhK
        AA+T2bgyhraqu
X-Received: by 2002:a05:6808:56d:: with SMTP id j13mr56850oig.153.1644559695514;
        Thu, 10 Feb 2022 22:08:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw5gU4wIGXlLW1Jvzjpc0mf5KT7f4nC8R9j24uARLqBgu6E+RgZKwF7wvmbioDaby82kslm/g==
X-Received: by 2002:a05:6808:56d:: with SMTP id j13mr56833oig.153.1644559695255;
        Thu, 10 Feb 2022 22:08:15 -0800 (PST)
Received: from LeoBras.redhat.com ([2804:431:c7f0:b1af:f10e:1643:81f3:16df])
        by smtp.gmail.com with ESMTPSA id n9sm8577282otf.9.2022.02.10.22.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 22:08:14 -0800 (PST)
From:   Leonardo Bras <leobras@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Leonardo Bras <leobras@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 1/1] x86/kvm/fpu: Mask guest fpstate->xfeatures with guest_supported_xcr0
Date:   Fri, 11 Feb 2022 03:07:43 -0300
Message-Id: <20220211060742.34083-1-leobras@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During host/guest switch (like in kvm_arch_vcpu_ioctl_run()), the kernel
swaps the fpu between host/guest contexts, by using fpu_swap_kvm_fpstate().

When xsave feature is available, the fpu swap is done by:
- xsave(s) instruction, with guest's fpstate->xfeatures as mask, is used
  to store the current state of the fpu registers to a buffer.
- xrstor(s) instruction, with (fpu_kernel_cfg.max_features &
  XFEATURE_MASK_FPSTATE) as mask, is used to put the buffer into fpu regs.

For xsave(s) the mask is used to limit what parts of the fpu regs will
be copied to the buffer. Likewise on xrstor(s), the mask is used to
limit what parts of the fpu regs will be changed.

The mask for xsave(s), the guest's fpstate->xfeatures, is defined on
kvm_arch_vcpu_create(), which (in summary) sets it to all features
supported by the cpu which are enabled on kernel config.

This means that xsave(s) will save to guest buffer all the fpu regs
contents the cpu has enabled when the guest is paused, even if they
are not used.

This would not be an issue, if xrstor(s) would also do that.

xrstor(s)'s mask for host/guest swap is basically every valid feature
contained in kernel config, except XFEATURE_MASK_PKRU.
Accordingto kernel src, it is instead switched in switch_to() and
flush_thread().

Then, the following happens with a host supporting PKRU starts a
guest that does not support it:
1 - Host has XFEATURE_MASK_PKRU set. 1st switch to guest,
2 - xsave(s) fpu regs to host fpustate (buffer has XFEATURE_MASK_PKRU)
3 - xrstor(s) guest fpustate to fpu regs (fpu regs have XFEATURE_MASK_PKRU)
4 - guest runs, then switch back to host,
5 - xsave(s) fpu regs to guest fpstate (buffer now have XFEATURE_MASK_PKRU)
6 - xrstor(s) host fpstate to fpu regs.
7 - kvm_vcpu_ioctl_x86_get_xsave() copy guest fpstate to userspace (with
    XFEATURE_MASK_PKRU, which should not be supported by guest vcpu)

On 5, even though the guest does not support PKRU, it does have the flag
set on guest fpstate, which is transferred to userspace via vcpu ioctl
KVM_GET_XSAVE.

This becomes a problem when the user decides on migrating the above guest
to another machine that does not support PKRU:
The new host restores guest's fpu regs to as they were before (xrstor(s)),
but since the new host don't support PKRU, a general-protection exception
ocurs in xrstor(s) and that crashes the guest.

This can be solved by making the guest's fpstate->user_xfeatures only hold
values compatible to guest_supported_xcr0. This way, on 7 the only flags
copied to userspace will be the ones compatible to guest requirements,
and thus there will be no issue during migration.

As a bonus, will also fail if userspace tries to set fpu features
that are not compatible to the guest configuration. (KVM_SET_XSAVE ioctl)

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 arch/x86/kernel/fpu/core.c | 1 +
 arch/x86/kvm/cpuid.c       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 8dea01ffc5c1..e83d8b1fbc83 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -34,6 +34,7 @@ DEFINE_PER_CPU(u64, xfd_state);
 /* The FPU state configuration data for kernel and user space */
 struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
 struct fpu_state_config fpu_user_cfg __ro_after_init;
+EXPORT_SYMBOL(fpu_user_cfg);
 
 /*
  * Represents the initial FPU state. It's mostly (but not completely) zeroes,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 494d4d351859..aecebd6bc490 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -296,6 +296,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
+	/* Mask out features unsupported by guest */
+	vcpu->arch.guest_fpu.fpstate->user_xfeatures =
+		fpu_user_cfg.default_features & vcpu->arch.guest_supported_xcr0;
+
 	kvm_update_pv_runtime(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-- 
2.35.1

