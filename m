Return-Path: <kvm+bounces-53198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0529B0EEA5
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 11:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E3761C84B34
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 09:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF6D2882D0;
	Wed, 23 Jul 2025 09:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XQfUwyXQ"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9E72853E7;
	Wed, 23 Jul 2025 09:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753263759; cv=none; b=OyC6dyanz50ouCbaRYbTfjH98wl0jLO9wQY1dJ79TJ22VbPlP5BjkwIRqNVlcdA1FfPc2X/QpEyRUk7/bqUCz3lMSPsI/506fawRiXt4u36CHx1H0NkuRFEg7VVeG9tpOnYiAyCZAo5qu4388Qg2q0vUUUc7OU4Vkt6tO9uR7lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753263759; c=relaxed/simple;
	bh=vaLSVEk/I8c+AN22zxdA34oe9R4YxZV31UGdwncXb/w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XJGGKaRys1xT9BT1C7J4VlFpVfA512Q9tYLZNKluDRFBCXYuE/4pbRSXXb/1IEawNBTvUmVkHuUnl15VNtuxupHCuK/ioJmtGtRVthpjxB/7OchnuBHpjR1WHD5YwJrNwVMQ8cpSA0qj1QcT0dPVO1iQTa14Vsl0nvHi/yML0B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XQfUwyXQ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6c077I1RSBowU6xDJVwopXrSusY0xQYRPoalBYci8Aw=; b=XQfUwyXQ35eTM56dFmxc9++ViX
	9+n6OB4zXy1yZ93MOahWNJA5IO6CmDX7dHGaQGJHLDC40ASazl8q8YITrJpafLoGOpMSgjEwSBceq
	9maqKqtXQhsR0bYsakvjUT+8PqlFq800U6GQCn8WxUXy/mjSanMAb4iiFeoz18+AXX2SN0eOrZ5jr
	B8wS6THjOG7cUIinzjFDTVbJ22T52Snz+4l2s0X29KRet38GOhbLCLwBgL0dsm9eXASBR3qVs1Zov
	Pa6ALnOHdD2f2bJkDUbfSaTgG38rVKaTIsFVSop9umgGYOU/JVAefdomVekXVfNn7HSaklSK79Xr+
	FOuAyY6g==;
Received: from [54.239.6.190] (helo=edge-cache-169.e-lhr50.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueVzY-00000008khV-1Hnr;
	Wed, 23 Jul 2025 09:42:29 +0000
Message-ID: <590aa43842aa1e6667d6a564cfdcb86a2ca02160.camel@infradead.org>
Subject: Re: [RFC PATCH 2/2] KVM: arm64: vgic-its: Unmap all vPEs on shutdown
From: David Woodhouse <dwmw2@infradead.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sebastian Ott <sebott@redhat.com>,
 Andre Przywara <andre.przywara@arm.com>, Thorsten Blum
 <thorsten.blum@linux.dev>, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>,
 linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,  "Saidi, Ali"
 <alisaidi@amazon.com>
Date: Wed, 23 Jul 2025 11:42:26 +0200
In-Reply-To: <aIAUxarULx3vC2MO@linux.dev>
References: <20250623132714.965474-1-dwmw2@infradead.org>
	 <20250623132714.965474-2-dwmw2@infradead.org> <aIAUxarULx3vC2MO@linux.dev>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-cwbpnR8RpG6qtbrpv5c5"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-cwbpnR8RpG6qtbrpv5c5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-07-22 at 15:46 -0700, Oliver Upton wrote:
> On Mon, Jun 23, 2025 at 02:27:14PM +0100, David Woodhouse wrote:
> > From: David Woodhouse <dwmw@amazon.co.uk>
> >=20
> > We observed systems going dark on kexec, due to corruption of the
> > new
> > kernel's text (and sometimes the initrd). This was eventually
> > determined
> > to be caused by the vLPI pending tables used by the GIC in the
> > previous
> > kernel, which were not being quiesced properly.
> >=20
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > ---
> > =C2=A0arch/arm64/kvm/arm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 5 +++++
> > =C2=A0arch/arm64/kvm/vgic/vgic-v3.c | 14 ++++++++++++++
> > =C2=A0include/kvm/arm_vgic.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
|=C2=A0 2 ++
> > =C2=A03 files changed, 21 insertions(+)
> >=20
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 38a91bb5d4c7..2b76f506bc2d 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2164,6 +2164,11 @@ void
> > kvm_arch_disable_virtualization_cpu(void)
> > =C2=A0		cpu_hyp_uninit(NULL);
> > =C2=A0}
> > =C2=A0
> > +void kvm_arch_shutdown(void)
> > +{
> > +	kvm_vgic_v3_shutdown();
> > +}
> > +
> > =C2=A0#ifdef CONFIG_CPU_PM
> > =C2=A0static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
> > =C2=A0				=C2=A0=C2=A0=C2=A0 unsigned long cmd,
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c
> > b/arch/arm64/kvm/vgic/vgic-v3.c
> > index b9ad7c42c5b0..6591e8d84855 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -382,6 +382,20 @@ static void map_all_vpes(struct kvm *kvm)
> > =C2=A0						dist-
> > >its_vm.vpes[i]->irq));
> > =C2=A0}
> > =C2=A0
> > +void kvm_vgic_v3_shutdown(void)
> > +{
> > +	struct kvm *kvm;
> > +
> > +	if (!kvm_vgic_global_state.has_gicv4_1)
> > +		return;
> > +
> > +	mutex_lock(&kvm_lock);
> > +	list_for_each_entry(kvm, &vm_list, vm_list) {
> > +		unmap_all_vpes(kvm);
> > +	}
> > +	mutex_unlock(&kvm_lock);
> > +}
> > +
>=20
> This presumes the vCPUs have already been quiesced which I'm guessing
> is the case for you.

