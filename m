Return-Path: <kvm+bounces-48459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 815FAACE78D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 02:35:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 165477A5C4B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 00:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD13179A7;
	Thu,  5 Jun 2025 00:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lbE9Fq40"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CF41FDA
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 00:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749083720; cv=fail; b=VOu4CkvXtLUwQ0I1t907teJnaOWezbxx5Vl6gi1LAJUa/fzl4rNqNXbbs/xsgvlBz5oD3ksnjbgjmAkv6nEe5CVhjRqTDK9WOyUe6i72vJ8pUCngBHR/JViRFgX6GpSTFkmUa8r0bL3HA1M8017FArd5AOB8w0IEr5rgEB1xtBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749083720; c=relaxed/simple;
	bh=oGMNCIRZqA3XsOwIQyzM3nq+wv9yiUkzWKMy/A2gR9Y=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E1C0RJucv8xmEyhgq+I4vgCqSyuIvJubuhREwGpJr+g2G/mLmEMn2DTNKKsiJJCivf2n6SbdiWq7gQvzQstp9iwOBeeCf91uU3+EURRb76trQB0dskMy4MBZJMHHSoR3ri+Yl9CElXTEdSkYduxddts9KqBmo1TS5z9uKbQZmvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lbE9Fq40; arc=fail smtp.client-ip=40.107.96.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3nPgwxUz61BKrrW5vGDPugGHL7kfs4YrE0h12xTj3/L3yoVLn4DIksWYJdTwhrGowo6lR8qg1z5QXXc73pu/fPQIhRqsnS0HtjQoYBbI+nVENPPB/E+E8BI35s3MXZKlYHvsTZ9GLcGaCEAt3f0kscaweXgVKY3lIDeb8XemvmLWwWennTU3sPTN9DQ0bQ0478SokMcIWF+1TErGrxqT7nrjUFBVcHuyi2PWnJNC1XYBeQ89BSiaNuL3PI6xxTPNar6d5jfCkyYDAbCE3pMIjIGLq/62bG4TRtxfNykn+jc3/gu3Qha+lu0QtVHGvQV5dLLiX5vOhDpHQI3KOA/UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pujCwPNLqcTJySf48Y35hJ/ze8ijOrN7I8y6qhN2/90=;
 b=AagkMBGdAp/zE6IIGJPRxAPlifc9JHjSOL8wms9mmLWhNCHa7qYydBFHdgIKiRemd5ULAnOx9PLiPEv+dWd3DI28Yif75KTupxs9PQQQ78cyuNITnNn+gQwdq6gnGRNGmsouDlNvvseHb2LgqYfHJ/5nLFz5ysGuEPGlDyFFVAHHyy4Kh5xhwnHal4t0zO7DZpxAS8TWKqBlsN9T8hiRMNRcte/kx8bUfxZSWy9WuOCj3H3ldmc9UQK90vdrtdnaRHQFc+KhbLDzGyJK8s0D1Uf8YaJxRhSV6HJ8i//gUStVldmYEVSHO4IRGVJOghI+UE5JHsM10DNowUMsoxhR5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pujCwPNLqcTJySf48Y35hJ/ze8ijOrN7I8y6qhN2/90=;
 b=lbE9Fq40JhDlN4hmSn3MxP/O82Fd1nLt4Rd9DOLxae0Jl3LPmHveVz7WbrtU54XjFMgtsECcMTDVh2N2hjyG0Z3T6iPGg6jTMNT5prOVBTrSRKBccO7wRfHYIq5YDWIzrdG8rI83Lif30ACoWVABFR/qyAoGJLjp5Y5E4Mm3AKQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB9039.namprd12.prod.outlook.com (2603:10b6:8:de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 00:35:13 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.037; Thu, 5 Jun 2025
 00:35:10 +0000
Message-ID: <d22f7319-6748-4d06-805d-a6b1494e425f@amd.com>
Date: Thu, 5 Jun 2025 10:35:01 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
From: Alexey Kardashevskiy <aik@amd.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
 <55ebb008-a26f-4173-937a-3bb2d8a6c972@amd.com>
Content-Language: en-US
In-Reply-To: <55ebb008-a26f-4173-937a-3bb2d8a6c972@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY8PR01CA0023.ausprd01.prod.outlook.com
 (2603:10c6:10:29c::33) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB9039:EE_
X-MS-Office365-Filtering-Correlation-Id: 634aaa26-0c98-40aa-e77e-08dda3c8d382
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clNsTjJ4TUk3djA3elUzYVp3UVdMN0cvNFVsVWJ0VkNVbXM3M2tMUzdsMm40?=
 =?utf-8?B?SnEwV0VlUVhrRWg4Z0MyY21FdlRJRm9vQXJRMDl1dnJpOFFjQXd4aHJYc1Yy?=
 =?utf-8?B?UmtEN3NyM1V5b29oOE1xLzJUZ25FYk9TellTZzNYSkdHVzcwNFRZR1F1MXdO?=
 =?utf-8?B?NStIT1JmSVJ5aWJwUFRZSDRLdzh4dkhUbFVoTXV4U0pHY1Vqc0oxNlNaUzR6?=
 =?utf-8?B?d2ZVbHlPd0E5N0FSck1yYTZtSk1qQkZJc0EwejdpTnNXVVhLdnZHMmY1KzdW?=
 =?utf-8?B?MWhUWjZIa3QzV2Vvdll5QkdNVUJqSXVkSklOTlAvTHdoRWFGbUZtR0tMdm1Y?=
 =?utf-8?B?dEszM3E5a3g2Z0liUTdHYjVQVDZrcUNpWUJrWURqYTkybldUMmZ6UHFISnAx?=
 =?utf-8?B?bDNXQTRrMkptd09SOUFWTE5JVEhxZy96UWgwRm9iM1RuV1dnQlhNSkpkWDM3?=
 =?utf-8?B?cDNXKzVEZXRSN2I4K3AyR0ZnM1FJTVJvc2x5WTF1MUVnbVl5TkN5QXliQ2lM?=
 =?utf-8?B?Q2UvNGloL1lKdEliL0w4U0pUenFWeFVVbDNuZGdTa1VqL2VGeEFOcllabm1E?=
 =?utf-8?B?ZS9YMzBxTWlVSEZRTmNyRWh3MmQ4QUl3c2JIdHB1Q0J4UDlPNitwM2l6ckZC?=
 =?utf-8?B?b1hvZ0NKeE9lTHFIbGtvNjU0cXFaR0M0UER5Smp4T2xqRTJic0NwWFFLbytD?=
 =?utf-8?B?REZEYUVpak5oSUxZdS9kdHFDcndYaGNBUVkwcW0zWkRIS0hqektBM05UQk1y?=
 =?utf-8?B?ZDlndFN5OXp5QXpXQWt6VWsydjVncEdZWjhJeVU0RlgvSUl3NVg5Zm5ya2k3?=
 =?utf-8?B?TE5wWnBKVlBMK0ZGTDQ4RUpRZnp3Rzl4Y28vc1ZPSVU1QUZMWHp3YWFqb21v?=
 =?utf-8?B?VXhyZGxML3UvMmgrMEQ4UExnODluRjVEQ1RXVEZsQ0Rxb2hsSTZHaHMrOTJF?=
 =?utf-8?B?MnVZTno2d3lMU1AzNjRMdzM2RVZ4WWJEcWpnc0E3YlRxSzNDNEdNSno3SVhp?=
 =?utf-8?B?VnlTdG5wbDFUeVBVWE4rZ0tJb1Z6SGxnbytzalljMGlrd2xnRVhqK3VqZWdD?=
 =?utf-8?B?UkdKaE0yZVArYkY2MytEbzkwenEvaDR0bXNBMTY1a0k0VEhVRmxFZDFPeVpw?=
 =?utf-8?B?aDlzQW5XM0wxMzYwUm9yY2VwR1VndlBLSnpnZlJER2IyN3VaQUdxUnYrN1Ft?=
 =?utf-8?B?T2dLM1htOXpieGVrVE9lclpiR0l3RjNtb0RyUGphdkRTQUZ0cSs3emU4T0t6?=
 =?utf-8?B?ZWVpRjRoRm5mUUVXUHFDcDNQeFRSUW5ibzNjc2cxZ1hhNTRyRGc5bmZxRE41?=
 =?utf-8?B?NC9WYTQvUGc5NysrMWVFWFZaaW9sV09GTUx2RHluZ1JxQkkrTWVzKzc1TWFJ?=
 =?utf-8?B?aE5DNENtN2MxVVVFY3k1OUdyY0pHMUVFZ3pPQ0w4M0xFdDZZVHdRT1hZRzEr?=
 =?utf-8?B?QkZJcTlFRWpkMm1vQzlWRng5NUhZdzRLSWlSclNtNEJmY1czZk5Xcm9UVEhQ?=
 =?utf-8?B?SE4zS21RTEkxU3VsVVZBbCtCMkhXdlJpRXo1bjZaZEl4Q21xSnI3QUkxWlBu?=
 =?utf-8?B?R0kremc0cHFDV0MvUms4cHg4a3h2dGRzTW4yamFsSUxiODNPcmZtOFVXNnlD?=
 =?utf-8?B?UlhJNWFBRHB4eHZYNFdFdHNKbWhiZ1RONGduaGR4a3FoMDNNRlRGQmtPTmhI?=
 =?utf-8?B?eEM0OGUvWXoyQjEybFZsOW5xdUJ1ZHh5VGFIcnJRQ3J4bzZjRUIrM0VZeDF4?=
 =?utf-8?B?VE5DVlVvcFdWSDhXT2NDSGVvWHZkWUhxNlBXcHkxb2EvOXV1QXNmakhsSmY4?=
 =?utf-8?B?NFdoK1VubkdqbkZnRXl2OURUL25UNkRWV3Awd2lXclZqU3N5RGlQU3VTdGhy?=
 =?utf-8?B?NmlLWWJ1K0lvNmRiUzNBQkNSVWdncld4Y2VxSTZKSEpwWFVKRUhqNXl6Vlhi?=
 =?utf-8?Q?KkyoEEjV5kY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azVKVTJQTi9PM2kxaEZNL1ZVcjlDYWpBRFdmVThKcEJPZ3RtOEg2MitneE1o?=
 =?utf-8?B?V1pML1lDaTJtMGoyNGQ3d3E4QzFmSDczVGd1K3dGY3ltcGFERUpmbVd1ODlR?=
 =?utf-8?B?TUxaZVkvVzhyaDRPanQ4Q3J4N1JpMEl1YXpJS2hOUEVKSk51VXhBOGs5ZWcv?=
 =?utf-8?B?aDZlcXBXWCtOc204eEpkQlRWcUR4aTl4Qzc1WlVmQlY5UldSR3MyWDVQdm5q?=
 =?utf-8?B?Z0FySzd5blBlN2ZUQ0l2cHVnOGlObXY3ZTRMeUNCZXJaYkppY05wM093cjVz?=
 =?utf-8?B?MzZEbmVMdlNtMFNleTFjYUtQckJRVUNONkpFYWZ3UUtPWHh5Y3F5dTlYQjdF?=
 =?utf-8?B?UTBYMDQzNWk1eTVlaVBLaUgwK3F5WGl6VHdJRUdXcS9QVFpPSUVlaWpKamdh?=
 =?utf-8?B?UjNBeFdpSE9xTU5rQkl0QTNmR0F5aGVwREVreCtqZFVRRHFKNXppY3ZFWWFy?=
 =?utf-8?B?R24rN2ZoRGRuaHN5SS95a3owQnMwUzFDeDY0SGpWM0Y5b09RcHFwdnpHUUtp?=
 =?utf-8?B?WFlsaHZhV2hBWjhmN1pGellvTGs0NHpadHFXUGYwK0M4SksrdVh1d0hROGxy?=
 =?utf-8?B?eUlkL2QyTERGUWtCRjhNNGh1Y1JtdjI0akdzWnhMb21FNEdtQlBrc1g0RHF1?=
 =?utf-8?B?NnhhU2hZV1pOMFI5WFhmdGhXaEt6V2tPenJDQUt4Rk5aSVdRQlpQb3VCOXVK?=
 =?utf-8?B?K25OZnBTZ3VjMjFLcU1jTDNMRnJpUVNZM1VqN0ExWUc0Qk1VdkhjRVhTd09m?=
 =?utf-8?B?dXJBeFZtSy91SWVhTGM4cDJtbGRkSTE4VDNzM1pnN3ltM2tML3RJSDZnSlNx?=
 =?utf-8?B?RjV4N0tpWGJ5RUFwbTQ0dlRHZlNsZkJHQmkwekJkL1V0U0JoanVnV2l2MFZi?=
 =?utf-8?B?Y3ZuQ0o4a2ptZWQycm5Zbmx6ZWFRUERUU0wyRmRkY0V0N05IUDdEMWJoVXVR?=
 =?utf-8?B?VFZ2MnhRRzlwOTBCUmhxTkFDd013Q0pJcWFIR2RCYnV1U0xJcEFPelpmdzl3?=
 =?utf-8?B?SzhoMmIxNVlqRmFybU5CRTVWb3g3S1RVN1VpVVdSamRhclQ4UlYydVQvTldN?=
 =?utf-8?B?b1U2U1I4OG1KOXEzSWc3UEZ2RWNhcnN2SFVBRFMrZW9NK0lCR2hvUXNJck42?=
 =?utf-8?B?OG1rNjc4b09RUHpHYzgrRHIyZW9URWhrUW5uNkJsaFVTL3BLeEpJeXZkaWRr?=
 =?utf-8?B?VUVwRWVuSGZ1clZaUCtQU21hU2ZwaE9wQmNTMU5HZTlSeGZVdE4zYTNMSEg0?=
 =?utf-8?B?T1Q0L1ZXdkxFOTg4eEpMWGZwQTNqYi9ONGZWMWVTZVJyd0VKL0h0VS84Q1cz?=
 =?utf-8?B?R2Zxa0JLVTdlL1VmWW9nUWw5RTFmdHhLeGhnTnJVZUNCM0pyNm50NzVrM3ND?=
 =?utf-8?B?SjQ4Tmc0N0Fnd1hUaUpuYVdhaFF0UEw3RkFPMmxBS1ZHS3NORGkzWnRodlZZ?=
 =?utf-8?B?S1F2bVgwelN6eVUzcHVUb3J3WXRBWGwvYThIQkpCZUZ6SG5LZkxiS1ZtM3U1?=
 =?utf-8?B?TWVId1oreVFYN3AyUURpTTBKSlZ2aThVTjJJNUhDVzJqZk1YTGowNHRtby9k?=
 =?utf-8?B?NkNCQmxWalVrRU9vYXFGR3JTaU9uMkh4WUJkTDlqcEhZemZCdHVTNEErNzN6?=
 =?utf-8?B?TjVZR2RkSFJ6ZG9VQm80TFlBdXd2aFVZZThTa2ZwclhGbUEzMnlQY252MUxo?=
 =?utf-8?B?V0dmY2tGNm1UTlZDQVJ5SkpkTjdIbE9jNXdOSlVlOFgxNzFEMS9mb1dSVGcr?=
 =?utf-8?B?eGF6aFlYQm5WSngyVDZacStYZUZhaXgvRTJ2RlJxVEp5YUlFRjUzb1BvdHhs?=
 =?utf-8?B?dzh0NmZEOHhyVDhhTHdSTDJxdkFBbHE4d0dhRnZkcW0xOUQxWVcxWlV6UFcr?=
 =?utf-8?B?ZWZnNHJDdmc1T0EzaFNKaTVOaWwzNUswaG51WTNTSXRUNjhtZ2s3alRpdXNl?=
 =?utf-8?B?blRqWk5yV0tjcUVtam5vM2Y3VTFpOS90UHhoMEdpUHJZdjNuYjluSjU4bjJR?=
 =?utf-8?B?dmxWTW5LcVYvYTEzU09yTHhUY1ppQXE0ZjFnWlFNUXB5QTFacnJTODJQeHRS?=
 =?utf-8?B?WktVZlgwSDRwUzZZalNlZXAzbkRVSGtEVDhSYk1CTUgvWHhud1ZXUkFUWFBo?=
 =?utf-8?Q?GciYJMVc0FsMPCIzw0taShZcS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634aaa26-0c98-40aa-e77e-08dda3c8d382
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 00:35:09.8481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjVhU8BQOSfKgKNvheMrONomHhNNEK1Hc9GRzzY+EfhZ3kBnmp7fkM0A29w92Mgp6o0fJ8sNFLu6x77XJ8KedQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9039



On 4/6/25 21:04, Alexey Kardashevskiy wrote:
> 
> 
> On 30/5/25 18:32, Chenyi Qiang wrote:
>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>> discard") highlighted that subsystems like VFIO may disable RAM block
>> discard. However, guest_memfd relies on discard operations for page
>> conversion between private and shared memory, potentially leading to
>> the stale IOMMU mapping issue when assigning hardware devices to
>> confidential VMs via shared memory. To address this and allow shared
>> device assignement, it is crucial to ensure the VFIO system refreshes
>> its IOMMU mappings.
>>
>> RamDiscardManager is an existing interface (used by virtio-mem) to
>> adjust VFIO mappings in relation to VM page assignment. Effectively page
>> conversion is similar to hot-removing a page in one mode and adding it
>> back in the other. Therefore, similar actions are required for page
>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>> facilitate this process.
>>
>> Since guest_memfd is not an object, it cannot directly implement the
>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>> have a memory backend while others do not. Notably, virtual BIOS
>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>> backend.
>>
>> To manage RAMBlocks with guest_memfd, define a new object named
>> RamBlockAttributes to implement the RamDiscardManager interface. This
>> object can store the guest_memfd information such as bitmap for shared
>> memory and the registered listeners for event notification. In the
>> context of RamDiscardManager, shared state is analogous to populated, and
>> private state is signified as discarded. To notify the conversion events,
>> a new state_change() helper is exported for the users to notify the
>> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
>> shared mapping.
>>
>> Note that the memory state is tracked at the host page size granularity,
>> as the minimum conversion size can be one page per request and VFIO
>> expects the DMA mapping for a specific iova to be mapped and unmapped
>> with the same granularity. Confidential VMs may perform partial
>> conversions, such as conversions on small regions within larger ones.
>> To prevent such invalid cases and until DMA mapping cut operation
>> support is available, all operations are performed with 4K granularity.
>>
>> In addition, memory conversion failures cause QEMU to quit instead of
>> resuming the guest or retrying the operation at present. It would be
>> future work to add more error handling or rollback mechanisms once
>> conversion failures are allowed. For example, in-place conversion of
>> guest_memfd could retry the unmap operation during the conversion from
>> shared to private. For now, keep the complex error handling out of the
>> picture as it is not required.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v6:
>>      - Change the object type name from RamBlockAttribute to
>>        RamBlockAttributes. (David)
>>      - Save the associated RAMBlock instead MemoryRegion in
>>        RamBlockAttributes. (David)
>>      - Squash the state_change() helper introduction in this commit as
>>        well as the mixture conversion case handling. (David)
>>      - Change the block_size type from int to size_t and some cleanup in
>>        validation check. (Alexey)
>>      - Add a tracepoint to track the state changes. (Alexey)
>>
>> Changes in v5:
>>      - Revert to use RamDiscardManager interface instead of introducing
>>        new hierarchy of class to manage private/shared state, and keep
>>        using the new name of RamBlockAttribute compared with the
>>        MemoryAttributeManager in v3.
>>      - Use *simple* version of object_define and object_declare since the
>>        state_change() function is changed as an exported function instead
>>        of a virtual function in later patch.
>>      - Move the introduction of RamBlockAttribute field to this patch and
>>        rename it to ram_shared. (Alexey)
>>      - call the exit() when register/unregister failed. (Zhao)
>>      - Add the ram-block-attribute.c to Memory API related part in
>>        MAINTAINERS.
>>
>> Changes in v4:
>>      - Change the name from memory-attribute-manager to
>>        ram-block-attribute.
>>      - Implement the newly-introduced PrivateSharedManager instead of
>>        RamDiscardManager and change related commit message.
>>      - Define the new object in ramblock.h instead of adding a new file.
>> ---
>>   MAINTAINERS                   |   1 +
>>   include/system/ramblock.h     |  21 ++
>>   system/meson.build            |   1 +
>>   system/ram-block-attributes.c | 480 ++++++++++++++++++++++++++++++++++
>>   system/trace-events           |   3 +
>>   5 files changed, 506 insertions(+)
>>   create mode 100644 system/ram-block-attributes.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 6dacd6d004..8ec39aa7f8 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>   F: system/memory_mapping.c
>>   F: system/physmem.c
>>   F: system/memory-internal.h
>> +F: system/ram-block-attributes.c
>>   F: scripts/coccinelle/memory-region-housekeeping.cocci
>>   Memory devices
>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>> index d8a116ba99..1bab9e2dac 100644
>> --- a/include/system/ramblock.h
>> +++ b/include/system/ramblock.h
>> @@ -22,6 +22,10 @@
>>   #include "exec/cpu-common.h"
>>   #include "qemu/rcu.h"
>>   #include "exec/ramlist.h"
>> +#include "system/hostmem.h"
>> +
>> +#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
>>   struct RAMBlock {
>>       struct rcu_head rcu;
>> @@ -91,4 +95,21 @@ struct RAMBlock {
>>       ram_addr_t postcopy_length;
>>   };
>> +struct RamBlockAttributes {
>> +    Object parent;
>> +
>> +    RAMBlock *ram_block;
>> +
>> +    /* 1-setting of the bitmap represents ram is populated (shared) */
>> +    unsigned bitmap_size;
>> +    unsigned long *bitmap;
>> +
>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>> +};
>> +
>> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
>> +void ram_block_attributes_destroy(RamBlockAttributes *attr);
>> +int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
>> +                                      uint64_t size, bool to_discard);
>> +
>>   #endif
>> diff --git a/system/meson.build b/system/meson.build
>> index c2f0082766..2747dbde80 100644
>> --- a/system/meson.build
>> +++ b/system/meson.build
>> @@ -17,6 +17,7 @@ libsystem_ss.add(files(
>>     'dma-helpers.c',
>>     'globals.c',
>>     'ioport.c',
>> +  'ram-block-attributes.c',
>>     'memory_mapping.c',
>>     'memory.c',
>>     'physmem.c',
>> diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
>> new file mode 100644
>> index 0000000000..514252413f
>> --- /dev/null
>> +++ b/system/ram-block-attributes.c
>> @@ -0,0 +1,480 @@
>> +/*
>> + * QEMU ram block attributes
>> + *
>> + * Copyright Intel
>> + *
>> + * Author:
>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
>> + * See the COPYING file in the top-level directory
>> + *
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "system/ramblock.h"
>> +#include "trace.h"
>> +
>> +OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttributes,
>> +                                          ram_block_attributes,
>> +                                          RAM_BLOCK_ATTRIBUTES,
>> +                                          OBJECT,
>> +                                          { TYPE_RAM_DISCARD_MANAGER },
>> +                                          { })
>> +
>> +static size_t
>> +ram_block_attributes_get_block_size(const RamBlockAttributes *attr)
>> +{
>> +    /*
>> +     * Because page conversion could be manipulated in the size of at least 4K
>> +     * or 4K aligned, Use the host page size as the granularity to track the
>> +     * memory attribute.
>> +     */
>> +    g_assert(attr && attr->ram_block);
>> +    g_assert(attr->ram_block->page_size == qemu_real_host_page_size());
>> +    return attr->ram_block->page_size;
>> +}
>> +
>> +
>> +static bool
>> +ram_block_attributes_rdm_is_populated(const RamDiscardManager *rdm,
>> +                                      const MemoryRegionSection *section)
>> +{
>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    const uint64_t first_bit = section->offset_within_region / block_size;
>> +    const uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
>> +    unsigned long first_discarded_bit;
>> +
>> +    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>> +                                           first_bit);
>> +    return first_discarded_bit > last_bit;
>> +}
>> +
>> +typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
>> +                                               void *arg);
>> +
>> +static int
>> +ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
>> +                                        void *arg)
>> +{
>> +    RamDiscardListener *rdl = arg;
>> +
>> +    return rdl->notify_populate(rdl, section);
>> +}
>> +
>> +static int
>> +ram_block_attributes_notify_discard_cb(MemoryRegionSection *section,
>> +                                       void *arg)
>> +{
>> +    RamDiscardListener *rdl = arg;
>> +
>> +    rdl->notify_discard(rdl, section);
>> +    return 0;
>> +}
>> +
>> +static int
>> +ram_block_attributes_for_each_populated_section(const RamBlockAttributes *attr,
>> +                                                MemoryRegionSection *section,
>> +                                                void *arg,
>> +                                                ram_block_attributes_section_cb cb)
>> +{
>> +    unsigned long first_bit, last_bit;
>> +    uint64_t offset, size;
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    int ret = 0;
>> +
>> +    first_bit = section->offset_within_region / block_size;
>> +    first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>> +                              first_bit);
>> +
>> +    while (first_bit < attr->bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_bit * block_size;
>> +        last_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>> +                                      first_bit + 1) - 1;
>> +        size = (last_bit - first_bit + 1) * block_size;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            error_report("%s: Failed to notify RAM discard listener: %s",
>> +                         __func__, strerror(-ret));
>> +            break;
>> +        }
>> +
>> +        first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>> +                                  last_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int
>> +ram_block_attributes_for_each_discarded_section(const RamBlockAttributes *attr,
>> +                                                MemoryRegionSection *section,
>> +                                                void *arg,
>> +                                                ram_block_attributes_section_cb cb)
>> +{
>> +    unsigned long first_bit, last_bit;
>> +    uint64_t offset, size;
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    int ret = 0;
>> +
>> +    first_bit = section->offset_within_region / block_size;
>> +    first_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>> +                                   first_bit);
>> +
>> +    while (first_bit < attr->bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_bit * block_size;
>> +        last_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>> +                                 first_bit + 1) - 1;
>> +        size = (last_bit - first_bit + 1) * block_size;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            error_report("%s: Failed to notify RAM discard listener: %s",
>> +                         __func__, strerror(-ret));
>> +            break;
>> +        }
>> +
>> +        first_bit = find_next_zero_bit(attr->bitmap,
>> +                                       attr->bitmap_size,
>> +                                       last_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static uint64_t
>> +ram_block_attributes_rdm_get_min_granularity(const RamDiscardManager *rdm,
>> +                                             const MemoryRegion *mr)
>> +{
>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +
>> +    g_assert(mr == attr->ram_block->mr);
>> +    return ram_block_attributes_get_block_size(attr);
>> +}
>> +
>> +static void
>> +ram_block_attributes_rdm_register_listener(RamDiscardManager *rdm,
>> +                                           RamDiscardListener *rdl,
>> +                                           MemoryRegionSection *section)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    int ret;
>> +
>> +    g_assert(section->mr == attr->ram_block->mr);
>> +    rdl->section = memory_region_section_new_copy(section);
>> +
>> +    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
>> +
>> +    ret = ram_block_attributes_for_each_populated_section(attr, section, rdl,
>> +                                    ram_block_attributes_notify_populate_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to register RAM discard listener: %s",
>> +                     __func__, strerror(-ret));
>> +        exit(1);
>> +    }
>> +}
>> +
>> +static void
>> +ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
>> +                                             RamDiscardListener *rdl)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    int ret;
>> +
>> +    g_assert(rdl->section);
>> +    g_assert(rdl->section->mr == attr->ram_block->mr);
>> +
>> +    if (rdl->double_discard_supported) {
>> +        rdl->notify_discard(rdl, rdl->section);
>> +    } else {
>> +        ret = ram_block_attributes_for_each_populated_section(attr,
>> +                rdl->section, rdl, ram_block_attributes_notify_discard_cb);
>> +        if (ret) {
>> +            error_report("%s: Failed to unregister RAM discard listener: %s",
>> +                         __func__, strerror(-ret));
>> +            exit(1);
>> +        }
>> +    }
>> +
>> +    memory_region_section_free_copy(rdl->section);
>> +    rdl->section = NULL;
>> +    QLIST_REMOVE(rdl, next);
>> +}
>> +
>> +typedef struct RamBlockAttributesReplayData {
>> +    ReplayRamDiscardState fn;
>> +    void *opaque;
>> +} RamBlockAttributesReplayData;
>> +
>> +static int ram_block_attributes_rdm_replay_cb(MemoryRegionSection *section,
>> +                                              void *arg)
>> +{
>> +    RamBlockAttributesReplayData *data = arg;
>> +
>> +    return data->fn(section, data->opaque);
>> +}
>> +
>> +static int
>> +ram_block_attributes_rdm_replay_populated(const RamDiscardManager *rdm,
>> +                                          MemoryRegionSection *section,
>> +                                          ReplayRamDiscardState replay_fn,
>> +                                          void *opaque)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
>> +
>> +    g_assert(section->mr == attr->ram_block->mr);
>> +    return ram_block_attributes_for_each_populated_section(attr, section, &data,
>> +                                            ram_block_attributes_rdm_replay_cb);
>> +}
>> +
>> +static int
>> +ram_block_attributes_rdm_replay_discarded(const RamDiscardManager *rdm,
>> +                                          MemoryRegionSection *section,
>> +                                          ReplayRamDiscardState replay_fn,
>> +                                          void *opaque)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
>> +
>> +    g_assert(section->mr == attr->ram_block->mr);
>> +    return ram_block_attributes_for_each_discarded_section(attr, section, &data,
>> +                                            ram_block_attributes_rdm_replay_cb);
>> +}
>> +
>> +static bool
>> +ram_block_attributes_is_valid_range(RamBlockAttributes *attr, uint64_t offset,
>> +                                    uint64_t size)
>> +{
>> +    MemoryRegion *mr = attr->ram_block->mr;
>> +
>> +    g_assert(mr);
>> +
>> +    uint64_t region_size = memory_region_size(mr);
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +
>> +    if (!QEMU_IS_ALIGNED(offset, block_size) ||
>> +        !QEMU_IS_ALIGNED(size, block_size)) {
>> +        return false;
>> +    }
>> +    if (offset + size <= offset) {
>> +        return false;
>> +    }
>> +    if (offset + size > region_size) {
>> +        return false;
>> +    }
>> +    return true;
>> +}
>> +
>> +static void ram_block_attributes_notify_discard(RamBlockAttributes *attr,
>> +                                                uint64_t offset,
>> +                                                uint64_t size)
>> +{
>> +    RamDiscardListener *rdl;
>> +
>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>> +        MemoryRegionSection tmp = *rdl->section;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>> +            continue;
>> +        }
>> +        rdl->notify_discard(rdl, &tmp);
>> +    }
>> +}
>> +
>> +static int
>> +ram_block_attributes_notify_populate(RamBlockAttributes *attr,
>> +                                     uint64_t offset, uint64_t size)
>> +{
>> +    RamDiscardListener *rdl;
>> +    int ret = 0;
>> +
>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>> +        MemoryRegionSection tmp = *rdl->section;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>> +            continue;
>> +        }
>> +        ret = rdl->notify_populate(rdl, &tmp);
>> +        if (ret) {
>> +            break;
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static bool ram_block_attributes_is_range_populated(RamBlockAttributes *attr,
>> +                                                    uint64_t offset,
>> +                                                    uint64_t size)
>> +{
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>> +    unsigned long found_bit;
>> +
>> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>> +                                   first_bit);
>> +    return found_bit > last_bit;
>> +}
>> +
>> +static bool
>> +ram_block_attributes_is_range_discarded(RamBlockAttributes *attr,
>> +                                        uint64_t offset, uint64_t size)
>> +{
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>> +    unsigned long found_bit;
>> +
>> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
>> +    return found_bit > last_bit;
>> +}
>> +
>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>> +                                      uint64_t offset, uint64_t size,
>> +                                      bool to_discard)
>> +{
>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long nbits = size / block_size;
>> +    bool is_range_discarded, is_range_populated;
> 
> Can be reduced to "discarded" and "populated".
> 
>> +    const uint64_t end = offset + size;
>> +    unsigned long bit;
>> +    uint64_t cur;
>> +    int ret = 0;
>> +
>> +    if (!ram_block_attributes_is_valid_range(attr, offset, size)) {
>> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
>> +                     __func__, offset, size);
>> +        return -EINVAL;
>> +    }
>> +
>> +    is_range_discarded = ram_block_attributes_is_range_discarded(attr, offset,
>> +                                                                 size);
> 
> See - needlessly long line.
> 
>> +    is_range_populated = ram_block_attributes_is_range_populated(attr, offset,
>> +                                                                 size);
> 
> If ram_block_attributes_is_range_populated() returned (found_bit*block_size), you could tell from a single call if it is populated (found_bit == size) or discarded (found_bit == 0), otherwise it is a mix (and dump just this number in the tracepoint below).
> 
> And then ditch ram_block_attributes_is_range_discarded() which is practically cut-n-paste. And then open code ram_block_attributes_is_range_populated().

