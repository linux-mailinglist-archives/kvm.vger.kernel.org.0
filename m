Return-Path: <kvm+bounces-51725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E882AFC1D9
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 07:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C300D16A40C
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 05:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA52A1E571B;
	Tue,  8 Jul 2025 05:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MAdBTU3e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8650E5383
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 05:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751950878; cv=fail; b=S5BxPLXpMg+x2QkB8oEfM46BP2FB/x/7xwgoP4jNnJndE/s9QMFYqJ8IkPb0FSYXR0zE460Dj/fGyD7E7DiixeMuX84S4Jg6PQBgH5L+vFHAxpaIROvnPT1AtfOTAoeDV2xKKWFM7GbotlBeG8Mtms9IQSL33BHkR+T08l+pVgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751950878; c=relaxed/simple;
	bh=LQpZIaX8cdodsAPPRyJ9v+0OFLlGxWAoGUW+HIAjXQw=;
	h=Message-ID:Date:To:From:Subject:Content-Type:MIME-Version; b=mI503xstPQGbDdaFqO+WJhHDxW+tlp4Meny+z3RlWUzP50NT/g9yPLZ9EnWH8CiqV202ElewLiT5O4SYsrSJ1ahLAPmPXhYrFQ93Qd2WvqEDHddhgdmrx+x5DCCiytRxe4iuauMxtnRLoyntRdDrywExyC6J5UmwAXBtACqwLw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MAdBTU3e; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cWOLfOXAdN6mhixxuJvWCCsuNNALyAYM8r+HoAwdobmJSNhgFZA0g7FRmCntFKzCWe81Z5uReHUlZ70nZZ38wp/Y+Gj3Cx8Glc+Bl0rq52g5T9heGiMawUeYhjzTkbYDZwT9qVT1NkbRG7qmZY5PkOusLgUxf/slCbHCI1hqsl5rscVy66yj1PZBEa33RiWJaeiM7vtdPh4FCTW5gORJs3qSpyh7mh4HAOiSkFPyXAqQjHt7nrq1jSlNkD3H2UT21NHLJX4t6JyDjvjcF1zWjx2ph8lplDq+PZVHZF/krm6vLDe7cgVGVw8uEjw0zpN7TqIrt9J06uskdJ7qwEgGPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsDt7EPOHnZScBzDvsKquJS2SSuxZ/Wo9xEsc5FnRYk=;
 b=joB8e+D8ZRq01XWmhJrxd4FlNmxhbE4S7FzbWHOSo2UiqdKfNJ58N/SSC45+RxmjGNpKsIjw0hzqVA4AYXyMRboqX5oDD9z2EuXLQGYwY9qe/6bgjhdjmg1PNeEqml/5J7iZS+Ww5bqUQgWOKXl6PHV1ExT/upYo1lQjK/mU3RXBr449OcSWj0dI6DAoujYaZPdtO7K2p1EaGgJ4vGVauvEzkjBFH4YmWiC6QNrSDs9J3oVp+XM1DJDfQhMCznQ25j9YbWeTMZpAeL5/SbrMpH1lZyXdlWgZKywAxwgTlRfFjawxy0KD1SLHAgsfnh+B0GJcFQANnTxz8v0pCHYOLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsDt7EPOHnZScBzDvsKquJS2SSuxZ/Wo9xEsc5FnRYk=;
 b=MAdBTU3eURWsyAncdX1eKKt2O9nG+cypQLzIU+kmr0ZcGZO4SHgFmgVDuCb19w3HD/6DcY5huRwgHHNx/I4P6+q6jt7cim2TiiPblFaCILTy4qIv7qqy8DKABlw4j2YBjnQpqQSsE0PPdkctdcbFIeeE46RZuKDn/Geqo4QuMKk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 05:01:14 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf%6]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 05:01:14 +0000
