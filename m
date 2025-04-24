Return-Path: <kvm+bounces-44111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE60A9A974
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73AC418873E2
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03CA226888;
	Thu, 24 Apr 2025 10:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PKj79mUv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9309221FDA
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745489122; cv=none; b=lM9VMNyHMgPrBTU4TFYN4csa29bXtd/wfY7TRrLNWscbE7GsPQgb9BEI+uavBFYRSr5yxor0J4aE+ANKC44VhP6jwIomoWsFmxdPgF6bDH+83Cjh4YjUPoMtioTb1RjDxS6XwyO3E1y3vtE56TjvaTu6qZk8pl//QiHiRAOX2fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745489122; c=relaxed/simple;
	bh=Snc9P4tltLODVmDFrO3IyAgaPtpL6T6ziTpCwKYtdwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NyjzfedpCqBkvmUrpbgZxBV+vw4SkdC372EajlULI7jCL3R8zUx0tP/1jwmdCxuVg4QMMqETF4zczKDHE8Wy8xll5fk5Pg7TXKn6+HNYYTiB2luUUiHByrNbEGCE4qk0w+s5/mCnhtC36F4YxV9TUetEtY59HegxdG5WyeogIjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PKj79mUv; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39ee57c0b8cso797952f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 03:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745489116; x=1746093916; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Snc9P4tltLODVmDFrO3IyAgaPtpL6T6ziTpCwKYtdwc=;
        b=PKj79mUvw+lz+avSw1A61Ev3y3qI2uuW1W7flFcB48cNVWjMpMZ2YX0VejvUU6BVmV
         prdhBVVfV5EIgEtjgt9Bzhcgl2hk38Pu6BIfZ038wfacui+EQPJrHaySlka/fcUM3sqa
         OVd4VjZGSA4PWYQqAFNKwpL8XB3IABWhyiJ7EmML0aL7f7s6qwCVb8HSB1gSvrnynyrj
         ZNrgj89RWnT/mNjWsiKID0cYoWNTX978u/sFctYDbgtEM0MmbePIsYwBWWXb0NW/Xf6u
         WblBsKW/q8ZoUXZyoR3D/mf/2cBlc+CqROFd3JZa0qlSrqDAMNC8l2gHm1TfUuc66ev1
         NRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745489116; x=1746093916;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Snc9P4tltLODVmDFrO3IyAgaPtpL6T6ziTpCwKYtdwc=;
        b=MFLsWYa7gEF87jUoVG9R+VsmKg+dBOiCyKnF7+sLfKEmzszJZxvcolBD0yHBbI562/
         By6TgwYCTX8tTvFB0Msm3DolfYWf/PGkaW+rcp+i9W7weZifotdavlXzF+5/8nK6sU7+
         Sg3GqxoQXmiruGgq5W5/djFnsG868/skRHMTtNoNhuv5hV1v2umrgmV5hd1s9L7uMnuz
         jOj2l0/fJ53eD0okr/ePNSwnkDoJ5alFzgPAh5oSp82sD1EnnIqf3/2JUZmejeNnd0Gy
         itZAhaA8YOr118lBzairiictuEyI9FVW4LtvN+9yoPepykQB5EOsUTb45BX8SfkmUGpb
         x+NA==
X-Forwarded-Encrypted: i=1; AJvYcCXVAJyvWaOOAF7gN6ZJgLjsnZB3mL6490PSZciPol1pabXH68SAu4Mp5hjOMMQnCIMQdf0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiMTZFIRHhPQGDo80QALPCo6EjkvhwOzmXKBlAy8E/Lj/PtDqz
	lixiWiKxgXK8y2hTbuUaf+obdRjlPKjbi5S6mdZVIW/xb8YAjFMsfsSWmzmw6kI=
X-Gm-Gg: ASbGncuafVBC4xVDOZdy9cdkGtt+GKjS0TIKslkom4gMiPlFBsr7cGpVJn9SU6ljwSL
	/TJ+VqAUQKVn1hHAUlt8FCKnPS7Y4KhxUvX+uAMqTFkDV0M7BGTObxzUAwlzh7Jgv/Rp5H4/+e+
	C6lK11kcFczCQqcMvcr+DzCjUiOz/snVXfBokI0XNm2qUSgVu5DcmtbfnuBSTD68lzz+FqsDMHd
	ZV19Lcb8eTtPBcU9Y77K2biRm8Yh/wqv6U8OAYW/VuYwkf2hRWt6OwGTiWk+uy69EzpNzGxR2/4
	K5kvCK6RIHHyv6SNC24HKrc8kh1kbBA3U37co6N1zttusTSEeyd6+FrPPcP3BD5WLATXAo41R7i
	wPu95GqZ4WhgL8zaKSGFliCUycdtG6EKOZx1WsSzaekcyd/yLPu0REOqC/+ZESibATw==
