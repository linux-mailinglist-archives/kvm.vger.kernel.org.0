Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5416C512C21
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244686AbiD1HEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244700AbiD1HEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:04:00 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D61E689B5
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:00:42 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RMBw8J023997;
        Thu, 28 Apr 2022 00:00:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=Pl4icI6YoYmB4hw6wCKsZw3mNXPIxvFMHj6wCGo49OE=;
 b=y0M/MFml95taYSyJOSMIcY54d22q5PEuTmKUdOTe26L4cXreklJE1nShD2+WzKEYemLg
 sbciYFFuQtetIAmXBSBMquvf7vk2RmAdj+X+WXIhZpPlG9nVBulgDL5SeMV90i6GPLbF
 8ClLl/SJ3Sc4Rgd10QuBVACnJkBl7OQEfSvcQBpPz6u+hecnXDE82BLRRgUoFRn3Pvcj
 2zHdO/bU37Sfaeiymh4pMII/b8cbwvyf13/d3z6DC8n8foZ2o0/bhqF+zrVSQaQqJW+2
 fw5viFqV/3UmdqhO5pil1dWeSRDdt7ky6Rnw+xqEIYz07895YN55KlEZpuVB9cE4t2eU Xw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fprv93a20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 00:00:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lc7BPiUkhlAGxffe/2Skn+WOcs9EqiYNy4jzldiyvR+0XYK4mbb2erR2A8NK83ellCafaWEncj9lnUdni2gcQYeCXKpESH9P6LILKePY34r/zasQg/R/RC/Lf3yuOZrGrjwE796vaQq7XquNyQZegZOdPfQ3vpim3/kbH/shxHUYo+zBNh7TVKl+cwePN0cUoRDjanKb5wzEWTB0kqffzRqYXbDEBVtYurTXyvrJmsJVPwnp0fk19WRlGhKOLVei2sgw8svuaujeIxn+y8Fe4rpVTkMJz+DWyuFUC+PA+v3kBlV4Tond9ea9x2jutXLsOPUL1suTJ2k15kQGg6ld5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pl4icI6YoYmB4hw6wCKsZw3mNXPIxvFMHj6wCGo49OE=;
 b=SV/5F8L+bWjxegrYnji0RNgi+LalZegwseDgwEJ442sVt56o4tctuaGa83F4zzXfCeY7xdfHOGMnCtlkN4z1yn8QsiPHZvRvv2faoWyQybltRgerrlCHRDsXzA9ZX9w1wxXqnJk22cINpBfKZ/oM8YBI71U1iHkY8xtaSpA5n5RuNBgq72zHwTRRseim6j7y71btkZ5S3XErFDReFgoJsipofODaVahMF3tqy4aXeDzpM0RZ3ysO7DGHxxk/9iRxgNHdwHZXuyjXnaMUWblT7+JwOIZflAeFKyr9iYBYNllPHWO04eXLgCFn0+C5hEFn4XXlPq4Pf0B03tLGsiYaVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SJ0PR02MB8644.namprd02.prod.outlook.com (2603:10b6:a03:3fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 07:00:35 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 07:00:35 +0000
Message-ID: <a8468330-5126-901a-7e49-2566ffcca591@nutanix.com>
Date:   Thu, 28 Apr 2022 12:30:25 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v3 3/3] KVM: selftests: Add selftests for dirty quota
 throttling
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-4-shivam.kumar1@nutanix.com>
 <3bd9825e-311f-1d33-08d4-04f3d22f9239@nutanix.com>
 <6c5ee7d1-63bb-a0a7-fb0c-78ffcfd97bc5@nutanix.com>
 <Yl2PEXqHswOc2j0L@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Yl2PEXqHswOc2j0L@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR0101CA0032.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::18) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24aea309-3d20-4b5a-71c9-08da28e4cb2e
