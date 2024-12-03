Return-Path: <kvm+bounces-32934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC209E2130
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 16:08:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15254286320
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 15:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959321F75BD;
	Tue,  3 Dec 2024 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KlFz6KbN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5073E1F75A6
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238475; cv=none; b=dmadrCMvVkOIpTp6HgSVnk/VYtpctYKMBGRWyfcfMTvvkHrNsjARQu+A2Ouo/iuWs6ELGTvsdC3uKfS/lKNZwoR2WjXtKNraa8pqPNSCHIilnpjjOKDAwU/Rcwj/g4GkiZP5IpF7QqH3wo4KtpXUIRbSen79pe0Zhf+1A32fryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238475; c=relaxed/simple;
	bh=dVgKSkGnZXZhsq1kQNLJnniFbw3xKNx16SzezHEG9CQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MdSZj3AYwrqTAFuitE83ZMd6EFMby08EZ5mRRUdRGBpwxzBUpLhtbzcd3jc7DohvP2SROKgIIoQ4qhbNK7jxu7JUHVio0P2+p8o9eIz3om2te5g+NqzqXlt5+iCzBIb06DDTgsSeOhjqXhqHiW8YQQoDgVqpkEtzKsH+6Cuzljo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KlFz6KbN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733238469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hNslBpXHlM7U1V+HxZpEwfEmxtrjgHkdVPnxHVlsPRQ=;
	b=KlFz6KbN7hy03ib06KF0kFKzJOjx4ImTCzqKoL8kZkpSmkSXVUgDhbjiTbCjzooTKqbYNe
	fU/X5/fLBHtg7B7XQ8aGJHHsolX4o1PX6tAn/M3d0b3F2fo8nmnwdgFNp5GtFToatiIRtz
	tX2M1HTSKFtYahEtippNLXqlqmkFakw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-EBYsNGKzNz-T_y4yLdHtdg-1; Tue, 03 Dec 2024 10:07:47 -0500
X-MC-Unique: EBYsNGKzNz-T_y4yLdHtdg-1
X-Mimecast-MFC-AGG-ID: EBYsNGKzNz-T_y4yLdHtdg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-434a73651e2so37092965e9.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 07:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733238466; x=1733843266;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNslBpXHlM7U1V+HxZpEwfEmxtrjgHkdVPnxHVlsPRQ=;
        b=f+yLwWWeNAhi7V+Ijfe8CXabmGzQgo34Jebun+Gh+lrebwENVTZQLJVB9KleOTsQ+t
         +Nl1e2UmvINoe7zioNQatAK/UjPHyI7tyMaplQkYUINqcTTW54F4mVoeK+xI76hJYTSe
         36EEHv9FoUVkiF4qPu/QfNPSwvI5vAJs+KMD8Bw/7gT51M9XpCtPrgy0s/lk2wjD0h7i
         UTWRZ2xGc0VTyInI4c7wbiLdGtxL+m8YqBmmiCT/D3qvkqR6p6x18YWBaFMn0W1Kva0s
         JLlnNVet1UWJSJUItk+h73aTIWBeRIH5RAPsfYQ2nMwnoQr9yo0RUg9T0GTgo1HpQzGv
         FlRw==
X-Gm-Message-State: AOJu0Yy6s762IicT6C0jcfzltI7xArlUyvh1sO2L6bnEMSjmFlWSuhLL
	Plm0Et6UWUt26zC1QCfJAjI+kBlMm4PJvijTg6T+wU8++mZLXAU6F0mKAwmhjrvmQfTlSCQPLNr
	BqwWMAdBa4WgzYsAiRK1z301XRGDxFP9Mpp2+CwgE1l0aAaab4g==
X-Gm-Gg: ASbGnctrEakp+LVoKrOnAhMUZBkMfszhhjzf16mSdyfd7x2aItPl+u+izhzhwoAC58n
	hPni92BAexHn16QVomVSLlkbtENAGCLTlJxLDMkIxHRq6scJwg4g8lR6Q0mZzgxeQLD49X60BOq
	LwwoR1+wDvK4TyF++9Mq2pNOQleDkN38VzaunPmyEp1WCFhbxOngPWoJ0DhAAAlSCJ9zwEuomkp
	W7ab5awQobRvEWmgscpVRpj7DKce72FQtHP0xZ8Ole4P+mwD1WcXR/kuvdOHAJHBfEYRqJrhq6+
	aZkHPhKvEEtB
X-Received: by 2002:a5d:64c2:0:b0:385:f9db:3c58 with SMTP id ffacd0b85a97d-385fd532aa5mr2468220f8f.49.1733238464741;
        Tue, 03 Dec 2024 07:07:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbNdvzdz18eI6yDOtajAvf4AgQhJeHzryoJM5oP+G07WIkdGvshuTLhEDrfpX9ke+32LOl9w==
