Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93B84ACEED
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 03:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345934AbiBHC2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 21:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345926AbiBHC2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 21:28:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E690C0401E7
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 18:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644287317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ssfxozQsVXkPqd8hURrWGqEOTDmpelF59UyVKkS50EU=;
        b=V/EIlirUbeFtlNY0PgW4YQTASMyQOj+54tRj6BAZxpJFs8W2mnND3+ZdsquMe6rZpHmVtW
        QrzR8IpcHsRYZARfmefr1wg9uJzUQ+JEbHicmsyNiYgadwymrUJMYWyae5gOYQ0F7LPS+H
        3hs/rF7BP1t0tJYc+aZMljsKdf1TLo0=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-F7QB1qRpMKyT7tS8TlZJvg-1; Mon, 07 Feb 2022 21:28:36 -0500
X-MC-Unique: F7QB1qRpMKyT7tS8TlZJvg-1
Received: by mail-oo1-f69.google.com with SMTP id k16-20020a4aa5d0000000b002eaa82bf180so10310144oom.0
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 18:28:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ssfxozQsVXkPqd8hURrWGqEOTDmpelF59UyVKkS50EU=;
        b=uMvVh8K2xfHcpy1bOioHvFKn/gVVlKFo5CXEibaLcrL/oZIqTjk4RwCj0NNqHOP98c
         MjtGp0EVXr5gluGGQFLYXeJcx6L8NaoOBPVGs31puT+1Kh7syba6FtueBJjgJpQzN9Ia
         ydPALzc2H2/ZgqKoExhWrv0xbS6BDuKO8L/XD7F7Vw1I/SWvXFpUYwsW4qH5G7QqcktR
         /hfCsAM14boBy0rqhVS2NA8uoPfZ6dUl6WXxPxVBedELlQ7/u8GuD1XtGhctnUtGmrcV
         2h+yjnJjX89POovxgYM/d75Ix4nKfQEthBOj1eR5FzlJGK7an7Jfcj+0foJlG11YkMyr
         HhtA==
X-Gm-Message-State: AOAM531W8sXbf5HUqqV7AefYS2w+Igl5yGxoqF5fvfPn075bgYqYtsSv
        pvhKpANoMOc6S7UR+42Fn34/c2jfMHW/jWLhA22+X297vkvwUe1FbcsRKK6yNBJ+opSdMCNwXUO
        7PGElfYVkvzbb
X-Received: by 2002:a05:6808:158f:: with SMTP id t15mr765194oiw.245.1644287313997;
        Mon, 07 Feb 2022 18:28:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKiOrDglYt2FuXCmTmQ1mgfMz6OLvLtfGvYuXOiUJqkP4WbrVQO9aFHbdfA1Qfwpp+yI+c3w==
X-Received: by 2002:a05:6808:158f:: with SMTP id t15mr765182oiw.245.1644287313783;
        Mon, 07 Feb 2022 18:28:33 -0800 (PST)
Received: from localhost.localdomain ([2804:431:c7f0:b1af:f10e:1643:81f3:16df])
        by smtp.gmail.com with ESMTPSA id y15sm4617016oof.37.2022.02.07.18.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 18:28:33 -0800 (PST)
From:   Leonardo Bras <leobras@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Leonardo Bras <leobras@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] x86/kvm/fpu: Mask guest fpstate->xfeatures with guest_supported_xcr0
Date:   Mon,  7 Feb 2022 23:28:10 -0300
Message-Id: <20220208022809.575769-1-leobras@redhat.com>
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
 arch/x86/kvm/cpuid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 28be02adc669..2337079445ba 100644
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

