Return-Path: <kvm+bounces-52044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6780BB005EC
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 17:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4258F5445C6
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 15:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64ABB274648;
	Thu, 10 Jul 2025 15:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xENOs94u"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9DC72636
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752159863; cv=fail; b=PYclQl3udYylflAVvVhRdCYoHgPOiuI3Q//v9l9LthceHsjys3aBfsRNqBwOa8rW1MnRZH8yzVUKo/DZbxeVYYSAo2v/irxV2tRLq/tHE+uMyzsYibd+so3oSQIdik4vHdbNnorLujO/hD4rZMTQq4yLi+rEz6FgOUGA8dAYFJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752159863; c=relaxed/simple;
	bh=uGjDAGxki+L6/9hch0wl8It3JF2/VuVkg26BiShKHWk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ks1tdO/vZdK+SS9G9q/scAXjthf/ndd9eQ8rOYnWiVkBBfCpl3JXoMQCwrLfGkOlHrGIACHhMD5hU0GElqcpP4EPNDOs/ihDO6GFiheWiskgN6VcCFXBkSedJNMcU+KJI1qWGQ4nKcgqYlMNftNlkxk92SJlar18mf5nd7c2Hd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xENOs94u; arc=fail smtp.client-ip=40.107.237.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ezI2WcQ/h7I+qGPm2n9cn24I2BeIck0qecxNF5uSuU94B1P+nqjqUHY4DT7zqCrqqFUP3vogiZyiNFss62LzR8gBGB0h6rGyMuzVfuxhtmghMf22qIg6ByccwX1WpKSEsYWB3gyEt7Ha8A+7y4AfhZ+68AP4kVuWiCJgMilFySFS8XPcAVrrVe1SZ3I5a9FpIzhN/4q4hhKhRU6PpNHTlGZBZ2tsdN4FXTKlkU+dhY3hrqeVu1Q0Q6WL4w+I1iHJ9TuDUKywrJgTsipem4K9Wu2f+5XE2nsGAU8ZlYHhEhO7PaTTnQ7G2pVRhPJdJeshyNtPOAb2Q7nFOC0rDFGmUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4e2UNifhDME3rCtNw/pcSJCx74CYopVKJ+V+Pqg+oXA=;
 b=Dyp25ua/g1fnSC48uHAkxf+pms/8ynMTe4d/OC1Loo1WdA36E7fk/BD0rymaj1l6M9+Ma/plOh5+oQuLqa8zSP1xlklksJg7ZnlPKDMYhTXc4oxLb2ZlLbaBRhhKQG7yeYIpc4IuJ9F1sc3Gy8S4Bq9V2WKMEl7P592kKeoS88Mm05NYcqBucgHi+OzOGfDZoi6a3YxJFV6aRNSz7EXYBrgUyw2K4sr6Gj4ZL13d6uHF3p5vKTPcHavivRyzSvKzCi2RZd7DS/eUaJaKoHinZDXl4uhd4OlK13LYNCvoLyk0gNIlhOzbib/xnvrQDonD/WKXhexhh++y1B5NnHcWGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4e2UNifhDME3rCtNw/pcSJCx74CYopVKJ+V+Pqg+oXA=;
 b=xENOs94ualYX2RbwQ0qlr1fk2x0l8NGm4WXedqUIS7ryW6Jew93ROI86k0HWh3VHv3U9D3Qqwneb/x8KT/Dvf8URcXPifWVaqdNk1Xgh1bvVAa4VH4p3ryWq1ZU205UofeQa+pg4Zl4DMevsdtM0slQvGPhS/2lZqAHhLm/oFo8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by SJ0PR12MB5661.namprd12.prod.outlook.com (2603:10b6:a03:422::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Thu, 10 Jul
 2025 15:04:16 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%6]) with mapi id 15.20.8901.021; Thu, 10 Jul 2025
 15:04:15 +0000
Message-ID: <99ca91cd-4363-42b8-bcac-5710684c6d92@amd.com>
Date: Thu, 10 Jul 2025 20:34:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
To: Sean Christopherson <seanjc@google.com>
Cc: bp@alien8.de, pbonzini@redhat.com, kvm@vger.kernel.org,
 thomas.lendacky@amd.com, santosh.shukla@amd.com, isaku.yamahata@intel.com,
 vaishali.thakkar@suse.com, kai.huang@intel.com
