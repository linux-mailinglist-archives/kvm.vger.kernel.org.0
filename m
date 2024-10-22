Return-Path: <kvm+bounces-29328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E639A97A0
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 06:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24A811C218C0
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 04:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C588154FAD;
	Tue, 22 Oct 2024 04:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="30j0K71p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6903A17FE;
	Tue, 22 Oct 2024 04:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729570574; cv=fail; b=M5CxS9ith7p52/11c18CSY9pI5+A/IttQ8KLAwf3ykJBNpj8AWFFM9vLOrOVcuV2Xwr1ooADTjYizIphTpXcaTbYrbq2K1IlF6ySupHot+oYMvq9o5uNwIjBcqFc0ctkQFnGqrxxXx9HsO4WUefgUTg0+vd557xFVCEmYEZfOaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729570574; c=relaxed/simple;
	bh=dILg9tJy3KmL8R1O64fqqWFJcS9aOdzGGlYOMZvgUEU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f4wyLtBqpDTBzJk+eNc+zm9BYhwyTqFT4ETRwihTCfeywBA7hXTQd7tS3NjKnLqN9d2p5x8VNBqeqgo2icydh7PQ4pkc0bXceFCV4PDibtivyncQpuPo6zdD4FpB3qNcZgEm2lTcLDhwyk8BG20JK3h2czNFrql8Rg/WZ3SGoLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=30j0K71p; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JrQ5i3t6F7BkQf1KmEIiq4daMexEJLyRG4RKwWDfKFQjSYDg3sK90VoUMPFTbYM4kECBdS7x7EMORxJx6/zy7xb9fz/GI+D1WvvvGElMTC/wGEW/0ntFSn2/Pva4eaHch/5CVsB/h9xF2PPzEku44ueRMs6VbOjFl7uToXvCRTmXYZyq84XyV59YCezMtsrBNUr7kplPYpco7ytSG2XcwQWrm+Qb6b+t0W6NWWC5vTBFQd6rWj6qLiZLs7lRzmELhNOw1aTHosvchsfU+/c2Jv0PqNWqz0RRjxsdIzP/K/43JDwBDQ3Bl/Lwvqjp8A5mbXxtlMWTyvcZMTLdw2zsng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pa4Ubb+NPsd4+gAugI0inrOppuuJC3KUqWU/A702+Ek=;
 b=j0NrmAhYs9RQO+n7HL3TzwPDZG9+cqAxHRoYKm0uJLaqth0j1MQu+znB395ZLdntOSEwv/fX6BFl4j85zh5hvaDbteyDbrbwRaqBLtmaXAIgXS/3LZipaLdboewpbp+vWTG6rNgwcRkRekhKMNNao7maBUDVnin4U4t+GVB4w//IJBH1I+ej+ekSwQo9lzXxeMfSakGtDb4MzFu2zBpeDqLKUcA6bA1RJ9rCBGdHfmoXAiY+/f/NxVCMgexl94q0SxVSREBDe88Rz1Mw4+2+WqaxDHApaaaNTXyH8q7zdtCzSelDdsdBk9ArpbdAatdpDIbMHijTIzyhxo9nqmX9VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pa4Ubb+NPsd4+gAugI0inrOppuuJC3KUqWU/A702+Ek=;
 b=30j0K71pX9bn9lWhGSF8w//RA3gLHyakVoHWccumDvq+LZEuCTKe+v+R+S0cj0NhASPyFOQSgwuqwyHen2Qmyk03dVtKkhpnPUGW5ZXsDh0KcRETgphO7VfQKvr2T1u/IKgHLBamea26K8CzyzSDbF5Linvy6drfN5L18p7LoB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB9101.namprd12.prod.outlook.com (2603:10b6:510:2f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 04:16:08 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 04:16:08 +0000
