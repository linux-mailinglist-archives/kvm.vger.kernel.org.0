Return-Path: <kvm+bounces-32960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AAD229E2E68
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 22:50:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EA0AB313C0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8215C205AA9;
	Tue,  3 Dec 2024 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zVGI8bSn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4D810E3
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 21:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733261412; cv=fail; b=HmZAEgK/C4UbNIVjQFNWXQ/uXo2CogV0TQrTB4B0IYR/tHSTaF5/8AX/Kk2ECVcaYtJTijkeWliyuZC/HTM8lJoyQaYvml2MvOe1hJ8/Bi8Olv4yLpSBepVi7gSLr3kPeelc7I4PWhAiOVPsDVM0u5D9Lym2hGO8XNZJvKvNLpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733261412; c=relaxed/simple;
	bh=ugK3Fg2VDGzKmZGZOEPK9C1uFm4yr/41l5lrIS0ccTA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YsojOsYfDRlS4wkqmeVB6xJkbH/DLBLd6b8XAImbUt1YDtQtqTPp0wbTwJHmirmYxNNCwf0nciQT8aIHQYyFp/+AZikBElBJYQf5nDBqE6FWm8rfJD4QOOFHrcftkiIkyt41eDJaXpZsp60rRhgmk7tSoWYTWGY+fs+3osrRjsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zVGI8bSn; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XeaXG5JgT3e1Vt/gayx2ZyZq5rR7frKWPCRByTiM5PRhbmiRS2vJakMlf4RZJ3vOANBHEgHxy2aB+3VUm45EIsZwCwjPUZvhTi5rDa1Ui5VvANEHhuaQ04N/83OtClOWj/Dco+tbvQqlg1cjbBKLKCyoNZ4pi956MzX+4f+O/1dgIR/kiZ7AqrIW6/T0RcafAgLRBFBW8DJzBG3tZu5DHYUtS4FdTbRzU/LOS8reMPXFo/qu+VfiR1NTw1sM1bUR6TejCwoPTBLEsrTNP6H+AGIjUwnBp5Rk5TBHV13W731RwSG9TJI/CQouisf3bm+WJp3S8+2WoowmZkHfxIfAaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wZ0RE+eqnah6Nru5Hm/K/kZ57NaSn+xFEU3ApkvM/E=;
 b=pM94AxZXZX3AphA4VpZ1u88A3oV7bCenJ4eU6M4hdco5W/coA9kbwzUvQbao4D29dU62lWStIH7XGjBNoT+XLMdW0JTVsOFZZYMEwEB+ll0QnwQktXiP93OyhqRs9d7D7npHrmR3exCgeqECeng+pmf+/0D+jjNOkK56d8UriJE1SZBhucMPLtNcwNgmnorB2lxV0gbZtXdCsHRxJQYEicRgU6oADG/Dul1p74tWAety3jxcB+SuYg6Pf8jBYSw5x3dJ3nhpUfDNmIL41Cr7pUSuJPtRaW72nbiRp1zPgJe3Fbd4XTeOgczUDTD3azq7A6w2wu1Wfbtgdx8VSY+RUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wZ0RE+eqnah6Nru5Hm/K/kZ57NaSn+xFEU3ApkvM/E=;
 b=zVGI8bSnDsTGTt+/hCORDpER/YHBsrJkHimN/CrdhN+Mp59iy1/s9quFBUsqquZ+xUWHxxbn45P2vE1GqRI9osIXMyed4mvGChDTQUSeVeNBa5JOZ/nXnDx3cRSE0gQiBWYw2pelHxQGdU6I1MKxEuIo4iwe7Wmb8oA798oS0mk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8344.namprd12.prod.outlook.com (2603:10b6:8:fe::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.19; Tue, 3 Dec 2024 21:30:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 21:30:08 +0000
Message-ID: <544da565-46b9-f5f0-0593-546684f46229@amd.com>
Date: Tue, 3 Dec 2024 15:30:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 10/15] KVM: SVM: Don't "NULL terminate" the list of
 possible passthrough MSRs