X-MS-TrafficTypeDiagnostic: SJ0PR02MB8644:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR02MB864486BD98EFF1975A8D2819B3FD9@SJ0PR02MB8644.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l974TujB4uacsPlR8fg1FVLSLVU+7HFxd3x2YB5DVPqY83peNO+It3Sl2Sefe1b41lLiT3lYQblSP1lpcpD0j5L+O2J1PV7ZBTbiiWeokIDumsmycYQ7uMfHkRIWA0WOuA+SM7P4SE0gOz2mPAafy5bwYiW7/w1kH8DZ6431wkshNgdv4JJg5QOkuIrtkke9P2xsfVcKhtyymfD2wi4iylD80eZ/SC2GWGMVKSBKOEA9XRmz+lGjbpL0jxhmT8uJqZ5+WE50tZuXJMFT6iQA9aKhynu/+PSmpnQ71lkwwBzU8HYbKGNmwHxYBZ+0OKmaXM0Cd9YRiG4WLQW/yedVYKuRjyfxrjDWt7zyf9t9Uyf2LBOpvrMafXnxZHRq5JqnJHONlhVNx5Kged5jtNsmTljVTfzGgwn8/Sr8Tybid2tsxuCFb836lN54T3hlzCEbV1oq1JfJTmuLw3lqiiAxk24XMBrnVygs/0DlM7iSwul7DrB/1r2yv6fu65risnx+gQjAoMul0eya+dd/fTiJgFmgxc8+JJj/Tdsek4nOqQ26+fgJ3LCmYDjspcC5jHOSA1DTTONNjTUcJFIVpop4hwSvyEeZPEcI/F4MnSRwJWvbWskm7+L/+7f70j3MzAJAuBf2VTdQ0EnvFPTv2TozV88LChpQIianQk0cA9+KWRi47dWaA27TP8vhXCQBl1lFki9rgOk0eT7OfaQuzaU43PARHoJvc94LOMXu3mSwbMqkJpsLciR23YBmqLltuIawAi6b/POTwAs9YU+oGsgooQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(31696002)(6486002)(15650500001)(38100700002)(508600001)(6916009)(66476007)(8676002)(4326008)(66556008)(54906003)(6666004)(66946007)(8936002)(316002)(86362001)(5660300002)(6512007)(26005)(31686004)(83380400001)(107886003)(2616005)(36756003)(186003)(6506007)(53546011)(55236004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bE5VbWw1MzAxVWc4ampjWDJZQlk3M21wWEJzaWhUeUJyUlFLMGxtamhTOUps?=
 =?utf-8?B?ZmJTVjM4a0kyL1c2YWdEQWVQd2wwbmtobU95aDRPN3dvNXlXdTRGQlpnbGVq?=
 =?utf-8?B?M0w1dUxtMDQyYmpmdnhxazk4RUFjZ3lES2NvYlZoNldmcFQxajBNNHJxVS9E?=
 =?utf-8?B?amtiMm5UaW9HbkU5MWFDRkpJY3M4N0l6bTlOWFJSenU4em4rQXJtbEp0dWdi?=
 =?utf-8?B?QWJyT2xQQ2RxY2tUMFRremUwN0ZzaXpTRVQxUE16Y0pFN2FzbnJabEkrYWp0?=
 =?utf-8?B?eEo3NXJmUzJsb0lVdjFuQUhicTNLR2ZFU1dCcktkUkJmbXNpbCtwTVl3eFdP?=
 =?utf-8?B?bGJPTGxRQWFlZHlYUG80emxZUXI5SXRBQ25sc0JaWkdzNWxzbDVyM29QdWZY?=
 =?utf-8?B?UUUwNE1wN2JteE02VG5LbWYvcE1lVW5GOVdFNWMyS0R3eENra2VaMVFDMUZ1?=
 =?utf-8?B?OXZsaFR2VkNidm5tMWhXb0hVSDBpQTJpWEd0eEh5aWxtSmtJSGhmVTVzREpt?=
 =?utf-8?B?NW8vNk14Y2xwMnBTRC9GN0ZrTk80N0N6RVh1VkFtbXNLeXBXeFNUcE9XRmlK?=
 =?utf-8?B?Q2JZWE85ZU54bHM2eXhpMFBSSGIrRkpwM2pYeWdCdDlQdVg2OFZwQmV5LzM2?=
 =?utf-8?B?UHpidFdmb1NaTzhoOEdRRnlENWtCZ1F6TEN2MlBXaldtR3o3eWE4ci84OHlY?=
 =?utf-8?B?ckwzc2VMNG56VjJ3L3FkV013RkxCakhBaHRoUkxqM011K3o2Y0FxZ3Z4S2Mx?=
 =?utf-8?B?QUoxL0lzOEFheFlCOGkvWDdibThGSHJCMjhYWWwrdk82TlVWTWVwanp6MlBW?=
 =?utf-8?B?TVlUMVE4dEFkc1JvazBiVEFXU0Rac1dpbWtsc1gvRmNmdlVXMktZdksvblBH?=
 =?utf-8?B?clZDSWhjSzBBSmxmOU9BdTBVdFpRb05Gazg2QjR4b0pQcnhEVGRUKzVlZGtq?=
 =?utf-8?B?WjdhNThNNXlMWlNJNEovQk1hNTNaVHVoL1pRZThvWjMyNWwrbWhjVmJHYUVD?=
 =?utf-8?B?RG11Skp0SXI0UWQ0RldMVmhrOHozU0dXTDlpeXN2VjdBcGlPQVVId1R0cGhV?=
 =?utf-8?B?NnhsTG9PS2JUTlVLNXJCMERYaWVNcVZmbTBiM3Zpd2VUOWtSSzJmdXhaVThM?=
 =?utf-8?B?a0hqb0Y4clBEbXRvVEtNM0hhVGJFa2tjVWYzeGxTdHJTZjlzeDQzc2JHZldV?=
 =?utf-8?B?TExOVHJFMGRHcFd5S0UvTGx0V3JDTVlLSTFxTW1JRURGYWRQTzJpcFl1dm02?=
 =?utf-8?B?QmpTWDNVWU9MYW1QUWM2RVc3RGtsUzNvSVA1c241M3dFalNmYmQ0UFBWbi8v?=
 =?utf-8?B?aU9PU1NxMUk4NFl4WGNKb2c0Q0M2SGtDRit0dTJWL1NZd2VHQUlsdkxObG91?=
 =?utf-8?B?TTh3cUhMKzViSHBaN3k0NjU5cmxJb3R2YjlDaFRoMjNZNkxJUXprM1Ria0lX?=
 =?utf-8?B?d253OThtbWZyVlNLNWFEM0xQOU1RT0xtNjREVktrU1VJaG82K0JnRzBBRVNN?=
 =?utf-8?B?K2VGV0dzZFUyV1p3c2VBM05LR2w1MUZjb21lK0h4eVZsa1JjY3RhSUFaNFR4?=
 =?utf-8?B?dkhuRTZpblZ4L0pmWkR2UmswWGsvT1BLZDZuTkhnOUk0SEpqb2VNVndNS2cr?=
 =?utf-8?B?bVErbEd2Rjhac0tkVmV2L3FoZ2pmMHhpNjNhdGRuZldwU1FFRERVamdRY1Rh?=
 =?utf-8?B?S3dqZW1hRkE3WFgrd1hCcjVVeUNTSE9oREJ5RlpidlE2UElBditoZ0hweWdL?=
 =?utf-8?B?bllUczd0bXhpeE0yU0ZQZkFIZ1h5ZzlXM1oyV2VSeURndXdFcndWQzM4c1p2?=
 =?utf-8?B?SnRoQWN4ZjFCeXJ5eGJlVVpKNWl4Tnkrdld1dFNkZ1dOaVlsNHpMSFYzeVV2?=
 =?utf-8?B?VktNZ1l3Tk9HTWFwY1R0OGpqNkpvMWZrT1UvaTNJaHNiVkVUb2tBdFFHZzF0?=
 =?utf-8?B?YVp5eTh0MDBsdkJ5MWxPNE80S0Z3R2NaZ2RLaFJpOE15RkxXbm1JNXRSZmpx?=
 =?utf-8?B?bDZVWExORHE3UnRaTkgwSlJGTTNlVExCZFpNVHJvMUVDaXUvTFdVYTVkNFR6?=
 =?utf-8?B?emhLZDc1Ynl4cmowVk8ybENDbXFGQ21NTTFkSlU4UndQbE9NUFFUYjEwR3Zh?=
 =?utf-8?B?cy9yazFTMGtOZnpjVzFCK0s4ZnB6UXRzRzRCMmxiWGNhMU1LVk12RFVIT1FY?=
 =?utf-8?B?SjZGRjJyRitMQUtKdG10WVU2L0dQMnpzdlBZUysvYUhRbTRsV0lVVVk5U1Fs?=
 =?utf-8?B?ME5uK05weDFjNC93Q3MrL3d6S2ZHQmF1Q2FOTlU4N0w2TE9ER2ZUWTk1b1VG?=
 =?utf-8?B?MzZEVjlZeTMranEvSHZMLzFSQkJ0MlpYZWFjTUgwRU4vTkVIUTBCRmJxdCtF?=
 =?utf-8?Q?PBk0qKP5aN7yP84s=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24aea309-3d20-4b5a-71c9-08da28e4cb2e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 07:00:35.6569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Shr2CpbNDDAxfUxZBKZ1qxN/+e25u0wDnipJSbZ02ihIiWDhA43eBQWyv1Wgc2FLBbJBueMChOYBKUfpQJAhp7jJJgZ+1M9+z33lTp3cEX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8644
X-Proofpoint-GUID: vP9Buq_xQJjD1ULMQvcFW_DJ6T4LDwKb
X-Proofpoint-ORIG-GUID: vP9Buq_xQJjD1ULMQvcFW_DJ6T4LDwKb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 18/04/22 9:47 pm, Sean Christopherson wrote:
> On Mon, Apr 18, 2022, Shivam Kumar wrote:
>>>> +void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
>>>> +            uint64_t test_dirty_quota_increment)
>>>> +{
>>>> +    uint64_t quota = run->dirty_quota_exit.quota;
>>>> +    uint64_t count = run->dirty_quota_exit.count;
>>>> +
>>>> +    /*
>>>> +     * Due to PML, number of pages dirtied by the vcpu can exceed its dirty
>>>> +     * quota by PML buffer size.
>>>> +     */
>>>> +    TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of pages
>>>> +        dirtied: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
>> Sean, I don't think this would be valid anymore because as you mentioned, the
>> vcpu can dirty multiple pages in one vmexit. I could use your help here.
> TL;DR: Should be fine, but s390 likely needs an exception.
>
> Practically speaking the 512 entry fuzziness is all but guaranteed to prevent
> false failures.
>
> But, unconditionally allowing for overflow of 512 entries also means the test is
> unlikely to ever detect violations.  So to provide meaningful coverage, this needs
> to allow overflow if and only if PML is enabled.
>
> And that brings us back to false failures due to _legitimate_ scenarios where a vCPU
> can dirty multiple pages.  Emphasis on legitimate, because except for an s390 edge
> case, I don't think this test's guest code does anything that would dirty multiple
> pages in a single instruction, e.g. there's no emulation, shouldn't be any descriptor
> table side effects, etc...  So unless I'm missing something, KVM should be able to
> precisely handle the core run loop.
>
> s390 does appear to have a caveat:
>
> 	/*
> 	 * On s390x, all pages of a 1M segment are initially marked as dirty
> 	 * when a page of the segment is written to for the very first time.
> 	 * To compensate this specialty in this test, we need to touch all
> 	 * pages during the first iteration.
> 	 */
> 	for (i = 0; i < guest_num_pages; i++) {
> 		addr = guest_test_virt_mem + i * guest_page_size;
> 		*(uint64_t *)addr = READ_ONCE(iteration);
> 	}
>
> IIUC, subsequent iterations will be ok, but the first iteration needs to allow
> for overflow of 256 (AFAIK the test only uses 4kb pages on s390).
Hi Sean, need an advice from your side before sending v4. In my opinion, 
I should organise my patchset in a way that the first n-1 patches have 
changes for x86 and the last patch has the changes for s390 and arm64. 
This can help me move forward for the x86 arch and get help and reviews 
from s390 and arm64 maintainers in parallel. Please let me know if this 
makes sense.
