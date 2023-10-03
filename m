Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2B7B6FC3
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjJCRcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 13:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjJCRcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 13:32:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA959B;
        Tue,  3 Oct 2023 10:32:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezd7+fdR2D5vslE/mHbOrWns73AnntEBsK97zAIoTqnhVG6lWBxC7BPCHwc14HurodRdFSZjSZVvtGkxhaOvlh7ysgJgZ72y13d87hl/SyPEGuKudh2kuW22/m7Ke0GhpR2Z/XXX2bRc78ALmH++NvwGjUojbq4/YNcVysYi9fO/JyjnlKYF7bBZ6NtUc0k5E33CN4H7kEkXH8vR8JFd4vhtOAeeMTbTO4Y0ir2N1u9oOvhy1DCUC0QaCg5as42N/vP7r+udMLSaZlZAlErSqv+EQPvNWYYOfehA/kvc1YfZl9Om4lW66uDo6N/Kbc5MNUqI3ay2W9PWZxgcx358zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zkR5pr6eFWsRfsahfhH/3iWHa3/Op93avmkrlyqCeek=;
 b=IIVAkOfMHD+NNG8GBLkshAopFhgk6jD5HK3pch0Jnz3N01R/Jk79n150gRSarY0VOwdiGq4vM0tMy78Saf3hC1PYdzqPSCITjzKpvidcN5RbwvoyP+iufXGK/6qYQ6Z1dnwUqvcZ7JrTgGrYuGkAkYNU6ISRhA625dcRSv0Np2LmJyH3ShYE69qX5BluMoS1RRV2YZsrDikRJcd0sJQz6rZln7Dxwu27LXGzSH9UY6MX1hF6XCL/lE576csfiI1waT7eEeIzcpUupx7QuGXKGZLxPiEXk21EqUg153FX3fyOvApx7GE1VFidgw/mzQs1IvcZiohSwaa5ViigKmTnDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkR5pr6eFWsRfsahfhH/3iWHa3/Op93avmkrlyqCeek=;
 b=sU+5NF6Dxn57awqmnj50MRf5SbGvoBcaysPzX4yEvCZjXRgYc4yj87IqnUYrAlTPvVek3ph7Kojc9rjoFaEjSQA+XEvdRSpID5jwBjyE9VZS9Lvpm41SipqyYGTs5nvhEE70PYkbCSq37EIKwt+IU9Lax4E21F0khR63U7c/qT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 SA1PR12MB7150.namprd12.prod.outlook.com (2603:10b6:806:2b4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.25; Tue, 3 Oct 2023 17:32:18 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::2d00:60c4:e350:a14d]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::2d00:60c4:e350:a14d%5]) with mapi id 15.20.6838.029; Tue, 3 Oct 2023
 17:32:14 +0000
Message-ID: <13b55438-d990-6d6d-f1d3-8e8a18027825@amd.com>
Date:   Tue, 3 Oct 2023 23:01:56 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com>
 <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20231003081616.GE27267@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0007.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::12) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|SA1PR12MB7150:EE_
