Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD9177565C
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjHIJ25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 05:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjHIJ24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 05:28:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2096.outbound.protection.outlook.com [40.107.243.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB0F1FD5;
        Wed,  9 Aug 2023 02:28:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtND0K5/D06xRynqtUUFQ/wDwey9/K5G/e411fHJ9vncJNKKg9In5o+J+CFz3X4SWoRVFA/7QipJAvMxlXr01KlKcyjKo1tFTcMs69VksVV7ISbA58OalqpRb5hN961elwaJ3KtmAfhh8pPFRyuuBLRQBpr+DQqar8L/UqdADlVHWcwmQ8RKUH6fekT0CxJ2R5S8DTdrlucCClCzVSMAsLQ7lrxIv8NTjs1ZLwIumgGGloQmZ4TRwxdkSbaXibmvSZWf9hMcAmQTUytuiDw0qpb+4jrACbt0mmgWKNKF/DNQF4coh+jCwXQ1FH2QVaO/RS2K6AlELnDYYeq1nQ1t6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xstrkwb/Ifij46XYmcuAnIRLFegZWM4kNw14vvCfRDQ=;
 b=Fddsf/FNf5VrkQ4mOAExwq2xyMVxUOhCmCfc9V5SmXAQCuFpV2/MMkTN/FDrhgbK6o4ylYA9FAJCv39TZHZTlLXPIMZPHBfUUpM8U1O4LeRmmViLWLrLluEwQBQ6lUNVntRUdrQNQ9oY0MQNiXFKMSVS/5AgJVuHHPjukYNgi8J7ap0Lhk8x9ikzEtZsZEKFgRxvEnGLby7KqOIP4+FtOWJTjhh/gU0BTAfrIxKRH/vfI/9qrx2p54pWkJ+fF5YfgCnEiDVKnqs3ggfPo1s9nH71Plms8/b1idEIfrbku55S+ap59guSOIXcckg20j65NaYLTSl0tCW8zq4wQCwsgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xstrkwb/Ifij46XYmcuAnIRLFegZWM4kNw14vvCfRDQ=;
 b=4nvhG9rFx9t718WWWFyskL7sPvGJ9pqMyVlQPvfu6IYkPT0J58ZCH5e9CFUk6SSKFsBy2+dU9+MJPcTVxhrSKsXMlAy2mo7u/jqmclUohS9n/ogVqTDdua83mTlcBwpE6XOkCKXpvA88v2BIPcVW4B4Xsd5DPwEMj+gSgyNmi7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 SA0PR01MB6377.prod.exchangelabs.com (2603:10b6:806:d9::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.27; Wed, 9 Aug 2023 09:28:50 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 09:28:49 +0000
Message-ID: <0df9d4fe-b3d7-7612-a9b0-925fb5ba7077@amperemail.onmicrosoft.com>
Date:   Wed, 9 Aug 2023 17:28:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] perf/core: fix the bug in the event multiplexing
To:     Marc Zyngier <maz@kernel.org>,
        Huang Shijie <shijie@os.amperecomputing.com>
Cc:     oliver.upton@linux.dev, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
        peterz@infradead.org, ingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, namhyung@kernel.org, irogers@google.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, patches@amperecomputing.com,
        zwang@amperecomputing.com
References: <20230809013953.7692-1-shijie@os.amperecomputing.com>
 <864jl8ha8y.wl-maz@kernel.org>
From:   Shijie Huang <shijie@amperemail.onmicrosoft.com>
In-Reply-To: <864jl8ha8y.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P221CA0039.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::21) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|SA0PR01MB6377:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d892df4-3729-4814-e608-08db98bb09dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8qTt3TS+gKPvAC91iPSh34FW1BM76JW9o7JolsVEykiTZ7OydjnyL3CkrAJIAtKMIORaeUjrZBzsqqAiOkyXcLxoV0pO2wk6qb/Rz6jGaqhGYaQpxv/nMY9+UwF2ViJPHeJNG9kTve0is9PxPzRlKtNT8qc81Qqe0HPb5q2XdpVLVIs7Nma6vTcpIyWK/RcIxnhgRYP3rNDkpkAcqQDkiUM/gsCwuLqeoKLZxBCDmSmM2D4YBJEKJJhegbBQk2/77AIEZp69BM/S6GRq2Z19jWgt6IH5Nuh6zNjtVU6tFovNXoqrUk8yJmXCtpPUFk8whXaHzbC2o9JA36wcybEZKgY3L8Uft922euLy6MFm+WeJYV6yzrVwpt7h11jvHy+ZFHc03kHDvsOAjbCo0blpKKTk/slaCvKW9LLHzKjEFPcyqVju4a84VvKNWINkBpodOX6oV5E3bPtlfyvcRZniM2uLS6d3sldfL6szKXD12LR/3T3rBWrl75DL88RGtoO9W1jfHkyqKW0KvE3krOF1JlzX6GAy7VmRz0CyNIcCoDS0oms+sTZmdDHuHrUUa9FzRI5/KzgqO9iBWE5mvOemVCAF4Ja4sNqwqP+PRMqESIVj7o6m9JkmtCNgZN42N7sLzNQrZQMmm04YnwDq7J1gLUMiW26DfySaBSBhJHt4FzXtQyUABSnjOegPMwiWSm+S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39850400004)(346002)(396003)(376002)(186006)(451199021)(1800799006)(31686004)(2906002)(6512007)(4326008)(316002)(52116002)(110136005)(6486002)(6666004)(478600001)(2616005)(83170400001)(26005)(38100700002)(38350700002)(83380400001)(6506007)(66946007)(107886003)(66556008)(66476007)(5660300002)(8936002)(8676002)(7416002)(31696002)(41300700001)(42882007)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGF0a2Fsb1ZoUUdFazhsanEvQnQ0TkRYWVM5QSs5S0dPVERoNG83Y0ErTS9o?=
 =?utf-8?B?RXM0TStJd1BsUFpSYVJCRlI1YnRyZmpYWkdNcHQ4b2MvWHY1T2lQVUlVWmZa?=
 =?utf-8?B?UnF5NkJ1RzhHS05rcVhjZThZWG1WenRKSFBYNGhRQy9rcy9uek9UN0FPblJU?=
 =?utf-8?B?RURKMEYyQzRyS2MyQktZUkVuUDh6djVrOEc3R2VHVEQ2cy9mZmx5ZVkxbXor?=
 =?utf-8?B?Tks2Ni91dzZFaFNMMGRrVEhjaEZkL0x3WGdubk95YUdlRVhTMy95ZUhjcHRi?=
 =?utf-8?B?M3Z4TXFqdG1FU25kRkIxcStvckRXM0ZUWWttaFJpd0xRb3NMZ0haMWViZDJ1?=
 =?utf-8?B?am5HQXpJSjMwZTNlbGRDUlFHaC81WDhZQlNTVVF1RTN4OVVxUlhmY2RJZHlr?=
 =?utf-8?B?ekJTb2RWZElRbFpUL1FmdHR2dG1xaFRnZTdmd3RhY2xiYjdHSEtSdU1KNTcr?=
 =?utf-8?B?T2ZONU92amJORlBqNkFhUDZKVjh3Szd5MTh5OFJhL1hRc2NlM0NVQ1RqRkxM?=
 =?utf-8?B?bXJzYlVWSDRFQmYxcjVUcWMxZnM3VUtBTFFaQUtIdFEwd040djdYNjVFc0hE?=
 =?utf-8?B?UUpyNzlCbHNwU2gzTWR0VWJkYjJ4dWlaMExURmNuejBtQkhsd0xBanhwelVG?=
 =?utf-8?B?SDF6MVk2YXBiNkVIalJJQUdXM3ZmMWFMUXp2TitqekUvZjBWMldDcDh3VFVi?=
 =?utf-8?B?YmloeGRYVWRCdlFESk5RVDd3dzE5SFVCUFlPbXhSVldQbm9yMUFPbHEvelpq?=
 =?utf-8?B?RVFKUEVpMjRQVmJyc2NWclRtMHRrRUFHUlJpMTNaZWkwZUs4QXFPakJ5TUkx?=
 =?utf-8?B?WGpYdURwZ2F5OUhFYzA4Uzd0b2VpREw2dU1SUUZmWFQ1NEZ2QWlqZGFvemR3?=
 =?utf-8?B?ZS9RQm55cjlnS005dnBMc01JNFZEbWt4cEh1T29uRkF4Skt4Vm55YmJralEz?=
 =?utf-8?B?UHAydy9aMmtFdnBtWkw1dGJnMi9lOWRVS3RVSHEzelE1Y0ZjaWFIRTArZW9E?=
 =?utf-8?B?ODhJMi9HK0l3amQySkdGcFBxVnZ3d0ZNWXFVdERzbmxyQ3Q2NEhNaVNTN2ll?=
 =?utf-8?B?dmwyTFVKOGlkVXJJOEljejFiZmhXRlh1eXdQTVBveUpWenRmZ1VCYytnYVlQ?=
 =?utf-8?B?WStkRHo3NDExRjE1dC8vUGNsZjlwSmxKWW1GTVk0dnVsTnk2OGpTemRkdU12?=
 =?utf-8?B?eXNMTncyL0pvbFV3d21mbW1FL201QVQzM01HbGoybGRvbTJmWHNCdDJmdmpE?=
 =?utf-8?B?N1E1VEdLaUJhZGh2OVpXNk1TQyt2SER4aEx3Nm1NUDYwOGRpUVNPK2JsVmJH?=
 =?utf-8?B?VGFrWG1jc1VTU1hUWmpnUmNMYmdlbTE1UGJpVzhPWUhIMjFzdkxTV0NPM0xi?=
 =?utf-8?B?d05yMEFsbW94QVB3Z21HRE5Td0R2b3RCSzBZQTk3cDd0am5xRitrSENwUUVL?=
 =?utf-8?B?ZDBJK0xjTFlnWDZYMlQ3L1dnNWR0V2E0Qk5XMnRpZzNlbThTcVdOZ0Qvais5?=
 =?utf-8?B?eG4rUm9veU1SSjlGM1R4WWtLVUpkVS9RTVBPb2xPcTBtaEFqVWFGeHJ5Y1k2?=
 =?utf-8?B?eDl5NGJyekJ5ZEMwWmY0SUIyU1ZwS2QvY004aDlndFdwZlk5S2htNjZaUWJo?=
 =?utf-8?B?TnBUWkVVY0w2dG1zSTJmeU5aeGMvbEdWN1gyNEs4dkk1alF6NkltZkFNVkVU?=
 =?utf-8?B?Q3FtL2N1YWlzWVRjTXZOWmNXUkRRSFRiZHhmeWxjQkhLN0xrd2Fsek1EQmwy?=
 =?utf-8?B?OEU4UjhFYVBFckVPZHpMMEtZTmpDY2NjN1lBMkczYU5PUWpIZ0xQR2lkdWNZ?=
 =?utf-8?B?dmVhMW9FRDZhbTZpR0dDQzFFcFVkYnhtUEdaYW0ybFFWY211K3ZMM09hSkpq?=
 =?utf-8?B?ZzZqZk04enZBd2pJbVl5cnI1OHNyU3dIWmo1ZjVFb08yanI0OU1zZTdPRVYz?=
 =?utf-8?B?M1RGSDRJd1ZDWHpackhoWHBzays3V2NkeWlseXdmaEJSOHRxR3NFcGpnaE5w?=
 =?utf-8?B?NlB6K1dQRURNYUpFVTRPR0V4cEMxOHRUbmpQdVpuMnJmWUd1R3NENlZEcE5i?=
 =?utf-8?B?cVErbENXMEY4WVVwTHlUVEx3SGx3RFc0VmMrWHNjYVBPcEtLejlFWncxckFv?=
 =?utf-8?B?QzZjd2puWWthWXRsWEtjS0NtZjk2YkVReVBLZEFueldCd0tXZThBa0pEaTFm?=
 =?utf-8?Q?MH6LLYb+ABHQx5aVpZq6BGM=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d892df4-3729-4814-e608-08db98bb09dd
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 09:28:49.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewnSSbQMQwkAhK8x5PDkEp0cTl6AI07x3OwcdDFD2cnmfk2zeqnJAbvD71aAcJsmEIINJfC/eAy/UMwSADHFQ0rTYj3PYtAqDaNnGQukZn3wOhmlK3ftWcADh4ZIJThn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6377
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

