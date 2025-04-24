Return-Path: <kvm+bounces-44097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73534A9A586
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:14:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB7C4623C5
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4020620A5EC;
	Thu, 24 Apr 2025 08:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g5ipNrlQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C015E1F8BA6
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745482467; cv=none; b=uuyz2Sz9CPfVSaOeSNs6AhE4a2AjhBmP3pLqkd4PTAh57c9W3/ZB0IoHOO7Uug4qPopu+RcEboGjec4keNY0iDXOrMFGOsOUwRFYqszAgPFqT/9lMCJAU+usVW1AeznEiH9tY2q/SpB4rygUu01+ov2y5KiUWfuhMEAD4ZCy8Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745482467; c=relaxed/simple;
	bh=008EJSG/phqGVPmxi0nDH3NCIHBvP55QLSxmr4tKYHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W8V9Emy9daREXB+aSzbdGKKmQm2VoVvk5aio7zcTqL+YG5y7mFbhlCzlLm+BQaPvgFe24Jmdk741bdA9sWnuofubJ539lQzuOZTzHFXMhOB23wp9JBokhjxRw+YHntKQaZSFGXbkteFuaqNn+vTOjET42TkmMh0rpsXRBm2LOa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g5ipNrlQ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso4312735e9.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 01:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745482463; x=1746087263; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=008EJSG/phqGVPmxi0nDH3NCIHBvP55QLSxmr4tKYHM=;
        b=g5ipNrlQnbWNQDx5PIdtRQxcoYaTUktowF593eplhxCKnKvGsx8xL5Io9JUFqMREuH
         uifLo70GGibNxkA8BZJteNwZ6EAF6s3nY8zDad3SPCPDHIW8oJyJtj9ld22kl1EUa7/q
         Lq1uEOedlXyJ23cirzmv3C2OhC5i7BWJ9jmtvolAe7r3Pk+oDVHQQqFcu1K6F0Ym2RYk
         XNmFokhCNHR0lp3MdXn/d2pua9jvTf3BLD4icK36KM7xmjCMjXw6Btf/U1t7BPZNU1mu
         n7zr9HdwCu+uMliMO3ktz7yD82fUwnl47w0KptodS04C/vn7at/8RzvBzNPnfB/xHfev
         zt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745482463; x=1746087263;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=008EJSG/phqGVPmxi0nDH3NCIHBvP55QLSxmr4tKYHM=;
        b=Jnl3yk1SHBcBLiYuQW66ft0NQclZfFvh011o/60xHMxeLgRVqsi+tHbx7pBCSPhHXS
         /rk/waZOuBjPAt7zruHk+4a2H7eWtp/GdcgfNEdD+1StS+OSHoiNlFk3YaI/Oz8+DPzn
         V02BBEziZpd+wojRi+2sk+g7JGmJafYZGzLIhtFLEhv64aFyP0r42D7T0LQar+jORI2E
         weSqahRCXLtkIwBSMPbJ0XGorHHmzT/QHJ9kzvFYiIRZpaSKoIld1d2HL6GkhNOIrzOj
         4BdWCseRsNOTejaaQI//IdNg29uo6AC4mlG4OoM39m/v7PI9qu71dLqeuTHP7NafSjV1
         3RKw==
X-Forwarded-Encrypted: i=1; AJvYcCXRBLjv83It+mpL7FjfoYRYsrycoqOcAwPKxj5Rh2Hbudi4uv/XrG6qPq1HW98XX6hL5LQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9uiSBsEj60pKJJQ8pNR2bPO9MGbPWQcqUJIYAnTxyoLjxQvVG
	k29D3CNgRuYl/2Tyb0z1WSZXZ8UqR9JSMhMCPYzYk+Zzq55U32yrd/KE08rYKVg=
