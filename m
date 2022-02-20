Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817954BCC7F
	for <lists+kvm@lfdr.de>; Sun, 20 Feb 2022 06:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiBTFff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 00:35:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiBTFfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 00:35:34 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C567546662
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 21:35:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoWtOxHU7mRlHh/aJXcPkQ9UDaxrWs1znwRc8LoYYVsgq/+ms+HV9CLa+G0edM1G360pX6o+fpj0MhHyJkYsYXCBTNYT/U/iNBCbGTVXcZhz8D8IckPdRKZaLJWfrWmcln23Z0hbYR5UiznBH7pGF9nV7eDHfYrm5ROIEtMnMm67/S2RRh5cSKjwF25ZNMgApFiskTD2crZZluea2IH/xnTlL6kk/XzJERzKbqVlkXG5Wtt3Ldhd8yup9PD97LDBw3KoHOLEunuRYOUhg6yPR0zBpBOvfy08vBxGhnxakGK6K+JXpsxnCATo2YwLYM1kbK0aBlmB1tBlInySeAeJpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pt12J9cIMmqdlgT/DPg/6PkweMgVJqCqs9tMjBruGkU=;
 b=d7+OBB398UHTk4gdvWoJnjZwtrUh7ulAYiA/st+Tid8+YvN5ci8U2VI6MpKul0JNAploAnTARv9RzmASYPJaRBqRTrggkZ/TtmUpjBBn7PzXsJO7ajdHOLKRabtf//+xzPh/KzRc/8txUxm2ncXD/6HO+SAuQMn1IkvfPNqR3SBfTulrzOY0h0OX1AadCO7yUuLM/Q1yfvAjP+wfIKAn2tE70uZrNo+4lVZGv0GFqiEWAaIUzoXw61w+tNBXak3GOPB26CXtZmEgkA8EpZqqid/sA84ExMPxCdxg75c7Nj2Loez/OWq9UyVpZGE0jczuYj5IZdyRGmG6dWWx06gxeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pt12J9cIMmqdlgT/DPg/6PkweMgVJqCqs9tMjBruGkU=;
 b=iJPpjkOwxZbnl1LOx/V5Vlmux1KZGopWOzgSTJe7XENHqAucXvzOCjpJg1F/HONveYdgIDABGs4WjK+2mbVYdvhKK191fvUO/sTrOvo0BaDQtMnYQXc3t5V4JJ/u8n89209RiKx08Quis7ExzDTYR0GrrPMOcn27gIk4kjbteC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by CH2PR12MB3847.namprd12.prod.outlook.com (2603:10b6:610:2f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sun, 20 Feb
 2022 05:35:10 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::e9be:e1be:5abe:f94c%5]) with mapi id 15.20.4995.026; Sun, 20 Feb 2022
 05:35:10 +0000
Message-ID: <a451e567-3ba7-8ba5-4dd3-ec697ca70175@amd.com>
Date:   Sun, 20 Feb 2022 11:05:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add routines to set/clear
 PT_USER_MASK for all pages
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, aaronlewis@google.com
References: <20220207051202.577951-1-manali.shukla@amd.com>
 <20220207051202.577951-2-manali.shukla@amd.com> <YgqtwRwYbJD5f9nA@google.com>
 <e9eba920-9522-6a56-4293-b60c0f1b77ed@amd.com> <Yg5np2qFj7ErxhYp@google.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <Yg5np2qFj7ErxhYp@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0147.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::17) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d033314-5a44-407a-f551-08d9f432c2c6
