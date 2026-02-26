Return-Path: <kvm+bounces-72111-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CD3EFJvaoGk+ngQAu9opvQ
	(envelope-from <kvm+bounces-72111-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:43:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C4FB71B0FD3
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:43:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 84F09304E7C4
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B603346AB;
	Thu, 26 Feb 2026 23:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qCYTTfVl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96521E5B63
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 23:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772149389; cv=none; b=HkX0JdJxvs1EHJKvIJWhtSQtrrlklAMAdNrTxdkNIPDig7LkAh2J3CHgciHNew9X+VVjx+L7GNzf8ac5Qurg1ruPeya2PddqPzhIqOG2kjHAPZo8iiZ8yxsRTFNOKapsJcHsNR0Eszl93TqL9Uy6+ncP9uMRKG60zn13dIV8vug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772149389; c=relaxed/simple;
	bh=nYT1y/hhQW/86aS4ZN4OJ957tRCJesbnqHhi2ZZK9B8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pPXqMd7i7bnVn4hfFx+aiDw+qYB9gExXP/BvDaoujqe8QbSoj5Z+jjggMQTfuIGlLUS31lEASeWUKt24Qluo40tRCPcnucRSOrhi1Re696cOhGDeeKBWM8jeoRamWgN81XUXAb7f3MJpx9ASZpw3TH42b/Av8/lqgznQ9+oqQ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qCYTTfVl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35449510446so1196913a91.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772149385; x=1772754185; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5xV9Fp9Mp3wKt/HL2xKn2gAO+TqSS/NXayrdSUMZqB8=;
        b=qCYTTfVlC5qn1oHz+Yt5dDM0Wbprkq41lljrj9akTAHgLb6cwitfub0zVDC9L3kQzd
         j9cOt6j5Pcei1A3/pxH+yCYN1BUJSPH5/dradmt+e4N/exOmCCftjKWWzCE7S7s8ZlmC
         ZS7hGiFTDwARJeczyDmkq58s/+FetZDp8wQQtYQbClPrtyHJjmZaXJl96OOnTh4GDH2H
         X7daTeVOqlUpdv8wPsAg/NFhq3ocM46yHsRuUJGjmE6ziIGZTfBEZw9ZMj77TaDZ2td1
         oOW8GGpbOdc+F2tA3lvrb2YjybB5aVCYfS4ok8pBvF14W1rpsXpUQ908VyAQ2VTea7QG
         7X5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772149385; x=1772754185;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5xV9Fp9Mp3wKt/HL2xKn2gAO+TqSS/NXayrdSUMZqB8=;
        b=dvV66HVotv81W4eV4RbD+WC9sEYROym2KYES08oZnkSJDH7dVAZRAN8A9qBcAIR+JC
         5Kt1ykT4d36bD0co5ii5EycNMAicb9OI6H8cmHCkK3c4Cv897oWxqYTzBaCBev/WY9RZ
         WsspYQ2T86AINGqp715lWJGMfU1MhCoKQtUWQIk37ROJdnRzipN0JloytDMK9R3rkzXw
         vNaz/sbEbnZBFkJemUJiuCaheIPp5ggIbEzNW8NJh7+WL+6AR4dRJPyNJvKS0wlzZKSa
         0oxXbsdZAo8vBHyOi+ScA6rDSW78a1ahrHWjk8GNpIvyeGqZoKKhBwkahRbuOXzuYOvD
         aGQA==
X-Forwarded-Encrypted: i=1; AJvYcCXUEQ4OOai4oVnijUfrHkEqzPDgLi57ZEbgUsEZ+Zy6xfW2O3XQ3bCe3vfgK9IzHQR67oU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRdjwFREOgGS+jTszhsduMTXRwFKFbDisoqpJcvJpuu6IOOsi8
	PacjM1fqWFW/WBLAEU/TxtNKaKohrutiQXmlV37PCO7j+3F+toXXxCgMJ8XosejtHwgdftPZPRC
	gvXaxjw==
X-Received: from pjwo21.prod.google.com ([2002:a17:90a:d255:b0:356:213e:d56e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5710:b0:356:23be:7ecb
 with SMTP id 98e67ed59e1d1-35965c34bc7mr627146a91.12.1772149384979; Thu, 26
 Feb 2026 15:43:04 -0800 (PST)
Date: Thu, 26 Feb 2026 15:43:03 -0800
In-Reply-To: <aZ/5CDmCa8O5vrFZ@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com> <20260214012702.2368778-8-seanjc@google.com>
 <aZ/5CDmCa8O5vrFZ@intel.com>
Message-ID: <aaDah8QSFqWpNvqY@google.com>
Subject: Re: [PATCH v3 07/16] KVM: SVM: Move core EFER.SVME enablement to kernel
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72111-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C4FB71B0FD3
X-Rspamd-Action: no action

On Thu, Feb 26, 2026, Chao Gao wrote:
> >-static inline void kvm_cpu_svm_disable(void)
> >-{
> >-	uint64_t efer;
> >-
> >-	wrmsrq(MSR_VM_HSAVE_PA, 0);
> >-	rdmsrq(MSR_EFER, efer);
> >-	if (efer & EFER_SVME) {
> >-		/*
> >-		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
> >-		 * NMI aren't blocked.
> >-		 */
> >-		stgi();
> >-		wrmsrq(MSR_EFER, efer & ~EFER_SVME);
> >-	}
> >-}
> >-
> > static void svm_emergency_disable_virtualization_cpu(void)
> > {
> >-	virt_rebooting = true;
> >-
> >-	kvm_cpu_svm_disable();
> >+	wrmsrq(MSR_VM_HSAVE_PA, 0);
> > }
> > 
> > static void svm_disable_virtualization_cpu(void)
> >@@ -507,7 +489,7 @@ static void svm_disable_virtualization_cpu(void)
> > 	if (tsc_scaling)
> > 		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
> > 
> >-	kvm_cpu_svm_disable();
> >+	x86_svm_disable_virtualization_cpu();
> 
> There's a functional change here. The new x86_svm_disable_virtualization_cpu()
> doesn't reset MSR_VM_HSAVE_PA, but the old kvm_cpu_svm_disable() does.

Doh.  I'll squash this as fixup, assuming there are no other goofs:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f033bf3ba83..fc08450cb4b7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -490,6 +490,7 @@ static void svm_disable_virtualization_cpu(void)
                __svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 
        x86_svm_disable_virtualization_cpu();
+       wrmsrq(MSR_VM_HSAVE_PA, 0);
 
        amd_pmu_disable_virt();
 }

Very nice catch!

P.S. This reminded me that there's a lurking wart with __sev_snp_init_locked()
where it forces MSR_VM_HSAVE_PA to '0' on all CPUs.  That's firmly a "hypervisor"
thing so it doesn't really fit here (and code wise it's also kludgy), just thought
I'd mention it in case someone has a brilliant idea and/or runs into problems with
it.  IIRC, we ran into a problem where __sev_snp_init_locked() clobbered KVM's
value, but I think the underlying problem was effectively fixed by commit
6f1d5a3513c2 ("KVM: SVM: Add support to initialize SEV/SNP functionality in KVM").


