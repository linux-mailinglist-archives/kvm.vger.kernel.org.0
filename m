Return-Path: <kvm+bounces-59497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 130DBBB9497
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 10:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8C7C23456B3
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 08:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE601F1302;
	Sun,  5 Oct 2025 08:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="EDta2+Vd"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012048.outbound.protection.outlook.com [52.103.43.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9F12CD88;
	Sun,  5 Oct 2025 08:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759653037; cv=fail; b=sAaaF0qSUouc+G9Xs8PMbxAoc099CULS8nn/Fif0Re6yjKYXti+KRC6VM4aMbAN0nZhV71+2BRB1Dwnc7MKvQo0+odoQ8C7r29qyYQaKLqIIVmIxhTpxgHbsq7GVvQwy0BcEixXL/2lGwyJO4Bx4CsPJOBwAYsP8RXONLniet/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759653037; c=relaxed/simple;
	bh=iDG6zh3X/XBOi3tzjElrUmJoVL2CkApJDUx99o4EnMY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fNhpEQfyGtiZqspR0OsPy4gq7mwc03PvAGT9iWg9C1obA9E9oQtwyMl/EoVFx6PSsb5/tEzt59i27OmZd2IdOFDEgb3cQEcGmEVkA1RhmzMMJENfLBql9nOYu20D2vqO2RHdqJt42BX64i1VBcrYNA3ph/ZX7kPjKz/FWb+QT6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=EDta2+Vd; arc=fail smtp.client-ip=52.103.43.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gC9aN1x4XGVP2kX9q2yOIK60TeGI8AyIzLs5S0EAOeP+beggvzm0Ilep9Ep/CDTG/De84PAArJeqwMeS2U17Pl+sPuQb86E6xhHli3E57vc7iU9Dzt5BgqYQ181rTTSR4m1NXb+NZ9dHUMkxBHNzdh/lMxmaVlG/ZOgzaaHDEqIPZxKkAoqtPiC53y79LtBquQs+56NYlIdljKHRgfZ2UatfT8XQk4iUa1/iOPhIwRh/dOUdWsuvtMLpU7DNU1kfQyL/0H3cdOmVD3r94cp9GtwC9ODwg27xtS3672p9AbKDd5X/UpzObsLa15ryr32hhwcZrKsvco3hkOH0Le3fXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EhWZsGzs2o3hIInLVfsSwusNpdVh4GZDAqDckqOm6NQ=;
 b=pMt6wNw5JsfZ+oWMcxHlmv9GkFaDWuJ7RN3iefYL27ub9JLtT1g8Zth5WaDSnjMCp84yWQ7Su60rZBWMCR2MjlmlNEIpPGX62BB+0VRuCCmiy13JxHsa4XT2cDi/uNXH/7CPWWE33httdlRiB18aSKzFzqtGTkKyB88lf02RrFzCsU+m5jFeQsydH80DTl0iAbgJ89TSXhKix2Sj2KW4O2gnosbLrz+LnOrvs/1R2UAFHE8jyVXTF2zXLaT1yvi/tA2DOJdWCVNvPXCmje4Qi84uxdKcc+9UAn/JxbJJya1qMbtWXQLtb2jqkFG6pNKvlVDBtm1wuq9mMXAOmni94Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhWZsGzs2o3hIInLVfsSwusNpdVh4GZDAqDckqOm6NQ=;
 b=EDta2+VdSV68vKQk4iw81A1zUENHNYryECWpsroLqbBXg44ZOQLcpeiaD95i+4XoC5BwSQ7oi1RgBYKNTwQCcy0/Y5ty++TZ/lrb6z4/xBiE8I8PcayFXXqdQsu6jHXdLntGovAAKKFYAD+pdoDR6hQyLo/DKn3axTrhMMrye36YASeMt08FrnY42sCEfvkPgNjZL5GwVKcEhaX6gnqox5z3mjwgTfp6dv7fN0BMqxmVF+DuIdo7xoltIR70JRAvKGzVeH7Q3Lo1ppAcHxTr1hcM0tYI035cd0O5foCULskrXcAYUXNrox4O72ygbxePOCJnV0zoegT6Lfh+AuvaUQ==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYPPR04MB8960.apcprd04.prod.outlook.com (2603:1096:405:314::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 5 Oct
 2025 08:30:31 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 08:30:31 +0000
Message-ID:
 <KUZPR04MB92650FF9B2E10BC4BBA5F707F3E2A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Sun, 5 Oct 2025 16:30:25 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 05/18] iommu/riscv: Prepare to use MSI table
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-25-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-25-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:3:18::18) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <d27716fc-1ce9-483b-b175-866e533f888e@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYPPR04MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b5536ae-91a1-4b1a-2553-08de03e971ff
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|15080799012|461199028|6090799003|8060799015|23021999003|37102599003|19110799012|3412199025|40105399003|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2FSREY5Mm9scmN2NnZ6SEdVNXhYREVmR1RQcmJQak9vUjBKdU9obzFUeEhy?=
 =?utf-8?B?UzB3OFE4RWZEOE9yTmxxaFdiTm44c2UrOVovTXhsamdTNk1rWVduQTF1VDdD?=
 =?utf-8?B?VDNYRVZiaVhxR1E3eDQvVEFRWWhIb0RLTVE0RWNERU1iZ1V5ZkV1Z29KaVho?=
 =?utf-8?B?NmtWTDlpNDBvTXFFNmxJZmxUT0plVlB6Q3RVTFpRc1pnNUFEa2JTTXpVTnFp?=
 =?utf-8?B?VVZ5L3JBQ2Y5cXJZRDM5aUxvcFd6V1lGa1JHeXJnemxrVXp3VC8xcW1BRGYr?=
 =?utf-8?B?Y0FuSGdTZlJzWk5Nejl2ZU5xeWVtSzB4cGtVVUZMWUVoWGxIVGhKeXlkRDFC?=
 =?utf-8?B?WWZNVWVkVmxjT1RvS3dXVk1XdHE5TmZmNGpzN0Jzek9wVnBlaXhTUmgyb3FH?=
 =?utf-8?B?bHhMSk1RUjZvQWNEWmNpRTI1UDBrUTBySnhnNEtvdEd2L0loWFllSi9Lc0Zw?=
 =?utf-8?B?L2RUcVpRUE5kcFFGRmFoS29KWlFXb0F4WnRHY1hvbW0wQVdLUnYvMkM0MlZT?=
 =?utf-8?B?WnlSUFdGdUhwU3RrMXNHRDBubHE3aWc0ZWhLOEhhZ2tvNW14dFNUWVpWaktX?=
 =?utf-8?B?dXlqOW9BODJnMXpzQ3BrOGk1aG83aE56Zzc5M1lMb3NpbnkydzBhSCs3dHYy?=
 =?utf-8?B?UTFobXFkQ1ZrR1J1SDBtVU1sYUxpQUphdXhRb3ZXejVGcTNFZFpHNDBZdVh6?=
 =?utf-8?B?OTgyY3I2TTZpVjZURURkd2ZocUtIdW81ejduMGdpWUhIOStJNkYzaU9IRmRs?=
 =?utf-8?B?d295NlBPNWdTRWhQdHNUaDZ6VU5DcUsxcm5zMWtITWZQN0JGVnJQZ2RQUWhy?=
 =?utf-8?B?UXJrZXBPLzhoYWNVMnRBS3hQbFIyaHRzaC9UVUFHMllZWXJQZE5yd1JFWTNT?=
 =?utf-8?B?RkdTUzJVb1F0enBJcGlZZ0VkbEtDVkIzQlRkWW9jVW9sMGhmN1NmeVRlUE1U?=
 =?utf-8?B?TStPcGg4USt6NlJnK0h5RkY0dWZZenhlN0cvVFpnaGtHaUxUWkx4MHB3SVcx?=
 =?utf-8?B?eUl3ZlFUendDdWJnclV6RFlFUkpob0UwVG43M2hHNlNYUzVaYTBZV0NkK1RF?=
 =?utf-8?B?RVBmNGh4Rm9TMmFJQ2NvZitLajhqVzdEYUx1VEtrRGJlK0R2aEh2UXRGZC8r?=
 =?utf-8?B?SzdvYzhxNkQwV2RLZ3BlbDVZcm9Rc3l0N1pCaWlJalB0b0V0REJremdvRC9R?=
 =?utf-8?B?eVg1Umk1alhkUG5SNjk0cmVXZUFxUEYvaEJiZ1VQT3BhUVQySVJja0dmT3B6?=
 =?utf-8?B?dXZ6NlpVTmpZaGxoYmRRQ1hIRTdZcFp1NzJtbVlDUkhGR3dRYjRHOVFxZVpC?=
 =?utf-8?B?bUR3M2tYTnlsQlhSRCtCNk1Fc3VXQTNBci9jSzhrNnpTRW9nanF5UmFHNXJE?=
 =?utf-8?B?cXZEeFFvUG1KaWFvRGdKVk8zSW5zcVAzNzMrd1N3TDVZRVl5QXB2MmlSTEV0?=
 =?utf-8?B?UXV1Mk5BcWo5WG5XN0RtVlFoTGtSdVBXbVU4WFJ0WWFvSGJPSm4xZ3pnWHVV?=
 =?utf-8?B?VzA5S2JoSkY1R3d2MjFrMU1Ebk1Yc2hrMVM3TURKcW83UUpiaG5OL3d2Mkk1?=
 =?utf-8?B?cmVYakxVWFc4TGRvZWpIamw5eGthUHZNWURoZnFkZG9tYUs1OEorUnFJYk9a?=
 =?utf-8?B?YU52VjV0WXBIMHN3TUY3RFk2M3FFbmc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXRxaDZsUHpacUY4V0xGMFhZQVlmVDF3cUpxeTlJVGc0MVdGMHA1aHZWSGxF?=
 =?utf-8?B?eHptaXRUY3p0aW9YTFdCdGU2c1l2M0ttMjVZMVZtUldpVmJaV0N4UVJLdjd6?=
 =?utf-8?B?NkZHSlZVcFFrZko4Sm1vaWxOMmRlbVJLQ056MEtINWJVRjJZTFdLYkFkWVl4?=
 =?utf-8?B?YWZmUFJtTW5jL1ZNSTlWQnh0eEFucmxKZVpWZTVSTnNYZ0w0OVpxTHJkamFU?=
 =?utf-8?B?Wnd4Z29yNHJDNTUxa2xtNnZQQWQ4blpZTUU1R2hHRlVPQ2kxRHE0YTJnWXdz?=
 =?utf-8?B?VUhleEdMQWkycy90TXErTVRKYTRUTHRhWFA4WG9tUTd5R05TYnpNWnpiWmsz?=
 =?utf-8?B?QkRoNlUrVnZzYzlhTFN2RFdnR3E5Y0h1UGhGQVk5Qjc2R3Q2aUJpc0FXSHRO?=
 =?utf-8?B?bmtpT0o1clJFMTZHWktDME1IRU8zcE54cktPZ01POGFSb3IwcmptQVQ3QmV5?=
 =?utf-8?B?UFdDQldEVS9WTEttSVJKQ1R4N0ptandBeVV1MlBhc29PSHc1cUE1Z3VsaXZp?=
 =?utf-8?B?bzh0OHRSNFpVVm1lTFMrMmtSY3IwSHpIakl2WndvZDNycit6MzErVEsxWWpn?=
 =?utf-8?B?Y3BqTUtFVFlmSFloZFBOMmc1RDNLUHdJK3NScnk1alJ3ZXNNZEtBM0hHZ1VS?=
 =?utf-8?B?SktiVk0rZm9tYTUwOFMyOEhXMTExeDl0dEVVTUd3T3NDVVJXanNaVjRtWHRD?=
 =?utf-8?B?VGl6NEVzYTBQMGdQM0FZUkNQQkpMRmRaa3BtaG50UFNkN29ncXRKVjl2RmtO?=
 =?utf-8?B?VUV1eW1WaGVicGFIbWpXRlROeDV0eTRQcnNOV2lrT21lYlFORU54NG54UXpt?=
 =?utf-8?B?cndwUS9oZXlZWEZ1cXI2Zzh5bWVJMEFFMXBEMXpjbkdWdHU2T0trUWQrazJm?=
 =?utf-8?B?U1dFTUpBM2NKdFppTGRORURaR2RPdnJhTW9FTzNhU0VaSm1iMFFlaTkzRVJv?=
 =?utf-8?B?Ty9GN1BYb2pQQkJpMEtBWlp6cGtZZjh5cGIrYmUzQnZiUXJhUVJsakNvTmJp?=
 =?utf-8?B?cjZrZ2g4MjhRQWsyaXM2V2RSTFJhRk5qMXV5dzJZRHlZTUMza016ZXpIV2Ix?=
 =?utf-8?B?THhSWVFqRERpaC9oME1oRmRNZS9vNFd3Qjk1dTFYS0VRRkJ3enE1a1BkVTFk?=
 =?utf-8?B?aHFPSGg4cGZyd1NoM2tkSTdxbTc4bHhkNm1lRlF4Q0xUVXc4Q01Yemxsd0wz?=
 =?utf-8?B?MVRocnBFNTBTb2JROTQxMmZZM0dtT1dIS2xxeE9KRU5IODB3RXZmVzA0dXBP?=
 =?utf-8?B?MnVLMFFqNjdUSVduRVNkdWpkQStEZGJ6Vk5hRFhjRVlSYS9URFlIQ1hDcjRC?=
 =?utf-8?B?V25ScnNPWjRyblp1ZjgrbjN2MENJZUVOQzZiWGVmMW0wdkZxdHNZcEEvcmtx?=
 =?utf-8?B?OGZRV05Bakw3QnYyMWJZVXJHM3g1aHFpYU95ejBiY0x1ZGVjU29OTE40MmM4?=
 =?utf-8?B?aTFqd1JiMU1qSWZhY0kzblBjZjdieDVuelNmeHZ6eVFrSG5kaEdUTEZMWXg1?=
 =?utf-8?B?SE9ZV0RTTDRhOHZIbXB2K0loNFN6OE9nTnB0b2JuRFlDUW5sZXFHVGVBcEd0?=
 =?utf-8?B?eVVKVWxOQmxXdzFtK3ZmKzlrZUlpS2tiL0dmSXBobXptbzJwWVJVWkhOQjU1?=
 =?utf-8?Q?RDptQAdP7Yw8nHLkTYz0FaoNqOVgiRxrVKAUbUc1wUHA=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5536ae-91a1-4b1a-2553-08de03e971ff
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 08:30:30.9692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR04MB8960

On 9/21/2025 4:38 AM, Andrew Jones wrote:
> Capture the IMSIC layout from its config and reserve all the addresses.
> Then use the IMSIC layout info to calculate the maximum number of PTEs
> the MSI table needs to support and allocate the MSI table when attaching
> a paging domain for the first time. Finally, at the same time, map the
> IMSIC addresses in the stage1 DMA table when the stage1 DMA table is not
> BARE. This ensures it doesn't fault as it will translate the addresses
> before the MSI table does.
>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   drivers/iommu/riscv/iommu-ir.c | 186 +++++++++++++++++++++++++++++++++
>   drivers/iommu/riscv/iommu.c    |   6 ++
>   drivers/iommu/riscv/iommu.h    |   4 +
>   3 files changed, 196 insertions(+)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

