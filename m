Return-Path: <kvm+bounces-55258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9BAAB2EDE3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 08:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FD775E23C4
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB8B28642E;
	Thu, 21 Aug 2025 06:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G2Pm+G6M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6440721C9ED
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 06:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755756168; cv=none; b=aBz0Xo+X1oegleWQ0Vpr+gn3/q+aCv40TH1rlhpbAoRCFlXMdqWPo3lVZ/gHgt9ApUbmfgXRD4IBInp6XcjVgVhzjA84ienYBfbxjl1ZpXlkwiHVxzmjXcfdLCLJ5iN1hwPItJEKUxKEKFsxagEICCt1wqwUf3yd1pMeYgzP9ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755756168; c=relaxed/simple;
	bh=fdECNDsiGebUu74L4g2NDdlaQYjWw7SdZ06FIM0bnGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=giqx7fbomn3DyYTfpRRraWRanF6e9Kkutlw54NTKWBsAAesL5JKTEbS+KMmorfH3aCQm9kwcECOjtJNx/aGPQuRDe/CiDkfmjS0ntEhmaoK5Y/7hceVMQj2XU0uBDxxuYJutUVFMl40W88OthPO2YFnKJmvTPnAHSdZd+vjFRIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G2Pm+G6M; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afcb7a16441so89611066b.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 23:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755756165; x=1756360965; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fdECNDsiGebUu74L4g2NDdlaQYjWw7SdZ06FIM0bnGI=;
        b=G2Pm+G6MPJoHcW2gAB8XB4ZJrcCxyE2Ejsz3fGQV+R8zlcOXQdPcjEbG1dNSm+llff
         5ZBofsUI3cXBthQvgRIv2+HcAMLyslYoIaDMBe8G2E6MUX9qwpjH6sXFhpV4UexAmbs2
         HToiGIG0fagYDH9pI49JDZmz9ynLX48e1jiAm5+5tvOmxb/zDDEEqTTqBhSM8oBX4cBJ
         57rV2o4Fjao0MEUPKZ3oHfoAMR99ScGAiuMFIsSEg0fofmTf02InbN6slE2dtQwNVElO
         aFX/oxi5Phk7A0jITPtflcvaQGxmy9Vb9jAWwBfm/sML2wVFeGANvKzDJyKu0bhizzqZ
         CaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755756165; x=1756360965;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fdECNDsiGebUu74L4g2NDdlaQYjWw7SdZ06FIM0bnGI=;
        b=UO6387en0NcHxgaRSoGDnkwL1rzviXkxsVIQo8O31hT////DROVbT5AlY8+VZoyigX
         RyCl003h2RJthxHrJcOc8lw86TEtFCkTeRm5VGflXM1xw857isjSDOomNdZB3PsmHA6o
         XIRDYD0sa4PUnJwuVAnmEt+xAwaP76i7+tpRoci5gunCiqCxVTJ+jtXaPEpQgPz3ylK6
         iK+xCztBL9ILYrTYSBz8mGbgYc5kFai1kNbllENlIMI/dtq0VjkFNGzuIz8+Qp3NZa/B
         a/9IiwrzaKP+Xtuyj+tepNoJ/FuohlHWGvygsQ1XljeT3hCz7IXOE3L8iPDckV0hFyiL
         Lg0g==
X-Forwarded-Encrypted: i=1; AJvYcCWnL+APYFSD5yFMYqLEgFRU/2UVQeP7I92x/twrGDkhUR2fUkOmBi1ycLIpS1N4pQxuank=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjWUwwzm9LWpITNzsH3kKzzwTcxKCTQxSC5IB3RDol4g2iAcX6
	ZUvb9UQgUkwb4CBMSjt7t0dOoJKF3DIlVdr57+sYiqZSmhYzP7CISnIlKOz6Laxd2KY=
