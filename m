Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4336F03B2
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 11:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243405AbjD0Jww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 05:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243412AbjD0Jws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 05:52:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6386F92;
        Thu, 27 Apr 2023 02:52:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K21ZTQw2IaiduLf0u/H1Kh0YM2cCohDPRrztltC/X9nvdL48kRqlyxh/Fni2LpDSy3cCqfQRETP3SjQLehES27ol4dSo/jvaGZbgPwXE0evPfQj2OLWxzdap0XvgjfeBZZ+O/kxCvHxhJPlEaOFSaH7f4IBih0pAGrgOXcqH+nhmOutNT7M6yU5Xntv28FhZU+3ukoo6pj7Jo4v/IBBWHQEiBZlIL7qAbcy2w3s6b9zergCuGlyBmMHLU3bZoDpna/dihqFJXWU3/RrPQ2/e9xEpH0o7ti8scPBTkfLFR/pl4WN9lcLeo+ggJM2LsGNfzezp7Ba5HUjAs5OMDQ/ytA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lr46Mw5/T9qeoTdB+t6kSwwpXjLmP8ECnJjsMqY7F1Q=;
 b=A3HhD7/molMkXSxHHuVkwr9BBVeR5l41JDHfYBsD/LrTmw/hvO6SPja58frbzk9cMObIqiPZKNFzgua13pBQOBIzET4D7/FuxnMID/nlozfLMcHlZYd2c3ImHohnt1FZ0VROxNRqD7T1n1NfXhk8bzP3rSti59DNS0pCFR+Nw66hZ/p2IKrMwcCI3MN4BsjQYpcM3jLeunsRNBs84U551kxCC1aFYnsHJILe2mDGo3nOS7/kAs2y/PT2LDF+bmjYcJvjWi7t68o/I7njFPc3PiyX+v0R92DwuiEC313scR+s+XrYlruDUySzELTkq+cnivOcPxRXVDzmrTaSNEkUyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lr46Mw5/T9qeoTdB+t6kSwwpXjLmP8ECnJjsMqY7F1Q=;
 b=f6eSu8Uus/NMn+kTPrkPrCO07rQ+GtCOg1H8dJxtVkQBDfZt9q3Pbt9GRugyju7MncaiESoG1ppiCnQqNT9liwD51SOIe+ybZl12QNKhP+07zgdKQVgYAzhXdYpJ6Sb3gqHs3hM2GzaVVksKrveY53lhVzVnNCjrnvFvKz7kgXw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 MW6PR12MB8960.namprd12.prod.outlook.com (2603:10b6:303:23e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 09:52:42 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::756a:e835:b8a5:16d5]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::756a:e835:b8a5:16d5%6]) with mapi id 15.20.6319.033; Thu, 27 Apr 2023
 09:52:42 +0000
