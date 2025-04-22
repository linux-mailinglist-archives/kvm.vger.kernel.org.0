Return-Path: <kvm+bounces-43829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57D51A96FCD
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 17:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79FD81623B5
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 15:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916962900A6;
	Tue, 22 Apr 2025 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UNE5zRVM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UNE5zRVM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0667C28FFFA
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745333966; cv=none; b=AG6kU1M+QO3o2EnSmDHELj7dWIsi73esEzfrME4WK3NsTp98uAJH1h5Oks1ERq82y9VL+UO0dQGJnpbmLF2YPEO9QW+JZlw3XM9ScBr8WML/aegPfueSliF+HOqsTJh214br6+VYpMZ/UphqdojAXxvPTWG7EqeKBcWP/LrmT1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745333966; c=relaxed/simple;
	bh=cjmhCdjX5S99zSAjWNy78nsxXHO3iUtXCl1SScMKKec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NyUr9bAyZcFCrPnGIzNfalEWzCdzDnPwJInh0EngnQ658PQ3wBnncd5KHmwZwa1R/Itkqr+GjmXcYBldy7DGy7h3z4XqstXhq0Zcr//GmP0mVq2TJv16Ad8T+g85vprVCtmARzeYjslLn8IIUjsk7MZUnS0aJ+521SplR3JofiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UNE5zRVM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UNE5zRVM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2AD79211B8;
	Tue, 22 Apr 2025 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745333963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cjmhCdjX5S99zSAjWNy78nsxXHO3iUtXCl1SScMKKec=;
	b=UNE5zRVMYIKYycGv3s+/StKRd8CkMwGFWj3LvGpf26yP+HVn0tQPupk7jSyXOzBKj8E7zm
	3psAbpXKWB+lUGCoMKSJ6Ce881zFWOQbELRGBEzwahlKaSgWx7LpMCkXlaI2lXr1X1ZxZU
	sX66KNGfvQ4vCC5WsKNPDjzMPmCh370=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=UNE5zRVM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745333963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cjmhCdjX5S99zSAjWNy78nsxXHO3iUtXCl1SScMKKec=;
	b=UNE5zRVMYIKYycGv3s+/StKRd8CkMwGFWj3LvGpf26yP+HVn0tQPupk7jSyXOzBKj8E7zm
	3psAbpXKWB+lUGCoMKSJ6Ce881zFWOQbELRGBEzwahlKaSgWx7LpMCkXlaI2lXr1X1ZxZU
	sX66KNGfvQ4vCC5WsKNPDjzMPmCh370=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D5E1F137CF;
	Tue, 22 Apr 2025 14:59:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7GLdMMquB2i+VQAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 22 Apr 2025 14:59:22 +0000
Message-ID: <801d663a-d448-401d-a957-c9825aca06c3@suse.com>
Date: Tue, 22 Apr 2025 16:59:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: MSR access API uses in KVM x86
To: Sean Christopherson <seanjc@google.com>, Xin Li <xin@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
References: <a82f4722-478f-4972-a072-80cd13666137@zytor.com>
 <aAeqRk8fk8mvutw2@google.com>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <aAeqRk8fk8mvutw2@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------w66X6YdQOmQ4uTHDxY9vXxOD"
