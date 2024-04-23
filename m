Return-Path: <kvm+bounces-15643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB38F8AE5A1
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBBFD1C22F29
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3F384FAC;
	Tue, 23 Apr 2024 12:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lkrjEGQt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2064.outbound.protection.outlook.com [40.107.102.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489E08405D;
	Tue, 23 Apr 2024 12:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713874179; cv=fail; b=b8lRWEZn/qcwW9bUQYTimM34XKFcwaFXX9gBwXvzOweb+r0xxcdie9tiLomjUmTCfqU0LbhwmJgXTblhRDqgGQMl2YmqZxz9wkj0SKayFwWPJ8NfMJEAx3M/ldjVCx8AKLXmJaIVqhbhc6b9RKaLOCJLtIUH6adWPDrXhJ+d8OA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713874179; c=relaxed/simple;
	bh=rJs7QfwhumoQOo+M67VQRMWz+WaG/VO7BRHYssTudrc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XO+fwI0j5e/O49ahKtCxjE7h0eoJDDD0Llm+VLeHrAttV0bwi1kKaO3UWEg0B2NaEsDRQ2Sidp0AjXRkJeUE2APuAvVVXRI+bkxxIsFQVlXJpyPiwpNobhkAUWxAZVrQ5ZlznhXvEAKCb/+Un+FsPk3Cmpp7nmUgieAHMCgbNhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lkrjEGQt; arc=fail smtp.client-ip=40.107.102.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRB1NPXwmR9iUofNheq3aMQN3Ei5Hr8PCHGlmiYBiLf0w+TYsaYmv0Y4gupz8q6BLmtCsbEArM0SkFrrIXpgzLsRL6HdfXR5IQlG6YpfwbNAn26M2jN2tJmOB10ABJsqopI31on2zQgo2zVflOqKtN4aqqoAE+bD12fss/H+rrjeGQRsz3tT5afWxcqxGLWLnjUMvttkCdu+Fm2s5X2FtnTFE7sacL+3wbRzKmt6xKOyWoJRdV/BHe57k0q8TEgLXbUfqmNOf6gpxVBVo34XM0j1DIEc+DgMwFNj9DpzIo1+yzSXdLuilwlRnf3+CaXcDkzjHL6O5Nhhtin3j0Ydbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4L8t9gYgor0m6EFAgFvppv+PPdvWIoatSfgnOocDKg=;
 b=AQzfzKfv00jWIFwPU8CpR/mvk3jyhykO8LTuudGiX4aAom3UpTJVtOhdEZm5jVfsw8DxPSPFV9p3WCtP4lmjqxvbbh+Q/Eed+vRExJzQBz9zeMz14CWkmW0Y9N6gjFSzMyFKVe52GrPJY+H2JgHm97BRj673K/MSyqQqEbhwUB4MK7SSSlE9ucaT31RsDyKkPib0YbqaVFIc3mMvpUHeUhCBeBs5Z50WsRUn7pEI0P6tu+1/io40mN1SXkqNkPePujeu+Kpswl9rKDJjcd5FQZK4zzM7GFklKQ5sFNy2G+YAnKweOCM+eN0uUwmRSBAC1Y+kYDG6idYQ0SJDoZMBGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4L8t9gYgor0m6EFAgFvppv+PPdvWIoatSfgnOocDKg=;
 b=lkrjEGQtTmTKDJTf4FFQf9u7Rqru92LpdxoxPqITkvq7Frm37tMFvT4l7IV0EBycno6l2dZiDWF6JaQFQjnrT73CrAZ977y9qL4htW8D3+eAh2pHZAFiiCTit4SDTR8rHsHbCpM7OdoBHCDXclk76aT/VAMNJQa5haifRACG7+OKW776Xg/lvqqiC5Aq15EaFPxq+3CU3NtJr1qxjX82iaCvVNWIDKADQr7Tu2l4b/ZEoXji2YPMV9HMzn3XPY2xcS6aXaEjxQHRdDgCd1Nmbbmjgd6pOSi3dH9ftowbbcRjOrUQy8mvixH9kkMBKhWuQ1eG6bEdAYXAkWzd5hcCHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CH3PR12MB7546.namprd12.prod.outlook.com (2603:10b6:610:149::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 12:09:33 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%5]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 12:09:33 +0000
Message-ID: <76db8302-e1c9-4de5-8bde-e1d89e225b9d@nvidia.com>
Date: Tue, 23 Apr 2024 13:09:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/15] KVM: arm64: nv: Add emulation for ERETAx
 instructions
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Fuad Tabba <tabba@google.com>,
 Mostafa Saleh <smostafa@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
 <20240419102935.1935571-13-maz@kernel.org>
 <14667111-4ad6-48d2-93ee-742c5075f407@nvidia.com>
 <4c2fd210-fa36-8462-8a4d-70135cc2f040@huawei.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <4c2fd210-fa36-8462-8a4d-70135cc2f040@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::6) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|CH3PR12MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 462e3ab1-c18a-4506-bfe0-08dc638e3caa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDZKWmdDSjRNQ2lqRXlmSUc0dkxpZEhBdjlDM2thYVdBUThNZ1BsYmEwYlk0?=
 =?utf-8?B?NzFSN1ZXL0tOcWRSR1E5bVRhNEt0dnRic0s5YU1qa1ZMWGFjN0ZmKzl1VnVX?=
 =?utf-8?B?Y3E0dmtIWjhrbnRuNnlQRHJ5OGFxTGxiNzRXNVpBbGU3UkgzdmJvd0dCaEpz?=
 =?utf-8?B?NU5kbWt1d0wvOHgyY1Jad0Z3VnNqZzIzekhpb3hLeE9JckFiQjVINFhicGRQ?=
 =?utf-8?B?RWhsVXJmTDZrZDRDak82anZ3d2pBL1BPNmNBUjU1U2lFV3YxRU5VOE1od2Nh?=
 =?utf-8?B?bDY5K2FIVk5CY3RJejRjM3Nuc1VERmh1TnpiM3p1VENqUlJVVVJPcEpqaTB3?=
 =?utf-8?B?bEMxNXk2WTFpY2JZSVpGa29LR3NNcDVVSHR4bkN1MnptYXpHK0hPa3NJcUlV?=
 =?utf-8?B?YnZhclUrbWprNTdBVVNVWlVIUDJaaGtPOVJtL1p6WHFSblJ0SGxtaU02Y29D?=
 =?utf-8?B?MHJ4ZlRBVk96V2ZiTURXT3NiNFFTRDhRbE9aK1FKSzNwUGlpRm16ZjBPSjZS?=
 =?utf-8?B?QzVBWWwycVFFRlcxb0k2VmppSlE4a2pVUERuS0JxQ1g1RVcxRlFWTkc3OUFp?=
 =?utf-8?B?ZWpIV3N3SDlnZ2YwWTBYckRvSlNmVHBQUnBuT05TZGluWDhIV1BJdkd4ak9w?=
 =?utf-8?B?V0lMY0pmQ1Z6cnlOZUNjK0NmREdXS082K3ZVT0dlZno3MG9hSVJjY2QrWWRo?=
 =?utf-8?B?bTdZSElZYUdCUFNqaUNLbWZsMzVHUDNSM1QzaUxxU1l1bnpzdlNNbzFQWXhs?=
 =?utf-8?B?L0FwMGw4KzVWd3ZwTHoyaDhjbTVhdDBVcVpBNmYrS2xqaWR2WEc0cE1yM1ZY?=
 =?utf-8?B?ZXhaRWlsZWQvR2ZnUmxvUGE5Zk9DQ0RvYkN2Z0MyMUJVSmtZdlkvQmNXZS9s?=
 =?utf-8?B?Z3FJR2lobFJnQ3R6emdWRDBZek12NXVOcjlzd216WEZDZFpPTEpzZGp4aCt0?=
 =?utf-8?B?U1RjVWlKMjBXdGphaGtERTFNTVdweG1WNXM3Mytvd1B5UXhXb3R5QUdhYmox?=
 =?utf-8?B?cklDaEZ1WmRucVhqeW5zcEhNM1JmRytFdk1HOW5XT2RqajNyY1orMmF4UE5K?=
 =?utf-8?B?b1NvdSt5bUp1TkF5di92ZTE2eHc5TWt3eVA0Yk96YVAyVXN6SW5oOE8weW40?=
 =?utf-8?B?R3VPWm1VTFg4VElPak4vOUtvdldLNGRxeUFpWkw5QVVyRGNkR2ROYmY3MU5F?=
 =?utf-8?B?dFJkVy83ZnNzNFM0UzlubmdlK3Iva2ExNVVoMDU1Wmh0b2xsU0JLUzU4Ny83?=
 =?utf-8?B?ZmlvY3BDbnQrL20vRGlXSVJ5M2hYajVNYlp1TTJYWSszRmVzM09tbUp6M1Z3?=
 =?utf-8?B?WVFrNGZJajJxTTg2dEc1b1B4Zk1YRWpSWnlwbEJtQ0hNVE9RbnhLck1qNlh3?=
 =?utf-8?B?bmtZcXJicWRjcnBHak5sZVZab01JNzFzQkdUbmwveHNpSlgzTERQK2hhdDZy?=
 =?utf-8?B?NGZGTDJrc0IvSXZKemxsNEMyYlVsTWdOeGNEVVg3WlRzeGxINldnaGNmam9M?=
 =?utf-8?B?Mnc4amhrZjlLVy9jVlRkQ2tiRUgwOTI2cUlWc0gzQzhkQW82S2h6c2svU2lP?=
 =?utf-8?B?TkJZUmpzcDlZZFBTbStrMW40b0doRFpIeVJ3VFdHTFVMWTVtQzY3ekFYQ0Ji?=
 =?utf-8?B?UkJ3MFo4N1pBM2hvSkY5dmdVcjl4QlplNTQwMnZoMVl2TFAxM1FXbDVreGVw?=
 =?utf-8?B?OW5DK0xrZ2YzK1VEcjVYYUtpWGI1MVhtek5LR0RWMFoxWDc4WWR3V3NBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bThjYk9FN0NCcEo5WlhqbHVKdVpEN1RQN0RldGJSUTBRaXpvR0xpd2RaQnFK?=
 =?utf-8?B?d1NBdGdvQ0NuNTlpOHZkZXFLRHQ5Z1pNUVlQSUZra3pMWlhUZVJtNjFnMy9K?=
 =?utf-8?B?TEJXSUVJYnBJengrUWpQQk9nd05hWUVYZXIzK2ZUdlRjTEhBRE1uVVVDaTZx?=
 =?utf-8?B?TUUyN0JQQ212cFZpc1JKM2QrajdoR2tnc1B2V1MyZXJ6WXpVMFBqRU16U1ZO?=
 =?utf-8?B?SUYvN2psSTFhTkl2NnJvYzlCRUYwaTArYVgwR3JRcGwyR25SVWJuaFkwYWZK?=
 =?utf-8?B?U08vbkJ3eXVaT1ZUZHJsWnQyVTQzMzVDbnhpYlI0UVFoSWhKNWRZbUl4alNi?=
 =?utf-8?B?N2taTzhJcWUyWEFsSTV2KzNTL2RDVlJxWk5OVCtNMDlGQmhIWUFzZkY5blcw?=
 =?utf-8?B?aVVQQTJjOWgwWVZiazY0c2lFYzU3T0pTWG5KbTd5OEtDanFRQ2k2SGdXMkdu?=
 =?utf-8?B?VnI4blo2THIyOTYvRHcyOVNSWHo3eTFmUXNJZ1MrQmRCOVpQUFZ1Wi96czln?=
 =?utf-8?B?OHc0R3V2UnV5ZmJSbWNvM2J4U2xDNjI5V1I2ZkpoRE9OblVyc0xMMHYzN0Z3?=
 =?utf-8?B?cGhMdFlBM1ZTTUtyczBiUitZZjFUQ2RJWEZPamJNYnBVNmc1cU0zclI1Ukhx?=
 =?utf-8?B?T25ucllBWHdhaWFzVEk2RUZPbndBV3dLRzBRMVRVenpOY0FNRHYxaHR1bGlu?=
 =?utf-8?B?QS9SMmJ6WHdHWTZaZm1uQ2NYZUoranl0dmM0M3RTbHM2Ty8rVGY0UVJrc2VH?=
 =?utf-8?B?STgvMHNNSjV2STkwcGdaa2NvMWtVd010em1NRUgrUlRxUzhRQWVFOWd0Wm0y?=
 =?utf-8?B?TEhJclkweGE1OHU1aklJaktrUk1yeTN1cGp4TVl2NkV0NXo3WFBFeldxUS9V?=
 =?utf-8?B?Z2ZFbGpYa1Brc0hFZk5xQWFiakVaMTMvZFN0Y2k0UFlVbTF0MWpSTFdhbXBp?=
 =?utf-8?B?c2JkYW4wMkVvZGx4b2I5bUVPTnRLZExpTUl4T2kxUFlKZm81T2NKT1JvK01N?=
 =?utf-8?B?QndiaytyM1lZN3lWc20zb1ZSblVHVjBDc3RvNGIyZ2R6Wk95ekJIUzVrb0Zr?=
 =?utf-8?B?RXNSRyt2U05tblZwNzhkRTUrcTJ2NGtXcWROd0c5UkpIVzNtZUZudkpSR0xY?=
 =?utf-8?B?RWhaNUhkYUd0UFRXUVMyNGFKVC9yVU5wNTlVSU9WNktkclExcGdjQzc5aU1P?=
 =?utf-8?B?SmZTb1VVMWJmRlFkS3J0eUt2cFBIZTFFRzBVdW1YQS9KcVRieDBCSXJyRkNV?=
 =?utf-8?B?bHE5TjE4ODk1Y2tCd0FPWE96N1BZRmZ6Um5pZ1hyZWNZR0llSHdHMTNsUGxI?=
 =?utf-8?B?TXFjeno4dHl1Y0Uvd3R5K1I0NzFuVXNQcGx0VWlhZDcwc2RZNjRzMFlwbEs5?=
 =?utf-8?B?M1FjSmZBQjFpYlZtRUoyRE9kTTRaNVl0VTNIU0Rpc0cyV2JTMng1QXhRbWtL?=
 =?utf-8?B?QTc0WUh6RjhkZTgxREMxZFA5THMxYUF2WTEzZytGZ2hWU2J4c2trRkhSZmhC?=
 =?utf-8?B?SUNlSHJvZGZ6ZSt6N0pLTDNWUE4zMmxIVjVndFRoQUVCOVZmaWljeThmdEFG?=
 =?utf-8?B?YUc2N3E4cU5QRWV4c0RWRGtoMkd4UUZQTG4vL2t6M0FVemFwcDBFNlhZMThR?=
 =?utf-8?B?MlZWanpma1EweGcvWHBaZXJYZDJyeWtBdnMzaEJFSTllYWFvOU5zZndNeGtK?=
 =?utf-8?B?blBJYjJKUFM1L2VOdFIwMEhiL0JYSkh4ekN3N2xjVHZUa1hiV3QyT0Jld3Qw?=
 =?utf-8?B?cFBIRXo2TGFjK1pvMUxqc1hRWHlLZDgyZTJHQWJnWFp0N09jTk5Dcmcvbm9C?=
 =?utf-8?B?aVZIamF2SDlXME1MWk1YbzZUVm5DVGJGQzBOdU9ZTE9URU0xNXVWTUh3QjBr?=
 =?utf-8?B?eXJHbXA3dEFGbU5aR1MrVndiNjhnMFgyQWhPSnE4Smd0SU5YMlpLTHJpaGsv?=
 =?utf-8?B?VWlmUXFzVDJBNmw4aXVsSEZkRzRlTmZHTkFjYzNFUDJSMVlqSjBsWnJvSDJ6?=
 =?utf-8?B?QU9sMDV4VXpPcW11MFh6aTVnTDZyUEdCMTllUk1vcmV3cEpKN2R4VTdGZHJR?=
 =?utf-8?B?eVhmQ0oyY0hLN1ZBSlJGbWJsTmo4RmNUTlppTzdadE91dmIwRTU1ZlR1Z0VE?=
 =?utf-8?B?T2ZjQU9kTTV2Z3pmKy83bkZBajRrZUZaWkVidm0zdWRWK09wNzFZcUplU0hG?=
 =?utf-8?B?SjdTV0pLbGViK2sxbEYrNUVRNXRwYVdnMGpaTmpOUlFnOHJ0a0JBbk1yZURw?=
 =?utf-8?B?SHpLdHhyQ0hUNU9KT203YnAyeDRnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 462e3ab1-c18a-4506-bfe0-08dc638e3caa
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 12:09:33.6294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivzOy8ldLz0f5DIl0uN6/+i2pCQgirnVaMpPExdTl5IWh5TJTamIWPWFu7zORQLPa+zAFeNDi64p4iKHM+FxDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7546


