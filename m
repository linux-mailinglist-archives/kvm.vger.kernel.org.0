Return-Path: <kvm+bounces-27744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10D0C98B3F0
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44C6DB22615
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50681BBBEE;
	Tue,  1 Oct 2024 05:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="ukDHPS0t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9740136AF8
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 05:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727762077; cv=none; b=sl7z94TbUxjOD875dNIXM6WyCJaDjGI0FoV9/lHOt302UJQI8jXlqrIYpSruia0kWc7ZomVJO9HgrJZTpKsQlUq743PKYc3yU29XRxrdEzrcUHwoTncLs+8E8+NPeG7IeqjE4YO6uMBTfVFiI4+9Lu5RiymjlcymfVkZ3yaD3Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727762077; c=relaxed/simple;
	bh=jwGSkO56afJU1ZykB3f/IrdDpZ6b9CUjy6ikv5vxw2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsXGqUNBFe8KRiW1MFp+ZB98Mtv/X8CYZuXNbm0/stCg4YQnBclP5LcKC7lfeAI9lXsyiixEiml10pBQf2uKE0iluiKZopsSB0LrQHAMLawN7tHHX3hAyVVE7HRAUMPx/w25oX+O5W3EERSdomhU2XK+DLFZKrm6Ut+MTs+fv9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=ukDHPS0t; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20bb610be6aso1589285ad.1
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 22:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1727762075; x=1728366875; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GW6JKIMSJkoy7ESOeaiL6uJ49rRhUcpJss1NlSyIBZo=;
        b=ukDHPS0tpA5ik3e06H83dlUdD1y9rAadF8h51l8S+cQjflbKasMRqWTYWRCl2a0/kO
         NQOls3IE2N3+8VKfS3WynlCm7CjcrsbUaTSsx/k1W23z74fDZ/j6PvJw7rn5gVdo9CP4
         c+vJ5/Nh8O0DIwvoNv+jq5ZDEO2yFlsH+ImmYMWsDWRJRME8+kbUSQ+kneUDCLInal3/
         O/9rj6dfGAgNZAZtQYtd+zbojcczdi0Ozuo3sS8RaHvkbtV1DsmuEK8OVqrNHQwFHTy+
         n7EhpWzmOrtKfdkwDlqZLsHh8ESOiCh5dZP45GAtpLavPdvwUcvE2l/3EWtBCOQV4Mgx
         Mdvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727762075; x=1728366875;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GW6JKIMSJkoy7ESOeaiL6uJ49rRhUcpJss1NlSyIBZo=;
        b=l5S8+NWIg970m74P6Y39FQwTqPddtAOChM1agrSG6nfoTs8MMqAtAgfqW1QbPIfIDD
         IkSg283Xk/PaxyGSDGcOGGWWIR0QIKZrsMSngRUwY0p0aWolpks+yZzapwtzhMWf7EWd
         aLXG/chZQRJhEkuS/5Sl0ikIfhHBdMinLMWisc1/AoCUW//rum2STp4Ik1AfV8fYm4Sm
         XDjZWbJJfF0FkIoKdtpoRmDw4cHRkttBDwy8cJFtF2lTg9l4S+fHc/bkRkSrq7HRKVx1
         ioXe1ZQ0SWzI/OunINshMDkqOyGi0fJIAO8uwYBz3ZzQEB2DzMzgbuLdzDLt01nEEBGZ
         iZfg==
X-Forwarded-Encrypted: i=1; AJvYcCVMIvZ5EnCuYJ6FZRjE7ATqh9SQB32W4CSXHmPw1mAq5GlQKcdehMiXMEwBeoyrTdIkztU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcibmFwuAYEyvZ2o6ZGMGeUPA+dqg3NWnrfbIte1tpPyNyaUqW
	eObKoaudE7RUq1vhq4ZiowQI5j6TV8s/GknfszJhV1SGt3hjlkoC9uB4tGbi29o=
X-Google-Smtp-Source: AGHT+IFhIsPLEQ/TcepiVOkMJKIDjkaQae3ulnJtI9h3ifP3aAnGkfCXTch2f3Cv0L6+buDt1VANcQ==
X-Received: by 2002:a17:902:c40b:b0:205:968b:31ab with SMTP id d9443c01a7336-20b37bcacf4mr225656085ad.58.1727762074890;
        Mon, 30 Sep 2024 22:54:34 -0700 (PDT)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e4efdasm63400305ad.252.2024.09.30.22.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 22:54:34 -0700 (PDT)
Message-ID: <f437d2d6-e4a2-4539-bd30-f312bbf0eac8@daynix.com>
Date: Tue, 1 Oct 2024 14:54:29 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 0/9] tun: Introduce virtio-net hashing feature
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Jason Wang <jasowang@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>, gur.stavi@huawei.com
References: <20240924-rss-v4-0-84e932ec0e6c@daynix.com>
 <CACGkMEvMuBe5=wQxZMns4R-oJtVOWGhKM3sXy8U6wSQX7c=iWQ@mail.gmail.com>
 <c3bc8d58-1f0e-4633-bb01-d646fcd03f54@daynix.com>
 <CACGkMEu3u=_=PWW-=XavJRduiHJuZwv11OrMZbnBNVn1fptRUw@mail.gmail.com>
 <6c101c08-4364-4211-a883-cb206d57303d@daynix.com>
 <CACGkMEtscr17UOufUtyPp1OvALL8LcycpbRp6CyVMF=jYzAjAA@mail.gmail.com>
 <447dca19-58c5-4c01-b60e-cfe5e601961a@daynix.com>
 <20240929083314.02d47d69@hermes.local>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20240929083314.02d47d69@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/09/30 0:33, Stephen Hemminger wrote:
