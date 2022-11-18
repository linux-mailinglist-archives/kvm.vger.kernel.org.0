Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80D62F1CB
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 10:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241078AbiKRJt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 04:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241481AbiKRJtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 04:49:08 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C181640441
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 01:49:02 -0800 (PST)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI1i91Y011931;
        Fri, 18 Nov 2022 01:48:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=+zc/Qpm4nLph7luQaOb6JUVQLG2kuX+KlI1y9wugvh4=;
 b=mxtF6y4GJLsQufLquXCYs3ALcYDm+8m8jphw9+6j+DBD731LX2EnIZzxrhAE0pqEmcr7
 PiR1rJR+tVMVLrZbOuns1BZ5/dfaFkskEcfEIzC657YG7vNzs/CYQFN8zs2XYCSfiaN+
 Uf34EV1LHZhjECyDHrLm6GGnFXNVEETTPKwWd1l1MUbDDdRj53iUDAl5EuXpbGMFCvMu
 Go22RRmwyB/FExl7DF1JYlcgzKKDGYbuQkHHDRaccGHoQp9smjffHmBVi/qjX+pwDfkm
 TI+TrTXLirFlKdwN4P5n3klo2an52esm6Vxk1KKOEFlAuhmCkFPufXUDr5TL0/eQiVqh oQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3kx0mtrqwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 01:48:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOUvd2wCFBuIN+H0BNQHnTAyaJC8gudVI1LcKFHtCsDOWq+f/hOKBhjP8qW17rLyn4i7fi3HXA4vQTeWr5wUdhBjlrDbCKG08fbxLxhobX/rpJgO1F2dSV9X8tdsQ6HXBrHcRAkRQ0i3Mz11934v+USRg9aHOXijfbt0XGYEIWij11YrcRLBG522rGO3y17CzchtxllkyjGliQdEF0FA+UyQf70DuYgXujyOyHm5jbhCWSDJIjHvdmWqsqTpNCU6vyvaHaZzVu990tjQ/bGCbWolGoVscPistwBCD+aoo7QYgEwZOJga0TEzGHCxOOaJRi/pk2Y0BjmcygdpLB4cxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zc/Qpm4nLph7luQaOb6JUVQLG2kuX+KlI1y9wugvh4=;
 b=mfdHfjmhFQinpRsX1wcueZ5vKGfC7icPWi51C2/+ciDcAFDGONWC7nkVSN6zgDca6SPIuRdlCkKhAjgxpLuENUk03C1qdeaMd6Qxn5EcEGfWlEszPgKjN3mIIfqJhLws3TA7CSsL49xGePxfqm90QpBcYD+5qkd6ga5yIsWYJxiFDjTq8CGhZ51nTxCeo+KoJTMRAmQiG0hyJ1RtN0tWPczT2QQz81bLx0kTBJ9UGvZpyCvfZ5/mtuBt3FD45gq5WIc8liq0hY4BT5hZPsCR4ihAitRZHo68WIqmg475dg+kAeUmXTf/INPDkAF94E8KjDsfW8ULTtS/VtLiUxU92g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zc/Qpm4nLph7luQaOb6JUVQLG2kuX+KlI1y9wugvh4=;
 b=pI1kjNUfdvjBe+ZjyS0qIDWANHuwjkT1WKtciv3J8USAs6jJ1Qyhh+g/ji01a9M+A9d1S6GpGnIRTNVCcASZ5qgziOsxDyqbrkZhGqZ6RcSoVFrFkxNKsA7GwizEjB9fwkAUOz3k7OQZOCEzkPB+KoWoYI/z+5O4w2AEUpdpQ+fE13K5+khVB51jeWa1v9TT02zBKHkSV/rpSERT0WMtYo6uB9K+oh6fXiPoOj4544lVihzr1+5Y8vB5cBfZSmCElVc9tbKeXNybjecj47FzxoBUWCQl4SgKGe656r9ajpmlr6Ae8fijoVsUgqgHwr5MWmX9oFmpEu1lcezHcl/5EA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DM4PR02MB8981.namprd02.prod.outlook.com (2603:10b6:8:bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Fri, 18 Nov
 2022 09:48:50 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%6]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 09:48:50 +0000
