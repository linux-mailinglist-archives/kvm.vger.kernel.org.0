Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F885AE0D6
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 09:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbiIFHUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 03:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238846AbiIFHUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 03:20:05 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3B81C924
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 00:20:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCg/icET3dINwI6Esl7rGu9p0/jNVSqLANDlCHjmkvW+RJqcQbuIs4HSSzytFGxwyLCF0zAJFJGgeaSZ55JhwCCc5PRBzDCZFLw9eo/zPSMR0Wjf4mVQXwr9TXCeublg2Fc0x/HiedfnavrUxQ3MBBRMDxTzwMxcckIpWo8Uz4XIjwXhjMqVL0ZP73yMzZx83XTmq2mrY0nK8exbSkEWHsKTGzksJhTs1kUX4j5+0D/i1yPwoCy+fDF+Dvv5gYXXlYb+YTLngv7Gsru28Zp2J2UU7kpXa3zzW3gfAYqel0Ufoen18M2u4fbUo41mUd5uAj5+n7CFgoDID+bpVxthrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPBxnJlMscwMHSv0IkhLMhZRdjoceZZZU/zHzAgcaiM=;
 b=VblajvnM/T5NNS90KDEVmhAg6kY/eNj9E7elWkzpeVzpvZ3yQGrAKHeQWtsFOEZdQCn1tFppYp2iILKa/4ZodjMzejE325cLlIGh4b+UwUhFqBnFnrAaqumx6o75ldccFFdas4CoK6jS/hTO/mNZUli7snYm+bqKK1asbHMcpuZjov4kl3IYzCqm7cwqzp77uDrTMiV/fA/pU7aSytXjTHiibiBbx+fbHmstNR0lq7R9HzYSw23/RgxdZaxy04W90lg4o7F41oGj9hBpm7g1wEhpoOBftRjBOK7U7TIYd4dH3UUkV3V+gAD3uiz7cFkTpBgWg1bW7aB1Ad3Skuy14g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPBxnJlMscwMHSv0IkhLMhZRdjoceZZZU/zHzAgcaiM=;
 b=za4eQUKW17E71oNqKdhtlXcSfVxXXl2kz1lPQl/7Q4kQl+nZDGjlgScWtHxGmAnslI0bFBVYiNKFY/Y7HLJF7wi/Eqf/c6Gwf09hGxeyr3Ten8/pzbIWU+J5bwXxqtjDzUvpkg1hUq5EYTYRnTqbl/uF5a3ybvFWOBGQnc8FEsk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by SA1PR12MB7343.namprd12.prod.outlook.com (2603:10b6:806:2b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 07:20:01 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b%8]) with mapi id 15.20.5588.016; Tue, 6 Sep 2022
 07:20:01 +0000