Content-Language: en-US
To: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-11-aaronlewis@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241127201929.4005605-11-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dd4eda9-4b99-4056-9afb-08dd13e1a92c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c01UTTVUTDVaTVRiVUd5S1R6bVpieTBxT3FONEFldnB1SUk5K2loN0c4N3Rk?=
 =?utf-8?B?MDlKYlN6dE9pc2NwVEtxY1RST0l5NzFZNzRHNW1qRHI1cElKZldKVVB3UDJj?=
 =?utf-8?B?Z1daZWs0N1g5cVprRzhjWEdEVXZoZW5TK2NRdEJxZXVjbGttR2dTTklWejVB?=
 =?utf-8?B?RkUrM2JRWEkvTFRzOUdkL052am56TDRreXNtVzVpMGN4NTNsV09EbGtoQ1FR?=
 =?utf-8?B?RWV3VmlCZUd3aFRISkx5OUNtYWJTTXVTblNCNVdIYTQ3YS9pQXdNTHg3cTZ1?=
 =?utf-8?B?Tmx0RHhHV0Zrb1o5TEJ0MVBqWmhIc2xKcGhUaElBVVk1RWZVaVpoNnA3SWVE?=
 =?utf-8?B?cmk0SDgyOWdjQnRCajZ1UVJZcU9vVHk0QkpmdU15ZlNRejZCUTZiRWRSTkdS?=
 =?utf-8?B?UFMvWmJJNmtKZGRqU2JJQnUwUkNxVTN4RTQ2bkRIckdicjl6NlhISDByUEZL?=
 =?utf-8?B?Q1RHSytsTWJOTUVObWFGek9ZT2Z2NGVhS2NwS3Vqc2RmaTFtZlF5ZjNDWUJr?=
 =?utf-8?B?ME5nSUl6MnduZzRDcm4xdlh2SEFOZmRKTXAxdDcxcEhBN1NnM1dBOEdhNWph?=
 =?utf-8?B?OS9Fcnd1ZmtrWmFmL1ZRa2h6QkdaQ2h4a1lUYzJ2SHhYbzZPS2VJUlZuNzhK?=
 =?utf-8?B?ZEtHVFJBTUFhTjRuY2NVdlcrL1Q4SjNLZlNacWpMUCtTazhRZ0RIRHVaNm5j?=
 =?utf-8?B?bGlSTWMrUXFubWpFM0Z0QXdtenhiMFJKU3JTSmpreWJaVU1MUy9zL3Mwcmox?=
 =?utf-8?B?OUt5aHBLU0VXS2FERm1kR0txV1I0WTVBNWZPRjVXTHVkNkx1cjI3SHBQYnF4?=
 =?utf-8?B?MWxqNGY2ZTVzUzR3YnFuYTBOVjRVRU5pRjNJNU5UV0tRSXJjQVlqOHhYeS9l?=
 =?utf-8?B?YzhvN2dGZ04zVmlsdStSaktxR1Y4OFd3MWUyU2Ryc2NkVk50M3pOd0dIWVhI?=
 =?utf-8?B?OFNaOEN6aHAwU0NseVF3cGEySE1CallsNk5pempuMlorQkZqdDNsaDI4Wm82?=
 =?utf-8?B?OFcwMDBUY1NFZXlGbFhuYlUyUXBoUXNsdFJxVVlHUEVNck02WStieHJrbEZK?=
 =?utf-8?B?cXMwaldFRDJaV1Jxb1pMLzVuVzlaZ1RqemI3clhxUXVyYUovbEsyRm43cmtE?=
 =?utf-8?B?NGJLY3ozeFhrdFYyUGhPbkVaQmJ3bmxZSTZMbHJQNlpNcEh0KzdHSWNMQnZt?=
 =?utf-8?B?YUM1cXVRUVBpK3I2KzVuZzdmaUJMaDdCTjB2UDhhTEw3TU1xSVhoMm55YUM3?=
 =?utf-8?B?U250YnZzRHpMTHBNNWVMajBTazNyQllnQlVjaTgzRExaYU91TzZuMFNkU0JI?=
 =?utf-8?B?QXl1SXMyOVF4UlZnK00zTklhM09nRGsxTXovZndsdDJZQThqM2c2ZCtzbWJh?=
 =?utf-8?B?b3c1bGZSbHhad2xKUjFuek0yOGFML2FkcjNKelNJWDFtNFJDTTU0Mnd4SFVI?=
 =?utf-8?B?TE5WcE0wcGd6NWVPREdVT2habDdBRllVeUx2QmlLbHZqOFFZTnI1WHVkbUVm?=
 =?utf-8?B?NWJvbm1wbmh5OWhhRkNITVQ4QVRLamZSQWtVVDhvSUpua1NrSWJPV2NmRkFs?=
 =?utf-8?B?ekNkaEFudWh3dUV0WjBlMlMybVNMb09ZdkRWZUdXOUFXOE5mUHJPbmJoK294?=
 =?utf-8?B?ZzNnTlNEbGl5ZlBSMHkySTJDNm12V0ovbG9TY09UUHVrbmNQVExhZnRZY2lN?=
 =?utf-8?B?UUY3cG9OczZ5V2xNWkt4anRiYU9NNUY0UUk3MkpNYnllUVZUQjlteWxYeGs1?=
 =?utf-8?B?NjI0bzlGMmZXMitGOFZmODh6RVY1WVFLU3RhencxRDczTks4K1FFbEhCelZC?=
 =?utf-8?B?U0NyMnJhZjBpNmcxeGN5dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekUyWUFOUkZoZVdKc3BuMnpRbkRsMkFOeWFzZHFOekp2VktmdHBoZWVzV1M2?=
 =?utf-8?B?ZWxMYUp5MUZnblU4WmE5bVBoZlNUTEgwTDVvcWlNRzFhaHBBTnhwZDRJYVhK?=
 =?utf-8?B?M2t5Z056S2tsSENpeXRJNmRpcFI3RFhmU3FYMm0xZlRUcEpCdk5SaEFGUjZm?=
 =?utf-8?B?emxYclpIUHNOcEx5N1ZlSUtDWHVZZnJFc1lkNGJtQmRkMjdOYUhEWklUZUNP?=
 =?utf-8?B?bDhlMU5ySkRnd1o4ZzhWMmxaajlOQnFmeHhHRXd5N1laL2hoTU0zdS9odnBS?=
 =?utf-8?B?anlsT2p4K3JiaEx3bXBQdC81L3RpUzFVZy92Z2Fpck85YU5pVk03eVRtY204?=
 =?utf-8?B?U0svbENhMUxNUkRvazNGM25KTWJ6RzNUMlBvTFNYWDZwdWtMajBkRzRjOGd2?=
 =?utf-8?B?MWI3bWlLY2EydG9iTTZxSWFmeFhkeGdCSysvT2RNQ2VMN3ozY3RLQ1FBWm50?=
 =?utf-8?B?ek14RnRvSXBLRjJRSlBQa3VWYkRXQ2lmY2RuWlhuNk9aUlo4a01PV3B1aFRH?=
 =?utf-8?B?ZG1aWjdScWF0UUFsRkZWMTFxU29jdXQvK2wyb1h5dWs2bmFpMk4xM0xXOEdr?=
 =?utf-8?B?TWZCTG9vMHRZa0lpT1ROVGZTWFZRRWpDUnFHL2lJdkl0TkhIZHd2a05kLzQw?=
 =?utf-8?B?VDk3Y0VOL0RUQUV3RUdGNE1JcTAxNnBLeW5GdTZSYkVDSmd2UW00cVBLZ2xR?=
 =?utf-8?B?RkpKK01iWkRZYnZ4azFmdDJlOFd0WUlNUlpUYlo1T0loSE5BTVJPczRKNXFH?=
 =?utf-8?B?OGo3dzFGcnB2N0ZDUThqT0VDeE9SNzJHWGdnZWd6aENYS081OGhNVi9IZFIr?=
 =?utf-8?B?eTJmeFMwOHhFQ0pSTVlFQkpZWHJVRnZXcVltakEyOTdtdXFPRmlPNS9OQWZM?=
 =?utf-8?B?OU9DM2NVeS9PM2RGM01Obm9VT0NEbkFGRUl3bno0V0JmeE9GTzRiUE1raXFM?=
 =?utf-8?B?UXUzUTBhaHVZQkM2RWRkbmdMeWl6eEY4TmRNV3J1aXcyc1IzUWVkalNlRmcz?=
 =?utf-8?B?Z1pqbmxJTTJ4eThhelNuOG9Nb29EOGpEc04yTGpXQlhzTERERXVEbU9UTkdj?=
 =?utf-8?B?Wld3bVgxS2dUS1VKZERPTVhBNUVFZTBYbUtNKzVlcTRUY0VYWGx1STVJQWIw?=
 =?utf-8?B?UTY2aDQrRnFvOUJSUFUwYW0yaXlvU2wwRTVDczVDVG0wZkFPN3ZteWc5UnI5?=
 =?utf-8?B?U3oyWUlTdjZsdDRZcGFSdWRYV0pmL0NVMGd3cWU0cFM0TExYNDROVEhFS2dm?=
 =?utf-8?B?cWdhU3FuQ1ZoUHU0NFRteWk2aTBVSkJPSW56MEFXR2U0eXVqM1lnY3daR0Iw?=
 =?utf-8?B?ZWpWU2ZMR2w3Y2t6R1JhR2pvLzZtdXZzUTFrUmJoV0tERjdHdHM5OGRLRWdM?=
 =?utf-8?B?a2N1czRNU1lGUkxPTjF2cnVjQ1hjYlV5K21sZTVqNCtzbHAzU2FTMThSNGdy?=
 =?utf-8?B?bjNqUkNPdEF1QUxBRXYzNFRmUS9RUHdobXhubTlmampkMmdQaVRsNG1pc0tL?=
 =?utf-8?B?Q2FROG5LblBNeFRCTTRwb3hUY25NUGFaQmFpaVNVV2xYeEorTWlpd1l1QUlM?=
 =?utf-8?B?NndIdnV4ZWZRK25QZmV0RTMxV3piZG1ZTmhlbW4xZzRIaVMyOVJvYkFPK29o?=
 =?utf-8?B?Ym5sdVN0dkxNdVdSU01lN3Jra1NGVVdUaE95R0JwOFdMY2dWQzVYYVkzYUU2?=
 =?utf-8?B?a3Fxb0JsS1laVVRwMWR2SStCbHg4TWptUFZsa1VJOEFlRXhNcFU4eHp4bzA3?=
 =?utf-8?B?aDVZelh1ZXhLenozU2JDa3RyV2Vpc2FDazEwUTN2eUpYcDRIWXh2ZmE5bnA3?=
 =?utf-8?B?YTlCN2VEM2g4aThmdjVQSzJYUFRBU1hXZDZvQnJ5V3lRRFk1S091d2xMMXRS?=
 =?utf-8?B?dHlpQWJSMDFlWldxZGVvcy9aV2Y3ZjJTNkJEeVNrRnZxKzhCVUI3NWRkZGhp?=
 =?utf-8?B?cHRFWXc2bXlkSFNQOFN4a3k3Q3Q3WCtXa1YvTGVGenZ5NllCVzFVd0dERDlh?=
 =?utf-8?B?eDZvRzRDU1hhb0w3ZmJPNlNWNWppMXNvWCtTQ3ZtOWdUM2lUYnNmZTQ1MHI4?=
 =?utf-8?B?K09OQTZNRmJqNUZrR3d1ZE1wSXR6alRxWXNFbzNKd0kyQjZrNDBzWXR2T3RN?=
 =?utf-8?Q?BVojUNqYI79eid9tJLbZnKR75?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd4eda9-4b99-4056-9afb-08dd13e1a92c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 21:30:08.4699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQBNof4yMS1x/+fpDT38dXoRB3YappCsJCGLwbusjqYrUyNdBb7vlXvgzOF1w7Ah2Kt6GoQhLdAPqpLMe69yVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8344

