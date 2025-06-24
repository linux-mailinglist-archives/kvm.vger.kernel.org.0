Return-Path: <kvm+bounces-50442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F541AE5957
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 03:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C95F48018F
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 01:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD8B1DE8B3;
	Tue, 24 Jun 2025 01:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LqLRI/bW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC41E19CD01;
	Tue, 24 Jun 2025 01:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750729379; cv=fail; b=WKqd5p0ENKaIgCURrV21ss0n46jt7H/mswt1VqJWWRZ8Fp81cdvk8/co5sr6W6P2OeNkPjJblJAlDu8XdxDxHYpG0qlgzSFS9Bw1UqS97L/uQI4AbGWVamki9KoCbULNKgCKvo144WinoL1R69ccrGDgjgEvcr6mI3srsxJL120=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750729379; c=relaxed/simple;
	bh=RGROFycoQ93rm+ZgwmFqbVuEA/Xf9Z/8YqHMPQBteZA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bKWiE0aUnN/3LQ95JFI/ULJ2vfk++Ax2JLqqyPnR38bhgRUH5yKRHhrLoFEU669AGT5OQAqix6lPNXTlTpeCRMVldX3po+qx6/Pnsq3hmy1gQBEbpdkK6LuhvfOO3xDyAr15MMUmAlX4MGlw0ZhtCYDPeNUUi6efuVSTkimJcn4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LqLRI/bW; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LWpSGRODPsvRWg+8qwfwodhrAQUcGUHBTHgXQk9p3QFv2uNhMz0MLVi/74BYpyi0sJcLsMcqOPD7A8CAca8Zf4EcfrOwaX2s3gII2Bj3TT7ZDRnT3M/UHoCBmVNllGjgpopvKYWMXffG45r+TNEsm1D0tyfOiVOIVxr5DBg53ZVnnJ9oYl0yMIj9eclQPK+DZyqndnxAjqQqg5vnfPfvwEvGBDVzjXgpbKw23nMu5NfsiM4upYRYF8bIZuAwIJtsqd+TCd4c1VikXb63C1soyUVoPVP9XWTETAgAY9xUZkS5fj5C2asShEKgvH5i4r50m7x8tL71+jLPKnXR/CaF5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrrcNtz+1B7DgCLcVyuu1S0O1xGRonbINXsJUmvY/8U=;
 b=ZUfppuYTHqjvq3FAjmKmaN2TqDjizOspmlyFBfGuuMxHjPH1R26jEqwTcPvf+vMeWGWwsTGBCLv+Lc2i2aBBX8HPTB0Suwn6ctboGfvOpMU66MQdeI9hvj/VPjnvLN0egjKfHSi1/elOBxEhDO3SU1aWMHRVip+OBvXF2U/x8Zbx6Gkav99/rLlqPuHFCNDUp5WM9EPr+W7tIgDqZwrUO6uZs7esXrcv8Wpdos40q8EF69eGKDZevFBpxo7iHujJR9cciV+fsHLoLf9npt3HQGx8OXOdDGT+h4WIHlaHWRng+t/yw0+Kk4PIGMFne7FmZrgrmMumaEF7ESQ4yDhOzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrrcNtz+1B7DgCLcVyuu1S0O1xGRonbINXsJUmvY/8U=;
 b=LqLRI/bW/XNaEHnigTzBqTlWjNvQPrlP+6lnsPbBpX+znMT2953M/b36S3EyxqWTMTW3v1JH0jodS5o0QJwYATMb48Rae7fqwTIO9HyqFjrHAg/lgtXZShABqqLbqMigaAndRB1NwDlzLgxgjy2geVFFwttWDBfPF8UJcOUJ8SQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM3PR12MB9287.namprd12.prod.outlook.com (2603:10b6:8:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Tue, 24 Jun
 2025 01:42:54 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%7]) with mapi id 15.20.8857.019; Tue, 24 Jun 2025
 01:42:54 +0000
