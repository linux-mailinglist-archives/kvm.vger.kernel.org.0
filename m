Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69A250EEBD
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 04:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242242AbiDZC2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 22:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240656AbiDZC2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 22:28:20 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7282B253;
        Mon, 25 Apr 2022 19:25:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lW9CYn31Fqg+H4z8FLx+qQEXlbv48xKNKd4QUXTteJY6Eml3l5qOCxUlflTO18V5nypllVZeSZaCB0tQMmXAjLux6/sjKX6vZ3DRb13SLR7DEkTPXI4n9cwjCazBNRFKpI+EeI3LInhUwu3JtnM2W1pbH/kyaxoZKfhhLTF+Myuf9cAP23O2HJg5iA0W6fSax6SpvsHIjImNA+xZ+7rux7iPi86uoc0xj/fvBfXFUt+tw7Hr7cYcQKyQ6d3dtHfqjXzZhTmG0hNx+ZGc6OZ3EHcyFhQ9SYQvpLxF+RwwSQMohPNTvDXvf+xbJ5xRukIS68XZo8iLHk/4qtjyTBqzFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dH6JV6B+0qR7V4+ferqg9nUMaQbIk2dcOjuWjki2i4E=;
 b=N/dxHNqo1uFDn+b14p1vEAcYaE9ZhQFXtUNT+EDKLIJ9WA9aDb78gbAYNWjZLg1CkY8D/PklH2si4q7YO9fUCPyQ2YGke7IsuK08jyEqkTp/PhT9fS5/qxDu/I56yk719rPZSocLCl7ySbqhXpOrMjOqzdFOe40hgD7jovkosj+FbzxtBYeYcxhtYS2eR67m/O54o+mpjEPuQgU30FI6FixXD5GggOXTxJ/vCg5uAeycT3g7S0Zf7TSXYK2OMiFE7DyiC3TEQpXCjzvQdEdaESb4ZywylukSnxbrqZ43MjP67lsHtCI6/yB58Z124mrBxGskQmUDtq/RfjoJiND84A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dH6JV6B+0qR7V4+ferqg9nUMaQbIk2dcOjuWjki2i4E=;
 b=m2b1ct5sTboJi31CGlZ3ZU579UWMdpAsCzMdVevflzcAypSGuwjIO8GhE583PNyyAFLXEiY2N4JmVKgq6UyvU2BrsmXG+EPUT7uffVbbQAf4Exaz1gHXaMkadPkQWy11UGRVOdoXKKF225eYSmeqVbCvE7gMiYiBugZg9vPXGcQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB4339.namprd12.prod.outlook.com (2603:10b6:5:2af::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.13; Tue, 26 Apr 2022 02:25:11 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b%4]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 02:25:11 +0000
