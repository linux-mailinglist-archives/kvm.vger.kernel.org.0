Return-Path: <kvm+bounces-37361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC87A294B1
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 16:29:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAD6B165D5E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 15:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5FA16DC28;
	Wed,  5 Feb 2025 15:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VIwtTbkX"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583BA21345;
	Wed,  5 Feb 2025 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738769221; cv=none; b=I0iYpeHHI6VMMyF3F8jAhwK7cEpidoEWWWKsfArDYeyV5TPKPKLZPnpO1TI5ggUBhxEok4nBwT+WXe4ef8wcan7/rhN/aijkN4dSNyiBq+6mIBWJjEwOzzP4w2TZjQSue146v0n/92+aiDWrRt10A0DKni0rPpUBfcvE9v8P2ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738769221; c=relaxed/simple;
	bh=mQxxpnUWPbAtmrclpjK+br7D/z2ISM4TOgdKD14QY7o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AuCWmOMRy1gdmX4OmLsYjZbEcnIspxUbLGuRxm3nCBozSWiugeqLLP32X+3xOYv9DYGO607i6QTrb5qssGKUuT4B+vS3wZzOoa5j3rkA6jswxyq2e/Ip730njq9q81YTQpHkQGuW7N0AN3D7BVwcly7d8aN044/y7vJCYzyxdyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VIwtTbkX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vIu8g03GVWDfQvpvKYikyK/3pMQHZ9JTwx+20Ge+g/c=; b=VIwtTbkX35iUs09J3LtOg4dmrE
	yoC4txBUwrUxe9a7THKa8s0WC/V2dNfnKUFMfNXxJWknvRJHt/4VCuG+UVUwj6117o7mm6JlIf+5i
	jhO1cvgJWs514UfL6KcBccrFYjKtrlI7lFsfJqXFTMdayc8g8oDAPY3THPPKChaABhp4ySvMVOHLt
	GfnwPFj2Qk98E3Q7sUkiUwJ2wZ/imj2Kt31WcSM6HNvdKNsWbhST2AhU9hbynaRasd54nLvt39Tlc
	FyCA5C8DVQC0uFUfqDRMpQfbBp1bEmZPOB2LmLJW0Xo3WBZLbxoEOnTEqDABNrae3ERuLm3Pl2HQx
	OvkufN3w==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=edge-bw-108.e-fra50.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfhIk-00000004cnF-3qhN;
	Wed, 05 Feb 2025 15:26:55 +0000
Message-ID: <cd3fb8dd79d7766f383748ec472de3943021eb39.camel@infradead.org>
Subject: Re: [PATCH 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, Joao Martins
	 <joao.m.martins@oracle.com>
Date: Wed, 05 Feb 2025 15:26:54 +0000
In-Reply-To: <Z6N-kn1-p6nIWHeP@google.com>
References: <20250201011400.669483-1-seanjc@google.com>
	 <20250201011400.669483-2-seanjc@google.com>
	 <43f702b383fb99d435f2cdb8ef35cc1449fe6c23.camel@infradead.org>
	 <Z6N-kn1-p6nIWHeP@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-oL5qriotlyWGFZC+p49q"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-oL5qriotlyWGFZC+p49q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-02-05 at 07:06 -0800, Sean Christopherson wrote:
> On Wed, Feb 05, 2025, David Woodhouse wrote:
> > On Fri, 2025-01-31 at 17:13 -0800, Sean Christopherson wrote:
> > > --- a/arch/x86/kvm/xen.c
> > > +++ b/arch/x86/kvm/xen.c
> > > @@ -1324,6 +1324,14 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct=
 kvm_xen_hvm_config *xhc)
> > > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0 xhc->blob_size_32 || xhc->blob_size_6=
4))
> > > =C2=A0		return -EINVAL;
> > > =C2=A0
> > > +	/*
> > > +	 * Restrict the MSR to the range that is unofficially reserved for
> > > +	 * synthetic, virtualization-defined MSRs, e.g. to prevent confusin=
g
> > > +	 * KVM by colliding with a real MSR that requires special handling.
> > > +	 */
> > > +	if (xhc->msr && (xhc->msr < 0x40000000 || xhc->msr > 0x4fffffff))
> > > +		return -EINVAL;
> > > +
> > > =C2=A0	mutex_lock(&kvm->arch.xen.xen_lock);
> > > =C2=A0
> > > =C2=A0	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
> >=20
> > I'd prefer to see #defines for those magic values.
>=20
> Can do.=C2=A0 Hmm, and since this would be visible to userspace, arguably=
 the #defines
> should go in arch/x86/include/uapi/asm/kvm.h

Thanks.

> > Especially as there is a corresponding requirement that they never be s=
et
> > from host context (which is where the potential locking issues come in)=
.
> > Which train of thought leads me to ponder this as an alternative (or
> > additional) solution:
> >=20
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3733,7 +3733,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, st=
ruct msr_data *msr_info)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 msr =3D msr_info->index;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 data =3D msr_info->data;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (msr && msr =3D=3D vcpu->kvm->=
arch.xen_hvm_config.msr)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Do not allow host-initiat=
ed writes to trigger the Xen hypercall
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * page setup; it could incu=
r locking paths which are not expected
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * if userspace sets the MSR=
 in an unusual location.
>=20
> That's just as likely to break userspace.=C2=A0 Doing a save/restore on t=
he MSR doesn't
> make a whole lot of sense since it's effectively a "command" MSR, but IMO=
 it's not