在 2023/8/9 16:48, Marc Zyngier 写道:
> On Wed, 09 Aug 2023 02:39:53 +0100,
> Huang Shijie <shijie@os.amperecomputing.com> wrote:
>
> For a start, please provide a sensible subject line for your patch.
> "fix the bug" is not exactly descriptive, and I'd argue that if there
> was only one bug left, I'd have taken an early retirement by now.
okay, I will change the subject in the future.
>> 1.) Background.
>>     1.1) In arm64, run a virtual guest with Qemu, and bind the guest
> Is that with QEMU in system emulation mode? Or QEMU as a VMM for KVM?
Run the Qemu as a VMM for KVM.
>
>>          to core 33 and run program "a" in guest.
> Is core 33 significant? Is the program itself significant?

It is not a significant one, just chosed by random.

The program is just used for testing the perf, not a significant one.

>>          The code of "a" shows below:
>>     	----------------------------------------------------------
>> 		#include <stdio.h>
>>
>> 		int main()
>> 		{
>> 			unsigned long i = 0;
>>
>> 			for (;;) {
>> 				i++;
>> 			}
>>
>> 			printf("i:%ld\n", i);
>> 			return 0;
>> 		}
>>     	----------------------------------------------------------
>>
>>     1.2) Use the following perf command in host:
>>        #perf stat -e cycles:G,cycles:H -C 33 -I 1000 sleep 1
>>            #           time             counts unit events
>>                 1.000817400      3,299,471,572      cycles:G
>>                 1.000817400          3,240,586      cycles:H
>>
>>         This result is correct, my cpu's frequency is 3.3G.
>>
>>     1.3) Use the following perf command in host:
>>        #perf stat -e cycles:G,cycles:H -C 33 -d -d  -I 1000 sleep 1
>>              time             counts unit events
>>       1.000831480        153,634,097      cycles:G                                                                (70.03%)
>>       1.000831480      3,147,940,599      cycles:H                                                                (70.03%)
>>       1.000831480      1,143,598,527      L1-dcache-loads                                                         (70.03%)
>>       1.000831480              9,986      L1-dcache-load-misses            #    0.00% of all L1-dcache accesses   (70.03%)
>>       1.000831480    <not supported>      LLC-loads
>>       1.000831480    <not supported>      LLC-load-misses
>>       1.000831480        580,887,696      L1-icache-loads                                                         (70.03%)
>>       1.000831480             77,855      L1-icache-load-misses            #    0.01% of all L1-icache accesses   (70.03%)
>>       1.000831480      6,112,224,612      dTLB-loads                                                              (70.03%)
>>       1.000831480             16,222      dTLB-load-misses                 #    0.00% of all dTLB cache accesses  (69.94%)
>>       1.000831480        590,015,996      iTLB-loads                                                              (59.95%)
>>       1.000831480                505      iTLB-load-misses                 #    0.00% of all iTLB cache accesses  (59.95%)
>>
>>         This result is wrong. The "cycle:G" should be nearly 3.3G.
>>
>> 2.) Root cause.
>> 	There is only 7 counters in my arm64 platform:
>> 	  (one cycle counter) + (6 normal counters)
>>
>> 	In 1.3 above, we will use 10 event counters.
>> 	Since we only have 7 counters, the perf core will trigger
>>         	event multiplexing in hrtimer:
>> 	     merge_sched_in() -->perf_mux_hrtimer_restart() -->
>> 	     perf_rotate_context().
>>
>>         In the perf_rotate_context(), it does not restore some PMU registers
>>         as context_switch() does.  In context_switch():
>>               kvm_sched_in()  --> kvm_vcpu_pmu_restore_guest()
>>               kvm_sched_out() --> kvm_vcpu_pmu_restore_host()
>>
>>         So we got wrong result.
>>
>> 3.) About this patch.
>>          3.1) Add arch_perf_rotate_pmu_set()
>>          3.2) Add is_guest().
>> 	     Check the context for hrtimer.
>> 	3.3) In arm64's arch_perf_rotate_pmu_set(),
>>         	     set the PMU registers by the context.
>>
>> 4.) Test result of this patch:
>>        #perf stat -e cycles:G,cycles:H -C 33 -d -d  -I 1000 sleep 1
>>              time             counts unit events
>>       1.000817360      3,297,898,244      cycles:G                                                                (70.03%)
>>       1.000817360          2,719,941      cycles:H                                                                (70.03%)
>>       1.000817360            883,764      L1-dcache-loads                                                         (70.03%)
>>       1.000817360             17,517      L1-dcache-load-misses            #    1.98% of all L1-dcache accesses   (70.03%)
>>       1.000817360    <not supported>      LLC-loads
>>       1.000817360    <not supported>      LLC-load-misses
>>       1.000817360          1,033,816      L1-icache-loads                                                         (70.03%)
>>       1.000817360            103,839      L1-icache-load-misses            #   10.04% of all L1-icache accesses   (70.03%)
>>       1.000817360            982,401      dTLB-loads                                                              (70.03%)
>>       1.000817360             28,272      dTLB-load-misses                 #    2.88% of all dTLB cache accesses  (69.94%)
>>       1.000817360            972,072      iTLB-loads                                                              (59.95%)
>>       1.000817360                772      iTLB-load-misses                 #    0.08% of all iTLB cache accesses  (59.95%)
>>
>>      The result is correct. The "cycle:G" is nearly 3.3G now.
>>
>> Signed-off-by: Huang Shijie <shijie@os.amperecomputing.com>
>> ---
>>   arch/arm64/kvm/pmu.c     | 8 ++++++++
>>   include/linux/kvm_host.h | 1 +
>>   kernel/events/core.c     | 5 +++++
>>   virt/kvm/kvm_main.c      | 9 +++++++++
>>   4 files changed, 23 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
>> index 121f1a14c829..a6815c3f0c4e 100644
>> --- a/arch/arm64/kvm/pmu.c
>> +++ b/arch/arm64/kvm/pmu.c
>> @@ -210,6 +210,14 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
>>   	kvm_vcpu_pmu_disable_el0(events_guest);
>>   }
>>   
>> +void arch_perf_rotate_pmu_set(void)
>> +{
>> +	if (is_guest())
>> +		kvm_vcpu_pmu_restore_guest(NULL);
>> +	else
>> +		kvm_vcpu_pmu_restore_host(NULL);
>> +}
> So we're now randomly poking at the counters even when no guest is
> running, based on whatever is stashed in internal KVM data structures?
> I'm sure this is going to work really well.
>
> Hint: even if these functions don't directly look at the vcpu pointer,
> passing NULL is a really bad idea. It is a sure sign that you don't
> have the context on which to perform the action you're trying to do.
>
> This really shouldn't do *anything* when the rotation process is not
> preempting a guest.
Thanks for explanation, I will try Oliver's second method to resolve 
this issue.
>> +
>>   /*
>>    * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on the pCPU
>>    * where PMUSERENR_EL0 for the guest is loaded, since PMUSERENR_EL0 is switched
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 9d3ac7720da9..e350cbc8190f 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -931,6 +931,7 @@ void kvm_destroy_vcpus(struct kvm *kvm);
>>   
>>   void vcpu_load(struct kvm_vcpu *vcpu);
>>   void vcpu_put(struct kvm_vcpu *vcpu);
>> +bool is_guest(void);
> Why do we need this (not to mention the poor choice of name)? We
> already have kvm_get_running_vcpu(), which does everything you need
> (and gives you the actual context).
yes.
>>   
>>   #ifdef __KVM_HAVE_IOAPIC
>>   void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm);
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 6fd9272eec6e..fe78f9d17eba 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -4229,6 +4229,10 @@ ctx_event_to_rotate(struct perf_event_pmu_context *pmu_ctx)
>>   	return event;
>>   }
>>   
>> +void __weak arch_perf_rotate_pmu_set(void)
>> +{
>> +}
>> +
>>   static bool perf_rotate_context(struct perf_cpu_pmu_context *cpc)
>>   {
>>   	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>> @@ -4282,6 +4286,7 @@ static bool perf_rotate_context(struct perf_cpu_pmu_context *cpc)
>>   	if (task_event || (task_epc && cpu_event))
>>   		__pmu_ctx_sched_in(task_epc->ctx, pmu);
>>   
>> +	arch_perf_rotate_pmu_set();
> KVM already supports hooking into the perf core using the
> perf_guest_info_callbacks structure. Why should we need a separate
> mechanism?
okay, I will check it too.
>
>>   	perf_pmu_enable(pmu);
>>   	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>>   
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index dfbaafbe3a00..a77d336552be 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -218,6 +218,15 @@ void vcpu_load(struct kvm_vcpu *vcpu)
>>   }
>>   EXPORT_SYMBOL_GPL(vcpu_load);
>>   
>> +/* Do we in the guest? */
>> +bool is_guest(void)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	vcpu = __this_cpu_read(kvm_running_vcpu);
>> +	return !!vcpu;
>> +}
>> +
>>   void vcpu_put(struct kvm_vcpu *vcpu)
>>   {
>>   	preempt_disable();
> It looks like you've identified an actual issue. However, I'm highly
> sceptical of the implementation. This really needs some more work.


Thanks again.

Huang Shijie

