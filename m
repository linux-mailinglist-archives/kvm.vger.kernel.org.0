Return-Path: <kvm+bounces-68832-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cIN1KJd9cWk1IAAAu9opvQ
	(envelope-from <kvm+bounces-68832-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:29:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FABA60549
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 57BB2700BBE
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 01:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FC034FF41;
	Thu, 22 Jan 2026 01:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cq00LJrY"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373E72D0C63
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 01:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045302; cv=none; b=gxWzNu+2wc8TX3R6lgD6nlCA1LMBILCIK1nsjayW/9XjQXsdLOUn0uj+mE2hchQPreHUYIIrdxWlG3E9P2UVebHG5+GtqSyN4mrvIZSymZUg5IZit1qrKN6XoBpLHk18+8xhbSpnyu4LRp2LFy7RXr7i3UuyoL4U0ZO8C1IG20k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045302; c=relaxed/simple;
	bh=bS3uJGcSc8XzWKau3wF/igzdk6MwAfqPuCz3Fm6ZEdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSYiH7CnQHOBdbxGYLY4deHupj1r4gbpWfftU5JsdoQuW9uQ3ld4rR8nZ80l5owYm6Hkr1nonRRE3bPvcxwk+akVbnjs5/dJcRsCXaGNYLddrFTFp16AZatjb9zSDm4plEdOwO8X0V7HRSv3PoApFD8zaWkD5Z1fYueJ2cz3W50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cq00LJrY; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 22 Jan 2026 01:28:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769045287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F2ablW7VskYcPWkbB6tN0UjDv6XdHdkGDUS5v3E2wMM=;
	b=cq00LJrYkg7S808DLke5tkuUy+pERkK/OFMo68an51rUDlOY7Rfw8eKVQCyIW1ovfvoMWr
	OH9D7FhIa2W+72Iz5CEJ502gT1Mc2c9m1TzEuDO4IHnYrRAl5MYMkzr0ugyk06gMCLUGf3
	gvvoVsMM1lO0dM0/AocOlAndPoZIrQc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/8] KVM: x86: nSVM: Cache g_pat in
 vmcb_save_area_cached
Message-ID: <e3j5qgrdjad7ura7kodfzcagynvrkxv227ddg3jfjknzewvyay@h5pb67muiycd>
References: <20260115232154.3021475-1-jmattson@google.com>
 <20260115232154.3021475-3-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115232154.3021475-3-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68832-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[linux.dev,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,linux.dev:dkim,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 0FABA60549
X-Rspamd-Action: no action

On Thu, Jan 15, 2026 at 03:21:41PM -0800, Jim Mattson wrote:
> To avoid TOCTTOU issues, all fields in the vmcb12 save area that are
> subject to validation must be copied to svm->nested.save prior to
> validation, since vmcb12 is writable by the guest. Add g_pat to this set in
> preparation for validting it.
> 
> Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")

g_pat is not currently used from VMCB12, so this patch isn't technically
fixing an issue, right? I suspect this only applies to patch 3.

Anyway, I think it's probably best to squash this into patch 3. Also
maybe CC stable?

> Signed-off-by: Jim Mattson <jmattson@google.com>

If you decide to keep this as an individual patch, feel free to add:

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/nested.c | 2 ++
>  arch/x86/kvm/svm/svm.h    | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f295a41ec659..07a57a43fc3b 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -506,6 +506,8 @@ static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
>  
>  	to->dr6 = from->dr6;
>  	to->dr7 = from->dr7;
> +
> +	to->g_pat = from->g_pat;
>  }
>  
>  void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 7d28a739865f..39138378531e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -145,6 +145,7 @@ struct vmcb_save_area_cached {
>  	u64 cr0;
>  	u64 dr7;
>  	u64 dr6;
> +	u64 g_pat;
>  };
>  
>  struct vmcb_ctrl_area_cached {
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

