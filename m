Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1835F8D34
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 20:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiJIShC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 14:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiJIShA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 14:37:00 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B93325597
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 11:36:59 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 299HqeWT006210;
        Sun, 9 Oct 2022 11:36:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=bT8qvSMrDIUSbLWS6FGaDqXUE30vUW1GGyLU5Nj9onk=;
 b=xMp22TkxG4C6Z013i3ms17mprwoCkV9YNe2pX3Y5MK5KKyBQqxrxzCxyHdr0F7GgTeV8
 KdMUHqzvuZ9y1rxysQXWIRp3u37xdwK4NtpHsPx1LAQy6NElnylULeGcbl9gNUElvuLh
 DvC3X8Qn26PciHc5i5sqkKC5OyXTGL895TU0M4E4W3ZWIm0+x9kJ12yNsPkNd2qgMhmM
 VLi7xacf4+UDrZQ3+FRPVgIugOGd+2Q53g8TqNwcFTnkhsidILfEhSac9cjJoSmpkK5I
 XxurXw5piL1DUln2sFFCdRZgOPsQsDd4a5va1FPzrmLgpcGN8Kmroi30CQvfTGh2NitF bg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3k389gj34h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Oct 2022 11:36:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgf3D9lgQZ8/og6rOJ6HLKXDiY9+i9wlSMSo1H28gnUj126wb39FYyrNIGqXlFKW/y8J9gYS0q3U4JpH0dTL8VkCJJEdwl1WiLP5AyBZxJgMVdGVvb++yRMmrVHHaGyxs6iKH2tEB91V9jjPKXhsO64tyLGtGCT3/+kRv1V7TYV7wf1Rsv18YkLPd4tUcLBpVBKXZmgB8HGRyYHq/Hc1Yc6v44Hrv8wYfHSVslT2I9+ri/lTFCCBentlTf9iFOlaHDptcq+QggbdbibCp0XwWpyMq/86Kn/CAEGWrVNulv8qpzkFr60oTEeQytrz2qYKA0MXfHNtmdO1KMEjuapjIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bT8qvSMrDIUSbLWS6FGaDqXUE30vUW1GGyLU5Nj9onk=;
 b=DWhw4SDnYyOij2yLWqcBfUnlQYkDjZwlt6nXtwKmilW53u45HYG+QYusrNOTb37y/EedXGFAqrsTKNG05y3hL14DRmKVdA7l643gdV2PuoH5vTXRQyHdDvq/AvsEXQxLyC//eQvhTRwgcCt2JTxm6QXYdfNVNIgjUcFUnol2elvdphC7tP80fKX+Ya/3qstyXdqYOEIiq6+UEB8PcM40b4fPKAZOj4285Tl6/b0cTLoZ7hc3Lf8wIXdywYMq2IbfxccU6LonM4e81Td4PU6p2y9ylguzs+t1tZgOmx/WMI7/N8opFRRknL2yUJzXZbBHJAqHmnEz1sE5IpDmhWM10Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA0PR02MB7436.namprd02.prod.outlook.com (2603:10b6:806:e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Sun, 9 Oct
 2022 18:36:38 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2%5]) with mapi id 15.20.5709.015; Sun, 9 Oct 2022
 18:36:38 +0000
