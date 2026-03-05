Return-Path: <kvm+bounces-72781-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iOE8E+QEqWlW0QAAu9opvQ
	(envelope-from <kvm+bounces-72781-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:21:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DC020AC0B
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:21:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 701A23064BD1
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 04:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48EC5245031;
	Thu,  5 Mar 2026 04:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LlBae1wC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637311F0E29
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 04:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684469; cv=none; b=fyCKgAYReo3G8ted/WWRcKKn1k+u32O3I01qhwM0+ES7wBnbe9uaudtlZAcpy5AFWJXhAV++lTKS1bWxbUoTV1qvYfg+EHh+BNUeyVYHV1pFvppKlcIOGw0yQtDc3q8Npm0DUFoyoUs1QCFzNTTp7MLi9D9QOCA0XSGt0nSc0xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684469; c=relaxed/simple;
	bh=mCfnJLaJLg+daVBBNaHa3/R5EF5xE+Cjpkd0CDVtjtw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BFPT/3N2G5o3oPRtaE/bUJiykB2lc9LJlm+qCydTefU7nsr5vh9t4c7PbHFnkSo60cMPAd43Xg5ecM0cYJfROR+BXQzZB1LiJAq51AWnYDQEWMEB1Ld8adVQc/NeLxr/x4oE3oNoCCnPwYbT/6EffNnDQZBt0A4Zk6Bp0z1mLIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LlBae1wC; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e24ee93a6so4645486a12.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 20:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772684468; x=1773289268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ceZ3dTJkwg4Hdhcsp9fwJ65sqpITXml71eHPvJD5bDs=;
        b=LlBae1wC9wjNODUto144Notsr2tHNx2rbqw7S/rdKhcNeKbR2YRCn2fye3OEcuK7F6
         1QkZMWzeV4vH6k4u7m/p5+3/VN9TiVz/Uoa2WIfAPSNx7xIaJNNk/EwJw/ga4Uda9PfD
         0sUU5cmGvcTz5Vd96fjYTWd1QJ5K6kCQB+6ZW5ioJoeofyD1oUBt51DSX+V4CfgQ9MnI
         9MeHPbPBNLv3iF9PuCm80qcJWkfI5iUYx81xZGLFohEqmjGm/bxYkJlLWNj07is1zz2w
         w8pdcYK7CJIima0YJ5fLJCSXcgdxIOcmFkGhNvQph6HgDWwaju0nmDLbYgSEMNBSJjkq
         FIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772684468; x=1773289268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ceZ3dTJkwg4Hdhcsp9fwJ65sqpITXml71eHPvJD5bDs=;
        b=LuSPkpkrnt2JaxiV97ZiEsy4k1hM8ALGTFninZbe/xzMjuFDqc7ZY+siY7NdmmYvHt
         9RmK1DdpmO8V9lagkk20i3BCxIaMZC8aGOO/d+yrdoHm4417aVK9La0pLvKP+aTrCi09
         2Ba4+RIoC5KDg1gj5SwZ/b7VAO0un8vZ525grVrSuD25jMih7T3gb2g23vw7OMIpXCdi
         rn6X32OLUfxMUokzXRyOt04sDN92Ll+7ZbZPVAfpH+RIvCk4EnhB4JhINhbBnBFBbMd6
         D4ydXLN0oI9pFcLlob02IbUdKD1a3YWJ7FYnUNnpvf3NfL2ov5yHpjXoMc0/aHrYbJ3C
         8xPw==
X-Forwarded-Encrypted: i=1; AJvYcCVeLkXXwWCNxmdkblbJuyVLaqqMDQy7secvslPx1Po+wUnRFnHrVJHmerePM3JD1kBXwYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXxqPRIFWkH20qXMs8l0Ejwe+t3yFweE68AKsTuL9FG68xsR9a
	wKDg+V2S6RU3X4TGlYLIt9JM6t9pZ/gVsNe9PGxyRDo+ucM9wu0GcBRbFKyoC5AW20Fpxa+XREt
	Z83GawQ==
X-Received: from pgww16.prod.google.com ([2002:a05:6a02:2c90:b0:c6e:18d8:7280])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d509:b0:38e:974e:af00
 with SMTP id adf61e73a8af0-39842626e0bmr1012163637.38.1772684467465; Wed, 04
 Mar 2026 20:21:07 -0800 (PST)
Date: Wed, 4 Mar 2026 20:21:05 -0800
In-Reply-To: <20260112235408.168200-5-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112235408.168200-1-chang.seok.bae@intel.com> <20260112235408.168200-5-chang.seok.bae@intel.com>
Message-ID: <aakEsXJgO-3m2xca@google.com>
Subject: Re: [PATCH v2 04/16] KVM: VMX: Introduce unified instruction info structure
From: Sean Christopherson <seanjc@google.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: E2DC020AC0B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72781-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:email]
X-Rspamd-Action: no action

