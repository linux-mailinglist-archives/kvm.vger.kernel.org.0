Return-Path: <kvm+bounces-53000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC85DB0C6E1
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 009BD17D5ED
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41EE28C878;
	Mon, 21 Jul 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kdGhhjR4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2063.outbound.protection.outlook.com [40.107.101.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AAD22EF4;
	Mon, 21 Jul 2025 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753109455; cv=fail; b=R7jrN9H0ks5JTGkKodYwoRS08jKy2gwpTq5ESJvtjoTcylb8BPVW/Qo4RYfe4pLZ2zZUWeWxrN+B8bTIbCe6XL0z2NyItQoD4v+Fn68YI3KFZ0YiWZw4HS+rAwthppY6HBJVZLlOZ+Z/30fCx21ldCWDdwot4gXhUdRQIsoThHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753109455; c=relaxed/simple;
	bh=KGu4xJgzrPf2GOR2DgqZyRCy67BHTKtPsM6Hrw/+S/I=;
	h=Message-ID:Date:From:To:Cc:References:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=H9aU4IMC7iT0mXEh2d6QV8zJWvj/pRWaxV+njdAMlRa7mjrnUtLo+Wd9VYM2T/OwCSOl+NSbTpvg/bziMRTb3ju+lCC6UheXfdNSNuSippxDqf9cdLTwMdF0uocvuo3E4xlrbzuDJLP5C2AkPSBIQRfYhukZBQ8SdWQSQ3FOlMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kdGhhjR4; arc=fail smtp.client-ip=40.107.101.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gWMlOHF/5dabgCD/Rl7jIaf4kUOF6asB63mgtS48IPuTAcpN+UUzQ0JzScNuAVlSmWlL9xeIByVfKpgst1X/n9IXiXqZdCWFcUTmGKh7ZKJeiiAwwOXFon/WkpZzpBlUCkrwGrm2SAup6CNtXWHMH+2Q3/4t5loMkYUNXoDoi2bU3lGfqv/R+t97aNmiNX4TKEHFsp6g7dmhKHvGXS8CPS0nfsDtvxOBS/IKDGrE1N/ZTUNr1z+cX+6L4VtGVyFdUtqAgMUCf1+uXU+XfMNhnPb08Dsu7SwxvoiPrz8nhnrDRdeSXsSAELGDBtUy71X8Y1fPR+qMe0nV6A9qTtJ5hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+4nXvjRIKoe01dUizWmpy1RL4CT+IMZWDZ1xgC0+tA=;
 b=Oufr2xbDCwiKDuVGm4ZZMxVH6zYjbFsIksP66WyycKSDc+41N1nRCtPa1WMwdIkV/M9jYH84XqDRt1vo3RI3wQ3tMrvPlX1JYvF6mmgi9MdI2h34IMeL224GuLwzhDYX7ppSSkKaEUxJzy1lPixPaRIPVfWViyfjofNc7VVKAhmbZ3U91ah+jPfcN8YtpkQbb7WYhZBqQZwOsmEOzoRP531pdqLB4ElE1FtJfL/GUcatPfHq+d0bjsufJtffpteF97/Fx9DoVP73u5vp8Q3uuUkLBo3TOaaqqo43jdXlQS3FeRAhnprtMbJDPhQQrM19FWPjhcRBIWmbHKUj9BOxEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+4nXvjRIKoe01dUizWmpy1RL4CT+IMZWDZ1xgC0+tA=;
 b=kdGhhjR4KEbMljTrBFujObLPPjegJ/C5MHKMPGqoS1urVJpHDu1uzWR3srWoAicKuQDfEN0jI/VuTDo2gqAqETNAHQeQJqvoeBogh85sjFHRs+MBr6VrIBG7ieW0D4z4m46srfNsfVlD4buZBAogI6Sr5oqHC78blHkQPrdSTRw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB6421.namprd12.prod.outlook.com (2603:10b6:8:b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 14:50:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 14:50:50 +0000
Message-ID: <8374a887-9bde-c7c0-ace2-0afe22f1f616@amd.com>
Date: Mon, 21 Jul 2025 09:50:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, kas@kernel.org, rick.p.edgecombe@intel.com,
 dwmw@amazon.co.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, reinette.chatre@intel.com,
 isaku.yamahata@intel.com, dan.j.williams@intel.com, ashish.kalra@amd.com,
 nik.borisov@suse.com, chao.gao@intel.com, sagis@google.com
References: <cover.1752730040.git.kai.huang@intel.com>
 <f999349e-accb-dcd6-75f4-eb36e0dda79f@amd.com>
Subject: Re: [PATCH v4 0/7] TDX host: kexec/kdump support
In-Reply-To: <f999349e-accb-dcd6-75f4-eb36e0dda79f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0155.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: ec991b94-f161-440b-bba8-08ddc865fc01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cWhHMDFtemNFdEZiRmk1U2VxZU9iblovT3FTT0ZNOFpPOS9JL213dzdiRm9h?=
 =?utf-8?B?REtSNVNtNm9GZW5nVEJ1dzRpYk40UXZERmxRSjJOdDBGMWhoRlQ3MUJjd1kz?=
 =?utf-8?B?ZExFU2EybTFjSWtFaVVDRlJMNDNwWU0zL1JTM1JhdVAxcWphVzQ1RzhEZWNE?=
 =?utf-8?B?VkxQTmt2bnR4WlgybXN6WVB5RW9hQy9IU25WUlZHK2ZwSGI4MlZmM3hEVTNR?=
 =?utf-8?B?aXV1cU5kK20xTjVOS3NwM3JVODBVc2lDN3kwSUVHazc2d0VjZ2JaTHNNdEN5?=
 =?utf-8?B?TG9kb2pIV1pqQlFOY0hSaUFROHhONXRGNGQ5cEdhR0I1VUJBbkVyZ1EyQzR5?=
 =?utf-8?B?bjlKdXN0SS91VWhTTWxjWXgxUDhwWVNKYTBjUkRZRUhmL1hvQlRRUm5BVVNm?=
 =?utf-8?B?UGRnV0RodDA2Ris5RlZRK0E1WFI3U1FJdVdsNXV4UWVMdWtBMkw1SkJ6K2lN?=
 =?utf-8?B?R1VkbFhDSHBqVlZBMit0VXFoOStIVFZzc3h1eWs4WmNJa200MzhCblNwTERZ?=
 =?utf-8?B?elhFTk1rUmttSTIwVVJtZzhJc3VBakJEYlhJd3p6MDJXSG04Ti9HTmdLN1Rr?=
 =?utf-8?B?cThMOUpzWDU2Y2p1TkYxN1RXTHIwRmN6Y1JhT2pWV1FnYTYvRUM3L0RoTmVi?=
 =?utf-8?B?RG8weXV2MUNIV05OeVFIK0tBYUdQVjhFWUpqOE9TbW94elNBREQ4SlB3L2lM?=
 =?utf-8?B?YVMxSmdPUThpb2x0c1lXZEcwWmJSV1A3VGFJeFVydnB4dUxWK3BkR2xITjRP?=
 =?utf-8?B?Vm1rMWNEdHU5ak9KclZLdElqa3BYWkp1RFZqZDdEd1RMMlRPREliWTlkWmJ1?=
 =?utf-8?B?YXQ4QzYzSFNqMnpvSCs1K0N1Y2hSN1RpOVc1WXhWZlRCM25BUHFXdHhaWWJ2?=
 =?utf-8?B?Z09JamRGQWs4S3dabjViS0M4V3Q4WjZrVjFvUXpPVW9vT09mblFyVGYwdDdI?=
 =?utf-8?B?N0lUSUFwUWF0UmhkK0dXWjJZTFlGT3ZIMDQ1d0t3eHZaSjRjd3E3OVg4aWpl?=
 =?utf-8?B?UFZQYnJCZHlwZDZ0NXVMTThBTGtXazd2QURwdm5VRjFCNTNBdmZkY2dMdHJq?=
 =?utf-8?B?UzlMRjluUUcxeXdieGtBaGhUQm10Z2lzUnJqRld1S0hDLzZRU0xGaS9UL1Fh?=
 =?utf-8?B?QXE3WmNYMXJ1eW4xb01Kem1hc0ZwaTVRODl2NWd2aE14TFQ5OXJVK1J3cVlL?=
 =?utf-8?B?VmZVdkxRZmI4RkpJSTZZQlNEVFdjSW9IUEtrNHMwSFkwajFYdStqK1F1b2Jm?=
 =?utf-8?B?dE1BblZ4WlhuSUMyZXhwK1gxMW5aY1ZBbHdLUFFJTG9YcEJsT1ZIdWlZaTdU?=
 =?utf-8?B?SjNOVUpFOXgxMVpqaXkyWXhHS2NvcC8zN255aU05NmtmNFhRUWtOZHpKeFhE?=
 =?utf-8?B?ZkZ3bENDWU5YZXZhNXVKSkw0QmJ5UU9uNFYxVktKMjVoR2YycUNOMktiTjly?=
 =?utf-8?B?Z1kvUXRpR2hPcG5QMXJIL0J5TG8rY3lJUHdqM1BnekdTcWZlSnlpdnB4OVBa?=
 =?utf-8?B?RzJqQlZUdTFLbzNwYVp2VEpTTlYrUUQrdmN3enYyWXlYTlpGRHYvRWd5a21j?=
 =?utf-8?B?TmYxNHJoRlFVYU01TTIrZGNHQS9NdFBMaHo1QmpQcTl5T3dhd0hKMEo5MHZ4?=
 =?utf-8?B?OGhiejFoLzNRVFRPUDRpNDdHSXhEZFowT29WbGIzSWtKNEVFclhHTitkV29u?=
 =?utf-8?B?NmIrR2RDVXpxZFBRUmVpOFZHNG5XTE93UjNWbU1kK1FtQVUvTzBHL2JlaVJD?=
 =?utf-8?B?eTRrOFhpNHdaNFpJTy9QRVkxMm83QVJTOXZtVFM5ekw0eGxwWjZicFpYWkFm?=
 =?utf-8?B?MXBqV0NsS1dDeGJ3NTNLYlFrbTRXOFFDTmJMZkdHNXVxYnRCTFhoamZQN2Rs?=
 =?utf-8?B?Q2owUU5CNVVhT2xGZ1U2RXFFMmxWSEVZdi9Ubks4SzFMUEZRZ0M1cERRL1lj?=
 =?utf-8?Q?87Wg5f2IGPA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHpJZXhxY2VEd3NRSnZ0ZjhRVmlLK09jMjdwbG9TNmFOZkdJaXVzbDJmSjBV?=
 =?utf-8?B?MTR4RDR1UTcyZlFyYkREMjVXMGRUVXZXVnlzUWRpa1g2VDIzVndjR0daYU81?=
 =?utf-8?B?eG12Y1ZhRGVUVis4NnNPSTB1bGdhVW9zM1lvRktmUDRZR0dPeldTNk03K2k1?=
 =?utf-8?B?R1pJT2RxTEhzTkxmNTIzOGc3UDAzSDNtM2ZxYTFCYXFyV3Q5N3BodmJNNE1U?=
 =?utf-8?B?S0x1VndVU1J2K1FLRkEwTHRHeC9meGx0Z0ZGem5icTRwOG9ESWc2T2F2VUNp?=
 =?utf-8?B?ZFlrUWRlbFB1ekxQbFZWRGxQM3M2cy9kdXVicU11cWVUclZPdmpockRhVE9H?=
 =?utf-8?B?Yk92bDNRc3hleWpUYVd6SGZEK1JBTDZwR3JKZk9TS1hId2I1UmdydXdWelYw?=
 =?utf-8?B?d2VMMm9lTm1qQXVBQWdGSnBEZFAxVlNjMC9JK2ZtajNtcHI4RS9mM2FYMFRa?=
 =?utf-8?B?NXhEYmtBYVdmVXVqY3NvUUo0N0xKTVNSWUhYVEFoYS9remM4SDhHdW5aWG1x?=
 =?utf-8?B?ZkN1TU5OZDAzVXAvWTVCem1hdTVsWUNiSVRhQ2ltd0lIdXdTWWdYNUozOXlB?=
 =?utf-8?B?bWJ0SEZxYjNvSFhjR1A5K0pGVFBheWV4c25HdzNsVUtrUlFoNGdGUU1NeEp6?=
 =?utf-8?B?eG5EV0VSWjZDbHhOMW9WN2FmN1VhSURUNFdPUkxaT2tkSU0wUmN2QkV0aE12?=
 =?utf-8?B?RHlRci9FcnloU244WlMyRXM0SE5jTHBMNzlRTTNVamtxNm15NndEU3lJZVdw?=
 =?utf-8?B?My9FYmIwNkwvaTZWSy9sbThSajgzZTd2U1JTOVZsTkpid2JyNGlNcW9TYzhu?=
 =?utf-8?B?cnpydWZnY0pDT01MZUdjMTAzWnNWWWo2Z0szbVp3bFM0VVFHRWFnaU9uUjFF?=
 =?utf-8?B?bGpSeDRkM1N6NXFlQ0JYcmx4Y0VnV0FWWlM1VDR4aGc1Q1ZZY3cvRzYxZkhu?=
 =?utf-8?B?SGFGVDAwb282QisyK0g3d2diT1grcVVwcjhWcHNiU1ZFL2FyU29ndnByS2p2?=
 =?utf-8?B?YTRSZmhzaWFNaUpqVm15NUVBZlZlMWdxZXovNS92SUJIOHNYVzUrMHlRNUVM?=
 =?utf-8?B?Q05zNkFiaXcvNDE3K2RxZ0QrSmtZRjN5MEVNTUFqTzNJeTNqWUZKMVU4RDBT?=
 =?utf-8?B?RDVCd1pYREoxSGI2NXJsRGZHZ1N0cnUvN3Z4SmFjNCtETnY2M2d6MzhldW1y?=
 =?utf-8?B?Tm9WZU00cks1WWhNb1hMZ0VhdFEwRlVuQmlrcmhlaXI0OXpWRm96Y2VOTEYz?=
 =?utf-8?B?S0JrZmR3SHViSGVEdkRaY2RLZXFheTFjZGpUZy9JMU9LengwbVFlRmJPa0Jx?=
 =?utf-8?B?K1ZudjN6V2F3VGtVYXlDN3BBWlA0aEsvTWY2OHVKWUxTMXJYWVN6dnQvUGRq?=
 =?utf-8?B?bkZhRUhkZ1VLQUNHb0JoS29JWkVpcDJ3S0hGRWNjVHJlRlV4TGtiSUdSTldw?=
 =?utf-8?B?by8xYmJoc1Vsc0dKTHdnQWpzRzE5dTZnNVdzMER6L3Z1K21xaGhEemdTNm9J?=
 =?utf-8?B?RGhFVUV5NVowZ2dPc1R1bnFGSDFqUHhXTjV4RGhzMlZ5SzNMYm1sOWcxd215?=
 =?utf-8?B?ZGxKdzZtQ3dkZXRpTlh6S2IyeldOS04xN3ozalRPWnpXbXNYRkVwUjVNQVBs?=
 =?utf-8?B?OS9xdmMzQkZhNGxmckRDeVdQWGZWRUZPcHU4UkdzaHZFL1JYL2NTTXQxZzBT?=
 =?utf-8?B?djNPM2lsMVUxM0s4cUUvM294WFRsNmZWeXllZ3BCNFY4bm9xa2xlcU1oUGgz?=
 =?utf-8?B?YjcxTEc2WjgxMTBIY1lTRjNLaEJxOWlnTnUxTFhFcktSTXh6ZS9zZ28zSlFh?=
 =?utf-8?B?ekJsU1hDaGdVajdKazVTMy9MU1JXaGtSNzFlcFNpR3A1c3NwSERmM3pEMC9h?=
 =?utf-8?B?dTBBNmFZaHNFL3RSVCtjU2FxUXVSaS9tNDUwc1NTTGtVVks3dkRXbWJERVRa?=
 =?utf-8?B?cmV3T3NCemk5dWZJUEkyVVhHS1JKWGNENjd2NnB0M1Jjblc0Q3F5blIxaVAy?=
 =?utf-8?B?ekRKdjJOSExKSC82cmtnbHEwQjZZNmpiMWU1cFVmZzdmYmFyLzc3a3BsN3Fx?=
 =?utf-8?B?MXNBTGxIMU9FWEMrdVVYb1ZQVnFaWlowWnlYeHc5NE15Z3hWRC9VN2NIMXZC?=
 =?utf-8?Q?HOLotTM6DBP7HNzZ3H/ed+BUL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec991b94-f161-440b-bba8-08ddc865fc01
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:50:50.4957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eVzRaMdPS3r5IyPPXr0fnStrfuWzJ1BHpKg0kM2tBWUJIs2x6RXt43v/94V1esW3+kjsGb4yrspRleedep7hHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6421

On 7/21/25 08:08, Tom Lendacky wrote:
> On 7/17/25 16:46, Kai Huang wrote:
>> This series is the latest attempt to support kexec on TDX host following
>> Dave's suggestion to use a percpu boolean to control WBINVD during
>> kexec.
>>
>> Hi Boris/Tom,
>>
>> As requested, I added the first patch to cleanup the last two 'unsigned
>> int' parameters of the relocate_kernel() into one 'unsigned int' and pass
>> flags instead.  The patch 2 (patch 1 in v3) also gets updated based on
>> that.  Would you help to review?  Thanks.
>>
>> I tested that both normal kexec and preserve_context kexec works (using
>> the tools/testing/selftests/kexec/test_kexec_jump.sh).  But I don't have
>> SME capable machine to test.
>>
>> Hi Tom, I added your Reviewed-by and Tested-by in the patch 2 anyway
>> since I believe the change is trivial and straightforward).  But due to
>> the cleanup patch, I appreciate if you can help to test the first two
>> patches again.  Thanks a lot!
> 
> Everything is working, Thanks!

See my comments in patch #1. I didn't test with context preservation, so
that bit was never set. If it was, I think things would have failed.

Thanks,
Tom

> 
> Tom
> 
>>
>> v3 -> v4:
>>  - Rebase to latest tip/master.
>>  - Add a cleanup patch to consolidate relocate_kernel()'s last two
>>    function parameters -- Boris.
>>  - Address comments received -- please see individual patches.
>>  - Collect tags (Tom, Rick, binbin).
>>
>>  v3: https://lore.kernel.org/kvm/cover.1750934177.git.kai.huang@intel.com/
>>
>> v2 -> v3 (all trivial changes):
>>
>>  - Rebase on latest tip/master
>>    - change to use __always_inline for do_seamcall() in patch 2
>>  - Update patch 2 (changelog and code comment) to remove the sentence
>>    which says "not all SEAMCALLs generate dirty cachelines of TDX
>>    private memory but just treat all of them do."  -- Dave.
>>  - Add Farrah's Tested-by for all TDX patches.
>>
>> The v2 had one informal RFC patch appended to show "some optimization"
>> which can move WBINVD from the kexec phase to an early stage in KVM.
>> Paolo commented and Acked that patch (thanks!), so this v3 made that
>> patch as a formal one (patch 6).  But technically it is not absolutely
>> needed in this series but can be done in the future.
>>
>> More history info can be found in v2:
>>
>>  https://lore.kernel.org/lkml/cover.1746874095.git.kai.huang@intel.com/
>>
>> === More information ===
>>
>> TDX private memory is memory that is encrypted with private Host Key IDs
>> (HKID).  If the kernel has ever enabled TDX, part of system memory
>> remains TDX private memory when kexec happens.  E.g., the PAMT (Physical
>> Address Metadata Table) pages used by the TDX module to track each TDX
>> memory page's state are never freed once the TDX module is initialized.
>> TDX guests also have guest private memory and secure-EPT pages.
>>
>> After kexec, the new kernel will have no knowledge of which memory page
>> was used as TDX private page and can use all memory as regular memory.
>>
>> 1) Cache flush
>>
>> Per TDX 1.5 base spec "8.6.1.Platforms not Using ACT: Required Cache
>> Flush and Initialization by the Host VMM", to support kexec for TDX, the
>> kernel needs to flush cache to make sure there's no dirty cachelines of
>> TDX private memory left over to the new kernel (when the TDX module
>> reports TDX_FEATURES.CLFLUSH_BEFORE_ALLOC as 1 in the global metadata for
>> the platform).  The kernel also needs to make sure there's no more TDX
>> activity (no SEAMCALL) after cache flush so that no new dirty cachelines
>> of TDX private memory are generated.
>>
>> SME has similar requirement.  SME kexec support uses WBINVD to do the
>> cache flush.  WBINVD is able to flush cachelines associated with any
>> HKID.  Reuse the WBINVD introduced by SME to flush cache for TDX.
>>
>> Currently the kernel explicitly checks whether the hardware supports SME
>> and only does WBINVD if true.  Instead of adding yet another TDX
>> specific check, this series uses a percpu boolean to indicate whether
>> WBINVD is needed on that CPU during kexec.
>>
>> 2) Reset TDX private memory using MOVDIR64B
>>
>> The TDX spec (the aforementioned section) also suggests the kernel
>> *should* use MOVDIR64B to clear TDX private page before the kernel
>> reuses it as regular one.
>>
>> However, in reality the situation can be more flexible.  Per TDX 1.5
>> base spec ("Table 16.2: Non-ACT Platforms Checks on Memory Reads in Ci
>> Mode" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
>> Mode"), the read/write to TDX private memory using shared KeyID without
>> integrity check enabled will not poison the memory and cause machine
>> check.
>>
>> Note on the platforms with ACT (Access Control Table), there's no
>> integrity check involved thus no machine check is possible to happen due
>> to memory read/write using different KeyIDs.
>>
>> KeyID 0 (TME key) doesn't support integrity check.  This series chooses
>> to NOT reset TDX private memory but leave TDX private memory as-is to the
>> new kernel.  As mentioned above, in practice it is safe to do so.
>>
>> 3) One limitation
>>
>> If the kernel has ever enabled TDX, after kexec the new kernel won't be
>> able to use TDX anymore.  This is because when the new kernel tries to
>> initialize TDX module it will fail on the first SEAMCALL due to the
>> module has already been initialized by the old kernel.
>>
>> More (non-trivial) work will be needed for the new kernel to use TDX,
>> e.g., one solution is to just reload the TDX module from the location
>> where BIOS loads the TDX module (/boot/efi/EFI/TDX/).  This series
>> doesn't cover this, but leave this as future work.
>>
>> 4) Kdump support
>>
>> This series also enables kdump with TDX, but no special handling is
>> needed for crash kexec (except turning on the Kconfig option):
>>
>>  - kdump kernel uses reserved memory from the old kernel as system ram,
>>    and the old kernel will never use the reserved memory as TDX memory.
>>  - /proc/vmcore contains TDX private memory pages.  It's meaningless to
>>    read them, but it doesn't do any harm either.
>>
>> 5) TDX "partial write machine check" erratum
>>
>> On the platform with TDX erratum, a partial write (a write transaction
>> of less than a cacheline lands at memory controller) to TDX private
>> memory poisons that memory, and a subsequent read triggers machine
>> check.  On those platforms, the kernel needs to reset TDX private memory
>> before jumping to the new kernel otherwise the new kernel may see
>> unexpected machine check.
>>
>> The kernel currently doesn't track which page is TDX private memory.
>> It's not trivial to reset TDX private memory.  For simplicity, this
>> series simply disables kexec/kdump for such platforms.  This can be
>> enhanced in the future.
>>
>>
>>
>> Kai Huang (7):
>>   x86/kexec: Consolidate relocate_kernel() function parameters
>>   x86/sme: Use percpu boolean to control WBINVD during kexec
>>   x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
>>   x86/kexec: Disable kexec/kdump on platforms with TDX partial write
>>     erratum
>>   x86/virt/tdx: Remove the !KEXEC_CORE dependency
>>   x86/virt/tdx: Update the kexec section in the TDX documentation
>>   KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
>>
>>  Documentation/arch/x86/tdx.rst       | 14 ++++-----
>>  arch/x86/Kconfig                     |  1 -
>>  arch/x86/include/asm/kexec.h         | 12 ++++++--
>>  arch/x86/include/asm/processor.h     |  2 ++
>>  arch/x86/include/asm/tdx.h           | 31 +++++++++++++++++++-
>>  arch/x86/kernel/cpu/amd.c            | 17 +++++++++++
>>  arch/x86/kernel/machine_kexec_64.c   | 43 ++++++++++++++++++++++------
>>  arch/x86/kernel/process.c            | 24 +++++++---------
>>  arch/x86/kernel/relocate_kernel_64.S | 30 +++++++++++--------
>>  arch/x86/kvm/vmx/tdx.c               | 12 ++++++++
>>  arch/x86/virt/vmx/tdx/tdx.c          | 16 +++++++++--
>>  11 files changed, 155 insertions(+), 47 deletions(-)
>>
>>
>> base-commit: e180b3a224cb519388c2f61ca7bc1eaf94cec1fb

