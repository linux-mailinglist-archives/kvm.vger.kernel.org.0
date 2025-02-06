Return-Path: <kvm+bounces-37517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F3B6A2AE28
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 17:51:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5A0D3A397A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79FC613EFE3;
	Thu,  6 Feb 2025 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rhYapGNy"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413A223536E;
	Thu,  6 Feb 2025 16:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738860682; cv=none; b=Wa6szN5p2zw5IWWux37krEWcHSc5thmmMTu9serOvi0etbb3RtiPZ3aLNEVBBzEJlr6z1mfRcK+Wn7yLSU8pfeUFM87abcl0Hc8fTZB3j21T2+ESA/AXpKz74/gUe8w4aUWE4aWXMapMolXoFR1PzgyyPPybPlMqO6xpmHl5nCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738860682; c=relaxed/simple;
	bh=NipMCG/wa0uK2gMq/NrgWDKhD910nUEthHcSXyVr08c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c1rZmczGKuGkW8gmj5X6FWHEqTtXC+WuJSFo8QUExjL77aHTwAFdfIowvAG21cFSxcIPXvs7ycXPAs068mc3zsPDTWSR791+alwLiC5AYju03FwCGeE2JQ9X9Z8Fw32h7IxmWxh/JIatZ0fBIHggWx6Y69ffQzU6VPYmbkRqQVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rhYapGNy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NipMCG/wa0uK2gMq/NrgWDKhD910nUEthHcSXyVr08c=; b=rhYapGNylX1URiruQVi1lS0hNm
	tsJBhO/yMIP9cZIF8rid7NmNDksYc+cDt0kpxal+1+x9x/+Y9chMI+lR/Y6ovzAWmwqBMsD3z/xkN
	Qb8rS0fjCgNCcIURhrEhX2SEMckK/cM6TzmzJ2MZGtJmxDqLLyk6/uiisnuJyiS+QCtkyMhK7zZQ2
	WnT0DTHBWFyW/qEkgPU0Sh/xH291Xea7DN+0AfTfhB/sJG30p0mozzbx6y1y/JT57w1Zbeh3FkVul
	QyuL1DywIElZfPP9om2WuUTjIM5jPqI7Zmoi0Qvs3wGxo5vMtOdBPe0gO8F3AiRNVKGAl/SBU93oj
	Cw2IEmgQ==;