X-Received: by 2002:a5d:64c2:0:b0:385:f9db:3c58 with SMTP id ffacd0b85a97d-385fd532aa5mr2468181f8f.49.1733238464301;
        Tue, 03 Dec 2024 07:07:44 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0f32837sm196881385e9.33.2024.12.03.07.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 07:07:43 -0800 (PST)
Message-ID: <c69d6fc7-ab18-48f5-9e23-e0f947f8840e@redhat.com>
Date: Tue, 3 Dec 2024 16:07:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/mlx5: Align the page tracking max message size with
 the device capability
To: Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
 jgg@nvidia.com
Cc: kvm@vger.kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
 maorg@nvidia.com, galshalom@nvidia.com
References: <20241125113249.155127-1-yishaih@nvidia.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20241125113249.155127-1-yishaih@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Yishai,

On 11/25/24 12:32, Yishai Hadas wrote:
> Align the page tracking maximum message size with the device's
> capability instead of relying on PAGE_SIZE.
> 
> This adjustment resolves a mismatch on systems where PAGE_SIZE is 64K,
> but the firmware only supports a maximum message size of 4K.
> 
> Now that we rely on the device's capability for max_message_size, we
> must account for potential future increases in its value.
> 
> Key considerations include:
> - Supporting message sizes that exceed a single system page (e.g., an 8K
>    message on a 4K system).
> - Ensuring the RQ size is adjusted to accommodate at least 4
>    WQEs/messages, in line with the device specification.

Perhaps theses changes deserve two separate patches ?

> 
> The above has been addressed as part of the patch.
> 
> Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty tracking")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>   drivers/vfio/pci/mlx5/cmd.c | 47 +++++++++++++++++++++++++++----------
>   1 file changed, 35 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 7527e277c898..a61d303d9b6a 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -1517,7 +1517,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
>   	struct mlx5_vhca_qp *host_qp;
>   	struct mlx5_vhca_qp *fw_qp;
>   	struct mlx5_core_dev *mdev;
> -	u32 max_msg_size = PAGE_SIZE;
> +	u32 log_max_msg_size;
> +	u32 max_msg_size;
>   	u64 rq_size = SZ_2M;
>   	u32 max_recv_wr;
>   	int err;
> @@ -1534,6 +1535,12 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
>   	}
>   
>   	mdev = mvdev->mdev;
> +	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
> +	max_msg_size = (1ULL << log_max_msg_size);
> +	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
> +	if (rq_size < 4 * max_msg_size)
> +		rq_size = 4 * max_msg_size;
> +
>   	memset(tracker, 0, sizeof(*tracker));
>   	tracker->uar = mlx5_get_uars_page(mdev);
>   	if (IS_ERR(tracker->uar)) {
> @@ -1623,25 +1630,41 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
>   {
>   	u32 entry_size = MLX5_ST_SZ_BYTES(page_track_report_entry);
>   	u32 nent = size / entry_size;
> +	u32 nent_in_page;
> +	u32 nent_to_set;
>   	struct page *page;
> +	void *page_start;

A variable name of 'kaddr' would reflect better that this is a mapping.

> +	u32 page_offset;
> +	u32 page_index;
> +	u32 buf_offset;

I would move these declarations below under the 'do {} while' loop
A part from that, it looks good.

I haven't seen any issues on x86 and I have asked QE to test with
a 64k kernel on ARM

Thanks,
C.


>   	u64 addr;
>   	u64 *buf;
>   	int i;
>   
> -	if (WARN_ON(index >= qp->recv_buf.npages ||
> +	buf_offset = index * qp->max_msg_size;
> +	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
>   		    (nent > qp->max_msg_size / entry_size)))
>   		return;
>   
> -	page = qp->recv_buf.page_list[index];
> -	buf = kmap_local_page(page);
> -	for (i = 0; i < nent; i++) {
> -		addr = MLX5_GET(page_track_report_entry, buf + i,
> -				dirty_address_low);
> -		addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
> -				      dirty_address_high) << 32;
> -		iova_bitmap_set(dirty, addr, qp->tracked_page_size);
> -	}
> -	kunmap_local(buf);
> +	do {
> +		page_index = buf_offset / PAGE_SIZE;
> +		page_offset = buf_offset % PAGE_SIZE;
> +		nent_in_page = (PAGE_SIZE - page_offset) / entry_size;
> +		page = qp->recv_buf.page_list[page_index];
> +		page_start = kmap_local_page(page);
> +		buf = page_start + page_offset;
> +		nent_to_set = min(nent, nent_in_page);
> +		for (i = 0; i < nent_to_set; i++) {
> +			addr = MLX5_GET(page_track_report_entry, buf + i,
> +					dirty_address_low);
> +			addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
> +					      dirty_address_high) << 32;
> +			iova_bitmap_set(dirty, addr, qp->tracked_page_size);
> +		}
> +		kunmap_local(page_start);
> +		buf_offset += (nent_to_set * entry_size);
> +		nent -= nent_to_set;
> +	} while (nent);
>   }
>   
>   static void


