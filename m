Return-Path: <kvm+bounces-69903-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MOtcHsnxgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69903-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:49:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CF474D04E9
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F11A302837E
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581DB376BE8;
	Mon,  2 Feb 2026 18:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="A6vQWelR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HgM4ztt/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F66C2F60A3
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 18:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057938; cv=none; b=DN6vVPWKWE5OtmEfYN8StYH9Ew11zN9qgnobAwCEkcsnZLfwgGUzSwFWXVXpSBwx9BfwfG5BcDym2k2IYM6V7fakrwE486xhsa0rsgEl6tAsUlqItjbniGUUr7UHyfIwkeJmeGtAfHbUz7CbF8JNcnF0+brLTNkgCAXsZcrBAAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057938; c=relaxed/simple;
	bh=RJUo7bccRTxp6w/X5Mb4jk7DDbM7Ry33Sc91fPvwY3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rc5bAVwfINJK4I+WU3kM2QcHEfViERBfgTTzRM3FYFWxzSm2KWACltKtysBAJ6raLgARl3tz+j6mHHM7yJxG6ozo3C+uGLYvmbgR6D2/FHXRyMhamVwm1MG9eAPUWcBUC8cUTOoSuiyjFMuyfRDJV4UHHgnlvkht75hQyFgOEqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=A6vQWelR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HgM4ztt/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 612Aw2xw2262278
	for <kvm@vger.kernel.org>; Mon, 2 Feb 2026 18:45:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=F3pTCtfOUHdevSdvNcn6XqzL
	AXxPpY1f4QI0AgduT8w=; b=A6vQWelRxUO5ssU1d44HbW04LSRdJPcgJDyxrVRY
	Pc2aHeWYECNXWzDegYEcHfxupof23ZBmKMNWIGEP+3bnwrkj/iCzv6qYArKL12u+
	JFhpG3dfm6h/wOfRjiLBR41kilUIeIbNRjFKd/vMepW+pqb9sv8ln4ME28IUginG
	YOk07VoqVwmTpLvO7q12pqmW1iRis2xpqm3p1W/GVdEI+6S+0TyMmQ2hT9It0aPT
	Q32w4ITgOW8x55wWCvEF/z9HQ3XUCu3JehBwgFuAvlbhag+FMzXatRJ888aBxoD0
	fJSdRiOsoBtfbuBsFuJV8mKGqlEi/tKvOStg9UYB/w+Wfg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c2tmthd42-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 18:45:35 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2b71bdcd037so21419eec.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 10:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770057935; x=1770662735; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F3pTCtfOUHdevSdvNcn6XqzLAXxPpY1f4QI0AgduT8w=;
        b=HgM4ztt/OGY9RxgX5fs48z3Wikzu7bD+M9jeVcsk4xiT7dxqreY4ENM5FkSTtjzKso
         2z5+IBWiwJ/WwnutERzIhquGHG/oTi+ReyodhrswYd11aJZTDS+RBkVt62yqvuRJ7Ww+
         kUSZMV5wAaO7Wh8JHLm3btOy5Q0cRMvqCAgTFbPHDfo44UNNpLRqu4qGWEN2E+8ytILg
         VIwsnU65fUIBEh6Pf+RzS+yP8TrIS4vwSeKreL+WufETtmLTiQDq0WCX2h8CRLfciu8j
         7TnLrtZIy9C/OQDv4bp7H1Qv5REf3yszGddvA3eNnVTdF3/sI/2rgNgg47JRXgbUzNvx
         Sv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770057935; x=1770662735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3pTCtfOUHdevSdvNcn6XqzLAXxPpY1f4QI0AgduT8w=;
        b=ZDRiPBlctTLooHC+6HPk2OcUV3U2BPyds4SAJy/mzTdRkG05MOT4YoVpFpDfGBkee+
         9mOQWXF5gfyvFiZBkcqyt8qOEuaXMIQ+bkoqiG20gMsjKOalcJqZBUSKf9NOOvol3r9n
         jS8t99NpAiQ4jobl0SJL9HFZCAN5hIeq9XdhclTXr/l3g+TIKqHyulKjxYCbnDKZWvnz
         Gz5IZcppiPPjTAAp7bqn1nSCTCIdD7SrGHbhdahiaaRokyOh4iw8PvI1fuoZNg02gaB5
         ZdhpLnpL/zjZ+tmFXWfoRC+x+0m8Nv2Gs2gJwSO69hnCH6eZ/3Onai8YeG0FlsoFlGSF
         Zpng==
