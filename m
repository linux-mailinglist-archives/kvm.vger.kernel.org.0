Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1500A664CBF
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 20:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjAJTq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 14:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjAJTqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 14:46:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BCC13D02
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 11:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BKoF2aIH6F7bDssyMpOzh8nWr46dxXYEHvqOjND35b4=; b=KGHgrPp/7WhDS8uCMS7KZ5r8XI
        JZcehYiSzSWOviA/aIr564lg/ubhv1e//hrE7ObY9DpQBmJFcyW2MRKgIK3k/bX2zFWsMwZtU2G/7
        SXHIZdRT5QFtx5E80ABs3UuagENQRX/WVJB/2M3k6eruLZUBzEqAMsktALpwf/+vPdZ522DGVanyl
        Waxkm8aMogeXClPERxbQMb0nKTdSiyc81mJuNjFKN0ghtjeMUINmN0TBvqrq1sGcD/XYXtEoPLhVh
        sGd9FrvKdJ/gyr9ZqSQ2AXD2w/gn6FHyOrfdX32fWRWymYFE8YYxCuruaJyl1gKNUXZTbsvfkVbRI
        CdwiW7Dg==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFKZq-003UR7-QU; Tue, 10 Jan 2023 19:46:30 +0000
Message-ID: <8b3741992e2d32659b8d119f3eb6aa777bca0f96.camel@infradead.org>
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org, paul@xen.org,
        Peter Zijlstra <peterz@infradead.org>
Date:   Tue, 10 Jan 2023 19:46:16 +0000
In-Reply-To: <Y72+ZVwp5Gxy4asX@google.com>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
         <20221229211737.138861-1-mhal@rbox.co>
         <20221229211737.138861-2-mhal@rbox.co> <Y7RjL+0Sjbm/rmUv@google.com>
         <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
         <Y7dN0Negds7XUbvI@google.com>
         <3a4ab7b0-67f3-f686-0471-1ae919d151b5@redhat.com>
         <f3b61f1c0b92af97a285c9e05f1ac99c1940e5a9.camel@infradead.org>
         <9cd3c43b-4bfe-cf4e-f97e-a0c840574445@redhat.com>
         <825aef8e14c1aeaf1870ac3e1510a6e1fe71129d.camel@infradead.org>
         <Y72+ZVwp5Gxy4asX@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-IxJ9L9xdmUNQkHp7DkIL"
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


--=-IxJ9L9xdmUNQkHp7DkIL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-01-10 at 19:37 +0000, Sean Christopherson wrote:
> No idea about the splat below, but kvm_vcpu_init() doesn't run under kvm-=
>lock,
> so I wouldn't expect this to do anything.

Ah, good point. I think I misread kvm_vm_ioctl_create_vcpu() *dropping*
kvm->lock a few lines above calling kvm_vcpu_init().

This one gives me the splat I was *expecting*. But Paolo said he had a
patch for that and now the other one is *much* more interesting...


--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3924,6 +3924,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm,=
 u32 id)
        }
=20
        mutex_lock(&kvm->lock);
+
+       /* Ensure that lockdep knows vcpu->mutex is taken *inside* kvm->loc=
k */
+       mutex_lock(&vcpu->mutex);
+       mutex_unlock(&vcpu->mutex);
+
        if (kvm_get_vcpu_by_id(kvm, id)) {
                r =3D -EEXIST;
                goto unlock_vcpu_destroy;


[  111.042398] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  111.042400] WARNING: possible circular locking dependency detected
[  111.042402] 6.1.0-rc4+ #1024 Tainted: G          I E    =20
[  111.042405] ------------------------------------------------------
[  111.042406] xen_shinfo_test/11035 is trying to acquire lock:
[  111.042409] ffffc900017803c0 (&kvm->lock){+.+.}-{3:3}, at: kvm_xen_vcpu_=
set_attr+0x2a/0x4f0 [kvm]
[  111.042494]=20
               but task is already holding lock:
[  111.042496] ffff88828f9600b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_io=
ctl+0x77/0x700 [kvm]
[  111.042547]=20
               which lock already depends on the new lock.

[  111.042548]=20
               the existing dependency chain (in reverse order) is:
[  111.042550]=20
               -> #1 (&vcpu->mutex){+.+.}-{3:3}:
[  111.042554]        __lock_acquire+0x4b4/0x940
[  111.042561]        lock_acquire.part.0+0xa8/0x210
[  111.042564]        __mutex_lock+0x94/0x920
[  111.042571]        kvm_vm_ioctl_create_vcpu+0x1c1/0x4b0 [kvm]
[  111.042618]        kvm_vm_ioctl+0x565/0x7f0 [kvm]
[  111.042664]        __x64_sys_ioctl+0x8a/0xc0
[  111.042669]        do_syscall_64+0x3b/0x90
[  111.042674]        entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  111.042679]=20
               -> #0 (&kvm->lock){+.+.}-{3:3}:
[  111.042683]        check_prev_add+0x8f/0xc20
[  111.042687]        validate_chain+0x3ba/0x450
[  111.042690]        __lock_acquire+0x4b4/0x940
[  111.042693]        lock_acquire.part.0+0xa8/0x210
[  111.042696]        __mutex_lock+0x94/0x920
[  111.042700]        kvm_xen_vcpu_set_attr+0x2a/0x4f0 [kvm]
[  111.042764]        kvm_arch_vcpu_ioctl+0x817/0x12a0 [kvm]
[  111.042817]        kvm_vcpu_ioctl+0x519/0x700 [kvm]
[  111.042862]        __x64_sys_ioctl+0x8a/0xc0
[  111.042865]        do_syscall_64+0x3b/0x90
[  111.042869]        entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  111.042873]=20
               other info that might help us debug this:

[  111.042875]  Possible unsafe locking scenario:

[  111.042876]        CPU0                    CPU1
[  111.042878]        ----                    ----
[  111.042879]   lock(&vcpu->mutex);
[  111.042882]                                lock(&kvm->lock);
[  111.042884]                                lock(&vcpu->mutex);
[  111.042887]   lock(&kvm->lock);
[  111.042889]=20
                *** DEADLOCK ***

[  111.042891] 1 lock held by xen_shinfo_test/11035:
[  111.042893]  #0: ffff88828f9600b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vc=
pu_ioctl+0x77/0x700 [kvm]
[  111.042943]=20
               stack backtrace:
[  111.042946] CPU: 23 PID: 11035 Comm: xen_shinfo_test Tainted: G         =
 I E      6.1.0-rc4+ #1024
