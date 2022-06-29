Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA85455F26C
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 02:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiF2Abv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 20:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiF2Abu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 20:31:50 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270EB2D1D2;
        Tue, 28 Jun 2022 17:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVdlirQZQwBWkME3K2MF4KSNQH9Ol8B3+6NfwyQwWaJZSpWcCJDArOxl4GI89wDLkLW2JSDYOmoZZ077KG8YH6cE3s08SbRnfdwsg4tyPduXOQP+QInO5WSCn/SAlBhmOkqP4pNAiGlDlwn8ezUg9Cbxm2cSsule65mDY/zuHbv4XfXMxgrTf39nCQgzDCFD9lSVPzMuCobgFG4GtxoEwBtHCsRurJxH4Iy0D7zTx2n3fIGdU8uqX05Y1mTMg51tiHjEMgM4V3SpfJqEA1bNg9X8JXLzamYSOQMsChAGO83ND2jfAS9S6Chg3U7c912SU+VkcJGRxkvM4iWLt4sKjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Nn4MG9VPfk/6zgHTojHrhPiWWseUHED/vJSq1dNiik=;
 b=dY4W3z+GQOfEwEydRsRooLExgHuTF86y+GHNWzCgymN+vy6j5YHySyJMQpble07HrAjkkRy/p2wgQ6HgMwRglItQdtB/KJmdxQzV15kqp4GX/HPjhr9ew0Fh80JTukcTLzLzENUd5vJONpfZ7TfrZpGPsRM0A20VEJ2E/ACjhYagsrqnYWDf0S6bzO8TwXpy4yzTyOouuQ4lnfNVPEwUaDxt3qnAIkHzGN621pp5b+xexYIxuIwsMKfcVLgFDvCors495mAE9B7WmUw1JDtFh3p37BHnMrDod+80DyrkCMFwTZTT3JwR6Vn29Wh0ZXnplTd/NhzmyJbXpZASdlMJxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Nn4MG9VPfk/6zgHTojHrhPiWWseUHED/vJSq1dNiik=;
 b=DQCZGEu5xnTvnY85HpWgB7T3RzgG8v6+bOtGhqV0ZvysBEY3CEHAo0O7tXyo4hRNRydcvOH8woq4kTbD5CIOMT5clpT9R3S+Dagjyz7la+mI41eCXEsTwTVQAykGVFFv1Hu+aGd7v3q8G4z/H+zoC9BYi0SwKQUQD9HVhI5LGEE2T+zvmHXfY45yjDrodotWBL9UbHSZKq8HnuxtxBaqO3cmIBLyhpH8DaG9AjYwWDmcUCFXwtG95Py6pgDn1Z46ivUtUINrIvt2exSdFrG8nE1BsZaLHiT9OX7JKSTkO+5HjI48wxdSuhDYYdY8t6nyILyGw7WK25XFcia4ySw47A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BY5PR12MB4306.namprd12.prod.outlook.com (2603:10b6:a03:206::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 00:31:46 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910%4]) with mapi id 15.20.5373.022; Wed, 29 Jun 2022
 00:31:46 +0000
