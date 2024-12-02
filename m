Return-Path: <kvm+bounces-32854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBC49E0E3D
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 22:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE8A2B29E5B
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6721DF245;
	Mon,  2 Dec 2024 20:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m7QFMEMU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2738619BBA;
	Mon,  2 Dec 2024 20:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733173046; cv=fail; b=KC/WZEB+3YXwq0A4pfxRPKaWZdTvncxNKDhk3g7dCNJY5BruVQgw6xtgc1gPAkaTo4P42xuW15zmYWuPMRt+9Cdu2CLKRh6JS9XWVCyGenFe0I82inELhRWxduB9ZPic9EuXRac0xzgEQFYR7YZlo13u7xWGnCVh8flKJHU5iNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733173046; c=relaxed/simple;
	bh=UAi2hgLlEDUQGo3oXiSuqyWx11liyb30FKtp70wGXFg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UO1DDygjRC43NaPJIlcnJ6loKV0GNOvwT95dwT7yVGXl6NMQ1D6/Nte0mAAvV2ZqY+Mx8P0JolvU8iFV1Jt6WSTs8rnhkOFAAde1TikKHIv52CvV7XYMcF5J2NBAPyOgu6Dvm2E1aNF5+PPfj5GIAQINtlHU7e1Jn4uee/FTWdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m7QFMEMU; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l/ULhJoUK3qu8Gbv7GV5su9AaDVM/NolNHJTMJ8PCuooWXgLGCkp8FfhViRQc0H/oTyrmYe5P7WQw5PvuX4YixfcEK+xri2ofm0lgy0/KeH0qGS8Xo793XuIkRmCftGREoXCs665mSHEwXAG9sJ5zr2+b+3QjmoI/u9RWBd+KRIvol2zUWn6WmJ7EozMM7JyLyJ5+UC2qMVh1qEtvx+fyQ/gYwHSZte2a72LjpuISGj/LYxowVDYlZ4508WiWZpoe+DbnxG2mnW7JcdHtpvhSxqJRdMN6KwXCqDXojEl19HS/VAUTUYufaJ4gZgt5rlHaa05QuYjv1t7dV5Y/lSfZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HR6U/LGgELyvgRoAYaZPBzzCcHOXKVqE3k19mTTHQqU=;
 b=tX8cnFSVU2xsfU+oa/2FNr+GO5agRo820Cr7/bFo+OSvpJq86NpUHi3EC2JHibjMAgKkDxVru7lWs5LbeDv2mmGaUpvzqaE0QYMHLpOH7d9UUfiHKEZrqRyqjyuTyRQN4PwfV5eC5fQKAAVT7CoAhPkr2q7kqvJa03iuFmTS9tn310Uh3qjyw9YEZL2xDwChqwBhgh6Tied6q5wURYlfRtrU3UHgm0NB0gqctYgpYzIJFppd8Jp71yVy8QX9rgKQRjLdrg95gFLBarLBrEfEk3F8odylChwilpwmc0BmpcVK2vp6bH3mLqkcvrxxMzWO78rt8LfiVQ47DwHKSLBtKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HR6U/LGgELyvgRoAYaZPBzzCcHOXKVqE3k19mTTHQqU=;
 b=m7QFMEMUQqDEjLfc46SuMKfgRfnqH/jWJwpV5p5uoYQAbNFi0jzFOQVId/dXgftVDvdCPKDdWTlYiU/3V2HkWDMivUM5CLYSD6bOFUH3ErNo3VtWRHlTWk0DxMR3PB2yyCjCp4bE1vXY8CXhyKjmXO2i5+5aEW/MgPEjYMNs1p8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB6213.namprd12.prod.outlook.com (2603:10b6:8:97::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Mon, 2 Dec
 2024 20:57:15 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 20:57:15 +0000
Message-ID: <6f4aabdb-5971-1d07-c581-0cd9471eff88@amd.com>
Date: Mon, 2 Dec 2024 14:57:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 5/6] KVM: x86: Always complete hypercall via function
 callback
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-6-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241128004344.4072099-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:806:120::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB6213:EE_
X-MS-Office365-Filtering-Correlation-Id: dfbfb791-e2f8-43b3-2f0b-08dd1313e673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MDZmSDBHQnc3dHgrK0hDaWRUNTd5TXR1UmxhaDB3bzAzMTFRaXZ5anVBcXgv?=
 =?utf-8?B?T2FnRXFITC9MTjZHMG8vM3FWVXRZc0xZYkt4TmtLT1RSVWswWURrbUFCUmRU?=
 =?utf-8?B?WGwzdFdsMUpvTkNvMEw3Y0xQSGo4QU9rUGRJNWNTTUpXN01TYjcwTEROMGxr?=
 =?utf-8?B?NXZUSzVqUk80di9NYnlWV3pyOTZxRkw4RFQrZnl3bEJPSXhiRS9OT1BDSzlS?=
 =?utf-8?B?clpROGNjLy9OQ2ZFaTdtSHZRZEhxVDlEc2cxM2tnSU5OWlRnWFA3cmtWSFpD?=
 =?utf-8?B?dGVUcFM1TU4wYW1qblRvL3VEaTByemdEdlJpUXJDeU1QdW1tV29mcXpuMTB5?=
 =?utf-8?B?WEV1L3VkZE5PZ3pzR01LMWVYQ2dTaWxrQXhaeldZRXFpMHkzbU9WTEpQRlgr?=
 =?utf-8?B?VWNHVEZOTXlmb1FXbUZYcTltcVNvL2RVNldlWFhZTHIydzVDelVCMUp4Zkdn?=
 =?utf-8?B?Mk1VNVBzOXpUZVpZTVV0V0xmWlFlQ0JLSGhzbFZNeWFtT2wyeFdENkw4TTJK?=
 =?utf-8?B?QTAzWi8zWFVpOFVRN1hkQ1NYYmFyRFc4Mml3NFUxZm40RVBvek56YTZUL2dr?=
 =?utf-8?B?YlIvd2Ezd2xnVkJ3U2JrK3c5Y2lLRVRTY2ZZbks0aFpZQUNwWE0zYlNMVDgx?=
 =?utf-8?B?SlNiQlIzcFZDMEVqakhqNVY0SG1xZDUwT3JXdVVQd2E3SDlnOEtIcjRYZDNp?=
 =?utf-8?B?aXpsaDVmcms2d3dDdU5Bb0RsS3VORnhTNWFndE92ellPMU0yOWFQalpOM3lR?=
 =?utf-8?B?d0tLUS9Ua1A5a0NrcFI2a1QxazdKMVI2T3ozNjBBcDNsdEN4NUlncVU1bUhq?=
 =?utf-8?B?UklLVjlodjV2M00vdHF2QWk3VXhYV0VkU1RVdnpwWkxtZ2JUMWZ2N0ZvbjRs?=
 =?utf-8?B?bmFVT0h3bG5QaGE2UmpoM05iSzQwc3Zld0Mrc0xTVzQ5MHpvdm16WFVLNzB1?=
 =?utf-8?B?YUZqeitoMlhhZkVHZ2ZDaUtJaXgxU3pmV21MQWdPOXFqYTN6U0xZWlA5Qjdi?=
 =?utf-8?B?SVdySmRKbjB5ZEtZbXdxVjBNYWViYmtEcXJuUC9xNEpVS3FJR0Iwa1psNHlY?=
 =?utf-8?B?WE5QYnJCdGlOMWdkdndRL1lSZEM0T0pCNERrWGtPUnlHRWRrMUc4cm9HVHAw?=
 =?utf-8?B?emdqbW1pdEd3TUZnOTF6bkpOWXpIR1lWRTJvM0NML1RkamE4Z1M0dlhkTHpw?=
 =?utf-8?B?RUNkcTdkRXdkWlNDVkJGWUg1Rm4zSUdIS3ZZZTBBYVNTQUVMTjBwanVYUi9w?=
 =?utf-8?B?cWhoUXVTSk01SllVNVRlQjdsakQ4eERXUVNsNGZUM3NQbEZFTkNzVXM4VWtM?=
 =?utf-8?B?by9pSmpFK2loVW85QnVnaGxQRG1LWnBLOGdzdVFyOEtiUS93K0kxRzZLWGZk?=
 =?utf-8?B?cXVnVWxiQ3J5UW95WXF0cWpjdkcyTFFUaElEQ21lTGVNK3NYSGNmd3kva25y?=
 =?utf-8?B?cjh2QVNoWEtBWGdYNkJHMkVzcWdYRDZKOTNtdHhpTFo3cHN3eHFCdDVwMHFo?=
 =?utf-8?B?dmh0b1FXWmxPelNJYysvV3BWQjQ2WDZlNUNGbGpkWTc2UEJqS0w3dWxaMlJO?=
 =?utf-8?B?dGdLa21yL3BNMTd4RnRPQzV4Y0FaN0RlQVMxUlNVZWhLZklwd0ZmL1JPZFV2?=
 =?utf-8?B?SWhib1JFR05jRko5YXYvZWJlSEFOL3RIejJDY0NLYXFuajVJOFh3TkV6Szla?=
 =?utf-8?B?NWJjVkhZYjFyMkswRVAvblNpRmI3cnBGRVZPb3dpbFFnQ2FsY1B5bVNZb2Rp?=
 =?utf-8?B?LzVDNUpaQzEvdHYwbG8yaDZRVS9uT0d4OWlWaG1BdHFHSFc3ZWR3MVZVNjJq?=
 =?utf-8?B?cEJ0eVFUYnBFV0xsV3JKdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWZVWEZwUE41aUNmaDVhSlhHRFFpR2ViVU54T3BKZjB1L2prMmFuSWovVW1T?=
 =?utf-8?B?NFZPWDBXMkhwL3JkenpHNHF0N2U5RXdkbUZwSlJzTWlyWDd0cTIrWFUzdTh3?=
 =?utf-8?B?VlEwTlNNbk9MeVFpSjZ1OVpNdjZyTnhVZStLME8waCsvQUltTWEzRGVzb0VI?=
 =?utf-8?B?N2ViZWZIMnh4ekk4c3hTWnFZVlhUY2UxUHZMdllkOFlxOTRDTDVyNHZOQjQ2?=
 =?utf-8?B?c1psM21kMnR3M3crcUdxMjE0YW9CampWRllZV05jTUs4b0lSOHNNS1VFRFlU?=
 =?utf-8?B?aFdNaUdNWEpFbll2a0puTExsWDBjd2JDTEdkL1QwbFR4Lzg5WGtTdUx5ZWFI?=
 =?utf-8?B?VDdpZHVqbmY0blJoL0w2OXpGdUxWRHljcEoybkFiaStHMEpqYWNHOEx1bWU1?=
 =?utf-8?B?RVNycTVURE51S0hEWUF2QXQvTyt1alBkcWJzN3Y5bVRBYWtRb1NXUDhFREdw?=
 =?utf-8?B?R0xPd2ErMW9QT2ZZbk82NlY0bFZSdU13SUxLZTY5KzdVQ1EvQzZnRTNZenBD?=
 =?utf-8?B?RmVrMk1yWXNBZFdlVGhZZ1lsTnJTemVYdE5ubnY4eElKK0tvNFExT2hpZEFR?=
 =?utf-8?B?Z2RyMnJMNVltS24xb3k4TFVyeXV5aWlWZlJvWFlkYlZpTVlSb2gvMzZkeTR6?=
 =?utf-8?B?OThHbFpjaTV1dGE2TzlSaEFtbm9TWjhZeTRZT3U2R2RtMHkveDlQVTcySWMy?=
 =?utf-8?B?bTdQaW5Vc2xlV0JweTF1NDBFRWMrU1BEemI4TFJ4UU11bktUSkRrR3dFay9z?=
 =?utf-8?B?cXExTFlFTDFCKy9qY2o1WEIzOHVLSHNNUjQvZ0VJc2piWEh1Wkl3OGR2VjB4?=
 =?utf-8?B?QXVjelhWY2Jwa2JWaTI1V3JVdzB3Z1dwdkhVQkRnWWtNalQ5akxvZUdqa3F3?=
 =?utf-8?B?Q0V3K1hpU2JqTUlDLzBhckFHbXRTVFNHd2xjcTVsL2V0WUdJQkZqYzhkVUdQ?=
 =?utf-8?B?bXZoZnVLZUYwbXhxR0VHUkVua2JkR1N3RGZzSmNobmRicUcvd1V6RHdiNFlS?=
 =?utf-8?B?WnN3ZjBEdWNKM2lDMHpHak1BbVZBdGJ1M2tZckcwRFlUS0hoc0ZCcnhKVjcy?=
 =?utf-8?B?ZzBzKy9aeHBETEo0OERYTFZFTnhyZmtFMllmUUQwaUttcGtzRHdXSS8wNUlh?=
 =?utf-8?B?RFNzaFFHaUliRU5tOXlBcDJUT29uR2VkN3Z6WTZMSi96a2xvUFlzcnhmSjN1?=
 =?utf-8?B?c0VTQXFRTFZDaDg0SFNkYW1FZ1I5VHNicEd6NE1TM0lDRlNyeFoxUzIvYzdK?=
 =?utf-8?B?WTR1alppZjdoaFRINEhSYjI5Mms4dkd0ZmlJTUptV1VtMHdOdXZsdDczQWJT?=
 =?utf-8?B?L0tuUXdsMnp0NnFkUkc5MEpDK252L04vQlRoRjMzT0d3QlIwdXVudnl3Tllq?=
 =?utf-8?B?dDQ4QnFaTUZSNDZtbnlaVjF5MkNsUS9xaGRNRlQrL3Yrcko3b2pEUU4wemQx?=
 =?utf-8?B?OVo5bkJXTkV3N3gxUm1zSndodUNvUTgwQi9LU2pnNys5a0xkVXZGdlo3Tk5i?=
 =?utf-8?B?WEt6NGdkRG8xa2NPTHpQOFhCbWovbTl5Qnc0elFXOG9LbmpQL1ZmRDd4VkQr?=
 =?utf-8?B?NC8vUU55YXVaaTM1aDBwRGdoa2Y5YzVpbzhvUXRjSjVsTDJyUUlHMDZJbHFP?=
 =?utf-8?B?KzlnNmRXb0pPd2xCM2VWeHZZQmdJeERSSkZubXB3WUNWWWlBSndWbXJHdy8y?=
 =?utf-8?B?OTd4V0gxVHBYN3h3OXZ3OTBuSmNEMXFmRllsUWFFYUROdHV5WXFla2ZJaURo?=
 =?utf-8?B?NTJVQ05ONnA5YWQrakFZenVhMzR4OHlsT1ZrcCswQnUweHM5MnlOb1lEbFNX?=
 =?utf-8?B?K211R1UzWW9mY0ZIU2VKL2pxcXpycE91Vk0zQ1JsNFV6YzVHUStJWk5Tb1pk?=
 =?utf-8?B?RnY1dWVDS3pHT2RCUkZ5a1ViZ1RqZjEvcmNYbUJjUWlsbnd4WTJXbEhUVTJh?=
 =?utf-8?B?N2xReS94aGZLTWVrWmFNVUZkWk83QWdiOXJuNDgrOFNxU3kxVVdMMU4rUDhV?=
 =?utf-8?B?bXZ3UUN2aHBlM28zM0ZRM1JBYUxGZWE2Q25pWUJsVS90Ym1qMzZCaCtWTTZM?=
 =?utf-8?B?SU9POGVsTXFNMmE2a3o5QlNXMHV4OEtURENxWjErVXBRcWRMc21aTnY1cUV0?=
 =?utf-8?Q?cmZd2Jl+pIukR3XARkdqnFSgd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfbfb791-e2f8-43b3-2f0b-08dd1313e673
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 20:57:15.1277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4+lutXCxCugvK4PJW2Daf6R2zbNEILI8v2kxi79xYpRnRPtf1s1l3VQ3mba1QhpQIlMCzsySB8n0PM3VIRRqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6213