Message-ID: <7c09a269-bce0-2533-1795-9410714716aa@amd.com>
Date: Tue, 22 Oct 2024 09:45:59 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v13 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-4-nikunj@amd.com>
 <396e511f-e5cc-4850-bf72-0a2111f7683c@wanadoo.fr>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <396e511f-e5cc-4850-bf72-0a2111f7683c@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN0PR01CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::6) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB9101:EE_
X-MS-Office365-Filtering-Correlation-Id: 262f2769-f816-4a88-f5b0-08dcf25040fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWJQUGpKdGFwMnd3SVRrZTVGdzBVS0laSEtnSmx1ZEg1K3V2OFN1QXNsMnp1?=
 =?utf-8?B?R2JoMjBQRlJBOHl5RmNSZktISlk3T3NLd2lWaVZpVWJtVE9RdVpvV0N6V3ox?=
 =?utf-8?B?U3Z5VERQMGRJOFp2WHF2WXBQVWpQZDZwVnB3dlNGelgzSlN6OENjL2RjUUpR?=
 =?utf-8?B?a1pBOEp2dUowZ1Qra3ZISm5xZmJtNTVsTjZMak9rbW9obzkvSFVGOWJwLzVQ?=
 =?utf-8?B?S2JvY1JYM2FYNUFaRWhkR3VvaEwwSU1Mb3dibllleFhGdUJ5cTZKMnpGL2Ev?=
 =?utf-8?B?ZjFtZ1NST052dldFRmJYYnJ2azFPdm5EUThhTFEzQWc1OTcyRXBiem1CaXBL?=
 =?utf-8?B?YnN3NXRtY1NVSzNuK0xBcFdrc2dPS0l5dEpXcHJteC8wUzllNVlzUTcyek1C?=
 =?utf-8?B?WUpzanFMeUptQ09pVllsZ2VoUmk3SWhoelNLam9MSnBLamVkSFpZUFM3Qkhh?=
 =?utf-8?B?YlN2ejRXdGNEMk5HTE9CMjV1clM2bmtzS3BrME11cXdCQTZnaWdxV28xMHZE?=
 =?utf-8?B?bDB6d2xabTJuRFBLaUlVQzBEcXVPWEtIa282QlEreFQ3Sjg5OHlhblVMNkN6?=
 =?utf-8?B?NGcxa1Iwb0lzK1VzN3M0eCtWcHNGQVlyYWI2QW9sRG1LNklOOU0ySHZHNzNi?=
 =?utf-8?B?ZmRJZkwwdk43ZUIwWkRwOEQrTnNJQXlRL3R6M04rNmlTbXlhY2dHZ0dFZDRv?=
 =?utf-8?B?ZHkrYXozeWt2QkdXc3dQYnFzVW5rMEtUVjJ6aEZOd0NTSlVIa2JMb3JkWS9u?=
 =?utf-8?B?b0NBdkRTZUNjZG5wU2NxWklXOGRKUHBOZWJLcXAwdXVjbEc3VnZsSFlKMXFF?=
 =?utf-8?B?STduK0t5TExyS2h4a0hIaUl3c1FZeFR6ZER1MkpBVGp5ckVabjRhS1FuK2NP?=
 =?utf-8?B?NmVEbzZTa1VLTHd5U3J6eDZVcU45RmxwQVJuNGpLNVBIWnhnZ2xGai9hQVpX?=
 =?utf-8?B?bTFiTk0ybXlPbWQ1OUxrd2R3YUh2RXgrL3ZBZWtnN0JvU3JsNHpQTHdPMGpJ?=
 =?utf-8?B?N01MWTRDMU1LQmhkaHRvTlp3R0hSVVJKMUgxTDA5ZVN0d21VMXJZbnkzeW93?=
 =?utf-8?B?U3NCeXFkTXMrbkRtQ0VMcU1ha0hzTUZONkh0ZS9YUjBxaTBkbDQrdHorSFhr?=
 =?utf-8?B?NjZuTUZtSk94YW9iL1YvVktwdHF6djR4N2tBdE4xRGcxK3VpMXZOeUJsZVhS?=
 =?utf-8?B?M2hZbDJFdzZYMVA0NXhWcS9WenlxTExMUnk3MlY4OXl2Ny9UT3FxbVcrMlN6?=
 =?utf-8?B?eU45MXdSdEVEZzJheXloSUZBQzZzVkhIVUtZT0JYNDFILy9ENTQ4WC9nOHpT?=
 =?utf-8?B?SmozM3VabXVSYnNvdzNyMTBybE5GeThORnZ2VkdJekVTR25mNnpFd2sxT0s2?=
 =?utf-8?B?eVZVaGs5bzA5R2tCMDlKK1VVMTgvakFmQXg2aHdrVmhSYURqeVlyM05mVDN5?=
 =?utf-8?B?ZXpNTytDYTAvTUxLU0R4dmxaeWJFRmh6RnBaZmVxZlB3WWVsWFR2V0R4WVUr?=
 =?utf-8?B?YXNPMDU5TXF0TTA3UEVNM2dEYTk4QTNrZERnYnpQQjMwRVlLbzh1LzVpaTJH?=
 =?utf-8?B?N1IwVGdrMStyQ284djd5RndvazE2NVEwZDM4ZFZnTk9VcVJpSmtjQk9pYnQ0?=
 =?utf-8?B?QVlFQzdBeXoxWDlqclF1bisrMmUwdEhCVzBDYTFyeXl0a0NOb3lEUStzNC9l?=
 =?utf-8?B?eW50a1NmYzU4aithMjZUTGE2NWJCaXRaZXFXQklaU1hHbVBhR2RzTWxzaGo5?=
 =?utf-8?Q?mgsey3SjKmf/bikoYw6fOSMy6jpEqV3FNYgfqpZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUQvNmttM2NRZDk0UFAzZ05QUEVWd2lYSGU5U3M2dW02U2NGdlY1MHNoOE1D?=
 =?utf-8?B?QTVOY0pDU1k5L2hxakhJdWF6b01FdTdRbHErWXA3MjE1aTNOb2gwOVNyRmQ5?=
 =?utf-8?B?M2EzTDNRTk9Fd29LazZUN0svaGVpbjRqTENrTFJUMWhzUnVRWlZNOVpQeG1U?=
 =?utf-8?B?U24yVW5VbTRyNzBKMkI1ZmtQZlk2OEVTbFZZNmE4b2NsK1EyVUxMYkg1WWhl?=
 =?utf-8?B?VC9Ea2h0U1AvNGY4SzFQWlFxTGo2NGJZcFA2eGF4QVNFNTZ1Y1U5RXE4c094?=
 =?utf-8?B?L0ZzaSttMWoyd0ZVN3ArVWYzWjZ3L2tWRGU1UVpkSjVKRHBYVHdKL3cwQWFY?=
 =?utf-8?B?dGNVWGFJamczUEt5VUVsU0JRSGtyVXlUNC9tSCtTZVo5REJFYlVZVGtYOWY3?=
 =?utf-8?B?T1pYaWcrVW1HTlZLWHg2MzF5TktocHFONXBBdll2TE1tdFlnVDg5bTF3b1VB?=
 =?utf-8?B?RURFam9HLzFrSDdYajIvTzFlR3BVREY1ZDc1bFI1REUwQmFObkh6NFFHS1J0?=
 =?utf-8?B?LzFDVkhhcHVjVlErbWo4ZTRVQWlZVy9DakZYMEpkWHhiN1dEY0U2eDNrVjF2?=
 =?utf-8?B?b0xSU3kyV3M2YXgzRnpkZDBuTmdtRjdjdjVpOXFMQ040WlNZQXgwQjcvd29j?=
 =?utf-8?B?M1JIUnkyZU1uOTF5bnB3ZXFBTTByVDFnbjQ5RUJkL3FrK2lnUllWb2QwTzky?=
 =?utf-8?B?WWhvdGpkbUJjWHFoT0ZhVFk5NXdYQ0JTZC8wa3Z3bTl3QnpTaFM4RE9BODE1?=
 =?utf-8?B?UUxKWlNaeUFtZmRUSTNSQnF0RmtuTkcyL2hUYmdJZEltbk1aWFJxZjNyT1hS?=
 =?utf-8?B?bnk4ZjhvUkZxWHNrcGlOME1mbzdtWU5LcHd4QVlVODQ0UkJZR3BRN1Q5VzF5?=
 =?utf-8?B?RHBacHdnZ0xJZUk2S3VMbzBFeUVrTFpzbG12LzB1WU9nR1dOblRGdUVNbUJw?=
 =?utf-8?B?S2liRGtXTVhvYU9mb29iOXdqd2Q5VlpZRk0xajk3WVlJSWdyZXkzY1lCRjVS?=
 =?utf-8?B?d00xcGpIN3Q3cUlhUi94UU94ZWVLS2hnbGNkSzlCeWtHY1l4eisxOHR1WUlo?=
 =?utf-8?B?b3RsMVAybkZiR3J5dFJpd1cyVnZFdUZLSmtra01qUjc1SUpJZ1JtWjZkUzIw?=
 =?utf-8?B?V3JCYzgxT0N5UmJ6dE9ScVhQN3lHRWFQZG1iSFV6VWxidHliTHgzQmdhcjl0?=
 =?utf-8?B?c1hmU0RHSXpVRFRuc3lHM2ZRRXNpZjJ2WUFFWWM5R0dPc2RKU1Nzcyt1RnZq?=
 =?utf-8?B?bHdGbWxERk41cVhRTm8waVB6SDR3YTRrT0RicHlJRXMrcXYrdWlIdjIrV3Ay?=
 =?utf-8?B?OUhlcE42VHhkYXBYVzlGdXlXSTYwMThnQkRiRUhTN0JWanB3OTA5L3ZHU3d1?=
 =?utf-8?B?YnlQRnRDbWxuRXlrS1dBTHhnQWE3K0pRNUVBMEM2T2hId0d6SkpVNEpXdkRl?=
 =?utf-8?B?a1RVbzRxaEtuUnBmZEZsSmZtWmlMVXNXRWRndi9SaDBzdzZkSVpFVmtJTTVR?=
 =?utf-8?B?Rjc0RElPbDJlai9xeXQyRVZNSHVMRUxkZTFxL3huOURXa2UzVWFFWlNic1Rt?=
 =?utf-8?B?bVoxY3V4S1I5Si9wWFJ2RWNtazBpN0Fsck1rNVkyZEU0RWlwWmJPRmxFNnlq?=
 =?utf-8?B?dEo3bHljQ1pxOVJYMkp2bHdIVHZRYlpvQWNPV051UkRQR1duTXpUNW9na2Q2?=
 =?utf-8?B?TUNZZ1NZZkNDcThUb2tNVnBoYUZkQ3N3aDIzbkRaQ041cjU5WTN4SmhISDc5?=
 =?utf-8?B?MEVDYStlbDhmRnNYWFlUVWlPWjFXRDl5T0ZxZUkzNUEzSGU1YmtQR0Z3T3Vo?=
 =?utf-8?B?TkFWRjRnS0Q3b1JGZlMvanpqaERpQldRcWJJdTR0Y0ErQlRIN2gvRG5qVHhG?=
 =?utf-8?B?VlZWdXJmM0tsaUdEckwwOUFwN3huRHdkVWVhaWk2U1pWUVhlV0MvTmNLZVd5?=
 =?utf-8?B?bzRrS0FoNE01WlVzUFZOamp4UlVLMWpONGVDQ3NSQ0kwQTF3ei9QZFkxajUv?=
 =?utf-8?B?V0tIa3NOa201K0p1QzdpRDAyS0tEeHA3WTJ3eS95a0Vxd3lqci9yRlpDbEZk?=
 =?utf-8?B?NWRqa3RkbWdyS3JWTkRKUmwyYkd5UHhueEJ5SHBuRjJZV3YzdFZXcDBNcm9T?=
 =?utf-8?Q?pGpRqnqAhVJv/YRfUtjVPWE3R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262f2769-f816-4a88-f5b0-08dcf25040fb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 04:16:08.4709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l0dfK6hlc9k8WRuknv86moJU33MfA0JkBzX+qWv0rXracej5OdJmdMo81cvLQ+b23FmXwpP3j6aANvFANfIe4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9101