Message-ID: <f156887a-a747-455f-a06e-9029ba58b8cc@amd.com>
Date: Tue, 8 Jul 2025 10:31:09 +0530
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: KVM <kvm@vger.kernel.org>
From: "Aithal, Srikanth" <sraithal@amd.com>
Subject: KVM Unit Test Suite Regression on AMD EPYC Turin (Zen 5)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0122.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b2::11) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|DM6PR12MB4354:EE_
X-MS-Office365-Filtering-Correlation-Id: b9aa71df-7dd0-4b3f-03c3-08ddbddc76b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTBFakkwTmJKT25JL3lhY211MU9sZkphUmJmRUpzdTh6WkUxUElXVjV1Vmxk?=
 =?utf-8?B?ZDVjK0MvS0NWYTY4MzVTMXROM1JvQXU4NFkxRi82UHVEVUt3NkVPMnhmUDc3?=
 =?utf-8?B?VjdBNUJPSDg1bm9oMDdOa3M1UHB2UXV5cmhMWnpMcFRXenBDL0xLS0tEeWFH?=
 =?utf-8?B?cVRROUZUMFdoc2lZWGwxR0N1N2N5YURrZXlUcG54QnJyZzZLck1UQ242c2Ji?=
 =?utf-8?B?L0VkRks2ZHk2QjJSSktBZFJ6ZmgyM3kwN3B5MjVkV294TGtrNlF4QTVOeUc1?=
 =?utf-8?B?SGVYdWtCNnZpbGl3K2Z1V3dIdmQvSmV2cExXTXp6cG5PbFQwa0l6ZTNMNXlW?=
 =?utf-8?B?S1JVaDhBVFpqTGdHOWtUQWJzL2UwQWlvWDFIMzE4a2wzeTNnR29ma0t6dTI1?=
 =?utf-8?B?bmhISFR5ZUF0VCtEZlR6a1plTWNWQ2orTENDY0NEcGh3c0pIK3Npb3ZVdVNK?=
 =?utf-8?B?WHhwRzBoUE5waG02R0FTN0tpRzhsVStRTStsdGRjWGlMZldHdjF6SGFRbi9a?=
 =?utf-8?B?WDNTdCsvRDUwd1NUaEpEYzhpb01PMG5mNU1JSllIdUlmQTN0MWUvVVhVTWJO?=
 =?utf-8?B?VXR4OEVENG5FTVh0eXZUSnIwZ2xuUzFMTEdrWmc2b1M3dkJ3djhqKzUxVnVF?=
 =?utf-8?B?L1BMZzh2cy9WbUxnK3ZqRWllTUNLSWxqQ1pZcnp0aVhZcUdHTUlCMFJCcVZU?=
 =?utf-8?B?SUtONElVNXdIc28xS1lyOXd2ZlkrcGlzbHQwNk93bHFNZmxVbzkzZ3pPWWk2?=
 =?utf-8?B?bUwwbXZZcmxVTUFtN3VYam9SYTB0Q3dBdjF6c2RMTHF0SW1uY1pFcFFzKzNa?=
 =?utf-8?B?SkN0Q2kxM2RQZGt5NEZSVFpicnpuNmpYRkR1aEF4dTZibHI1VHkzdVFwU1Vm?=
 =?utf-8?B?a1pVd2YreWRFclo3b1k4TWFhYnh0QURqRkxpT1RBc3NiS1RxdkRIeStrQ0tT?=
 =?utf-8?B?NGVWZmdQYUNvVVJDK3Y4K2N6UzJkVlg5RUF4RGN0aDlsUEM4d291RVZEVmQw?=
 =?utf-8?B?ZWtwZUdpWGNxSDhHb214RTk1V21DdzVJK0N4czZIWXU4MTRzcWZ4ZkZWcDZo?=
 =?utf-8?B?VWFMYkpmWkZHM1RZMGtJSU5CdnN4elQyTDc2aklBcGJaZkZwVXFyNk9WTDhO?=
 =?utf-8?B?WGVzVkQ1MjkzQit6ekhVMFh3TUtPS3dpZzRJak5MSzZuZDZ5ckQwTVhLOGlv?=
 =?utf-8?B?UTRUeUUySVptU2FWclBhSjBianA5TVZ0U3A2bUM3Z3d3YkZzNjF2ZjFkMkhS?=
 =?utf-8?B?dlhINXc5cVV2RjN6aWlneDNFNWpqOFpkeVZzZk9DTkJDQmkyM0w2RGttbFJs?=
 =?utf-8?B?THJldmVnNkxtMGhQNk11SnpaWDUwNkRacjQxTk1wYlZUb0Zhd3hORno3S0lr?=
 =?utf-8?B?M3FjQ0pRdDArc2lLSUlpKzhUOUY3WVdHMjZ4Z1JIWDBLbFJHb1hSZFB2a0dl?=
 =?utf-8?B?V3oySVBGaU0xTUtSVFZBTEppMWpKQmYvVVBzeWFLOEd5U3kwVTBtb25rT2I1?=
 =?utf-8?B?bVFpTFU2RVByMUhLVzBJWEp3MjFBTGZzdDVNd3lrQlV0QTA3eGxxaUhFaFRn?=
 =?utf-8?B?czBsVmFsN0VtalR6SHROK0dnR1lPc2FVbXExZllvTHAveS93blR4Mlh1RXp6?=
 =?utf-8?B?UHFOdXY2LzNuUlNnK2ZRMkxML0lDcndvOGRLSVJCZ2EyWXdGbW5LM01QS2Zy?=
 =?utf-8?B?eXgzd2x6ejV2VHBVMDM0bm5ieTBGYi91RVpPM2VJTXJZWTNneGs2YzFEZnU1?=
 =?utf-8?B?SW9DckRhVnRMSThHdEFIdnk4d2RUR3craTY2V2lKYkI4YnkwVTdaNDY1YWpu?=
 =?utf-8?B?KzVBOXpTWFNsb0gzNFJSeURFaGFVRENqVFVtbDZGUGNqNUoyU1QzZ2VvZ1hZ?=
 =?utf-8?B?N0hzZlZnUmFLbS9DMEZETEJaNEdsdWhaNS96elhuRmpRMVhtV3BlcVE3WHpZ?=
 =?utf-8?Q?TuDk7lnuooE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTF4eDB3clByM1N4TGlvRVlldUxNa05NTysvNU5Hd1F5Q0J1N0tMOWdoNHZB?=
 =?utf-8?B?aXhna202TzNmY205U3FJWkJxRzhSaDRSbXlTanZPR1ZRT0doU3QzKzZBVkJB?=
 =?utf-8?B?L0FUYmppT0RuUjVrWTFOcjF4STRpMkMzbFE5U1FGR05LaE9lbWk4Q0ovZTQ3?=
 =?utf-8?B?bVh0QkE5bkJCa21oSHZVUU9oZHA2Q0NkOTVvYVZaWFY2dmFCc0tiL2hjejFw?=
 =?utf-8?B?K2g2N1J3L3VZa0tXWDMyVjRJV0NKQVBhZGVudTdIL2ErWTNoSkR1R3laSVRB?=
 =?utf-8?B?WHdmNHpvaG8zQUJOVng3NWRLNnV6a1ZBVDBUVHVCUFpUTFRsNVZDS1h5b0xa?=
 =?utf-8?B?SlpBZWJyYmFWbXpqRkM0aERoVy94QlZSZllrTTYyRVV4VFRsdTdRejlBMy84?=
 =?utf-8?B?cE02UjVDWmFuRUxmVEZtci9pMlJwenFkRUgvVkJWYUNHUFdqTThWSVRNb2FT?=
 =?utf-8?B?VXFQcURqVDVhdDVyZ1lidm5ZdEFYaUtwOUtPaFo1b1kzTGFBRHk2bFZzT0xi?=
 =?utf-8?B?S3pWYnNCMDBTU3I3amg1V3haTGpZQlgrTTlLV1EvN092R1Q3NjZPVFdBNGdB?=
 =?utf-8?B?R0dhU0hnc1FFVWp4RWFiM2djV2dTMUVZOENyUFg3RnB2WkNmR3hMMDBHUUlv?=
 =?utf-8?B?RkJIN0I1NXMyMXRWWHI1R1hpWDI4cXpvSCsyYUFXNUQwSGYxSE9lUW9BVk5Y?=
 =?utf-8?B?U3hDcDJjbDBxMmFHd0g5eUNrdzZDN2ZXQmE4cmFvZDl1SkZiaGFzNGlGY3Bt?=
 =?utf-8?B?MnhuREhnR1VQM1hiQWYxWXJHR0xHS1k3NjFWM0tvM3o4QjJOdEhRVVM5WW04?=
 =?utf-8?B?dTFUNkY1RHhGRFAyTzJHcXFaYzBHVXFtR05PeGFsZklFTHk3cCtpbWVqTnJ5?=
 =?utf-8?B?UlhlQUE0OFcyVUFJYXJDOFB6a2laRXBTZFN2UGhCUlFpSmhqZFRPdCs4Q2JN?=
 =?utf-8?B?S25PY3NJa0xRdWRYQTVzZWdYT0psOEhpbWFRYVpkcWs0eUpFNmtzc0ZUZjRa?=
 =?utf-8?B?RzFGdUt3WXoweUNjNTY3ZTM2aHNveG0zbDZaMlZhVGtRdUFWOUxaUXF6dEhB?=
 =?utf-8?B?ZzByZzMxK3lrbEpLQ2pHS21ieDN3Q0p3L0tNVXVqTURkYUs0U2pzK1p0M3Jn?=
 =?utf-8?B?Umw5L1FlRDVTQ3hiRXc1MC91VUxEaUNSMzZ6V1ExVTZOV3gxNFArYy9Cb2li?=
 =?utf-8?B?U3c2cU5MMHhTa1BOa1FTOUtsTG42VFB1MSs5a29zRmhuM1RxYWl1M015WFAx?=
 =?utf-8?B?YXMyV3Z2N0d5VW9sZUZXdDRHTU94R0t0c0JYQXo2S3hlQUxvT3poM1lYQ2Q5?=
 =?utf-8?B?YnZtRFJHdnNyTUVDNVJJb05iZm9NSlVETTh5cG9Bdis2ZVVjVGNzdGZKblB2?=
 =?utf-8?B?TEp3TDJudjhsdytKNlpHTjAyTlN5Ymd0cEpFZTJ3OHBQWXdLS2Jqay9jcmln?=
 =?utf-8?B?ZzNFOGJZWGxwQzdTNFBKK1kyTlY3ZURSN0VRNjNQQU9TKzArRWlIN1ZsRUhT?=
 =?utf-8?B?RklZMVRPenVUWVRSaDJoaE0wcUQyUHdZMlo1VlZiS3JpcUhPNENKUnYyUTVy?=
 =?utf-8?B?TDE0di9GbVZuWFNqeXk3aDBHNTB2TndONGVSNTRqcCtQS0phRGxrU1FyT3F1?=
 =?utf-8?B?ejhSOTdtb0NsbnV4NnV6NFFJZmVPdUwrVUM5dnZDR25SZUhBbHMxL20zVnJh?=
 =?utf-8?B?c3luV3h0WU50NUhwNGVRRVprNi92YlFPYVdhZnJWdGZCL0xlZ2ZrcVdDa3Bw?=
 =?utf-8?B?SndZZEpZOE8vSG83bGY0WFI3RWx6ckNlVG91R2hINkVVeHpXWUQ1d2sraVdU?=
 =?utf-8?B?RDNLWXZQY21JNGpySTB6YXk4cTh0Z2Q5U2U1RzJUS0JjTzZrWVJPNEQ2dzA1?=
 =?utf-8?B?RUYzRGswWUJnY0FGN21XWlJWYkFxaXQzOTgxamVVaEh4c3k0aVZ4UFBnVWVV?=
 =?utf-8?B?UVVRcUMreWh0ZU82TURLdnFrN0NzejRISnpJS0ZOYVdlQU80bEYwVXRRR1E4?=
 =?utf-8?B?S3oxSWtSNmxkRElzbzRKVy9EWFVxVVN1U0R3aFEzL3lGZHNVUmFjRWluSjZp?=
 =?utf-8?B?d2RuMlhDeVVjUmtjODFPWGlLQkRvVkhPbmZXWDJEdHRHVWFWVGUyOG5sRCtZ?=
 =?utf-8?Q?RSG5549dnA9kQNwtvi1dC2hZA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9aa71df-7dd0-4b3f-03c3-08ddbddc76b0
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 05:01:13.9711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /cwLKNsBFzePkEEw2ikCvgbm6izq0rgKv+IVgUjzFhv795s4aRLspTJ1Mh1+GPGravnfvmC/KM/s/YPU2jLjWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4354

