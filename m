Return-Path: <kvm+bounces-65348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 844EDCA8495
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 16:59:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 026DB3021AAF
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 15:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A4E5340DB0;
	Fri,  5 Dec 2025 15:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aje60Mxd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D99B340A64
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764949676; cv=none; b=B6WX9dP5YlNH5rXuKmYIY3Xd1q5TXq6nmyC2qTujNtNTDvcSEP12Hn4IbJ5WjF5kfDKL8+Vurs0kTTzILTbKdB7/X3IBCT9KdqPdajsmDC4/rASVxk864jGtRFBmYaeV7PtqfYQpS+HP5uFWzlnhzQ3g/3oISp+y52fh1Mm429k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764949676; c=relaxed/simple;
	bh=54roHDvWK2XlCKRXvMJX9bgi5rXp6En8koei8e4Kpd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G1uoKa+419iaJvJhVAt2oX69SN0zxlcxVlbQNz5RwmyVniWjS/Wo/c/fZeJhi1NL9jiLzKREIzsg5PXpQHXtp/CscMXdJSgkex+8C4sCExLLRCjWusMHYDwiGjYtMuksYikmQeI7aklRwn/IiMYBEDAENrRw/KfW/QsxN2u7H1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aje60Mxd; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b76b5afdf04so343407166b.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 07:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764949664; x=1765554464; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=54roHDvWK2XlCKRXvMJX9bgi5rXp6En8koei8e4Kpd0=;
        b=aje60MxdaSzmJFgj51Bn+jcdSshxySb+qH+pt3eS8OtuKc441ZN+1VDkeoUHDFvN7A
         VbjKUYETcRwUcV7liNQUMk8NI723l7vitnGbEJwOOVyoxJrxESTSblgnEfdoMOO64HFe
         DsGmXYwnpVlOInnnd8mPjOjawFAMrkSBTXhQUiMIdERRMMZ9r/pF/GJUDw9ONGWPYa/g
         uLJ45F86kjfmmG4NrfGkLBG7Mc3+6Z4bcBXS6SM9tWoYpxogPZ27FnVWkVzjR6LAvj9Y
         O5JzPcAr2UuHtzeC80FGUk8DOXMznzXzW0mPfe6ChzIm0lNvuLKg+vlUyWq4S4FIsprh
         IlBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764949664; x=1765554464;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=54roHDvWK2XlCKRXvMJX9bgi5rXp6En8koei8e4Kpd0=;
        b=I6Mjy20yRHQwG2qMtK/nb8Fd19C3rtJvFbmbtLHPguOXCnW94Sqaw/vpLLfHc4t6jH
         nKbs2UJpJmU30Akk1J3klu4ks4qNzFHAVew9R22TbVReM1rNxvl/etPJbA0PkNcwiyZ9
         eovUdrBpaEvC9UBSzmhgNXeyHljZdLtcAqqywxSxiV2EOjOs3i+ZZZfk+sem0khcse0R
         gJcX6EM44bFrRTXvzMczle04Rjd8l5KblmJRZfY/ylgfLiuwbaW1G6l1QwxcejLvo6f5
         Sso8bLRV1viusIZsVwJoJS/nwdMvjx2TToPKyEXEIKF7DKbHPpkZ9x0aEHuG8yQSgVjV
         zEYw==
X-Forwarded-Encrypted: i=1; AJvYcCXdc+TlJ13suw2qff5eEiJLsqP2F7WC68ZLx9jGJoGtujrR3dbax+xzhWsqLs6RLGB34vQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIr1kuEV0g+YpdFNMfiHD2VRv/G2HA4QKhJ9DigjeuKxZHzDKW
	dRMe96GwxyHPcqi+I5CklLUpg3cbqcpCF0WjtUdfMaYtULpT1Vfg60vXrmeRLj3A+Vk=
