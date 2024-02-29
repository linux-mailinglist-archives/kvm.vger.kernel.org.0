Return-Path: <kvm+bounces-10516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21DA086CE76
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B7951F21598
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AE4158D79;
	Thu, 29 Feb 2024 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WRstr6se"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619DA16064E;
	Thu, 29 Feb 2024 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709222027; cv=fail; b=GSAxJdXrA3xeTYO41mJKhySvFYGU1YTvg0FyR9yWoyUmQ/nqkr38cr6rOzHD0T4jzEy58e/jf+oUpXW9GK8LhexUXwXSxlf9YsDf47o797CBk+2raz9t1ovjjfIqf7dJSVyFVgWe6IcYp2UKQvfj1LquUAJmP1/p4B0Aeh+xVLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709222027; c=relaxed/simple;
	bh=f9t/SEjKgCdkV3GnnCf7/JbapJlz2tOzT12kGNCqcDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=t6fFFgrjfJErRyXtIhK6Y5rVnRgGjlqgNt29owd6RvyRKSzHCJS5dCluOAVUaVJRLcShRgnc8Jh7J75X0O313jy50s9rbDYkpD0WFGjyQjRJFvwQ2u+9v55VpyOS8y2BtqJ6nlzzUszSbsZvGw8pUd8zl57T8qG3YHT6JRRMMcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WRstr6se; arc=fail smtp.client-ip=40.107.237.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQX67uEPMlAI24f/DFZdAnHh+QQ/AyYz/S+IXUJskpjmYwKatXdq1wgar/bSQRiZ8wb2mPH0ypgatI6VYa78bZ9Pi9+xGDlDaFBDvWkRLfC80G1beGb/Db81H9vYqkyMli8SNZsECugWJZmQC7wu6C9P5owJGiJsZ6VIWGCPxX2GO9AOKauzs+pZYWvPVjs9aa9P3wf7nVWljHHxi9xiEdMeT1C2ja9QIce+qkfIAeVyifuwsIyIn9Y7T8e8G3v2HxN6af+whZ0EkAhQpSKcB/iG8FY6efP9RsQPzYo9iy/sU9ltysJlf9K5NYMBfmrnBOG0v7m41q7qmDCEqzEPrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0Rl9PfrMyzwshrT9cl43UFVsHbmS4bI+TY35QLM1fs=;
 b=KpcLmZoiyEZrDUoRot4+bP67clwe955s0J5UKwyU/X0eB82lE4RcKOXW6mXCZdCm6ZMFQEQ63KP0EcqnosbNx3bPHW/Eps1y2C4dWmjQ6i8KyJ8u2KKc4VmKWcG8tx8BIeiEcNSol0EZLe8RrGRnWKdp5nLRDfMgatQpRFy/O+gh+tbV1IcgjzoYDaLnRY6FoABrWp3Xwxw3Ts3VjFpLtbXBn+BZJ266W+49mb9v9MOGOMAF3plf8MOS+zM7+cogindMcPEIbEsLQKo/JhyB5QPh7NXN3VZQIDw4rBU9r168iUAitzSxfCO7JJF4o1GdlcfIctkKbdHa9t+B6GqP/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0Rl9PfrMyzwshrT9cl43UFVsHbmS4bI+TY35QLM1fs=;
 b=WRstr6sejKifw2ZonLp6m32V7G7BeamLwo+AnmAJdF3MOZtBFnb04hmQjdAtBMEhMotpHmAVc+nWdiXNxEzPUcZwU8QgYVaTyp/0JXeTsy/CL3B9q81bJUwyiMgWze2QUgKak/+UbT3bJlS0iBI1DJfmVFz1ENKifPZwlhN76TwepmlO478MeA+1TC8NArm3NZAdwfb3c5c/jI6aReE+OSvNe4OCB0UwgvMwoh61TsFNomrmAHSXsbtSYwOY1iWw1UArh6tcbh4hWIb7n1brk0x5GFtVsRgUBhE/dFx0lOCVtHDjf+UkuOgy6sY3HC3HbzW+FmL0w7HuYWRYiZ4ckQ==
