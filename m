Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03D97B368B
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 17:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbjI2PU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 11:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbjI2PUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 11:20:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E30BF;
        Fri, 29 Sep 2023 08:20:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9GKxQcD3ru7w7lu+4/CEv1khup779AF2cA6kjZA3KIfGnoH8Wx4Xe6WY+2uij8TUQXSQPEmOgZyvGP43/evm9BhA2jTFZWCJHof2IOqbQUcl86pBXmOj4zTUiYIhIxHF//fZaNsKfinbQ7hdMQcyDt1UuVPeBA/+C6RHftzvw5w2KxWoSyjLVGM5MOjJGgT13lqWQqfqvxlZuedF/xz97TAw3iRq+/EZuz+dHX4UDFEx/q9C4ebz2kPWAUuzULQPSHQsgoNjItGYy0c3a6tNu6U6cCkKOMw03J9DLCvo8cAFh4+mXRVqD4kjFMlN75dD4LEC51uIhB7rPx52ohaUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgPGfeBA26AOK1p/cUqj6SE2f1ZpErc9+DbTahbj0d4=;
 b=n9ihLJnpdxN1QKFA4yktVuHkmL7uN6YkJQp9LkBYhW8tekGkIt+ePzAC6ORm8pJRtDgUdYcydUivvv+jQOxPVMrAHFmSbEekkL7qejA0wUyqP0nM0vj9/S51ZbEtGmGg22qpkI3Ui7fiQblPeqj5Qap8KeeaVQE8m53j8hsmINBpdIjZmZfySIdNfK8tnFh9BSbfUnWoSvkFkzrCMnUKIr6es+0MeLNPahCGMi38Mt3SFTL9q6UkcHyFZpq3vvaFUE8BdDrwKoU84eqW2fuGeiLbqiEhHPsbHhufds42At8Ax5ufXIIazsHdbKGQQUBPeGQ/MklhTgiN3i4LhFA9oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgPGfeBA26AOK1p/cUqj6SE2f1ZpErc9+DbTahbj0d4=;
 b=F1DuA4dTt98M3MI3CPUz+UFXNoxI2Jm5gU9WJf/kYrTOUOordNpW8pU3IJLmxSPZ4ZL83jyVnZxK1rx/6u2YRPsVO5tXUJFLQJljiC4Kn1CjTGhd6G3Epj9nYfoyrVxHtPg0XI/mxSxTa5sEl48tRZbw31StUvW8R9L11t0pkx0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by PH7PR12MB9104.namprd12.prod.outlook.com (2603:10b6:510:2f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.27; Fri, 29 Sep
 2023 15:20:20 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::a4ed:10a6:876a:10d7]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::a4ed:10a6:876a:10d7%3]) with mapi id 15.20.6838.024; Fri, 29 Sep 2023
 15:20:19 +0000
