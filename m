Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1197E6469A8
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 08:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiLHHUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 02:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLHHUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 02:20:41 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF41A429B0
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 23:20:40 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B80U6kK022336;
        Wed, 7 Dec 2022 23:20:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=e++65hNf/jlPeAh5GFYIF6xm8XuHoCvWfxbr7Wca+cM=;
 b=133CusdbRcuMLYSQT2hhDNqajkzYqR9tfwN/MLT8xDh2VE4YgHMx18IIs4VnTTigXYiJ
 ygy+6TiHYTtrG0o1NtROgGgRbvFgjCxhI7pItlbZipLOe2IWR14jF1mdMoZEcA3LT0Pf
 7Ts7xCMau0qfNjeSkooAR6g3CiCURV5kNXn2WMBUwWO7/PDz/lDLIKTzzDu1ZNPNWktX
 9vWTB3P8RuziHaggL6AIRW1TJl+pGoCv1wUplQObvLC1sEV0F9K+HRXJg7GKekx94k8/
 v7UfQJQKgok86zeS3EXdGTeLYQEwS3qI3HMyQprtZklK9qMoJe+EwbG7Bertuwj/MMuV 2A== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3m838dkdvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 23:20:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyEuGhyCf13jxzUhCoAuM+fz8n60tjuF/yVrsAO3kuGdpRGS4nEsenb/LbFKGaAhtQVRvyX5B9biSbddq5COtt0NMgGu7CdDEfsEDhZb+1R0OW22UZ5deP5zUECmWPISekHh7Oe116/AnGoQrGzEwV/GC63Ey6UIJ11Mkrp4z+gGm3+iNCmASoE5GWqk8J+ukQ+ofR9YQs7kFWMIAh7LS5fBTs7SoICXHei9dVMFso9iWGaDEp7vqgj5YZuSy3+hPoJZRuER5gX2BlWuJaodjM1e+BNVbHzTPkuFPybn0i4DDuvWC9BF35MTChnx/I9FnK596YXTicVwmuozC0TzrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e++65hNf/jlPeAh5GFYIF6xm8XuHoCvWfxbr7Wca+cM=;
 b=O9w7Vg86+qNfoIm7z9J93xO8dbq2CfneJjB62YywHng4K+P9oDidR5tLbBqmg5uHA2uA+f15zzDNFrMxdspADU2P2I84/NT0GgFkQ6YBYBHsljkc++RZGlxdjKIlbHLY9aMi6MxJlGMRlLHvgbT+IFDEkdGI0NHtHgwvt3f1NTPpfmz53Fd2yF3T98L04nKMQJmQ7dgxHbzO5349Z/sLmZeCKAMaXpC9uUjDl+f4JPbdNMIF0rNiVGBsAhcjgoX6lJ+5GPVhhHwAmcc4YueYzhE9lyXvnfoLnLuk45G2GctGHVS+ZDOjMYwwcXoPekvXaESxDtAKgDoPhRy9/M0m7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e++65hNf/jlPeAh5GFYIF6xm8XuHoCvWfxbr7Wca+cM=;
 b=UhOhJKv0zAKNiZvaRColrY0FSZDwQpzJq359fmvQDt83Bh8ByPvdRyHefD7ER27fm5eg8m4ueJ/qtgTKHYb5iOnruYfKqneXC4QMJKjX/T5S04/A5HOCmJ+DCWK8jdpU8+e7qnke5XA40Pw8oM3wPY51rOpk1YLsPVpSvYNphNoYSIGxt1vqxNGPouPZt1rZUGplm/4kkNuPY2GbiNF6C9g4PvxWwcIg96Z5OWLKMxqhxzeKW+fCafdkZIrMKXp+jN9yv5LRPAvRK9ngq3Gp+C3ahIOCtkdCQsSCqUgmzrA4waYSivqv46/jrFC01HLHXumfCDHwG8Ora+jBWUQtMA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SJ0PR02MB8516.namprd02.prod.outlook.com (2603:10b6:a03:3fc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 07:20:18 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%6]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 07:20:18 +0000
