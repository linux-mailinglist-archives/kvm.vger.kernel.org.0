Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F7B66950E
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 12:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbjAMLLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 06:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241211AbjAMLKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 06:10:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F7B68C87;
        Fri, 13 Jan 2023 03:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OjMNFrMw9E14SVkRjzqTpbnFxm0iH4W3L8nYb4oGlTo=; b=XVRmZEVkHcqeWHpLDRNjIkOlU1
        GumUqO4e7i1n6x9/hwK9dfSElbEcQd8DlgRpU+pTDVxFN98hm6U/lkWB0S5GpGbDjVznSuBtKNTtJ
        N1Hqx/1ZMsi/RK7rKCZC1is3mV62YV5ypRIGaCK/4bOw1E2Uy1Nzv86PG5EGZw+z/Vg/RCSnbyLgV
        GG5RQKLIJc+pQW/oJ/8v2D3HmIuxbP6Iotf+kUf6Dj6qrJiuaKaMKozoaAhSfX/PU2+EQ7DfI0qqy
        oGl7n8FgKs+jS3DdVj66X8U+zMCmLQgrXKAACyViAf/3OLfzLjsfevjXqGoGfCgc5UWm4eRhIEuzn
        pvuDEDyw==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGHq7-0061vj-N7; Fri, 13 Jan 2023 11:03:17 +0000
Message-ID: <41fad1dc90c2bef4f2f17f1495c2f85105707d9f.camel@infradead.org>
Subject: Re: [PATCH] Documentation: kvm: fix SRCU locking order docs
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        Peter Zijlstra <peterz@infradead.org>
Date:   Fri, 13 Jan 2023 11:03:02 +0000
In-Reply-To: <023e131b3de80c4bc2b6711804a4769466b90c6f.camel@infradead.org>
References: <20230111183031.2449668-1-pbonzini@redhat.com>
         <a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org>
         <20230112152048.GJ4028633@paulmck-ThinkPad-P17-Gen-1>
         <Y8EF24o932lcshKs@boqun-archlinux>
         <d1d44f07-558c-e0ed-403e-61a854c868cb@redhat.com>
         <023e131b3de80c4bc2b6711804a4769466b90c6f.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-faejZK8MwCv7sSfxNlYE"
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


--=-faejZK8MwCv7sSfxNlYE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-01-13 at 10:33 +0000, David Woodhouse wrote:
>=20
> So everything seems to be working as it should... *except* for the fact
> that I don't quite understand why xen_shinfo_test didn't trigger the
> warning. Michal, I guess you already worked that out when you came up
> with your deadlock-test instead... is there something we should add to
> xen_shinfo_test that would mean it *would* have triggered?

Got it. It only happens when kvm_xen_set_evtchn() takes the slow path
when kvm_xen_set_evtchn_fast() fails. Not utterly sure why that works
in your deadlock_test but I can make it happen in xen_shinfo_test just
by invalidating the GPC by changing the memslots:


--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -29,6 +29,9 @@
 #define DUMMY_REGION_GPA       (SHINFO_REGION_GPA + (3 * PAGE_SIZE))
 #define DUMMY_REGION_SLOT      11
=20
+#define DUMMY_REGION_GPA_2     (SHINFO_REGION_GPA + (4 * PAGE_SIZE))
+#define DUMMY_REGION_SLOT_2    12
+
 #define SHINFO_ADDR    (SHINFO_REGION_GPA)
 #define VCPU_INFO_ADDR (SHINFO_REGION_GPA + 0x40)
 #define PVTIME_ADDR    (SHINFO_REGION_GPA + PAGE_SIZE)
@@ -765,6 +768,8 @@ int main(int argc, char *argv[])
=20
                                if (verbose)
                                        printf("Testing guest EVTCHNOP_send=
 direct to evtchn\n");
+                               vm_userspace_mem_region_add(vm, VM_MEM_SRC_=
ANONYMOUS,
+                                                           DUMMY_REGION_GP=
A_2, DUMMY_REGION_SLOT_2, 1, 0);
                                evtchn_irq_expected =3D true;
                                alarm(1);
                                break;



I did also need the trick below. I'll send patches properly, keeping
the fast path test and *adding* the slow one, instead of just changing
it as above.

I also validated that if I put back the evtchn_reset deadlock fix, and
the separate xen_lock which is currently the tip of kvm/master, it all
works without complaints (or deadlocks).

>  I even tried this:
>=20
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1173,6 +1173,16 @@ static struct kvm *kvm_create_vm(unsigned long typ=
e, const char *fdname)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (init_srcu_struct(&kvm->irq=
_srcu))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 goto out_err_no_irq_srcu;
> =C2=A0
> +#ifdef CONFIG_LOCKDEP
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Ensure lockdep knows that i=
t's not permitted to lock kvm->lock
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * from a SRCU read section on=
 kvm->srcu.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&kvm->lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 synchronize_srcu(&kvm->srcu);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&kvm->lock);
