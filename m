Return-Path: <kvm+bounces-43811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7512A96538
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C347189CFD9
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC55204689;
	Tue, 22 Apr 2025 09:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dPvsgzst"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D83D20B7FE
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745315828; cv=none; b=uWvbxFMyZ7cVfp8VFLbZ30rKsYGvVgLldHITanIFmhq6E7sBUzISOsRAFzjrsDfrsuBoAUDJF1uUBp6R2eaRK3uzLW/lJ0PleFa/Tahjdo3z4pT2JzSX2ahmdsMi3sqFV78l/VssQiLVRVJT1NLML4fHzCU9OspvAUlpxIQ0Rzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745315828; c=relaxed/simple;
	bh=ra2hUSK0u1Z8gUcixrox3gM8oCMvOjxq55/e3XVGs0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J2JogT9oz4RzAR8fHcSikr/d+hVTomhbTOaXyBPdxZIg0ka16jRlcU3/joI8Wq8n6udwlnK4DP8zKg181ilLCmH04MqLCZI26cpFXLBCPmlSYvskI/elamSsK+yQxQwC2fDGkZNQ6Z5D4PFRQOIpmI+s5ObaQepsKY8gglaooXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dPvsgzst; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso53917535e9.1
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 02:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745315824; x=1745920624; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ra2hUSK0u1Z8gUcixrox3gM8oCMvOjxq55/e3XVGs0c=;
        b=dPvsgzstmKQEwnc4EJpIvqVl+k+qH9HoZpWdC5QDpatDl8oIVWHU63hWl1GUkPnmUX
         kgXC29YG1EQIjY2GosRoBbXHjWHebFXGLaO3E9BE1eTBgGd1fJWdXVKMLYXvJaaEXm85
         d1ji4J0Y9mXzmxMsZ6Ey/PTvt58XJ9JowebgLx1dRKc4Mtdi5nY8qm7MindShVx3og8q
         2DJ0VsfvQSHY3tn+sqVl803vU4TMIfmdt0YiAsI7Z8VOVwsykI4NOZhjE4LRIN/vlzfb
         Hd8Ct9yv0DjPEoQ7pZYYxOkivkwqLquE1Lo59iY2YByii/azz92ECzZ5DBI/uEWG5tl0
         Kl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745315824; x=1745920624;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ra2hUSK0u1Z8gUcixrox3gM8oCMvOjxq55/e3XVGs0c=;
        b=JdlbOjLnfmE3krc3w+O96AoManNfDahXCL31ipWUNSfm+rFPUxVAI/UyA3OOoEzWh8
         izpHR0vVEM08DchCwtkLEDuTl4MCRYSrSlB0EVrAEa0jrfgyglsTew8V+zWuucP8dbvr
         9XWpBSfPU+5g22JtPYMIFjGltQ2RzRCWl6XosQb5zvTJoWq6ztS0O92nL0jYO6/F/Ef3
         Kwzhj0heMKpRUKfh9YVtL8Ggif0Gfe5h/qGDZIfK1fv4k6twTWaN12+PYdGx/B/V4qx/
         kXGQzrSoDO3h2kwdvZ9F6MuHy4yzeFGwg0WkVPaGEt0mHnFngict7tXj5Uw6V4XG5/EY
         QbxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZJbUpSpeyu45dZxYMuC6QIFNW0RJTsdqsERdlBubl7RnadbdboHtXjzWKBMQy7BR5gpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YysgOB3+H8U6ii9N5KuUbX91VFcdvdMobnlDL7M4D/wYxbe+e/w
	gC367yYVHqPnE3K2JVrUwgZyzAAZv2F031DhYapiXxAU4XRIDprb8kAuLqY87O0=
X-Gm-Gg: ASbGncs031VRxLCTdlSwzufxtRS0E/9AtkdD49Z/ONBGv9oaFnH0YtvD8nudnjzNfPg
	E6GvKGGozVxiLH0iFs+RkkoqyzQrvfsMZjWjcOTz5AwkE3AIMi1kzKWpdc1Hi0A5HTKobrW4SyO
	HXJXrnDq78vXmywT08AY6HrOLakJ7cfZS+1822r/v1TZkTtXeUhj1oX8AiTtsJpAbFBDkyXgixD
	j8cXQAUQJYElI4mR3lPiMFfhh3CBpOQoJfTf3XbylqYnFVaZoUcKSGXVMd0AW8QIvzLPj6cg99n
	OorVzir5y/3bh5TF8lGgUxF0CsgoS3qIrnOpl90qagSWA6NEm6jLhIyQRBiTYK590shlLwmIWjI
	s+Omkh8IgOV7Cp/NsrXh9OiwEY4oxkOZrYFLkIFBqC4EpNK0MdioEV3d02W3n76IQTQ==
