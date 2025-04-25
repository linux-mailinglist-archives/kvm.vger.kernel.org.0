Return-Path: <kvm+bounces-44248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B67DDA9BEE6
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0096C4A3F88
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 06:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B9822D7B7;
	Fri, 25 Apr 2025 06:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fnqWZbK2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C122D4D9
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 06:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745563925; cv=none; b=IAJDwpgFwUw5XRl+cmglB1WjTnbQhlr8tn+V5SmNgP+32vxqXZfFws4S/zSrXjZfQaMw8HcsQ7oKPHnPPhQMA8y0DeVxzFx/QSigmTgzHrhvsFXOEfDrA4X/ngxmBk+BdAeb6FclIveVLu9IGoLh6MHpD335MbFzySDpfaDRD34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745563925; c=relaxed/simple;
	bh=0MiSnhd6LKI51whYJ6+YCfOKtkOaJi9qq1W8mhQmh9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+wlA+Jfee+1UyfGqVEwO2xoIjOmo2DtGJzDgL2Yrq3J9NepaP8geZnvaGY1JkkTk1lCnTq984svZ43EbL0//LULedO9WEHyWafmQcD82bU40MfvMi/FG43Hmw0CFLT59MtgiIHPBFd6vxiz27suruPlYYiGR2MfAzoY/LByxE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fnqWZbK2; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ace333d5f7bso315021666b.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745563921; x=1746168721; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0MiSnhd6LKI51whYJ6+YCfOKtkOaJi9qq1W8mhQmh9U=;
        b=fnqWZbK2i0YmxcoOG0zwYb2a+Njrm2KAMK3IjjE1hPI9ahskxAWKUBtirzYV6c+1Mt
         jxWOh6pW767U7EP6Po6NN5DiXU1Z1Nowi7LrxATJMxITfv1slAYE2ND/SpU4nZ54BNtX
         Lx8mHhZiVSap73rMiTrKIBz15BtR/zpl0Okzwhpgrys1yPYT86foBDxeyla6u+WiWv3o
         qPPL74heDQIiUk2hIQqSy+2LushrU49hnuQUHqtArTw56zf5n3jC3yFha72iYsnYR5rE
         UqKeN2QipdaeFdsC+Z/cXLpzmNk9VpjiHhVCeRYiAYM82uWkWRec2fKNCwyAGDtJR1Td
         IEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745563921; x=1746168721;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0MiSnhd6LKI51whYJ6+YCfOKtkOaJi9qq1W8mhQmh9U=;
        b=XRm4mTdQTkum+YMunDAG6mBo0PiJybcj7YOfc/d7OE5doVyiVqj3vVVsI2vsV/VCkL
         C82ztESqzXFYmWLcnaVfjtVn9ciJy7lLbYcOzSkf+r6RsbpiotTC+MyrqqfbjXsXK1pj
         vcNTl9mRTmnGvEnHUTW/qK/VPCO3TSNDrwOk5J9nZsKG+kTsc7cdDGy/CPGUgS/AgjZQ
         taZEubgj807z2cB/hIQOsKlYOKdcqe1hQptbl3nze8KsAMqnWxfDJANx+U2MaIkoIiZ5
         4vKIxdFI7ZdlDZzlI5BhiVIlwRB3yGX3t69mkHm+Mg50uB/HZUKPJgdD3sUmXYOGzCjN
         e3Iw==
X-Forwarded-Encrypted: i=1; AJvYcCVVGhSG/wk9lWkEfZX1WnjVPlr90vSIKWbcaGfIW/+vLli8e04zI5ZTq5E9g6VDmSAaH9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoKZcmzGgahN7khWs4itkcUKJFEKaVQBUpuMt1BN3+Gm14+O75
	5/SzyfbmI+ofyYhEwqAH4snwUmOn7N3RoNC0UjYeGRRNaHLXjl5CAVv5S7cM9qc=
X-Gm-Gg: ASbGncvXD/kMXM5LW1urEakW5Hrh56k2+hp3xN7LrzF7RnmpEKIXBkeSOI/NC3Eu2IC
	18F/kk5AnTf3fEnh5acnapX9vQoloZGWCbEM+Gtv9AwaxdFWZq8VBjwM4popNaADGbu2DDsZ29M
	KXVJsKyQo7w3j2/3MwkZBwfkfPp0sqf4vklgeLTLRe4bAeOTf9BMsydaPrVsoL0uwGlyS1nXR5S
	n1qGW8rpTdK//HcH1H49fLs4AW1v1r4iWfrVdu7K5b8yvP9SgL+uhMQDpBDA9hFr5vbljPcno7Z
	3UfYzv56hXQDvUBqBk7NWX63gkiIkFKt4JYNziPWTMKxceZHN1G2L2DzVXm1+ipvZ0bThUi81P9
	VglEDWksJk/w0tqdTCAh3Zqt3dKBSKW1NmcmzUMkCFe4aclcSs4gNrCYWU//Ahzz/Qw==
