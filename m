Return-Path: <kvm+bounces-72937-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICIjLK3XqWl5GAEAu9opvQ
	(envelope-from <kvm+bounces-72937-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:21:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9E0217630
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:21:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 476B130D63AB
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC61304BA3;
	Thu,  5 Mar 2026 19:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q+CdtHlg"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF1227EFEE;
	Thu,  5 Mar 2026 19:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772738322; cv=none; b=G6MRb9KuVWbx1F3y/hVaVW9d14fEVD9A0b/kAWMchyrYN+qa7lbuJDQJZf+9u5W8ZR5UmtLHH1KvUCsTzSFgUXAuqYqCB1x8xLwi396tWS6w7FZGB+THi5yDqGwmjV6VQP+pBvDm2vTr5E6cmNoV2Y5620ZG/rrhAAsB6NW3vBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772738322; c=relaxed/simple;
	bh=PdBAR4MGvQ5clNQcgo9d7iULqve3mqxtlCX4RiG45mQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZXpYBNo+4WknfI81jZIhshCuAHS5ddjTvEIDIDNBjPUccRXgoIAVyF/ld2Kg+mIFdar0TZulUSz9HfR7p3gOdw4Sm9GM8DRpN337hWFYa+DjbhJUlDZ+G/K/QwQXM/llsJaYN0cY3NTNnA3FtEt+2dXHe2StALg6lZ1GgcjP1is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q+CdtHlg; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LnHix+yY0XsmWThjHySb02jtAMeJdWH9rBBn7eMmUZE=; b=q+CdtHlgHoiqDnp2RrSWhdrnWa
	gdiy58LAetfg6FpVIc10bP2lc2WiUKiZU2lazTP/zGHFhhZ1gwLaF7/umVQ4Yt9qqPLOZllsr6dcb
	UwDDyIqwUH2iXyWqr0qLlX9sl7WSV8l8VDYhPjPrgZQbzeJojHWqCxRGEL5vnilYomnD6jDGYMaMA
	BQELWbZ++LJyUmrHWynznDGYDcVPkYRQZq+XA3jrkm1yykDVPPMxTOh7vNSHDfxoe3ItQKQYNDJRP
	lz6kDNLNZPvEtxyQjb1YozNZJWOiH6y2hqN9Q/PQ4es6WtbSL1RVjn0R0StKBanaziftUI6ZaHIfW
	SElOj6MQ==;
Received: from [54.239.6.184] (helo=freeip.amazon.com)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyEDP-00000007WZL-2SeU;
	Thu, 05 Mar 2026 19:18:31 +0000
Message-ID: <4746a98c3390aab3d5f561dbcd0ce9d14266f003.camel@infradead.org>
Subject: Re: [PATCH] KVM: x86: Fix C++ user API for structures with variable
 length arrays
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, keescook@chromium.org, 
 daniel@iogearbox.net, gustavoars@kernel.org, jgg@ziepe.ca,
 kvm@vger.kernel.org,  linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>
Date: Thu, 05 Mar 2026 20:18:30 +0100
In-Reply-To: <aanNPwnH7l-j61Ds@google.com>
References: <aaa7ac93db25459fa5a629d0da5abf13e93d8301.camel@infradead.org>
	 <da02314c-e6da-4d9e-a2c8-cd3ee096bc0c@embeddedor.com>
	 <97d40dd0e6abaf28f43d4d8ccf9c547a16c52e33.camel@infradead.org>
	 <aanNPwnH7l-j61Ds@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-vN7fseNddNbjSRw/6g3j"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 0A9E0217630
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-4.26 / 15.00];
	SIGNED_SMIME(-2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72937-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dwmw2@infradead.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,infradead.org:dkim,infradead.org:mid,amazon.co.uk:email]
X-Rspamd-Action: no action


