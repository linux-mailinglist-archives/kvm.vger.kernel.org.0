Return-Path: <kvm+bounces-64319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 239E6C7F208
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 07:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 17995345592
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 06:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6107A2E0400;
	Mon, 24 Nov 2025 06:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P588ZuKU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CF078F2E
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 06:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763967352; cv=none; b=oQksQxMPWN2/nwUnI1Cb5QYHXzdII2HRISclMPNOmagorzInPnOTPw3yYHe2oQhQDmmg30tlSek9lYk7kRfV+9FGLExBi1Tw0xbv7Xtr5NDqrUw2ZrMADgbCnDRRSeZ/wYnT9rAWFBFDTmTQJw52Obcc8VLbjMKqSLO/vu6UX6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763967352; c=relaxed/simple;
	bh=a4qMLYoLqh14x5R4HIfeoF8rKvEGU/r1XnAUIuUE8qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HD968qaOjN7fVwFcDL5hlwIAaNpFZjMbNbL6NQVXAe3mr5I+w6YmJLiDrGheV7bjsEBkbGYNeAHKOElFIic7jbzaiKxo7Zqe1Gvgq3bstIoTh3AV6LWKDXPwyZ1MsBtrCG4+cUzdGyz51PI/MCPQYOOyGSjUAP7fChXwPPzwVl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P588ZuKU; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b73545723ebso736829866b.1
        for <kvm@vger.kernel.org>; Sun, 23 Nov 2025 22:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763967348; x=1764572148; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a4qMLYoLqh14x5R4HIfeoF8rKvEGU/r1XnAUIuUE8qc=;
        b=P588ZuKUwCkPsAtkCP2Nx1dmKLQ7lSJJJS6ZknbSFrgU0lS7XGNknQBTx4RgPMEiGK
         WSeUyw8AyAE4jb7lw74n4XdcdVdRS2zArZDa5HhT6Z/LbSbajbQSDvjpxvG02rBeNAan
         3k1QVb/URA0mq6Ut/Tmd9za73utL8DuB/mUo09SkyHQ+um+fd8UYg5XpOJljttt7Th+D
         w/oR5zry5DCbnN4wtc+wTr3JgiLLcvJMRobfIkHdZDpD4wz1plwvAXme0N2YYJfu1s69
         DziAVWLAXv1teNcsaXNeU4yHMtUozYX6V7AT2V2x6JpRGjVOEScRG3WnLurBdSOmlWNH
         u24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763967348; x=1764572148;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a4qMLYoLqh14x5R4HIfeoF8rKvEGU/r1XnAUIuUE8qc=;
        b=Ju96jFoNJ7iDhyODQdOF5n8W9rgi4E6CvVlrHm1jPwp/4ahBj/DZCQ8nXYjhatWagT
         0RUPwJBT80Lts2LRRxCmhSrcpDOLD6LLlbLmQHHyLMzllVCz22mM1bZuY0d75yJdje8a
         pav2f6cHWvwL9CG7Ol+0DvriQgICdRMbb4N9FH1P4ym/5nK7ViKOXM3DboulVFelpI/I
         ftaU1dipfSc+DMB2L7etchZD/HYeKlVayM4u6yWh6lTakrKD/NwX8AQM3/ZdZH6lT1C1
         XT9nw6nVKTDOpjIA9ECItysXCco7+FuSlDIzt5NtK/EL3IBl+lS6Br6KuJJFisswv6XL
         749A==
X-Forwarded-Encrypted: i=1; AJvYcCW1w1JgDZpicUlMzsFOF8gYn9CADGLmq2ZWP+wZnfG04L3nzXRK3KL20A3Me0qhjgI1MOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkU5XnlreRIdCbfWsFpdxf9UdWqFfEEjWrkZm+WI5xSNdLP3rB
	OJUe5OYYBnJsUy2qUIFy76i22Hp25Ko2NQIob0/QZG/+n7PArpniHhL9SBl8akLl7Eg=
