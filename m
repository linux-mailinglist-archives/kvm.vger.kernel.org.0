Return-Path: <kvm+bounces-12023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA8787F213
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89F961F21D91
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 21:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5567C58AAF;
	Mon, 18 Mar 2024 21:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pvtVNYKT"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F5457326;
	Mon, 18 Mar 2024 21:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710797156; cv=none; b=Hm7eBVRFundqkOw8FewAWnLHEJKCCown4nd4B8I1jVxIxDwyRysfBtSN4OW0UGtAIa4lH3ZMY9ms99K/aipjxDxRnVbvEBtE6NfU8AZ1OTT79vDegKYNBl4orcyn1USldXKD6ov+LDlGB68hRy4gephbYRNSQI2IbqNY42aBNFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710797156; c=relaxed/simple;
	bh=TzwvTt+9iCCIJdB1gil3dyZVTfJJJs594zLU5pDv4lQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a5xYAlMTc+tKbJO8yQcOCjmQQzAIP0tn5vLs5NMnTW1ps8ACX4d7Oei+qXb1XMimZAFIv+8gag7ewAAnptIm11fzKl9KLtXNIBk17PRa0OV1lUHzUutxL+cxa9cKRMEc2LXkgaLICX94YrQnVTx82I0KCTAAS9EEayf1E+kAbDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pvtVNYKT; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IcOxEDsgjki4p6f7S8CjydcT2C3C1ZteJLAMD39qZMM=; b=pvtVNYKTB5yJwyZ97m/VJHZIi+
	z+fGRSGnbvoteonFVTvNCTqJbF/VD6Yqh9WmRFdIGkEpcpa+eHkUhw83lXP/GCPMn2+Rz8uo2aZI+
	Uiz0XMb8R0ReKQED0k9JO4Y4koKTeWOuDpwLZ8fHiygDnKGeP6tMTE5VnOY1NgiFZKe20j6O2CwBb
	6JKOG+djt72CcOrro5Qy8tIE0oJ4kGNj2MYNAZ7Yac8y9de2aGQneXwnhjhZ6o4dPiPqNP2Oc7r09
	44YFpK9PA4rgLW9JgUDMJg38pGFnehpu1QdJyBVaki0Xv4XEdI4/GBe+mDT84s/uu+hHBQiprntAV
	eXvRsgPA==;
Received: from [2001:8b0:10b:5:d467:67b2:6675:b6a9] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmKUL-00000000SK4-3mcb;
	Mon, 18 Mar 2024 21:25:46 +0000
Message-ID: <b7561e6d6d357fcd8ec1a1257aaf2f97d971061c.camel@infradead.org>
Subject: Re: [syzbot] [kvm?] WARNING in __kvm_gpc_refresh
From: David Woodhouse <dwmw2@infradead.org>
To: syzbot <syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Cc: paul <paul@xen.org>
Date: Mon, 18 Mar 2024 21:25:45 +0000
In-Reply-To: <0000000000005fa5cc0613f1cebd@google.com>
References: <0000000000005fa5cc0613f1cebd@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-h1YXphzygVT9+ius1U8I"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-h1YXphzygVT9+ius1U8I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2024-03-18 at 09:25 -0700, syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:=C2=A0=C2=A0=C2=A0 277100b3d5fe Merge tag 'block-6.9-20240315=
' of git://git.k..
> git tree:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17c96aa518000=
0
> kernel config:=C2=A0 https://syzkaller.appspot.com/x/.config?x=3D1c666224=
0382da2
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D106a4f72b0474e1=
d1b33
> compiler:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gcc (Debian 12.2.0-14) 12.2=
.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://syzkaller.appspot.com/x/=
repro.syz?x=3D14358231180000
> C reproducer:=C2=A0=C2=A0 https://syzkaller.appspot.com/x/repro.c?x=3D110=
ed231180000
>=20
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7=
bc7510fe41f/non_bootable_disk-277100b3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6872e049b27c/vmlinu=
x-277100b3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/68ec7230df0f/b=
zImage-277100b3.xz

