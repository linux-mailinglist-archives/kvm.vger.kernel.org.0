Return-Path: <kvm+bounces-64490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AAEAC849EE
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 12:04:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59EB83AC243
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A63F315D3C;
	Tue, 25 Nov 2025 11:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GlfFe7j5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JnNmbrh9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7351C314B9D
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 11:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764068644; cv=none; b=KbWiB4PIOoopvfN+fZhpN/elhT3sUqFns3Aj/qnT9erNFPmAR8QFt9XNWi8VEw2SoNsbbQPjBE3UXohAs2k8+Ozi8Jc5eb2kJ7S9tFDa4SRGUbVKsaReVtbqhBSsJUo53KFQdZ8IZ08DbnQIhYeP46LMssK7xZm99UCax0QVrKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764068644; c=relaxed/simple;
	bh=iXKpiuNQlb6X68ZweO+BOUjOZ+bKXmHmii0jmBG3APg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Orhyewt6BIBTD94tBQMjBll/KV0RPJT+Mo6yp6cIuv7u6Hzt7n8svM+3Q1/JsoydmzUqDnRvKRG/mO3DCkz9TKw+XR+W5slcSuLmQ6zE2wRMrfGqXsMRf2qOE5Adu/adCwMRj7w+dieNrpS/hSwJizUQyjfowJxQk8jAnfjBawY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GlfFe7j5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JnNmbrh9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764068641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2jX8nyV/wRTc5eESPtXjGF1WJi21h6fkrbY07+2SJ7E=;
	b=GlfFe7j5djGvVcy5VW0Sui70GxQPjxkbErEyTM+pumYgABPILRXlWSeBeoHN2gJKQGAa+C
	4vwIBqPBMo2s8VRLvCrqeTx4z1Lkc7U8pjvqvXTOSXdgylAuuRRKyEmdp2hsQIDIudkel/
	CtKD5XVscwEXji6USgdHSaeDS1ebf4c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-QQuhdzWVPo2UMDfy1WXz0g-1; Tue, 25 Nov 2025 06:04:00 -0500
X-MC-Unique: QQuhdzWVPo2UMDfy1WXz0g-1
X-Mimecast-MFC-AGG-ID: QQuhdzWVPo2UMDfy1WXz0g_1764068639
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b2ffbba05so2678670f8f.0
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 03:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764068639; x=1764673439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2jX8nyV/wRTc5eESPtXjGF1WJi21h6fkrbY07+2SJ7E=;
        b=JnNmbrh93ftx8BdFQsVOSeTNa3xDgm4vsIofeBTmYMVNOko/s/WTU8FsMaI9+K9sl5
         jYrmttgbG/dyUBGsAMOL1h43rWiBQ6DXytgaKs/dbf82kNClvGSWO8LHfZKMoWjlT3xv
         peBf+2K670Uw6eJLX6uw8rnHxF8k6v+TAs1VJrqJ+JX6+4Vtysv8Ex/fM59ceg2Q1Mga
         cnENbzexJP1n4DGSOWEJyjLycj4PJg6YT7Qsn0Hr7M1c/OZbfscCeeU2V2XF3ALyfiZn
         KNhqaxMaOxYORsGr1yV6YcMPzW9jf9TVIohkllshsm8Rnuhl18oR/PTVUi/xW66uPtAc
         EebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764068639; x=1764673439;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2jX8nyV/wRTc5eESPtXjGF1WJi21h6fkrbY07+2SJ7E=;
        b=Y6vhbeYqw0AdzfMzREnoJAiySBfBTtdDeR6sHI3j4sDNpjEYf9n9fp9I/Et692PsI2
         OHFxkbDcF230cd4qxokURayy5YJRG68utFXaVtX/UH3KCCszFr/kyzN9f5VZEDzBrvvJ
         ch79De9Kn0F2qvQBX9FSkMIgd5NIKK2fgpYSfbIy98Pxq499TLi0nfbelBKwIYcfSqin
         Y5acvKqa3XF8Vsyw34k7z01Fv7Hgy8xz26ocuYcyEotMjq7uxvguuXFbm/buLKZ7Baro
         qDX7zvVF4K4rehglLNeP+xDAf1dNc5rHZheUuqB6/Eq1dA+FB4kXxKMzUxTudwEyIw2l
         7SZQ==
X-Gm-Message-State: AOJu0YzS8GpLoU5qH4bGP/geKw3FP7WKlSx0TIBEsI3/n2lYx7XyH6Lg
	3uc4homPjuCK8j2j8IBaDFh9+yX3wOK7Z2hoTHGrmFNkxDMt3fh9AIjjTF+jTlnWjT4K13VAB/t
	EVJwS1ialU0mxYRG9XLaycGzXnEgwTSPNVIIxYbJbPFydyOBtWvrObA==
X-Gm-Gg: ASbGncueKTQjD08NCC08J5roDbsH+w0DgfgEY50WM/VLINRpSV+eLYq+ueD83sY3OH/
	6XYsAEn3NVcq4HinddiNRme5NXW1gP+TWjSLRw6bB38oNeq5ioc38Ctc5tiJqTGdW1iKM0y9f1T
	WLYPebueMTmV42/7BmuYOoay5A+xiwJYbneK9V73pYOX5jxxcms04SPUygQxFQRKB1wTKY5epaH
	YOrrr/lGJBXUgcnEqAfSS07gECNswDtgTmSJsdSZCK4o+KLUpkZF314VQTvT0purG+2DxF69cVa
	+AMggZLKXYPJipSO2HLAfhpGkaAL2F4BKelRYrAPw0DrZwfrMABtQYUadqALGRu5wkeXL0LKh6y
	6Y2a+gOZWi3Ckig==
X-Received: by 2002:a05:600c:1547:b0:46f:d682:3c3d with SMTP id 5b1f17b1804b1-47904adff1cmr19046355e9.13.1764068638808;
        Tue, 25 Nov 2025 03:03:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFoT6Pfw7CHSt37IswgwvDmurDiD6Zw/XOCayfoPPARGoD0QI10X//Yl97sd3GIIuQ+9cHtCg==
X-Received: by 2002:a05:600c:1547:b0:46f:d682:3c3d with SMTP id 5b1f17b1804b1-47904adff1cmr19046025e9.13.1764068638268;
        Tue, 25 Nov 2025 03:03:58 -0800 (PST)
Received: from [192.168.88.32] ([212.105.153.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf22ea00sm246531145e9.14.2025.11.25.03.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 03:03:55 -0800 (PST)
Message-ID: <323a8b07-6df3-4cc4-960a-994649fb03e3@redhat.com>
Date: Tue, 25 Nov 2025 12:03:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_net: enhance wake/stop tx queue statistics
 accounting
To: liming.wu@jaguarmicro.com, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org, angus.chen@jaguarmicro.com
References: <20251120015320.1418-1-liming.wu@jaguarmicro.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20251120015320.1418-1-liming.wu@jaguarmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/25 2:53 AM, liming.wu@jaguarmicro.com wrote:
> @@ -3521,6 +3526,9 @@ static void virtnet_tx_pause(struct virtnet_info *vi, struct send_queue *sq)
>  
>  	/* Prevent the upper layer from trying to send packets. */
>  	netif_stop_subqueue(vi->dev, qindex);
> +	u64_stats_update_begin(&sq->stats.syncp);
> +	u64_stats_inc(&sq->stats.stop);
> +	u64_stats_update_end(&sq->stats.syncp);

Minor non blocking nit: possibly use an helper even for this increment.

@Michael, Jason, Xuan, Eugenio: looks good?

Thanks,

Paolo


