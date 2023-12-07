Return-Path: <kvm+bounces-3796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F66780808D
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:12:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C98772819C4
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 06:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EB712E57;
	Thu,  7 Dec 2023 06:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KQrN6B7O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720FED4A;
	Wed,  6 Dec 2023 22:12:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V22dVAmzW+jAP7nCTwQuM4QOMdRIg6cZqmLyaA7fKnJGtusMdKPk1DWhkCA4uhTPGV7zM+RHWf85h6lGxJhPs1cAfABST824SRQPRFJAwkTq6z8Jwob/fC/QFIEJr5Rshv80e1aJZTVDdziBm+yX/2ntQjoj0iinhwHEnmt9Rz54Vf4/JAl4/HZyKlToyBOaAy4/m3p4KDOetMq+Afmz5FsuCs4u9ZwqkaGV90OSXMfAd0lkatN909OHY/qt0dxn/Ek3Asgr7bHFfhv0Zi/380QTVGGgroAolq4YLprk4dj68Ax6LuKn4VfabhXFZGkO1gJSISTeh8BYRXWbrSb9lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0u3EM5sEBI8dMCNznilsJEqPPbjvrUtddhqlC0q/hs=;
 b=a/HD1dXb3BYTvoJv7kzlg/VSoEvhGXHjBsVX8+bww86X6/ZMGdqLCxjAw34upV7cRt8nWP1VIfmAhtUO41Twt19RHTHNtqHGakPgl+cOAsaCiJt1BYUlvLZdBWX4HHF56/Um5v0LCfOyEkqlW9A4JVuzBqDVbHmPAgH282BhlbinL4Y/Vi8Xab6a50V1TFieUUJ+zbCouApbs8jsN7qs3xqPCYcpv7KCzhqu6cQ+qDcwrXc/++G8xuywBh6PVfu7rFOv0ZM6wi+dU0ftIziTqFeRW3/O76LVF9cs5R3YOSJAxR/d6w2sRgNGbua2kf/SpR8+FUl7Z8KcVtaOjXA74g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0u3EM5sEBI8dMCNznilsJEqPPbjvrUtddhqlC0q/hs=;
 b=KQrN6B7OHbyDd0YuABMz2Pfm9ZLx0XnAV6MmWOh86QFZRuItNq62sRCGgG0CCktLrOMys1jkF8idQoZvTuoj6qrH4AOWBMDSWosHz+ewfMRSh6TkvaFnlTUzdNxex2qHSe5ybEICUwodsXtGAlYTnPx3b5+NvsOBSRdEBkzs008=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB8172.namprd12.prod.outlook.com (2603:10b6:806:352::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 06:12:19 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d320:6e6c:d4c4:7fda]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d320:6e6c:d4c4:7fda%3]) with mapi id 15.20.7068.027; Thu, 7 Dec 2023
 06:12:19 +0000