X-Forwarded-Encrypted: i=1; AJvYcCVJN8jmz1AMl+ZbDxpkkdNFjsjATygHJTREbzAUNY7HdWWGaWbZOikX87EQedyyPtPlYBM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/q0rZzv6q9MpJic5WZU+Hk/xceUWXxjCXOHG53lfRCceRKP6O
	1ve0dCyLY2Ag0bcnJOnwbeAhUoYzWr2EEFUgxgzihjUTLs+96SnfdCHT+KUzBtyDhKdVn0KVG9I
	7L+bXJsnWcIwRHVEli82zkGT5Gv000U+p+61JQmNHOwIjcpyVbe6J5NU=
X-Gm-Gg: AZuq6aKnJiDnFnVWnN71l7aIvi55/pW7W8vLxa74J+6+hHFg1Z5hd8P9UB1k5rx7O65
	ZYNtGzS3VhimfXUZCpKgEpsoXBUwOdCLYuVFNxd8vVxv3WSqXIEuv/u2SgD0bZduZxAphsBG6j8
	8HtCCd6v86oiWEJd+xvIRzjf1dVwkI+wGpLFpmh/VHUJMaaIcuiTA2+EpYHQ2jTBF4hDO08asIS
	tjbj7rxiobBJT+rp0SfeqV3tz+1HwNnf4D6RH67Lyh61AJE+5QnIRsBdWg4HgH7GSqkhKuqU0UE
	hqtIu57A/ZFBWXEtZnp3fmiJNF6X1wFZWm0CaNGo8P3b/X683uRNDtEKX15LJQDKEFMFbnTN71l
	mNIcs/kO3zQlUu5vGo34=
X-Received: by 2002:a05:693c:2289:b0:2a4:3593:ccbb with SMTP id 5a478bee46e88-2b820e4d59cmr181290eec.2.1770057934521;
        Mon, 02 Feb 2026 10:45:34 -0800 (PST)
X-Received: by 2002:a05:693c:2289:b0:2a4:3593:ccbb with SMTP id 5a478bee46e88-2b820e4d59cmr181263eec.2.1770057933918;
        Mon, 02 Feb 2026 10:45:33 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16eab80sm20197175eec.9.2026.02.02.10.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 10:45:33 -0800 (PST)
Date: Mon, 2 Feb 2026 12:45:31 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: fangyu.yu@linux.alibaba.com
Cc: pbonzini@redhat.com, corbet@lwn.net, anup@brainfault.org,
        atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@kernel.org,
        ajones@ventanamicro.com, rkrcmar@ventanamicro.com,
        radim.krcmar@oss.qualcomm.com, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] RISC-V: KVM: Detect and expose supported HGATP
 G-stage modes
Message-ID: <ftdnjnfvmybiskej3txd23mqn3jpjdewmgjxjbap3y4ekj4h4m@d74ihtpclyps>
References: <20260202140716.34323-1-fangyu.yu@linux.alibaba.com>
 <20260202140716.34323-3-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202140716.34323-3-fangyu.yu@linux.alibaba.com>
