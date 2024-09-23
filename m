Return-Path: <kvm+bounces-27310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D15597EEC7
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 18:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFAF41C20C48
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 16:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F7519D067;
	Mon, 23 Sep 2024 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nIOdOIZ9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348291FC8;
	Mon, 23 Sep 2024 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727107366; cv=fail; b=YBPS0d9EaVyGRCXbNHVdj83DkWYkm35GYo/jf+W0VR2gbAaCDNTGCDlBZIK7EL6t0sJMqZE1/w6Iqp1xono4g1WTsCkgm5HmVUQVAZxSCjC0MPQBvYSpDXIHTQ9CFX41DJBWGdEKAoZ+u8QWuZAAvP3eD7ou5yqAJU6GW52laM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727107366; c=relaxed/simple;
	bh=vsk9KbCDf6II1+7UZfrYe8ABGvoU6naE9OluOnuT3+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qhOfZMe4BvSVl0i+G9XhMNqasOblVO0Kl7Rly/p79L/NOe9k+DxbzrmUuFroqHz/ax9GQNOwVC5Z1EukeRQK9/x0bzg6BCl4XloHbf4Zb0swDKppMn3yfQqIPlm4P6UhTwtCspoqeJAWJyTpAe1SQG/iw8iBycb/6qWmKB1Gubk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nIOdOIZ9; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zHYD9TbtzioB/V65FaamSbrQm3rcbuzWJUocQUX/kzRvNckJ7H3ZlphPMc0jLKgMupY+3Ebq2MtpP2jRwcesUfv1wcPU8KRFsZbsD3W7hjAnRzc0L+P2afNZrwGmwsumQ0q/yUfqtQlnsgSejkjZcHrR2BHiMuu3I8UJXuLk+8OVU/UvBPSg+eqFqzcW4qluXQKF4ltwJRoqC4iwpDV3FCurKGas7zQUnlpRGEXjaux29THEha1SxMi2tcJhnREYFjIMuKa8zH3gHeG+wSk415z7gsfr3fda+sNBM/PsKMJVHCG99MYTXTyiW3vtDshA/b7dE7oECrVabsn/Fzw/aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFwVbUGARjJQE2VLahDGuGNBaEYJetWduXzQC9dfz7A=;
 b=fiTmIByHE8NolHOH3xhMDkUUm72ySppYR8wePq7RXz5CJBJCeClYlBr0hTy+gKVF+YuIX8Qd4/ZCuVFcr04o3MIEolTaWJ71KpjeugAdw0I1ezZB1A9vWbLVj2W1f5iqX19HYOFZgKhmlZz0lvQiTWdQHI0LJjjViHfwPEiV34uWxQjmp8aVFo1Pt+ibDiBFfgnHvsRwMQEkJ0JG/svgRAP+07QZHVJ8UKwOGvcwqv/cokM1rJs1yIRAiqXYG27lcxrQ1chHfvZ0+yyNTGr+GE0N9YknKBh5zz6PWjZaMYUdW4dzhAE3z6n8gahiaQnL9dQ9hFmRAmjo7x0zlPpI0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFwVbUGARjJQE2VLahDGuGNBaEYJetWduXzQC9dfz7A=;
 b=nIOdOIZ90lXocx+TZ6MtO6MI7REaLu4Nc1NHQmRtr6rbX7BlIVBP0d2QjfkR2muU57LLZBLS5oojIp6LFSKx8dLWR1RizsmGVO9FRY5M1I5BMKBWKC+//+Uyd/2YXs+B5yzeNjFxDv5MrCxhmhwmhYjTfss8XESq15W0xL1r7s1U56lKMCUekMm6lulmJ5iyZXbu+l2SyvhAg11vtLbNnA1izBpaWzI9l/0OzO6UZPjAWBUo8IxrkIJb5ldJXyZMXNBTbxAHPmSTLwNHE3IDQR38kfNCF4LTie7SYrHQaotFjsWYrDzn+4h33cOWPw9kN/GfEO3xlNduOYi9wwjBAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6961.namprd12.prod.outlook.com (2603:10b6:510:1bc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 16:02:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 16:02:41 +0000
