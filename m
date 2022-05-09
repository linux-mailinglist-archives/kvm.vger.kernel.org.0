Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A37451FE96
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 15:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbiEINpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 09:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236183AbiEINpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 09:45:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE7B1A4093;
        Mon,  9 May 2022 06:41:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fg2A3D11zFGBPtldfjD3N1VFCxRttdWCnORwQPZLbXj3OZIx8qRis7EuunlnbUrpoxEG/nraZzNQ5N+x7rlJ+TirKwfVfpB9ik2v3iqjPfjRL8rPjyZgSud+S2cxn1AVRfFz24y96oGkJxPjJ/KXqpBwaIG5NvUw/NgzmhEeBeY2OopP3AKClf32Gl27eZ7zQU1y6lPa1DL0FWD4wMgErkYkhftZq5Qbek8wGF2dWV+AjSb1BgTm44rOe7hpc0zfQ4oJplPk82jzMei4rJrlvizWdBDMBNT/nIuyqSDE1vHNrCle+1cJUqrXyNJHcsWm22E3Xo0eoIUDqv/THCzJjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UYOiNrrn8OM1S4FJRvFcc6aGXES/At8wGwUNJ2Uz0fU=;
 b=KOgjv8EvgkKkz2OVDQK9dGIdLOpKu8+45umDRQShtjO3uOm2GPgIq1BULJpbhN7tlyvb3SnFwMzUamhI/X7CbCwsFVJe4fRtWE/ik3XyQFQwh+03eASowoHqtKyjKYgOJZqDwiObIhl9k7CNbjDBKE0Ty7dLHHr5Xit7w0ytW2fIRrhK3hR6PcvfhJ/zd3B+M1HlQyfzfdMYUeYTGUQetSAXh+YPnI9o3NTItB9tUcjxqLND8VeGAG1lFCTcKzgLGbhP368T3Ko7z4ZJHutByAeB+6Hc/dJax7gJP7SJY0TSP4Y7PN+MdQFvYP2KDrzUSEZ5DfNLfL+ul82xWE9SVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYOiNrrn8OM1S4FJRvFcc6aGXES/At8wGwUNJ2Uz0fU=;
 b=EPW42mU8t3gwTPbe9409XxBM/6XEqlZRSUQXZlkceHcTuc8by67Gx33lydGJXw+rwqBHGkGPi6S8pw5PpA09FdHpraaWWs3IsUd8hDDGNy8YfEBIDsQVIvpIKKFEs1UVjU17wBPJcGeeTl1pUe8/m3GzBZ3TFaaRTBqTdcR1Hog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11) by MN0PR12MB6320.namprd12.prod.outlook.com
 (2603:10b6:208:3d3::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 13:40:08 +0000
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::5c1f:2ec0:4e86:7fad]) by CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::5c1f:2ec0:4e86:7fad%3]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 13:40:08 +0000
Message-ID: <e7f692a5-a88b-9094-12da-0cf29b880527@amd.com>
Date:   Mon, 9 May 2022 15:40:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 11/15] KVM: SVM: Do not throw warning when calling
 avic_vcpu_load on a running vcpu
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, jon.grimm@amd.com, wei.huang2@amd.com,
        terry.bowman@amd.com
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
 <20220508023930.12881-12-suravee.suthikulpanit@amd.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20220508023930.12881-12-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM7PR02CA0007.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::17) To CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6e8314f-d0b9-46ed-d780-08da31c16ebe
