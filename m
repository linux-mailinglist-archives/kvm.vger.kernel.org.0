Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38090549C10
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 20:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344756AbiFMSrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 14:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343652AbiFMSrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 14:47:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3DB5713C;
        Mon, 13 Jun 2022 08:10:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IljUDjX8okk3de65w1LevYq2Ak7NgBJEhqAOWlhiaAGLVec/oN4Z9B6wr6fzyKkP+L16A3mQFVFO+oDeh4laOtUiBwy6/O/eScQwRgxrm/GFZmIOfY/ENRflzIQ/6sVMbxlrGwmxThhdEZ+FF2zvgaahG7PLE4rTVr3HDw4wO057Cuagd8L/R192Yq5jFKWoDeSHXPIqEBLEltu7BXhVKVj/Ra8Y71fFixNhgoVvbpDpoJ7BtahAXr0mFXFNqy8wSQ6Q7BPmmr2Afxq4BQt3DbsEH4SwhtGvbf9DFq8UheZfFbhiuVug6Ph9JlzXC6WHQKWStYY4HLYLHtE2VelrnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXS+h2+s/nD9LehVCgCJPCCmZJylzpOiOE4xXsqAkGA=;
 b=iTG3Dnt9dfP8D/v5XXPTSePBFlCagXyrQ0jHMLQj1FR+oCywkPHHJq2YwJe2vaUzKXhv1tosMAhOfTjP8nxTtndGX1LQc+zM6DynauAkz+yUSyiyrtnZEp09AY7J8pFezP5Q/UUuhdoSzohxHdCAH37xUGYq2JiSNdfjrm+w1Dla+juTJ21kyRq7NKB+sI/8/CdnZiGSgO0ENsmmvVNpqXBoQlzWMOcsUHwgGC5JSIsCk7clDkfuoIiWCpnahAh3TRZgiomie/maLP1GmknMTKG2iPH+MQs1Iv/BXaMNS7NOjgBms8vKG6G5CBgM0ERmCGrXvT4K2XY6yhkgPNEXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXS+h2+s/nD9LehVCgCJPCCmZJylzpOiOE4xXsqAkGA=;
 b=DlcmQVIEiiw8egjc9D3Vk37K6VWRRIbmu2Z1a6vWJu9JZVeLD7zSM7OgCChNDPilWU2Y3/NLsy9MxNdP/7M6CO/VUve0W5zTIoTU6A1v2jhbHfFri4rwwHHlnUqcFHSvxEFgahxf3O/3UlrAHqLL1iFzRtScdCw5JCrmrTVdenQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SN6PR12MB2781.namprd12.prod.outlook.com (2603:10b6:805:67::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.14; Mon, 13 Jun
 2022 15:10:01 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a%4]) with mapi id 15.20.5332.021; Mon, 13 Jun 2022
 15:10:01 +0000
Message-ID: <5d380b11-079f-e941-25cf-747f66310695@amd.com>
Date:   Mon, 13 Jun 2022 10:09:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, fenghua.yu@intel.com, tony.luck@intel.com,
        wanpengli@tencent.com, kvm@vger.kernel.org, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com
