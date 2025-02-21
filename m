Return-Path: <kvm+bounces-38814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B2FA3E944
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:44:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 375DC19C4DE9
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F1818651;
	Fri, 21 Feb 2025 00:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tD+5/0wo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FD55CB8
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 00:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740098631; cv=fail; b=EJGibJ8vuvqnogQ/WD/vKkiIpYYPv42UKYr3MpAOZhzwrGP8EfKE1zDnPEATFvwxGPy+cPf9zyTTJKthVoP1zBtY4ZFvVYH/GnQ2cld5sVUUOdqWB4MamzwXP/IR11fVP3BPc3I3biHtuc6FpdwNne/7PSzA6oZXntPz9l1M7WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740098631; c=relaxed/simple;
	bh=UlkoJpklFmQNnxQAzzaA+AFpzLJr7/WPtn4qhGmzarw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BE7tEhSTDl5jTDimhFAd1HGwt1/4uPyoGq6jWdpsCjGPfDrMzpFAfi2PNaNVmBbJKxkv+AI76xxrw9kLEnxKlgzbDSrQfe3JxlayM1tctHLvMW5xpWgkjAshcp1S/T3QT29Fl4lhNdkqWm+jOHzA1F47lGipq7Yp5HN1gHu5cgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tD+5/0wo; arc=fail smtp.client-ip=40.107.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pVaJ01ao0/WHZtQEiVXqBNzA+RoAOTp9AX+9OtRLDyWzm94Hep62i9BUggk30cialmNfjfHpKk5xyi7egXHtxsDt+pH++YL4hEllv5uwuGYto17HHtcRBFEp6w1TjHjnVBJw6rXjP11xkG/zxuwN4nhYEb09Y4N349zPoWYvBrlllJXE5+HZpgudUe8vDGLf3LMBzn2d8aMFhjSsFwSQfF7exjXzRniQL6zVh3YbQtaEGUzmFv1gx3wJn0ab6G5QZH4OT6gSvShw5Ju8A5TC9ktY3mKPzKc5cQUPbumQ5QptcrUBUZlP8lw/7GbEyIrHVEV5+JFtvj+yK3MQs/S98Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/WfLyBkkTYODA8uH6NpyPciLru7bGOILIMjyIhmaHU=;
 b=kNkWnAHRERiutA2+Ffj9OZAhDTHgG0lMf4Ox+Ap9GKt5cfgcnO6U++710CjvmfGmSM0Y4hbWhpO4+4dtrOouIAYNknuKEpvuCKa6D0eXgTEthu9w57OYJtnvivn9J7/p08GqmnGtkVZ3yoI9G6HPNICteJVWs/PINrEc3VlPMROAkKWU5uhZdMW7TY14nRACDZ3LazCSXt6imlloAioqA+jgHJ/z5R2WOg+X5zf4eb7HXnaGBOXZMUbwEMWjJ4CdOLJl6M7Framm0z+D+3GfTXQEfHJhY+Wfjy8cwbJwK0y5W0mQ28guCnFg3dmXsv1wOpDJcO1X0UVfHeoAwTuhfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/WfLyBkkTYODA8uH6NpyPciLru7bGOILIMjyIhmaHU=;
 b=tD+5/0woqm1ep7PKq+ME5zwtJeu+y8O269ts2JhGvJmMNJCOReuV6jxZfjotBRo8ljSl7HL1GekN+n2ml6SqeLtIAgZI0nXvLO8z8WIQpdeCaScJmgh/AfF+LCvl6W06yzazNQVKatsn6oNEA9q29/GepNn/m6nRH8JgdJX0HWs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DS7PR12MB5743.namprd12.prod.outlook.com (2603:10b6:8:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.14; Fri, 21 Feb
 2025 00:43:48 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 00:43:47 +0000
Message-ID: <ab656d72-25af-463e-982a-09e4f991f92a@amd.com>
Date: Thu, 20 Feb 2025 18:43:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/6] target/i386: Update EPYC-Milan CPU model for Cache
 property, RAS, SVM feature bits
To: Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 davydov-max@yandex-team.ru
References: <cover.1738869208.git.babu.moger@amd.com>
 <e1aeb2a8d03cd47da7b9684183df06ec73136f87.1738869208.git.babu.moger@amd.com>
 <Z7cRYbhxviv1wNyD@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <Z7cRYbhxviv1wNyD@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0114.namprd05.prod.outlook.com
 (2603:10b6:803:42::31) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DS7PR12MB5743:EE_
