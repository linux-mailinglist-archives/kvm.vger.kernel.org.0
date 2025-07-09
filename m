Return-Path: <kvm+bounces-51897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 571F4AFE2E9
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2223517B987
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C11827C178;
	Wed,  9 Jul 2025 08:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SRRWxzoF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20F227F007;
	Wed,  9 Jul 2025 08:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752050377; cv=fail; b=hXXEbXB3GD5FaIfrQi0Hge69V2HMcrxv+eR6NGHqyRALt2c4M4rOECDCl2x1s1aDlpZ+YdqeF4pa0EFgBSvTCiXkSTVIjexNTbA52pcwRQr7+C9tt6XM7g8Hxji/EOk5dmSIEmpMYQh62mXwhsGF0S0SqoKRSXtR7BJ62Jbws/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752050377; c=relaxed/simple;
	bh=65lBHr4nmUOzsrkQ90wUrE+1tQcQv/SYeQnlhtadDbU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XkT0M0C30ZqTbv6n9nG/Gus8Jx+pUSXwIuOC57sUulJ/M4EqY9+kqdLWIjdmQtC4ap+epI77ozTf17GKje/lUeTBCsXL+VGBrsjXHxY0P5xGlcoY+dOlSEftZLvhOV/BJSaPgrKT433t642YTxeCOh892dfg8xz57eqyP0Lv6RU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SRRWxzoF; arc=fail smtp.client-ip=40.107.101.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t7mNgzTzoRKGyolB6X5AyRyFOY71Pggl5b59O0GXg1epD4fnTVqBszA6eWDMAsmw7ezNpB/ZY+1S7k/Zj93onNFhOWmvy/7BwYQZCYj02UxpMPquRg+TX011FyiVNhaFtcOUV428wRzPLfVKT2D68UUshmOTg8DxrvNO8JRY4JgIZLoslsKWbwAUPHxYwgz27zhbIKGQGYv8FkLFhxTklg2fnfTIDlBNupSe0ry6WLjaw+E7XetdXUlqTghF2Dj9/2Lk1RihM3EUfU3ik5Xq9/1W2sTqY6VAz6vgQkamdSiH8+3wciFmaMmGOWxzX8IUaoyYfxX7f/cB0fKhwNkH9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gghg7NN/WIp1q9qEtaU1jRgNiKFw+F2Ze2faM+rTJTU=;
 b=J5GZq3hPDeECG0c2W98hDecZE1HtfohTon3yzEfGexu6ySrhdXRCctrlTUGL91miozXQkhKks4+bLmq/Vz/mgQmMhbttDUOK668H9MDHEsNvTIXWZ3zvi7kLItqxJwghobFT23h0XfckwhXOCU6JSrQQ3SF9f4ZlxGDR4gEO5buHP6xWaZDp5vcB5dFWQWbT+t8KsLZjiJ9hVRkX8MwG43V0kSAskCqpjJEze/c8vz5Fm/LrJ022tyitAHV0sy8TWJYVufD+u2xos66HvUCKnCyQjczZLt64EXTYltqjE9yn9MJKOfOUgKIGl0afl7Dc/b35iqDiion5F2FEfRGSGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gghg7NN/WIp1q9qEtaU1jRgNiKFw+F2Ze2faM+rTJTU=;
 b=SRRWxzoF0f6/f4n5e2iSllTpMBSTZMJa7DU9zRy7SOhNBslOL3NhxW3miWWBJg9qqtuAVmGqK6AlPCeC9Inr3WWdSgioMzuHCXx+cOcfXCkEKWD2HryelCZoDbA5u4U4uPFnFHOWyCIxRMo+8DbuLo2So7xcfO7DH3UHe1lIx9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by CH3PR12MB8909.namprd12.prod.outlook.com (2603:10b6:610:179::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 9 Jul
 2025 08:39:32 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%6]) with mapi id 15.20.8901.021; Wed, 9 Jul 2025
 08:39:31 +0000
Message-ID: <e3da1c7e-fa47-415f-99bf-f372057f0a75@amd.com>
Date: Wed, 9 Jul 2025 14:09:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC
 protected guest
To: Kai Huang <kai.huang@intel.com>, seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, rick.p.edgecombe@intel.com,
 linux-kernel@vger.kernel.org
