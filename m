Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D3613F993
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 20:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732701AbgAPTcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 14:32:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:35906 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729010AbgAPTcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 14:32:45 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 11:32:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,327,1574150400"; 
   d="scan'208";a="243400331"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 16 Jan 2020 11:32:44 -0800
Date:   Thu, 16 Jan 2020 11:32:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
Subject: Re: [Bug 206215] New: QEMU guest crash due to random 'general
 protection fault' since kernel 5.2.5 on i7-3517UE
Message-ID: <20200116193244.GA21633@linux.intel.com>
References: <bug-206215-28872@https.bugzilla.kernel.org/>
 <20200115215256.GE30449@linux.intel.com>
 <e6ec4418-4ac1-e619-7402-18c085bc340d@djy.llc>
 <20200116153854.GA20561@linux.intel.com>
 <e2045e6f-f069-c396-c080-cb85919bda0e@djy.llc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2045e6f-f069-c396-c080-cb85919bda0e@djy.llc>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 02:21:25PM -0500, Derek Yerger wrote:
>  <IRQ>
>  gcmaes_crypt_by_sg.constprop.12+0x26e/0x660
>  ? 0xffffffffc024547d
>  ? __qdisc_run+0x83/0x510
>  ? __dev_queue_xmit+0x45e/0x990
>  ? ip_finish_output2+0x1a8/0x570
>  ? fib4_rule_action+0x61/0x70
>  ? fib4_rule_action+0x70/0x70
>  ? fib_rules_lookup+0x13f/0x1c0
>  ? helper_rfc4106_decrypt+0x82/0xa0
>  ? crypto_aead_decrypt+0x40/0x70
>  ? crypto_aead_decrypt+0x40/0x70
>  ? crypto_aead_decrypt+0x40/0x70
>  ? esp_output_tail+0x8f4/0xa5a [esp4]
>  ? skb_ext_add+0xd3/0x170
>  ? xfrm_input+0x7a6/0x12c0
>  ? xfrm4_rcv_encap+0xae/0xd0
>  ? xfrm4_transport_finish+0x200/0x200
>  ? udp_queue_rcv_one_skb+0x1ba/0x460
>  ? udp_unicast_rcv_skb.isra.63+0x72/0x90
>  ? __udp4_lib_rcv+0x51b/0xb00
>  ? ip_protocol_deliver_rcu+0xd2/0x1c0
>  ? ip_local_deliver_finish+0x44/0x50
>  ? ip_local_deliver+0xe0/0xf0
>  ? ip_protocol_deliver_rcu+0x1c0/0x1c0
>  ? ip_rcv+0xbc/0xd0
>  ? ip_rcv_finish_core.isra.19+0x380/0x380
>  ? __netif_receive_skb_one_core+0x7e/0x90
>  ? netif_receive_skb_internal+0x3d/0xb0
>  ? napi_gro_receive+0xed/0x150
>  ? 0xffffffffc0243c77
>  ? net_rx_action+0x149/0x3b0
>  ? __do_softirq+0xe4/0x2f8

Bingo!  Thanks Derek!

>  ? handle_irq_event_percpu+0x6a/0x80
>  ? irq_exit+0xe6/0xf0
>  ? do_IRQ+0x7f/0xd0
>  ? common_interrupt+0xf/0xf
>  </IRQ>
>  ? irq_entries_start+0x20/0x660
>  ? vmx_get_interrupt_shadow+0x2f0/0x710 [kvm_intel]
>  ? kvm_set_msr_common+0xfc7/0x2380 [kvm]
>  ? recalibrate_cpu_khz+0x10/0x10
>  ? ktime_get+0x3a/0xa0
>  ? kvm_arch_vcpu_ioctl_run+0x107/0x560 [kvm]
>  ? kvm_init+0x6bf/0xd00 [kvm]
>  ? __seccomp_filter+0x7a/0x680
>  ? do_vfs_ioctl+0xa4/0x630
>  ? security_file_ioctl+0x32/0x50
>  ? ksys_ioctl+0x60/0x90
>  ? __x64_sys_ioctl+0x16/0x20
>  ? do_syscall_64+0x5f/0x1a0
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ---[ end trace 9564a1ccad733a90 ]---
> WARNING: CPU: 2 PID: 9296 at arch/x86/kvm/x86.c:8060
> kvm_set_msr_common+0x2230/0x2380 [kvm]
> Modules linked in: vhost_net(E) vhost(E) macvtap(E) macvlan(E) tap(E)
> esp4(E) xt_CHECKSUM(E) xt_MASQUERADE(E) tun(E) bridge(E) stp(E) llc(E)
> ip6t_rpfilter(E) nf_log_ipv6(E) ip6t_REJECT(E) nf_reject_ipv6>
>  mei_hdcp(E) kvm(E) intel_cstate(E) intel_uncore(E) intel_rapl_perf(E)
> eeepc_wmi(E) asus_wmi(E) sparse_keymap(E) rfkill(E) snd_hda_codec_generic(E)
> pcspkr(E) wmi_bmof(E) ledtrig_audio(E) i2c_i801(E) snd>
> CPU: 2 PID: 9296 Comm: CPU 1/KVM Tainted: P        W  OE     5.3.11+ #16
> Hardware name: System manufacturer System Product Name/Z170-K, BIOS 3805 05/16/2018
> RIP: 0010:kvm_set_msr_common+0x2230/0x2380 [kvm]
> Code: b0 26 00 00 e8 91 9f b5 ce 66 90 bf 06 00 00 00 48 8b b3 88 26 00 00
> e8 7e 9f b5 ce 66 90 83 a3 60 26 00 00 fb e9 e9 ec ff ff <0f> 0b e9 d2 ec ff
> ff f0 80 4b 31 10 e9 32 ee ff ff 48 8b 83 98 02
> RSP: 0018:ffffb42e03d17d30 EFLAGS: 00010002
> RAX: 0000000080004b20 RBX: ffff98f1783abf40 RCX: ffff98f17757f000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffb42e03d17db0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff98f1783abf70
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff98f1d8bc6c00
> FS:  00007f02faffd700(0000) GS:ffff98f286a80000(0000) knlGS:000000f0dd174000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000001f8249cd000 CR3: 000000043d3dc003 CR4: 00000000003626e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  ? recalibrate_cpu_khz+0x10/0x10
>  ? ktime_get+0x3a/0xa0
>  kvm_arch_vcpu_ioctl_run+0x107/0x560 [kvm]
>  kvm_init+0x6bf/0xd00 [kvm]
>  ? __seccomp_filter+0x7a/0x680
>  do_vfs_ioctl+0xa4/0x630
>  ? security_file_ioctl+0x32/0x50
>  ksys_ioctl+0x60/0x90
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x5f/0x1a0
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7f0302457d4b
> Code: 0f 1e fa 48 8b 05 3d b1 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff
> ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff
> 73 01 c3 48 8b 0d 0d b1 0c 00 f7 d8 64 89 01 48
> RSP: 002b:00007f02faffc6c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f03005fd001 RCX: 00007f0302457d4b
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000020
> RBP: 0000000000000001 R08: 0000564efe32fa50 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000564efe3129c0
> R13: 0000000000000000 R14: 00007f03005fc000 R15: 0000564f00123300
> ---[ end trace 9564a1ccad733a91 ]---
> 