Message-ID: <01460b72-1189-fef1-9718-816f2f658d42@amd.com>
Date:   Tue, 26 Apr 2022 09:25:03 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v2 11/12] KVM: SVM: Do not inhibit APICv when x2APIC is
 present
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
 <20220412115822.14351-12-suravee.suthikulpanit@amd.com>
 <3fd0aabb6288a5703760da854fd6b09a485a2d69.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <3fd0aabb6288a5703760da854fd6b09a485a2d69.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2P15301CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::21) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fbcc07a-0ffa-4729-dae3-08da272bfd4a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4339:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4339FB0635337E8289923F56F3FB9@DM6PR12MB4339.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: La7Naw9A07M5PmNktGZJ5m0VFKTX/8ZaRBnLn7rBCc5LScWcRQAmD96MZWzT/pg5+9zeq1r+cm45zr/V+g6K0arSWwo+vMrIYsL0CG/IZdkzRGVwOjHfMDe6VX4YJS5HPtz5T+nZCYS8KIMmr+VYVhk1VVkNK7hyfYQaoUno6vxAad/q5UDjpSQWXj0Z6eT1AboEDAnbmPoO2k5UEudyX/WYvcx1Z1YwX8IIcl5NGOHCG9rH+MIb9U/6QNF5lWnhhMmVdky/TViggKi+Wcz/pQlCmY1DpHR+KpAgh4OKoR2TlrszzuT8Y9g0mI3DZyX3/lotlVUPbBronj3L6jsHUWiehANYAx2Y3U65CKAdE9qInBYLMQC+/zVR6gWwmzODoaalCWCdRlp0U4Bm0NWG08gNACzVDWWMP1DN/vbp12qCsONiGhK3epV8wYvVKsjtVfcHF8G+rO/tNO9j8WSHVQWAJUz6TAraOerUZ4xL1Op7Xu4eoNMdVJu1bekFHGGeRkwfNkPfkwUYC9zrfZRbiICgPpYUadd3d+IeJVywe8qTW1ZhFdv4z/HJX/JRsVNKQpm+8jxiCyybwVzEgy6m6OBNOUl3TcEMvYZrdV/hVxUG9TT8IRLVhW3lmduMw8IAmc9q2Xh+j9mBI5/yxIc6xNheRfkugANBO03Za6kk3vOK2V6jeAuF89pMh8DMvFP5PKYO1TAEWk5bTS6AJwvqAAs8ggnO1/Z1Rn5JhyHjE3Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(186003)(6512007)(6506007)(31686004)(36756003)(2616005)(508600001)(6486002)(5660300002)(38100700002)(31696002)(86362001)(2906002)(316002)(6666004)(66556008)(8676002)(4326008)(8936002)(44832011)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmcrUHVETFFmUVZ4SGd2a2Zpd2h1SWpDZDJ6cEZ6RXZvRU93UEw0d0R5M0Z2?=
 =?utf-8?B?K0RqTU5HWnZhRi92TDhaZklPYlpBT2RXb1M1Y2Fjd1A2WFM5ZVVrMTNaMVM0?=
 =?utf-8?B?elphUVZzKy8yRjhRT0RHZSt3VXFaVXNhajNpY3VkQU9JaTcyaTFVdG5MZWF2?=
 =?utf-8?B?UDVJbVo2b3V6M2NENSthakVBZXgzdGlaMG1RaTF2UlRXUm1WQ3hqcG84Nmlw?=
 =?utf-8?B?T0ZUUWNWVDZyV3VKTGVXN3IwbWZQTTV2Tk1xbC9ONStvK2x2VW1hSVlUc0Rl?=
 =?utf-8?B?ZjZBeVdSd3JDQUFMYjJqblQ5WE50dGJsR3NLc2RhK3diaGlMMkNWTU1waTNM?=
 =?utf-8?B?dWk0WFRXOVdocVhlTGRDZ1RlbGN3K0lIdzBEWGl2UzlyZ3cwMVR0T1ZNYkJl?=
 =?utf-8?B?aGJ4TmFBQnBLbFd1dGIxRFZRUmNJZkN0VTZqdGJYc2ZKK1pLUFFkRlJhR3Qv?=
 =?utf-8?B?MHlYa25VT3lwU29uZUwzQ2NCMXo0UjZOa1BiakprdllOdkxhNzl2Ym92cURy?=
 =?utf-8?B?ZWZac21SMTJ6UVZ2RHh0TWx5NGJ2WEREQ3RnT3NKdWZmbU1lT2NhYWNydlc3?=
 =?utf-8?B?NlVLNm9WNXpRM0V2VkVXOEZ3L2Iyd3RjY3F1dnVzUHk4WjBWeEhxejF2VmVQ?=
 =?utf-8?B?Sm1ZR29DZXcvVXZIemNmZXVYaXptOHlFWEpKNkJ1Rjc2d1FyQlV2b0ZEeXZj?=
 =?utf-8?B?WmNDam95aHp5YkNLYjAxWm8vRjJsZHdnZ3piVnJRVjZrdGlEd3dNYjNFTXdB?=
 =?utf-8?B?ZGVRMkJDZHJoUkZVYlBibE05S3pHZmZjREFncG81VXk2WjVMN21ZL0l0SVNB?=
 =?utf-8?B?Nk9mK0xKbXgrZzhPakZHOFplQW9HaGpvYUFNTWlkREgvMHpreFU2eklCejNL?=
 =?utf-8?B?QUNkQ3VxRnpobjdKdnFRRFBYVVIwOE4xL3pQeFFjVkgzQWdhQVBpN3RiYzF0?=
 =?utf-8?B?UXd6cFdZamxKZWswMXo2K2dRU3R6TGljcExvSFdJYURqSVBtLzZ3clRKUFZ3?=
 =?utf-8?B?aWk3dTduR3FubWlSalpuV1YwOGNDYkEveFZuTkhTWXlzdnRwQ2ZYWklaTElT?=
 =?utf-8?B?VVBIekZrb2kvY1ZGd3hLVStra0pVdUV1RkJaakZpM2NlNlphQlZjMFJISjJr?=
 =?utf-8?B?R212TUNtV0RqYlYvdGZsVHc3MDNHc1k4T1B6RTdGRWNMeVBSckpyU1FCMVV6?=
 =?utf-8?B?Q2dVQzlPb3A4c3VjVG45ajEvRjVtdFM3bnFDdldjS0FybThlOEl6SHFaZ2VY?=
 =?utf-8?B?UTZtOWZLbThpNGtrUnFiY2dJM256MldWamIzSUppUGltc3BaZ3IyS1luOUlB?=
 =?utf-8?B?NForY1daM3VoVmRUem41bWNGd1pSckdLcDZncFJKek1Vd1BhTDNxZkluZ3lp?=
 =?utf-8?B?dHlrUkMrTFdZdUo4ZCsrb0NoUnZ4R2REQnk1S1NhRWF0OGN3SWN6Tm9PYlhm?=
 =?utf-8?B?U1VNakptamN0emF1OW9UdDJBYWxaaTdKQU4rUVJucmNTOWJIc1kzaFc1Z3Zp?=
 =?utf-8?B?ZlhYTkx6RUN0SzRxSHN0dU9qZGdESFNZdjdyTXRLTDZrTXVieEd6MXlpYmdq?=
 =?utf-8?B?L0ZKdFlNVnk3ZkkycmF1ZjBELy95MVJOM1FPL1pVUGYwWmZ2bzJCaEV5eVpp?=
 =?utf-8?B?UWF6RXdVVHRrUkZoQ3owSmlUNy9ySDhGaFFRbmF1RkdZcmtybVdmdFBtZnB4?=
 =?utf-8?B?RWhOL0RVUS9aa0NEUC82TzVRWnN0MjhXVkcyREtkN1g3Qi9uVHByYTd6LzVw?=
 =?utf-8?B?aUtpVUxGYmllMVA2bTgyWUZqazNvbHQ1Q3V3cHZ2NjRZTDZMRTRUZWQvcXJG?=
 =?utf-8?B?MWJtWmVuSGV1clRRdzJWRENDSWZ0by9TaXpxazdjMGd5S0JFc0VvQk1XdW5o?=
 =?utf-8?B?QTNUbnRQMi9XTXRKN3IxRXFOVGNYT3ZHdEtkaEZ4VE9KYjIzNTNBWFU1djhK?=
 =?utf-8?B?NnhxdGJEa3BucWJzQjRVbHJZMU44MjFNOW0wTm82QTRZbFkvanpFK0tLR2Qv?=
 =?utf-8?B?bG0rZ3BJMDNReDNFVkpKNXRXZXlpUFA1VU9uT3FCajF1RHlLTWZyUDh6eVZV?=
 =?utf-8?B?SEhIa1pveExWS3cvVlA4WlJBeEszdkMwbmNhNlhOY1ZqeERlRXF0ZXpzYmNo?=
 =?utf-8?B?aVBPRktJWldRdFhpS1NIK3RPVUlJUUtlTmZaVWVCZCt0YTBHK1N5cUgzZHc3?=
 =?utf-8?B?WUVkRStEWTFMdkdpaVdXQ3RDZFRtQit6SHhnNVM2Rlp5OVJlOTNjajdFZVRi?=
 =?utf-8?B?dVpRdG5nUHBLaEdRSnhLSFcrb2Z0UEo2NlZ0anA2ZzlBaU5FVE9IWWxLZHE2?=
 =?utf-8?B?Q2NQVXIrYk1BS3h0ZE90aFNTVDIxbkhOU0hOTkc2OGxDcjMrd0d4Z3RBQ215?=
 =?utf-8?Q?fZhVRsjQDcXejHaXw9DJ5jVANE6NRPOmnT9kXk6pBDUWi?=
