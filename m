Return-Path: <kvm+bounces-71501-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALJrBcOFnGm7IwQAu9opvQ
	(envelope-from <kvm+bounces-71501-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:52:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8242D17A2AD
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5E1993092BA5
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC087316918;
	Mon, 23 Feb 2026 16:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qpD9R9Tp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5483090F5
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864823; cv=none; b=TEWjOljqGky+7U+tzjrEbCzu7AI5SUB9T2k7BjLHMRu+LRPtAugpF98tBB/bNZHPDF8s91xSo2b2NHwV2IfJA9IinJ3yuw6FlL05qp22BpY2BqN8Vi9ymNWc0qC/dAQDVgNmD4Oc4lvBqnMaGm4zlmaMSuY7fGP0L6aBnzw3AYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864823; c=relaxed/simple;
	bh=IXJhAAH1/nmIyhl+YBK57kQ2alnGFS9TAjMkhdnb+3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vCjesublrV3yn2021BzFuI6X6W9DdAJAGEdiyrfHXZN1X6Pal7EW+4b1DYYsofL2Rny+dkos5qjXGPDACLPAKttE1Q+tI+Vuux8ZfoTj8Sn4HZbEWiVakMbTo1zETCDSf4izfPav0AgCghU9GED0USkA5LXU9e3w3NzQxn3dR3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qpD9R9Tp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6df833e1efso21019312a12.2
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 08:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771864821; x=1772469621; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRtHqCOflJjuPuiCBSIsHs0ADNxbSUOiJ4HAHkLUWyE=;
        b=qpD9R9Tp0iRXgJB9LWTSr1kD7uwTsK4NNVck1Eum3lHKA6pJaOD5xYYfWAlGNu3T1a
         0m6abhsLoxTsW1mHX/LMpzwkscBTp0aJ7bxgJTFmiSRoIJoJg2qOBIfU5hBgR/XLf5ZI
         a44dXN+u3G9hFhcVwAuln5rAsO3+1gxZIuZtIDrI3dhDxfuXtg7vvZWuL7LST3paZh8z
         Q32NxfedTW9UUiSp7eO3+dryeAI8xA51u8q3JaX1pW66iU0P9oNNw+UbIuouuZMcRFTw
         RXF/erVmIGugrqdsc2cwGWqVYgXFpdJs/d/L/mg0Lr4GmH+/9eLLMxD1hG0H0nmnOSiT
         yGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771864821; x=1772469621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRtHqCOflJjuPuiCBSIsHs0ADNxbSUOiJ4HAHkLUWyE=;
        b=EDvpVY0QuSPuAEV5mlNIKpjhZ09OqIDPJg943q8gOgth385NM3Su3NGp95hjTFOdLc
         ldtgLOIRvxKZj1knxcFqYHdbFA5t6Kf7CO2qORmSvFyfK999fUgUyykILgqcpJJa9uTR
         RbMHxGvLgmnM8fmL8jPms14O3stq/q0z4T+2/+VgHMNRxFYPi+M/ntbYrEMSr1dVB2q/
         9FN/faFDqp48XOdwW7cVLVBwPd11UhndDnZMoFSBbtmE8sGUPmAAtNq8gXEypgSMy0Ge
         4WTr4DlQJxlCl6VVtiGBN9OU5wT+S7trlK7cDu/YCAdPJXyEr4LnUy+QwyUihX0PRyOe
         DW/A==
X-Forwarded-Encrypted: i=1; AJvYcCV8roZPWI+Lov4kOpK29BOXnXlpAkVyJBdMhYFWw/UZXSe1M900Kvpw+6joyUsCh9/uIBg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTCgRHrknpGb7j6h1cnXFrtUAtK3Nr5pcWvvPO1rN4tx6i7KTU
	EPoRfSVoX+Ek6gyynAo7ae3/J8FJrAz6jQRHt2zoXsOSsZ8fgrBupQc65VEo4OQgQ0cTEA3agyP
	LOPeaPA==
X-Received: from pgbcp13.prod.google.com ([2002:a05:6a02:400d:b0:c48:d03e:cc20])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9987:b0:366:19e9:f43
 with SMTP id adf61e73a8af0-39545e527a0mr8858315637.6.1771864820987; Mon, 23
 Feb 2026 08:40:20 -0800 (PST)
Date: Mon, 23 Feb 2026 08:40:19 -0800
In-Reply-To: <20260223162900.772669-4-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223162900.772669-1-tycho@kernel.org> <20260223162900.772669-4-tycho@kernel.org>
Message-ID: <aZyC89v9JAVEPeLt@google.com>
Subject: Re: [PATCH 3/4] crypto/ccp: support setting RAPL_DIS in SNP_INIT_EX
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-71501-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
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
X-Rspamd-Queue-Id: 8242D17A2AD
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> The kernel allows setting the RAPL_DIS policy bit, but had no way to set

Please actually say what RAPL_DIS is and does, and explain why this is the
correct approach.  I genuinely have no idea what the impact of this patch is,
(beyond disabling something, obviously).

> the RAPL_DIS bit during SNP_INIT_EX. Setting the policy bit would always
> result in:
> 
>     [  898.840286] ccp 0000:a9:00.5: sev command 0xa0 failed (0x00000007)
> 
> Allow setting the RAPL_DIS bit during SNP_INIT_EX via a module parameter.
> If the hardware does not support RAPL_DIS, log and disable the module
> parameter.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 096f993974d1..362126453ef0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -75,6 +75,10 @@ static bool psp_init_on_probe = true;
>  module_param(psp_init_on_probe, bool, 0444);
>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>  
> +static bool rapl_disable;
> +module_param(rapl_disable, bool, 0444);
> +MODULE_PARM_DESC(rapl_disable, "  if true, the RAPL_DIS bit will be set during INIT_EX if supported");
> +
>  #if IS_ENABLED(CONFIG_PCI_TSM)
>  static bool sev_tio_enabled = true;
>  module_param_named(tio, sev_tio_enabled, bool, 0444);
> @@ -1428,6 +1432,16 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  			data.max_snp_asid = max_snp_asid;
>  		}
>  
> +		if (rapl_disable) {
> +			if (sev->snp_feat_info_0.ecx & SNP_RAPL_DISABLE_SUPPORTED) {
> +				data.rapl_dis = 1;
> +			} else {
> +				dev_info(sev->dev,
> +					"SEV: RAPL_DIS requested, but not supported");
> +				rapl_disable = false;
> +			}
> +		}
> +
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> -- 
> 2.53.0
> 