Message-ID: <177284f9-416d-c142-a826-e9a497751fca@nvidia.com>
Date:   Tue, 28 Jun 2022 17:31:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
 <c196a140-6ee4-850c-004a-9c9d1ff1faa6@nvidia.com>
 <YrtXGf20oa5eYgIU@xz-m1.local>
 <16c181d3-09ef-ace4-c910-0a13fc245e48@nvidia.com>
 <YruBzuJf9s/Nmr6W@xz-m1.local>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <YruBzuJf9s/Nmr6W@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::6) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8dc710c-7e6a-47cc-3294-08da5966bf7d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4306:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9fyt31lGJYv1CNGvrv5SoGdRw8KPmHED0oT0HcJy0xYv7VbbCU3+CGWoZi5vovjybTydSKv1q+benb3asUj6TzdXk+pAuxcHtCfr2dMmei0wCShEY7fam2iW3sMgBVSjzuyKfcDmiba0HyoQEAEIqDHXZagKkA5b71BSD4UvOpSMwqA35mp5rSyvdyDJQ9fxXCzhc1RY4Rkqd/iKnxGmqg4+9WyPvD0teLt7vEkEHIIaQb8xo/VAeUx79HFHmx+/ScTil5XrVP38g15QWtCAE4jknf6Ffgnn2qTyinIGFomaLdxyl8XoRr4Ds+LrBDmxqw1Di98kczE79OadaxAhJ9hsZg6kjToXoP6pB2ELPiG+QNtSg47CDRA7WUwbcNZa6ihW9OHY3rgojCsHBDb4pcWbQFADlsUU3zFaUqwKgWs+2BvFHmYaVAPxHA4L0sme2G6xoOU8tJFgzitu4wHZi8z7v77XqZq9Iru73odL1Znq27SW795mCVl0bbojtcnoc5L5MyHmu0dds8Jt6U8ceTnN19Z1H1U+UjfpYg1ybUxFNjGU0rp9Bd4lsE79K44iaMYWr63yVRUdP7gvVoEaWU+PZG6r+dQ8hARSBHaj9wZU08nXJcf8X6mPH9tDWoJY0b6mHR+gbol75lM/Ugd8sI1BbfcOf8TLnaNJAqQSK4NvEE+zwaNMa2pn8Y2mLf1p9L5E8g9Kz4nbIzl0V8aGkxAAoN+1tkW/Pvdd8Y8Bvo54ACKE95MLOnN989NrbKJBLV1cXqMNbbt0S6Rp1mKwHLFm25EwHR7dP91fFiAxUAn5dwcheYg3Y8t2/kN/LmKkJvrwyCxnDs1J71p9V2Gf9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(86362001)(41300700001)(53546011)(7416002)(5660300002)(316002)(66946007)(38100700002)(6666004)(6506007)(66556008)(2906002)(8676002)(31686004)(2616005)(36756003)(83380400001)(8936002)(186003)(66476007)(31696002)(4326008)(6512007)(478600001)(26005)(6486002)(54906003)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWFGS1llViswRGZOM2FPakdYYUw1dEVNdGxEc3o4NUpGeWVEdU14d0c0c2VZ?=
 =?utf-8?B?TmZLaGUwaWFCSng5dVV5WW0xRTZwdUdTWFE0a004ZVpwc1Q3TFBna1hPQVhH?=
 =?utf-8?B?c1UyMXFWZjJqYndrWXo4MU5yS1lQaERxK0ZWdlNHeTZnT0xxMWlFcmVBWVJC?=
 =?utf-8?B?c3UrT2JXQW1Xd3dRMjl1T24yeXZWT3A0YnlaL3BweTBVTk9ZbTNBTnZMdUxP?=
 =?utf-8?B?NitpQ1dLa2Y4NXhZUXdCVjdhcnVhdGNLMkZyV2FFOFFiUFdLNmc2WDNHcTVD?=
 =?utf-8?B?UEVGUjh0bC80YmY1ZzZqaCtFZ1A1WVphdkI0SzVqOTFSazN3NUg5WHZEcTJ3?=
 =?utf-8?B?R3pqY3JTT1hyVnM0a0MwV1RwWDJlN2tWbzlTYnptY2loYTNCVnhqU0pVcG1I?=
 =?utf-8?B?QmZsWWl4cjVKUDFlK3dCL01rV2ZINUJvRUVYN3ZaTE1TRlRzZFhhV0lLeldS?=
 =?utf-8?B?OUF2VUVDQUhwVnRBMkl2RGQzVW81YzB1c2drSEYwUWpiWWdxdWEyRHB3NCtK?=
 =?utf-8?B?VTZaQVdRQ3NQZlRPelA3ajRxNm1VRnpFcFd2Qi82MVVlbzUvdVVUQlIwK1hD?=
 =?utf-8?B?SmdOQ3lhVC9vTm5BbzQ3V1VPSm1KS2x3R25lSVo3bFFqTDZvNVcvYUdMU3ZM?=
 =?utf-8?B?TUdkYm5SMHM0L2hwb1JwcUcvSytJNENEMlI2WmFUSDNCTGwvSWVoSkVXeWZD?=
 =?utf-8?B?ajYyWFdJUHhqZ2VOd2J6WmwvRVFsM09kVEs3SVB5Nk9TUzU2VkpTLzY1b3pB?=
 =?utf-8?B?TnlIanJtdzRNU1ZKN2p5UDFaU0FIc21Na3Y3d1BOWUt6bWoxVmRER3FvWUtp?=
 =?utf-8?B?Z0FhUkhpN0xOa01UNlU0K08vVUl4NFZvREFLL1J3TlA2ZFcvTzdSQ05YSW5I?=
 =?utf-8?B?c2lQdDFUZG5aSUR5bDN2eVp6c2hjTHdwZnR0QlFYYXd3Z2tkNW12bDZQNkcx?=
 =?utf-8?B?Zm9Pbi9lbDB5bXJQeEMwcjZTdGczN2UwOUxXTm10S3VlTTV0YndXTUlZZDJ3?=
 =?utf-8?B?UEFoQUhyTFRGaXBsK2tFSXZucGFUMUxab3R1L1BPWVpqYm1SenhzMldFTGlW?=
 =?utf-8?B?cUpXa25mcDdwUldzSDM1MkZDZTd3RFZwUzRMOHRtakZuZmlMWUZZUlJLcUlC?=
 =?utf-8?B?d3A4eUFKWWVHNjBzMmUxbDIwMFF6cVlubm1VbEl6MzlpR3VUenFmeE1EWkhX?=
 =?utf-8?B?cUhNNjRKWDd1OHBZVWUvK0tEWXBFNGhCSDR1RFcrTDVqMkc3NjNGbktNaXhG?=
 =?utf-8?B?RHg5cFZkRTg0SkhFWU1RTHk3SWhqMWQ1dnROOUY5Q29VTjA0WFBPeTlDY1Zv?=
 =?utf-8?B?MmNqU0IwUENPSU5oLzN0dG1YVzU1aEI0L0swYTVmSkhqTFpMMjkvWDFhd2tY?=
 =?utf-8?B?UHpNaXIwZDR0czNsTVJEZ20vOWZBdHZGT0ZwS2ZqRndRYytETmdLalJuLzA0?=
 =?utf-8?B?MTl3cGxsOVpBNnNkcVNFelZTUW1JMS9IV2NNeW1sZ0dEWTNIUGM0RG9ZK1F6?=
 =?utf-8?B?RXd3WkZBL1RoRHVUS3daVUJGSDdmMkdOcUl1UFBUYjQzZmZoNVBhdXlIeGNN?=
 =?utf-8?B?WVBxRExyeVpFaHkzbk4wbUs0OEsxUVVQMStGS2J2U1lUQ2h5RUhYeWxuZVg5?=
 =?utf-8?B?ZktnUUx4ZllpZFdLckZXQm05cDc4STFsY0JWUGtkT2JWOVpXUlZHRUVxc3RI?=
 =?utf-8?B?cDI4Tmg0QWtESDBtempzV3ZIb2RXcVQzUlpqQlJ2S01YcTAzd1I3MUIxc01a?=
 =?utf-8?B?T1hLMDlYM25HRVpRQ0Nrb0M3a3hnUjRxYXFibndiZ3lkQXJuZ1VPR00xT0Y1?=
 =?utf-8?B?SFV0QjJoM2JmWGxKWUx4V2c2TEU4eWR2ZU03UkF1SHpWZkVHY2xKKzA5Smsr?=
 =?utf-8?B?SUlLM01BbmplaUgvUDFzRWJQNURma3JUK2IzMUpTVWFZNHN0UHAwN2s1Ry9K?=
 =?utf-8?B?SzJkajdhR3E3b2VNNEQ2emR3YXVGbG5Bc2Q1TXhaWW1SZ3ZTQWcrWFdpa2Nw?=
 =?utf-8?B?MDgybUJacWNsQTJKU1lLWS9VVElVK2VXb2FHOHA4YlBsbGFzeDJseEFqNi93?=
 =?utf-8?B?cnBvT3dmWHVFMG1abll3M2pCT0p4TUlhNDRhdjk2K3cxQzJ3U0RVUnF1K1Iy?=
 =?utf-8?Q?Cy2j8Woyd9JcXWdLTMZ/A3FaX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8dc710c-7e6a-47cc-3294-08da5966bf7d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 00:31:46.1785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CyXoGGJFqk5eAJP3lNCdtNIrq6TTBohFuDo6Bx6YCknoTNE1xXkJ8fADx9pviC+UbPiZNUzPZSZT22Xhq//h8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4306
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

