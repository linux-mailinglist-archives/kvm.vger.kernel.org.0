Return-Path: <kvm+bounces-20495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53234916ED1
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 19:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0954F1F2224C
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 17:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7E3176ABC;
	Tue, 25 Jun 2024 17:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PHcYjjAe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEAF175558;
	Tue, 25 Jun 2024 17:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719335116; cv=none; b=fnxIlj6BFH+T0RYWRni+V5Egg9db18y4TPdI6axmuMRplXDEqVBEN0eOaduRXUcZyXkABceDDA6bgf0O3uBPQMS/lyOWw6G9V3+mcVNEuiQuaFI8/SDENWFzsatRH+dRAOiuq1n2UuG9uRlZDv2QQqCZ1hAs+bvf3+KICjAntkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719335116; c=relaxed/simple;
	bh=bAJxqJreOQhdu05vPdDWIDbgLqBEkg5rP957BB262rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzYN0bQjEMn1BSUk4NlRgnoVHz4kLYDKPYdAmgPHptpPHsFqGh2wYXHSelZ/Q+LCe2Ma6zVCmuZy2CT4zoaD0GMGxBtFeaWd25iEOTU8B49M/Qk4NJxSCqsT451hXBTWtYDXTa6fQzjqI1iPaxeuHWgKS/kNuIV1cQfBrPne2IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PHcYjjAe; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D11EA40E021D;
	Tue, 25 Jun 2024 17:05:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pvROVOZs_XNT; Tue, 25 Jun 2024 17:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719335107; bh=GffioiUyd2+8wWvENj/ITHvgKJm5zK5Y0K6pcsxMWAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PHcYjjAein+EQN8mEF0iTLtE8ozBxZYDTysdSuSh4puWx7G7uA2GC7QIrnZCS1+VH
	 kYlaVj1XbLPQ9aveHXzkYsplHDGW7V3TupZluoVCzl2n/4vJ4V2jB/2wt5fy3y5Xh8
	 2rPb8LN8C7e2/YVxHcrWx6FQsILqrMaZfwCnEf03ByAdo2psxBdaRkWCa69ZR0a1Ic
	 4Mt/a/MdAu7DZbb1mo0/WLNgj/KM71+dh0qIuh9Qx9zeQS+XUu0FIwmVXJAMIiGlSc
	 5o20fxmfvneYwJEy9ogPpiVV2YnEy/beNLT4qXlx/t8g3ArpKD+DmTPXnOm2Nw3kCC
	 pQFwkUeQ4tbb4Or436WlPgu5ckCsKBWtpobEGo+h+kszVqev83HJB8afglmVAtXnt1
	 VxFZGoVritV+dF9Yqk+wmLBtQE81fd2qsbJrg9vZgwPSWku9UHlwX0VIiDKHj8f/7t
	 lbc1SzgNhtjiGTm3NszeuyHUEio2UcPwIofeJ+Ty2s0YcpNYoQ2agLXh/j6gj2bcPE
	 Vc4Odn+knbZgLdlzhXNo834KaKMeJ66cPm6teODv3MKYCA3GmKANba3gw+jxXrKyJG
	 I8DRE3n+ImHC28vj7KtTn2ov8+RcprzsLhdk6C2pzmLgo1Sdeuyigt3kMTC7977MuV
	 lUsK9PuthfUwBEiMjhtRVJHc=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0141140E0177;
	Tue, 25 Jun 2024 17:04:55 +0000 (UTC)
Date: Tue, 25 Jun 2024 19:04:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v10 06/24] virt: sev-guest: Simplify VMPCK and sequence
 number assignments
Message-ID: <20240625170450.GMZnr4surYmBPd94lC@fat_crate.local>
References: <20240621123903.2411843-1-nikunj@amd.com>
 <20240621123903.2411843-7-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240621123903.2411843-7-nikunj@amd.com>

On Fri, Jun 21, 2024 at 06:08:45PM +0530, Nikunj A Dadhania wrote:
> Preparatory patch to remove direct usage of VMPCK and message sequence

"Prepare the code for removing... "

From Documentation/process/submitting-patches.rst:

"Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
to do frotz", as if you are giving orders to the codebase to change
its behaviour."

> number in the SEV guest driver.

remove, because...?

> Use arrays for the VM platform communication key and message sequence number
> to simplify the function and usage.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/sev.h              | 12 ++++-------
>  drivers/virt/coco/sev-guest/sev-guest.c | 27 ++++---------------------
>  2 files changed, 8 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 2ac899adcbf6..473760208764 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -118,6 +118,8 @@ struct sev_guest_platform_data {
>  	u64 secrets_gpa;
>  };
>  
> +#define VMPCK_MAX_NUM		4
> +
>  /*
>   * The secrets page contains 96-bytes of reserved field that can be used by
>   * the guest OS. The guest OS uses the area to save the message sequence
> @@ -126,10 +128,7 @@ struct sev_guest_platform_data {
>   * See the GHCB spec section Secret page layout for the format for this area.
>   */
>  struct secrets_os_area {
> -	u32 msg_seqno_0;
> -	u32 msg_seqno_1;
> -	u32 msg_seqno_2;
> -	u32 msg_seqno_3;
> +	u32 msg_seqno[VMPCK_MAX_NUM];
>  	u64 ap_jump_table_pa;
>  	u8 rsvd[40];
>  	u8 guest_usage[32];
> @@ -214,10 +213,7 @@ struct snp_secrets_page {
>  	u32 fms;
>  	u32 rsvd2;
>  	u8 gosvw[16];
> -	u8 vmpck0[VMPCK_KEY_LEN];
> -	u8 vmpck1[VMPCK_KEY_LEN];
> -	u8 vmpck2[VMPCK_KEY_LEN];
> -	u8 vmpck3[VMPCK_KEY_LEN];
> +	u8 vmpck[VMPCK_MAX_NUM][VMPCK_KEY_LEN];
>  	struct secrets_os_area os_area;
>  
>  	u8 vmsa_tweak_bitmap[64];
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 61e190ecfa3a..a5602c84769f 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -678,30 +678,11 @@ static const struct file_operations snp_guest_fops = {
>  
>  static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)

Why is this a separate function when it is used only once?

>  {
> -	u8 *key = NULL;
> -
> -	switch (id) {
> -	case 0:
> -		*seqno = &secrets->os_area.msg_seqno_0;
> -		key = secrets->vmpck0;
> -		break;
> -	case 1:
> -		*seqno = &secrets->os_area.msg_seqno_1;
> -		key = secrets->vmpck1;
> -		break;
> -	case 2:
> -		*seqno = &secrets->os_area.msg_seqno_2;
> -		key = secrets->vmpck2;
> -		break;
> -	case 3:
> -		*seqno = &secrets->os_area.msg_seqno_3;
> -		key = secrets->vmpck3;
> -		break;
> -	default:
> -		break;
> -	}
> +	if (!(id < VMPCK_MAX_NUM))
> +		return NULL;

Or

	if (id >= VMPCK_MAX_NUM)
		return NULL;

?

Also that id needs to be unsigned as it is an array index.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

