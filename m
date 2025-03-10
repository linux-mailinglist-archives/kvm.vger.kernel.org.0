Return-Path: <kvm+bounces-40576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0E8A58C70
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89C85169F47
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87CA1D5ADB;
	Mon, 10 Mar 2025 07:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="QZRBYT7/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4CB1D432D
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 07:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741590290; cv=none; b=syxkHWOaB6SboNAdKFbr1Z2ntPyG/2NwLEK4rIVZLr/22tMcS0Gb2JYI1YDhmGjBceMkdMx4ARWSt9HvT7sfaLCnAEAPhdmhiltIZykwzmOqT2mP3T2tKyqvbYQPq7pkQGljYDaNgzlflS2TBHdWCBONnVTrvtlmSM8cjbMQXRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741590290; c=relaxed/simple;
	bh=eSw/Sz1ql/4UPcLEbJRVUH0uYPxF2xmC0A18fnAZuI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IckVc/0ULZI+Uc/b9L7NsgXZRrDLh1SqfqmUSuCMRnREumbGizOMrOcbRBLWnq5TE+tdROpIAu64haclWb4qwWozcC3jY7baYKXHf/A5XlhlmBTefpvZvvbI+V8/GIfVl3XuFds47CyLC4TUB9CMdVbvt3uyuVE83HIJNQ6dDr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=QZRBYT7/; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2239aa5da08so58525485ad.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 00:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741590288; x=1742195088; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z4zUjmNxjokxBeO8EjZH90AMO+cgLdiVs95Lgo++StE=;
        b=QZRBYT7/pUx1N5WjjIh58q+/IinjLV3aq0UR9zGCTNxVna0gfBnE9gUO8W4GuVM9KA
         aXu0TGNLBTvShFK8ky5kFa+mBCVnbzcSPm6vG9pdeZNO3EyOZ4DBu0fksbpXqnIhuwNL
         xEsrLyqVKi+jnkBwXgx5FsdLc7LEKJkinZtQGEHh9kZd3bkFzQI+gKlwnuQEg5BQkvkX
         HxCDTgg0yUZJOLlF8ic1Bi2VoU4YMXRfO9wYbI5HdOdHcSk6mPFQ+UqIAtysplhtjrP8
         XVw77g1RD0BBt3zcQosaTS1XIvITQ01qguj0TkwT+IoPolx2Hr1pDl6gbOH9qtQMrkr2
         DbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741590288; x=1742195088;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4zUjmNxjokxBeO8EjZH90AMO+cgLdiVs95Lgo++StE=;
        b=WawNfwV3DuAktG38jpZUmCmZavVn+coIC3aGS9RYEZ09Dm0g54TvPLM4JngEtZnCo0
         eEc9jm77w+DiVJdIct/aUb5nP0C5N6kB1j2wSyVosRGHkALx3AtdxZ+xY88ztIfQVCOD
         y1RLVBd3JqUQNpoqpts0FasCCZvsQNPTLdR3psDnFie3sdZ+V2bljzCeTV07SpdWnzEG
         I3Khun5ixDUBBXK66x7MaBw2p9OMpelnJSZB0QYv41N3g1gQN6h1VoXZNB25TryWCC1B
         2PkH6f/Gp2pcojR8nrVGuFhcfQ2926rWkqltrboJEa2hs2ldvt/MlxmSXxA3q/ZRoXbT
         MtaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEvFJt0w9mJ7MT+i8+X15U6EqhYbRyOotZWCWq4soIgk2aER9MKAdVTyjv7FGgWVshzRk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgj4Ro6qXB/j5lLXqLL/VZbdM8edtmEAsKlFFh5BwvBQzRl54v
	aHzMnuE5C0aBU0/jXbF4zgNWa/sc958hfxWJlA9lZoCaL+aFr4otipV8EEy1v20OOzRMh+Ok/Bd
	w6mM=
X-Gm-Gg: ASbGncugYlXI8diUjdjsn0/invgCJu+EcX9o+epIHLmHOvOh35PnhOzOAIEqIy1LzRv
	cMgsUS3/sSXCy7yuwYBBclT9WK4IM0DB3dfwdQ5GiLbfisqqOekVUdalUgUWSGzZXN1A8FuVF0D
	2JqXoB2KQ1XGyhtKiHh0GFd3WQiyxuwcvaRWid1Qu580gJ9VQ5976hwLyUKTZ30f4n328bBJt83
	NJtIYQiZW3WN5P437H/pRKkEWbh9A1IQYlqtZhXn/MIQRlr8LAQ6wft5aTvOMRyHnLIiTobeRU9
	g+Sfa6kwQ0xRva+4T2YxAulg5lhA38f8FkJT8W1eWDcieYEbiOT+YvDf+w==
