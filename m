Return-Path: <kvm+bounces-60528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA09BF1AEA
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 15:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8543442482D
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C9D320CC9;
	Mon, 20 Oct 2025 13:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M6R41M+U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99ED320A1D
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 13:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760968653; cv=none; b=mkK/Zxzgw8Ccvs/+qsZGuj7zggourjB6JgULL4Z32tzNfQa8jIzigevqffSXThjr7dUblf9kkp0d07+N7Q0z3DeSzw3BnRSf3z9foP7a5CpeUoxwFnIm8kLPykBayE1bYid3p964Z9FCj1Wz+seRI+OLcIgJK3TkD+QFkKwkI/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760968653; c=relaxed/simple;
	bh=by/B3ZF4ltTXKR7zti0GcW7Yp/JTFBt6fuWW4uMr8pU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q9lgQcten7iiHR/KEIjDlFwuqBTcdUmnV3PtY97HVlI6bZDg4usSmZ3hUfw/mgTt5BzlZsoABGbcPdS6URhs8hWy155bm3wXCCd+tBXiDkZGO3PtNFzvlayd4ldo1f9CtiGsjFcgvnhsnrRNYAGtK0oP63jdtgtcKoRuauLSg7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M6R41M+U; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-290ab8f5af6so34694915ad.3
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 06:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760968650; x=1761573450; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M0+EDFFrKoSwKYvzTgc8liBMbmZOSvdeEq8OSVJkaRM=;
        b=M6R41M+UYbCNauRWmOcJMSynaFyor9XVvM/+Rby8nP+YWFQMUsoiT0xRb/pFqTjxgI
         m6sDWUQ4FQBwZ60ZGBMNcO5pK0iWsgD6sczOpPfbdFcFoYYPDcv8rqAxnlXADhzY8MkQ
         aZubZQFkEX5GXuh/6x252TB1KTI3fQ2sozsFsWxi4lJtfMkvl3SvkyB/gV91513/LBZE
         EzF6+KWjXcZdYY9y7Wrzv/dgJIKMHbwPvyyvq+/UjodkUvrJ6kTNC5iOPpn8CYoFn6OR
         qS6L6MpvMpkF65tjBK4KTRtBTeeuVuj6U5KjQfikHHiMtak5WA8MWv6phPLy2ERN8fl8
         vD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760968650; x=1761573450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M0+EDFFrKoSwKYvzTgc8liBMbmZOSvdeEq8OSVJkaRM=;
        b=v6dPk+SRdpSELQoLjChMQSVey5++Q9NJCxWRlYBRjTlkC4axgsSl5HgQVQsSUsDyTK
         FUyD7tPmoDX4nWHJHEdX7FEqjxyCLkC02NtjxqFXrKhv5U3MtPYOZUJ0ndbdkUn8xIXP
         4xPqMvFB5y4eAvQCMcx3Hx8c8OKhSio9wbuhwtlMTjzOIaQiwfgW/76I0hT2pmpNWQze
         3in2vwURS9ODeJUXAaWOpLBX0TwzwLLX81WnqfLetr9lTcNB/+qd62liMqrpeGwvG2xn
         JsarNpqY4QtDRnXnyiMW83Ri5Fpo6bR86BDV8optW+OFYV5P0NennOvbGM5GgTolLnrz
         xGxg==
X-Forwarded-Encrypted: i=1; AJvYcCU9T/5re3GgvuJ3nFjra9KME6atOC59MFf24Z4eNlff0TNzAJGRvSoSyHrJjz5rKPjv0RQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiubhzKGwPoCNy5RzL3Z9ALac4cB2jV6vYueFdr1uuqOp3ZXB4
	gZZENLQTkbWBFUatYUFwmkW2AbPgoxb8qcw9n5FyyYGLpubq0JvJImlXblijtR5zTr7HJqSIPU/
	7fPsZrA==