Date: Mon, 23 Sep 2024 13:02:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Annapurve, Vishal" <vannapurve@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <20240923160239.GD9417@nvidia.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <ZudMoBkGCi/dTKVo@nvidia.com>
 <CAGtprH8C4MQwVTFPBMbFWyW4BrK8-mDqjJn-UUFbFhw4w23f3A@mail.gmail.com>
 <BN9PR11MB527608E3B8B354502F22DFCA8C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CAGtprH-bj_+1k-jwEVS9PcAmCOvo72Vec3VVKvL1te7T8R1ooQ@mail.gmail.com>
 <BL1PR11MB5271327169B23A60D66965F38C6F2@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL1PR11MB5271327169B23A60D66965F38C6F2@BL1PR11MB5271.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN8PR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:408:80::41) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6961:EE_
X-MS-Office365-Filtering-Correlation-Id: 549a8222-8c3d-4518-bf3f-08dcdbe9271b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFlrQjFPUFo2VkNKZ0J5c0xlelVuS1BGK0txTDVmZDF6b0RlaUpkVEs1bmxC?=
 =?utf-8?B?dUw4RFBnY1RQcmpucVdpdGt4ekpxMEExZ1dCNjNkbFc1Qk1TZUlhblhkZ3dv?=
 =?utf-8?B?WWd2OFJGd1F4KzVacTBncnFjSG96U2s0MHVkdGlFRUorSHcrcEpERHdWbjg2?=
 =?utf-8?B?NzBjL3pWQkp4QXhsNmV2UW9iMjBYZktBSmY2SHlLRkJDL1R2ZjluWFg3bUtn?=
 =?utf-8?B?aGpCSGpYanBmR2lFUklUb1hBaDRnVWR5bDNWTVcvNy84Z2dMcWJma21td3RK?=
 =?utf-8?B?R2xRN3JhMTJzd3pNczlHR1licmhoUTYybGJXOHU0SitJd0ZETERRZWhlMGpt?=
 =?utf-8?B?cHdjcUk4RXR3Vm03SmdNUVBmUGcrWjIrYmpSdHhFUG0wUUc5T1E3aXkyUG43?=
 =?utf-8?B?SmhOaEZsVFk3MDFzR2dRU1JTVHJhTFFES3NuWjMybEdyTGRDOXhPQVJMUmZ4?=
 =?utf-8?B?SEVicitldGJDV3NnQTcxQnduS0JHMmRyaG9tSklHU1dQRkFkdVQyZWtLbDRC?=
 =?utf-8?B?QzRyOGpaNGtaVTMrZVZwTjc4aytSMWlEcDJGbFp1LytldkVudlBiWlpGV1Zr?=
 =?utf-8?B?T054cGFwclhlWXlCeElpRGtDMVlHUi9Hek9PakZIWGZscTlpdG5xYnV3c0c5?=
 =?utf-8?B?Riswa0tqY3k4NCtSOU81NTNNWGdlZTZhYUlBOFp0VHRwazdBc210M0tXelRa?=
 =?utf-8?B?T2x2dXIvUVQ3SUFnNE9uSjA2UHZOd2o5UFNabDFMOXo5eW05TDJ6dEEyb24r?=
 =?utf-8?B?Zk5jUmF4ZEt6VDl6YmFYRi96d3R5RVpkdDRzUU0vSDdIbTl6SHNwL1dyb1Z1?=
 =?utf-8?B?Z2RNb2VXNlJ2c0pIMDdLS095ZTlHRE1nWElQMDZkZjFMT0VUck4yRzRBeFkz?=
 =?utf-8?B?d1NxaTFMZk9UNE5sUDJ5MHJzUDFFbnN1ZmhteHhTUmVBT3VVY2ZmT2xtNnJL?=
 =?utf-8?B?R3p6N1FFcXVOYVlZdW1hVk0rSnE4cFRMQTh0ZmlsYXU5Y0F5R0V4M3FhQVF5?=
 =?utf-8?B?Q3JSVEt2WlAzTm5LdHBpdXRod2VrMkl1bjZSYlpRWWEwRTViZExkUU41Qm5v?=
 =?utf-8?B?ays1OWQ2QjVkV21MOHYyTjdKWUVUMmJLQmxOdE9uU3E1VjV1ZFVvcXR2azNy?=
 =?utf-8?B?UURHTFUwN1N3TGwyRWQ2aklyMUhJMVhvMW1ZcWo2NUd5bzgwaWIxVmNmYWdt?=
 =?utf-8?B?TTZIaVlraXNHaDhza0pRU3orL0wybk1NUmdPZThubFlwbStBUEdnTGs5dEZu?=
 =?utf-8?B?M1N4U09Kbk84YU94RXlwQXRhMzRVSmczWnBCVUEwdG1BcHJjQUd1NGtUN2w1?=
 =?utf-8?B?bEV1RCtDbGhhNkc1V0liNWxzVXk1cmE2ejRnZFVIUXN1U0FzQTU0TnorUWNv?=
 =?utf-8?B?dU12SzRTbUZacFJ0NEpNSEc5a0dwVTBITmFYNU83ZXhLbXhlamNSRFBEMG9o?=
 =?utf-8?B?bzZhUzU3K2lTbzhucWl3M2VVT010ZHJOZ0s3VDl0aGV3NWVSUGVRa2lLeFpv?=
 =?utf-8?B?M1dlQlJ1eWgvVTZrN0taTk16aDNadVB2ang2emVLWDJrWTdQSUc2Nk1hOUc3?=
 =?utf-8?B?Rkw0emprMHhkWU5OQnhNc1R5VnBHSi8zc3VsSjRSSGZIeWFGeS94Yk1FZXRV?=
 =?utf-8?B?Z2lyOXVYNFNmY05IK1YxM1QvaGIzWHg2dzNmcnJkOEhNTExKblgycWZkN1lh?=
 =?utf-8?B?S0xKQ3FHUlU5L3k1OWhoYi9FUmxlV0tIZVR4Ym9Yb0MxRFBUMnFES3ZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzRRU2Zxcnc4bzQ3Y1ViOUpqejVnaG1KMlB2cTRrVmMrbit1SkhRb1VjOHlk?=
 =?utf-8?B?Ymp6cjI4UlZPN0E4N3IybWtRZ2Zid21SNU1SV2J3R2s0aHhIb2Iwd3ZLZXBn?=
 =?utf-8?B?TXNOOS9JanR6WU9OdzhVOHU5NCtwdWNSQkE2cFA0bGZkMFROZHl5YWFFL2FH?=
 =?utf-8?B?VG8rYTQ5ZlEzTkZXZnhEQmlqTmQycS9OenBxWWtkZm5nS2hyc0FsOVRpL3VR?=
 =?utf-8?B?NUU2ZkgrcDFoUXZNem84dDA0N25ObEtrdHMvMGpibmVqUXFCRWYwbG4yQ3NE?=
 =?utf-8?B?K1REU0FIU3ZvTGpXZXVnVnhDZHV6RVJDaHBTSUtYVnpRWFhmU1h5YUxKSU9q?=
 =?utf-8?B?ZjFjRHlvRTJxV0pPUXhwU0h0cG1HSCtXUjBJdDN3WnhWRXBLZ2hXZSswZXp3?=
 =?utf-8?B?bUNPam0wUnExK0Y5bVhYek1sdEFzQWwrdFpLanB3b3lwcElOVTk1SlUrWEsy?=
 =?utf-8?B?T3Z4Sk9XZFlqckhCZnVOMFMySUFza3BrQ0h3UEIyRGpvNTA2ODRCNXNsSWpL?=
 =?utf-8?B?aFUzc095bkZnSDdIQWUzdHVDTWRiaDltc3ZkMnBCcWZPcFFmNWE5MnFxMm8z?=
 =?utf-8?B?V2U2RS83elE2dG5zMzBNTjhkUzIyeTJsc1BZWDVLUlpMTjRoUG51d3BESnY5?=
 =?utf-8?B?UTkwSUJKNGZub2xkQW96VjVXSDhpVjFSUmJTZWk5amphNUZDa0ZEOXRTN3FD?=
 =?utf-8?B?WG5rRHhVWGVqNkE5WWpOeGUzcEZ6NU4zUk5uNHgyMzJucmpKRkZCUWRsanF0?=
 =?utf-8?B?dGkvS250Tjd5Mmh3NkczRTZYQkUwOTRRZng3cXFES0N4U1BMMFJsZjI1NHQ2?=
 =?utf-8?B?TzlrY3YvUG9KVUZ6NTJ0YzYwbzBTU0ExcTNmVUFGZnE3Rnk0NzZsUjhkd0pI?=
 =?utf-8?B?Y2pnT1lJMEhmanQ2M0tFVVljcGFHOWRabm1UbEt4NW1Qb284aTB0TkZQaWt0?=
 =?utf-8?B?QUZTU0ljdERBMHFGTk5qTkRFVTgxWVlpS0JqZUMzRlh2dVBSWUdzNHVFcnNY?=
 =?utf-8?B?YkJGMTFxT1d3R09VZVFESjhQNnJTOTlnNzA3aitKZVpFMlhKSVVyYTdNc3Ix?=
 =?utf-8?B?OXdteS9TR2FRaGNMQ3U1V3ovOHFCNGY5Rmt1SnFMSXhNVDJlSG1TVnJUR0dB?=
 =?utf-8?B?VWkvTk5QODJ1QVhCbDV5cVg2SjZkYXBPZElJMVU3a0xvY3p5Vy85ZEVnRmkz?=
 =?utf-8?B?L3VjRmRhWWh2cFkrUUdqSXhlczN2MlNzVE1KY3FBU0RiSzh3cUdXVzdLK2pG?=
 =?utf-8?B?dU5Wd3dSQkxzcFlKQzdTSlkrYzRnVWtaYUJ1c3ZMc1gwMWUxT3ZmTnFCQjZR?=
 =?utf-8?B?bklJeFl4a0MvY0hQdHE2RFIrdHhXSk5uSm5kdEl4QjMzbGxHNkpBUmJKVUt2?=
 =?utf-8?B?RXFkaGs2Qk8rd0cwRHk1SlZ5aGtKa2dRQkFIeDFOWE5EYlIrK3NVeUZpNWpJ?=
 =?utf-8?B?M0VQcVhZSzdzdVFGQ0pnaEpteW5JS2kzWmZzU3dnVTBLcVV3bW9Ed3Vyd2FC?=
 =?utf-8?B?cHBxakdXWFZiU1oyYktKSFBLOGRhcUltcS93S2MyOC82Z1RBRnRFNWtSQzJN?=
 =?utf-8?B?emU1SjlJRG5JWlN6UDVBdkN2aUo2dHp0dytscCtuQlRTV1dQT1NHdVcxQ2pl?=
 =?utf-8?B?aVF1SFJlOStTZ09UMHlUZzlSN0pjd0Y1Q2htS3ExZE9qcHJhTXVWZjludjZ2?=
 =?utf-8?B?MjdTN1Z3TnpkWW1Db0NPbmkzcmpOdTZ0UnNmQkhpa2JpMTVZWFdYZ0F3Q1pm?=
 =?utf-8?B?Q2wvaHluY0lSWjhkYlNjc2dHZHFaVGU2dXpHaWxPYW1JczdqekVtT24yb1Iy?=
 =?utf-8?B?c1VabU5SZGdLaU0vMlgyK0wxczlZMG13ODlGU2tvbnNveWtPeTVicm1PWlFX?=
 =?utf-8?B?Wml3V09abnhDbkx0SnV2WXVLMjdBaWN4RkVlWnpobUgyWWhNVVFxY3RaUnRL?=
 =?utf-8?B?bXFrNXpYR0l2K1RXckJWWG9nQXhIUEJ1OUJIb1hoa3lKWGZEQ1gyKzJKVldK?=
 =?utf-8?B?U1NaaUdwV3dDdHdhSHh5aHRMYU1KcEpRZ29iM2FTZjVZTkpnaTRnMlNhOHhS?=
 =?utf-8?B?MU01dkg1THpRK1V5Ull5QXR6VTM4QnIyVllCYXdkcGFWemdpYWlKeW01NlBJ?=
 =?utf-8?Q?IBSk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549a8222-8c3d-4518-bf3f-08dcdbe9271b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 16:02:41.1414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5+KblVhahtmcQXQ5FuYQG0FQchJ+FPJ16h7V0JMLVwr7/TLhonWXi2V8G/VqTqe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6961

