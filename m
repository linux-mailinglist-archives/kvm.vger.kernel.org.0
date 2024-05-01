Return-Path: <kvm+bounces-16378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 348778B91B0
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 00:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 576E21C213D0
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 22:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C6250286;
	Wed,  1 May 2024 22:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2uieFxCE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093201E4AF
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 22:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714603251; cv=none; b=PgzMJr9BBfSIm9Da/N2AuaLpDzFBuqBGTUuWRQr2F8JOcRsI3mlxoBfiJwwrQg94d15Jrrs3/wq7WhNwtADCXxSUkJikrVH41d38PrZI/vt9/I4KxcbBNmNdVwX/jHMoksmnrEb3DU+94XVmRGmRWZ2A+ZAZ7fSfVc/rVxAG+KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714603251; c=relaxed/simple;
	bh=IiDcFptLMdgb3/1nfaa19sIHtTalENoDFZQD7gAW9MU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VCUi156DauIiC41+MaTx7XPMjWK1QmFspMp/5K1Bc7OjlJpfWtlkDprZ8avFmyaDsqsJngyfZ+FnQ8sQpiAxwYtpb4MY0kIjxCDW4KW1GL7VcrQoIyYUirTOQlQjrFKfIO3ZTwmbwVBr2stkpcwzxLhT0qFlTDIzmfDJkrwZilQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2uieFxCE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ec56ab5e39so22812655ad.2
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 15:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714603249; x=1715208049; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rt/4BZWOrpUOF7PzlC/RN5bc07yVSBXbxiXU6J5bsS8=;
        b=2uieFxCEAKq3kkU4FtcBLqs/xReEepgsboH4LGXNODOgFgo1D71quaqQQAJpdDT2HJ
         ses/6JOvgHVBj40u3SrMuM5UGd4VWqvHLUuf/AdnW8YjoWLULoNNjY6l64emadKSp0Ia
         RAB8OD7QqQfGfL4KfFFG1uk1GJRtY5LIPPzPZsY4TA7Jl+ZcwsnNwumc7EMlG21+DBFg
         VI0XzCgNzWbwfMKPFmZDvlTF8HAUHEBZJCNkIoUlmES35ouw5kaSnypZChrGAftQAbLz
         6+PMG20pPx6lR7nWd1Fnt4ErL4lXNO6JM1YwBgc8pYe0qymTlGrMiqPX8QOyVoioEZyu
         qq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714603249; x=1715208049;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rt/4BZWOrpUOF7PzlC/RN5bc07yVSBXbxiXU6J5bsS8=;
        b=mhgdyO0dQkuCULbZ4v0RCRBKccYld+Wu/PX+VRwcqFFk2GmBUSwFypkM9DH1BUdWPo
         StReCtldnGyv5VUOaiv0z+uihJtdosqPxnv2qS5plFWSnD3H9fYGpKBmmKM8KTWJnWoM
         wXrhQSw0z+JH72C0ZoPngJLJIzD9fizXjYBh1frbDN68Dhk44PJR4paIp5vhp/1xOXYW
         4LV5QM03r+FYeXUfjVahD7+C39fNH9fGzO2MgoUxWlPoAhdxHGNBRIIj/fDzkQ+GQNHk
         Rn3GNh8zzF8kzoCxNqsJopAFvUlEkrGjml3intKN0STVc/l19EhM2BGv19G7eCouEWV9
         vtRA==
X-Forwarded-Encrypted: i=1; AJvYcCXh2qWC70DVl/1PKHXUS4drngJKjL4RjVn6DXji7nKIhPIyu4TRABzjhKf2Kyj+Hi8AU5E9WvQ9jPI1wlfxTr51prIQ
X-Gm-Message-State: AOJu0Yxbdqfq6WT7RGydtNDXUGfUL7yCq1M3uK4wQqaReQYc4sBslaTG
	qLBZp5S4/T8Bbm08eEIfUJoXNDEutHEAW41zoUXa/QXxgXXh2x8H1IZRGQ+8BarcD22YCX+MVKr
	W8A==
X-Google-Smtp-Source: AGHT+IGinMb3eodPjryBPLOEdE6sjayigodRjkxa0Wa/LFaQbbJME9u7v6BfG2AyFp21HLt9Vm2c2BaSg3M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa0d:b0:1ea:26bd:fd95 with SMTP id
 la13-20020a170902fa0d00b001ea26bdfd95mr8989plb.11.1714603248688; Wed, 01 May
 2024 15:40:48 -0700 (PDT)
