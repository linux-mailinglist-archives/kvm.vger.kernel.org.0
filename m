Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8EF6D9458
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 12:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbjDFKpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 06:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbjDFKpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 06:45:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2C7658B
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 03:45:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9zP+JmwPVynL1xK6dOv46vupmP1Jp4qE9565kTgN7+b74D/JlmWKaXEU+uqs2WDCEd2uKHLkIe9l9x7VNzOEU1rt2tatnqWU3quvq8+Ky3/Fv7iV5jtysZB+lu7YADdsBtEob8r3IVb9eyXdfPZvMAWBbzrPqhwPCpAM2PDYbybF2gSmwDb3sbY9ihPqlJ/BYzoEZVx/JDzi/QBpnj9SjKN5KDbMAqsn8cCFXizDiy7xS7SG7qL2HqM3xzWqEkmoY4JGMzRXjjvq+/tgREpDH0E8kC+OssyWaI+G3dZOLrtMU9hBXcIx0iqzk/ofI1Jrk3ygSIqgP6RFgvwAULDTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpZfhAZNHWp8DTXBpki015nMYjbFfGR9syp4KpwHsN4=;
 b=M6LztLY/Gqjjlcw7CkRo9hH47VUCjaGrFuOILqO6yp46jpq/XhR76PnwOD7P2+U1A7hSZ0ku/PSIsJ4sEXXtTFV+5L7Zk9iG86LFTcVrdXRfJmgIWC4y0qutIZ+wsKMZI6q56/KVEW8mx4qpo7idOzm8fCV0Bht+ZkksETkByI0/oyN1p+UTHtNrW7xs6BJbWdxzo2znFnmE1yikEwfvDfXPEURqinqqo37lQGoAtFgGjLYoN9E6BxCVHpTWalwhdw7OEpMz24cMwjRO63vaBJYP8AexEfbL35wKUcc+/zQq64gDdNxz7wrBLDo28tpBKIhUcyvcKGeE3/ENwDQ8sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpZfhAZNHWp8DTXBpki015nMYjbFfGR9syp4KpwHsN4=;
 b=P5fa9cQ6He11DXkY52xZpdxxc0FiGtaHHgwkXirt2AIJdpA23csUTTSw10X5gRLAENbchz8+15wSy756UgFyWvT2vojkrOKhO12HtxWOs9qRieStMk0mTnuh6X9LYSPdj+z4PBtWsZ5nDDXKzSEjN4HJoH0oAuz+VzySDor8a6M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DS0PR12MB8344.namprd12.prod.outlook.com (2603:10b6:8:fe::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.28; Thu, 6 Apr 2023 10:45:28 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::609:e897:a127:79ca]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::609:e897:a127:79ca%9]) with mapi id 15.20.6277.031; Thu, 6 Apr 2023
 10:45:28 +0000