On Mon, Sep 23, 2024 at 08:24:40AM +0000, Tian, Kevin wrote:
> > From: Vishal Annapurve <vannapurve@google.com>
> > Sent: Monday, September 23, 2024 2:34 PM
> > 
> > On Mon, Sep 23, 2024 at 7:36 AM Tian, Kevin <kevin.tian@intel.com> wrote:
> > >
> > > > From: Vishal Annapurve <vannapurve@google.com>
> > > > Sent: Saturday, September 21, 2024 5:11 AM
> > > >
> > > > On Sun, Sep 15, 2024 at 11:08 PM Jason Gunthorpe <jgg@nvidia.com>
> > wrote:
> > > > >
> > > > > On Fri, Aug 23, 2024 at 11:21:26PM +1000, Alexey Kardashevskiy wrote:
> > > > > > IOMMUFD calls get_user_pages() for every mapping which will
> > allocate
> > > > > > shared memory instead of using private memory managed by the
> > KVM
> > > > and
> > > > > > MEMFD.
> > > > >
> > > > > Please check this series, it is much more how I would expect this to
> > > > > work. Use the guest memfd directly and forget about kvm in the
> > iommufd
> > > > code:
> > > > >
> > > > > https://lore.kernel.org/r/1726319158-283074-1-git-send-email-
> > > > steven.sistare@oracle.com
> > > > >
> > > > > I would imagine you'd detect the guest memfd when accepting the FD
> > and
> > > > > then having some different path in the pinning logic to pin and get
> > > > > the physical ranges out.
> > > >
> > > > According to the discussion at KVM microconference around hugepage
> > > > support for guest_memfd [1], it's imperative that guest private memory
> > > > is not long term pinned. Ideal way to implement this integration would
> > > > be to support a notifier that can be invoked by guest_memfd when
> > > > memory ranges get truncated so that IOMMU can unmap the
> > corresponding
> > > > ranges. Such a notifier should also get called during memory
> > > > conversion, it would be interesting to discuss how conversion flow
> > > > would work in this case.
> > > >
> > > > [1] https://lpc.events/event/18/contributions/1764/ (checkout the
> > > > slide 12 from attached presentation)
> > > >
> > >
> > > Most devices don't support I/O page fault hence can only DMA to long
> > > term pinned buffers. The notifier might be helpful for in-kernel conversion
> > > but as a basic requirement there needs a way for IOMMUFD to call into
> > > guest memfd to request long term pinning for a given range. That is
> > > how I interpreted "different path" in Jason's comment.
> > 
> > Policy that is being aimed here:
> > 1) guest_memfd will pin the pages backing guest memory for all users.
> > 2) kvm_gmem_get_pfn users will get a locked folio with elevated
> > refcount when asking for the pfn/page from guest_memfd. Users will
> > drop the refcount and release the folio lock when they are done
> > using/installing (e.g. in KVM EPT/IOMMU PT entries) it. This folio
> > lock is supposed to be held for short durations.
> > 3) Users can assume the pfn is around until they are notified by
> > guest_memfd on truncation or memory conversion.
> > 
> > Step 3 above is already followed by KVM EPT setup logic for CoCo VMs.
> > TDX VMs especially need to have secure EPT entries always mapped (once
> > faulted-in) while the guest memory ranges are private.
> 
> 'faulted-in' doesn't work for device DMAs (w/o IOPF).
> 
> and above is based on the assumption that CoCo VM will always
> map/pin the private memory pages until a conversion happens.
> 
> Conversion is initiated by the guest so ideally the guest is responsible 
> for not leaving any in-fly DMAs to the page which is being converted.
> From this angle it is fine for IOMMUFD to receive a notification from
> guest memfd when such a conversion happens.

Right, I think the expectation is if a guest has active DMA on a page
it is changing between shared/private there is no expectation that the
DMA will succeed. So we don't need page fault, we just need to allow
it to safely fail.

IMHO we should try to do as best we can here, and the ideal interface
would be a notifier to switch the shared/private pages in some portion
of the guestmemfd. With the idea that iommufd could perhaps do it
atomically.

When the notifier returns then the old pages are fenced off at the
HW.  

But this would have to be a sleepable notifier that can do memory
allocation.

It is actually pretty complicated and we will need a reliable cut
operation to make this work on AMD v1.

Jason