References: <cover.1752038725.git.kai.huang@intel.com>
 <8aebb276ab413f2e4a6512286bd8b6def3596dfe.1752038725.git.kai.huang@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <8aebb276ab413f2e4a6512286bd8b6def3596dfe.1752038725.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0126.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::11) To CY5PR12MB6321.namprd12.prod.outlook.com
 (2603:10b6:930:22::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|CH3PR12MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e9cdd9b-f935-465b-ef97-08ddbec41f50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHNMdnFheW4vNGxvKzlDcVcrUFBWR3Vxb2xyeTZCZjMxbUFqZFVhOHcwRFlP?=
 =?utf-8?B?OXhxWWYwSEg4d1dzTjBGV0hmSjVSdGtjaEJXcTNBdGp0YlZTVm1JOElIaVls?=
 =?utf-8?B?dHdVM1AyZVVnL1VpMWRIb3dVTk16Y1QwdEF6cmJtTjVzZUxwMmNZMFlxRVNp?=
 =?utf-8?B?ZFRjTHMybm85WjdpZ2puMUlWbUp0a0VzZ05tekVSeWp6UVdPc1BxVmozZmoz?=
 =?utf-8?B?bk5LMm52cHloZjl3TjUzU0FwVXl0eFkrQU9aS0NjVnVTbm1HT1JrdlRmeFpM?=
 =?utf-8?B?QmhHZjl2ZWRlSTlHemtuUHNGS1dPamd6YnVZcVFNaTduekF2SmNQYjlhc250?=
 =?utf-8?B?dE9zNjlkU2ZGcUUvd0N3c2tPa1VVWjR1cFZQWHM1cElFdkI2TytGTDJRcjVM?=
 =?utf-8?B?VTF6OG5YSVRBNWhrUnYweXhBc2ovL0EwdDErYmNrcUpmUkdRdzdMcTRGalJG?=
 =?utf-8?B?VExteE5leWYrVEg3a1BwTUdMdDlndWVPU3VWdGxpYkNjMXZEbEdqa29OVktq?=
 =?utf-8?B?ekQvRjQwZnpkUk0vMHMyaUNrdHQxTml0YldUYmdBM0pmVlg0YmpoQ09Rc0hH?=
 =?utf-8?B?aGVPNlJ4Y3J1TkRjL20rM3RqeXVOenZsZ3BpOHVrZUdxS1BLQ25Zd3lIanRG?=
 =?utf-8?B?dy9vZmNrM1puTTdBeWl6Q1ZZNTRNT294TGgrUC93Q3lGbW9qZzJtSjhnWWZJ?=
 =?utf-8?B?b2N0R01xWjcrVUtERzJIM2RLWHRWYXJkcWRET0RZeVhoNXFSUURuZVhqZXBl?=
 =?utf-8?B?QUxnZzVJS05ab1Qwd3dZa2p0bUI5Tis0a2ViWGpSZGxKVWlNdW95ZUQwT2ts?=
 =?utf-8?B?SVRtSFdQSVpWMW4rWkxTVEJqZVZkODA2M2dEeXgrdzRVdHZCeENJMUVnelU5?=
 =?utf-8?B?RXBiNlIzU1dXRWNaTWV3RG1WakV0VlY4Q0ZIbGZCMVNld3ByeERzVndCUmcy?=
 =?utf-8?B?SiswMnNjMVNUcktrTDAyUDlaczlOTlN0cGJ1VVpRRWR2b3dwMzQrVzFjVENI?=
 =?utf-8?B?ZXhJU1gwU3ZQR21GRG9oSUxnVzBpTGhHN2RMTDhzYkllUUozM2ZxWVM0NG5X?=
 =?utf-8?B?UWlleG5aMVdzWkJRc0NVMEpDcjdYdzdaSHNBMVVycy9saUt1eGlnSGY4a0FC?=
 =?utf-8?B?K3N6MlQwQUh1aEs1NnhTVnhNcjNaLy82WFFjRDVtRytKQmQ0RzFRTGQxdUdR?=
 =?utf-8?B?czFZM2I1K1Qyc3ZGRnk2cXQwSmkxeGlBNFp2eWxVVnVGRGR3bXlZL2NQWkU0?=
 =?utf-8?B?T3JEalFTamFXTHhzdjVYU00yZWp0RUdHN2xoT0xsNTYxMi91UXRNVzdpelBU?=
 =?utf-8?B?QWFtaVJTemJKT2ovZ2F6aW1BcHNqdjZDYVdnTDZuZVd4R1YvZTZzREFYaVFy?=
 =?utf-8?B?b3o2bXZGaGNsaEhrZmIvUFRaUVh6L0ViNTdWQ2hkQTNkaGNxZWd1ZVNZckgz?=
 =?utf-8?B?R3VZenBHTHg0V2lwQUpmVU80blZ0M1V3R1ZHZC9EVG1obTc5d28rNlNFSldC?=
 =?utf-8?B?VW1HcG1pMXRod2UwSGNiZmRFeDc3V3pBMXNrUFBOSHZGMnZlUklKMTQ5RlhW?=
 =?utf-8?B?QWlrYmF1TldRVkVCbVk3OWpoMUxWZWRKNDU0ajhRRW5sRGNSZFNZTDlnZFVp?=
 =?utf-8?B?WUoxWUR0OHF6WDRyR0pCSkpmYUhXbWNYc28zTjQ1UG5yN1hMMXRKQTZ3OEVS?=
 =?utf-8?B?QnJ5MndtSlIvOVY1azFmb0ZVdUtDYUp6V24vU1FoV1I3Z2Y1MFJ2OURVZEVP?=
 =?utf-8?B?aTJWV2dXUEpuMUVCWkRFazhublJLS2RqVTdTd1J0T21SQ0FrWDBWUjJ6SWow?=
 =?utf-8?B?a0pGNHBsclpFWUZMUENrTzJHM3RwNzRlckpnTEhpL0xWczJoNFF5UnFUYlF0?=
 =?utf-8?B?bTQvNzlLbjNJWG5MTHdQUkFDQVRFVWtyUjlTaTFLU0xBMkJEYTVpaUpzcjk1?=
 =?utf-8?Q?nFUgxYMuXrE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVA0bXQrK3JnU2hicDMxMkdOWnRjSXlJblJHMVp5M3U0QUovUkhGMW54VmZh?=
 =?utf-8?B?enZ2dC91eG5ycVJKdnFhSWxTZFhEdVg4ZWFOeUY1ZlBsWDhHaWJQdjQwR0kv?=
 =?utf-8?B?MUpCb1FXWUlKNFlHWk5LUmVNM0xPM1ZpWit4RVd0Wi85ZWFwNG54cFEyWEVG?=
 =?utf-8?B?bWVvWEFBQUlaRXhjT2dkMTNtdHc5cTFXUFQ0UU9iSm0xY090U25CMWNYYkdn?=
 =?utf-8?B?Q2Z5TUs3dUFoTzk2ck55WnR1b1p0aUFveHlYVjQyMEFjdVBHTWczOTdIUUNO?=
 =?utf-8?B?VTc2LzVJUUt3RGxlbWdRb0ZwMG00RkVKTStaNFArWitoNVAzY0JadFkrMCtS?=
 =?utf-8?B?S2pMOWx5MDYzNFpBSmdKRzRXbHo5L0VibURWWGxnOUJnNHA2ampXOUQxOU5y?=
 =?utf-8?B?dVZ6MDllZzAvbTBVWVozYlYwMmRrcVowOXJlT2t6ZTFpZWluTnA2VXE4aDRq?=
 =?utf-8?B?RGNRdDJ3Q2Y0N1JoZDJXYWoxUFI3UzZFV0puMjBtdHk1Sk4vcHN5WlZ6UDU2?=
 =?utf-8?B?dExTcHloNTNvcHZybFVuZy9pVmFRcHpSZ3pwejU2SVZjb3hQYkxmUmUxaGFx?=
 =?utf-8?B?NG9xZnBOVUwzQUV2cC9LU2JtNncwblFPblRMb1grL3BMNWtQQXhycEErbmZP?=
 =?utf-8?B?dHNGNmdMd2xIckkxcGlYMjZhR0RxZkFNeS8reWp5NG5FNmsybXl6VGFnNFNq?=
 =?utf-8?B?ZFZyZFQyQzRiejA0MDBvY1J2TGJTUnNqbW9vNDlvVFNYK0RBL2tCYTgxK0Z2?=
 =?utf-8?B?WlU3cWkvTU5IaGNBQ01lWGJFS2k4RnFqQkYrb3puQXZjelVxckFzQVdIUzRK?=
 =?utf-8?B?TERoVXRiekx5UUVaTzNiWWoweGpOUnFzMjA5dlVYSUlpcCtDTHZrb3dLdUNU?=
 =?utf-8?B?OUJXdjVick5kbFhNbVI3WlVFU2d6Q2FlY0JFRlIxUElpQk9oaVZaeE95QmpV?=
 =?utf-8?B?clZ2TzZrMXdjMVJlb3I3YnNlemlOUXpweXNxaWxORWZNcndRZFBYOXh1cXN6?=
 =?utf-8?B?Y0ZCS2E4UVZlc2E0VFNmVVpCY0EzbENGcENFbU5NcU1VblFsQkNaVGFJalpr?=
 =?utf-8?B?d21ZNHZzaEhpY1RZakpsbHNCaEZCMVl1M3BKZWxFVC9tdStEOXBzYmNBaStH?=
 =?utf-8?B?ek85L1JFbUVVd1Frc3lBbWlQcEx6ak5vUTZ2K1ZvZ2pwY2prRWtQZ1NkYjQ5?=
 =?utf-8?B?dFJ2WFZWUGVwZU5ibFBEbzhVeDBibWwvL0tLRDI4ZklVRURVSDVad1NMRWZU?=
 =?utf-8?B?RkJVY0c5YlB5a0p2Y1hkK0Q1K2xuZHM0L3lmTFZPTW9waVhST3NJTzg5eHNp?=
 =?utf-8?B?RkVvd3YxV240T0RMaTB1Mi9DRVVQKzF5cFZhREtORVFtdFQxek1IZkhCV1Ir?=
 =?utf-8?B?UXV5TTVndTFOVlk1cVpwS3VoeGE0T2NiTXVFb1E3andXMENicE4vZlptemxa?=
 =?utf-8?B?OFZVWEVpZlMyUG1SRjRySmJCSXI2aVNleVljeGMxVVdOZTNFbitoK3BSNFlQ?=
 =?utf-8?B?MWhxcXdzcGpWUFpYZCtVcnJHOE1TK2I5NCtKRWE2YkRmcGozZjN5czJyNXlD?=
 =?utf-8?B?Yk1qMmxWNHBTWlk0TVJ2RnpmT2E1WStyZU16d1JsZ0tkUDZoVHBMNjJJL3RO?=
 =?utf-8?B?cGZER3NTdWJmY2JXMHM1UFlvT2Nma2ozczdJK0VmL0xaSVE3SU5wODRwSzlq?=
 =?utf-8?B?OWZiWnF4b0MwZHBMTldZNDF2bmdLSFJYNjJ3RnBFOXBCc2VhUVY0YU83WHhx?=
 =?utf-8?B?NjJhZHltb2JjUFdQNnhmcU1ObTRzZGZDL0dVT0FRMUxpMHovYXYzMUZkenEy?=
 =?utf-8?B?b1Y2dzN1c2hVN0lGK3JJQ0lQdktsRkE2TExWRjUxZS9YQkQ4Y1VjcXozbWYy?=
 =?utf-8?B?NWwrN29Rck9hRlRGVjNHQWkrT0RkTEozZ0Z3VlVHb2h5M2NWSEhFa3JmemtX?=
 =?utf-8?B?ODVvaHY1cEtnOGw2Mmp6MkkyUzh5emIxWHNmTDR5c3JRcHhVaUMzeFU3VzdW?=
 =?utf-8?B?Nm9CZ2F1T1ZyQmQrOGgyTzBRRTFlQ05QbXppYUI5V1M1dGEvNEptTE9LaTJZ?=
 =?utf-8?B?bUZmTyt3WEdZWUdJYXpHR29ZSklDK2JNQ3VkRUJxcUV1K015aHVvRDc0STcw?=
 =?utf-8?Q?w/tKpDcOfa2+pYmA9AB2uFBWq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9cdd9b-f935-465b-ef97-08ddbec41f50
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6321.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 08:39:31.6502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iH4YRnggJGBlHc6n6pE60UmhfmclbjCnSOB+Obh4+ckgNKoPQ+5AUKyVmvymPyF3zgCDZ/JS3OUqXxk3s+Oh3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8909



On 7/9/2025 11:07 AM, Kai Huang wrote:
> Reject KVM_SET_TSC_KHZ vCPU ioctl if guest's TSC is protected and not
> changeable by KVM.
> 
> For such TSC protected guests, e.g. TDX guests, typically the TSC is
> configured once at VM level before any vCPU are created and remains
> unchanged during VM's lifetime.  KVM provides the KVM_SET_TSC_KHZ VM
> scope ioctl to allow the userspace VMM to configure the TSC of such VM.
> After that the userspace VMM is not supposed to call the KVM_SET_TSC_KHZ
> vCPU scope ioctl anymore when creating the vCPU.
> 
> The de facto userspace VMM Qemu does this for TDX guests.  The upcoming
> SEV-SNP guests with Secure TSC should follow.
> 
> Note this could be a break of ABI.  But for now only TDX guests are TSC
> protected and only Qemu supports TDX, thus in practice this should not
> break any existing userspace.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Need to add this in Documentation/virt/kvm/api.rst as well, saying that
for TDX and SecureTSC enabled SNP guests, KVM_SET_TSC_KHZ vCPU ioctl is
not valid.

> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2806f7104295..699ca5e74bba 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6186,6 +6186,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		u32 user_tsc_khz;
>  
>  		r = -EINVAL;
> +
> +		if (vcpu->arch.guest_tsc_protected)
> +			goto out;
> +
>  		user_tsc_khz = (u32)arg;
>  
>  		if (kvm_caps.has_tsc_control &&

Regards
Nikunj