Message-ID: <930fc54c-a88c-49b3-a1a7-6ad9228d84ac@amd.com>
Date: Tue, 24 Jun 2025 11:42:47 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH] PCI: Add quirk to always map ivshmem as write-back
From: Alexey Kardashevskiy <aik@amd.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
 David Woodhouse <dwmw@amazon.co.uk>,
 Kai-Heng Feng <kai.heng.feng@canonical.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Santosh Shukla <santosh.shukla@amd.com>,
 "Nikunj A. Dadhania" <nikunj@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20250612082233.3008318-1-aik@amd.com>
 <52f0d07a-b1a0-432c-8f6f-8c9bf59c1843@amd.com>
Content-Language: en-US
In-Reply-To: <52f0d07a-b1a0-432c-8f6f-8c9bf59c1843@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY8P282CA0025.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:29b::30) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM3PR12MB9287:EE_
X-MS-Office365-Filtering-Correlation-Id: 10b27cf4-44f8-45f3-895b-08ddb2c06fe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXJaVDFkTC8weXhOK3VJZE5oSUUvbkliQ2ZZRVdRVkg0N09xMjc4aDFuaExQ?=
 =?utf-8?B?Zkx3c2FxTlZuNExTbml3cmpHWklHN2xOR2FETnhITm5tc2dHTHRhNGpNOW00?=
 =?utf-8?B?VDBDRjN2S1IyNmtJOGhZOXpKekxnOWVlNUtuaWNXTFE0WTVFQjdwa2k3bzg2?=
 =?utf-8?B?aFkxOURYTWF0bXFWaHlBZ3ZpV2pVTlgxU2QvazhGTnJMdHJiMHlTWnhsSDk3?=
 =?utf-8?B?OHFPV3RtNnI2OEpnbW45dUpVVWZPWTNjaVJqaS9INVBZYUJnQkdYOUY3RGNr?=
 =?utf-8?B?eDNuVEtoRDloaHk5cjNiMy9wMThIQXErR2k3dnlnbHl2aVVmQ2JHd1loWU9J?=
 =?utf-8?B?c21teG9mbmVkaDJvRDVwdzVEOGJ4OHdTamV2RW5Xd1BnZEVicCtsck5lNHBM?=
 =?utf-8?B?WGxjdGRpcGh0M3Q5akJwaW5LRWlYK2ljaUFuVGVZL2s1eVE2anBUSHRjdXNH?=
 =?utf-8?B?MDlRTXhwWXpFcnhwQkVJWW1uSWYxQmM3elFQVm9YeDlFcllNaG9rU0hMTDZw?=
 =?utf-8?B?TkFJaG9vREUySkplZllqb1IyTXhmRjB5ZVZDS2hobmJmUGxseW9EcDhJMXJr?=
 =?utf-8?B?Q1ZaL1BEUDkxNFp3SCtWUXdkV0tnMlh3dFhnTVBkazJDdGJTYzdUS0xYZnZI?=
 =?utf-8?B?WDR3RHJSNktkY2pKeTY3a2s1eWhIWkdYdlZiSHdiZWQ0MjBVRFBZYkVsMitn?=
 =?utf-8?B?TU9FVjVxNjdqbG9xK0tlU2RveXVuMGUrYnJlVlhXUFVMMTdIb3FVOTJlL3hJ?=
 =?utf-8?B?NEQ3NldyZDFCTUhQSER1RCtwN0NQcUlIMVRXVzF0eVhsOUh3UjE3M0E5V1V6?=
 =?utf-8?B?RnUxbjFQYjJPS0pJTlZ2UDdqbUZsMW1iYkRsOEg1S2t3U0lxMkZYNGhieHUx?=
 =?utf-8?B?Z3Y1cDcwNFJQZE1BUnp5d3lWNGRTbE1FRFFXajhNTW9JaHNUWkp0NE5xd1JN?=
 =?utf-8?B?bVhIZXk4T1dxSWNTSXVCbGRaOEtjVy9Ja2g1eFRtajBQT2F5MjB6MzJqMGNU?=
 =?utf-8?B?dHE5QUZGME4wYnpTVXpDYUQvcUhIbnoxaDNxQkFVTlBPc1lGNVpLWm83SG4v?=
 =?utf-8?B?WTIxRFI2Tm1VUm1nRVRjN0d1MU11dm5DcWNKek1UMi9kb2dMUGZsWWNSK0dC?=
 =?utf-8?B?ZTF5Mi84c2lZVzJabHlyeVhZQ3A3R1JDK1k4cENHRkVsSVFaaHVaemhSYWY3?=
 =?utf-8?B?R2M4VFhqY3VHdlpPZ1FDSHg1c1ZpSkVjWUNhc0lkYnc5R1ZxR09ycFVEeDdU?=
 =?utf-8?B?TFRhR3JiY0lpY0NtSEtEOVpKeXdUVWtidTdJNS93MUxZOUN2ZkpNaDUwZ2NT?=
 =?utf-8?B?SGVEY0xBTXhnbmhCYmVGYlNSZWxjSFhxOElScUdQRjhqRFU2dms0RCswdzlr?=
 =?utf-8?B?VmRleE9mU1JNcllCN2ZlY0g4Wk1OamdkUVNyZ1MrWThuMWRYVnZUcUEzTXUx?=
 =?utf-8?B?MzNvYVkzUS8zd2N0VDZMOGVNNVFCNkIzc1V4U2x3Q1NXYkJBdXVMVFJlSjRR?=
 =?utf-8?B?MjM3U2h6aGIrUUgyYUIrRkFBVm9UMjU3YWQ1dFZ4NVkxSGppQ0dWSncyU1VG?=
 =?utf-8?B?Q1ZWWmdSajlBMlRISkt6a3ZFYi9vRFBHZkdGSERZK0NvVkVodTRMaTlya3Ft?=
 =?utf-8?B?WXdhMStObDVVUUlINGgwVFplM0ZEcStWc3ljTzJ5L0ZyR3NiQUFYOXVnL3Bv?=
 =?utf-8?B?OUdMejdndUNtTDVqc2JrZktJUUhrR0YxSWZUeFZ2M2ZPNEk5bklXdVBWK0s1?=
 =?utf-8?B?eE11RHV0eE9vcmp0bWNwUHZYcFk0aXkvV3hkU01pTkRDREhjaER0dkpRLy9h?=
 =?utf-8?B?TFZpWlI0aERIZ01jRUh4SzIyWWh0akxhdlRIR3FuNXhHdTNkckt6K3NaQ09C?=
 =?utf-8?B?QWNicGE5dTFMdCtRVTV1Umx2T0g1RFl4Rk43MnV4T2tmT0RRSUZWa0d4WERE?=
 =?utf-8?Q?HMaTJCQTfpQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVJ5dXNERk9KYUZ4bUphZW80RUpRRzNMcmNRUFBHaVMxNHp0eTN1eElVbk1S?=
 =?utf-8?B?Y2NrWElPd2d3TWM2RDlnaXJOSjFHc1Jjemt5QWsyOG55UUpUS1lNcUo2QmJR?=
 =?utf-8?B?aTQzazMycFhxZGkvcllJblpVcDZzbmsrb09pNC9yVnA1aXB3dVJRS2RJK2lK?=
 =?utf-8?B?QTBzWWY4QUloWC85RVZ2ek9hZ2ZGWUxkUkNtcS9FcEUxNXMyRlpQQ0hRUHBE?=
 =?utf-8?B?b0xGbEZSdng5bU1VcFduTExFNU9XdzFQOU8zTjFqOXpDOGVsbElLMlJsc2RU?=
 =?utf-8?B?Q0YxaHVwTFdtK0FCazY0UU9MZzlONW9vNGxaN3Z1d29DNzROWVU0UnM4bFVK?=
 =?utf-8?B?OEFwTG5sME14Mk5SQTJ5dFdpK0lkY2YxTWJFSUdSVUZZam1rNU5Mb3h1RW9H?=
 =?utf-8?B?ZkFWYlFla3JQZVFpSUtyOUk4Q25iYkhMNVU2bk5Hbm1IR3VEb3JXOUpySGda?=
 =?utf-8?B?aHNyMnRpUWdSN2E0cVQ1YVQxdlFHRW1jd296ZTdQeDVUYTN5L1lYRXdvQjAw?=
 =?utf-8?B?TzJLdnNmSm5MbEw2bkxtdTIwbitxQ3I3UmR2cWFxMTk2MENvNkNUWmErUDda?=
 =?utf-8?B?dlZwZ0FFRVVSMG9pZm85dm11VGQ2OU14TmVPWkNhcmZWeU55NndzcXJwVXVR?=
 =?utf-8?B?eFdJM3ByMmtKamFkZWpJZmd1a2djS3lSRHUrY3U5MU5IcEV0TnRtUWE4SU15?=
 =?utf-8?B?VzVjZE5McmM2T1BkMzIxZ1Nod29GdElueGlSb2tGYXVNYmhIM05kOHQ0RnYy?=
 =?utf-8?B?TEpXWmFIbkkyeGZJSHBLbkJKM003dHlDUlVxaFFEOEMxMVlwbE5LNG9LdVE0?=
 =?utf-8?B?a0hvbGNRYnVMdFVacUVSYnBqTEtPbkUxYWhpWWI2NEFJVGJoOVhEZDBHNjMr?=
 =?utf-8?B?RzhDL1dRcERGVElMTDV0enJsU3kxUmtDMldMZ2pXbysxNVBmOGE2YUhJRXpL?=
 =?utf-8?B?MXpxWGd2aWhyV0xhNDJLOEVwVzNmcUxzd1d4NzB3aWNzL3plc2tCcjZHZVRT?=
 =?utf-8?B?VytTaWVRdHRCTjRCUXlGelJTRDhySVV6ajFFdDllclpodlhmeGVtcFdjQm5N?=
 =?utf-8?B?STFhVThIa0RGQml0MFJOZ0RTejhrK3NqZVRsNnkxVHFaKzJOR05Ib21xNDl2?=
 =?utf-8?B?Q0lXajdlNkl6RkNsMWFzQlZVZjZ1d2V0RmZyNXQxZG9xeFM2OUxKWmFpN1Nq?=
 =?utf-8?B?YmQzcEhuMW9VQVduRXFnV3poTmxYWmFFVjhtb0pLZXB6MnVFd3FlQUJqR09i?=
 =?utf-8?B?ZThEcFZJOHBrY01URk5BUnFsOUtkSHI5dFRJUG1tdS80VGRlOVJsTlBVanhY?=
 =?utf-8?B?Z3BnTThkeFh0TmMweVpTSUh5VThwQUQzT01pUW94NHdlVmYweWdITkJ6UWQy?=
 =?utf-8?B?SFlaY2hLUVFON3dxNHJXM0JhdGdRUU42NFQxM2FhR3RLYUtwemVpR3NjWVpZ?=
 =?utf-8?B?VUVEUThmNy9LRTR2WVI3ZGdQRWh6Rkk2OTRzVmI3OXZJTXpFbGpQMGRIQ0NV?=
 =?utf-8?B?RXZ3SmdWZTNmMGd1UndoRkxMR1NhU3I3cm5odnNwbzFqV0lZZnNBNjkwZ1lZ?=
 =?utf-8?B?MWZMay9HUmtOUjJ4ZlV4SmRGcEdLeDl5SmNqR002YkdkazR0amE0TmVOR0xW?=
 =?utf-8?B?dC9NNkNyVnFFNUFiWVZvK2psR2NDb0JZcVIyUytTNWZCenl4aThHZUVBL0dz?=
 =?utf-8?B?WWVod1d5a2dQZzRxa0xOYWhESmU2SzZFRUxOam1BV200VnFNMTRGc25HR0Zs?=
 =?utf-8?B?TkgwQTNqYS9VTmhwcTd4MHlSSVo0c1ZnclJPZ0grVllLOXNXT1JpSDcwY0Y1?=
 =?utf-8?B?NzlMSzhLNEZWQVJHVmx6WE9RQSsvTkRSclFzdVNQVm5peU5YQi9LdVVsRmdx?=
 =?utf-8?B?YWlXN2FrN0R3QzJMMFcyYzUvM3FYRzB2V0p0WXJGTWxWMDkvdk9PZlBzNHRW?=
 =?utf-8?B?bnJWNGVlVytpUEpJYnpIbkpMT2NMTThjQWx4SWwxVXU4ZDVIZkdFMzk5dWNQ?=
 =?utf-8?B?NXRKdCtMbU04VERhT1ZWenBwY28wZm1jN1duQndRQUpxYWt2Y0w1NzAxelov?=
 =?utf-8?B?bDRWMzlkdDhvR05aZU05U0lGTG0yTmdLQkxLZFk3T0NzNVlDMnpCVWtNTGFo?=
 =?utf-8?Q?VPbyA9BOjMMUzrOAdx4G3FZes?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b27cf4-44f8-45f3-895b-08ddb2c06fe4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 01:42:54.0700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tiongESJxVf6Uvj/1wyRAlAWVF2WwiHuaZXVIixc4iDzn8VvSERoFjbAHak8/BP6tPdtA92oIZ4Ta0rd5uvSGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9287

