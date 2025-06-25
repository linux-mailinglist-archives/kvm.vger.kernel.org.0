Return-Path: <kvm+bounces-50610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77CECAE7663
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:25:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 105901BC25E2
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 05:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D901E22E9;
	Wed, 25 Jun 2025 05:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fwwrhAhM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E8715442A;
	Wed, 25 Jun 2025 05:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750829132; cv=fail; b=AWeZ2iGki7bzAsSrK0G6N2px3SYmsS6viL5KMR9TSS8TATemjHZU10KSxKIvK9UwXNfSsYU40yg0YGU6MOZZ6/gBySs2ejog7QxkmztPD9FI01RxO3sd2jJpUVxR5uMV41Vm4qCR+FhmF5H6Pjul+f0hTQslbYart+TVWvTFsxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750829132; c=relaxed/simple;
	bh=TwDe/SwQExH45BHMSoRiSK6gGdYoyftdHARTU4KsBu0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ts61YsO/taDHp73F5ZJWNJzFRgmCOMXiWXJJ45xt5xlm52JEwUuGxGq66kR7pyJ6TtIVGh/oNh5ZVwBxaVdRKOXteLeKoAtvLQfopeELA/H/lKNjjO5Ngh7niSsHULXy7DiuAuxfH35OKH01zL4XXJfd9I0kUAXgC63pB2AQIO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fwwrhAhM; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zw/+urHzcDlRyzKOxUgrASs2IJGajCGGx7SZs5t9dMBXcE45HsDfqRL8EprELnd7c+TgN9OnlgADgYNfxj3VIj+c/muf0a2OFhjATDtGDuX7KVRPzQfB34qedjVAgL/h7oGtlBvlvnsCFrh9u4V/Mnm+KKRhAuCkK0wTpN7C+fTnOoTh6s4XnY+ft2tKEOILElN9YQ0EAMJNO+K/BwwfhA9u9K1/So5KEWC4GDSzQfXTHcfHzJpnFRBQZ4IYQvG8UEAJHdwlXHZz/1y4MmxEagzVyKzNVhA1+zk4yAcXAXuDDV8UeHqLNxC2/3gXiDX6htofKe0Un0DBz+2S8nXVqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DIkfbf3v2wrWflH1V0gAoj9GwlQ2cy1PStqMrYYCPQ=;
 b=YJ9Ud0yXiDUnzskmwD8dRlDsOX4KhAUoeV/kOsL8lQuWmpZpbNEuX+4uy4Qp2b1rorfYBHuAnSAxgwwjB1iRXN/60mJaMRiXDf4yxoi83UpQmoIAGe7Z4U/gAUdd4RLoRhQC3/+B2DOLBFUrm98aNYUSwgSvoJj2FfXNSdJ9yD1ALVdHgRLmHa4OUQsrm+hMMQEjYPC64z5yWdYdZLDwilEO9uVhdF2V2+ZdX6snIU7T3SfuS2If5NCdei8O21YbXw1Rvd6+Phx5ih5068zDS0ezyDe8GuZBh8vBYluIZZalZF8cyPU/Sy5RGUUA/tH7NZjYAjaL4gDPh9FUkyPgaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DIkfbf3v2wrWflH1V0gAoj9GwlQ2cy1PStqMrYYCPQ=;
 b=fwwrhAhMZDHt+CqcmMWpzuM0ypPPB05qFUonzME/AI0t6OAoH1xUC3e573mXD5PfShQy4yLr9bDkJ4UgFD+cP5p4t7RcasPfkHyeTnMmIqzYuGf7Jj8d/fQ0Kbf/iMRxBVzc7e5F6ycEQ28ZUCZsKPa7NaH/2KA7QQhDtJ+Ix1E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9aa) by SA1PR12MB9004.namprd12.prod.outlook.com
 (2603:10b6:806:388::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 25 Jun
 2025 05:25:27 +0000
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf]) by SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf%8]) with mapi id 15.20.8722.031; Wed, 25 Jun 2025
 05:25:27 +0000
Message-ID: <91554c83-a7d6-4e5a-a9a0-32b6d2653cbc@amd.com>
Date: Wed, 25 Jun 2025 10:55:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: guest_memfd: Remove redundant kvm_gmem_getattr
 implementation
