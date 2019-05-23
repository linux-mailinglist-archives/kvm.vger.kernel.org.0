Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A0527756
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 09:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfEWHlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 03:41:19 -0400
Received: from 3.mo7.mail-out.ovh.net ([46.105.34.113]:37128 "EHLO
        3.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfEWHlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 03:41:18 -0400
Received: from player696.ha.ovh.net (unknown [10.108.35.185])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id A666511DF07
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 09:41:14 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player696.ha.ovh.net (Postfix) with ESMTPSA id 2363D626FFDE;
        Thu, 23 May 2019 07:41:11 +0000 (UTC)
Subject: Re: [PATCH 0/4] KVM: PPC: Book3S: Fix potential deadlocks
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20190523063424.GB19655@blackberry>
 <3d159268-3645-bbf0-8f99-306c9ca68611@ozlabs.ru>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <e8e76c2d-6555-4939-9d2b-5e514422b4cb@kaod.org>
Date:   Thu, 23 May 2019 09:41:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3d159268-3645-bbf0-8f99-306c9ca68611@ozlabs.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5663839483700874199
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddufedguddviecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/19 9:21 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 23/05/2019 16:34, Paul Mackerras wrote:
>> Recent reports of lockdep splats in the HV KVM code revealed that it
>> was taking the kvm->lock mutex in several contexts where a vcpu mutex
>> was already held.  Lockdep has only started warning since I added code
>> to take the vcpu mutexes in the XIVE device release functions, but
>> since Documentation/virtual/kvm/locking.txt specifies that the vcpu
>> mutexes nest inside kvm->lock, it seems that the new code is correct
>> and it is most of the old uses of kvm->lock that are wrong.
>>
>> This series should fix the problems, by adding new mutexes that nest
>> inside the vcpu mutexes and using them instead of kvm->lock.
> 
> 
> I applied these 4, compiled, installed, rebooted, tried running a guest
> (which failed because I also updated QEMU and its cli has changed), got
> this. So VM was created and then destroyed without executing a single
> instruction, if that matters.


kvm->lock is still held when  kvmppc_rtas_tokens_free() is called
but kvm->arch.rtas_token_lock isn't.

May be we should change the lockdep annotation to what is was
before ? 

C. 


> 
> 
> systemd-journald[1278]: Successfully sent stream file descriptor to
> service manager.
> systemd-journald[1278]: Successfully sent stream file descriptor to
> service manager.
> WARNING: CPU: 3 PID: 7697 at arch/powerpc/kvm/book3s_rtas.c:285
> kvmppc_rtas_tokens_free+0x100/0x108
> [kvm]
> 
> Modules linked in: bridge stp llc kvm_hv kvm rpcrdma ib_iser ib_srp
> rdma_ucm ib_umad sunrpc rdma_cm
> ib_ipoib iw_cm libiscsi ib_cm scsi_transport_iscsi mlx5_ib ib_uverbs
> ib_core vmx_crypto crct10dif_vp
> msum crct10dif_common at24 sg xfs libcrc32c crc32c_vpmsum mlx5_core
> mlxfw autofs4
> CPU: 3 PID: 7697 Comm: qemu-kvm Not tainted
> 5.2.0-rc1-le_nv2_aikATfstn1-p1 #496
> NIP:  c00800000f3ab678 LR: c00800000f3ab66c CTR: c000000000198210
> 
> REGS: c000003fdf873680 TRAP: 0700   Not tainted
> (5.2.0-rc1-le_nv2_aikATfstn1-p1)
> MSR:  900000000282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
> 24008882  XER: 20040000
> CFAR: c000000000198364 IRQMASK: 0
> 
> GPR00: c00800000f3ab66c c000003fdf873910 c00800000f3d8f00
> 0000000000000000
> GPR04: c000003f4c984630 0000000000000000 00000000d5952dee
> 0000000000000000
> GPR08: 0000000000000000 0000000000000000 0000000000000000
> c00800000f3b95c0
> GPR12: c000000000198210 c000003fffffbb80 00007ffff20d57a8
> 0000000000000000
> GPR16: 0000000000000000 0000000000000008 0000000119dcd0c0
> 0000000000000001
> GPR20: c000003f4c98f530 c000003f4c980098 c000003f4c984188
> 0000000000000000
> GPR24: c000003f4c98a740 0000000000000000 c000003fdf8dd200
> c00800000f3d1c18
> GPR28: c000003f4c98a858 c000003f4c980000 c000003f4c9840c8
> c000003f4c980000
> NIP [c00800000f3ab678] kvmppc_rtas_tokens_free+0x100/0x108 [kvm]
> 
> LR [c00800000f3ab66c] kvmppc_rtas_tokens_free+0xf4/0x108 [kvm]
> 
> Call Trace:
> 
> [c000003fdf873910] [c00800000f3ab66c] kvmppc_rtas_tokens_free+0xf4/0x108
> [kvm] (unreliable)
> [c000003fdf873960] [c00800000f3aa640] kvmppc_core_destroy_vm+0x48/0xa8
> [kvm]
> [c000003fdf873990] [c00800000f3a4b08] kvm_arch_destroy_vm+0x130/0x190
> [kvm]
> [c000003fdf8739d0] [c00800000f3985dc] kvm_put_kvm+0x204/0x500 [kvm]
> 
> [c000003fdf873a60] [c00800000f398910] kvm_vm_release+0x38/0x60 [kvm]
> 
> [c000003fdf873a90] [c0000000004345fc] __fput+0xcc/0x2f0
> 
> [c000003fdf873af0] [c000000000139318] task_work_run+0x108/0x150
> 
> [c000003fdf873b30] [c000000000109408] do_exit+0x438/0xe10
> 
> [c000003fdf873c00] [c000000000109eb0] do_group_exit+0x60/0xe0
> 
> [c000003fdf873c40] [c00000000011ea24] get_signal+0x1b4/0xce0
> 
> [c000003fdf873d30] [c000000000025ea8] do_notify_resume+0x1a8/0x430
> 
> [c000003fdf873e20] [c00000000000e444] ret_from_except_lite+0x70/0x74
> 
> Instruction dump:
> 
> ebc1fff0 ebe1fff8 7c0803a6 4e800020 60000000 60000000 3880ffff 38634630
> 
> 4800df59 e8410018 2fa30000 409eff44 <0fe00000> 4bffff3c 7c0802a6
> 60000000
> irq event stamp: 114938
> 
> hardirqs last  enabled at (114937): [<c0000000003ab8f4>]
> free_unref_page+0xd4/0x100
> hardirqs last disabled at (114938): [<c000000000009060>]
> program_check_common+0x170/0x180
> softirqs last  enabled at (114424): [<c000000000a06bdc>]
> peernet2id+0x6c/0xb0
> softirqs last disabled at (114422): [<c000000000a06bb4>]
> peernet2id+0x44/0xb0
> ---[ end trace c33c9599a1a73dd2 ]---
> 
> systemd-journald[1278]: Compressed data object 650 -> 280 using XZ
> 
> tun: Universal TUN/TAP device driver, 1.6
> 
> virbr0: port 1(virbr0-nic) entered blocking state
> 
> 
> 
> 
> 