X-Google-Smtp-Source: AGHT+IFeiub5CJ4A2GUDjwMiofQYe2tDyhhjoa6mmc6NHfiKexbzfePgihm0x9Laf/1+RKVbRkMUdg==
X-Received: by 2002:a05:6000:2901:b0:39a:c8a8:4fdc with SMTP id ffacd0b85a97d-3a06cf563a3mr1591258f8f.16.1745489115718;
        Thu, 24 Apr 2025 03:05:15 -0700 (PDT)
Received: from ?IPV6:2003:e5:870f:e000:6c64:75fd:2c51:3fef? (p200300e5870fe0006c6475fd2c513fef.dip0.t-ipconnect.de. [2003:e5:870f:e000:6c64:75fd:2c51:3fef])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4be673sm1532611f8f.23.2025.04.24.03.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 03:05:15 -0700 (PDT)
Message-ID: <8944b510-6d70-472c-99a2-52a60517733d@suse.com>
Date: Thu, 24 Apr 2025 12:05:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 12/34] x86/msr: Remove pmu_msr_{read,write}()
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
 <20250422082216.1954310-13-xin@zytor.com>
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
In-Reply-To: <20250422082216.1954310-13-xin@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------1R2qpraBQH5lAxkZ0x5pXs03"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------1R2qpraBQH5lAxkZ0x5pXs03
Content-Type: multipart/mixed; boundary="------------UPIgRGhz6y9kAKC46Fb5ZNDF";
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
Message-ID: <8944b510-6d70-472c-99a2-52a60517733d@suse.com>
Subject: Re: [RFC PATCH v2 12/34] x86/msr: Remove pmu_msr_{read,write}()
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-13-xin@zytor.com>
In-Reply-To: <20250422082216.1954310-13-xin@zytor.com>

--------------UPIgRGhz6y9kAKC46Fb5ZNDF
Content-Type: multipart/mixed; boundary="------------wbK5qLJRzlz94m02IO59B0xR"

