Return-Path: <kvm+bounces-42929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC2BEA803D0
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 14:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73AE63AC6DE
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 11:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD6E269CF0;
	Tue,  8 Apr 2025 11:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ESGG7u5Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19C4269AF3;
	Tue,  8 Apr 2025 11:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113220; cv=fail; b=opuAUN4ng1aLD2riVvn/I6cCZJBR8oe0Cej8EIk0DoTIMg0PVudvhfNUPumVLq27/sqB96rz58+QXgWz8K23mRVaGMPKDA1pczc+Tqj1XeKpjj+Ngbjr0E+lLElCYhKUJUcnkKcF6+WR+Z6wWIWOHkKL90dbZPYr2g9h2OkVvhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113220; c=relaxed/simple;
	bh=11xN22kL6cOt7ttLT7go89wMhLm04IOsRsj/gjACYgw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tO0QYuRggKVv60fpn6yGQuw1K2+OfGJzXGBxcqKYGWHOKYszr0xi3LuIweggafFzbHeBVtow328Ow8OV1545VBP0SRaXHNdkLk75VHasFVXpFRTSmiDdUzcO5DmlzZjNu5xInEYByL0ahEYi9Zh41iPo15A3Xi/iO7OaDW6hUmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ESGG7u5Z; arc=fail smtp.client-ip=40.107.237.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FM4fC0akoHfm0RlPFzzbz7m1IF1E9X5BcjLoIaxQk5ra3R9cso4ul+NXg4G7JSF9g6fU/gUsv8EzGbf+X+FUhxEEZH8n9rprIX/cpv1qj+DmzJ3LTU7CX+ZT4tvpQQ3rvaB4OYYFrx7dtG3VI1jIbbDUvsa97usHDjL78//XyWrK6L7CsDpKWDGhMeoWErrU6nfrD1qCCE+smDLvuO1ruoArX+LEAPBzST/HtawgKCwhD1XzHQqChxhH9sSLeB6AHSTsHAuvsg/NRHm+AuVZqCWB2YUW5yYWwboOJDr64Z7wqkfPMp3hnRWdwuoU82aflbQlzWCEYOwByBw0oV6u8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mt5pc/qmJhlPeXh56YE4qFTgqWEn3sG/TPYfKZgZCvA=;
 b=s7pTQpSZwNS9CP0qkK4hgWSKmTPDbIrhSmDhRwfCvmPUzw+UjHImfiYpqdb1/agR4ZT7uIQrJcg6FLEdIAUOWty5AsASFfC94odV18zrF4fMuRjTDdU+YMusEZFo72v4uRJcgGV80i1gdMxL8+sEVJ3YkiLTNVtvgKcIhC8krDbGGz63R8Gz01gXJyEgLowMgofXNdksYtdupY9jkijK6EeWCpcqfk33ZTTPQKf0h9lglIn9dguGoNOXsJc22w2nwg2dzssilQxWyzkS+3HZGPZtkQRE5PDOzsz7DI9PVpgmBRxIzwcHYHTyJwc10LIEtWC0CZ1HPOZFXcYUhCZSZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mt5pc/qmJhlPeXh56YE4qFTgqWEn3sG/TPYfKZgZCvA=;
 b=ESGG7u5ZtHi7W4mb4NwOWrv1BioBafs8/vHYFRHRtBTe9VUfCFTIse6ROQwCyV8NL12eKoxy6U2OZliEPGKndlqOinpkvpO93DCwNWru2v4XLnp4gmm9b+WvosdcY8C4vwlz9+p9pEDCj2TdAGLjUaxRoOHlaCaECvR9eHryKe0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by MW6PR12MB8916.namprd12.prod.outlook.com (2603:10b6:303:24b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.32; Tue, 8 Apr
 2025 11:53:35 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%4]) with mapi id 15.20.8606.033; Tue, 8 Apr 2025
 11:53:34 +0000
