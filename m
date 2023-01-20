Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47D567524D
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 11:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjATKYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 05:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjATKYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 05:24:11 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6548C91E;
        Fri, 20 Jan 2023 02:24:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbFJvrfQOfyiVJWW9p9VcjHT/4aqbMSz3BOFnh80qsyr/Q2rZPfEK6/LbP/RZUpeCrnJDnCcn52x4GZEUqhzRa+ZVGV2Tfm/fcUkuciJyy/UehFuf2jDSNxMEfOSthyDHZJQqn568Vh0AqRdVQ6coE2uBzw9eHlMCEcAcqUl7dEanVFmTVyPhDB8DLDo+pM9pQ7oV3F4sAtwmNGRsDwBze6MCa4UGWS58WY22QE9RxOiJVrl5wNFwdglRx2fXBkizy/dwD0vSPEhrCaQy2CF+pJbxAbHNvex5zZgMeLkBRS6WWQipDVSQmZG70zLS/cS3LDiul86FIcIyeDxldBB6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvbrBGIbYVm5p2M8slIaMdZtbxKmYbwlL4pGhvtN8u8=;
 b=ecy4bGIi/xLpdzd+0CUo0gokxhqAJ/umoIMYHLBxb7wIZZQSLHoM9ouXtch+cA7yQSzYr94Y8ss+1agHfoMeymQExONW/2cVjeVSFmTVYrN32EFML9uzMciQlASR9ygKtcs/yjchCHtWLqAn25lE7uM3NxYK/g0lLYqi8/aajLtZRKuf6iBhDBVw5rGcKF5eH6RgaLjxOD9npZz9wSHUJtrLpghaSKQCBifXvzcddZY3rt8BeHm3dHYbj7VU56mRCdToVDQ7UnFZJkuyZwUQPCNFBBphdBPVp8GU34Ilghs74hD6oURHg620VUHKrpvvtb7BNSG2CYX6t2TGEiJ56Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvbrBGIbYVm5p2M8slIaMdZtbxKmYbwlL4pGhvtN8u8=;
 b=LSOyPmTZoN63d6ZgjxqrHFv01OFGAaDfzH5/km4NCpDVDzPFYthl89UNKbKHPSFg6mqzWHbhn5Tde+lO+iiexQTvVcBHFa7u2Ll9CDbqPItBLhRLHGeF6cBmG5LtBGFNTj0cmVELaRgrRGEDwBNzXF0Plmwuu/HU1ToxEln1pvQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CO6PR12MB5474.namprd12.prod.outlook.com (2603:10b6:303:139::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.27; Fri, 20 Jan 2023 10:24:05 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%4]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 10:24:05 +0000
Message-ID: <533c5c83-b68b-eff0-d36d-9963194ab844@amd.com>
Date:   Fri, 20 Jan 2023 21:23:48 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v3 3/3] x86/sev: Do not handle #VC for DR7
 read/write
Content-Language: en-US
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-4-aik@amd.com>
 <adc11ed3-de89-a389-e629-3c951257469c@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <adc11ed3-de89-a389-e629-3c951257469c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0079.ausprd01.prod.outlook.com
 (2603:10c6:10:110::12) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CO6PR12MB5474:EE_
