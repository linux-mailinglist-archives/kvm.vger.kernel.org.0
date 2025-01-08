Return-Path: <kvm+bounces-34755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD80A0557B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 09:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C624518880CD
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D1E1E501C;
	Wed,  8 Jan 2025 08:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N5Unzi4b"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404841AAA03;
	Wed,  8 Jan 2025 08:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736325311; cv=fail; b=e4Q6ZWLD/qh+5tjejJatLyTtmkhgUQC0MTWUkJGqcNTkZQRZOGKwOYWGWY2OxCSAwoE8FN6NYnx+qJuKm8tYnUe9Wm3mCfi+weTrEy/B/kcB/Z82DnZj4rMhwuberowHOQ90n57nSfmE1Tibwc3baX/uErB7pFfVlaCMYmHpNKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736325311; c=relaxed/simple;
	bh=PMavHkdMcjNt0RW0iJ6koLY11mvpVT6vuf4KfLGGajw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bmep//BapAfaYNTPqThZthB8pFQBl7xvoce/5oeYdyq/F5YZ/LuLdxL+Hx3P2OzU3C49NbkBgX7bbHFyo18+A6MqvZd7LO48ogHoi8RsweWaK/qkpH9PxCCSgREMYQEVSgadM8V3+rLWl0tXdcu3++XYyL0aLh8R7B6j17OnMag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N5Unzi4b; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G5q8Qhgdw/7dmj61Tzink5ZMNeuBR+irSJjx1sir1Ikq9XOl9cfzRCC2ad+XjMISysb0ZWLvFYESRRLaWeA3eqjONaxMeV0BieFdzpW2T+5Uj6p3LYzRycuqP1YuKFLF2TVtZnHP9s6nFKQTUtzq8vnZAudb994D0NN8YMK2CneT4EovJlYzGtyJTix3NKG9uR5qYmuzqyeTahyGtBCN34QzokfppysBMVE7lLze1Qd+ciLhd8SdvMmvGqI18SqkO5X1i4dhdz9iTzViKsJ9zc2oc1rRjhVdQctSCKcenlk1T1/VUwYPHwgblHn9xXoSgjCG/LdhuqJ2jdXIICmLlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkQlq0EexbW4R1BCt4Wgzpi1fuGBe6V/BrzLjIKysss=;
 b=Isx+p6GJkCy89+0NWH5TudB5Cb1ia6NwZy8JQG8sUR8f/mu42QZ1wnRRjRNcLm/U/PMZw5gLbcaT4q9cP7EKw+T3/NCkVorFzpEi9MtF2Mf5YMspN83XlKbCPGlrRQUqOHvY358axMM24X8l8TAvKMqsV+hRXJCTV7wdXaNA+5p+W3mPo7rN2rjCPujecozd/i0iW8K7s2TvWINIvaaaqG+8sDvTo0LPqfQ+7y8Ln2QhnaL6ZLUqrcgbZYdbD/MAr8FFORwx5o7gLhm+rJuCxu3S375V/Z5eWwYviChtclg1/55G6W/AMaHHoz1UNNp1S07H9RUy3dWMk53DAPs8ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkQlq0EexbW4R1BCt4Wgzpi1fuGBe6V/BrzLjIKysss=;
 b=N5Unzi4bQvRvKZYno+dJmlib6epDeU3XKMnuupt5+5M7h+fKT+TykRV/UpprnjDLTWR0BmZ60toI+efeXngatoh2vgXdJ11k5zMVjJperrRNzdRonOGP8rcFy3PFxQ5kCPvYWvZAMRsMGtdzm/13sDRSe0Y27URw+m4Rxv4EPoI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH2PR12MB4086.namprd12.prod.outlook.com (2603:10b6:610:7c::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Wed, 8 Jan 2025 08:35:07 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 08:35:06 +0000
Message-ID: <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
Date: Wed, 8 Jan 2025 14:04:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0220.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH2PR12MB4086:EE_
X-MS-Office365-Filtering-Correlation-Id: d59a8b63-cb28-42d9-16a0-08dd2fbf5a56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eW4vdGZVT1lWK3ZIQ09ISFRxc29ScEFvRFlPTjQ1OGl3enpZYVVNaDlnM09h?=
 =?utf-8?B?ek80a2JUN2toNkRscER2NnFSY3g3dVpEQmZoVmNZMjh1T2pvdi9MTFl2YU5l?=
 =?utf-8?B?WnVrK25Kd0ZTM2tlcGJGb1Q1c2Z4RGdsVE9GNE5LRVR1VHk5ais2YXQyRkZJ?=
 =?utf-8?B?K3o2RlNuVVF1QTc4RUlGeXYrMUUwNWJTYXRjam5EMWRGYjhaVTloODBXSFpr?=
 =?utf-8?B?QUx3VUN5VUdpK3dqYTdWdnVQdms5UmxJbHRyTTU0TUNsdVVRbU1ITHRuNUtT?=
 =?utf-8?B?Qm00N1B0cjhpL3ZHQ1FWZHYxamMrWDlQdXBqYmthV3Y1MDJueUR4d3ljNVUw?=
 =?utf-8?B?amMyc1JLZkpCVUZhZ0lZSUtDakhIeFFhbTliMjBLNjJqUUtlZFpYVEpHL25B?=
 =?utf-8?B?OHdFWkRMZXFaaVdGZVpaWitYTWtEYm5XUndRd0p2ckVGUGNNU1RYc0F6ajBU?=
 =?utf-8?B?N2ZkSVpaV1BYemQxR0R4cDFqVmdNR3pldmZaVXh0YlowaXF6ZVlMSzc4ZnhS?=
 =?utf-8?B?OWJoOEM0S0lqUTVXNkwwMWNyckk4Yk5Zb0lpbzlPSXhVaHRQTG9udVFGbnEx?=
 =?utf-8?B?ZHdDdkxjamtQNVBGOXVjTmpNY3JvMGhvRVFFMWRFZ21aVTFOWngxL0FaQ2Fu?=
 =?utf-8?B?QzdabU9RZjBPQTBkOXZ0cHQ1c2I3bTFsSlpHdmlCZzdwNGd5d2o3cS9OYWdo?=
 =?utf-8?B?L2JRMEl6VFh5UnlZZCt0bkJBYTBreW1OcENPVHZaMlpkelpKKzlyalVjc1lo?=
 =?utf-8?B?bUF4bENwMjdXL08wd01lekJQamx5VFByT1VPQ1pPVnFZLy9rVzEvWFJ4VUY5?=
 =?utf-8?B?S2FyZ1k4VHhFS3dWVEM2MjhYUWJWa1pHVzVJNnNXeVFqemZkQVBpRHNHeVZV?=
 =?utf-8?B?ZWY4L0JNYkJEcEd1RnVNQkIyRzE5RGFkOFhqL3lld05ZTFZ1RFJGQzFFNjhj?=
 =?utf-8?B?Z3ZKam42YlBiL1Z4UXRDTHArV1RuWXJybG10Y09ONmRUWDkvS1grdHg5RFIw?=
 =?utf-8?B?ZE5naE8rM3pPZzRvS2hiWnN5NEpLQ2V1Q3RBQXhKcmN0VkFIMTdSbDJCSFd4?=
 =?utf-8?B?VndwMGR1Z2MrSDJXVXZkQlQvSFMwWnJlRERpVVVKSXZJR0xYcGVoVnJVcDhP?=
 =?utf-8?B?OVZyNkZoYUx4SDFqd0JaM3hVY29NRU1sREZESlJCSDFpamtqdmlmazFPVUUv?=
 =?utf-8?B?Mm96ek5YZTZDN0s0YlRJdlhKQ0xhRGxqelZ6K0N2R0NJYyt4SEFxeG05Z1Nl?=
 =?utf-8?B?RzBZQ1pKbEZpVk80ZThxNnp2MkZPY3hPRlc0RzRVWStMSHBiOEU5bDJTbE5N?=
 =?utf-8?B?eStxZ0VxU0JnYlY1cjU0SHlNS2NKTmsrREVzMGFBQnFGekVKZDdablZibURI?=
 =?utf-8?B?dkYwZDZHbWNJSUJQOTRzWHh6TkRzUWYzREZqV0RvVlNWbU1rS3FOeC9ERVhJ?=
 =?utf-8?B?eVpMeS9JTUkrT0JlMUEwUytRMnhrUFY1NnhHMC96L3RtYjBScnZLZlNOYmJX?=
 =?utf-8?B?c0YvYzFTS1BZMXQ1L3VwZ0tOSVJsbThETThhQzNxeDNQQjdyNTdtZ1RGS1My?=
 =?utf-8?B?QzFHcSttMGVZRFdva2c4bEJtL3pLVTJUdmNLU2ZLZW81K05VWkpkZndSTVJo?=
 =?utf-8?B?aG5QSGJnOTlCbkRweHJwdnRIRlpQZTJ6bm5MVEZkNEdYemVOcWJwRWI3cFhm?=
 =?utf-8?B?cU9EODYzOVhBRXh1OHFiWGFUMHcwcnM2WGNvbXhLR2FNNEVaQ1hHNnZtNk9H?=
 =?utf-8?B?U0I0bG43UW5DYXpGTjZzenVrZWQ1WVZiS3RERlI0YS9CaHk0c203VTZYTmNW?=
 =?utf-8?B?N3dPeVViOHBmUFF5VjZZcm5BNkhRNS9lbkRka1M1OFg2MVFPUFhhZGk3VWVa?=
 =?utf-8?Q?Eis6ov4fITdIQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGNhYWpUclVUZmFPRmVVWm9BOGxGOEljbER1U0UwYkZuRmFMVGFqUzR1disx?=
 =?utf-8?B?eUR2T0hUQmVjdUQva0FiSXhqVmNJVVlmd0ZRdzBxTW92eDN5a0hIVXowcUcx?=
 =?utf-8?B?S3ZMekZQWUo4bThXSUx2TTlFUDZUVTYwcHN2M21XUWh6djE4eUQzSnljci9T?=
 =?utf-8?B?THN4OWFmVVhIRVBhbWh1TFhPK2FSVXQ1Q2gzbEI0SDg5U2VUSFBVZFQwRURr?=
 =?utf-8?B?M1BOOTlGdXRINTRaVG1BWHhJUFVJcWh6SnNsbXo3MW83Tmp1SjJMMXdzUm8r?=
 =?utf-8?B?Q1hSOExONzRaSGR1OWQvRm1hZmMwZFdpeGZveFpFeUhtaFQ4MVZDRExiVnpr?=
 =?utf-8?B?dmZHSXl2T1Nrb0E4cnZiL3FTZ0l0MlprSDlHeW9UTEVXOUJNRTZjSVhXYXJu?=
 =?utf-8?B?SWdCbzJLQTBXck1sY014dFpNNFRVYUVLTkxtTmU4VlcvWWVNbUxnOUYrY0d2?=
 =?utf-8?B?c0dlYlpOYlNMWmhNOHF5QlJycWw4aXZsOXgzZHNSaktReWc4ZGRtaWVXUXFJ?=
 =?utf-8?B?S2d4TVlpNTlUL1dGajlONzdORU10enpNczFsVWFJeFZWaXpCUWFveDFMSDlR?=
 =?utf-8?B?Ym42MWJlalczYU5FV0xuaHdpTEpDd3pLYTF3YmRnaDZ4bmFKSFVoNzBLdG1o?=
 =?utf-8?B?ZHl6U3JZUTE3V0tWTFJ4aWs4NlY3Y0o5WEs1aUJGSE1jdTFiWWZpb2JlTmtz?=
 =?utf-8?B?TnYxbDEvTVpMTGpkREo2clc1RVZsU1NBZU1MbjRGWGxxeXhtV25mZ3VYcDRU?=
 =?utf-8?B?aVc2RlhBZFZzWG5xWkRLWFVVcUYrU2lsMW9ZRHc3ZFBFMXNxandxcU9UbXo3?=
 =?utf-8?B?UlFxR0JSYVBEazRpQUVKSk1DU0lQVVBNOFVNaCtkZEhkZ0F2dzVlcTVmMFY2?=
 =?utf-8?B?WG9CNnpkMVJrT045M2txdHFUVFVEQm0zbTdud2RKOUNXZkV6THB6cEJ0Q1c2?=
 =?utf-8?B?VmlVTktCRU9uWTRYcUVaZ1puUXZpQjJ2YStpanhRL01SWDQ3TEI3QnBMSlJG?=
 =?utf-8?B?MWJFWXlucHFQWjRuWEU1OFNGanVISDNQNnAxdVk1Vk5wMWxZblBoNkxIMEhC?=
 =?utf-8?B?alFpczJiQnpsL28wcXA1eWJzaFVQL3d4VEMxWHVhMktGK2lwdE1Jd2wxbjNH?=
 =?utf-8?B?Q0hldWljdWxnWU5weHV4cGtyVTV4dURyLzZaSlhOOEVqakkvVnJwZkJ6Nk9D?=
 =?utf-8?B?b0t2UWdxcEluUEsrU0JtZFpxRVAxb2ZrcWNRZkRVMHYrQ1JHMEFCMmpqSmxY?=
 =?utf-8?B?SDNnOUROOXVuSHdseWtEd2ZRQkt4Zjhid0FZNXVUZ1BwcmgrRTRHVExUSGMx?=
 =?utf-8?B?eDJBNWlMVWZLSDdtNENCQnU3b0FXVzE0RE9qUDhGUEtUN2h3a002Vi9idWtP?=
 =?utf-8?B?Rm1TVDF2ekVPMXp4R2wvbWRHWDMvWFB2SW9pNnkyaGlTaGdGcW44Yi82K0tW?=
 =?utf-8?B?cDB3a0dTd1VxODVVMGRnSG9IVDI1WW1yUnZEUHVMZnllVjcvbWhGbEh2cTg4?=
 =?utf-8?B?Zm40b2poSmJrbUF4T2ZRd3V1VVRDcno4eFRIbzNBM015YVdXeEJCT2p1Zk5a?=
 =?utf-8?B?cVdvSllqbVlpV0xQMHVWY2ZMMHZJTURpclAxNzRVZ1ViOEFpaGR0UUg4WGph?=
 =?utf-8?B?bHdBdkhySkxqWXY1NHFCRWhhU0hkcHFxZS8zKzY1NmNRc0FxL05CNWNGSlA5?=
 =?utf-8?B?VmdFaW1PY2t1RWxpWEthMThDbzNTc0pPTlhRZUZpTFlwWWFpWWsyTC90NGUx?=
 =?utf-8?B?bkhFMmMwWTJ4K3hsTmdNMVEzVnhBZDc5M01WZWRtUVRXTVRhQ0Q0WnQ0UEtF?=
 =?utf-8?B?QWNLOGVKMzJNZFFCK0QrcjhVR3RVc1VtbUtkbHhqTFUwck80eklQNklxdUk4?=
 =?utf-8?B?OWwvcUFpenl2WTkzaC9Dd3plVEtEMlcxQXRPdGZMQS94dVU1SWpSc2xTTW5G?=
 =?utf-8?B?WnpjTUFnNHJuWXJQRGtBRWJCM3Q5ejRwVXFZQ09WejJpTzdMaHRRWlVaUk9D?=
 =?utf-8?B?ejhPL1IyRzMwajg1R0cxSitwaGFSaTBJek8rcHExTm80UEl4U25tOFNOTGhV?=
 =?utf-8?B?OWdkSU5JR0JHWWc4WHFoWTZ1bmxLR0R1WnQ0TEJsQnI2dDdDdFZRNkpCcHFr?=
 =?utf-8?Q?QhS2EuaHA8wl5OCkMvXgAMHzr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59a8b63-cb28-42d9-16a0-08dd2fbf5a56
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 08:35:06.1005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8tu+suQvUC3NZIMlcsO3deqbuao6yqkNkt9g78MI032r9V8dmgMWK49l8+8Fl3XxEJzwoXkiDys/Y/uaXFslg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4086



On 1/8/2025 1:52 PM, Borislav Petkov wrote:
> On Wed, Jan 08, 2025 at 10:50:13AM +0530, Nikunj A. Dadhania wrote:
> And your patch doesn't have that at all. I know Sean thinks it is a good idea
> and perhaps it is but without proper justification and acks from the other
> guest type maintainers, I simply won't take such a patch(-set).

I haven't heard anything from other guest type maintainers yet, and they are 
on CC from v12 onward.

> And even if it is good, you need to solve it another way - not with this
> delayed-work hackery.
> 
> IOW, this switching the paravirt clock crap to use TSC when the TSC is this
> and that and the HV tells you so, should be a wholly separate patchset with
> reviews and acks and the usual shebang.

I agree, we should handle this as a separate patch series.

> If you want to take care only of STSC now, I'd take a patch which is known
> good and tested properly. And that should happen very soon because the merge
> window is closing in. 

In that case, let me limit this only to STSC for now, i will send updated patch.

Regards,
Nikunj