Message-ID: <b050a77e-94cd-45ac-ba06-b56899ecf946@amd.com>
Date: Tue, 8 Apr 2025 17:23:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/7] KVM: guest_memfd: Make guest mem use guest mem
 inodes instead of anonymous inodes
To: Fuad Tabba <tabba@google.com>, ackerleytng@google.com,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250328153133.3504118-1-tabba@google.com>
 <20250328153133.3504118-2-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250328153133.3504118-2-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0123.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b2::6) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|MW6PR12MB8916:EE_
X-MS-Office365-Filtering-Correlation-Id: 2edc1826-45bc-4568-1ac3-08dd7693fd8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUlyV0dPeU9lMjlEclFpNTBNRG1KQkNvSGRITG5vMU4rTDRpNTU3OEwyYW9I?=
 =?utf-8?B?clBEZ1NqVE1CeEtMWWxhWjJPUzh4aFpxcDF0MEJGMkRGM1IwU3h1ZlZGRXhS?=
 =?utf-8?B?MDd4VG41N1lKNnFwbFhYT3lVSTc2OHBIS1RGRk1rQ0xVMHZNSWRMcTc0Qlpt?=
 =?utf-8?B?eGY2cCtvRkpzcVlQK2s4SURpYVNNQk5rTjNlQ21SOHp4S21EWlljTmZZc0pZ?=
 =?utf-8?B?YzQvczc0WkcvK3BYeHdXOG9GZEVVUGZEdmNzWHpJTnBmSlAxa245VmVjTG9D?=
 =?utf-8?B?ck5ON3BEa21xeXlWMjlUZFRUdEhKUVFKR1dkR21tT2EwR1Q5UGJKTEljSFFE?=
 =?utf-8?B?UDdtYzV0cG91L0NTU0dqcWpMYTRkMk5WQXg0SEMrd3FPSGtUN0liL29lTUVk?=
 =?utf-8?B?QmM5eHJxK0lac0VtMHV5VU9DQzBSVllKTGpWelJ0b0s4cmZhUEZmV0Ywdk10?=
 =?utf-8?B?d0tNazJMVmx0Y0ZMRi9HMVIyUXNla3ZHdms5ZDdFcTh2SjJ1ejBPNmtpZGxi?=
 =?utf-8?B?bHlWRTVhZXd5V3Z0aDEwZ0R1OXlDd0MxV0VINHpmZEp5S1o0RnZ1RlVkZFhn?=
 =?utf-8?B?TCtKWE9RMWYray9IS3J2c3RPZ3B5YWxYYUlKcDRmUTQ0eTY3VXBvNW16OFNR?=
 =?utf-8?B?aFB3dEhtU25UQmJOejFSWVVST3FrdFJhYkZjOXc1MzBWZm4yaUxKRTh2R0JU?=
 =?utf-8?B?bE9sdXl6VVRRVnk1UzhDWUlIN0JRYzZMRHVLNFFQUGVuWWdHNlBJYklvenRi?=
 =?utf-8?B?UGpIMk9tRncrT0dkL2Z5ckR6UDZhNVU5b0NSWTZueWFabmh0UWQ0b1hUWFBy?=
 =?utf-8?B?TUZveGIvQVZscm1ZVHd4cEp2czZFZ1BVd0FCSnl1clo0WC81T1ZNTzJhcFJP?=
 =?utf-8?B?aGtJeHZkaE9YV29ud0FFZ2dMWmE2WHF5MVpqVlFZVldIK1dXV1hLWEsvdXpk?=
 =?utf-8?B?cUc2bnladlFrZ3h1VXgxeENHY0pSbm5uM1hydE5tQ3M5QWZWQVBTSzZpQWJN?=
 =?utf-8?B?b01BUkpsdHRjYUROR0FRVjhhY1NhV0VzcXZ4UC9sWFczMzUyK2UrRnF5QjNQ?=
 =?utf-8?B?ZU4za091ci91bEpRM0tZWC9sbUVZMmJqTEFIY2pTems4WGtlWEFYWnhHbWd6?=
 =?utf-8?B?RG9jVVNpN0thcWMxWml5aG81YUVrUEVNV0tuQllzSUNrWWxFLzFYMDRXOU5L?=
 =?utf-8?B?emR1Y05aYjNqclRMYk1WelEzc2V0Njk5aVlib3ZnYWJXNU8wdExWdG93TXZD?=
 =?utf-8?B?VjI1ZmVKSVo4eDkxSnBqOHFCM0oxQVpxS1gzSmxHQm13ODYydFp6V2VGcEJP?=
 =?utf-8?B?eFZGRTRKVkM2S1BQb1YzWktIUFZEdG9zUlJYMW5DWC95VVd3dDJhVkJrbG5C?=
 =?utf-8?B?VitGL3crbWJGakt6ZnZnaWN5OXgrS2JYSE5hZXpnaU4vUExORGE4NUU1THZz?=
 =?utf-8?B?azJmckVydU1JK2Vnb1RJQnBiMkhVMkhGbDloZTRCNlhzWUtxQXhtQjZUK1Ez?=
 =?utf-8?B?Um80aThId3cwRXhKRTdLU2Ria04wYzFWOTlQWDcyY2ZuUmFZV3UrVkJKVGtv?=
 =?utf-8?B?Mk85UGFRZzRmYlVveTJ2am1DT2VKZmpqT09GdnBsRG1QeXpyUmJseUpmUTRT?=
 =?utf-8?B?dW5IM0k0dGpXSnRVR2dnMXQ5aHExOEw2eW9iTWZPT3ViQ000L05SSTdXVlFv?=
 =?utf-8?B?TkhLdng2S2IzYkdvcWNmSEIyVmxvdWR0aUFWSWl4WVNxS2RZcStVNXNUVHdp?=
 =?utf-8?B?c21GeStJOE9NRTBRaDZPQkM5NXcvMG1NcEZHMG5oRkxQa1JkSEdxdHFnZ0lp?=
 =?utf-8?B?K0ZHQnhNRlpybi9xVmZjMFViV3ZJeDc2bGNXYXZSMTlwcWxFNW8xYXdGYldP?=
 =?utf-8?B?RW82OUcxK25PdEZwejhnRXRETlFmeEE1WEFDZVdHa243V2twT2t3bDZNVGtR?=
 =?utf-8?Q?aMt4NvAVF2I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkIxdnp3Y0lQbmZLcWQreFd6Rzhqc1JGb1VsckMvNm0zSzJkR1JhTlY4ZkRo?=
 =?utf-8?B?T0hrMEp6eHlaQU80bDBRckhDeHU4aE5qWXRWR2U3Rzd3aGNMZGlCUm5vdXR4?=
 =?utf-8?B?Y1NXSmUvL3hFTTBhcnBQMERoL29LUmdCbTJyNTI2RTNHYVBNNU9FeFlkaGVR?=
 =?utf-8?B?Q1EzeE1FZHE2aFpPc0gzTmNJcUVIWVlwRGtBQlFBNzRpMFJPcGp2aGdNdVRz?=
 =?utf-8?B?d1RTMDVPWDk0bzZVOEpOVFozVElqd0FZb1FGekxLNFBvakhjWFI0TGxVb0do?=
 =?utf-8?B?bFpVUFg2cWM5ZkhMNFpVU0I3dUdJcldrOElpcFRCN250bXFCcXVpdm5ybXEx?=
 =?utf-8?B?NTVJMDlPQm1sSlhpaVVNdWdJTmZKRG9lUVV1Sld5dFpWNEI2V1BWZVRSTlYr?=
 =?utf-8?B?enBQWWI1SFVGanZlK2lZRXh1dFR5VklrYk9rQXhXSm1RcXd1a0tBTnVxVEdQ?=
 =?utf-8?B?MUYwWThXRFVQRzI5Tk1Hc3NHVzFPQzFycmJ2WjRpMVo4THU5VEN0TFErY0hv?=
 =?utf-8?B?Mnc3aDRocWNUTDVUdzFIVzMyQmphRzdpZi9uVDBhTURzNzBGTFBpOWUyNEhk?=
 =?utf-8?B?TDlIRjV0NDh6aWw3QktMUDhNSHpvclNUTlJ0RjV1SGZQUkxOeUk1TzhXZWd0?=
 =?utf-8?B?a2RMM3Y0TTRSdm5vYXJxeG1QR2pxNVF6T01ORFlvY3lVb3FvL2VJR2NLK1Ev?=
 =?utf-8?B?QWcwYjBWSnN4NThNd2xGbHJGeStsempYUTJPVFFyUTl6RjVPb3YvTUVxVi9s?=
 =?utf-8?B?YnRaMjk5bmpLK0R5UEpSV3luWE0yVjRBeXcrQ0FkMXhaMkRmTjNUSHFZbDZD?=
 =?utf-8?B?K1JXTStnclcwQ0hVbWorVXVOTWxVV1lCb1MyYVlJY3hRN3lrMTcwVStWMmhC?=
 =?utf-8?B?Z3k3TUJUeFQ3R1dKRXF1amthRDZTNmRJYlpKak5ENFIxT0ZmdktUM000RXRo?=
 =?utf-8?B?Lzdpd3lyeTk0d25tRzNiS2xJN2d0ejVINGNqOXl6U0FRQnlTaURlMXRQb2tz?=
 =?utf-8?B?UU4remxhbVVhRHZxREQxeTlwOHNSWmFyRk82WCsvNTgvT2FRaTUvekNGTXFw?=
 =?utf-8?B?MUc5bE9zcWRaZTdLUnBwNGowWHVZQURzb1dIamRWWVY3bGhwQmNpTE5YdVV6?=
 =?utf-8?B?eWNSZ2s4UGJ0ai9FWFJ0bFc4TC9NczVxazh2SzFBSld0VGhqVVRHQ2s4VW1v?=
 =?utf-8?B?T2xUT1QyL2FIQ2lDWjZrUXFtY3FXb3dtbGxsYXZTNWgxcUlqbDNyZWpCbTc5?=
 =?utf-8?B?OXFxUVN6WFhpL3UybjdWM3RBSktyTlQvZUdKMlNiZjhMREFWa2RGZ09VQWxU?=
 =?utf-8?B?M2FVNkt5NjhlNCtKQUkwQy90WDM3K0J0c1BiTUFaVmNCNzAyM1c2czc5ZkMx?=
 =?utf-8?B?VXAyU1N5R0xEdTBUNUdHYlUzZndlVktNNWtDbUdGcjZvYzNMYXZTMjhqdVJy?=
 =?utf-8?B?aEhiWm1DQnIwV21PMUZ0YzFVdFErZG5aZ0lZYndObisweGhFdUU1SUgvb3J1?=
 =?utf-8?B?aG1VTCtqWlJiL2tmWm9uVmhFNk4rUFJMZFQ5enB2THJEOVBDelBMVXFmVXJi?=
 =?utf-8?B?b2cwaU5nc1hpNHVPZDh5YnZ4aDY4Y0NUSTd1eHJtYUNkL1YxekZyaWFMSkNZ?=
 =?utf-8?B?QU9zTVZabkIzRDJwem5LMXpkU1cvWDZRaHVoblEzdFlIc2N6eXl6RkRlZFUr?=
 =?utf-8?B?NS9zN1dSTU5nZWw0eGphN3RyVmF3T1NYVkdlOUFRTXJ3MVllcG0xSjdBc255?=
 =?utf-8?B?bGtDN1FIODA0dGozRHdmaFJUMnVENE5jWUtFZmE5S0p1eUVISHJFWXRwampz?=
 =?utf-8?B?S0JJdmVLek80SW96YldGMHNvVVRYalN1bERZRTZuQzBHMm5sb002Snc3L2xS?=
 =?utf-8?B?YTZCb2FVWk1lL3VuY25TQ25SRGhWRHdIVmVlY0V6QWhScGZWVzFGa2psWGQv?=
 =?utf-8?B?NE15bXZXaVg2bWNLcDZjWmE5Q3N5L0FjK0M4akQrRlB3WjkvakpZUm1TbERr?=
 =?utf-8?B?N1AyWUc4UlU5VTFXdkxpQ21oNHBjRkhxZ3ZHZjBKVHEvbWRaczNEZzExVVgr?=
 =?utf-8?B?ZkI4ZDlLUjllYWJhVnNVYWUzK3dPZ0VnTEIrTzJjVk9EZUNEb3Q1UStPTTRU?=
 =?utf-8?Q?eLoshG6xL8Z0Rphf3CohZiF9y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edc1826-45bc-4568-1ac3-08dd7693fd8f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 11:53:34.7635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3RU26fPj6Y0WedFal/rNTZTux/szzcqqCaFxY37uPpV3tBsWsZ/kv7I/40/CE3OGCwKDEkpXD5nVhkskKD8r/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8916

