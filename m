Return-Path: <kvm+bounces-6077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C3282AEE4
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 13:43:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B94091C22BFB
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 12:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8CDE15AF2;
	Thu, 11 Jan 2024 12:43:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4AE12E6E;
	Thu, 11 Jan 2024 12:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 4A9F544E2E;
	Thu, 11 Jan 2024 13:43:16 +0100 (CET)
Message-ID: <2c73db3f-2465-49e1-9d57-ef8d978849b6@proxmox.com>
Date: Thu, 11 Jan 2024 13:43:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Temporary KVM guest hangs connected to KSM and NUMA balancer
Content-Language: en-US
From: Friedrich Weber <f.weber@proxmox.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <832697b9-3652-422d-a019-8c0574a188ac@proxmox.com>
In-Reply-To: <832697b9-3652-422d-a019-8c0574a188ac@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 04/01/2024 14:42, Friedrich Weber wrote:
> f47e5bbb ("KVM: x86/mmu: Zap only TDP MMU leafs in zap range and
> mmu_notifier unmap")

As this commit mentions tdp_mmu_zap_leafs, I ran the reproducer again on
610a9b8f (6.7-rc8) while tracing >500ms calls to that function (printing
a stacktrace) and task_numa_work via a bpftrace script [1].

Again, there are several invocations of task_numa_work that take >500ms
(the VM appears to be frozen during that time). For instance, one
invocation that takes ~20 seconds:

[1704971602] task_numa_work (tid=52035) took 19995 ms

For this particular thread and in the 20 seconds before that, there were
8 invocations of tdp_mmu_zap_leafs with >500ms:

[1704971584] tdp_mmu_zap_leafs (tid=52035) took 2291 ms
[1704971586] tdp_mmu_zap_leafs (tid=52035) took 2343 ms
[1704971589] tdp_mmu_zap_leafs (tid=52035) took 2316 ms
[1704971590] tdp_mmu_zap_leafs (tid=52035) took 1663 ms
[1704971591] tdp_mmu_zap_leafs (tid=52035) took 682 ms
[1704971594] tdp_mmu_zap_leafs (tid=52035) took 2706 ms
[1704971597] tdp_mmu_zap_leafs (tid=52035) took 3132 ms
[1704971602] tdp_mmu_zap_leafs (tid=52035) took 4846 ms

They roughly sum up to 20s. The stacktrace is the same for all:

bpf_prog_5ca52691cb9e9fbd_tdp_mmu_zap_lea+345
bpf_prog_5ca52691cb9e9fbd_tdp_mmu_zap_lea+345
bpf_trampoline_380104735946+208
tdp_mmu_zap_leafs+5
kvm_unmap_gfn_range+347
kvm_mmu_notifier_invalidate_range_start+394
__mmu_notifier_invalidate_range_start+156
change_protection+3908
change_prot_numa+105
task_numa_work+1029
bpf_trampoline_6442457341+117
task_numa_work+9
xfer_to_guest_mode_handle_work+261
kvm_arch_vcpu_ioctl_run+1553
kvm_vcpu_ioctl+667
__x64_sys_ioctl+164
do_syscall_64+96
entry_SYSCALL_64_after_hwframe+110

AFAICT this pattern repeats several times. I uploaded the last 150kb of
the bpftrace output to [2]. I can provide the full output if needed.

To me, not knowing much about the KVM/KSM/NUMA balancer interplay, this
looks like task_numa_work triggers several invocations of
tdp_mmu_zap_leafs, each of which takes an unusually long time. If anyone
has a hunch why this might happen, or an idea where to look next, it
would be much appreciated.

Best,

Friedrich

[1]

kfunc:tdp_mmu_zap_leafs { @start_zap[tid] = nsecs; }
kretfunc:tdp_mmu_zap_leafs /@start_zap[tid]/ {
	$diff = nsecs - @start_zap[tid];
	if ($diff > 500000000) { // 500ms
		time("[%s] ");
		printf("tdp_mmu_zap_leafs (tid=%d) took %d ms\n", tid, $diff / 1000000);
		print(kstack());
	}
	delete(@start_zap[tid]);
}

kfunc:task_numa_work { @start_numa[tid] = nsecs; }
kretfunc:task_numa_work /@start_numa[tid]/ {
	$diff = nsecs - @start_numa[tid];
	if ($diff > 500000000) { // 500ms
		time("[%s] ");
		printf("task_numa_work (tid=%d) took %d ms\n", tid, $diff / 1000000);
	}
	delete(@start_numa[tid]);
}

[2] https://paste.debian.net/1303767/


