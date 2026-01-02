Return-Path: <kvm+bounces-66949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F44CEEFED
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 17:41:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6527C3009C10
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 16:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBAA2C0F97;
	Fri,  2 Jan 2026 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dMJAamDH"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71540291C33;
	Fri,  2 Jan 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767372101; cv=none; b=HWS67afINbZe04IxqskulRMXDLlULxPjjmzrLDCJ6vT3b9MEu8xMxnx+oXbLkg7iH4pKG1D61toAWATzqTwSJmALlT0duiBzQbp50vnaiWgJj5yqJjN0dvhWbnhGm/icZcx57ywiJWzLzy6YwfsiyrcKRTCPhqndEHWmiXshcIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767372101; c=relaxed/simple;
	bh=5/a6Lsy/D5Wxzb+zjVDb9wcOmyYEPpU2zUn1m69k67s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PtUyjye0y9itGb97N9FDL4PBgtcrqQe/6B1tY/WBKfZcDUB2lwsuM1Bj1jkQqePmBDPNNOLOFHSYkdMi3/yZFFxb+dOC2sePZ+a/b5SY39ZDJsqLjmInzCjMqomJxe52V0JxxJtfY6kXVS4qZWyBmI4dC94hU5rsEtyE79A+1zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dMJAamDH; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fsp1VhPpYZb1dGASRwU5WZIOS6V2+sf0wq+zIAQmtSk=; b=dMJAamDHMVd/hSmg5hL1KlOrq/
	hEXmSqf3e0/YPQ2t8LoTREFJf4UJdM+4MvsBVb2D4emL7fA7LZ7J7kwS9mx4CcSsqtij/PWiKyYxq
	cC3mVKDdc+8kGMP/R+11xs5sbxPsieorQxmzGF3ZSPYULDiBGIiLktjSaPLbsNpSs7USmJu5evjqY
	dXUTWMBC70rFTOToaTueHOfm6RiKBkyeqJ6pAXX4urkj04gLomwNVjDQTw6S9RRY/s8gmABBX38PG
	2L91dA36Wwof3UN/jOUfUfCYViWS4pAJgsNhbmRjv37si4F3scDWJY3mSQxFtdkMpC6VqMMA9oxAe
	lY71YqzA==;
Received: from [172.31.31.240] (helo=u09cd745991455d.ant.amazon.com)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vbiDR-000000062NN-0RXy;
	Fri, 02 Jan 2026 16:41:29 +0000