--------------wbK5qLJRzlz94m02IO59B0xR
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMDQuMjUgMTA6MjEsIFhpbiBMaSAoSW50ZWwpIHdyb3RlOg0KPiBBcyBwbXVfbXNy
X3tyZWFkLHdyaXRlfSgpIGFyZSBub3cgd3JhcHBlcnMgb2YgcG11X21zcl9jaGtfZW11bGF0
ZWQoKSwNCj4gcmVtb3ZlIHRoZW0gYW5kIHVzZSBwbXVfbXNyX2Noa19lbXVsYXRlZCgpIGRp
cmVjdGx5Lg0KPiANCj4gV2hpbGUgYXQgaXQsIGNvbnZlcnQgdGhlIGRhdGEgdHlwZSBvZiBN
U1IgaW5kZXggdG8gdTMyIGluIGZ1bmN0aW9ucw0KPiBjYWxsZWQgaW4gcG11X21zcl9jaGtf
ZW11bGF0ZWQoKS4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogSC4gUGV0ZXIgQW52aW4gKEludGVs
KSA8aHBhQHp5dG9yLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWGluIExpIChJbnRlbCkgPHhp
bkB6eXRvci5jb20+DQo+IC0tLQ0KPiAgIGFyY2gveDg2L3hlbi9lbmxpZ2h0ZW5fcHYuYyB8
IDE3ICsrKysrKysrKystLS0tLS0tDQo+ICAgYXJjaC94ODYveGVuL3BtdS5jICAgICAgICAg
IHwgMjQgKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAgYXJjaC94ODYveGVuL3hlbi1v
cHMuaCAgICAgIHwgIDMgKy0tDQo+ICAgMyBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25z
KCspLCAyOSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni94ZW4v
ZW5saWdodGVuX3B2LmMgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuX3B2LmMNCj4gaW5kZXgg
MTQxODc1OGI1N2ZmLi5iNWE4YmNlYjVmNTYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L3hl
bi9lbmxpZ2h0ZW5fcHYuYw0KPiArKysgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuX3B2LmMN
Cj4gQEAgLTEwODksOCArMTA4OSw5IEBAIHN0YXRpYyB2b2lkIHhlbl93cml0ZV9jcjQodW5z
aWduZWQgbG9uZyBjcjQpDQo+ICAgc3RhdGljIHU2NCB4ZW5fZG9fcmVhZF9tc3IodW5zaWdu
ZWQgaW50IG1zciwgaW50ICplcnIpDQo+ICAgew0KPiAgIAl1NjQgdmFsID0gMDsJLyogQXZv
aWQgdW5pbml0aWFsaXplZCB2YWx1ZSBmb3Igc2FmZSB2YXJpYW50LiAqLw0KPiArCWJvb2wg
ZW11bGF0ZWQ7DQo+ICAgDQo+IC0JaWYgKHBtdV9tc3JfcmVhZChtc3IsICZ2YWwsIGVycikp
DQo+ICsJaWYgKHBtdV9tc3JfY2hrX2VtdWxhdGVkKG1zciwgJnZhbCwgdHJ1ZSwgJmVtdWxh
dGVkKSAmJiBlbXVsYXRlZCkNCj4gICAJCXJldHVybiB2YWw7DQo+ICAgDQo+ICAgCWlmIChl
cnIpDQo+IEBAIC0xMTMzLDYgKzExMzQsNyBAQCBzdGF0aWMgdm9pZCB4ZW5fZG9fd3JpdGVf
bXNyKHVuc2lnbmVkIGludCBtc3IsIHVuc2lnbmVkIGludCBsb3csDQo+ICAgCQkJICAgICB1
bnNpZ25lZCBpbnQgaGlnaCwgaW50ICplcnIpDQo+ICAgew0KPiAgIAl1NjQgdmFsOw0KPiAr
CWJvb2wgZW11bGF0ZWQ7DQo+ICAgDQo+ICAgCXN3aXRjaCAobXNyKSB7DQo+ICAgCWNhc2Ug
TVNSX0ZTX0JBU0U6DQo+IEBAIC0xMTYyLDEyICsxMTY0LDEzIEBAIHN0YXRpYyB2b2lkIHhl
bl9kb193cml0ZV9tc3IodW5zaWduZWQgaW50IG1zciwgdW5zaWduZWQgaW50IGxvdywNCj4g
ICAJZGVmYXVsdDoNCj4gICAJCXZhbCA9ICh1NjQpaGlnaCA8PCAzMiB8IGxvdzsNCj4gICAN
Cj4gLQkJaWYgKCFwbXVfbXNyX3dyaXRlKG1zciwgdmFsKSkgew0KPiAtCQkJaWYgKGVycikN
Cj4gLQkJCQkqZXJyID0gbmF0aXZlX3dyaXRlX21zcl9zYWZlKG1zciwgbG93LCBoaWdoKTsN
Cj4gLQkJCWVsc2UNCj4gLQkJCQluYXRpdmVfd3JpdGVfbXNyKG1zciwgbG93LCBoaWdoKTsN
Cj4gLQkJfQ0KPiArCQlpZiAocG11X21zcl9jaGtfZW11bGF0ZWQobXNyLCAmdmFsLCBmYWxz
ZSwgJmVtdWxhdGVkKSAmJiBlbXVsYXRlZCkNCj4gKwkJCXJldHVybjsNCj4gKw0KPiArCQlp
ZiAoZXJyKQ0KPiArCQkJKmVyciA9IG5hdGl2ZV93cml0ZV9tc3Jfc2FmZShtc3IsIGxvdywg
aGlnaCk7DQo+ICsJCWVsc2UNCj4gKwkJCW5hdGl2ZV93cml0ZV9tc3IobXNyLCBsb3csIGhp
Z2gpOw0KPiAgIAl9DQo+ICAgfQ0KPiAgIA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYveGVu
L3BtdS5jIGIvYXJjaC94ODYveGVuL3BtdS5jDQo+IGluZGV4IDk1Y2FhZTk3YTM5NC4uYWZi
MDJmNDNlZTNmIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni94ZW4vcG11LmMNCj4gKysrIGIv
YXJjaC94ODYveGVuL3BtdS5jDQo+IEBAIC0xMjgsNyArMTI4LDcgQEAgc3RhdGljIGlubGlu
ZSB1aW50MzJfdCBnZXRfZmFtMTVoX2FkZHIodTMyIGFkZHIpDQo+ICAgCXJldHVybiBhZGRy
Ow0KPiAgIH0NCj4gICANCj4gLXN0YXRpYyBpbmxpbmUgYm9vbCBpc19hbWRfcG11X21zcih1
bnNpZ25lZCBpbnQgbXNyKQ0KPiArc3RhdGljIGJvb2wgaXNfYW1kX3BtdV9tc3IodTMyIG1z
cikNCj4gICB7DQo+ICAgCWlmIChib290X2NwdV9kYXRhLng4Nl92ZW5kb3IgIT0gWDg2X1ZF
TkRPUl9BTUQgJiYNCj4gICAJICAgIGJvb3RfY3B1X2RhdGEueDg2X3ZlbmRvciAhPSBYODZf
VkVORE9SX0hZR09OKQ0KPiBAQCAtMTk0LDggKzE5NCw3IEBAIHN0YXRpYyBib29sIGlzX2lu
dGVsX3BtdV9tc3IodTMyIG1zcl9pbmRleCwgaW50ICp0eXBlLCBpbnQgKmluZGV4KQ0KPiAg
IAl9DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGljIGJvb2wgeGVuX2ludGVsX3BtdV9lbXVsYXRl
KHVuc2lnbmVkIGludCBtc3IsIHU2NCAqdmFsLCBpbnQgdHlwZSwNCj4gLQkJCQkgIGludCBp
bmRleCwgYm9vbCBpc19yZWFkKQ0KPiArc3RhdGljIGJvb2wgeGVuX2ludGVsX3BtdV9lbXVs
YXRlKHUzMiBtc3IsIHU2NCAqdmFsLCBpbnQgdHlwZSwgaW50IGluZGV4LCBib29sIGlzX3Jl
YWQpDQo+ICAgew0KPiAgIAl1aW50NjRfdCAqcmVnID0gTlVMTDsNCj4gICAJc3RydWN0IHhl
bl9wbXVfaW50ZWxfY3R4dCAqY3R4dDsNCj4gQEAgLTI1Nyw3ICsyNTYsNyBAQCBzdGF0aWMg
Ym9vbCB4ZW5faW50ZWxfcG11X2VtdWxhdGUodW5zaWduZWQgaW50IG1zciwgdTY0ICp2YWws
IGludCB0eXBlLA0KPiAgIAlyZXR1cm4gZmFsc2U7DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGlj
IGJvb2wgeGVuX2FtZF9wbXVfZW11bGF0ZSh1bnNpZ25lZCBpbnQgbXNyLCB1NjQgKnZhbCwg
Ym9vbCBpc19yZWFkKQ0KPiArc3RhdGljIGJvb2wgeGVuX2FtZF9wbXVfZW11bGF0ZSh1MzIg
bXNyLCB1NjQgKnZhbCwgYm9vbCBpc19yZWFkKQ0KPiAgIHsNCj4gICAJdWludDY0X3QgKnJl
ZyA9IE5VTEw7DQo+ICAgCWludCBpLCBvZmYgPSAwOw0KPiBAQCAtMjk4LDggKzI5Nyw3IEBA
IHN0YXRpYyBib29sIHhlbl9hbWRfcG11X2VtdWxhdGUodW5zaWduZWQgaW50IG1zciwgdTY0
ICp2YWwsIGJvb2wgaXNfcmVhZCkNCj4gICAJcmV0dXJuIGZhbHNlOw0KPiAgIH0NCj4gICAN
Cj4gLXN0YXRpYyBib29sIHBtdV9tc3JfY2hrX2VtdWxhdGVkKHVuc2lnbmVkIGludCBtc3Is
IHVpbnQ2NF90ICp2YWwsIGJvb2wgaXNfcmVhZCwNCj4gLQkJCQkgYm9vbCAqZW11bCkNCj4g
K2Jvb2wgcG11X21zcl9jaGtfZW11bGF0ZWQodTMyIG1zciwgdTY0ICp2YWwsIGJvb2wgaXNf
cmVhZCwgYm9vbCAqZW11bCkNCj4gICB7DQo+ICAgCWludCB0eXBlLCBpbmRleCA9IDA7DQo+
ICAgDQo+IEBAIC0zMTMsMjAgKzMxMSw2IEBAIHN0YXRpYyBib29sIHBtdV9tc3JfY2hrX2Vt
dWxhdGVkKHVuc2lnbmVkIGludCBtc3IsIHVpbnQ2NF90ICp2YWwsIGJvb2wgaXNfcmVhZCwN
Cj4gICAJcmV0dXJuIHRydWU7DQo+ICAgfQ0KPiAgIA0KPiAtYm9vbCBwbXVfbXNyX3JlYWQo
dTMyIG1zciwgdTY0ICp2YWwpDQo+IC17DQo+IC0JYm9vbCBlbXVsYXRlZDsNCj4gLQ0KPiAt
CXJldHVybiBwbXVfbXNyX2Noa19lbXVsYXRlZChtc3IsIHZhbCwgdHJ1ZSwgJmVtdWxhdGVk
KSAmJiBlbXVsYXRlZDsNCj4gLX0NCj4gLQ0KPiAtYm9vbCBwbXVfbXNyX3dyaXRlKHUzMiBt
c3IsIHU2NCB2YWwpDQo+IC17DQo+IC0JYm9vbCBlbXVsYXRlZDsNCj4gLQ0KPiAtCXJldHVy
biBwbXVfbXNyX2Noa19lbXVsYXRlZChtc3IsICZ2YWwsIGZhbHNlLCAmZW11bGF0ZWQpICYm
IGVtdWxhdGVkOw0KPiAtfQ0KPiAtDQo+ICAgc3RhdGljIHU2NCB4ZW5fYW1kX3JlYWRfcG1j
KGludCBjb3VudGVyKQ0KPiAgIHsNCj4gICAJc3RydWN0IHhlbl9wbXVfYW1kX2N0eHQgKmN0
eHQ7DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni94ZW4veGVuLW9wcy5oIGIvYXJjaC94ODYv
eGVuL3hlbi1vcHMuaA0KPiBpbmRleCBhMTg3NWUxMGJlMzEuLmZkZTlmOWQ3NDE1ZiAxMDA2
NDQNCj4gLS0tIGEvYXJjaC94ODYveGVuL3hlbi1vcHMuaA0KPiArKysgYi9hcmNoL3g4Ni94
ZW4veGVuLW9wcy5oDQo+IEBAIC0yNzEsOCArMjcxLDcgQEAgdm9pZCB4ZW5fcG11X2Zpbmlz
aChpbnQgY3B1KTsNCj4gICBzdGF0aWMgaW5saW5lIHZvaWQgeGVuX3BtdV9pbml0KGludCBj
cHUpIHt9DQo+ICAgc3RhdGljIGlubGluZSB2b2lkIHhlbl9wbXVfZmluaXNoKGludCBjcHUp
IHt9DQo+ICAgI2VuZGlmDQo+IC1ib29sIHBtdV9tc3JfcmVhZCh1MzIgbXNyLCB1NjQgKnZh
bCk7DQo+IC1ib29sIHBtdV9tc3Jfd3JpdGUodTMyIG1zciwgdTY0IHZhbCk7DQo+ICtib29s
IHBtdV9tc3JfY2hrX2VtdWxhdGVkKHUzMiBtc3IsIHU2NCAqdmFsLCBib29sIGlzX3JlYWQs
IGJvb2wgKmVtdWwpOw0KPiAgIGludCBwbXVfYXBpY191cGRhdGUodWludDMyX3QgcmVnKTsN
Cj4gICB1NjQgeGVuX3JlYWRfcG1jKGludCBjb3VudGVyKTsNCj4gICANCg0KTWF5IEkgc3Vn
Z2VzdCB0byBnZXQgcmlkIG9mIHRoZSAiZW11bCIgcGFyYW1ldGVyIG9mIHBtdV9tc3JfY2hr
X2VtdWxhdGVkKCk/DQpJdCBoYXMgbm8gcmVhbCB2YWx1ZSwgYXMgcG11X21zcl9jaGtfZW11
bGF0ZWQoKSBjb3VsZCBlYXNpbHkgcmV0dXJuIGZhbHNlIGluDQp0aGUgY2FzZXMgd2hlcmUg
aXQgd291bGQgc2V0ICplbXVsIHRvIGZhbHNlLg0KDQoNCkp1ZXJnZW4NCg==
--------------wbK5qLJRzlz94m02IO59B0xR
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

--------------wbK5qLJRzlz94m02IO59B0xR--

--------------UPIgRGhz6y9kAKC46Fb5ZNDF--

--------------1R2qpraBQH5lAxkZ0x5pXs03
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgKDNkFAwAAAAAACgkQsN6d1ii/Ey/O
WggAhEABdU9+YuQyKPIQ+RmrWdmsL0iabZcb3x7rJTwABnt69GF5YeQn2PpqIOPLMP2K7lGPPeUW
N3vYbEdQ2iXBM1nEmYVwhlAfqOkHW0mbSu609L69eftNl+EJA/sV/gjM/v6aksZQCP4CQTk9d+x/
rzxIM6fws+5kBUjN2O+jCZBf9C6haQn7tcjQLi+r8OCW6fZPOmU+Or93SThiXbZauLQqSLT8BRlC
IKSpDQe8sfdiIBaKqBb0sObqRSZmNBN935Yf6lW/7YJlSps/VY+xZHQqg7FWNGZKeX3vCsEQ/hDW
q0oL5h9ZNoSFdaaxqsm3qXYBaEPW4xaz7RFclWCdTQ==
=wVQ7
-----END PGP SIGNATURE-----

--------------1R2qpraBQH5lAxkZ0x5pXs03--

