Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AA06C7672
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 05:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjCXEGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 00:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjCXEGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 00:06:15 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B409C16327;
        Thu, 23 Mar 2023 21:06:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqtB+A0ADbovsSUkoJ2Yym7ViHmNoLXN+w4HnzC/juvBzcoXet/TBhcPf4duquH8NgOFILLqUhcKsg6L+H7sQZPqgtOVL1a/6SvKAe/9hV/QsU9cQt9e1Fo0WDxCMSFHtDzztI/IinlXjljDeXl7FW5bIpR1Pgf0vc4IwNmVU0r8/lXOX9RIpCBRoYdbfvB7b+kukq6HI1+QqzUnoG+7/n6Z/KQpAHPRDRyr1kjFx/mVZAYETjJxqub7HpDpPCMZr5wfU47/qCqUPsk9TUnuJMZu9HJHr/ZSZt4djT5lYk467FjTaUhYErbMQEiK1aCKU+z+LrBfqFN4aYbtmyvNVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fw9OK7YT7ymiRKKfdoJVRpcBMR0KiO8MyA5zxKb9+Pk=;
 b=VkpvybpMvHccSkuzjDa4p7nMv3owsMXL5AIWFkEVMErcikbBQutm8myuuGK6sPO1UcYrL9mPqjjh1AMmVnuMHEHHuIko7P+WVZW73JA8h83PgyQAgb10/I8cD8MIjcbPCshBkXifTgJLfdGc1st6m/nM4V5coR+Lip/+Yu0uxyRupSsusD6x3Sh0GLdRnhewzxFxMmWD4+ghqaTts7ei0KLssN/GJFBgKcvbvM50oEhxGIFLyF3PwLyJi2X/NdQC0oL90KXLSEFGnONAo1oaNfsr9HdROBLhFslRN4vgsLyKOOfvBP2j4EtoJbR6FZ6Rdh5cd43M7ZUI/XwK1oZfeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw9OK7YT7ymiRKKfdoJVRpcBMR0KiO8MyA5zxKb9+Pk=;
 b=xHXe0sDCIqHu0V3jcELwR3HROkM0VBAOwUfpMLQhGOC7ZVykQdJpmv8/d0eshnF9sdggT8ErWzii2SRUYeTBb+Smt1IdihTspsOMOWloMh9DlJr3SahgQm8zru2Q/8GDCFpouvOUTKq9nMGApEQJJJj5mVHbmz1UTfEnVdEjopE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 04:06:06 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3%7]) with mapi id 15.20.6178.037; Fri, 24 Mar 2023
 04:06:06 +0000