X-MS-Office365-Filtering-Correlation-Id: 49127259-f9b7-414e-a185-08dafad074f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qIOvxF99OArDDwFQ2giTROoZAPevStijgSuHkYRBj8Dcz4YdSggP4hHt4p+/GO1Yl6EXEe5p2J2ifM05DgIi0Ld69dEH5CnQEnMnw/DBXPV4+4o0fqyFy2O7xpKww+kkzW0eL9ZiLCwhFFcDCH5wjp5LlzZjg0CoD/ikxghUGhA3UCU5Kisdm8rdeKVAjcZnBDODDPPbeNq8Q7JO1ohG1UPUI3f6fIZhdVsavMJxmcwQwJIN0Wb/ObDk4yluS6M11+VVtlkcC1NjEJohMNZSVodUcTToQ/ws34gqwBP4Jiir8IyNeRuFsUzAud0lZSQ65sc6YsDB+ck7lJYSv9eJNjPqDTlgTrhehXjxnwZ0PcY+j5dIse0tnw06PyPkSc5OPidKpeGIRc1opN50rhTV72ERrPYRyHUdxJZ4FmonV0zLSjoIaBN4A8gGT3FebdUXNCTt5TfiqYQVk61CMtJjBGUsQExzJ5jd/ygXZDRKEwrH28j1aflMMp9GdLRyMXYhZsLdzsgcLeRphm+0CPyVDmkTfCRDriOJ+2UWdsWYIGiqv7HJI+ozWY6chEG7A/kYNP3kNmjM4Qn+E3B2492ZeuS2O64MJCetuIP9nP+9pvKnthz4ErNIxYUdXxOjEnacWbmDEb3yUvuBkohdWXzfgIdLYetbnYJkY4LRopeK5GfTsTzvDOXcccIwlN3GXIPwe6QWYoUNyoPpiDGq5E+fdrueGYg8Jrakifgk63mg08+vrPyN8cSHT5TRm7E6wcnwJjEFHGgiUtBWGmI1SMYnMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199015)(26005)(2906002)(6512007)(186003)(6506007)(6636002)(53546011)(316002)(37006003)(54906003)(2616005)(6486002)(966005)(36756003)(478600001)(6666004)(38100700002)(31696002)(83380400001)(41300700001)(4326008)(7416002)(6862004)(5660300002)(4744005)(31686004)(8936002)(66476007)(66946007)(66556008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUdDWGRjMXJtUUY4blhMbXRMU1FsMzJIWk5aalo2ck5pVk5MaGpIR1VpMHIy?=
 =?utf-8?B?MmNtWXlxSk5meTFBUkRlSWk0YjdTZno4cWJqNG0vQ2pBRFRqNC9VSmp2SEZH?=
 =?utf-8?B?MUowbUJkSnNLZVlvN3JESGpBQjZObXBpb04rWXhpOW51eCtodEhWNUJVWHZV?=
 =?utf-8?B?QWdjaUxlOHdTRXNPK0hMS0UwbU1IK3RwSTVVclJ3S3FTc2NjSGg2U1Z2andG?=
 =?utf-8?B?QjdLaWlCQk1IRENNeUp0S0pWUmxQNS9ndWNnNDVOdTJ6LzQ2ZHp1Y2hQT25v?=
 =?utf-8?B?UzArRk54Mk1YcFlZVmtQa3lqS2k0U00yY0ZmS1htSlluVFdvYllodSs4TmNN?=
 =?utf-8?B?TDNPZlkzN3JuQzM1WjJZeDRaSlVKNHVHYTZLRDVpaW1Cak94Z1JaQUhRbDgr?=
 =?utf-8?B?bFBENnVIcFRNMjNiR25GdkFsQWRsS282MnE2amdqdGNOSzMzaGhEc2RsYU40?=
 =?utf-8?B?RklNNjdpVEJXVExmeDcvN1p5MmdscW1wSFRhVGJETU94czhPcG4vOXBwdm5E?=
 =?utf-8?B?d0xJWTBUZFIrczlmRE5XRjVoOVZ4Z2ZzT08ydjUydTBLZGtIZ25lUFN3ZDE1?=
 =?utf-8?B?S3FSUXpBaHI3NmlHMi94Tm55V2RqR3JHQWxQTmVwcVBuSEI4SlhnbXNZcEJI?=
 =?utf-8?B?U1drOEExQ0hZVFIzU3M1YXlYdzdtM3k2RCtlS0tIYnBLckNscllwUzNwT2hT?=
 =?utf-8?B?ZFBGMkI1RGhyZXBwR1F5VnRYdC83WG1OcFpOUEt5WnVEQkJ1M2Q0RUphQlVr?=
 =?utf-8?B?bnpiKzVKSlBUUDlESjhvcWVqbWtRdGJNR3dUanI2bkFCWmJwZmRWUXhodUwx?=
 =?utf-8?B?T1NYc01SbEFQT3BHN0FZMXc3d1UzMFF3am1nZGRBY09WalJBamY3RlBabi93?=
 =?utf-8?B?dktNU2hrWWJpVmYyTGdOOWt6SGo2eTFJMUJacDBhYnVpaVNGMW5KNkMvRTh6?=
 =?utf-8?B?NStiMXArcjFIcWg3QVkvUnVmano4SXFBd1g4OXR1RVBPeFVCN3JzWTMzR3lN?=
 =?utf-8?B?S09BVmpEVlBxUzlkOVJRaGlGd2s2WmYwUWgzZXU4cXRYZEUrWEMzN00vZTdu?=
 =?utf-8?B?NnRrcDVhR01lUlJTRERMcllNTFJJU2lmMFRiZjJ5eFhtRXJPSXF0OTdUNFFL?=
 =?utf-8?B?b3dwZGtMUEVaNGZUQnVoWGRpaVVPWEdlVVh4VjFqSjhZQzRTUmRhdUVkVGlK?=
 =?utf-8?B?QUtiVXdjZ1NIOXJzczNOajNTWmE3R3Z0S1ZlWHEwZUppUUN4STJRaGpWSTZE?=
 =?utf-8?B?Y0pKNm5xcjJNd1JmekF0T2ZoYTBzUFpacDRVVUM5OTFNUHdSd3hGSXhpVC90?=
 =?utf-8?B?cmEwVEJ3NW9PdGhGdUdETWVqUlEzMFM2T2NxVE1BVGtSSmhBcG15OTVSM041?=
 =?utf-8?B?V2NraGhPMEJlOXBrbkd0dnJScW1UZEdTWm41YTVuRW5wSWUvc0NSNWR5RGpu?=
 =?utf-8?B?UHozN3lKcm02dDAyb25iZkJlYXkvWHZJK2UrbE9yOXlWeHNQbDBLdzdDSHRX?=
 =?utf-8?B?K3g3ZEpSeGFMUkNiRjYrUFBEelh1V3ovQXpseCt3aTFzVy8zR1BpLy9Cdld1?=
 =?utf-8?B?SDQ1Z1VZUEx0Mi9mMjU5VHhPQU5pOXJHVWVLUG12SFRSY2ZGR2p6YnJON3ZW?=
 =?utf-8?B?SGxDU2RlK3I5SEFsN0lOSGVVcUhqVEREblp2ZVYvUmVtT2NHa0YrY2d0SWpX?=
 =?utf-8?B?azlmL0w2RW55SGp6MlI1a3ZsTTN5S3NjS09hWGdPVkNURUJyelBzQzdOUUpr?=
 =?utf-8?B?TzcyWC9RTS84eUtZTmRLelcvM2hiazVHem4xcTRrb21qTVN4bnlocHpqT2p4?=
 =?utf-8?B?ZzRudHA3b3JXN0VQdCttaStwcUcvekhTandNcUk0ajc4ZmJUcHZRYlkrbFhw?=
 =?utf-8?B?Yk4wMW1mVXl3dzRuVTN0dDBSMlRTUmw4RVBCdFVodmlxWHYxMEZnbEJzOHlR?=
 =?utf-8?B?U041WWhyQUNHMVBNSW1WQlZoOC84WFM2OU1Qa1N4M0l0TGlQMnBabWJzS0px?=
 =?utf-8?B?blZsOG14d2FyQjgrNlcvNWlqcHJsYTdhM2haZ3B5T0dlY09YNXpHQjhKekYw?=
 =?utf-8?B?TmJKcEtqWVRkZVoyVUZmaDFNVVI1TW51R3JEMzJsTVdndkRPem0wbk9CMjdu?=
 =?utf-8?Q?v0uFQMuCro1AxfB5Ocy7EjfeN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49127259-f9b7-414e-a185-08dafad074f0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 10:24:05.3883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0gRypqgK4pgJSv5LLlFQ6/Nir9Za23BiiTSW9FzNt4deZ+dBiXv/o04QVFNF7eogArWGHbribqmh/NJeucaGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5474
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/1/23 16:12, Nikunj A. Dadhania wrote:
> On 20/01/23 08:40, Alexey Kardashevskiy wrote:
>> With MSR_AMD64_SEV_DEBUG_SWAP enabled, the VM should not get #VC
>> events for DR7 read/write which it rather avoided.
>>
> 
> SNP guest feature negotiation patch is part of tip now: https://lore.kernel.org/lkml/167414649850.4906.1693185384677559889.tip-bot2@tip-bot2/

Worth mentioning it is tip/x86/urgent (which does not have 
X86_FEATURE_NO_NESTED_DATA_BP), not tip/master (which has 
X86_FEATURE_NO_NESTED_DATA_BP).

> 
> MSR_AMD64_SNP_DEBUG_SWAP is already defined. As this requires guest side changes, please add MSR_AMD64_SNP_DEBUG_SWAP as part of SNP_FEATURES_PRESENT bit mask.

It is MSR_AMD64_SEV_DEBUG_SWAP (SEV, not SNP), it is an SEV-ES thing. 
Why is that feature negotiation SNP-only and not SEV?


-- 
Alexey

