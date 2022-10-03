Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBC55F35FB
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 20:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJCS4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 14:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiJCS4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 14:56:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1599436782
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 11:56:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoBsBMyNIOYgUnqVdaAo6COhjYtePGTCNpoKZKRmmCbtvTgmVTI1QZXYWki+f+gIrvNZ84qYsPMqTWOmS+bG0V8jwPP2Rqvl88evqdXb3AupZpZdQ69Bo4Mbk8porD2J/QJSyJbC+6faUzOi1NmMJgzaRJsCry3cBc0WoSkD5efFlrOsHHWa+BWdqsGn4R6sFzjp5IKwLMhkMTQDcCc4LqFqTuIrzfCmgOYlvu3WwBhSMNrInNSVBKwWpo/ByxRTHh6gVsy0J7LNQIa04mkYYN5z2+lT2Qnpr20YW7wf1NeExwoHXFdmOrqZNLwiRpqiIL53O+5UCVUzpJafk81lfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3YgRnuXNKXZOmk5GsssyOA38Hl0+3WYyXLpoFY2qJQ=;
 b=g8ZCHSiwrRTsFkUg0xNY10+TyFzI3p1Tflkb0tgW874Rx/7Zec07SJRpxuOHYCVgUbO8iVL9HND6elU5Qlduf6Pmzmewk2yQxjZrNBN59+DTZy9g3Y710K4G+43o5tDlZKAtFF9HixlO5LlA0m55Oxf3jNuV7uv8c2id9C3vzwoMCkBOpMZIoFWB+WdtPDGUoRU9H2NbJM9k4zeWwn/y/w4i2qTz6vIPt09THVEElV0i5PBBGj/O0FQTUOEJBQ4Uyktt1B/OF+vHd0ZX2sHI/EntEiBar0VUP9iEK6VSqxnCIV0/iI/WytcbttdJ//mrB2zA45jT2G2hc11VuR0YJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3YgRnuXNKXZOmk5GsssyOA38Hl0+3WYyXLpoFY2qJQ=;
 b=MjTEX6VxMU8Wiy8QPgSQxFG6KtYFgBYRnfRPNjIsJHqOe4NVsTJGfHrt+IYFhzvW9Dd9TRV8GxN+hYluNfLKWS+glXdP8t2hWoMLwDD92pm8MnVUhHhkZAFZOQuiBVvDVeLViv7HOVF7SosRc0VcEKJ47GgefufthAe7OdAhBQE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB6908.namprd12.prod.outlook.com (2603:10b6:510:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 18:56:16 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396%4]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 18:56:16 +0000
Message-ID: <3b670574-a3bc-25d2-1237-571df009cfcc@amd.com>
Date:   Mon, 3 Oct 2022 13:56:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
Content-Language: en-US
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Moger, Babu" <Babu.Moger@amd.com>
References: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
 <20220903235013.xy275dp7zy2gkocv@treble>
 <CALMp9eR+sRARi8Y2=ZEmChSxXF1LEah3fjg57Mg7ZVM_=+_3Lw@mail.gmail.com>
 <CALMp9eT2mSjW3jpS4fGmCYorQ-9+YxHn61AZGc=azSEmgDziyA@mail.gmail.com>
 <20220908053009.p2fc2u2r327qyd6w@treble>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220908053009.p2fc2u2r327qyd6w@treble>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:208:32d::21) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB6908:EE_
