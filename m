Return-Path: <kvm+bounces-55923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F74B389E6
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 20:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A59481B6582A
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4662F2E7BDA;
	Wed, 27 Aug 2025 18:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="io5iLWOa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA4C2E62C0
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 18:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756320922; cv=none; b=u1jTwHbUtlb0WnxH7Cw87h8LvrBbuuCzg5JfJ7icRA/8S+RN7akJsIR40cK1TEAwFYxiezQqI4K4og/kVbS4ag6oq6h/ovK9wcXA2DP0HwLpteXLFhcGjF+uwXAJ8B33Xzo1clgpGEuLbbsL36cj0b/FIdkmPcoKtIu1rZlX2Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756320922; c=relaxed/simple;
	bh=fG2lAgkNwX5fAWKDfLrJ3TcVo72HVbsVBL+3zr4ipWU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lY4Qr3FA2svLAYlMlf/znaM1H9XRxZnr2BjN+QeJv0LT5KQg3LcKSKfiLBNhgQ8znvwMu2/HqVve/eoF53InNTd05WF0uJ3B8tBf3QDge/kujAu9mMySytZr9zqcha5gDRDLHV7iOXixNpAbL8DzV3huh2icU4Wj9JPtgQ70Jrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=io5iLWOa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756320920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6gvdhbCmBfEcFFZYSrlsrqioBPJc+RVSg8MeTRDQPEM=;
	b=io5iLWOaqHcop8IxUTHka9qpFvCOGGxqPF5G1NFdXzR4E2zEHentZMC1Cwtrh8qU0MPdmp
	C3ru1GtQ8Z2/BtMMHJwnvqE9SR3bC5KtFIzYUhSlz7cXA8amf74P17Bhoalpsr7/uBVJXU
	70YhpTfFr9b3lPp9pvFw8aET7xW9sLI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-GYssrIQuNIuV2ahfmIFKbQ-1; Wed, 27 Aug 2025 14:55:18 -0400
X-MC-Unique: GYssrIQuNIuV2ahfmIFKbQ-1
X-Mimecast-MFC-AGG-ID: GYssrIQuNIuV2ahfmIFKbQ_1756320917
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e67d83ee31so199985ab.2
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 11:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756320917; x=1756925717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6gvdhbCmBfEcFFZYSrlsrqioBPJc+RVSg8MeTRDQPEM=;
        b=bRopPqsWn/1RY7o9+2ZXYtXLSERdpaUyd0iqpSk7Zq/xk+pBqxqzmcpUEgMd/o4Xbe
         jNCPGzK0XSuti6HnQgk+NHDMzwtPkL11yyUahwEK60Y06F2DnwrZVRKvGJq3DIw2eAZk
         kbMSvttTphhlKA5qODyQgAmGw+zuiQHwHp/sDp+6ENoK/yTsaNSQ2h/PbzsAvu0A50IW
         33X482RX9RXAVdEqhMQ6sC/x9Hh/IpBwT2gLJfGefkwvPjDv3dbXH9v8P0S0AVy0IeWb
         E8Pwqjmtv7bGEJuJF1BSd235hH5EYR2VWmxeG+uAWbue/Ibcz8ESnxSHH5M/ulBvFI/+
         U56Q==
X-Forwarded-Encrypted: i=1; AJvYcCWSnkJdrbmPKa6uGvu1PtqyXAk1KaNzOR4whF+VkAZLwvz7I1muzDNnCKfROR4+ryLqwlE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz80u7CecMW0tBS5o7Rnpem2Jh1eSQXORH0RgiVAI/h7Fi/IMPQ
	7tW67Hal1YpM52mZWoCup/xk27KQjkBy5kPUn03Xa26UoOa107nXAoJLsMhE+kYA4fNvcPyt9tn
	4oGmpapAgw5atVHkqMiVPJQgQkW8JpXCFwZvwy5cTSYoq9RtD+pY0W6N0ggxwJQ==
X-Gm-Gg: ASbGncs0p1pTrOO90Ul8uyo+usC5zAiGgvfrxz3XNgkUM42UEAeZLrVO1Etl8/mCfci
	PRezqnuMHQY9nuB8GdHbjXU67IavV9PjMX4St2BIvl0q005XlYFQcIHV0PPs14JTzKILhtxQZo6
	EaRfXmsCh0vzYLaEse3ol2/zRruRSYR1ena0BJ4RqwRV/RwUJT/cNkeFeclxzqzVOyLflhdN+yP
	vsFLZEa72ppSf70n2AOQcnZOuufYgggb4hxGtcWTd3gokmxQC0t1ZPlccRKffmgG5Yn+J1yU84i
	NtW/TUJOFNMipf5Cg0tPClM3mqU39mxyRWuLomUGQGA=
X-Received: by 2002:a05:6e02:19ca:b0:3e5:2df0:4b88 with SMTP id e9e14a558f8ab-3e91fc2327emr105607995ab.2.1756320916826;
        Wed, 27 Aug 2025 11:55:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETOWYFV13Jgn0+Ln161aamHU5qaP1seKxDyxTdLgbmk74WU/ef1o5BKDWfSPh4Aa6LOXeB4A==
X-Received: by 2002:a05:6e02:19ca:b0:3e5:2df0:4b88 with SMTP id e9e14a558f8ab-3e91fc2327emr105607875ab.2.1756320916375;
        Wed, 27 Aug 2025 11:55:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4c759f6fsm90258575ab.20.2025.08.27.11.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:55:15 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:55:13 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Morduan Zang <zhangdandan@uniontech.com>
Cc: ankita@nvidia.com, jgg@ziepe.ca, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 wangyuli@uniontech.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/nvgrace-gpu: fix grammatical error
Message-ID: <20250827125513.715e7c81.alex.williamson@redhat.com>
In-Reply-To: <54E1ED6C5A2682C8+20250814110358.285412-1-zhangdandan@uniontech.com>
References: <54E1ED6C5A2682C8+20250814110358.285412-1-zhangdandan@uniontech.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 Aug 2025 19:03:58 +0800
Morduan Zang <zhangdandan@uniontech.com> wrote:

> The word "as" in the comment should be replaced with "is",
> and there is an extra space in the comment.
> 
> Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index d95761dcdd58..0adaa6150252 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -260,7 +260,7 @@ nvgrace_gpu_ioctl_get_region_info(struct vfio_device *core_vdev,
>  	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>  	/*
>  	 * The region memory size may not be power-of-2 aligned.
> -	 * Given that the memory  as a BAR and may not be
> +	 * Given that the memory is a BAR and may not be
>  	 * aligned, roundup to the next power-of-2.
>  	 */
>  	info.size = memregion->bar_size;

Applied to vfio next branch for v6.18.  Thanks,

Alex