X-MS-Office365-Filtering-Correlation-Id: 52174501-1f2d-4570-64ee-08dbc436aeaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JE4F15MnBdG1WMT6IJaDrGWaTPOJ1i7BrIK9WeQKKtJk/jzwNdEZP91+ra/kCd8yWRFrZAmtA7EhKnGBmmaX6VXxIg5ZtyzLAbthU31A6fyknagJGuBBn1teb4OvP+/fKgtSzKKhe6jr6yzT5ZFN+XpZlRNEG6ZcAFDH1n/fxQHJ3pdO6gqmdFC5DMMTESBEQMbPkOa8nDJF2L1rPlAbAOBmYXG0mH54xUIjI+rTg/RYaAqsEZiJyTfBWYfWv/chIF27W8tw6KrEisuRq+fnWa5oOuJ6LH8uq9sUjfvfrOnzopmmz+5RFXJeYmLuFEQo2keDWF07sNNERNI2kLgWhfP6CXBOQnrP/wCkauWskqP/HxIl5Yey3RDJbY1mfwIEWKRGwug3me9KE5UN0JB19HGiEve6gxGyRGgYnaPj3KEPZj0mbzSgecAsBFoWRujWaOBFgO2hHWiX/USNPs9/NARe4BGSIix/TeNVx1CInmM75nvil4Twdbocn0zppJvQQ4vqrLnnHOFTC588pkP4rDKheGqFoWgGTXnmBIvcSTYnO82uKEDvEbs5qKxb8i5jPu2nLry6bRpNtw1sYEdBhtbt3Z3EXGHZ0ZcrX6g0JIkKJB9Ko20W88xCW3PJ8/vhJxtzZWQgnLCupVI1Ok+tkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(396003)(346002)(39860400002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(83380400001)(2616005)(86362001)(38100700002)(36756003)(31696002)(66946007)(110136005)(316002)(66556008)(41300700001)(54906003)(66476007)(5660300002)(8676002)(4326008)(8936002)(53546011)(31686004)(7416002)(44832011)(2906002)(6512007)(478600001)(966005)(6506007)(6666004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2gvdlN1WVE2RmhYYkFwbXR0NkcwSDducElJUm5yc015VFlOSVhrbnE1WTc3?=
 =?utf-8?B?dGs5RDVISmFhL2d6WW5hRTNhZnAySU0wSFhWQzIzOW1MdUtkQTVxUEthN3JU?=
 =?utf-8?B?QUJqMFpsVExyYUsyU09lQ3R2SjFsRWRjQ2pjRG12WjdzSnlkZmQ1TzMrSldL?=
 =?utf-8?B?ZCtBV0N2UFViek1LTk0vRkJlOVhZN1dyQzJpRk9ZbjB5SUx2R0lld09tSmVs?=
 =?utf-8?B?angvRHQ0d1kvNDI2b1RIdSt6YlNYNnFtekZtZVBieE91QUlSTXZNNDI0aERl?=
 =?utf-8?B?aWk3cWFiMGY1ZDhIZHRIKzNVQ0tER3NUdG1hNVRZRVpRWUtrSFJQd0JTSzZQ?=
 =?utf-8?B?U1BDSUxhanU5Z0pUS1lBVGh3QVZmQUUxeXdqYk01djkzdk1Dc1RtVGo0SS8v?=
 =?utf-8?B?aGxBQURGSDA3Y3d4cjg1ZWM1T254ckhqcXp2dGJ0bU1kdzg4VXJrVnJpN1Zh?=
 =?utf-8?B?WnhYNElaQVN5cXROMS9GUzhKK1IrbDRXcWVsZ3pqczhKbkwwaDlxbU56dDdz?=
 =?utf-8?B?MnZ0Tkw3QllsM2k2bWZNaVQvdmtCcnpvbHVjelJmajI0MFh0OWZMcXFOTE93?=
 =?utf-8?B?ZjAwNlFCZkw5eTYvbENrZ0Y2T2lYMTFaR25jMlhHVm1xRlo5Y0tCd204OE14?=
 =?utf-8?B?Zmd1K2pxRzNTdXE0d1pzTlVWTVFNLzFqUWVnK3hzVkdVN0NhYk9wOGVQbFVl?=
 =?utf-8?B?czZneURIcHVKMnMzeklWTVNtV3dOS0VBeHJVbmt4SmxvaDhqUGdIUlFpT0tx?=
 =?utf-8?B?MWllcm1wNGRwMksrOVJ1MVJZRHZIenVIbUprLzJQak50QXlKWWYyb3NqUHNI?=
 =?utf-8?B?WWVUQ3lDRm1GOENYTlZsc09YNzdHdEd1dXlpTElrQ3UveVVTMWtYN0l2MERN?=
 =?utf-8?B?ZW1aMWoxNXBzOXJZTnlFMzFScWF5djhxTkVBbmVsSDArMXFyYWFDRmZkTWt2?=
 =?utf-8?B?VDlXWVA2SVdURjZ5c0xOTTZZcSttSUxSZW9rekt0cnpOTFBBa3Q4SmwzUXpv?=
 =?utf-8?B?TEMrQzN3TVBvZFRYbWpNRkNJWlpHdmQrTSthVGxmZUg4Vzc3WkpIdDZEdndL?=
 =?utf-8?B?ZHJwM3VIc2x3Q1luMHdlaVVJdm45aEk4TWxsVVpaeFNFRkU1MEJqWkJSOVdM?=
 =?utf-8?B?YmYyaVBJSXY5andFSG1WdUVpb3hsQlhtanRQdHoxK2F2MFowTVB0YWZSRUhs?=
 =?utf-8?B?QVF2d3ladFBGcDlXaXZoZnhVdGV5Qm5sS1VHREV3RDl4eUhrNG9PWklJd2o4?=
 =?utf-8?B?dDJqdEVheDVDeXhYYmFsOWk2bHlRd0tXbGtXdDZNR1pXM1NFZmViaDdXQ1RN?=
 =?utf-8?B?d25oWWt0WlhCeGJuQzY5djlXVFV6MkZLVWk3alc3ODF6TUdURWtLazNldXZW?=
 =?utf-8?B?UCtWckE1OCtLamFnOUVjYWxlSXIvSDVINjNGNlluRXlIcVdFSHdVZU01SEZz?=
 =?utf-8?B?MlliVy8razNVUUZwaUt3cjBGa2lMb2xrWXd2bGZXRkhaaFdrbTRBbkNqcjBO?=
 =?utf-8?B?TzhkY2FkaE5FUmE1aXJac1VXSnA4QlliUzEvZE1mMnEwYVZ4dmNkSk1HeGdL?=
 =?utf-8?B?Y0czdVVzek9wRmgzOEExejNnVXVIM1ptdTJ6NlJOSzBZUlRGd3N6Qy9qSEYy?=
 =?utf-8?B?UTB0cnhlcWs1bWpRN3RjVkE2MGxYejdnV0g2N1BnbmNaUEV0Z0Zuem43bTNX?=
 =?utf-8?B?SjFIM3BaOGlqL3ZJUkpVVDJNWTdTdDJjQUh0ZU5YYXlJckRTYU9KcGxEUVlr?=
 =?utf-8?B?UmxIUkNFT2V6ejNwa3NQV1I5VDVZR0RUMXpnTm1ob21nM1VyTE4yNWxKVk9M?=
 =?utf-8?B?aU5sWXNLV0RvdDBpbWQ5S2pGUG5STjhMK0dmUmxQbjZmekUxcmlDTTM0R2N1?=
 =?utf-8?B?MFdrOG9BMVI3QzV4QlVoVDJMbWQ5WmViNVBkRWpyb3laZXFUUUZ1SDlHUmVC?=
 =?utf-8?B?WmZUbElaN1llU2JEUjZMVUFHd0hOOHd4TUhmNXAxYmk3UXNTalNrdmlyeVpI?=
 =?utf-8?B?VjVFMFZJdlNVZFhybjRrOTYzZUFyU1NVL2RlMi9zTWJSazVIcmZQaE4xS2Fu?=
 =?utf-8?B?OEdQUEFYM0sybmI3cmVEc1AwNk03N3NsY1NaSEk3TlNUNWtUUE5zanBkY1kz?=
 =?utf-8?B?WXJneWdGaVlndHQ0eTUvMlZQSHZjRjdWNE1WcndyRHJ3L3cwYWxvUnZYV2ly?=
 =?utf-8?Q?RUg+yr+GwhnFbNrD1OAFbGz3xO6LpAZKU7GIzWFkYvzM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52174501-1f2d-4570-64ee-08dbc436aeaf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 17:32:14.5589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wk1xtdulIhYe7t6Dk8VjJtGstmV1EF7n6XANz3Ist2A1aJL9or8yR8Dq7yCvq7R9uolkRXmjy1kcd1tyWLZiUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7150
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/2023 1:46 PM, Peter Zijlstra wrote:
> On Mon, Oct 02, 2023 at 05:56:28PM -0700, Sean Christopherson wrote:
>> On Mon, Oct 02, 2023, Peter Zijlstra wrote:
> 
>>> I'm not sure what you're suggesting here. It will have to save/restore
>>> all those MSRs anyway. Suppose it switches between vCPUs.
>>
>> The "when" is what's important.   If KVM took a literal interpretation of
>> "exclude guest" for pass-through MSRs, then KVM would context switch all those
>> MSRs twice for every VM-Exit=>VM-Enter roundtrip, even when the VM-Exit isn't a
>> reschedule IRQ to schedule in a different task (or vCPU).  The overhead to save
>> all the host/guest MSRs and load all of the guest/host MSRs *twice* for every
>> VM-Exit would be a non-starter.  E.g. simple VM-Exits are completely handled in
>> <1500 cycles, and "fastpath" exits are something like half that.  Switching all
>> the MSRs is likely 1000+ cycles, if not double that.
> 
> See, you're the virt-nerd and I'm sure you know what you're talking
> about, but I have no clue :-) I didn't know there were different levels
> of vm-exit.
> 
>> FWIW, the primary use case we care about is for slice-of-hardware VMs, where each
>> vCPU is pinned 1:1 with a host pCPU.
> 
> I've been given to understand that vm-exit is a bad word in this
> scenario, any exit is a fail. They get MWAIT and all the other crap and
> more or less pretend to be real hardware.
> 
> So why do you care about those MSRs so much? That should 'never' happen
> in this scenario.
> 
>>>> Or at least, that was my reading of things.  Maybe it was just a
>>>> misunderstanding because we didn't do a good job of defining the behavior.
>>>
>>> This might be the case. I don't particularly care where the guest
>>> boundary lies -- somewhere in the vCPU thread. Once the thread is gone,
>>> PMU is usable again etc..
>>
>> Well drat, that there would have saved a wee bit of frustration.  Better late
>> than never though, that's for sure.
>>
>> Just to double confirm: keeping guest PMU state loaded until the vCPU is scheduled
>> out or KVM exits to userspace, would mean that host perf events won't be active
>> for potentially large swaths of non-KVM code.  Any function calls or event/exception
>> handlers that occur within the context of ioctl(KVM_RUN) would run with host
>> perf events disabled.
> 
> Hurmph, that sounds sub-optimal, earlier you said <1500 cycles, this all
> sounds like a ton more.
> 
> /me frobs around the kvm code some...
> 
> Are we talking about exit_fastpath loop in vcpu_enter_guest() ? That
> seems to run with IRQs disabled, so at most you can trigger a #PF or
> something, which will then trip an exception fixup because you can't run
> #PF with IRQs disabled etc..
> 
> That seems fine. That is, a theoretical kvm_x86_handle_enter_irqoff()
> coupled with the existing kvm_x86_handle_exit_irqoff() seems like
> reasonable solution from where I'm sitting. That also more or less
> matches the FPU state save/restore AFAICT.
> 
> Or are you talking about the whole of vcpu_run() ? That seems like a
> massive amount of code, and doesn't look like anything I'd call a
> fast-path. Also, much of that loop has preemption enabled...
> 
>> Are you ok with that approach?  Assuming we don't completely botch things, the
>> interfaces are sane, we can come up with a clean solution for handling NMIs, etc.
> 
> Since you steal the whole PMU, can't you re-route the PMI to something
> that's virt friendly too?
> 
>>> It also means ::exclude_guest should actually work -- it often does not
>>> today -- the IBS thing for example totally ignores it.
>>
>> Is that already an in-tree, or are you talking about Manali's proposed series to
>> support virtualizing IBS?
> 
> The IBS code as is, it totally ignores ::exclude_guest. Manali was going
> to add some of it. But I'm not at all sure about the state of the other
> PMU drivers we have.
> 
> Just for giggles, P4 has VMX support... /me runs like crazy

I am working on Solution 1.1 from the approach proposed in [*]. 
I will send V2 (for IBS virtualization series) based on it shortly.

* https://lore.kernel.org/all/20230908133114.GK19320@noisy.programming.kicks-ass.net/T/#m7389910e577966c93a0b50fbaf9442be80dc730b

- Manali
