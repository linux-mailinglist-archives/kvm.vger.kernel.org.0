Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FACA55E468
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346338AbiF1NXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346349AbiF1NW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:22:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09994344F0;
        Tue, 28 Jun 2022 06:20:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvvGJytgOjlkU2pmzXIBd40G2WHTAKFczz3UfeGA1RR3jNkPMPNTTsvufytlBQXrcp8v+0TELFyLauQ3zKWMNs27B1a09+TNwdvbdlUw0YWGbvEJOxJOzEA+6TVPI6E5KT2nka+NHemBLH7FdgZZ70r3d7dagSmqVo1A6Zn1zVcVS867syarRSiZGUwnu12TDUYfd/q2zQ/YH7heqS6nr2oUmtNLckZyBvbt/4LtsN4RbOu9R87i5WYVkzNhnnvMPKSUgIAx8zsKMdKBPyk/uSQuod4tZJsu+XyRgzgfXuKCmE4oMhwkUbIZ35ZToDmyJl9y+m6vUvUqv7DZmbSXNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsRASZJU9kDK8OK4+gLrkV/M4p+q1DSP8JyFXxxjafc=;
 b=iWlFKPkDpIw5L2Jf5Z41uHSw/vMwdnDVbbnF1hZB50z8M4LjRpCRv1NtLRjuMXefnegPu15Tp4I82OnZQX0a1sDBJ2vWTC7HSbGkkgJJuDX0U3YXY8XbQstQLlDOOpwX1CGlQrbfBohOyx2LyBQJUZbPfmIIi+5VrMXrUfFfd09PryrhPHuPLHg/xxYTtvPCto9bdrjM4zW2RovwKHcyaZkc+UVjEiDI9jhG/LnjBsCK1YLJhjLkz8djPkSNztDtvrC4v9RiTFjuEZPHUA8yUsSB8yDVeL7r4UNz60M0YOxo0cbu8qNaNsrQcbZhIgZEbm5BmtSP7Lwt1vCO1rVx1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsRASZJU9kDK8OK4+gLrkV/M4p+q1DSP8JyFXxxjafc=;
 b=aaax/l+sSJSwDkDtg1J0bWNngtSy1SeJdW7BkG+c/T77zY2MOamq0aaWJb92h5nQ/n2X9zopiECgSM6oES1ALlmrHzJJg7n57mXjRhgtJKeaX4qkAS2/WFs8sKVXLVSJCq6D8/hlbqV7Xv6dWvw2HG+SB2Ni3fbsFBN/NM2Q/bw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BL0PR12MB5554.namprd12.prod.outlook.com (2603:10b6:208:1cd::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15; Tue, 28 Jun 2022 13:20:30 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594%9]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 13:20:30 +0000