References: <20250707101029.927906-1-nikunj@amd.com>
 <20250707101029.927906-3-nikunj@amd.com> <aG0tFvoEXzUqRjnC@google.com>
 <63f08c9e-b228-4282-bd08-454ccdf53ecf@amd.com> <aG5oTKtWWqhwoFlI@google.com>
 <85h5zkuxa2.fsf@amd.com> <aG--DjX1r4RK3lFC@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aG--DjX1r4RK3lFC@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ac::10) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|SJ0PR12MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: fd81f56e-71a4-4a19-0e77-08ddbfc3097f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TSttMjk2WEppZStRczljNWNickdUd29paDFiUXBmcU1uenRLRzRoRmxtaVZy?=
 =?utf-8?B?djdKQ2c2S1AzWnByMUFvb1RXZzFRU09WU2xpSnBveUFKdGk4Qk5jWmtwRlkx?=
 =?utf-8?B?K0tRTE94aUljY2tzZVg5czVFZnhKZ1BEKzRVMFJkNStrTXpMczFOZm1WM1pi?=
 =?utf-8?B?SkdtVGw2ZnZ2VFZvcGdGeDFZRUVYSWNKdGNrZGIyTW11RjZzNDc3TjcxNnhT?=
 =?utf-8?B?MHpIUk8zbU1qZlFJbHJETDJLM1R2VWVzb25ha0ZNT1hvTWp1U0FnUUlhOVRu?=
 =?utf-8?B?Zk1sSXJUN0NQUlNJMktEVUVpZUFzd1pUOUhrUStHdTREdkx5UThITHIybXVI?=
 =?utf-8?B?VjBoT2hwQ3gwaXhYaTdESTcwM3MwRzN1OHRzSXlZandLSEo3RFhkNGVrY2w1?=
 =?utf-8?B?Z3ZRWmllYWlGaFY3R0lHMDlralZOK2JBTGNuVGJlUS80dlpvS1JFMWFtbkVj?=
 =?utf-8?B?SmRYUS9MaWlFdGwySmlCa3Y2eVZ4OFR4SkRlaEFMS1c1bnl4elhGNlJ0c3kx?=
 =?utf-8?B?amJTSHpvN1JYMXV6SUVOWHAxTENpRFR0cTAzWStuUXAxb1gyZEV0YStZUUQ0?=
 =?utf-8?B?eEQvVXlHZW1IbU5EMHVUanJKbXRpNkYvazNvY0JsL3U1YVN3QnlTVGtreHNs?=
 =?utf-8?B?WjNlWU94MXFpSlQwQUtPMlRySVVmMmpMMmtpSmQwbmR1WEVZUGZoRG1aUDBO?=
 =?utf-8?B?OFM3MG9VUzg0MUFHcHB3M1liWll4dm8zZU11TFAwOHpBcC9HMm0zemZrbkZ1?=
 =?utf-8?B?TXBzNGs0VVhWMFpsbkNEM1g3amlxSy81MFFNeEZvRWdXWEttdWx6K0pNZWkx?=
 =?utf-8?B?eERVeTFzaUVER3FDbnpJRDhxRXZ6SVc3VWhWM0VDT3NUT3hZeUxMa0tRS3BR?=
 =?utf-8?B?VmFNa0JyRmJGYlRwbUpSYmlVbXJPa0pBNVR0Q1lPRW1aY1hLUU9aanZqdm04?=
 =?utf-8?B?UlUxM1BvUFNMYmw2NWFhNXVMeUlnZTRvd1I1Vk5IOEoyTmtlRGVlVEU2NEdH?=
 =?utf-8?B?bTFFREM2aWVvRWE0QUY1b0lLZTFpTGpDdlkyRXZrUFFaaHNUcmdDN2RWYTBw?=
 =?utf-8?B?YzJQRDcvL0tqZFVFalB6RFVkMTdUdUswc1RqYVhtY2l6SHVGUEV3U1gvR2FG?=
 =?utf-8?B?amo4MUZ5NlpZZTF3bnhIRFVRNVB0M3pORXVJMlJzN2dhWHlxVmF5cmZoMkFS?=
 =?utf-8?B?Vk9nM2xKSGtjb0txTk1kZ1JUN3J1eFlYZjBwQ3RyN0taOWQ2ZStDTlpGU3Fn?=
 =?utf-8?B?dmVOK1Y1ek10SG5yRFdXMVpiTkNCOXdCaVRWMFdyK01QbXI4em5tbHJjR3l1?=
 =?utf-8?B?VkI4Yi9uVkZULyt0YTNXV0puRVRIVjJtdWNkdm9UWFpDeHhNR2h3dGpCZlU5?=
 =?utf-8?B?WFU1c0plcCtTMG5QZzJLcUxKZlRRMWNZdCsvMXhJRytzM0kzZ25pVWViT2Z1?=
 =?utf-8?B?QmdEemJ2MXdNNXNUV3MzNmd0UFo0YjE0R1Zid2FaM0MzNUQ5bmQvN2JkbFA4?=
 =?utf-8?B?NmlBemJFS2dHZnlOTmdhakdKYW93dkJOaXR0bmhxZy9RTkRIUVhWOThJRUhh?=
 =?utf-8?B?dXhZZmphUnk0ZUNPSkV0bGZhUmpkdzhSWG9lZDg1TlBTTm1BTEtEZUhHUjZB?=
 =?utf-8?B?YmdORFdIRVB2UmM4MVlRdVpDQUI4Vlg0MzY5empWZEtmd2FXRnhScCtjbHhh?=
 =?utf-8?B?LytEQUE5Wk4vZXQ3b1ZxN1NmU2VvZHdUWkJQYWl4MEJzdWdIYXVRTGJLaVdM?=
 =?utf-8?B?YnM3Tm5ic2MvSTh3OXcxcUJyUmxacFFsTDlZbVI4Z01JOUNXUDlFMW5QOTZS?=
 =?utf-8?B?dHl4SStlM2c3TEV2VjdzRUtzU0o3VGozVGYyd1lWL0pteUp0Q0Nod2piRDNR?=
 =?utf-8?B?M1JqeEhSYktycTljTnNTMm1ITW5JZ2N4TjVPemRWUWFKS3lUWXRlTHhNRXlz?=
 =?utf-8?Q?Rv43X3fxwd0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VjZKZmFrYjZsaHRXMUtZNm1UcG5PclVyeXVWVzVGcExnZDN4M2RZK0NPaDgv?=
 =?utf-8?B?a2c4TlFacXJ0aEp3dTFzaVJxVlRsQ2pMYW9tUG9iTXVTOFFLTlV0ZVo0Qmwv?=
 =?utf-8?B?NFZWbE51VE8yRGV2RWcrZ2l4b0pkQkVpSUZjM3FOU1ZXK3paVFZaWVhaYU56?=
 =?utf-8?B?cmR4YkgrMWw2bW1hL1pJeFVjZW9RdndObXI1M2ZyOFJxRXhwM3JtTFpCL1My?=
 =?utf-8?B?SW5xMnBjcHk1cG1OWGdvZ0h3SU0wc2JKNGVqLzBFQVNraHZyZGFYaFp5ZWpx?=
 =?utf-8?B?SnNlSDd5cmRBcVF6T1dGcmNqTVBFQTZnTk5yWnI5emdJL2JCMVVsNEw5aWp4?=
 =?utf-8?B?K1JiQStsM203RVVFMUlHTFJNZDllS0o1ZldhWnlqSUtZOVIxSFZnRFdSOGx3?=
 =?utf-8?B?RkR5OEs3Z2FrVWY3bllmaFJZMFZsdlF4UjBmb2hTMVNwQS9KZEJUZ0FNN2pH?=
 =?utf-8?B?RVpQMWpCc3NsWkJIMXhIRm5kT1ZNdVpET3JJamFobEhOTVNOV0JncjFvblI3?=
 =?utf-8?B?NW9xb0xESERsWS9hL1AvTHQ1aTJOclNva00zSGNiZEVCMUExNlFyS3VnVW5B?=
 =?utf-8?B?ZnlBUW5XMytIZUhkbmMrYnFtbXp0eXBJT2l6cFRzZUIwZ3VXMkpyT1JOdEhm?=
 =?utf-8?B?U1pZOUdwU0lQcW10V3JiMFZaMGlVNC9xcVIzSkRmOEdxT294bEVTdkl4STNO?=
 =?utf-8?B?RXJSZ3NUUXMzZks2cGl6S2t1V2Zkc0xEdU1aOGZlWmt3SDVOM3NrcE8zais1?=
 =?utf-8?B?dHoyalV5M1RlMjVvRWtqVUpjWHRnWTJjNW4yUVlTNk1uMk42ZTJiSnNoT2Ux?=
 =?utf-8?B?eWdjOVYzcmZMMmQ0MGNtbWZFLytkaUt0V3hUcWRhM0ZtSGNpMWNzVGtOYWlQ?=
 =?utf-8?B?bXRVK2Rac1RqQjczamJmd3dDMzA3N2tSMG9UdHB3K1FrenhHc2I5SUs4cXFt?=
 =?utf-8?B?RVBBTWFlanh1WjkxdWhERzRGRTN5K05pL1hlNUZTcmE4Qjd5bktKcTZHNzZk?=
 =?utf-8?B?bncxbU03VHZaWTQrU00wblc1bHBTcmV5NWFLYlB3TElQT2JTYU5YanVzYVVt?=
 =?utf-8?B?QnorWjI5Mms1RHZTNVc5RnhPaXR5Q05sRDlLbFgwZjdOak5vYklwTGtza2NQ?=
 =?utf-8?B?QjNZV0dwWXYvai80dHEydXhxUE9qTmhCZTh5WGpnUnNsRlF2ZFgvMDZmOXJ2?=
 =?utf-8?B?OWdOQjhZUmlaUkcyOEpybThPbFhTVHdhVEhES3VrbnVpbUhjT2s4TWQ3UlNW?=
 =?utf-8?B?aWc2d1hXZDFwSlZiVnJlMkJMSEs3dGpNWmlWekkyZGtDMThQME1zZ3N4ZE1z?=
 =?utf-8?B?ekw4QlFSYmJWWE4wdlhBQ1A0RnhXenpwa2U2OGZmWlRBZTU1aUhWeHF2SXVH?=
 =?utf-8?B?dGRKTzR1SG11aERuVUg5SDl6SjRjUUttK0Z4OHRRMTBEdjBtRndMS3JVTVBu?=
 =?utf-8?B?OE1SQ1M2SGlaUysxNkNzdU5VRmVYVzFjT2o5U3lCbElCYVNHQkNqdzdhNlI3?=
 =?utf-8?B?dHB3WERlWjA4WWhMWmlFcUdYeDJMaFFlTVVXcmQ0RnozdWM0MXZYK25CSHIr?=
 =?utf-8?B?MVROZ2RHa1BEd1hGWFMvUElLbm5WQUl5STN1c1dicHI5Zlc4SGVIVlVmczM4?=
 =?utf-8?B?TzJrbm9wRnZnYXlYVExBUU41NWlNaXhkbEkzN25xeG5aTDl4OEU3bGtpQXU2?=
 =?utf-8?B?YUp6amEzYUZzanRid0JSZU5oL1dNekFud0ZtVXdEand3ODNLc0R4WjQvRFhT?=
 =?utf-8?B?UHVUeUJnSURFZWhPWjU3bGxNRXRUaWJJL1JXZVlWTnNhcmhVQ0s4L0ljclFs?=
 =?utf-8?B?SnF6djZXZUpiemc4aUVBbFpDTzNhRGVLNDZCSWs0dkcybWc5QVhCaUxGS09D?=
 =?utf-8?B?c0doOHZhVXR1UWFybjVEd3B0ZHNpSzJVRkRRMkRhS0J3ejR2bHN6RzN6a2Rr?=
 =?utf-8?B?Q21JekcyS2loMllyWkQ5ZmlLenhQa0kvOGJzMkYrckxLVXpJSXhFamd6Mktj?=
 =?utf-8?B?dUhQVWZmdzgrcS9xN0twWTlKV2daTVdUWW1PVUpud2VYTThXb3VxYnpnTi9t?=
 =?utf-8?B?eE1NMFdaSktLZlVGcUVZUkl0dkFmK01HL2xoVVV6Z0krTE5GS09KZUxqcE9l?=
 =?utf-8?Q?mx9GmVzpsTXgoLkReMdMCBoC5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd81f56e-71a4-4a19-0e77-08ddbfc3097f
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 15:04:15.7544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /swuFoU1BvpBVkNCY0/Rpy+CNZrIHKGXaSO1AZ9iQnJpV/XxeeLIu4j96YFIrWEZqsa+BzYw5z//JqJUgSPnZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5661