X-Google-Smtp-Source: AGHT+IEegHaHYzFVYqyqvV4s9CP9vHbxqmxDIAALjlbfcfnjkYigut/sITLzJii3S/SE6bsFdLLg+g==
X-Received: by 2002:a05:600c:384b:b0:43d:b85:1831 with SMTP id 5b1f17b1804b1-4406aa872edmr146519085e9.0.1745315823722;
        Tue, 22 Apr 2025 02:57:03 -0700 (PDT)
Received: from ?IPV6:2003:e5:873d:1a00:8e99:ce06:aa4a:2e7b? (p200300e5873d1a008e99ce06aa4a2e7b.dip0.t-ipconnect.de. [2003:e5:873d:1a00:8e99:ce06:aa4a:2e7b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5a9ed9sm170762645e9.3.2025.04.22.02.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 02:57:03 -0700 (PDT)
Message-ID: <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
Date: Tue, 22 Apr 2025 11:57:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
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
 <20250422082216.1954310-22-xin@zytor.com>
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
In-Reply-To: <20250422082216.1954310-22-xin@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8vGI03Dqxf6ImVX0xeh765vV"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8vGI03Dqxf6ImVX0xeh765vV
Content-Type: multipart/mixed; boundary="------------2IPlD0AsRlb1LDytrzf7MO1r";
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
Message-ID: <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
In-Reply-To: <20250422082216.1954310-22-xin@zytor.com>

--------------2IPlD0AsRlb1LDytrzf7MO1r
Content-Type: multipart/mixed; boundary="------------TWjE0O8m3DPylu59JiT9iwph"

--------------TWjE0O8m3DPylu59JiT9iwph
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMDQuMjUgMTA6MjIsIFhpbiBMaSAoSW50ZWwpIHdyb3RlOg0KPiBUaGUgc3Rvcnkg
c3RhcnRlZCBmcm9tIHRnbHgncyByZXBseSBpbiBbMV06DQo+IA0KPiAgICBGb3IgYWN0dWFs
IHBlcmZvcm1hbmNlIHJlbGV2YW50IGNvZGUgdGhlIGN1cnJlbnQgUFYgb3BzIG1lY2hhbmlj
cw0KPiAgICBhcmUgYSBob3Jyb3JzaG93IHdoZW4gdGhlIG9wIGRlZmF1bHRzIHRvIHRoZSBu
YXRpdmUgaW5zdHJ1Y3Rpb24uDQo+IA0KPiAgICBsb29rIGF0IHdybXNybCgpOg0KPiANCj4g
ICAgd3Jtc3JsKG1zciwgdmFsDQo+ICAgICB3cm1zcihtc3IsICh1MzIpdmFsLCAodTMyKXZh
bCA+PiAzMikpDQo+ICAgICAgcGFyYXZpcnRfd3JpdGVfbXNyKG1zciwgbG93LCBoaWdoKQ0K
PiAgICAgICAgUFZPUF9WQ0FMTDMoY3B1LndyaXRlX21zciwgbXNyLCBsb3csIGhpZ2gpDQo+
IA0KPiAgICBXaGljaCByZXN1bHRzIGluDQo+IA0KPiAJbW92CSRtc3IsICVlZGkNCj4gCW1v
dgkkdmFsLCAlcmR4DQo+IAltb3YJJWVkeCwgJWVzaQ0KPiAJc2hyCSQweDIwLCAlcmR4DQo+
IAljYWxsCW5hdGl2ZV93cml0ZV9tc3INCj4gDQo+ICAgIGFuZCBuYXRpdmVfd3JpdGVfbXNy
KCkgZG9lcyBhdCBtaW5pbXVtOg0KPiANCj4gCW1vdiAgICAlZWRpLCVlY3gNCj4gCW1vdiAg
ICAlZXNpLCVlYXgNCj4gCXdybXNyDQo+IAlyZXQNCj4gDQo+ICAgIEluIHRoZSB3b3JzdCBj
YXNlICdyZXQnIGlzIGdvaW5nIHRocm91Z2ggdGhlIHJldHVybiB0aHVuay4gTm90IHRvDQo+
ICAgIHRhbGsgYWJvdXQgZnVuY3Rpb24gcHJvbG9ndWVzIGFuZCB3aGF0ZXZlci4NCj4gDQo+
ICAgIFRoaXMgYmVjb21lcyBldmVuIG1vcmUgc2lsbHkgZm9yIHRyaXZpYWwgaW5zdHJ1Y3Rp
b25zIGxpa2UgU1RJL0NMSQ0KPiAgICBvciBpbiB0aGUgd29yc3QgY2FzZSBwYXJhdmlydF9u
b3AoKS4NCg0KVGhpcyBpcyBub25zZW5zZS4NCg0KSW4gdGhlIG5vbi1YZW4gY2FzZSB0aGUg
aW5pdGlhbCBpbmRpcmVjdCBjYWxsIGlzIGRpcmVjdGx5IHJlcGxhY2VkIHdpdGgNClNUSS9D
TEkgdmlhIGFsdGVybmF0aXZlIHBhdGNoaW5nLCB3aGlsZSBmb3IgWGVuIGl0IGlzIHJlcGxh
Y2VkIGJ5IGEgZGlyZWN0DQpjYWxsLg0KDQpUaGUgcGFyYXZpcnRfbm9wKCkgY2FzZSBpcyBo
YW5kbGVkIGluIGFsdF9yZXBsYWNlX2NhbGwoKSBieSByZXBsYWNpbmcgdGhlDQppbmRpcmVj
dCBjYWxsIHdpdGggYSBub3AgaW4gY2FzZSB0aGUgdGFyZ2V0IG9mIHRoZSBjYWxsIHdhcyBw
YXJhdmlydF9ub3AoKQ0KKHdoaWNoIGlzIGluIGZhY3Qgbm9fZnVuYygpKS4NCg0KPiANCj4g
ICAgVGhlIGNhbGwgbWFrZXMgb25seSBzZW5zZSwgd2hlbiB0aGUgbmF0aXZlIGRlZmF1bHQg
aXMgYW4gYWN0dWFsDQo+ICAgIGZ1bmN0aW9uLCBidXQgZm9yIHRoZSB0cml2aWFsIGNhc2Vz
IGl0J3MgYSBibGF0YW50IGVuZ2luZWVyaW5nDQo+ICAgIHRyYWlud3JlY2suDQoNClRoZSB0
cml2aWFsIGNhc2VzIGFyZSBhbGwgaGFuZGxlZCBhcyBzdGF0ZWQgYWJvdmU6IGEgZGlyZWN0
IHJlcGxhY2VtZW50DQppbnN0cnVjdGlvbiBpcyBwbGFjZWQgYXQgdGhlIGluZGlyZWN0IGNh
bGwgcG9zaXRpb24uDQoNCj4gTGF0ZXIgYSBjb25zZW5zdXMgd2FzIHJlYWNoZWQgdG8gdXRp
bGl6ZSB0aGUgYWx0ZXJuYXRpdmVzIG1lY2hhbmlzbSB0bw0KPiBlbGltaW5hdGUgdGhlIGlu
ZGlyZWN0IGNhbGwgb3ZlcmhlYWQgaW50cm9kdWNlZCBieSB0aGUgcHZfb3BzIEFQSXM6DQo+
IA0KPiAgICAgIDEpIFdoZW4gYnVpbHQgd2l0aCAhQ09ORklHX1hFTl9QViwgWDg2X0ZFQVRV
UkVfWEVOUFYgYmVjb21lcyBhDQo+ICAgICAgICAgZGlzYWJsZWQgZmVhdHVyZSwgcHJldmVu
dGluZyB0aGUgWGVuIGNvZGUgZnJvbSBiZWluZyBidWlsdA0KPiAgICAgICAgIGFuZCBlbnN1
cmluZyB0aGUgbmF0aXZlIGNvZGUgaXMgZXhlY3V0ZWQgdW5jb25kaXRpb25hbGx5Lg0KDQpU
aGlzIGlzIHRoZSBjYXNlIHRvZGF5IGFscmVhZHkuIFRoZXJlIGlzIG5vIG5lZWQgZm9yIGFu
eSBjaGFuZ2UgdG8gaGF2ZQ0KdGhpcyBpbiBwbGFjZS4NCg0KPiANCj4gICAgICAyKSBXaGVu
IGJ1aWx0IHdpdGggQ09ORklHX1hFTl9QVjoNCj4gDQo+ICAgICAgICAgMi4xKSBJZiBub3Qg
cnVubmluZyBvbiB0aGUgWGVuIGh5cGVydmlzb3IgKCFYODZfRkVBVFVSRV9YRU5QViksDQo+
ICAgICAgICAgICAgICB0aGUga2VybmVsIHJ1bnRpbWUgYmluYXJ5IGlzIHBhdGNoZWQgdG8g
dW5jb25kaXRpb25hbGx5DQo+ICAgICAgICAgICAgICBqdW1wIHRvIHRoZSBuYXRpdmUgTVNS
IHdyaXRlIGNvZGUuDQo+IA0KPiAgICAgICAgIDIuMikgSWYgcnVubmluZyBvbiB0aGUgWGVu
IGh5cGVydmlzb3IgKFg4Nl9GRUFUVVJFX1hFTlBWKSwgdGhlDQo+ICAgICAgICAgICAgICBr
ZXJuZWwgcnVudGltZSBiaW5hcnkgaXMgcGF0Y2hlZCB0byB1bmNvbmRpdGlvbmFsbHkganVt
cA0KPiAgICAgICAgICAgICAgdG8gdGhlIFhlbiBNU1Igd3JpdGUgY29kZS4NCg0KSSBjYW4n
dCBzZWUgd2hhdCBpcyBkaWZmZXJlbnQgaGVyZSBjb21wYXJlZCB0byB0b2RheSdzIHN0YXRl
Lg0KDQo+IA0KPiBUaGUgYWx0ZXJuYXRpdmVzIG1lY2hhbmlzbSBpcyBhbHNvIHVzZWQgdG8g
Y2hvb3NlIHRoZSBuZXcgaW1tZWRpYXRlDQo+IGZvcm0gTVNSIHdyaXRlIGluc3RydWN0aW9u
IHdoZW4gaXQncyBhdmFpbGFibGUuDQoNClllcywgdGhpcyBuZWVkcyB0byBiZSBhZGRlZC4N
Cg0KPiBDb25zZXF1ZW50bHksIHJlbW92ZSB0aGUgcHZfb3BzIE1TUiB3cml0ZSBBUElzIGFu
ZCB0aGUgWGVuIGNhbGxiYWNrcy4NCg0KSSBzdGlsbCBkb24ndCBzZWUgYSBtYWpvciBkaWZm
ZXJlbmNlIHRvIHRvZGF5J3Mgc29sdXRpb24uDQoNCk9ubHkgdGhlICJwYXJhdmlydCIgdGVy
bSBoYXMgYmVlbiBlbGltaW5hdGVkLg0KDQoNCkp1ZXJnZW4NCg==
--------------TWjE0O8m3DPylu59JiT9iwph
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------TWjE0O8m3DPylu59JiT9iwph--

--------------2IPlD0AsRlb1LDytrzf7MO1r--

--------------8vGI03Dqxf6ImVX0xeh765vV
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgHZ+0FAwAAAAAACgkQsN6d1ii/Ey9o
Kwf+Ka8aDvktSdKOtwo3ZdG8CXGbhTVU/RFRiiCX+p/ja038CoQl+/SDzpsd9r4wApdxZeP3Kw5A
w9rGmV/b+b6SjhX9aMR5V6/WtL+8fHF3ahX8pZQB436Zmltil3ORUWP2bUJ1XBDf0uuNEnS2orO8
7i7LqV+E+lvJtjsS+Ml6iQQUwETDFQEfShG2bFqyCbaxEPKeZqdEiCUoVQ85jAksvE0UEujITh/K
V8dUgromwUTsyo2GZkgjDh9ewmx+4xkMLCLChn6rFRGVOPjQ62XoTE0KqPecMkfV0JiDCiKgSmBZ
/zmgOaF+fasyXqt62Tb/l2F9PvlX5TGvS5kMqcpYDQ==
=zY3y
-----END PGP SIGNATURE-----

--------------8vGI03Dqxf6ImVX0xeh765vV--

