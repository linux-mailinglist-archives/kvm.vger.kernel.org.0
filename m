Return-Path: <kvm+bounces-42831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B31A7D97D
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 11:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 364077A3EB6
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC50227E9E;
	Mon,  7 Apr 2025 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OjyBY2B/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFB022A1E5
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 09:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744017755; cv=none; b=mCwOm8N7vmgt1LAG8XJd9WyMTOdK5i0sIil25N7mLNDV32Hg9+xAe+PwdhgpkUxLL3oBcvHU/PKMT2jmYqC20t+CEuk7xmd5/lfSIu3Jp86+vBoZacnYMp3dbNfHLLieiFK3N+iNdcWip1l4ftn80lBON2AetsihfKF1U0s2kTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744017755; c=relaxed/simple;
	bh=VqyGAa/Wnple9ormWUNewXd2QL7o32mB++LF6Ev1Zls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BvBtaXEu9CHrDe9JcbvCFFah/f/eF7rHWVVEpEAB6Mze0dRhP86DKyQCVrSkpt+gbjSMSzYDoNibn1Ei3CXAoJHUPOTVu/A91YsvAS6B0fxIazY44yfJ3mL044DJgqyE2j3s0r8YltEZvbbDLJTMyzK/xr6nL9frCFvcuoZ8gx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OjyBY2B/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744017752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/yCYFM5XQ5OKPftJDCwWOuxcCEJiJqE9Gf8hXOCSC2Y=;
	b=OjyBY2B/7k75ML5Hwnx8xnUnJNbKCF2Dxu/0l6lQp/CMyVzmzZW3msNAxz0YUNKDSUiZv5
	i6EirqpF1CgMLHEfKPTMalB25lhj+3GaKi3XFlLgAz+33/5yDayBggvCq7BPJHEB55NZjp
	l5+jSXiz73k8fGRXekLdGEZd/i01bXY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-ZwJLYhFwM8SsqWf6PkVT5g-1; Mon, 07 Apr 2025 05:22:30 -0400
X-MC-Unique: ZwJLYhFwM8SsqWf6PkVT5g-1
X-Mimecast-MFC-AGG-ID: ZwJLYhFwM8SsqWf6PkVT5g_1744017750
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3912fe32a30so1636608f8f.1
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 02:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744017750; x=1744622550;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/yCYFM5XQ5OKPftJDCwWOuxcCEJiJqE9Gf8hXOCSC2Y=;
        b=n8RW1BwaLBRWGav62NV9fGWpsLceRmZY80dXs5nZ9T2WkizkcK/uBB8UsA1o6PHe8+
         iHugNOi26l3RAFZgaTEwo/gIf6OrXECvaFhjzLTpGiTBeekKck/kNIZ/o/lNqjiJwObj
         kwk6PXdM4IpxZsmcXYfukkN2luu0WAOvPLUNnrmfv++YqdaXe9FbDiT2tOuon45VPbEC
         ex8SyqTUnAL1FUvcDmOVJreU09FEmRg2nfY1WC5QmSFxM2q/C2lWYwqRFmtYQT8LyllM
         ICptzgSYdyJCEAkYud14MAAm60j8CoF8j5RkBggtAyy6pf+YxToMMdLXRbT9aeVr3aH0
         0+0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVmnlpclVr9iVJs7LLc0wzr9P48KLg4O8uWK2fDMiMN9vHq1IDw+A6n0S8Z42ob2542ERo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxykdM3KVJ8QWMsPARQqdaMp4po77vKF3OZV6/f7qV/W3eBryKi
	O8YTMrMtlyfFUCO4SWSvNVCqm6njgjGw8ujbJG+RswsMuuBPMfYcFGLhq9g3/1YB3L9lKp4vF08
	6YtMCPE73vt4Yb4fue/J6uS8uEgDw5kgjdYNJ/+DkCfDYiVGRhQ==