oops, cannot just drop find_next_bit(), my bad, need both find_next_bit() and find_next_zero_bit(). My point still stands though - if this is coded right here without helpers - it will look simpler. Thanks,


> 
> These two are not used elsewhere anyway.
> 
>> +
>> +    trace_ram_block_attributes_state_change(offset, size,
>> +                                            is_range_discarded ? "discarded" :
>> +                                            is_range_populated ? "populated" :
>> +                                            "mixture",
>> +                                            to_discard ? "discarded" :
>> +                                            "populated");
> 
> 
> I'd just dump 3 numbers (is_range_discarded, is_range_populated, to_discard) in the tracepoint as:
> 
> ram_block_attributes_state_change(uint64_t offset, uint64_t size, int discarded, int populated, int to_discard) "offset 0x%"PRIx64" size 0x%"PRIx64" discarded=%d populated=%d to_discard=%d"
> 
> 
> 
>> +    if (to_discard) {
>> +        if (is_range_discarded) {
>> +            /* Already private */
>> +        } else if (is_range_populated) {
>> +            /* Completely shared */
>> +            bitmap_clear(attr->bitmap, first_bit, nbits);
>> +            ram_block_attributes_notify_discard(attr, offset, size);
>> +        } else {
>> +            /* Unexpected mixture: process individual blocks */
>> +            for (cur = offset; cur < end; cur += block_size) {
> 
> imho a little bit more accurate to:
> 
> for (bit = first_bit; bit < first_bit + nbits; ++bit) {
> 
> as you already have calculated first_bit, nbits...
> 
>> +                bit = cur / block_size;
> 
> ... and drop this ...
> 
>> +                if (!test_bit(bit, attr->bitmap)) {
>> +                    continue;
>> +                }
>> +                clear_bit(bit, attr->bitmap);
>> +                ram_block_attributes_notify_discard(attr, cur, block_size);
> 
> .. and do: ram_block_attributes_notify_discard(attr, bit * block_size, block_size);
> 
> Then you can drop @cur which is used in one place inside the loop.
> 
> 
>> +            }
>> +        }
>> +    } else {
>> +        if (is_range_populated) {
>> +            /* Already shared */
>> +        } else if (is_range_discarded) {
>> +            /* Complete private */
> 
> s/Complete/Completely/
> 
>> +            bitmap_set(attr->bitmap, first_bit, nbits);
>> +            ret = ram_block_attributes_notify_populate(attr, offset, size);
>> +        } else {
>> +            /* Unexpected mixture: process individual blocks */
>> +            for (cur = offset; cur < end; cur += block_size) {
>> +                bit = cur / block_size;
>> +                if (test_bit(bit, attr->bitmap)) {
>> +                    continue;
>> +                }
>> +                set_bit(bit, attr->bitmap);
>> +                ret = ram_block_attributes_notify_populate(attr, cur,
>> +                                                           block_size);
>> +                if (ret) {
>> +                    break;
>> +                }
>> +            }
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block)
>> +{
>> +    uint64_t bitmap_size;
> 
> Not really needed.
> 
>> +    const int block_size  = qemu_real_host_page_size();
>> +    RamBlockAttributes *attr;
>> +    int ret;
>> +    MemoryRegion *mr = ram_block->mr;
>> +
>> +    attr = RAM_BLOCK_ATTRIBUTES(object_new(TYPE_RAM_BLOCK_ATTRIBUTES));
>> +
>> +    attr->ram_block = ram_block;
>> +    ret = memory_region_set_ram_discard_manager(mr, RAM_DISCARD_MANAGER(attr));
>> +    if (ret) {
> 
> Could just "if (memory_region_set_ram_discard_manager(...))".
> 
>> +        object_unref(OBJECT(attr));
>> +        return NULL;
>> +    }
>> +    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>> +    attr->bitmap_size = bitmap_size;
>> +    attr->bitmap = bitmap_new(bitmap_size);
>> +
>> +    return attr;
>> +}
>> +
>> +void ram_block_attributes_destroy(RamBlockAttributes *attr)
>> +{
>> +    if (!attr) {
> 
> 
> Rather g_assert().
> 
> 
>> +        return;
>> +    }
>> +
>> +    g_free(attr->bitmap);
>> +    memory_region_set_ram_discard_manager(attr->ram_block->mr, NULL);
>> +    object_unref(OBJECT(attr));
>> +}
>> +
>> +static void ram_block_attributes_init(Object *obj)
>> +{
>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(obj);
>> +
>> +    QLIST_INIT(&attr->rdl_list);
>> +}
> 
> Not used.
> 
>> +
>> +static void ram_block_attributes_finalize(Object *obj)
> 
> Not used.
> 
> Besides these two, feel free to ignore other comments :)
> 
> Otherwise,
> 
> Tested-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> 
> 
>> +{
>> +}
>> +
>> +static void ram_block_attributes_class_init(ObjectClass *klass,
>> +                                            const void *data)
>> +{
>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
>> +
>> +    rdmc->get_min_granularity = ram_block_attributes_rdm_get_min_granularity;
>> +    rdmc->register_listener = ram_block_attributes_rdm_register_listener;
>> +    rdmc->unregister_listener = ram_block_attributes_rdm_unregister_listener;
>> +    rdmc->is_populated = ram_block_attributes_rdm_is_populated;
>> +    rdmc->replay_populated = ram_block_attributes_rdm_replay_populated;
>> +    rdmc->replay_discarded = ram_block_attributes_rdm_replay_discarded;
>> +}
>> diff --git a/system/trace-events b/system/trace-events
>> index be12ebfb41..82856e44f2 100644
>> --- a/system/trace-events
>> +++ b/system/trace-events
>> @@ -52,3 +52,6 @@ dirtylimit_state_finalize(void)
>>   dirtylimit_throttle_pct(int cpu_index, uint64_t pct, int64_t time_us) "CPU[%d] throttle percent: %" PRIu64 ", throttle adjust time %"PRIi64 " us"
>>   dirtylimit_set_vcpu(int cpu_index, uint64_t quota) "CPU[%d] set dirty page rate limit %"PRIu64
>>   dirtylimit_vcpu_execute(int cpu_index, int64_t sleep_time_us) "CPU[%d] sleep %"PRIi64 " us"
>> +
>> +# ram-block-attributes.c
>> +ram_block_attributes_state_change(uint64_t offset, uint64_t size, const char *from, const char *to) "offset 0x%"PRIx64" size 0x%"PRIx64" from '%s' to '%s'"
> 
> 
> 

-- 
Alexey