X-Google-Smtp-Source: AGHT+IH6tRnHb03g3T3b9xd39ZFziT14G1AusaxT67r9u6w2KcJuEH4Jv4x/SdvY9ic/HmRGz4GAmQ==
X-Received: by 2002:a17:907:1c18:b0:aca:a162:8707 with SMTP id a640c23a62f3a-ace71025d83mr100133966b.7.1745563921096;
        Thu, 24 Apr 2025 23:52:01 -0700 (PDT)
Received: from ?IPV6:2003:e5:870f:e000:6c64:75fd:2c51:3fef? (p200300e5870fe0006c6475fd2c513fef.dip0.t-ipconnect.de. [2003:e5:870f:e000:6c64:75fd:2c51:3fef])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f703831b5csm794913a12.65.2025.04.24.23.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 23:52:00 -0700 (PDT)
Message-ID: <0825ae04-6545-424d-ad01-3a5fda36ad86@suse.com>
Date: Fri, 25 Apr 2025 08:51:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
To: "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin@zytor.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
 linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, acme@kernel.org,
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
 <0cdc6e9d-88eb-4ead-8d55-985474257d53@suse.com>
 <483eb20c-7302-4733-a15f-21d140396919@zytor.com>
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
In-Reply-To: <483eb20c-7302-4733-a15f-21d140396919@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------T4ZWz9eXqhqS8XTZKkH4szjE"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------T4ZWz9eXqhqS8XTZKkH4szjE
Content-Type: multipart/mixed; boundary="------------aDhkvWpyJ2mqrcVlzpHJ5Lh0";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin@zytor.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
 linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com
Message-ID: <0825ae04-6545-424d-ad01-3a5fda36ad86@suse.com>
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
 <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
 <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
 <bb8f6b85-4e7d-440a-a8c3-0e0da45864b8@zytor.com>
 <0cdc6e9d-88eb-4ead-8d55-985474257d53@suse.com>
 <483eb20c-7302-4733-a15f-21d140396919@zytor.com>
In-Reply-To: <483eb20c-7302-4733-a15f-21d140396919@zytor.com>

--------------aDhkvWpyJ2mqrcVlzpHJ5Lh0
Content-Type: multipart/mixed; boundary="------------zlSHc0vaMFKhZ0dLG0JUBad0"