X-Gm-Gg: ASbGnctTK2QNI5fwuOGMpvb3YKQxcieax6OBN+pruCz5I4WbN6sHEFAiy0wnuroLlDq
	q4jKA8liaLNjnq8nHiNJMblWaA1DlbflopP9fTYy/rQxCS67WqZ6RPiIg4wDfSHAfmKKWU43ORS
	goYQBQKF+bJpYSzoTuxVSV8VJ+d7xs4ytwOioqVFh3dtyVbKi9EL04CgDNvmD9VfN/hgiNJfY4A
	VcDVrfGBpQNCx5OR9BojE1f9fSnWb8vL8LSu8hjI9jzDJX5Dl0PsQs6RJhxKKW7wxAoXSS167xs
	YROhH9a82zcSCHArv+/GkXHgrSOFlDCKq167jQ8vVC4QiiVliOLshnwQPZRtk4U2v1Bewbp+w2K
	2QCn5Mmyu+56LNwf7tcmfBO8ixfNWbdVP5vey4PhTbEqQ6BEobGBryndvR1v9CbXWpWBd0EIFJp
	ezmCSoD4YD6aZ7JKqMrHEz/wdVscTY1miJReKnPzmqhd9B0rlbRF+Y7gfYcz7KuRHmNJBV
X-Google-Smtp-Source: AGHT+IHsosajA2d/NGUSIiN45qGoTaNkQgpbCLCE9sSySHOaLSCcdYvsMspda9L/rhn6DCB8r5zF+g==
X-Received: by 2002:a17:907:1b09:b0:af2:7ccd:3429 with SMTP id a640c23a62f3a-afe0787b726mr110416266b.9.1755756164417;
        Wed, 20 Aug 2025 23:02:44 -0700 (PDT)
Received: from ?IPV6:2003:e5:872d:6400:8c05:37ee:9cf6:6840? (p200300e5872d64008c0537ee9cf66840.dip0.t-ipconnect.de. [2003:e5:872d:6400:8c05:37ee:9cf6:6840])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded2bad79sm323826266b.9.2025.08.20.23.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 23:02:43 -0700 (PDT)
Message-ID: <218c4e93-4da6-4286-bb17-dd68c9d6db66@suse.com>
Date: Thu, 21 Aug 2025 08:02:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Binbin Wu <binbin.wu@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, Jianxiong Gao <jxgao@google.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dionna Glaze <dionnaglaze@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 pbonzini@redhat.com, Peter Gonda <pgonda@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Tom Lendacky
 <thomas.lendacky@amd.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 x86@kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>,
 jiewen.yao@intel.com
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com>
 <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com> <aIDzBOmjzveLjhmk@google.com>
 <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
 <aIeX0GQh1Q_4N597@google.com>
 <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
 <CAGtprH9EL0=Cxu7f8tD6rEvnpC7uLAw6jKijHdFUQYvbyJgkzA@mail.gmail.com>
 <20641696-242d-4fb6-a3c1-1a8e7cf83b18@linux.intel.com>
 <697aa804-b321-4dba-9060-7ac17e0a489f@linux.intel.com>
 <aKYMQP5AEC2RkOvi@google.com>
 <d84b792e-8d26-49c2-9e7c-04093f554f8a@linux.intel.com>
 <f1ec8527-322d-4bdb-9a38-145fd9f28e4b@linux.intel.com>
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
In-Reply-To: <f1ec8527-322d-4bdb-9a38-145fd9f28e4b@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------2MfuXcvxug2VLYSoSv3dz04Q"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------2MfuXcvxug2VLYSoSv3dz04Q
Content-Type: multipart/mixed; boundary="------------iSNfml08aoXAkYOslibcpctk";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Binbin Wu <binbin.wu@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, Jianxiong Gao <jxgao@google.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dionna Glaze <dionnaglaze@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 pbonzini@redhat.com, Peter Gonda <pgonda@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Tom Lendacky
 <thomas.lendacky@amd.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 x86@kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>,
 jiewen.yao@intel.com
