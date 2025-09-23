Return-Path: <kvm+bounces-58564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1330B96B65
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E7362E40B0
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7382B270EBB;
	Tue, 23 Sep 2025 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CCpusJJp"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010062.outbound.protection.outlook.com [52.101.46.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6598258EC1;
	Tue, 23 Sep 2025 16:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758643385; cv=fail; b=endowQ4xctaXokUTKC40YakkcraU63Wkt0j4Xf6oV/iLh//PZw8O74Hxm/RZ6vyNa2vXGWrXVa8e9XOe8oD6KVYPdTtrr+UFgja3beBm3NoBGEeDA82woQcCypVHdPLX7KCtTwoRMeY8qDYIpoUjycpJIr+eAjYOVhKXwHiUJo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758643385; c=relaxed/simple;
	bh=y9d5pcBQ9eUAyMvMg+Dbo2y/QIcvH3ooDXVsSoVeKKg=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=d4tvP91MyWBYzyr2zUCe8kMCt14lcU0mJK5RLNYbOYJ4IWil0XKmt0WKMyPIJ9LOvlNDjK+Is4WbWExcXuHbLgzE+QFHg4CXEfMOPnnmEguKHBBf6MM7x2G/3TTUTp1IGLXoUscN3pGadIyBOd/GI7pwdr/RFtPfX6ojpnmKi98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CCpusJJp; arc=fail smtp.client-ip=52.101.46.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x+9O6jAih51cxEz4hmsbf3wtabc51UCXxPtm8HIFsfENKKyNfQ6SjxqHKoVIKlSAwgV0wUHA6FhGjJ5j4FhbVRXJWn5k+N2kGbWNMC/Hx7vzYbXp0UB+tP0BpzoxvCL5XuK0vt5lhwL37ZJbMxEq/QnZdCR+VKQneMAyCdUT41NCAVlII0GDGj1LFvcxksX8foAWgGFKWBgrzwvc5POkkvQ3g4NITA04CuGOHzvpKAw00Sae+RejTQ1+xnEC2mheKXp6/gD+Ib3+SisvqExbq8nWQXqdqvG8MjcGyktrlV70SironfU2xFyvSEnoSJoKX/2DF1g3ofO5dlOtMo/baQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aic4soMJACNy1jpLDr6UxT1DD90Y/CmFxQOs87Tr5lQ=;
 b=CmNvU0GZBptgOZF66KAujKgMd7ezAL2UzJGv9B+GsJHdhYzgJDBYvO+axqJYC86wDt1hHGtvA4BuWug8X32XAOknfKXJrh4Q46hSPFNBnxO2ZVE2hTU7WfjA9Ai0W4eC7clHUh7Wsbso96AlDMNdSwqWCUZLcGyYEQAvgjvIUHcDt85tzljMulIz4KeEPJn9k/giRAzObNAPnb99g/fvFOETEHvyRSgAl9LcvzFLvdUPGVgIf1nlqNzDl+n1cVuaslr005e1zvzjqybzo4ennv3Yma0I2ii6zki8ZaNPVmnq/U7Ij4HMoTuCkWJ1kcKQL/Fk5354zbCUNQNaAYhrGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aic4soMJACNy1jpLDr6UxT1DD90Y/CmFxQOs87Tr5lQ=;
 b=CCpusJJpxgdo0mVqevI3NbXt61uMInatqB/zi+pLbzu9eH56KvXEalIgxi3schMjeuA15MkUkdrUdTiPJofoZQTRMDwLfqSe3ckrkFy1uzJqcFnOISO1HqNXXwEimg5/gioh4DpZWcMHBuPK/FVGh+b8EFEEFV+yB/z8VlQjC6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ1PR12MB6100.namprd12.prod.outlook.com (2603:10b6:a03:45d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 16:03:00 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 16:03:00 +0000
Message-ID: <ca0133cd-4cef-8eb8-0698-1a130b40271f@amd.com>
Date: Tue, 23 Sep 2025 11:02:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-13-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 12/17] KVM: SVM: Add VMGEXIT handler for Secure
 AVIC backing page