--------------zlSHc0vaMFKhZ0dLG0JUBad0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUuMDQuMjUgMDM6MTUsIEguIFBldGVyIEFudmluIHdyb3RlOg0KPiBPbiA0LzI0LzI1
IDAxOjE0LCBKw7xyZ2VuIEdyb8OfIHdyb3RlOg0KPj4+DQo+Pj4gQWN0dWFsbHksIHRoYXQg
aXMgaG93IHdlIGdldCB0aGlzIHBhdGNoIHdpdGggdGhlIGV4aXN0aW5nIGFsdGVybmF0aXZl
cw0KPj4+IGluZnJhc3RydWN0dXJlLsKgIEFuZCB3ZSB0b29rIGEgc3RlcCBmdXJ0aGVyIHRv
IGFsc28gcmVtb3ZlIHRoZSBwdl9vcHMNCj4+PiBNU1IgQVBJcy4uLg0KPj4NCj4+IEFuZCB0
aGlzIGlzIHdoYXQgSSdtIHF1ZXN0aW9uaW5nLiBJTUhPIHRoaXMgYXBwcm9hY2ggaXMgYWRk
aW5nIG1vcmUNCj4+IGNvZGUgYnkgcmVtb3ZpbmcgdGhlIHB2X29wcyBNU1JfQVBJcyBqdXN0
IGJlY2F1c2UgInB2X29wcyBpcyBiYWQiLiBBbmQNCj4+IEkgYmVsaWV2ZSBtb3N0IHJlZnVz
YWwgb2YgcHZfb3BzIGlzIGJhc2VkIG9uIG5vIGxvbmdlciB2YWxpZCByZWFzb25pbmcuDQo+
Pg0KPiANCj4gcHZvcHMgYXJlIGEgaGVhZGFjaGUgYmVjYXVzZSBpdCBpcyBlZmZlY3RpdmVs
eSBhIHNlY29uZGFyeSBhbHRlcm5hdGl2ZXMgDQo+IGluZnJhc3RydWN0dXJlIHRoYXQgaXMg
aW5jb21wYXRpYmxlIHdpdGggdGhlIGFsdGVybmF0aXZlcyBvbmUuLi4NCg0KSHU/IEhvdyBj
YW4gdGhhdCBiZSwgYXMgcHZfb3BzIGlzIHVzaW5nIG9ubHkgYWx0ZXJuYXRpdmVzIGluZnJh
c3RydWN0dXJlDQpmb3IgZG9pbmcgdGhlIHBhdGNoaW5nPw0KDQpJJ2Qgc2F5IHRvZGF5IHB2
X29wcyBpcyBhIGNvbnZlbmllbmNlIHdyYXBwZXIgYXJvdW5kIGFsdGVybmF0aXZlcy4NCg0K
PiANCj4+PiBJdCBsb29rcyB0byBtZSB0aGF0IHlvdSB3YW50IHRvIGFkZCBhIG5ldyBmYWNp
bGl0eSB0byB0aGUgYWx0ZXJuYXRpdmVzDQo+Pj4gaW5mcmFzdHJ1Y3R1cmUgZmlyc3Q/DQo+
Pg0KPj4gV2h5IHdvdWxkIHdlIG5lZWQgYSBuZXcgZmFjaWxpdHkgaW4gdGhlIGFsdGVybmF0
aXZlcyBpbmZyYXN0cnVjdHVyZT8NCj4gDQo+IEknbSBub3Qgc3VyZSB3aGF0IFhpbiBtZWFu
cyB3aXRoICJmYWNpbGl0eSIsIGJ1dCBhIGtleSBtb3RpdmF0aW9uIGZvciB0aGlzIGlzIHRv
Og0KPiANCj4gYS4gQXZvaWQgdXNpbmcgdGhlIHB2b3BzIGZvciBNU1JzIHdoZW4gb24gdGhl
IG9ubHkgcmVtYWluaW5nIHVzZXIgdGhlcmVvZiAoWGVuKSANCj4gaXMgb25seSB1c2luZyBp
dCBmb3IgYSB2ZXJ5IHNtYWxsIHN1YnNldCBvZiBNU1JzIGFuZCBmb3IgdGhlIHJlc3QgaXQg
aXMganVzdCANCj4gb3ZlcmhlYWQsIGV2ZW4gZm9yIFhlbjsNCj4gDQo+IGIuIEJlaW5nIGFi
bGUgdG8gZG8gd3Jtc3JucyBpbW1lZGlhdGUvd3Jtc3Jucy93cm1zciBhbmQgcmRtc3IgaW1t
ZWRpYXRlL3JkbXNyIA0KPiBhbHRlcm5hdGl2ZXMuDQo+IA0KPiBPZiB0aGVzZSwgKGIpIGlz
IGJ5IGZhciB0aGUgYmlnZ2VzdCBtb3RpdmF0aW9uLiBUaGUgYXJjaGl0ZWN0dXJhbCBkaXJl
Y3Rpb24gZm9yIA0KPiBzdXBlcnZpc29yIHN0YXRlcyBpcyB0byBhdm9pZCBhZCBob2MgYW5k
IFhTQVZFUyBJU0EgYW5kIGluc3RlYWQgdXNlIE1TUnMuIFRoZSANCj4gaW1tZWRpYXRlIGZv
cm1zIGFyZSBleHBlY3RlZCB0byBiZSBzaWduaWZpY2FudGx5IGZhc3RlciwgYmVjYXVzZSB0
aGV5IG1ha2UgdGhlIA0KPiBNU1IgaW5kZXggYXZhaWxhYmxlIGF0IHRoZSB2ZXJ5IGJlZ2lu
bmluZyBvZiB0aGUgcGlwZWxpbmUgaW5zdGVhZCBvZiBhdCBhIA0KPiByZWxhdGl2ZWx5IGxh
dGUgc3RhZ2UuDQoNCkkgdW5kZXJzdGFuZCB0aGUgbW90aXZhdGlvbiBmb3IgYiksIGJ1dCBJ
IHRoaW5rIHRoaXMgY291bGQgYmUgYWNoaWV2ZWQgd2l0aG91dA0KYSkgcmF0aGVyIGVhc2ls
eS4gQW5kIEkgY29udGludWUgdG8gYmVsaWV2ZSB0aGF0IHlvdXIgcmVhc29uaW5nIGZvciBh
KSBpcyBiYXNlZA0Kb24gb2xkIGZhY3RzLiBCdXQgbWF5IGJlIEknbSBqdXN0IG5vdCB1bmRl
cnN0YW5kaW5nIHlvdXIgY29uY2VybnMgd2l0aCB0b2RheSdzDQpwdl9vcHMgaW1wbGVtZW50
YXRpb24uDQoNCg0KSnVlcmdlbg0K
--------------zlSHc0vaMFKhZ0dLG0JUBad0
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

--------------zlSHc0vaMFKhZ0dLG0JUBad0--

--------------aDhkvWpyJ2mqrcVlzpHJ5Lh0--

--------------T4ZWz9eXqhqS8XTZKkH4szjE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgLMQ4FAwAAAAAACgkQsN6d1ii/Ey8v
GAf8CiwnPQUGDuLTROoGEGEZYhZNiIuP6NpPgDIjznR04WHQqCKmSKzSJU9bRnXelOjMGbYovqK5
H/4ovrb5WrWiSib6UbfpZkkgEJi/2YSoXppYhG4sNDnhRSUrFBREETgpfTokr0tYEvX/ZZYrx+nV
RVCKKt9kWmHh3+v0+SzR5AfexZ5c13gqdsYhMKlYu49q82NdjjrwXF6F/WHahWchlhxv2LElrYO+
K7zm4YOjDOn3F04XKVSHqBfQsO5J6ZKHLbow+YnWjYIo5B4GlUGkd6xRmxrTXd7cvqwGxJ9urozi
pw9xdCBracc183w0319kUg4l8bsZ35Ynel8AymEH+w==
=pOyC
-----END PGP SIGNATURE-----

--------------T4ZWz9eXqhqS8XTZKkH4szjE--

