Return-Path: <kvm+bounces-34630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75BC8A030DD
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:48:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F269318861BF
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 19:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F611A3AA8;
	Mon,  6 Jan 2025 19:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="BTF9JbDr"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FCBCA64
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 19:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736192875; cv=none; b=i2++j9ITnbj+14DK4hPZGja57fsnUjzAZuaQwGN3lnsvwC60voNFnajJOs/puWyvH+2a1xiOoae8JoqTfkCpotLlfTRIAgTq7CXcgNWxt7wQjFOlrVu2hwqHcfyzMEu7g/M8ihx9bgTv0U71TYKo/GJCXIPsJF+/DeYoacQB5Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736192875; c=relaxed/simple;
	bh=KcRnOliVbPNnDerGTJx1m+xAYvr2alYi62GnOrQGtCY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=OOITiq0LvtGhBKl/W4dCuYIn2TkEUryggn3Luu7QYrO45c/5V8SJQKT3PoESv29HIK0LMNTPolqIWxttFYX3pgolroNoqh5oQYOBDCJsnajhOks+rhEektpiPNKkCG3/ESui2n9Dl6Sg8Q/LlSffWEyPXcDkQF90y4UPZP0hTUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=BTF9JbDr; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 6E109828840C;
	Mon,  6 Jan 2025 13:47:52 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id uM6_vjIp4ZJe; Mon,  6 Jan 2025 13:47:51 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id C584A828840D;
	Mon,  6 Jan 2025 13:47:51 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com C584A828840D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1736192871; bh=KcRnOliVbPNnDerGTJx1m+xAYvr2alYi62GnOrQGtCY=;
	h=Message-ID:Date:MIME-Version:From:To;
	b=BTF9JbDrbhsfSd5jo7qDUIra0f0GDGdKbLW7dxP/+19MbewFHIYHPL0KUzK0aDbR0
	 NyrZKXdpV7myVytWc8H742fp4E/gVctbpQ1Yw4n2AJrzkMFJOJsSn9rJpPLReKHQmU
	 Ru5YDu5qr852s06HasKdo0CL7mUk4McMtfNiaAfk=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id eXzVAU9ak-L2; Mon,  6 Jan 2025 13:47:51 -0600 (CST)
Received: from [10.11.0.2] (5.edge.rptsys.com [23.155.224.38])
	by mail.rptsys.com (Postfix) with ESMTPSA id 4C15A828840C;
	Mon,  6 Jan 2025 13:47:51 -0600 (CST)
Message-ID: <8dd4546a-bb03-4727-a8c1-02a26301d1ad@raptorengineering.com>
Date: Mon, 6 Jan 2025 13:47:50 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Shawn Anastasio <sanastasio@raptorengineering.com>
Subject: Raptor Engineering dedicating resources to KVM on PowerNV + KVM CI/CD
To: kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Timothy Pearson <tpearson@raptorengineering.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all,

Just wanted to check in and let the community know that Raptor
Engineering will be officially dedicating development resources towards
maintaining, developing, and testing the existing Linux KVM facilities
for PowerNV machines.

To this end, we have developed a publicly-accessible CI/CD system[1]
that performs bi-hourly automated KVM smoke tests on PowerNV, as well as
some more advanced tests involving PCIe passthrough of various graphics
cards through VFIO on a POWER9/PowerNV system. Access can also be
provided upon request to any kernel developers that wish to use the test
system for development/testing against their own trees.

If anybody has any questions about the test system, or any insights
about outstanding work items regarding KVM on PowerNV that might need
attention, please feel free to reach out.

Thanks,
Shawn

[1]
https://gitlab.raptorengineering.com/raptor-engineering-public/kernel/kernel-developers-ci-cd-access/linux/-/pipelines/1075