In-Reply-To: <20250923050317.205482-13-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:806:20::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ1PR12MB6100:EE_
X-MS-Office365-Filtering-Correlation-Id: a254f986-3322-49ec-d793-08ddfabaab80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVNocHp2bzdKYUI2Z1IyNHZ6c1pmSEMrRzZ5TDg1RWw3TWFLYW80YlhMQjNZ?=
 =?utf-8?B?Q1ZOSXlHcnR3YWhXclpjUmx6RDRvdFNmbm5zaVlwTnRaMUMySVl0b0d5bk9F?=
 =?utf-8?B?MWJxWGZHY1BlNEV5V1EwNnFqL05PYThSVTdDZzVIMWVCdUtoK2Z6RVFOQ0Z4?=
 =?utf-8?B?bHdBZEFha3FINEJIZHFYMVVVT0lNb2ZhQUErcE5HdDVHK0Q5azBZRWdpQUww?=
 =?utf-8?B?cEc3WHdLZmNuMExhNlh2N1d1TjRDMEtvcDFrTEU1TENGcnFMd2NPZTRNU0Rp?=
 =?utf-8?B?bHEvWStTT2ljd0hrRXk1UlQ2MjhWRWhndkNSdDNoa0VYa3hNeUN4WllFNVVU?=
 =?utf-8?B?YklqRmI4ZllPYU1Vek0zVU9scDlyckJzdEtvNmo0RTZQOVNGZDdDc2hpTWhC?=
 =?utf-8?B?T3d0Tlp5bmxwRUVEUFk2SDNBVWRqOXZDTFE4c3hOdXcrTmJ4ZGhaRkd4VzFk?=
 =?utf-8?B?M1cwamxuTmVzSktJcFNOQks5VVdqWVMxU0RZTVZjTmRMRUpROGlVWHFLVUE2?=
 =?utf-8?B?YllqdGtQNm1oVGV3MEdsa2tVMzJzQ3VFNFduOHFDc2h0Y3VUWXRxaVBLcDFt?=
 =?utf-8?B?aFVwdy9EWkk5YWtjK3pjbGdOOGkvWmtqRmZxaE9XMmY5cFRVYzdwQTBraWdR?=
 =?utf-8?B?TmhjQW5OcXlNWWd3ZWtKOWU5c3RQRENCc25aeHVnYWVpZmxqaXpwUEVvbTF2?=
 =?utf-8?B?Sm5MYkszb0w0S3p2dUxaMEE2Nkg2d240WEc5VkVvZ25jRkZiU3o4cThpbE0r?=
 =?utf-8?B?MWZLMWpFbFhTNGNoU21qeEY3ZXAvTFQ3VDVMVWRta3lYQzVOVXhXYVc3Mm5s?=
 =?utf-8?B?TUxIZFc2RzZHR29mWVpQa0NMSFNEbm15THhRUFhqVUNmWFdwWjVQVU1TWkYx?=
 =?utf-8?B?Y0JlNTJkN1lrVlFFcW53Nk1xU0FYYzVBM2dSbm50eXBRQUZ1OGdsbGhzb1lH?=
 =?utf-8?B?OWUrWFg3MEZJNm9LejBodDV0RFBtQ1lHK0V0bXdBSFZzemg3emRiYzNESWla?=
 =?utf-8?B?T2NNMTRLZ0NsQzlPMmNSY09LQ1QyMERjczNiUmNTYTJCVUphc2JmdE1LdEx3?=
 =?utf-8?B?aGRrNjRiYkZ3OEo3V0phNmdneERKek92LzN3dVNlWDZKL0pEVlBNVkc4elcw?=
 =?utf-8?B?NkhLbzBvYjFWRnkwVlFWajhEZzFlOWZoTWIwVkUwMWhVRnA5VlRuRVJINUlR?=
 =?utf-8?B?dEh4cFZSRmJ4d21wenBua09UaGhkR01ad00xT1ozZW5mMVdUYzdDMUMzZzht?=
 =?utf-8?B?alMrRWx2QjdiQVkzVVNPc1UvV1B0R29ZWHVSMWdCV21mdUlhclpFelZVTDBn?=
 =?utf-8?B?YjNKVkFJa2twalo2eGFXbFFXS1BHRVI5aTRuaEgrN3V6RUc2S2M3WjBZc1Rs?=
 =?utf-8?B?S2s3VkdYOSt0YUN4SWY1QTU1Y0pnd21hTlRJTmRGUFBsbGxjNWN2bmpkcGhz?=
 =?utf-8?B?ak1HRWJ5cG4wZjlJZEFGalkxRnczZVRlS2czVG91REJuSzhuOGVXbzZOYzFD?=
 =?utf-8?B?clEvcm1kdG5FWlhjeE5oUnFqYUhFNWNPYUdXaC9malpNR1dZZ1RyWWxNaXZL?=
 =?utf-8?B?WW1HYTI3TFdFMmUvZkNtWDE4dzc4aE9iTTZBc2o2TEhPd1RMK1FHZnRKUEFw?=
 =?utf-8?B?SGtDeW9BKzVndTJyNndqclo3SHNvNUJjZnR5cHVqUkhtM3BpSktxcDVhNURl?=
 =?utf-8?B?WUtvMlFZSzZ4YTFYYmpZblBkV0Ywbkw3d1NqRnBjUHluaUpZVnZKenNHUk4r?=
 =?utf-8?B?alJGMlhhWktCQ2RPYWpqYkIvdXJyWSs2Ry9GM1BkVTNaajFsMGtuWllDZE92?=
 =?utf-8?B?RW85SFdxMWZlWVBwOHFGekcxS3lpTkpFWHBkWG1uY1JrRHd1emxpUkdmYkRk?=
 =?utf-8?B?MjhtTkRVYXIvZGFiSk0xeVo1SnovUDh4dG5sdmFMdjFreWpnWGlLSTc4ZGdw?=
 =?utf-8?Q?CO5+7TIfftU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alNnMGZmM2lxOG93RXY0VDhhcXdCcFNrazVzRGNtbEhDcHVQSVB1dUJkb1Mx?=
 =?utf-8?B?QVZlS3lUenB4NXlkUk5qUkdmdk9PZDFmL2I2NUorZURkbG9uazNTUnFZbFUv?=
 =?utf-8?B?eGNaK2tweVc2R2tKamhMSkpiZGhnSkkyd0o3QU5payszR1pMMW1wSnZXUith?=
 =?utf-8?B?R2Z2SS94RTNsaW0zUEg2MUNaekxzZ3ZCV3ptMW5sNnpHMXBtcmZ2R3JocytY?=
 =?utf-8?B?blY1S0lSS0I0bGRDYzJzVVNOeWU4YXp5NnBLalJILzRDYmJXbHdGdzFLYzhO?=
 =?utf-8?B?R3Rucm50bWFtUjI1bTNLUkhVcU1HcFN4QmFVOUdlZVlIY2Y4b1o1UFNjK0JR?=
 =?utf-8?B?VVA4cldNeGtudG1zT2I1L1N2N3FXN2ZiNTMySDFiTU9nVzYxc280emV2dWYx?=
 =?utf-8?B?Wmh4V3dqdXViZ3E1Y1FNVEpIMUViQklEbHRFc1ZEMHRFV0RLaWVqNnV5bUt3?=
 =?utf-8?B?VlFEb1NhbTJTTlV6VHdFUkhBakZWMFJGNXNVVmk1aHBMcXIvYzcrSTVwSU1u?=
 =?utf-8?B?S0x0ZHhiVm9TaC9iZVo5NUV1SE9Na29NUFFFYU5WeEQ4d1cvakRBbEZZSmpq?=
 =?utf-8?B?cEd4SjUyeFowdjNXU1JCWlI1c0pqTktYay9UZERJNGM0aVI2ZWMralo5a0hj?=
 =?utf-8?B?TlkvUEFJSHoyRkVjRXZjMW9VTUlYQWFOMWF2RWVrT0NTc28rcG92Y0NOQWcy?=
 =?utf-8?B?TDhWdkVGR0xxMUFzZTBxMTZyekdlWG5qM0Y3M056dkMxbXZEcW8ySDlvV011?=
 =?utf-8?B?dExWdStrOHJkTHIxZFdVd3VUdngrekttSnhXRVhDMGo4aFViMHpYS1RLN0F2?=
 =?utf-8?B?WStzNlNVY2lTS0hkazFSQmJkS0RBYVFldTJ0N1c4QnZuZHp5ZHpqL1ZSdHhF?=
 =?utf-8?B?elA2SXNwY29oNG1aVXZQdmVscE5walozSGZNelhqWktUTVY5aEpqbHdnZXdv?=
 =?utf-8?B?Z3FuQm9uUmZ4UDhva1I5T29CcG45VDNtd0IyWnBrbXphcTdnQWJsZ2tkVTdQ?=
 =?utf-8?B?clhDd0dudlJoZHo2YmxPa0hFNVMrR3VUYVBMUHVYcnJzMmhMMWJVbnI1QWpv?=
 =?utf-8?B?M1RWeVhENlp0VmIwWGtFSlhOazV4em81VzRPM1MvK3dKMnpHbU1yZkRFUEVS?=
 =?utf-8?B?QSt5YnhFWUxwV0M5aTVoaGY1VUxFamlCa2tSTi93b1RqWnRnSEZ5MEp4bG0w?=
 =?utf-8?B?VEZGSS9id2Zma2g1Rk5WODc1bHlQRXdmWVBnYkhOdmxrcS9QdFpEQlNXS2VV?=
 =?utf-8?B?Rk94VUhSeXF4YnhJZnN4bFkweDJDc2pMZ2crZUtjZC9Zb1BTR3RTUEVxdFFI?=
 =?utf-8?B?V2ErbmppL1BJRUd5cGtEOXpLZHpmb09ZbVlNRG1EV3RHQ3AxbE9ib1hVOThl?=
 =?utf-8?B?dGtuTXlyQUJxaEFvanpWMlE2WFJCUDJZckdoOFhXMVIrWERRTTJzRXRSWUh3?=
 =?utf-8?B?dmlVQ0Y5YkxSVHpBcmtlN2EzanFNZ24zZGpkMUFFamZyVVY2eFpkcmhvdlZz?=
 =?utf-8?B?UnRhVzIxQy9BY1JaczJpTFpDNEw4WGxmcCtjYnlNenBOcDI3NmZSdW4zUzB6?=
 =?utf-8?B?YSsxaGxtTXJMd09CV29KWm0yWnNSMmN3SWgzeUZWbWhvMzJxYTZOaVlCWmJx?=
 =?utf-8?B?YnM3NUFEUC9GUitKd1hUdnplVHV6VDRabTVscDU1azQvQ2hmSklJalhYL01t?=
 =?utf-8?B?cjdaTHZDcG9vQXlHYUVpdFViUk1PTUtpUUFLdXdRNzA3VlVYdy9BaVErVDFS?=
 =?utf-8?B?Y2E2MnoxNkZ5REtyaGNmd3E5VzhGUmd5VTZoSFl0YWxjMklqTldta1dWQkx2?=
 =?utf-8?B?dDdlZVg1bGlibUxJUjdWd29QQTB0RGZENENOUkUvaGwyR0tSQ20rcnpWdlNP?=
 =?utf-8?B?RG11d3NqMUkyTTZ3Tll3WHd6YVoweWdmaHNOVU53RUwzS0ZyYlA3Z0N5eE5M?=
 =?utf-8?B?aDhoQnIzWE9pdklCRW5QckVxS3JRNzRCTVVaSG9MWGhXUTQwSWFrRUZQWXdt?=
 =?utf-8?B?b1IvdFp5dWIxSWRKNDM3Qi9lcVJ5NGQyMFhPQjRpOUVDVktiV0tpT0RNZkVJ?=
 =?utf-8?B?d0hEWVJtWlZocW9OQ0N5S24wYW82K1pOR0xZRWU1aGQ0OFp2OHFmOUtSN0FE?=
 =?utf-8?Q?Ee1yI6N0Gy7yXswUp9O0bIwUY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a254f986-3322-49ec-d793-08ddfabaab80
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 16:03:00.6709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vBLi+Z+LNV0dmiB56eaOdwD56V5pWyy3mqdFJGCmMZfDGjztFDdrPU+P6XRoxT5kY/41HTtQaEKm4UFOUVYfbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6100

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> The Secure AVIC hardware requires uninterrupted access to the guest's
> APIC backing page. If this page is not present in the Nested Page Table
> (NPT) during a hardware access, a non-recoverable nested page fault
> occurs. This sets a BUSY flag in the VMSA and causes subsequent
> VMRUNs to fail with an unrecoverable VMEXIT_BUSY, effectively
> killing the vCPU.
> 
> This situation can arise if the backing page resides within a 2MB large
> page in the NPT. If other parts of that large page are modified (e.g.,
> memory state changes), KVM would split the 2MB NPT entry into 4KB
> entries. This process can temporarily zap the PTE for the backing page,
> creating a window for the fatal hardware access.
> 
> Introduce a new GHCB VMGEXIT protocol, SVM_VMGEXIT_SECURE_AVIC, to
> allow the guest to explicitly inform KVM of the APIC backing page's
> location, thereby enabling KVM to guarantee its presence in the NPT.
> 
> Implement two actions for this protocol:
> 
> - SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE:
>   On this request, KVM receives the GPA of the backing page. To prevent
>   the 2MB page-split issue, immediately perform a PSMASH on the GPA by
>   calling sev_handle_rmp_fault(). This proactively breaks any
>   containing 2MB NPT entry into 4KB pages, isolating the backing page's
>   PTE and guaranteeing its presence. Store the GPA for future reference.
> 
> - SVM_VMGEXIT_SAVIC_UNREGISTER_BACKING_PAGE:
>   On this request, clear the stored GPA, releasing KVM from its
>   obligation to maintain the NPT entry. Return the previously
>   registered GPA to the guest.
> 
> This mechanism ensures the stability of the APIC backing page mapping,
> which is critical for the correct operation of Secure AVIC.
> 
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/include/uapi/asm/svm.h |  3 ++
>  arch/x86/kvm/svm/sev.c          | 59 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h          |  1 +
>  3 files changed, 63 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index 9c640a521a67..f1ef52e0fab1 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -118,6 +118,9 @@
>  #define SVM_VMGEXIT_AP_CREATE			1
>  #define SVM_VMGEXIT_AP_DESTROY			2
>  #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
> +#define SVM_VMGEXIT_SECURE_AVIC			0x8000001a
> +#define SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE	0
> +#define SVM_VMGEXIT_SAVIC_UNREGISTER_BACKING_PAGE	1
>  #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
>  #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
>  #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7c66aefe428a..3e9cc50f2705 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3399,6 +3399,15 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  		    !kvm_ghcb_rcx_is_valid(svm))
>  			goto vmgexit_err;
>  		break;
> +	case SVM_VMGEXIT_SECURE_AVIC:
> +		if (!sev_savic_active(vcpu->kvm))
> +			goto vmgexit_err;
> +		if (!kvm_ghcb_rax_is_valid(svm))
> +			goto vmgexit_err;
> +		if (svm->vmcb->control.exit_info_1 == SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE)
> +			if (!kvm_ghcb_rbx_is_valid(svm))
> +				goto vmgexit_err;
> +		break;
>  	case SVM_VMGEXIT_MMIO_READ:
>  	case SVM_VMGEXIT_MMIO_WRITE:
>  		if (!kvm_ghcb_sw_scratch_is_valid(svm))
> @@ -4490,6 +4499,53 @@ static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
>  	return false;
>  }
>  
> +static int sev_handle_savic_vmgexit(struct vcpu_svm *svm)
> +{
> +	struct kvm_vcpu *vcpu = NULL;

This gets confusing below, how about calling this target_vcpu. Also, it
shouldn't need initializing, right?

> +	u64 apic_id;
> +
> +	apic_id = kvm_rax_read(&svm->vcpu);
> +
> +	if (apic_id == -1ULL) {
> +		vcpu = &svm->vcpu;
> +	} else {
> +		vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
> +		if (!vcpu)
> +			goto savic_request_invalid;
> +	}
> +
> +	switch (svm->vmcb->control.exit_info_1) {
> +	case SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE:
> +		gpa_t gpa;
> +
> +		gpa = kvm_rbx_read(&svm->vcpu);
> +		if (!PAGE_ALIGNED(gpa))
> +			goto savic_request_invalid;
> +
> +		/*
> +		 * sev_handle_rmp_fault() invocation would result in PSMASH if
> +		 * NPTE size is 2M.
> +		 */

Why you're invoking sev_handle_rmp_fault() would be more appropriate in
the comment.

Thanks,
Tom

> +		sev_handle_rmp_fault(vcpu, gpa, 0);
> +		to_svm(vcpu)->sev_savic_gpa = gpa;
> +		break;
> +	case SVM_VMGEXIT_SAVIC_UNREGISTER_BACKING_PAGE:
> +		kvm_rbx_write(&svm->vcpu, to_svm(vcpu)->sev_savic_gpa);
> +		to_svm(vcpu)->sev_savic_gpa = 0;
> +		break;
> +	default:
> +		goto savic_request_invalid;
> +	}
> +
> +	return 1;
> +
> +savic_request_invalid:
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
> +
> +	return 1;
> +}
> +
>  int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4628,6 +4684,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  			    control->exit_info_1, control->exit_info_2);
>  		ret = -EINVAL;
>  		break;
> +	case SVM_VMGEXIT_SECURE_AVIC:
> +		ret = sev_handle_savic_vmgexit(svm);
> +		break;
>  	case SVM_EXIT_MSR:
>  		if (sev_savic_active(vcpu->kvm) && savic_handle_msr_exit(vcpu))
>  			return 1;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index a3edb6e720cd..8043833a1a8c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -337,6 +337,7 @@ struct vcpu_svm {
>  	bool guest_gif;
>  
>  	bool sev_savic_has_pending_ipi;
> +	gpa_t sev_savic_gpa;
>  };
>  
>  struct svm_cpu_data {

