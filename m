Return-Path: <kvm+bounces-34708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2365EA04A73
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 20:47:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 939DD188690E
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F35A11F63D4;
	Tue,  7 Jan 2025 19:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5SsdiVqY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EED2C187;
	Tue,  7 Jan 2025 19:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736279221; cv=fail; b=i4wlEf/Bk5BckRlJM6IUPIStO5UMM2SuD/pS+6ylSJA2x9puL7EezhfMf5GrphNO2vnRj2iKnEYXyqr8nGc63ZeyvYq3oIeOMWnHgSNeTjyH6UVwYLoTSCYgMj0W3kj713IJSf6n+lenWXzteEtwF4efxzGzheGi//dlfZMd09I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736279221; c=relaxed/simple;
	bh=ypK9Yn0hRVXVDS5r8GTrA2LpeoTCEud40X95HBHgXHw=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=aRguohSXrIAVtfK7D2QvUxEThJ0vntwO9yZGIg01BKSdnOpfjrS6M8yLkngi6kccLPINff2se8mRtpI/M2Z2NwN+yr1cg+8TEc8iTkzBkiIkE20MAHjwQMratEflqFwTbx7tIepqJbo31n5r62brEn4Dq4Wqn14UG8+IQTu3S7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5SsdiVqY; arc=fail smtp.client-ip=40.107.94.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZMto6YIaRxC8+vckdAxHMunzAmrMPJgBl06o0g1dHiL3poyxQpFgnGEJcyYBGkD0X3sOhR7k4xlwFnjLKTkwsqq1UBHIcGveUb2EdbAzcVp/Ltc87rFQ9r+KTbFyz1gJu8kBgud5YzFcyI5syi+z7N3FSAtysx9r37/TKg3d+xbW36DsoTvvmFRRcubSRaEd3iP8Kfo0A1+xjDVdJkIPoCLrd/QtZwyNmRsr0G1/WbVS06WDr8A5fNMqkPsoxy53kcPRoxrWlBlAPVlYQF8R/dQU+wEH2LmWJxbywN/4Q8DqHYPBxHtFpLEhkP/gDg1hOFe3kBdB2hnjharC8NOwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYbFLZj3aMW5HCFHnIfvkiAZfCElM/cBb1gizTx2sfQ=;
 b=Hc2JjGuw43B4hqJC0057uhTNpnBW7SCz1InFf6t6GsWm1EcVHMtDDT0CbQw25MpoY6nTqG6B0ToMXi70Y+24tZcoviYXc60w8XjLxTzxk7UO/GhYa/lEPUycEI+RV51kkmJA/sUPkuywFJb6MUqvwXZKVa18qRigNv+u9hbwqjyL+bnNI0jJ/mulTeXHjVyTDf7RD/M4vpPz/5oM7Nkg20koxM2q8S+N5flfp5ygZpn7YuNxwKa4puviOlT05B/FWEz4tXiHagVzQK36S5ZbgO4keq8+Z5dsbY14L4qAq1WnvnNf39++CzX8JW1zadgZEWnHzyySBJhO0mxf7VlCQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYbFLZj3aMW5HCFHnIfvkiAZfCElM/cBb1gizTx2sfQ=;
 b=5SsdiVqY+kK6gko7nLcR9B43n31oNcEmaZhweHlCDL0pihvAyVg+JHUR43FnUsfBneWanQBgAPMfUKYUDbpxD9bZI40dI8nz3yShMLldGEKn+td/xA/v5TDOUcEE8SGSpIeAJpxrlz24SWzwZ6fgR0kmW2Rd+6yjyHVWDJFtoFo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB6840.namprd12.prod.outlook.com (2603:10b6:806:264::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 19:46:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 19:46:51 +0000
Message-ID: <de503473-e0a8-bf65-39d2-2b6bd9fa638c@amd.com>
Date: Tue, 7 Jan 2025 13:46:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org
Cc: kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
In-Reply-To: <20250106124633.1418972-6-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0012.namprd18.prod.outlook.com
 (2603:10b6:806:f3::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB6840:EE_
X-MS-Office365-Filtering-Correlation-Id: 21019a70-810f-4286-24cd-08dd2f540805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXloYlNvRzlmRnptMFdWTHJVMWZ2RUovMFRzWEhIZDR0eG5RTWFIcWVaT2hs?=
 =?utf-8?B?dEhDM0dKT1JLSDlFYWk5TElYaVArK2QyMEd4OVVabDZ4eG5ibnhNNmtsZE1P?=
 =?utf-8?B?Vnk0NU1KVGpXcStSbG5vdkNuQTQxNnh0MUxXSUpFMWVVdUVSMWloUHdmZ1Iz?=
 =?utf-8?B?VGJXemdsVlVSUkZEQTRlNGh2RHFTNUo2VUdyZldsMjBMK0hWQ29wdFFIaWJH?=
 =?utf-8?B?WW9lNFIrRHZhSFZGb3VkVDFUZ0Q3UGZ3UzVzcTExT0ZyWHdxbWhEQWY2NGVX?=
 =?utf-8?B?djI4LzV5SThveFhkVkpiZVl5K0xLM0NFbWRQOWJxU0pzdHozMVVwTG5YanAz?=
 =?utf-8?B?clVZWDVmbWRETXlCYXJ5RHNKNDRtbFFETnRBOWhWMnBvcFF1SzVCbnVMZTVV?=
 =?utf-8?B?cFJ1WXF4L0VPVHlpT3Q1bTdWMnE1K0NmTXEwSU9ZQThxOURIZnRzakxndkgz?=
 =?utf-8?B?Wm45UkZLZDBsTGM3L2JIN2IyZnduOTVoK2hMS09lNjMxUmVicFM5QUJqSFl6?=
 =?utf-8?B?V3cvZTY4M1B2ZW1YTGZTQlRKUFhseURUSFNnV2N2WVhVR0d6TjcreWZSaU8v?=
 =?utf-8?B?aitVbjEyYUFCOHdKMVJPaUNXR0FxODU4QWV0WE9oOGJ4cWFMTDE3ZnZqWFR0?=
 =?utf-8?B?SUlmQzNXZEQ4QXRWSXhKMlV3TUxNNm0zb1dtZFdRakhwbVR0bEV0KyswdEQy?=
 =?utf-8?B?WjdLR2RGT0FDc1ZhV2dreU53TGNhdCtTVzhtUUJKaXFMMmtSRVRNMVR4cEdh?=
 =?utf-8?B?Qjl2MUwxbHk0aUY1NlJQRDVlTnBYZFdxTlVyejhQdjM0MDJ0dGhYazF4Qkxj?=
 =?utf-8?B?TnZpMy9RQXFPbGRxYkNIR1o1L21uOWorY3dFdi9kbjhJU0oxd2YvQTMram93?=
 =?utf-8?B?aGhsZXM5UkpCVy8wVGJBQ09UTlFZaER6Y2cvN2tiZitObUdSODg3cnVWZmZy?=
 =?utf-8?B?UFo3NWFQYVA5bXRIZklsSTFBem42VmI0MkNRZ1lvdmg1dytUeXRUYUZ3YzNq?=
 =?utf-8?B?SWhHNUw1cit1REVxQ3ZUOUwyVndDNjJTR3hOT1k1YTRvd2V5dGNheWcrRXk0?=
 =?utf-8?B?S2plOVJ3RDk1ZVlLa1VEOGdCM3ZVYTZBSnV6djQxU2djYVJoRkNObkhPa0tG?=
 =?utf-8?B?L1hqajFKeHZDYkdwaW8rS01PMWxYRzZ1eHl2dXNLL25weGxtcXpNMk5mSjNz?=
 =?utf-8?B?WWhQbmYybDlrZ2RBMVpYamk0SUhORHRmVTdqNDc2TkpkV2w4aERXQnZJbVZx?=
 =?utf-8?B?Q1Z1eHVBQktXRWpaRHUreWFXUDBRcktmdys3YVRXUnNoUTNtUENWaFlLZVNa?=
 =?utf-8?B?Q25ZSjZUYzhZRzg1OFdPZjYrQTYzcWpiRE9DQy95VGNNSlo3b0VUUngvNmo4?=
 =?utf-8?B?dElVU0JvSHIvWmZVeVJEOFhFNkM1V0l5UHJpbFJpU0FJRldKYkxkcmVLbnlk?=
 =?utf-8?B?bndBdmxtWHJrL1ZCaGxPVEgvbXVwUVVGRFhnTmJaeWNJRHVtcklvSHV2K3dS?=
 =?utf-8?B?RnF2Y1FzeW9md1BXdGEzRHBrV0VPdEp0KzY5RlNmMjBkSGszeU1QZXpBMWJk?=
 =?utf-8?B?MEx4MmdzZVFyNnViNWRoZEFIK250OTNBdzBObWRLZlBzTEJGZWd6T2RLbHhC?=
 =?utf-8?B?V0hUK1FmNXRsT0hJYTFyQjJ1Y2krc1dJZmplK3VCMmJQdndvYm00RjA0RkEr?=
 =?utf-8?B?SHJlTGsrNnQ2ZW9kTXNKTGg3S212SEdpazJ2MHJlS0Z6d1RNOWZLQkxKTytp?=
 =?utf-8?B?SlJrN0xwdmczdmVaMlNQdlQ2ZUF5MzZoZzUyczhwaHl3MFY4M0dHcmY3R29t?=
 =?utf-8?B?cDduMmNWS01lWDdsalcyUk5Ndm9EMm1rV2pMcXJia25GYkk5dVRpQ2Y1Q1Fr?=
 =?utf-8?Q?S+Bc0gp7oU1F+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MzI5Ukg2cjIyTE5LbkI5am9sc2hKN0ZGaEV6TFg1QkpUSnpKVkRCUGk3eXFi?=
 =?utf-8?B?bEsvVVhRUlIyWjdFb21ES2hnUjVmWXFtbkNleTFQVEVlUE1BZkFRY09Fb2c2?=
 =?utf-8?B?akhTdkYzRmtFd1ZLVXAvbU1HR2MrWjRMVVRCdnZjUHFxeUx2cUZIVVFDTUtv?=
 =?utf-8?B?K2NLa2pJcU9EVUFhVnhoZ2ExSSs4dnFnV0hNY3BxQ1FXNW0wbmJuRWFzdTQx?=
 =?utf-8?B?MlRWSlJEVCtEWnNiMHdxd0w4djlWK3NQYm9Yeit0eFFncWZlZXg1WFd4ZDhP?=
 =?utf-8?B?VnpIWGdaZk9SbG9pOHdGY21kYldHWXl0dkpTTWwxTFhTSTRWNlF5aWRJeGw1?=
 =?utf-8?B?aWJLWDVQN201MzRQTkMwaGZTRzIwUGVDTmNrS3VFMUZ1bUsvMEJlTDNBemQ0?=
 =?utf-8?B?TU02QTV0MGdCQkdiOUFieS9NVmFBaThvU2h2Z1BqZjIxVk5OblhJdHdYTzli?=
 =?utf-8?B?M2xhTW5JS1lJUklGVEQ1YkIvOEZVOUloTXZMTFJkZWZHTnlsaHo5WHYzamta?=
 =?utf-8?B?NXFCTktuYmFHZW1aWWp0WVcyWVFhTyt0Z1FRLzU3VUVMdWI2UGtZTU1CZm9x?=
 =?utf-8?B?U1FxNnhkcUU2aW5XamdSMlliKysyVHFWK3J0ZzJFM3lEOTJHUm94RzFUOVhK?=
 =?utf-8?B?TkkxUndzWXNBQzdYd3pIUk5DL2dHRDhUc0RocngvZkVUZW16VWs3M0UwUWZk?=
 =?utf-8?B?ZjJEZUhGQklCZ0ZXZjYwWlpiUHdlYWNjdW4vTUptNG9ZUlYxazMwWnhnTXZS?=
 =?utf-8?B?ZjJGcVFTNTJ0S2NzTTNLU1EvWHA1U1A2VllWSFBwT2tHa253YmZjYUI1Rk9I?=
 =?utf-8?B?aEFreWZuWmR0UldrdHFIN01lNTFWb281cW44ZXlPVW9OQjNDUWRVaGMyM2ky?=
 =?utf-8?B?R3RiR1hnZUl4d3FOZTNqU2h0MVZPa3laMUpqV25Rb0E2Q1U3dy91YitDLzF0?=
 =?utf-8?B?TE1Pdm5HZVpOVFhJM1BjWThYaVVPdU9pUm1jSjdMU1lFY0lnNnU2YVJKbFhu?=
 =?utf-8?B?YkZmQjU5NDRyTnJDU1RVMUxHQkZKTzNIOHppa2NBNW5XQ250UE5vUTl2UXdx?=
 =?utf-8?B?UFBnWFBoajJDTDE1ZXF6bkxwbDJuVFU3OTdST0VaZ044c2taWjArMkJZQ1dY?=
 =?utf-8?B?UGlOdWxUaDV5VVNGN1c2YUE5aER4aWU2WGcwQ0RQQjdaMldnL3UvL3YrdHhN?=
 =?utf-8?B?ZWFLUkYxdUorWGJlWm0zVzR5RjNYQkVCYWdYakdPNFZjZS9oN2wwbWUvRnV4?=
 =?utf-8?B?U25MMkNRUXZmSVA4VlhpcnZESVhYUXY3QXM4N0R3aWpURE9FTWY4UW5FQ0JC?=
 =?utf-8?B?WFNKci9qc3BKWEZvQlNjc2hzWFFqRUpjdDhyNUtqUTdtaGJydnNrR0MwWkU4?=
 =?utf-8?B?M2t4N0hacmIvSG9ERjljUjVjWkJNQjhTZ0Z3M0hQamZNektnb0RQZkZadUUr?=
 =?utf-8?B?V2FZRkl6ZDU0TVlDOUdVMVJCM1VYZEJ6WGlWRGFpMjhJaWNXTFBxYTE0cHZX?=
 =?utf-8?B?ZjdsQUZwRDZ3eURUeEQ1bGE2VnB3b3VMYkZ0eW5rcXNoV29CVU9SbWhjbnYv?=
 =?utf-8?B?SDN3WXRBNG9PeTQzQ3FEbU5ISVRTM2FIVU9DRFNJUDF2cENxSjNIcm1RTEFj?=
 =?utf-8?B?NXpCMkJtZDhRaDZocWc2Rk5sQkxnY0tHa1NDQk9RVDZPSHJ5UmFPN01zMnBE?=
 =?utf-8?B?blRRRytCMUZCbkhPTW9OamVLUjBWWkNobTRQa1kxNmVqbFhNeG5jNHpFemtE?=
 =?utf-8?B?UHlqbkwwTHpqVERzejliQlA5UjBEeEZXUkRqa0ZBSDdqMGNvZUVrV1Nqd0Fn?=
 =?utf-8?B?aTE2Wmd1VGNVTGlEbHh1My9CUVZOTjFQT2J2UVRhUHhkc2hSM0JBSmpzUmdK?=
 =?utf-8?B?ZFpvS0t1TXJHQlA4Qld3Z2wrc2pOZEcwekFuL2xMcWd0ekhBWmdEMWtkNTJD?=
 =?utf-8?B?MlZJUlZkMWFIMVFyOVpzemNZVk1RUTZqZmdJdlVlVlY3TzNIbCtKZ2pkVzE5?=
 =?utf-8?B?NVBCaG1MTzlpbjgwbGlZS08xT1NqM2t2VVpXblZxbEwzRUJqUmxtMUtlalRr?=
 =?utf-8?B?bnFTamZoMW9qd2JrM0tWYUNPVXNueVdRL3ZFckZZLzlONFkrZ1hQQ1ZJcEsy?=
 =?utf-8?Q?mnliylTCVJamoTqMp9ZzOYVzA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21019a70-810f-4286-24cd-08dd2f540805
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 19:46:51.6467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2csoCM16qCaQ7hr8qMrrHgEbLW+NfpDx34cHj8nPNq8RsxYwkH3sBVNgjziItwjIZfn5WmtclG3irwTPiPyYEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6840

On 1/6/25 06:46, Nikunj A Dadhania wrote:
> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
> used cannot be altered by the hypervisor once the guest is launched.
> 
> Secure TSC-enabled guests need to query TSC information from the AMD
> Security Processor. This communication channel is encrypted between the AMD
> Security Processor and the guest, with the hypervisor acting merely as a
> conduit to deliver the guest messages to the AMD Security Processor. Each
> message is protected with AEAD (AES-256 GCM).
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Although if you have to re-spin, it might make sense to use the __free()
support to reduce the number of gotos and labels in snp_get_tsc_info().
You could also use kfree_sensitive() to automatically do the
memzero_explicit(), too.

> ---
>  arch/x86/include/asm/sev-common.h |   1 +
>  arch/x86/include/asm/sev.h        |  21 ++++++
>  arch/x86/include/asm/svm.h        |   6 +-
>  include/linux/cc_platform.h       |   8 +++
>  arch/x86/coco/core.c              |   4 ++
>  arch/x86/coco/sev/core.c          | 107 ++++++++++++++++++++++++++++++
>  arch/x86/mm/mem_encrypt.c         |   2 +
>  7 files changed, 147 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 50f5666938c0..6ef92432a5ce 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -206,6 +206,7 @@ struct snp_psc_desc {
>  #define GHCB_TERM_NO_SVSM		7	/* SVSM is not advertised in the secrets page */
>  #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
>  #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
> +#define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 0937ac7a96db..bdcdaac4df1c 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -146,6 +146,9 @@ enum msg_type {
>  	SNP_MSG_VMRK_REQ,
>  	SNP_MSG_VMRK_RSP,
>  
> +	SNP_MSG_TSC_INFO_REQ = 17,
> +	SNP_MSG_TSC_INFO_RSP,
> +
>  	SNP_MSG_TYPE_MAX
>  };
>  
> @@ -174,6 +177,21 @@ struct snp_guest_msg {
>  	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
>  } __packed;
>  
> +#define SNP_TSC_INFO_REQ_SZ	128
> +
> +struct snp_tsc_info_req {
> +	u8 rsvd[SNP_TSC_INFO_REQ_SZ];
> +} __packed;
> +
> +struct snp_tsc_info_resp {
> +	u32 status;
> +	u32 rsvd1;
> +	u64 tsc_scale;
> +	u64 tsc_offset;
> +	u32 tsc_factor;
> +	u8 rsvd2[100];
> +} __packed;
> +
>  struct snp_guest_req {
>  	void *req_buf;
>  	size_t req_sz;
> @@ -463,6 +481,8 @@ void snp_msg_free(struct snp_msg_desc *mdesc);
>  int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>  			   struct snp_guest_request_ioctl *rio);
>  
> +void __init snp_secure_tsc_prepare(void);
> +
>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>  
>  #define snp_vmpl 0
> @@ -503,6 +523,7 @@ static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
>  static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
>  static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>  					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
> +static inline void __init snp_secure_tsc_prepare(void) { }
>  
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>  
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 2b59b9951c90..92e18798f197 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -417,7 +417,9 @@ struct sev_es_save_area {
>  	u8 reserved_0x298[80];
>  	u32 pkru;
>  	u32 tsc_aux;
> -	u8 reserved_0x2f0[24];
> +	u64 tsc_scale;
> +	u64 tsc_offset;
> +	u8 reserved_0x300[8];
>  	u64 rcx;
>  	u64 rdx;
>  	u64 rbx;
> @@ -564,7 +566,7 @@ static inline void __unused_size_checks(void)
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
> -	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
> +	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index caa4b4430634..0bf7d33a1048 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -81,6 +81,14 @@ enum cc_attr {
>  	 */
>  	CC_ATTR_GUEST_SEV_SNP,
>  
> +	/**
> +	 * @CC_ATTR_GUEST_SNP_SECURE_TSC: SNP Secure TSC is active.
> +	 *
> +	 * The platform/OS is running as a guest/virtual machine and actively
> +	 * using AMD SEV-SNP Secure TSC feature.
> +	 */
> +	CC_ATTR_GUEST_SNP_SECURE_TSC,
> +
>  	/**
>  	 * @CC_ATTR_HOST_SEV_SNP: AMD SNP enabled on the host.
>  	 *
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 0f81f70aca82..715c2c09582f 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -97,6 +97,10 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
>  	case CC_ATTR_GUEST_SEV_SNP:
>  		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
>  
> +	case CC_ATTR_GUEST_SNP_SECURE_TSC:
> +		return (sev_status & MSR_AMD64_SEV_SNP_ENABLED) &&
> +			(sev_status & MSR_AMD64_SNP_SECURE_TSC);
> +
>  	case CC_ATTR_HOST_SEV_SNP:
>  		return cc_flags.host_sev_snp;
>  
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index feb145df6bf7..00a0ac3baab7 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -96,6 +96,14 @@ static u64 sev_hv_features __ro_after_init;
>  /* Secrets page physical address from the CC blob */
>  static u64 secrets_pa __ro_after_init;
>  
> +/*
> + * For Secure TSC guests, the BSP fetches TSC_INFO using SNP guest messaging and
> + * initializes snp_tsc_scale and snp_tsc_offset. These values are replicated
> + * across the APs VMSA fields (TSC_SCALE and TSC_OFFSET).
> + */
> +static u64 snp_tsc_scale __ro_after_init;
> +static u64 snp_tsc_offset __ro_after_init;
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>  	struct ghcb ghcb_page;
> @@ -1272,6 +1280,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
>  	vmsa->vmpl		= snp_vmpl;
>  	vmsa->sev_features	= sev_status >> 2;
>  
> +	/* Populate AP's TSC scale/offset to get accurate TSC values. */
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
> +		vmsa->tsc_scale = snp_tsc_scale;
> +		vmsa->tsc_offset = snp_tsc_offset;
> +	}
> +
>  	/* Switch the page over to a VMSA page now that it is initialized */
>  	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
>  	if (ret) {
> @@ -3121,3 +3135,96 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(snp_send_guest_request);
> +
> +static int __init snp_get_tsc_info(void)
> +{
> +	struct snp_guest_request_ioctl *rio;
> +	struct snp_tsc_info_resp *tsc_resp;
> +	struct snp_tsc_info_req *tsc_req;
> +	struct snp_msg_desc *mdesc;
> +	struct snp_guest_req *req;
> +	int rc = -ENOMEM;
> +
> +	tsc_req = kzalloc(sizeof(*tsc_req), GFP_KERNEL);
> +	if (!tsc_req)
> +		return rc;
> +
> +	/*
> +	 * The intermediate response buffer is used while decrypting the
> +	 * response payload. Make sure that it has enough space to cover
> +	 * the authtag.
> +	 */
> +	tsc_resp = kzalloc(sizeof(*tsc_resp) + AUTHTAG_LEN, GFP_KERNEL);
> +	if (!tsc_resp)
> +		goto e_free_tsc_req;
> +
> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		goto e_free_tsc_resp;
> +
> +	rio = kzalloc(sizeof(*rio), GFP_KERNEL);
> +	if (!rio)
> +		goto e_free_req;
> +
> +	mdesc = snp_msg_alloc();
> +	if (IS_ERR_OR_NULL(mdesc))
> +		goto e_free_rio;
> +
> +	rc = snp_msg_init(mdesc, snp_vmpl);
> +	if (rc)
> +		goto e_free_mdesc;
> +
> +	req->msg_version = MSG_HDR_VER;
> +	req->msg_type = SNP_MSG_TSC_INFO_REQ;
> +	req->vmpck_id = snp_vmpl;
> +	req->req_buf = tsc_req;
> +	req->req_sz = sizeof(*tsc_req);
> +	req->resp_buf = (void *)tsc_resp;
> +	req->resp_sz = sizeof(*tsc_resp) + AUTHTAG_LEN;
> +	req->exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +
> +	rc = snp_send_guest_request(mdesc, req, rio);
> +	if (rc)
> +		goto e_request;
> +
> +	pr_debug("%s: response status 0x%x scale 0x%llx offset 0x%llx factor 0x%x\n",
> +		 __func__, tsc_resp->status, tsc_resp->tsc_scale, tsc_resp->tsc_offset,
> +		 tsc_resp->tsc_factor);
> +
> +	if (!tsc_resp->status) {
> +		snp_tsc_scale = tsc_resp->tsc_scale;
> +		snp_tsc_offset = tsc_resp->tsc_offset;
> +	} else {
> +		pr_err("Failed to get TSC info, response status 0x%x\n", tsc_resp->status);
> +		rc = -EIO;
> +	}
> +
> +e_request:
> +	/* The response buffer contains sensitive data, explicitly clear it. */
> +	memzero_explicit(tsc_resp, sizeof(*tsc_resp) + AUTHTAG_LEN);
> +e_free_mdesc:
> +	snp_msg_free(mdesc);
> +e_free_rio:
> +	kfree(rio);
> +e_free_req:
> +	kfree(req);
> + e_free_tsc_resp:
> +	kfree(tsc_resp);
> +e_free_tsc_req:
> +	kfree(tsc_req);
> +
> +	return rc;
> +}
> +
> +void __init snp_secure_tsc_prepare(void)
> +{
> +	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +		return;
> +
> +	if (snp_get_tsc_info()) {
> +		pr_alert("Unable to retrieve Secure TSC info from ASP\n");
> +		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC);
> +	}
> +
> +	pr_debug("SecureTSC enabled");
> +}
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 0a120d85d7bb..95bae74fdab2 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -94,6 +94,8 @@ void __init mem_encrypt_init(void)
>  	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>  	swiotlb_update_mem_attributes();
>  
> +	snp_secure_tsc_prepare();
> +
>  	print_mem_encrypt_feature_info();
>  }
>  

