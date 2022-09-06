Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93F25AE125
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 09:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiIFHc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 03:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbiIFHc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 03:32:56 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C3874BA1
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 00:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBKC5rh28hVP2mB7a5QUaZr6XY9abe2hLzYwhRzGxLpzFnfaGoEO24T5YZAg5+KcmyUmTMDIsIsN3Ly2GW+fWTGMMh4PW0/EegBoi2ZB8Kb3eQlmf57vm0o74O1l3pQlgk/X3BND4QaoAa24edrlFrW2M0jk6W4zUntpgsOi6pUi4RRht90OuObKCKYYP3qhNo+kcmTA8TGEYoJiMD1pPTqsyB4SOlJcp5WWjuEsWFDqrn+/G8Nz1yEHU9fksMSHfwnAQbB85JNov1niNg3mVKrRZEl6Xuuq6QHgv99zbnHt3rSubT47/VDLz6YbAYOYfED1Z0hqLXFDJFjE42ik2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=468Ex7WfFHcmEGpddaRjFJKZQTlNraf0Ap6wvL5Fc9c=;
 b=MCoQ9HRiWe2UqVrUpe+xE2FX285ppRrku6oOK6rIuBT4a6HlI73AkU0EwV45jB8rpZTPyTwBvmYQZ6jJ/SdalPEBEt1Lv+cXKfKaH1wMwTEuroZqASuFahlFMpbjR9/4H18fU1pST7YMQ6no6k4efGpTLtlxauBoZYN4Bnv+jpmByzIGyuPJxWePub3/yI2ZieI2IkQJr7LOxejjeyQO1wbGM5T5zWBBmdY2CtDRQNfG6i5Syzk/6A3nNjznWHYgg2h3F6vWDeki2gWZbRmj57HtmjRoQUaWDjyanTp0ie7jITP55Bhx2BocqeLVl5v0tHii7D9ZFD0ehAUZAOvQ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=468Ex7WfFHcmEGpddaRjFJKZQTlNraf0Ap6wvL5Fc9c=;
 b=i9+VzXo9HtxqIrItrfMkCCIAV0aiwsc4B6yazqcwTZQojA99JVX9q1lLcaPBkqmQiIElxwHnf/jVSG2q8tmL+HgewhbshC6Z7Ab4tXGUmeLQEW8r5i9YETNrGWWEMEkoS0ZAl8nq2XVnNhTRzwiLlfm/QHFuU0K4lB4tmQjvMTI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by CH3PR12MB7667.namprd12.prod.outlook.com (2603:10b6:610:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 07:32:53 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b%8]) with mapi id 15.20.5588.016; Tue, 6 Sep 2022
 07:32:53 +0000
