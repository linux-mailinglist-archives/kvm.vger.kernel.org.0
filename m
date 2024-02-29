Return-Path: <kvm+bounces-10486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB69686C951
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BF72286931
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 12:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20CC76F05;
	Thu, 29 Feb 2024 12:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Hn9GdPAF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9B176EF4;
	Thu, 29 Feb 2024 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709210200; cv=fail; b=kul1jmeXd/Y8RIl8c8sGnrf4QB7rB+8leWTY9D046MGfOUyEQw2BSa1vxsGa7BdLubBuLr8bLBf4MJ+oY9RPEA1ZcARcVQlQbjyBAGe3TWIvZFtp5g1oZaYBUJvgZQgS2yGpQjkRGUzBz/QDs+Q2MyE5CvnOenooDQ+U6P43DTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709210200; c=relaxed/simple;
	bh=5BH8LT9Fs0ZnCcKJsgz8qrCQkaPbx40Tkg2s8Upp9sI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MGGBCXHSHZKi59ycOX5OkUIGR+4vv+s3tC5SFOw9Nx94bWfBk9+DdY0qWvFVfA24yOBN2x10wmoDckM8uqJLdTPMptNRkQu6IemlhPj5x2XQWkOMFmBa2liAzoJgaFZW9SVZTN1W8lOkkcPY0fXdGakLndMQfDURa081S7qixBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Hn9GdPAF; arc=fail smtp.client-ip=40.107.94.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhZJfPFV17OhCeTtAxK5+NCAHQb7XF2Y32tyrwityw9r3iBiOdadpjaZ17DuL91xdoPNeqqdoeKEqyZcq79EJJeiSEG+W3UmC6FxP5gagKY8qADNAXRHRmKUjwAd94mr9pY9sAG9uy90OwcouYxn7FwGmPlZxePMWLx8fkMAHBXh8qg0XOZSLs0kEN5L33njD85gTB8BjqCmZROWr2pQSn7+d/LOYrZ3uIncCxtX0U+xs3Lig+N8aye0HNOXbLgsDmKonrwCpbBn/nlIk7+ufxJ52JwPJLIOcbCWxZLiBPRlhrOA8eKEkBgA29G+Ew/lpNiWLK3EYyWpb+FzvWGuIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NR5GaIR8XnHwSW4zyTh2E0mMKyyfcK4yaiN0CtivFzw=;
 b=hA4uEgHBIaNOwXeJD1O2k+qzJmIidAZZiEeF/1gTV0h0n58eV7wzH9E3vugYW+nVHuVwvpRheRkCGWxEI3AU4c6nizO5np+tTTjnLa3CLCjxkLV4hYYku3YjCMSO7qsDB7O9+e6jZuvsy814GFQDWVyOqDIPrNjurm1XNYsMIyKKQihwb72U4AK7Nyjo4SAgeiZIl5d1tbq3yG/S6+unPNRMH4WIxSMo1k50pYtuA5BGUaGFzubLgejP3/X3SQa8o1JyXbiy2eySbDaTMGGVKJ87YLJWO29NMWXESX5yy5wG5TCVr42gjhzbitUEUqsJ76CF61WFb3+I/p4lpP5Wjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NR5GaIR8XnHwSW4zyTh2E0mMKyyfcK4yaiN0CtivFzw=;
 b=Hn9GdPAFRz22nqU1fbP74y1WzJsBHnXOstxoUwDnCdDW7yX5wGENBV+QJWi4d7/A6qe5HtUvkH0LsYkFVeMDimC0JGLtyKMCCIfnQfXhceoG6qD1Zjm8PXWbwlpYTP7MTPcTrOywfaQbjZspxSSWf4nbHPu5Qvj8LrDHcHaHV1nVZrNcHSeVLTw7savK7bzcsgYG3wcRgji3Oxr97yhwP2ZhuS/uoK2YP5SHzOy8tN3GKCBZGTtLFjaHRerQoT5k6swTrHKemg7A199GJLinGwCU7RNS4tibVr5i5/5IuRcSkxYXolptLW+B+uLIXg9+Yczjkn/FL0dRuQRgytuqWw==
