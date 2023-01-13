Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E589B669429
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 11:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbjAMKdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 05:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbjAMKdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 05:33:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD4B17423;
        Fri, 13 Jan 2023 02:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1rgoOUjXtpYcWXEy1lLUFpE40E7NnQoz12WECeLjv5U=; b=MOxhz+TOr799cqlR5kKt3WzGzN
        24X649wq3+CVfCgy3NRsF9xnil5uDE8170wwCzFzs0y+bdZ6iROy56IwhO7VHvOWpdC8X7E+3rzes
        hKeqZk1qS7cmysbpGboqJsqhAON5bDGy6Usq7TpkiGx3OFVsR+RqXki+loW6lKDn+OpXzIjLqZNYr
        2GGaBCwc+pw9iGlT9siBcrWmnFZQ364I53jRQrYyn8ogpAdXs/fUBXPrRvda24pRj96FX6sVle862
        hsdRFK6LNYIlSPErRn38TT7gYKxmpLDTiCpfBy6ux3EzBSVTgjxXK6Tktxuc57rWqj+KOF0Qy7VJC
        EQCUerIg==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGHNa-0060Wd-MP; Fri, 13 Jan 2023 10:33:46 +0000
Message-ID: <023e131b3de80c4bc2b6711804a4769466b90c6f.camel@infradead.org>
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
Date:   Fri, 13 Jan 2023 10:33:33 +0000
In-Reply-To: <d1d44f07-558c-e0ed-403e-61a854c868cb@redhat.com>
References: <20230111183031.2449668-1-pbonzini@redhat.com>
         <a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org>
         <20230112152048.GJ4028633@paulmck-ThinkPad-P17-Gen-1>
         <Y8EF24o932lcshKs@boqun-archlinux>
         <d1d44f07-558c-e0ed-403e-61a854c868cb@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-R07t1ZgzRZNOXGItP/As"
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


--=-R07t1ZgzRZNOXGItP/As
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-01-13 at 10:20 +0100, Paolo Bonzini wrote:
> On 1/13/23 08:18, Boqun Feng wrote:
> > On Thu, Jan 12, 2023 at 07:20:48AM -0800, Paul E. McKenney wrote:
> > > On Thu, Jan 12, 2023 at 08:24:16AM +0000, David Woodhouse wrote:
> > > > On Wed, 2023-01-11 at 13:30 -0500, Paolo Bonzini wrote:
> > > > >=20
> > > > > +- ``synchronize_srcu(&kvm->srcu)`` is called inside critical sec=
tions
> > > > > +=C2=A0 for kvm->lock, vcpu->mutex and kvm->slots_lock.=C2=A0 The=
se locks _cannot_
> > > > > +=C2=A0 be taken inside a kvm->srcu read-side critical section; t=
hat is, the
> > > > > +=C2=A0 following is broken::
> > > > > +
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 srcu_read_lock(&kvm->srcu);
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&kvm->slots_lock);
> > > > > +
> > > >=20
> > > > "Don't tell me. Tell lockdep!"
> > > >=20
> > > > Did we conclude in
> > > > https://lore.kernel.org/kvm/122f38e724aae9ae8ab474233da1ba19760c20d=
2.camel@infradead.org/
> > > > that lockdep *could* be clever enough to catch a violation of this =
rule
> > > > by itself?
> > > >=20
> > > > The general case of the rule would be that 'if mutex A is taken in =
a
> > > > read-section for SCRU B, then any synchronize_srcu(B) while mutex A=
 is
> > > > held shall be verboten'. And vice versa.
> > > >=20
> > > > If we can make lockdep catch it automatically, yay!
> > >=20
> > > Unfortunately, lockdep needs to see a writer to complain, and that pa=
tch
> > > just adds a reader.=C2=A0 And adding that writer would make lockdep c=
omplain
> > > about things that are perfectly fine.=C2=A0 It should be possible to =
make
> > > lockdep catch this sort of thing, but from what I can see, doing so
> > > requires modifications to lockdep itself.
> > >=20
> >=20
> > Please see if the follow patchset works:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0https://lore.kernel.org=
/lkml/20230113065955.815667-1-boqun.feng@gmail.com
> >=20
> > "I have been called. I must answer. Always." ;-)

Amazing! Thank you, Boqun!

> It's missing an important testcase; if it passes (does not warn), then=
=20
> it should work:

I think it does.

I started with kvm/master from
https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dmaster so that
lockdep didn't find other things to complain about first. I then:

 =E2=80=A2 Dropped the last two commits, putting us back to using kvm->lock=
 and
   removing the dummy mutex lock that would have told lockdep that it's
   a (different) problem.

 =E2=80=A2 I then added Boqun's three commits

 =E2=80=A2 Reverted a79b53aa so that the srcu_synchronize() deadlock return=
s

 =E2=80=A2 Couldn't reproduce with xen_shinfo_test, so added Michal's test =
from
   https://lore.kernel.org/kvm/15599980-bd2e-b6c2-1479-e1eef02da0b5@rbox.co=
/

The resulting tree is at
https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/kvm-src=
u-lockdep