On 11/27/24 18:43, Sean Christopherson wrote:
> Finish "emulation" of KVM hypercalls by function callback, even when the
> hypercall is handled entirely within KVM, i.e. doesn't require an exit to
> userspace, and refactor __kvm_emulate_hypercall()'s return value to *only*
> communicate whether or not KVM should exit to userspace or resume the
> guest.
> 
> (Ab)Use vcpu->run->hypercall.ret to propagate the return value to the
> callback, purely to avoid having to add a trampoline for every completion
> callback.
> 
> Using the function return value for KVM's control flow eliminates the
> multiplexed return value, where '0' for KVM_HC_MAP_GPA_RANGE (and only
> that hypercall) means "exit to userspace".
> 
> Note, the unnecessary extra indirect call and thus potential retpoline
> will be eliminated in the near future by converting the intermediate layer
> to a macro.
> 
> Suggested-by: Binbin Wu <binbin.wu@linux.intel.com>
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 29 ++++++++++++-----------------
>  arch/x86/kvm/x86.h | 10 ++++++----
>  2 files changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 11434752b467..39be2a891ab4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9982,10 +9982,11 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>  	return kvm_skip_emulated_instruction(vcpu);
>  }
>  
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl)
> +int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			    unsigned long a0, unsigned long a1,
> +			    unsigned long a2, unsigned long a3,
> +			    int op_64_bit, int cpl,
> +			    int (*complete_hypercall)(struct kvm_vcpu *))
>  {
>  	unsigned long ret;
>  
> @@ -10061,7 +10062,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  			vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
>  
>  		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
> -		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
> +		vcpu->arch.complete_userspace_io = complete_hypercall;
>  		/* stat is incremented on completion. */
>  		return 0;
>  	}
> @@ -10071,13 +10072,15 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  	}
>  
>  out:
> -	return ret;
> +	vcpu->run->hypercall.ret = ret;
> +	complete_hypercall(vcpu);
> +	return 1;

Should this do return complete_hypercall(vcpu) so that you get the
return code from kvm_skip_emulated_instruction()?

Thanks,
Tom

>  }
>  EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
>  
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long nr, a0, a1, a2, a3, ret;
> +	unsigned long nr, a0, a1, a2, a3;
>  	int op_64_bit;
>  	int cpl;
>  
> @@ -10095,16 +10098,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  	op_64_bit = is_64_bit_hypercall(vcpu);
>  	cpl = kvm_x86_call(get_cpl)(vcpu);
>  
> -	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> -		/* MAP_GPA tosses the request to the user space. */
> -		return 0;
> -
> -	if (!op_64_bit)
> -		ret = (u32)ret;
> -	kvm_rax_write(vcpu, ret);
> -
> -	return kvm_skip_emulated_instruction(vcpu);
> +	return __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl,
> +				       complete_hypercall_exit);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>  
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6db13b696468..28adc8ea04bf 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -617,10 +617,12 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
>  	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
>  }
>  
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl);
> +int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			    unsigned long a0, unsigned long a1,
> +			    unsigned long a2, unsigned long a3,
> +			    int op_64_bit, int cpl,
> +			    int (*complete_hypercall)(struct kvm_vcpu *));
> +
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>  
>  #endif

