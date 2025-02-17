Return-Path: <kvm+bounces-38325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E494A37A65
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 05:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0517E16D9C6
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 04:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF9D188587;
	Mon, 17 Feb 2025 04:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQmMTmQE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C27028E8;
	Mon, 17 Feb 2025 04:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739765814; cv=none; b=Sy+zUiKeeq43fjB7D8CMJ1J5Sbuyj5oRAULdhzjyGL+hnLn2S8+Fl2ttOFuzCagU4uvCU6po0qMD5niBeIln1JP2nN0Vjg1G2yLSbkpgAcN/pjDgr5nOFcqnCecG/d20jUySeiFlB1LEfGoDgrtSd5zWOpA2g8XF9JJji8kXVL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739765814; c=relaxed/simple;
	bh=N86/h7l83+47tvxTpYCMDfgo8tnXcSE6ua8ZwDv94HA=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=hk8+KyfTdUYE7+bVQXxf1tyVVGAi1NiVTzt6kRQguHX+MQaBEhBvJoqPjRtWXRb9e91g1z/tIAA+K4wLtIKIZhUo/qzieoSVnMV1ISk/Z9hllVqpNyW384ppkh8C/KlFwYBWkBUIkRW4NWGFfnQ2r9xjc5d+giZV3zWh5rA4wzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQmMTmQE; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2fa7465baceso8020725a91.0;
        Sun, 16 Feb 2025 20:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739765812; x=1740370612; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VZVssffNqWNjzTU9TTGkv9mNAMtzHUOrTJpj7IuOEXk=;
        b=CQmMTmQEKnkSYZ5kWTcsvdOcjqGmzicir/Oxsy63uJN8FLcFQiXuKRjnDbL05iYlJI
         x1wmuf0Qs106BXOL49BvTYQj6ed2z2p7l2mXUayydUmSJNodebshlDX5VryBuaTfOJ+7
         woh2VnyTiNpfxI/uZJz2pooNzTDXWxVAFyghAeufvQChR3FcyywCsvd/OXpq4ID0NLyO
         f2exAqXps5+2QEQGiM8FKrHjFixdLBQ53y+fg6w3zdcJ5NtYDLi6pn7o0LWiWnD2YJ6j
         mqB2aeE2XnZEkre1TgJdgcdMQE5N51E2AT0bZ7S0I9wuYesu3ZvCjgtrNNosGuttq2nz
         SK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739765812; x=1740370612;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VZVssffNqWNjzTU9TTGkv9mNAMtzHUOrTJpj7IuOEXk=;
        b=nmISTqnEq0j/WDRLWE21+NieBUEdoFH/GH4ofHelXakO8CFmbn8/SLWZ2Y2zCbwTTS
         U13MAUP4kAWNo9iiJBS2bfQ/d1JT632wB2tsbI5o0DYuZ0Nj5ykkVygtaPO/M1w7BHxG
         c36i4F0h+ndvo/u0hVSse9/80KO0ujgz5m5IJjDChxwsDUZgKmVxYB76VaphmD0LkqFF
         Pe+x4XQP3UVq6W8NLhxgnofXsXzzyMcI7PzXJPZ6Nr3v5KvpNyCJXyjZ08BvU1KkY0so
         gu1TOlgEp4GVE1YsnJWX8o1CF/yJyqHNyDbPf1JLKGn8UUzGBeSSFt95cwDVb/qp2CHo
         u/7w==
X-Forwarded-Encrypted: i=1; AJvYcCV3e+yeDLyNqrYlh5X+NZe9y7amaMpy2v6OGK85HZYr4P2VS5nqQtozhYyeTXYC+JuC73u1@vger.kernel.org, AJvYcCWEw5Ok0vlShO5F/n3QS6n1pKst/CN1bd43BPsJKvFV0XbecNCnA4aQHWrUWuGgNmfzRQ58k26wvnWBYSWM@vger.kernel.org, AJvYcCWhFTOcB5s85uENbRKxia25Aswh6fXYU1Se0kW0i4GaL5ftZ1jGhxVXtt6XZ2JXDgOGNASxboJU@vger.kernel.org, AJvYcCXlVUla3ToZEaBxHjFdpoqbEwWo6takuJAckjVzS13lRZK67zvTWtt8ypaNSXTYKuAfdJCipgBB@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg3bQP7DwpTd0qnaEnP6pmfM+7rHRV2/E2qT6BlXbXUja2vwEC
	5nieNvRGj+YRn+OoOfRTtr5syligdl6QmGKQecxzOXHErYrLWPO+WhU4HABg
