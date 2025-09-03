Return-Path: <kvm+bounces-56698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E3AAB4292A
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 20:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8EEF7B9115
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 18:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B1936932C;
	Wed,  3 Sep 2025 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="Td5hLOs/"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389581547C9;
	Wed,  3 Sep 2025 18:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756925732; cv=none; b=JJyWdme8Gp3/kV3lcEAfsZPGGg5nOHd5E/x3axykebOB28an8uajLHDCNxYMI59zjsk1TKEpiLsKgo0s3pPOsW0HO065yODtMQYXH1xs54DXCSIfWCZMcMDsP1RJpOvJ6ECV2K/LtlcRU9A0vHQkwnb6smkY/nHuW+Sk/KsVNLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756925732; c=relaxed/simple;
	bh=q1PBB34EdsjgNUFzHZgAtK4E4ZE/BeIbEQJOmAy5iYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E/3gUhe0/h7T239PmBKD4UpLkLVcbvIcfqLs9YPfrNlRrk6mvBGRLGaYamJk0LrPXsYg3ziq65h4D4bFZOUEuhOySmS+T+djZ8hXcWwvDlFfv0iN7CEM6KtwC3TGabCGoZ7HXM5iTDrmTTfPFb5QVUMSxE0jupAZRpQAQ1Cupl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=Td5hLOs/; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (pd9eaae6b.dip0.t-ipconnect.de [217.234.174.107])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 583ItP78029180
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Sep 2025 20:55:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756925725;
	bh=q1PBB34EdsjgNUFzHZgAtK4E4ZE/BeIbEQJOmAy5iYY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Td5hLOs/8TpA4H5OoGdbmmwJTVJ9tlKqm5fNwhdZpNKIBSwmaKEw0BF4qXlc8Xee+
	 BjTIM/cDV6H9Dq3fYOCbdMtMxrRxVNSSxEDb+Umb9uu5ISYFHMXeLQb8MH3EktxEA+
	 +/tTFCydC/mMzEac8JaPfc96LVvB6GY41gL3VVrs=
Message-ID: <e7a2e703-f618-48c0-8de2-637c178207f4@tu-dortmund.de>
Date: Wed, 3 Sep 2025 20:55:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v4 0/4] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, mst@redhat.com, eperezma@redhat.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <CACGkMEviyLXU46YE=FmON-VomyWUtmjevE8FOFq=wwvjsmVoQQ@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEviyLXU46YE=FmON-VomyWUtmjevE8FOFq=wwvjsmVoQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Jason Wang wrote:
> On Tue, Sep 2, 2025 at 4:10 PM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> This patch series deals with TUN/TAP and vhost_net which drop incoming
>> SKBs whenever their internal ptr_ring buffer is full. Instead, with this
>> patch series, the associated netdev queue is stopped before this happens.
>> This allows the connected qdisc to function correctly as reported by [1]
>> and improves application-layer performance, see benchmarks.
>>
>> This patch series includes TUN, TAP, and vhost_net because they share
>> logic. Adjusting only one of them would break the others. Therefore, the
>> patch series is structured as follows:
>> 1. New ptr_ring_spare helper to check if the ptr_ring has spare capacity
>> 2. Netdev queue flow control for TUN: Logic for stopping the queue upon
>> full ptr_ring and waking the queue if ptr_ring has spare capacity
>> 3. Additions for TAP: Similar logic for waking the queue
>> 4. Additions for vhost_net: Calling TUN/TAP methods for waking the queue
>>
>> Benchmarks ([2] & [3]):
>> - TUN: TCP throughput over real-world 120ms RTT OpenVPN connection
>> improved by 36% (117Mbit/s vs 185 Mbit/s)
>> - TAP: TCP throughput to local qemu VM stays the same (2.2Gbit/s), an
>> improvement by factor 2 at emulated 120ms RTT (98Mbit/s vs 198Mbit/s)
>> - TAP+vhost_net: TCP throughput to local qemu VM approx. the same
>> (23.4Gbit/s vs 23.9Gbit/s), same performance at emulated 120ms RTT
>> (200Mbit/s)
>> - TUN/TAP/TAP+vhost_net: Reduction of ptr_ring size to ~10 packets
>> possible without losing performance
>>
>> Possible future work:
>> - Introduction of Byte Queue Limits as suggested by Stephen Hemminger
>> - Adaption of the netdev queue flow control for ipvtap & macvtap
> 
> Could you please run pktgen on TUN as well to see the difference?
> 
> Thanks
>

Yes, I will look into it :)