X-MS-Office365-Filtering-Correlation-Id: bb1bdd72-98a2-4948-2116-08daa570f2f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BvokzxgJo+USJD2k8143baZjnibKcJMKBxHAorA+9+C+SlY/dneWYGCMwxwS2lWGx5BdOYX5BKZkc1KszzOvMeZ6ibzu/z/dfE5KDudIYSzvnnWuXqY4cBQYpSKlV+JvIg8yya6/PAUvVmPaURcaDFJOqM1KGK5cmC91f9JFq0Y+v9Yofgqz+pYn6Gs9Ig4ZygfrJAHpskaFrnt+5+OaKDv/usA8vIRiV2iohTWOOAX9680HgpJY21ifUAX7HM0Du72aTFlsNO/OFalSTG0Ub9+6kLMghWzmfrAHJO3BG1O/8+O2pFMNuG5heWY/8B3UxlHI94ynmINItXx9ghUCJfPUF/6c2JGOigHORaCR2WLPhSQeBCkiIa/tXdV2yc0rHyGXBhrQmfIC3+Nt2o+pdZV5pflDyKSDFRKBRD6PNNzCEO+jJXItXl8s6cRCNF/AB+E2GVW4WGhDBmS5WeDuq4qVL2KP6XbrxXWuo1tzGTmB2jMtrzHTNjl13hz5QuHfo6+nO2tPw0FvHk/QTRJgrWFHdzpGIhvnSDbXyB75DpQH50WjzFsmtvtp+d9SHkgreb4cQWM+8AtQvxL+QOfjk33yh0aUfr7nWIGNGuPFa1khQB/JXo7KJoJDoFoz8SQssgAgdBhUoH0jvB4wzWfq3wgmO0oiEPhUhGCkfoAK2gglJexLErDJTUEoTdbFpSxGvKnWSuB5yfBBZ3TEsPvhITDP/zzGWH2HHzTqKqOrYjkT3gO9Z0s10MqT3ify8XuUes/m/Dffu5l2xuIDjgQfT1jKKCqdLlIRaMAZRQAfzHPLLzkyOhrh4MDGCEAXnM4j2JskQsSMhezLcDvcQvicMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199015)(5660300002)(6512007)(36756003)(2616005)(186003)(8936002)(8676002)(2906002)(66476007)(4326008)(66556008)(66946007)(53546011)(41300700001)(6506007)(6666004)(26005)(38100700002)(83380400001)(86362001)(31696002)(6486002)(966005)(110136005)(54906003)(478600001)(31686004)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1VRU3lid0RVbFpGYWV0ckFFU3F5Zm9EckFrVUNpU0RmUHE0clFLcjZCTXB6?=
 =?utf-8?B?Q2JPclNUMlVxZHRUN0pCcFhMbTFLYmpjb2x3Vlc0aitSb3Z6a2NsUkwzeTJL?=
 =?utf-8?B?VU5ZaVdDRlFPbUhSNmhaTFhZaHgwd1pMOWx2TmhneVVENkRBSGY3SEpoc0Vn?=
 =?utf-8?B?WGkrTEFKU1BxQ294bERFblByMGwwT0E4OW9zZXEzUzVMZHd4eWpWWDY2enM3?=
 =?utf-8?B?aTk2MmVYUUdmR1MzaTNOVm9DSThWNWRpY1FVNjZESWJhaDUzcmQxZGRWcGFl?=
 =?utf-8?B?S1d1NkFwVVpRLzNrNjcxRU5ydm1ieDlBRWJEaWtqanR2c1pMS2l3cmhyVita?=
 =?utf-8?B?NytyOHYzSUthd1NFYTg3ak5kbGtzU01vRzZyTEdLbGJHcFgreUdXdDNXdEFN?=
 =?utf-8?B?QzZIQ3dJOHZTWjRhVFFxckhVZnI1bVd3aHhKb1RTTE56NUh4QUlFd3dycnpG?=
 =?utf-8?B?NHVGd3VlQm5xR0J0WnRzSzJlS3lRWEYwTVV0MEI5YjZjY1VJbVhNVGVWZGpo?=
 =?utf-8?B?UVFvZy8wTnhaSkxPK3dkQlZBWTg1TTNQeWZITCtqeGVXemd6UnllZnVJM0to?=
 =?utf-8?B?azRlQ0ZxYkVoTWhETDREM0xGSDNMUG5FRHI2b2tCRWNvZUdRQThpMkd1VGlB?=
 =?utf-8?B?ckEvMjBsWnJQSVB0VldXMGc3Qy94NmhDYnBGU3k2eTd1clF2RTRNbUdxR1Y2?=
 =?utf-8?B?d09zWkcrTEl1V2wwc2JsVVFVRXRXUVFuTGVFUkE4Qm8rSnhSOEhPUjFBczlw?=
 =?utf-8?B?a1d4aWxJZkFRVEV5ZXhndkJ2ck1mMlhyUEMzSFpqVGVpV3lINnN6T2lkR0dV?=
 =?utf-8?B?b3FVVkJ5ZWNSbWEzMU1YaDdDTHhiU2Z5Y0ZRTEpEVGdzN1hyMjZ5ZFMvK0hl?=
 =?utf-8?B?YytVdER5SUxGOUkwSjJqcWFJTzFNS1hEMzNDdkFFMmtDZFpiZW1JWVdZeTZ1?=
 =?utf-8?B?am5iNG5qenFOMWNJUFRiQnZtNS9ZWER1YUxYd2FVcGxyV0dhT3pYVVRGL3FB?=
 =?utf-8?B?L1RLWW10WStjaktETjg3eENXVmJyaWE2bVI1TzJvV2hjSGZYUXRTUDlzTFdm?=
 =?utf-8?B?Vm1oWVk1MGNyZi9NZy9LY05mVTR4REhVdGdBSzlaQ1FET3Era09HT1JXZlBk?=
 =?utf-8?B?UUhKSTlWMzF0eHJSbXViUkp5VGQvWkJPRXl0N2wxa1lLQ3p4NXdhenJkY1ZR?=
 =?utf-8?B?WlcrOE94cVFRanpncWdQSDNHZjU4ZEVGOWR0MVVMUGt4L2ZXZVhWVzhqOG9j?=
 =?utf-8?B?NGFVUkV1dlZ6TnhvUWp6bCsrNWJwOWNjQjk2eUJPRVh6TjRsZGk2U0t1S2ZH?=
 =?utf-8?B?OFdxd0pucXd0aXY4MU5vK0FsNC9KbW5oQ083dW1BWWpsc2kvWW0yNDVlci8r?=
 =?utf-8?B?aHRhWjdKTjZxa2VPMVFvb2RFVW45ZkZqblROMkgyYytMaCsxN3h1bDk1dVdF?=
 =?utf-8?B?Z0JlSUJOK04vVE0wQmVrOGZjc0VUNVgzS0tMUW1WdkdxazJreWdkSjFRWWM2?=
 =?utf-8?B?OHpYbVVYWE1DRzI0cFNSQ1BlakFDRWdHYm9MQ0hZNFJNZjBRbXhoUkRsbmNo?=
 =?utf-8?B?OVZvWWpNOVhCRXE5VFpIYUVrWnF0ZldyckZjQjhGMzJKRjZ5QTh4Uzh0MlJ2?=
 =?utf-8?B?Wnp0aUdvdjZna0RKdTlwSnB4My9RRjEzcTAzMWVVaVNnakswSHlIUEh4ZjNL?=
 =?utf-8?B?U3VPRzcxeFZWeEtvaysvRlBKWnEyemxlWE9KeFYrc1VtQzhmZlBmZWVjQk1E?=
 =?utf-8?B?cmF2dnRsalVVMDJEcXNpaWllek1hQ3owR0xmUjd2dmZ6clBKT1BBSjQ4K0tK?=
 =?utf-8?B?MVRIeWdPbmRFUXNXQVk4TlFRMHViU29VYXVnVVNTL3JnVmFaMkFHZWxpVmtE?=
 =?utf-8?B?aVJBSTdxQWJsV1VzWjM5M0JEa1lMOWVaNjhvTVd5bm5zcUdaRmxKRVhkc0dF?=
 =?utf-8?B?emRiOEZEcTFHbWlxc2o0OWV3L0g5YndweU5lbEdCNFRnT0xvTjdWMFdISGZZ?=
 =?utf-8?B?TlEzL3k2MXZobENnbllWNitjUUJrWlVqY29ONnJINkkrelJoY0tMaEI3OXZJ?=
 =?utf-8?B?Uzc1UEhVMzh2Mm9OOXVZSjM2QWdmUitEYUx4dWFBR2kzbTNNNmZ2dnBJdlBP?=
 =?utf-8?Q?ycEEaBD2l4S4WIDRVC2u8xH3R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1bdd72-98a2-4948-2116-08daa570f2f5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 18:56:15.9460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGGpFm0ErZGvuUI95fj//zp6uMi7MJ0UZwpw65CkhxJWX8tIezlvaNHZzQ46hqzIBi8SMZDtZ+Aa10R3/1WooQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6908
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/8/22 00:30, Josh Poimboeuf wrote:
> On Sat, Sep 03, 2022 at 08:55:04PM -0700, Jim Mattson wrote:
>> On Sat, Sep 3, 2022 at 8:30 PM Jim Mattson <jmattson@google.com> wrote:
>>>
>>> On Sat, Sep 3, 2022 at 4:50 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>>>
>>>> [*] Not 100% true - if STIBP gets disabled by the guest, there's a small
>>>>      window of opportunity where the SMT sibling can help force a
>>>>      retbleed attack on a RET between the MSR write and the vmrun.  But
>>>>      that's really unrealistic IMO.
>>>
>>> That was my concern. How big does that window have to be before a
>>> cross-thread attack becomes realistic, and how do we ensure that the
>>> window never gets that large?
>>
>> Per https://developer.amd.com/wp-content/resources/111006-B_AMD64TechnologyIndirectBranchControlExtenstion_WP_7-18Update_FNL.pdf:
>>
>> When this bit is set in processors that share branch prediction
>> information, indirect branch predictions from sibling threads cannot
>> influence the predictions of other sibling threads.
>>
>> It does not say that upon clearing IA32_SPEC_CTRL.STIBP, that only
>> *future* branch prediction information will be shared.
>>
>> If all existing branch prediction information is shared when
>> IA32_SPEC_CTRL.STIBP is clear, then there is no window.
> 
> Yes, that would be an important distinction.  If thread B can train the
> branch predictor -- specifically targeting a retbleed attack on thread
> A's RET insn (in the thunk) -- while STIBP is enabled, and then later
> (when STIBP is disabled in the window before starting the guest) the
> poisoned branch prediction info (BTB/BHB/whatever) suddenly becomes
> visible on thread A, that makes the attack at least somewhat more
> feasible.
> 
> Note the return thunk gets untrained on kernel entry, so the attack
> window is still constrained to the time between kernel entry and STIBP
> disable.
> 
> It sounds like that behavior may need clarification from AMD.  If that's
> possible then it might indeed make sense to move the AMD spec_ctrl wrmsr
> to asm like we did for Intel.

Sorry, just saw this thread...

Any predictions made while STIBP is enabled are local to the thread 
creating them. When STIBP is cleared, newly created predictions would be 
shared between thread A and thread B, but old/existing predictions from 
Thread B that were created while STIBP was enabled, wouldn't be used in 
thread A.

Thanks,
Tom

> 