Received: from [54.239.6.187] (helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tg55y-00000006HQX-11Ks;
	Thu, 06 Feb 2025 16:51:18 +0000
Message-ID: <2ca93bb7f577e206226e7201741ec832a45d226a.camel@infradead.org>
Subject: Re: [PATCH 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, Joao Martins
	 <joao.m.martins@oracle.com>
Date: Thu, 06 Feb 2025 16:51:17 +0000
In-Reply-To: <20250201011400.669483-2-seanjc@google.com>
References: <20250201011400.669483-1-seanjc@google.com>
	 <20250201011400.669483-2-seanjc@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-KtCCnDt2lk1j11C8XbOm"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-KtCCnDt2lk1j11C8XbOm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2025-01-31 at 17:13 -0800, Sean Christopherson wrote:
> Reject userspace attempts to set the Xen hypercall page MSR to an index
> outside of the "standard" virtualization range [0x40000000, 0x4fffffff],
> as KVM is not equipped to handle collisions with real MSRs, e.g. KVM
> doesn't update MSR interception, conflicts with VMCS/VMCB fields, special
> case writes in KVM, etc.
>=20
> Allowing userspace to redirect any MSR write can also be used to attack
> the kernel, as kvm_xen_write_hypercall_page() takes multiple locks and
> writes to guest memory.=C2=A0 E.g. if userspace sets the MSR to MSR_IA32_=
XSS,
> KVM's write to MSR_IA32_XSS during vCPU creation will trigger an SRCU
> violation due to writing guest memory:
>=20
> =C2=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> =C2=A0 WARNING: suspicious RCU usage
> =C2=A0 6.13.0-rc3
> =C2=A0 -----------------------------
> =C2=A0 include/linux/kvm_host.h:1046 suspicious rcu_dereference_check() u=
sage!
>=20
> =C2=A0 stack backtrace:
> =C2=A0 CPU: 6 UID: 1000 PID: 1101 Comm: repro Not tainted 6.13.0-rc3
> =C2=A0 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/=
06/2015
> =C2=A0 Call Trace:
> =C2=A0=C2=A0 <TASK>
> =C2=A0=C2=A0 dump_stack_lvl+0x7f/0x90
> =C2=A0=C2=A0 lockdep_rcu_suspicious+0x176/0x1c0
> =C2=A0=C2=A0 kvm_vcpu_gfn_to_memslot+0x259/0x280
> =C2=A0=C2=A0 kvm_vcpu_write_guest+0x3a/0xa0
> =C2=A0=C2=A0 kvm_xen_write_hypercall_page+0x268/0x300
> =C2=A0=C2=A0 kvm_set_msr_common+0xc44/0x1940
> =C2=A0=C2=A0 vmx_set_msr+0x9db/0x1fc0
> =C2=A0=C2=A0 kvm_vcpu_reset+0x857/0xb50
> =C2=A0=C2=A0 kvm_arch_vcpu_create+0x37e/0x4d0
> =C2=A0=C2=A0 kvm_vm_ioctl+0x669/0x2100
> =C2=A0=C2=A0 __x64_sys_ioctl+0xc1/0xf0
> =C2=A0=C2=A0 do_syscall_64+0xc5/0x210
> =C2=A0=C2=A0 entry_SYSCALL_64_after_hwframe+0x4b/0x53
> =C2=A0 RIP: 0033:0x7feda371b539
>=20
> While the MSR index isn't strictly ABI, i.e. can theoretically float to
> any value, in practice no known VMM sets the MSR index to anything other
> than 0x40000000 or 0x40000200.
>=20
> Reported-by: syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/679258d4.050a0220.2eae65.000a.GAE@goo=
gle.com
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Paul Durrant <paul@xen.org>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

With macros for the magic numbers as discussed (and a corresponding
update to the documentation), and with the Reported-by: and Closes:
tags dropped because they should move to the commit which makes the
hypercall page only trigger for !host_initiated writes and resolves it
in a more future-proof way for the general case,

Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>

--=-KtCCnDt2lk1j11C8XbOm
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDIwNjE2NTEx
N1owLwYJKoZIhvcNAQkEMSIEIIBkzzezKSlW9odMfeI1LAgFZ2QMkmuxWuSTpFYE6f7bMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIA2j96qAsTUYz6
rcBCHDAyLQ8P6nkUzBTvK8R95sKspF0SuTLsDbWB1Vjq9mify0ZmnPO8RCxEExu9ELHLSNjn7xqB
a4NbXzccTbeVj3WrB9CCbcLpBURFho4FjygCyXwjKq92RgsPHf6bivffwx4Tmgn+cVkRSokOq1Wf
c1X++d9ev/MvAM1qAccyzr3+ON6uQuUTTYLAeBwHMoQPTJwE5jaW4aUBgi9pT8aA/PW/RMjAF5lV
4lfPWE27kWdplGOf2xHIj25tTaF2RCjEYkNwwhgNUGdsx3z19NtDui822S6Fq4O0GCm17q4JSpUS
w1pbZ+zIGD1FhvqfhrFAv8eFcSdGIqLiHXGVDStojqQ99/MEEGjSSlVz7PZsSip1EqAvUkUHj2Hx
gEa0riCkDs+MpXgVqU/Std6T/DGsb34xSY9Ok8sPIXgbrJrauPL0Qc4kSNTHZwORTK6lzgYgHXmi
rR2ljTHG0BD1trzM4b20LCiJTaG45YBBqn88dErx0Tr6MUV1F/D9tNkkMTQGBgu6P1adlzPyEf62
Bs74Iwgvx6Vq2UvOWgvKN2MOr7zFwilccjNtvUH0ylkEOkGBkvKNRMyrPWmoKywLeDeMu7bdJPuF
YWpVtm1ylLM7HEAnYlh0Q/IcvC61IA5lma99ksnFuiivbp8Zt0HXVKW4kCyFkPIAAAAAAAA=


--=-KtCCnDt2lk1j11C8XbOm--

