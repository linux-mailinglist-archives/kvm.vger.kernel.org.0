Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2BF69D6F8
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 00:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjBTXYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 18:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBTXYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 18:24:01 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2074.outbound.protection.outlook.com [40.107.100.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6382B47F;
        Mon, 20 Feb 2023 15:23:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+G96lIL3DhQy+27kiDfboZ8pLVM/I3m94gL7/4qqI1d280MTUF5jPfdzjHeszA+VlkbhT26ut59IHiYvjiD0i2lC+Rhdx8/ergcX61iHvR/EEWB4qhOuuvnRx1/Ybzdy6ygP2ZCnsKlGtP+DphEIfJfRfKL1wcKcwam9knpgmYDFgtLdS664UtJ1PwmxBOk5CGB0VyTdVW4hXDVQZ35BmwSdhmTMZegMwf1UQNIVTirkndPYfb+BAHN4vatO1I/Cev67UVjeXl/0thsaf3QLAS+yiRKQuiqyzFKh/hDqg+MnEuj1ACg20k6CCdMkzWDrm1njltXUW7XMUkpElbf5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxr3nyzcP1bX75HGQinFQokmHrydguHXlvkFFw+eLXo=;
 b=flYShLTMhvQYXnqcc6tTl7URY3sfyFo9hJAZRQVxJOe5Oha/LG9x9DocviwHODxo/zQZ8sZlLVQK1/nd7xQJ9b1SdCSbjVFIkxujwmJB5I8GaMic8kRiM3iryNfg5c4OzdBsRtAoHXfRKStAWzOoWl8yldCg4ERa9cpsXF4hW4KTTCew4RAy6qB8ZTfb43VeRMk59WOvPicKp/q0EFVL6UMKPXdTO2ZoXtncFZ43N0f4gZ2GaEAfMn4ErMMN5lcMRGQvdbBndHe9Fgk3fTG1ZCdMHE6Mf8dxAHhgwGAXJmoiBqYSyKwf2Z0YQFRt8e3yDuIlxGNXPhFiq6LdrBvVEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxr3nyzcP1bX75HGQinFQokmHrydguHXlvkFFw+eLXo=;
 b=aP3Lp5sPco6c2cNdO6BFBRmyWnOSkPc+yfuM9Xx9gCz8gx6MAVzCWf0sm/6+iqeyGTpqldCxFHw40kENMQY6Nclm8gPPxDynsfokl4xAHq+mo2SNXLAZSgj6OH8JmcFhC5ZkL6foXuyWlcTgQuqk6sxFNoe/0HsqLbkhm8SbLCI=
Received: from BN9PR03CA0353.namprd03.prod.outlook.com (2603:10b6:408:f6::28)
 by DS7PR12MB6189.namprd12.prod.outlook.com (2603:10b6:8:9a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 23:23:55 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::b0) by BN9PR03CA0353.outlook.office365.com
 (2603:10b6:408:f6::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 23:23:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 23:23:54 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 17:23:51 -0600
Message-ID: <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
Date:   Mon, 20 Feb 2023 17:23:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
CC:     <tglx@linutronix.de>, Usama Arif <usama.arif@bytedance.com>,
        <arjan@linux.intel.com>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>, <x86@kernel.org>,
        <pbonzini@redhat.com>, <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <rcu@vger.kernel.org>, <mimoja@mimoja.de>,
        <hewenliang4@huawei.com>, <thomas.lendacky@amd.com>,
        <seanjc@google.com>, <pmenzel@molgen.mpg.de>,
        <fam.zheng@bytedance.com>, <punit.agrawal@bytedance.com>,
        <simon.evans@bytedance.com>, <liangma@liangbit.com>,
        Piotr Gorski <lucjan.lucjanov@gmail.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT056:EE_|DS7PR12MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: b9c6d8ed-125c-47cb-24b9-08db139988c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HndAmj/k3aU1a0Qt+IVXGXKv0xowG7OlQZ7eeMDIwJHapRdn+BzOzGPe6agdyiti8OXz1e4xH5j0qXPvTh65/KzbV5sU07odH8AWOPuA9Qnxg1jm+sXZVbPFySehUZhLw3Yeeoz52PYqUtoyYNXJcr6opKi4Lw1e/0x/5lKH1LtdFvKCnOr2G9/Tk5B1+q0i2C/IcfSiIV8o8vwRsYQaafW+F7fX5/fMJLuJ9hpe9JmGBeleIyxDRWIxr8JaINctcsFLYdKxLhNM77wz2yPIr1XTUU47lpi8o8tx7tiuydd+e/ghu7TIBMkJllcoVAZGO2GOT4SHPsd/iq/hrzOcqEUXjUY0Ub6TQpXKBHA3z1c6N+JlFAezFKruv/lJGr5gnJKBUoQvEguLzpmz0Es8ajqaImHqAN2Ai1PcvA+jV5OPTPTELZnmTSIJ87DLkv9GyRko2j0q69uedxPApCojsCwSSs69JEvftCVFyDrP4wm7cMOyA3Fs+9H7IcMIqO8qSbp7lMfTsZHGaORsh4QFdhDU0VXykk/2bG4zf+lweX5C8c30dHg/389gxdlH9FNGHBysU5kgLrS56tZFCtArevc4Hej4GRxT4MxxlcTDLw530kBhEirkC+c5ID0oTj0Stc9tQjRZaVFIzf5RSjoDvMkfTo2obm0iPHguAq7Az+F8ATT9gPzq0CNBuIflJIn4Q5MWCKHPS9ohDsF68WX6PRamIAmCUQnA719gmIp+hMv/cRUAZY/mNTh3UbE/U53LCo1uM0h+ETu5Qajv+tMjGw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(31686004)(40480700001)(36756003)(44832011)(356005)(82310400005)(7416002)(8936002)(86362001)(82740400003)(31696002)(5660300002)(316002)(16576012)(4326008)(54906003)(53546011)(83380400001)(2906002)(8676002)(70586007)(70206006)(81166007)(45080400002)(40460700003)(16526019)(186003)(478600001)(26005)(41300700001)(36860700001)(66574015)(47076005)(110136005)(2616005)(426003)(336012)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 23:23:54.7806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c6d8ed-125c-47cb-24b9-08db139988c0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6189
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 3:39 PM, David Woodhouse wrote:
> On 20 February 2023 21:23:38 GMT, Oleksandr Natalenko <oleksandr@natalenko.name> wrote:
>> Hello.
>>
>> On 20.02.2023 21:31, David Woodhouse wrote:
>>> On Mon, 2023-02-20 at 17:40 +0100, Oleksandr Natalenko wrote:
>>>> On pondělí 20. února 2023 17:20:13 CET David Woodhouse wrote:
>>>>> On Mon, 2023-02-20 at 17:08 +0100, Oleksandr Natalenko wrote:
>>>>>>
>>>>>> I've applied this to the v6.2 kernel, and suspend/resume broke on
>>>>>> my
>>>>>> Ryzen 5950X desktop. The machine suspends just fine, but on
>>>>>> resume
>>>>>> the screen stays blank, and there's no visible disk I/O.
>>>>>>
>>>>>> Reverting the series brings suspend/resume back to working state.
>>>>>
>>>>> Hm, thanks. What if you add 'no_parallel_bringup' on the command
>>>>> line?
>>>>
>>>> If the `no_parallel_bringup` param is added, the suspend/resume
>>>> works.
>>>
>>> Thanks for the testing. Can I ask you to do one further test: apply the
>>> series only as far as patch 6/8 'x86/smpboot: Support parallel startup
>>> of secondary CPUs'.
>>>
>>> That will do the new startup asm sequence where each CPU finds its own
>>> per-cpu data so it *could* work in parallel, but doesn't actually do
>>> the bringup in parallel yet.
>>
>> With patches 1 to 6 (including) applied and no extra cmdline params added the resume doesn't work.
> 
> Hm. Kim, is there some weirdness with the way AMD CPUs get their APIC ID in CPUID 0x1? Especially after resume?

Not to my knowledge.  Mario?

> Perhaps we turn it off for any AMD CPU that doesn't have X2APIC and CPUID 0xB?

Perhaps.

>>> Does your box have a proper serial port?
>>
>> No, sorry. I know it'd help with getting logs, and I do have a serial-to-USB cable that I use for another machine, but in this one the port is not routed to outside. I think I can put a header there as the motherboard does have pins, but I'd have to buy one first. In theory, I can do that, but that won't happen within the next few weeks.
>>
>> P.S. Piotr Gorski (in Cc) also reported this: "My friend from CachyOS can confirm bugs with smpboot patches. AMD FX 6300 only shows 1 core when using smp boot patchset". Probably, he can reply to this thread and provide more details.
>>

I ran mem/disk versions of 'sudo rtcwake --mode mem -s 60'
on my Rome server, and multiple suspend/resumes succeeded, and
with all CPUs, but then the NETDEV WATCHDOG fired - not sure
if it's related:

...
[ 2751.335882] smpboot: Booting Node 1 Processor 127 APIC 0x7f
[ 2751.340124] ACPI: \_SB_.C07F: Found 2 idle states
[ 2751.392591] CPU127 is up
[ 2751.455650] nvme nvme0: 7/0/0 default/read/poll queues
[ 2751.466112] e1000e 0000:41:00.0 enp65s0: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[ 2751.635573] PM: Cannot find swap device, try swapon -a
[ 2751.641315] PM: Cannot get swap writer
[ 2751.926594] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 2751.928527] ata7.00: supports DRM functions and may not be fully accessible
[ 2751.933208] ata7.00: supports DRM functions and may not be fully accessible
[ 2751.937797] ata7.00: configured for UDMA/133
[ 2751.948170] ata7.00: Enabling discard_zeroes_data
[ 2762.428397] PM: hibernation: Basic memory bitmaps freed
[ 2762.429004] OOM killer enabled.
[ 2762.429008] Restarting tasks ... done.
[ 2762.433155] PM: hibernation: hibernation exit
[ 2762.447318] systemd-journald[1387]: Sent WATCHDOG=1 notification.
[ 2830.013372] systemd-journald[1387]: Sent WATCHDOG=1 notification.
[ 2919.099718] systemd-journald[1387]: Sent WATCHDOG=1 notification.
[ 2992.729927] ------------[ cut here ]------------
[ 2992.729965] NETDEV WATCHDOG: enp65s0 (e1000e): transmit queue 0 timed out
[ 2992.730012] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:525 dev_watchdog+0x234/0x250
[ 2992.730032] Modules linked in: intel_rapl_msr intel_rapl_common amd64_edac edac_mce_amd rapl ipmi_si wmi_bmof binfmt_misc kvm_amd kvm nls_iso8859_1 joydev input_leds k10temp mac_hid sch_fq_codel dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua ipmi_devintf ipmi_msghandler msr ramoops reed_solomon efi_pstore ip_tables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 multipath linear ast i2c_algo_bit drm_shmem_helper drm_kms_helper syscopyarea sysfillrect crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3 aesni_intel crypto_simd cryptd hid_generic sysimgblt nvme usbhid ahci drm libahci hid nvme_core i2c_piix4 wmi
[ 2992.730711] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.2.0-rc8+ #20
[ 2992.730720] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS RXM1007C 11/08/2021
[ 2992.730727] RIP: 0010:dev_watchdog+0x234/0x250
[ 2992.730732] Code: 00 e9 12 ff ff ff 4c 89 e7 c6 05 6f d5 42 01 01 e8 c1 55 f8 ff 44 89 f1 4c 89 e6 48 c7 c7 28 ff 88 b1 48 89 c2 e8 85 fc 1c 00 <0f> 0b e9 22 ff ff ff 0f 1f 44 00 00 e9 0b ff ff ff 66 66 2e 0f 1f
[ 2992.730740] RSP: 0018:ffffbf6100003e30 EFLAGS: 00010286
[ 2992.730754] RAX: 0000000000000000 RBX: ffff9a8606da8550 RCX: 0000000000000000
[ 2992.730764] RDX: 0000000000000103 RSI: ffffffffb1741bcc RDI: 00000000ffffffff
[ 2992.730770] RBP: ffffbf6100003e50 R08: 0000000000000000 R09: 00000000ffefffff
[ 2992.730775] R10: ffffbf6100003ca8 R11: ffff9b038d9fd668 R12: ffff9a8606da8000
[ 2992.730780] R13: ffff9a8606da8460 R14: 0000000000000000 R15: ffff9ac346fe2480
[ 2992.730787] FS:  0000000000000000(0000) GS:ffff9ac346e00000(0000) knlGS:0000000000000000
[ 2992.730788] systemd-journald[1387]: Compressed data object 717 -> 433 using ZSTD
[ 2992.730797] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2992.730804] CR2: 00007f4c419a0890 CR3: 0008004e47412003 CR4: 0000000000770ef0
[ 2992.730812] PKRU: 55555554
[ 2992.730819] Call Trace:
[ 2992.730826]  <IRQ>
[ 2992.730840]  ? __pfx_dev_watchdog+0x10/0x10
[ 2992.730852]  call_timer_fn+0xac/0x250
[ 2992.730868]  ? __pfx_dev_watchdog+0x10/0x10
[ 2992.730876]  __run_timers+0x22d/0x2e0
[ 2992.730884]  ? seqcount_lockdep_reader_access.constprop.0+0x45/0x60
[ 2992.730893]  ? ktime_get+0x28/0xc0
[ 2992.730903]  ? __pfx_read_tsc+0x10/0x10
[ 2992.730915]  ? ktime_get+0x56/0xc0
[ 2992.730922]  ? sched_clock+0xd/0x20
[ 2992.730930]  ? sched_clock_cpu+0x14/0xd0
[ 2992.730941]  run_timer_softirq+0x33/0x60
[ 2992.730947]  __do_softirq+0x12f/0x380
[ 2992.730960]  __irq_exit_rcu+0xaf/0x120
[ 2992.730970]  irq_exit_rcu+0x12/0x20
[ 2992.730976]  sysvec_apic_timer_interrupt+0xb4/0xd0
[ 2992.730984]  </IRQ>
[ 2992.730989]  <TASK>
[ 2992.730993]  asm_sysvec_apic_timer_interrupt+0x1f/0x30
[ 2992.731004] RIP: 0010:cpuidle_enter_state+0x12d/0x4d0
[ 2992.731015] Code: 00 31 ff e8 e5 c0 45 ff 80 7d d7 00 74 16 9c 58 0f 1f 40 00 f6 c4 02 0f 85 7b 03 00 00 31 ff e8 99 de 4d ff fb 0f 1f 44 00 00 <45> 85 ff 0f 88 d1 01 00 00 49 63 d7 4c 89 f1 48 2b 4d c8 48 8d 04
[ 2992.731018] RSP: 0018:ffffffffb1a03dd8 EFLAGS: 00000246
[ 2992.731024] RAX: ffff9ac346e00000 RBX: ffff9ac4ec3ce400 RCX: 000000000000001f
[ 2992.731027] RDX: 0000000000000000 RSI: ffffffffb1741bcc RDI: ffffffffb17470fa
[ 2992.731035] RBP: ffffffffb1a03e10 R08: 000002b8cc9a617d R09: 000002b8c7e0b83a
[ 2992.731041] R10: 000000000002bc82 R11: ffff9ac346ff2d44 R12: 0000000000000002
[ 2992.731048] R13: ffffffffb1f60bc0 R14: 000002b8cc9a617d R15: 0000000000000002
[ 2992.731059]  ? cpuidle_enter_state+0x10b/0x4d0
[ 2992.731067]  cpuidle_enter+0x32/0x50
[ 2992.731072]  call_cpuidle+0x23/0x50
[ 2992.731080]  do_idle+0x1dc/0x250
[ 2992.731090]  cpu_startup_entry+0x24/0x30
[ 2992.731096]  rest_init+0x108/0x110
[ 2992.731101]  arch_call_rest_init+0x12/0x35
[ 2992.731114]  start_kernel+0x6f3/0x71d
[ 2992.731120]  x86_64_start_reservations+0x28/0x2e
[ 2992.731127]  x86_64_start_kernel+0x80/0x8a
[ 2992.731133]  secondary_startup_64_no_verify+0x186/0x18b
[ 2992.731151]  </TASK>
[ 2992.731158] ---[ end trace 0000000000000000 ]---
[ 2992.731371] e1000e 0000:41:00.0 enp65s0: Reset adapter unexpectedly
[ 2992.870854] systemd-journald[1387]: Successfully sent stream file descriptor to service manager.
[ 2996.338900] e1000e 0000:41:00.0 enp65s0: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx

Thanks,

Kim