X-Google-Smtp-Source: AGHT+IGwXt5nNKVJSLvunD70jP+TkqfMmkfhrgwNxrmYjfs0sanoJMdXrBHWe3iLon8zoT/KxTnC2xnbn/U=
X-Received: from plbll15.prod.google.com ([2002:a17:903:90f:b0:290:af0d:9383])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a0e:b0:28d:c790:43d0
 with SMTP id d9443c01a7336-290ca30e417mr163929165ad.29.1760968650214; Mon, 20
 Oct 2025 06:57:30 -0700 (PDT)
Date: Mon, 20 Oct 2025 06:57:28 -0700
In-Reply-To: <20250910144453.1389652-1-dave.hansen@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250910144453.1389652-1-dave.hansen@linux.intel.com>
Message-ID: <aPY_yC45suT8sn8F@google.com>
Subject: Re: [PATCH] x86/virt/tdx: Use precalculated TDVPR page physical address
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Thomas Huth <thuth@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 10, 2025, Dave Hansen wrote:
> From: Kai Huang <kai.huang@intel.com>
> 
> All of the x86 KVM guest types (VMX, SEV and TDX) do some special context
> tracking when entering guests. This means that the actual guest entry
> sequence must be noinstr.
> 
> Part of entering a TDX guest is passing a physical address to the TDX
> module. Right now, that physical address is stored as a 'struct page'
> and converted to a physical address at guest entry. That page=>phys
> conversion can be complicated, can vary greatly based on kernel
> config, and it is definitely _not_ a noinstr path today.
> 
> There have been a number of tinkering approaches to try and fix this
> up, but they all fall down due to some part of the page=>phys
> conversion infrastructure not being noinstr friendly.
> 
> Precalculate the page=>phys conversion and store it in the existing
> 'tdx_vp' structure.  Use the new field at every site that needs a
> tdvpr physical address. Remove the now redundant tdx_tdvpr_pa().
> Remove the __flatten remnant from the tinkering.
> 
> Note that only one user of the new field is actually noinstr. All
> others can use page_to_phys(). But, they might as well save the effort
> since there is a pre-calculated value sitting there for them.
> 
> [ dhansen: rewrite all the text ]
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> ---
>  arch/x86/include/asm/tdx.h  |  2 ++
>  arch/x86/kvm/vmx/tdx.c      |  9 +++++++++
>  arch/x86/virt/vmx/tdx/tdx.c | 21 ++++++++-------------
>  3 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 6120461bd5ff3..6b338d7f01b7d 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -171,6 +171,8 @@ struct tdx_td {
>  struct tdx_vp {
>  	/* TDVP root page */
>  	struct page *tdvpr_page;
> +	/* precalculated page_to_phys(tdvpr_page) for use in noinstr code */
> +	phys_addr_t tdvpr_pa;
>  
>  	/* TD vCPU control structure: */
>  	struct page **tdcx_pages;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 04b6d332c1afa..75326a7449cc3 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -852,6 +852,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>  	if (tdx->vp.tdvpr_page) {
>  		tdx_reclaim_control_page(tdx->vp.tdvpr_page);
>  		tdx->vp.tdvpr_page = 0;
> +		tdx->vp.tdvpr_pa = 0;

'0' is a perfectly legal physical address.  And using '0' in the existing code to
nullify a pointer is gross.

Why do these structures track struct page everywhere?  Nothing actually uses the
struct page object (except calls to __free_page().  The leaf functions all take
a physical address or a virtual address.  Track one of those and then use __pa()
or __va() to get at the other.

Side topic, if you're going to bother tracking the number of pages in each struct
despite them being global values, at least reap the benefits of __counted_by().

struct tdx_td {
	/* TD root structure: */
	void *tdr_page;

	int tdcs_nr_pages;
	/* TD control structure: */
	void *tdcs_pages[] __counted_by(tdcs_nr_pages);
};

struct tdx_vp {
	/* TDVP root page */
	void *tdvpr_page;

	int tdcx_nr_pages;
	/* TD vCPU control structure: */
	void *tdcx_pages[] __counted_by(tdcx_nr_pages);
};