Message-ID: <c1e99170-1a2c-8c84-e622-a10fd313169d@amd.com>
Date:   Thu, 6 Apr 2023 16:12:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v4 2/2] x86: nSVM: Add support for VNMI
 test
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Santosh Shukla <santosh.shukla@amd.com>
References: <20230405205138.525310-1-seanjc@google.com>
 <20230405205138.525310-3-seanjc@google.com>
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <20230405205138.525310-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::7) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|DS0PR12MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: e7249a61-3211-41e1-d41a-08db368c093e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O5CX6wdG4Fi92Bi/DVO0sO/boeMBK8PAhiFVlU/vWcCrvygyDlaWtgsrT0e8i1LPLXwhalt+Pv2msNCig9YY7ysFfNXsC1eLwai5iQNe8V0HTIqH8T4RW2zfrbzkA/TZ88CbmYNRGIWGprEMIxKV2yw4PKyatN3unXuQPkMCIitNdcarqt4icXjPlyBT7vgGpC4zETgn8x59dWSaMUJA1XU+4xn1hotLEpAmruvsADPPXicSdh+DrCA2Y0xamKSCJC/i1mMt6AsxAMDC/vqJs10Uh0oVTFSYMbwmHTvDtPSCrfw0+gFNEDoJg5vFcaCZ7Fw2kIpYfzihrqqOyHwedeQrTk2JLXSsNkBcqTzchiwhvaDwzTJBK2vD4ezHNwe+JDHHiivK1Xl3gYcZTN8oGsnZXs++L2uIl1wvB0imSJgu//Pn1af8U51ylF9KMiexDS3gYZIvsC8EDcdSyd9tOzEDMMRjoQyZTUW3dkuHywI/nvk0OgBAQOWfUBHALKqJBtjaEZRN/w2nH40CLXgUOJKpQusSefQLRRujLjAREcX8i4zMtP7spl0qEN3HWvk71o7Bmusg7kb0efMhIIff5KOV8wjmZcJQR9tHXGtz7az5xYFMqmd5xfh5PXm1wsgQGuVMzusBa1vW5LmgsIu9JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199021)(2616005)(66946007)(5660300002)(66476007)(6506007)(66556008)(478600001)(38100700002)(4326008)(316002)(8936002)(41300700001)(110136005)(8676002)(186003)(44832011)(6486002)(26005)(6512007)(6666004)(53546011)(31696002)(36756003)(2906002)(86362001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHpBUGJtTWxyck1MMlUzemJPL2JjVUUveHY2aVhERGFDZDBqNkNOTGdCRzZJ?=
 =?utf-8?B?Y1BydlJISFNncWpMRWd4UlFwS2dqMy9hcDFNYlBTZmdSdDdJNCtDTkVnMjE4?=
 =?utf-8?B?QjhEb3lBVXRGejBBSTA3dCsxaVpmU3dTUm5JZ1RkK0FwM2dZMnFaWTZkdnBR?=
 =?utf-8?B?VVEydEdhRC8zMjZsbGhXanl2QWVjclpJNXpzYk1HVDg1UTdNTFlFbGlDZzBX?=
 =?utf-8?B?MVdFSVFxTUtDTXFTNlh5WmlWdWgzbzIxdTU1bnF6Nm9BVFV3VmNKMTJTNk83?=
 =?utf-8?B?RDlBZlVzcWU5dkdzMHNMWnFjSXRPaEt4a1NYTzdGY0dreHBwSUNGaFZJUGVn?=
 =?utf-8?B?WjZDd2Z4TDRDVEh5QzZ2WFFwNG00UjdIckR1czZyQmR6MDM5WmZYNVY0UGpm?=
 =?utf-8?B?SHplMUhDM0ZEaXpjRm9qNEE4WmdQZ0ZXSlZVaG5hUEhQS3ZFak9mdnFrU0JL?=
 =?utf-8?B?NVd2SURjZjJzc25wSHNuMmlnVWM5Q0RXUFFOUTcwd0t4bTFDQXdTazl2SmJk?=
 =?utf-8?B?cFo5NUR4THNzVEkvMXFyNXIvQW1od2k5QTlqeGtZL2dsK3UydjhleE1MVjM0?=
 =?utf-8?B?YnVtQ2ZlNnpYVGNJTmtHYnFLcVRJci84TmMvZ2ZQQitJOTNBcWJVcHdLQ0JM?=
 =?utf-8?B?NHpmWGJNWmNrNWRhN1JKelFEVEVpSUo3MkYrRERTOXNnNXM3MS9hcnhraDVL?=
 =?utf-8?B?Rlp5WStCbEVDdEhpOWVpWDRqREJ5RmVieEw3a3luUGtvT3JkcXp1b3d0aUto?=
 =?utf-8?B?Sm5RVjFrckU1eGJDQ2x3STZJQmZwanprb2JZcDd3VkdXZ2pGOVZPSHZVREV6?=
 =?utf-8?B?L2VsUXlsMTRmWk80dHVsTGV3NUdDTlZETVNNYjYvb3hzdmROQ2hwQzlaWHZ2?=
 =?utf-8?B?TXBVYU83TFhlc1FOMXRkOVY3N3RsUjlhUytYMXIxYWxZSGhqc096KyszdEgy?=
 =?utf-8?B?TGFncnZFbzBCNmJ2NU9TMjA0VDdZMlZBZVR3blJZNEM4K0Z6SFVZZ0MxNG0r?=
 =?utf-8?B?clQzVG53UkdtSGRMSUdFNm5Gdk5qYzJ3TTM4a3UrMXd2a3ZOT05FWldpQmVO?=
 =?utf-8?B?TVV1Zm1XdHpCbjF3SFdrRUdOdWkxSDM1UFdKQ0R5NW9VeXZpdllnS0hoSlMx?=
 =?utf-8?B?SkZSQTVURkI1Q0x3UlN2R092M1ZraWxySC9HU3l3ZENsR1VSNXU5Kys0VUtD?=
 =?utf-8?B?elpEQmlNeVJaREJSalNlb2Fldmh3cEZqRUpqcEtlaHMvMmlRRlhxVUFXdUZp?=
 =?utf-8?B?SWdreENVcmRoMVM1enNaQ3UwdlV3WktXM3NrWE0zWUZMcXVyUVM1WlpqbXpy?=
 =?utf-8?B?L2FlcEtBOVJRcWt2T0s3L0tycUhpTUo1dXdTWE9JWU9GdFZ4bzdvaDZVYVpF?=
 =?utf-8?B?aUY5WWlvUFE3bU82VkR2UHQ1UW03RXlkUElsOWQ5bmVqOUMrcUZYa2NGOE1r?=
 =?utf-8?B?b3BUdW1JdkJnTVpKRTJvaGhvUHcrOFdud3FYQThwaVdqcTk0TDlQQ04wT1Zl?=
 =?utf-8?B?dC9wcDZQSjdYSFNsNHlob0d3YlowTXdTcm9MYmk1dGFWeDdJK1Vad2tQZStO?=
 =?utf-8?B?L016eCtoRllFK3hiM3dCMUJ2QnJOSnNmTXE4TXl3dEhSSGNKNCtTVWpTNjZY?=
 =?utf-8?B?SG51MXBWVWZoREVYNEJpL3JMU1NCSFg1aE1lbnlOaWYyamE0N01memU5WWkz?=
 =?utf-8?B?Ym8yclZnaGxTNE5BcFRyclZCamdERzZyRHpxL25mRWZzSUNXM256aHZYSUtD?=
 =?utf-8?B?YmpCczJPekxpR2FjdkMvSjZLdHdWcTZ6TmdJS1hEdmFUbFNIRStHVWp2Ykxy?=
 =?utf-8?B?WStiNEh2Slk3b2VXaGdJZW9HK2pJNVBFUFRnbGtRbjNXbkk4UkZFWVhtOHFW?=
 =?utf-8?B?SGxKeTdMSllBVFdJdlFzMVVmemdWdDBZMnZMUm5oUGhZV2VPTVJ1VUlYM0JZ?=
 =?utf-8?B?dFFGcHhPc1J0cDlZK0hIQllJZll3VEpSMmljTEpEMDNZTXhxNSt4NkZNQVNa?=
 =?utf-8?B?WmV5dmJaRzkreW95R2NPekZMbzVnekp4LzRoM2NLanFxdEZqL0haMXRiZkNm?=
 =?utf-8?B?cG9QTDlVU2k4amY4RGdTOEhsOEs1dnVrRUV5YlVDeU03WUZvZVAveTNQNmhy?=
 =?utf-8?Q?L7fuN95OAVp/Ya4P6T0T4RdZX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7249a61-3211-41e1-d41a-08db368c093e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 10:45:28.5071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gcrjJz2J1v6CPqCmjrV63LmU6fZcdRM4z5RP3hCDj+u5ENn7k3SN8yzthKODPpvyL+M63XKl1CfG6M8tFEBCfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8344
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 4/6/2023 2:21 AM, Sean Christopherson wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> Add a VNMI test case to test Virtual NMI in a nested environment,
> The test covers the Virtual NMI (VNMI) delivery.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> [sean: reuse pieces of NMI test framework, fix formatting issues]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Tested on Genoa system, Test passed, Thank-you!.,