Hello all,
KVM unit test suite for SVM is regressing on the AMD EPYC Turin platform 
(Zen 5) for a while now, even on latest 
linux-next[https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tag/?h= 
next-20250704]. The same seem to work fine with linux-next tag 
next-20250505.
The TSC delay test fails intermittently (approximately once in three 
runs) with an unexpected result (expected: 50, actual: 49). This test 
passed consistently on earlier tags (e.g., next-20250505) and on 
non-Turin platforms.

[stdout] timeout -k 1s --foreground 90s 
/home/VT_BUILD/usr/local/bin/qemu-system-x86_64 --no-reboot -nodefaults 
-device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc 
none -serial stdio -device pci-testdev -machine accel=kvm -kernel 
/tmp/tmp.j05CJuifTf -smp 2 -cpu max,+svm -m 4g -append 
-pause_filter_test # -initrd /tmp/tmp.rYXaENVjEC
[stdout] enabling apic
[stdout] smp: waiting for 1 APs
[stdout] enabling apic
[stdout] setup: CPU 1 online
[stdout] paging enabled
[stdout] cr0 = 80010011
[stdout] cr3 = 10bf000
[stdout] cr4 = 20
[stdout] NPT detected - running all tests with NPT enabled
[stdout] PASS: null
..
[stdout] PASS: tsc delay (expected: 42, actual: 42)
[stdout] INFO: duration=20, tsc_scale=670, tsc_offset=505748840785296448
[stdout] PASS: tsc delay (expected: 20, actual: 20)
[stdout] INFO: duration=9, tsc_scale=830, tsc_offset=8332629130251870915
[stdout] PASS: tsc delay (expected: 9, actual: 9)
[stdout] INFO: duration=46, tsc_scale=550, tsc_offset=65726211827426474
[stdout] PASS: tsc delay (expected: 46, actual: 46)
[stdout] PASS: tsc delay (expected: 50, actual: 50)
[stdout] FAIL: tsc delay (expected: 50, actual: 49)
[stdout] PASS: shutdown test passed
[stdout] SUMMARY: 285 tests, 1 unexpected failures
[stdout]  [31mFAIL [0m svm (285 tests, 1 unexpected failures)
[stdlog] 2025-06-30 08:38:28 | Dependency was not fulfilled.
[stdlog] Not logging /sys/kernel/debug/sched_features (file not found)
[stdlog] Not logging /proc/pci (file not found)

Versions of qemu and ovmf used:
qemu : v9.2.3 as well as v10.0.1 ovmf : edk2-stable202502

If this issue is resolved, please include Reported-by: Srikanth Aithal 
Srikanth.Aithal@amd.com<mailto:Srikanth.Aithal@amd.com>

Regards
Srikanth Aithal