Message-ID: <957d37c8-c833-e1d3-2afb-45e5ef695b22@amd.com>
Date:   Fri, 29 Sep 2023 20:50:07 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Dapeng Mi <dapeng1.mi@linux.intel.com>,
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
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Manali Shukla <manali.shukla@amd.com>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
Content-Language: en-US
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <20230929115344.GE6282@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0209.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::20) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|PH7PR12MB9104:EE_
X-MS-Office365-Filtering-Correlation-Id: b49d64bb-8b3a-4867-7ef1-08dbc0ff9786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDap6XSMPVq4YXDZT6n7kXqOHUQwZoAdgHhSfJVub8h7dZAWqze2YUusqxWQ7D43jK/VeDbFeu29NYiy+zzOoLgSHvU7YagRj3BI179hdkZ0qolLd5whZJoebqp1tZujpWO0f+SB4+dNNhBkHUy96+SKOl8pCh63xb4PEvHnYNHxMqx98HLMhSF3o9OQR+orR54XPQRLRCp47mw0n0rQm3Y2Da2EyrDT/wzb3xsIWbUX2ZcjvnXNmyZh3xRv58Q8/wCfpiaAzfZH1xnaRMgzrHIkApp2qOhvqwel6YwliqvB1NLPI/YeHfUrHQhlE88VOcUrtcNhMFEHgiz5wIq6kJf78Z6JEeppHK/c7eJCivmrYPfNH+HHjEyb8088PJLqtrukeGt4Ay9hzjMQlO8AGgiLbwUQtXazoPcHBRyyUfXA2dKdzY2DNmSzwwzhfASaH7UN8r6v3aVHTIb6b6UI9q4uO6wwClH/bd3wx7qWokdv1j7HWRRekJRe50lN309VQo/HO5rMIg1HZOGNnVYrFC/BHu3ADsIgLkaIqh3EETWv/Bgpb8Jhhv07U8AyYxsegmsO8PJ2B8G2J+kSrjrqIW9I49NxRtHld8TBIhCBdVQzIN1P1iOknp6dt8ZBgwTxTpSgHg/QU2FNFlqfmg7HJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(396003)(39860400002)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(31686004)(66899024)(83380400001)(38100700002)(4326008)(54906003)(7416002)(86362001)(31696002)(36756003)(966005)(478600001)(66556008)(66476007)(110136005)(66946007)(44832011)(5660300002)(41300700001)(8676002)(8936002)(2906002)(53546011)(26005)(2616005)(6486002)(316002)(6506007)(6512007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWVGcVhXYXZUR01CTk9yVzRuMU03Y2s1RWtVQzg2ek5IVnV2MG1jT3QzSU9Q?=
 =?utf-8?B?QkFrUDRJWVVrWW1jRWVTRVcySUZWRXk3M0M1SG5EMzhOTE52NGVESW1mM0ha?=
 =?utf-8?B?TWg3RUVrYWFKUXJEa0xtb1NlU01nbC96SnNWVmJKVVFCS3V2VzZWcWM1L3pX?=
 =?utf-8?B?UGN2TkZudWVqelB5SmlvY252OWZiME4rQjB0bFdEY0g2SDNxRGtPTUxSQWto?=
 =?utf-8?B?TDdMd01xcC9tVzg3RERidUdnMm1laExpMmVBWVFkSFNDdUgzbUlBQmdCSFFJ?=
 =?utf-8?B?NnZqUHBXTTltZmhZb3ZpMzM2ZWdrazZtZFZDTEZxcWpsMFJXampXVWl4aUdW?=
 =?utf-8?B?d3RtN29tQ1pSVnRYbzZmbUNlTG9kbjJlOU1QYVhuTm5tLzJRWEZMTGxNQ002?=
 =?utf-8?B?UDdraS9RRndvOEkyT0FzV0kxNHpYOWZqZjEyZmN5RS81eFY5L0RTRkdRdjhk?=
 =?utf-8?B?bUJnaUlUNE1ZMEdUVjhXK3c5TjVaYzVNcmtCdHFzQ3cvTFdXaUwwbktoSTBu?=
 =?utf-8?B?UnJzSXVNazFGdnpobUZXdGQ2ZGl6bTZYdzhpcXorS3gzTlR0L2pWUWNEaCt5?=
 =?utf-8?B?LzRZWngvUTVNdit4VHBYcDZ0N292VjVyTTh6N0dKZXc4ZWdHVXZ1cnczMkhl?=
 =?utf-8?B?dTZBaEkyZHhRZGtueDdhRy9DVC9hZi9POXpVQ0FoVHNmbHc5cTMvK2RGZ0tm?=
 =?utf-8?B?Q2dCYUQ2dmZkdVFTSEJFclpkNkdEb08rcGZoRXFRSlhqZVlqSE8zaW5MRzlP?=
 =?utf-8?B?RkxHSHRSZkM4TFRMUUMyUmx1azVRNzk5TUZ2OTF1Nk96aUVnNkJUdDh0bmhy?=
 =?utf-8?B?Y2t1TVVwQjNFZktJK0QrWUluU3pyMEl2TlVsOW9rNkErRHVMWUMxUlByL0RW?=
 =?utf-8?B?QVFZdVFZY2NQSG5FVmE5STA3Wi9kMkZWbFBLTU51T2xmZlNzMXNnczZOOEUx?=
 =?utf-8?B?UVczOW10WVR2N1JUZmRReXNSNVB0K0pycmoyd3lSRGEvUUFCNTMzemFnSm9q?=
 =?utf-8?B?SkdGSmVvdGJXZGpSTWZtdUhNNWxBcVFLV1laZklyZ2NNRWhsVE9tT0RCR1Rt?=
 =?utf-8?B?T2pIL0Qwa2RweVBscjB5OXJuRXNjaUVwYTRtd1F5VXdXaUc5WHNUNVVKeHRW?=
 =?utf-8?B?YTVQL3dDL1hRZHJueGIwTUpLKzl6Q1I5Tjl2cHN1UnpHbmkxMEpQOFNqdUZS?=
 =?utf-8?B?RG9KN2p1V2R5c3lDZ0pYZ09nNUtkZDhNazlyZlZTNU15cDVPWmNFMlo0ZFky?=
 =?utf-8?B?WUxpTVFXU1p2dzVxQ3V3c3hXTVlTV2QzbExnT0I2MXFJYWw3b0NJdk9Ed29F?=
 =?utf-8?B?NWdMY21FNUxPYU1tcmM5c2JxQ0N5M2NKS0Zzbm9Lc1l6Y0FGb0t3RWpRQ2ZZ?=
 =?utf-8?B?WHhHenhpRy9mZzRtWFNxVGRhd3FjNlV4RUFIa1VnY3lZeFk1eTlMeWZvc0lE?=
 =?utf-8?B?ZWtvZTJreXgwK1ZTMDg4YmI0TEx5eFY1WU5RTHNXd096ZnArZzVRbXFsVy8z?=
 =?utf-8?B?blRYUDFJeHYrWHFRVWpYZmo4bXlsRHFCeHNoZGNpdUphN3FleXV6c0h6OTJu?=
 =?utf-8?B?UHhQQU5nMEluZFVLdUsrK1M5RGE0NG92RlpqenNkODVVNjlHbUVsNVZmN2Vz?=
 =?utf-8?B?ZkpjOGdDWENld1pzTThJY1lORmlhUjN5ckRZVXh4ZUdFZG82N2NCVzZkQWZJ?=
 =?utf-8?B?bDNCTkZraC9vY1ZXeGhubkxBMXJneWRyNEdTd0xIaDlrRW5GTWNlVlBsVzNH?=
 =?utf-8?B?aFIyZkw5cHVGcDU2ZUFqL3pXdkFHVHdSWGZ1cE9Cc0R5bFczR1FTbWdreTZY?=
 =?utf-8?B?MjFOSmYyMWlQWE9rMFB3WnhCUnplcWJRUC9aWjdqdlB1UDBycWJRS201cEJE?=
 =?utf-8?B?K2RJNFRkTjROM01KMVRvTkc3Tkd1cGlOcnpUZ1lvL0o1QWdmV3VMcHFNSlVz?=
 =?utf-8?B?QnpyQU1ZUm42NWhXcnM2M3J2OXBLWUI5aFg5VTAwUnZFMXJjU0lRbmxkSDBG?=
 =?utf-8?B?aXBZVGFNZmRINnA5L1R6QTBnanpmbHc2T2VCY0Y5d2wzWUtTSGQ0ZjZ3bkhk?=
 =?utf-8?B?T2FJcHVESW9HNmtRcThPb29tOGR0aFFINWl6aTJRdTNMUnI5dW54OVhNbUxl?=
 =?utf-8?Q?1Ww9Xy3/B+XUz5biRdNOKYQD5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49d64bb-8b3a-4867-7ef1-08dbc0ff9786
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 15:20:19.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awIQZK6hHMZx6o4IuGy8LDi4myTffgAEYx/QYXTHw6DOGseWKKeGJKDIAU2JygrmOqoWw4sSM/4QPf9EOvPLzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9104
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29-Sep-23 5:23 PM, Peter Zijlstra wrote:
> On Wed, Sep 27, 2023 at 10:27:07AM -0700, Sean Christopherson wrote:
> 
>> I don't think it does work, at least not without a very, very carefully crafted
>> setup and a host userspace that knows it must not use certain aspects of perf.
>> E.g. for PEBS, if the guest virtual counters don't map 1:1 to the "real" counters
>> in hardware, KVM+perf simply disables the counter.
> 
> I have distinct memories of there being patches to rewrite the PEBS
> buffer, but I really can't remember what we ended up doing. Like I said,
> I can't operate KVM in any meaningful way -- it's a monster :-(
> 
>> And for top-down slots, getting anything remotely accurate requires pinning vCPUs
>> 1:1 with pCPUs and enumerating an accurate toplogy to the guest:
>>
>>   The count is distributed among unhalted logical processors (hyper-threads) who
>>   share the same physical core, in processors that support Intel Hyper-Threading
>>   Technology.
> 
> So IIRC slots is per logical CPU, it counts the actual pipeline stages
> going towards that logical CPU, this is required to make it work on SMT
> at all -- even for native.
> 
> But it's been a long while since that was explained -- and because it
> was a call, I can't very well read it back, god how I hate calls :-(
> 
>> Jumping the gun a bit (we're in the *super* early stages of scraping together a
>> rough PoC), but I think we should effectively put KVM's current vPMU support into
>> maintenance-only mode, i.e. stop adding new features unless they are *very* simple
>> to enable, and instead pursue an implementation that (a) lets userspace (and/or
>> the kernel builder) completely disable host perf (or possibly just host perf usage
>> of the hardware PMU) and (b) let KVM passthrough the entire hardware PMU when it
>> has been turned off in the host.
> 
> I don't think you need to go that far, host can use PMU just fine as
> long as it doesn't overlap with a vCPU. Basically, if you force
> perf_attr::exclude_guest on everything your vCPU can haz the full thing.
> 
>> Hardware vendors are pushing us in the direction whether we like it or not, e.g.
>> SNP and TDX want to disallow profiling the guest from the host, 
> 
> Yeah, sekjoerity model etc.. bah.
> 
>> ARM has an upcoming PMU model where (IIUC) it can't be virtualized
>> without a passthrough approach,
> 
> :-(
> 
>> Intel's hybrid CPUs are a complete trainwreck unless vCPUs are pinned,
> 
> Anybodies hybrid things are a clusterfuck, hybrid vs virt doesn't work
> sanely on ARM either AFAIU.
> 
> I intensely dislike hybrid (and virt ofc), but alas we get to live with
> that mess :/ And it's only going to get worse I fear..
> 
> At least (for now) AMD hybrid is committed to identical ISA, including
> PMUs with their Zen4+Zen4c things. We'll have to wait and see how
> that'll end up.
> 
>> and virtualizing things like top-down slots, PEBS, and LBRs in the shared model
>> requires an absurd amount of complexity throughout the kernel and userspace.
> 
> I'm not sure about top-down, the other two, for sure.
> 
> My main beef with top-down is the ludicrously bad hardware interface we
> have on big cores, I like the atom interface a *ton* better.
> 
>> Note, a similar idea was floated and rejected in the past[*], but that failed
>> proposal tried to retain host perf+PMU functionality by making the behavior dynamic,
>> which I agree would create an awful ABI for the host.  If we make the "knob" a
>> Kconfig 
> 
> Must not be Kconfig, distros would have no sane choice.
> 
>> or kernel param, i.e. require the platform owner to opt-out of using perf
>> no later than at boot time, then I think we can provide a sane ABI, keep the
>> implementation simple, all without breaking existing users that utilize perf in
>> the host to profile guests.
> 
> It's a shit choice to have to make. At the same time I'm not sure I have
> a better proposal.

How about keying off based on PMU specific KVM module parameter? Something
like what Manali has proposed for AMD VIBS? Please see solution 1.1:

https://lore.kernel.org/r/3a6c693e-1ef4-6542-bc90-d4468773b97d@amd.com

> It does mean a host cannot profile one guest and have pass-through on the
> other. Eg. have a development and production guest on the same box. This
> is pretty crap.
> 
> Making it a guest-boot-option would allow that, but then the host gets
> complicated again. I think I can make it trivially work for per-task
> events, simply error the creation of events without exclude_guest for
> affected vCPU tasks. But the CPU events are tricky.
> 
> 
> I will firmly reject anything that takes the PMU away from the host
> entirely through.
> 
> Also, NMI watchdog needs a solution.. Ideally hardware grows a second
> per-CPU timer we can program to NMI.

Thanks,
Ravi