> +#endif
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refcount_set(&kvm->users_count=
, 1);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < KVM_ADDRESS_=
SPACE_NUM; i++) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 for (j =3D 0; j < 2; j++) {
>=20
>=20

[   91.866348] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   91.866349] WARNING: possible circular locking dependency detected
[   91.866351] 6.2.0-rc3+ #1025 Tainted: G           OE    =20
[   91.866353] ------------------------------------------------------
[   91.866354] xen_shinfo_test/2938 is trying to acquire lock:
[   91.866356] ffffc9000179e3c0 (&kvm->lock){+.+.}-{3:3}, at: kvm_xen_set_e=
vtchn.part.0+0x6d/0x170 [kvm]
[   91.866453]=20
               but task is already holding lock:
[   91.866454] ffffc900017a7868 (&kvm->srcu){.+.+}-{0:0}, at: vcpu_enter_gu=
est.constprop.0+0xa89/0x1270 [kvm]
[   91.866527]=20
               which lock already depends on the new lock.

[   91.866528]=20
               the existing dependency chain (in reverse order) is:
[   91.866529]=20
               -> #1 (&kvm->srcu){.+.+}-{0:0}:
[   91.866532]        __lock_acquire+0x4b4/0x940
[   91.866537]        lock_sync+0x99/0x110
[   91.866540]        __synchronize_srcu+0x4d/0x170
[   91.866543]        kvm_create_vm+0x271/0x6e0 [kvm]
[   91.866621]        kvm_dev_ioctl+0x102/0x1c0 [kvm]
[   91.866694]        __x64_sys_ioctl+0x8a/0xc0
[   91.866697]        do_syscall_64+0x3b/0x90
[   91.866701]        entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   91.866707]=20
               -> #0 (&kvm->lock){+.+.}-{3:3}:
[   91.866710]        check_prev_add+0x8f/0xc20
[   91.866712]        validate_chain+0x3ba/0x450
[   91.866714]        __lock_acquire+0x4b4/0x940
[   91.866716]        lock_acquire.part.0+0xa8/0x210
[   91.866717]        __mutex_lock+0x94/0x920
[   91.866721]        kvm_xen_set_evtchn.part.0+0x6d/0x170 [kvm]
[   91.866790]        kvm_xen_hcall_evtchn_send.constprop.0+0x138/0x1c0 [kv=
m]
[   91.866869]        kvm_xen_hypercall+0x475/0x5a0 [kvm]
[   91.866938]        vmx_handle_exit+0xe/0x50 [kvm_intel]
[   91.866955]        vcpu_enter_guest.constprop.0+0xb08/0x1270 [kvm]
[   91.867034]        vcpu_run+0x1bd/0x450 [kvm]
[   91.867100]        kvm_arch_vcpu_ioctl_run+0x1df/0x670 [kvm]
[   91.867167]        kvm_vcpu_ioctl+0x279/0x700 [kvm]
[   91.867229]        __x64_sys_ioctl+0x8a/0xc0
[   91.867231]        do_syscall_64+0x3b/0x90
[   91.867235]        entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   91.867238]=20
               other info that might help us debug this:

[   91.867239]  Possible unsafe locking scenario:

[   91.867240]        CPU0                    CPU1
[   91.867241]        ----                    ----
[   91.867242]   lock(&kvm->srcu);
[   91.867244]                                lock(&kvm->lock);
[   91.867246]                                lock(&kvm->srcu);
[   91.867248]   lock(&kvm->lock);
[   91.867249]=20
                *** DEADLOCK ***

[   91.867250] 2 locks held by xen_shinfo_test/2938:
[   91.867252]  #0: ffff88815a8800b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vc=
pu_ioctl+0x77/0x700 [kvm]
[   91.867318]  #1: ffffc900017a7868 (&kvm->srcu){.+.+}-{0:0}, at: vcpu_ent=
er_guest.constprop.0+0xa89/0x1270 [kvm]
[   91.867387]=20
               stack backtrace:
[   91.867389] CPU: 26 PID: 2938 Comm: xen_shinfo_test Tainted: G          =
 OE      6.2.0-rc3+ #1025
