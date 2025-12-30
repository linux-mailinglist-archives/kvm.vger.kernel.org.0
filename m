Return-Path: <kvm+bounces-66848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3E8CE9EFC
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 15:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1313B30198E2
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 14:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48112741AB;
	Tue, 30 Dec 2025 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P/btNzLs"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735EE1F4611;
	Tue, 30 Dec 2025 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767105019; cv=fail; b=kbdZDV3YNzJkT+EmyVe9jOdsVF+Uzs01XBZE49vuf/o/NJkkgUVY1LANAu1n0zPgwb3Fg9uXZDBH6JvgRWDKPrTHTtaZbQ0SClClj4XQY2vKyPy6OBcNE7bYhfgg+Q7TAZCFMsxlO504pIboli5Efs2Yl+yjnUgMQe1Yjx1ySMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767105019; c=relaxed/simple;
	bh=mDCapkgl7/DJqDPuJfe2IWoWAYmv0CffUdrVVjhlFE4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jQv8Ddo3Tfa7krrC4ldr6L3g3lGAJvg6m4XAm2rwO5Ga9sgm9vhk/snOe0uzSbn0+UEfpTX97Ru1vMGqKFEWEX2JjdbS0K1T9dTRbn27AAgvnur6KfO5SV8I4scGhtiYpgjdktMzbXzDmZfvYf94DmrVLZBT6GaEyy1aTC6TwuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P/btNzLs; arc=fail smtp.client-ip=52.101.43.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vMvhHv5rXIGMMBGrveXwxNdHgI9a5DvWVQzAxggzzYkWqoUk13eiXRr0rPyamtG2ZUeP16W5z/fDeU19s3FFFbNfvjKW9/UQZKqLWdujrChbykXl39KJo5v/Unqus1rvLNv7bV33E1tM5dkDQJb+j8mti6CTuPH/RV2gbJgHUsssXeV1fELyNqN8LzKGs1WF8o3b8Tfhch1L0K2CZY3+XO9Wpd/f3jSWvvIMX6oVWccv6d/+O7vnDPNkBlOmO3KcsXI6yK2rQbjaC4vGts22Ea30EdYW/bI0mmMgzgPEBCewnl2mkiCNyLQgV38n7iUxRiuEI6goRvfVJmV6RqmSpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mqv4Us8ti7IB9FliAsCscX1KPVt7cjec4vcLfNcmvrE=;
 b=ukxkatrJJrtA4mPMLHxDQ2dg/yr0AE+IYs8O+zIjO+5KvCpSBOJ6jQgVYaHPcVAekyt08w6h0qAfcLeXOV7Z3PdcmQ+KNNHgyJE0siBVsfSxZOZu1xXmaPQVOzAF/i8ZK7kPK1lZh+TaV5IyilQEbFvcUrwxiJ91MRlyZnGfwvbjUpXNNyqcAwzLaDEKPji8sd0VgDCFi1Pi3u5twWb6K5ASTem+8ULUhRwPhZKVV/JWk0j+u47mDGGYyZq3Gplzqkt5cgWbQzzsfzqJgkayw7CvjUPEo/R3u5Ayhe8gGZk9W/E+dS3OFLIg34qZOojGLaZRoRrjXHqvHvVtv+wOXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mqv4Us8ti7IB9FliAsCscX1KPVt7cjec4vcLfNcmvrE=;
 b=P/btNzLsThdx21DzNX3CzOe8RcElFbecBKVqh2gwft79+bNo+jDOjHo6BxTHTrp39mVfSXV9Ratv9ltk6awLSWANKwgkY37unLjmlRahbmN6oo2ZQHznvYJ2D0wj8mabfZrCKjoIb1v/CviFhT3YWoZZ3xl90tMLVTgbl+RhAhE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by DM4PR12MB6422.namprd12.prod.outlook.com (2603:10b6:8:b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 30 Dec
 2025 14:30:12 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277%5]) with mapi id 15.20.9456.013; Tue, 30 Dec 2025
 14:30:12 +0000
