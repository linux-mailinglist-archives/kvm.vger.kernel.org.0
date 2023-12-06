Return-Path: <kvm+bounces-3768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A63807974
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 21:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6E251C20F1E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00324B143;
	Wed,  6 Dec 2023 20:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aY3pPK1t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADB7D5C;
	Wed,  6 Dec 2023 12:35:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTofi2Jj1mdRyQU7bRZbh5143R+wLEJ/nDfvZMPXHQP11DQR0vcvkC87RlZZcINyHcTkhAjxfvdz4JVBGClyW9nvwQhS4P3DkyLBK5r4XRIlpg7TR2xR6kLiT9t2Rwzr33powKv1QBSNCoOrv1qqq0Vm2RgJnV3WZahdchoX+tU60aQfbBmSciXBnRIJ+100lPUnC/9nM3pY0BM8Qd3xifJpXt5J0mwdPaPo2khnoCEi2fJzDFSSIbfOUYiv3MpIH7uPgnZg+9W1mZyd8KJVFLgIZWOqiQD1iNi1IPCA+6A5uEgrkRCl0/PGElLphXibq9h/sfnh32IHv22Aj2VZXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yf5A6/Q53LugxL4lu4tYjyI2OkN8idTKGkvO/tsL4bg=;
 b=LCNWyG9Jwdt46G1wMrbB0D7Me8AU4EeIz34bSwGgbUqrKH9nmx2F0pwZRyIYHA3yfOKxgASUAVVSpY8opfA1fd/GULz6axjGsEqQ0RCf0VcIVpvLN+8i25v8uq53tVU0qQEIKT5AYkoFMKzBPRTW8KHhQdnaorpl2xzfsFzIsWWKiONAjxp0KLpnwJwmEkt/3Dx4dAZiCx0aNSp6SKv/WuPdluZ2lXzU7SaNv56Qf+QbVL5l2960QWRijPF/RleXz4OnYVm8CmMt/lTwu+Fq/2lyl2fbR5XpuWTOMq2zHAR6s/TqhPQTgUeUgMjQIZgRTl1wzIvhuGY3/4q5Q/VwKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yf5A6/Q53LugxL4lu4tYjyI2OkN8idTKGkvO/tsL4bg=;
 b=aY3pPK1tg19SgjLi8YY0xxdZ9WbTV+E5Xj7tmg9NUElZEmgVxyytbkxB7Rqpw+o+XoK8P4RDLo/d05UrAia1Taq+/FmmRT6BTc6XwZXXYWkce8Hcp8bSGUR/ZlvklYGN3KT5CrcxOaOKhapqfV6xkhYATioQBOq8k4IJN1ju+uA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH0PR12MB7908.namprd12.prod.outlook.com (2603:10b6:510:28e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 20:35:32 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 20:35:32 +0000
Message-ID: <9af9b10f-0ab6-1fe8-eaec-c9f98e14a203@amd.com>
Date: Wed, 6 Dec 2023 14:35:28 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 14/50] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>, Jarkko Sakkinen <jarkko@profian.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-15-michael.roth@amd.com>
 <20231127095937.GLZWRoiaqGlJMX54Xb@fat_crate.local>
 <d5242390-8904-7ec5-d8a1-9e3fb8f6423c@amd.com>
 <20231206170807.GBZXCqd0z8uu2rlhpn@fat_crate.local>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20231206170807.GBZXCqd0z8uu2rlhpn@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH0PR12MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: 758ae55f-f5b6-43cf-43cc-08dbf69ae438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	666IGnSyk5vqfMUgq8LL2his7GkBHoGqlU3bamZhQFmN7R5r4FdQd6CvNqXhcwmR1/uPAWDogd3ACSu49XFGsNagrd4VX1cuzsi36rJwBck1+LZpAXkB1JkclfdkUTnNXBftaqywEVVT3xprML6n/b9X5F6FgWHOwh8osqrpXv1h6zBom93AUJYIUp6oRsgWA+LFFCcJ9vbRHpqDgbN2OoibXsrCJj1WyWwq6oJOULufiwhx04v1U8R2fIsStlm12iPW/MTtiMcDcMa7g7eiHI/WpzGiYao7mYK0s4P9mo5ULz/h9ni/07y2/gOHgEvjlWa2u0WiQzy4+X3sS9L6zLCGzKPnq2oAxVUJN5mKp7Vw9ML6lLCR+qUg0U4Yl2WA4a/WjNsyvgprda6KjJvM4hbpSZ94J5wZ1O/gi7/+FAnggas3ep1JhDj9GPa811N9CZKdlV2c4hO5103SLBZWfH1t1CCND6o6d2XiidsKWItPA2qrlu9yA6BoDKDiGFiySYFC+nUI1dtgeTf1XgVvRLsclGcuCVhATYMjlYrwdMi5n8SbnoTDwQxtodhcDbdkyQcU1EpSRDKskqRHaraNkPQia6zmqax7O7KMkFNB2NKURpJvfiUjq1QBCNxxSzrKaRhfHoVlVmiweeSKcheLOw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(41300700001)(36756003)(7406005)(7416002)(5660300002)(86362001)(2906002)(26005)(2616005)(6512007)(83380400001)(478600001)(53546011)(6506007)(6666004)(6486002)(38100700002)(31686004)(8676002)(8936002)(6916009)(316002)(54906003)(31696002)(4326008)(66556008)(66946007)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXMzSTZvYm5iZ0dHYnZkNmlUQmdvVE5nNy9nR2NKMXNmK05Va0dkVUxJRWJ2?=
 =?utf-8?B?K0NkYUV0T1VKRWZOWnE5QnFDbjhlcDZNWmw2cjZxU2hKVmdla3FuNk9SWXNv?=
 =?utf-8?B?VGtDQlRmbEZGNGFuR2tVanhHMzBmQ3NyQnZRUGd0Mkh2Q2VhNHdSYXJNQlo5?=
 =?utf-8?B?bmNvanJnR2VjeXlobmN2UGNLUDBlOTdQbzk5MFRnMFEzTjNiaXhRcG01N2RM?=
 =?utf-8?B?NEJsMTJZYTdJOTE1Mk8xMS9kcGlMdHJRUUlrU0xsR29tbEgrQzlwcGpOaGE0?=
 =?utf-8?B?TlBveDlLMTFPajFiSTl5Z1l3RlFEQ1VqR0t3M21adUMzeGRTMVNmSVZ4d3dy?=
 =?utf-8?B?VG9pdWVEelZhTXo0RDdjQnJ3S2ErY2lGSW1HU0tXa0tKUyt4cUxLK3NETkQx?=
 =?utf-8?B?UkZZMHRmZVV5VnJvOFo1UW1Qb0NZbUxQZG5Uc0JhQXFHUmtvTkJ6LzRoTkh5?=
 =?utf-8?B?NXlyU2FsaVlhMFc3akt1a3BhOW5DbktqKzl1QnFLMDBFUFVwSjFFMVVpR24x?=
 =?utf-8?B?ei9zL0pPb1QwUmFpeUwzSXdBZlBBQU5pT3crWU1LQld1c3JGam5pOGpXWlF3?=
 =?utf-8?B?bWkxUi9iUVlzRFBzdVZ3THQ3Wm4rWnhLNHN6dmluKzdHWlhaUjhIeTZlSGJo?=
 =?utf-8?B?V25CRWpaNTNna3dTL3g0UlZseXE4QVhsWjlKeVpvN2FJenJzM3pmT0xlTDBm?=
 =?utf-8?B?ZktXOXNVNnFUMmN5QlJadnJBeDNlYnpsaHhKdm5wWE90ZkpiMlorZWtXQ1JR?=
 =?utf-8?B?d1hiUy9NYy9LbmdtL0tXUHg2ekZiNUloS1ZNWldUUXE0MFpvbFlLcjdqOU1j?=
 =?utf-8?B?SUNvelRicytXTTlNRUYyNUJ6dm9RKy9Sb1pRSFUrc3N3anpNRHc1Z2tMcmdR?=
 =?utf-8?B?WGU4TlZmc1lhSjRsZnkrS1o5RXZXRmE5SEVRR2c1K3dXZU93cUx6RUpxRFhL?=
 =?utf-8?B?d1Q1VEhwbFpNMFN2bnBZdE5pUUpSeDRabzRicWNTNE80cTJLM2JYbE5VMmxl?=
 =?utf-8?B?MFZxTG9zd0VHVHltYVV5WXdDZktTWHVVRG16c2tNdHNISjA5KytYc0RnUllX?=
 =?utf-8?B?dms1bjArR1lQaDRqaWdiWEZieHltRlJMbEpSNUN5aFlEUmhHQStFd1V2M1BZ?=
 =?utf-8?B?RXpLdnBYZTl1dVRxYWd2WFdJclN1OXlOcTFXWGh5WC9ERTdGZFl3SmZtbGFz?=
 =?utf-8?B?OHp0Yk4wK29nMWNOdGhscUV1MW9yWlZETzBqUGF4NGp1dXljUGxIRThhNGVQ?=
 =?utf-8?B?ckNSVno4TmR3M09VaEJWclcvT05EQk5OdHlhSFZTbXVjVmNZWFlURTQ5dXhQ?=
 =?utf-8?B?UjdjUXp4cXZuellDa1hSaXZIMzllRXRwejZJT3ZCd3BTN0kxU0ZmZ0E2RUdN?=
 =?utf-8?B?YTN6dDFnais2ODNMNWRTeSt5aWZveWJIT1dsOWdNY1pCTXd1dTQwODBpeXB2?=
 =?utf-8?B?bHg2Wkd2SVFUYllRdHhrMnZnWXd3eVZiMFNocnpFTjJjdkZ6M1hJSk0wZUIy?=
 =?utf-8?B?MTdZbk05b0FZOXpnYnR0NlFYMDM3TGZBanhYRE1sYUF1THVSYThWb3p5UitN?=
 =?utf-8?B?dmFvMzZmaTdkK3RKZ1VaM3pONVJZZmRVVlVQZlhySjROU05EUU56QW5aa3hj?=
 =?utf-8?B?czVUZi9OemJneHhWaWM0SnkvQTNsc2M1Tyt1ZDFUeW9zbU9VNWNEa3lHS1ll?=
 =?utf-8?B?UERudE1mOTNHVEpJS1VURUpKNGdGdFRXWkN4WWEzMC82T2RFdlRSTUIydnRR?=
 =?utf-8?B?a2ZQRXdNQ1hOV0ZZZ3hzNitadmVCUHNnQkdJWTNiVDhNTmhVL0l1eVFTY0cr?=
 =?utf-8?B?dkF2OFU5RU15RTB2QTgvMFpKandzRnpuV2hhUEFCL2dvZ0RHcWE4YVVhQ1RV?=
 =?utf-8?B?MUVuYlhNa2UxbkJGRHpXZDBxUjhSaDk0OEpyZElVN0VDdFNEOTBEZVRHVTNu?=
 =?utf-8?B?VE0yVEpaYWxSTE9FUUlVdE5LelIyaUg5d2Z1SXFxNG1FUkNnbjJ5NEYwdXJr?=
 =?utf-8?B?YkM3TWlYeEhRckhESEZWV2ZVMWJmWFpSaWtYL3AxNE1Ka2xGZHp2V3V5SjV3?=
 =?utf-8?B?TlFyUE4xOTJZRXVLcmtoU1JrNWhNSTNpQ2hDUGRrZFR0VUd4ODVKUlVEd3pa?=
 =?utf-8?Q?RZrg+6YpoH2S1drzKYe2uRcSS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 758ae55f-f5b6-43cf-43cc-08dbf69ae438
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 20:35:31.9005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nq44Zt4tZmxh+PibsdgkI8ZIVKzkMd1OVk81LX+fe26rfqzn63pn8fzcyhwUtKtYSrjsqkj1rKWXVgMVTcuT1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7908

Hello Boris,

On 12/6/2023 11:08 AM, Borislav Petkov wrote:
> On Wed, Nov 29, 2023 at 08:13:52PM -0600, Kalra, Ashish wrote:
>> It surely seems hard to follow up, so i am anyway going to clean it up by:
>>
>> Adding the "probe" parameter to sev_platform_init() where the parameter
>> being true indicates that we only want to do SNP initialization on probe,
>> the same parameter will get passed on to
>> __sev_platform_init_locked().
> 
> That's exactly what you should *not* do - the probe parameter controls
> whether
> 
> 	if (psp_init_on_probe)
> 		__sev_platform_init_locked(error);
> 
> and so on should get executed or not.
>

Not actually.

The main use case for the probe parameter is to control if we want to do 
legacy SEV/SEV-ES INIT during probe. There is a usage case where we want 
to delay legacy SEV INIT till an actual SEV/SEV-ES guest is being 
launched. So essentially the probe parameter controls if we want to
execute __sev_do_init_locked() or not.

We always want to do SNP INIT at probe time.

Thanks,
Ashish