X-Gm-Gg: ASbGncu6QWNOaHl1gKueoDE0pAMmGUkqRKn805/cpHiHjUVrvs4R36e8arCfa1puEcx
	1s6OiG9va+2rqYE+ykM03aOG4mkvap2X6FoqCM4BGvFHWMFGHGICMZpYcgporevuKElfJkS1gzb
	YTsAMTiVBsu0bLWDyKgosOALxix93czC4ASsi3G/gSjBfH2w657d1HnxSOSvRaWmng/W2kYOSNh
	9txh6Sq81Zjwrk+9LuSKwuYE/unKIL7xDzGXXeiHBTvLpwVj3eKGtbZFW0S+1uo3ytTgwnFSwnN
	0mhK1swL
X-Google-Smtp-Source: AGHT+IGB5lOheIDXmi3sWf655bfcf3YqTTKwUkHEUPhH7vLLYB3KzpSLLyEceBcoqQHonVYqV8aYkg==
X-Received: by 2002:a17:90b:384d:b0:2ee:74a1:fba2 with SMTP id 98e67ed59e1d1-2fc40f21e20mr12741959a91.20.1739765811865;
        Sun, 16 Feb 2025 20:16:51 -0800 (PST)
Received: from dw-tp ([171.76.86.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf5b93282sm4910089a91.1.2025.02.16.20.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2025 20:16:51 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: Amit Machhiwal <amachhiw@linux.ibm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Amit Machhiwal <amachhiw@linux.ibm.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Shivaprasad G Bhat <sbhat@linux.ibm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: PPC: Enable CAP_SPAPR_TCE_VFIO on pSeries KVM guests
In-Reply-To: <20250129094033.2265211-1-amachhiw@linux.ibm.com>
Date: Mon, 17 Feb 2025 09:30:51 +0530
Message-ID: <8734gdqky4.fsf@gmail.com>
References: <20250129094033.2265211-1-amachhiw@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Amit Machhiwal <amachhiw@linux.ibm.com> writes:

> Currently on book3s-hv, the capability KVM_CAP_SPAPR_TCE_VFIO is only
> available for KVM Guests running on PowerNV and not for the KVM guests
> running on pSeries hypervisors. This prevents a pSeries L2 guest from
> leveraging the in-kernel acceleration for H_PUT_TCE_INDIRECT and
> H_STUFF_TCE hcalls that results in slow startup times for large memory
> guests.
>
> Fix this by enabling the CAP_SPAPR_TCE_VFIO on the pSeries hosts as well
> for the nested PAPR guests. With the patch, booting an L2 guest with
> 128G memory results in an average improvement of 11% in the startup
> times.
>
> Fixes: f431a8cde7f1 ("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
> ---
> Changes since v1:
>     * Addressed review comments from Ritesh
>     * v1: https://lore.kernel.org/all/20250109132053.158436-1-amachhiw@linux.ibm.com/

Thanks Amit for v2. However we still didn't answer one important
question regarding the context / background of this patch asked here [2]

[2]: https://lore.kernel.org/linuxppc-dev/87r059vpmi.fsf@gmail.com/

<copy paste from v1>
    IIUC it was said here [1] that this capability is not available on
    pSeries, hence it got removed. Could you please give a background on
    why this can be enabled now for pSeries? Was there any additional
    support added for this? 
    [1]:
    https://lore.kernel.org/linuxppc-dev/20181214052910.23639-2-sjitindarsingh@gmail.com/

    ... Ohh thinking back a little, are you saying that after the patch...
    f431a8cde7f1 ("powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries")
    ...we can bring back this capability for kvm guest running on pseries
    as well. Because all underlying issues in using VFIO on pseries were
    fixed. Is this understanding correct? 


Please also update the commit message with the required context of why we can
enable this capability now while it was explicitely marked as disabled
earlier in [1].

But looks good otherwise. With that addressed in the commit message,
please feel free to add - 

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

-ritesh

>
>  arch/powerpc/kvm/powerpc.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index ce1d91eed231..a7138eb18d59 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -543,26 +543,23 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = !hv_enabled;
>  		break;
>  #ifdef CONFIG_KVM_MPIC
>  	case KVM_CAP_IRQ_MPIC:
>  		r = 1;
>  		break;
>  #endif
>
>  #ifdef CONFIG_PPC_BOOK3S_64
>  	case KVM_CAP_SPAPR_TCE:
> +		fallthrough;
>  	case KVM_CAP_SPAPR_TCE_64:
> -		r = 1;
> -		break;
>  	case KVM_CAP_SPAPR_TCE_VFIO:
> -		r = !!cpu_has_feature(CPU_FTR_HVMODE);
> -		break;
>  	case KVM_CAP_PPC_RTAS:
>  	case KVM_CAP_PPC_FIXUP_HCALL:
>  	case KVM_CAP_PPC_ENABLE_HCALL:
>  #ifdef CONFIG_KVM_XICS
>  	case KVM_CAP_IRQ_XICS:
>  #endif
>  	case KVM_CAP_PPC_GET_CPU_CHAR:
>  		r = 1;
>  		break;
>  #ifdef CONFIG_KVM_XIVE
>
> base-commit: 6d61a53dd6f55405ebcaea6ee38d1ab5a8856c2c
> -- 
> 2.48.1