static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsig=
ned long uhva,
                             unsigned long len)
{
        unsigned long page_offset;
        bool unmap_old =3D false;
        unsigned long old_uhva;
        kvm_pfn_t old_pfn;
        bool hva_change =3D false;
        void *old_khva;
        int ret;

        /* Either gpa or uhva must be valid, but not both */
        if (WARN_ON_ONCE(kvm_is_error_gpa(gpa) =3D=3D kvm_is_error_hva(uhva=
)))
                return -EINVAL;

Hm, that comment doesn't match the code. It says "not both", but the
code also catches the "neither" case. I think the gpa is in %rbx and
uhva is in %r12, so this is indeed the 'neither' case.

Is it expected that we can end up with a cache marked active, but with
the address not valid? Maybe through a race condition with deactive? or
more likely than that?

Paul, we should probably add ourselves to MAINTAINERS for pfncache.c

ffffffff810c8650 <__kvm_gpc_refresh>:
ffffffff810c8650:       41 57                   push   %r15
ffffffff810c8652:       41 56                   push   %r14
ffffffff810c8654:       49 89 ce                mov    %rcx,%r14
ffffffff810c8657:       41 55                   push   %r13
ffffffff810c8659:       49 bd ff ff ff ff 7f    movabs $0xffff887fffffffff,=
%r13
ffffffff810c8660:       88 ff ff=20
ffffffff810c8663:       41 54                   push   %r12
ffffffff810c8665:       49 89 d4                mov    %rdx,%r12
ffffffff810c8668:       55                      push   %rbp
ffffffff810c8669:       48 89 fd                mov    %rdi,%rbp
ffffffff810c866c:       53                      push   %rbx
ffffffff810c866d:       48 89 f3                mov    %rsi,%rbx
ffffffff810c8670:       48 83 ec 68             sub    $0x68,%rsp
ffffffff810c8674:       e8 17 9b 80 00          call   ffffffff818d2190 <__=
sanitizer_cov_trace_pc>
ffffffff810c8679:       48 89 de                mov    %rbx,%rsi
ffffffff810c867c:       48 c7 c7 ff ff ff ff    mov    $0xffffffffffffffff,=
%rdi
ffffffff810c8683:       e8 18 96 80 00          call   ffffffff818d1ca0 <__=
sanitizer_cov_trace_const_cmp8>
ffffffff810c8688:       48 83 fb ff             cmp    $0xffffffffffffffff,=
%rbx
ffffffff810c868c:       4c 89 ef                mov    %r13,%rdi
ffffffff810c868f:       4c 89 e6                mov    %r12,%rsi
ffffffff810c8692:       41 0f 94 c7             sete   %r15b
ffffffff810c8696:       e8 05 96 80 00          call   ffffffff818d1ca0 <__=
sanitizer_cov_trace_const_cmp8>
ffffffff810c869b:       4d 39 e5                cmp    %r12,%r13
ffffffff810c869e:       44 89 ff                mov    %r15d,%edi
ffffffff810c86a1:       41 0f 92 c5             setb   %r13b
ffffffff810c86a5:       44 89 ee                mov    %r13d,%esi
ffffffff810c86a8:       e8 a3 94 80 00          call   ffffffff818d1b50 <__=
sanitizer_cov_trace_cmp1>
ffffffff810c86ad:       45 38 ef                cmp    %r13b,%r15b
ffffffff810c86b0:       0f 84 76 15 00 00       je     ffffffff810c9c2c <__=
kvm_gpc_refresh+0x15dc>



> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com
>=20
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5192 at arch/x86/kvm/../../../virt/kvm/pfncache.c:24=
7 __kvm_gpc_refresh+0x15e2/0x2200 arch/x86/kvm/../../../virt/kvm/pfncache.c=
:247
> Modules linked in:
> CPU: 1 PID: 5192 Comm: syz-executor422 Not tainted 6.8.0-syzkaller-11063-=
g277100b3d5fe #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__kvm_gpc_refresh+0x15e2/0x2200 arch/x86/kvm/../../../virt/kvm/=
pfncache.c:247
> Code: 48 c7 c2 a0 5e 02 8b be 5d 03 00 00 48 c7 c7 60 5e 02 8b c6 05 bd 8=
9 7c 0e 01 e8 a9 23 5e 00 e9 31 fb ff ff e8 5f 85 80 00 90 <0f> 0b 90 e9 69=
 f7 ff ff e8 51 85 80 00 48 8b 54 24 40 48 b8 00 00
> RSP: 0018:ffffc9000317f940 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffffffffffffff RCX: ffffffff810c86ad
> RDX: ffff888022360000 RSI: ffffffff810c9c31 RDI: 0000000000000000
> RBP: ffff88802f2c0948 R08: 0000000000000000 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000002 R12: ffff888000000000
> R13: ffff887fffffff01 R14: 0000000000000020 R15: 0000000000000001
> FS:=C2=A0 000055555b2d9380(0000) GS:ffff88806b300000(0000) knlGS:00000000=
00000000
> CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000002fa8a000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> =C2=A0<TASK>
> =C2=A0kvm_gpc_refresh+0x7d/0xe0 arch/x86/kvm/../../../virt/kvm/pfncache.c=
:364
> =C2=A0kvm_setup_guest_pvclock+0x5b/0x6f0 arch/x86/kvm/x86.c:3174
> =C2=A0kvm_guest_time_update+0x935/0xeb0 arch/x86/kvm/x86.c:3313
> =C2=A0vcpu_enter_guest arch/x86/kvm/x86.c:10769 [inline]
> =C2=A0vcpu_run+0x1993/0x4e60 arch/x86/kvm/x86.c:11211
> =C2=A0kvm_arch_vcpu_ioctl_run+0x42e/0x1680 arch/x86/kvm/x86.c:11437
> =C2=A0kvm_vcpu_ioctl+0x5a1/0x1060 arch/x86/kvm/../../../virt/kvm/kvm_main=
.c:4464
> =C2=A0vfs_ioctl fs/ioctl.c:51 [inline]
> =C2=A0__do_sys_ioctl fs/ioctl.c:904 [inline]
> =C2=A0__se_sys_ioctl fs/ioctl.c:890 [inline]
> =C2=A0__x64_sys_ioctl+0x193/0x220 fs/ioctl.c:890
> =C2=A0do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> =C2=A0do_syscall_64+0xd2/0x260 arch/x86/entry/common.c:83
> =C2=A0entry_SYSCALL_64_after_hwframe+0x6d/0x75
> RIP: 0033:0x7fb4618fd069
> Code: 48 83 c4 28 c3 e8 d7 19 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd71e140e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fb4618fd069 RCX: 00007fb4618fd069
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
> RBP: 00007fb46194a07e R08: 00007ffd71e14218 R09: 00007ffd71e14218
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd71e14150
> R13: 00007ffd71e14130 R14: 00007ffd71e14120 R15: 00007fb46194a012
> =C2=A0</TASK>
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ=C2=A0for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status=C2=A0for how to communicate with syzbot.
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
>=20


--=-h1YXphzygVT9+ius1U8I
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwMzE4MjEyNTQ1WjAvBgkqhkiG9w0BCQQxIgQgc3RkTS/5
zKq6v20JbxdddwV1j23aLjATIO9oB1+Rtxcwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBVO6rxYMDN6o+CRozz+9Kbnn1Q4QLUxLSj
Ed7Kok1SE9XE7tdAlKiq5TnUdtdh13wjA4MJM7l4LQHeu9Y2fchUF5SHl8Z+Em/V+jdPZQ/7UTTg
9nwk6mgqmCotbMXjdhz/CuyNRNxfoYXM0qivhFRxDFLVjHAB/NBxXiwSfYb9olTqPs6e3bmFfhwk
8yXqxJhlZELAe85L4nXVQ+gKAQgAc5KyLonnfBHXKACkglsPlA18n8RzucwIfj/A6voFs6bXbifL
wSO+CJNdO+EpOH4RhA8VVOS7c9CaWdIB9od42qG70r1hhvM5eh5YrjPZgLY7pux/8uKeSjm1r2tR
I1Mm6ti2jLbemQrDZEkfkMOY2fInoMwHLz9qq87nVb06mMykQOipo+hhgQxgiudhCtDMOfdBpkY8
BUSqeEOIgXofGdBHtoCGkGtjJw4ECNSxzsFFpk9qB/OPa9LiLIoUBNvbR861+lx06n0gubjrtwtF
f18e0NS7f+x7g9ulwAqr6S1n1c75PUZITqBtA98lKfQdF2ljjHMGTKnzyVKOn2JLO7M3c1x4WQL6
lkeTjMZRJWV+/s/y5aa/I077TKEty+appmdRCqhaqkGVtBI0HuebDgmgqeB8GbkmJqGVPCT35nYq
rR17fXQLBB/bA19S2o53+73wSfWhASW8Y8QsHBor2gAAAAAAAA==


--=-h1YXphzygVT9+ius1U8I--