Message-ID: <218c4e93-4da6-4286-bb17-dd68c9d6db66@suse.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com>
 <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com> <aIDzBOmjzveLjhmk@google.com>
 <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
 <aIeX0GQh1Q_4N597@google.com>
 <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
 <CAGtprH9EL0=Cxu7f8tD6rEvnpC7uLAw6jKijHdFUQYvbyJgkzA@mail.gmail.com>
 <20641696-242d-4fb6-a3c1-1a8e7cf83b18@linux.intel.com>
 <697aa804-b321-4dba-9060-7ac17e0a489f@linux.intel.com>
 <aKYMQP5AEC2RkOvi@google.com>
 <d84b792e-8d26-49c2-9e7c-04093f554f8a@linux.intel.com>
 <f1ec8527-322d-4bdb-9a38-145fd9f28e4b@linux.intel.com>
In-Reply-To: <f1ec8527-322d-4bdb-9a38-145fd9f28e4b@linux.intel.com>

--------------iSNfml08aoXAkYOslibcpctk
Content-Type: multipart/mixed; boundary="------------sbCUedizuOSyjThHNHVuczye"

--------------sbCUedizuOSyjThHNHVuczye
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjEuMDguMjUgMDc6MjMsIEJpbmJpbiBXdSB3cm90ZToNCj4gDQo+IA0KPiBPbiA4LzIx
LzIwMjUgMTE6MzAgQU0sIEJpbmJpbiBXdSB3cm90ZToNCj4+DQo+Pg0KPj4gT24gOC8yMS8y
MDI1IDE6NTYgQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+Pj4gT24gV2VkLCBB
dWcgMjAsIDIwMjUsIEJpbmJpbiBXdSB3cm90ZToNCj4gWy4uLl0NCj4+Pj4gSGkgU2VhbiwN
Cj4+Pj4NCj4+Pj4gU2luY2UgZ3Vlc3RfZm9yY2VfbXRycl9zdGF0ZSgpIGFsc28gc3VwcG9y
dHMgdG8gZm9yY2UgTVRSUiB2YXJpYWJsZSByYW5nZXMsDQo+Pj4+IEkgYW0gd29uZGVyaW5n
IGlmIHdlIGNvdWxkIHVzZSBndWVzdF9mb3JjZV9tdHJyX3N0YXRlKCkgdG8gc2V0IHRoZSBs
ZWdhY3kgUENJDQo+Pj4+IGhvbGUgcmFuZ2UgYXMgVUM/DQo+Pj4+DQo+Pj4+IElzIGl0IGxl
c3MgaGFja3k/DQo+Pj4gT2ghwqAgVGhhdCdzIGEgd2F5IGJldHRlciBpZGVhIHRoYW4gbXkg
aGFjay7CoCBJIG1pc3NlZCB0aGF0IHRoZSBrZXJuZWwgd291bGQgDQo+Pj4gc3RpbGwNCj4+
PiBjb25zdWx0IE1UUlJzLg0KPj4+DQo+Pj4gQ29tcGlsZSB0ZXN0ZWQgb25seSwgYnV0IHNv
bWV0aGluZyBsaWtlIHRoaXM/DQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2Vy
bmVsL2t2bS5jIGIvYXJjaC94ODYva2VybmVsL2t2bS5jDQo+Pj4gaW5kZXggOGFlNzUwY2Rl
MGM2Li40NWM4ODcxY2RkYTEgMTAwNjQ0DQo+Pj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2t2
bS5jDQo+Pj4gKysrIGIvYXJjaC94ODYva2VybmVsL2t2bS5jDQo+Pj4gQEAgLTkzMyw2ICs5
MzMsMTMgQEAgc3RhdGljIHZvaWQga3ZtX3Nldl9oY19wYWdlX2VuY19zdGF0dXModW5zaWdu
ZWQgbG9uZyANCj4+PiBwZm4sIGludCBucGFnZXMsIGJvb2wgZW5jKQ0KPj4+IMKgIMKgIHN0
YXRpYyB2b2lkIF9faW5pdCBrdm1faW5pdF9wbGF0Zm9ybSh2b2lkKQ0KPj4+IMKgIHsNCj4+
PiArwqDCoMKgwqDCoMKgIHU2NCB0b2x1ZCA9IGU4MjBfX2VuZF9vZl9sb3dfcmFtX3Bmbigp
IDw8IFBBR0VfU0hJRlQ7DQo+Pj4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3QgbXRycl92YXJfcmFu
Z2UgcGNpX2hvbGUgPSB7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLmJh
c2VfbG8gPSB0b2x1ZCB8IFg4Nl9NRU1UWVBFX1VDLA0KPj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIC5tYXNrX2xvID0gKHUzMikofihTWl80RyAtIHRvbHVkIC0gMSkpIHwg
QklUKDExKSwNCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAubWFza19oaSA9
IChCSVRfVUxMKGJvb3RfY3B1X2RhdGEueDg2X3BoeXNfYml0cykgLSAxKSA+PiAzMiwNCj4+
PiArwqDCoMKgwqDCoMKgIH07DQo+Pj4gKw0KPj4NCj4+IFRoaXMgdmFsdWUgb2YgdG9sdWTC
oCBtYXkgbm90IG1lZXQgdGhlIHJhbmdlIHNpemUgYW5kIGFsaWdubWVudCByZXF1aXJlbWVu
dCBmb3INCj4+IHZhcmlhYmxlIE1UUlIuDQo+Pg0KPj4gVmFyaWFibGUgTVRSUiBoYXMgcmVx
dWlyZW1lbnQgZm9yIHJhbmdlIHNpemUgYW5kIGFsaWdubWVudDoNCj4+IEZvciByYW5nZXMg
Z3JlYXRlciB0aGFuIDQgS0J5dGVzLCBlYWNoIHJhbmdlIG11c3QgYmUgb2YgbGVuZ3RoIDJe
biBhbmQgaXRzIGJhc2UNCj4+IGFkZHJlc3MgbXVzdCBiZSBhbGlnbmVkIG9uIGEgMl5uIGJv
dW5kYXJ5LCB3aGVyZSBuIGlzIGEgdmFsdWUgZXF1YWwgdG8gb3INCj4+IGdyZWF0ZXIgdGhh
biAxMi4gVGhlIGJhc2UtYWRkcmVzcyBhbGlnbm1lbnQgdmFsdWUgY2Fubm90IGJlIGxlc3Mg
dGhhbiBpdHMgbGVuZ3RoLg0KPiANCj4gV2FpdCwgTGludXgga2VybmVsIGNvbnZlcnRzIE1U
UlIgcmVnaXN0ZXIgdmFsdWVzIHRvIE1UUlIgc3RhdGUgKGJhc2UgYW5kIHNpemUpIGFuZA0K
PiBjYWNoZSBpdCBmb3IgbGF0ZXIgbG9va3VwcyAocmVmZXIgdG8gbWFwX2FkZF92YXIoKSku
IEkuZS4sIGluIExpbnV4IGtlcm5lbCwNCj4gb25seSB0aGUgY2FjaGVkIHN0YXRlIHdpbGwg
YmUgdXNlZC4NCj4gDQo+IFRoZXNlIE1UUlIgcmVnaXN0ZXIgdmFsdWVzIGFyZSBuZXZlciBw
cm9ncmFtbWVkIHdoZW4gdXNpbmcNCj4gZ3Vlc3RfZm9yY2VfbXRycl9zdGF0ZSgpICwgc28g
ZXZlbiB0aGUgdmFsdWVzIGRvZXNuJ3QgbWVldCB0aGUNCj4gcmVxdWlyZW1lbnQgZnJvbSBo
YXJkd2FyZSBwZXJzcGVjdGl2ZSwgTGludXgga2VybmVsIGNhbiBzdGlsbCBnZXQgdGhlIHJp
Z2h0IGJhc2UgDQo+IGFuZCBzaXplLg0KPiANCj4gTm8gYm90aGVyaW5nIHRvIGZvcmNlIHRo
ZSBiYXNlIGFuZCBzaXplIGFsaWdubWVudC4NCj4gQnV0IGEgY29tbWVudCB3b3VsZCBiZSBo
ZWxwZnVsLg0KPiBBbHNvLCBCSVQoMTEpIGNvdWxkIGJlIHJlcGxhY2VkIGJ5IE1UUlJfUEhZ
U01BU0tfVi4NCj4gDQo+IEhvdyBhYm91dDoNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tl
cm5lbC9rdm0uYyBiL2FyY2gveDg2L2tlcm5lbC9rdm0uYw0KPiBpbmRleCA5MDA5N2RmNGVh
ZmQuLmE5NTgyZmZjMzA4OCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2t2bS5j
DQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9rdm0uYw0KPiBAQCAtOTM0LDkgKzkzNCwxNSBA
QCBzdGF0aWMgdm9pZCBrdm1fc2V2X2hjX3BhZ2VfZW5jX3N0YXR1cyh1bnNpZ25lZCBsb25n
IHBmbiwgDQo+IGludCBucGFnZXMsIGJvb2wgZW5jKQ0KPiAgwqBzdGF0aWMgdm9pZCBfX2lu
aXQga3ZtX2luaXRfcGxhdGZvcm0odm9pZCkNCj4gIMKgew0KPiAgwqAgwqAgwqAgwqAgdTY0
IHRvbHVkID0gZTgyMF9fZW5kX29mX2xvd19yYW1fcGZuKCkgPDwgUEFHRV9TSElGVDsNCg0K
SSdkIHByZWZlciB0byBhdm9pZCBvcGVuIGNvZGluZyBQRk5fUEhZUygpIGhlcmUuDQoNCj4g
K8KgIMKgIMKgIMKgLyoNCj4gK8KgIMKgIMKgIMKgICogVGhlIHJhbmdlJ3MgYmFzZSBhZGRy
ZXNzIGFuZCBzaXplIG1heSBub3QgbWVldCB0aGUgYWxpZ25tZW50DQo+ICvCoCDCoCDCoCDC
oCAqIHJlcXVpcmVtZW50IGZvciB2YXJpYWJsZSBNVFJSLiBIb3dldmVyLCBMaW51eCBndWVz
dCBuZXZlcg0KPiArwqAgwqAgwqAgwqAgKiBwcm9ncmFtcyBNVFJScyB3aGVuIGZvcmNpbmcg
Z3Vlc3QgTVRSUiBzdGF0ZSwgbm8gYm90aGVyaW5nIHRvDQo+ICvCoCDCoCDCoCDCoCAqIGVu
Zm9yY2UgdGhlIGJhc2UgYW5kIHJhbmdlIHNpemUgYWxpZ25tZW50Lg0KPiArwqAgwqAgwqAg
wqAgKi8NCg0KTWF5YmUgYSByZWxhdGVkIGNvbW1lbnQgc2hvdWxkIGJlIGFkZGVkIHRvIGd1
ZXN0X2ZvcmNlX210cnJfc3RhdGUoKSBpbg0Kb3JkZXIgdG8gYXZvaWQgYnJlYWtpbmcgdGhp
cyB3b3JrYXJvdW5kIGFnYWluLg0KDQoNCkp1ZXJnZW4NCg==
--------------sbCUedizuOSyjThHNHVuczye
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------sbCUedizuOSyjThHNHVuczye--

--------------iSNfml08aoXAkYOslibcpctk--

--------------2MfuXcvxug2VLYSoSv3dz04Q
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmimtoIFAwAAAAAACgkQsN6d1ii/Ey8T
wQf5Aa1NxQFM2TeeWP+YhltUXd/7WFcYeUNgtTu80Hwi+Dqe+vZIOXj1islE3G7X8VLtJzsIbZ5I
cVaIFbpVkI+FFKvjcLU6FQbVXr+zSmH0N4zECghsBXIS+ce/DyiWPJXrhgAXbG0OLhP4mWDW6eWc
5DI6kDwzxvbmC6LoFW/Ek6HtEbFtWeqNaUI+YKT7rDvPMRsShU6TEYVHZlolXObNEbInfBW52DYe
KOCSa3+vC3RwOoeVAiAOb5yDzwHUYeNjCV2jzCOTuld5jg40qcJyGzBZ4l7mC9F1PGfjpim5D6mb
00yQjcYId1AmEDGRMOMdh7+r8qtJdME+fNmoR1e/NQ==
=B0NK
-----END PGP SIGNATURE-----

--------------2MfuXcvxug2VLYSoSv3dz04Q--