Yeah. With KHO we aspire to be able to do a kexec with some pCPUs
actually still *running* guest vCPUs instead of pointlessly taking them
offline just for *one* pCPU to do the kexec work. But that's a way off
yet, and in that case all these tables will need to be in memory which
persists across the kexec so we won't need to quiesce anything. But
those fantasies are a way off for now...

> The vPEs need to be made nonresident from the
> redistributors prior to unmapping from the ITS to avoid consuming
> unknown vPE state (IHI0069H.b 8.6.2).

Right, I think that's what's being done in the second patch I sent,
saying, "FWIW this is a previous hack we attempted which *didn't work".
To be clear, we do still *have* that hack, in addition to the explicit
unmap_all_vpes() call.

I would love a definitive answer about what the hypervisor is
*expected* to do here. It's very suboptimal that the GIC doesn't
actually stop accessing memory when it is quiesced, and that the GIC
doesn't live behind an IOMMU which would at least allow stray DMA to be
prevented.

> So we'd probably need to deschedule the vPE in
> kvm_arch_disable_virtualization_cpu() along with some awareness of
> 'kvm_rebooting'.

Yeah, I also pondered doing it *all* from there, but it looked like it
would have required some kind of counting to work out when the *last*
CPU was taken down as there's only a per-CPU arch hook. So I didn't
bother with that for the early RFC.

Note that this issue with the GIC's scattershot DMA doesn't only affect
KVM hosts and the vLPI pending tables. We *also* have similar issues on
the guest side with hibernate. The boot kernel sends a MAPD command to
set up an ITT, then transfers control back to the resumed kernel which
had previously set up that ITT at a *different* address, and nobody
ever tells the (v)GIC. Which means that if the host subsequently
serializes that guest for LU/LM, it corrupts memory that the running
kernel didn't expect it to. I guess this would happen for hibernate on
real hardware too? And maybe even kexec but that one just hasn't bitten
us yet?



--=-cwbpnR8RpG6qtbrpv5c5
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDcyMzA5NDIy
NlowLwYJKoZIhvcNAQkEMSIEINQAJXmn1zKH1aw3XR5fNyRKX4AqeY7yJpd1AcKh141sMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAI+MgZUXVZCtU
hIGNVUXDBETy3DNPmjtJHnVEjIcGU4ZgQ/7sgK+c8hF7mi/5UhOsbQsTiB6vqI9dHGODvuVzFV2P
vdD/0UOz6HPfke13MvWQ6jGqDmLf9WquJbeGhU12a4yDci6pMjL69U03VWH6HVoClFNX5NE9mG8s
UCkUkZencwk1mjOASIlP0/WHu8qcBnW+5+pBAuegEJLZKmeB/mxY46AmdyXz+GK5bVqbgBmYkHaS
0QU3IatTxtNRodl1YnYgCun6zwDmqlof451MVNOey7Xi5yPSZKHEKI+QlcxhSHpqQ8fcPMnOOhhf
ECo5/htcmr61nNPq1sXNSgMpcm0iAdpH+nZZXtUeQ7Qb5y/XlSMgiubwKikIg6aAsD+3SrhZ8mLy
37862KLtdVaZ96ppI7rOsy+rlF8wDrgzeRb2GcASs5GrX9ldu+r7jvNYHKDPLa1wrEhzguPeYcMc
eFlieilD2HjmakBeD6tDehXVK+UBGcBrbkW9DaLLUvWIlUh6CSpmJT8SbPCZNkI1WjrTF0bz5c6U
Cjb+eGxolB0dTCAj2ndndhaEfgCsCGerlNAOJzWAUPYU9/4Rltr8DQtcIxJz7XeTMRfqjtdld2HD
uBUPXAgU/aWB22cVHpV4uJj0pOmEvLjc43xZjQAE2/jQqtGIPBbhNJ/calmc2yAAAAAAAAA=


--=-cwbpnR8RpG6qtbrpv5c5--

