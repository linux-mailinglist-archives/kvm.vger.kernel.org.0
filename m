Return-Path: <kvm+bounces-37925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FE0A31823
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 22:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 878A87A28FB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 21:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B8E1F03CC;
	Tue, 11 Feb 2025 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vWlAo3/V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110B726772A
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 21:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739310413; cv=none; b=D02OuDsK3/vk6ynn4qzJcbeeE/avX6XB7bfi7m5uYi9bbzkeURHf/l7YTjm42apOQAPcwdPmFNMrJVh+ULzKMY6z9/yIYnLx+N122VDX2UAi9XPRwAgNXEDYeOh6oi6rRyuUzKBoSt0u5QAl9V10s7AIimnHPALN7cAYwoNIt+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739310413; c=relaxed/simple;
	bh=mXdj/8Wy7lAGqqOFf0YkOFzZunV8YsJ1KxV4OGFZz20=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j135AyFs9lvCtELQfzGDEwlvwTbCNIUi6osk9iTrJsO14kR5oni2YkJmnaAKniiLHTMuzdcbaEaKrMtDQ+Yl/kt0DQFVBS7UUN8wCR2vmc28DIM68Y0mVkBlaHStElqxuiOuxr1pxvGPSA9hHdw2vIlqaviWSLDNAFxUZsE+wc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vWlAo3/V; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21f6890d42dso129947245ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 13:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739310411; x=1739915211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6mvCPTi078oatgZttY+CUepNgmI0pKTTmm/hDNy/tGc=;
        b=vWlAo3/V46XOYarc1uvsf/B7/ZnM4NA0QhmJG1Yy1FCAwUHbLFNpH/eKiJaU6cOkAp
         3KpHA0MEEvBpBfTjwvQ9ZMUef40l7hlcxOnDfeMleKqgoCphepz+658igBDa1f+Tje6t
         ZpZ8PcmhTaihcdPhnxnnsYHy0RJAe0NCH5R/5u2HXnGUqJvK9FCQmysGdx5D20Ie1V/R
         177PMnNEUnLdDKgR73Ui+uzgmkv9W/YjMa7hrzgb66/x+qNW9eHBJk7aHcAISfvF+6Sc
         4DDDsBeoYsaoQVoGy4srCtCAoAVIoz3jjx8MuMnqsZpywIKhhQuaBJlxzxyD5ylvSQPN
         IIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739310411; x=1739915211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6mvCPTi078oatgZttY+CUepNgmI0pKTTmm/hDNy/tGc=;
        b=oA0QHiTfKw60JkdvF/1He9fkg4er0MMRLrmSd0xjyazE2NUhfd5EtAdZEKZiqF4pO/
         nllddvH6uHcOsM9Ka5AovDD6IrWbKbSCeiXzZRxq6VWbsstLQtVv43Te+86B8BbO/BVp
         qlfLY6kW6OOc7QAlhAg8yxhCozM5I0QQhBHbgEJ6U+JwbK0D+4Y8bT7MaOgKoITU0BVu
         EndrhvcYeMh3NE7GTA2dgTHcoWB0lMnKEH/igwD+zpem7Wl70v2Gtszh0g2KZZSqDnus
         IzmKRJCJZv5+bbLSd+TIILxrvbWQGC41Dvp3ISfiTApMb5JmKceG1lrloU3y/TrejFMV
         acBA==
X-Forwarded-Encrypted: i=1; AJvYcCV+qErdNx+jDi0IdG7dYImRDXZcbyPaWzoXiScuPU5H2kE5D/bG3YVExPB7QHBjeAIZADc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJezvTFL0OTA8syZgJbAgRMNVtMWJhMVEr8hqcwYZGYOGtdr8g
	zxEm02lixTKjIE4E8+RwLMOUmDQJdWPxD69KZo3FafAg6hOBHfqTIo/EsDX1AbxX7v/VQjGFMyk
	rhA==
