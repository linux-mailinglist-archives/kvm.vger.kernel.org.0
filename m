Return-Path: <kvm+bounces-44181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9282BA9B13F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C841F9225DB
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D490517A5BD;
	Thu, 24 Apr 2025 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OJePo/ng"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B92715533F;
	Thu, 24 Apr 2025 14:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745505544; cv=none; b=aSDK3qrcyFv+Mkp2t0Gs1ty5ICFRARNAFyz6jZRk9Dja3+JK4uYnJyjtOQzoffviE5FXftUqnfJLknRF1DZhSq2smyCu8fNzA4XP2NvKl9hku1oZr1DjhSzw9UfraussVZKbNVOE4+ape82ItuBWhjKc0yyBJJA24wbFhRwgAj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745505544; c=relaxed/simple;
	bh=TLVz/CTjw1SW9cTVLZDqmNJSZsjwJqxJYyBQRUZ2vG0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=cj0kY4L7SzRr831PXLBzgkgo6k+Oxkx7wATqEFcUZ39f0auYhjM4koCIGimralGmbEc8/QKT4cXhoy9Cg8T1lpUA3UgV+1fw8qxHejbSK9ZmwAm763xJNQUWI1gtN3NFBnEC0ROrJTvJFhSKNMsv90LU4oKjlGuR/DOsg7JMCN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OJePo/ng; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43edecbfb46so8044105e9.0;
        Thu, 24 Apr 2025 07:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745505540; x=1746110340; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=He1Y9ktqx1lW20BpUlUu2/rAP5XgA+Dn5l+R6PEz93M=;
        b=OJePo/ng/AqMarQCDSzT6H6ruSuD5KfXshF5MJYSWlcTNSghmBfZxCFHuBfYWkxqCW
         NlkYoLyK2LghjDA+tTrNRf9Yt5fMQldT6lznNXqmmVSNgvNW9VRD+2ScSbl8CWE30j4k
         3pZcNKPGyEkf2uopnOSG083znxyJ6WFQ/urkcd021jsFBsoLDBcf1HCU3BeaDKj25B6G
         8RR77nqAiImCnJgQ1U3f+1dDq4r0Ftto8MG8MW+YBKe8CBwyFsMov6y+E2kJ1Cy/W1GX
         DTfYY2bGfJlBgIsDvctjnx3TW5YT9GgcF9xvwcl1oYLnSmmJcEjM4H2v49ASs2yqIxDl
         /FoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745505540; x=1746110340;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=He1Y9ktqx1lW20BpUlUu2/rAP5XgA+Dn5l+R6PEz93M=;
        b=p2NEwzSoYV5Eh4femfe85x2rJtoxlqnA0pbIQWhjpqpzU8NUY/wG/gjZE86EWN3mhK
         Xg8RMgNKQpeeDJCv78NrSzXM5ZQkAqKrCYfOWNztoxEWqWfoUUnO4GLOYM02nuSb1Qjz
         Da7DPY0XepSRwpaR5tf8tGthzZ7AdeB0iQVLfhN3l7JXAw4jQ5owoRiRbsqXmAhU3npv
         l9q64JFBUseDjDjQYIIiAOS2HOytpc0GdVi5igb0EEPeaQNzg0COOPZto+08S8XuQIKw
         5x9pppJU/5cI7K1dDfouZaMjgibcgruVeJp3l5VsI8l1OVmSJkFppqIAFVm9dDsW54bz
         Z3hA==
X-Forwarded-Encrypted: i=1; AJvYcCWXS1YgAQ/kO5CcscXa6zwpffTd99jglbtlNfyiaXvisZAebjOcQLNfVBqBOAa6SQ3hy/s=@vger.kernel.org, AJvYcCWgPl9t0ZDqjQvhgQHAdDC4DmGzjb+cD18IVtihZL3y8YnI/mARJ2hH/qG7oJwezUsHvuwuYr1/qZO2k2WW@vger.kernel.org, AJvYcCXfanbnSgNKxzSVPhJrB+UEdunIhqOaQ6J4NHjxvstaVrzLv3Xm4kgZIt8pM7jCm9vX7jB2t+eKpyDjeTJJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxLJPultxfHt0LklKGiv5iELd2dxHrmkva0zMphRdlA09XJ1727
	iFMPnvNGdXwI8evIyllX63ENh1NxUAt6IaO2yToUfvKH0qDQZgwX5bXGvsUI