X-MS-Office365-Filtering-Correlation-Id: 234716f9-628d-4e82-9d3c-08dd5210cd83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d3hlMWRFT3djVkJzRCtweXVHNFAvSmYxZmx0dTZ5aVNpMlF4VzlpTGt1ZHZ6?=
 =?utf-8?B?dkZjK2ZkMnpUVHNTWDFHbXhvUG5sUWdPQ0VzRWgwMXdUdFJ1ZVdISGp5YW9M?=
 =?utf-8?B?cktuQjRmeDFXMFprY3ZoYzF3SHdCSzZpM2ZDTWIzT0gwNWZ4emFLKzYyNVh1?=
 =?utf-8?B?ZzY4dzlROE1OV1VDazlSOEFFMVVHV0hXUTJCNENvY3JXUG91L3ZhUWRKL3RU?=
 =?utf-8?B?dUl1Unk3cHprSHFSaXRORm0wdWhob3VUOWdCSFZZRXhXaGpaTk4yRVI0cTVO?=
 =?utf-8?B?cWNUYkRjTnpVK0tjb21pS1lZMVc2V3hoMTlWRkdrRVNzSEhxNGlmVTZLdkZN?=
 =?utf-8?B?eGw2UzJvWk43cVNRMVNjQVZJTHJIZURGQis0UERWSGNGYysra0tZclhwZFBB?=
 =?utf-8?B?WWVDRmlja2xxN2RLN2FRek1HUU5MaHFHdFAyVHpyaHB5YkZ3OE1IM1RHTVhm?=
 =?utf-8?B?a1AwTFk2eHRYNkRlU1MzL0NsNXZHV1k5OWFmUVdUQ1NSdzMvSFBCQVk4U0ZI?=
 =?utf-8?B?RHYxQkJvVEQ4c3FXMDNxRytHUld5ZlBWLzRhRzBDdnY1eCs5NWlZT0I3Y09p?=
 =?utf-8?B?NHFsVkROQzQ0OFZ6VnpTbU5VbzNGRkUxUGlhSHRQZ3JLaWdIb3Q5cHpiRHdR?=
 =?utf-8?B?cnRaRWlpYklDYjZZVGt0VWVuRk1FMXZwRXV6ZlpPaXdibDJzTVFXUG1zMHUv?=
 =?utf-8?B?U0pIL3BiZUJGM0V1dU9TYSs1ZTdZRnlrd2FhVFlSNnFnNHZhdTA1MXhKTXVM?=
 =?utf-8?B?SGlqS1FGeUN3TGZkYkRvZVNXM043aS9JRitQTVppTGtURnpua3ZsV1JPRUZP?=
 =?utf-8?B?TCt2MHBXYjBRdGZsajlLTTdJeE01S3FKbEVlc0Z3dFVsQjZRQjBPVDF6Umt3?=
 =?utf-8?B?TVRnVFRJWmlWMmxFemtVZXFyQ1JNZUR3aEZDYytBQXNEc3NqRzZwT00raGVa?=
 =?utf-8?B?b2RZSDMzQ2NzZXJoRUdCQnlkbU1zUHh3a2J4emRzVS9Vd0pTQmNnQzJuanNn?=
 =?utf-8?B?Q1d2Nm1kZlFpUXlCZU5HZ2lDM3h3RFR3UlJ5dXJsMlloaVB1RlZPOENCZUdj?=
 =?utf-8?B?MWxXWTdSN0trV1pTMkRlTGR0ZEJqNEJwU3YxbDJLOVVGQXQ3RXZKQWxGZkJ1?=
 =?utf-8?B?c0xzeC9HWjh2dU1FTnhpNDc4UENHSE41YU4rNTVhQmxYSi9aNUFVSVVVNVpZ?=
 =?utf-8?B?bHhiZ3FnV2lybEdTcGErUHpxRU9CZ3F0SE5BbVRGblFWdGwyWTNIelM3TUJ4?=
 =?utf-8?B?TFBJeUJ3K3YwTjVIb2xzcng0NWdic25OazNIUzd6Ujl4cGFucWRNcTBnNnc1?=
 =?utf-8?B?WWhvNFJRY0l4Nm50aWxZRzlEdlRRLzRDZ3J3QjE4b1NIUWhpZytZeDVuc1pi?=
 =?utf-8?B?ZHp4bE01OHhGSFB4S1hvSEZJaE1LUHNCMWpic3JLcFFMREgrUHdaSC8rZm5n?=
 =?utf-8?B?azgrWEl0TDlqbzV1OVltbnFYTTFrSVo5L05EcG9QZnBhalExNXpKaW04RjhN?=
 =?utf-8?B?c2xEUWlFbTc2emhtQjI2WFF3Sm1PMVNlVmNEVWh3a3R5NHkzZ3Q4RmQzZ0VO?=
 =?utf-8?B?WjBBdnh5dytHc3dscEVSNi91czlidzI5dVZqTE9WUkUyOFhsWlBYSWo2cGhJ?=
 =?utf-8?B?WmVYR2VqNms5U2NGNXVDZEpBd3dtS29aSFpyT2EyczBwU2QvRENxY21CbG9M?=
 =?utf-8?B?TURNU21jbjh3Z2Y5dGFZY0dVQjlBd0FoKzl4Tktqd0xDcmpCQ29lVGR5T1ZZ?=
 =?utf-8?B?VlBMcElTYTkva0tZeWJkUzBTM1VqdE9iTTM3bWtDWHg3cGpkSjdmNlEyZ0Vx?=
 =?utf-8?B?UDNRTmRqN2l6aFRzVGVTQ014cXQ5eWVpKzRWVVB3UWQ2SjhDVUVsb0c5NTcx?=
 =?utf-8?Q?LnMENVcYAQ0UX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0NsTFFyVlNkcmlUOFdiQmZTYXpESlpaVzc5TWIxbUs2VnIwVmh4RWhWZTYz?=
 =?utf-8?B?NE5BY2oyMnhNMnQ2MHBYWlM2Y2FqRVlZRnJLaDlEdmNTZTlweWg1ZmhTZWN5?=
 =?utf-8?B?STQzWkNuYm1xajYvcmZJUkJWUi9uZEZtWmoxbGRVZHhGOUpjbmpDY29kRXg5?=
 =?utf-8?B?QVJZVFpFUDBpaXRqY1dZRkZEKzJ4azg0T1hrQXNnZUJYUDNwck5IdUdveEkz?=
 =?utf-8?B?cUZ0YktTdG9Qd01EeUhycXhhd09zOHVyaGlHdEJGenIxUFpiWHhRcWt0SURS?=
 =?utf-8?B?L0NqV1dzVUNFSWEyc0hjS0c3bnpXczJZZTJITFZqVW5FZkJJd2hQVjd4MW5N?=
 =?utf-8?B?S0FGT25uL0RxeFl0KzJta1U0ZXdGS3pRM2hyOStwMDVMQnlGNXVoZWptOGc3?=
 =?utf-8?B?Q1U5WGl5c0RteXUzV0dmY0FCYUZDaVc1Wm1NNUJmRnlTVDQvTGtzdXEza1NI?=
 =?utf-8?B?L2hMbkNweHhsN20wVHZIbjlIOFNaSEg4K0FyWldmejRNOXZmcGIwR3JObTZa?=
 =?utf-8?B?MVQ0OFpoR01lTnZBaHhjaFRxR3EreVB3Q3VXNHEzY1dKVWNxc3N2a2MwcU14?=
 =?utf-8?B?WFcwendzRGNxenQ3c3VKSUsvYnVtZHdUWjVKQXFpVlh6TTRjMEdQU1lhTXQv?=
 =?utf-8?B?TmdhenJ6bFF2ZHVVbjBQd2d6Qk5YV29pcXVMRm02dTBwVHBEVXVvYlhDYzht?=
 =?utf-8?B?dnkva1ZvYjVxTHU5bkl5Y1gxQ1JsMGhyWUhYT0RZTXhzZVFuZnpyUkhPb0g2?=
 =?utf-8?B?UlNJc3A3cm13K0pMWG95ZnRsWXdlVUNKWENCWlpFVmpSMjZOckNCZ08xbTBY?=
 =?utf-8?B?a0lKU2UrQUx5N2NCYUk3RTdNT0hIS0ZycnhiTFpzTFRnaVM4b3VIZFBPdzgw?=
 =?utf-8?B?MGhBOTI2dnV4dUEvVlRMaERlRTlRa05VVUxOMktIT0VoWUdaeHM5Wnp3emtH?=
 =?utf-8?B?YWZ1MDRjOENRSHRWdGpEWEQ4eCtiQUZNd2Q2amx4bGQ0clR6RGVFYWJvWXVr?=
 =?utf-8?B?UWRyY0FsV2FQcU9xNHdEK2l2RURhbm81cFVXVTNyNWhTZnFaRzhEWURzc2tW?=
 =?utf-8?B?c25XVTBGVk1UNWJ1bVdseXZ1VjZya3QxaWJWb0UrK2IrL1JZTWZaMUh5a3hn?=
 =?utf-8?B?UzE3L2s3WEl1aW0zR2pmUVdaM0wybGRGWFp2b3kyQUFQSTk5NFlUWGdjUloy?=
 =?utf-8?B?d2QwQ25yZDlQWnpRdXlRU3N3aktGUWt1cUhsRUFYVVUxVDhDemNmV1k5QXRm?=
 =?utf-8?B?MVBtUjFwNUQ2T2N6TW1UajhOVXpyRUhWRVVrVHdNYVpWUnZUeW1VUHpBM284?=
 =?utf-8?B?TStEby81alFkanRwdWQyMytSRE5PV1VIY2RoS1hIdngreVNNcXNIMEljSnY4?=
 =?utf-8?B?N0VXZ3gzc3VPVmlHMURJb2tQMmZYZjc5WWhuN2JvY3h6QXFzZ1lqQTVnVk1q?=
 =?utf-8?B?LzJqMzJBTjZmVGswdmViZVBCU3NnZWFoai80SHVNeiszV2RoWnFKazF4ZFdL?=
 =?utf-8?B?bjJZK3ZGYlBIVXZsNVlEakVudU44ZzhOdU04WTBzdUhrczFoK01oTWpGK2tp?=
 =?utf-8?B?eTMrNDNGaGdrWHlwQUxMbzd2Rm1OcjBpVzZleVh1bEg5MU1UZEZ4OXlUc3kz?=
 =?utf-8?B?a0dDUFZSK3ZnWC9tcTBZUXJWL3NHSzZGSG1PTkRROHRrY0lNbHVMQjRVRlZl?=
 =?utf-8?B?ZTJsQXVJa09yTXRrZTE5b2JFaDNYUXJrWXBUcmQ5T2NMM0YyNGRxOWNSUzRp?=
 =?utf-8?B?NVE0Y2YxMW5CM0RvZWgvSm1RWWVEUlVUT3V0a2h1Vms5QS9JLzFsMVc4amtz?=
 =?utf-8?B?M3hPWTE0MlhKbDFFSFM5c3JKblhYc2VOS1dRUVpISkVCai9NUkE1WlAwaGFs?=
 =?utf-8?B?MnZ2Wm1yaDdHaHZ0d2F6MGRXZlZvejhxL0pYbkVnT05rb0cwbkczS05KQzFH?=
 =?utf-8?B?RkhLcXVmRkFRWlAvc1JLSEdIVHlHOSs1dTRQaWRrT3REcWozVmRsK001ZWdD?=
 =?utf-8?B?QWNrbjd6RGhGeXVXQ3RNTEU3NmxOWVRWRWg3SXgyb1Z2UWdvZWFXMGhYM1Nt?=
 =?utf-8?B?TXF4cGVycGNlZUdUbmZJZlhET3Z5SSsyalJaOE9SMGFrSytEUkdiWm10SnFR?=
 =?utf-8?Q?mlQ6/gSKk7C5Y2ld6SeVCAtHu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234716f9-628d-4e82-9d3c-08dd5210cd83
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 00:43:47.8671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YlXFjJ99qHMEuEjcABQX/zWv2EFXMVMa8ogmvFQAedqDrmRinyHuC4cRN0+1j9ca
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5743

Hi Zhao,

On 2/20/2025 5:26 AM, Zhao Liu wrote:
>> +static const CPUCaches epyc_milan_v3_cache_info = {
>> +    .l1d_cache = &(CPUCacheInfo) {
>> +        .type = DATA_CACHE,
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
> 
> 

Thanks
Babu