[   91.867392] Hardware name: Intel Corporation S2600CW/S2600CW, BIOS SE5C6=
10.86B.01.01.0008.021120151325 02/11/2015
[   91.867394] Call Trace:
[   91.867395]  <TASK>
[   91.867398]  dump_stack_lvl+0x56/0x73
[   91.867403]  check_noncircular+0x102/0x120
[   91.867409]  check_prev_add+0x8f/0xc20
[   91.867411]  ? add_chain_cache+0x10b/0x2d0
[   91.867415]  validate_chain+0x3ba/0x450
[   91.867418]  __lock_acquire+0x4b4/0x940
[   91.867421]  lock_acquire.part.0+0xa8/0x210
[   91.867424]  ? kvm_xen_set_evtchn.part.0+0x6d/0x170 [kvm]
[   91.867494]  ? rcu_read_lock_sched_held+0x43/0x70
[   91.867498]  ? lock_acquire+0x102/0x140
[   91.867501]  __mutex_lock+0x94/0x920
[   91.867505]  ? kvm_xen_set_evtchn.part.0+0x6d/0x170 [kvm]
[   91.867574]  ? find_held_lock+0x2b/0x80
[   91.867578]  ? kvm_xen_set_evtchn.part.0+0x6d/0x170 [kvm]
[   91.867647]  ? __lock_release+0x5f/0x170
[   91.867652]  ? kvm_xen_set_evtchn.part.0+0x6d/0x170 [kvm]
[   91.867721]  kvm_xen_set_evtchn.part.0+0x6d/0x170 [kvm]
[   91.867791]  kvm_xen_hcall_evtchn_send.constprop.0+0x138/0x1c0 [kvm]
[   91.867875]  kvm_xen_hypercall+0x475/0x5a0 [kvm]
[   91.867947]  ? rcu_read_lock_sched_held+0x43/0x70
[   91.867952]  vmx_handle_exit+0xe/0x50 [kvm_intel]
[   91.867966]  vcpu_enter_guest.constprop.0+0xb08/0x1270 [kvm]
[   91.868046]  ? lock_acquire.part.0+0xa8/0x210
[   91.868050]  ? vcpu_run+0x1bd/0x450 [kvm]
[   91.868117]  ? lock_acquire+0x102/0x140
[   91.868121]  vcpu_run+0x1bd/0x450 [kvm]
[   91.868189]  kvm_arch_vcpu_ioctl_run+0x1df/0x670 [kvm]
[   91.868257]  kvm_vcpu_ioctl+0x279/0x700 [kvm]
[   91.868322]  ? get_cpu_entry_area+0xb/0x30
[   91.868327]  ? _raw_spin_unlock_irq+0x34/0x50
[   91.868330]  ? do_setitimer+0x190/0x1e0
[   91.868335]  __x64_sys_ioctl+0x8a/0xc0
[   91.868338]  do_syscall_64+0x3b/0x90
[   91.868341]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   91.868345] RIP: 0033:0x7f313103fd1b
[   91.868348] Code: 73 01 c3 48 8b 0d 05 a1 1b 00 f7 d8 64 89 01 48 83 c8 =
ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 a0 1b 00 f7 d8 64 89 01 48
[   91.868350] RSP: 002b:00007ffcdc02dba8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[   91.868353] RAX: ffffffffffffffda RBX: 00007f31313d2000 RCX: 00007f31310=
3fd1b
[   91.868355] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 00000000000=
00007
[   91.868356] RBP: 00007f313139a6c0 R08: 000000000065a2f0 R09: 00000000000=
00000
[   91.868357] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006=
5c800
[   91.868359] R13: 000000000000000a R14: 00007f31313d0ff1 R15: 00000000006=
5a2a0
[   91.868363]  </TASK>


--=-faejZK8MwCv7sSfxNlYE
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMTEzMTEwMzAyWjAvBgkqhkiG9w0BCQQxIgQgVUAKySm4
F2qM9YrVpfwwCHU03tS34YWR7vK9BQfhOnEwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBv3vRbM8ZaxbDZC/5m9SSIgnwoHpNmM7gz
yj/Dk/9SpfdVpZjkEjPpG19XSzRI0JqBXIMSx2K7A+xxT43QAgfnCr00M9snYGGwS5OSUn436Mmu
FFLOuFgwMGuvWKcoViIdFkhNjeQb1gUMVvLWZnLGr9Xx7VAgFhLItjkTS7uWM6O9JzPw7x7mDDYm
fc+vFIUP1EpjiLMw/HLcuseN2+afpwqeVJi7UCjQ7/RMPri9ePeb/+3jxl4aCH5NfrOeI/WP/FVH
3iVIsfwISjBgOg/S0pMIRtR4r+oYdyfm+5R6DPsw7kgjXluFBa07mYbIQHPdfyNpQQJ/byHhLgGJ
R4aW/ey+efdNRh0DrfU3JEJfHbEB7nhoPkwhotNN+x4FP2ZNDdeg4cFrp463+9SrslKzDX4XdZdC
FSS7thPymukYq4/g4iWbOvIDeotlahza/wNI8aFijYSggRO4VshzjsTDLI0TOmda7dzifeu1P09d
ztIqR0owHr1oCiAiGAa4bMHEHxd7DbJgtcP7bSyqyCU8qg5UwOaknZ0Cr1YE8CENrbNAVLn1wRSx
CvoKPnkDy50gOz1X91m1InDkrohRUFXV7YwZArlREWBTusl0UYRGIE0T9yxTKqwqddxy/WdqRUXZ
136KpB23kCD/0FNgymJZmLizjig5YtP6yXFedfIXLQAAAAAAAA==


--=-faejZK8MwCv7sSfxNlYE--
