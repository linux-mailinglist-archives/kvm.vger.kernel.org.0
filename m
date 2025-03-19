Return-Path: <kvm+bounces-41474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C016A68443
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 05:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4605A7AC31A
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 04:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C606424EF62;
	Wed, 19 Mar 2025 04:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="PEpcmQa0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948B320E339
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 04:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742359413; cv=none; b=aPbDgJRrJ9FS+l9ctqBudGyIPHgiW6gDjzRabyoLf/LUD9kMpfH/wt8VeXLshA04kWHsslUdtuTX5ohYglxwWmIxDCJmmo7nLaHBfY/XPTqeR+hfHzTr+h/7J5s99PznoRhcRC0FByobJPxbNCYTKTeE+5QjmnMncr0f4CsDpPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742359413; c=relaxed/simple;
	bh=W+5qKF3qhFO7HJvSJ5JslHI2FLRSJJDlW9p1Dm6uP2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xz0sumt7EaOBiARlUB3pI2V+rVCvgxNcgQwpf+KlidGfvpqrdndg7xdWrMdDG7i/vpTmyP06uSiTBFMGuuXY4ccLCDjGCToXqOXnR+/trgFHEShc1uJe3dwcppGR+VCvXTHnO8+OyrfzgiHWHRrNIRPvCIokoG2ZX85dc1tW4DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=PEpcmQa0; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22423adf751so112931455ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 21:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742359410; x=1742964210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m0FuB7eLHOMhTWKUvOYkydvye4ZBgqM3uoOA9MgEAqE=;
        b=PEpcmQa0o8pJYa6VoqDXWGTxIY+sYI+AxwZEhDIjxPy15tkZl7SBlkBsYsPgF+GmT/
         eGjetU/i5qQdPbTVhgqrgJkGXmk0JHpba4QSiudPyUHQV+6yI06sy/24LIDHpdseanQT
         ruwhWg7McCt1a87KOrsWLKP4OKXb7gSP93/CwGqYeiltBaCr7N4z9Rbz9YM2D9T49dE7
         UfoHoFL2L/RBi9fgYTK0txgIhUe/kPuSmiW23elYZ2Ek10N7+W/4+gX5LyhJPX55IGHf
         1QcSabnQo3jO8H7viez2CFhFiZzz/1U7FOcX9LHniv1u0MIyZrqz1wldCokVnlB626Km
         9OJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742359410; x=1742964210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m0FuB7eLHOMhTWKUvOYkydvye4ZBgqM3uoOA9MgEAqE=;
        b=svfTNrzJdBRtFrvCjqZ5JLB/rXdBrZndytcJx3zfJn4DZBeJbF0L8EzSENo80AUi/K
         /zj32c41WWvAafxKY1oqSPtZCneHeGhxQ5lydkvBBU7eF5SvefH2RywOn/XfUxx1cI6K
         kZ5YlwPCAhcjsF+hyxL1ixPwjJg1y6J3dnW8av8yU8I6r7gBBJspo4hPuEv9kIQVohPh
         fKJny1SntpmKGcNl1CKhm3IlOmn9gEC2AcDz1lXZvsW9DPw9QFhlDRqttqtrsIze95Zv
         CW8IGYUm9GryZKeH0veb2VpSFJI8Dh7Ffm8FiAa6YzBEJrZiWIvWndEHu3yYX0BM0IWs
         N5lQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHpJtdzOmyRHDxeB/SBUnW6GS/OGRfBeZQF0g2I68lEBYfu3PZFgIpsTna2cV20GfDjjs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Xy4e3F6gbpXutkkynQkKvNpijAcInTdqLt1POnZg5sTmsCxS
	isK+X2zAE+GDkxENalSNGXEKaJMP1MJQp0T3tUm6/2GWKe06WZRSxTxcnjzXhZg=
X-Gm-Gg: ASbGncsgJVZjlhs2JPyuW4EX5w5pArYF6yyGz4sWfdp53i6p1/HUFuNvSqi5d3KM7FY
	pqK+Y1cikSwbWGP7xL8lAQ59NfddBDefUSqkhjeDyN/OgEhi/SRCXPySZXKBb9fqYFps0hBCqYB
	qmwo1x2SCAwejT2p4U5wgz/5boiZ+eZdXZC4TbQRRLKyilKzEu6mo2Ktd8Nf1ZxkXxMeFUTds7H
	cTu10DBd5p06QRBS8Nx5xw7wADJVtwtu1gLzyq4UQg7ufWHWSFKXX1DYjtLZJRWx8v41K4hMsS+
	dBGhjsus7nNSn1LBbq6sNylbtutFd9r3a/i0GFWF2JcscYCQQT3sz9dQxA==