X-Gm-Gg: ASbGnct1AOBNAFySgTTaJj6w+xqZHrm7ulWFBsmJ/jul4e/H3vmgHAnTIU7kJyYnUxp
	JY+/g6vQQIBYO7JNq9YSUGWTOnuYy94fjHh5dkuSrwSzz1KuidMR7yGwXsJvFz6IAOi2/ttI41Z
	b+PVYKHDLkaCWrNWzuGqfV7Jop956Y2oFAS3ZqPqGMSe1kI/7a3JR7ABc4a3VkYIegwr7i5C/Tv
	059Wa0i1rJaIOTJ59/qyuSsDZdwZSssjfDKEQuNp4tzQa7+jAv4TEO1GlR1pKv2ZqpqJlKhhxlt
	tCB6Qo573eAQaPzC+10dH/picBK7hllJ12ntftVk5dY6cASJD9jDKFSpt/BTlHioFDyeHFpaufs
	A7Y2gOC1eVr/Dk/cU9btm+0G7UxInLSzM/J+vyD6t6gzBFWZ+GDSqBJE7FwlPVd9U2a71GkVPEr
	F8NTGQX5QiK8FkzRG6e3Q9YVQ8OphY6orE0EsbqIum3ULBew81HnGbEwmtnMK7RR3Zwl6cKoPPO
	g/rBkZrqaziluLfh67Wd8n77ZzcssWDt1t9U4ytcdGG/dU=
X-Google-Smtp-Source: AGHT+IGn82/AdrEx5wJoIyKOCaucXBtwQ6HlabzugQ7Ciq3PEJAoj/NootlKGc8Yguj1wqZ/BUfJ1w==
X-Received: by 2002:a17:907:86a7:b0:b73:6d56:f3ff with SMTP id a640c23a62f3a-b79dbea4561mr1071620666b.20.1764949663675;
        Fri, 05 Dec 2025 07:47:43 -0800 (PST)
Received: from ?IPV6:2003:e5:8721:bb00:9139:4e25:a543:997? (p200300e58721bb0091394e25a5430997.dip0.t-ipconnect.de. [2003:e5:8721:bb00:9139:4e25:a543:997])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4976c43sm396853266b.42.2025.12.05.07.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 07:47:43 -0800 (PST)
Message-ID: <7eb84037-303c-4218-aeaa-2d08ef0b3267@suse.com>
Date: Fri, 5 Dec 2025 16:47:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] KVM: Avoid literal numbers as return values
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
References: <20251205074537.17072-1-jgross@suse.com>
 <aTLpQjsSsjQbHl3y@google.com>
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
In-Reply-To: <aTLpQjsSsjQbHl3y@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BPTpYUTG4A0qsuxwtHQtECkx"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BPTpYUTG4A0qsuxwtHQtECkx
Content-Type: multipart/mixed; boundary="------------IcOpqvpa9gM9MYSeng3eqFrr";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Message-ID: <7eb84037-303c-4218-aeaa-2d08ef0b3267@suse.com>
Subject: Re: [PATCH 00/10] KVM: Avoid literal numbers as return values
References: <20251205074537.17072-1-jgross@suse.com>
 <aTLpQjsSsjQbHl3y@google.com>
In-Reply-To: <aTLpQjsSsjQbHl3y@google.com>

--------------IcOpqvpa9gM9MYSeng3eqFrr
Content-Type: multipart/mixed; boundary="------------ojkqFTTTuLiNbF3pMrquQqMR"