X-Authority-Analysis: v=2.4 cv=Xb6EDY55 c=1 sm=1 tr=0 ts=6980f0cf cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=XyLJYK2s2W5OP0ZauVAA:9
 a=CjuIK1q_8ugA:10 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: ugqZWHGH4g7e6ffb2BzNi_Iwfz8OCpKq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDE0NiBTYWx0ZWRfX84vULkVxwxrv
 tpPHDzwqY1Xhluany6mFEzDLaDP9PYFfLvaYU7mD6ncF3Rs2N04ehceAvX8BKl9YNVZyss4UQFA
 c7C7+1NXjawe/aaqT2OkvcUERsVjQCNlKFq7e4HcCwEcX9+DtZtI1QJSdAIzm/VfHn7mnA3eX+H
 08UJ8pttUzlMzLKC/4JRMr3nQFl1fvglOKfs6xgrAAUQFwDUVo2CZTc+lU8AYSopH15nMSnj26f
 HzBhaRhXGFIYeW5quQUcNkqwbd52oKfo2Cg7NCxPcx9tEy9I6d2ObnX3OP136MBIHGMYqgzN7Lx
 fYvIog+5j60AJ7NUQefks1SxOD2E+z++HDDPyDrzmWEWUnIBxw7XDPCaPLnFhHYOB9LOXQtNkbU
 dWvCprJ4eRfMw9m5FU3DCXurm4M1+aNd5jhdwKMClTwmeL9rvUlRRhDZf7SSk19l/9AQbZgevZZ
 4nK+xtIwaEoI/zESvKw==
