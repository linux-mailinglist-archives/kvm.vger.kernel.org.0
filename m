Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEA96440F8
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 11:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbiLFKI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 05:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiLFKID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 05:08:03 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2075.outbound.protection.outlook.com [40.107.96.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970D727DDF;
        Tue,  6 Dec 2022 01:58:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amrYRfhjJAgGKlRYg7BD3GgBPFjNBkFGUA6Awuq7jbXQBk2OMQCMDHE4RszMkXipBjrVtET0j0OqLugtfdAhun8N4VF9peHZypcDAcItHuWlXiUeRfPDTyXO0raImaYPDqC45g04lLxTMQ02Uz9IMeEoU5KtWpcZpQcK2tRuc7FPqi2G/QTLybnXZ2I2I7M3xdDoYjDlR9M6B49AxPcn6DJPHaM4Z4hNDIknw3oUZCKpqln6v62Iy5JDCdsgkyFSuwGhc2W/0gHY5Geyy4B/g4sgtr+5Ki6wF+PiQOSm6S3HvYUEI2GAIAHdq0sMVxT9E0pnJq/VjVcqcNoPmMrXGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mf3Jtaskdlv8ch96/V8upsdzNVD3+uNy2BVCuFu9w1Y=;
 b=dhlU0ErMOe8hdGal2/mfunnLVSKlREyH7k6PS5hFZ5srpPwI6MeO09K7QtKkauGP/lv64qbV0TzrQCgWCf8n21AuO49LbCQwyosIUs0/8fVg0tgnzBi6om6avCiB+lpIJFutZNs8b9yUzFvypnDf2uhwhFgxt+p0GAUklL7UKjzrBspY1THiuo6ojAvGUBdDeS0E0w0vnLQqSN1f96qgOF9KiOJ5wmoit7QPCFstH7An7xqv3V006/p3F76hYfmUzZcJzJ74hYXY/Mv3e5WYe0gU8QbopFBVq99gf7q5MEJBHFe2d+GaQX3IxtGnGqXWZimMRkHVA3sz7BUrAW6G7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mf3Jtaskdlv8ch96/V8upsdzNVD3+uNy2BVCuFu9w1Y=;
 b=az6BNK2C+fco4Fs4QyuQnDGmX4BVFF0QYoAI6v/C9azxN7JteFof3Fx41buKfOXfwsEq6gNADladjw7d3HXO9FHcGrJxkS7JTebhYN5NkX0kd8tYmtPlEW7ATADP2SYlWOLvWgD9rx6VeXukb2bDEPFLziUePltNR15wIAN1ISg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by IA1PR12MB8224.namprd12.prod.outlook.com (2603:10b6:208:3f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 09:58:36 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%4]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 09:58:36 +0000
Message-ID: <0f56e139-4c7f-5220-a4a2-99f87f45fd83@amd.com>
Date:   Tue, 6 Dec 2022 15:28:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 00/11] SVM: vNMI (with my fixes)
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Santosh Shukla <santosh.shukla@amd.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0034.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::15) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|IA1PR12MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: be71e3fa-dee5-4c0c-84c9-08dad770703d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TUEnQoGlHhPccnDm16csKH7hNOurEQw+sB6Vi2NxBZe8G9vS042SkwG3LpidIn6ZXgGXGv+tQJQNK6ioG/B0UsE2Ykjz/QUY+7xYKOKDho1Owv5/tfj4i8BRJVSxgAsGMb5HOsSAydyCNUtvFlcN9ZwrNe3cMZEfuzonUJfiRXNOuhXytt11cStOttXHU8cURZSFC6eC6IPQg4HqdJeCRHnCKJZpruLRUoDeVNqdutc5+WiPiXWWT5grs/JhtcViD1/esRJPAgPMOIbFXq3oaemDEc32zLhgY1Gx5ReNzVCUL+2gdebFJSgZ2xLtnxvgOGnoeDVVjo0wKp22rhQY1hmaRauqetKMImMVFL8QtOR2XrsTPs14at3FSL9I0z5YAlYgFxhl43VA5TjwmzQVDpTJ++cjKpkyuCVFnta87gCY7nOtV3BpwpyW9w0z2rChWwdHbHKDhqCul/aj2ElCPnYDVHVEiqNvu564aCCY25Jnv56ah+GfJWu/IeoKzmvcfI4/0ivnamN4Ht1Xyl7K5+xJV2MCg8TDTscSMjAHaa2UZo+9e/K8sZ2QxInNFZIPoVB8OE7hdjPNiq7COoxZcT5bosRsDk+t0NbsfTGvbAaRSbJ+u5PI2aV6r3ZN6fynLMztQR6FPcJYa4+2tXc9hbacTMqd8UQH1edloC/grwZUYNEKoB0rjS5X4OikzGlHvWxvgMRjw9E7V6F5RLXSk1VNs+A7dmrnyVhpY3wR2Pw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199015)(41300700001)(83380400001)(6506007)(8936002)(5660300002)(7416002)(31686004)(66476007)(66556008)(4326008)(6512007)(36756003)(2906002)(316002)(66946007)(44832011)(8676002)(2616005)(38100700002)(31696002)(6666004)(86362001)(53546011)(54906003)(6486002)(478600001)(186003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXl6MHNVYTZsM3pFY0M2cmZtSzg5ZGFsN2JlZFNXSThrcjdNSUR1Y0xKajRK?=
 =?utf-8?B?eTlaV3FYbiszNlVxUlZrTTRMeFlUT3diSjBIRzdha1RGdEYyQjZnYlJSYUtU?=
 =?utf-8?B?dVU0dUhKQlRFZzBEWWdrTEZqK3hsWnA0OU40Uk4reVVJa3JsaEtXTE5ESmNn?=
 =?utf-8?B?VXVGZGdXSUh4RGdPS1RCa25jbUdFOEdzVU1GeTMvVzk2TDJnV25uQjdUajVQ?=
 =?utf-8?B?THZTNXNnaVFpYlBEODdxZW1KWVgyZmZMOVlRS2JWczdwbkZiV3pFRExkMVJx?=
 =?utf-8?B?bXFRdGNML0NuVTRrcUVzUWJpWmx2WUVTQ3FpcDg1aUJLd0tGaFN2SllhZURH?=
 =?utf-8?B?U0F5ZDJsU0h1NDdoSjkzczdielYwYkZXUEpEZnFpKzlmUk9VTGhrang4OS9i?=
 =?utf-8?B?NFdnb0VEV3NzUG1yS000T2lDZ1pTV3d5R1dFTFRrekFJaTJyZHVmZFhyMGV3?=
 =?utf-8?B?YjNHam91KzhOMVplRnBHOGtQUG5EaWdHd0l5eHl1L2JtWXRHUGFQRWZiSXlY?=
 =?utf-8?B?S0EzeFg0Yy9MUzhHZFB1Z3k3UFpGVlQ3SEl1VCs3bzhLR2tScnBIQ05IOUZ2?=
 =?utf-8?B?OExuNVN5MmoyY3IvUlNER2FWOEZqekh5UC9lcXN5Rlc0YzhrVUhORVJYZlhR?=
 =?utf-8?B?T2FyRlJvcmhSbXVmYlFaTzhlMmxlcjhYQ2N0c1lwbGlyUG9IdzdTZ0FYS05M?=
 =?utf-8?B?KzZUWmFMTmxKeTZxM2NLdDZabGc1MmxRVUtYUUc4NEtzeEE1Mmo3YXZodnFl?=
 =?utf-8?B?ZkRoZ0xRY2YyeWhVRVovQVIxR25vYysvUE5uV3NDQnNxVU1wOUtKbTZMVFpi?=
 =?utf-8?B?emJtOU4rQ2ZtVVBzanNHdjRIQVhJOHNYbXBkdnBwbW5SaU1SakpESzBqNmdH?=
 =?utf-8?B?TEcybFJENTZEQkFvWmptb04xU0FkL21pSURzdjJXVHNJdlZTYXBYd1QrR3Vq?=
 =?utf-8?B?Vk5ib3ZtTWxZYjVyNWtRSXlkOERrUE9xR0pZalV4Y09VemU2YkI2TEhCTVU5?=
 =?utf-8?B?Y2pjQm5lcmYvQzE1MVR4MzhxeEt6MkdUS2pIbzZScWNMb0lic2JpNjJwbFFQ?=
 =?utf-8?B?ZUR0Y1puWStKc3VHNkNSaDl1Rm1ZdkozSGh1d0laK2Q2WjBmNUsxZUNDUW4y?=
 =?utf-8?B?MmNQWWFjQWY1bHBrWGcwRUhBMXh6U2MvbFBhajVGcWM1cVJTb25NREtiUGNs?=
 =?utf-8?B?V3dkQmNaeDVKS3M0YVFJRmJOcWZRUk5OMnNEWUVDSzlNNGxkTGhTSGlNanVh?=
 =?utf-8?B?eUMyYVY1WHpxekgwL1p4dVZlOWpLekZpZzNRNjFxQmprTW5wSE4wK3o3Tjds?=
 =?utf-8?B?UU9sei8wL0lXRHdqRFl5cXcvb3l1UGg4elBUZ0JrQVFBRUNzWmZvRFRZNGp0?=
 =?utf-8?B?Z1VkeWtkbFVFaHVVa3puNjBXSlR1ZDkvYVZPQmV4bWp0Z0JMV1FTcmhYMzRN?=
 =?utf-8?B?bnYyQUgwY1R2NkxjTHluTHJCSGRmTk9keE1GQnh0RlV4ZDh1N1hUd3ZXWW9W?=
 =?utf-8?B?RXRPaWRjazBxdWdYeCs2R05BQkoyN3l5R1BCZ2FONFBvOG13a1krcmxwa0tP?=
 =?utf-8?B?UU9EbVBQWmpXakF0NGtnSktjVzdLaWxaQUh6Qzh0T2RONEd5UzRtclNlWVV1?=
 =?utf-8?B?eFV4eEZNUVhER0JQeVlOV3kvL0o2VzV5d1lUM2hxd2xnQ0dUSEZSc3hIVEFQ?=
 =?utf-8?B?MXBOMnBZb0tIZG9xMk5xTElCNVlIbXpoVkc5bkxhdEdMTmd2d2dFRXI0NStu?=
 =?utf-8?B?Qk1oN3VmT3B1cFpRdjdsTU5jYXp6cVFHQkdveU9iL3F0V2p4Zk5QWk43V2Fr?=
 =?utf-8?B?OWU5NDhDOFpaTCt6VU4zRlJSWWlrL1lXcTRZV2JFYS9oU3JQcDZsa0VuZ0p6?=
 =?utf-8?B?UVJrWHFKVXRLZTNoZGQ0VXpJNjM1Tkx2dnY3eDcxcG15UitBT1NmWExlcHFF?=
 =?utf-8?B?QWUvZjFSZ2Zib2tVdnNzWXJjVWJ1QzQ0eFpHU01QVDc1RWI5VElDcmtwZ3lR?=
 =?utf-8?B?RVRLSzVDZmZSb3YwbDdZRklVbCtUbzJCazJhQXRoY09ycXhPcnNLM05ybEJl?=
 =?utf-8?B?MFJrTWdIbEs5ekg0enJvZytsY2dNMGZXMzFzcjkzZlZJOHo1ZkpYSDQ3aW5z?=
 =?utf-8?Q?/nl5L/GOrsgalg8uI0DRd9bfs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be71e3fa-dee5-4c0c-84c9-08dad770703d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 09:58:36.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82gJ2hr388U7deQUgX03aQO1RJ9dxy2TlUhDoJTpB+lDJ49Wr3Mt4jYc+BhJJuIv1zvo9Mpw5UtMF5Lw/2U/Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8224
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/2022 1:07 AM, Maxim Levitsky wrote:
> Hi!
> 
> 
> 
> This is the vNMI patch series based on Santosh Shukla's vNMI patch series.
> 
> 
> 
> In this version of this patch series I addressed most of the review feedback
> 
> added some more refactoring and also I think fixed the issue with migration.
> 
> 
> 
> I only tested this on a machine which doesn't have vNMI, so this does need
> 
> some testing to ensure that nothing is broken.
> 
> 
> 
> Best regards,
> 
>        Maxim Levitsky
> 
> 
Series tested on EPYC-v4.
Tested-By: Santosh Shukla <Santosh.Shukla@amd.com>

> 
> Maxim Levitsky (9):
> 
>   KVM: nSVM: don't sync back tlb_ctl on nested VM exit
> 
>   KVM: nSVM: clean up the copying of V_INTR bits from vmcb02 to vmcb12
> 
>   KVM: nSVM: explicitly raise KVM_REQ_EVENT on nested VM exit if L1
> 
>     doesn't intercept interrupts
> 
>   KVM: SVM: drop the SVM specific H_FLAGS
> 
>   KVM: x86: emulator: stop using raw host flags
> 
>   KVM: SVM: add wrappers to enable/disable IRET interception
> 
>   KVM: x86: add a delayed hardware NMI injection interface
> 
>   KVM: SVM: implement support for vNMI
> 
>   KVM: nSVM: implement support for nested VNMI
> 
> 
> 
> Santosh Shukla (2):
> 
>   x86/cpu: Add CPUID feature bit for VNMI
> 
>   KVM: SVM: Add VNMI bit definition
> 
> 
> 
>  arch/x86/include/asm/cpufeatures.h |   1 +
> 
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
> 
>  arch/x86/include/asm/kvm_host.h    |  24 +++--
> 
>  arch/x86/include/asm/svm.h         |   7 ++
> 
>  arch/x86/kvm/emulate.c             |  11 +--
> 
>  arch/x86/kvm/kvm_emulate.h         |   7 +-
> 
>  arch/x86/kvm/smm.c                 |   2 -
> 
>  arch/x86/kvm/svm/nested.c          | 102 ++++++++++++++++---
> 
>  arch/x86/kvm/svm/svm.c             | 154 ++++++++++++++++++++++-------
> 
>  arch/x86/kvm/svm/svm.h             |  41 +++++++-
> 
>  arch/x86/kvm/x86.c                 |  50 ++++++++--
> 
>  11 files changed, 318 insertions(+), 83 deletions(-)
> 
> 
> 

