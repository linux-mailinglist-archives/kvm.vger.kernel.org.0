Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CA46B3A59
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjCJJ0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCJJ0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:26:12 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5794210A29E;
        Fri, 10 Mar 2023 01:22:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSj7Yl+WY0IsgNJzOtP3PnaP0aIIVe2mZLf2BF1aJyBYR6spe681SRBSiwGmPNkpBrxMxINQZL24syMlwddsyHpxUWtaNjsqPqOkxMpGcL+rg8OChlNvP/dv2BS9hDncCUadlAY76POWUovN2s0NTk7L0eMEliqCwNWKGyG3LRHilHB9KUGPrTBN9XPzsaMYxSfDHMZnrpmyRBETYVxMclRl5w0By41xxDYYFZXrgrAfzw4bPfDY9MpVKeAt9RV8wuxIUkkw6tsLt5nZZsdXZpEQnVqsmzWJMb5IBlPLTNI29gfc/6Ho6n45c5gQVoJCe6roewngy2OGVRzPedQyCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5Nkd9UDfKaYvEGLKE5/KVc5pl8YtxjSGJWm0vswc9Q=;
 b=l2U6L40p4jIw25gOxvCvgpk3/vb2fWeOEdj7qQXUJn1LIbapDNWbccdm0+VKm3HRorIIylhTAEG1xbE4bde2UI0Q8v6Z25snxEXBfDq/6KwmT6jMktWQlt7A+jJGLDeaUC01tMyg32ENYzyXNiF8A0YZJFPEiDS7KeJy2LbKmxJfxn8Us9au7Qdm9F8uFQu/j1+7qcWaLL+GvWfX2d4m2naFJSjpklFnUGm3siruSA19fLAPs3bFBpoBPTL7YtaImwT22PlWCwOimKwJTVes8AKKg0sVE/RWqZMyig1ITCJy69gtgLq317miJrVuPQ0S1aeDLFb4DI839lKN+gB3cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5Nkd9UDfKaYvEGLKE5/KVc5pl8YtxjSGJWm0vswc9Q=;
 b=HZXNmCPfkrReaBqi+DlsugXbyJNcHPrUWZJyfty2uenIXnBvLdRX2llWPsvU/NT4B0/xFdAs3D5hU0lxw3+Mpk0mZwyg0HOh3pARtIZl/8AKm6Kuyys7FY1j/f+Beo20TlDdW28UITK3cDDvh2m9rcR80GNpA2pI6bSz5bjOvCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Fri, 10 Mar
 2023 09:21:12 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f%3]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 09:21:12 +0000
Message-ID: <7b763dae-e6c9-c269-2675-907430bbf21c@amd.com>
Date:   Fri, 10 Mar 2023 14:49:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHv4 00/11] SVM: virtual NMI
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     kvm@vger.kernel.org, seanjc@google.com
Cc:     pbonzini@redhat.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, mail@maciej.szmigiero.name,
        mlevitsk@redhat.com, thomas.lendacky@amd.com, vkuznets@redhat.com