Renaming comment inline -

> ---
>  lib/x86/processor.h |  1 +
>  x86/svm.c           |  5 +++
>  x86/svm.h           |  8 +++++
>  x86/svm_tests.c     | 78 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 92 insertions(+)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 3d58ef72..3802c1e2 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -267,6 +267,7 @@ static inline bool is_intel(void)
>  #define X86_FEATURE_PAUSEFILTER		(CPUID(0x8000000A, 0, EDX, 10))
>  #define X86_FEATURE_PFTHRESHOLD		(CPUID(0x8000000A, 0, EDX, 12))
>  #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
> +#define X86_FEATURE_V_NMI               (CPUID(0x8000000A, 0, EDX, 25))

s/X86_FEATURE_V_NMI/X86_FEATURE_VNMI

>  #define	X86_FEATURE_AMD_PMU_V2		(CPUID(0x80000022, 0, EAX, 0))
>  
>  static inline bool this_cpu_has(u64 feature)
> diff --git a/x86/svm.c b/x86/svm.c
> index ba435b4a..022a0fde 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -99,6 +99,11 @@ bool npt_supported(void)
>  	return this_cpu_has(X86_FEATURE_NPT);
>  }
>  
> +bool vnmi_supported(void)
> +{
> +       return this_cpu_has(X86_FEATURE_V_NMI);

ditto..

Thanks,
Santosh