On 10/21/2024 1:42 PM, Christophe JAILLET wrote:
> Le 21/10/2024 à 07:51, Nikunj A Dadhania a écrit :
> 
> ..
> 
>> +static int __init snp_get_tsc_info(void)
>> +{
>> +    static u8 buf[SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN];
>> +    struct snp_guest_request_ioctl rio;
>> +    struct snp_tsc_info_resp tsc_resp;
>> +    struct snp_tsc_info_req *tsc_req;
>> +    struct snp_msg_desc *mdesc;
>> +    struct snp_guest_req req;
>> +    int rc;
>> +
>> +    /*
>> +     * The intermediate response buffer is used while decrypting the
>> +     * response payload. Make sure that it has enough space to cover the
>> +     * authtag.
>> +     */
>> +    BUILD_BUG_ON(sizeof(buf) < (sizeof(tsc_resp) + AUTHTAG_LEN));
>> +
>> +    mdesc = snp_msg_alloc();
>> +    if (IS_ERR_OR_NULL(mdesc))
>> +        return -ENOMEM;
>> +
>> +    rc = snp_msg_init(mdesc, snp_vmpl);
>> +    if (rc)
>> +        return rc;
>> +
>> +    tsc_req = kzalloc(sizeof(struct snp_tsc_info_req), GFP_KERNEL);
>> +    if (!tsc_req)
>> +        return -ENOMEM;
>> +
>> +    memset(&req, 0, sizeof(req));
>> +    memset(&rio, 0, sizeof(rio));
>> +    memset(buf, 0, sizeof(buf));
>> +
>> +    req.msg_version = MSG_HDR_VER;
>> +    req.msg_type = SNP_MSG_TSC_INFO_REQ;
>> +    req.vmpck_id = snp_vmpl;
>> +    req.req_buf = tsc_req;
>> +    req.req_sz = sizeof(*tsc_req);
>> +    req.resp_buf = buf;
>> +    req.resp_sz = sizeof(tsc_resp) + AUTHTAG_LEN;
>> +    req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
>> +
>> +    rc = snp_send_guest_request(mdesc, &req, &rio);
>> +    if (rc)
>> +        goto err_req;
>> +
>> +    memcpy(&tsc_resp, buf, sizeof(tsc_resp));
>> +    pr_debug("%s: response status %x scale %llx offset %llx factor %x\n",
>> +         __func__, tsc_resp.status, tsc_resp.tsc_scale, tsc_resp.tsc_offset,
>> +         tsc_resp.tsc_factor);
>> +
>> +    if (tsc_resp.status == 0) {
>> +        snp_tsc_scale = tsc_resp.tsc_scale;
>> +        snp_tsc_offset = tsc_resp.tsc_offset;
>> +    } else {
>> +        pr_err("Failed to get TSC info, response status %x\n", tsc_resp.status);
>> +        rc = -EIO;
>> +    }
>> +
>> +err_req:
>> +    /* The response buffer contains the sensitive data, explicitly clear it. */
>> +    memzero_explicit(buf, sizeof(buf));
>> +    memzero_explicit(&tsc_resp, sizeof(tsc_resp));
>> +    memzero_explicit(&req, sizeof(req));
> 
> req does not seem to hold sensitive data.

That is correct, I will remove that.

> Is it needed, or maybe should it be tsc_req?

No, and tsc_req is zeroed by the caller and is not updated by AMD
security processor.

Regards
Nikunj