Now when I run tools/testing/selftests/kvm/x86_64/deadlocks_test I do
see lockdep complain about it (shown below; I have a cosmetic
nit/request to make). If I restore the evtchn_reset fix then it also
complains about kvm_xen_set_evtchn() vs. kvm_xen_kvm_set_attr(), and if
I restore the xen_lock fix from the tip of kvm/master then Michal's
deadlock_test passes and there are no complaints.

So everything seems to be working as it should... *except* for the fact
that I don't quite understand why xen_shinfo_test didn't trigger the
warning. Michal, I guess you already worked that out when you came up
with your deadlock-test instead... is there something we should add to
xen_shinfo_test that would mean it *would* have triggered? I even tried
this:

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1173,6 +1173,16 @@ static struct kvm *kvm_create_vm(unsigned long type,=
 const char *fdname)
        if (init_srcu_struct(&kvm->irq_srcu))
                goto out_err_no_irq_srcu;
=20
+#ifdef CONFIG_LOCKDEP
+       /*
+        * Ensure lockdep knows that it's not permitted to lock kvm->lock
+        * from a SRCU read section on kvm->srcu.
+        */
+       mutex_lock(&kvm->lock);
+       synchronize_srcu(&kvm->srcu);
+       mutex_unlock(&kvm->lock);
+#endif
+
        refcount_set(&kvm->users_count, 1);
        for (i =3D 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
                for (j =3D 0; j < 2; j++) {




> [  845.474169] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  845.474170] WARNING: possible circular locking dependency detected
> [  845.474172] 6.2.0-rc3+ #1025 Tainted: G            E    =20
> [  845.474175] ------------------------------------------------------
> [  845.474176] deadlocks_test/22767 is trying to acquire lock:
> [  845.474178] ffffc9000ba4b868 (&kvm->srcu){.+.+}-{0:0}, at: __synchroni=
ze_srcu+0x5/0x170
> [  845.474192]=20
>                but task is already holding lock:
> [  845.474194] ffffc9000ba423c0 (&kvm->lock){+.+.}-{3:3}, at: kvm_vm_ioct=
l_set_msr_filter+0x188/0x220 [kvm]
> [  845.474319]=20
>                which lock already depends on the new lock.

So the above part is good, and clearly tells me it was synchronize_srcu()

> [  845.474320]=20
>                the existing dependency chain (in reverse order) is:
> [  845.474322]=20
>                -> #1 (&kvm->lock){+.+.}-{3:3}:
> [  845.474327]        __lock_acquire+0x4b4/0x940
> [  845.474333]        lock_acquire.part.0+0xa8/0x210
> [  845.474337]        __mutex_lock+0x94/0x920
> [  845.474344]        kvm_xen_set_evtchn.part.0+0x6d/0x170 [kvm]
> [  845.474437]        kvm_xen_inject_timer_irqs+0x79/0xa0 [kvm]
> [  845.474529]        vcpu_run+0x20c/0x450 [kvm]
> [  845.474618]        kvm_arch_vcpu_ioctl_run+0x1df/0x670 [kvm]
> [  845.474707]        kvm_vcpu_ioctl+0x279/0x700 [kvm]
> [  845.474783]        __x64_sys_ioctl+0x8a/0xc0
> [  845.474787]        do_syscall_64+0x3b/0x90
> [  845.474796]        entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  845.474804]=20
>                -> #0 (&kvm->srcu){.+.+}-{0:0}:
> [  845.474809]        check_prev_add+0x8f/0xc20
> [  845.474812]        validate_chain+0x3ba/0x450
> [  845.474814]        __lock_acquire+0x4b4/0x940
> [  845.474817]        lock_sync+0x99/0x110
> [  845.474820]        __synchronize_srcu+0x4d/0x170
> [  845.474824]        kvm_vm_ioctl_set_msr_filter+0x1a5/0x220 [kvm]
. [  845.474907]        kvm_arch_vm_ioctl+0x8df/0xd50 [kvm]
> [  845.474997]        kvm_vm_ioctl+0x5ca/0x800 [kvm]
> [  845.475075]        __x64_sys_ioctl+0x8a/0xc0
> [  845.475079]        do_syscall_64+0x3b/0x90
> [  845.475084]        entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  845.475089]=20
>                other info that might help us debug this:
>
> [  845.475091]  Possible unsafe locking scenario:
>
> [  845.475092]        CPU0                    CPU1
> [  845.475093]        ----                    ----
> [  845.475095]   lock(&kvm->lock);
> [  845.475098]                                lock(&kvm->srcu);
> [  845.475101]                                lock(&kvm->lock);
> [  845.475103]   lock(&kvm->srcu);
> [  845.475106]=20
>                 *** DEADLOCK ***

But is there any chance the above could say 'synchronize_srcu' and
'read_lock_srcu' in the appropriate places?

> [  845.475108] 1 lock held by deadlocks_test/22767:
> [  845.475110]  #0: ffffc9000ba423c0 (&kvm->lock){+.+.}-{3:3}, at: kvm_vm=
_ioctl_set_msr_filter+0x188/0x220 [kvm]
> [  845.475200]=20
>                stack backtrace:
> [  845.475202] CPU: 10 PID: 22767 Comm: deadlocks_test Tainted: G        =
    E      6.2.0-rc3+ #1025