> any less likely than userspace putting the MSR index outside of the synth=
etic range.

Save/restore on the MSR makes no sense. It's a write-only MSR; writing
to it has no effect *other* than populating the target page. In KVM we
don't implement reading from it at all; I don't think Xen does either?

And even if it was readable and would rather pointlessly return the
last value written to it, save/restore arguably shouldn't actually
trigger the guest memory to be overwritten again. The hypercall page
should only be populated when the *guest* writes the MSR.

With the recent elimination of the hypercall page from Linux Xen
guests, we've suggested that Linux should still set up the hypercall
page early (as it *does* have the side-effect of letting Xen know that
the guest is 64-bit). And then just free the page without ever using
it. We absolutely would not want a save/restore to scribble on that
page again.

I'm absolutely not worried about breaking userspace with such a change
to make the hypercall page MSR only work when !host_initiated. In fact
I think it's probably the right thing to do *anyway*.

If userspace wants to write to guest memory, it can do that anyway; it
doesn't need to ask the *kernel* to do it.

> Side topic, upstream QEMU doesn't even appear to put the MSR at the Hyper=
-V
> address.=C2=A0 It tells the guest that's where the MSR is located, but th=
e config
> passed to KVM still uses the default.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Hypercall MSR base address =
*/
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (hyperv_enabled(cpu)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c->ebx=
 =3D XEN_HYPERCALL_MSR_HYPERV;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_xe=
n_init(cs->kvm_state, c->ebx);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c->ebx=
 =3D XEN_HYPERCALL_MSR;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> ...
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* hyperv_enabled() doesn't wo=
rk yet. */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint32_t msr =3D XEN_HYPERCALL=
_MSR;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D kvm_xen_init(s, msr);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return=
 ret;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20

Those two happen in reverse chronological order, don't they? And in the
lower one the comment tells you that hyperv_enabled() doesn't work yet.
When the higher one is called later, it calls kvm_xen_init() *again* to
put the MSR in the right place.

It could be prettier, but I don't think it's broken, is it?

> Userspace breakage aside, disallowng host writes would fix the immediate =
issue,
> and I think would mitigate all concerns with putting the host at risk.=C2=
=A0 But it's
> not enough to actually make an overlapping MSR index work.=C2=A0 E.g. if =
the MSR is
> passed through to the guest, the write will go through to the hardware MS=
R, unless
> the WRMSR happens to be emulated.
>=20
> I really don't want to broadly support redirecting any MSR, because to tr=
uly go
> down that path we'd need to deal with x2APIC, EFER, and other MSRs that h=
ave
> special treatment and meaning.
>=20
> While KVM's stance is usually that a misconfigured vCPU model is userspac=
e's
> problem, in this case I don't see any value in letting userspace be stupi=
d.=C2=A0 It
> can't work generally, it creates unique ABI for KVM_SET_MSRS, and unless =
there's
> a crazy use case I'm overlooking, there's no sane reason for userspace to=
 put the
> index in outside of the synthetic range (whereas defining seemingly nonse=
nsical
> CPUID feature bits is useful for testing purposes, implementing support i=
n
> userspace, etc).

Right, I think we should do *both*. Blocking host writes solves the
issue of locking problems with the hypercall page setup. All it would
take for that issue to recur is for us (or Microsoft) to invent a new
MSR in the synthetic range which is also written on vCPU init/reset.
And then the sanity check on where the VMM puts the Xen MSR doesn't
save us.

But yes, we should *also* do that sanity check.



--=-oL5qriotlyWGFZC+p49q
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDIwNTE1MjY1
NFowLwYJKoZIhvcNAQkEMSIEIJgkjyuiToD14cI1ppSIvG1o9C3TgfpriR0lt4WZwDbBMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAyZWgXusAsxTb
wVgq8txSb7FbrKLGFHdUNEyhYKMiavnMgjxDvM8QKwGnRrF577aWqDwO8HYJnDjuqe+4RmWH3SvD
dRjulvFZqsg4XqlNMsYsYt/DJE2S/W2hVnYAuS+JGb6FMgMNNu7lhSVJ3UOTxKtqzb6OlRwkHTeD
9JHsP78JafCUMzZddSoz6YdE6mEWEV+r/7W++04Mix4fVJdpTVWjXUUDm0ISaaHBgLL/iQqaTW97
rjh69luN4guSe5jFbgR3lfZ6N6jqK1NBBDbr1zAkrmLkLkvV9FC48RP5fnNtujS1dE8zLnnAocTs
ihYmJnYPZ0AQo7RSpw0Uw7wvHiA+1GVpCPIfmpIOP54d0QvrAvU62wHwrrngCeM8bOObmPGtuOcP
J5kTF8kmB/qN7TFng5YXDaloRsHf0GuTtxo8c1cuDxHBTQnz+EnvFARpOaG1Wyz1kKoIVHgozmbs
cKu/u/cMdfP0RjvJUZ3yUdaG5gTs+Pj7p0/LOuOu++hV07KF9+y1MppKmiKdY1g2Me+E3MKn7Pyc
eyhBrZBjKhZZAVuCiESo5e0Pp8Zi0zJC4hYOqen5OE9FOp3GDJ1z2KGuKGHb69ZKstK4doqkEcN9
ByvT6cnGSKUMqyIVJanNXvy24Gcjb+buflUb7Abw79KD+/28RXt9OlbC6quzU5kAAAAAAAA=


--=-oL5qriotlyWGFZC+p49q--