Received: from SJ0PR05CA0130.namprd05.prod.outlook.com (2603:10b6:a03:33d::15)
 by DS0PR12MB8247.namprd12.prod.outlook.com (2603:10b6:8:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 12:36:34 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::58) by SJ0PR05CA0130.outlook.office365.com
 (2603:10b6:a03:33d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.30 via Frontend
 Transport; Thu, 29 Feb 2024 12:36:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Thu, 29 Feb 2024 12:36:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 29 Feb
 2024 04:36:17 -0800
Received: from [172.27.52.232] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 29 Feb
 2024 04:36:13 -0800
Message-ID: <0c23d2c9-6c1e-4887-ab95-ca74f0dcb844@nvidia.com>
Date: Thu, 29 Feb 2024 14:36:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
To: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>
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
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20240228120706.715bc385.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|DS0PR12MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: 158181ad-9b44-466d-d7ad-08dc39231048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OEnwyvwLqW52OPt0ewsm3mXKm5twVb15IkQlgrFACOVj2gxbCGrEa7qPHxdWPts4gCMOx4HuYJsu0MEGkH+oY2ppigBwhqfhrxcfevzpGFIwkth694M199rtyZMXh6BS5ab7vUAyjwBWAIBmF4zFWO9w6bBQ0rOYXUJsVTArvYAkyOP5BPySGU4Y5FTOUYe52YHA7VjnhG0Vidkv693DXtTG0rUvhVtmRflZk0UU01EHcXG6szV7zrcLu+1T5TinOvHkG7DjyyAakaJsv9zlASJhRnOM3YscrD2gE9/RU0FJ64RXrPM6X0yIBIgHpikSp/68CsiHq6X3Sw6eG5KqXCR47MihhPUo91iMvTSsaIIAaux4+8xm7Coi/jSnFGUBpEjFM6b9ulklD31SFegZG8uz2OcVZ25TnYutPlhijILJ5qPx4XZg8RAYUtv6zGvnm6iTf2xwJaZTeyAv1q8b5AynSduw83QDaU8B9GpURE30xOYaldR0vm/nE2Y0K3B/GKzOh5MWARffNeplJCEbtcoSkc/0zPTzRiG9QiERtodE0VYZPRxWjKgmcTupiaBEH8XEOHRF0wynDSTRFHOdSRNONCheJnoMh+7tE4J7J677eFFqBltQOb44LuKX8tkUt2YnIUJCypAPqKIaFlvGaG+cF9Ous9H16k6YK8T0sxDDMs6HM0VN6gE4TePhJ8Q6OSwzdOXSkVO+Of+I4dqh4oUPlV93yGx88iTxi5lrx/P8vRDJDN6ns2UPiNDbe+xG
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 12:36:33.8990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 158181ad-9b44-466d-d7ad-08dc39231048
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8247

On 28/02/2024 21:07, Alex Williamson wrote:
> On Mon, 26 Feb 2024 15:24:58 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Mon, 26 Feb 2024 15:49:52 -0400
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> On Mon, Feb 26, 2024 at 12:41:07PM -0700, Alex Williamson wrote:
>>>> On Mon, 26 Feb 2024 15:12:20 -0400
>>>> libvirt recently implemented support for managed="yes" with variant
>>>> drivers where it will find the best "vfio_pci" driver for a device
>>>> using an algorithm like Max suggested, but in practice it's not clear
>>>> how useful that will be considering devices likes CX7 require
>>>> configuration before binding to the variant driver.  libvirt has no
>>>> hooks to specify or perform configuration at that point.
>>>
>>> I don't think this is fully accurate (or at least not what was
>>> intended), the VFIO device can be configured any time up until the VM
>>> mlx5 driver reaches the device startup.
>>>
>>> Is something preventing this? Did we accidentally cache the migratable
>>> flag in vfio or something??
>>
>> I don't think so, I think this was just the policy we had decided
>> relative to profiling VFs when they're created rather than providing a
>> means to do it though a common vfio variant driver interface[1].
> 
> Turns out that yes, migration support needs to be established at probe
> time.  vfio_pci_core_register_device() expects migration_flags,
> mig_ops, and log_ops to all be established by this point, which for
> mlx5-vfio-pci occurs when the .init function calls
> mlx5vf_cmd_set_migratable().
> 
> So the VF does indeed need to be "profiled" to enabled migration prior
> to binding to the mlx5-vfio-pci driver in order to report support.
> 

Right, the 'profiling' of the VF in mlx5 case, need to be done prior to 
its probing/binding.

This is achieved today by running 'devlink <xxx> migratable enable' post 
of creating the VF.

> That also makes me wonder what happens if migration support is disabled
> via devlink after binding the VF to mlx5-vfio-pci.  Arguably this could
> be considered user error,

Yes, this is a clear user error.

  but what's the failure mode and support
> implication?  Thanks,
> 

The user will simply get an error from the firmware, the kernel and 
other stuff around will stay safe.

Further details:
In the source side, once the VM will be started the 'disable' itself 
will fail as that configuration can't be changed once the VF is 
running/active already.

In the target, as it's in a pending mode, the 'disable' will succeed. 
However, the migration will just fail later on in the firmware upon 
running a migration related command, as expected.

Yishai

