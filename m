Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7A6664C2B
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 20:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbjAJTRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 14:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbjAJTRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 14:17:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8222652C61
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 11:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q2UPWoBt+l4MCtf3yjxssAU52nqzz9FU1p8pVY2oanE=; b=YqBDf6hLIq+/NhqbCT9gaceDVT
        88CU5gfK0gu2Df+2KC4N7miJv7NyKUIIc/2UrMQL7Xct9cks7XSaXa1gljtpeSGqXXfbYQRVzncQL
        ModX20SZa7+SYZ6z8WMIHArt8IlKvfKZ+BMHdmPP6Q9zzSFhPYG4IjJw/r60UjxZL+5oXPmfnCl6c
        OfVilTXTHFgAETDngKKiJZCagOFI2b/grDbmWuqIPsZVDPeFl55X+9ABRXFUJYhijw3knytvwM5pD
        HGgkCxNhB3gGHLeQg+Vgnn9TWVJ0rKfih6blMZdvzomb2VSRN6IyTw6QOZrU6uXfBEG30I7Sa0YBd
        4UywWbGg==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFK82-003TRw-Hs; Tue, 10 Jan 2023 19:17:46 +0000
Message-ID: <825aef8e14c1aeaf1870ac3e1510a6e1fe71129d.camel@infradead.org>
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, paul@xen.org,
        Peter Zijlstra <peterz@infradead.org>
Date:   Tue, 10 Jan 2023 19:17:32 +0000
In-Reply-To: <9cd3c43b-4bfe-cf4e-f97e-a0c840574445@redhat.com>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
         <20221229211737.138861-1-mhal@rbox.co>
         <20221229211737.138861-2-mhal@rbox.co> <Y7RjL+0Sjbm/rmUv@google.com>
         <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
         <Y7dN0Negds7XUbvI@google.com>
         <3a4ab7b0-67f3-f686-0471-1ae919d151b5@redhat.com>
         <f3b61f1c0b92af97a285c9e05f1ac99c1940e5a9.camel@infradead.org>
         <9cd3c43b-4bfe-cf4e-f97e-a0c840574445@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-hhDdhun7TIeYTw0ICt+e"
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-hhDdhun7TIeYTw0ICt+e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-01-10 at 15:10 +0100, Paolo Bonzini wrote:
> On 1/10/23 13:55, David Woodhouse wrote:
> > > However, I
> > > completely forgot the sev_lock_vcpus_for_migration case, which is the
> > > exception that... well, disproves the rule.
> > >=20
> > But because it's an exception and rarely happens in practice, lockdep
> > didn't notice and keep me honest sooner? Can we take them in that order
> > just for fun at startup, to make sure lockdep knows?
>=20
> Sure, why not.=C2=A0 Out of curiosity, is this kind of "priming" a thing=
=20
> elsewhere in the kernel

