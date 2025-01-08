Return-Path: <kvm+bounces-34805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95CB8A0632A
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4186A188A5BB
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 17:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4191FCFEE;
	Wed,  8 Jan 2025 17:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="dEZq5ZEs"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E6014F9FD
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736356645; cv=none; b=Fwh7H/iju4wioZmzqxfPXZ4t6S7Grk6xqg6ou+35E1whgN1PM9ckBDb4ZagVah/u2J/rHTk3ceb1ublos3z40m0gy3ITULqLC670rid/cZ9LN0N3mDEqxFvw109c+1GZcsYyndXJCNMLS5b5B5cj1H08wI3ACoLVm4TaXuFPCRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736356645; c=relaxed/simple;
	bh=iO4HIAzpzcHpgspoS+7GIoVKO5cEI583VCDCdoUTSyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CwVoxhQp8yWlEayAfyXP0U6KVZrIo/m5oOzThQrveja8R8eBHNjDVdY04dXeuvsynJiqXGPkWpavDzvA1PExqzSclXZLOKwjIz0IUZTsUgHa0A9qqeKp0qLCMQRhlLls1uNxg8xGSYF3xUDOoT4T3M7jCOZKPzdRYFbRXXLTias=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=dEZq5ZEs; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id C3EEF8287590;
	Wed,  8 Jan 2025 11:17:15 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id QV0Sx48sA9T2; Wed,  8 Jan 2025 11:17:15 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 24FCB8287D4A;
	Wed,  8 Jan 2025 11:17:15 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 24FCB8287D4A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1736356635; bh=rBne1mSxqFYz8GbBPb10Ksop8x4X2f8gV7i8UrBoAA4=;
	h=Message-ID:Date:MIME-Version:To:From;
	b=dEZq5ZEsCcMaz+TU98jieY6hhcQz3B7Y1TMX7h6TlEwv/1a/yqB1FUfGqSpdVEglH
	 hSrjy6/rIdim1chUeTPihMkEnV6hQYDptzl3WP2c8wLjHHwpSFKt0R5sgVpBkpcwxf
	 342hJBK7cqCHPQj/DPQrmfeaSFeiusgfyko+sm0Y=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KqOpN7vNWAuI; Wed,  8 Jan 2025 11:17:15 -0600 (CST)
Received: from [10.11.0.2] (5.edge.rptsys.com [23.155.224.38])
	by mail.rptsys.com (Postfix) with ESMTPSA id B2E728287590;
	Wed,  8 Jan 2025 11:17:14 -0600 (CST)
Message-ID: <de35acbd-8b35-42e2-b344-8c9c1103327b@raptorengineering.com>
Date: Wed, 8 Jan 2025 11:17:13 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Raptor Engineering dedicating resources to KVM on PowerNV + KVM
 CI/CD
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 Timothy Pearson <tpearson@raptorengineering.com>
References: <8dd4546a-bb03-4727-a8c1-02a26301d1ad@raptorengineering.com>
 <20250107064550.713c2fd9.alex.williamson@redhat.com>
Content-Language: en-US
From: Shawn Anastasio <sanastasio@raptorengineering.com>
In-Reply-To: <20250107064550.713c2fd9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alex,

On 1/7/25 5:45 AM, Alex Williamson wrote
> Hi,
> 
> What are you supposing the value to the community is for a CI pipeline
> that always fails?  Are you hoping the community will address the
> failing tests or monitor the failures to try to make them not become
> worse?

The failing tests are all isolated to issues with the specific AMD
graphics hardware that the test machine is using for the VFIO and host
GPU tests, and are likely isolated to the amdgpu driver itself. We have
filed bugs with amdgpu folks.

The non-failing tests however, possess value for regression monitoring
including VM boot smoke tests for both little endian and big endian
ppc64/pseries targets, as well as the vfio-*-attach tests that ensure
hardware can be successfully bound to the vfio-pci driver on a PowerNV
host. The test artifacts also include full dmesg output from the host
and guest machine (when applicable) to assist with debugging.

The data could definitely be presented in an easier to digest way to
make it more obvious which failures are regressions and which are due to
the aforementioned amdgpu issues, so that's an area for improvement.

> 
> I would imagine that CI against key developer branches or linux-next
> would be more useful than finding problems after we've merged with
> mainline, but it's not clear there's any useful baseline here to
> monitor for regressions.  Thanks,
>

That's a good point -- I'll definitely look into adding at least
linux-next, as well as any other branch requests from developers.

> Alex

Thanks,
Shawn

