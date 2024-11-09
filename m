Return-Path: <kvm+bounces-31346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B1CD69C2AF3
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 08:06:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1C0BB21845
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 07:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF05142E67;
	Sat,  9 Nov 2024 07:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FkwCvb/h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266FD286A8
	for <kvm@vger.kernel.org>; Sat,  9 Nov 2024 07:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731135989; cv=none; b=D9TDo7S/vknKc98JQfoB5UG21ZgCi0eWt3WvHZUzjCQb3gR/l0LRx02Jo87bsnXUL+qL/7kJioFzBRJmIeiZGBvRUVDPeTabIX+EJA/O55w7Xc1LKE66aiTIoEBYAQIg4LDkJMxjXcGWTgOFFgcMNcKzF0zSfoljNrVml//MGA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731135989; c=relaxed/simple;
	bh=8jNoAViCWI8vsA2Xo4+nKPQxFMzY/yJKP1J4b0jFQnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kb0Aw8GM0cxSKmU4xDoWWMpwyOdWbcUuYeqeM/G5IyYhQwqAh9750wOzW6bdr7uNTw/Y9wGIukz90ZRNJ7ebY1lej8J4XoDrO3ANLxhotlyAehOUWo9CMD9Y3jE3rLm2pAdY8ydNUsM950IFvV8VTAz69IeU+gk/p99hW5srApg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FkwCvb/h; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9ed7d8d4e0so427116966b.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 23:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731135985; x=1731740785; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8jNoAViCWI8vsA2Xo4+nKPQxFMzY/yJKP1J4b0jFQnY=;
        b=FkwCvb/h2XlOT98Hl9Cy2E6v4yGiNl5cFbxNNizw/wfxsjaUr8u5YxGIIuRXX36yxd
         tEx6WkaaezKTxzHlw50uubtFSUk5UPgcDeoMwXgWvRA6SFP+y5PZ3XqoJzXiYE5O3r+U
         JiDjrbThMlKZ79uspnV0/Rw+ld9YVibYXQIcrqawL5fWlTditSdeYDzoNQwQYMC+1q6f
         IAJmsstJEVWar9OPyw3b+tmwS79xM3D+K94gz9sBnsrXJ7FFkAOb783e/S7kyeqtNC/y
         A2DxPvey94mrOS1F1+Ft1h/jYd5lj9enay6jHd7nF67ePmp3pNOBGAHUu8YvjgjxnNBe
         mkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731135985; x=1731740785;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8jNoAViCWI8vsA2Xo4+nKPQxFMzY/yJKP1J4b0jFQnY=;
        b=DNzUsKykTgUcaLMUGDdC6OQtJ3sxhYbhyE4pcmZzSPf1GxCb6Yl287LGDdfMTR3BOA
         lWeSwyB3Y6rE6F3qnflEwSdGU3WeJMDiF15asgSxjBl2ebs04Kt1WxfCqVPsfPZkN5Eh
         0R9hDBHxGrgTetIkd3DIwCWvEtbOh7iiFlFpTB3YVsuJxyiPoSz6wr2NDJC/n14HJ3je
         OC0BR/CHNSFCmF4Cw5nzonWncn33c32goQuIeRXp8knUihpsHfl9aufGZaLVH6H+kxGr
         YhtOflFfuSJ8yM9nw0sR7fV23oBONM3xka9oBBZ8fcNJtD7lzqLQ7LwlJTXD9kpzDNZH
         WU0w==
X-Forwarded-Encrypted: i=1; AJvYcCU0n7GaoqJr1H9RzfcRR1fmemHF5jXSDWjqWpKV+8oodfkk6G9vhhGkfu0pZ9JWhP4+yKE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9mBavh7Zv7/L2zwLvD9D6uGM+W0BN3ji0ElhVzTH7zLdEE4j6
	bsjG7tXWKTeOXyQ9cR+YeU1718Y91lLbm5lRY4o8e17HenJWkDGQ4vGMx/XIvm8=
X-Google-Smtp-Source: AGHT+IGFGhexjxUAJJzNUCTXskIxVv6KD0CJ0vU8VpO07hG16ak5r1dn4qJ48nc5syMae94OVsex6g==
X-Received: by 2002:a17:907:7ea7:b0:a9a:4aa3:728b with SMTP id a640c23a62f3a-a9ef00190a6mr506349366b.53.1731135985230;
        Fri, 08 Nov 2024 23:06:25 -0800 (PST)