X-Gm-Gg: ASbGncsMCTZXpuqhzg0F4n8kKehtCYm1lTkJpxK6LSAnJvGHA6HAw62QD1tkumKSrWm
	93jwqTFZK7Lpenv2W7jY/7Qt+yB8nao2as1ANdyBXfbDqlJ+z8F9y+EGKB19zbKkILcHHTrcGFB
	iwqJdouWAsWbUqVMefkEmku23/FkCG5sB2v0B89kh1K4pDMuNo9rAeRJzrjHCynYd+0mvtqJXoW
	FLA5kbR02rQVggnEymjqtOCtbLh51dlzgwN/oWm6pJ4qiV11EyB5WWaQNlFHohc8cu04qTggWVt
	4f83MQ5R9j2xdu46JGEuYHM1UlkCZ36hTq4PGrGGLpSWqWRFCrU9YaLqCqIWAh21NQT9GT8UFSL
	LiLLCmNR1rEJycn+A+138oigUh598XDRd7JbIIWAK1xFW5VlY/X0rEPV0I3Hf7ezgNX+clsaUXL
	2E0BpC/bZw/DJyCYlDibUd/XIppvWfCvtosFWaEh0aIaNUUrC3pJcufKmEcaxEV9as09cx6oh7m
	xj2V0Jykep8kYyFDPDAKzN+E4K4ibOshL3K2vc=
X-Google-Smtp-Source: AGHT+IEM46sBoidOONMdY6F3oAmBVDOf6i+8F7241HLSpkAR60OcqxQEQPMneaYRD79kqK/LDZKD7g==
X-Received: by 2002:a17:907:3f2a:b0:b76:36ed:9fbe with SMTP id a640c23a62f3a-b7671a7a1cdmr1072927666b.40.1763967348136;
        Sun, 23 Nov 2025 22:55:48 -0800 (PST)