Message-ID: <2db152db-2333-4aac-8d77-fa32f850df91@amd.com>
Date: Tue, 30 Dec 2025 15:30:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] KVM: SEV: use mutex guards for simpler error handling
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 linux-kernel@vger.kernel.org
References: <20251219114238.3797364-1-clopez@suse.de>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20251219114238.3797364-1-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0207.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::16) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|DM4PR12MB6422:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ba49ec6-37f8-4b11-952b-08de47aff12a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ylh6b0lUVFRZU3d6U2x0eFpUUjVqc3hvV29ER0ZOdXNZOG8rTmxOZ2o4MW1X?=
 =?utf-8?B?SEU2TmpNYllRTFNPb3lZUFE2aHFrb0JXSXgzMXZvZHB1bUo2WENoaE13TW1J?=
 =?utf-8?B?WkNySTV0R3FyM2hNZjNIMnUwNUJHQnBOL3dTVVRIcUhrakdhOWxTaU5sY29O?=
 =?utf-8?B?MWZHMGpRTDBveFdWOXh5akcvODNqZ0JzTS8vbkswZjNkbFNab0lleXJEWm80?=
 =?utf-8?B?VVZXajlvdnJ1OWhKaXRIN3orRjFOamxDMUJvMys1SitkVXNNY1hlYVROcTcy?=
 =?utf-8?B?UkFqVGdyS3pqTFVMbkx6ZDdxOUFQQ2lkelJIWkcwbGt3S2JrMVRxS3BTYUNY?=
 =?utf-8?B?S3Vsa3JRbklHblZqcHdhaDErazBMV0lqRTBQVFZzU3FjZGFlWXhBMGNnTWx3?=
 =?utf-8?B?dE80dkVoMXZjMzhOdERqUUNFa2FGYWNDdHVsWEdZd3RTNzRQa3ROUmQrY0NQ?=
 =?utf-8?B?VDZKMWpTdWgwcCtQVUIzeEtMRnZ2dzlMWmFsak5uWWJHSE14TkEvZG9ITmkx?=
 =?utf-8?B?UTI0KzdIYUx0TmRQZXQ2YVdpNWRKQ0kzdVFiVGh5VjlZUW1FMDdPNmRyNlJ6?=
 =?utf-8?B?S21KTjJNbmNINUVyUmU4Y0l0aElRcVlFQ0o0WHlRQi96c3AvV1pYV3ZLSXhP?=
 =?utf-8?B?UExwMjBXSTlhV3N0akdGMVczWTR5b21mWVFyZm1LQi91dXU3Y3dzV0pyZldv?=
 =?utf-8?B?NERSOHdRcFJheForQ0h4Vklhei83S1lKQjAzWDBIUVpwcTQ2OFRBc2JJT3hR?=
 =?utf-8?B?Unp1aURXZjUwYWxnaTZwN3daMXJmWEJJNWVkYlRPQUhEQXJUUTBlTDgwUk1u?=
 =?utf-8?B?NElYU3lBenFaQWs5WWNjMFBhbzkrZFZxck02cE1jUDZIQktmdXVzSnBnTmN5?=
 =?utf-8?B?Z3RIWGhFNzNpMGJtc0JrQzdnVThtUi9XNjR1em9YdW44dVdGS25SVXk3MVBT?=
 =?utf-8?B?SHA2NWVSTlJXZmdzYkMvZEFmMzhLdlFkT24xcWdFOW1kYWhqWjJWLzhWaFQ3?=
 =?utf-8?B?OXFZTWZmZHh4ZE5KMmtQaExRSVRyVktZcFNINWk5Sk5JN2F3ZkdjV09yTmpX?=
 =?utf-8?B?aE15WTVmZk8vSytsbkJXa1BKblU2bzBLdUszMTFoQXpYQkNzbG8zUzlRcFRO?=
 =?utf-8?B?eDFDQW5GdXFudWJyWGRIamorQitNYzZrSGxpSnpiOGhHb0MwQ28wN21FUjdv?=
 =?utf-8?B?WG5meTNOSEZaeFZnUnRNWXhzQ0lzV05vaC9kZnFZZ0I1TkVmUEtiSXgzKytZ?=
 =?utf-8?B?Z3lnR3pzbElUSzU5QTlMbVRjN2haVHBlcjVOb21zeTRESGFybGM4TnBFaDcv?=
 =?utf-8?B?RWVlb0p3WjJpVHNWb3hValNWbUtqM2d2UHJ4NzBWcGlzMXdkeEpFWnd0SjN3?=
 =?utf-8?B?bXcyUXFybFF4VElkQmdXSzJyWmdIMUlCV3hoWG9xUGZUWHJmZEEreXdyQ0kz?=
 =?utf-8?B?dDVSNzFZOTJBNEpoblpldWhTV2FHM05oa01CVWozbi90d2VJblpwKzRRa2My?=
 =?utf-8?B?SzBqRUxNQkZQSlUvS21RT1JtYWd6TGx3QmluaDJlQXBFZS9jTitkZ0pHK01j?=
 =?utf-8?B?STV1SmpKV2pCYjQxQWlNajF0QU5udmUzYUhpMjRnWnB2QkFieU5QWUdic05H?=
 =?utf-8?B?emNsUVBtU0VDWWlwYmhabkUwUUNQSm00KzQ2bUtzT3FwY2hDbnZ6RzVQeDc2?=
 =?utf-8?B?TnQ1ZitRUVhGbkMvMDlMRnNWWDNVOVdiQWdmRTZhUXNLdTk4RGdpUnJDN2Fn?=
 =?utf-8?B?ZjE4VGo2N01ZMzVIUTdncHdZdGFXSVk4aVM1cDE0RG5MaE44RGhwdlpxb0Fn?=
 =?utf-8?B?eVR4Mm1qRllqMGFjVjZCM1RTblpJdWZiUkI1Y1dRZldUVDF3SVR2WWdDVEtJ?=
 =?utf-8?B?a1JUVEptR1NyMmZ5a1JVVkR1YWJaMHppbVU5OTdKUGs0bVdxMnlUei93MG51?=
 =?utf-8?Q?E9xdQWD/jytJAurKESJEr1a1TIMhbW7f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGErTURZSitxbTNtMk9qUk9TdEpIcHBKeENwd1ZNTHZ3UnFLUjlQNkhKbVg5?=
 =?utf-8?B?eENkQm0rMkxzQVdRZHlFcFhMeHpNNUhoS0ZBcmtER0ROS2haWktTNlJubktF?=
 =?utf-8?B?WWhwaDIwdUFkUXM3aG96L1hyT1VhNS9vK05jNmYvWVZkUXBieXVkMVdUdGR1?=
 =?utf-8?B?RGsweHEzUk5ZYk42QWVKdWFzRzJMTkVLbjBTUUZLMXVmWVM1TjlwRkowOEpT?=
 =?utf-8?B?VmpaemhRd3lLVlgrdVg4OEhZU0FMdjZ5cEJkZEZleGpGajlkbytIYmlRdXgw?=
 =?utf-8?B?Q0tSSjhDRUVmdTcwbStSY1VDd09tR0p6MCs1a1RtdXBwVUpwVk8yWnV6bURH?=
 =?utf-8?B?NUtCRWt3QURVWWhxMEdkdW5sbk9EWVVodWZOUk51TzhmOUwwaDhUNFVqcENs?=
 =?utf-8?B?aUxMdzlWRnk1bDhDbUxqSTZScjBhUDEza0xnUThlVVVoc1A1dVZGNXl0WnVo?=
 =?utf-8?B?K0NDNW9kL25pRFhESTFDaUUwZWppMVJ4dU9YYWoyc0dtM3Y5NWEvUG5lNFJw?=
 =?utf-8?B?dnpBQXdmM0Vwa0JQbG5lWDM4b2pFUjlvcHErTW1SdXNrUExLakFmM051Umdk?=
 =?utf-8?B?VnBEU0JJRkFiZVozZGdlR0FSV3JYN3IrTTB6REJZNE9hZFMwRmo4U3RUN0tM?=
 =?utf-8?B?dzJlSEgyc3RERVFzNGVmb3Z0S1V2RXk4OExjTC9PMkNVV0Fnd2xSaTlxL3ZN?=
 =?utf-8?B?Um43QUZvVk9pbzQrQW1FakFhQjRUSVVKWDdtL29QbHduZFJHeitWTmUrb3BO?=
 =?utf-8?B?RmVuZXJCSHR1c2xiNDVnK0VhSk16SlJLVUJZUGpvOEgxYkFoYjJzNnZzZ1c1?=
 =?utf-8?B?aGlqN0hKYURmSytwbkxzZjF5My9wb2hxalJ6ci9CQWdrTmxxVTJ6UlVSS3Jz?=
 =?utf-8?B?bjJONVAwdHBlOTFoR3pUY280eTJmU2FxaU8xZzlLeDVXS3o4VDJpSm55Nmpy?=
 =?utf-8?B?NmZKcEJURTQvdHJ5Q3VWMmF5bU1hcUpZT0huUjdkMjRQdkZDTXpUUFgzOWQ2?=
 =?utf-8?B?QURiWElwekFQaU5Xa292cElQMlBKRG43ZXBRMC83bTJoZHR3NVg1MVBleWNR?=
 =?utf-8?B?c3VBY2luWWp2bjkxZG1zOGZNdjJlS251ZmpDL3lRV1REaGpKY3NFQUQ4UjFI?=
 =?utf-8?B?RC9FNy9qa2h2UGxyVy93c1JFOGw2Tnh4R0h1OE9qZFYzWFlhY05udzhqejdM?=
 =?utf-8?B?cld1eVl5ZitlRzJtSENPUU41a0lZNlFmd3MwbTQvQUlhT0s4RjMxMUdXUVEw?=
 =?utf-8?B?QjV3a1ZtZUY4aUZhYUxVWnd6aHRESm4wUHdWUUdDZGU0QTJMTFlCN2x4c3hs?=
 =?utf-8?B?QVlWUWx4Q2cvdU90Z2ZTMDQ4N3Z5ZTlmbUpXWU9GcDg1WlkwcUtFaEpYdk5F?=
 =?utf-8?B?cnBheE03ejdSMyt6aWg4VmNSYzl6VWZSeEV1WDRlZnI4NStHYVpPK2NKekk3?=
 =?utf-8?B?SFI2bVJZMnYvNGsrMFhIUC9RKytLZUFwQ0Q0REZnVFhrUHo5d0RETks5bmNK?=
 =?utf-8?B?S1laREJWUThEQ0xjanRMcm9UN2RzbjA4bERRNGJ2aG4vK3BabC9Rc2ZEK3g5?=
 =?utf-8?B?OXpDVS9CZjZFdFJMN0c5bm1CSEVKZEtIMnliMEdIVXlYRGl6dTgyd0VIRms2?=
 =?utf-8?B?WVhSTVgxWFhJVnlyQ1hlRWxodng2ZTNNRkpSZEFMbVRlVHFSVjhPT3JmZ1FS?=
 =?utf-8?B?dWVtQXkrZnRlM0k4ZVIxb1FRMkZpZnpMT3NvRm01aU9YZnRPbm9DcUJpT3o1?=
 =?utf-8?B?QjJrZ0tJY1IvZXZHWXNpc3hUdStmM0x5QzNCdEk5TWdqNTdPbkxGK2ZUeVhE?=
 =?utf-8?B?Z0ttcUVhUWJvUUd0WHFxRkV5OHRFYzFVUEEyUENuRE1QOFFoMDJIM05XU0Zk?=
 =?utf-8?B?bEl4SEtVUjVaOEYwUS9qemFjdmRjeDZSNGtxSDU5WkxNVVFxQ3JIVGpMK1l3?=
 =?utf-8?B?RWdLR2JzVkxySjNZNGRNZmFtd3E4cGlkZXRmRTBFZnlzbkdoeERTRVQrb2Yw?=
 =?utf-8?B?R25xSWhxUVRUTjJ2VzVmSFdpcTloQktYdGxZM0FjVTM1WVcyeFlzTW9YbUlC?=
 =?utf-8?B?OW5Scms3cG5qR1BqVDM5QzNGZ1NhZms4blJEc0RWeDVYVGtGSU5DcVArUW1T?=
 =?utf-8?B?cnA4K2h0a1BCbVA0Z2l5OUhGNkNNa3l2MWFHNFdQM2pUVVVLQ3o3RHI0OUd3?=
 =?utf-8?B?TVkySnloZW5rZWk5dzVqTXAzYmsrSkZSb2ZmU2tHd0NKQ1IzUXludXBBV1BK?=
 =?utf-8?B?RlhZbWFLUWZZZmNGMGlmd0VUbHZld3VZVGNhdEZJdzlxenIyV2F4Q3ptQith?=
 =?utf-8?Q?sL74nh2tLLxBrCWO4g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba49ec6-37f8-4b11-952b-08de47aff12a
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2025 14:30:12.7205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TuMp7bSyAhpQ7fs5sDm7LwB2VTLZ+VtGffMjdE4DTs54/egnaP8miV9gBIehp9d4vsFDZydEdrSVnZGPYwDxow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6422


> Replace several uses of mutex_lock() / mutex_unlock() pairs with mutex
> guards, which are less error-prone and help simplify error paths,
> allowing removal of all gotos in some functions. This removes around 40
> lines of code in total.
>
> This does not remove all uses of the manual lock APIs, only those that
> have their error handling improved by switching to the newer API.
>
> Changes are separated per-function for ease of review.
>
> Carlos López (6):
>    KVM: SEV: use mutex guard in snp_launch_update()
>    KVM: SEV: use mutex guard in sev_mem_enc_ioctl()
>    KVM: SEV: use mutex guard in sev_mem_enc_register_region()
>    KVM: SEV: use mutex guard in sev_mem_enc_unregister_region()
>    KVM: SEV: use mutex guard in snp_handle_guest_req()
>    KVM: SEV: use scoped mutex guard in sev_asid_new()
>
>   arch/x86/kvm/svm/sev.c | 135 ++++++++++++++---------------------------
>   1 file changed, 47 insertions(+), 88 deletions(-)


Did a basic boot test on SEV{ES & SNP} VM.

Thanks,

Pankaj

>
>
> base-commit: 0499add8efd72456514c6218c062911ccc922a99

