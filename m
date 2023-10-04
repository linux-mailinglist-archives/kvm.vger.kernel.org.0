Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0DB7B83AE
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 17:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbjJDPfb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 11:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbjJDPf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 11:35:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B307A98;
        Wed,  4 Oct 2023 08:35:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SofHG+V1BN3irkrcyP8bsN/LTMTdBOfXY6q1GfeFRiznlp3uyk1CuEWe1XtAapcTl0WqFvhW7bLLvg5oxxHl4ssTg2w8y3V5dQtCV0ege2wrwI8rKxAFR1ZS0ZJZ9tvf2++rlOZ9SycKF7zjuwZ73zp2zarSVq9NzboQhi/K0DzY9Ays4MS7rwvKPX4RA/YWyzUg2rhKHmNoaB2j1mLhWSDM+ViUrEiv0UTGehF+97r4CyPWz6IrjQTZsuBJIxfYL50MQIIJV8HnR0JQM775HmS5KSn8w2hTCigyMS3FB4Hbbuaw/xacv7Pcu6FPpe+iU2EC3ERx7VobA6+UVRYbJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1zsRNupvmhyPrBT/ujOIsV3dz3dhGrPE51qsvBSLbs=;
 b=NCslPNz+zGHMx943zprUkCr9DfRSpn3qSOEjsuwIgPNRk9M6d4pVvfJM7eIZtLbm3ll6tt/ztAzADExRDvjhwWEvFG/cGykWhB8Q0efkt8gTi1OGoKldpUhIw7ORcAQN0mPjhRaWfRB5/KTFMSurarGE0FFL7pVkweR5RDXqJup24ta6YSpbMOPBQEAjMEu5R7/vQpb80JJY3mdyWh52pMr0PXisorpLpbinIY9CIs41dJDBtG64LAw5FiZ7UUH4FjMoVP8u2VRd7kUFyLrN7UFIOUa4e8noKIBNMtCcbhU9qy9Fzv4HxGTjeV1wHMijVYMtEe3pQHjVSxPtdaAqZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1zsRNupvmhyPrBT/ujOIsV3dz3dhGrPE51qsvBSLbs=;
 b=xum01oH6vGWajMimp+IKoDrmi8LyYCWutM2ztQazA/oUyHPb8JyUBSm3cqI96Xa980vyKmrLjd+8qqqwhcEN/dhNvahfjOXRKoIE5YXTjLCcQxD3VZWQvP4wzXjly6X9jGrgEQ2dqEQs3iyUXg2FQIS89Ic85AJtKYg1FQdftmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by BY5PR12MB4196.namprd12.prod.outlook.com (2603:10b6:a03:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.35; Wed, 4 Oct
 2023 15:35:21 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6838.029; Wed, 4 Oct 2023
 15:35:19 +0000
Message-ID: <e97430ae-08cf-56a6-cf11-e08725c8953e@amd.com>
Date:   Wed, 4 Oct 2023 08:35:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] vfio: Fix smatch errors in vfio_combine_iova_ranges()
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucong2@kylinos.cn, yishaih@nvidia.com, brett.creeley@amd.com
References: <20230920095532.88135-1-liucong2@kylinos.cn>
 <20231002224325.3150842-1-alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20231002224325.3150842-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR20CA0011.namprd20.prod.outlook.com
 (2603:10b6:510:23c::14) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|BY5PR12MB4196:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a79960f-de98-478e-18c0-08dbc4ef841d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eJilwVX5IRacYP1/t25CAjpk92gkDXhm4hidC4yb/moyZVJMcJvzruF4LzZCOJ2SYrcPykG29ZymUM8skP2AbOEALAgC2+VGZ8wYF1bmUu8syAepXgSXCL0aQWDY2D4i5uZseguHLI3etdvSEs2Yc5Nl5iVh/qtBjz5Ldj2117bO6ynRYTRqmZfDlJA8VcjxTSUDH7gaeGIIhlfAGfpqaKCEiI8DLnJcDSVgdy9c9JtCrTgqosGMxn7+FcfCRWRp4Sn/toLtlHBUcyQnJFWXGncjnh6lEXTc7WfsGiJrvuFjc/7pDR2LpEK16nG8ohF1BOlbUQJI7MPg2Ni/o/r1OvQW1p2Y0ZE/+XlkERu5rn5WEAufyo8mvMs+a6fgYTVCBmdWG3zGG2ehSF2gw4OFHOR9ChUGd1J3zfkUQbOtphfo/oEuSW4r+v4PYESq22rBTlqVtjeYp0he6NwhOf77R7ySUuVJr3wY9TQQjpgnbrKkEf9YwI8UU+QzE7KJnumZaLyqjCAknrnCPplHP+DRQoU7VXaP4tmrYGTYlRoH7PAHjqbydYMjjGnOTrjUkSsXwKOcHqDzdN1wN8eLBStKNtb6pI6R0TjZynD3DCtSrB/H1gYy88iZ2JdbsWcsZZNV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(31686004)(6506007)(53546011)(2616005)(6512007)(6486002)(36756003)(31696002)(38100700002)(2906002)(26005)(966005)(478600001)(83380400001)(8676002)(316002)(8936002)(41300700001)(66556008)(66946007)(4326008)(6916009)(5660300002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2pBdklkSytlSjVaSEo3R1EzeFgrcG9CTnNMbVVoQnc0ZTV2VnM3RGtJYktu?=
 =?utf-8?B?aGNiTlRyUUdZWFgxMFVwTkVsdWNZYTk5Z2xFbGIycVc5cGdMT0EvZFpUZXRK?=
 =?utf-8?B?YjM2VkZxVFJCSzk1dnBUUVhkdG1admovM0MvbU5uck5DbThBTUwvZ29ORzJz?=
 =?utf-8?B?K2hMaVFDNG5RZUU1RlNqVUI5TDRhOXZHWmN2NWZPaGRDdmpwZGlJK1FTM2ZP?=
 =?utf-8?B?eWI0SUUvdVBocHo5bXRzQk1mQldTdjBEYUJNVzhBenhZQnpybmtrTENMak9k?=
 =?utf-8?B?WEN1RE5ObDVURU5sTUpVbEdDSWg3RDBxR3p5dEZuTldUTkFjSnFKQ0lKSms4?=
 =?utf-8?B?OFlxTzFXa2dtSVJyeEcvQmtHbU9FVEVscHltcEwzVVZ0ZGxBQU9aTDU2VXVl?=
 =?utf-8?B?ZVRIZStmRFJNeTBBNHgxbTZCYWtDY0owd1JyQjlENFFsZElaUUpwVHJOR3Vp?=
 =?utf-8?B?TGZqN3QySzgzK2VES2kvZWxWVHdyRHdldGpKL0tiKzQ5aFIyeWRLczdjK3Bo?=
 =?utf-8?B?VEs0U3g1TUZ3MHRaTEhMQTczQmRTZ2k5SW8xVFFyUzB1SElMWHpjaExEa3pK?=
 =?utf-8?B?dE9EeWZFK3QrZlZSOTlIMDlTOVJuYnk5UElXSGJhVmt1dnB5OTF4d29UeGRy?=
 =?utf-8?B?WjhWbk9PeTM1dmtKaTV1d3ZSNERoTXduWXlRWEVDYmozdkhzeEtVUlpIUGIz?=
 =?utf-8?B?aHJIbFRaU2wwYnRJK3lkQkxKZW9YbWZnamV5cE9WZVRIeXNUZjN5UTVqMU5Z?=
 =?utf-8?B?MHQ2NTVDMjJuSTc2c0NLN2liSmhmM2w3VzlIT1NKRGljdkxDOWVXcmFTdzgw?=
 =?utf-8?B?Q21tc2xvdlRiRXNjN05keHE0SXV5QUhYaWE4REdldlhjOUxlUzN1RzQvYjc2?=
 =?utf-8?B?amZYbTBJNUFPRlV2bHF1ODVXOXZzZEt0UzdWbFZBVTJ3RU1Hc3FnVTlwTjBO?=
 =?utf-8?B?OUVVSE9JbWxqSnN4a3Y5MHV6U3pDOG5HWUZKT0hQL0c2ZWlhNDFPMlB6dUZs?=
 =?utf-8?B?aCtPMmxFR2JTU1J0M295bkN2UERyaTJvdThEL3pwcXExYTBWMnJDLzh3eXcw?=
 =?utf-8?B?KytOU1lBMk5GRGpjSGpZTHYzRUtuNjJnZWN1NkZFQk1tOUd5R05xc09TZHEz?=
 =?utf-8?B?c1hvVmo4Mnp5MU5IeUVnK3NaRklGRTQ0WWswWDJFd3c0Uk1HZGVyQXNuYzk0?=
 =?utf-8?B?U1Bab1BBYjFtcjVsSnNZYXhzSnpaRC9WbEl2UTBrZFZJaDhYUlZqVnBNRmly?=
 =?utf-8?B?SHJhYURWTnpWT0g3QjFBKzBtdGVvK2NZTWNtSWp4eUFxcUJzNE9qYWhHT2Fo?=
 =?utf-8?B?S0V0SzVVZ1lycy9tRHlqT0kveE4xbUZ3R1RWTFo1YkFkaDZmREVkN3hUbFFT?=
 =?utf-8?B?YTN1OU5UTmZ2dkhHM2NJQVhtaVZBU2ZwTDBWZzNPQWd1SXlMMXRsZ0QxQitS?=
 =?utf-8?B?cWxxRlVVRHhvUjQ3T2tHWEtIcHcxV2FmMFc1NW5zZlBXMEc1OGY4Z0Y3MW5m?=
 =?utf-8?B?YUpBRncwSDArenVTaGpaWmt5cXEwbDgrNXZOZDVKWnpjRXY5a1R3aTNuUFV3?=
 =?utf-8?B?MTA1dFRKOXZjcEIvRzRGSkdNQWxJV1NSRjlTVVBZWnNsTFJqby9MV05yNDZm?=
 =?utf-8?B?NnR3QVloNEY2YjZReWQ1WHBBL1l3NGVwSk1DanlmWVVoWWNrZlNPTFJtcWo1?=
 =?utf-8?B?d0NEMWd0cUEzWWJaQXRMYjEvM05HYjZ1Q05PQmJrdUxXN01heUs1WnE5eGdT?=
 =?utf-8?B?MVZBZndXSWhoNUNDSngyUFVEMy95NElkT2VuMmVhYUxPZkRRTGJhWFlwd1Fu?=
 =?utf-8?B?VWtCYnBkOEhRT1I0d0ZDZUxVVE54T09menVIRE92byt3SmtDVDFEdVJZcnpN?=
 =?utf-8?B?YXNqZTVuZEtnekdTa0Z6clgxZ2gwdEJ1MkZkNm5aanU5b3NxZXhsRUVhbHR0?=
 =?utf-8?B?WkhaZnZEMUNsUEZuOXpuWkRXQnExekg0UGhRU3JmdjZoM1h0YXExZ2h0bjU1?=
 =?utf-8?B?YVEwVEl0dVMwRHZFelRPbEdMZDI0Ly9tTjVDNUk3UzdXZGo2MUZwWEZSNUs0?=
 =?utf-8?B?UXlhZTVGZE9KMVZzd3YvMUt3ZlZaeDhUMElUN2VLVXVqUVFJTk4yUUhheHpr?=
 =?utf-8?Q?9amH5T76Yo+FxcMxwlHsEz2ez?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a79960f-de98-478e-18c0-08dbc4ef841d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 15:35:19.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+zivsRTGBcZEmEMaEBPpNJ+NtgAPaKaNlMgwGqlieTKuBt5hjO6VwVpj0ikaKSMlgjyJ2nBPoaUduzcv3wswQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4196
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/2023 3:43 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> smatch reports:
> 
> vfio_combine_iova_ranges() error: uninitialized symbol 'last'.
> vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_end'.
> vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_start'.
> 
> These errors are only reachable via invalid input, in the case of
> @last when we receive an empty rb-tree or for @comb_{start,end} if the
> rb-tree is empty or otherwise fails to produce a second node that
> reduces the gap.  Add tests with warnings for these cases.
> 
> Reported-by: Cong Liu <liucong2@kylinos.cn>
> Link: https://lore.kernel.org/all/20230920095532.88135-1-liucong2@kylinos.cn
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>   drivers/vfio/vfio_main.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 40732e8ed4c6..e31e1952d7b8 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -946,6 +946,11 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>                  unsigned long last;
> 
>                  comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
> +
> +               /* Empty list */
> +               if (WARN_ON_ONCE(!comb_start))
> +                       return;
> +
>                  curr = comb_start;
>                  while (curr) {
>                          last = curr->last;
> @@ -975,6 +980,11 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>                          prev = curr;
>                          curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
>                  }
> +
> +               /* Empty list or no nodes to combine */
> +               if (WARN_ON_ONCE(min_gap == ULONG_MAX))
> +                       break;
> +
>                  comb_start->last = comb_end->last;
>                  interval_tree_remove(comb_end, root);
>                  cur_nodes--;
> --
> 2.40.1
> 

LGTM. Thanks for fixing this.

Reviewed-by: Brett Creeley <brett.creeley@amd.com>