X-Proofpoint-GUID: ugqZWHGH4g7e6ffb2BzNi_Iwfz8OCpKq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 phishscore=0 adultscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602020146
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69903-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:dkim,oss.qualcomm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,alibaba.com:email];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[18];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: CF474D04E9
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 10:07:14PM +0800, fangyu.yu@linux.alibaba.com wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> 
> Extend kvm_riscv_gstage_mode_detect() to probe all HGATP.MODE values
> supported by the host and record them in a bitmask. Keep tracking the
> maximum supported G-stage page table level for existing internal users.
> 
> Also provide lightweight helpers to retrieve the supported-mode bitmask
> and validate a requested HGATP.MODE against it.
> 
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>  arch/riscv/include/asm/kvm_gstage.h | 37 +++++++++++++++++++++++++++
>  arch/riscv/kvm/gstage.c             | 39 ++++++++++++++++-------------
>  2 files changed, 58 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
> index b12605fbca44..c0c5a8b99056 100644
> --- a/arch/riscv/include/asm/kvm_gstage.h
> +++ b/arch/riscv/include/asm/kvm_gstage.h
> @@ -30,6 +30,7 @@ struct kvm_gstage_mapping {
>  #endif
>  
>  extern unsigned long kvm_riscv_gstage_max_pgd_levels;
> +extern u32 kvm_riscv_gstage_mode_mask;
>  
>  #define kvm_riscv_gstage_pgd_xbits	2
>  #define kvm_riscv_gstage_pgd_size	(1UL << (HGATP_PAGE_SHIFT + kvm_riscv_gstage_pgd_xbits))
> @@ -75,4 +76,40 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>  
>  void kvm_riscv_gstage_mode_detect(void);
>  
> +enum kvm_riscv_hgatp_mode_bit {
> +	HGATP_MODE_SV39X4_BIT = 0,
> +	HGATP_MODE_SV48X4_BIT = 1,
> +	HGATP_MODE_SV57X4_BIT = 2,
> +};

These should be defined in the UAPI, as I see the last patch of the series
does. No need to define them twice.

> +
> +static inline u32 kvm_riscv_get_hgatp_mode_mask(void)
> +{
> +	return kvm_riscv_gstage_mode_mask;
> +}
> +
> +static inline bool kvm_riscv_hgatp_mode_is_valid(unsigned long mode)
> +{
> +#ifdef CONFIG_64BIT
> +	u32 bit;
> +
> +	switch (mode) {
> +	case HGATP_MODE_SV39X4:
> +		bit = HGATP_MODE_SV39X4_BIT;
> +		break;
> +	case HGATP_MODE_SV48X4:
> +		bit = HGATP_MODE_SV48X4_BIT;
> +		break;
> +	case HGATP_MODE_SV57X4:
> +		bit = HGATP_MODE_SV57X4_BIT;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	return kvm_riscv_gstage_mode_mask & BIT(bit);
> +#else
> +	return false;
> +#endif

It seems like we're going out of our way to only provide the capability
for rv64. While the cap isn't useful for rv32, having #ifdefs in KVM and
additional paths in kvm userspace is probably worse than just having a
useless HGATP_MODE_SV32X4_BIT that rv32 userspace can set.

> +}
> +
>  #endif
> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> index 2d0045f502d1..edbabdac57d8 100644
> --- a/arch/riscv/kvm/gstage.c
> +++ b/arch/riscv/kvm/gstage.c
> @@ -16,6 +16,8 @@ unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 3;
>  #else
>  unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 2;
>  #endif
> +/* Bitmask of supported HGATP.MODE (see HGATP_MODE_*_BIT). */
> +u32 kvm_riscv_gstage_mode_mask __ro_after_init;
>  
>  #define gstage_pte_leaf(__ptep)	\
>  	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
> @@ -315,42 +317,43 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>  	}
>  }
>  
> +static bool __init kvm_riscv_hgatp_mode_supported(unsigned long mode)
> +{
> +	csr_write(CSR_HGATP, mode << HGATP_MODE_SHIFT);
> +	return ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == mode);
> +}
> +
>  void __init kvm_riscv_gstage_mode_detect(void)
>  {
> +	kvm_riscv_gstage_mode_mask = 0;
> +	kvm_riscv_gstage_max_pgd_levels = 0;
> +
>  #ifdef CONFIG_64BIT
> -	/* Try Sv57x4 G-stage mode */
> -	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
> -	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
> -		kvm_riscv_gstage_max_pgd_levels = 5;
> -		goto done;
> +	/* Try Sv39x4 G-stage mode */
> +	if (kvm_riscv_hgatp_mode_supported(HGATP_MODE_SV39X4)) {
> +		kvm_riscv_gstage_mode_mask |= BIT(HGATP_MODE_SV39X4_BIT);
> +		kvm_riscv_gstage_max_pgd_levels = 3;
>  	}
>  
>  	/* Try Sv48x4 G-stage mode */
> -	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
> -	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
> +	if (kvm_riscv_hgatp_mode_supported(HGATP_MODE_SV48X4)) {
> +		kvm_riscv_gstage_mode_mask |= BIT(HGATP_MODE_SV48X4_BIT);
>  		kvm_riscv_gstage_max_pgd_levels = 4;
> -		goto done;
>  	}
>  
> -	/* Try Sv39x4 G-stage mode */
> -	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
> -	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV39X4) {
> -		kvm_riscv_gstage_max_pgd_levels = 3;
> -		goto done;
> +	/* Try Sv57x4 G-stage mode */
> +	if (kvm_riscv_hgatp_mode_supported(HGATP_MODE_SV57X4)) {
> +		kvm_riscv_gstage_mode_mask |= BIT(HGATP_MODE_SV57X4_BIT);
> +		kvm_riscv_gstage_max_pgd_levels = 5;
>  	}
>  #else /* CONFIG_32BIT */
>  	/* Try Sv32x4 G-stage mode */
>  	csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV32X4) {

Can use kvm_riscv_hgatp_mode_supported() here too.

>  		kvm_riscv_gstage_max_pgd_levels = 2;
> -		goto done;
>  	}
>  #endif
>  
> -	/* KVM depends on !HGATP_MODE_OFF */
> -	kvm_riscv_gstage_max_pgd_levels = 0;
> -
> -done:
>  	csr_write(CSR_HGATP, 0);
>  	kvm_riscv_local_hfence_gvma_all();
>  }
> -- 
> 2.50.1
>

Thanks,
drew

