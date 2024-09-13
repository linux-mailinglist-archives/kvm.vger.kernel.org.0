Return-Path: <kvm+bounces-26840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E9197868E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6903BB20A33
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4256D823A9;
	Fri, 13 Sep 2024 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hAKngt/k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC03A63C;
	Fri, 13 Sep 2024 17:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726248084; cv=fail; b=X8f4lZkkJT9kIDLh0Txf1Do1dVOMqoyl2zGhX4Nm1uOiegx6w8hIg0F4/ugLcsFaqJVUj244AucQbC5WmlR1s9tXEgAarF+Yk011M48DC6w4TIJSe+fRn6zDYgmKlpNos5OTunpS/UNh3YKTVBwXHuFfjSatGWf715uawW0iKNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726248084; c=relaxed/simple;
	bh=kfkCMLTITx3ZsGbJSY22DJ2Ah36jEOrBWbFMnV8sBTw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kxhNFqr8+irbuzkCPIDltuXK4fl7dZPHhMD0jVPN4ZGq+VJjUNS6WGwQozU1fO5IN99MeSI1JqMxgUu0tx2ZjgRkIKwgkezoZsh09Z2OY4yTETljIctsqJmnDoHveetAciAudKeR7r3RlUIPgA65oJbqPXEFi/PBfqxF5bcARvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hAKngt/k; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wpODG1lbHUHr0JWb6KqQqzic482e8qpHn1wvPGL/+lwQ8GVJFUB5bJkT2IeEWkZgsx8HxGeEdoOJ4z7Mv4ybO9tsBtkB+HOf8qQS2c0fuU8LIwgXCda5AnJ2ef9KoxldRyAAmrCtqoj8JiYR6dKzu5IriE8IjBTp3D0G/Hw8dfcRgtwvelXRscWVDZxp/jYIamoqXsIAligmm9BEcj5MA2ICTYk14/C4r1tzCW92KOSagBVkwyzdbKcQPInQhIJg9KHXj/GkDDcMYynQQ9RcqPTXZWwC+qBnyxnTtpm4iq1H8Efh2cyNT4Gw5j6dgdD+hmXHSLjpZcTZeigjf0qM4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3u7QFZGnVsCPbPBSmniszO2Sz5LgUubXyM6239Z5eM=;
 b=k8b/UN0qCLmjGgom44hbOWyHUCMqmd4V7Jk/A/sLkNvvmo+9F2X+rIOKZ2yp4nQGLTxAbrU/KnPKqzjyghGQpdxBx6sN7DK82/L8VCP2kr+nfzmM7kO5jUwV6iZX4vPZ+D5i8BB1unt0JF3pqWJXi5+6otGmGCPtdXMU5UAepR/nJuk0IpdcYRkuez63wcVWzhUNy0Bc8rmAjZwFqx3lfaxsazWa1ksZajSrs64WnIBmtupGeq886lJGtIciVk1xD3nHlSIURsJAoKv719m+jcIXYyzMdUEMu61kVdqD2qQLBLXI9L7vmmV88HQpUP4DmDHXgjGV+prj2PAm5q4ZUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3u7QFZGnVsCPbPBSmniszO2Sz5LgUubXyM6239Z5eM=;
 b=hAKngt/ksWjArmgYCR/J7y3KEWGM7LOwdm5DAxOGn3up0q7FqoOODu4/cT5RvBVgjL943EnyS/oGQ4pVak4nwfIasVRTVNykX0OMGTb18/Ge1JP51gZe2VPk7mZ7iTi7bDnzM8+eujGeRGWGAkoXMA8f9BLGgcMbdR9JqL474kw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH8PR12MB7207.namprd12.prod.outlook.com (2603:10b6:510:225::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Fri, 13 Sep
 2024 17:21:19 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 17:21:19 +0000
Message-ID: <ad654a7b-47fd-c7a4-7d79-46f4393e9640@amd.com>
Date: Fri, 13 Sep 2024 12:21:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 20/20] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-21-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-21-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0179.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH8PR12MB7207:EE_
X-MS-Office365-Filtering-Correlation-Id: eb585544-c65d-4d21-f205-08dcd4187b84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnFQMHNDb09vUG1HKzVQVkpEY09HQVVFaEM2T092b3Bzc2JoVFNXN2JxckZw?=
 =?utf-8?B?QnBvLzFHSnlGSzZjYXhEbTBrVVhEbHEvSHBpei9tTTg3OWcwY0dQNUx1RTgv?=
 =?utf-8?B?SmJyYTRFcUpRSndZTzZSbklLR3ZSeVRwT1QxRG9ud1l6SW9TTHVSdCtnNE5m?=
 =?utf-8?B?YWpTN0lLVFIzL2pTdExUMmNJSkhXdzRGZis4Ry9LUE5BZkdSbDJxOUIzZFYr?=
 =?utf-8?B?Y3pxT3F1SDJiME5WMnJmS3VzL0t0bXppTExhMXpHRlZXZFUveWc3MWFLdkV5?=
 =?utf-8?B?VVd6WDJsZklyTS9JUVVJbjk0aVhSQUNZTDlBZjRrTHluNEg3Vk9YVUZPT2x3?=
 =?utf-8?B?cld6NC9KTjQ3SEJ4MUR6bUFoclV3ck5CbTVWV3R5R1lrU1RsNmFod0tCT1JX?=
 =?utf-8?B?ZVNlQkdzRFBpWHY5WjF0R2tsYm51TERaem1YTVlRZXVBdlBBc2RiTURLQWtH?=
 =?utf-8?B?ZUFSWFZGTEtvbTlickxkQjA1WExGVjdGZ0pHZTVKd0lXZHhWUHVjajBHV0FH?=
 =?utf-8?B?NUhkaWRtU09JR3RnMFFjYTlIUnpzL1NGbFNqMnEwSkxzRDFQZWFZeDQySHZI?=
 =?utf-8?B?b1VxNVg4QkF2NHJqclJaK09FN1FDa0VKK2FOTytqV0FVRHhHRGVnc2E0OEl6?=
 =?utf-8?B?bm1MM1RLQWxEQ1NCR1lhL1V6UlBVbUNISmU1SGlRbmdodTE3dFhYWU10NlRW?=
 =?utf-8?B?a1BrbnJCZ0FEcFRoV1AvMExRRy9KL1o2MWluV3krM0dySDdFakRxTHpiWGVR?=
 =?utf-8?B?L2R3VS9SZzhWbUV6RnV4ZEdhUHo2TXl6UkVENmVBRXdCb1p5NGNxWHMxQ1M1?=
 =?utf-8?B?YklEc0NXMFVHWTdpNHZPS3FUZ0tMT1pqcU54ejFHU2pMUW52eGVOYVI3Unoz?=
 =?utf-8?B?MGI2WDBwUWRMRnVLSmp6NDFWWmdQZGtpUEhxN09TWGNuLzJjV3pYeU5iMFRB?=
 =?utf-8?B?N28xTXZNWXVBTitGc2JJT3hDenZ4dTJJYTNiaHVmanRCWGVHS3czTmtGZzR4?=
 =?utf-8?B?M0FOWDNESkl1TklOa0NWMHJHYVBmL2ltZ29YTkRldEp1S3AyVGRieFJnRkt5?=
 =?utf-8?B?Skw1TlhGOXI3S2JVN2E5MWtXOGpEbFA0Q0s2ZW5HdTR6NEFvNFVRU1ZPaGg5?=
 =?utf-8?B?VTExTm9aWGhFUlRkbjcwM2xYdUYvalV3M1B5dlc4ak1Yck4vN2xtZkJNV1hu?=
 =?utf-8?B?cERpMmpPN1hDSUlWbXB2M25IZXNFZWZYR0lvSnE1RTBSWGlaV0FBVVhmY0Yx?=
 =?utf-8?B?SW9HbzNKd0svdEhkNkNhRHZLdGpNdTVFUE5LUHJYTGpGSEswZWxvckx5NFR5?=
 =?utf-8?B?cXBXY0I4YVR1YUx4NjNnak1lc1RGYmh6MDY4bDNGa1RucFFFTE1jbzRwWnp2?=
 =?utf-8?B?U3JJckY0NlRZNVZienR2c0NkMXVTNndnODFtU2Q3aXp3dkZrRmhFeFFTYlda?=
 =?utf-8?B?elNXNEU3OEJUMk5tR01kSjk3U1dQdStiQnp0VVJERkM3WTlGNVRQT0VhYkor?=
 =?utf-8?B?Qmg1bFFZVGcvOUFnOFlJNXM3Y3FhNi9Edmp0dHBjWHBZSllMY253ODZHVGNx?=
 =?utf-8?B?QVg2SzZaUCtLb2ZNNzZDaG5XMlkxZzgvdTRHdlFEUVNrNE5oYkVOSmQvbzlN?=
 =?utf-8?B?YTZjL1FHclFCVUNlMFFDZ1VCcFpaeVZKaEFWcHM1WmVjNytzUithWkl6SU55?=
 =?utf-8?B?WE9ZZVg5b0o3Qll0NnFEeXNjb2FYRXlzL0Yyc2JlNk4yT3pNWUVjTHA3b2RU?=
 =?utf-8?B?WEV5alFFMVBKVTFNME1TaTZtNXAvR242UkdjYUJQU3lEQVRKaGQ1MHV2V3cw?=
 =?utf-8?B?LzlhUDJpVHJTaDNIdytWdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d014VktvcTd2RGVTQkxwSXg1WjZmWmFDM3NiNkZDRVM4cVVEWGR6T2lTVktU?=
 =?utf-8?B?TGE3YkRLUGJod1o0bFBNeWVlWlVaSUN3ZW5Bd2ZJUENHc3NFcjVReWVaZEF4?=
 =?utf-8?B?cGZRNVB4OVZ5QnhSWGEvZndFU00vcmswZUNJZ0I3aktzSlRjTEsrL3FManFs?=
 =?utf-8?B?cko0czg0Vm5FTUhvbWFHeUdSbGlqUThITmJjbEdIcTA3My9LeFdKMStsQkZB?=
 =?utf-8?B?ZGswWU80RUNEb3hObGNLYkZhYW5sV00zY2JHRk1xUHhFaFdDTUhEU296SW5h?=
 =?utf-8?B?VUNka3dMMHBrbUlYUEZsZ2ZpdGJpdHFsU2U4amNVMDZTbW1MM2lnaFlmMWtL?=
 =?utf-8?B?MjBYU3JzSzg5YUdiUWZVcGptdk05SkhCdFJOeWhybXd2WGQ4Y2FVT3JaSm01?=
 =?utf-8?B?L2RXU3FCdWNMRXd0MWkrOFBsM3lmWTVHMUZkNGpYdWlNQXdleW0vdEdHVWM2?=
 =?utf-8?B?UmJrN2RWRGZyS2VUQ2tXMXRKWUlWS2NtK1ZnbndsbitGdks2cmV5MUc0STNx?=
 =?utf-8?B?Q0I4ZmE5UDZGOFFrUGRwNUwxT1U5YkxFK2J5RVhpUldnY01NQlRJK2p1Q3dN?=
 =?utf-8?B?K0d2bnJHSHZ3WUxmMEt4VlRGa0h0WkJtckhLOG1lNk1qa01La2Z4djFuOEh6?=
 =?utf-8?B?c29ORFM2cmV3L2JUUThCZWFVd3Q3OWJiVWlBQ3RuZm1xUHpQZ0FDcEFlK2FN?=
 =?utf-8?B?U09VczBXd2Npc1FFRFhqZ3NFYWJ1VDlqc1ZidVYzRUF2VWpGMzVLdktQRTQv?=
 =?utf-8?B?dDQ4Q0FVK3RZb0tEbWd0UWZkNjFYVmVpWDYvd08zUDJLQkVwZjhyK1ZnTTVy?=
 =?utf-8?B?czNKR1RNTFdiUWVTWGh2TUVFWUw5M3dSR1VwK3YwUnRsYTViUHZNR0hFVlIw?=
 =?utf-8?B?T0doTFBpNW5rWXdSaFRqWVVMNDNyakhJNXk4UXVxYk9iazlkb295YkZEQ3BS?=
 =?utf-8?B?eFMzTHp3VGZDa01aQVdHRU53bzl5K2toUHJBVHd5MllMNlRlRUpJWlc1c0xQ?=
 =?utf-8?B?a3RqdWdqbFJqZGU5M0RzUGQ5YjNmcFF1WS91R0YrQitNV0VCTmRReitNRWZF?=
 =?utf-8?B?aVFGelQzQWRkTVNIZDVRdUxubjY5dGlXQm5wcW13ZWxSemoydE5oamNFc2F1?=
 =?utf-8?B?aFluby90OUVCOHNialo1ZnRrT2pUalJmZG14UXB1UmlTZUVzY0VaendpeUVx?=
 =?utf-8?B?WlJRS3VVV2t1ZWNPc20xdUtpNzRHT3pSVVBndnJpSDFYMHlEejZFcnk0ZnFD?=
 =?utf-8?B?a1NFbTcyY1pndGYyM3d2RURzK3hjS295UHRVYXRWZ2tnQWtIZEg2ckFSaUFD?=
 =?utf-8?B?UmhpZ2FiSVE0a1pCalFyQ25oRzUxTkNSMjQycUoyL1FKUkVsY0pPQlpaU3Jr?=
 =?utf-8?B?STMrYyt6VzhESHJnV0xHL3JLTzRZMGphZzc5YjVNMDdRYmNsK3d3RTZ0cWdR?=
 =?utf-8?B?THFFS0o3MkhhVTZHRytOTCtqVjViNEE5ekt5akR0TlpBMVNuUjd2dFhhM0V2?=
 =?utf-8?B?LzZhcElQNFJieTlwVzJqdHBKZStvQ0d0cFVJMXRvWEpmdm1HUjFOWjlZVkN5?=
 =?utf-8?B?VGM4M28xS3ZZTFhMVHJVL0Rwd0xNeGlhTVRyWVlWanZJS3ZVR2RKM2FwdmlE?=
 =?utf-8?B?NWtvM1JOSFk2WWVJdTI2M0s2QWdmU1VSaXh1NDkyYXAvODk2L1YvbXFLeGdh?=
 =?utf-8?B?Umx6MU04a0VlMm9ramk2OGo2ZGtnQkZzdDNHTitQTlNDQjhLRmNDaVBHYkNR?=
 =?utf-8?B?emxVRXBmVXU2WkZEWCtYbittSCtxYWw2T2pVa1ZaMGRKRTlBR2pCek81OU5x?=
 =?utf-8?B?VVFZQWxqOERuU3V6VGhJSGt6ZmpvM2FHOTFBOXJ4SThxSzQ3TWN0ZnRwZFBu?=
 =?utf-8?B?WFYwNUprSEgyRGN0WkdwT00vaG9oZGRkRkF3bGIyS1ZEbW5MUDJ0NjR2QkxG?=
 =?utf-8?B?OEF3V0gzWkczWTl0YWhtN1FEUFBPakp6aHVpTW55NVlIUTAvUFdQbzhmSkFN?=
 =?utf-8?B?WUMwZWFnVmZ4eE1EbjV2T2VKNkwxNVNvR0pLTDRTSWtNRmV3VnRZbS80K0I1?=
 =?utf-8?B?cXVQUGJvdFZGMXlzakFKMm5JYjczbVZTaHBxb2NJSE5td2RaVlNGWGRYZ0J6?=
 =?utf-8?Q?ZN42MSLtdebuAeGCwHoxKNXW/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb585544-c65d-4d21-f205-08dcd4187b84
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 17:21:19.7801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csfQpTHrhxhTH5knVLjHr4MMtQEDP+2Fq0CJld6gt1k8Git1C7l+dFmF25viY/PVNwv5Uble2vpcEPY7M/j0Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7207

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
> is set, the kernel complains with the below firmware bug:
> 
> [Firmware Bug]: TSC doesn't count with P0 frequency!
> 
> Secure TSC does not need to run at P0 frequency; the TSC frequency is set
> by the VMM as part of the SNP_LAUNCH_START command. Skip this check when
> Secure TSC is enabled
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kernel/cpu/amd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index be5889bded49..87b55d2183a0 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *c)
>  
>  static void bsp_init_amd(struct cpuinfo_x86 *c)
>  {
> -	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
> +	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
> +	    !cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
>  
>  		if (c->x86 > 0x10 ||
>  		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {

