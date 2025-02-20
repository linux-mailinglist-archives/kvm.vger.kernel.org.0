Return-Path: <kvm+bounces-38761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E316FA3E29F
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2146B189585E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AEB213248;
	Thu, 20 Feb 2025 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MYyvorWm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDDB2116E1
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740073003; cv=none; b=Vs3AIcLRUXM7Ffl6IA/fzs6kugzn/CgGidr5bv5xyvnPga3k+k+lDO+XXzQIJl6ziX8Oay6DsRLSBW8i2Jg2Z3mxOXDStvmgCDbCBk/MxzvwhS7SaPuqNSRAHwbk6Ok1XYnschb4YbLZvVq2KZlPiv4XeMb8nWCZbs38wOjjH2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740073003; c=relaxed/simple;
	bh=kwe+tQSoGJcdPaF0wgLIDSLqOxgh5pk6T6ef3Yy9nVQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UM3d9XkOJuoEYYr/cYOlVdGr07dDuOj+F2vfKoqCBh7HyPRKxbDBEWQk1Nifb9LsXVE4iH4m8uW78l9iytihBMUEVw2Ny+SLP+P335O4Ko6Zco5oRqynCsQSEPUXnOeR5bOXgtsRjI8QJUot+s3vIt7AqRHmeOp5oODhoGNAW0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MYyvorWm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740073000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n15bf8E4w81YIQXcbn52KewH85spv07PWBoufUb1/Zw=;
	b=MYyvorWmWManwk1iS1Z/eBaLHsRdX/RoNBHai/2bZKkW0n8tNb6pD8WHlN3Hsx+luK6BsC
	oz42lZA1vzLXayeEFYChp7vg9WkdElbef2cqlJsjZ8PsetMUASfu6nyIRCRtBjA152hfuE
	MeGkqLOv/ZOkOimLe20PsELQ6uQ8Qs8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-FmUMubPEOKaIBIjXb7T4Rw-1; Thu, 20 Feb 2025 12:36:38 -0500
X-MC-Unique: FmUMubPEOKaIBIjXb7T4Rw-1
X-Mimecast-MFC-AGG-ID: FmUMubPEOKaIBIjXb7T4Rw_1740072998
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43943bd1409so8780605e9.3
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 09:36:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740072997; x=1740677797;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n15bf8E4w81YIQXcbn52KewH85spv07PWBoufUb1/Zw=;
        b=DGDiOprX2Tt0i/0fAz9Q8vRsJLfgnJ433+UE1iaGMRVyZpxiSX2MN9nrldkzOuXf3Q
         Jva037wvNZR/0mRczz/WC81g3OcwQBhqlUhE3X5WmWj6DRWkr9/XTpxEkEV9bR6FBltT
         VG8ehBc1AxGzyOGgJVf6uISR7c0iGqXbdid7b6ck/0A7S8UFxW8Tq2UGYGGz4bl9qAYE
         ygTJaZL7PvsNu8oHP2FpXqiEoef0AX9cXP6OBMqqa88ylmGmYODWzJ9fI6pEKzHyVCf7
         Jq7zSXj7WMfKKclOm7hD6chJd1bIifJeeSBl2+Ewh+CLHxyF1eQoVRJ5L8VIUtyLP7zu
         FIIA==
X-Forwarded-Encrypted: i=1; AJvYcCUcSiRd83iEBskY8WKZ/DdX49tuZXqN/SHyEA3GbG0ZNRIwyOZBNkuWTzCN0AAG6Wt1i6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt6Ca2I10ojHuwr7xuK80PPlti9O9LNESpcqnDytBxy+w3GFpz
	e4N8sPv7qrJHtNCl/3SQDv9DuoL2Xzvvg0RVc0Dl3aZDSAY7P6LurVvPXag4OdOX3JhHMkMeS3Q
	Cq2S5JUTC6UeA1/oKFppKZ483XNze+bxRvMP7jEbkq3M0rWhHmw==
X-Gm-Gg: ASbGncsDK5BoeU/ZMrx+Mmg738+0fAvaTZ9TriKcmRV7F7VRVQ1s1cjVYkwvT8VTwPd
	/fzSZeCl5tjTebtI098yuwENnd3uTYqk0QS78Apcmlp5ViN1z0e7hTDfXqxVURhpc26+tfEWPKQ
	364rrZpfQgzNHTGklDutIY22W23XHDsxmArJzCY5cs+rVd57IhpYiYWmTaixe+DCzRFBHJyyP9D
	mLHxMiMUT48KM+oCrMdqeGCzZ/VVRIkWCa6rWlmak3TF9UEZN4dlB9iX2bas1AL6jDvRc4HsZIP
	4x9Embz/rNtYfjuo9L959RJnSeTSyzePalbNGGMEbNPhxvFd3S85qw==
X-Received: by 2002:a05:600c:4e8d:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-439ae189b90mr2045245e9.0.1740072997620;
        Thu, 20 Feb 2025 09:36:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHy5FnqR/8AjjY8RLPAgdr+NGtk75Kqe0crbyEx5UtstYLGj4EGzUk8OPNUhCk+6xcuGov9Tw==
X-Received: by 2002:a05:600c:4e8d:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-439ae189b90mr2044905e9.0.1740072997264;
        Thu, 20 Feb 2025 09:36:37 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4398872fa85sm117119635e9.28.2025.02.20.09.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 09:36:36 -0800 (PST)
Date: Thu, 20 Feb 2025 18:36:35 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>, gankulkarni@os.amperecomputing.com
Subject: Re: [PATCH v2 02/14] KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest
 and userspace
In-Reply-To: <20250220134907.554085-3-maz@kernel.org>
Message-ID: <af16f5bc-4300-54d3-b480-c559ec070a44@redhat.com>
References: <20250220134907.554085-1-maz@kernel.org> <20250220134907.554085-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Marc,

On Thu, 20 Feb 2025, Marc Zyngier wrote:
> Since our take on FEAT_NV is to only support FEAT_NV2, we should
> never expose ID_AA64MMFR2_EL1.NV to a guest nor userspace.
>
> Make sure we mask this field for good.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/kvm/sys_regs.c | 1 +
> 1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 82430c1e1dd02..9f10dbd26e348 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1627,6 +1627,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
> 		break;
> 	case SYS_ID_AA64MMFR2_EL1:
> 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
> +		val &= ~ID_AA64MMFR2_EL1_NV;
> 		break;

This would cause issues when you update the host kernel while keeping the
guests register state. Could we allow to write (but ignore) the previously
valid value? Like it was handled in:
 	6685f5d572c2 KVM: arm64: Disable MPAM visibility by default and ignore VMM writes

Sebastian