> [  845.475206] Hardware name: Intel Corporation S2600CW/S2600CW, BIOS SE5=
C610.86B.01.01.0008.021120151325 02/11/2015
> [  845.475208] Call Trace:
> [  845.475210]  <TASK>
> [  845.475214]  dump_stack_lvl+0x56/0x73
> [  845.475221]  check_noncircular+0x102/0x120
> [  845.475229]  ? check_noncircular+0x7f/0x120
> [  845.475236]  check_prev_add+0x8f/0xc20
> [  845.475239]  ? add_chain_cache+0x10b/0x2d0
> [  845.475244]  validate_chain+0x3ba/0x450
> [  845.475249]  __lock_acquire+0x4b4/0x940
> [  845.475253]  ? __synchronize_srcu+0x5/0x170
> [  845.475258]  lock_sync+0x99/0x110
> [  845.475261]  ? __synchronize_srcu+0x5/0x170
> [  845.475265]  __synchronize_srcu+0x4d/0x170
? [  845.475269]  ? mark_held_locks+0x49/0x80
> [  845.475272]  ? _raw_spin_unlock_irqrestore+0x2d/0x60
> [  845.475278]  ? __pfx_read_tsc+0x10/0x10
> [  845.475286]  ? ktime_get_mono_fast_ns+0x3d/0x90
> [  845.475292]  kvm_vm_ioctl_set_msr_filter+0x1a5/0x220 [kvm]
> [  845.475380]  kvm_arch_vm_ioctl+0x8df/0xd50 [kvm]
> [  845.475472]  ? __lock_acquire+0x4b4/0x940
> [  845.475485]  kvm_vm_ioctl+0x5ca/0x800 [kvm]
> [  845.475566]  ? lockdep_unregister_key+0x76/0x110
> [  845.475575]  __x64_sys_ioctl+0x8a/0xc0
> [  845.475579]  do_syscall_64+0x3b/0x90
> [  845.475586]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  845.475591] RIP: 0033:0x7f79de23fd1b
> [  845.475595] Code: 73 01 c3 48 8b 0d 05 a1 1b 00 f7 d8 64 89 01 48 83 c=
8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 a0 1b 00 f7 d8 64 89 01 48
> [  845.475598] RSP: 002b:00007f79ddff7c98 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
> [  845.475602] RAX: ffffffffffffffda RBX: 00007f79ddff8640 RCX: 00007f79d=
e23fd1b
> [  845.475605] RDX: 00007f79ddff7ca0 RSI: 000000004188aec6 RDI: 000000000=
0000004
> [  845.475607] RBP: 00007f79ddff85c0 R08: 0000000000000000 R09: 00007fffc=
eb1ff2f
> [  845.475609] R10: 0000000000000008 R11: 0000000000000246 R12: 00007f79d=
dff7ca0
> [  845.475611] R13: 0000000001c322a0 R14: 00007f79de2a05f0 R15: 000000000=
0000000
> [  845.475617]  </TASK>



--=-R07t1ZgzRZNOXGItP/As
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMTEzMTAzMzMzWjAvBgkqhkiG9w0BCQQxIgQgXQAtwnM7
We7DjBHc/YOUNTBhHDp6Ci6LLzN5c+XMK+wwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCss4Id0pKSreyZUE/kOBAYDaGpgATCvWms
HkEzq+G1zcGu+8MFvP0+B9TviKXMvTc7DrVoHLDjseBVuw+qUcZ+mlsbTMm1sc98yrKNpG7PrEN/
ugg1tcSERCgjwb9qWw5tmAOlFn99WAW3DFpWj6bDEl4nB4qLSMXNjcG9QQp4irQF65T+G4ziLNaN
zK9nQmv69eTFAD9M1PxcSFiI212PrvzzHl/CjpDH9G4Xm0AVfb6OMtuJIBT91vQZot0APPnEID0D
Z3yMUMGYPj0c9mPyo6eNYXCxJ3TAhHiswPncocZowoWjfR/82+25eZymllMTkrCYud03ZHC24egB
xF4u/R1dDfUsA9OTwMM4qgOGyXydZfNqP4q6VwASuVmjTY8LqeaOTss/qyGnLeoQUOSXYToLh5TT
vpmuU8nONulNv9FAmuiukbdOD646wsvk71x6j6uv4Pf6iijLmj8Rmwgkg15dI1Bth0qrNZaRBVFP
F8iMs6LVuxcyov1MFRJl73guHLFsG4XfsjogVRzfdZl48H97FOR8U2FHELlyLFKmVdB5Xf1RjjwN
yEU0aYH1GwTvGPFptTIdERAYFPleM7ZEsYmulnUtjkyf0vj3IhwD7cYLTzPtn3fGfiOvkQ9PWZ21
Ue5rGlk6Xt6T1Id7GiKcnfAs8AQPsgsfols/HHFgnwAAAAAAAA==


--=-R07t1ZgzRZNOXGItP/As--