Message-ID: <12b878e2-febc-bc4e-ce33-497c84c8912e@amd.com>
Date:   Fri, 24 Mar 2023 15:05:51 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH kernel v3 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-3-aik@amd.com> <Y9nL8iqhiL5+ALa2@google.com>
 <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com> <ZByAptUXE+VMpn2x@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZByAptUXE+VMpn2x@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0058.ausprd01.prod.outlook.com
 (2603:10c6:10:2::22) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: a5e0a86c-6d2f-43cb-3ca6-08db2c1d1736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+CBxOK6zEKEy+jRCydUqGAMWIFhNUjYl6a2djvhI7ykX3266uvnHNhaW/7OgHfBwnPNPblXbWkBidXfxEOF1+F6wf0VarrJPB72iY9ImOuNS63risXz/lB9pY1XMT6ueDUmlkaEhVafqqTYHUrBvQE2zdakIklc+kLphMYBR9mF7bwf0wRLHcNs5kUighYuJECtbJKEHIOZei7JNiE2Pyjv6g85ddNsRE8OkId4Aj6lwFdDWRcCj1f7D0t7PnxcgaG5LNK9F7HrOckDSaHqaZ3O8QXP4XQX7OzE0e1Iw7yXtTkpLJYDFQtCciJXIxs9hL9OKW2vop3NeY1/J3J550Po+ngA0Tz1JwWw5BSHWjG0irm7zwC5ixRJ/XRGExXwiIfxUmNbxfwQnmxDzxYQ2WyqZBdTU+drTbIYxqB6+u6GoUjX0d2+hlzcBOjhzLfscFJvXlTmfRvyrTR5JaIsNZCsVM6CfIwF85dy8Rl2rLZRWmSSZPzegSwK6y9KomWQfJn1m7UitUk243AYNlKE5NUhftdvll89ykuyVEP5J2cNGz1cYKuLXH7q7xJh9XZVlwDV0RSjtNvhaUp9PzYwoHfHQyYtFZAkN3lUgWi3zJmilmGt0HfBpvCoZxRiDZEGWzC3H+zChtdUz40cmmsrOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199018)(31686004)(38100700002)(2616005)(2906002)(478600001)(6486002)(83380400001)(966005)(186003)(316002)(31696002)(36756003)(54906003)(66476007)(4326008)(8676002)(66556008)(66946007)(6916009)(53546011)(6666004)(8936002)(6512007)(26005)(6506007)(7416002)(41300700001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qzd1cHBlaXJDMHZ0SWtpWE9sMTN0bGlmNm5IUjI1clI5aHFSUHlkNjNGY1dv?=
 =?utf-8?B?MUVydnY3YVBQM1l0U0VNazcwU3haZ1RyUzdXMXR4MUVDRXNtc0NFTHZFQjdp?=
 =?utf-8?B?VkpYOWZRWmNqcUNWVDMwd3plODhKS214WnlxVm5uR2hMUmVzR01QMHZ1YU9s?=
 =?utf-8?B?c3Z6WERmZGlNa2dXcm1JZWNJdnA0aE8xUGJiZnAxZTlNdlVLcW5EWFpsb2dH?=
 =?utf-8?B?WDhwbjI2ZDRvNjdvL3VGMkZsTzJTVmNKZzhJMmdlM2N2V25jQkhHNkpjWUdE?=
 =?utf-8?B?cVE4TFBzMXk3VThSRGhBblp3VUMyNm80bUJBcVlEeUZzb0JseUMxdFZHZWU4?=
 =?utf-8?B?WHpCZFN0ZTZLckVtOERvWVgvbXdSSU9IUENtWE5aczBJbk5NL3d0N2Jmb093?=
 =?utf-8?B?M0p4OFhFQm5CVHAvYjlTMEJLb0FWbTBHSmErbW5IckZ5djNYUCsvZHE1TnBK?=
 =?utf-8?B?OHloZEhjMzlqTUdPNkhZZ0gvdGd2OEpYaER4L2xYU1lpUlR6ZUVTaXBzb2dX?=
 =?utf-8?B?VWc1anYzUVJqWUMxcEcvRDlSQUNyUnhLTnlua2U0Tkh0Rk1ER0ttTE1QeDhD?=
 =?utf-8?B?SXVwMEFBR0NNQ01MSUovV2NuRjdLcHROVldOUE03SGoxU0p6aW1SQVJ1R0Rs?=
 =?utf-8?B?L1Qvc0xRVk1nQzUvOFdpTW5ZdS9xMERUYm5BSkh1OCs1UkxRdnlQejg4ZTVQ?=
 =?utf-8?B?VjRObCtQQ1QvM3VuMHFlRTJ3blV6Z0Q3L0dYV0h1cnlNTUhFUENKakJaNUtV?=
 =?utf-8?B?SUowcHBGNGlYZUg0dEwrTms3dnNrZFBaN25TdE5ENkJscGZDRGhPVFFkYjJV?=
 =?utf-8?B?SnZncmNVRUxGOGtrM1gvL1NacW9vNE9mYk9IbXdLTDBRZ2xKcENYTXlKUDly?=
 =?utf-8?B?MldTWUFNM25xUDVMUmhSd280Tm1OUTlyUFo0anA1R2xFYjBKeFVmdHRwM1lS?=
 =?utf-8?B?OUppYy9nNG8vUjVHbU9qYnN2cnplMTdjaENjbVF3VFk5dENkVCtFZlJsT2VE?=
 =?utf-8?B?L0JRaytXZzVuRm01YU5xWm1xUEZKTm16R1FLQTRRZmRpNVNZM3NUR1lCWm9N?=
 =?utf-8?B?QkhQa2pVRHh1aXIvQ1V4TEpkRGxWd1ZEbVpUMFk0RzBheU9nS254NnRxOHRE?=
 =?utf-8?B?YkxTVTlieC9lTnRIUGJkb2FzdEpWTEgzQTdXYnF6OG1QUjM0ai9Za0x6bm9L?=
 =?utf-8?B?aVpVM25xZHBScHBiMmlZVGd4eGJMSmFWa3RLWlk5U2xoNU40bHU2dEtuUUNq?=
 =?utf-8?B?ejd4ejcwczB5VzBCcDhXanM1VVpTLzRTbXA0YXVqN2dRdGY1OS85Ty8rTnhp?=
 =?utf-8?B?Y3J5enFTR3FtR1VuOXN6WC84ZFpRRmJVUmI4emNqaExXNGw5YU5nK2RpSVBD?=
 =?utf-8?B?OG1MR3FhbGo3a2tJdFZpdTV4TjYvajNnN3Q2STZvR2N6QysyallqUitZRjZ5?=
 =?utf-8?B?N0tUaVFMTUtRUE4yd256Zm1DTmhMTDNUS2MzU1lrQkFMdHEvSmR4SWNiMVox?=
 =?utf-8?B?d3pRbXM2aVJSRmRsS0duM0hpTWdxTVJCdzczQ0ZYLzg3ME4yQTg4a0FnYXBa?=
 =?utf-8?B?WEh5VTg4MHlzcUFtVXA3NDhwZGNqWGlnbjJhWFNaRVc1VnV4NVU3VmpnbjNJ?=
 =?utf-8?B?Vm9EN1g3RC9YUmpTYmRtVS8rRVc2V1hueElaazJ5dlhZNEo5MmVIbElWaWdi?=
 =?utf-8?B?V1Vna2NVTDQrbjIxUUwzd0lwNnJIZlE5bUM5WDR6WnI2c1NvWGpJVzVqZWQz?=
 =?utf-8?B?L1lzaE1YU085aVp1Z3NMaTdmNms3M2xUMDJoMThjK2hmc2FYL0duUVBWdzky?=
 =?utf-8?B?azB1VFZqeXNNRGczc1Bkalg4OTYvWGFsNzdrUUNVWlZJQlNNVmxXNVZhNUZv?=
 =?utf-8?B?VE5YeTliVFdoaGRxS0FFdWVpL2JETDU5bU5GVzRQT0IwOXBtVVFaMVJWWnhu?=
 =?utf-8?B?QXdpV0dEcHVuUlMxWEVhNjU2RmN0TGtuYWdFYUpMaUdvS1BhMCtmZzEyVkNJ?=
 =?utf-8?B?OHQ4YjhRK01QWmYrNTJ4dFpUclN6SVJlbWpaaVZ4UEFvcHJQRzFKYk9vK0F4?=
 =?utf-8?B?ajBISG1YakxBcWJnaGNKaDNZRzZ3NEJTUTNqMXl4MFlQYWFjM0pRamRHT3Z2?=
 =?utf-8?Q?NjcwleENsTkS9mJ4M5ry0nkHo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e0a86c-6d2f-43cb-3ca6-08db2c1d1736
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 04:06:06.0661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvIU2ZnM++WW27xCSm2c/UeZhGMW1iaZRxV2yZoymbBxLCEvxf1aMSlhqJ4lSCGdiMhbwoV27Pq/Igp43s6Mlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24/3/23 03:39, Sean Christopherson wrote:
> On Fri, Feb 03, 2023, Alexey Kardashevskiy wrote:
>>> Follow-up question: does KVM _have_ to wait until KVM_SEV_LAUNCH_UPDATE_VMSA to
>>> set the flag?
>>
>> Nope. Will repost soon as a reply to this mail.
> 
> Please, please do not post new versions In-Reply-To the previous version, and
> especially not In-Reply-To a random mail buried deep in the thread.  b4, which
> is imperfect but makes my life sooo much easier, gets confused by all the threading
> and partial rerolls.  The next version also buries _this_ reply, which is partly
> why I haven't responded until now.  I simply missed this the below questions because
> I saw v4 and assumed all my feedback was addressed, i.e. that I could handle this
> in the context of 6.4 and not earlier.

Ok, noted. Sorry for the mess.

> Continuing on that topic, please do not post a new version until open questions
> from the previous version are resolved.  Posting a new version when there are
> unresolved questions might feel like it helps things move faster, but more often
> than not it has the comlete opposite effect.

Well I thought keeping the history in one place/thread is helping. Oh 
well...


>>>> +/* enable/disable SEV-ES DebugSwap support */
>>>> +static bool sev_es_debug_swap_enabled = true;
>>>> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
>>>
>>> Module param needs 0444 permissions, i.e. shouldn't be writable after KVM is
>>> loaded.  Though I don't know that providing a module param is warranted in this
>>> case.
>>> KVM provides module params for SEV and SEV-ES because there are legitimate
>>> reasons to turn them off, but at a glance, I don't see why we'd want that for this
>>> feature.
>>
>>
>> /me confused. You suggested this in the first place for (I think) for the
>> case if the feature is found to be broken later on so admins can disable it.
> 
> Hrm, so I did.  Right, IIUC, this has guest visible effects, i.e. guest can
> read/write DRs, and so the admin might want the ability to disable the feature.
> 
> Speaking of past me, no one answered my question about how this will interact
> with SNP, where the VM can maniuplate the VMSA.
> 
>    : > @@ -604,6 +607,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>    : >       save->xss  = svm->vcpu.arch.ia32_xss;
>    : >       save->dr6  = svm->vcpu.arch.dr6;
>    : >
>    : > +     if (sev->debug_swap)
>    : > +             save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>    :
>    : Resurrecting my objection to "AP Creation NAE event"[*], what happens if a hypervisor
>    : supports GHCB_HV_FT_SNP_AP_CREATION but not DebugSwap?  IIUC, a guest can corrupt
>    : host DRs by enabling DebugSwap in the VMSA of an AP vCPU, e.g. the CPU will load
>    : zeros on VM-Exit if the host hasn't stuffed the host save area fields.

I was convinced it was answered (by Tom). (...10min later...) now I can 
see it was an internal email :-/

The host will have to save DRs and masks to the host save area for SNP 
and non-SNP guests (until we get the hw which allows masking features). 
Which patchset will do this - it depends on what gets accepted first - 
this or the SNP support.



>    : KVM can obviously just make sure to save its DRs if hardware supports DebugSwap,
>    : but what if DebugSwap is buggy and needs to be disabled?  And what about the next
>    : feature that can apparently be enabled by the guest?
>    :
>    : [*] https://lore.kernel.org/all/YWnbfCet84Vup6q9@google.com
> 
>> And I was using it to verify "x86/debug: Fix stack recursion caused by DR7
>> accesses" which is convenient but it is a minor thing.
> 
> ...
> 
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>> index 60c7c880266b..6c54a3c9d442 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -1190,7 +1190,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>>>>    	set_exception_intercept(svm, UD_VECTOR);
>>>>    	set_exception_intercept(svm, MC_VECTOR);
>>>>    	set_exception_intercept(svm, AC_VECTOR);
>>>> -	set_exception_intercept(svm, DB_VECTOR);
>>>> +	if (!sev_es_is_debug_swap_enabled())
>>>> +		set_exception_intercept(svm, DB_VECTOR);
>>>
>>> This is wrong.  KVM needs to intercept #DBs when debugging non-SEV-ES VMs.
>>
>> Sorry, not following. The #DB intercept for non-SEV-ES is enabled here.
> 
> The helper in this version (v3) just queries whether or not the feature is enabled,
> it doesn't differentiate between SEV-ES and other VM types.  I.e. loading KVM with
> SEV-ES and DebugSwap enabled would break non-SEV-ES VMs running on the same host.
> 
>   +bool sev_es_is_debug_swap_enabled(void)
>   +{
>   +     return sev_es_debug_swap_enabled;
>   +}
> 
> Looks like this was fixed in v4.

Right. I'll try addressing the comments from the other big reply of 
yours and send the patches. Thanks for all comments!


>>> This _could_ be tied to X86_FEATURE_NO_NESTED_DATA_BP, but the KVM would need to
>>> toggle the intercept depending on whether or not userspace wants to debug the
>>> guest.
>>>
>>> Similar to the DR7 interception, can this check sev_features directly?

-- 
Alexey