On 11/27/24 14:19, Aaron Lewis wrote:
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3813258497e49..4e30efe90c541 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -81,7 +81,7 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  
>  #define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
>  
> -static const u32 direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
> +static const u32 direct_access_msrs[] = {
>  	MSR_STAR,
>  	MSR_IA32_SYSENTER_CS,
>  	MSR_IA32_SYSENTER_EIP,
> @@ -139,7 +139,6 @@ static const u32 direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
>  	X2APIC_MSR(APIC_TMICT),
>  	X2APIC_MSR(APIC_TMCCT),
>  	X2APIC_MSR(APIC_TDCR),
> -	MSR_INVALID,

Given my comment on the previous patch and then this patch, can't the
MSR_INVALID addition just be removed all together?

Thanks,
Tom

>  };
>  
>  /*
> @@ -760,7 +759,7 @@ static int direct_access_msr_slot(u32 msr)
>  {
>  	u32 i;
>  
> -	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
> +	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
>  		if (direct_access_msrs[i] == msr)
>  			return i;
>  	}
> @@ -934,7 +933,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
>  	if (!x2avic_enabled)
>  		return;
>  
> -	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
> +	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
>  		int index = direct_access_msrs[i];
>  
>  		if ((index < APIC_BASE_MSR) ||
> @@ -965,7 +964,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
>  	 * refreshed since KVM is going to intercept them regardless of what
>  	 * userspace wants.
>  	 */
> -	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
> +	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
>  		u32 msr = direct_access_msrs[i];
>  
>  		if (!test_bit(i, svm->shadow_msr_intercept.read))
> @@ -1009,7 +1008,7 @@ static void init_msrpm_offsets(void)
>  
>  	memset(msrpm_offsets, 0xff, sizeof(msrpm_offsets));
>  
> -	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
> +	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
>  		u32 offset;
>  
>  		offset = svm_msrpm_offset(direct_access_msrs[i]);

