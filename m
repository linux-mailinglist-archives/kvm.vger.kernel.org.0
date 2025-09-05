Return-Path: <kvm+bounces-56877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9218CB45775
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 14:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0699F189EC72
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 12:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D158434DCD2;
	Fri,  5 Sep 2025 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arvin.dk header.i=@arvin.dk header.b="n/POs+ie"
X-Original-To: kvm@vger.kernel.org
Received: from home.borberg.arvin.dk (home.borberg.arvin.dk [194.45.76.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8B372615
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 12:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.45.76.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757074494; cv=none; b=T41563VpJU+sKb5fPdSX2t9pPV1hO9tjTWw5vlM+QjwCtHfEIvpGSTT1cBEdcXNQQPj4BsoNYl5yT4G17IdgxVTBckCyu2nqizfE2NW746AwqZt5brDPobDl2R1++9UDNpgkS1a5Yaiz31U8vucPbOCl9AkIhyTxLeWRFttmtv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757074494; c=relaxed/simple;
	bh=X1qna4NucisaCOuveLFHxJBiuPl8+o2GIYDahq9EMPQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=njv1BA/4XkAu9nC/DFlzKnAviPl3o9OCsTIQYOlijlpYjXoPoAr2f9/3a7HSGBh2CP4EdvoyKS8sJboqduvSNHitaTEqQ7e9Md0NOZT9SASb6SWJQS8s1bjhI+0eKZaUEIAPgfkA9FT7DhoSnqhkViudhO20j+7mPSfGtTCJrT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arvin.dk; spf=pass smtp.mailfrom=arvin.dk; dkim=pass (2048-bit key) header.d=arvin.dk header.i=@arvin.dk header.b=n/POs+ie; arc=none smtp.client-ip=194.45.76.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arvin.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arvin.dk
Received: from localhost (localhost [127.0.0.1])
	by arvin.dk (Postfix) with ESMTP id A9E50251E1
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 14:14:43 +0200 (CEST)
X-Virus-Scanned: amavis at arvin.dk
Received: from arvin.dk ([127.0.0.1])
 by localhost (arvinserver4.home.borberg.arvin.dk [127.0.0.1]) (amavis, port 10024)
 with LMTP id EGF39Cr4F3dn for <kvm@vger.kernel.org>;
 Fri,  5 Sep 2025 14:14:40 +0200 (CEST)
Received: from [192.168.50.36] (0x57346fab.static.cust.fastspeed.dk [87.52.111.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (P-256))
	(No client certificate requested)
	by arvin.dk (Postfix) with ESMTPSA id BF216251DE
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 14:14:40 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 arvin.dk BF216251DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arvin.dk;
	s=202311171; t=1757074480;
	bh=fVPCWFSzmixgC+DRVVog1+dF1Ibob8whRAWSQsK0xQU=;
	h=Date:To:From:Subject:From;
	b=n/POs+ieS/9z4ZU1Q+MyHdR9xdIVHhiQ3r6ucTgI8GCNYxD7XrwAKntG4YToVVoAb
	 B3lngXehcMMlB2FlWOCv1f/g3Iix8yJLsVeBR+T0R/4p/IL22Skp2XVQLM0da4dWqK
	 bDxxBnlMVeSCJQAC6l2jUbY4qKXlhkEmSR69k24IbFPfMwYIdrIycLWpXz4xdkT0+A
	 D5MCXGpETyYcqXJsRWA0FNMRXwYvQ97Gtx2cXJ4p+i16HsuA5Co96a2B54t4+PrxXx
	 Y+kJOHmMC9TfznwwDIMEa4ETGPWNaqHtRlLAkPXKs9FdDxd/zW9QURbUKc1wC0Phua
	 Kba0ZWylp5Yvw==
Message-ID: <3204c99d-6c62-4327-9aa0-a09651a75f0d@arvin.dk>
Date: Fri, 5 Sep 2025 14:14:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kvm@vger.kernel.org
Content-Language: en-US
From: Troels Arvin <troels@arvin.dk>
Subject: Co-stop
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

According to https://www.linux-kvm.org/page/Lists,_IRC it's OK to use 
this list for KVM user questions, so here it goes:

How important is it to consider "co-stop" with KVM?

I haven't been able to find anything about this for KVM, but there's 
some material about it for VMWare (albeit typically rather old 
material). Based on VMWare material, by "co-stop" I mean the following 
situation:

A VM called "x" has been assigned quite a few vCPUs, e.g. 10, on a 
hypervisor with e.g. 20 physical cores. The hypervisor is hosting many 
other VMs, and the many VMs take turn running on the hardware.
Now, if it's often the case that, e.g., only 7 physical threads are 
available when it's x's turn to run, the hypervisor needs to postpone 
running x till all 10 cores can be allocated at the same time. During 
this waiting time, x is stopped (co-stop).

Is my understanding correct? Or will KVM allow x to run on (e.g.) 7 
cores, even though the VM thinks it has 10 vCPUs available?

It's my understanding that with KVM, the co-stopped situation is 
reflected in the VM's "steal time" metric in a tool like "top".

Does hyperthreading in either the hypervisor and/or the guest impact the 
risk of co-stop?

-- 
Regards,
Troels Arvin