Message-ID: <f0c56ea6-71db-450b-f978-e801524cf025@nutanix.com>
Date:   Mon, 10 Oct 2022 00:06:20 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Sean Christopherson <seanjc@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        david@redhat.com, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <a63becdf-18d7-25f1-9070-209dbc008add@linux.ibm.com>
 <52ad1240-1201-259a-80d0-6e05da561a7f@linux.ibm.com>
 <Y0BtWixstpm/fFlE@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Y0BtWixstpm/fFlE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXPR01CA0113.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::31) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA0PR02MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 258c66e5-0093-4310-eaa3-08daaa253311
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QtFN0YF7Xp3lXtcXZmjf2JXj1ED/mxOZgh4yHGp9MeEQkGmfC74wXIiLjuGT/8h0VElXI+0+zgMr/IMcwvX+wEe6s5ONcsKJG65BM6aI7VZTOritd0CJ/PIl5zup3UQKg77HWMpyi+E4funMNTTI6cll1ypp0YbHmCAfXWLunKwMy6AbmleozwYcuopdJX6ae0fCIyCtJPs0U79eOoZJToQJCOKBpKDz/xt9d1o3TPMXAJJ2rAvoBpxHqJtdEXkkBVA6bMYbUpPuLSR+KrjgyKod6VAdaGdDUUoJrsANEXd5r6c8k9F2jX3ccLGVasDLtClk/l4gcJ9DUI94+nbzyNNOjpfrzcP+RzkobM7auZUw4MepfgC+jvQAR+1Jk3pPgtFwwOIw0xNWDoR1yQKiuqSbZhBHLFUrMar5Hl3odPgxBjNIhFtLte+PReD9CSRnCKiGfNX8Y0QdV/snAgbHpigyqBG9pO7PRFNhE+uh2vK0CejNJS3uKE4kFS3tHLVSPDvfkxNvidneFtkqe8Is3MOsJuTFgtkyC1rKiwsyMVoVk1y/icf8pPpwU6iymT+pl0LEPZQweXWKAXvZiR0w34/ZWVkuIi5XgD2wwubYvchDrZ73CIP43AiCTCC5WgqOIzhSC2G93tamcD1gN4S458lKv5KB0eFS716mfUiGunOxydbatDlSSDBnuUOeauJY1w8mP4smf8hj/L9sJ/XRkEzNIu9S6EFfzwYIdkYOeVgAKNe7VwHk3ba5XIydxUSmziPgzWWHXo6AflGDRY+xaOXoc6FUGtm+jpGRuMH2qcSFqHmLbA3PEstBA1s7+Enq8/7D8rcFzBlnYRQt/joaRrF0b3OHhYRJUMxdyQZiDHU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(346002)(39850400004)(451199015)(110136005)(26005)(2906002)(31686004)(36756003)(6666004)(6506007)(4326008)(8676002)(966005)(83380400001)(316002)(478600001)(31696002)(38100700002)(53546011)(2616005)(15650500001)(86362001)(6486002)(8936002)(41300700001)(66556008)(186003)(66476007)(6512007)(54906003)(66946007)(5660300002)(7416002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEkxNFdTb1dYcEczTEREODBvUml0WFRScUJmODhyalU1b3RveGVJS0IzYlg1?=
 =?utf-8?B?blcybG1rRmo3WTFLZTQ3RGtwUFg0TDAzOG90NEs0eDFJNXBUQUxkVnNyQklE?=
 =?utf-8?B?KzVnSnJwZEZ4NXBZR0RaMFVuLzJwSlpBanpXZDBjcy9FeHRSK1RMd2IxejVk?=
 =?utf-8?B?SUVYWjRKQlF0QmhTOGZjc0ZreXcrdVF5blEzdWdiUnVGMENVMVo0SFNqMENn?=
 =?utf-8?B?SlRFQ0hycTVSSXpqcm9DQXI5dUFwUm5wdmRNTTBVVVpuUWFtOGdLd01hYS9j?=
 =?utf-8?B?NFg2dllBWmFKMzJyYWZtU1YyRTduRXJ5Rm1JdlhlczJ2eXB6NnA3RmtRSnY5?=
 =?utf-8?B?UktCZTV4V3R4MGtKUzZrcDQySEF0MFVwM1VMTnVIbnZtam1jd29NNlZGQ1My?=
 =?utf-8?B?d0hoSDVVRHl5ZVllRnhEMWFhekVZT0Y5NmNIOG9EL01JYzdoUitWWDlCb1Fj?=
 =?utf-8?B?M0lmV1ZYOWllYzRSU2tHOFJzUzd3cVg4eWVjelZJd0d3NFpXMzRhandKRk9C?=
 =?utf-8?B?Uzh3MWkvZHFRQ2I3TVg5RWR0WXVZbVQ5SzgwK0d3RFB0dk83VHNOczQwUnJw?=
 =?utf-8?B?bmJoazl0U29mU3FieGp0QlFBYzZERVZ6N0NHazVlVGVKOVR6SkcrdGVtd1hr?=
 =?utf-8?B?RGF1Wm9LVVp1emRCQ2dZNi9UdHBpZlkrbmFqYTU2N01YMnJ6TE9BYnpwa0h3?=
 =?utf-8?B?bnA3WjUzbzg2SzJJWHFrWXpQRmFOeFpFd2J3Mkw0OTViMDFEZWpqQ3pOZGpV?=
 =?utf-8?B?ZXVpT0FDanZUQjdldTlLK2pZL1dIUytrWktjc3Q5RE5SR2lNMS9ZbDRHYzRq?=
 =?utf-8?B?a1RzR0E4TXZINTErQjE3aGhIUk5vcVdMTUU1SmhlQWhuZit3TTRRY1pJL0Rk?=
 =?utf-8?B?TWZTcWFQMHBiZDN3eW9adFYrU0Z6MkJodVpaVEFDOVZ3TVZmOG1wQ3VtUCsy?=
 =?utf-8?B?WWV1QitZWkZ1d2tCbURYeXJaTGZMZTZMSy9Ia0xVWG1Ua1JQOVR2VEpEM3FO?=
 =?utf-8?B?Yll3bjc1eUVya2VYei9BM0xMS3lGS2dGaEVNeE5tT0VQOE5HeHZJS3h5UXFk?=
 =?utf-8?B?anc4NHNCc0V1OWpsYWltZU9pZ0lUbkc4Y2h6cHN3SFlNakc0bWY0TlZaR0JF?=
 =?utf-8?B?eGFsRUxwalpRWWt2d0wweWhnUXdzYnBJTmFDZDJScUx4UWYrRzVicTY0dG1T?=
 =?utf-8?B?TGh6bHhPN2h4bHp4c2RDc2ljQ09RSGgwbFBhbnB6bWx0OTAwZTBDQ3ZQMklj?=
 =?utf-8?B?R0E4YStBSE84T250TjdkdGkyTDJZNm9MWmg1b3E5UmJWSk5xMXByVCtleURk?=
 =?utf-8?B?RDFZa2VrSVZvOHoyblRCV1dXV1FEU0VhTFlabHZ3eEZQYURxaktSbi80QnNU?=
 =?utf-8?B?Vk9wblNGOG5TUHh3VjFQVUg5WW1rMDF5V2dRSzJpMERUaElNV0puT0Jmc1JT?=
 =?utf-8?B?cktraDFaMFZTMG9vcjNHZTdySWk0eFZQZzhJV1dPT3I4ZERCcXlWMWhKRGMz?=
 =?utf-8?B?eG13M3F1cGsyUCtHZmJyTWg0cHRMNUp4VjVhVGlzcHpYNFJLY1B6a0FKdEdl?=
 =?utf-8?B?Yml3ZkczRVUxMWJpUVQrb2hBN2NiWUdxeHZwUFRwRHpqemRmK2FybjN5NEk3?=
 =?utf-8?B?bStjNlc2MnJ5RVFBdHBabFZLUkh3QTJNN3NPSGxjY2NqQU5FRzFld2hFU1VQ?=
 =?utf-8?B?VlVoN0lRMGVDa09RWjhoUHR5dnBzMUNxeUo5MWZRWWJWR0oxRjI2M1FsUkNS?=
 =?utf-8?B?N1pnSm5DVDhQQVBxTWpRNWZKUTVSMkVxdjEwUlN1SkJKd2kwMms3dktEVDQz?=
 =?utf-8?B?U3VSSmdYM3U0L04vWmFzWkVDSlVrUTR0dENlc0tqZ3B6cGRnMkxsV3hZRXpw?=
 =?utf-8?B?VVN6UEYrdWtkeVAyVGJXODlVeVk0WEZPL0Z2S3ViWFRzcmxjTHBrenJrWXhB?=
 =?utf-8?B?bnJydDdsc1hIbm9kU0wrQVBIZ2NDK0hoTFhkSDdwZTltenp2bVN0SW52cXFS?=
 =?utf-8?B?NGF5ZHpMbjVkcllwK2lua1lVSmNWZFdHM2lobExKMGRvY3ZoK1czYTFMcUlo?=
 =?utf-8?B?a2tjVFBHZWN4enFLWU10TTc2dGZZZ2h5MXRkUHcxS1dyNXJWNlpFeEdxMW4v?=
 =?utf-8?B?NXQ0NmZjK0RYQlMvdWp2by9FTzlRVjhkSjhTZFBmdzVnTTBCdXpqME5QTnpi?=
 =?utf-8?B?bVE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258c66e5-0093-4310-eaa3-08daaa253311
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2022 18:36:37.8200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAahgFe6mFe0/atwfJVLrkc+wtN7drZceDRbFBUkSORO1UBVhS4/TQvAGMT+RbcSSuDcEndnTdMicTV/nhzjEkGIWbjg1TsdvL68cDuspus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7436
X-Proofpoint-GUID: F_7lMTbD0l52_-npcf18mWzEGQroeoyM
X-Proofpoint-ORIG-GUID: F_7lMTbD0l52_-npcf18mWzEGQroeoyM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/10/22 11:48 pm, Sean Christopherson wrote:
> On Thu, Sep 15, 2022, Christian Borntraeger wrote:
>> Am 15.09.22 um 15:21 schrieb Christian Borntraeger:
>>> I am wondering if this will work on s390. On s390  we only call
>>> mark_page_dirty_in_slot for the kvm_read/write functions but not
>>> for those done by the guest on fault. We do account those lazily in
>>> kvm_arch_sync_dirty_log (like x96 in the past).
>>>
>>
>> I think we need to rework the page fault handling on s390 to actually make
>> use of this. This has to happen anyway somewhen (as indicated by the guest
>> enter/exit rework from Mark). Right now we handle KVM page faults directly
>> in the normal system fault handler. It seems we need to make a side turn
>> into KVM for page faults on guests in the long run.
> 
> s390's page table management came up in conversation at KVM Forum in the context
> of a common MMU (or MMUs)[*].  If/when we get an MMU that supports multiple
> architectures, that would be a perfect opportunity for s390 to switch.  I don't
> know that it'll be feasible to make a common MMU support s390 from the get-go,
> but at the very least we can keep y'all in the loop and not make it unnecessarily
> difficult to support s390.
> 
> [*] https://urldefense.proofpoint.com/v2/url?u=https-3A__kvmforum2022.sched.com_event_15jJk&d=DwIDAw&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=ea1RmNv-vQM3Ad3SEOr7EmyBdSD1qIFG_Vp8yROenZZFQWjn4Dm6CGaOpNE0LIeJ&s=GRTR1AntYFCoIjcd2GajoTeeek3nLNgmU2slGAbzSgI&e=
Thank you Sean for the reference to the KVM Forum talk. Should I skip 
the support for s390 (patch no. 4) for the next patchset?