Received: from PR1P264CA0069.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:2cc::7)
 by MW6PR12MB8706.namprd12.prod.outlook.com (2603:10b6:303:249::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 15:53:38 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10a6:102:2cc:cafe::34) by PR1P264CA0069.outlook.office365.com
 (2603:10a6:102:2cc::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.31 via Frontend
 Transport; Thu, 29 Feb 2024 15:53:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Thu, 29 Feb 2024 15:53:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 29 Feb
 2024 07:53:17 -0800
Received: from [172.27.52.232] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 29 Feb
 2024 07:53:13 -0800
Message-ID: <bd471602-ef7e-4552-8de4-aba604739c62@nvidia.com>
Date: Thu, 29 Feb 2024 17:53:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Xin Zeng <xin.zeng@intel.com>, <herbert@gondor.apana.org.au>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>, <qat-linux@intel.com>,
	Yahui Cao <yahui.cao@intel.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
 <20240221155008.960369-11-xin.zeng@intel.com>
 <20240226115556.3f494157.alex.williamson@redhat.com>
 <20240226191220.GM13330@nvidia.com>
 <20240226124107.4317b3c3.alex.williamson@redhat.com>
 <20240226194952.GO13330@nvidia.com>
 <20240226152458.2b8a0f83.alex.williamson@redhat.com>
 <20240228120706.715bc385.alex.williamson@redhat.com>
 <20240229141023.GF9179@nvidia.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20240229141023.GF9179@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|MW6PR12MB8706:EE_
X-MS-Office365-Filtering-Correlation-Id: 698d54be-148c-4aca-f4ba-08dc393e9712
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hXevsymDVFETPZImhwQBC03Q8bsdCH9X4uInr/eognepcm4Pum9WmjSWEhouKlpxq1O2HJSydUtOc86JswKyoCCuvkmdSzPWYwyPPSTnb19NeuNwujhozjNXgX726UlB6qdrwnf3xXJgP83PIJ83y0X2X4rYDQHbaiiNIrFYIdhMkgDNwr1Mk0T6uKiI4Kya2fjVocn6oCjbjoUntt7T1kAXIO+fRBmEmqp2ugrUXVZtYMsvG6GthIKCA0Y1GNefEQK6Io1OPTLTTEr9DUpS9Wu4N7IKxRUr5o+W0M3F3uDsehFHtDLvUvGzg5xZwXOHEXtgyt5Lc6FS2xO1dAdt8vEIwv9HjU+PHzW4np/yR+SfuKY/ZDb3BRB72CeR9ZhO8ybewkGuWH4rBnbrJCopurKRqNvlYCPBhbiELobAxgKJKSBlezrak0g8vGAutMPDdcFoJP+2OeG3P9mBLTgoAa5LvHRHd9BoS/CpbBn/0HGEPdGzCjcfGxQRc+3dULHtn//5KzlNA6VfbQ5xE0ZtcP9e3qRk4xOO+wOFIbdcBnCcKtqWJ8XOL7Goapy7DY2HK7J4CFPpKpImkyfpHQnmbeyiJMWK7p4U37rzLX3dgGz5W+6Y3oHQbu7oWsceu/1lAznFZ06NiGYEH2WOmAF1bgd/nOVflsyKc/ITLvji9Ilc4i8YmYhxkoasShbsLUVKeEztr9uXaOzRsdefsmhUQf26DxTa9dPOqPGj6oeS9es2r8E3pScs/hlqhnsd2HeP
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 15:53:36.2468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 698d54be-148c-4aca-f4ba-08dc393e9712
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8706

On 29/02/2024 16:10, Jason Gunthorpe wrote:
> On Wed, Feb 28, 2024 at 12:07:06PM -0700, Alex Williamson wrote:
>> On Mon, 26 Feb 2024 15:24:58 -0700
>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>
>>> On Mon, 26 Feb 2024 15:49:52 -0400
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>
>>>> On Mon, Feb 26, 2024 at 12:41:07PM -0700, Alex Williamson wrote:
>>>>> On Mon, 26 Feb 2024 15:12:20 -0400
>>>>> libvirt recently implemented support for managed="yes" with variant
>>>>> drivers where it will find the best "vfio_pci" driver for a device
>>>>> using an algorithm like Max suggested, but in practice it's not clear
>>>>> how useful that will be considering devices likes CX7 require
>>>>> configuration before binding to the variant driver.  libvirt has no
>>>>> hooks to specify or perform configuration at that point.
>>>>
>>>> I don't think this is fully accurate (or at least not what was
>>>> intended), the VFIO device can be configured any time up until the VM
>>>> mlx5 driver reaches the device startup.
>>>>
>>>> Is something preventing this? Did we accidentally cache the migratable
>>>> flag in vfio or something??
>>>
>>> I don't think so, I think this was just the policy we had decided
>>> relative to profiling VFs when they're created rather than providing a
>>> means to do it though a common vfio variant driver interface[1].
>>
>> Turns out that yes, migration support needs to be established at probe
>> time.  vfio_pci_core_register_device() expects migration_flags,
>> mig_ops, and log_ops to all be established by this point, which for
>> mlx5-vfio-pci occurs when the .init function calls
>> mlx5vf_cmd_set_migratable().
> 
> This is unfortunate, we should look at trying to accomodate this,
> IMHO. Yishai?

I'm not sure what is the alternative here.

Moving to the open() might be too late if the guest driver will be 
active already, this might prevent changing/setting some caps/profiling, 
by that time.

In addition, as Alex wrote, today upon probe() each driver calls 
vfio_pci_core_register_device() and by that time the 'mig/log' ops are 
checked.

Making a change here, I believe, requires a good justification / use 
case and a working alternative and design.

Note:
The above is true for other migration drivers around which upon probe 
should supply their 'mig/log' ops.

> 
>> That also makes me wonder what happens if migration support is disabled
>> via devlink after binding the VF to mlx5-vfio-pci.  Arguably this could
>> be considered user error, but what's the failure mode and support
>> implication?  Thanks,
> 
> I think tThe FW will start failing the migration commands.
> 

Right, please see my previous answer here, I supplied some further details.

Yishai