Message-ID: <22a179fe-cc9b-d325-9931-7dd3dda2209d@amd.com>
Date:   Tue, 6 Sep 2022 12:49:50 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 12/13] x86/pmu: Add assignment framework
 for Intel-specific HW resources
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-13-likexu@tencent.com>
From:   Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20220819110939.78013-13-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0142.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::20) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 108a22dc-53a5-4b19-405b-08da8fd8363e
X-MS-TrafficTypeDiagnostic: SA1PR12MB7343:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+fe1XK8VYC/9str6HRufxJ0r0yP/iN7nItxUrRsFjIt1UArQju2NaiAy5XHnE6z6hmz6IxxaCfd3+oJWeJ5Uit5nbzGStRQMJ+TGT5XnwFS/svsCIfnAZ3k7wuGYA2jaURPV+7IZRvo+svp5fkt+3VPVnMMeYXMA4u5ttg0lQpCz7buWB0T0BNqE1edWWjOLW6XB83QM6yZ3Wt3rulpnDddTf+qTeg5FRBAygvMaQRp0L7UJ2f1fmDK12xBVhL9ucUcGlYN7t+8Qr7Xi71z8+61hWTrLUqGRcWpLfumiHrBrFpD6L12G/dg2gQstibegVtkDONnJcjyadkUYJxSI0i7n9T2mwJmfWpp1p1oSOZeCd0x0+NF2ahq0un1Z2faFxhoXwxg2QwVIRXZTx3yaQFEOUnKKxYczhKX+2No4ja9uOirsUo5SaUTX8NFnMd6HmHn6SXagwiP1dJjuKOWVvi5oPszwrR/R/cKkNsp78aQTCkpd8eksRkKwppFeJ9WqCrPHaRSsegtWq0NZ1p9o83IYpZ3D98558vj7mTfWaWt11A/BS/doTf9cFLBKFnDn2UmE2Y6yXTZIdkXgADGMQ0ePf458UYs5w6POKniftQZ7J/zt1YHMeq4Z0oI0h8TQr1xoUBbSLV6lcKCg04OwDPEjHXe0jo0YGjUCdpm78wyZ13DYSODnJtW8zy0NMj/Y1ijae+OVoXkxAld2LUPrVotQ8ZXkL4KazGulctniyCkw6INGUG22RYnWgNJnQ78p4zUfeh/bQlUxiRqOYAB5A9fqq3neujjtxsXb3sfuG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(186003)(38100700002)(2616005)(26005)(86362001)(2906002)(6512007)(6506007)(53546011)(83380400001)(31696002)(66476007)(66556008)(66946007)(31686004)(316002)(5660300002)(8936002)(8676002)(4326008)(6916009)(54906003)(6486002)(36756003)(41300700001)(478600001)(4744005)(44832011)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1pKQXluNW5NcGV4NmFyU2FnRXBNZmlCdzRpSzlWcUdGVW5XMlB4a0hsWUVO?=
 =?utf-8?B?L3d5bGl3bmxNY0FMNFZ3UGJIYmNSMFl4amxnTXF2eFNRYmt5WDJjUGVBd1V2?=
 =?utf-8?B?cjVRajZ0bDNLNmxBVUNGWm9hV0lEdzZMdXlLYXErYTQ0TS9XbFdsUUNpYng2?=
 =?utf-8?B?NHNkZG5waExOMG0xTTMrc1hlUHJwdWFUR04rbGY5cC8xQ0EzeWxDd1R0YkF4?=
 =?utf-8?B?bzRheFNDaXEwa2ZxYUVCUks0clZGRnpaQzNyeFF2UTlBUi9jSXYyZlF0Sk9w?=
 =?utf-8?B?YWpmWk5UN0tSeVljbllpS29iTFM0eGM5SG14OXBCRjF2S1lyQSsxaEVCMjJT?=
 =?utf-8?B?c3NScURvMERqWjJNQjlXNnE5Z2o5eHBxUklBcTlCMi9QTnZPME85Q1BXYlZp?=
 =?utf-8?B?MmpYcnh2VDlta0JUNWNvNW1oc1gxeG00TXBkQzc4Z0o0UmY3c3BMQnVhNzlI?=
 =?utf-8?B?dUpueUFaaWdYckcwMm1oVGVxbkVraE9YWUxQUUxBSVVKR2VnQ3NDU2NDclJk?=
 =?utf-8?B?RDhjUGh2ZW14emh6UktDc1NtSEVxQm84bWNLT29UYlBKQ0RzTWhQSVFld1kx?=
 =?utf-8?B?V0hRTzJVcEVVc21GQ1RsaDFjZUNkQWlOR3JENnd1MXF0Z3BleHJDaGZZaWha?=
 =?utf-8?B?aEdMY3JGcUlzM3hra0dOVHBubFdwd01rZjJBN3dvVGNBMGlUMC9OR2dwN05i?=
 =?utf-8?B?UGJia0dIdmx0SSsrY0VjUnFXVmgwcnlEV1krOHlpcVQ3bERJZm5zR3dwbElw?=
 =?utf-8?B?bC81K1EzTkRXaHkxbktkREN2ckZwMUV2RmVlNnExMlk2T3RndkdxSFZlMlI4?=
 =?utf-8?B?RUJEanJVUENjTXNLa0x0c2lVRjV6RFZKbDNtMzYyYWFSdm82UVJMUkk0dUF0?=
 =?utf-8?B?QSsxTTBkNiswSTJzc1M3V0RqLzRmbWZHU2xzYS91dkVqdnlhcHplY2IzMC9j?=
 =?utf-8?B?N21QUnhqZDlGY0NCdFdJVVNlLzBzb3l0NXdPeDJnaGlZbmFpb0hCNDRIS0FC?=
 =?utf-8?B?RU9YNGdJUkNhYzNaZ2pjTlAzWVU4d2E5aW5wZC9QQUR4c3dTL0N3WDVpSGFQ?=
 =?utf-8?B?N0ltb1hCNHloUGVLNE5WTGVlQ2M0bE0yeVdCQWVlVzB5UU9yWXFkc3FNU3Ju?=
 =?utf-8?B?RGhwdGNXZkRWVFEwanBSQ2VxNlI0WkF6YkN0TEd3c1JySUlQNGZUNjdlZGIz?=
 =?utf-8?B?QTNCdDJhTlBuZHpIRmtKMzRLai9pdDJKbnZTSlFKNTNhNndNQTczM1YwQmYw?=
 =?utf-8?B?cG9tYzZZQisxc2lkazNHQTg0MWg3d1l0Q2VBRFprNG5HRVdmR3VvbXgwZjdH?=
 =?utf-8?B?cC9BNjZqN3VlWmp4SWdsZ1NHeTQrbjhUYVgzVUczU1hDamdzc3d2UytDT2Yw?=
 =?utf-8?B?eklUQ01NMWgxR041N1kvblhnc2JxTzVtcCthYXlUMzk1NDVnV2lqaTVCNDln?=
 =?utf-8?B?Z1d2OEg1OGxDNjdOdjArT0g1ZlZIOWNQL2JkMVZWQUtPMDdsR0NxaWVJSG1y?=
 =?utf-8?B?Rmp5SC8yNlFIOGwzb0Jpc0dRd2NURWNLMkFKV3QySnNmWkYzZm1zL2RyWGNt?=
 =?utf-8?B?WFAzSWgwSjhaczZQL2NudFpVNG0vS0t6ZUpSejFqbmpJS3c2T3J4aXY0VzAz?=
 =?utf-8?B?MlFoakN0QzY1QnVGd0c1L1BkZ3B6WVU0RXhVaTR5MTl1K251bllsY3gxUlVm?=
 =?utf-8?B?YzVzM1UvTzVKMDhkMFJIcFlhUjJsLzVJWnpOUFFMd2hyZ0licFlOSnh4b0tE?=
 =?utf-8?B?dkhmL1p3UmM5MXVhTnp0T0NULzlNb0Z5dzRKOWpBR2FWc280eEJ4Z1dwbFBp?=
 =?utf-8?B?VU5OTVpOelRPdFdJVlVrUXRsb1dYT2R4MDQ2dlkwUkZJTUtvUEpuVHNYTWlY?=
 =?utf-8?B?VVIwWXU2TFJpR2k4NHlIVHVGK0t6a0ZTWVFOOXpoTFdRWjRDaW9IUjloQ0xB?=
 =?utf-8?B?czNud1BpWTduV0ZyT1ZOQ0Zkb0JjdE1WcEFYMWtpTjhNaE55U1ZoY2lsY1d2?=
 =?utf-8?B?VnN3aDMzN3RlUVo4TzBDcEVtYlZ6MG0zaGthU0JGd01OOExOWmFmbTR0d09o?=
 =?utf-8?B?U0xlQ0VWc0ZIV1MyTEZKa2xVRXh4a1JYOVYwSjI2Zi9ZQXlMU005T2htRWxS?=
 =?utf-8?Q?ISzGS0EwJrkp3IZ3Z87TvoRmi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108a22dc-53a5-4b19-405b-08da8fd8363e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 07:20:01.5540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVkFKd5VV2K26G00wYDwiDktTMlKQvirfgDBuxQI8S+1ruKPWPgr0altnTxbXjSqZpbXK8GunfPnN/DmP4E+yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7343
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
> This is a pre-requisite operation for adding AMD PMU tests.
> 
> AMD and Intel PMU are different in counter registers, event selection
> registers, number of generic registers and generic hardware events.
> By introducing a set of global variables to facilitate assigning
> different values on different platforms.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  x86/pmu.c | 99 ++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 58 insertions(+), 41 deletions(-)
> 
> 
Reviewed-by: Sandipan Das <sandipan.das@amd.com>