--=-vN7fseNddNbjSRw/6g3j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2026-03-05 at 10:36 -0800, Sean Christopherson wrote:
> On Thu, Feb 26, 2026, David Woodhouse wrote:
> > From: David Woodhouse <dwmw@amazon.co.uk>
> >=20
> > Commit 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with
> > flexible-array members") broke the userspace API for C++. Not just in
> > the sense of 'userspace needs to be updated, but UAPI is supposed to be
> > stable", but broken in the sense that I can't actually see *how* the
> > structures can be used from C++ in the same way that they were usable
> > before.
> >=20
> > These structures ending in VLAs are typically a *header*, which can be
> > followed by an arbitrary number of entries. Userspace typically creates
> > a larger structure with some non-zero number of entries, for example in
> > QEMU's kvm_arch_get_supported_msr_feature():
> >=20
> > =C2=A0=C2=A0=C2=A0 struct {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_msrs info;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_msr_entry entries=
[1];
> > =C2=A0=C2=A0=C2=A0 } msr_data =3D {};
> >=20
> > While that works in C, it fails in C++ with an error like:
> > =C2=A0flexible array member =E2=80=98kvm_msrs::entries=E2=80=99 not at =
end of =E2=80=98struct msr_data=E2=80=99
> >=20
> > Fix this by using __DECLARE_FLEX_ARRAY() for the VLA, which is a helper
> > provided by <linux/stddef.h> that already uses [0] for C++ compilation.
> >=20
> > Also put the header fields into a struct_group() to provide (in C) a
> > separate struct (e.g 'struct kvm_msrs_hdr') without the trailing VLA.
>=20
> Unless I'm missing something, this is an entirely optional change that ne=
eds to
> be done separately, especialy since I want to tag this for:
>=20
> =C2=A0 Cc: stable@vger.kernel.org
>=20
> I definitely don't hate the __struct_group definitions, but I don't know =
that I
> love them either as they make the code a bit harder to read, and more imp=
ortantly
> there's a non-zero chance that defining the new structurs could break use=
rspace
> builds and force an update, e.g. if userspace already concocts its own he=
ader
> overlay, which would be very unpleasant for a stable@ patch.
>=20
> If we do define headers, I think I'd want a wrapper around __struct_group=
() to
> prettify the common case and force consistent naming, e.g.
>=20
> #define kvm_struct_header(NAME, MEMBERS...)				\
> 	__struct_group(NAME ##_header, h, /* no attrs */, MEMBERS)
>=20
> struct kvm_msrs {
> 	kvm_struct_header(kvm_msrs,
> 		__u32 nmsrs; /* number of msrs in entries */
> 		__u32 pad;
> 	);
>=20
> 	__DECLARE_FLEX_ARRAY(struct kvm_msr_entry, entries);
> };
>=20
> But that's likely going to lead to some amount of bikeshedding, e.g. argu=
ably
> kvm_header() would be sufficient and easier on the eyes.=C2=A0 Which is a=
ll the more
> reason to handle it separately.
>=20
> > Fixes: 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with f=
lexible-array members")
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > ---
> > =C2=A0arch/x86/include/uapi/asm/kvm.h | 29 ++++++++++++++++++----------=
-
> > =C2=A0include/uapi/linux/kvm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 9 ++++++---
> > =C2=A0/* for KVM_GET_PIT and KVM_SET_PIT */
> > @@ -397,8 +402,10 @@ struct kvm_xsave {
> > =C2=A0	 * The offsets of the state save areas in struct kvm_xsave follo=
w
> > =C2=A0	 * the contents of CPUID leaf 0xD on the host.
> > =C2=A0	 */
> > -	__u32 region[1024];
> > -	__u32 extra[];
> > +	__struct_group(kvm_xsave_hdr, hdr, /* no attrs */,
> > +		__u32 region[1024];
> > +	);
>=20
> This is *very* misleading, as XSTATE itself has a header, but this is som=
ething
> else entirely (just the always-allocated region).
>=20
> > +	__DECLARE_FLEX_ARRAY(__u32, extra);
> > =C2=A0};
>=20
> There are several structs that got missed:
>=20
> =C2=A0 kvm_pmu_event_filter
> =C2=A0 kvm_reg_list
> =C2=A0 kvm_signal_mask
> =C2=A0 kvm_coalesced_mmio_ring
> =C2=A0 kvm_cpuid
> =C2=A0 kvm_stats_desc

Ack. Shall we do just the __DECLARE_FLEX_ARRAY() part, including those
missed structures?=20


--=-vN7fseNddNbjSRw/6g3j
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDMwNTE5MTgz
MFowLwYJKoZIhvcNAQkEMSIEIAmhdi8YA74Ua4TGhxIJUGNtDnp35y+6YZlS/Ge0bFwRMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAepp983Xg6Tjz
doUoTZjdet/UnscAvffaYxcfvZJv2FDn+9O40JtejIRWrs4oUaLvgVlDT3vxDA5HKy3g2kFjJOOc
OQQ2+/dxv0DHkckOTwlRmPnmHvTurfBShmkWhzMqV7keeVts6Y03QPP9cvHAqMOdWLCGnm+CYDE9
AGhmi2+oD0e1sz1py4SXpORMAWfgTNDuGPeNkV56G992a12g4H27P+QprHa7dYfg8TxNKpGMxFQ0
wvWLCBr+NU5g5r2FB0j+kNyVYqPA4LsdndSAfuPIIblz0g9HaMDIBfaCJvweS6k67z1EhUIUAspS
5c4IiBd/QFsEt31ki43H0L52oY/69v8tSORIg22kn8VcWp4oJtInjKASnjTTsNqbI4soqkAYC5OS
M35NHMUz2nIGSvUnyyy1mJ8GBU7kjTrWT2ch1acBaeoc2AHA1Qa0T8azeBKNI0pKCZz1uM/KJV3E
1N0LFZM2PTtkYHajQygCah9Wlq2MiKEd38qtITbAyjVKweXwkOF5OpCWZzEQBmcm5k9vCngsNvgc
PXzwy8hhk7oKYDSf3N1MLbMrB6Uc+BiLQsYgLpEHFZ8ByWp+mCkVVO7U9ygJ6fBadSrnHYHWeRFS
k+71TrrPzZyOsEXUehW4kP1N1KBtZVHzojWGrCuKf5m02v8uFDC+p7sL16UPe4kAAAAAAAA=


--=-vN7fseNddNbjSRw/6g3j--