To: Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 bharata@amd.com, tabba@google.com
References: <20250602172317.10601-1-shivankg@amd.com>
 <diqzv7pdq5lc.fsf@ackerleytng-ctop.c.googlers.com>
 <aFsDGvK98BRXOu1h@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <aFsDGvK98BRXOu1h@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2P287CA0008.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::13) To IA0PPFDC28CEE69.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::be8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPFF6E64BC2C:EE_|SA1PR12MB9004:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f1ff8f8-39cd-4ba1-055f-08ddb3a8b0d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHNUSG9FcnRkU3p1c0ZQQ2JFRDVwV2VmbVNCZW5CeDY1ZkdDbkdWNHhPVGZO?=
 =?utf-8?B?RTBBT1M1a09uOCs4Uys3VHdkbHoxN1NEZkNuMkRlQUZjVGhWcDdkNFZsdVF5?=
 =?utf-8?B?TjNhSGhML003c1k4dVUvczdkc1ZQa2xUVWVuNmNsbzI2TGVRRDFFMzdGVWVU?=
 =?utf-8?B?enk0TTcwRmIveVU1Vno4TDh5bXlnOG9lQU54K1BJVE9DRThRMG5BWkhHQU0y?=
 =?utf-8?B?WFJ0UDZ4dEZQQ21BM21Kb1kyMHR4bTNtNHVJOWdJRnkveThHMkxDaS9nZXdH?=
 =?utf-8?B?VDdnMGpTbXZNdTdRZ2tzcXRnRnloUTA4MUF6UWdSWTBkWjJPaFlqMnkxcFR3?=
 =?utf-8?B?T2tJWHRpSUM3SXpXRnY2Ui9QTEM3cm1EWDhEZ3h6a2NleVFWVkY5Q2lOYm8z?=
 =?utf-8?B?bkh2TC9CVUo1U3ltYitjRHVpMk9UYUJSa2VNUDE5MjJnMlpENXlkbVNRdzhy?=
 =?utf-8?B?cXhlS1VNTmE3MCtWRy9PSjJXYVFDQ2NoSXBzUUZzSSt6OEJwUnVHUjgxclJW?=
 =?utf-8?B?UmNTbTFqNXhUMEdyR0dKbFlyeExCV0NqallXcTE2eHp2enhGSUt5UXJpbXR5?=
 =?utf-8?B?WHgwTHMzT0FKQ2p1TVcvYXdvcmNoaVJRM0JJTG44WXY0VnZiMGhWNUtFN3Vm?=
 =?utf-8?B?SVprWWd2R29MclVjREU4cW1TOXk5dlFIaG5ubXF0amdTSDZBV0VZK2xkbU1H?=
 =?utf-8?B?NUV6VlA1bWFHcTQ3a2RjTHd0SFo2NkNobm1BZ0xmSm5rbkgwTFpob3dTT0Vz?=
 =?utf-8?B?RkUwL2xGUTRrRkpYT0MzOTZTK2hZZUhNakxRQVBoY0N2S2FGbys5UThwbWU2?=
 =?utf-8?B?N3RUbWpLZHpvYTF5N1c3bXBEa1d3K1BlWnMwempROGQ3L0czZXVjZVhzVGNE?=
 =?utf-8?B?VVk0R1pybGwrMWJBbXFMenNCNGY5RkhuN2Fock9NbTNCTm8wTEt3TGxrT3ls?=
 =?utf-8?B?cGFZa1hWSUVjVUtNa2hNS2UybldIUCs0SDRaZW5zL0xmY1lzYzlSQmx2ejB0?=
 =?utf-8?B?SVBZYWlJRUd1VUJzWERvODRXMmhuMDJDa3l2amRhSCs4eU9BR2hDN3kvUlNy?=
 =?utf-8?B?MXJ3K3Urekcwam8rMGdXMEJmRjQzWnVweUJQNWNDcWhqR2toODI3bkp1Y2Uv?=
 =?utf-8?B?d2NSQTd4Mk9XbzhJWWtmN3RYczUyMWdjNGFaLy9GZHRwMWcrR2ZrVmNNNHZq?=
 =?utf-8?B?TTk1U2srWS96Q0JSSU4vTU1nclJMYUNOT1JKcnhuNEpKMlFrMEQ3cCtKNnVH?=
 =?utf-8?B?MStHREFBaEVLWjFSWmVOU1B2aDdiMDVrb25kZTdKa0x1cjEyTTM1TVc4bVNq?=
 =?utf-8?B?Y0gxMVRXbnIybmV2Y3NnV0Y4Z3M3R0t5ODFuL2IyUFQzTHN3NVc3eUkxSkUy?=
 =?utf-8?B?L1dqcTNSRktVUTloeTdCRm9WaS9xTVkwbUVKUllxZ0JHbWtpd2xlUXBmekQy?=
 =?utf-8?B?SHJZTFNveEN5MEUrbmN0eDE1Nk5XYnJtUG1mYzFvZlFZQVhneG1yT2U0UFFa?=
 =?utf-8?B?QklHTFpHRjNpT1dqN0gzTXJ4WHh1c3Jla3I5T0QwVHpWc0FyK3UwNkI4VG1Q?=
 =?utf-8?B?V3EreHZmcysxTFRwQS9LaGduTWxBQVdpUVZNbEQvMjEvczJpQno1dUNMMm1F?=
 =?utf-8?B?d1JlYWs4dVBMUVlKVUIvR0hkTkp0WGhsVnpqR0VNc1FIamh2NTJ3MThoYXpn?=
 =?utf-8?B?YXBQckZaTG1pTnlQQU4ybU83aTQ0WlVzcWkwSVdkOVVxbmplbHRscmRuaGw2?=
 =?utf-8?B?bFY0T090eFR0MFJTcHNNajBkRHFMNjFYT3lDaXowSGNoU1lnWEdURjFGakRW?=
 =?utf-8?B?OHBZYVlkKy9oR3VuMkdpOTN5Z0crMVpDb3dEc1Y5VVgzajFrVkZVYWpwT0cr?=
 =?utf-8?B?OEhvK1pHSVE4SyszdjNqSGhhci8zL0NwZWw0K0M3bTNMOXF1TkRubnBoM1Vs?=
 =?utf-8?Q?Pub8k9gsip4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPFF6E64BC2C.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFFPaklNd0crbFRkV280b0VxQTNoZ1VpMzJWbjJ5M293YTdIbFB1NVZjWEZz?=
 =?utf-8?B?dXdPQlZQRmlnSWtzeWp0MG4vemdxVTJPRnBVVVkraTkwb0hHcngrWFljL2I0?=
 =?utf-8?B?YVFpdDBuT0d1SGZFVmVCeXVnVHlqTm40WHcwcGM0eDI5OGpXOVQyc05qMGJ2?=
 =?utf-8?B?RHF1U1FmdWoySGFKYS9sSk8ybWdiK01aeWVXRmtCMVY5ZHhnZWt4RSt1K2VI?=
 =?utf-8?B?bUxrRS9sTUZLN1luZjlKejdUTzVZUDh6cWtOS3RrWC9kZk41SnUzQ2RrU21P?=
 =?utf-8?B?MW16VjhPdWJJUmVtOVVOVjc2RmJWZXVhY24rSlpiUFhXRWVsalVpem1pTUxv?=
 =?utf-8?B?a0FuZDY3bCtubXNydjBmR0ljNUdmTWxvRDNNaUlBclZVM3hVclBNYlk0Rjgw?=
 =?utf-8?B?Rjh6dzlrcnp4TmFKaE5KQUlETHNiYWFqRkxxelNUdmliWlB4bnZMaW04d2R6?=
 =?utf-8?B?SVN3WWl2Q0FERjQ2d0hqQzZRVHRxMTQ0U3R6RWYyVjlrdStDYlE2dzhtbVRD?=
 =?utf-8?B?TWw5QzhRb1V5ZEI3WW9QQjFqSCt0dHZyMHl2cHVnWFFIQTZib2d6RW9XdWJE?=
 =?utf-8?B?TE5CLzROU29ZbVBPV3lObkZ2SnhiK3Rsa2NvM0YwM2MzNHFBTDlIanhwUFdw?=
 =?utf-8?B?bzFmMUlyU3EzUllrenMzc1FjWjlCUFN2elB5a2ZLb2N0ZGxzU1lRQnVkNFhR?=
 =?utf-8?B?UjNxZ1QyQ2drKzROVVQrYTJnMVgrYWVDTGlRVzJhUjJNcW1nRDd1bjV1MFMz?=
 =?utf-8?B?WjlySGVXM0loTnpjdFBXaXgxSkJ3QmlOQTBBeG82Lzd0NVhRY1pNdTN1d0Nt?=
 =?utf-8?B?OExYcmtmMFhQeDk2MFM1MVdZenZSTDFORVJ2Um1FK1krNFpHTUl3SUkxQ3ZP?=
 =?utf-8?B?UERZY1dqMjkrMU0yTzFaNjVxcUNnL2xOSmZwUFE0NXFEYUwvOXpPSWJkOWla?=
 =?utf-8?B?SXRjRHFHUjVvcHFOWS8zVVpTbnFRUTZPcHM5RURLSFJJRVBqTnNJZkFXMm1u?=
 =?utf-8?B?RExRQ01EYTc2ZCtVbzRvOGU1YzAvMmFJdTBWUjJNclRJOTI0RzRzQnhqUTlT?=
 =?utf-8?B?b2tQRzZhd290Ym8vNGgvRFpUeHlqb3lueTFjdU94V3k5a2VJZGlTOFpleEQ0?=
 =?utf-8?B?N21GRmQ0OGpjRXJJTlAzMnhKaFpHOUV3VUxCb2FCTVduaEJlK0RhMEZZSnRG?=
 =?utf-8?B?L0hBQTQ3bVluTUtmR0QwTG1jOWNxZFZDdnphYWQzalZoaXMzMnR0L2pGNms1?=
 =?utf-8?B?c0tmM1A1d2hIM2d0TnR4MzFPSnBHZmFYR2JMWm5CNXRzYU5VTXJ6SWNuLzFW?=
 =?utf-8?B?S09HczV6WWFnOGZweittZGtiZlZuZ2hpd3VEcVk0MS9kN0M3bExRaWlkSTMy?=
 =?utf-8?B?eWZTYzZFeHY0cnJodTJ1YkJQWlJveHF4eEhVVUsrZ3NXT2hkSlJlNktYZkZR?=
 =?utf-8?B?d1VpR1JIVS9lWk1xZFd1a2Jqc3ppRHVxOWRkR2FKaDBwd3N1Sno2NkZpZ1JO?=
 =?utf-8?B?cHg0aWpRRTVLVWRURlEwTnVrRWViYm5jaGRDNUlvdnVpcXBTcFlxUjE1WUpX?=
 =?utf-8?B?UTJYR1pzNVZLS0ZxUFM4NmltUmxxcEZ2Q3RBUVdMeGxMRkZnbnc5N3RQeTZM?=
 =?utf-8?B?NEsxR095QWE5SlVTWnNmMHpydGVhcHNjMllPR1pVVGFUcWsvSmJxQnZ3aHdP?=
 =?utf-8?B?ZEhnQldud2xYSUdzK21MQkJoU1hjZkYvZk94dzJmU1VJeHdvWnVmVVIzYUNL?=
 =?utf-8?B?Z1Ftczk5V0lpd25RTlJFVTlGeUtqbTdlMUxBNEEzdC84cXR2Z0FCSFVHd0RE?=
 =?utf-8?B?QzltQzg5VlRCbVRiV3VleXowSlU4ZUNZc3ArNEMyamRFMXVpNGZoNFJQS3Rt?=
 =?utf-8?B?eW1pNXlOMGdXR25HamdXeGJ5R011enlnY2tSYWNqVEZibUY4UWRBckEwVGJY?=
 =?utf-8?B?VFFEQTFXSk9FY3FVVEZqd2F2RkRqalltbDMxTjMwdG9IYW5QTysveVEyV3FU?=
 =?utf-8?B?eFpkVm1PS1FvZ2dxYkplbjMzNk1KSDZwUGlzZEVtbHVaQmxEVE0rL2l3Q21y?=
 =?utf-8?B?Ymw3T25DYW9aUStwVEZqV3ZNczhuOGdBSGMvUVBHajdUUFZqb3hhRnVYblVh?=
 =?utf-8?Q?4Ot4Re20w20Mb8/u3D3Wo364p?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f1ff8f8-39cd-4ba1-055f-08ddb3a8b0d6
X-MS-Exchange-CrossTenant-AuthSource: IA0PPFDC28CEE69.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 05:25:27.7335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5YLtg0s/9p8km8Qm/CwfoSVTK/DI5cauMQO6lWDHs+kWqXfr7B5os4DWqFhsKOadNSOS/RF14eb74WUH22NiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9004



On 6/25/2025 1:27 AM, Sean Christopherson wrote:
> On Mon, Jun 02, 2025, Ackerley Tng wrote:
>>
>> Reviewed-By: Ackerley Tng <ackerleytng@google.com>
> 
> Ackerley,
> 
> FYI, your mail doesn't appear to have made it to the lists, e.g. isn't available
> on lore.  I don't see anything obviously wrong (though that means almost nothing).
> Hopefully it's just a one-off glitch?

Hi Sean,

I can find it on lore:
https://lore.kernel.org/all/diqzv7pdq5lc.fsf@ackerleytng-ctop.c.googlers.com

Thanks,
Shivank

