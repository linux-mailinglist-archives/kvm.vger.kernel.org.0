Return-Path: <kvm+bounces-35030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E3EA08EE4
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 12:12:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B477416634C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6680B20B21E;
	Fri, 10 Jan 2025 11:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="MwO3UGQ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAD6205AC3
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507554; cv=none; b=Sf+/aPT5W63KmkcEWsQU4CAma5zXPNOQQmPf3uwbjqsWxiuBjTI+cRrKKZNILxTZ3OfM9tOUa9pOyK3deZPSSb3SMuGVeH5NoWg5VWElJEjZUNh9EC6/y3T9yrQ4Qpw7vVEY5vdaIp749Jiq2+eaOC6Io4zoGXKb2iLd3KKSDAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507554; c=relaxed/simple;
	bh=qXSynCY96TYG7wZ7OASI5Muii12uM+aBd0x+fKz2Q64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fE82IGeDN61HGtSTUi5Nj9IpYJQU/KdKaxt6NAl0Ewh4n36N+UbtF4GXnQa7ywUrNtqOFtGOqQOm2yyhzr6UFlp81VpriavJ/rfd1XlrIKa8Bjiq8UniVTxFd5iGa4hqWQk02S1fzRBJzE/7RBDAM9JuiXCinc5boAxb6RF72K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=MwO3UGQ8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2164b662090so28959645ad.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1736507552; x=1737112352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fUI/Gf/iNdZ2kON6E6PSrhEkMNvEUQIh/sL8yMhLamQ=;
        b=MwO3UGQ8TvdlcnS1Er/wPY9ota4qi9gGOgTNt7g7S6YG1L9H3gqX0ExQeXxKJnXL7X
         XeAWFpsMp3pjyvWra0SCvqOuqk/80Ss1ztp4HN27fDmWYrpuva407XWMh4/xOAEXA3KJ
         WuOh5DzuQ4gbLE0fUUS7YS/+tghLtkvK+s5eGulTypBG7qqUOlAMyYF9c7Z+TLIAXXwW
         UE9+ude3fE3mDWHLqpT9hK6iDDqMJCmdSPQ2vfvJ015wBRsVUBZDs2Tw0Jz3m2fwhswE
         9BT0HSyyEVIF8eiJ9+cOWEtoHXvBzBFnnCNhJrTMzYH6h9prUzxWAnD2O7WOPlgDTkiH
         UdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507552; x=1737112352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fUI/Gf/iNdZ2kON6E6PSrhEkMNvEUQIh/sL8yMhLamQ=;
        b=JLYR3K0xdXyikGZHkApQGwkwedYypMbeiJ9qe+JyKQPIiXa2IZUAaALyAxWw8t/1bX
         fBCsFGFV4zdzSE6oJxOxiLMRAPY0ME3iPlNGTPTmO+IkbeCcgvjWD2r/u5VYwRCPuqKZ
         53ihDrcHo8UwaMJ8un+wmj3p7ULONbKvoikgSHQTlng7WJ2ZtoPikRPvw/8ec8a9wS8d
         B7C+kto274GuYF8+2vbsQDGNMPmxlRyNkriyK5oMRabOj5oAfs6njIFM1mEGovWFWEzn
         iZsjjOIea4dr23z3a9ZddfP9LNWqHgAQBK16y39GLu5Y+UTygT0TXu+OVfRsvSkX5Fix
         vLRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNGGS481PVl+Fy1Cihv06TpBAXo1bO8FC80KACj7HqOCEyczVcVakWpE/BR3CriWygKIA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyileU3c8qcSg9OUzWP8vmFeQIJaRvCq5x9C/zAdo06G6/IUb6e
	cnmgyorv7ycMS/3iwW8pkUKktGK7LIkcANtM/oScD0JHobK7eJTj+hXdqlpwG04=
X-Gm-Gg: ASbGncuteNyxTLBDHLmwR/mddY+Zngrk1k/v1VwXAsxjEZMj/uGKp5R49IxdG/wuCEG
	Yxga7cy/07KKXvhl6Am2/JTrtgQQG9hXMfSZFP+GPYJykuctsB1RiVcYelBhZoqN4PuglqxA1jU
	9tIS6zwbtMyplLuCFAb/E9Qt4c3hipv531i6/pKTX+isALRrKxOmxlxqXLAvGq/Go76lAXDO+5Q
	1eRJEXPCWNxQA3uS6+0QT147VxZdnHHCo/qtgdoGgWMt/ZbP0vok/0cVkyiTpqsL9o=
X-Google-Smtp-Source: AGHT+IFsisJKA6JOrR0eUj5WfV8wXSlwG+ErpDxaHPAWov6uHn2OYu5jltHENp4vvgdoL273AAhZWg==
X-Received: by 2002:a05:6a20:244d:b0:1d9:fbc:457c with SMTP id adf61e73a8af0-1e88d0a4770mr18461822637.36.1736507552500;
        Fri, 10 Jan 2025 03:12:32 -0800 (PST)
Received: from [157.82.203.37] ([157.82.203.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d4056a2cfsm1373935b3a.51.2025.01.10.03.12.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 03:12:32 -0800 (PST)
Message-ID: <2e015ee6-8a3b-43fb-b119-e1921139c74b@daynix.com>
Date: Fri, 10 Jan 2025 20:12:25 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] tun: Set num_buffers for virtio 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 devel@daynix.com
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com>
 <20250109-tun-v2-3-388d7d5a287a@daynix.com>
 <CACGkMEsm5DCb+n3NYeRjmq3rAANztZz5QmV8rbPNo+cH-=VzDQ@mail.gmail.com>
 <20250110052246-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20250110052246-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/01/10 19:23, Michael S. Tsirkin wrote:
> On Fri, Jan 10, 2025 at 11:27:13AM +0800, Jason Wang wrote:
>> On Thu, Jan 9, 2025 at 2:59 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>
>>> The specification says the device MUST set num_buffers to 1 if
>>> VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
>>
>> Have we agreed on how to fix the spec or not?
>>
>> As I replied in the spec patch, if we just remove this "MUST", it
>> looks like we are all fine?
>>
>> Thanks
> 
> We should replace MUST with SHOULD but it is not all fine,
> ignoring SHOULD is a quality of implementation issue.
> 

Should we really replace it? It would mean that a driver conformant with 
the current specification may not be compatible with a device conformant 
with the future specification.

We are going to fix all implementations known to buggy (QEMU and Linux) 
anyway so I think it's just fine to leave that part of specification as is.

