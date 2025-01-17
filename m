Return-Path: <kvm+bounces-35764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E259BA14DAB
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 11:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D15C166D8C
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 10:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1A01FCF5B;
	Fri, 17 Jan 2025 10:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="P6RxKjc+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8911F9F72
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 10:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737110128; cv=none; b=ko9y0RA+bpDRnTbbwZXcxZpBON0ARLmBDgB0QesV2d/bpQixJWYKl6BrDnzJKoW8gZUxq60k6s2/vlNbMGxeGNhXZZibQqvUCh9UEYPyHssmZiw2S4dSPyvLzvJaeZDWCuW62BTSO1PBIvQ48l61TRFmmG87c278KetLynhkuw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737110128; c=relaxed/simple;
	bh=70bfaT34dxfacCnCOxEBqaLDOi2/f294fVDQPUnDUSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=OAdqSydmJ5cWfEmdThwIeZxwvNnxpPmkeyLeu82f8B/Sih3/NajVrb3qAB5WysTyQj+oUAb2v1CBF5Quy8qYq0xQRwLyL8zqDKv2s9hzkBwjoUAr1c34+45sAdVLNwn5Ue3Mho4d2GQ4KYB6ddHzAuVHBf3Bn7cjiznIWjf8ysY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=P6RxKjc+; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2166651f752so44689715ad.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 02:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737110126; x=1737714926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1s3j+Lo8FohUApnn9jxJmXSbe+FtIPWK2NNPguyY5ds=;
        b=P6RxKjc+Fvu+48J+Mgoj+P8aOkuqRlMij+k5AS9ELVIjMH2zLxK3uhS13pQt4yC0+0
         SomVAFK9Y8lOX+rGAfJ+8QWuuaqdOiMCj58MXIAMLQkMhlTJqEnVSQm54EYFUyf3JXFO
         iFpdKCmikfvAxOlwTASDIo3/nLsTSERDHlJTrf/qyFfOlZg+1D9C8cN/cZJVQRoeO/HN
         8svSpUy0Sv7EkTGsfCES7GE+q0zLb6hvRw7J9GuoDEwhWFqK18Oo75KTb/B2Dj2lhvLl
         uLAsgFpsmqrYJTAZLa4r0xKU7tcKBO7o3jBCYpu69EoOjnRCmiJqR8o/fFBHtxL73jH8
         bRsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737110126; x=1737714926;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1s3j+Lo8FohUApnn9jxJmXSbe+FtIPWK2NNPguyY5ds=;
        b=rs8xxMpG44pF/ZsHmySvEih6gw0tvAEA5+D8KvU5pKMrnNFZ8/mwoUaPh4ApMBW8aj
         b9ysFFB+5iKQ0sn9mhzsfR+rNXi7DVzH+LZjHtT1PVUtBqAtJ24PUxJg4YhMEk+8S+3a
         dwhi+aUI8FT83aHp3pB2nAFEv5jIPqtavTn4RWebLAW/wKpjUmPo+Vxzdomb4TfbULvb
         I3WojT+ql1IAMIeGeiq4c6NA2TtcVEIYOAL2GpRfoemgAGn/Occ7cFSyqLRFLogKCt+r
         1YVAqjauY2+FDQ9o4HqFbACeodevlLLVgtVT3z1ysnQSIIaQhoZAXoQs9EqRm9u8gUE2
         aUOw==
X-Forwarded-Encrypted: i=1; AJvYcCWH0vf81cCcnjXhStOTAh/YZV2rjoP+zAlx0THlmRrgr7l614CEghM2pXqnfNUxMDoIG6o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhDsz4S89ZjvCqcKNvTW1WviYE4yHJv/o3CwVDgr4IqWSMO/P+
	/2SB47P5xJP0PeQSiBGOf/XY2Dmcp0AjbqmLt3IoKyEzrurc0PWzq4I3cnN5UUI=