X-MS-TrafficTypeDiagnostic: MN0PR12MB6320:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB6320024E5E684234A15EC1B99BC69@MN0PR12MB6320.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSyvofLOXBCBzdwDnmTRs0NrXbwz4aWsBHZCdLpCucaRn6S+yrVxPwzz8cQZAVz+siHVOvPCvq8eG/rsQEk/DjXPdOWFES7kXhYSHTIwmzsylv2XycrTrYYJlZPVkxW5aqUiBhLMy3R7n9TQDckOFhJZdLPmA6l5QbhvO2O81y8Z8UuhfxGI4pRbiJgv3POjHwCO/+r9VrdIOEu4TtRCnUxxf56lUOuSvN/lWb54HzrArknQ5vtR44Mzu6zxWvACcdD+7GPT9opgSt9NGU17iWybxskfDAvUETnItNiWRYjakoaGiNur0W1w3MhxwQKOOQjL05LxJFO2GcIz9hPO+YpuKFVRBaKo6qpjWum7CR1KZaDXYZ6CTws5XpWcc9KJXeWJ7L1HWTje5QIXl7bCjVUAXAgezjReFonkPhK6CiHYgjuWUcnsPkcTi0Yf2xoShlPHn4gWTPE7E3bLVot9HNtl+hMJT6paGnhcRFKpFoeAZ4QpCIuHYg9PasH+Tx3lwLoTdVD6QLajb+Fb+pr02gIRn6hrHf/PpdBZNK/YIZsIqNIjx7shCTSMowWZ0XyzVeJvAgjUeLEsPRqLmYmRMP7fxysxwwFs0giarsHmCKgIVxXkJlQ+AH7HRHmNUr+QRXmgY+iSRs6Oh9h6FXOjH3nNtRkH0/kmZT7M+9p+0efEN70LSzvwhWOeCrAdlg6VIRLISHzWI19/J2009Ajw8D5+c2GNNR5VQLn1HSV53yA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1201MB0181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(53546011)(8936002)(6506007)(36756003)(2616005)(6666004)(38100700002)(66556008)(316002)(66476007)(66946007)(8676002)(4326008)(2906002)(31686004)(83380400001)(508600001)(6486002)(5660300002)(31696002)(6512007)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFRTcll0Ynpia0dHOHVvazZhQnJLakc2QkpVYVo2ajRWYStJakNEbGdMMWZL?=
 =?utf-8?B?U0xycE9ZNExiZHRralQ3VHpxVmZRL0hCVGVNTituMjl2eVNQSnpucjlPL2N2?=
 =?utf-8?B?QUZHdXBLUXBBajc4eDdML3dQWUNLOWdoanpLYU9KZENpT1Z0OU8rcWZzMmhy?=
 =?utf-8?B?K0U1VDJIR1dFM1NXSVdYL2tyZUgzdXo3TTMzQmpuY2JVSkZWWC9tVk1XMU5j?=
 =?utf-8?B?dHllZ0plbDhYK3VBY3VldUpxdy9iZXJvY2tQOWk5eDBnVWptd3BiTm0xUFNq?=
 =?utf-8?B?UVFQWm1pV0tPYjcxbnhJZlE4ZmFZZXE4aHNZQ0lEQWUyRDRlS2dRVlZvWC9L?=
 =?utf-8?B?YU5zclFxRHcyc0ZMUjAxbWlyME53aGRhcXErMW85WWU3ejR2Ry9MVXJuZGRt?=
 =?utf-8?B?VHJxN2JnTnhDcnJFcnRobm9QN0FKY0hITk4rNU1PdUNNTXVTWW1tSkJMVGlB?=
 =?utf-8?B?bHJyK3RvUDNLdUhzNUc4T0kydTRWZ3lGWVdmeElVMVVQbmRhUS9rSjFMMDBB?=
 =?utf-8?B?M05WTzl5N0xhYXNSVTFPaGpKbDhiRUdGck5FZFc4Ly91R3R5UnNSekRqTFdm?=
 =?utf-8?B?eXk0QW1SYUtXdVpXSjVXdWpvZXZMQ0IvbDJJYlZxRFNmVFlrVy9FRHJxNjRH?=
 =?utf-8?B?aTZEN1JxK3QrdXdOWS9zRW1nV2o3TjFud0F0NUtwRU5SY3JhQk90c3JKT1FR?=
 =?utf-8?B?bGhMZU5Cd3ZyUDB4ZmF1anU5aDJOZ2tVTjRKUlFtTU5USjl4OUF5QVJYV1Ja?=
 =?utf-8?B?SEZ4YXBja3NWZFlTd0lKd1ZXeGkvL0k2WVdzTUhza1JYNjhPdjNObzB1VGg0?=
 =?utf-8?B?dEw0SkdtK2NwUXQ0d1NnYmlHZDU2MENVdDE3a05tWEVkYzA1VjRIMmFFU3pU?=
 =?utf-8?B?WjRhSGNHN1FLUTYvaGQwWWs3cWJkaEs1YWJPdDB6VDE2NFJFNGFqZnF3MGlO?=
 =?utf-8?B?SThRNUpzci85MzRFOUpHb0wvZnZHM3dTMDAyNnh4eFNwK2E5d2ZJSHQrTUVv?=
 =?utf-8?B?dlZFZ3VGZnlSQkJqWXdaTmV0TFJXUVBIejBTR05xdU1DNHdWUzJlbXNSRXpW?=
 =?utf-8?B?d25COERURTYvQjNjU3FWMXJSdk5xM3ZIYTZlQ3Q0VTJ5ZE9zb0lYaU1Yc05L?=
 =?utf-8?B?SjhkVlJqN0o1S0RoWnUvR0NaTTNyTGR6ZFFSL2ZsNTVLTDZXeU1aVmdwdTlw?=
 =?utf-8?B?UUk3VTdpeVE0VmphRVEwOXpCS2JXZysyZVJXY2hBWE53dmhHRHdwM0Z0a3Q0?=
 =?utf-8?B?bTZwS3VlbldIWGYxWTdLVmJMYnRYOVVTenUxejJIS3YrZWNZY0tONGdTaXdT?=
 =?utf-8?B?NjN2dkVQdCtZeXF5aExwR3MzZ3hWeHRQN0licTc2WUZCcEV1bnIrOVFSTHRD?=
 =?utf-8?B?OWRpSVJzOVhzMjYyT0lxS3pUUmdXekkxQ3lBamhMVjYyT0pKWjRtbVJBUUEr?=
 =?utf-8?B?cVpQMU9haFVUZzhxTDRLaHBNa2tBc3hiTlNSQjQ4MllvME1JUDlQWFJTN00y?=
 =?utf-8?B?RDdORVNsSzdQbEZQVWFsU2JzNHNMOEh6djFPTTJUWElicURvcmhYMUlPaWlL?=
 =?utf-8?B?UFVsZ3JRYncreHZ4VFZCQ0VQL0cvWDI4THJLelhqYlJRZjVsSVM4aXQrSXZE?=
 =?utf-8?B?Z1RtM3lrMW9jTmFwdnk3SE0zZndtWVZ6eUxZS0E5eVZ4Zk9QcEJEQnRzWnZY?=
 =?utf-8?B?NGpPYmNlbmZUNVplZDNLTklmeWQ0VFNTeE01Z0hFMG95WkY4Vm1JOXVoL2Iv?=
 =?utf-8?B?RlRQYUpKaExqN3l4VTFjeGZUdkVoeHJST0VlTmVvOGYxaWNHQXNtWGFHU0hh?=
 =?utf-8?B?VU9iQ2xzUW9vSE9ialNVdUc1Z21tQnFJYkd3c3BEbS9IVXROWnloanBlckkr?=
 =?utf-8?B?enNwODF4WWpGR2FxTGExbitKelN0RjJoTmVGMzBPRk5xZ0FaekkzM1pQNEVz?=
 =?utf-8?B?KzJ3ZEVuZWp4aExTL1Bnb2ZpQStzWGZuKzJQWWxOSFBqTkNtOTNMeXAxZEdT?=
 =?utf-8?B?K052MkVsbnZES3Y0clhQczlTNU96aW03c2IzYUY4dmJUUzNXeExWSFBVc2w3?=
 =?utf-8?B?NWVXVnlmMmNYOGpIRFlMSFRzQ3cxQ1A0MXQ1dkdyY3JqTnNnVWhSVXlPMDJa?=
 =?utf-8?B?c1pXTTB2YkxnenFvUDZUVFRSSGpSTkZaK1JpeWtNTzJ1Y0ljbmFZOWRSblUz?=
 =?utf-8?B?czJuMmg2UE4xcTFqdUJGbnBwTWpobStWRS9GTnBXMjNBUkMrbU5SMmhGYjF6?=
 =?utf-8?B?d05YWUNFb2dIWnJjS1B6R1A3cklxb3VlTHhxdDJrMVVQbUZ2WDVZYmFUUk9v?=
 =?utf-8?B?Q2VDNWt3ci9hN3ZlbS9tYk9nZVNpdTllUzE2eTUvRlRYYjFwd1UrZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e8314f-d0b9-46ed-d780-08da31c16ebe
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1201MB0181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:40:08.5139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9UwR3SphWapWQfg12i77HQZA6wemPhS2+Ki4QBNoBhmkFYRA3Um04wzBuCLlwCG7jbe0mrNd7ITFSJZmYtaiwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6320
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/8/2022 4:39 AM, Suravee Suthikulpanit wrote:
> Originalliy, this WARN_ON is designed to detect when calling
> avic_vcpu_load() on an already running vcpu in AVIC mode (i.e. the AVIC
> is_running bit is set).
> 
> However, for x2AVIC, the vCPU can switch from xAPIC to x2APIC mode while in
> running state, in which the avic_vcpu_load() will be called from
> svm_refresh_apicv_exec_ctrl().
> 
> Therefore, remove this warning since it is no longer appropriate.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/svm/avic.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ad2ef6c00559..8e90c659de2d 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1059,7 +1059,6 @@ void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		return;
>   
>   	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> -	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>   
>   	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
>   	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);

Looks good to me.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
