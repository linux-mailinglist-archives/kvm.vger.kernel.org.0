Return-Path: <kvm+bounces-44112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67731A9A99D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:11:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4CB4467373
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96FFC223DDA;
	Thu, 24 Apr 2025 10:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IUUurXWB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E660221FAD
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745489478; cv=none; b=g120RNvQFGVZGFWY3+OBPEiKwCPDdALhEq5lRiNaVLLHBhHKrCX4wxAwcWkuzSctYpW44XaU/jJPsxS3/XMcR6HZHKjP7/g9kNf41pwIT9lP1BElldarvldx/9FWn0HYqBJ3Z9hL6Toc8wcgmOHnhSld5GE/8ddBvdpGThttIS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745489478; c=relaxed/simple;
	bh=fdSwYuBhxOdnqF7xkOxhz3DelClCI0K6T6vVUCDVKjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jMouPgjzJZteZ3TVMMG5ymDEf0zdp4K8Igo9CAUd6DeVtHOxoBmPy4GV0k+2JQkpkYzji5WxIBM0yUeF3aJOmMHePT4H68pRw6l6pa/A6sYre+c9CjtevyZ681jQDnCLjMl7ARntR9ussqM9jKBVXKO5zwlwhqyktnspbTrEFvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IUUurXWB; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-acb5ec407b1so139239466b.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 03:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745489475; x=1746094275; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fdSwYuBhxOdnqF7xkOxhz3DelClCI0K6T6vVUCDVKjQ=;
        b=IUUurXWBFYBMfrDYElqCnC7MV2jmQ0hg8XI2PRDBzoWHqinMtr6mLcKo1IlBbqdsHs
         ILZUEQ57yRXpxwfcyrL3MMPr8RbGEfGCfSooF3VY5LxKFzXLkwztcqNYOrF3+1jzcQuh
         b5sVo3ajxlRgPokkXdifwptxe2y3kHZ8/suXL1WBPq6Tbxqind0C+WfyAQVfJQdA7kkr
         awoPvXZTEbf6vIdOb1TEMYNkO/pclY7atJWXifVU2QpFTFQaY0Qcd9GsVwuGko12nvAv
         yxEJ3Rlw6ANnhkQygbz9Qa8sEXCOJQGTt5bgUMw9OEHbxyrN66gZzDlAlzZCsKKhRpwK
         9P2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745489475; x=1746094275;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fdSwYuBhxOdnqF7xkOxhz3DelClCI0K6T6vVUCDVKjQ=;
        b=JSajZC058NbOp1AV67xvdXrcIJUF1N9jqCPDoP507EKHWxcSAicsgGrwL5+coxEqak
         usnMxLUN75pr2lHgubACQI67NyB0Abrsgsnc7I86CXP37Ogwm3KK0geAeHdKVQBLsMdU
         4sO02G+vz6ibjReD8cSP7jq+3aOC5mClgmFP+CvBwxw58/6IPSkRjmbs1D/WTTTjgD08
         RBbdaKOQok52ZVuXMBKg7neKdUEYFubD1TEaTSMYHbPVm5fl/BpDv8Z6mld3GUTE8rN9
         e/10/ppbHcxLdWB1cRQWUtPQQZhRpMQvWS1FyLngw1e/mbUGtJZT9bxP+M4j3cRVFijB
         eFJA==
X-Forwarded-Encrypted: i=1; AJvYcCXJC4AFjaZMq7+BfU3QZmVbMKm3yQ5ZvC/mC1qW+62DHFDlbSpd/oiccjEhFq1DIXPW1/c=@vger.kernel.org
X-Gm-Message-State: AOJu0YywsK+YrLPEqNouQuFGJI2CAlEVkcT60yZ2X2mUzGFg/GVuJcYD
	qj3+4miDKlTxdLeVHt56w3lwe4aI21tKLZzkroptXO0BB6uaHeoyO+t+9IzzG3Q=
X-Gm-Gg: ASbGnctwUPZl565RANEY1TZXWEZQp/mO2f823qS06tZwir38W6X2FNjqoXLTfbBNa9O
	c3uivrMe3/aux1UEUOpIEy7CpzWz2SqExHnZ/hNd2fFUk+4aJ75ApZO6/GtUVCN/IJ0vkXsgyOc
	x2XigFm2oudnEkWuwHWK4EbqCsWtOomtpQlvHEZ2yQ8fg6n109VIqq1eyCPtj6lWziqSzjkRXYh
	7uN/rtiebgLzyailGZICg+GhgpeHwP0cItsYcXO8FoDaYe7tOwyaDo6sYaj7ICAnuhLWMSAtvzT
	hj+ZqrFMtMLL4zX25xvve/lOjqSNcoGEv2e+dbXk2FXamsr6qXQrzoaHvZ+KHWK/M57n1IMiG6j
	fFRAEpK7foHL7V7sLnTjp5+qjm+FUIUUK7wVDH6vF0SGGgVXGvlyrzAkX7+sHnoIbDQ==
