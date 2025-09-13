Return-Path: <kvm+bounces-57493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D2BB55F31
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 10:03:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65F741C247DF
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 08:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4FCA2E7BAC;
	Sat, 13 Sep 2025 08:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XJGRCbCu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A4A192D8A
	for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 08:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757750607; cv=none; b=imDijrZoVQVbJDAAiPArsrA5QgEd/i10fZkmgIWzYGFxMR5Qpq4V8iWNLXqJ9k4NJKAjMS8kp12blDY45jeGvYvE8RuzrXFCVXWICDFeYn1mMd0hm/JNMh3pua6Czzb8yvdnlsjYSdXP3YKobloCo7Y0Y1VibDPxyOSInZHNgZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757750607; c=relaxed/simple;
	bh=mH86EQWr6AGu2mollVX1DlBSZOBPxxseBdTdR5DelVA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfzO8ggNzfmqG0mmMyFCTpffi9LKAV7rqn98S+SkxjNrvcmDyz2j516DNYrFHq0X6dzCdoSxv+Jxk7dDUJCuWKCm1kXM7eLxY0czxgOFs0KkkiDtFLhgwI7WrmZvjS2gy6vV8/yynBOTkXIbrLm6K99lpI/P+WYKHyOoyPW2Rvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XJGRCbCu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757750604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sfGAXjEAE5IQc4g/CxBE4ZUWAqqWb1+3938rC7tk+70=;
	b=XJGRCbCuUd+moOeteru5MqTEQkfGt+6J50h5zSEnC8Xj/dp+jud2Ha+IEECbxGlEdHGBCq
	8YtIzU3xe0z3pC59pTX9UtKoh7XZQRKw4oWy9QZYHuQ5Kacw1IVu9Q4uFY1EIQD6L7rBQu
	sXmbpawswtGUDKjSqWaPl0/sLy6n2Kg=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-nCgPdKvtObC1nw-nPhN5mQ-1; Sat, 13 Sep 2025 04:03:22 -0400
X-MC-Unique: nCgPdKvtObC1nw-nPhN5mQ-1
X-Mimecast-MFC-AGG-ID: nCgPdKvtObC1nw-nPhN5mQ_1757750602
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-423f8f599c2so682105ab.3
        for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 01:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757750602; x=1758355402;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sfGAXjEAE5IQc4g/CxBE4ZUWAqqWb1+3938rC7tk+70=;
        b=Q9FR0DOV2fyLc5fUtxcQZOPxoILaD3cnS20dSKyAvsFLqTJ7RFOCLb5qWPwKJc4by9
         swnxRI/3MbhHiRjQujpPdvZfvdfdhZ6vmAb6ajN2h0IrzaB/xA+Kc5Lqmd7TMep5sesb
         Lr/XOA3ek7AulcFyaOMbj9FMzAaqzzaNhkeEGsQMKkOW8wlcaJ0IboT79UGZojMKDgY3
         iQnY1q3XpWmmfWyGl960aXVFIuVo2SX5Fhjtk7dI9jy7hGS8b2szHzGbjPQH1+hW/0PW
         oXTiDeaRteabOwWCP3Ljc8MttoA8vvqsVdhvwyIGTZFNYq+1smRbrwLNGXM2sH+XJezN
         l6Hw==
X-Forwarded-Encrypted: i=1; AJvYcCXoi90YMYL5zMLaW5IFjypI/B7fclnndut3KALdMB7LEwOsnssJJvcN/mwebqICFrPUFGM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrgM0E0C8Vlb9aVECIsMyy3DbrFyG8q7rCr0j8JB1LooUqvNh4
	d80r3fRtMdpyEaLlJuAT7Su/ajW8Cqu9GyQvwMsMjlFSCa7017cpTrT83W7RzXGFU5sZnDJFovD
	l6pXPb9YfXRKKeTOV/ujfemNe6uyfADbaVSbQVhkhqETLlcYvgehHGQ==
X-Gm-Gg: ASbGncvcPk77uX5WykoKFSG2Xkn1Dd0dtSlAI4Nvtv52eQ37MJR8mTLUXDpJA4gZvhF
	NutrH2yLDS2Rk/cq7xYEjJUq9QaWX8IeWEq+fJ2dxuXlX+5fkwOp1nfFGcpFJgWckJPFmKjCbA0
	o0bKFIBDQd5odo7Tlg4ApePOj3Tk7w3LIefh359F4FbdDKw8cL2rOSthqHjYOgMp9L6R8Fvv6VB
	7wB0R0mibGy3a7KCpstuD537l9LaUWfCMFBPaVtGlFZqFxnO8AOAFRF9P0dGIvToVBfYr7QZ3d6
	HCiiUMVCYqoAS+RGaqRA9Kgbr8aS6GgqR1NWN1KK3iA=
X-Received: by 2002:a05:6e02:378a:b0:40f:ee38:2cd3 with SMTP id e9e14a558f8ab-420a19141b8mr28592345ab.3.1757750601678;
        Sat, 13 Sep 2025 01:03:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGz7FR/9dKwPH5GyCTb8sfr8vUaJV1IXeXvvo4h/D6sbaJfzB+7D9+kkJ07988McEFbi6fQYg==
X-Received: by 2002:a05:6e02:378a:b0:40f:ee38:2cd3 with SMTP id e9e14a558f8ab-420a19141b8mr28592245ab.3.1757750601280;
        Sat, 13 Sep 2025 01:03:21 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-512174ef2f0sm144562173.51.2025.09.13.01.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 01:03:20 -0700 (PDT)
Date: Sat, 13 Sep 2025 09:02:50 +0100
From: Alex Williamson <alex.williamson@redhat.com>
To: Zilin Guan <zilin@seu.edu.cn>
Cc: brett.creeley@amd.com, jgg@ziepe.ca, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn
Subject: Re: [PATCH] vfio/pds: replace bitmap_free with vfree
Message-ID: <20250913090250.0cde9ca3.alex.williamson@redhat.com>
In-Reply-To: <20250912150418.129306-1-zilin@seu.edu.cn>
References: <20250912150418.129306-1-zilin@seu.edu.cn>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Sep 2025 15:04:18 +0000
Zilin Guan <zilin@seu.edu.cn> wrote:

> host_ack_bmp is allocated with vzalloc but is currently freed via
> bitmap_free (which ends up using kfree).  This is incorrect as
> allocation and deallocation functions should be paired.

This patch is fixing the freeing of host_seq_bmp, not host_ack_bmp.
Both are allocated with vzalloc().  The same logic applies but the
commit log is incorrect.
 
> Using mismatched alloc/free may lead to undefined behavior, memory leaks,
> or system instability.
> 
> This patch fixes the mismatch by freeing host_ack_bmp with vfree to
> match the vzalloc allocation.
> 

Fixes: f232836a9152 ("vfio/pds: Add support for dirty page tracking")

Thanks,
Alex

> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
>  drivers/vfio/pci/pds/dirty.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
> index c51f5e4c3dd6..481992142f79 100644
> --- a/drivers/vfio/pci/pds/dirty.c
> +++ b/drivers/vfio/pci/pds/dirty.c
> @@ -82,7 +82,7 @@ static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_region *region,
>  
>  	host_ack_bmp = vzalloc(bytes);
>  	if (!host_ack_bmp) {
> -		bitmap_free(host_seq_bmp);
> +		vfree(host_seq_bmp);
>  		return -ENOMEM;
>  	}
>  