X-Gm-Gg: ASbGncvRJbpKgr3z4j6Tjd9/8jtmzeFZGTIWzQFhI4riuYq5xbGU89VURpXREe6Bz04
	oh4/i6VqNXUM66Q53c6K1ASiw+NeQ1T/E6alN535SEE7OdsS3hVu37/5GgjvVbdylNXB69qRlJr
	5hMFovu3CYgLOXTpfuNtgH6y8D0U1Eg7z14AdNZRChD+S5qCKlHv9tfof84kdXfy1/05GS4I4JU
	sNcrVdzUPG3WrK1AQPTl9T7hHxejtwbyAMbRQdX/Qyx3pfGv1v5q9b8FQ6su34Oz3xjRPcFy6Gt
	jzEyobAscHCYn3l5Uhq9uQi2gFOi49kbFfsD0FK7IoRvO1uZ7D6IuNfO1kEfvpoShrb6Su4llSD
	kBpqKfBSpdOOrk716lSrWCTAA3ac5hmiIgr3ghfWeNbVCMkImL2r9aThpwsQxw0pjbA==
X-Google-Smtp-Source: AGHT+IFyv2kCFIwtSgJfhMLoeL4umabM8GMXtTutcFH/tZ4GaYnDHHb5JDeYCLMrA1sChvoEPbh09w==
X-Received: by 2002:a05:600c:1d03:b0:43d:db5:7b1a with SMTP id 5b1f17b1804b1-4409bd2225dmr12614855e9.12.1745482462951;
        Thu, 24 Apr 2025 01:14:22 -0700 (PDT)