On 23/04/2024 10:40, Zenghui Yu wrote:
> On 2024/4/23 17:22, Jon Hunter wrote:
>>
>> Some of our builders currently have an older version of GCC (v6) and
>> after this change I am seeing ...
>>
>>    CC      arch/arm64/kvm/pauth.o
>> /tmp/ccohst0v.s: Assembler messages:
>> /tmp/ccohst0v.s:1177: Error: unknown architectural extension `pauth'
>> /tmp/ccohst0v.s:1177: Error: unknown mnemonic `pacga' -- `pacga 
>> x21,x22,x0'
>> /local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:244: 
>> recipe for target 'arch/arm64/kvm/pauth.o' failed
>> make[5]: *** [arch/arm64/kvm/pauth.o] Error 1
>> /local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:485: 
>> recipe for target 'arch/arm64/kvm' failed
>> make[4]: *** [arch/arm64/kvm] Error 2
>> /local/workdir/tegra/mlt-linux_next/kernel/scripts/Makefile.build:485: 
>> recipe for target 'arch/arm64' failed
>> make[3]: *** [arch/arm64] Error 2
>>
>>
>> I know this is pretty old now and I am trying to get these builders
>> updated. However, the kernel docs still show that GCC v5.1 is
>> supported [0].
> 
> Was just looking at the discussion [1] ;-) . FYI there is already a
> patch on the list [2] which should be merged soon.
> 
> [1] 
> https://lore.kernel.org/r/CA+G9fYsCL5j-9JzqNH5X03kikL=O+BaCQQ8Ao3ADQvxDuZvqcg@mail.gmail.com
> [2] https://lore.kernel.org/r/20240422224849.2238222-1-maz@kernel.org


Thanks for sharing! That does work for me.

Cheers
Jon

-- 
nvpublic