--------------ojkqFTTTuLiNbF3pMrquQqMR
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDUuMTIuMjUgMTU6MTYsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IE9uIEZy
aSwgRGVjIDA1LCAyMDI1LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gVGhpcyBzZXJpZXMg
aXMgdGhlIGZpcnN0IHBhcnQgb2YgcmVwbGFjaW5nIHRoZSB1c2Ugb2YgbGl0ZXJhbCBudW1i
ZXJzDQo+PiAoMCBhbmQgMSkgYXMgcmV0dXJuIHZhbHVlcyB3aXRoIGVpdGhlciB0cnVlL2Zh
bHNlIG9yIHdpdGggZGVmaW5lcy4NCj4gDQo+IFNvcnJ5LCBidXQgTkFLIHRvIHVzaW5nIHRy
dWUvZmFsc2UuICBJTU8sIGl0J3MgZmFyIHdvcnNlIHRoYW4gMC8xLiAgQXQgbGVhc3QgMC8x
DQo+IGRyYXdzIGZyb20gdGhlIGtlcm5lbCdzIDAvLWVycm5vIGFwcHJvYWNoLiAgV2l0aCBi
b29sZWFucywgdGhlIHBvbGFyaXR5IGlzIG9mdGVuDQo+IGhhcmQgdG8gZGlzY2VybiB3aXRo
b3V0IGEgcHJpb3JpIGtub3dsZWRnZSBvZiB0aGUgcGF0dGVybiwgYW5kIGV2ZW4gdGhlbiBp
dCBjYW4NCj4gYmUgY29uZnVzaW5nLiAgRS5nLiBmb3IgbWUsIHJldHVybmluZyAidHJ1ZSIg
d2hlbiAuc2V0X3tjLGR9cigpIGZhaWxzIGlzIHVuZXhwZWN0ZWQsDQo+IGFuZCByZXN1bHRz
IGluIHVuaW50dWl0aXZlIGNvZGUgbGlrZSB0aGlzOg0KPiANCj4gICAgICAgICAgICAgICAg
ICBpZiAoIWt2bV9kcjZfdmFsaWQodmFsKSkNCj4gCQkJcmV0dXJuIHRydWU7DQoNCkkgZG9u
J3Qgc2VlICJyZXR1cm4gMTsiIGJlaW5nIG11Y2ggYmV0dGVyIGhlcmUuDQoNCj4gRm9yIGlz
b2xhdGVkIEFQSXMgd2hvc2UgdmFsdWVzIGFyZW4ndCBpbnRlbnRlZCB0byBiZSBwcm9wYWdh
dGVkIGJhY2sgdXAgdG8gdGhlDQo+IC5oYW5kbGVfZXhpdCgpIGNhbGwgc2l0ZSwgSSB3b3Vs
ZCBtdWNoIHJhdGhlciByZXR1cm4gMC8tRUlOVkFMLg0KDQpGaW5lIHdpdGggbWUgKEkgYWdy
ZWUgdGhpcyB3b3VsZCBiZSBtb3JlIHJlYWRhYmxlKS4NCg0KPiBEbyB5b3UgaGF2ZSBhIHNr
ZXRjaCBvZiB3aGF0IHRoZSBlbmQgZ29hbC9yZXN1bHQgd2lsbCBsb29rIGxpa2U/ICBJSVJD
LCBsYXN0IHRpbWUNCj4gYW55b25lIGxvb2tlZCBhdCBkb2luZyB0aGlzICh3aGljaCB3YXMg
YSBmZXcgeWVhcnMgYWdvLCBidXQgSSBkb24ndCB0aGluayBLVk0gaGFzDQo+IGNoYW5nZWQg
X3RoYXRfIG11Y2gpLCB3ZSBiYWNrZWQgb2ZmIGJlY2F1c2UgYSBwYXJ0aWFsIGNvbnZlcnNp
b24gd291bGQgbGVhdmUgS1ZNDQo+IGluIGFuIHVud2llbGR5IGFuZCBzb21ld2hhdCBzY2Fy
eSBzdGF0ZS4NCg0KSW4gdGhlIGVuZCBJJ2QgbGlrZSB0byBnZXQgcmlkIG9mIG1vc3QgInJl
dHVybiAxOyIgYW5kIHNldmVyYWwgInJldHVybiAwOyINCmluc3RhbmNlcyBpbiBLVk0uDQoN
ClRoZSBtYWluIHJlYXNvbiBpcyB0aGF0IGl0IGlzIHNvbWV0aW1lcyB2ZXJ5IGhhcmQgdG8g
ZGV0ZXJtaW5lIHdoYXQgdGhlDQpjdXJyZW50ICJyZXR1cm4gMSIgaXMgbWVhbnQgdG8gc2F5
ICgiZXJyb3IiIG9yICJyZXR1cm4gdG8gZ3Vlc3QiIG9yIGp1c3QNCiJva2F5IikuIFRoaXMg
aXMgZXNwZWNpYWxseSB0cnVlIGluIHNvbWUgb2YgdGhlIGxvdyBsZXZlbCBNU1IgZW11bGF0
aW9uDQpjb2RlLCBlLmcuIGluIGt2bV9wbXVfZ2V0X21zcigpOiBvbmx5IGFmdGVyIGV4YW1p
bmluZyB0aGUgY2FsbCBwYXRocyBJIHdhcw0Kc3VyZSB0aGUgInJldHVybiAwIiB3YXNuJ3Qg
bWVhbnQgdG8gcmV0dXJuIHRvIHFlbXUsIGJ1dCB0byBpbmRpY2F0ZSBzdWNjZXNzLg0KDQpJ
IGhhdmUgYWxyZWFkeSBzdGFydGVkIHRvIHJlcGxhY2UgdGhlICJyZXR1cm4gMTsiIGluc3Rh
bmNlcyBpbiB0aGUgZXhpdA0KaGFuZGxlcnMgd2l0aCAicmV0dXJuIEtWTV9SRVRfR1VFU1Q7
IiwgYnV0IHRoZSBNU1IgZW11bGF0aW9uIGNvZGUgY29udmluY2VkDQptZSB0byBhbmFseXpl
IGl0IGZpcnN0IGFuZCB0byBjbGVhciBpdCB1cCBiZWZvcmUgY2hhbmdpbmcgYW55IG9mIGl0
cyAiMSINCnJldHVybiB2YWx1ZXMgYnkgYWNjaWRlbnQgdG8gIktWTV9SRVRfR1VFU1QiLg0K
DQpJbiB0aGUgZW5kIG15IHBsYW4gaXMgdG8gY292ZXIgYWxsIGFyY2hzIHRvIHJlcGxhY2Ug
dGhlIGxpdGVyYWwgIjEicyB3aXRoDQoiS1ZNX1JFVF9HVUVTVCIgd2hlcmUgYXBwcm9wcmlh
dGUsIGFuZCBhcyBtYW55IG90aGVyIGxpdGVyYWwgIjEicyBhcyBwb3NzaWJsZQ0Kd2l0aCBt
b3JlIG1lYW5pbmdmdWwgZGVmaW5lcy4NCg0KSSBob3BlZCB0byBnZXQgdGhpcyBkb25lIG11
Y2ggZWFybGllciBhbmQgZmFzdGVyLCBidXQgdGhpcyBpcyBxdWl0ZSBhIHlhayB0bw0Kc2hh
dmUuIDotKQ0KDQpJIHJlYWxpemVkIHRoYXQgcHVzaGluZyBvdXQgcGF0Y2hlcyBhcyBzb29u
IGFzIHBvc3NpYmxlIGlzIHRoZSBvbmx5IHdheSB0bw0KZ2V0IHRoaXMgZmluaXNoZWQgYXQg
YWxsLCBhcyB0aGlzIGlzIGEgbW92aW5nIHRhcmdldCB3aXRoIGFsbCB0aGUgd29yayBvZg0K
b3RoZXJzIHdoaWNoIG1pZ2h0IGludGVyZmVyZS4gU28gbXkgcmV2aXNlZCBwbGFuIGlzIHRv
IGRvIG9uZSBhcmNoIGFmdGVyDQp0aGUgb3RoZXIgYW5kIGluIGVhY2ggYXJjaCB0byBjb3Zl
ciBzdHVmZiBsaWtlIHRoZSBNU1IgZW11bGF0aW9uIGZpcnN0IGluDQpvcmRlciBub3QgdG8g
bWl4IHRoaW5ncyB1cCBhZ2Fpbi4NCg0KPj4gVGhpcyB3b3JrIGlzIGEgcHJlbHVkZSBvZiBn
ZXR0aW5nIHJpZCBvZiB0aGUgbWFnaWMgdmFsdWUgIjEiIGZvcg0KPj4gInJldHVybiB0byBn
dWVzdCIuIEkgc3RhcnRlZCBpbiB4ODYgS1ZNIGhvc3QgY29kZSBkb2luZyB0aGF0IGFuZCBz
b29uDQo+PiBzdHVtYmxlZCBvdmVyIGxvdHMgb2Ygb3RoZXIgdXNlIGNhc2VzIG9mIHRoZSBt
YWdpYyAiMSIgYXMgcmV0dXJuIHZhbHVlLA0KPj4gZXNwZWNpYWxseSBpbiBNU1IgZW11bGF0
aW9uIHdoZXJlIGEgY29tbWVudCBldmVuIGltcGxpZWQgdGhpcyAiMSIgd2FzDQo+PiBkdWUg
dG8gdGhlICJyZXR1cm4gdG8gZ3Vlc3QiIHNlbWFudGljcy4NCj4+DQo+PiBBIGRldGFpbGVk
IGFuYWx5c2lzIG9mIGFsbCByZWxhdGVkIGNvZGUgcGF0aHMgcmV2ZWFsZWQgdGhhdCB0aGVy
ZSB3YXMNCj4+IGluZGVlZCBhIHJhdGhlciBjbGVhbiBpbnRlcmZhY2UgYmV0d2VlbiB0aGUg
ZnVuY3Rpb25zIHVzaW5nIHRoZSBNU1INCj4+IGVtdWxhdGlvbiAiMSIgYW5kIHRob3NlIHVz
aW5nIHRoZSAicmV0dXJuIHRvIGd1ZXN0IiAiMSIuDQo+IA0KPiBZYSwgd2UndmUgc3RhcnRl
ZCBjaGlwcGluZyBhd2F5IGF0IHRoZSBNU1Igc3R1ZmYuICBUaGUgYmlnIGNoYWxsZW5nZSBp
cyBhdm9pZGluZw0KPiBzdWJ0bGUgQUJJIGNoYW5nZXMgcmVsYXRlZCB0byB0aGUgZml4dXBz
IGRvbmUgYnkga3ZtX2RvX21zcl9hY2Nlc3MoKS4NCg0KUmlnaHQuDQoNClRoaXMgd2hvbGUg
d29yayB3YXMgdHJpZ2dlcmVkIGJ5IG15IGFjY2lkZW50YWwgImZpeCIgb2Yga3ZtX21tdV9w
YWdlX2ZhdWx0KCkNCnJlcGxhY2luZyBhICIxIiB3aXRoICJSRVRfUEZfUkVUUlkiLCB3aGlj
aCB5b3Ugc3RvcHBlZCBmcm9tIGhpdHRpbmcgdXBzdHJlYW0uDQoNCg0KSnVlcmdlbg0K
--------------ojkqFTTTuLiNbF3pMrquQqMR
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------ojkqFTTTuLiNbF3pMrquQqMR--

--------------IcOpqvpa9gM9MYSeng3eqFrr--

--------------BPTpYUTG4A0qsuxwtHQtECkx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmky/p4FAwAAAAAACgkQsN6d1ii/Ey9U
ZwgAi2vL+4t/NbgDk8r8FZoGyvzA+upfgleTFeFsDaPpaox6fG+qNnbT+uESrm7gZdZssJKwKhHh
u4nlUCIP89fw83hTeAZAQ3Kq60MtvBLBFfD+e7gUSjyC/U6MV2DVWPWZ75AfbBO7KcG3yo4hWEr9
ox1OBOTOpcQM4b5F98fhlQsoONe0beBW6SbvOyeaKRDxruZHQJetPfjXN4plaOSnt3bg2STAsylr
MM2UXxOrt5CFvr+rPODFPJDgwO13AnNaBrGaRkxCJKByEumHAIVMgi0QDkix3Rx2p6iivPVHl4t1
V3daqKyHUGfMn75qEOpzdZ4/HGlykIdmLj91/gdU4A==
=1UNM
-----END PGP SIGNATURE-----

--------------BPTpYUTG4A0qsuxwtHQtECkx--