Message-ID: <d0f6f409-6e7c-188b-f164-35d3da33d61d@nutanix.com>
Date:   Thu, 8 Dec 2022 12:50:07 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, seanjc@google.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <86ilinqi3l.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0178.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::7) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SJ0PR02MB8516:EE_
X-MS-Office365-Filtering-Correlation-Id: aa451d57-2283-4233-bd01-08dad8eca884
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6NUqlpuc+RvF+9mnL5RUoCaEy/EdYGXqvbx9rUwFzQvF7SpWEdK3IQeyOePo+Qi95W3RmQAypUtUKI0bmG73DVf0S2YQEJLv4X/byU/jbUng5Qia4dNua7g4VEUMg2KPxWA+fk+Hgia57pS30dRvKORXyZm8oTC2YjgwH2bYnbqEBxGbxl5z33JAutMBNadOX8tuxHGXr/XryIzFD/OEKBtsy30OOdFMtUpUbmUqSYGJ2syvPI3m3S7qP7vdC1K6KFfT4rEc7mZPXGEqbm/016ncSJm7e3gFzHYD2yJKtYfao0ddKUPZgYdtgAWL7Z8KbQwMMzAZdo9OruGShpgq1/O1/XjLGg3ir91/s+rag+KCqLIJj0fSQWwIXh4x/T4RAQZmxNmksXetjY2oGOMVJPdBaGOLAAMxLYO6xW6v8KAwxKCi4KoQsNWrmPNeMBQe5VHaDrrRpz8zArYqZ46rpgci7Yk0yVkc+T1EG3sZgOeYg3vxuIvQZIGqSOFNBaONgR8A2zqF61bVv7fW9LxFs9gb0Pg2vJNUAX8GWNoSqMnYYkOZLQy5N54bxmcUHgNS5K0ykYSsVsPo4aM69/y4msnyRvpUdu9JfgJ1AaHNq8meiYs6aWp61cSSPdSCsKjZtKV0SRCm6cwfO/6duP4Bdt6fUy4G/r/TpS6yaffqfkOSSANtjnT159TwPq6pPdwspz5ZAyDgMGMBKo8lpum50XfKcuQjGtstCgWSp6dtPDe6e04INTzq6yvcvD0Lf/c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(36756003)(31686004)(38100700002)(2906002)(15650500001)(8936002)(5660300002)(2616005)(86362001)(31696002)(83380400001)(6916009)(316002)(54906003)(186003)(26005)(6486002)(478600001)(41300700001)(4326008)(8676002)(6512007)(107886003)(6666004)(66556008)(66476007)(66946007)(6506007)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUxNZTd1M0VuNngrcTFZZzhQZjRaWFZWYjVWdGo4WTUyYTNxOU1HYittQlky?=
 =?utf-8?B?S3NkWUJwZTNqRFJ2c0FHWkovTGdESUw5aWQ0dCttWTZPMzZtNGp1NFQxUjhS?=
 =?utf-8?B?clM1K241QXZwVUJNTjRyQ3IvS2xOR2lRdVlUS3BnaWxpeTlKSTJrTHdKT0pV?=
 =?utf-8?B?c1pEb3k2MXVmcVdQVnVWTmFSQjg2VWM0ZTA2OW5RcFAxbDFFcWlDc1BxTU5X?=
 =?utf-8?B?bk0yYUxBV3ZXQms1RnNwend0UlRqYVVoSEIvUmpYZlJJQyszWmNEVVdja3pK?=
 =?utf-8?B?MVhrR1ZtYXNnOHJ5QjI5U0xLRy9mYzYwdmo4TmdOUjRIR0szWlZBZG1tbjR3?=
 =?utf-8?B?d3hVbVF6dXlhdEtNUDFBc1B1YnFvVDhleXQxY1ZIQnI5dVhDQ0xpUWR1WVA5?=
 =?utf-8?B?V01iem5DNmJBYnhsVGNHaGllS3h1aVhxdkhhL0RFdXd2bVQ0aHlRdytPRFVZ?=
 =?utf-8?B?eVRxUzVLWDZuYVhVaWVOVzNFV2d2TFpKNk03WXBuRnptUjhrcHdVSnRiZElS?=
 =?utf-8?B?NU1lWW9jV041dlo5NU9EakxCQjNpM3p5YWY5U3kxOXcyZmxqUUpIa3Z1ZzBE?=
 =?utf-8?B?dnczdHRVRUJTOXdHN1llOXFPT0hNZFovSTJUYW82VHh3aVY5eFpFVGlpRDlM?=
 =?utf-8?B?bmtoanhKUzZUdW9IRGo0MWpSSXl2WWNaMGx2Zkk0TEdrZVk3YTlqdGp1ZjA5?=
 =?utf-8?B?MWNxOE93eWUvUmZWRUFObW44TytYRHYxc3R3MWVNVDBGZ1BwU2d2Q2RyVWhW?=
 =?utf-8?B?WUFucVZLRThLeXdpOWV3cnlHUjV2aHU4VExjcTVQNGhDQ0M0R2NhdGVVNXBV?=
 =?utf-8?B?NzlyaFRCOXBVaTdYV2ExNzhUYy81SlR0QktvWnpJblRrSXJmdkNMdlN0R3dU?=
 =?utf-8?B?QVU4YnA1ZzI1eGtSa1I2UUJUTEdQc1c4T2IycEJmRGtPWUJWUlhGTTFzOThI?=
 =?utf-8?B?VVVYbDZzMU93aW14bDZTN21QV3JIbEZ4eVdSbzB3Z2o0Vk5qQURmNDl4MVY3?=
 =?utf-8?B?T3IrSU1SZDhlN21mMXU3ZTR5NzIxN2M2a0RMbys5dUxMSloxR0hNdTZ2L09t?=
 =?utf-8?B?b2l1dmRmdXFKTER4UVRUc0RmMWtlK2wvblVjNmxyNmhibU5iRUUvTkh0UDNr?=
 =?utf-8?B?aXBIc0pJdEtrcS8vcUJyczh4eFgrUUpJU2VYUkE2T1Z4OHdUZ0NWbTR6NThq?=
 =?utf-8?B?bmZGaTQ5cGc5U00yaVNjcGhoMEhmM2Z6dHhVeUtrTC9xUFh3UWsza2VZOGN2?=
 =?utf-8?B?MGFnNCtiQXh4M1M5aHpmWWwzN1krK0dTQURoTldHbm5GQWNzVk54OVRmTzMz?=
 =?utf-8?B?TDhoZmVqSloyQzd6ME9TNEYyanZsdjZTZExGZ25BZVlrbTY0Mkc4Rk0zNWJP?=
 =?utf-8?B?TXVkQTlPVlVKUTVlcGZURDh1Z0toa1Jid3BLT1FMNFR2aTkyUG4wN2Mvb0pC?=
 =?utf-8?B?bjZXeDV4WUlxbTJ3TXZaeHdha1l3Uk9aU3Vmb3ZoUE1tbTE3RjllNGVDeklw?=
 =?utf-8?B?RG03dHdVT0E3MU1WVzRsK09sd3QwWVVEbnhzenpldzVnM1MzS29VeWVvMFhC?=
 =?utf-8?B?aHBjWTkzb2ZPZVRYNFRCdHdvbUxqTTd3Z1N4VnZ0bkhuRXlCc3R6eEcvZ3lS?=
 =?utf-8?B?eit5ajNyY0ZtcWJDS2doa2FJUUZFOTAxRjI3UzE4TFRmUitVMCt4MFFDY2Zs?=
 =?utf-8?B?ZFRnQVQwTUZUUlhhdW1VZjNKSVRneW53aGJWSGhmQmh6K1JJQzlXMWZyR1Bu?=
 =?utf-8?B?dmRFQlQrWEZnWDQ0aXFyUFkvVWtobkhoTmx2V2dWOUZpMkpYSVVnRXFYazhV?=
 =?utf-8?B?d3VsSTNyRy90YzhHbTlkSWd6eE82bG1VcExyZFhiWmhwcDJTa1VuQ0l0eUVp?=
 =?utf-8?B?bDlSUmQ1bERXa3pvSUV2OFVMUXZLR1BGUDdqd1MzZytrcVFNNkw1SVNQUWRl?=
 =?utf-8?B?dGxYQmE5WWRpb3lrUGNGeGRVSkZmVnp0Mk1FeGU0Vk1uRWk2M2l4SHc1c1lV?=
 =?utf-8?B?NzUyVXV3RUtNRWlIcHQvQlJvRE1iL2pMS1Z3S1dFL0lod3lZTWlSd28wMFZF?=
 =?utf-8?B?ZXo4L2NMUFJBT2xtREd1STVTY0g1U3puYUxKcEwrUTBBNjRsNjN2M0h6ZmNl?=
 =?utf-8?B?ZDdPVUpHZFNzSXV5VERaSzV6TEJLS29tcjl2bGgyUkZLeUN3dFJIK2pvM1Z4?=
 =?utf-8?B?akE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa451d57-2283-4233-bd01-08dad8eca884
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 07:20:18.1072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JFKMdixJuB9EpZE4zldPH7xDCsYLFEhmGmYm5gaJmYHL/d2SyFAeDdcN+sM+Ht7S+Kh9koCgpNH3/iRNP7r25bsW1NazPi35r5aepe0Y1Kk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8516
X-Proofpoint-ORIG-GUID: XAaEQ_8DFYsIIlaaBvMDOa6TOmn9I4Lg
X-Proofpoint-GUID: XAaEQ_8DFYsIIlaaBvMDOa6TOmn9I4Lg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_04,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I'm certainly totally opposed to stats that don't have a clear use
> case. People keep piling random stats that satisfy their pet usage,
> and this only bloats the various structures for no overall benefit
> other than "hey, it might be useful". This is death by a thousand cut.
> 
>>> And while we're talking about pages_dirtied, I really dislike the
>>> WARN_ON in mark_page_dirty_in_slot(). A counter has rolled over?
>>> Shock, horror...
>>
>> Ack. I'll give it a thought but if you have any specific suggestion on
>> how I can make it better, kindly let me know. Thanks.
> 
> What is the effect of counter overflowing? Why is it important to
> warn? What goes wrong? What could be changed to *avoid* this being an
> issue?
> 
> 	M.
> 