Message-ID: <4eed40a7-d927-1b0c-b19b-9bb5b3083b73@amd.com>
Date:   Thu, 27 Apr 2023 11:52:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
Content-Language: en-US
To:     Pavan Kondeti <quic_pkondeti@quicinc.com>,
        David Dai <davidai@google.com>,
        Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        kernel-team@android.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20230330224348.1006691-1-davidai@google.com>
 <20230427074602.GA325349@hu-pkondeti-hyd.qualcomm.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20230427074602.GA325349@hu-pkondeti-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::8) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|MW6PR12MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bb3085c-b111-4d64-4571-08db470524a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ec1nxNtoiczVVs4b4txHaZ4qpnHATeA6cFsyJDCoX8ullKhmLLEE++9PiOowPmmtXB1zZTIltYMiap/oGDKfLbGr70ncOW5yxsT3aPZvByqpA1zwkStexvLerSmFgi/TJzo8FRpdvkoxvx7fDT1FE3aK7LUilQw33CTLzXNCw1u8TNEwcZ3bLgEEJjwuHUwOlkkenpgby2eGmfvLVEFUyLDYv0UENpX8Aeg2L0qpeNossSPQ/xJ2np4MplMCR8kYeOrFI2d34n/5q97nH+wQQ5vOzgOXRz07raOxVbMPS/oIOyThnRuFuy92tVQuKhFiMm/fQZhyoYUkP1egQP2WL7hQwUjyvTiq5Pol4jqC91O7PzlBwEcQtG+FS613rEuFfn1E4a8e46lbvCCRKSnfK0rRr2dPBK/72RjCgkYzJwCWCfqlHyyarjR+G0c19czcLqSqiRHw+5YLzNZ/tGshY34MpSnGoI3rMaIy3eiiGqdYqQdSra6M1enNNLtiNRJfhzuOVvDzvg/4n4iA6EleEk0CKhlnzPB4cj0/Z5UzwGK2jAIi+cbFC2fH+Mc4AzCtxcn13yGSKboCaxSSEOXv+eyzWJQpAevQ/WCq8tqUwI2r2R8qIUK36J8zzTfVdTXp7/IDizrFYgSO0wlUkQ4FrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199021)(6506007)(6512007)(26005)(186003)(478600001)(54906003)(110136005)(7416002)(5660300002)(8676002)(6666004)(6486002)(8936002)(36756003)(2906002)(41300700001)(4326008)(38100700002)(31696002)(86362001)(66476007)(316002)(66946007)(66556008)(7406005)(2616005)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QllEUnVFdjVEZXc4SzhWenlld3Y5S2hkNWpCRWg2T2VYcXhQNGNCSVpwZ2pq?=
 =?utf-8?B?UHdnajE0cXdBaVJpZmFPVzh1KzdIMm5UTm11R05UK2I0b1lzQzhMWmU2b3BG?=
 =?utf-8?B?dUF4SVcxbHpYOUZXQVhFRkRiVEFEUk5razVCdTdSV1FYcXM3aEJWMGdHSXNq?=
 =?utf-8?B?aEV6TXRyYUl4LzlEUnZ4MG9lMUF1SlpYQXc5VGhtTGxmdVU2cXlzTU5uQlFu?=
 =?utf-8?B?ZStPOVBUNW9VS1g5SmkrYmRNWTlpemhnQkVOM3JNc3ovNllwelpSOVVDV05h?=
 =?utf-8?B?cXp0UGFJak5JMHhYWTBOZXYxc0dnREFaeUI4eWtSaW5kakVnNWVWVWRMRTJH?=
 =?utf-8?B?bzhjVGRiRnV0RW5peENBNFVTMllFWkNxSzlveGNBdGhGNXY2bHNsVUYvUzFW?=
 =?utf-8?B?RG1OQi91WEtzZE9ZL0l0dXdLQk1qOHV6RGpGUFVQdEh2S3BjQVM3dDYyUlVW?=
 =?utf-8?B?SmdON3J5bkp1T2ZYQkh2WjVXc3FxNUNFMVN0cStCMjRmSnhydFVINzRZWnFF?=
 =?utf-8?B?WTVyb0RhV2FhakIvcFRlczRXcXJLVHBZbzRJRGNPbmd0eTJtRzFSZVl4SGcx?=
 =?utf-8?B?NlFjeU8rS1ZvK2ZJdkRJU1lFQW9MUE8zNzdBTnhHc3dxK05nZDBucDFBbzNQ?=
 =?utf-8?B?b1Vybm1JcTYzVFkvV3pUOHJxYkl1MmFkV01HNnVoZFNWaWJRNWVLbk9pZFF3?=
 =?utf-8?B?cEZteDhadWpnQ0t1UlVtUW1Vb1BPbFpnRmxXRXR4akhlaDdlcmZuWXFzNmJ3?=
 =?utf-8?B?VHduLzFLeTMyZkp0cFhCYkFEbUI3NW4veUc2RHdad29GcUk5S3JaNnVCQkd4?=
 =?utf-8?B?cnVucUJaUEZ2OC83YjI4RWVkSFlUVnVrenRHZzMrVlFMR21ndzY5S3loaUw5?=
 =?utf-8?B?bE00cFZlbG9XbURBTUUrRkExdS9IN1BYU0RIUmR4Wi9Dc3UycDBnMWZ4SUNO?=
 =?utf-8?B?dC80VGNEbGJsT1U0azU2cnZMMWF2c25zV1VybGtJY2JhT2REUWV6RE96SHB6?=
 =?utf-8?B?ODZIRW1zWWVHVVNKQ1VVSW95Zk4zVHdZbzFraC9ja3Z4L3NEUFNwRUNYa0Ix?=
 =?utf-8?B?ODNER0RBMi9RUXdKMFBJMkN4bU1ZcUNUKyttenZyWktWTmhvYTM3aWY2cjM0?=
 =?utf-8?B?cjZ5YmJjMU9vNUJrcUtQNGhqemNBdGc0ZE9OU0hETHNJWlNnZlRFMk9NMm1x?=
 =?utf-8?B?RnNzdEZtRmJiTU1qekhOQW9nYVpOOVVHVlMrSmhIWUN3UWJPZ2dDVGFTa3U3?=
 =?utf-8?B?Zm9INGM1Y2lxRE5wdFZZVXJQRmhKWEFMMlZxYktMTzhvaktWL01kbXFCcGZs?=
 =?utf-8?B?dklKSmNLMkxQeWRSc0hXdkE3QitmVDcxcE5Ra3JNYm1kaXltMWJ0dkN1UHhK?=
 =?utf-8?B?QnRQTnhYK3VhYWtVWitsbjNkTXdsVjU2TFg0Vm1ta3NBb0NROHUwWjNrU1JS?=
 =?utf-8?B?Y0dvTEwyTU05dVI1OFd6WHBSTlJTdGp5TDJzZVJQSFdsb2pSK0lQbnJNbDN0?=
 =?utf-8?B?dGJKRkQwQm1YZGNOWXFZSHJYMjJVdnp1RERxTTh4ZzBMdkRoQkVlZzJpODcy?=
 =?utf-8?B?dHh4WXY3NGlUeDFXdFllVzVFWXBMZnBGaFByMXB3b2NWMlFaQXVnd0lyYnkr?=
 =?utf-8?B?bnV5UHQwRDZtTUFXdktxVmYwYm9ZVW1UdThhTnNaVExDV0lKeW9LTDY1WDBR?=
 =?utf-8?B?VVovd002VnhHQUdTclQxV2hFZy9tOUNhZWJsM0VuSFRsSEhadXNLeUp0aXRG?=
 =?utf-8?B?ZXVwRmtLR2M5Z0FOdmJOcHRURWluZDFWUHVCT2tkQmNNYVhPUlBFdjBnd013?=
 =?utf-8?B?NDM3blhjRVloK29JUW1wdUFFRzlJTWdhMnV4OVZtdmhyNERtOFhvdDZjb0l0?=
 =?utf-8?B?Y3hYbTNwanZ4b3JITDI0eU93T2FUZ3R3WWVsb09xRFRTZVF5enQwbkU2MGNi?=
 =?utf-8?B?VVVuN0V0UlRmYi95ZnhweHRVN1Y0NDU0SGg4S2U3VDB2bGNWVGxsS3NBRnNl?=
 =?utf-8?B?dFRTV3hMY3dsMmNnTnliandaVHV3UDYxb1FucXVmSjhQSDRTVXBCUDE2MHZs?=
 =?utf-8?B?QnlXR3YveGdlaXpPTm9wcFRUSnUwVFNUZGpHdFhDaGg1S0N5YkFMenBoRkNC?=
 =?utf-8?Q?dyFUyDC2GIHEv1+JAb7rXe7wQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb3085c-b111-4d64-4571-08db470524a0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 09:52:42.1386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxKd7lr55O/WWLyhWtvCO2F3EA5j62msjoW48rcpJD5ApaqY0DJP+2lA1rlU/ER6i0xt5TxOddxp7WWI/xfkOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8960
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>> This patch series is a continuation of the talk Saravana gave at LPC 2022
>> titled "CPUfreq/sched and VM guest workload problems" [1][2][3]. The gist
>> of the talk is that workloads running in a guest VM get terrible task
>> placement and DVFS behavior when compared to running the same workload in
>> the host. Effectively, no EAS for threads inside VMs. This would make power
>> and performance terrible just by running the workload in a VM even if we
>> assume there is zero virtualization overhead.
>>
>> We have been iterating over different options for communicating between
>> guest and host, ways of applying the information coming from the
>> guest/host, etc to figure out the best performance and power improvements
>> we could get.
>>
>> The patch series in its current state is NOT meant for landing in the
>> upstream kernel. We are sending this patch series to share the current
>> progress and data we have so far. The patch series is meant to be easy to
>> cherry-pick and test on various devices to see what performance and power
>> benefits this might give for others.
>>
>> With this series, a workload running in a VM gets the same task placement
>> and DVFS treatment as it would when running in the host.
>>
>> As expected, we see significant performance improvement and better
>> performance/power ratio. If anyone else wants to try this out for your VM
>> workloads and report findings, that'd be very much appreciated.
>>
>> The idea is to improve VM CPUfreq/sched behavior by:
>> - Having guest kernel to do accurate load tracking by taking host CPU
>>    arch/type and frequency into account.
>> - Sharing vCPU run queue utilization information with the host so that the
>>    host can do proper frequency scaling and task placement on the host side.
>>
> 
> [...]
> 
>>
>> Next steps:
>> ===========
>> We are continuing to look into communication mechanisms other than
>> hypercalls that are just as/more efficient and avoid switching into the VMM
>> userspace. Any inputs in this regard are greatly appreciated.
>>
> 
> I am trying to understand why virtio based cpufrq does not work here?
> The VMM on host can process requests from guest VM like freq table,
> current frequency and setting the min_freq. I believe Virtio backend
> has mechanisms for acceleration (vhost) so that user space is not
> involved for every frequency request from the guest.
> 
> It has advantages of (1) Hypervisor agnostic (virtio basically)
> (2) scheduler does not need additional input, the aggregated min_freq
> requests from all guest should be sufficient.

Also want to add, 3) virtio based solution would definitely be better 
from performance POV as would avoid expense vmexits which we have with 
hypercalls.

Thanks,
Pankaj