Message-ID: <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
Date:   Fri, 18 Nov 2022 15:17:50 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
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
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <86zgcpo00m.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0079.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::7) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|DM4PR02MB8981:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ac350b-ccf4-4a0e-775f-08dac949fb27
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aMNRj7OJggWTkkxvB1ZSTNwhYzTva7UvUaF92o4jq0Ymuulhl/ZXkkH/xl1t5o8GEd1xwftdYQmTKGr47UDSomMEbE7bL0k0PeNGoPR4g79wAXckoubE0zq5OIUX1+ZucReTDXTH8FBZhBLqPXy52ir/YpLFMnyhgFIDw7P0SmewENHT77bYsalbRboF803GSBo5yDZERR7VNhNkjhECkbnEhwR9onkdRx7PusWz0jcbctqzV9rF6VuCFT4M5KNlXNsHCpWgslBKKrTJOOyoxZ+o7aft/zW/apiDH7UH2aBziP6SaNTyzCmq7+0mC9bXXQc4Ji3E9gb1lJFILI+DStGzyUE8+PRKd7ZuR8CDV7NDPED+B2y3xDdwZl0LUGzlRHcz8Vi6DpGDgjeqoZtdloXePjn/iaRFBUDIIuWykfsdAsBYyDJWe0ksHP3sPx+RJmWMf5HE7gPM9jiqyq9+YmKeUm2MAATBPHyhfgev7CYE82sonIB5rrPyFy9HtDqqBW3BvlkCWxXPQgwTkamCksvWT28U4eKNuE3i+kzTfjM9wWJfe7SpGEfCfr7HcGFLQIT2oGpIrkSEZ2ROnpxTHrDX2ZLuhg2Sjy6I9Y4/BP2U15BEVpJx86rdHBrAK1EWTWY9E/sCqGlcZKr5pNkDTaSGAjVNo+dOV/rMqhRzW1q0LILwq3u8Fpmj72cZ7A9LaBRuNHpL1pOTuRKhpjB0XD7aU6a4UY+H04RaFDONcwpN4jizQCERffE+QI6oRxal
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199015)(2906002)(31686004)(53546011)(36756003)(6916009)(86362001)(41300700001)(31696002)(6506007)(6512007)(83380400001)(186003)(15650500001)(4326008)(478600001)(107886003)(6486002)(8936002)(66946007)(316002)(2616005)(8676002)(66476007)(54906003)(66556008)(38100700002)(5660300002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkRqSnU0cnEzMVc1MzdwY0h5YjNBM3VlRjRsU0VzR0NqMWFwTWVIeU1HeXA4?=
 =?utf-8?B?S1pJU241bklQbFpaTEpUbS9mbU9MaGVLNEh6UmV5SGRzaFZoKzV6Q0pvMXZ4?=
 =?utf-8?B?TzcvdFN1ZEJZN2x1TWRlVEowckVlVkVSTTdxRE5wcXU3Y1JZVEFYeUxYeWRU?=
 =?utf-8?B?M2VRS2hBNnRMbGt6eEFsNzZMNGhqc1B4M29iY0FCamhzR0VwVzMxaFdFY3Z0?=
 =?utf-8?B?L09BdEl4K0FEY1lQR1I0dWtaY2NTVElIMmw0NDQrUGw4aHlpcngrUXNuU1p1?=
 =?utf-8?B?SWRFZ2EvTlJxR295Q3ZCY2hrQ29EWFllTWdLWGNlbXA3Z3hzNm9GSzY0dDlv?=
 =?utf-8?B?VmRxVEpQengxY1JhSE5zdmN2bW5LeE9sdU1vZGhnKzlmU0p6MnI0L2xlUXMx?=
 =?utf-8?B?bjdzSktnalc1UUlibnhVYytxbUVXTVU2WkN4RWV5L05ROFlNV25KdzNqMGRY?=
 =?utf-8?B?eUxEZHRGVmdWSHFCcFQ5MlExcjd6RVhSbm9MY01PSHhRYlRsQ1FzUHUyakRZ?=
 =?utf-8?B?YW0xNnQ4Z0RaTEl0dXA1eTRXSTZOcDl4Um52T2hpTzQ1UnVrd0RURVNYTzJy?=
 =?utf-8?B?cmhTSzlpTjVlYVRsTTE1Yk9QTFBxYXlGSGlFZXdoN0NiVklTNXZKcWF1d3RB?=
 =?utf-8?B?b3B5bGNnTnE3SEIyUGE5Q0o1dVJPU1IxSEtwZ1RRVHZWUVFaTmlJbXZ4SlVQ?=
 =?utf-8?B?MkFlR0Q1WjM4UGZXcmlNS3l3S3BzNkhkTnNzb3ZOOWdXRExNUy90QXZTVVZZ?=
 =?utf-8?B?a1hGR2pocWYydUlTOVVyZ3JOZVliSHBDR01oMHVIWmxKTkZxWTlNZmZUdS9x?=
 =?utf-8?B?aDFIZ0dseUlaa0tDeUxwQXpEVXZDbUNLNWRWbTJKZGF4QlpiUzkySERCek5P?=
 =?utf-8?B?N0J0ZmtYQTR2Tlcxdnkxc1VFT2xUWC9LYld3eWlhUDhaV2lHc2tnblRlNHp5?=
 =?utf-8?B?MVpkKy9BaFhHNkZQYU1EekdyVzFLcjl2MDNQNmQrc01BK21PWmJhREJueGdn?=
 =?utf-8?B?eXBDSmFRcGhydnFLY0hsQmN6aVhCWW5aRCtwd3pIMm05MFJyWEszQnZwb1NO?=
 =?utf-8?B?NGJocklvNG16UUEvNjB6a3FBQ09CSlNFaWN4ZS9RR3I1Z3N3R2ZmK0ZGTllY?=
 =?utf-8?B?SFo5dmMwdks2bFErR29lZlF6RVRMRDBaakUzVnB1djhsRHBPeC9kMk9ZWlZQ?=
 =?utf-8?B?YitsYzVOWlU3czlhRHRpOVdCNGVvSlJTeFJxN3dZRnhWNUdCTVpTV0NXVm1W?=
 =?utf-8?B?RTRzNW5qY2EzSjVnYnMvaThKcVh0Y21SKzJZR0xySWZpbFdNc0FqZmlWbkV0?=
 =?utf-8?B?MWtDNGdOZlVyUitRbW15c0JXUm9rWmh3aWJwZjRsTXdBdDYyRzI0SitCL2h1?=
 =?utf-8?B?ZCtYNVRCdWlaUjk2cEgrTXNMcDBVa3I3citSWFpTNDB2QkFhM2hTMGxaa1Nj?=
 =?utf-8?B?SmVwKzBBVHR1WG9neUFVSGhMUXh4ZjdhaGVwZjJDdHZwVXlwQXdZSGVWT3Ex?=
 =?utf-8?B?Z1Q2eXp5dUVjZGNPaU40bGFxcCtnRnltdFR0cFc2SW1GcDVxRnR2VDlzTEtQ?=
 =?utf-8?B?U3BDWUozTTlURzZKRk01bHB1czFZNkdURnNGRlR5YzlEMFZIT3NEdXYzUGpi?=
 =?utf-8?B?SnZva2hTM1FzNVFSODl1ZlFkSmFaS3dPT1dydEwwTE1WcVl3T01TMlMwMnlK?=
 =?utf-8?B?a0Q3c2VQMGtFaWtSUkVZMlZhSG5WOGZIMUdMTlRGNW1Hekg0ZW9nQkVVQlpm?=
 =?utf-8?B?TGVSUWZ3dXc2MStOV0RKaldwallIRDBOT05JY1JJL3FWZ1MwNksyZjNwMVNt?=
 =?utf-8?B?NGlXL0ZRcGFuOFhVTUljMG9BU3dCQmZ1ekJtOXZhRVlTdFQxZm92YTZJUHR3?=
 =?utf-8?B?WE1QSEpkRmdlWGtKVmgrbGNiem1xS3ljZFJKUkxpOGRJbVQxYUR3eENkbEg3?=
 =?utf-8?B?MUtIZDNiZmp2WUVxN0orM1NQc3cwQkEvaUFjVkRiNWpEWThFNUwreGVPbWtq?=
 =?utf-8?B?cFIyaFlSVmh3UW9pZXJsQnNtblZOV3NRVW94aThIT1d5ZUh5a1RXOTk4c3dl?=
 =?utf-8?B?WWFMWlNlTlFmY3RnSmI2VVp3THMzTEorVDZmR00zK1NROFZiM1BUb2JRVm4z?=
 =?utf-8?B?MW1LdXVnZWpLQVJmK1gwc2dLVU5GQjY3eGt6eDRRWmg4SVpKUWtCQmhUUStB?=
 =?utf-8?B?aWFUc2xIbGVqQURtUTlhbVdtZkd2V0VqdGxKODVZYVkxL213TlhIS2RmNGJq?=
 =?utf-8?B?TExBWER3K2w3Z2phUnk4bHBGS3RnPT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ac350b-ccf4-4a0e-775f-08dac949fb27
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 09:48:50.2512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SrmIPEvJ+uVL0tU+Iq3a3qEKwM2ptJgkPLwo9zFUQsZ8QjjoBjxZit+0LS4noMdZz4K/vkUK5ROLd/pjKvuTgIaP3rSe8KdxxunUEauPEaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR02MB8981
X-Proofpoint-GUID: 1W2KxREsX-WpaTyZIf2W9yaPyuKoAV0R
X-Proofpoint-ORIG-GUID: 1W2KxREsX-WpaTyZIf2W9yaPyuKoAV0R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18/11/22 12:56 am, Marc Zyngier wrote:
> On Sun, 13 Nov 2022 17:05:06 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>
>> +    count: the current count of pages dirtied by the VCPU, can be
>> +    skewed based on the size of the pages accessed by each vCPU.
> 
> How can userspace make a decision on the amount of dirtying this
> represent if this doesn't represent a number of base pages? Or are you
> saying that this only counts the number of permission faults that have
> dirtied pages?

Yes, this only counts the number of permission faults that have dirtied 
pages.

> 
>> +    quota: the observed dirty quota just before the exit to
>> userspace.
> 
> You are defining the quota in terms of quota. -ENOCLUE.

I am defining the "quota" member of the dirty_quota_exit struct in terms 
of "dirty quota" which is already defined in the commit message.

> 
>> +
>> +The userspace can design a strategy to allocate the overall scope of dirtying
>> +for the VM among the vcpus. Based on the strategy and the current state of dirty
>> +quota throttling, the userspace can make a decision to either update (increase)
>> +the quota or to put the VCPU to sleep for some time.
> 
> This looks like something out of 1984 (Newspeak anyone)? Can't you
> just say that userspace is responsible for allocating the quota and
> manage the resulting throttling effect?

We didn't intend to sound like the Party or the Big Brother. We started 
working on the linux and QEMU patches at the same time and got tempted 
into exposing the details of how we were using this feature in QEMU for 
throttling. I can get rid of the details if it helps.

>> +	/*
>> +	 * Number of pages the vCPU is allowed to have dirtied over its entire
>> +	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
>> +	 * is reached/exceeded.
>> +	 */
>> +	__u64 dirty_quota;
> 
> How are dirty_quota and dirty_quota_exit.quota related?
> 

dirty_quota_exit.quota is the dirty quota at the time of the exit. We 
are capturing it for userspace's reference because dirty quota can be 
updated anytime.

>> @@ -48,6 +48,7 @@ config KVM
>>   	select KVM_VFIO
>>   	select SRCU
>>   	select INTERVAL_TREE
>> +	select HAVE_KVM_DIRTY_QUOTA
> 
> Why isn't this part of the x86 patch?

Ack. Thanks.

>>    * Architecture-independent vcpu->requests bit members
>> - * Bits 3-7 are reserved for more arch-independent bits.
>> + * Bits 5-7 are reserved for more arch-independent bits.
>>    */
>>   #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_UNBLOCK           2
>> +#define KVM_REQ_DIRTY_QUOTA_EXIT  4
> 
> Where is 3? Why reserve two bits when only one is used?

Ack. 3 was in use when I was working on the patchset. Missed this in my 
last code walkthrough before sending the patchset. Thanks.

>>   
>> +static bool kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
>> +{
>> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
>> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
>> +
>> +	return dirty_quota && (vcpu->stat.generic.pages_dirtied >= dirty_quota);
>> +#else
>> +	return false;
>> +#endif
> 
> If you introduce additional #ifdefery here, why are the additional
> fields in the vcpu structure unconditional?

pages_dirtied can be a useful information even if dirty quota throttling 
is not used. So, I kept it unconditional based on feedback.

CC: Sean

I can add #ifdefery in the vcpu run struct for dirty_quota.

>>   		else
>>   			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>> +
>> +		if (kvm_vcpu_is_dirty_quota_exhausted(vcpu))
>> +			kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
> 
> This is broken in the light of new dirty-tracking code queued for
> 6.2. Specifically, you absolutely can end-up here *without* a vcpu on
> arm64. You just have to snapshot the ITS state to observe the fireworks.

Could you please point me to the patchset which is in queue?


I am grateful for the suggestions and feedback.

Thanks,
Shivam