Message-ID: <179aa29aa9d5baa698171b884bb6fbe66ad5c2b3.camel@infradead.org>
Subject: Re: [PATCH v5 3/3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: David Woodhouse <dwmw2@infradead.org>
To: Khushit Shah <khushit.shah@nutanix.com>, seanjc@google.com, 
	pbonzini@redhat.com, kai.huang@intel.com
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com,  tglx@linutronix.de, jon@nutanix.com,
 shaju.abraham@nutanix.com,  stable@vger.kernel.org
Date: Fri, 02 Jan 2026 16:41:28 +0000
In-Reply-To: <20251229111708.59402-4-khushit.shah@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
	 <20251229111708.59402-4-khushit.shah@nutanix.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-fwQoJZLWYsFrxIprpRpV"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-fwQoJZLWYsFrxIprpRpV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2025-12-29 at 11:17 +0000, Khushit Shah wrote:
> Add two flags for KVM_CAP_X2APIC_API to allow userspace to control suppor=
t
> for Suppress EOI Broadcasts, which KVM completely mishandles. When x2APIC
> support was first added, KVM incorrectly advertised and "enabled" Suppres=
s
> EOI Broadcast, without fully supporting the I/O APIC side of the equation=
,
> i.e. without adding directed EOI to KVM's in-kernel I/O APIC.
>=20
> That flaw was carried over to split IRQCHIP support, i.e. KVM advertised
> support for Suppress EOI Broadcasts irrespective of whether or not the
> userspace I/O APIC implementation supported directed EOIs. Even worse,
> KVM didn't actually suppress EOI broadcasts, i.e. userspace VMMs without
> support for directed EOI came to rely on the "spurious" broadcasts.
>=20
> KVM "fixed" the in-kernel I/O APIC implementation by completely disabling
> support for Suppress EOI Broadcasts in commit 0bcc3fb95b97 ("KVM: lapic:
> stop advertising DIRECTED_EOI when in-kernel IOAPIC is in use"), but
> didn't do anything to remedy userspace I/O APIC implementations.
>=20
> KVM's bogus handling of Suppress EOI Broadcast is problematic when the
> guest relies on interrupts being masked in the I/O APIC until well after
> the initial local APIC EOI. E.g. Windows with Credential Guard enabled
> handles interrupts in the following order:
> =C2=A0 1. Interrupt for L2 arrives.
> =C2=A0 2. L1 APIC EOIs the interrupt.
> =C2=A0 3. L1 resumes L2 and injects the interrupt.
> =C2=A0 4. L2 EOIs after servicing.
> =C2=A0 5. L1 performs the I/O APIC EOI.
>=20
> Because KVM EOIs the I/O APIC at step #2, the guest can get an interrupt
> storm, e.g. if the IRQ line is still asserted and userspace reacts to the
> EOI by re-injecting the IRQ, because the guest doesn't de-assert the line
> until step #4, and doesn't expect the interrupt to be re-enabled until
> step #5.
>=20
> Unfortunately, simply "fixing" the bug isn't an option, as KVM has no way
> of knowing if the userspace I/O APIC supports directed EOIs, i.e.
> suppressing EOI broadcasts would result in interrupts being stuck masked
> in the userspace I/O APIC due to step #5 being ignored by userspace. And
> fully disabling support for Suppress EOI Broadcast is also undesirable, a=
s
> picking up the fix would require a guest reboot, *and* more importantly
> would change the virtual CPU model exposed to the guest without any buy-i=
n
> from userspace.
>=20
> Add KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
> KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST flags to allow userspace to
> explicitly enable or disable support for Suppress EOI Broadcasts. This
> gives userspace control over the virtual CPU model exposed to the guest,
> as KVM should never have enabled support for Suppress EOI Broadcast witho=
ut
> userspace opt-in. Not setting either flag will result in legacy quirky
> behavior for backward compatibility.
>=20
> When KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST is set and using in-kernel
> IRQCHIP mode, KVM will use I/O APIC version 0x20, which includes support
> for the EOI Register.
>=20
> Note, Suppress EOI Broadcasts is defined only in Intel's SDM, not in AMD'=
s
> APM. But the bit is writable on some AMD CPUs, e.g. Turin, and KVM's ABI
> is to support Directed EOI (KVM's name) irrespective of guest CPU vendor.
>=20
> Fixes: 7543a635aa09 ("KVM: x86: Add KVM exit for IOAPIC EOIs")
> Closes: https://lore.kernel.org/kvm/7D497EF1-607D-4D37-98E7-DAF95F099342@=
nutanix.com
> Cc: stable@vger.kernel.org

Do we want the Cc:stable? And if we do we'd want it on all three
patches, surely?=20

> Suggested-by: David Woodhouse <dwmw2@infradead.org>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>

Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>

Although...


> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1229,6 +1229,12 @@ enum kvm_irqchip_mode {
> =C2=A0	KVM_IRQCHIP_SPLIT,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* cr=
eated with KVM_CAP_SPLIT_IRQCHIP */
> =C2=A0};
> =C2=A0
> +enum kvm_suppress_eoi_broadcast_mode {
> +	KVM_SUPPRESS_EOI_BROADCAST_QUIRKED, /* Legacy behavior */


I believe it's cosmetic but I think I'd be slightly happier with an
explicit '=3D 0' on that, as we rely on that field being initialised to
zero with the allocation of struct kvm, don't we?


--=-fwQoJZLWYsFrxIprpRpV
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDEwMjE2NDEy
OFowLwYJKoZIhvcNAQkEMSIEIAjDgGUsdIasL2Fd63qItkYucHO5JnxLjPCaop7TIjEqMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAwNd2IimrZmfN
tRGWsiunPx4iNvZI9bv8wJiDgYjVYGbxjNqLnqGc2gR3YDw1N1/vDCB7cESw7liqXt9GtmY7jDIP
zBuCTZ3NyguIwOp1yOJ2iUnnEqhwyKFMfMLnkSFbPV6OPTPa6BN6x4YK1JVUwYHSXQJ2e5aaOCZs
jI+yQpOwKRoof6Zi0F/P1lIT+/eXsODbRthBWkaRluHjT0ViSruMtPkwTowG4lc+FqX5zqH24ieh
J1R7ENOkqKx3p7hcszbMnK+HlEWj9mopxQUKOeUugx1MKDefz4P/s1KxvT2ERedYBRVrhIkrTn0I
i2fMQAYJq+YxlKXG8b8OWeuRaU2oenPhFdPrSvAraZj3uVgvCwqflxieWCVJnEeoCHt+6JMqTzHH
wuwy0OinhY6KUWn3ZAF+qLGbG+iPVrvYfn4KhYlcvhwcLeNUDkkoEKWCh12U9eWT6qYwhbwH0Gvf
4E/A4fsxxR5HqnFqZAYIBhIUb1Obmyih3ZWtBqHWYwa/3xWflj/E+GcR31Kxne6kifKVPJXXO/FT
0Ko/Brr4WjrTz2sZ7QIOZP7Rp8Z38TkqoO/Ubs3JgGZgWMB5Oqr8kJcrleQf118UirThnVIi0a5X
M0nzlwLSnnaKJEz3B1JMPNBNXvrwuYdWcYoNK2lVXuT/yg6v1Jh5/6QIRw82fv8AAAAAAAA=


--=-fwQoJZLWYsFrxIprpRpV--