X-MS-Exchange-AntiSpam-MessageData-1: dpxBoE5Kmh6YOA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fbcc07a-0ffa-4729-dae3-08da272bfd4a
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 02:25:11.6714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qhlSmnYG/fdkSNFH9o2ozPpqrzKgKKLGpqnroTrAyGUSPczlSggmyazftWilkFfdDSvKu9xpI7vKfiglOG0C4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4339
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maim,

On 4/19/22 8:29 PM, Maxim Levitsky wrote:
> On Tue, 2022-04-12 at 06:58 -0500, Suravee Suthikulpanit wrote:
> 
> Hi!
> 
> 
> I just got an idea, while writing a kvm selftest that would use AVIC,
> and finding out that selftest code uploads the '-host' cpuid right away
> which has x2apic enabled and that inhibits AVIC, and later clearing x2apic
> in the cpuid doesn't un-inhibit it.
>   
> That can be fixed in few ways but that got me thinking:
>   
> Why do we inhibit AVIC when the guest uses x2apic, even without X2AVIC?
> I think that if we didn't it would just work, and even work faster than
> pure software x2apic.
>   
> My thinking is:
>   
> - when a vcpu itself uses its x2apic, even if its avic is not inhibited,
> the guest will write x2apic msrs which kvm intercepts and will correctly emulate a proper x2apic.
>   
> - vcpu peers will also use x2apic msrs and again it will work correctly
> (even when there are more than 256 vcpus).
>   
> - and the host + iommu will still be able to use AVIC's doorbell to send interrupts to the guest
> and that doesn't need apic ids or anything, it should work just fine.
> 
> Also AVIC should have no issues scanning IRR and injecting interrupts on VM entry,
> x2apic mode doesn't matter for that.
>   
> AVIC mmio can still be though discovered by the guest which is technically against x86 spec
> (in x2apic mode, mmio supposed to not work) but that can be fixed easily by disabing
> the AVIC memslot if any of the vCPUs are in x2apic mode, or this can be ignored since
> it should not cause any issues.
> We seem to have a quirk for that KVM_X86_QUIRK_LAPIC_MMIO_HOLE.
>   
> On top of all this, removing this inhibit will also allow to test AVIC with guest
> which does have x2apic in the CPUID but doesn't use it (e.g kvm unit test, or
> linux booted with nox2apic, which is also nice IMHO)
>   
> What do you think?

This is actually a good idea!!! Let's call it hybrid-x2AVIC :)

I am working on prototype and test out the support for this, which will be introduced in V3.

Regards,
Suravee