[  111.042949] Hardware name: Intel Corporation S2600CW/S2600CW, BIOS SE5C6=
10.86B.01.01.0008.021120151325 02/11/2015
[  111.042952] Call Trace:
[  111.042954]  <TASK>
[  111.042957]  dump_stack_lvl+0x56/0x73
[  111.042963]  check_noncircular+0x102/0x120
[  111.042970]  check_prev_add+0x8f/0xc20
[  111.042973]  ? add_chain_cache+0x10b/0x2d0
[  111.042976]  ? _raw_spin_unlock_irqrestore+0x2d/0x60
[  111.042982]  validate_chain+0x3ba/0x450
[  111.042986]  __lock_acquire+0x4b4/0x940
[  111.042991]  lock_acquire.part.0+0xa8/0x210
[  111.042995]  ? kvm_xen_vcpu_set_attr+0x2a/0x4f0 [kvm]
[  111.043061]  ? rcu_read_lock_sched_held+0x43/0x70
[  111.043067]  ? lock_acquire+0x102/0x140
[  111.043072]  __mutex_lock+0x94/0x920
[  111.043077]  ? kvm_xen_vcpu_set_attr+0x2a/0x4f0 [kvm]
[  111.043141]  ? __lock_acquire+0x4b4/0x940
[  111.043145]  ? kvm_xen_vcpu_set_attr+0x2a/0x4f0 [kvm]
[  111.043209]  ? kvm_xen_vcpu_set_attr+0x2a/0x4f0 [kvm]
[  111.043271]  ? vmx_vcpu_load+0x27/0x40 [kvm_intel]
[  111.043286]  kvm_xen_vcpu_set_attr+0x2a/0x4f0 [kvm]
[  111.043349]  ? kvm_arch_vcpu_load+0x66/0x200 [kvm]
[  111.043405]  kvm_arch_vcpu_ioctl+0x817/0x12a0 [kvm]
[  111.043464]  ? trace_contention_end+0x2d/0xd0
[  111.043475]  kvm_vcpu_ioctl+0x519/0x700 [kvm]
[  111.043525]  ? do_user_addr_fault+0x1fa/0x6b0
[  111.043532]  ? do_user_addr_fault+0x1fa/0x6b0
[  111.043538]  __x64_sys_ioctl+0x8a/0xc0
[  111.043544]  do_syscall_64+0x3b/0x90
[  111.043549]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  111.043554] RIP: 0033:0x7f485cc3fd1b
[  111.043558] Code: 73 01 c3 48 8b 0d 05 a1 1b 00 f7 d8 64 89 01 48 83 c8 =
ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 a0 1b 00 f7 d8 64 89 01 48
[  111.043561] RSP: 002b:00007ffe8726c018 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  111.043565] RAX: ffffffffffffffda RBX: 00007f485d027000 RCX: 00007f485cc=
3fd1b
[  111.043568] RDX: 00007ffe8726c160 RSI: 000000004048aecb RDI: 00000000000=
00007
[  111.043570] RBP: 00007f485cff26c0 R08: 00000000004188f0 R09: 00000000000=
00000
[  111.043573] R10: 0000000000000012 R11: 0000000000000246 R12: 00000000000=
00010
[  111.043575] R13: 000000002645a922 R14: 63bdc02500000002 R15: 00000000021=
082a0
[  111.043581]  </TASK>


--=-IxJ9L9xdmUNQkHp7DkIL
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMTEwMTk0NjE2WjAvBgkqhkiG9w0BCQQxIgQg2XQneC67
SGh74AYePHsBUUT0zQQUzPwdzpbNpjBZc0swgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAaz6Zxy92POrOxxAA1MX927I698t5bH/Qt
en970pct+vLQ39YaJxbOaSec87T/XY1/uvJ/M1053SFQ+rvI16Vhhj1IpGYTFC4sGYVK8QHGat8n
WHpH1N3I+2ggEWyM2dXGYdUl7PjI0owvyAxKFUD7It1K4+Cyqe5Yu6Q8/NWLINWaGxKjFhx9KSWt
cJlVqMiTBT45tCv4befPHH0QzEsa0Wc9yQL7QdtjKcOj9XOldXZZAHoWxR9FQNiMcrsu1QE21DCm
3zmnbVQbJ0L0KEc2sdMIV0cyXqPoGEQeA9dixSwyKnrtIYUjXctzBKIQox0hYgK6ZLzvz49xbJ5e
CpkEI8bolK1TXurXgltD1gA1JpzRoRAvk//6HKp1Tr4tr0mb4GUja+2ufLrPLf+VRttYI4uCERUR
2bP7m0VQDI3Sv7k/2/vqjSHGEVMaQSIH+MB+l9Mos7yqV/kLhPWvihWpEUFRm/UrGURs+K30j/rZ
04iMsW8umezJWqghkF1O6XZiVeroYDGwY3IXIWf8ZcQiX4vWYhfCc/06Ei6A+JJ6u4rxdl89EXRq
vE2+kwFTEZIq8IUqXc5wb+AGLZA6fNEbpOHaVZQGR8MaYFe3+8eKUQGTKea8CYDFjyR3bP/ihO9M
QQqaCclLsNU3qqsnmkW+lJE5yQc2eOH5Rm/BCToSxAAAAAAAAA==


--=-IxJ9L9xdmUNQkHp7DkIL--
