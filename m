Return-Path: <kvm+bounces-44817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FCDAA161C
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 19:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63DC87A4289
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3EF72512D8;
	Tue, 29 Apr 2025 17:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1dUyCMbH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F4982C60;
	Tue, 29 Apr 2025 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948023; cv=fail; b=YHpNVnWb2ev0wXt1AqJRCjHImlcGOrmt7u71OeIWaf0ZSoCScC8jnDXZHVhzkroi2TcQP8HRBGGdake/HCgzpMDmQYf5nWBIZcIJxbRronst7zW13fwAr5e8mkV50HQCRmehyL8fRpBIbitoxIw1Y5Eo7SOgwS4g4jAnAN18Rbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948023; c=relaxed/simple;
	bh=sIQNf+iT6Dh0wJ4GaMOAet6WMf4DyD/ywFYu+4y0KSc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bBDV0mAZTlX+4rY551a8wkALN+SBQ8ZwhHFzN6g/IZqb1nS710HMXXL/qOk9JxiJXlWXwt5UARzjh7GFZ5uFMZdTR3HBcghg3uSoQMZrFcu5rbLSrrlB5pPjIz1pgXzmV/rEvAk8iezhcOiNdW/59IYHxR5UobR0paCXIzE6h9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1dUyCMbH; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhHzfKs3aAs41urGNzZ3QSD8hQHkNngE2z+MAcBab6LkC0WgjbE51mjqXMsVTVJIjfRqsqFL/oK8zFXj96GIVEZJ42WIAnZQWO/UybboXEk+HYdPTvmTsP5ZQBzOV3R/HSMaH9hWv0DCsgokDwwjrZjC5WCUMPp6mohivqO+7NrvY5NV9GxhNruhHPMYLESTFXgi1T+3e9jnAD6XRbvfRQto4WOmp8NqWsRGWN+xmVEUcz/MFu9T5x8DBc18Rt7beHDdY1egjrK6STJJuU7fn5MbeqCb0B/6wESMvvJfTpmncog/53ycpokBjl6x+jHXFF2t679aMQdYPW3YcKxb8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yv3GzEa7wbMYT3/j3MWFYQmtJcpXpzJqhBB8Gw6TXRE=;
 b=R+0pz+84D4WPYw8rwEkZsKBuNxel/htWomwQ6RyEW7+o8q5FQNRiB1eliXj/oUFmqg4oUuwTDOTlsjElkDh5LGaam9sLvTQjAQQ7xND+xzIucccd9MovLKAAhLhpl8dPOBm38FMjnbioFWnnY7jVxh75rQXc4nuj1p4jyiv/gnq9AliQGieJUkmjDnF8NrU5WdmK6CVFmPD4Usv5v45Amunn88Dt633SegJ/Apg/yEUYGIFwWQVKmIuMXjdESGu/OvJwSM0BpAehU0DNcfVEO6/E7dqmtq3lb7gphRXU5ZqYJhkzw0Sgm1SQh4zRU+3JfqwvpsleUJMvXmorZSAA9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yv3GzEa7wbMYT3/j3MWFYQmtJcpXpzJqhBB8Gw6TXRE=;
 b=1dUyCMbHMxwp9OrpgfD/b0aefgGf4FEM88Mx33PHOyX/+oDoPiugYUtUv0OStpdDjFtVo0iq2h1uBgpB6fv3KdBOLMtcSHBj1bmebDC9AF+TsckLpNH26HSiC8r+h2IdKKdlV9AOt2D9hMVfJF2ikhP3LXASBQXPzCEAjY0zBFE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7490.namprd12.prod.outlook.com (2603:10b6:930:91::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 17:33:38 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8699.012; Tue, 29 Apr 2025
 17:33:38 +0000
Message-ID: <926cde15-b1e2-1324-99e8-f5f07fc71ffa@amd.com>
Date: Tue, 29 Apr 2025 12:33:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot
 fields
Content-Language: en-US
To: Liam Merwick <liam.merwick@oracle.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
 <aBDumDW9kWEotu0A@google.com>
 <db704530-e4ae-43af-8de4-bcc431f325a2@oracle.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <db704530-e4ae-43af-8de4-bcc431f325a2@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: af327d69-3404-4dc1-735c-08dd8743f9fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFpjS21HZkNoRExJdmRMNEU2bVhKZ0RRNFpPYUw2Q2N1STUwUGozdVJhQmxi?=
 =?utf-8?B?aXl2dmRuSVVnUWhzZnZGOVNBb2d4TWt3RDdqY2tlZW80cTk0RDAzM25SK0w5?=
 =?utf-8?B?R2hKNTB3UGx5NncxdlduUWRSMER5dWlTZUZaZlNJaGxoNkcvYzQ5cnRPMHpS?=
 =?utf-8?B?V0RDRjZPR1owWm8wVm8wTzhPci90LzJBWXErR3g4cm1XeUNzcWZudkV2cmpD?=
 =?utf-8?B?OCtjcHk0V05MaXJqdmlIeEtPSkYvSjc0dU1GVStmSVFMOVpmSEVmK0hsRlJn?=
 =?utf-8?B?cmtVQUwydXhzZ2NTYytTZStzUjhaMGlBWGx2WWM5cmFNRGxyYWZneEh0YlZi?=
 =?utf-8?B?dW9jNnFmNVlzeDArNWF0RTgzbHloS29pL2R1U2thM21sZXU0d25XWEpsQnRM?=
 =?utf-8?B?RUFpUm1PWjZqVnRobnAzdTBvMnN3amt4aCtkdXBsQ3lmWlM1ZHpvWDJJMXBu?=
 =?utf-8?B?c3hNWGx0MkNHc2JrcWJWOXE1YTBLY1NxMlJkTnB1Q2oxcks2dWd0UjJseU50?=
 =?utf-8?B?YW43MnN6R0hLNmNXMW9PSFQ1WHNSemxsbVJLMUljcFFXR3Bza1dPTC9jeWZH?=
 =?utf-8?B?cVdZTDQrQ0R4Wk1DdGxHSkFTckg1cTZKemRyQ0p1dmZVNEs3SkJqck45VG11?=
 =?utf-8?B?aWtiZUM3YU1aNFh4Y3gzNHlBOGNGQnoyekFld3ZLUkhDVExVM0h4aFNGbWdX?=
 =?utf-8?B?dmFPMGZOSVhScTVTanp1QVE1TG54L2Z6aHdPbEJHMHd2dFBTdWN5RUY2VDVS?=
 =?utf-8?B?K1RyUHZPU3dQU2xnOE51d2QvVEZDUVI5MlNhN2dVSUZWdiswNSt1T1ltVFNN?=
 =?utf-8?B?MVFGTDFQdU9ESWIzeDVrWVY0QXp5emhGQnhXcEovbkkyYjZaSHA4NDRVWUFk?=
 =?utf-8?B?Z09wZmdoV0hwL2l2K0prL3FQaFdTR3k0L3JkWngyRzhkR2h0T2dGaldpU0Vl?=
 =?utf-8?B?SFY0S0lmSnpBQjBCN2lYNkpCNVVkbTlhbFZYU3pHejNXUk1KU3hKK0lqTkdN?=
 =?utf-8?B?N1VQdUJhcWwraGZXNmNtNmt0MDJHNXVzdDZKRXdOaTROU1ltSDdqaDM0ZHpQ?=
 =?utf-8?B?Tks2bnJ1VUlwSWZXcVRJQU15NUR4bVQzUjF6RmJRVW1vZ1FKL2xBTm9jUlox?=
 =?utf-8?B?VUQrWW8xcFh6c3NYa1FlMkJTMkQrWlMrVWtaUEhXSzJJbGo2OWt1VGYxRkh3?=
 =?utf-8?B?c0lyZ3RMeENlYmZiT2tOVHVtYmY2VzBPWGZoMllOZDZ3WmpMUEs1d0p5OFZC?=
 =?utf-8?B?MXFWRXRtaXFmSXFCNVZFS3VzOGNyMkM1ZVhwUnBKTFlSQ2FKcnNOMURQdk1v?=
 =?utf-8?B?RHAvVmhuaXRuRUpZRGY1WFdCclBET3NaQ0hRL2ZocVozMGdRMWxDcVg0c0tj?=
 =?utf-8?B?dGYzT2lLbmw5U2ZIT1U0Vitlbkt3S3hUV3FsN1dGaDZhclVRSVB1blpSRExR?=
 =?utf-8?B?YU1OUit3RDI3YVVVTWFTa1BzMzlHR1JWNFJ1ZklvYlZyeUhHVkRxN3FWaml1?=
 =?utf-8?B?OXVQbDZLKzl1TGwwaC9EWjVaL0tPUGVUYkRFV0JlQUQycEZrakQwR2hOTjYw?=
 =?utf-8?B?amRDWGd3VVFYRmhsZEFKSDE3cjF1SVR3QnJNZmgzRXNyZHpqZzNvQnp4T1NW?=
 =?utf-8?B?aHBCSnp0YjJkVm9yZ2xEZ3NBcFB0NHlRUUJTNWM0ZnM0WTVHYldVZkpONmVp?=
 =?utf-8?B?Zi9BTnhDTVVTblpEREdWUHF6UFhoNmZSRFBYL0p3amtEUlp6UDhxeVkydDdP?=
 =?utf-8?B?Z1BlRnJoSzVNMHNmSzJJc0h0WDhGMjNtUjlZcjdZeW5UTjMzcyt1WTBWaWsv?=
 =?utf-8?B?ellFaUNaWlBWUW9rUDhzZmhaMTZBeDY0WWtkOUdXZmRic1lHb0RCbXRBaFZD?=
 =?utf-8?B?VHpNSHFVQkZlNDY2WWttWkpMMit6bThlNzNISDFQYmtreHg2YldtbHcrK3p6?=
 =?utf-8?Q?wgbPEqg+6Dg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eSsrUGlVM1B4eEpaOVpocDN4bm9SendDNW9qV09mZ1V5SDlZdFlpVi94eEk5?=
 =?utf-8?B?K24xQUZJditKaytKTVQ1dWxyb2hKL1ZzcE1EblFyOGZua2lETnk5MGM0akpH?=
 =?utf-8?B?OVV1ZWZPS1hGOWl0dElnMWdYdjN6SWtsbzRycVgxREp2b0lMOFNEcDc2ME04?=
 =?utf-8?B?Vm1DOTdaNnhvRWxSOFB4aGppd1NoY3BNY1BzVHBqclFUZ2NvRkI1SEJuaHpi?=
 =?utf-8?B?NkQ2Z090RDRnQXFMVnZmUFBmY0xhRzQyd1lDcW5HcG1rTkJpcnpPR2QwbVlB?=
 =?utf-8?B?ZWh6S2xKNWpHVVBZR0U0SnIzdUhIQ3lsaWQ1cFhYL29JNllXa0N2blpDQnNN?=
 =?utf-8?B?Y1RxMnorZkxFLyt5bExoRTR4WjFWakFpb3pxT2RGZ1FaM0I0S3cvRHN6aGd1?=
 =?utf-8?B?b0J5RFc2VW80c2dNdE5VZDBFQUJVUys0T25qbVllRFVENTZRMUJ1dVRUWGlL?=
 =?utf-8?B?eWVVYmxQcUdZL0ZJVVNwclFWbDZaNWRYZ3IwMVZCM0EwY2NDa21ZTkpKd3Bt?=
 =?utf-8?B?ZWUxK29FWmtrbnB4V3JPY2czK2xwNW5kUVlQNVNPaUc0dEZVTU5VbHBnZnhV?=
 =?utf-8?B?Q2RmUWFoZXpZNDBEWlpQUmJKYkp3ZUxzT3hDOGtpSERsWFp6em1UbFdEOU1O?=
 =?utf-8?B?Nnd3R3RIWFd3T2tCTEl2STduMklnRk02UVM1M3pCOGxTelRtZmdFOWlyQ1J2?=
 =?utf-8?B?QmwwTEVuY0M5Lzhrczc5bjVvM1RtZTFKdzdOWk56TmlDTk14MU1iejQ5TElR?=
 =?utf-8?B?NTlyZ3hsZ1NRcGdFQ1BZNkwycEtRcFlCWGVZcnZtTEpjN0JrQlViTENqemRa?=
 =?utf-8?B?aWNKM3pzNXh2b3pCRzZLdzN4TnNnZUUxYlZVT2RpRU9iSzFQV1M3Y211cHlh?=
 =?utf-8?B?UXg3dDZiR3dwUWlsSGtlT0VCWTdrYWVkMzNpQmtvb0xReG9paDFiVVh3OVE3?=
 =?utf-8?B?b2JRQlJ1QXJaS2RsZXIxcWtYdlRvYzdlZHJlanpPWnNKekpWcW1ESlJ1Yjhu?=
 =?utf-8?B?M2p1SWdSY1NQbS8yb3Y0UnJ3VTlIUzZGM0tDY3VLSHR6UEhLeEF6RE1rWW5V?=
 =?utf-8?B?OU91ODJPUXpHT2grdms4WTNzYlVBTVNZallmako4VFFWWDhhYmlBNWJDdkcv?=
 =?utf-8?B?OEdYRjBDeHhYSFhqS0RaMloyM1lwazljNXZnUmpzRCtnUWI0dEJDU0hEeFda?=
 =?utf-8?B?dFJ5MHp1RU9USDg4WWs5UGt3VTF2ampDZE5TYTlFSnRXbWRNN0hQZnhVZSti?=
 =?utf-8?B?N2FzT1E2dGk2aDFSaE9UOXJVQUY3ci9NblBIbUdoT3g1ajVDU08zTEY2YVp3?=
 =?utf-8?B?QUZuYnVLTnJ4UGVlcGJLZENLVHNqSGJJNldhUVQyRGpqUFZIb0tlYUxtK2lW?=
 =?utf-8?B?WHhtOGg3VVYwdU53Z3RMUktDQlR3L0k3NFB3TytzcmlTclg1UzdkWXRhMktW?=
 =?utf-8?B?YWxGZFJQS1lma3AvMjl0SWl0c3lDZm1XZzU5UDVUUFlqemh2emlKNnFxYndH?=
 =?utf-8?B?T3ovc0QvOTBKQnBnbHc0eTZzS3JXc2VxVHZ1elY4VjB6Q3Rlb1F1SjgzRXpl?=
 =?utf-8?B?V2ZBZC8vWTkwbTJEZWZ2ci9MSkprdUY4YkZVNy9NcGZYLzdFWnVYRGV5ZWxS?=
 =?utf-8?B?Y1hQQnNsZnVzamI3c3ZhV1VscTJqOEw0TUF4ZWhJR1NOOTN0TXZCSm0vUnd3?=
 =?utf-8?B?SVp6ZnVvL1l3bTgvcU1ZU1JabUZpVWJ5Y25VS214UXFjNTVQOFlnZzJtN1lp?=
 =?utf-8?B?K2h6RUdUdzBSQTIyUlY0QTd4VnVzNGFvVFFtUlA2aXV6ZlpCRGRseVkvWm1P?=
 =?utf-8?B?bFZ4aE5YUUFVbHN0QmZsalFEUk90Q1pIRzdsckxxRzNhdHZ0YmRwNjFoYVln?=
 =?utf-8?B?bUVna0NuaURLcGpuYks0Z2laR1p3akVYay8yL1JUcUJOYnNNZUxMTFhpNWtF?=
 =?utf-8?B?ZlZ1WXhOYS9LNThneUQ5ZXR5bVZtb0dodnhyWTFFQzJjNFFkUTR0OEtONGZw?=
 =?utf-8?B?NWpOVEhUL0hEWWlVUE9ONmpRc09sK25VbUZGK3RaMUgvYjdMN1ZFcDRyY3ZJ?=
 =?utf-8?B?QmlWbHduNHNNODM1V2NXTXdyQmxSRXk4TmR0Vi84WEdydEZwNVlJdTMwTTF2?=
 =?utf-8?Q?MIeQSMf85ZOSmqJZoa7+kiKfc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af327d69-3404-4dc1-735c-08dd8743f9fa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 17:33:38.4439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ckRXnVEVKk9Er/cOJkUDY1tvxxVbYtef3ADZ9QGzHeW48+5RqSHfgPwqx5K0eNuUa6750AO29HToqxFpdlWUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7490

On 4/29/25 11:31, Liam Merwick wrote:
> On 29/04/2025 16:22, Sean Christopherson wrote:
>> On Mon, Apr 28, 2025, Tom Lendacky wrote:
>>> @@ -3184,18 +3189,18 @@ static void dump_ghcb(struct vcpu_svm *svm)
>>>           return;
>>>       }
>>>   -    nbits = sizeof(ghcb->save.valid_bitmap) * 8;
>>> +    nbits = sizeof(svm->sev_es.valid_bitmap) * 8;
>>
>> I'm planning on adding this comment to explain the use of KVM's
>> snapshot.  Please
>> holler if it's wrong/misleading in any way.
>>
>>     /*
>>      * Print KVM's snapshot of the GHCB that was (unsuccessfully) used to
>>      * handle the exit.  If the guest has since modified the GHCB itself,
>>      * dumping the raw GHCB won't help debug why KVM was unable to handle
>>      * the VMGEXIT that KVM observed.
>>      */
>>
>>>       pr_err("GHCB (GPA=%016llx):\n", svm->vmcb->control.ghcb_gpa);
> 
> Would printing "GHCB snapshot (GPA= ...." here instead of just "GHCB (GPA=
> ..."
> help gently remind people just looking at the debug output of this too?