X-Google-Smtp-Source: AGHT+IEHZ9Psi/SCzbOatJGEzjLCWs+vjmZWHBFS3Nhre3FUf18pjDyAewf6QgAsZyNqXQV5PhieHw==
X-Received: by 2002:a17:903:32cd:b0:221:7eae:163b with SMTP id d9443c01a7336-22649c9475cmr18050105ad.46.1742359409803;
        Tue, 18 Mar 2025 21:43:29 -0700 (PDT)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6ba70f3sm103992335ad.157.2025.03.18.21.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 21:43:28 -0700 (PDT)
Message-ID: <f714fc53-a9a0-4c4d-bd94-f895ddfc972c@daynix.com>
Date: Wed, 19 Mar 2025 13:43:22 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 6/6] vhost/net: Support
 VIRTIO_NET_F_HASH_REPORT
To: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>
References: <20250307-rss-v9-0-df76624025eb@daynix.com>
 <20250307-rss-v9-6-df76624025eb@daynix.com>
 <CACGkMEuccQ6ah-aZ3tcW1VRuetEoPA_NaLxLT+9fb0uAab8Agg@mail.gmail.com>
 <2e550452-a716-4c3f-9d5a-3882d2c9912a@daynix.com>
 <CACGkMEu9tynRgTh__3p_vSqOekSirbVgS90rd5dUiJru9oV1eg@mail.gmail.com>
 <1dd2417a-3246-44b0-b4ba-feadfd6f794e@daynix.com>
 <CACGkMEthfj0KJvOHhnc_ww7iqtmhHUy9f9EGOoR-n0OwHOBrvQ@mail.gmail.com>
 <77c21953-b850-4962-8673-6effb593d819@daynix.com>
 <CACGkMEtMghoZbMO8c+30vqtOr3daEYrU2gG-QAZjOJev8NnBhQ@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CACGkMEtMghoZbMO8c+30vqtOr3daEYrU2gG-QAZjOJev8NnBhQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/03/17 10:15, Jason Wang wrote:
