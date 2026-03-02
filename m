Return-Path: <kvm+bounces-72387-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IrXGOyqpWmpDgAAu9opvQ
	(envelope-from <kvm+bounces-72387-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:21:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60AF31DBB55
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F2E75304E762
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 15:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D193407598;
	Mon,  2 Mar 2026 15:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cvg0kMbi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739EB401494
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 15:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464263; cv=none; b=sfip4GF3ZTa6xjbeFYuFxLz0E75lv64YeGqUJDssHnJ4wGKSuTUu6jIHpruYFceUG4WylCs9C35v9pStVTPgXtBrZtjdp6dSreRlLFrrEIJdIT2J3O99UH6R2oqh/BY+ivu6gFDCRZ80LYECe8SZ16LhUvd7+ThmFoBKS7HXUUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464263; c=relaxed/simple;
	bh=Yve/BpFkzyt3lOXcoTJY/52szTrD/U3uOL7+WrHNHHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ql3aGnR3sp32ZnNjdZXRarFH9ErNvemULGks6jLgwAKkmaqxpH8b+8nqNfZNSm2236LljqtOZlFgyuGNk/m/YKuDSCCQrCScSRMRTMlUkN+0+jXDWTDnFKL4Z0J2XUzQepablHVRds6nUgvCp9TjxVYQjM29BVSt9FAZrUcU04U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cvg0kMbi; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4e20a414so51310255ad.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 07:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772464261; x=1773069061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fAXHam1k+WHPTbPZyih3X1AbQHxa90npC7npw0uHXbc=;
        b=Cvg0kMbixP4vXCdB8QdyGYVDYjAg13wgraYN/svoItxyXQQyqPa+qtVKBLtc1nRxHr
         T94L/NwNsY78M2PkOE1I6adxVUfGA3LIkmwilfJ6l+wt8HQFwXipAOE81zjSwEADVaCo
         BEYLhDIMVYAV6l65Td//erSByzHOMpDUDpvvdDenNZCfRALfw4zcazC3bBbMOBO44FcA
         eW8CKYWklAOwPzRz0q52hqXdvR5JCwhSDTdkPBEFXgbe0M5EmqgLx808a6iivH3/YU5z
         2fGfW/9flrVlYTLwQrUqFRf8WQHM/RdGiJreWBhKNBr2vZhOyKo/uvq60+Mz2WwQTacC
         wLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772464261; x=1773069061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fAXHam1k+WHPTbPZyih3X1AbQHxa90npC7npw0uHXbc=;
        b=OXAp7WTo4kTgSMKuX5xElMTMv2N50zgWG+n66Oe8akt+y0PYxtZ8caDXExZjfkH/Fr
         3jVCZRaKdpu09Euy6VogSb7E0fDcy8xC9XfkDFU00Z7jUpEXg/6sTrHnxUhx9+nm3UAR
         uoc1kd0tAtR2gpzg5sj+fe0pSWHRYsAnBPBMCx9FZZWsSB88m5zy/2/2TshiPfB4ijo1
         c8qhg3hCSsFNabHg3bSZi+fXaBE3qsOXt5uN2V3RxN1QBRrownnFYUyJhkTmn3g/WEUD
         GDshdraS9T1VFDdW+4laZ/vura9NYg2oGT0LB+5vnRaIwmNeNLNuHNe/DxsSVIjkPe6f
         symw==
X-Forwarded-Encrypted: i=1; AJvYcCUP+ScSmhcA5suEszXwm8oA9sV6V2MfPH5HM+M+AMdmXLs/bmajpgr9Meo+lkCodEAZ0gM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXcM3VNGbtiSClELG4Jtbi+c+y+FSY/kNmJ3IsA0wKNITzesPS
	uF9U7ZpSzxVRfuON9in67+R1Tgy72buXsItKzwGoMrJ3IfDRlNC9z/Wj+nIbA+Fr7cTc6/C4Xqm
	330ehQQ==
X-Received: from plan2.prod.google.com ([2002:a17:903:4042:b0:2ae:499b:f9c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:228b:b0:2aa:fad8:7474
 with SMTP id d9443c01a7336-2ae2e4a6621mr147425615ad.33.1772464260610; Mon, 02
 Mar 2026 07:11:00 -0800 (PST)
Date: Mon, 2 Mar 2026 07:10:59 -0800
In-Reply-To: <20260228165506.GAaaMd6nQ56E7i5Cqg@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203222405.4065706-1-kim.phillips@amd.com>
 <20260203222405.4065706-3-kim.phillips@amd.com> <20260228165506.GAaaMd6nQ56E7i5Cqg@fat_crate.local>
Message-ID: <aaWog_UjW-M3412C@google.com>
Subject: Re: [PATCH v2 2/3] KVM: SEV: Add support for IBPB-on-Entry
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Naveen Rao <naveen.rao@amd.com>, 
	David Kaplan <david.kaplan@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 60AF31DBB55
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72387-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Sat, Feb 28, 2026, Borislav Petkov wrote:
> Sean, ack for the KVM bits and me taking them thru tip?

Ya, should be fine for this to go through tip.

> On Tue, Feb 03, 2026 at 04:24:04PM -0600, Kim Phillips wrote:
> > AMD EPYC 5th generation and above processors support IBPB-on-Entry
> > for SNP guests.  By invoking an Indirect Branch Prediction Barrier
> > (IBPB) on VMRUN, old indirect branch predictions are prevented
> > from influencing indirect branches within the guest.
> > 
> > SNP guests may choose to enable IBPB-on-Entry by setting
> > SEV_FEATURES bit 21 (IbpbOnEntry).
> > 
> > Host support for IBPB on Entry is indicated by CPUID
> > Fn8000_001F[IbpbOnEntry], bit 31.
> > 
> > If supported, indicate support for IBPB on Entry in
> > sev_supported_vmsa_features bit 23 (IbpbOnEntry).
> > 
> > For more info, refer to page 615, Section 15.36.17 "Side-Channel
> > Protection", AMD64 Architecture Programmer's Manual Volume 2: System
> > Programming Part 2, Pub. 24593 Rev. 3.42 - March 2024 (see Link).
> > 
> > Link: https://bugzilla.kernel.org/attachment.cgi?id=306250
> > Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > ---

...

> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index ea515cf41168..8a6d25db0c00 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3165,8 +3165,15 @@ void __init sev_hardware_setup(void)
> >  	    cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
> >  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> >  
> > -	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> > +	if (!sev_snp_enabled)
> > +		return;
> > +	/* the following feature bit checks are SNP specific */
> > +
> > +	if (tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> >  		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
> > +
> > +	if (cpu_feature_enabled(X86_FEATURE_IBPB_ON_ENTRY))
> > +		sev_supported_vmsa_features |= SVM_SEV_FEAT_IBPB_ON_ENTRY;
> >  }

I think I'd prefer to nest the if-statement, e.g.

	if (sev_snp_enabled) {
		if (tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
			sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;

		if (cpu_feature_enabled(X86_FEATURE_IBPB_ON_ENTRY))
			sev_supported_vmsa_features |= SVM_SEV_FEAT_IBPB_ON_ENTRY;
	}

I'm mildly concerned that'll we'll overlook the early return and unintentionally
bury common code in the SNP-section tail.

More importantly, this patch is buggy.  __sev_guest_init() needs to disallow
setting SVM_SEV_FEAT_IBPB_ON_ENTRY for non-SNP guests.

As a follow-up, I also think we should advertise SVM_SEV_FEAT_SNP_ACTIVE and
allow userspace to set the flag in kvm_sev_init.flags.  KVM still needs to set
the flag for backwards compatibility, but disallowing SVM_SEV_FEAT_SNP_ACTIVE
for an SNP guest is bizarre.

E.g. across 2 or 3 patches:

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index edde36097ddc..7db1bfce4cca 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -307,6 +307,10 @@ static_assert((X2AVIC_4K_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AV
 #define SVM_SEV_FEAT_DEBUG_SWAP                                BIT(5)
 #define SVM_SEV_FEAT_SECURE_TSC                                BIT(9)
 
+#define SVM_SEV_FEAT_SNP_ONLY_MASK     (SVM_SEV_FEAT_SNP_ACTIVE | \
+                                        SVM_SEV_FEAT_SECURE_TSC | \
+                                        SVM_SEV_FEAT_IBPB_ON_ENTRY)
+
 #define VMCB_ALLOWED_SEV_FEATURES_VALID                        BIT_ULL(63)
 
 struct vmcb_seg {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 41385573629e..b2fe0fa11f90 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -500,7 +500,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
                return -EINVAL;
 
        if (!snp_active)
-               valid_vmsa_features &= ~SVM_SEV_FEAT_SECURE_TSC;
+               valid_vmsa_features &= ~SVM_SEV_FEAT_SNP_ONLY_MASK;
 
        if (data->vmsa_features & ~valid_vmsa_features)
                return -EINVAL;
@@ -3218,8 +3218,15 @@ void __init sev_hardware_setup(void)
            cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
                sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 
-       if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
-               sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
+       if (sev_snp_enabled) {
+               sev_supported_vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
+               if (tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+                       sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
+
+               if (cpu_feature_enabled(X86_FEATURE_IBPB_ON_ENTRY))
+                       sev_supported_vmsa_features |= SVM_SEV_FEAT_IBPB_ON_ENTRY;
+       }
 }
 
 void sev_hardware_unsetup(void)