Message-ID: <0d9d6900-9197-48fa-9627-8a9231b3857e@amd.com>
Date: Thu, 7 Dec 2023 11:42:08 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v6 12/16] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231128125959.1810039-1-nikunj@amd.com>
 <20231128125959.1810039-13-nikunj@amd.com>
 <CAAH4kHYL9A4+F0cN1VT1EbaHACFjB6Crbsdzp3hwjz+GuK_CSg@mail.gmail.com>
 <dbffc58e-e720-42fc-8c8d-44cd3f0281e3@amd.com>
 <CAAH4kHZVdZtU3MGLTuuxMZyBF1xO=UzpdVhqSE6szCxMLkHFvQ@mail.gmail.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAAH4kHZVdZtU3MGLTuuxMZyBF1xO=UzpdVhqSE6szCxMLkHFvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0077.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 7502e2e5-df70-4e8b-0467-08dbf6eb77a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/K5vCXRaYfiHCuRSuXVz0GsweBP1fu8LagEOUblu6Eas6ewV16Qvix/CSV5KhzsBSMFJhG5/u68EKCWYjgH6p8OMCDP1bd2fI3LdAPQDN9ehGWPJhLds4i/9HGuLAAh8xJe2iLFTHCwMeu7uUQXJ5tIkld+MaKb/9ipUZ+YZASyF7bqXRwVhAgM4SPCu8/3JjYJai8FqjfI9TCGT5uWEGGbT4gzahF0nULCxrRmHpU8qE470QWA9hgysxFZLEAWrhnVKvI2OD3JEuJkpdjK2dGct7Az0olzLZL7FN3g+vD4PFysXFMhspx+TDeXBONMrKY+KRz1qNiZmmTeCG/Vi/BL4cv6yvrjuoXfiPaR7SlpWC63zlk8+cH73vK2M1/Hp9ssNzElJjVAlQRcFOAmZjYELEI2TaPsJ8BO6bgqk2WaZ6o73WbB2f9t+/VH2BYZeaEiHAoY64sUsrLBXyUpLqNrybGgfsaZpb5RQMsUrq0mcBfi2PXb9AgKEpuiJjWNu9kcipa0X9aaPTcVMfg6wfux4zSssV3sNBoZ7hRU4gciFwxQkbY3vnfVtY714nRGu+jzIu5PkejNFRp3iWZ7z6qBMrv+I5rE6hEPPOiH9nD4XPLsCt9kC2hMaxjKP/6XyxUddEnJXf5s9Clo8sTCaaA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(366004)(136003)(39860400002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(6486002)(478600001)(83380400001)(6512007)(53546011)(2616005)(6506007)(26005)(6666004)(8676002)(66476007)(66946007)(316002)(36756003)(66556008)(6916009)(8936002)(41300700001)(4326008)(7416002)(3450700001)(31696002)(2906002)(5660300002)(31686004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEloR2xqREFkbWtORHNReU05OXBzT3MyaE15R0Z0NjRvSXIyMC9ibElTZjdy?=
 =?utf-8?B?RzNHdXI2eVhxeERkaCtVSVNPdEVOWTYyVC9tbVFhNG84V0JOQmJLOXg3eEox?=
 =?utf-8?B?TDNxNXFKcUVqQkttdEEyZWh3aHRRSnc3L3V3U2w3MXlqWG40N2JNdFdLdUNK?=
 =?utf-8?B?RWQzQ3R6dzRmVmhCWHBlVGhTWmVNUDlBclhDRzIvbDFWVUwxSWxjR1FuaFV3?=
 =?utf-8?B?c0FjZ3dQYk81dW1ZZzROd280U1pHU0ZDbW9xcHN3TU80cXNYQmdtTFZtR3R6?=
 =?utf-8?B?Vk9XK2tRa1hjbWVyVzE3TnFlZFFRbzU4RGtrQjRFUEVIN2c5emM4d3J1NGFw?=
 =?utf-8?B?M1NpbTNoZWdnYzREQXRJaC9pK2JTaWRUdDZpT2RXR3FDdzJOVTIvSjhZcW1q?=
 =?utf-8?B?bnc5aGd3ZDVoYlFJZktPT3dQaUtlZVlYZGRaYWZ1Q0ZRYlBFYmtWdURVNy9i?=
 =?utf-8?B?U2JPcnB3WHpMZmlYZFRrZXFVb3lOcEJUNzhSZFJiZHc1bWRld291ZXBxWGdG?=
 =?utf-8?B?TDBObFgyN3VDa3AvMXZqYmhiaXd3b0dIdzR6REVpZ1ovZUpIZ3N6MTlqY0xS?=
 =?utf-8?B?cmZIb0F4KytOaG9ucUNnTHhmck51ZkhpdkpKYll6aGJ1Zk9xOFUzSkRQQzBL?=
 =?utf-8?B?Q29PT0J4RndPZjIyMXhBU3VaSE5EdmlQbXh1K29xY3hEZEJmWWJNenUvd3Bk?=
 =?utf-8?B?RFQ3bDloVERkZU5lamYzZGxYcUt1c2hUZjNJQkxtVWNyY2VFaFBRVm5uNUF4?=
 =?utf-8?B?QmlTTktvb05qT3ZNYUtnMloxeVIvSHp4ZEE1cEFCZnV3WVNCaXh2OGhRUHF3?=
 =?utf-8?B?bFc3UHptdjd1WmtJaTZyT3V0SmE3ZnFJMWFTNFhsOFgwekJjM2o2RjV2NjhX?=
 =?utf-8?B?V3JTSzJOdGMvbmlSSGZTY0RFVWM0djc4ekxVVkRRdDYwbE5QZ0laRkJNbUUz?=
 =?utf-8?B?ZS9mS05UNEFuN1BJcWNMVjM5WksrVUFmVW5CTXVzaEtjRzdXaWJ6ZDJvNldm?=
 =?utf-8?B?cWxPSnUzbkVVRGo3UC9yOXp3TGg1ZWN1Q0RWbFp1Wm9tWGhmbGs2YjE4eWZK?=
 =?utf-8?B?RGJpL0Rlc1dsRmpyUlg3TTBKRFF3RFBlVlJhdGhMaVM4eitWM1ZzWlU2QjE1?=
 =?utf-8?B?WC91dTZzMFZNK3l4MFlzdDZyaTBvdWZZTFJGbXFiRVdvTGxONjBHNjcyZVM2?=
 =?utf-8?B?UFF1RnNueWwzOU1wZTRtUEc2YW5NWnNtaUY5RGhpRlhWcTBKaUE3V0tjSTE5?=
 =?utf-8?B?N1MvRnVkOUQwd0pNcDFOQm1Xd3NXMUdlM2xCK3VrU1c4QnVqZFlZUUZWb1Fv?=
 =?utf-8?B?WTJSM0hDYUVIK2pHUUVLYWlOK29lTGRHanZPRXY3TG1CTDNJWERlaWw2R2s2?=
 =?utf-8?B?Vm5kMXBWSGwva083SXlvbS9BY09JT1RiME84ZEw1UklOY0dQaWtnaDhiR25B?=
 =?utf-8?B?aEMrRzROSVh4c1ludGRaODJzeW1RNWxiTzJibjBtQzNqOWYwdk8yRWUyRy9j?=
 =?utf-8?B?Vm5FNDd1dkdhVE9XOEUwSi9pOGF3R0J4b1lpRlZqVEVMaDhkOGViZExteVU3?=
 =?utf-8?B?VjNtVHNmc3ZtbWJ0YXc4YnQyUTFqaTNNdUFTb2lBZEp5bWJsY3BsdW9JUlhK?=
 =?utf-8?B?TUtLR1N0dVI5elVIenpoTE11KzhzSFk2OVVjamJPUHNNNXFyN2ZZQ28rRXIy?=
 =?utf-8?B?bDVFNzJwdWdsanBLNnNCMHNtNG1DVWZPUFZHZzAvL0xGNWcwVitpUnNDSHRr?=
 =?utf-8?B?QXVORWV6NlozRExWNVdaUHp4NjRZUVJndDRWYXJwMUVYMFNrdzhhd0RBMVEw?=
 =?utf-8?B?Y0hQOEEwSmxTL2ZocnNBOFpRSlRwUkxyL3NSRi9SdHVuVGpnRi9mUExXdDFq?=
 =?utf-8?B?K1cvYlF3OHJ4OE1kbXgrRTBwZTlkSjgxYjNBZXA2OEMrUTZ1cUIwVmJDK1R5?=
 =?utf-8?B?T0FnV1ZVQkE4YXdXaUplZnYyTmlBZXdERFp3Y0R3UFpzQlJBMFhDTndGVGRR?=
 =?utf-8?B?dGw3a1BPRFpkTkRYQ0pDQzVCVjJYdEhIa1pvdFkvL3hIR1JyQjk3QjBRc1JJ?=
 =?utf-8?B?S2JUQWdqOGMxc2YyTzJ2SjhnTWw5SSt5SUJJb3ZJT04zTXpFbkhBSkpPaStF?=
 =?utf-8?Q?qjUW7YPM72wY23nkh+hKWlq/w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7502e2e5-df70-4e8b-0467-08dbf6eb77a7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 06:12:19.1561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQVzlLxHTny2Hff+d4UCEJyQ/vFffnOLfDL3ZF+n/+/CL0vpuFRYpaTinRwKT8t3Sjvvv2awyUtgnYqXVj1cZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8172

On 12/7/2023 12:15 AM, Dionna Amalie Glaze wrote:
>>>> +       if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
>>>> +               return ES_VMM_ERROR;
>>>
>>> Is this not a cc_platform_has situation? I don't recall how the
>>> conversation shook out for TDX's forcing X86_FEATURE_TSC_RELIABLE
>>> versus having a cc_attr_secure_tsc
>>
>> For SNP, SecureTSC is an opt-in feature. AFAIU, for TDX the feature is
>> turned on by default. So SNP guests need to check if the VMM has enabled
>> the feature before moving forward with SecureTSC initializations.
>>
>> The idea was to have some generic name instead of AMD specific SecureTSC
>> (cc_attr_secure_tsc), and I had sought comments from Kirill [1]. After
>> that discussion I have added a synthetic flag for Secure TSC[2].
>>
> 
> So with regards to [2], this sev_status flag check should be
> cpu_has_feature(X86_FEATURE_SNP_SECURE_TSC)? I'm not sure if that's
> available in early boot where this code is used, so if it isn't,
> probably that's worth a comment.

Right, I will update the comment.

Regards
Nikunj

