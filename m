Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AFD230C97
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 16:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgG1OkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 10:40:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30072 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730449AbgG1OkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 10:40:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595947201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=n9RcmArQYWuTpAAdErmPZFmnkNv3sBLv+UXOnyAaRMc=;
        b=dfS1KQhXXclnOnW+XfHy+L9eycSKr65TDIJC/MODcXXD+pKtaSMbc2s58dZMfzUQZRZBMH
        xEeuB5qo498fmWf+ulwVO/Aoi79ivl6/4wWJhyMGbIH4oiNcG/9YmkAD3o0ykmmBiH7CNQ
        PDCBWCnA834BybuW2g8E5JIt88EvIfw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-WoCX-GzcPXGCAUZw2cnI1g-1; Tue, 28 Jul 2020 10:39:57 -0400
X-MC-Unique: WoCX-GzcPXGCAUZw2cnI1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A724107BEF7;
        Tue, 28 Jul 2020 14:39:56 +0000 (UTC)
Received: from [10.10.115.102] (ovpn-115-102.rdu2.redhat.com [10.10.115.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A2C819D7C;
        Tue, 28 Jul 2020 14:39:51 +0000 (UTC)
To:     linux-kernel@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
        wanpengli@tencent.com, Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        liran.alon@oracle.com, "frederic@kernel.org" <frederic@kernel.org>,
        tglx@linutronix.de, Juri Lelli <juri.lelli@redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Subject: WARNING: suspicious RCU usage - while installing a VM on a CPU listed
 under nohz_full
Organization: Red Hat Inc,
Message-ID: <ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com>
Date:   Tue, 28 Jul 2020 10:39:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cKA76uN3vpOZ7s5J449z384XSweVwhWxY"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cKA76uN3vpOZ7s5J449z384XSweVwhWxY
Content-Type: multipart/mixed; boundary="aTJONYBsVsQ5tMycSC03DBOrrMr8uJuQs"

--aTJONYBsVsQ5tMycSC03DBOrrMr8uJuQs
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Hi,

I have recently come across an RCU trace with the 5.8-rc7 kernel that has t=
he
debug configs enabled while installing a VM on a CPU that is listed under
nohz_full.

Based on some of the initial debugging, my impression is that the issue is
triggered because of the fastpath that is meant to optimize the writes to x=
2APIC
ICR that eventually leads to a virtual IPI in fixed delivery mode, is getti=
ng
invoked from the quiescent state.

Following is the RCU trace dump that I was getting:

[=C2=A0 178.109535] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[=C2=A0 178.114027] WARNING: suspicious RCU usage
[=C2=A0 178.118518] 5.8.0-rc7-upstream-+ #10 Not tainted
[=C2=A0 178.123685] -----------------------------
[=C2=A0 178.128176] arch/x86/kvm/lapic.c:269 suspicious rcu_dereference_che=
ck() usage!
[=C2=A0 178.136254]
[=C2=A0 178.136254] other info that might help us debug this:
[=C2=A0 178.136254]
[=C2=A0 178.145205]
[=C2=A0 178.145205] rcu_scheduler_active =3D 2, debug_locks =3D 1
[=C2=A0 178.152506] 1 lock held by CPU 0/KVM/2959:
[=C2=A0 178.157091]=C2=A0 #0: ffffc9000717b6f8 (&kvm->arch.apic_map_lock){+=
.+.}-{3:3}, at:
kvm_recalculate_apic_map+0x8b/0xdd0 [kvm]
[=C2=A0 178.169207]
[=C2=A0 178.169207] stack backtrace:
[=C2=A0 178.174086] CPU: 18 PID: 2959 Comm: CPU 0/KVM Not tainted
5.8.0-rc7-upstream-+ #10
[=C2=A0 178.182539] Hardware name: Dell Inc. PowerEdge R430/0CN7X8, BIOS 2.=
6.0 10/31/2017
[=C2=A0 178.190895] Call Trace:
[=C2=A0 178.193637]=C2=A0 dump_stack+0x9d/0xe0
[=C2=A0 178.197379]=C2=A0 kvm_recalculate_apic_map+0x8ce/0xdd0 [kvm]
[=C2=A0 178.203259]=C2=A0 ? kvm_lapic_reset+0x832/0xe50 [kvm]
[=C2=A0 178.208459]=C2=A0 kvm_vcpu_reset+0x28/0x7b0 [kvm]
[=C2=A0 178.213270]=C2=A0 kvm_arch_vcpu_create+0x830/0xb70 [kvm]
[=C2=A0 178.218759]=C2=A0 kvm_vm_ioctl+0x11b1/0x1fe0 [kvm]
[=C2=A0 178.223635]=C2=A0 ? mark_lock+0x144/0x19e0
[=C2=A0 178.227757]=C2=A0 ? kvm_unregister_device_ops+0xe0/0xe0 [kvm]
[=C2=A0 178.233698]=C2=A0 ? sched_clock+0x5/0x10
[=C2=A0 178.237597]=C2=A0 ? sched_clock_cpu+0x18/0x1d0
[=C2=A0 178.242087]=C2=A0 ? __lock_acquire+0xcf6/0x5010
[=C2=A0 178.246686]=C2=A0 ? lockdep_hardirqs_on_prepare+0x550/0x550
[=C2=A0 178.252429]=C2=A0 ? lockdep_hardirqs_on_prepare+0x550/0x550
[=C2=A0 178.258177]=C2=A0 ? sched_clock+0x5/0x10
[=C2=A0 178.262074]=C2=A0 ? sched_clock_cpu+0x18/0x1d0
[=C2=A0 178.266556]=C2=A0 ? find_held_lock+0x3a/0x1c0
[=C2=A0 178.270953]=C2=A0 ? ioctl_file_clone+0x120/0x120
[=C2=A0 178.275630]=C2=A0 ? selinux_file_ioctl+0x98/0x570
[=C2=A0 178.280405]=C2=A0 ? selinux_file_mprotect+0x5b0/0x5b0
[=C2=A0 178.285569]=C2=A0 ? rcu_tasks_wait_gp+0x6d1/0xa50
[=C2=A0 178.290342]=C2=A0 ? rcu_read_lock_sched_held+0xe0/0xe0
[=C2=A0 178.295608]=C2=A0 ? __fget_files+0x1f0/0x300
[=C2=A0 178.299912]=C2=A0 ksys_ioctl+0xc0/0x110
[=C2=A0 178.303719]=C2=A0 __x64_sys_ioctl+0x6f/0xb0
[=C2=A0 178.307913]=C2=A0 do_syscall_64+0x51/0xb0
[=C2=A0 178.311913]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
[=C2=A0 178.317557] RIP: 0033:0x7f6b9700d88b
[=C2=A0 178.321551] Code: 0f 1e fa 48 8b 05 fd 95 2c 00 64 c7 00 26 00 00 0=
0 48 c7 c0
ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 0=
1 f0
ff ff 73 018
[=C2=A0 178.342513] RSP: 002b:00007f6b8cbe9668 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[=C2=A0 178.350967] RAX: ffffffffffffffda RBX: 000055e8162d9000 RCX: 00007f=
6b9700d88b
[=C2=A0 178.358935] RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 000000=
000000000e
[=C2=A0 178.366903] RBP: 000055e8162d9000 R08: 000055e8155ec4d0 R09: 000055=
e8162d9000
[=C2=A0 178.374871] R10: 000055e815d94ee0 R11: 0000000000000246 R12: 000055=
e8162ad420
[=C2=A0 178.382838] R13: 000055e8162d9000 R14: 00007ffedf043660 R15: 00007f=
6b8cbe9800
[=C2=A0 182.771858]
[=C2=A0 182.773606] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[=C2=A0 182.778084] WARNING: suspicious RCU usage
[=C2=A0 182.782564] 5.8.0-rc7-upstream-+ #10 Not tainted
[=C2=A0 182.787719] -----------------------------
[=C2=A0 182.792197] arch/x86/include/asm/trace/fpu.h:60 suspicious
rcu_dereference_check() usage!
[=C2=A0 182.801329]
[=C2=A0 182.801329] other info that might help us debug this:
[=C2=A0 182.801329]
[=C2=A0 182.810268]
[=C2=A0 182.810268] RCU used illegally from idle CPU!
[=C2=A0 182.810268] rcu_scheduler_active =3D 2, debug_locks =3D 1
[=C2=A0 182.822407] RCU used illegally from extended quiescent state!
[=C2=A0 182.828824] 1 lock held by CPU 0/KVM/2959:
[=C2=A0 182.833397]=C2=A0 #0: ffff88903f8500d0 (&vcpu->mutex){+.+.}-{3:3}, =
at:
kvm_vcpu_ioctl+0x172/0xb00 [kvm]
[=C2=A0 182.838308]
[=C2=A0 182.838308] stack backtrace:
[=C2=A0 182.838313] CPU: 18 PID: 2959 Comm: CPU 0/KVM Tainted: G=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0
5.8.0-rc7-upstream-+ #10
[=C2=A0 182.838316] Hardware name: Dell Inc. PowerEdge R430/0CN7X8, BIOS 2.=
6.0 10/31/2017
[=C2=A0 182.838318] Call Trace:
[=C2=A0 182.874318]=C2=A0 dump_stack+0x9d/0xe0
[=C2=A0 182.878024]=C2=A0 switch_fpu_return+0x37c/0x410
[=C2=A0 182.882602]=C2=A0 ? fpu__clear+0x1a0/0x1a0
[=C2=A0 182.886700]=C2=A0 ? rcu_dynticks_eqs_enter+0x15/0x30
[=C2=A0 182.891807]=C2=A0 vcpu_enter_guest+0x1854/0x3df0 [kvm]
[=C2=A0 182.897121]=C2=A0 ? kvm_vcpu_reload_apic_access_page+0x60/0x60 [kvm=
]
[=C2=A0 182.903738]=C2=A0 ? lock_acquire+0x1ac/0xac0
[=C2=A0 182.908062]=C2=A0 ? kvm_arch_vcpu_ioctl_run+0x1dc/0x13c0 [kvm]
[=C2=A0 182.914107]=C2=A0 ? rcu_read_unlock+0x50/0x50
[=C2=A0 182.918489]=C2=A0 ? rcu_read_lock_sched_held+0xaf/0xe0
[=C2=A0 182.923788]=C2=A0 ? kvm_load_guest_fpu+0x94/0x350 [kvm]
[=C2=A0 182.929177]=C2=A0 ? kvm_load_guest_fpu+0x94/0x350 [kvm]
[=C2=A0 182.934528]=C2=A0 ? __local_bh_enable_ip+0x123/0x1a0
[=C2=A0 182.939635]=C2=A0 kvm_arch_vcpu_ioctl_run+0x310/0x13c0 [kvm]
[=C2=A0 182.945529]=C2=A0 kvm_vcpu_ioctl+0x3ee/0xb00 [kvm]
[=C2=A0 182.950406]=C2=A0 ? sched_clock+0x5/0x10
[=C2=A0 182.954336]=C2=A0 ? kvm_set_memory_region+0x40/0x40 [kvm]
[=C2=A0 182.959897]=C2=A0 ? ioctl_file_clone+0x120/0x120
[=C2=A0 182.964572]=C2=A0 ? selinux_file_ioctl+0x98/0x570
[=C2=A0 182.969347]=C2=A0 ? selinux_file_mprotect+0x5b0/0x5b0
[=C2=A0 182.974507]=C2=A0 ? rcu_tasks_wait_gp+0x710/0xa50
[=C2=A0 182.979280]=C2=A0 ? rcu_read_lock_sched_held+0xe0/0xe0
[=C2=A0 182.984547]=C2=A0 ? __fget_files+0x1f0/0x300
[=C2=A0 182.988852]=C2=A0 ksys_ioctl+0xc0/0x110
[=C2=A0 182.992660]=C2=A0 __x64_sys_ioctl+0x6f/0xb0
[=C2=A0 182.996853]=C2=A0 do_syscall_64+0x51/0xb0
[=C2=A0 183.000849]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
[=C2=A0 183.006491] RIP: 0033:0x7f6b9700d88b
[=C2=A0 183.010486] Code: 0f 1e fa 48 8b 05 fd 95 2c 00 64 c7 00 26 00 00 0=
0 48 c7 c0
ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 0=
1 f0
ff ff 73 018
[=C2=A0 183.031446] RSP: 002b:00007f6b8cbe9618 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[=C2=A0 183.039901] RAX: ffffffffffffffda RBX: 000055e8162d9000 RCX: 00007f=
6b9700d88b
[=C2=A0 183.047868] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000=
0000000018
[=C2=A0 183.055826] RBP: 000055e8162d909b R08: 000055e8155ec1d0 R09: 000055=
e815db1620
[=C2=A0 183.063784] R10: 0000000000000000 R11: 0000000000000246 R12: 000055=
e8151f6290
[=C2=A0 183.071752] R13: 000055e8155c81c0 R14: 00007ffedf043660 R15: 00007f=
6b9c163000

Please let me know if any other information is required.

--=20
Nitesh


--aTJONYBsVsQ5tMycSC03DBOrrMr8uJuQs--

--cKA76uN3vpOZ7s5J449z384XSweVwhWxY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl8gOLUACgkQo4ZA3AYy
oznjIw//cdB8faGNVptH+3XAklgpKq65lAgc/pXBqHp2NqeWtOv/J8RiFXpDtZcS
vl2XbQHggOvcSXIGv9ygqwfWSkdx8d7rt1BCg7ErXqHEVbY0B9PvevCQr10QnQxB
aXn5mEqc55sk8iX/NgBZQF9oIiQEB8AzlB7IJVWslQ+2yp940QSCP1s3UAJat0Sp
dpqfeABd3waQZYHGY9IgJ+8TeA2Sch6nlCg9TTZHEyL2xKfZOT+eZpX6KDM+7xHA
qQnMpw5PqM9F+3hHgFYNw0Fgc3Mj1342F1NqSrtdlEzDrS4I17vLJQXpTiQSK78+
C2Qtd3e8TqLHXdZWhKiWTfdVtI4Xwoq4SQtzombs4jrzM591Qgjykp568JBQ/r0R
AAh9QZHtvrAeOZ90cvoSR/lumFDc8ImTnCILL5psKMzopTMq5GzR0zIPWGbGp2JY
6zq5OAE9H0IPZjP9CLGGGoJdWwNM9UQXFN39tXiYRG6rUzdZwdTua27Vh884iDBB
YgOEwcONMZQY/RJBidn7fAnba//v1bKQPpejhAxc+3ky8th21WUH64lwr/06P3Ag
Y/vOJROzQYUWjyIK5rzNtYwoRbBxa17WmT9O9JmSQ5pcz5XAHNG2mNke6EhX42B5
Efb7gx8I4M52+ZM58KlZzDefkc4Mn9ZyJqd41Otlhed+frow5ps=
=/N2c
-----END PGP SIGNATURE-----

--cKA76uN3vpOZ7s5J449z384XSweVwhWxY--

