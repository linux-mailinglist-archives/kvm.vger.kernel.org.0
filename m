Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4585F518A4F
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 18:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiECQsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 12:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239683AbiECQsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 12:48:35 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2AF2C671
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 09:45:01 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlvdx-0007hQ-LS; Tue, 03 May 2022 18:44:57 +0200
Message-ID: <0426aa3f-bd8c-33f6-e492-088972b5dff0@maciej.szmigiero.name>
Date:   Tue, 3 May 2022 18:44:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20220502022959.18aafe13.zkaspar82@gmail.com>
 <20220502190010.7ff820e3.zkaspar82@gmail.com> <YnFWT+OdBAOPpZfi@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: Core2 and v5.18-rc5 troubles
In-Reply-To: <YnFWT+OdBAOPpZfi@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3.05.2022 18:20, Sean Christopherson wrote:
> On Mon, May 02, 2022, Zdenek Kaspar wrote:
>> On Mon, 2 May 2022 02:29:59 +0200
>> Zdenek Kaspar <zkaspar82@gmail.com> wrote:
>>
>>> Hi, when I noticed fix for pre-EPYC and older Intel hardware I checked
>>> v5.18-rc5 on my old Core2 machine and something else fails here.

Core2 means shadow paging, but I don't know how this is related
to pre-EPYC AMD chips (Family 10h and Bulldozers support NPT, too).
Do you mean AMD K8 support here?

>>> When I kill -9 the first qemu attempt (see dmesg-1), then next
>>> attempt is OK, after successful VM shutdown another attempt fails
>>> again (see dmesg-2). After that it takes some time and machine needs
>>> reset (see dmesg-3).
>>>
>>> HTH, Z.
>>
>> Oh crap, I had auto-applied mglru patch, sorry...

Try a raw v5.18-rc5 if your test kernel has some extra patches applied.

>> Now starting qemu does this:
>>
>> 20 root      20   0   0.0m R 100.0   0.0   0:28.33 kworker/1:0+rcu_gp
>> looks like:  94.36%  [kernel]                  [k] delay_tsc
>> kill -9 "qemu process" and noticed several D state processes:
>>      107 ?        D      0:04 [kworker/u8:7+events_unbound]
>>      108 ?        D      0:03 [kworker/u8:8+events_unbound]
>>      632 ?        Ds     0:00 /usr/lib/systemd/systemd-journald
>>
>> machine is trashed, here's dmesg info:
>>
>> [  172.349282] BUG: kernel NULL pointer dereference, address: 000000000000000b
>> [  172.349324] #PF: supervisor write access in kernel mode
>> [  172.349345] #PF: error_code(0x0002) - not-present page
>> [  172.349363] PGD 0 P4D 0
>> [  172.349375] Oops: 0002 [#1] PREEMPT SMP PTI
>> [  172.349393] CPU: 0 PID: 626 Comm: qemu-build Not tainted 5.18.0-rc5-2-amd64 #1
>> [  172.349420] Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
>> [  172.349446] RIP: 0010:kvm_replace_memslot+0xb0/0x2a0 [kvm]
>> [  172.349496] Code: ac 1c 80 04 00 00 4d 85 f6 74 65 48 89 e8 48 c1 e0 04 49 8b 4c 06 08 48 85 c9 74 21 4c 01 f0 48 8b 10 48 89 11 48 85 d2 74 04 <48> 89 4a 08 48 c7 40 08 00 00 00 00 48 c7 00 00 00 00 00 48 8d 44
> 
> ...
> 
>> [  172.349772] Call Trace:
>> [  172.349785]  <TASK>
>> [  172.349795]  kvm_set_memslot+0x3a8/0x5e0 [kvm]
> 
> My kernel build doesn't match exactly, but it's pretty close, and this call points
> to the kvm_activate_memslot() call in the kvm_prepare_memory_region() error path.
> 
> 	r = kvm_prepare_memory_region(kvm, old, new, change);
> 	if (r) {
> 		/*
> 		 * For DELETE/MOVE, revert the above INVALID change.  No
> 		 * modifications required since the original slot was preserved
> 		 * in the inactive slots.  Changing the active memslots also
> 		 * release slots_arch_lock.
> 		 */
> 		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> 			kvm_activate_memslot(kvm, invalid_slot, old);
> 			kfree(invalid_slot);
> 		} else {
> 			mutex_unlock(&kvm->slots_arch_lock);
> 		}
> 		return r;
> 	}
> 
> What I can't figure out is how that can result in a NULL pointer dereference.  The
> the faulting instruction is
> 
> 	mov rcx, [rdx + 8]
> 
> which appears to be
> 
> 	WRITE_ONCE(*pprev, next);
> 
> in __hlist_del() from hlist_del().
> 
> 	if (!hlist_unhashed(n)) {
> 		__hlist_del(n);
> 		INIT_HLIST_NODE(n);
> 	}
> 
> which comes from
> 
> 	hash_del(&old->id_node[idx]);
> 
> so the fault on 0xb means the pointer is '3'.  "old" is zero allocated, and idx
> comes from slots->node_idx, which is effectively a constant '0' or '1'.
> 
> I can't see any way for "old" to be '3.  Even more confusing is that that would
> imply kvm_prepare_memory_region() failed on a DELETE action, which should be
> impossible.
> 
> I've tried hitting every edge case of this flow I can think of and haven't been
> able to reproduce the behavior, e.g. triggering the new error path introduced by
> commit 86931ff7207b ("KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
> host.MAXPHYADDR") is handled cleanly.  Furthermore, AFAIK QEMU doesn't MOVE slots,
> so that path seems highly unlikely.
> 
> The other relevant datapoint is that fsnotify() hits a very similar NULL pointer
> shortly after KVM's explosion, that one directly on address '3'.  That suggests
> there's data corruption of some form going on, and KVM just happens to be the first
> to be encounter a bad pointer.
> 
> Have you tried bisecting?  And/or can you provide your kernel config?  Maybe there's
> a debug/sanitizer option that's causing problems.

+1 for bisecting.

Would also ask the reporter to try enabling KASAN,
if it is a genuine memory corruption bug it might show the place it originally
happens (rather than where the overwritten pointer ultimately gets dereferenced).

Thanks,
Maciej