Hi Ackerley, Fuad,

On 3/28/2025 9:01 PM, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Using guest mem inodes allows us to store metadata for the backing
> memory on the inode. Metadata will be added in a later patch to support
> HugeTLB pages.
> 
> Metadata about backing memory should not be stored on the file, since
> the file represents a guest_memfd's binding with a struct kvm, and
> metadata about backing memory is not unique to a specific binding and
> struct kvm.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

<snip>

> +
> +static void kvm_gmem_init_mount(void)
> +{
> +	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
> +	BUG_ON(IS_ERR(kvm_gmem_mnt));
> +
> +	/* For giggles. Userspace can never map this anyways. */
> +	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
> +}
> +
...

>  void kvm_gmem_init(struct module *module)
>  {
>  	kvm_gmem_fops.owner = module;
> +
> +	kvm_gmem_init_mount();
>  }

Looks like we’re missing a kern_unmount() call to properly clean up when
the KVM module gets unloaded. How about adding this?

 void kvm_gmem_exit(void)
 {
-
+	kern_unmount(kvm_gmem_mnt);
 }

This hooks up the teardown for the guest_memfd code nicely.
Right now, kvm_gmem_exit() isn’t even there, so this needs to be added.

https://lore.kernel.org/linux-mm/20250408112402.181574-6-shivankg@amd.com
 
>  
>  static int kvm_gmem_migrate_folio(struct address_space *mapping,
> @@ -511,11 +549,79 @@ static const struct inode_operations kvm_gmem_iops = {
>  	.setattr	= kvm_gmem_setattr,
>  };
>  
> +static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
> +						      loff_t size, u64 flags)
> +{
> +	const struct qstr qname = QSTR_INIT(name, strlen(name));
> +	struct inode *inode;
> +	int err;
> +
> +	inode = alloc_anon_inode(kvm_gmem_mnt->mnt_sb);
> +	if (IS_ERR(inode))
> +		return inode;
> +
> +	err = security_inode_init_security_anon(inode, &qname, NULL);

Also, I hit a build error with security_inode_init_security_anon() when
using this in the module.
Looks like it needs to be exported. Adding this fixed it for me:

+EXPORT_SYMBOL(security_inode_init_security_anon);

Can you guys check if this looks good?
If so, there’s a revised patch here that includes these changes:
https://lore.kernel.org/linux-mm/20250408112402.181574-1-shivankg@amd.com

Let me know what you think!

Thanks,
Shivank