> On Sun, 29 Sep 2024 16:10:47 +0900
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
> 
>> On 2024/09/29 11:07, Jason Wang wrote:
>>> On Fri, Sep 27, 2024 at 3:51 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>
>>>> On 2024/09/27 13:31, Jason Wang wrote:
>>>>> On Fri, Sep 27, 2024 at 10:11 AM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>>>
>>>>>> On 2024/09/25 12:30, Jason Wang wrote:
>>>>>>> On Tue, Sep 24, 2024 at 5:01 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>>>>>
>>>>>>>> virtio-net have two usage of hashes: one is RSS and another is hash
>>>>>>>> reporting. Conventionally the hash calculation was done by the VMM.
>>>>>>>> However, computing the hash after the queue was chosen defeats the
>>>>>>>> purpose of RSS.
>>>>>>>>
>>>>>>>> Another approach is to use eBPF steering program. This approach has
>>>>>>>> another downside: it cannot report the calculated hash due to the
>>>>>>>> restrictive nature of eBPF.
>>>>>>>>
>>>>>>>> Introduce the code to compute hashes to the kernel in order to overcome
>>>>>>>> thse challenges.
>>>>>>>>
>>>>>>>> An alternative solution is to extend the eBPF steering program so that it
>>>>>>>> will be able to report to the userspace, but it is based on context
>>>>>>>> rewrites, which is in feature freeze. We can adopt kfuncs, but they will
>>>>>>>> not be UAPIs. We opt to ioctl to align with other relevant UAPIs (KVM
>>>>>>>> and vhost_net).
>>>>>>>>   
>>>>>>>
>>>>>>> I wonder if we could clone the skb and reuse some to store the hash,
>>>>>>> then the steering eBPF program can access these fields without
>>>>>>> introducing full RSS in the kernel?
>>>>>>
>>>>>> I don't get how cloning the skb can solve the issue.
>>>>>>
>>>>>> We can certainly implement Toeplitz function in the kernel or even with
>>>>>> tc-bpf to store a hash value that can be used for eBPF steering program
>>>>>> and virtio hash reporting. However we don't have a means of storing a
>>>>>> hash type, which is specific to virtio hash reporting and lacks a
>>>>>> corresponding skb field.
>>>>>
>>>>> I may miss something but looking at sk_filter_is_valid_access(). It
>>>>> looks to me we can make use of skb->cb[0..4]?
>>>>
>>>> I didn't opt to using cb. Below is the rationale:
>>>>
>>>> cb is for tail call so it means we reuse the field for a different
>>>> purpose. The context rewrite allows adding a field without increasing
>>>> the size of the underlying storage (the real sk_buff) so we should add a
>>>> new field instead of reusing an existing field to avoid confusion.
>>>>
>>>> We are however no longer allowed to add a new field. In my
>>>> understanding, this is because it is an UAPI, and eBPF maintainers found
>>>> it is difficult to maintain its stability.
>>>>
>>>> Reusing cb for hash reporting is a workaround to avoid having a new
>>>> field, but it does not solve the underlying problem (i.e., keeping eBPF
>>>> as stable as UAPI is unreasonably hard). In my opinion, adding an ioctl
>>>> is a reasonable option to keep the API as stable as other virtualization
>>>> UAPIs while respecting the underlying intention of the context rewrite
>>>> feature freeze.
>>>
>>> Fair enough.
>>>
>>> Btw, I remember DPDK implements tuntap RSS via eBPF as well (probably
>>> via cls or other). It might worth to see if anything we miss here.
>>
>> Thanks for the information. I wonder why they used cls instead of
>> steering program. Perhaps it may be due to compatibility with macvtap
>> and ipvtap, which don't steering program.
>>
>> Their RSS implementation looks cleaner so I will improve my RSS
>> implementation accordingly.
>>
> 
> DPDK needs to support flow rules. The specific case is where packets
> are classified by a flow, then RSS is done across a subset of the queues.
> The support for flow in TUN driver is more academic than useful,
> I fixed it for current BPF, but doubt anyone is using it really.
> 
> A full steering program would be good, but would require much more
> complexity to take a general set of flow rules then communicate that
> to the steering program.
> 

It reminded me of RSS context and flow filter. Some physical NICs 
support to use a dedicated RSS context for packets matched with flow 
filter, and virtio is also gaining corresponding features.

RSS context: https://github.com/oasis-tcs/virtio-spec/issues/178
Flow filter: https://github.com/oasis-tcs/virtio-spec/issues/179

I considered about the possibility of supporting these features with tc 
instead of adding ioctls to tuntap, but it seems not appropriate for 
virtualization use case.

In a virtualization use case, tuntap is configured according to requests 
of guests, and the code processing these requests need to have minimal 
permissions for security. This goal is achieved by passing a file 
descriptor that represents a tuntap from a privileged process (e.g., 
libvirt) to the process handling guest requests (e.g., QEMU).

However, tc is configured with rtnetlink, which does not seem to have an 
interface to delegate a permission for one particular device to another 
process.

For now I'll continue working on the current approach that is based on 
ioctl and lacks RSS context and flow filter features. Eventually they 
are also likely to require new ioctls if they are to be supported with 
vhost_net.

Regards,
Akihiko Odaki

