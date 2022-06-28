Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D2855C336
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243405AbiF1CHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 22:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243381AbiF1CHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 22:07:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25B324956;
        Mon, 27 Jun 2022 19:07:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3fQ5beIleeVBCXh3CLsg+CnVQusag5si9sy5rlAcr61UNPtuBQ0DD9gQrlkqA5cjEqpSdQ/a7N0NafUmk+liZFonblnL5gcbBLpIF6ItIL6yjCtPSWuRJQrltYJWUBIreY9Kk+LqGA4/C17ReYF2kpT28cdeiHhkxRYBLIGqJaAmj1vERcuThcLe1ZKnUaqZ7u1AsUPzIAUxa/BndC1ZHiev4JiShqw6qhpKFPGPnmum1pc+xW2ZAwvQGVhqYQO85+WDaYFJbvXbg4Uxuay4OuIWAlm1hsFxbO8+AjNFwAx+jChiHWBrxKwIdF0Ghj5RcTgm17D0/J3CyuupzSTdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1miGiCjJH0mlrKmQbgHIYoGLMop/FjiooM7ZrBLaJGE=;
 b=aEwcWKqn6J/OJb2HD07s1PBEN/TwzQFgj0L9VQTpM36t7ukd8hKq3Mnw2FoabnDSSDghEdjK4UxBRHgtA7GsmguwcvR3jHpm6E0t3skn/1qmbadfnd4xtESquaeJUgDxuIztxqAu3/vLVkYmVgig6KZmHt4sMz3Gq3X0jRmW60QVihEOi/2RQ8+lrtCPWODiPrGP3c6+U2dseSrJrmgNmKKOvPjr29bUTgBSAJFZ549+fTK1qDC1sVQgAXr2sJc110jD5Zw6YxdjtzSBrMsBTNr6sV8xor8pK1mkz8vRoc3IBSA+zeor6474LIG4qXMzfuSDep2AlFHTNOztsNwXEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1miGiCjJH0mlrKmQbgHIYoGLMop/FjiooM7ZrBLaJGE=;
 b=EPsJDHf0ClsSGfV1ZhsfUr1nMBII/PuR5CV9Qes0wIZVQhCCk9I94bYspKCSjFa8U8JwzJxKSpw7NJmJ0HBsU8BgvXzY+KDXK90/F1YhCMUFdgwkl5s7M/yvfgwFwzHdCts2suzviwymcIvEZ3+R0cOaOn3a9BCOias20uHg42EameoQtH0bS2cQZURs73xNShFP6zRkhuULHTfkVwEZlULmCfS/0gDdGAbuYQlioGW997lFGDN40LHY/KCH8bUm37S1nK9Sgw7erK8S5L2qYanHNA35Pi5f1daaRTSGpaEKuuibiPfznxuEHCp40Jc+NMRLUunzr2z5x6vayoI5NQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 02:07:30 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910%4]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:07:30 +0000