Message-ID: <c011b51d-6955-5f7f-21e6-fa4250dbeeba@amd.com>
Date:   Tue, 6 Sep 2022 13:02:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 13/13] x86/pmu: Update testcases to
 cover AMD PMU
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-14-likexu@tencent.com>
From:   Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20220819110939.78013-14-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0088.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::28) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 842b289a-bf46-43aa-a228-08da8fda0252
X-MS-TrafficTypeDiagnostic: CH3PR12MB7667:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8R648Qf58Kij4cB1NtuD+jp473JFCLBSZrhkvwcilglX0gnegIXG+mF1qN3xBFHR9TqEAWpOlGOktUraNphDc3heI0N1pzZMsI/SSf6sTzCN1NkyjUZE/HKN/c0fUY97yn8RZygoxFOonSJL+67Xq8besSDSFhT0U6C0KaZoaAg+ue5OlDqxbtfopS7JALl7cWb3ilufp0dwmwg4ihwr+rDuoOcG9sJ+mzdP/IK1zX+wPnk33QgIU8fCJZ5ZzZFaoemhSuA5RYYQf61jSzeqDnuAE/iQPU09LgmGpbErkm3prH0bEO6qj+EfRAioyFPA/mfOqm1gE/AoGdVD3Ic2Y08DpnIPslMsEVabfl2P9Iz9vqBIbiD62HpMTWdbxpMF+O0rliI7rtji4fNeArgdGn8umpT6g5zeytu+/B4emCBpMQWXhUSfHLUYsI1788tXWzo9u/2HNxi38SPQR9tP7o9UQ9zxu0ekFYXIK6zIkK1NlOWdUOJpjPku0mX7UPO6ZtSm71S3H2ahVGzwMmC/LjEveQ/Ff5Y0WLxhQRAY5Foscybi03lANme5Dv53+GQXlKraz3Cr3VOuvVmNd3BglInMqEDyH/hnaJav/WVao5pUacwTswtY9MQOt82mSMSjvWZGea7mfgJ+h0le4aWNg/GN50UwIGYWj8JfN3FJeSi3B2kYauHghGHj93cQp+4umohA7kzf/qqD4Blk6uVCrHgjFH5oK2MbNZLsyfj0LYvCIb358zFDcQQ3z8DpMpC2gMgdb8vhNMK0hYKu2bCdLUPUGwBNYbb0jrU22Po3N2w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6666004)(478600001)(66556008)(4744005)(4326008)(41300700001)(66946007)(8676002)(66476007)(316002)(6916009)(54906003)(86362001)(31696002)(6486002)(36756003)(26005)(38100700002)(6512007)(31686004)(83380400001)(8936002)(186003)(44832011)(2616005)(6506007)(5660300002)(53546011)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWQ4VlJVMXBCOWZ3OWFoSEJTQzJNYU9UVVlPR0VMYmxsWmRUdGhjaklzSzFw?=
 =?utf-8?B?QnhwazkyQ3ZGSzVlTEhQTGo5NDNkMHhFUWZ5M3BYbmdFSWxITVlRUHJrTjUz?=
 =?utf-8?B?c3JrbXVtYm1PQThwNnUvNUd2bC85MkNCb1h2eFVHV1U1eEFPOTFqMjNnLzM2?=
 =?utf-8?B?M1E1RkJWY2dyN0ZTdm10VWN4T29xenBHOWpuUmtBOUhJLzFRbEl0bnp6RnBz?=
 =?utf-8?B?bGlhYWNNSTlsajNaNk9heEtoQ1J2c29PZnNBdlI1YWUrV1Zmd1V4SkZ4d2xM?=
 =?utf-8?B?WFZJVmt2T29IOWNIYmdDMnBvOTcwRzV5a0N3bGsrRkV5ODBGV0lYSHF2NDl3?=
 =?utf-8?B?N2NURktybzNUdGwyL0hoTHp4V01FQUhiZiswZC9IeWRJeDZQNm15a2ZPOXlL?=
 =?utf-8?B?cloyZlErZVZLQ0Z3ekNZVXMxN1dNQjBhNFU0UU1UTGJLSFM5NStWcnZlbnVF?=
 =?utf-8?B?N3RSTWc0YU1hY3VLMHFtcmROQ2NoQTVCb3FRVkMzMVNBWkxWYmVzQ2RmMjVP?=
 =?utf-8?B?UEJ2ZFk0WXNFQ20xQyswclhkZEVoQ2YvNmpFc21iYmJxZkY0ZFNEdGVPSVVr?=
 =?utf-8?B?S044cmJ1elc3bC9uc3M0b1lyVFRaWUlnZW9zbFJqdjhyOHVWblV4ZEp3YWlx?=
 =?utf-8?B?Rk9aVzlhU3lWWVZuQ3hIQzR5dlA2dDRoMFErUGMwWk9ER042WUlRSXZKYnNJ?=
 =?utf-8?B?QzI3ZmpreE9zcEdyTU9mTGt2TVdnRExKbGFKWlgwTi9lUmd0MkhXdmF1TzIv?=
 =?utf-8?B?N1F1dFFhVG5pNUo1RUxYeVViRnZ5WGhLUXhoOVpydGVNNDRLWXUrTlVpZXI2?=
 =?utf-8?B?VEdQQ2hrbHVQZjBLcnNSS3JhTmg4RzhjczB0Nzdmdlg4eWZ5bEVtVnNERDF3?=
 =?utf-8?B?SEJweU1xODFqUUhLeTBOM2MwTkNWRVFsMHNrUkp3Nnd2K2xwbjlhS1d2Q2Er?=
 =?utf-8?B?VjJ1RVBHK0F2YkdBWFoyUHZmcmR6cDdjbVRqZUpqNVZxMjByczZ4T0tnUUl6?=
 =?utf-8?B?RnE5TkhPcE53UlBtc2ZGQ2U1YThseVg5MkNIVGVnamE2QlBnbGI0NTNxblo5?=
 =?utf-8?B?WDdIc0xCWG1kUVdBYklsK0Z1QVd6d0xRb3FQcFltdWhEZm9BQ3pUMDA1elpk?=
 =?utf-8?B?T2ViYm9SelBPdXFFRGFkelRZczJTSlZnZXFuc2NZVEdtc3pBUWdVemkrcTls?=
 =?utf-8?B?dHdaeEc4SmN6eGpEdTlvanpXMEJrL2thZmlTYVpsSGxBSzhEVlFkNmU3bEV0?=
 =?utf-8?B?MnBONHRRQk0zOThtOG85T3BGdWdTV1RmUk15aUsrNkdVb3lOTzhYV1BJSU9Y?=
 =?utf-8?B?dzhDRjVqUjZIczZiMkpzSjVyWHRocUhpS0k2TkpIK1RJelRHSy9zQ1BGbEIy?=
 =?utf-8?B?eHp3YzkxRjUyRHB6QzU0QUY1MlFqUXZzTVRHWDR0VmZMT0NyNGEvVHJxbTFD?=
 =?utf-8?B?V2dNUTkvMlE4MnZGQVZsbzdRc0R2YmI2aDEwUHlxY3k3VkszYTZUV2NUQ1Fs?=
 =?utf-8?B?Q1RBRHN3b0RlVUpJbmtwVUJiYUMwMnRCK1dGSzJEZVd5eHY5Y1FXVm9MMHZM?=
 =?utf-8?B?cGdhMHZVTVFUYzJieUxKbzRGVkNzczN0cnRWdHg5eGYrclZaMXB3TVBWMit4?=
 =?utf-8?B?aDdNRUlrY1MyZWpmdlNkY3hmWEM5Tng3NThMNXRaQkE1Y0c2TFJGb2h2MSs5?=
 =?utf-8?B?dzRYM1Y5eVBXbTloZ0xzcG1xcVJrK1czaFlZZDJNcFc5Q2JoSlpFNWxiYktX?=
 =?utf-8?B?K0FIaXFyMC9SaFAxdS80NWRteEVEV0lXUWpqWEFtQkEydURYbGlOcWFPb3FL?=
 =?utf-8?B?a0tDd1hxc0NUWnVQK0lFMll5L3hVSW9IS1FSNzYzL0VyYVpDaTB2S1JuNGNy?=
 =?utf-8?B?ZEpRTUJ5c2lmNW41S1BCZUZ3T3lYT3ZtREVRVE5rYTUwZitVSm0ydXRhcHA1?=
 =?utf-8?B?YlF6aFk3UHVyK2FvSC8vcFZzY2RjQ2QyRHNMSDVvV2NmbC83MUFBMXFVKzM2?=
 =?utf-8?B?VmM2c2gxNTRKWGkrMWFjZGdvc0k1a0xucWZ6ejdxWUZwbHNjT0QvQWZxOEtr?=
 =?utf-8?B?VDROTzhBZjlmS2J6NGFob1E3RTdyWkc2YjMwODVPeGFNTEhPRzl5V3lra2RG?=
 =?utf-8?Q?0lzwUuScLnDfbspvo8drdZboG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842b289a-bf46-43aa-a228-08da8fda0252
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 07:32:53.4395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NBR5YR+jEygnuWLVJn2uqziYXhgJthQ5YqtEskMuQgIX14wJ4+nhlQO7ZsZHevY9upyaBoAn6l8csB/83bGBKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7667
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/2022 4:39 PM, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> AMD core PMU before Zen4 did not have version numbers, there were
> no fixed counters, it had a hard-coded number of generic counters,
> bit-width, and only hardware events common across amd generations
> (starting with K7) were added to amd_gp_events[] table.
> 
> All above differences are instantiated at the detection step, and it
> also covers the K7 PMU registers, which is consistent with bare-metal.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  lib/x86/msr.h       | 17 ++++++++++++
>  lib/x86/processor.h | 32 ++++++++++++++++++++--
>  x86/pmu.c           | 67 ++++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 106 insertions(+), 10 deletions(-)
> 
> [...]

Reviewed-by: Sandipan Das <sandipan.das@amd.com>