X-MS-TrafficTypeDiagnostic: CH2PR12MB3847:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3847654FBCD2A4298EB2BCDDFD399@CH2PR12MB3847.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MSbzfc04q0TktfZatcsM7Us7/Cflug8iDroevujhUxSpftmDMexBuM1N6yJa5HS0LVtcjIv6TMp61ZWXrS0CrX0ckJoACgDJ3OA0LPEl1f5dkX6L2MGN8N083PVf97vzlmECnIQsQHvEOb8HxQ4rBtTXhN+UAWfn/JnaAGekpswtw3I3Oh+AhQF3bViM1P4yW3X9K//ITDAbE8aeD04mi7VZxJUZjeHyzRgUvl/Sdx/4XE9bco4WCb0zy+hNtre/pa64h8h8hgkkz5htDkrYQR5jyFQYjHNcOqEfyikAoSJxEaNFHuBmz5lWziKHMzIqH3Js8oT+64nYgHFRK5eT81jv+UmphNnMymP1Wqz3Dsrd23GRbXIwV56bgR03h0bTHoXIAWvPKUqwr1vjw1VmSN89j73DNDUZsTP1rKl7xxsWTrAwphuSNyE2xHsuIcZTGaT9BkkNJkp00ldIpN3My8xrD6BsclX5KccD+CeZyVT5tZIt9rFtRYNftps62HyZbaLYEtE1RcaDie5cYMxlz77gbiJkV4xo+sphOfArJ5Jxj5DSE2h9YdQma7N2JZX5FUAnvlpRP3WzWWnZxhoLFiJtAAxfJ9nEhLiCw088vPiKAIppg/yG5/DF5OYWnPyWttPwEwjxFC+MJb/zbNeIN67eQyBouuTl08QoUALSjSLUhAhHLPiVpsG1G9Lt09ufm/A4Sy2HOdASedeFgdfGBMRn8rsE1Dk2fPybCZI0/Ho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(36756003)(8676002)(4326008)(508600001)(2616005)(186003)(66946007)(66556008)(66476007)(316002)(6916009)(31686004)(53546011)(6506007)(6666004)(5660300002)(6512007)(8936002)(38100700002)(2906002)(31696002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3dZUkFVRzcvMnV6YUlvQU9EWGRGQnZJRnd1SHNEZUd5QzdUZWNjZ3hZNlJh?=
 =?utf-8?B?bS85SGhLZzZxTkJkRmJCU3FzL0lwNFhodGRxMjgvSHJuTCtOZEJOcGNEWUw5?=
 =?utf-8?B?T3pFcGNlQ2VZZHo4T1dYUjVUQnptVUJxRTREaUpKWG9sTVF2Y0F2VGFYa0tu?=
 =?utf-8?B?ZDM4TE54WEtzZGp1VG41MVU4TDl5LzRCMFJubHBaYTdabXhnV0twQTQrOGFr?=
 =?utf-8?B?ME9od0REdzFWWE8ySXI5UUVvT3dtZkw5YkttdTBnTnlWYTNxTFZEUGtiL2ln?=
 =?utf-8?B?RmNJSWNlTFQ1b3lIREVHdlFtUGV3dHE0N1Q1cTUzZC9GQ2V2S3JOcWZzWW43?=
 =?utf-8?B?TDNTQVZNVDdMZERwVnRuby9ESFdWSG9Sd0RkWFlCQTE2S01hYjBKamFuNTA3?=
 =?utf-8?B?NW53MlQya2k1ZlJySy8yaFpmRXF3OEFrZzByTi8vMTZpVHIxVE9WUDh6aTNQ?=
 =?utf-8?B?aUpTMGY1MVF5ZjVyM1N5dEI4Qk9rUlR6dmFEeWo3NDNGK3lOcXVrNERTZmRH?=
 =?utf-8?B?RFpWMGd0UWFDWm5DT3lESk52SzdycTV2R1B6cUxVRlN3L1M0N085TklhNDAx?=
 =?utf-8?B?K082VHZqZW10YlRVbXI3Rlo3N3BQZzhCSUxwWVVFdjhDWjZWRXlMYUN0d2s3?=
 =?utf-8?B?b0dtMnJhYmJseWl4RXpET2N2MkZ1OXNGdk9ZMWdRb3pUeUJKa1FwcE1LdGJP?=
 =?utf-8?B?a1JMTEhWTVYrVThBOEhkMkNoYTlJLzJ0eldYSXZlclhhOVY3YktFQy9HRlhp?=
 =?utf-8?B?OHZsU0gwNk5NQUhnOEZVMW8vOEFSclNjOEdkSDVFODhUMjB2c0lTenRHZ1Vh?=
 =?utf-8?B?T04wc09CODlIOWRTWWlsc3JMWjdxcFRjMVJMVUdnQ3MyaVpZc0g2TGhnL3ln?=
 =?utf-8?B?RGFOVGwyS09xZTZmY0N4cm1WY2lUaXZFWUtLcktnS2M2TzNBUUtlaWxTYVhj?=
 =?utf-8?B?dFVXN1E3UGFtZ1IzRDlTTkI2ZUVJN01iTjZjczFSM2tqV2Z0ZjNMcHIrTFJU?=
 =?utf-8?B?Wmt0aHZYVjR6STQzQUlyMVpiZ2tlMkFDYnpXbHdYdmQyeGdObkRnWm1NYThz?=
 =?utf-8?B?OE5JTUVHNitML0tqZGh6NGxsMHBMdU9jckZHZTJ1MCtyT1hZbGVHaDZ2aXdw?=
 =?utf-8?B?RDZORmZSdFVjb0NYT1BpRjhMaWRGNG5Jczl1QXpwZ0V4RDZYSFlzVk9xd3pp?=
 =?utf-8?B?SGxNT0dxUDNDaUlXUUd0MUJyNWhwZVl6dWY0ODhaZ2U1dW96ZTJqVlpPNVVo?=
 =?utf-8?B?dzRuanZJby9lOHgwY1NhOG1QUHlIdjFBdmRQZVlnT01PT25CWlJoYmZZVHN3?=
 =?utf-8?B?c1lvb2FMUlRNTmk0bUxHTHRsYTVpcFBCVWhXN1dZYnhKL2dXNU03NDVoWURV?=
 =?utf-8?B?WjIxMG1BbnI4WkUwSFNEdmpiZkx4TVRaUHhlOEIyL2xlbFJNMTJhM2hNN0dE?=
 =?utf-8?B?YlpYY1A4dXVRWXVoY2JETWVFc2NaTzkrMlFpdVFWSFhsZ1dZejZPbi9rbHdn?=
 =?utf-8?B?cUZja3RuVWtKdGc4b3JXZ2FkbUhjdUlvU3RKUnphNTVTWDBhRXFwQ3N6L0sy?=
 =?utf-8?B?cEJkMHNWbldKNmhtOWpKRHh3UllKQW5LUDRVazR5eFY1Rm9mWTdJQVFUcHRG?=
 =?utf-8?B?OTFISjBsWUZFVHZIVXpoeThqd1NNeDQ4dmtUeXA5cjZvN3hmS1VlQzBCSUdP?=
 =?utf-8?B?enZVZUU3eFRqdGFpL2FXUVBidWJLVURVMTlQNkRVZUJuUHJERFcrK0Z3dEQ1?=
 =?utf-8?B?SU9ZTXJuUnFyWEVKRThndzZlSE1zUDJ1b0orVjd5TkpmMHdDS2pEZkFmaHZQ?=
 =?utf-8?B?VGYvbXFpVlo2eXRvU0w2bHViT3Q2TkF2ZzB5dWxvV3NiZHlkdFVKcHFkTnRq?=
 =?utf-8?B?NTFXN0FHbzJxc1dma0Vic014ZjJRZ0RqM3BlbWZ0RTAvWXdrT0N4UTVlM1VF?=
 =?utf-8?B?T2U5dTdOUnVoT2t6VGt6cnU1Q2c5QW5FdkpZbmhObm5FV3ByNVBZTHFyU1FO?=
 =?utf-8?B?a1B0RTVRR3FLeHd4RDdOd1dwNnVMM055UzB4cTBFK3JmSEFKT21OZStMYWFn?=
 =?utf-8?B?Qk1LdUR5U0JzQStNajVSbjJRZFZwUHo4V0pUZGJocko0UlJGS1pVczVWNExO?=
 =?utf-8?B?ZXBFeStkZklma2RtUzB3OS92NmtQUThrTG15UWc2QXBsQlJhdW1OV0xOK0V3?=
 =?utf-8?B?MlZLYzZsRVFCdHR2NlFIWmtqZllpU3lDS1dEcFdWSmZXYURrME5iOTMzZWl1?=
 =?utf-8?Q?tXzZqzjThSixhaVmGUwl//+fe4K3u6P0Ka8VSzNX4c=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d033314-5a44-407a-f551-08d9f432c2c6
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 05:35:10.6902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27KABAn+JpGUz1YZiMkkQbi48Q0a3d5rZ8nRws5mabCdy6sv2iT6tZrP7f3j6tYSNa3OeveSjN2rOcFbavdKHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3847
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/17/2022 8:50 PM, Sean Christopherson wrote:
> On Thu, Feb 17, 2022, Shukla, Manali wrote:
>>
>> On 2/15/2022 1:00 AM, Sean Christopherson wrote:
>>> On Mon, Feb 07, 2022, Manali Shukla wrote:
>>>> Add following 2 routines :
>>>> 1) set_user_mask_all() - set PT_USER_MASK for all the levels of page tables
>>>> 2) clear_user_mask_all - clear PT_USER_MASK for all the levels of page tables
>>>>
>>>> commit 916635a813e975600335c6c47250881b7a328971
>>>> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
>>>> clears PT_USER_MASK for all svm testcases. Any tests that requires
>>>> usermode access will fail after this commit.
>>>
>>> Gah, I took the easy route and it burned us.  I would rather we start breaking up
>>> the nSVM and nVMX monoliths, e.g. add a separate NPT test and clear the USER flag
>>> only in that test, not the "common" nSVM test.
>>
>> Yeah. I agree. I will try to set/clear User flag in svm_npt_rsvd_bits_test() and 
>> set User flag by default for all the test cases by calling setup_vm()
>> and use walk_pte() to set/clear User flag in svm_npt_rsvd_bits_test().
> 
> I was thinking of something more drastic.  The only reason the nSVM tests are
> "incompatible" with usermode is this snippet in main():
> 
>   int main(int ac, char **av)
>   {
> 	/* Omit PT_USER_MASK to allow tested host.CR4.SMEP=1. */
> 	pteval_t opt_mask = 0;
> 	int i = 0;
> 
> 	ac--;
> 	av++;
> 
> 	__setup_vm(&opt_mask);
> 
> 	...
>   }
> 
> Change that to setup_vm() and KUT will build the test with PT_USER_MASK set on
> all PTEs.  My thought (might be a bad one) is to move the nNPT tests to their own
> file/test so that the tests don't need to fiddle with page tables midway through.
> 
> The quick and dirty approach would be to turn the current main() into a small
> helper, minus its call to __setup_vm().

Yeah this seems to be a better idea. Based on your suggestions, I am planning to do 
following.
	1) Move svm_npt_rsvd_bits_test() to file svm_npt.c and run it with __setup_vm()
	2) There are 7 more npt test cases in svm_tests.c, move them to svm_npt.c 
	   Below are the test cases:
           npt_nx, npt_np, npt_us, npt_rw, npt_rw_pfwalk, npt_l1mmio, npt_rw_l1mmio
 	3) Change __setup_vm() to setup_vm() in svm_tests.c ( after doing this #AC 
	   exception test will work fine without the need of set_user_mask_all and
           clear_user_mask_all)
> 
> Longer term, I think it'd make sense to add svm/ +  vmx/ subdirectories, and turn
> much of the common code into proper libraries, e.g. test_wanted() can and should
> be common helper, probably with more glue code to allow declaring a set of subtests.
> But for now I think we can just add svm_npt.c or whatever.
I agree, we can do something similar in future.