Message-ID: <c196a140-6ee4-850c-004a-9c9d1ff1faa6@nvidia.com>
Date:   Mon, 27 Jun 2022 19:07:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20220622213656.81546-2-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::8) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2244aa4-432c-414d-fdae-08da58aaf4c9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4154:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vz3XahR539UQm7UXJp1LE4AgKqJQicocjRh5ITTUdwydvpnpLte6KsBDQKWiStiR7AJx1vMW1miZES3DgjhGYJKM+4VRB57bmySMj5Xsm0NBgAWaAnDVIWywP9zRMHJmiftQSA+y09Rrxkj1kI2uV2Tl/m+vASpDbx0k3H/91L2CJZYb65Acb0ZtGSuYNdGm7Ytv0RiLn3letP03meoUswteqR40eUP6t4dDDyHgDgGfM6of83eP6d66D2OLg0mrtYgmw4Mmdo+z8TuLnnO9wnD3rqQyn7WIdE800fi1kYqDTmLvCBbPYABqc7YEX55CoPwe3YaerACq70uzqeK5iMnNggApm7GlXUf1eSOPwL6ABEZvZDBL0v3dbMmjA7Cw3MJCyC7EmrkMMl+F+RQ2nNF6REK+mJhg10n8ReVd1i1Yq0v09C1TNaxsyhuDihyHKsfzZq+T90LfIpw7m/aWtKxJAwkRqNxw3SSGb4/jGg22YkJLN4uXR4roGmNenBqw8P3Ca8gaODsQnmQheEg0EA/af0uMpDbwjPmLKFf+cY8ptE2HuC0vjCdKauDkLGnXTRu4wEIRA6FELZgUUcjaoen5QdCtLFoNWjK67eKVwD4bbkvMUGhXHCT/Cd/n221hK7D+tIpX5zwU4O40MR/esiTccI3Udg2pgxzg1koWu5J8kPxT32hPtiOGp/2jTP5sx88t5+ojFsiirafTz+qTG8vTs4Nsc7jrhYWhrecGqYzKP9hLia2VcEgS6sLSQAdHq95b/8lZs7flPp9zBTMowdBPcrYCxRctbaw95ldR6M+AB/i+ZQ56WsCdWgIn2ozT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(86362001)(83380400001)(53546011)(36756003)(31686004)(316002)(6486002)(2906002)(186003)(66476007)(478600001)(66556008)(7416002)(5660300002)(4326008)(8936002)(66946007)(8676002)(41300700001)(54906003)(2616005)(26005)(31696002)(6506007)(6512007)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0NVRE5vdkRUeUwvNXJIS2hoT3RXY3U0V284VS9Hd25Ec0t2Tm5jTTA3WGZx?=
 =?utf-8?B?NXdXNFdvRXNIcTBQVWNYYU5KUlRVQzZKdjZpQnRwYmRJK0l6SlV2Z25Jd0k1?=
 =?utf-8?B?Yk5IQ2JzS0tGajRyL29VZjlnVWNmaE1kRFBhaitxWlhaeE5Jb2JrRnlSQ2FV?=
 =?utf-8?B?dG1QU1lGYkxUMGxQTjliRUV0NnB2cnRib1A4NndrU0RGMCtjNGZVZUdMeGtV?=
 =?utf-8?B?a1lDS211RnlBT2JXN1B4VWFDUkUzek1sZkhNcmgxMmxxSUlLUWd3VXlWUmxz?=
 =?utf-8?B?eFNtR2xPYXllMGVTTTlGMEtzTjBjTjBDbW5QcmI3TWNKKzhNZFhNZlppczFr?=
 =?utf-8?B?SWdVNERlT0xTNXVkRVoxQUZuL3lDTmJmcmFPVEtnK0lmajdCYWtBR0RzcTN6?=
 =?utf-8?B?ZnByYTE4V1ZnT29FRmxaYmkyVEpiMjdKNzVkY3h1V21PQ0lmZmVHN1lwV3Fj?=
 =?utf-8?B?ZTI5Nm93Y09rOEhSUG9lNXJUVnBXMGs3eVBtdCtuTS9VT3BHdERhdlJ0Q2o1?=
 =?utf-8?B?T1lWQzVpeTU2Rjhqd2x3dkhUOFd5cjdJQnFVd1dMVGRrZGRXWWZlZXFCenUz?=
 =?utf-8?B?K1RZR0lud2tnUUNBSXJKWkxMUmtQVFZITTdRaU0waGxVeGwybFkraS9wWnZI?=
 =?utf-8?B?bkJMcE1hWHF3elB2MUl2bkZpbDhtcnF2T3NmK3NLSmp3NytKVmg5K1Z2OVp0?=
 =?utf-8?B?QnRPcElrbUM0ZE5aUExHMGtqQjJuOEJob2c1WTVQSzFDbEY5RE9uNWxTMDZP?=
 =?utf-8?B?TnF1Q3dvR01WQXRZUDBYbnJZVC8xOSs0b2lWTFc1YWtZNWRpQjNuRFhTTmtr?=
 =?utf-8?B?MUVuUEhUM1E3M3ZyNmxEdWlyVS9nMjlGRW05MDdmN3VxTTBWNXlZaThoTWFZ?=
 =?utf-8?B?TE1SWnlIQ2FGdkNJM0VxS1lQaXIzUzV3b01QNWVRYlp0azh1VWJtQmNEUk55?=
 =?utf-8?B?MnA0Q1VFNkt6K0JvZ1hPRTB3blcxdkEzZEl0VDBCY2h0b0I1OWxxczdCRzRI?=
 =?utf-8?B?OGV5VkoycFl0eUNvNHprLzVWUzMraW9kQnBRRDJZTTc3SGNQQ0lXWm1ZaEM4?=
 =?utf-8?B?bllIcWkyWVpydUhOOFJoVCtLa2F3ZmVBTEZkbUhFdUxseGVOYURYRGQybTc0?=
 =?utf-8?B?OUwrejFYVElYZVpyK3cxQkZHdm1ELytOSTZYK1NTZ1dCVldwemg5cWlBYzhW?=
 =?utf-8?B?THhOejk4UHlXcXVSM1c2Qlc0MDBrekg5WkZYM3BVbVlJNlQ4RHMyTkUwSzdp?=
 =?utf-8?B?d051SmNjZFZ6UURUNWxzcjVkUW9jVWxiTDdWUjNKWGpPSWduT3UrNW9mUmo4?=
 =?utf-8?B?N1IzN04zSVRFWUtBYi9oMFJ6VlZ4aVRJUVp4Z0FHdUVWQU9remJLSk9uZ05a?=
 =?utf-8?B?VWRJV2pkS2g5WFBsbjg2S25GQ2xIVkZUM1k0eFo3RkUrZ3hldWt4RWgrNUhw?=
 =?utf-8?B?Y2hHWWkrMGkwejJrcThvaEJnV1h0UXhKSmkzODhjOS9UQUw3R1FGNWNBTXdS?=
 =?utf-8?B?R0NkMHJLTnVkbzR5dVFiWEtXMUY3cnFjUU5WRGRiNWJVYklENEJmRnN5cnJ0?=
 =?utf-8?B?d21HSnRXM0FQaTJjcThyc0ZRaGEvZUFxdHQraUdxUTlNSzdqa25WTDFLK1lq?=
 =?utf-8?B?aHJhU1FUbnJzd0s4NXZaaUhwcW5ncTJoWUsxSThrRDIzRGdzcmdIM2tFcit0?=
 =?utf-8?B?N1JpYkxxVkpqYUtNSFU5ejFRYVNzcUdlNjN5dWZKSFl2QzhrRi9ycHNSMWhQ?=
 =?utf-8?B?Qko5VVlWNkdGR1A2YXRDUExZR1JLbTI2elloWjJYUGJhd0kyMU1weG9DTXgv?=
 =?utf-8?B?ZXY1Rm1QSzZjSlhDNXcvOWxRODA2ZE84MHYzWGdnenQ4VlF3UFA0aFpRTUY3?=
 =?utf-8?B?TG0vZHo1empNYVdodzN2YjVRa2xPa0NkUXh3Nzh0QkhaNnMzVmRNanczRHdn?=
 =?utf-8?B?V2RiN0p5R2lKREpYeXEwZFBzbThrWndhNGJ3SXR3Q3lneU9tS3dzMGQ0cVVI?=
 =?utf-8?B?SHJIUktYdGM4ZTZkSklCN0tlN0E4Uk5SbzE3YzZmL09KTWl6aG85VVRkUnRh?=
 =?utf-8?B?RjdEeFA4Um9Kb1BmSG81R1VYM2tkeGNldTc2MHh0UHRDeXNUa04zVVl6aVAx?=
 =?utf-8?Q?TlqaKZ/u7xdK6w8K2oug/A0WD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2244aa4-432c-414d-fdae-08da58aaf4c9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:07:30.1690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MF0yQWnK9uTFlwg9xs9bKuDl7J3x0fSnjIR3aW+eCSaxdX5oF8BNUA9XfSJI1q7wo3Qscq+p/qRIm/aBHiko6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 14:36, Peter Xu wrote:
> We have had FAULT_FLAG_INTERRUPTIBLE but it was never applied to GUPs.  One
> issue with it is that not all GUP paths are able to handle signal delivers
> besides SIGKILL.
> 
> That's not ideal for the GUP users who are actually able to handle these
> cases, like KVM.
> 
> KVM uses GUP extensively on faulting guest pages, during which we've got
> existing infrastructures to retry a page fault at a later time.  Allowing
> the GUP to be interrupted by generic signals can make KVM related threads
> to be more responsive.  For examples:
> 
>    (1) SIGUSR1: which QEMU/KVM uses to deliver an inter-process IPI,
>        e.g. when the admin issues a vm_stop QMP command, SIGUSR1 can be
>        generated to kick the vcpus out of kernel context immediately,
> 
>    (2) SIGINT: which can be used with interactive hypervisor users to stop a
>        virtual machine with Ctrl-C without any delays/hangs,
> 
>    (3) SIGTRAP: which grants GDB capability even during page faults that are
>        stuck for a long time.
> 
> Normally hypervisor will be able to receive these signals properly, but not
> if we're stuck in a GUP for a long time for whatever reason.  It happens
> easily with a stucked postcopy migration when e.g. a network temp failure
> happens, then some vcpu threads can hang death waiting for the pages.  With
> the new FOLL_INTERRUPTIBLE, we can allow GUP users like KVM to selectively
> enable the ability to trap these signals.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   include/linux/mm.h |  1 +
>   mm/gup.c           | 33 +++++++++++++++++++++++++++++----
>   2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index bc8f326be0ce..ebdf8a6b86c1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2941,6 +2941,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>   #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
>   #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
>   #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
> +#define FOLL_INTERRUPTIBLE  0x100000 /* allow interrupts from generic signals */