On 7/10/2025 6:50 PM, Sean Christopherson wrote:
> On Thu, Jul 10, 2025, Nikunj A Dadhania wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>> Because there's zero point in not intercepting writes, and KVM shouldn't do
>>> things for no reason as doing so tends to confuse readers.  E.g. I reacted to
>>> this because I didn't read the changelog first, and was surprised that the guest
>>> could adjust its TSC frequency (which it obviously can't, but that's what the
>>> code implies to me).
>>>
>>
>> Agree to your point that MSR read-only and having a MSR_TYPE_RW
>> creates a special case. I can change this to MSR_TYPE_R. The only thing
>> which looks inefficient to me is the path to generate the #GP when the
>> MSR interception is enabled.
>>
>> AFAIU, the GUEST_TSC_FREQ write handling for SEV-SNP guest:
>>
>> sev_handle_vmgexit()
>> -> msr_interception()
>>   -> kvm_set_msr_common()
>>      -> kvm_emulate_wrmsr()
>>         -> kvm_set_msr_with_filter()
>>         -> svm_complete_emulated_msr() will inject the #GP
>>
>> With MSR interception disabled: vCPU will directly generate #GP
> 
> Yes, but no well-behaved guest will ever write the MSR, and if a guest does
> manage to generate a WRMSR, the guest is beyond hosed if it affects performance.
> 
>>>>    The guest vCPU handles it appropriately when interception is disabled.
>>>>
>>>> 2) Guest does not expect GUEST_TSC_FREQ MSR to be intercepted(read or write), guest 
>>>>    will terminate if GUEST_TSC_FREQ MSR is intercepted by the hypervisor:
>>>
>>> But it's read-only, the guest shouldn't be writing.  If the vCPU handles #GPs
>>> appropriately, then it should have no problem handling #VCs on bad writes.
>>>
>>>> 38cc6495cdec x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests
>>>
>>> That's a guest bug, it shouldn't be complaining about the host
>>> intercepting writes.
>>
>> The code was written with a perspective that host should not be
>> intercepting GUEST_TSC_FREQ, as it is a guest-only MSR.
> 
> It's fine to panic on a _read_, I'm saying the guest shouldn't panic on a write,
> because the guest shouldn't be writing in the first place.