X-Google-Smtp-Source: AGHT+IHqctElHQsje8GD0oIhIva/TYzquQdAPSXcMtbPFuairkitbpoJ8EDI9U/Ym3LShWUab2Umb92QUi8=
X-Received: from pfan21.prod.google.com ([2002:aa7:8a55:0:b0:730:7a22:c567])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2450:b0:1e1:bdae:e04d
 with SMTP id adf61e73a8af0-1ee5c85db6bmr1716822637.36.1739310411277; Tue, 11
 Feb 2025 13:46:51 -0800 (PST)
Date: Tue, 11 Feb 2025 13:46:49 -0800
In-Reply-To: <4eb24414-4483-3291-894a-f5a58465a80d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207233410.130813-1-kim.phillips@amd.com> <20250207233410.130813-3-kim.phillips@amd.com>
 <4eb24414-4483-3291-894a-f5a58465a80d@amd.com>
Message-ID: <Z6vFSTkGkOCy03jN@google.com>
Subject: Re: [PATCH v3 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Kim Phillips <kim.phillips@amd.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	"Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Kishon Vijay Abraham I <kvijayab@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 10, 2025, Tom Lendacky wrote:
> On 2/7/25 17:34, Kim Phillips wrote:
> > @@ -289,6 +291,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
> >  #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
> >  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
> >  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
> > +#define SVM_SEV_FEAT_ALLOWED_SEV_FEATURES		BIT_ULL(63)
> 
> Hmmm... I believe it is safe to define this bit value, as the Allowed
> SEV features VMCB field shows bits 61:0 being used for the allowed
> features mask and we know that the SEV_FEATURES field is used in the SEV
> Features MSR left-shifted 2 bits, so we only expect bits 61:0 to be used
> and bits 62 and 63 will always be reserved. But, given that I think we
> need two functions:
> 
> - get_allowed_sev_features()
>   keeping it as you have it below, where it returns the
>   sev->vmsa_features bitmap if SVM_SEV_FEAT_ALLOWED_SEV_FEATURES is set
>   or 0 if SVM_SEV_FEAT_ALLOWED_SEV_FEATURES is not set.
> 
> - get_vmsa_sev_features()
>   which removes the SVM_SEV_FEAT_ALLOWED_SEV_FEATURES bit, since it is
>   not defined in the VMSA SEV_FEATURES definition.

Or just don't add wrappers that do more harm than good?

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a9e16792cac0..4d0b5a020b65 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -894,15 +894,6 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
        return 0;
 }
 
-static u64 allowed_sev_features(struct kvm_sev_info *sev)
-{
-       if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES) &&
-           (sev->vmsa_features & SVM_SEV_FEAT_ALLOWED_SEV_FEATURES))
-               return sev->vmsa_features;
-
-       return 0;
-}
-
 static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
                                    int *error)
 {
@@ -916,7 +907,8 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
                return -EINVAL;
        }
 
-       svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
+       if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
+               svm->vmcb->control.allowed_sev_features = sev->vmsa_features;
 
        /* Perform some pre-encryption checks against the VMSA */
        ret = sev_es_sync_vmsa(svm);
@@ -2459,7 +2451,8 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
                struct vcpu_svm *svm = to_svm(vcpu);
                u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
 
-               svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
+               if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
+                       svm->vmcb->control.allowed_sev_features = sev->vmsa_features;
 
                ret = sev_es_sync_vmsa(svm);
                if (ret)

> >  #define SVM_SEV_FEAT_INT_INJ_MODES		\
> >  	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index a2a794c32050..a9e16792cac0 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -894,9 +894,19 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
> >  	return 0;
> >  }
> >  
> > +static u64 allowed_sev_features(struct kvm_sev_info *sev)
> > +{
> > +	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES) &&
> 
> Not sure if the cpu_feature_enabled() check is necessary, as init should
> have failed if SVM_SEV_FEAT_ALLOWED_SEV_FEATURES wasn't set in
> sev_supported_vmsa_features.

Two things missing from this series:

 1: KVM enforcement.  No way is KVM going to rely on userspace to opt-in to
    preventing the guest from enabling features.

 2: Backwards compatilibity if KVM unconditionally enforces ALLOWED_SEV_FEATURES.
    Although maybe there's nothing to do here?  I vaguely recall all of the gated
    features being unsupported, or something...

