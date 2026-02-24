Return-Path: <kvm+bounces-71671-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIEfFH4YnmmcTQQAu9opvQ
	(envelope-from <kvm+bounces-71671-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:30:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3E618CC7D
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:30:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A31BB30636A2
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 21:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3DD33F37E;
	Tue, 24 Feb 2026 21:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BKcFN1Qn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8A8226D00
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771968629; cv=none; b=qe8RBc0Vz2dK40ji0Qxp7YF/h50YrpwvSUHGOt46okur7JTcCmJ3MTJyLi4lYMH/oH5jR8HeWOR+VnTIVLE0Pdyo1TSyYMMqRubYVP1trr8U40OzEhNd5pAXS9lrTjRinVK1kXuCcJpFg7/CzXkQuhTmXHw6ZZe3RHdzUPausfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771968629; c=relaxed/simple;
	bh=FXKeSoSMfzizdfAiGbgrzg+JYZn/1M0RS192UpKNA8o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQ+HvfJdg2Yg6dy3M4U5O3+Fadj2WbFcBlt4IEy2/ZaZWHE2cYa1bPHEVaxqBlSPTk0ttSr289EAjbLdcdog7RSg4h7ujlAt4ixAYs+3R8m3zTb2CmC/AezbLpPk8Q0d0G7VO5fA21kWlB3Ya9CrZDlnKQ2rKmk2zhDoWe/OTsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BKcFN1Qn; arc=none smtp.client-ip=74.125.82.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2b81ff82e3cso134641eec.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 13:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771968626; x=1772573426; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fp3gQv/wLfwDQnfgoRQPjUqkZeQgl8EZgadP4mI+PPw=;
        b=BKcFN1QnTJBkevYWv29g4n5UA3W6IMKFkH4PYtx2HkE1QKQpzQuPmbEt1JvwrPfj8T
         YlOpZtM6adgpEdPWpcxxYSi0PWHDuJ9iLaHLJIDZgMTCdhDokrKAl8hwLOgNHK+7PbZk
         bet3KVdBXz+Rvn+/wpZ6TNYrhLut0oRJf9UHmp+s1DX/JrwSi/UsizKLFqE9Cplx2AEX
         osEyX9SdpxTMpMIus4OsIA/U6Yo2GNOHSsIjOeb35tPyCGxqa+mCAf6d/bZxr0p5J487
         rynvCrtYhyEAXOTbVVwJMVVwaHTcZ7+88+GNL9an7SOGAVBOSLFQXcPx0UXZCwGotOH8
         XfOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771968626; x=1772573426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fp3gQv/wLfwDQnfgoRQPjUqkZeQgl8EZgadP4mI+PPw=;
        b=BV2uwJ1cZUNLEfQO6XFXHq+pXLdz80QpcVuewnnoN4F5y8Y2ZHYzeyQpzaslWt5dv3
         WfCIgDG0DzMdLgpv/5fBouqsJ5SfHq0xQYZBCAD5S1F/J7lBiVgfiIj7K021SMIysUgA
         +kmwR6W+ufATes/t3FP8CsEwvSUQS/tytxKQiYK3dV5oVZEtdxAAmjmJELbanIYOWcqY
         M/2ULfVDsQxdlFRK33LZtEY+ziNeITgdebyw95iAIc/TIcj+Sl59YkHSHwOQCsypUNjD
         u1c5+zYmh9t8CdaV/muSguItl5Xm9Zh9scZQMGUfin+a6+B0cXdAcW9Ze0kZtjA0j5jc
         y4vw==
X-Forwarded-Encrypted: i=1; AJvYcCXsPPSJf/QVzdGwTMThWVZcK4rlRf+/UZSE6YrQu23Lrj/kgh72QSR8zCHpyAZlPXggBzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YydkXfL7tUJjwJrJKJP8TruRoXoyE7Z9PxiyKM5Xj2LJQhtObon
	M6PxQTpAnTgIdeSbgpljY0+rv3uZj06uNhIru14xiARV6wjbca/trryRqmoOQKgoVO7YzQrxslS
	seZp6llik2r4vR3TKDpA9Jw==
X-Received: from dlnn36.prod.google.com ([2002:a05:7022:61a4:b0:127:16bc:8eaa])
 (user=changyuanl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:209:b0:119:e569:f874 with SMTP id a92af1059eb24-1277f547694mr557374c88.17.1771968625917;
 Tue, 24 Feb 2026 13:30:25 -0800 (PST)
Date: Tue, 24 Feb 2026 13:29:39 -0800
In-Reply-To: <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224212939.2081828-1-changyuanl@google.com>
Subject: Re: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
From: Changyuan Lyu <changyuanl@google.com>
To: rick.p.edgecombe@intel.com
Cc: binbin.wu@intel.com, bp@alien8.de, changyuanl@google.com, 
	dave.hansen@linux.intel.com, hpa@zytor.com, isaku.yamahata@intel.com, 
	kas@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	seanjc@google.com, tglx@kernel.org, x86@kernel.org, xiaoyao.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71671-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[changyuanl@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_TWELVE(0.00)[17];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2E3E618CC7D
X-Rspamd-Action: no action

Hi Rick!

On Tue, 24 Feb 2026 01:57:46 +0000, Edgecombe, Rick P wrote:
> On Mon, 2026-02-23 at 13:43 -0800, Changyuan Lyu wrote:
> > [...]
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 2d7a4d52ccfb4..0c524f9a94a6c 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -172,9 +172,15 @@ static void td_init_cpuid_entry2(struct
> > kvm_cpuid_entry2 *entry, unsigned char i
> >  	entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
> >  	entry->edx = td_conf->cpuid_config_values[idx][1] >> 32;
> >
> > -	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
> > +	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF) {
> >  		entry->index = 0;
> > +		entry->flags &= ~KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>
> There are two callers of this. One is already zeroed, and the other has
> stack garbage in flags. But that second caller doesn't look at the
> flags so it is harmless. Maybe it would be simpler and clearer to just
> zero init the entry struct in that caller. Then you don't need to clear
> it here. Or alternatively set flags to zero above, and then add
> KVM_CPUID_FLAG_SIGNIFCANT_INDEX if needed. Rather than manipulating a
> single bit in a field of garbage, which seems weird.

Thanks for the suggestion. I agree that initializing entry->flags to 0 at
the start of td_init_cpuid_entry2() is much cleaner.

> > +	} else {
> > +		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> > +	}
> >
> > +	WARN_ON_ONCE(cpuid_function_is_indexed(entry->function) !=
> > +		     !!(entry->flags &
> > KVM_CPUID_FLAG_SIGNIFCANT_INDEX));
>
> It warns on leaf 0x23 for me. Is it intentional?

Leaf 0x23 is not in the list of cpuid_function_is_indexed.
Thanks Binbin for the explanation!

> This warning kind of begs the question of how how much consistency
> there should be between KVM_TDX_CAPABILITIES and
> KVM_GET_SUPPORTED_CPUID. There was quite a bit of debate on this and in
> the end we moved forward with a solution that did the bare minimum
> consistency checking.
>
> We actually have been looking at some potential TDX module changes to
> fix the deficiencies from not enforcing the consistency. But didn't
> consider this pattern. Can you explain more about the failure mode?

The main purpose of this patch was to make the KVM_TDX_GET_CPUID API
more intuitive from userspace VMM's perspective.
Since both KVM_TDX_CAPABILITIES and KVM_GET_SUPPORTED_CPUID return
struct kvm_cpuid_entry2, I expected the semantic of the flag in both APIs
to be the same, as I didn't find any special notes to the contrary in the
TDX documentation Documentation/virt/kvm/x86/intel-tdx.rst .

> >  	/*
> >  	 * The TDX module doesn't allow configuring the guest phys
> > addr bits
> >  	 * (EAX[23:16]).  However, KVM uses it as an interface to
> > the userspace
> > --

Regarding the WARN_ON_ONCE, I understand it touches on the larger
consistency and compatibility questions that require more discussion
as you and Sean mentioned. Since I am new to TDX and lack the full context
on those prior debates, I removed the WARN_ON_ONCE check and focus only on
the KVM_CPUID_FLAG_SIGNIFCANT_INDEX consistency fix, which was the core of
this patch.

Best,
Changyuan

-----------------------

From 18b967b718911c09872c3717d8ab083fa59c4a70 Mon Sep 17 00:00:00 2001
From: Changyuan Lyu <changyuanl@google.com>
Date: Fri, 20 Feb 2026 09:55:28 -0800
Subject: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs

Set the KVM_CPUID_FLAG_SIGNIFCANT_INDEX flag in the kvm_cpuid_entry2
structures returned by KVM_TDX_CAPABILITIES if the CPUID is indexed.
This ensures consistency with the CPUID entries returned by
KVM_GET_SUPPORTED_CPUID.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb4..1c039eab2f3d8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -167,6 +167,7 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i

 	entry->function = (u32)td_conf->cpuid_config_leaves[idx];
 	entry->index = td_conf->cpuid_config_leaves[idx] >> 32;
+	entry->flags = 0;
 	entry->eax = (u32)td_conf->cpuid_config_values[idx][0];
 	entry->ebx = td_conf->cpuid_config_values[idx][0] >> 32;
 	entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
@@ -174,6 +175,9 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i

 	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
 		entry->index = 0;
+	else
+		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+

 	/*
 	 * The TDX module doesn't allow configuring the guest phys addr bits
--
2.53.0.414.gf7e9f6c205-goog