References: <20230227084016.3368-1-santosh.shukla@amd.com>
Content-Language: en-US
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0003.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::8) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a0d434f-8849-45b5-0839-08db2148ca32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qTfgtYry4TSveV1rg8hio+6bpVv+O9WwRf0vMWP8SDnMgew1whtAy8YYfzoAqI7UNJ1MJC9yR5QO5aDMOVtNbnvHgWUFgdePJm7jLhIQqAyMMHg8apIZvVLT8AxiYoKb5vbsF8HsvHPmrrFyPb1XGBlg1c+KmWNTyP9CIH7P4fbieep/VyTL8DPtQMdrRJoTl+RuskvI+/5BWpunfiXbKI0w4uQoHzayko56A0GiRFmvnVFupzkHrkxDBJyzO1VPFOI22SkMdbWlklpAQtT2llQ0Km1CrPXyl57Vlr9AqUweanZ8rppBHiDAbgVCmwGJBk+x8B/LXs3JBQcGImNn8mXSgsIroBStiU2Yp6MrlPJBlsHiXQo7vCq004soLKo39060XYXciyjPMlTQHeKGd/TAg0jvV+OmxERRQdUv1ZiHVXK5bkuRK0wsvjtZLw93TmHoTQe7ZMg3aD5klOYqUEEZ5QItf4NZXA+9bqdFTLfi7p+iWLuMaIVuIuw0T3eWlFrx3l9CCuzcyEc+w+kuLP+rADaZVFoDtqlrB6+XnfFE1Fd55kC/5uZ46AuC+L0I2sJ86kqmJMsz1NBSEdLQNkDNKwvLUMuH2cFXhdssDHtxPmCKSI5mJ0iCpTpP7r/SCED33GAm9hYQKXiTEgbyZkVH0O5CQyWJUJC5WXp0wykFaEvUZWK/M+ST6U13NYRx5qddUM9Frh2HxT4DwAzVRlPfBFld1XFf1q9GBMtSwQlQiM2CdlCz6ltL28rlD1QCmlAgpoqaMGYQYUSfrYT9Ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199018)(36756003)(83380400001)(186003)(31696002)(8676002)(26005)(41300700001)(6512007)(66556008)(53546011)(478600001)(2616005)(6486002)(6506007)(6666004)(5660300002)(2906002)(8936002)(66946007)(66476007)(4326008)(86362001)(44832011)(38100700002)(316002)(966005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHFPd2V6N3ZqaThXb3ZRQ1d2OWNBVG5wYjNWLzFkVXMyR0lSdzVseGZDS29D?=
 =?utf-8?B?d3IyRllTSTZCQWZPaWhvM25rVnQ2c0ZyUm9GMlBnQU1RMVJJd2JWWENWbVRk?=
 =?utf-8?B?dzlLaWMrd2R3RWZsMkhGZno1R0pyaDBCZ01SRTNVQU1EYjlnRVRVOSt1cWxS?=
 =?utf-8?B?SGZ2VWk5N042a3ZURXhva2l5MldMTktyeGtpWGp5TGlTZjRpMzFVa05HcnZm?=
 =?utf-8?B?UEZLb3phaXM0b3BTTDMxcWdWWmQyMGU1Ulh0a0tVUzZBOE9nVTh0SWF0Tmh5?=
 =?utf-8?B?cWNVVmZHM2xFaitYZzI3ZlovdUlnRmd0dDBlb1pjN1VzWmpjZnZaRWJxelBv?=
 =?utf-8?B?NExwcmFzbVNqUkZSUHFuYmFiWElqSEMydjVVSnJuTlNRdGNxbVFyTU9BUDM4?=
 =?utf-8?B?d1oyWFdZbWEyOHd6RmhOMGhmWjlVYkZLZ3pVSnVybmFNOS9WbXBNTWFzVmdz?=
 =?utf-8?B?c295bmVQZ05aV3ViS0RRL3NBWjJzZ2ErcFJtVTNKNHhGYVpGNlpvRGdNOE1q?=
 =?utf-8?B?TkVPMlRiQlBYdkhWTjF4QlpDa2k5YzJyeC9OeTFrRXJGTnMrM1NoZWZBSnQw?=
 =?utf-8?B?bHBLQTRWVkVBMlZuWkFiMmlCdHVYL3MzN0pvaXJFcjNnenFMMVhXWmcyZmZp?=
 =?utf-8?B?azVMUDFwTHdlbk5TajJQT0JINkN1MzZySGN1MzMraW1ZRDdUekpoYllwajlx?=
 =?utf-8?B?V2tmN2RGVGxSMlhTeXZib2lheWZTMTlVWWxoWGduODVCMzUrTmM5RE9BYTZT?=
 =?utf-8?B?MXdvajUrT2JNM2hzbTYzYzRoMFgvTVp2U1BlbFdJSm54bnQ1cCtWOEJGNE9R?=
 =?utf-8?B?UXMrSnlXdEZTNFd4OHRvTmY4QWFqcCt6L3YyY3VtZDJ2N2ZwanV2eTBYVTRR?=
 =?utf-8?B?WmNrVzhHYUJrNWxySy91U0tRS09OU3pmNUtsQVVGaEdDVkpOZ3JaNC9VSHc0?=
 =?utf-8?B?YlliVVJuZlUrZElWcTlsaDRmN2hjNDRGMzc3dmp6ZjY0TStKamFCNFdRejZC?=
 =?utf-8?B?RE1adSsybFRzZmtGTkFpZ2RHTS9jK2hTWWZ1cVY2VXhGbG42T001THJCMlVN?=
 =?utf-8?B?b1BxYVB1blp0Z0dKa1pEMGp5VTdQdHpoY2VIZUI2TFdmTUJFZWtEdjhnQ3U0?=
 =?utf-8?B?aDUxTUFIQU1vN3pERlNwTXpPWFAxSlpuSTJxK2JFQUJsQmtYdzV3MUlxYUxl?=
 =?utf-8?B?dW82S0p5eFFoVmk2dWUwVy9HZFFoajRKS2pRWVNPOHNjdDNpNVBUeGlCejFH?=
 =?utf-8?B?NEx4WHV3ZEVPTEVVWTNUWm1SWlM5aHlvQnRybmc3VmQ5Wk41eE0xMzdBdFpU?=
 =?utf-8?B?UTh0di9uczI1WXhwQ2puU2lxWGpwQWxxbFl6WW5CZXU1WGZ0cFdtR0NrcHFm?=
 =?utf-8?B?Q1pQaHFENHFkd2RDc2Q4Q3ZSVmt0dU9UMit2S0JCWnNabFc0N3U1WUxjL2Vi?=
 =?utf-8?B?elFDQXRZaXFqYzBDQnQyaW5NdzF3M3ZrTmxhY0xXaVA3TDB4TWhYS01JYzJU?=
 =?utf-8?B?WjBkZks4a1hsdjFKY1ZILzVwV0xsYVAyZExzV1FTMnpSMEw5YjZhcndUR2VY?=
 =?utf-8?B?U052dERyV1NlcVdBeVBOWVZKWHdsV3QvOUFWYWFZSERsTDk2cDFOenVFWlY3?=
 =?utf-8?B?UWlqR2xhWm9jdE41TG9zM0NGTDcvSjRpZFpYdTVOVmhIcnR3MCtnOC9vbVpG?=
 =?utf-8?B?eWxzeE9GWTF2UkpTM0FTZlIxOW12MVBpbnEwV0ZCWTNjd0R5emcxTVl4VUZl?=
 =?utf-8?B?bURSOGRsc1RsS2ZaSENEakEzekdCcDZUaXRkbm5nNEhqQ2RMc2IxbnljSUI0?=
 =?utf-8?B?V3IwcGZKeG5uVHM0SlV2dkFONXBjVCtsUGV3T0p2Y0FHTDVzQUVVWEVoUlJ6?=
 =?utf-8?B?aFFhNmdnZWQwakduQW5pa0xpZ2ZBWkh2aFpIMkhuSVI1RXVTY0lRbUo3ZFZF?=
 =?utf-8?B?TzFoUXNaZVlFREZPZUVBVHE2RVZuZ28yU0E3SGFvMUsrZVZzQUt0SS9ycXBU?=
 =?utf-8?B?eitUaVpvVXM4YS9PNEN0K1RoVVYxQVJKdkRtenA2VEk1Tzl5K1pheXFJM3FJ?=
 =?utf-8?B?cHVKVkt0bDNDV1NiMm1PbFhJNVlKdTFWa2VtK0czRFhDS3VLclVLREVnWWJP?=
 =?utf-8?Q?w050NY+pYW8td54/xsXy0y0aW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a0d434f-8849-45b5-0839-08db2148ca32
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:21:12.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dc7/e+RDpj+Hx0tDRRxBs5pnIEBRg+f5KIlDrIKP8QhAcICTEhPyQQTpLFo7niWrwHt9ixNeOGYL5n/ruMRvnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/27/2023 2:10 PM, Santosh Shukla wrote:
> 
> v2:
> https://lore.kernel.org/all/0f56e139-4c7f-5220-a4a2-99f87f45fd83@amd.com/
> 
> v3:
> https://lore.kernel.org/all/20230227035400.1498-1-santosh.shukla@amd.com/
>  - 09/11: Clubbed x86_ops delayed NMI with vNMI changes into one,
>    for better readability purpose (Sean Suggestion)
>  - Series includes suggestion and fixes proposed in v2 series.
>    Refer each patch for change history(v2-->v3).
> 
> v4:
>  - Missed sending 01/11 patch in v3.
> 
> Series based on [1] and tested on AMD EPYC-Genoa.
> 
> 
> APM: ((Ch-15.21.10 - NMI Virtualization)
> https://www.amd.com/en/support/tech-docs/amd64-architecture-programmers-manual-volumes-1-5
> 
> Past history and work refer v5-
> https://lkml.org/lkml/2022/10/27/261
> 
> Thanks,
> Santosh
> [1] https://github.com/kvm-x86/linux branch kvm-x86/next(62ef199250cd46f)
> 
> 

Gentle Ping?

Thanks,
Santosh


> 
> Maxim Levitsky (2):
>   KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
>   KVM: SVM: add wrappers to enable/disable IRET interception
> 
> Santosh Shukla (6):
>   KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is
>     intercepting VINTR
>   KVM: nSVM: Disable intercept of VINTR if saved RFLAG.IF is 0
>   x86/cpu: Add CPUID feature bit for VNMI
>   KVM: SVM: Add VNMI bit definition
>   KVM: x86: add support for delayed virtual NMI injection interface
>   KVM: nSVM: implement support for nested VNMI
> 
> Sean Christopherson (3):
>   KVM: x86: Raise an event request when processing NMIs if an NMI is
>     pending
>   KVM: x86: Tweak the code and comment related to handling concurrent
>     NMIs
>   KVM: x86: Save/restore all NMIs when multiple NMIs are pending
> 
>  arch/x86/include/asm/cpufeatures.h |   1 +
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |  11 ++-
>  arch/x86/include/asm/svm.h         |   9 ++
>  arch/x86/kvm/svm/nested.c          |  94 +++++++++++++++---
>  arch/x86/kvm/svm/svm.c             | 152 +++++++++++++++++++++++------
>  arch/x86/kvm/svm/svm.h             |  28 ++++++
>  arch/x86/kvm/x86.c                 |  46 +++++++--
>  8 files changed, 289 insertions(+), 54 deletions(-)
> 