Agree, and the with the below change the write to GUEST_TSC_FREQ will be ignored.

Should I send a patch with your authorship/signed-off-by ?

> diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
> index 0989d98da130..353647339a79 100644
> --- a/arch/x86/coco/sev/vc-handle.c
> +++ b/arch/x86/coco/sev/vc-handle.c
> @@ -369,24 +369,21 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
>         u64 tsc;
>  
>         /*
> -        * GUEST_TSC_FREQ should not be intercepted when Secure TSC is enabled.
> -        * Terminate the SNP guest when the interception is enabled.
> +        * Writing to MSR_IA32_TSC can cause subsequent reads of the TSC to
> +        * return undefined values, and GUEST_TSC_FREQ is read-only.  Ignore
> +        * all writes, but WARN to log the kernel bug.
> +        */
> +       if (WARN_ON_ONCE(write))
> +               return ES_OK;
> +
> +       /*
> +        * GUEST_TSC_FREQ should be not be intercepted when Secure TSC is
> +        * enabled. Terminate the SNP guest when the interception is enabled.
>          */
>         if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
>                 return ES_VMM_ERROR;
>  
> -       /*
> -        * Writes: Writing to MSR_IA32_TSC can cause subsequent reads of the TSC
> -        *         to return undefined values, so ignore all writes.
> -        *
> -        * Reads: Reads of MSR_IA32_TSC should return the current TSC value, use
> -        *        the value returned by rdtsc_ordered().
> -        */
> -       if (write) {
> -               WARN_ONCE(1, "TSC MSR writes are verboten!\n");
> -               return ES_OK;
> -       }
> -
> +       /* Reads of MSR_IA32_TSC should return the current TSC value. */
>         tsc = rdtsc_ordered();
>         regs->ax = lower_32_bits(tsc);
>         regs->dx = upper_32_bits(tsc);

Regards,
Nikunj