X-Gm-Gg: ASbGncsY3Bi3KTVOHHHwqxS8tYo0NTSTVAsr7pWifvn7iJKDLrHZh1nDoVg/CXdCfOl
	9uSUC3hWUiwvR66fZpM7wVjs1xqDW2uU0Y0xWXBzKh5PQhRZk88vEQh0TjxgpP572YnSMvrqgGF
	jjh+oqCMLoEFn2kpAapLNqqwoBz1B07pS96mbJs/7ugCaT8tKjXmkU78mhossqMMU3UY2aBoOeD
	RewhsFXLJT5pp+PteXCNno6cjNMtUnSix0sN83gAp8JkpalQQ1aVjWaW46y7Kqx1VbSeZQjAA90
	Q1qiIJYUaXf42h/MyVB7A1ZpuNtqQTaGpopgYLqkXA7h9CTFtFFgXrEgh77hBfMJt9Kuz/2BYvw
	xmv/m6wW4MjmdtlpsCbVd/klXJ7npBzriEEK5gIrapiM=
X-Received: by 2002:a05:6000:1842:b0:390:d796:b946 with SMTP id ffacd0b85a97d-39cba975b7amr10984339f8f.44.1744017749699;
        Mon, 07 Apr 2025 02:22:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpnuVhkewnRTqYTGM8Rx3shfIX+fz32ljJ3fzJujcF/CDjD46/a7MbDgl6ZMvURv3xWypjfg==
X-Received: by 2002:a05:6000:1842:b0:390:d796:b946 with SMTP id ffacd0b85a97d-39cba975b7amr10984301f8f.44.1744017749294;
        Mon, 07 Apr 2025 02:22:29 -0700 (PDT)
Received: from ?IPV6:2003:cb:c738:3c00:8b01:4fd9:b833:e1e9? (p200300cbc7383c008b014fd9b833e1e9.dip0.t-ipconnect.de. [2003:cb:c738:3c00:8b01:4fd9:b833:e1e9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b816csm11532758f8f.57.2025.04.07.02.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 02:22:28 -0700 (PDT)
Message-ID: <d5080785-b197-4444-b9c1-25838cd9496a@redhat.com>
Date: Mon, 7 Apr 2025 11:22:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
 Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Wei Wang <wei.w.wang@intel.com>
References: <4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
 <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
 <20250404153620.04d2df05.pasic@linux.ibm.com>
 <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
 <39a67ca9-966b-40c1-b080-95d8e2cde376@redhat.com>
 <20250407044246-mutt-send-email-mst@kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250407044246-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.04.25 10:44, Michael S. Tsirkin wrote:
> Wow great job digging through all these hypervisors!

There is more ... :(

aloith: 
https://github.com/google/alioth/blob/main/alioth/src/virtio/dev/balloon.rs

It uses the incremental vq index assignment like QEMU.

impl VirtioMio for Balloon {
     fn activate<'a, 'm, Q: VirtQueue<'m>, S: IrqSender>(
         &mut self,
         feature: u64,
         _active_mio: &mut ActiveMio<'a, 'm, Q, S>,
     ) -> Result<()> {
         let feature = BalloonFeature::from_bits_retain(feature);
         self.queues[0] = BalloonQueue::Inflate;
         self.queues[1] = BalloonQueue::Deflate;
         let mut index = 2;
         if feature.contains(BalloonFeature::STATS_VQ) {
             self.queues[index] = BalloonQueue::Stats;
             index += 1;
         }
         if feature.contains(BalloonFeature::FREE_PAGE_HINT) {
             self.queues[index] = BalloonQueue::FreePage;
             index += 1;
         }
         if feature.contains(BalloonFeature::PAGE_REPORTING) {
             self.queues[index] = BalloonQueue::Reporting;
         }
         Ok(())
     }


I'll dig some more, but this is getting out of hand :D

-- 
Cheers,

David / dhildenb