Received: from ?IPV6:2003:e5:872e:b100:d3c7:e0c0:5e3b:aa1c? (p200300e5872eb100d3c7e0c05e3baa1c.dip0.t-ipconnect.de. [2003:e5:872e:b100:d3c7:e0c0:5e3b:aa1c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0dc52bbsm325675366b.97.2024.11.08.23.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 23:06:24 -0800 (PST)
Message-ID: <a934013f-1f13-40a6-b665-67d62f9df4bc@suse.com>
Date: Sat, 9 Nov 2024 08:06:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: don't use a literal 1 instead of RET_PF_RETRY
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>
References: <20241108161312.28365-1-jgross@suse.com>
 <20241108171304.377047-1-pbonzini@redhat.com> <Zy5b06JNYZFi871K@google.com>
 <854e43f7-0eed-4a1b-8ede-37c538791396@suse.com> <Zy6M57VglxCSaZky@google.com>
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
In-Reply-To: <Zy6M57VglxCSaZky@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Rhz207CexZ2tAPLDbpmz1jQ5"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Rhz207CexZ2tAPLDbpmz1jQ5
Content-Type: multipart/mixed; boundary="------------dEEAdA9PknnRkOt0z6GjVSyU";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>
Message-ID: <a934013f-1f13-40a6-b665-67d62f9df4bc@suse.com>
Subject: Re: [PATCH] KVM/x86: don't use a literal 1 instead of RET_PF_RETRY
References: <20241108161312.28365-1-jgross@suse.com>
 <20241108171304.377047-1-pbonzini@redhat.com> <Zy5b06JNYZFi871K@google.com>
 <854e43f7-0eed-4a1b-8ede-37c538791396@suse.com> <Zy6M57VglxCSaZky@google.com>
In-Reply-To: <Zy6M57VglxCSaZky@google.com>

--------------dEEAdA9PknnRkOt0z6GjVSyU
Content-Type: multipart/mixed; boundary="------------ykxUJrFbPhW4kzwagp9zJdec"

--------------ykxUJrFbPhW4kzwagp9zJdec
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDguMTEuMjQgMjM6MTIsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IE9uIEZy
aSwgTm92IDA4LCAyMDI0LCBKw7xyZ2VuIEdyb8OfIHdyb3RlOg0KPj4gT24gMDguMTEuMjQg
MTk6NDQsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+Pj4gT24gRnJpLCBOb3YgMDgs
IDIwMjQsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+Pj4+IFF1ZXVlZCwgdGhhbmtzLg0KPj4+
DQo+Pj4gTm9vb28hICBDYW4geW91IHVuLXF1ZXVlPw0KPj4+DQo+Pj4gVGhlIHJldHVybiBm
cm9tIGt2bV9tbXVfcGFnZV9mYXVsdCgpIGlzIE5PVCBSRVRfUEZfeHh4LCBpdCdzIEtWTSBv
dXRlciAwLzEvLWVycm5vLg0KPj4+IEkuZS4gJzEnIGlzIHNheWluZyAicmVzdW1lIHRoZSBn
dWVzdCIsIGl0IGhhcyAqbm90aGluZyogdG8gZG8gd2l0aCBSRVRfUEZfUkVUUlkuDQo+Pj4g
RS5nLiB0aGF0IHBhdGggYWxzbyBoYW5kbGVzIFJFVF9QRl9GSVhFRCwgUkVUX1BGX1NQVVJJ
T1VTLCBldGMuDQo+Pg0KPj4gQW5kIHdoYXQgYWJvdXQgdGhlIGV4aXN0aW5nICJyZXR1cm4g
UkVUX1BGX1JFVFJZIiBmdXJ0aGVyIHVwPw0KPiANCj4gT29mLiAgV29ya3MgYnkgY29pbmNp
ZGVuY2UuICBUaGUgaW50ZW50IGluIHRoYXQgY2FzZSBpcyB0byByZXRyeSB0aGUgZmF1bHQs
IGJ1dA0KPiB0aGUgZmFjdCB0aGF0IFJFVF9QRl9SRVRSWSBoYXBwZW5zIHRvIGJlICcxJyBp
cyBtb3N0bHkgbHVjay4gIFJldHVybmluZyBhIHBvc3RpdmUNCj4gdmFsdWUgb3RoZXIgdGhh
biAnMScgc2hvdWxkIHdvcmssIGJ1dCBhcyBjYWxsZWQgb3V0IGJ5IHRoZSBjb21tZW50cyBm
b3IgdGhlIGVudW0sDQo+IHVzaW5nICcwJyBmb3IgQ09OVElOVUUgaXNuJ3QgYSBoYXJkIHJl
cXVpcmVtZW50LiAgRS5nLiBpZiBmb3Igc29tZSByZWFzb24gd2UgdXNlZA0KPiAnMCcgZm9y
IFJFVF9QRl9SRVRSWSwgdGhpcyBjb2RlIHdvdWxkIGJyZWFrLg0KDQpJIHRoaW5rIHRoaXMg
ZnVuY3Rpb24gaXMgYW4gZXNwZWNpYWxseSBhd2Z1bCBjYXNlLCBhcyBpdCBzZWVtcyB0byBi
ZSBuYXR1cmFsDQp0byByZXR1cm4gYSBSRVRfUEZfIHZhbHVlIGZyb20gYSBmdW5jdGlvbiBu
YW1lZCBrdm1fbW11X3BhZ2VfZmF1bHQoKS4NCg0KPiANCj4gICAqIE5vdGUsIGFsbCB2YWx1
ZXMgbXVzdCBiZSBncmVhdGVyIHRoYW4gb3IgZXF1YWwgdG8gemVybyBzbyBhcyBub3QgdG8g
ZW5jcm9hY2gNCj4gICAqIG9uIC1lcnJubyByZXR1cm4gdmFsdWVzLiAgU29tZXdoYXQgYXJi
aXRyYXJpbHkgdXNlICcwJyBmb3IgQ09OVElOVUUsIHdoaWNoDQo+ICAgKiB3aWxsIGFsbG93
IGZvciBlZmZpY2llbnQgbWFjaGluZSBjb2RlIHdoZW4gY2hlY2tpbmcgZm9yIENPTlRJTlVF
LCBlLmcuDQo+ICAgKiAiVEVTVCAlcmF4LCAlcmF4LCBKTloiLCBhcyBhbGwgInN0b3AhIiB2
YWx1ZXMgYXJlIG5vbi16ZXJvLg0KPiANCj4gRldJVywgeW91IGFyZSBmYXIgZnJvbSB0aGUg
Zmlyc3QgcGVyc29uIHRvIGNvbXBsYWluIGFib3V0IEtWTSdzIG1vc3RseS11bmRvY3VtZW50
ZWQNCj4gMC8xLy1lcnJubyByZXR1cm4gZW5jb2Rpbmcgc2NoZW1lLiAgVGhlIHByb2JsZW1z
IGlzIHRoYXQgaXQncyBzbyBwZXJ2YXNpdmUNCj4gdGhyb3VnaG91dCBLVk0sIHRoYXQgaW4g
c29tZSBjYXNlcyBpdCdzIG5vdCBlYXN5IHRvIHVuZGVyc3RhbmQgaWYgYSBmdW5jdGlvbiBp
cw0KPiBhY3R1YWxseSB1c2luZyB0aGF0IHNjaGVtZSwgb3IganVzdCBoYXBwZW5zIHRvIHJl
dHVybiBzaW1pbGFyIHZhbHVlcy4gIEkuZS4NCj4gY29udmVydGluZyB0byBlbnVtcyAob3Ig
I2RlZmluZXMpIHdvdWxkIHJlcXVpcmUgYSBsb3Qgb2Ygd29yayBhbmQgY2h1cm4uDQoNCkkg
dGhpbmsgaXQgd291bGQgYmUgaGVscGZ1bCB0byBhdCBsZWFzdCBhZGQgY29tbWVudHMgdG8g
dGhlIGZ1bmN0aW9ucw0KcmV0dXJuaW5nIHRoZSAwLzEvLWVycm5vIHZhbHVlLg0KDQpBbmQg
aXQgd291bGQgYmUgZXZlbiBiZXR0ZXIgdG8gaGF2ZSAjZGVmaW5lcyBmb3IgdGhlIDAgYW5k
IDEuIE5ldyB1c2UgY2FzZXMNCnNob3VsZCB1c2UgdGhlICNkZWZpbmVzLCBhbmQgd2hldGhl
ciB3ZSBjb252ZXJ0IGN1cnJlbnQgdXNlcnMgaXMgYW5vdGhlcg0KcXVlc3Rpb24gKEknZCBn
byBmb3IgaXQsIGFzIGl0IGlzIG9ubHkgYSBtaW5vciBhZGRpdGlvbmFsIHdvcmsgd2hlbiBh
ZGRpbmcNCnRoZSBjb21tZW50cyBhbnl3YXkpLg0KDQpJZiB5b3UgYXJlIGZpbmUgd2l0aCB0
aGF0LCBJIGNhbiBzdGFydCB0aGUgZWZmb3J0Lg0KDQoNCkp1ZXJnZW4NCg==
--------------ykxUJrFbPhW4kzwagp9zJdec
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------ykxUJrFbPhW4kzwagp9zJdec--

--------------dEEAdA9PknnRkOt0z6GjVSyU--

--------------Rhz207CexZ2tAPLDbpmz1jQ5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmcvCfAFAwAAAAAACgkQsN6d1ii/Ey/H
HAf/Xp1efSVQh9iulSx+vTCV4HdTTaQK3QYQCSIaJ7o8JONxc/rWXx1gKNnI10g/sLCCDydTtZ86
N7+Y6FuRv2icw829cahcObaUZlrTh6qv1N66Sl+QnDB78ZcKMPmkydGjSNs3Zs+qTXIi0/lmOqZh
fZ/02EUVX9qnjLwjEia4uq+6zN7upex3de/hkFN4gMHU0aP1efG7i2Dsz7LhjiX6NwHMbNajs+OH
cbeVyMhfoQ9Ka6ca1Efphrf9WRygXRUnKs1lnPPtajWXThlUi5hUfFUlFL/3I/7L0N9MNb4xBbqB
lpIls8U9RLFWlp7GS3oTzDHap+br4iROtkxoIYCAvg==
=997E
-----END PGP SIGNATURE-----

--------------Rhz207CexZ2tAPLDbpmz1jQ5--