> On Wed, Mar 12, 2025 at 1:59 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> On 2025/03/12 12:36, Jason Wang wrote:
>>> On Tue, Mar 11, 2025 at 2:24 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>
>>>> On 2025/03/11 9:42, Jason Wang wrote:
>>>>> On Mon, Mar 10, 2025 at 3:04 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>>>
>>>>>> On 2025/03/10 13:43, Jason Wang wrote:
>>>>>>> On Fri, Mar 7, 2025 at 7:02 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>>>>>
>>>>>>>> VIRTIO_NET_F_HASH_REPORT allows to report hash values calculated on the
>>>>>>>> host. When VHOST_NET_F_VIRTIO_NET_HDR is employed, it will report no
>>>>>>>> hash values (i.e., the hash_report member is always set to
>>>>>>>> VIRTIO_NET_HASH_REPORT_NONE). Otherwise, the values reported by the
>>>>>>>> underlying socket will be reported.
>>>>>>>>
>>>>>>>> VIRTIO_NET_F_HASH_REPORT requires VIRTIO_F_VERSION_1.
>>>>>>>>
>>>>>>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>>>>>>> Tested-by: Lei Yang <leiyang@redhat.com>
>>>>>>>> ---
>>>>>>>>      drivers/vhost/net.c | 49 +++++++++++++++++++++++++++++--------------------
>>>>>>>>      1 file changed, 29 insertions(+), 20 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>>>>>>>> index b9b9e9d40951856d881d77ac74331d914473cd56..16b241b44f89820a42c302f3586ea6bb5e0d4289 100644
>>>>>>>> --- a/drivers/vhost/net.c
>>>>>>>> +++ b/drivers/vhost/net.c
>>>>>>>> @@ -73,6 +73,7 @@ enum {
>>>>>>>>             VHOST_NET_FEATURES = VHOST_FEATURES |
>>>>>>>>                              (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
>>>>>>>>                              (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
>>>>>>>> +                        (1ULL << VIRTIO_NET_F_HASH_REPORT) |
>>>>>>>>                              (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>>>>>>>>                              (1ULL << VIRTIO_F_RING_RESET)
>>>>>>>>      };
>>>>>>>> @@ -1097,9 +1098,11 @@ static void handle_rx(struct vhost_net *net)
>>>>>>>>                     .msg_controllen = 0,
>>>>>>>>                     .msg_flags = MSG_DONTWAIT,
>>>>>>>>             };
>>>>>>>> -       struct virtio_net_hdr hdr = {
>>>>>>>> -               .flags = 0,
>>>>>>>> -               .gso_type = VIRTIO_NET_HDR_GSO_NONE
>>>>>>>> +       struct virtio_net_hdr_v1_hash hdr = {
>>>>>>>> +               .hdr = {
>>>>>>>> +                       .flags = 0,
>>>>>>>> +                       .gso_type = VIRTIO_NET_HDR_GSO_NONE
>>>>>>>> +               }
>>>>>>>>             };
>>>>>>>>             size_t total_len = 0;
>>>>>>>>             int err, mergeable;
>>>>>>>> @@ -1110,7 +1113,6 @@ static void handle_rx(struct vhost_net *net)
>>>>>>>>             bool set_num_buffers;
>>>>>>>>             struct socket *sock;
>>>>>>>>             struct iov_iter fixup;
>>>>>>>> -       __virtio16 num_buffers;
>>>>>>>>             int recv_pkts = 0;
>>>>>>>>
>>>>>>>>             mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
>>>>>>>> @@ -1191,30 +1193,30 @@ static void handle_rx(struct vhost_net *net)
>>>>>>>>                             vhost_discard_vq_desc(vq, headcount);
>>>>>>>>                             continue;
>>>>>>>>                     }
>>>>>>>> +               hdr.hdr.num_buffers = cpu_to_vhost16(vq, headcount);
>>>>>>>>                     /* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
>>>>>>>>                     if (unlikely(vhost_hlen)) {
>>>>>>>> -                       if (copy_to_iter(&hdr, sizeof(hdr),
>>>>>>>> -                                        &fixup) != sizeof(hdr)) {
>>>>>>>> +                       if (copy_to_iter(&hdr, vhost_hlen,
>>>>>>>> +                                        &fixup) != vhost_hlen) {
>>>>>>>>                                     vq_err(vq, "Unable to write vnet_hdr "
>>>>>>>>                                            "at addr %p\n", vq->iov->iov_base);
>>>>>>>>                                     goto out;
>>>>>>>
>>>>>>> Is this an "issue" specific to RSS/HASH? If it's not, we need a separate patch.
>>>>>>>
>>>>>>> Honestly, I'm not sure if it's too late to fix this.
>>>>>>
>>>>>> There is nothing wrong with the current implementation.
>>>>>
>>>>> Note that I meant the vhost_hlen part, and the current code is tricky.
>>>>>
>>>>> The comment said:
>>>>>
>>>>> """
>>>>> /* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
>>>>> """
>>>>>
>>>>> So it tries to only offer virtio_net_hdr even if vhost_hlen is the set
>>>>> to mrg_rxbuf len.
>>>>>
>>>>> And this patch changes this behaviour.
>>>>
>>>> mrg_rxbuf only adds the num_buffers field, which is always set for
>>>> mrg_rxbuf.
>>>>
>>>> The num_buffers was not set for VIRTIO_F_VERSION_1 in the past, but this
>>>> was also fixed with commit a3b9c053d82a ("vhost/net: Set num_buffers for
>>>> virtio 1.0")
>>>>
>>>> So there is no behavioral change for existing features with this patch.
>>>
>>> I meant this part.
>>>
>>>>>>> +                       if (copy_to_iter(&hdr, vhost_hlen,
>>>>>>> +                                        &fixup) != vhost_hlen) {
>>>
>>> We should copy only sizeof(hdr) instead of vhost_hlen.> > Anything I miss?
>>
>> sizeof(hdr) will be greater than vhost_hlen when neither
>> VIRTIO_NET_F_MRG_RXBUF or VIRTIO_F_VERSION_1 is negotiated.
> 
> Just to make sure we are on the same page I meant we should only
> advance sizeof(struct virtio_net_hdr) here to make sure we can set the
> num_buffers correctly.
> 
> But this is not what the code did here.

This code wrote num_buffers in hdr instead of setting it later.

However, with v10, I changed it again to fill the whole header with zero 
and to set num_buffers later. The end result is identical either way; 
num_buffers has the correct value and the other fields are filled with zero.

Regards,
Akihiko Odaki

> 
> Thanks
> 
>>
>> Regards,
>> Akihiko Odaki
>>
>>>
>>> Thanks
>>>
>>>>
>>>> Regards,
>>>> Akihiko Odaki
>>>>
>>>>>
>>>>> Thanks
>>>>>
>>>>>> The current
>>>>>> implementation fills the header with zero except num_buffers, which it
>>>>>> fills some real value. This functionality is working fine with
>>>>>> VIRTIO_NET_F_MRG_RXBUF and VIRTIO_F_VERSION_1, which change the header size.
>>>>>>
>>>>>> Now I'm adding VIRTIO_NET_F_HASH_REPORT and it adds the hash_report
>>>>>> field, which also needs to be initialized with zero, so I'm making sure
>>>>>> vhost_net will also initialize it.
>>>>>>
>>>>>> Regards,
>>>>>> Akihiko Odaki
>>>>>>
>>>>>>>
>>>>>>> Others look fine.
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
> 


