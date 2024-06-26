Return-Path: <kvm+bounces-20560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9869F91844A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 16:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52FDE28706C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 14:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5748186E4F;
	Wed, 26 Jun 2024 14:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r3EQgpPh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B88B186E2A
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 14:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719412355; cv=none; b=oQxcsYRce9vw/sLHibKZkQ0iWBOSxGgC7jbkEKIWcP3adqvJabGdtPPUULwfY7lAVkp7PAcQtGZsMqZwnfPBAeJVVRCHoADWwbZcQOhT67rCKGqU6S/MSyW9KldRlE+dOvAzmgza2ix+NLTicehlX1ZUlYN+izFHOUY5cNvNalk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719412355; c=relaxed/simple;
	bh=ZNPzGDrViZtN+euOTYNGNCvhSBpNIjiT+sYwF77Gmis=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XwaQ45M+m/pcT2ukmApH9Z9El6xgS8khY+ng+ZDU6b54069SOvMbz3YzXn/+0s9ud1Gxz3BXJhiVtT+/0rP9Uc36SmJdgUnOZci4alTbhErw5OrBFwgN7PMtj+LB+7uSJbqvmnLBv1W4M8a/YrXw1m+VersqCNGQegjTvj+gFTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r3EQgpPh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c24109ad3fso8599937a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 07:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719412354; x=1720017154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Ymlm/4AWkUfS196/Og/rjOQ+iw7EfhnrK5+wBxuoc0=;
        b=r3EQgpPhbMAZDPicDQ3ZsPOiFCPTrsN2u/NcGmyFf7CpG/LVOz3H7ylimnT8bO0XBN
         iJItMVsoJwTJv62TDBC33A35xodVouHtKVmyZ+hBCF5PdQPcsp85YaoWDR8ih/7QRba2
         sLi9q9SfbZAaiJpzbrls3CUbghkRy9DALQVIgzsmhvPl6/PnBuRAPtVVfj67OCcmRm0q
         oXF4/DDIai+aIxWDDVi3ts03HyVYfYPsz8/rDZpkFMkenyYaexMGmgwElmiFX3nCO/61
         +UuuX7VOisxk8A7L6Rp9R1u7/We8sz77Jmb7u4nqJz0IhE2jqDXA/E1b0M5VPZRLuZlt
         fVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719412354; x=1720017154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Ymlm/4AWkUfS196/Og/rjOQ+iw7EfhnrK5+wBxuoc0=;
        b=JmYoJ5LdmacED/CnHeHwMYaFbA/R05MwZZUZk7eDR120bu/tBd6reGU7b4ENHf33qR
         zn1GIzBMWJX2yDZ6Ijueb5CgeTwOF5Fy700N4PgApGZlHr8yMzBOfwiDrDaGgp1rrN8D
         CFS6g5xeITUhRcKyzwuKpnxzp8h4RTVk2YiF6SgH5mKOKninNPekJHxPM/6BscPrh6oi
         GwYbrWXzOxryr2PcDJ7IfM7+TdBwhWRNk67MEy4mVpGWEWwKg6xBWaZruZgYBdjzmAl1
         XqMuwEEmCc6VKwq9l8s6UFzlfHRLLZ9q4KRbPmgXoEGLBcSdvmehMZbFqQtvX39B+EOm
         9etw==
X-Gm-Message-State: AOJu0YyNqtLp5PBIfTUHjxBXhryPgDgHPP7jf/gi10Wur1oiui7G/fRh
	xXD3ZbIC5+bU42wNK0xEQMlgqchIQe8FNW4OFiIiJMCBkoWqyIQRS7gWCVj6VL7XUtTJv/ow6vm
	P3g==
X-Google-Smtp-Source: AGHT+IHoLpy1haJfmM+o0LmD5U1iZh86EBvuJ5rgP0o2pdMh09BBK9/6PtMelrlOW3VGdks0UySW+x/E2qQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e7c4:b0:2c2:c6fa:c05d with SMTP id
 98e67ed59e1d1-2c86147a695mr30306a91.9.1719412353662; Wed, 26 Jun 2024
 07:32:33 -0700 (PDT)
Date: Wed, 26 Jun 2024 07:32:32 -0700
In-Reply-To: <20240621171519.3180965-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240621134041.3170480-2-michael.roth@amd.com> <20240621171519.3180965-1-michael.roth@amd.com>
Message-ID: <ZnwmgHYWQQ4DP176@google.com>
Subject: Re: [PATCH v1-revised 1/5] KVM: SEV: Provide support for
 SNP_GUEST_REQUEST NAE event
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, pgonda@google.com, 
	ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com, 
	liam.merwick@oracle.com, Brijesh Singh <brijesh.singh@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 21, 2024, Michael Roth wrote:
> diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
> index 154a87a1eca9..7bd78e258569 100644
> --- a/include/uapi/linux/sev-guest.h
> +++ b/include/uapi/linux/sev-guest.h
> @@ -89,8 +89,17 @@ struct snp_ext_report_req {
>  #define SNP_GUEST_FW_ERR_MASK		GENMASK_ULL(31, 0)
>  #define SNP_GUEST_VMM_ERR_SHIFT		32
>  #define SNP_GUEST_VMM_ERR(x)		(((u64)x) << SNP_GUEST_VMM_ERR_SHIFT)
> +#define SNP_GUEST_FW_ERR(x)		((x) & SNP_GUEST_FW_ERR_MASK)
> +#define SNP_GUEST_ERR(vmm_err, fw_err)	(SNP_GUEST_VMM_ERR(vmm_err) | \
> +					 SNP_GUEST_FW_ERR(fw_err))
>  
> +/*
> + * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but define
> + * a GENERIC error code such that it won't ever conflict with GHCB-defined
> + * errors if any get added in the future.
> + */
>  #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
>  #define SNP_GUEST_VMM_ERR_BUSY		2
> +#define SNP_GUEST_VMM_ERR_GENERIC	BIT(31)

Related to my suggestion to not have KVM-defined error codes, if we go that route,
then I believe SNP_GUEST_VMM_ERR_GENERIC is unnecessary.

For snp_handle_guest_req(), if sev_issue_cmd() fails, KVM can/should do something
like:

	/* Forward non-firmware errors to userspace, e.g. if the PSP is dead. */
	if (ret && !fw_err)
		goto release_req;

	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(0, fw_err));

And then in snp_complete_req_certs(), we could either let userspace shove in any
error code whatsoever, or restrict userspace to known, GHCB-defined error codes,
e.g.
	int err;

	err  = READ_ONCE(vcpu->run->coco.req_certs.ret);
	if (err)
		if (err != SNP_GUEST_VMM_ERR_INVALID_LEN &&
		    err != SNP_GUEST_VMM_ERR_BUSY)
			return -EINVAL;

		if (err == SNP_GUEST_VMM_ERR_INVALID_LEN)
			vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->coco.req_certs.npages;

		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(err, 0));
		return 1;
	}


>  
>  #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
> -- 
> 2.25.1
> 