X-Google-Smtp-Source: AGHT+IFkDjhIOqYcqagzT94jgytjjwhSIQTT2o6zqPzPIQtmCm+lioqyAyJhjHPUINzm2ba//BDswA==
X-Received: by 2002:a17:902:ea07:b0:224:a79:5fe4 with SMTP id d9443c01a7336-2242888681cmr196310675ad.2.1741590288383;
        Mon, 10 Mar 2025 00:04:48 -0700 (PDT)
Received: from [157.82.205.237] ([157.82.205.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a7f93esm70081685ad.142.2025.03.10.00.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 00:04:48 -0700 (PDT)
Message-ID: <2e550452-a716-4c3f-9d5a-3882d2c9912a@daynix.com>
Date: Mon, 10 Mar 2025 16:04:43 +0900
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
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CACGkMEuccQ6ah-aZ3tcW1VRuetEoPA_NaLxLT+9fb0uAab8Agg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/03/10 13:43, Jason Wang wrote:
> On Fri, Mar 7, 2025 at 7:02 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> VIRTIO_NET_F_HASH_REPORT allows to report hash values calculated on the
>> host. When VHOST_NET_F_VIRTIO_NET_HDR is employed, it will report no
>> hash values (i.e., the hash_report member is always set to
>> VIRTIO_NET_HASH_REPORT_NONE). Otherwise, the values reported by the
>> underlying socket will be reported.
>>
>> VIRTIO_NET_F_HASH_REPORT requires VIRTIO_F_VERSION_1.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> Tested-by: Lei Yang <leiyang@redhat.com>
>> ---
>>   drivers/vhost/net.c | 49 +++++++++++++++++++++++++++++--------------------
>>   1 file changed, 29 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index b9b9e9d40951856d881d77ac74331d914473cd56..16b241b44f89820a42c302f3586ea6bb5e0d4289 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -73,6 +73,7 @@ enum {
>>          VHOST_NET_FEATURES = VHOST_FEATURES |
>>                           (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
>>                           (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
>> +                        (1ULL << VIRTIO_NET_F_HASH_REPORT) |
>>                           (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>>                           (1ULL << VIRTIO_F_RING_RESET)
>>   };
>> @@ -1097,9 +1098,11 @@ static void handle_rx(struct vhost_net *net)
>>                  .msg_controllen = 0,
>>                  .msg_flags = MSG_DONTWAIT,
>>          };
>> -       struct virtio_net_hdr hdr = {
>> -               .flags = 0,
>> -               .gso_type = VIRTIO_NET_HDR_GSO_NONE
>> +       struct virtio_net_hdr_v1_hash hdr = {
>> +               .hdr = {
>> +                       .flags = 0,
>> +                       .gso_type = VIRTIO_NET_HDR_GSO_NONE
>> +               }
>>          };
>>          size_t total_len = 0;
>>          int err, mergeable;
>> @@ -1110,7 +1113,6 @@ static void handle_rx(struct vhost_net *net)
>>          bool set_num_buffers;
>>          struct socket *sock;
>>          struct iov_iter fixup;
>> -       __virtio16 num_buffers;
>>          int recv_pkts = 0;
>>
>>          mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
>> @@ -1191,30 +1193,30 @@ static void handle_rx(struct vhost_net *net)
>>                          vhost_discard_vq_desc(vq, headcount);
>>                          continue;
>>                  }
>> +               hdr.hdr.num_buffers = cpu_to_vhost16(vq, headcount);
>>                  /* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
>>                  if (unlikely(vhost_hlen)) {
>> -                       if (copy_to_iter(&hdr, sizeof(hdr),
>> -                                        &fixup) != sizeof(hdr)) {
>> +                       if (copy_to_iter(&hdr, vhost_hlen,
>> +                                        &fixup) != vhost_hlen) {
>>                                  vq_err(vq, "Unable to write vnet_hdr "
>>                                         "at addr %p\n", vq->iov->iov_base);
>>                                  goto out;
> 
> Is this an "issue" specific to RSS/HASH? If it's not, we need a separate patch.
> 
> Honestly, I'm not sure if it's too late to fix this.

There is nothing wrong with the current implementation. The current 
implementation fills the header with zero except num_buffers, which it 
fills some real value. This functionality is working fine with 
VIRTIO_NET_F_MRG_RXBUF and VIRTIO_F_VERSION_1, which change the header size.

Now I'm adding VIRTIO_NET_F_HASH_REPORT and it adds the hash_report 
field, which also needs to be initialized with zero, so I'm making sure 
vhost_net will also initialize it.

Regards,
Akihiko Odaki

> 
> Others look fine.
> 
> Thanks
> 