X-Gm-Gg: ASbGncu1BqOVv8N3xUPrh+Bw2xFldObuSJrBsJ6BZ3TY6E3BFzuiYOmO4qRPBAF3oDZ
	vdL+Z6JHDQUq0NatN4nfzQ4a+YEkGuttpkeOOx+6s9GL3xm/NMV2BvFrmNZvVyagl9xWflvmu+Y
	KHxWPnnAiMW6wMHL9Nw0wja4t37R5KFT5Zg2GEqAQOmmkt83LN1bSvII3pynGhl8/cCGJ/mPih0
	iEWm855N2guYVzUySoqO0kjcnDuKNO48ikny1sLRtBWignc1DBzn5piFgv2nSHI2Hw=
X-Google-Smtp-Source: AGHT+IGPzLz6S37k0uPz0pnAPaNjl5ykAtTRRDNMCEBSSX1EJykbz5I62peVJ/pXXng63XBSAbFQiQ==
X-Received: by 2002:a05:6a21:788b:b0:1e1:9bea:659e with SMTP id adf61e73a8af0-1eb215d4c46mr3415218637.35.1737110125973;
        Fri, 17 Jan 2025 02:35:25 -0800 (PST)
Received: from [157.82.203.37] ([157.82.203.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab81754csm1564334b3a.63.2025.01.17.02.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 02:35:25 -0800 (PST)
Message-ID: <51f0c6ba-21bc-4fef-a906-5d83ab29b7ff@daynix.com>
Date: Fri, 17 Jan 2025 19:35:19 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3 9/9] tap: Use tun's vnet-related code
To: Jason Wang <jasowang@redhat.com>
References: <20250116-tun-v3-0-c6b2871e97f7@daynix.com>
 <20250116-tun-v3-9-c6b2871e97f7@daynix.com>
 <678a21a9388ae_3e503c294f4@willemb.c.googlers.com.notmuch>
Content-Language: en-US
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 devel@daynix.com
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <678a21a9388ae_3e503c294f4@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/01/17 18:23, Willem de Bruijn wrote:
> Akihiko Odaki wrote:
>> tun and tap implements the same vnet-related features so reuse the code.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   drivers/net/Kconfig    |   1 +
>>   drivers/net/Makefile   |   6 +-
>>   drivers/net/tap.c      | 152 +++++--------------------------------------------
>>   drivers/net/tun_vnet.c |   5 ++
>>   4 files changed, 24 insertions(+), 140 deletions(-)
>>
>> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
>> index 1fd5acdc73c6..c420418473fc 100644
>> --- a/drivers/net/Kconfig
>> +++ b/drivers/net/Kconfig
>> @@ -395,6 +395,7 @@ config TUN
>>   	tristate "Universal TUN/TAP device driver support"
>>   	depends on INET
>>   	select CRC32
>> +	select TAP
>>   	help
>>   	  TUN/TAP provides packet reception and transmission for user space
>>   	  programs.  It can be viewed as a simple Point-to-Point or Ethernet
>> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
>> index bb8eb3053772..2275309a97ee 100644
>> --- a/drivers/net/Makefile
>> +++ b/drivers/net/Makefile
>> @@ -29,9 +29,9 @@ obj-y += mdio/
>>   obj-y += pcs/
>>   obj-$(CONFIG_RIONET) += rionet.o
>>   obj-$(CONFIG_NET_TEAM) += team/
>> -obj-$(CONFIG_TUN) += tun-drv.o
>> -tun-drv-y := tun.o tun_vnet.o
>> -obj-$(CONFIG_TAP) += tap.o
>> +obj-$(CONFIG_TUN) += tun.o
> 
> Is reversing the previous changes to tun.ko intentional?
> 
> Perhaps the previous approach with a new CONFIG_TUN_VNET is preferable
> over this. In particular over making TUN select TAP, a new dependency.

Jason, you also commented about CONFIG_TUN_VNET for the previous 
version. Do you prefer the old approach, or the new one? (Or if you have 
another idea, please tell me.)

> 
>> +obj-$(CONFIG_TAP) += tap-drv.o
>> +tap-drv-y := tap.o tun_vnet.o
>>   obj-$(CONFIG_VETH) += veth.o
>>   obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
>>   obj-$(CONFIG_VXLAN) += vxlan/