On Mon, Jan 12, 2026, Chang S. Bae wrote:
> Define a unified data structure that can represent both the legacy and
> extended VMX instruction information formats.
> 
> VMX provides per-instruction metadata for VM exits to help decode the
> attributes of the instruction that triggered the exit. The legacy format,
> however, only supports up to 16 GPRs and thus cannot represent EGPRs. To
> support these new registers, VMX introduces an extended 64-bit layout.
> 
> Instead of maintaining separate storage for each format, a single
> union structure makes the overall handling simple. The field names are
> consistent across both layouts. While the presence of certain fields
> depends on the instruction type, the offsets remain fixed within each
> format.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.h | 61 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index bc3ed3145d7e..567320115a5a 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -311,6 +311,67 @@ struct kvm_vmx {
>  	u64 *pid_table;
>  };
>  
> +/*
> + * 32-bit layout of the legacy instruction information field. This format
> + * supports the 16 legacy GPRs.
> + */
> +struct base_insn_info {
> +	u32 scale		: 2;	/* Scaling factor */
> +	u32 reserved1		: 1;
> +	u32 reg1		: 4;	/* First register index */
> +	u32 asize		: 3;	/* Address size */
> +	u32 is_reg		: 1;	/* 0: memory, 1: register */
> +	u32 osize		: 2;	/* Operand size */
> +	u32 reserved2		: 2;
> +	u32 seg			: 3;	/* Segment register index */
> +	u32 index		: 4;	/* Index register index */
> +	u32 index_invalid	: 1;	/* 0: valid, 1: invalid */
> +	u32 base		: 4;	/* Base register index */
> +	u32 base_invalid	: 1;	/* 0: valid, 1: invalid */
> +	u32 reg2		: 4;	/* Second register index */
> +};
> +
> +/*
> + * 64-bit layout of the extended instruction information field, which
> + * supports EGPRs.
> + */
> +struct ext_insn_info {
> +	u64 scale		: 2;	/* Scaling factor */
> +	u64 asize		: 2;	/* Address size */
> +	u64 is_reg		: 1;	/* 0: memory, 1: register */
> +	u64 osize		: 2;	/* Operand size */
> +	u64 seg			: 3;	/* Segment register index */
> +	u64 index_invalid	: 1;	/* 0: valid, 1: invalid */
> +	u64 base_invalid	: 1;	/* 0: valid, 1: invalid */
> +	u64 reserved1		: 4;
> +	u64 reg1		: 5;	/* First register index */
> +	u64 reserved2		: 3;
> +	u64 index		: 5;	/* Index register index */
> +	u64 reserved3		: 3;
> +	u64 base		: 5;	/* Base register index */
> +	u64 reserved4		: 3;
> +	u64 reg2		: 5;	/* Second register index */
> +	u64 reserved5		: 19;
> +};
> +
> +/* Union for accessing either the legacy or extended format. */
> +union insn_info {
> +	struct base_insn_info base;
> +	struct ext_insn_info  ext;
> +	u32 word;
> +	u64 dword;

word is 16 bits, dword is 32 bits, qword is 64 bits.

> +};
> +
> +/*
> + * Wrapper structure combining the instruction info and a flag indicating
> + * whether the extended layout is in use.
> + */
> +struct vmx_insn_info {
> +	/* true if using the extended layout */
> +	bool extended;
> +	union insn_info info;
> +};

Absolutely not.  I despise bit fields, as they're extremely difficult to review,
don't help developers/debuggers understand the expected layout (finding flags and
whatnot in .h files is almost always faster than searching the SDM), and they
often generate suboptimal code.

This is also infrastructure overkill.  Two bitfields, a union, and another struct,
just to track a 64-bit value.  And the macros added later on only add to the
obfuscation.

Even worse, saving the "extended" flag on the stack and passing it around turns
a static branch into a dynamic branch.

I don't see any reason to do anything more complicated than:

static inline u64 vmx_get_insn_info(void)
{
	if (vmx_insn_info_extended())
		return vmcs_read64(EXTENDED_INSTRUCTION_INFO);

	return vmcs_read32(VMX_INSTRUCTION_INFO);
}

static inline int vmx_get_insn_info_reg(u64 insn_info)
{
	return vmx_insn_info_extended() ? (insn_info >> ??) & 0x1f :
					  (insn_info >> 3) & 0xf;
}