X-Rspamd-Queue-Id: 2AD79211B8
X-Spam-Score: -6.41
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-6.41 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SIGNED_PGP(-2.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_BASE64_TEXT(0.10)[];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	HAS_ATTACHMENT(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------w66X6YdQOmQ4uTHDxY9vXxOD
Content-Type: multipart/mixed; boundary="------------6Kzqkpfo0G04mC9NQA0OA00Z";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>, Xin Li <xin@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Message-ID: <801d663a-d448-401d-a957-c9825aca06c3@suse.com>
Subject: Re: MSR access API uses in KVM x86
References: <a82f4722-478f-4972-a072-80cd13666137@zytor.com>
 <aAeqRk8fk8mvutw2@google.com>
In-Reply-To: <aAeqRk8fk8mvutw2@google.com>

--------------6Kzqkpfo0G04mC9NQA0OA00Z
Content-Type: multipart/mixed; boundary="------------YGgMTjLMaXyiPa7UpTSb4gcO"

--------------YGgMTjLMaXyiPa7UpTSb4gcO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMDQuMjUgMTY6NDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IE9uIE1v
biwgQXByIDIxLCAyMDI1LCBYaW4gTGkgd3JvdGU6DQo+PiBJdCBsb29rcyB0byBtZSB0aGF0
IE1TUiBhY2Nlc3MgQVBJIHVzZXMgaW4gS1ZNIHg4NiBhcmUgTk9UIGNvbnNpc3RlbnQ7DQo+
PiBzb21ldGltZXMge3dyLHJkfW1zcmwoKSBhcmUgdXNlZCBhbmQgc29tZXRpbWVzIG5hdGl2
ZV97d3IscmR9bXNybCgpIGFyZQ0KPj4gdXNlZC4NCj4+DQo+PiBXYXMgdGhlcmUgYSByZWFz
b24gdGhhdCBob3cgYSBnZW5lcmljIG9yIG5hdGl2ZSBNU1IgQVBJIHdhcyBjaG9zZW4/DQo+
IA0KPiBJIGRvdWJ0IGFueW9uZSBrbm93cyBmb3Igc3VyZTsgdGhhdCdkIGxpa2VseSByZXF1
aXJlIGEgdGltZSB0cmF2ZWxsaW5nIGRldmljZQ0KPiBhbmQvb3IgdGVsZXBhdGhpYyBhYmls
aXRpZXMgOi0pDQo+IA0KPj4gSW4gbXkgb3BpbmlvbiBLVk0gc2hvdWxkIHVzZSB0aGUgbmF0
aXZlIE1TUiBBUElzLCB3aGljaCBjYW4gc3RyZWFtbGluZQ0KPj4gb3BlcmF0aW9ucyBhbmQg
cG90ZW50aWFsbHkgaW1wcm92ZSBwZXJmb3JtYW5jZSBieSBhdm9pZGluZyB0aGUgb3Zlcmhl
YWQNCj4+IGFzc29jaWF0ZWQgd2l0aCBnZW5lcmljIE1TUiBBUEkgaW5kaXJlY3QgY2FsbHMg
d2hlbiBDT05GSUdfWEVOX1BWPXkuDQo+IA0KPiBBcyBKw7xyZ2VuIHBvaW50ZWQgb3V0LCB0
aGV5IGFyZW4ndCBpbmRpcmVjdCBjYWxscy4gIFRob3VnaCBJSVVDLCB0aGVyZSBpcyBzdGls
bA0KPiBhIGRpcmVjdCBDQUxMIGFuZCB0aHVzIGEgUkVUIHdoZW4gUEFSQVZJUlRfWFhMPVku
DQo+IA0KPiBJIGFncmVlIHRoYXQgdXNpbmcgUFYgQVBJcyBpbiBLVk0gZG9lc24ndCBtYWtl
IG11Y2ggc2Vuc2UsIGFzIHJ1bm5pbmcgS1ZNIGluIGENCj4gWEVOIFBWIGd1ZXN0IGRvZXNu
J3Qgc2VlbSBsaWtlIHNvbWV0aGluZyB3ZSBzaG91bGQgb3B0aW1pemUgZm9yLCBpZiBpdCdz
IGV2ZW4NCj4gc3VwcG9ydGVkLg0KDQpTaHVkZGVyLiA6LUQNCg0KTm8sIGRlZmluaXRlbHkg
bm90IHN1cHBvcnRlZC4NCg0KDQpKdWVyZ2VuDQo=
--------------YGgMTjLMaXyiPa7UpTSb4gcO
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------YGgMTjLMaXyiPa7UpTSb4gcO--

--------------6Kzqkpfo0G04mC9NQA0OA00Z--

--------------w66X6YdQOmQ4uTHDxY9vXxOD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgHrsoFAwAAAAAACgkQsN6d1ii/Ey+9
4ggAiLzknjzYIwe9GJPqAY5tfSMeiT4hL2y5/8vog2S1FzA8zuvKZVyMYopPvHvpf6AV+/wvAoqx
GXUSF7ntNybIvPI9B7vN3+QcKrc8SiE4DuP7/1KStS04Iv73rD+6oYg8QxP4FDWt6orRpL/vZnht
2UFdWPZAC9+k56KRK4qKtTuJLjItOxpuWcbSoaatSPdqeXRoYhEnRBVJFK6yZVtRYN6STPfyllnU
VNbT7eXFfj2vP9PGrTDrV8sILbsfa0bsZH1D8Z1Gw3BbTpfBh6qtyoIMNy+13ScMkPdJAA8KiQWF
GXaFMXLuo1KSLioqTdxVDonsIj40HE7NgT3YzoFaJw==
=5exk
-----END PGP SIGNATURE-----

--------------w66X6YdQOmQ4uTHDxY9vXxOD--