Ping? Thanks,


On 12/6/25 18:27, Alexey Kardashevskiy wrote:
> Wrong email for Nikunj :) And I missed the KVM ml. Sorry for the noise.
> 
> 
> On 12/6/25 18:22, Alexey Kardashevskiy wrote:
>> QEMU Inter-VM Shared Memory (ivshmem) is designed to share a memory
>> region between guest and host. The host creates a file, passes it to QEMU
>> which it presents to the guest via PCI BAR#2. The guest userspace
>> can map /sys/bus/pci/devices/0000:01:02.3/resource2(_wc) to use the region
>> without having the guest driver for the device at all.
>>
>> The problem with this, since it is a PCI resource, the PCI sysfs
>> reasonably enforces:
>> - no caching when mapped via "resourceN" (PTE::PCD on x86) or
>> - write-through when mapped via "resourceN_wc" (PTE::PWT on x86).
>>
>> As the result, the host writes are seen by the guest immediately
>> (as the region is just a mapped file) but it takes quite some time for
>> the host to see non-cached guest writes.
>>
>> Add a quirk to always map ivshmem's BAR2 as cacheable (==write-back) as
>> ivshmem is backed by RAM anyway.
>> (Re)use already defined but not used IORESOURCE_CACHEABLE flag.
>>
>> This does not affect other ways of mapping a PCI BAR, a driver can use
>> memremap() for this functionality.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>
>> What is this IORESOURCE_CACHEABLE for actually?
>>
>> Anyway, the alternatives are:
>>
>> 1. add a new node in sysfs - "resourceN_wb" - for mapping as writeback
>> but this requires changing existing (and likely old) userspace tools;
>>
>> 2. fix the kernel to strictly follow /proc/mtrr (now it is rather
>> a recommendation) but Documentation/arch/x86/mtrr.rst says it is replaced
>> with PAT which does not seem to allow overriding caching for specific
>> devices (==MMIO ranges).
>>
>> ---
>>   drivers/pci/mmap.c   | 6 ++++++
>>   drivers/pci/quirks.c | 8 ++++++++
>>   2 files changed, 14 insertions(+)
>>
>> diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
>> index 8da3347a95c4..8495bee08fae 100644
>> --- a/drivers/pci/mmap.c
>> +++ b/drivers/pci/mmap.c
>> @@ -35,6 +35,7 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
>>       if (write_combine)
>>           vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
>>       else
>> +    else if (!(pci_resource_flags(pdev, bar) & IORESOURCE_CACHEABLE))
>>           vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
>>       if (mmap_state == pci_mmap_io) {
>> @@ -46,6 +47,11 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
>>       vma->vm_ops = &pci_phys_vm_ops;
>> +    if (pci_resource_flags(pdev, bar) & IORESOURCE_CACHEABLE)
>> +        return remap_pfn_range_notrack(vma, vma->vm_start, vma->vm_pgoff,
>> +                           vma->vm_end - vma->vm_start,
>> +                           vma->vm_page_prot);
>> +
>>       return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>>                     vma->vm_end - vma->vm_start,
>>                     vma->vm_page_prot);
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index d7f4ee634263..858869ec6612 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -6335,3 +6335,11 @@ static void pci_mask_replay_timer_timeout(struct pci_dev *pdev)
>>   DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_GLI, 0x9750, pci_mask_replay_timer_timeout);
>>   DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_GLI, 0x9755, pci_mask_replay_timer_timeout);
>>   #endif
>> +
>> +static void pci_ivshmem_writeback(struct pci_dev *dev)
>> +{
>> +    struct resource *r = &dev->resource[2];
>> +
>> +    r->flags |= IORESOURCE_CACHEABLE;
>> +}
>> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1110, pci_ivshmem_writeback);
> 

-- 
Alexey