When dirty quota is not enabled, counter overflow has no harm as such. 
If dirty logging is enabled with dirty quota, two cases may arise:

i) While setting the dirty quota to count + new quota, the dirty quota 
itself overflows. Now, if the userspace doesn’t manipulate the count 
accordingly: the count will still be a large value and so the vcpu will 
exit to userspace again and again until the count also overflows at some 
point (this is inevitable because the count will continue getting 
incremented after each write).
 ii) Dirty quota is very close to the max value of a 64 bit unsigned 
int. Dirty count can overflow in this case and the vcpu might never exit 
to userspace (with exit reason - dirty quota exhausted) which means no 
throttling happens. One possible way to resolve this is by exiting to 
userspace as soon as the count equals the dirty quota. By not waiting 
for the dirty count to exceed the dirty quota, we can avoid this. 
Though, this is difficult to achieve due to Intel’s PML.

In both these cases, nothing catastrophic happens; it’s just that the 
userspace’s expectations are not met. However, we can have clear 
instructions in the documentation on how the userspace can avoid these 
issues altogether by resetting the count and quota values whenever they 
exceed a safe level (for now I am able to think of 512 less than the 
maximum value of an unsigned int as a safe value for dirty quota). To 
allow the userspace to do it, we need to provide the userspace some way 
to reset the count. I am not sure how we can achieve this if the dirty 
count (i.e. pages dirtied) is a KVM stat. But, if we can make it a 
member of kvm_run, it is fairly simple to do. So IMO, yes, warn is 
useless here.

Happy to know your thoughts on this. Really grateful for the help so far.


Thanks,
Shivam