Message-ID: <84d30ead-7c8e-1f81-aa43-8a959e3ae7d0@amd.com>
Date:   Tue, 28 Jun 2022 20:20:20 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 00/17] Introducing AMD x2AVIC and hybrid-AVIC modes
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, jon.grimm@amd.com, wei.huang2@amd.com,
        terry.bowman@amd.com
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::17)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c69c80b9-d3d8-47d6-c73c-08da5908f8f4
X-MS-TrafficTypeDiagnostic: BL0PR12MB5554:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ayHGQ9aesvLPV5JfkfPOwo22aRE8EAYZNOUOlvZ92SSfNPSuHKwH+cZPuxg66YkPwJuVYNhiRNcmmxf+Dwbv7rvNbWeXkqXDY1PkjpIO7URDvcNUjowy6rKFvQvnOX0NsDROJbDRUc4ToURWkJ0i68QNPWnkNs4YjH5powE0h1cyOeZcbmmqafjMlhztxzA2t7LmlcpvGIsoT9AvZ0E5xHs25cl4j1xtcnIaWil+Z9ChOyVSs9mr97EYTknhluBDe6iNETBaSs8ATD1as2GtHc0fXcNEfdHj/dieBa3yREqBL1xNMoY7jB8b4e+h1+X4oklj1fGPRoI2OZu9SUE34/OFYQ4M3HRVofxruiqRZwSA525U8Mu0r2pIEX0O0Mtzl4V3mcezN2/nvID0Vw2BCHK6mRqhmYdE4ufqOQKg1yjaztt4Gqfyc8ARuR/8xPQtku6Pf3T/PxsexwRnRTQV2PcchlvTXvc/VFo7RJ8uVGvLaEmNS8isje5+iQoWFKhQxKc6UsebY9NzrGw6k2RKSqVp4EH47EWbsSorLSPCCxsmnzAB5mcyIBj+s4OKh1BKZnNEQrKQ6o2+ON0dGfhv1HDy7BXHpwB2rsB92L3nxlWwOsOTpWDn+70CHF78Qi24ThoqVx30L3i0B55qQe55xXxLSk5aMX4kXXnDkCykdK9OWKrINrkA/RqYpcP8dXe1l0F9bR+3vs/8LJicZk6wnFroqWXKNu9KfBkg9fInx4Jgfs1ADMDjtYCDkcdipamOIDG93x2oY+8cGKhuDiD7CmTMVOmASon01NBaZFRjhkKjd8qT2flv8i9DZ43oaDTEkcGQkvvqrIcGOmSoArjeqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(2616005)(41300700001)(86362001)(8936002)(31696002)(6486002)(38100700002)(478600001)(8676002)(66476007)(66556008)(4326008)(66946007)(26005)(6512007)(36756003)(5660300002)(186003)(316002)(53546011)(6506007)(83380400001)(2906002)(31686004)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWdybWQ2UHdVYmRzSXF4YU9wOHRybWxjSmcycEVBcXpUTDZJeURJblZDeXVx?=
 =?utf-8?B?Qkl3cmhLSTBqNEo0Sm5VNGlPb0d1djFPT3VEWnVuTG9TUENCc2lCQlozNm1w?=
 =?utf-8?B?MGQ3a3lLYVVWeTFJSGRkajZYdW95bC9FZVBOMFRTN1l6U0hWUURvcGlRdFJt?=
 =?utf-8?B?WU1oaGJ5Z2hzQ1RITmJUemZmWnZtNW1iYzZzYXZoOFVNaDJRaU9FRTdIT2ZG?=
 =?utf-8?B?djdhTXlPWW8zcTBLNzNYZmZWZng1SWpRbERENWgyNTB1SGxuOGd6ajlYTUpH?=
 =?utf-8?B?OFg4STNlMzVUa0ZOTEdwcU05TFZUblhJbGY2Z1ZNM1hwNkU1N0ViNVczNXpn?=
 =?utf-8?B?RWZnbkQydUJrL25LdUtuZldwc1FvWlZIMmI4TTlNSUlxRTNGOFZ5SW4zUzRZ?=
 =?utf-8?B?VVQyOHdZbjU2alROdWdFY21BZ0pKSjgzM202VkthbTY3ZXdiWXJaeG1SeGdG?=
 =?utf-8?B?WE5RTzMwajU3bTQ4ajVEMFFqZWxJTGdIaUllbDlGZEY3eUFtTUdSNDBFVmRX?=
 =?utf-8?B?d2k4L2c4aFRzRm1PL2o2bmtOWmdCY1FwV1UrNnFyRHJJVVRwYmErZDlQWE9T?=
 =?utf-8?B?Rnpaa0U3REpaS0tBYkwzRExCUHFlSURQWjlGWDdyQVFZb3AzMFl1bks3Sm0z?=
 =?utf-8?B?cWZzelBMWjh2cExOWU1XWmI1T3VpWWlBY0NkL1BWMUhwbHRMNWtnUk9TRFFj?=
 =?utf-8?B?cFE0dnl4OGoxb2VLOTBhUSszQk85empoS09hNzFpZk9ZVkgzOU02SUNEVGs0?=
 =?utf-8?B?Z0xkT0N3RmtFYUozOVpyWmxYcE41MjNPaWMyNzJ0THhRY0luNWlDM1dLTGJX?=
 =?utf-8?B?d1drR0JlTzhmTTY1Si9TR2Rsdkl5K2ppZmNFdmNDVnVWMXVuRW45TkxjU0hp?=
 =?utf-8?B?YkN0a1dDRHp6eXdxaGc4VThRTjdabU16V0IrMll1NG5jeVBBM2N5dUlFUFpU?=
 =?utf-8?B?UGlHcXBVTW1lYkhvYjVoMDdqODh3M0VJYTlJdVNCbDh2eXIyYUVkbzdtOUpy?=
 =?utf-8?B?R0t1WkthQmdvZVFPdCsrVDBVUG9TT1Yyb2hla1B6VEt6NUw2aWZsZStZWWFH?=
 =?utf-8?B?YWRHOWJ5NlNCM2dEUFJpcDJId1Rqc080Yzd5Z1NIZGpWRlNmY0lrZWtmQW1X?=
 =?utf-8?B?RTRRM2o5T0N2N1lYeHdUbVNxNXl6RjF2R2w5cHRzdjlBd0hkbmgzNS9TQ3Bx?=
 =?utf-8?B?cmplZkozckJkNlJRUXBwejllMy91cnlyOVE3N3MzcG0zVzJ4cFpCSUNJaWh0?=
 =?utf-8?B?SVl1TmdVcGxOc1B2YU1NVFgxVDlSSmtUdHpXYWRuckJrbnlETEVlc3h0UFUv?=
 =?utf-8?B?ZWkvY3VoN3BJNGJ3WXllSmdyVVc2RER1TmNCbmt2QlRoMnpuaFRCTHdIR1pw?=
 =?utf-8?B?b3lhNW80MGVxcjFISElVT1hNYUQ2TTkvekxEOXhFWjJVby9hZndRRFBYZG9w?=
 =?utf-8?B?VUNCRml3UHlZOHg2QktLVW5sdjQxY283bUpkWVhzU00wQ1A3ck1QR1FUalBh?=
 =?utf-8?B?dSs2dXBNcVpIT3MrejUrS285S0pNcnJsZFFOVlRFUi9PNXBFVUZaNFV1SWU1?=
 =?utf-8?B?TVZTYkJBR21WdXg1OWVUSWxmNnZYU3ZwbUxQSmhhUVU3elE5ZUpkL21VRU0r?=
 =?utf-8?B?V0lIalcwd3lkMm8yeFp4MkVlQ0piU05oUW55clVpVjFzZWROd2xVWCtJZkU0?=
 =?utf-8?B?Y1JyTEExNUF6NXBZbzl2RmVKQmQ0blluRU1TVkM0MktaaXNpRVNJcDhRZDB5?=
 =?utf-8?B?VDBBeHJ2eldUTzB5eWtQZjRkdXRTYlIyRHhyK2pjUGt2VktnMUhKQlJnRmh6?=
 =?utf-8?B?c0pXTEhVbEJ1elQraHl5Rmx2Zzh4emlMVWhnTGlVaVQ4UWpNeDZnc3BwOE1y?=
 =?utf-8?B?d1gydjFOZ3liZ1VDME5sNFlYWXFBMWJzaS9CZXVYL2JFQ2hKMlRIRktKWHlx?=
 =?utf-8?B?NHVnUGpGci9adVMzV2ZIOFhKaHdoMjA4Wlo3TTBXeEx4TVlsd0lPWWpDMFVI?=
 =?utf-8?B?blRobllmVW91akdJU0tzUjZTK0MvSDkvUS9KMXVibDVLRm1WVXRlSXNUOVI4?=
 =?utf-8?B?U0pnV3dTY2tDclVoOS8vdDhXL2RtcmkrNXU2eEtnaFAyeVQ4ci9QSUpEZm9G?=
 =?utf-8?Q?ZXpvI969n8dJ/oa4xYLDPtmS5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c69c80b9-d3d8-47d6-c73c-08da5908f8f4
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 13:20:30.0872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkeNE4g9wTogTKr14JJqrgODlxDempvRO0ho3qHyOGpCR58NM98hnqufMALboOgMNiRmhttu+kKhjFiT78pgtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5554
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 5/19/2022 5:26 PM, Suravee Suthikulpanit wrote:
> Introducing support for AMD x2APIC virtualization. This feature is
> indicated by the CPUID Fn8000_000A EDX[14], and it can be activated
> by setting bit 31 (enable AVIC) and bit 30 (x2APIC mode) of VMCB
> offset 60h.
> 
> With x2AVIC support, the guest local APIC can be fully virtualized in
> both xAPIC and x2APIC modes, and the mode can be changed during runtime.
> For example, when AVIC is enabled, the hypervisor set VMCB bit 31
> to activate AVIC for each vCPU. Then, it keeps track of each vCPU's
> APIC mode, and updates VMCB bit 30 to enable/disable x2APIC
> virtualization mode accordingly.
> 
> Besides setting bit VMCB bit 30 and 31, for x2AVIC, kvm_amd driver needs
> to disable interception for the x2APIC MSR range to allow AVIC hardware
> to virtualize register accesses.
> 
> This series also introduce a partial APIC virtualization (hybrid-AVIC)
> mode, where APIC register accesses are trapped (i.e. not virtualized
> by hardware), but leverage AVIC doorbell for interrupt injection.
> This eliminates need to disable x2APIC in the guest on system without
> x2AVIC support. (Note: suggested by Maxim)
> 
> Testing for v5:
>    * Test partial AVIC mode by launching a VM with x2APIC mode
>    * Tested booting a Linux VM with x2APIC physical and logical modes upto 512 vCPUs.
>    * Test the following nested SVM test use cases:
> 
>               L0     |    L1   |   L2
>         ----------------------------------
>                 AVIC |    APIC |    APIC
>                 AVIC |    APIC |  x2APIC
>          hybrid-AVIC |  x2APIC |    APIC
>          hybrid-AVIC |  x2APIC |  x2APIC
>               x2AVIC |    APIC |    APIC
>               x2AVIC |    APIC |  x2APIC
>               x2AVIC |  x2APIC |    APIC
>               x2AVIC |  x2APIC |  x2APIC

With the commit 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base"),
APICV/AVIC is now inhibit when the guest kernel boots w/ option "nox2apic" or "x2apic_phys"
due to APICV_INHIBIT_REASON_APIC_ID_MODIFIED.

These cases used to work. In theory, we should be able to allow AVIC works in this case.
Is there a way to modify logic in kvm_lapic_xapic_id_updated() to allow these use cases
to work w/ APICv/AVIC?

Best Regards,
Suravee