X-Google-Smtp-Source: AGHT+IEbbmIPPrsikvb3BTzA0vI8qHnxarVzFktNTu67SixW/XcJ61OviQ7YGJJWqIAYONft+vNyww==
X-Received: by 2002:a17:907:7d8d:b0:ac3:4373:e8bf with SMTP id a640c23a62f3a-ace572204b7mr216108466b.10.1745489474688;
        Thu, 24 Apr 2025 03:11:14 -0700 (PDT)
Received: from ?IPV6:2003:e5:870f:e000:6c64:75fd:2c51:3fef? (p200300e5870fe0006c6475fd2c513fef.dip0.t-ipconnect.de. [2003:e5:870f:e000:6c64:75fd:2c51:3fef])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace59897e30sm83112766b.44.2025.04.24.03.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 03:11:14 -0700 (PDT)
Message-ID: <7c7de4be-e8d0-45b9-9212-186d79e95512@suse.com>
Date: Thu, 24 Apr 2025 12:11:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 13/34] x86/xen/msr: Remove the error pointer
 argument from set_reg()
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
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
 <20250422082216.1954310-14-xin@zytor.com>
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
In-Reply-To: <20250422082216.1954310-14-xin@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------S0T23vorp0xJmxsOKDfgVss5"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------S0T23vorp0xJmxsOKDfgVss5
Content-Type: multipart/mixed; boundary="------------e7SX2BGON4oOR8X6gtLTAdYZ";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <7c7de4be-e8d0-45b9-9212-186d79e95512@suse.com>
Subject: Re: [RFC PATCH v2 13/34] x86/xen/msr: Remove the error pointer
 argument from set_reg()
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-14-xin@zytor.com>
In-Reply-To: <20250422082216.1954310-14-xin@zytor.com>

--------------e7SX2BGON4oOR8X6gtLTAdYZ
Content-Type: multipart/mixed; boundary="------------8yUdmrKCo5lfdOTdqXAp6QOj"

--------------8yUdmrKCo5lfdOTdqXAp6QOj
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMDQuMjUgMTA6MjEsIFhpbiBMaSAoSW50ZWwpIHdyb3RlOg0KPiBzZXRfcmVnKCkg
aXMgdXNlZCB0byB3cml0ZSB0aGUgZm9sbG93aW5nIE1TUnMgb24gWGVuOg0KPiANCj4gICAg
ICBNU1JfRlNfQkFTRQ0KPiAgICAgIE1TUl9LRVJORUxfR1NfQkFTRQ0KPiAgICAgIE1TUl9H
U19CQVNFDQo+IA0KPiBCdXQgbm9uZSBvZiB0aGVzZSBNU1JzIGFyZSB3cml0dGVuIHVzaW5n
IGFueSBNU1Igd3JpdGUgc2FmZSBBUEkuDQo+IFRoZXJlZm9yZSB0aGVyZSBpcyBubyBuZWVk
IHRvIHBhc3MgYW4gZXJyb3IgcG9pbnRlciBhcmd1bWVudCB0bw0KPiBzZXRfcmVnKCkgZm9y
IHJldHVybmluZyBhbiBlcnJvciBjb2RlIHRvIGJlIHVzZWQgaW4gTVNSIHNhZmUgQVBJcy4N
Cg0Kc2V0X3NlZygpLCBwbGVhc2UgKGZ1cnRoZXIgdXAsIHRvbykuDQoNCj4gDQo+IFJlbW92
ZSB0aGUgZXJyb3IgcG9pbnRlciBhcmd1bWVudC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFhp
biBMaSAoSW50ZWwpIDx4aW5Aenl0b3IuY29tPg0KDQpSZXZpZXdlZC1ieTogSnVlcmdlbiBH
cm9zcyA8amdyb3NzQHN1c2UuY29tPg0KDQoNCkp1ZXJnZW4NCg==
--------------8yUdmrKCo5lfdOTdqXAp6QOj
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

--------------8yUdmrKCo5lfdOTdqXAp6QOj--

--------------e7SX2BGON4oOR8X6gtLTAdYZ--

--------------S0T23vorp0xJmxsOKDfgVss5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgKDkAFAwAAAAAACgkQsN6d1ii/Ey8n
iAf/Q6AJZFMakTRIVTgS05wIOPuMydvp8L3b0MHg2v83cNkEIg7troXAv1WpNireLBumlMqQPsna
E7/sncIbwOKkbZ2HKMnSFRDvYBp08xO7ZVbM8lGRYaJ/1vx3pvkls9dvrK3kQiKeLIN2j6+cCKXV
uPsdSv++pBdBiHP+4jqnP1xus8szgWgbgxb6MrFbo/5sqMGIKVn0RggRKVSI74Bk3ohbrhKbkPSd
RmqEioBJsYwKvBLXcwVeDsT5mMAnoPh4J0s1i0qH4xeF/07FSclbHljXeLQ+CCmK0BrOuG/CIwuL
g9vlmHLxYyJ+Fkhk0Ebh1uIdY+8KGzFGtrSV+tRLyQ==
=TDhx
-----END PGP SIGNATURE-----

--------------S0T23vorp0xJmxsOKDfgVss5--