On 6/28/22 15:33, Peter Xu wrote:
>> The key point is the connection between "locked" and killable. If the comment
>> explained why "locked" means "killable", that would help clear this up. The
>> NOWAIT sentence is also confusing to me, and adding "mostly NOWAIT" does not
>> clear it up either... :)
> 
> Sorry to have a comment that makes it feels confusing.  I tried to
> explicitly put the comment to be after setting FAULT_FLAG_KILLABLE but
> obviously I didn't do my job well..
> 
> Maybe that NOWAIT thing adds more complexity but not even necessary.
> 
> Would below one more acceptable?
> 
> 		/*
> 		 * We'll only be able to respond to signals when "locked !=
> 		 * NULL".  When with it, we'll always respond to SIGKILL
> 		 * (as implied by FAULT_FLAG_KILLABLE above), and we'll
> 		 * respond to non-fatal signals only if the GUP user has
> 		 * specified FOLL_INTERRUPTIBLE.
> 		 */


It looks like part of this comment is trying to document a pre-existing
concept, which is that faultin_page() only ever sets FAULT_FLAG_KILLABLE
if locked != NULL. The problem I am (personally) having is that I don't
yet understand why or how those are connected: what is it about having
locked non-NULL that means the process is killable? (Can you explain why
that is?)

If that were clear, I think I could suggest a good comment wording.




thanks,
-- 
John Hubbard
NVIDIA
