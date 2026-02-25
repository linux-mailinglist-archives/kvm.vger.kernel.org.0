Return-Path: <kvm+bounces-71874-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOCuK0hHn2nvZgQAu9opvQ
	(envelope-from <kvm+bounces-71874-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:02:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2977719C85D
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8B0603019125
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB733D348E;
	Wed, 25 Feb 2026 19:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+50fg56"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C82379CD;
	Wed, 25 Feb 2026 19:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772046139; cv=none; b=PlaejVceHFBLKdtWxsNESRIZTUDQ0QAqoX8540f5ZZmKJtutDNfmQN/z/JUysUrgvictUtvwwESCTHK9v0IA31iespmgnMPzu6qT3r2SKTRWhZAa/nZyK1RGTEgXOxaLJcuNYSnfCj6oGflT8uro5D+Pj8aj+SGpH4IA3AHUbz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772046139; c=relaxed/simple;
	bh=3J4m6I+NeRwNMzOIEpLwkf6TJbT4imOT5nxMDbUiIY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRvx5pVgLP//4+9NyPLcRA9KXpabpwGCrjXYjTtsBsdCinr7chtDffKhdpFkLiQbjFsg4mJ4fj26CMkNKPCiYK7gu78zP5oslF9QtnpD3Ri1Do852OWs4q2nfaLBfPAiUgKsbjDTLzoaTLBLChnHIlUxsPUU3Ynap0Nh1L89mnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M+50fg56; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8084EC116D0;
	Wed, 25 Feb 2026 19:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772046138;
	bh=3J4m6I+NeRwNMzOIEpLwkf6TJbT4imOT5nxMDbUiIY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M+50fg56vT1gIJGSECq3oBEd//N3hMT6tdT8LNST7/95uNVkTuxZlsPPCd8wa8jhW
	 9UMnrhC2HFq0a/aYwfjL4UFbOVc/c2YpGhf40XCcuFr3wuVdSTYJ8x7enIXY23/Xcr
	 2OKjLV8JsIZwWZ144IyqzSKVumniJBGqxmmav+GiHgbXChuGw/s97YK3eJGDTetkP2
	 h/sWuHkbcxtigZ1aDkXShRykWu4e8MjN1+kmpYtn77qeIcWpnASrcQOdKl7BMrivdH
	 Y9I0MzVwTz1f6A8TWTcxTO3Z3QOxQ+wpMOTd8xoKTEwqRPQbtGwJgtidzsHTMhhJtd
	 Av9Jbm/SpgA2Q==
Date: Wed, 25 Feb 2026 12:02:13 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, llvm@lists.linux.dev
Subject: Re: [PATCH 2/2] KVM: VMX: Use ASM_INPUT_RM in __vmcs_writel
Message-ID: <20260225190213.GA2755431@ax162>
References: <20260211102928.100944-1-ubizjak@gmail.com>
 <20260211102928.100944-2-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211102928.100944-2-ubizjak@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71874-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nathan@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,zytor.com:email]
X-Rspamd-Queue-Id: 2977719C85D
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 11:28:50AM +0100, Uros Bizjak wrote:
> Use the ASM_INPUT_RM macro for VMCS write operation in vmx_ops.h to
> work around clang problems with "rm" asm constraint. clang seems to
> always chose the memory input, while it is almost always the worst
> choice.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Acked-by: Nathan Chancellor <nathan@kernel.org>

FWIW, I hope this issue will soon be fixed in clang properly so we can
add a version check to this workaround:

  https://github.com/llvm/llvm-project/pull/181973

> ---
>  arch/x86/kvm/vmx/vmx_ops.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
> index 1000d37f5b0c..81784befaaf4 100644
> --- a/arch/x86/kvm/vmx/vmx_ops.h
> +++ b/arch/x86/kvm/vmx/vmx_ops.h
> @@ -221,7 +221,7 @@ fault:									\
>  
>  static __always_inline void __vmcs_writel(unsigned long field, unsigned long value)
>  {
> -	vmx_asm2(vmwrite, "r"(field), "rm"(value), field, value);
> +	vmx_asm2(vmwrite, "r" (field), ASM_INPUT_RM (value), field, value);
>  }
>  
>  static __always_inline void vmcs_write16(unsigned long field, u16 value)
> -- 
> 2.53.0
> 