X-Gm-Gg: ASbGncuIO6Katmrlkjae3hkduehSW8zlrBYl2hkCbNEmGj3RwyCha+DNVmzz9+Eujhu
	/nsI2j+3PGexwXT6trA2WgN3bfwuKlODrMdE+c90F+xjv3Beh6hlf4Go5wOdpTtG54pmkI+2yJB
	k6+rT7AE2GITVgZplMWdBytAHlhIiT5gGo9QCv9S0CpKn3j/TGWp9RttlaB4xRmC41CDd+t1TSY
	Jv7WekhSF9rd2JlSDq4qAbwzHE1Q9DmIfWn2Suk397wXWNjP6DIYqStrLEczJe7jl3CAV/g9wl6
	MgWGMUAcFxgbD25eKMXoMgVSVY2fXfWWobr9Qw3kpO7KNKOr1HmjawoqMh5cGAk9m0KpUcoQuYe
	lwF4w9wh17jvAPZ2kQ6GjGQ==
X-Google-Smtp-Source: AGHT+IHguIgZwJYV78SWBgbaRJqi2L28fF8iAgoCSk/UNtw4z12GqAm7g8nXeMSLOYYgnmRBoYQR5g==
X-Received: by 2002:a05:600c:1f93:b0:43d:d06:3798 with SMTP id 5b1f17b1804b1-4409bd8cf5amr25620225e9.20.1745505540103;
        Thu, 24 Apr 2025 07:39:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:16d3:1272:6f9c:e726? ([2001:b07:5d29:f42d:16d3:1272:6f9c:e726])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2b8940sm23938575e9.30.2025.04.24.07.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:38:59 -0700 (PDT)
Message-ID: <7da931d3e045aad6349879c16db9a8bf17aa0d60.camel@gmail.com>
Subject: Re: [PATCH v3 2/4] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: ashish.kalra@amd.com
Cc: bp@alien8.de, dave.hansen@linux.intel.com, davem@davemloft.net, 
 herbert@gondor.apana.org.au, hpa@zytor.com, john.allen@amd.com, 
 kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org,  michael.roth@amd.com, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com,  tglx@linutronix.de,
 thomas.lendacky@amd.com, x86@kernel.org
Date: Thu, 24 Apr 2025 16:38:58 +0200
In-Reply-To: <0ec035a24116dce7c8b2a36a29cf5eed96e0eb52.1745279916.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2025-04-22 at 0:24, Ashish Kalra wrote:
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-
> dev.c
> index b08db412f752..f4f8a8905115 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -232,6 +232,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return
> sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct
> sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct
> sev_data_snp_commit);
> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct
> snp_feature_info);

This function is supposed to return the size of the command buffer, so
for this command it should return sizeof(struct
sev_data_snp_feature_info).

>  	default:				return 0;
>  	}
> =20
> @@ -1072,6 +1073,50 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
> =20
> +static void snp_get_platform_data(void)
> +{
> +	struct sev_device *sev =3D psp_master->sev_data;
> +	struct sev_data_snp_feature_info snp_feat_info;
> +	struct snp_feature_info *feat_info;
> +	struct sev_data_snp_addr buf;
> +	int error =3D 0, rc;
> +
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +		return;
> +
> +	/*
> +	 * The output buffer must be firmware page if SEV-SNP is
> +	 * initialized.
> +	 */
> +	if (sev->snp_initialized)
> +		return;
> +
> +	buf.address =3D __psp_pa(&sev->snp_plat_status);
> +	rc =3D __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf,
> &error);
> +
> +	/*
> +	 * Do feature discovery of the currently loaded firmware,
> +	 * and cache feature information from CPUID 0x8000_0024,
> +	 * sub-function 0.
> +	 */
> +	if (!rc && sev->snp_plat_status.feature_info) {
> +		/*
> +		 * Use dynamically allocated structure for the
> SNP_FEATURE_INFO
> +		 * command to handle any alignment and page boundary
> check
> +		 * requirements.
> +		 */
> +		feat_info =3D kzalloc(sizeof(*feat_info), GFP_KERNEL);

The SEV firmware requires the supplied memory range to not cross a page
boundary, but kzalloc() does not guarantee that the allocated memory
fits this requirement. You need to allocate a larger chunk of memory (2
* sizeof(*feat_info) will be enough), and possibly set
feature_info_paddr to an offset from the start of the allocated memory.