Except the GPA is that of the actual GHCB. And the values being printed
are the actual values sent by the guest and being used by KVM at the time
the GHCB was read. So I'm not sure if that would clear things up at all.

Thanks,
Tom

> 
> Either way, for patch:
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> 
> 
>>>       pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_code",
>>> -           ghcb->save.sw_exit_code, ghcb_sw_exit_code_is_valid(ghcb));
>>> +           kvm_ghcb_get_sw_exit_code(control),
>>> kvm_ghcb_sw_exit_code_is_valid(svm));
>>>       pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_1",
>>> -           ghcb->save.sw_exit_info_1,
>>> ghcb_sw_exit_info_1_is_valid(ghcb));
>>> +           control->exit_info_1, kvm_ghcb_sw_exit_info_1_is_valid(svm));
>>>       pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_2",
>>> -           ghcb->save.sw_exit_info_2,
>>> ghcb_sw_exit_info_2_is_valid(ghcb));
>>> +           control->exit_info_2, kvm_ghcb_sw_exit_info_2_is_valid(svm));
>>>       pr_err("%-20s%016llx is_valid: %u\n", "sw_scratch",
>>> -           ghcb->save.sw_scratch, ghcb_sw_scratch_is_valid(ghcb));
>>> -    pr_err("%-20s%*pb\n", "valid_bitmap", nbits,
>>> ghcb->save.valid_bitmap);
>>> +           svm->sev_es.sw_scratch, kvm_ghcb_sw_scratch_is_valid(svm));
>>> +    pr_err("%-20s%*pb\n", "valid_bitmap", nbits,
>>> svm->sev_es.valid_bitmap);
>>>   }
>>
> 