I did this:

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -461,6 +461,11 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory=
_cache *mc)
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned=
 id)
 {
        mutex_init(&vcpu->mutex);
+
+       /* Ensure that lockdep knows vcpu->mutex is taken *inside* kvm->loc=
k */
+       mutex_lock(&vcpu->mutex);
+       mutex_unlock(&vcpu->mutex);
+
        vcpu->cpu =3D -1;
        vcpu->kvm =3D kvm;
        vcpu->vcpu_id =3D id;


What I got when I ran xen_shinfo_test was... not what I expected:


[13890.148203] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[13890.148205] WARNING: possible circular locking dependency detected
[13890.148207] 6.1.0-rc4+ #1024 Tainted: G          I E    =20
[13890.148209] ------------------------------------------------------
[13890.148210] xen_shinfo_test/13326 is trying to acquire lock:
[13890.148212] ffff888107d493b0 (&gpc->lock){....}-{2:2}, at: kvm_xen_updat=
e_runstate_guest+0xf2/0x4e0 [kvm]
[13890.148285]=20
               but task is already holding lock:
[13890.148287] ffff88887f671718 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0=
x84/0x7c0
[13890.148295]=20
               which lock already depends on the new lock.

[13890.148296]=20
               the existing dependency chain (in reverse order) is:
[13890.148298]=20
               -> #4 (&rq->__lock){-.-.}-{2:2}:
[13890.148301]        __lock_acquire+0x4b4/0x940
[13890.148306]        lock_acquire.part.0+0xa8/0x210
[13890.148309]        _raw_spin_lock_nested+0x35/0x50
[13890.148313]        raw_spin_rq_lock_nested+0x23/0x30
[13890.148318]        task_fork_fair+0x45/0x170
[13890.148322]        sched_cgroup_fork+0x11a/0x160
[13890.148325]        copy_process+0x1139/0x1950
[13890.148329]        kernel_clone+0x9b/0x390
[13890.148332]        user_mode_thread+0x5b/0x80
[13890.148335]        rest_init+0x1e/0x170
[13890.148338]        arch_call_rest_init+0xa/0x14
[13890.148342]        start_kernel+0x647/0x670
[13890.148345]        secondary_startup_64_no_verify+0xd3/0xdb
[13890.148349]=20
               -> #3 (&p->pi_lock){-.-.}-{2:2}:
[13890.148352]        __lock_acquire+0x4b4/0x940
[13890.148355]        lock_acquire.part.0+0xa8/0x210
[13890.148357]        __raw_spin_lock_irqsave+0x44/0x60
[13890.148360]        try_to_wake_up+0x69/0x360
[13890.148362]        create_worker+0x129/0x1a0
[13890.148366]        workqueue_init+0x14b/0x1b0
[13890.148371]        kernel_init_freeable+0x95/0x122
[13890.148373]        kernel_init+0x16/0x130
[13890.148375]        ret_from_fork+0x22/0x30
[13890.148378]=20
               -> #2 (&pool->lock){-.-.}-{2:2}:
[13890.148381]        __lock_acquire+0x4b4/0x940
[13890.148384]        lock_acquire.part.0+0xa8/0x210
[13890.148386]        _raw_spin_lock+0x2f/0x40
[13890.148389]        __queue_work+0x1a1/0x490
[13890.148391]        queue_work_on+0x75/0x80
[13890.148394]        percpu_ref_put_many.constprop.0+0xea/0xf0
[13890.148398]        __mem_cgroup_uncharge_list+0x7d/0xa0
[13890.148401]        release_pages+0x15b/0x590
[13890.148404]        folio_batch_move_lru+0xd3/0x150
[13890.148407]        lru_add_drain_cpu+0x1ce/0x270
[13890.148410]        lru_add_drain+0x77/0x140
[13890.148413]        do_wp_page+0x342/0x3a0
[13890.148417]        __handle_mm_fault+0x3a1/0x690
[13890.148421]        handle_mm_fault+0x113/0x3b0
[13890.148424]        do_user_addr_fault+0x1d8/0x6b0
[13890.148427]        exc_page_fault+0x6a/0xe0
[13890.148429]        asm_exc_page_fault+0x22/0x30
[13890.148432]=20
               -> #1 (lock#4){+.+.}-{2:2}:
[13890.148436]        __lock_acquire+0x4b4/0x940
[13890.148439]        lock_acquire.part.0+0xa8/0x210
[13890.148441]        folio_mark_accessed+0x8d/0x1a0
[13890.148444]        kvm_release_page_clean+0x89/0xb0 [kvm]
[13890.148485]        hva_to_pfn_retry+0x296/0x2d0 [kvm]
[13890.148524]        __kvm_gpc_refresh+0x18e/0x310 [kvm]
[13890.148562]        kvm_xen_hvm_set_attr+0x1f5/0x2f0 [kvm]
[13890.148613]        kvm_arch_vm_ioctl+0x9bf/0xd50 [kvm]
[13890.148656]        kvm_vm_ioctl+0x5c1/0x7f0 [kvm]
[13890.148693]        __x64_sys_ioctl+0x8a/0xc0
[13890.148696]        do_syscall_64+0x3b/0x90
[13890.148701]        entry_SYSCALL_64_after_hwframe+0x63/0xcd
[13890.148704]=20
               -> #0 (&gpc->lock){....}-{2:2}:
[13890.148708]        check_prev_add+0x8f/0xc20
[13890.148710]        validate_chain+0x3ba/0x450
[13890.148713]        __lock_acquire+0x4b4/0x940
[13890.148715]        lock_acquire.part.0+0xa8/0x210
[13890.148717]        __raw_read_lock_irqsave+0x7f/0xa0
[13890.148720]        kvm_xen_update_runstate_guest+0xf2/0x4e0 [kvm]
[13890.148771]        kvm_arch_vcpu_put+0x1d4/0x250 [kvm]
[13890.148814]        kvm_sched_out+0x2f/0x50 [kvm]
[13890.148849]        prepare_task_switch+0xe7/0x3b0
[13890.148853]        __schedule+0x1c9/0x7c0
[13890.148857]        schedule+0x5d/0xd0
[13890.148860]        xfer_to_guest_mode_handle_work+0x59/0xd0
[13890.148865]        vcpu_run+0x328/0x410 [kvm]
[13890.148908]        kvm_arch_vcpu_ioctl_run+0x1cd/0x640 [kvm]
[13890.148950]        kvm_vcpu_ioctl+0x279/0x700 [kvm]
[13890.148986]        __x64_sys_ioctl+0x8a/0xc0
[13890.148989]        do_syscall_64+0x3b/0x90
[13890.148993]        entry_SYSCALL_64_after_hwframe+0x63/0xcd
[13890.148996]=20
               other info that might help us debug this:

[13890.148997] Chain exists of:
                 &gpc->lock --> &p->pi_lock --> &rq->__lock

[13890.149002]  Possible unsafe locking scenario:

[13890.149003]        CPU0                    CPU1
[13890.149004]        ----                    ----
[13890.149005]   lock(&rq->__lock);
[13890.149007]                                lock(&p->pi_lock);
[13890.149009]                                lock(&rq->__lock);
[13890.149011]   lock(&gpc->lock);
[13890.149013]=20
                *** DEADLOCK ***

[13890.149014] 3 locks held by xen_shinfo_test/13326:
[13890.149016]  #0: ffff888107d480b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vc=
pu_ioctl+0x77/0x700 [kvm]
[13890.149057]  #1: ffff88887f671718 (&rq->__lock){-.-.}-{2:2}, at: __sched=
ule+0x84/0x7c0
[13890.149064]  #2: ffffc900017c5860 (&kvm->srcu){....}-{0:0}, at: kvm_arch=
_vcpu_put+0x2a/0x250 [kvm]
[13890.149109]=20
               stack backtrace:
[13890.149111] CPU: 1 PID: 13326 Comm: xen_shinfo_test Tainted: G          =
I E      6.1.0-rc4+ #1024
[13890.149115] Hardware name: Intel Corporation S2600CW/S2600CW, BIOS SE5C6=
10.86B.01.01.0008.021120151325 02/11/2015
[13890.149116] Call Trace:
[13890.149118]  <TASK>
[13890.149121]  dump_stack_lvl+0x56/0x73
[13890.149126]  check_noncircular+0x102/0x120
[13890.149131]  check_prev_add+0x8f/0xc20
[13890.149134]  ? validate_chain+0x22a/0x450
[13890.149136]  ? add_chain_cache+0x10b/0x2d0
[13890.149140]  validate_chain+0x3ba/0x450
[13890.149144]  __lock_acquire+0x4b4/0x940
[13890.149148]  lock_acquire.part.0+0xa8/0x210
[13890.149151]  ? kvm_xen_update_runstate_guest+0xf2/0x4e0 [kvm]
[13890.149204]  ? rcu_read_lock_sched_held+0x43/0x70
[13890.149208]  ? lock_acquire+0x102/0x140
[13890.149211]  __raw_read_lock_irqsave+0x7f/0xa0
[13890.149215]  ? kvm_xen_update_runstate_guest+0xf2/0x4e0 [kvm]
[13890.149266]  kvm_xen_update_runstate_guest+0xf2/0x4e0 [kvm]
[13890.149316]  ? get_kvmclock_ns+0x52/0x90 [kvm]
[13890.149359]  ? lock_acquire+0x102/0x140
[13890.149363]  kvm_arch_vcpu_put+0x1d4/0x250 [kvm]
[13890.149407]  kvm_sched_out+0x2f/0x50 [kvm]
[13890.149444]  prepare_task_switch+0xe7/0x3b0
[13890.149449]  __schedule+0x1c9/0x7c0
[13890.149454]  schedule+0x5d/0xd0
[13890.149458]  xfer_to_guest_mode_handle_work+0x59/0xd0
[13890.149463]  vcpu_run+0x328/0x410 [kvm]
[13890.149507]  kvm_arch_vcpu_ioctl_run+0x1cd/0x640 [kvm]
[13890.149551]  kvm_vcpu_ioctl+0x279/0x700 [kvm]
[13890.149588]  ? exc_page_fault+0xdb/0xe0
[13890.149591]  ? _raw_spin_unlock_irq+0x34/0x50
[13890.149595]  ? do_setitimer+0x190/0x1e0
[13890.149600]  __x64_sys_ioctl+0x8a/0xc0
[13890.149604]  do_syscall_64+0x3b/0x90
[13890.149607]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[13890.149611] RIP: 0033:0x7fa394a3fd1b
[13890.149614] Code: 73 01 c3 48 8b 0d 05 a1 1b 00 f7 d8 64 89 01 48 83 c8 =
ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 a0 1b 00 f7 d8 64 89 01 48
[13890.149617] RSP: 002b:00007ffe7f86c0a8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[13890.149620] RAX: ffffffffffffffda RBX: 00007fa394e01000 RCX: 00007fa394a=
3fd1b
[13890.149622] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 00000000000=
00007
[13890.149624] RBP: 00007fa394dc96c0 R08: 000000000041827e R09: 00000000004=
18234
[13890.149626] R10: 00007fa394bb936b R11: 0000000000000246 R12: 00000000018=
f9800
[13890.149628] R13: 000000000000000a R14: 00007fa394dffff1 R15: 00000000018=
f72a0
[13890.149632]  </TASK>


--=-hhDdhun7TIeYTw0ICt+e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMTEwMTkxNzMyWjAvBgkqhkiG9w0BCQQxIgQgzUy8EMKR
UD+rErRxTTAVYlUugB7HXWWyJEZOe2HhcZcwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAkEJ8y3las5wBDJusHh0ZTC4hppZAW0Oy0
YHgCMOLd47sGRIsyoz48eVbBEJ/c69F3OotKhrFfuaE7uSVI+b7yY1dxvQWo6ZZSIGq7AtZkVzAT
jIYcukxztD5HHNrQxZxG0fyX6oyyoReHL3wyjn+yysmrFU4DhSxCukM02HFRvF+EaE6VR8vguhiD
cBkL98r7G47m6/wm0PiSnLw7OpS4zKfEX8a5E+OW3DOK781ERQ9j8jJBhCWyk2mP9Su7S4Nzv/ng
hJW2ImUx4DWLuykKyzR+kRcUK2oBd+svHIFBjzPRfjqTh84vc8aNFCeZx4JPM9XoSgzp7fVdhi3V
V6qZJa/2JZzSbRFRNnnX8IZnpUGcvBAF/rqLIc2STuDRC+mVGT18Amb5lb3UpKhwjkluRZLl2Xkj
eJO6Y7gYHjKB/IBNLKy9riLZAJZ+p9X8vL1bQT+xFHTETbBxV5haGnjsU/yKeBk48TjzHZkZghBd
Gj0KcepiSidbiZoiwAMLRndKbyB2czeFaKIkoNqq86n8J3f1PjZqMeILoUZih2DtkSHdNPNbpAEV
njYXKa8tfNAYXyjtW5hOUj2MdZaKVIQdRyFkoC/NMczCE0JXSiVUVm1tDpAmhAVljLPGp0ZsW8P9
iq+DhzCUPnyeukO6uVcQWGsh8tLzklWxNNohzin9MAAAAAAAAA==


--=-hhDdhun7TIeYTw0ICt+e--