Received: from ?IPV6:2003:e5:870f:e000:6c64:75fd:2c51:3fef? (p200300e5870fe0006c6475fd2c513fef.dip0.t-ipconnect.de. [2003:e5:870f:e000:6c64:75fd:2c51:3fef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2bfa93sm10528525e9.37.2025.04.24.01.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 01:14:22 -0700 (PDT)
Message-ID: <0cdc6e9d-88eb-4ead-8d55-985474257d53@suse.com>
Date: Thu, 24 Apr 2025 10:14:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
To: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
 <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
 <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
 <bb8f6b85-4e7d-440a-a8c3-0e0da45864b8@zytor.com>
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
In-Reply-To: <bb8f6b85-4e7d-440a-a8c3-0e0da45864b8@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------VMSl19Ws92VaJ19wHUdCoQEK"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------VMSl19Ws92VaJ19wHUdCoQEK
Content-Type: multipart/mixed; boundary="------------0vp5F0mv6hCcRHQUu1aj0a9v";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com
Message-ID: <0cdc6e9d-88eb-4ead-8d55-985474257d53@suse.com>
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
 <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
 <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
 <bb8f6b85-4e7d-440a-a8c3-0e0da45864b8@zytor.com>
In-Reply-To: <bb8f6b85-4e7d-440a-a8c3-0e0da45864b8@zytor.com>

--------------0vp5F0mv6hCcRHQUu1aj0a9v
Content-Type: multipart/mixed; boundary="------------0yeVN4sI0bLxwrBqbg5RE1SY"

--------------0yeVN4sI0bLxwrBqbg5RE1SY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjQuMDQuMjUgMTA6MDYsIFhpbiBMaSB3cm90ZToNCj4gT24gNC8yMy8yMDI1IDk6MDUg
QU0sIErDvHJnZW4gR3Jvw58gd3JvdGU6DQo+Pj4gSXQncyBub3QgYSBtYWpvciBjaGFuZ2Us
IGJ1dCB3aGVuIGl0IGlzIHBhdGNoZWQgdG8gdXNlIHRoZSBpbW1lZGlhdGUgZm9ybSBNU1Ig
DQo+Pj4gd3JpdGUgaW5zdHJ1Y3Rpb24sIGl0J3Mgc3RyYWlnaHRmb3J3YXJkbHkgc3RyZWFt
bGluZWQuDQo+Pg0KPj4gSXQgc2hvdWxkIGJlIHJhdGhlciBlYXN5IHRvIHN3aXRjaCB0aGUg
Y3VycmVudCB3cm1zci9yZG1zciBwYXJhdmlydCBwYXRjaGluZw0KPj4gbG9jYXRpb25zIHRv
IHVzZSB0aGUgcmRtc3Ivd3Jtc3IgaW5zdHJ1Y3Rpb25zIGluc3RlYWQgb2YgZG9pbmcgYSBj
YWxsIHRvDQo+PiBuYXRpdmVfKm1zcigpLg0KPj4NCj4+IFRoZSBjYXNlIG9mIHRoZSBuZXcg
aW1tZWRpYXRlIGZvcm0gY291bGQgYmUgaGFuZGxlZCB0aGUgc2FtZSB3YXkuDQo+IA0KPiBB
Y3R1YWxseSwgdGhhdCBpcyBob3cgd2UgZ2V0IHRoaXMgcGF0Y2ggd2l0aCB0aGUgZXhpc3Rp
bmcgYWx0ZXJuYXRpdmVzDQo+IGluZnJhc3RydWN0dXJlLsKgIEFuZCB3ZSB0b29rIGEgc3Rl
cCBmdXJ0aGVyIHRvIGFsc28gcmVtb3ZlIHRoZSBwdl9vcHMNCj4gTVNSIEFQSXMuLi4NCg0K
QW5kIHRoaXMgaXMgd2hhdCBJJ20gcXVlc3Rpb25pbmcuIElNSE8gdGhpcyBhcHByb2FjaCBp
cyBhZGRpbmcgbW9yZQ0KY29kZSBieSByZW1vdmluZyB0aGUgcHZfb3BzIE1TUl9BUElzIGp1
c3QgYmVjYXVzZSAicHZfb3BzIGlzIGJhZCIuIEFuZA0KSSBiZWxpZXZlIG1vc3QgcmVmdXNh
bCBvZiBwdl9vcHMgaXMgYmFzZWQgb24gbm8gbG9uZ2VyIHZhbGlkIHJlYXNvbmluZy4NCg0K
PiBJdCBsb29rcyB0byBtZSB0aGF0IHlvdSB3YW50IHRvIGFkZCBhIG5ldyBmYWNpbGl0eSB0
byB0aGUgYWx0ZXJuYXRpdmVzDQo+IGluZnJhc3RydWN0dXJlIGZpcnN0Pw0KDQpXaHkgd291
bGQgd2UgbmVlZCBhIG5ldyBmYWNpbGl0eSBpbiB0aGUgYWx0ZXJuYXRpdmVzIGluZnJhc3Ry
dWN0dXJlPw0KDQoNCkp1ZXJnZW4NCg==
--------------0yeVN4sI0bLxwrBqbg5RE1SY
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------0yeVN4sI0bLxwrBqbg5RE1SY--

--------------0vp5F0mv6hCcRHQUu1aj0a9v--

--------------VMSl19Ws92VaJ19wHUdCoQEK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgJ8twFAwAAAAAACgkQsN6d1ii/Ey8k
sgf/bXb/yPNEYKqkydqe/bdDkpvmLpSFUpdHMovM4PRMGt6zioNmVWczEr+IQ53jJEK1EgOrz1V5
CSe5GF6AQ52FukYXR+nsdEhvJ3SQbHcC1jjQ0KBbi7qxCIl5hNUVmyEEjIxdE5u2TPCMWxoot6t1
yNRYVLJOfCGc+rtLzkqT+DCZhmL5bJV7aHjBV/gGYMQs5mZvFWky2orA31cQd87ZQ01sJsXhSyK5
kyPT2DLGT2EUSFgkADIATsccYzDmoFGHujoktt1Dvy7KAp5Ij89J1F9z/bJPieoeXbxYM6WgXK6i
mL8fdLmqdHH+xIxH3Fw7vjbOQPVv3Q5NLHeDBr80mQ==
=oHe8
-----END PGP SIGNATURE-----

--------------VMSl19Ws92VaJ19wHUdCoQEK--