References: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
 <161188100955.28787.11816849358413330720.stgit@bmoger-ubuntu>
 <CALMp9eTU5h4juDyGePnuDN39FudYUqyAnnQdALZM8KfiMo93YA@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CALMp9eTU5h4juDyGePnuDN39FudYUqyAnnQdALZM8KfiMo93YA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:208:120::19) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57ff602e-34b0-4c1d-103b-08da4d4ec94e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2781:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB27811FA2F64BABE10CE92561ECAB9@SN6PR12MB2781.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KY5VrCN2YMjy5YmRs46IDpDfmMecZErHULQlwOV+IqK7RRji/jdJ1Fs8dqnqtGu82HlFFNCdhc/x+VwU/54In4MqMePmbaTvTvgQqPzaNWD2TjbWoZj9i5OPuRUfixSwFDDtB3sgBgQANr+8Yf1MKwftUHDew2GgWBs6gqo98k92H34pwlo8yROBjt6zU54ez2azqGK15PUsoyzS1YT9TsDUu6CNIzg0AHM+ZNI34A2GnZVl1rbg0Zu6+PVrBdH+EvwqtuzzCP9xBiiZgPDXyAUi2voImD5edbmFp675+8VfL7a2BLP0MrJehr7eTiirhz9jWqneslTlD4dfN+W/MtOncvZUYRzHc8QF84zJou+gZ7mnzvEYn4xuX0LZTOUng7PhlJg+TsGH3ej+zG4pMys5nEeEMaiZps+yND2VM4bbHKzKnWq5cAKInHAq3lW6BG6FkVZcj6vErOzfjGY5rCPIBapNxonRCRFY0vNGMEYlDvx22GTSc/NwbqQaKiy4zYMcUPO+b6oAWtc9q7a8yx7Jnrz+YzKLc9o/SnOTABzLWOG7c5oJiGqg4ijyGI8KR/ei0pRGpJniyniWP1cg3oASrSRQKEUCVv1wqXctCA7kcpewZ1y6NF21wValRgQpf+pKyIFj4JlYeAMMhjfqO8TK6dSHE8uiEFLqF2jRsDjHt3ROUttWauAIqrZt8Nt7M/gPamNBPk0yFEJy+mh2h5wk+9w/Gu+VgO2RvO83Uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(6666004)(31696002)(2906002)(508600001)(186003)(8936002)(26005)(6512007)(5660300002)(6506007)(7416002)(53546011)(86362001)(6486002)(2616005)(38100700002)(36756003)(110136005)(66946007)(6636002)(66556008)(316002)(31686004)(66476007)(8676002)(4326008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU01R1BDL3ZnT3pPclV1cGpoa0lKblFneDhvd2tRbFNVdEtJQk0yc01oQlhx?=
 =?utf-8?B?UktEcy9ncnlMMy9xZy9aaFZBM0NwTXhDUzRianpRdVVpb3duY2p5SCtzNk5y?=
 =?utf-8?B?bXJZS01udi9TRkllMkt4ckF3UERnSmRoanZTRXFLdTlaSUNjZ0liTzBvTVFI?=
 =?utf-8?B?QzE2OWZkdXBWZ2laTVJEcmZHOVNGNmwyVGdLNE5EdTl4VytNc3FsWmZuWHJJ?=
 =?utf-8?B?Z1plY0U3YVZUYkxOZXBMbU1nTEhtdFdNQjBJOGJzS1lJbmFVVlJpSjc0RzNa?=
 =?utf-8?B?MGpJekFzMC9tUnI5OS9KSUc5Z1pjczdHWGZNVlpCenF1MzltU0dwb3Rtbytq?=
 =?utf-8?B?NW95R3hYVWpEWWw2cnRNOE5FMUxQUGJQTDZQbWZYd0xDaFV6VGRZT3M0MGM0?=
 =?utf-8?B?Um1WVy9rY2NiODJNbmd5WmM4NXNVZUJVZGJWUVJXQzZjTmFQWVl5bk5pSVJW?=
 =?utf-8?B?QTRRZkl1NVZSdzhRZHdVZEZjVEp5UWJ6b1EwazZha1pCUWJwcHhCZmpxN2Fk?=
 =?utf-8?B?T0dPNXMwbE1ZejFWaXh4TDd1S0hDWFpleFJCTG9SR3dqNFRQZHZwMjJqWXor?=
 =?utf-8?B?b2xLQnZIT1MzRk40KytJcWg4eUw2aDZydlhpK0ZSNGhVY0gwd2lYUzRqeWNn?=
 =?utf-8?B?ZTFzOFVvaVVab0VRZ3Q4VkFCcFRqKzhPRTJzdVVpdThZaHdlZFFSWS9ZSFMx?=
 =?utf-8?B?eDlkM0JQYVhZUmJ4c2pVd2VUVXpDZ01QbTFJN3Q1bGJHSkk3SmZqZDBMSHRU?=
 =?utf-8?B?azB5OFJvU0dGNHMwNTZONkVFVEJjRFpqQ1pIWXF4ejJYelNGeWpTRllqWWVv?=
 =?utf-8?B?QllLVDBlSUo2dktaREt1THNDajFhelpnaERlRzFBdzhnN0d3dUxoRWQzTStv?=
 =?utf-8?B?QjlxQXlaT0ZCbVkyN0RLeEhzV2M3MFFlTHhUR05uNkk5Rm9Vdm8yTDlQang0?=
 =?utf-8?B?SlhIOGRrdEdLMDJOdStld20vNjNZU1VuSGNlcE9uVFVLck8yVnZmNFFUczl4?=
 =?utf-8?B?VFNzbDVxeWc1QmNyUnBLUXduR1JURWZ5a3QzZllwdC9RZlBDemhPT0t1eENY?=
 =?utf-8?B?SXlrTE92RTZ4RFFWaEVxZ1YwbjdFeUY2eFJudjloajg0SktnV0grQVFRRmFj?=
 =?utf-8?B?UEQrbk44Q2tad2ZOSUxISkdpQmowT3pXeHNDZ1hiWU5GcDJTc2xld29LYWh0?=
 =?utf-8?B?SnIvV2l5WFVtNnErN24vM29rMVZ1d0M5TFEwM0NkMG1keDFDZk11NUp5bklO?=
 =?utf-8?B?MUlYb1hyTmVKa2NvQ1VKeVl0R1ROTnZUWVM2WXFwUW9qaUgzY1ZZTU91ZDNm?=
 =?utf-8?B?aWM0VFF6QzFiTGFicG0raG5FT3ZnQjQwZUgwWUxMWS9wVGFnVFJRWFJTWWxp?=
 =?utf-8?B?OFN3SkJXL1pxWFUyK1RWclBadU1PTW85eFY2ZnVSME0zVkI0UzBKeUtqTE5n?=
 =?utf-8?B?TlZlTXVXSmpCSGZyaWlOL04xVzh4c2VocE1pWEN4L0F1dStNSm1NWWJuMVl3?=
 =?utf-8?B?dG5aUlZZYWF0VWM0MkZreXNNZklzeXNWRTJSTiswUEdxRVhPNzhEUnpSK0ZZ?=
 =?utf-8?B?MDBxYlVKOHZNWGh5ZzFzUmlQcWJLT1liMWxCaGwxVnRKTVlCVGlGK1hLZklq?=
 =?utf-8?B?NHFvVE5EWkRuZUpKVTV2ZFBmN0J0c0JtZW1ROVdqQW8vanZsd3daZk96S2Zs?=
 =?utf-8?B?VjQ1TlhoalZRZ0h3WXVydUFseDhGdGplUjc1USs0L0VyMU8rdTVydUhUcyt6?=
 =?utf-8?B?cUlTZTNUY2M4dFJ3RTVpMmJCa1VpcVVvdGc3QTRiUVRMRXcwWERlckJqb1ZY?=
 =?utf-8?B?QXlMQWJpbXV5bE96NTNwWFhMVHdOMHFNMjk4RlY2VjBDOE9MbzdSNHd5TjRM?=
 =?utf-8?B?NnV5cjFXZ2Y5NVdLNXVrV0t3MjlQbEVnNnNWUlRIMW16K3ZHQXpFZ0VSaWdm?=
 =?utf-8?B?NEwxN1p2M21GRTAwNUlpU05MRnFvWDNPOHk3SElKWFpPUE5UOVlsWWxBaGlv?=
 =?utf-8?B?U1BKVnVQSnpybDJPU3BVNXY2RzRjYjVKbWJ3K0pwN2hlS0lUTEVBbUtpdkM5?=
 =?utf-8?B?c2xOaDFGMS95YUNFNkhUU1hkZ3AydWpWODV5MEpweUdkc0l1YmdyMFZwbEIv?=
 =?utf-8?B?SWJtOTdHSTZ4VUFkZ2pKWk5SbDJOckpiMGw1TFd3RHNXU2JOai96TEhGcjYx?=
 =?utf-8?B?ZzhKMzc4UHBaT3NzYUpFT0dzKzNkc3VwQmtlYXAxZ0JEQUNidTlDbXJIeTcx?=
 =?utf-8?B?aDR6anYrb3NUR2JLdjQ4MmRhUlpvNlFHN0dHbkd3QzkydEpVMW1iZmNqZVBj?=
 =?utf-8?B?Tnlpc3l5alpvN1F3WTFLcXdiWGl6ZDBLSThhalFzRWg0N2ZOOGZDQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ff602e-34b0-4c1d-103b-08da4d4ec94e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 15:10:00.8814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +pccdHiynLgHNurA3t/7BTkvv2jVdUcEAuNCWIiIE/WelDVV4KoF/F0Zd5B2PnvQzjT7eynlsKRRqRwdmZx9mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2781
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 22:11, Jim Mattson wrote:
> On Thu, Jan 28, 2021 at 4:43 PM Babu Moger <babu.moger@amd.com> wrote:
> 
>> This support also fixes an issue where a guest may sometimes see an
>> inconsistent value for the SPEC_CTRL MSR on processors that support
>> this feature. With the current SPEC_CTRL support, the first write to
>> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
>> MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
>> will be 0x0, instead of the actual expected value. There isn’t a
>> security concern here, because the host SPEC_CTRL value is or’ed with
>> the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
>> KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
>> MSR just before the VMRUN, so it will always have the actual value
>> even though it doesn’t appear that way in the guest. The guest will
>> only see the proper value for the SPEC_CTRL register if the guest was
>> to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
>> support, the save area spec_ctrl is properly saved and restored.
>> So, the guest will always see the proper value when it is read back.
> 
> Note that there are actually two significant problems with the way the
> new feature interacts with the KVM code before this patch:
> 1) All bits set by the first non-zero write become sticky until the
> vCPU is reset (because svm->spec_ctrl is never modified after the
> first non-zero write).

When X86_FEATURE_V_SPEC_CTRL is set, then svm->spec_ctrl isn't used.

> 2) The current guest IA32_SPEC_CTRL value isn't actually known to the
> hypervisor.

The hypervisor can read the value as long as it is not an SEV-ES or 
SEV-SNP guest.

> It thinks that there are no writes to the MSR after the
> first non-zero write, so that sticky value will be returned to
> KVM_GET_MSRS. This breaks live migration.

KVM_GET_MSRS should go through the normal read MSR path, which will read 
the guest MSR value from either svm->vmcb->save.spec_ctrl if 
X86_FEATURE_V_SPEC_CTRL is set or from svm->spec_ctrl, otherwise. And the 
write MSR path will do similar.

I'm probably missing something here, because I'm not good with the whole 
live migration thing as it relates to host and guest features.

Thanks,
Tom

> 
> Basically, an always-on V_SPEC_CTRL breaks existing hypervisors. It
> must, therefore, default to off. However, I see that our Rome and
> Milan CPUs already report the existence of this feature.