Date: Wed, 1 May 2024 15:40:46 -0700
In-Reply-To: <20240219074733.122080-18-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-18-weijiang.yang@intel.com>
Message-ID: <ZjLE7giCsEI4Sftp@google.com>
Subject: Re: [PATCH v10 17/27] KVM: x86: Report KVM supported CET MSRs as to-be-saved
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Feb 18, 2024, Yang Weijiang wrote:
> Add CET MSRs to the list of MSRs reported to userspace if the feature,
> i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.
> 
> SSP can only be read via RDSSP. Writing even requires destructive and
> potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
> SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
> for the GUEST_SSP field of the VMCS.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm_para.h |  1 +
>  arch/x86/kvm/vmx/vmx.c               |  2 ++
>  arch/x86/kvm/x86.c                   | 18 ++++++++++++++++++
>  3 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 605899594ebb..9d08c0bec477 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -58,6 +58,7 @@
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>  #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
> +#define MSR_KVM_SSP	0x4b564d09

We never resolved the conservation from v6[*], but I still agree with Maxim's
view that defining a synthetic MSR, which "steals" an MSR from KVM's MSR address
space, is a bad idea.

And I still also think that KVM_SET_ONE_REG is the best way forward.  Completely
untested, but I think this is all that is needed to wire up KVM_{G,S}ET_ONE_REG
to support MSRs, and carve out room for 250+ other register types, plus room for
more future stuff as needed.

We'll still need a KVM-defined MSR for SSP, but it can be KVM internal, not uAPI,
e.g. the "index" exposed to userspace can simply be '0' for a register type of
KVM_X86_REG_SYNTHETIC_MSR, and then the translated internal index can be any
value that doesn't conflict.

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ef11aa4cab42..ca2a47a85fa1 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -410,6 +410,16 @@ struct kvm_xcrs {
        __u64 padding[16];
 };
 
+#define KVM_X86_REG_MSR                        (1 << 2)
+#define KVM_X86_REG_SYNTHETIC_MSR      (1 << 3)
+
+struct kvm_x86_reg_id {
+       __u32 index;
+       __u8 type;
+       __u8 rsvd;
+       __u16 rsvd16;
+};
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47d9f03b7778..53f2b43b4651 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2244,6 +2244,30 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
        return kvm_set_msr_ignored_check(vcpu, index, *data, true);
 }
 
+static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
+{
+       u64 val;
+
+       r = do_get_msr(vcpu, reg.index, &val);
+       if (r)
+               return r;
+
+       if (put_user(val, value);
+               return -EFAULT;
+
+       return 0;
+}
+
+static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
+{
+       u64 val;
+
+       if (get_user(val, value);
+               return -EFAULT;
+
+       return do_set_msr(vcpu, reg.index, &val);
+}
+
 #ifdef CONFIG_X86_64
 struct pvclock_clock {
        int vclock_mode;
@@ -5976,6 +6000,39 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
                srcu_read_unlock(&vcpu->kvm->srcu, idx);
                break;
        }
+       case KVM_GET_ONE_REG:
+       case KVM_SET_ONE_REG: {
+               struct kvm_x86_reg_id id;
+               struct kvm_one_reg reg;
+               u64 __user *value;
+
+               r = -EFAULT;
+               if (copy_from_user(&reg, argp, sizeof(reg)))
+                       break;
+
+               r = -EINVAL;
+               id = (struct kvm_x86_reg)reg->id;
+               if (id.rsvd || id.rsvd16)
+                       break;
+
+               if (id.type != KVM_X86_REG_MSR &&
+                   id.type != KVM_X86_REG_SYNTHETIC_MSR)
+                       break;
+
+               if (id.type == KVM_X86_REG_SYNTHETIC_MSR) {
+                       id.type = KVM_X86_REG_MSR;
+                       r = kvm_translate_synthetic_msr(&id.index);
+                       if (r)
+                               break;
+               }
+
+               value = u64_to_user_ptr(reg.addr);
+               if (ioctl == KVM_GET_ONE_REG)
+                       r = kvm_get_one_msr(vcpu, id.index, value);
+               else
+                       r = kvm_set_one_msr(vcpu, id.index, value);
+               break;
+       }
        case KVM_TPR_ACCESS_REPORTING: {
                struct kvm_tpr_access_ctl tac;
 


