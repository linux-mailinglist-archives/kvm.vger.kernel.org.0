Return-Path: <kvm+bounces-38818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9C0A3E95B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:50:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 322427AC0B4
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919641A270;
	Fri, 21 Feb 2025 00:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="06M6Kfpu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43786EEC8
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 00:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740098935; cv=fail; b=DXa8orlGg/PJ9mwyY3BUu8tvXKW5eeIQxp/5E7kT9et55lyGhF2Lu4ITvQFm4h+6zwoC8nfpISq0g0rFwhgO7zu9pPmffXmHrM/Lc3aNnnBkdAm3XKT536wFhSTC43hf+GbMacqmnze9wy66U277MXY0Iq2Dz25rQOo9BY+cUTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740098935; c=relaxed/simple;
	bh=T6CPmDIRtIaFD3gOnw3vPtxk+21RrP7Ts7TG7AbgD2o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cAlx3/sDYPs4UgicipnBYbxJKmoTCYrAk77sNby27e0wN40CMgxYjbU5s1FTkDUWN2tYuu4aJZf1XNuc8kY+cRQ7gUmRTdafgA4AA9cngubDkuwvJq/35EhEYygFXIBg2/Ds2IKXef/EBJAKvA7a1LA4ruHOPzOHE1AoOxmTnNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=06M6Kfpu; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXVAvutbuUz22BTWf5dgKrNKBk9aLN7uNKoVFtd3ApR8teMAo58BP7pov8NVYZgmIPIgLA8MgNFQkpeHRjqU+MIpdQIjAWST4VuYIrnflRfr/u570vYPNC8hYarSNY2v40sjyWQi4TV7zXH1tyJahsg0+avBOext0itOApGxKKeDnTyfAXBB+PcuSenyEj5MByQCE8WO/M7y6sLwG8PdFagI6Zq+r/jpp0GZOKYjy0M06MAJPBOx1qVle9M5nFzMJ2377p9fK19JU765aVCI9w/DQvHSu28fgrAZyNtx2qMevVgJPZKZro0ItWF5tWO2xtepxvlV0eOnUjoG0bJkww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cra4AL3++r7JVv7n8iDHZihHtatT3qlI+kGWuOvI+fc=;
 b=bqCiZOZ11S8O0XUTYUwT3AA9SB6YuzCfnGKPryGTPmNZ0YrM6JSzVhiVpRDIPOnGIC1zgDSpVHCiHoPGT/E71GHJC0kPXbGfSp9hcwH6ZhRxU6SmUqv+JXTkrhW+x0aOWdrJEeguDFDoCnTHLN4k4PuIAYgMJAnqn2niwgvtE8uAnriT0MszUUh/CJN3cWv2CCIB0cH+hDLk3lebA52ODSeh4qGjVEjna8+iuyL/jIcUxD6n7iyAlrGGG23Z0aQiMIK1QL9Rr3gtMyqQtZo3NbRinAzGCWDYHi2HvJvct+MIEJK2OlbVJGg730EW7MEyY2IaQHLG6EgE3FQcZqPCNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cra4AL3++r7JVv7n8iDHZihHtatT3qlI+kGWuOvI+fc=;
 b=06M6Kfpu8CjENX3FrCkivBQX5XmY5du7Q64/ikXCoymJfd/dAGmbUNkKQOctG6dKiNdZNvtNR/stSpvVmrFFgRiDGSEAoy9x9xo2ivWJctH0YB83+y3DyKO0NLrsjBVPHJCky7G4IfIfEs7ISDkchvESVtjbwvrfDItIfyUsdoI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH7PR12MB6612.namprd12.prod.outlook.com (2603:10b6:510:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Fri, 21 Feb
 2025 00:48:50 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 00:48:50 +0000
Message-ID: <8466a8bd-540f-4f4e-9cdf-6cf233e48363@amd.com>
Date: Thu, 20 Feb 2025 18:48:47 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/6] target/i386: Add support for EPYC-Turin model
To: Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 davydov-max@yandex-team.ru
References: <cover.1738869208.git.babu.moger@amd.com>
 <3d918a6327885d867f89aa2ae4b4a19f0d5fb074.1738869208.git.babu.moger@amd.com>
 <Z7ccCtbPPuRRdGUN@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <Z7ccCtbPPuRRdGUN@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0028.namprd10.prod.outlook.com
 (2603:10b6:806:a7::33) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH7PR12MB6612:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e72dd6e-e292-4768-e0e0-08dd521181ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q050bjA2REdxWHFRQ1ZobmdraFU4UURMdXlnejU4UmtPeCtOWTVlSVltSlZw?=
 =?utf-8?B?d1A2d0xISmNYUk9XUGhUbHlWTStEdjJDcUZnRjBydmxKSUpYR1laL1ZFYlBG?=
 =?utf-8?B?K1QzcW5DSC9nZ3NhVUR3a1ZDZTRPbDR0SFM4L3V2R2xvUURoeTlaOG1IMHVn?=
 =?utf-8?B?OEpON3UvRTVOT0hNZWkyTWkxZWhTaWVMSVp4NW5ZWUFORm9Vd2FXN0hrVi9P?=
 =?utf-8?B?SkNhWnJDZWc4V0hjckdjOWVVYkRrZDVmcFhNSk1mNnhyQXBYU1pJclVyZWZp?=
 =?utf-8?B?YjgxN2JJSDRPbTQ1eWt5aTdGSGJ1QllwcnFjSnhSeFNTTzdud0tzTnQrd2ov?=
 =?utf-8?B?Smg2RW9JL2trdVRheVQ2MEtGd3RMUmdOLzNNRlU2aFhPK1RRYjQ1YUEyNkR6?=
 =?utf-8?B?YXdXbS9yK3JEYWRyQjNhTDBQTzFZL3pQb0p3WFB1K2E0Rlhoamd2S0VlNTV1?=
 =?utf-8?B?ZHpuT0tIUGhNNW1EZC9LeHBBL1R4aFk2aGFOUlJmeThIa2VvL1p5T2JOOGZD?=
 =?utf-8?B?cjhwMzhUd2x6T2g0aGFuelJ5aGpPOURxZVFwNnZQQ3ptY05IYTdxUHRrZUJy?=
 =?utf-8?B?U2ExYUhlaWxyV2tYQXRpQTUyQ2NKOHBndkk1UDhtVlJMTkJWWHllV1F4MjhD?=
 =?utf-8?B?VFpnL2FBOUVFSlNJRU5MaWwyVFVhRlhEN0ZXMDZGZnFncExuNUdoOWJhaTdN?=
 =?utf-8?B?VDRBeU92VjkrbGk2NmZXdDVSaDVuakE2M2U2MGZlRktQcTFSY2hLRUh4a1lq?=
 =?utf-8?B?MHQ3ZDVvSGtKK0hMOFFUY1Nvd3JseGQyK1lCQThrUkFZcjFVTyswTjI1SWNH?=
 =?utf-8?B?UE1ZZmphY2JyZHdORG1yRy9vdSsrQzQ4aFJ1bjJIOEh0RTlqbnF1R05oZUpp?=
 =?utf-8?B?NnhoUlVwOTVZOGMzdkJYTXN0OFlZSmo5YWRGNGEwSUdJTEtIWE1VSkpRdkc2?=
 =?utf-8?B?cXpLR3pEV1VRNWlQdG9NMysxSmpLUnpaaHBtT004b1BBK29CcHdmMGdBSzVt?=
 =?utf-8?B?Z3hoQlNRZG10ZUhETnhTNXVqRER0S3RvdW04NGwrQm1UUlE3My9LR0txak9i?=
 =?utf-8?B?L2UzblpIelpUZjE3VGZVTUpVRUhBbEdtWkpScDBMd25SMlljM3pidEVwRWRE?=
 =?utf-8?B?S1lqRFhmUjN0YW5TRktTc1drd1FCK2ZkU3JhcFFqSi82dVZFdUtsOStldmZY?=
 =?utf-8?B?NDYxcmQ3dUZ3dDVrb2picHdhM3hJb3hvbHgwSE95dTZtL3E1dGFHZTIrY25Z?=
 =?utf-8?B?N3dhVzNETUN3d0tKeHFKZnVDbUtiQlRMTFdCeCt3dDUrZXpXYU42VG5DdXE4?=
 =?utf-8?B?L3hCYnk1MDNOS1FzWmpCMGJBSXV4ZzJvM2lrUTZLc0dQcWQrLzducitHTDE0?=
 =?utf-8?B?cFhBR1BMWUR2UGdQMDR1em45dWs4Q3ZTZFhUbG5hTDMycmRtT1VMYVUxejJZ?=
 =?utf-8?B?YWwvRHJDVlBBNGhXU0lsL0FzaVNjMElsdE80YlZoZEhJV2lkT1FsZVg3UWd3?=
 =?utf-8?B?NElSQWxoaWR1VDIxanVTb0hpY2lZQWdvK1h6bnkwSi8yeEwydXc3NTQ3Y3Ra?=
 =?utf-8?B?bVlnNVBTVk1vYWJQZ2hCMHhYSmNqeVNhNXBVWDIxZkV0ZWVVdGxRdmNUYWpn?=
 =?utf-8?B?eE9mZ1VSYURnejc5WEhVenZ4K1pvT1YrTFpRZU45VVJkV1ZheE9pcWZuMmNa?=
 =?utf-8?B?ZWs4RDJxRGJ1ZnZ4TDhaeURhVGdPNjhicDlNR2g3cWt5NlFCdGMvK0czZ2s2?=
 =?utf-8?B?L3p3ekJaczZpZWxjZklPMTlWaGdxSmlsemxIcElNQ1NBc08wR1F0djU2NEZU?=
 =?utf-8?B?bnFldnpqemJiQzB0b2wzRy9zckQ2eXdpNkdyd0cwVVlkeko0YzJFck1aVFlG?=
 =?utf-8?Q?SPAr2/EpGj9ja?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGx1RGx0Tk1rZ3NqdXBROEFobER0QisyM200VVpiNFFjeWRhOC8xN1BGTitx?=
 =?utf-8?B?aWpJaVlDbzdZS3AvOUFKVDJsMlJZMk9UeDhFNHIvelRHcEIvUzA4bFA0SlBq?=
 =?utf-8?B?K0VhWWtkRkRhNUFWdExnOGdqcVNXbDROZVg2UTJtT3dlKzNWS1pPM0owQ0h0?=
 =?utf-8?B?Wnc5Wjl3TlVhUG55Wk5kYmhMTWVLbkl0ZDVteTBtOHFNMmZQNzdrc3dTQi9G?=
 =?utf-8?B?QStOVWNkZWRSdWhUYkR4eHI4U3pReUx3bkwxMmhyMSsrL0RXRWFvejk1cE1r?=
 =?utf-8?B?WTV0cjF0ZGh0ZG5PUVhqOXZhNm0rL2IreGFKSkU5T2FFUGliMDJBY3FDelpK?=
 =?utf-8?B?a0VGYSt5WkU3dmNxdFl3eXJMOWpwME5XUk9rR0NOWHBncERWWjZGQjYyNFJz?=
 =?utf-8?B?WXVpOFRLNmVRYTN5STZDVi9iSGFGMkowc2JhZUg1ZXFGcVdjM0Q3WURLZmpw?=
 =?utf-8?B?NUlqeFNsZ1BOSUVaTDdxM3pMSDJSeVc0ekNIazVFejRIUXJNNzRrQ25UMFRD?=
 =?utf-8?B?TGUwZzZxOXBUYSszTHpuWXE5ZkdScW9DNDJiQU9RaElscW5IeW9YcXZUV1gy?=
 =?utf-8?B?WnB5Y2diaWlmSU5tUW1uT09WSUpoaVlGNDZZZGZBcExXTXZaMjJMWEc5UlVi?=
 =?utf-8?B?MCt4VjZwZExoa3ZveHVleFJKRWVJa1gxN2dZb0ZvK1RUWTdiT2hhd0ZkMWU2?=
 =?utf-8?B?YzUyeVBEVGJkam5qdDErRHZzcXNxc3N1YkliSTlUSkFHamVSd0JEcTByTkQz?=
 =?utf-8?B?L3M0MmFieElkMjBmMnZ2Q2pTRGxreVRORjJ2cElyY2lJSE1hNlpTTFdzV05M?=
 =?utf-8?B?TjJzYjZnREtWT1BIME1GbTlDdUlsZTFlYnFWbG00RFl6NiticUFHcy9OQjhQ?=
 =?utf-8?B?WFF0eStUTzR3dUJISnY2Q2tTcVViVExySDdrUGowbmM1dzZuWVR0dWlvL0w5?=
 =?utf-8?B?dXIzZEdRQjR6T0I1dmt5Mkd4UE15bnAwalRzVmVmRFFobUdvU1Nha09scUJP?=
 =?utf-8?B?RTRvL3pIT0R4QzZlS1lud1hxcS9rTXpBTm9LTXJrbW1LblBBOVhnMklrdUh5?=
 =?utf-8?B?a0w1emtQT3lDR2NDV2RrRzRBTUVHVFdTQXhkSHV1a3dDazRJOWdlQzE2Vm5I?=
 =?utf-8?B?Zkh4dkFWVytHeE1LdmdyMmk0L1FnbzJrOVAzckV2b1Q1dS9pSHp2RnpzYUhB?=
 =?utf-8?B?eTFNR2huWkRsTkZUOXlkMnZwOWFKOGRvLzM2eG1Yei9qbVcreml4MTBnYllE?=
 =?utf-8?B?ajBRQTA4SUdZOGRNWGhHdW5sN3lZZXNLNkUxZnRKNGg2UWdlM245Z0hBUnZH?=
 =?utf-8?B?VWN3VkpXOWpJeTRNWE1VNjVUYjd3SDR2VHdscCtpYUhsSEk1NHNGa255UDF4?=
 =?utf-8?B?WWR6MFRXcHI3Tzd1SC9YRHU1Nm1oaDBBU2JBQ3pjYW9tR2xIUWlLK3k0czlz?=
 =?utf-8?B?Z2hnenJtcUFtWVliYXg0SS9XWGhuSkZMVzVzM0s5bUpFdzR4ZXk1U3lsZHpL?=
 =?utf-8?B?cTRudzZ2MmZCWGZROTZhMUppejZyQTNyUFNEMWhEWS9NM3hCSUxCOCtqVmVC?=
 =?utf-8?B?V1hDendnYWZKdDNaYkpIb3o5ZFRxN0pnbW5PSGMxdCtCYWxkaDVieFlVZmZG?=
 =?utf-8?B?R2tuVEZtRjR3TitnYVI1UTB3aWpWSlhXbnZxRkhpTUk1Z1hHQWRVclBSb3Jv?=
 =?utf-8?B?bkNnWjBTQnhqZHJ2WU56MG9QWEhTUDFGQ3dwQmgrN2dQcW9CZ0U4bFBsS1hX?=
 =?utf-8?B?cVVmblp1SWVhcis4REhWRnVFTTJacjZvQU90MEJDdnpLeVFDLzhWdUh5Vy9M?=
 =?utf-8?B?QlRnRm1uZDB3R2lvV2ZhL3Q0amVBaXArclA4ak1wSTJpRzhxa2pwR3BSc213?=
 =?utf-8?B?S0pHRVNOSXlNQTZCMDBDRDlWV3FLV2Erakh2ZG1tZG1lK1BLa2g0SE9GanNJ?=
 =?utf-8?B?c2ZWV1ZsV2QxaG8vakZjOGNSekJWbFUwaC9wK0JWM3hLTHlDSUhvL3ZSUG1P?=
 =?utf-8?B?NEEyb1RiOURQbkkzK1NiSUpjL2k5bHU3TGgvcUdMVENuckJxeVNyWnlzcXJn?=
 =?utf-8?B?Y3VIUXFFdVp4VGc0aGZvdTlNeFAxVFVIai9LMlNQbEozSkdQVEw5ZkUybWli?=
 =?utf-8?Q?AsECMIPZJ4yvi0HgKFJQPtHdb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e72dd6e-e292-4768-e0e0-08dd521181ab
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 00:48:50.1748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vH9hzbd44dQgYk9Wb39n8aam5ao0UcSW2NBPi59/XnA78jJ7zZ/0Vs2GIdQ6km2r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6612

Hi Zhao,

On 2/20/2025 6:11 AM, Zhao Liu wrote:
>> +static const CPUCaches epyc_turin_cache_info = {
>> +    .l1d_cache = &(CPUCacheInfo) {
>> +        .type = DATA_CACHE,
>> +        .level = 1,
>> +        .size = 48 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 12,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
> 
> true.

Sure.

> 
>> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>> +    },
>> +    .l1i_cache = &(CPUCacheInfo) {
>> +        .type = INSTRUCTION_CACHE,
>> +        .level = 1,
>> +        .size = 32 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
> 
> true.

Sure.

> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

thanks

> 
> (And it would be better to add a Turin entry in docs/system/cpu-models-x86.rst.inc
> later :-).)

Yes. Will add a new patch to update docs/system/cpu-models-x86.rst.inc.

> 
> Thanks,
> Zhao
> 
> 
> 


