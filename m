Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44FA913F8EF
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 20:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437821AbgAPTVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 14:21:39 -0500
Received: from mta-08-3.privateemail.com ([198.54.127.61]:7658 "EHLO
        MTA-08-3.privateemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437794AbgAPTV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 14:21:28 -0500
X-Greylist: delayed 65573 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jan 2020 14:21:27 EST
Received: from MTA-08.privateemail.com (localhost [127.0.0.1])
        by MTA-08.privateemail.com (Postfix) with ESMTP id 554C160046;
        Thu, 16 Jan 2020 14:21:26 -0500 (EST)
Received: from zetta.local (unknown [10.20.151.212])
        by MTA-08.privateemail.com (Postfix) with ESMTPA id DEA1B6004A;
        Thu, 16 Jan 2020 19:21:25 +0000 (UTC)
Subject: Re: [Bug 206215] New: QEMU guest crash due to random 'general
 protection fault' since kernel 5.2.5 on i7-3517UE
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
References: <bug-206215-28872@https.bugzilla.kernel.org/>
 <20200115215256.GE30449@linux.intel.com>
 <e6ec4418-4ac1-e619-7402-18c085bc340d@djy.llc>
 <20200116153854.GA20561@linux.intel.com>
From:   Derek Yerger <derek@djy.llc>
Message-ID: <e2045e6f-f069-c396-c080-cb85919bda0e@djy.llc>
Date:   Thu, 16 Jan 2020 14:21:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200116153854.GA20561@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/16/20 10:38 AM, Sean Christopherson wrote:
> On Wed, Jan 15, 2020 at 08:08:32PM -0500, Derek Yerger wrote:
>> On 1/15/20 4:52 PM, Sean Christopherson wrote:
>>> +cc Derek, who is hitting the same thing.
>>>
>>> On Wed, Jan 15, 2020 at 09:18:56PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=206215
>>> *snip*
>>> that's a big smoking gun pointing at commit ca7e6b286333 ("KVM: X86: Fix
>>> fpu state crash in kvm guest"), which is commit e751732486eb upstream.
>>>
>>> 1. Can you verify reverting ca7e6b286333 (or e751732486eb in upstream)
>>>     solves the issue?
>>>
>>> 2. Assuming the answer is yes, on a buggy kernel, can you run with the
>>>     attached patch to try get debug info?
>> I did these out of order since I had 5.3.11 built with the patch, ready to
>> go for weeks now, waiting for an opportunity to test.
>>
>> Win10 guest immediately BSOD'ed with:
>>
>> WARNING: CPU: 2 PID: 9296 at include/linux/thread_info.h:55
>> kernel_fpu_begin+0x6b/0xc0
> Can you provide the full stack trace of the WARN?  I'm hoping that will
> provide a hint as to what's going wrong.
WARNING: CPU: 2 PID: 9296 at include/linux/thread_info.h:55 
kernel_fpu_begin+0x6b/0xc0
Modules linked in: vhost_net(E) vhost(E) macvtap(E) macvlan(E) tap(E) esp4(E) 
xt_CHECKSUM(E) xt_MASQUERADE(E) tun(E) bridge(E) stp(E) llc(E) ip6t_rpfilter(E) 
nf_log_ipv6(E) ip6t_REJECT(E) nf_reject_ipv6>
  mei_hdcp(E) kvm(E) intel_cstate(E) intel_uncore(E) intel_rapl_perf(E) 
eeepc_wmi(E) asus_wmi(E) sparse_keymap(E) rfkill(E) snd_hda_codec_generic(E) 
pcspkr(E) wmi_bmof(E) ledtrig_audio(E) i2c_i801(E) snd>
CPU: 2 PID: 9296 Comm: CPU 1/KVM Tainted: P           OE     5.3.11+ #16
Hardware name: System manufacturer System Product Name/Z170-K, BIOS 3805 05/16/2018
RIP: 0010:kernel_fpu_begin+0x6b/0xc0
Code: f6 40 26 20 75 08 48 8b 10 80 e6 40 74 16 65 48 c7 05 b5 27 fe 70 00 00 00 
00 c3 65 8a 05 a5 27 fe 70 eb c4 80 78 0c 00 74 02 <0f> 0b 48 83 c0 01 f0 80 08 
40 65 48 8b 0c 25 c0 6b 01 00 0f 1f 44
RSP: 0018:ffffb42e0014c7f8 EFLAGS: 00010202
RAX: ffff98f1783a1ec0 RBX: 0000000000000038 RCX: 0000000000000048
RDX: 0000000000000020 RSI: ffff98f1d9a5cb00 RDI: ffff98f1d9a5cb00
RBP: ffffb42e0014caa0 R08: ffffb42e0014cab0 R09: ffffb42e0014c860
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000002ba
R13: ffffb42e0014c860 R14: ffff98f1d36882aa R15: ffff98f1d9a5caa8
FS:  00007f02faffd700(0000) GS:ffff98f286a80000(0000) knlGS:000000f0dd174000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000001f8249cd000 CR3: 000000043d3dc003 CR4: 00000000003626e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <IRQ>
  gcmaes_crypt_by_sg.constprop.12+0x26e/0x660
  ? 0xffffffffc024547d
  ? __qdisc_run+0x83/0x510
  ? __dev_queue_xmit+0x45e/0x990
  ? ip_finish_output2+0x1a8/0x570
  ? fib4_rule_action+0x61/0x70
  ? fib4_rule_action+0x70/0x70
  ? fib_rules_lookup+0x13f/0x1c0
  ? helper_rfc4106_decrypt+0x82/0xa0
  ? crypto_aead_decrypt+0x40/0x70
  ? crypto_aead_decrypt+0x40/0x70
  ? crypto_aead_decrypt+0x40/0x70
  ? esp_output_tail+0x8f4/0xa5a [esp4]
  ? skb_ext_add+0xd3/0x170
  ? xfrm_input+0x7a6/0x12c0
  ? xfrm4_rcv_encap+0xae/0xd0
  ? xfrm4_transport_finish+0x200/0x200
  ? udp_queue_rcv_one_skb+0x1ba/0x460
  ? udp_unicast_rcv_skb.isra.63+0x72/0x90
  ? __udp4_lib_rcv+0x51b/0xb00
  ? ip_protocol_deliver_rcu+0xd2/0x1c0
  ? ip_local_deliver_finish+0x44/0x50
  ? ip_local_deliver+0xe0/0xf0
  ? ip_protocol_deliver_rcu+0x1c0/0x1c0
  ? ip_rcv+0xbc/0xd0
  ? ip_rcv_finish_core.isra.19+0x380/0x380
  ? __netif_receive_skb_one_core+0x7e/0x90
  ? netif_receive_skb_internal+0x3d/0xb0
  ? napi_gro_receive+0xed/0x150
  ? 0xffffffffc0243c77
  ? net_rx_action+0x149/0x3b0
  ? __do_softirq+0xe4/0x2f8
  ? handle_irq_event_percpu+0x6a/0x80
  ? irq_exit+0xe6/0xf0
  ? do_IRQ+0x7f/0xd0
  ? common_interrupt+0xf/0xf
  </IRQ>
  ? irq_entries_start+0x20/0x660
  ? vmx_get_interrupt_shadow+0x2f0/0x710 [kvm_intel]
  ? kvm_set_msr_common+0xfc7/0x2380 [kvm]
  ? recalibrate_cpu_khz+0x10/0x10
  ? ktime_get+0x3a/0xa0
  ? kvm_arch_vcpu_ioctl_run+0x107/0x560 [kvm]
  ? kvm_init+0x6bf/0xd00 [kvm]
  ? __seccomp_filter+0x7a/0x680
  ? do_vfs_ioctl+0xa4/0x630
  ? security_file_ioctl+0x32/0x50
  ? ksys_ioctl+0x60/0x90
  ? __x64_sys_ioctl+0x16/0x20
  ? do_syscall_64+0x5f/0x1a0
  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
---[ end trace 9564a1ccad733a90 ]---
WARNING: CPU: 2 PID: 9296 at arch/x86/kvm/x86.c:8060 
kvm_set_msr_common+0x2230/0x2380 [kvm]
Modules linked in: vhost_net(E) vhost(E) macvtap(E) macvlan(E) tap(E) esp4(E) 
xt_CHECKSUM(E) xt_MASQUERADE(E) tun(E) bridge(E) stp(E) llc(E) ip6t_rpfilter(E) 
nf_log_ipv6(E) ip6t_REJECT(E) nf_reject_ipv6>
  mei_hdcp(E) kvm(E) intel_cstate(E) intel_uncore(E) intel_rapl_perf(E) 
eeepc_wmi(E) asus_wmi(E) sparse_keymap(E) rfkill(E) snd_hda_codec_generic(E) 
pcspkr(E) wmi_bmof(E) ledtrig_audio(E) i2c_i801(E) snd>
CPU: 2 PID: 9296 Comm: CPU 1/KVM Tainted: P        W  OE     5.3.11+ #16
Hardware name: System manufacturer System Product Name/Z170-K, BIOS 3805 05/16/2018
RIP: 0010:kvm_set_msr_common+0x2230/0x2380 [kvm]
Code: b0 26 00 00 e8 91 9f b5 ce 66 90 bf 06 00 00 00 48 8b b3 88 26 00 00 e8 7e 
9f b5 ce 66 90 83 a3 60 26 00 00 fb e9 e9 ec ff ff <0f> 0b e9 d2 ec ff ff f0 80 
4b 31 10 e9 32 ee ff ff 48 8b 83 98 02
RSP: 0018:ffffb42e03d17d30 EFLAGS: 00010002
RAX: 0000000080004b20 RBX: ffff98f1783abf40 RCX: ffff98f17757f000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffb42e03d17db0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff98f1783abf70
R13: 0000000000000000 R14: 0000000000000000 R15: ffff98f1d8bc6c00
FS:  00007f02faffd700(0000) GS:ffff98f286a80000(0000) knlGS:000000f0dd174000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000001f8249cd000 CR3: 000000043d3dc003 CR4: 00000000003626e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ? recalibrate_cpu_khz+0x10/0x10
  ? ktime_get+0x3a/0xa0
  kvm_arch_vcpu_ioctl_run+0x107/0x560 [kvm]
  kvm_init+0x6bf/0xd00 [kvm]
  ? __seccomp_filter+0x7a/0x680
  do_vfs_ioctl+0xa4/0x630
  ? security_file_ioctl+0x32/0x50
  ksys_ioctl+0x60/0x90
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x5f/0x1a0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f0302457d4b
Code: 0f 1e fa 48 8b 05 3d b1 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 
66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 
48 8b 0d 0d b1 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007f02faffc6c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f03005fd001 RCX: 00007f0302457d4b
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000020
RBP: 0000000000000001 R08: 0000564efe32fa50 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000564efe3129c0
R13: 0000000000000000 R14: 00007f03005fc000 R15: 0000564f00123300
---[ end trace 9564a1ccad733a91 ]---