Received: from ?IPV6:2003:e5:871a:de00:dd24:7204:f00a:bf44? (p200300e5871ade00dd247204f00abf44.dip0.t-ipconnect.de. [2003:e5:871a:de00:dd24:7204:f00a:bf44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b765503a990sm1203093766b.63.2025.11.23.22.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Nov 2025 22:55:47 -0800 (PST)
Message-ID: <47fed3cd-58fd-4670-a939-7b2e7ca1b673@suse.com>
Date: Mon, 24 Nov 2025 07:55:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
To: Huacai Chen <chenhuacai@kernel.org>, Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, x86@kernel.org
References: <20251124035402.3817179-1-maobibo@loongson.cn>
 <20251124035402.3817179-3-maobibo@loongson.cn>
 <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
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
In-Reply-To: <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------AKfOm3Kbax9qlTbc8gnUDRKE"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------AKfOm3Kbax9qlTbc8gnUDRKE
Content-Type: multipart/mixed; boundary="------------ePwLpA0utK1z0DrhxPEAXiVi";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Huacai Chen <chenhuacai@kernel.org>, Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, x86@kernel.org
Message-ID: <47fed3cd-58fd-4670-a939-7b2e7ca1b673@suse.com>
Subject: Re: [PATCH v2 2/3] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
References: <20251124035402.3817179-1-maobibo@loongson.cn>
 <20251124035402.3817179-3-maobibo@loongson.cn>
 <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
In-Reply-To: <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>

--------------ePwLpA0utK1z0DrhxPEAXiVi
Content-Type: multipart/mixed; boundary="------------imVIQBVKAQQS75YfpAqza0DE"

--------------imVIQBVKAQQS75YfpAqza0DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjQuMTEuMjUgMDc6MzMsIEh1YWNhaSBDaGVuIHdyb3RlOg0KPiBIaSwgQmlibywNCj4g
DQo+IE9uIE1vbiwgTm92IDI0LCAyMDI1IGF0IDExOjU04oCvQU0gQmlibyBNYW8gPG1hb2Jp
Ym9AbG9vbmdzb24uY24+IHdyb3RlOg0KPj4NCj4+IEZ1bmN0aW9uIHZjcHVfaXNfcHJlZW1w
dGVkKCkgaXMgdXNlZCB0byBjaGVjayB3aGV0aGVyIHZDUFUgaXMgcHJlZW1wdGVkDQo+PiBv
ciBub3QuIEhlcmUgYWRkIGltcGxlbWVudGF0aW9uIHdpdGggdmNwdV9pc19wcmVlbXB0ZWQo
KSB3aGVuIG9wdGlvbg0KPj4gQ09ORklHX1BBUkFWSVJUIGlzIGVuYWJsZWQuDQo+Pg0KPj4g
U2lnbmVkLW9mZi1ieTogQmlibyBNYW8gPG1hb2JpYm9AbG9vbmdzb24uY24+DQo+PiAtLS0N
Cj4+ICAgYXJjaC9sb29uZ2FyY2gvaW5jbHVkZS9hc20vcXNwaW5sb2NrLmggfCAgNSArKysr
Kw0KPj4gICBhcmNoL2xvb25nYXJjaC9rZXJuZWwvcGFyYXZpcnQuYyAgICAgICB8IDE2ICsr
KysrKysrKysrKysrKysNCj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCsp
DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2FyY2gvbG9vbmdhcmNoL2luY2x1ZGUvYXNtL3FzcGlu
bG9jay5oIGIvYXJjaC9sb29uZ2FyY2gvaW5jbHVkZS9hc20vcXNwaW5sb2NrLmgNCj4+IGlu
ZGV4IGU3NmQzYWExZTFlYi4uOWE1YjdiYTFmNGNiIDEwMDY0NA0KPj4gLS0tIGEvYXJjaC9s
b29uZ2FyY2gvaW5jbHVkZS9hc20vcXNwaW5sb2NrLmgNCj4+ICsrKyBiL2FyY2gvbG9vbmdh
cmNoL2luY2x1ZGUvYXNtL3FzcGlubG9jay5oDQo+PiBAQCAtMzQsNiArMzQsMTEgQEAgc3Rh
dGljIGlubGluZSBib29sIHZpcnRfc3Bpbl9sb2NrKHN0cnVjdCBxc3BpbmxvY2sgKmxvY2sp
DQo+PiAgICAgICAgICByZXR1cm4gdHJ1ZTsNCj4+ICAgfQ0KPj4NCj4+ICsjaWZkZWYgQ09O
RklHX1NNUA0KPj4gKyNkZWZpbmUgdmNwdV9pc19wcmVlbXB0ZWQgICAgICB2Y3B1X2lzX3By
ZWVtcHRlZA0KPj4gK2Jvb2wgdmNwdV9pc19wcmVlbXB0ZWQoaW50IGNwdSk7DQo+IEluIFYx
IHRoZXJlIGlzIGEgYnVpbGQgZXJyb3IgYmVjYXVzZSB5b3UgcmVmZXJlbmNlIG1wX29wcywg
c28gaW4gVjINCj4geW91IG5lZWRuJ3QgcHV0IGl0IGluIENPTkZJR19TTVAuDQo+IE9uIHRo
ZSBvdGhlciBoYW5kLCBldmVuIGlmIHlvdSByZWFsbHkgYnVpbGQgYSBVUCBndWVzdCBrZXJu
ZWwsIHdoZW4NCj4gbXVsdGlwbGUgZ3Vlc3RzIHJ1biB0b2dldGhlciwgeW91IHByb2JhYmx5
IG5lZWQgdmNwdV9pc19wcmVlbXRwZWQuDQoNCkkgZG9uJ3QgdGhpbmsgc28uIFdoZW4gdGhl
IFVQIGd1ZXN0J3MgdmNwdSBpcyBwcmVlbXB0ZWQsIHdobyB3aWxsIHVzZSB0aGlzDQpmdW5j
dGlvbj8NCg0KDQpKdWVyZ2VuDQo=
--------------imVIQBVKAQQS75YfpAqza0DE
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjri
oyspZKOBycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2
kaV2KL9650I1SJvedYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i
1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/B
BLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xqG7/377qptDmrk42GlSK
N4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR3Jvc3Mg
PGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsE
FgIDAQIeAQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4F
UGNQH2lvWAUy+dnyThpwdtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3Tye
vpB0CA3dbBQp0OW0fgCetToGIQrg0MbD1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u
+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbvoPHZ8SlM4KWm8rG+lIkGurq
qu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v5QL+qHI3EIP
tyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVy
Z2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJ
CAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4
RF7HoZhPVPogNVbC4YA6lW7DrWf0teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz7
8X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC/nuAFVGy+67q2DH8As3KPu0344T
BDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0LhITTd9jLzdDad1pQ
SToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLmXBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkM
nQfvUewRz80hSnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMB
AgAjBQJTjHDXAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/
Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJnFOXgMLdBQgBlVPO3/D9R8LtF9DBAFPN
hlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1jnDkfJZr6jrbjgyoZHi
w/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0N51N5Jf
VRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwP
OoE+lotufe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK
/1xMI3/+8jbO0tsn1tqSEUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuZGU+wsB5BBMBAgAjBQJTjHDrAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgEC
F4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3g3OZUEBmDHVVbqMtzwlmNC4
k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5dM7wRqzgJpJ
wK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu
5D+jLRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzB
TNh30FVKK1EvmV2xAKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37Io
N1EblHI//x/e2AaIHpzK5h88NEawQsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6
AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpWnHIs98ndPUDpnoxWQugJ6MpMncr
0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZRwgnBC5mVM6JjQ5x
Dk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNVbVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mm
we0icXKLkpEdIXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0I
v3OOImwTEe4co3c1mwARAQABwsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMv
Q/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEwTbe8YFsw2V/Buv6Z4Mysln3nQK5ZadD
534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1vJzQ1fOU8lYFpZXTXIH
b+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8VGiwXvT
yJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqc
suylWsviuGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5B
jR/i1DG86lem3iBDXzXsZDn8R3/CwO0EGAEIACAWIQSFEmdy6PYElKXQl/ew3p3W
KL8TLwUCWt3w0AIbAgCBCRCw3p3WKL8TL3YgBBkWCAAdFiEEUy2wekH2OPMeOLge
gFxhu0/YY74FAlrd8NAACgkQgFxhu0/YY75NiwD/fQf/RXpyv9ZX4n8UJrKDq422
bcwkujisT6jix2mOOwYBAKiip9+mAD6W5NPXdhk1XraECcIspcf2ff5kCAlG0DIN
aTUH/RIwNWzXDG58yQoLdD/UPcFgi8GWtNUp0Fhc/GeBxGipXYnvuWxwS+Qs1Qay
7/Nbal/v4/eZZaWs8wl2VtrHTS96/IF6q2o0qMey0dq2AxnZbQIULiEndgR625EF
RFg+IbO4ldSkB3trsF2ypYLij4ZObm2casLIP7iB8NKmQ5PndL8Y07TtiQ+Sb/wn
g4GgV+BJoKdDWLPCAlCMilwbZ88Ijb+HF/aipc9hsqvW/hnXC2GajJSAY3Qs9Mib
4Hm91jzbAjmp7243pQ4bJMfYHemFFBRaoLC7ayqQjcsttN2ufINlqLFPZPR/i3IX
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------imVIQBVKAQQS75YfpAqza0DE--

--------------ePwLpA0utK1z0DrhxPEAXiVi--

--------------AKfOm3Kbax9qlTbc8gnUDRKE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmkkAXMFAwAAAAAACgkQsN6d1ii/Ey8I
0gf/YCT12ru5754lpR2Z13qnrHOpfqrznDHRwf4PsOpLP6YbnMP3gD2BG9hoMyBb/apZEADtE/3y
2EzqEnDo7VORctQrCZoGVMXTGJxMyVLvct5wOk0G7MboOFo2Ad3jaJWPxCXj/RHCxEsNk1E+U+97
V9IJBmM3qLYinjC9/a0Cgr5xz/Xd2PZuba/LM8XrNJAMTiFhJHf8y2ceElgFg2Rp8PKiKaaM93RU
Loro2dsdhCGcoA+IDTQVg0pgyo20cbeBQzrcMhISvTQu41mUz/tIpQWJYc/fUu0jtHo1392Mk4Py
aDdbd+Zb3uFMMJ8GUNnjyEUqm4Pyupd1+lcGh8+S5A==
=UH6T
-----END PGP SIGNATURE-----

--------------AKfOm3Kbax9qlTbc8gnUDRKE--