Perhaps, s/generic/non-fatal/ ?
>   
>   /*
>    * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
> diff --git a/mm/gup.c b/mm/gup.c
> index 551264407624..ad74b137d363 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -933,8 +933,17 @@ static int faultin_page(struct vm_area_struct *vma,
>   		fault_flags |= FAULT_FLAG_WRITE;
>   	if (*flags & FOLL_REMOTE)
>   		fault_flags |= FAULT_FLAG_REMOTE;
> -	if (locked)
> +	if (locked) {
>   		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> +		/*
> +		 * We should only grant FAULT_FLAG_INTERRUPTIBLE when we're
> +		 * (at least) killable.  It also mostly means we're not
> +		 * with NOWAIT.  Otherwise ignore FOLL_INTERRUPTIBLE since
> +		 * it won't make a lot of sense to be used alone.
> +		 */

This comment seems a little confusing due to its location. We've just
checked "locked", but the comment is talking about other constraints.

Not sure what to suggest. Maybe move it somewhere else?

> +		if (*flags & FOLL_INTERRUPTIBLE)
> +			fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
> +	}
>   	if (*flags & FOLL_NOWAIT)
>   		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
>   	if (*flags & FOLL_TRIED) {
> @@ -1322,6 +1331,22 @@ int fixup_user_fault(struct mm_struct *mm,
>   }
>   EXPORT_SYMBOL_GPL(fixup_user_fault);
>   
> +/*
> + * GUP always responds to fatal signals.  When FOLL_INTERRUPTIBLE is
> + * specified, it'll also respond to generic signals.  The caller of GUP
> + * that has FOLL_INTERRUPTIBLE should take care of the GUP interruption.
> + */
> +static bool gup_signal_pending(unsigned int flags)
> +{
> +	if (fatal_signal_pending(current))
> +		return true;
> +
> +	if (!(flags & FOLL_INTERRUPTIBLE))
> +		return false;
> +
> +	return signal_pending(current);
> +}
> +

OK.

>   /*
>    * Please note that this function, unlike __get_user_pages will not
>    * return 0 for nr_pages > 0 without FOLL_NOWAIT
> @@ -1403,11 +1428,11 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
>   		 * Repeat on the address that fired VM_FAULT_RETRY
>   		 * with both FAULT_FLAG_ALLOW_RETRY and
>   		 * FAULT_FLAG_TRIED.  Note that GUP can be interrupted
> -		 * by fatal signals, so we need to check it before we
> +		 * by fatal signals of even common signals, depending on
> +		 * the caller's request. So we need to check it before we
>   		 * start trying again otherwise it can loop forever.
>   		 */
> -
> -		if (fatal_signal_pending(current)) {
> +		if (gup_signal_pending(flags)) {

This is new and bold. :) Signals that an application was prepared to
handle can now cause gup to quit early. I wonder if that will break any
use cases out there (SIGPIPE...) ?

Generally, gup callers handle failures pretty well, so it's probably
not too bad. But I wanted to mention the idea that handled interrupts
might be a little surprising here.

thanks,
-- 
John Hubbard
NVIDIA

>   			if (!pages_done)
>   				pages_done = -EINTR;
>   			break;


