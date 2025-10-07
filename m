Return-Path: <kvm+bounces-59571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 70057BC17F7
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 15:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1454B4EC971
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 13:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67272E093A;
	Tue,  7 Oct 2025 13:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gb1ZmBAn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F431E32D3
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 13:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759843907; cv=none; b=TYifZ4DiwV4DoJ0hwoOe1wWlqRQUK3JF9T15LVp54ubsMDGIMo1pJ45V5HiFoS+nrls0FEg9KdG4tfCHNPpphsNup0hMN03aLZIdLmfEImP7J6OGAISwpCJhKf1Mp1ZqZAbDVNyzDJlh9tUe44U2NKYEGo11kGtRw6lKzWGA8J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759843907; c=relaxed/simple;
	bh=nmqHCCYLjv7UOISdWOVnZizfWfYHpPgRLbuQW0jXLas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qXWswqYClgf6Duti2aKmNv/cjzDNfROr5dd7JvxGYaLIR6ydE2oeS+ThdRvLiW+mPbusdOBTHQ3UPB7it+O7nywC6mcCx4KrHuUVNKHSQRPbcCdvkc+Ih2RYcjWFEsnRHsEjsYmj0K++/h9W6tDgj4BoYf5t//p+9iW1BPCUkmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gb1ZmBAn; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4060b4b1200so5439234f8f.3
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 06:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759843904; x=1760448704; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nmqHCCYLjv7UOISdWOVnZizfWfYHpPgRLbuQW0jXLas=;
        b=gb1ZmBAnHhJ/N98arGaW5PdrmWKOF6nywyAji+CjzHBCH9ASIDuPzy5P3ou9aqfkBz
         YUBdz/X9rBvkyo7U8kyEulLYwcViRGlqSoFHLRFKvUSpFN9zaj/sTLf0h6lHI0purtRn
         n48cVjbtI9UdqaCvmx460AgYA1aZiEOYutUuN17uh7whPSyXXP9iVOmwi/bDNZizFu1M
         dco2iWhkofP5242vf9J7jwe6e37Eh8rMAK11ulDYVWX4NIKHsSW3178/QdIDtDjaKnDE
         h4UkNCcGxDpJvCwY5zeu83uQDSyfI1CCgJ23MbMrY6F0WdZfONKa6T4y83HibCdN1CcA
         +WKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759843904; x=1760448704;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nmqHCCYLjv7UOISdWOVnZizfWfYHpPgRLbuQW0jXLas=;
        b=r1E6PEJMcaEG0dI2ejJip2sU2fTxzCF9dP7jHSNWYnXzJfJXPCXrbBsXH2fzhznaTc
         kwFp7ziuMLDDZIke49RQ0j5fI8KC11HIadOfVymESa8jZ4Yxgi1wfat8f+jux4KoeY1/
         o4x6VjvJv/albghtKUZdPbgRZisEOJCk/X+ph+vy5bPhDJ598579l3quuDrBJPkNIWND
         6WLVZkCC1NXtXu5n9Un48JvSA1EJZqFLGDmBQONf29vw6QGR5johCVkNXliCU5NUbFRv
         7XZSA7OUPQN0LhrE2jJXAWTjQdhK9M36ouT4wyX5PGL+ag2xLUZzx/aJHtGLANpMY3xP
         qfOw==
X-Forwarded-Encrypted: i=1; AJvYcCXZMn4tBhmxYKnnwqpqES7CRNNt7Fmo2PDjRpj5UUvghraMa3HY75vVDT9Xy6KDnzvN0+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDEu+tRnieluW78IJ7wtA7AAF8oehj4r1BHzHEKrQBiw8eib7A
	0/tfizDeAYFTM+mBKNX5GIEapQYuNjKofIRP1rPfbBbG7DbhlAXas9mAxQvytPpOw2I=
X-Gm-Gg: ASbGnct07yHqkDXsYUE3Irk0xSdALu/h2W45bIuGh4Na1YAWE/16SdUPZ2rp78ptPw0
	zYArZDpZEe2GMiDL2ouo7XUcqwkMhjljmHutG1tpfCpseE5pyWsOvGYvcLXsnIW0W6ORzycriU+
	WvPVk9V7nzZUfO2HuQ7HR7thLKvUr27oHQJNzoZOZvnGG/qfBLWRh0Yp0vcfV9PiwravbZsWSl0
	scTmH98VHsbxMMOuA6oz6KHZ3vgka5CiZFrtzGgvWfq1CeLYlM1eGOs0HbOqx5IDFsREr2L2kpb
	5tWLQbewdaGa7Dw1xGTPU2vJBNo1f/A7e0yW1347PkXH2U1Q3AH4Q7zKYye1Iip2nFO2cc3hcVV
	4VT85vrcjwTxf1CKtXDCgYwgqTu1YUl5U0eUAMvi3UeODbUPPWMBXTsUrKle7U9mXz9IiLjIFoF
	UGxDNQtulX2btc1+P91l7gKq/OEjAAvJFDrDdBLTOa1Gs6jDLJcvA5ypMH3f9qlSZJyt6B++e4J
	C1VXSw=
X-Google-Smtp-Source: AGHT+IGDBarKisTLZ3aOlvaz9TPlo6eBvhoC8Zr4diC92RrOmHD9/iLkB04bWjBNEXUlLD5vKyJOTw==
X-Received: by 2002:a05:6000:2901:b0:3eb:4e88:585 with SMTP id ffacd0b85a97d-42567194b00mr9558612f8f.29.1759843903831;
        Tue, 07 Oct 2025 06:31:43 -0700 (PDT)
Received: from ?IPV6:2003:e5:873f:400:7b4f:e512:a417:5a86? (p200300e5873f04007b4fe512a4175a86.dip0.t-ipconnect.de. [2003:e5:873f:400:7b4f:e512:a417:5a86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f0392sm25840968f8f.42.2025.10.07.06.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 06:31:43 -0700 (PDT)
Message-ID: <5d792dc5-ea8e-46d2-8031-44f8e92b0188@suse.com>
Date: Tue, 7 Oct 2025 15:31:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
To: Dave Hansen <dave.hansen@intel.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Huang, Kai" <kai.huang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>, "Gao, Chao"
 <chao.gao@intel.com>, "sagis@google.com" <sagis@google.com>,
 "Chen, Farrah" <farrah.chen@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
 <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
 <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
 <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
 <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <27d19ea5-d078-405b-a963-91d19b4229c8@suse.com>
 <5b007887-d475-4970-b01d-008631621192@intel.com>
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
In-Reply-To: <5b007887-d475-4970-b01d-008631621192@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------eh2kZetL0id6wh0cV6D67V5G"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------eh2kZetL0id6wh0cV6D67V5G
Content-Type: multipart/mixed; boundary="------------SS3m9n9G0zIP5yb22DVC4Q10";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Dave Hansen <dave.hansen@intel.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Huang, Kai" <kai.huang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>, "Gao, Chao"
 <chao.gao@intel.com>, "sagis@google.com" <sagis@google.com>,
 "Chen, Farrah" <farrah.chen@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Message-ID: <5d792dc5-ea8e-46d2-8031-44f8e92b0188@suse.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
References: <20250901160930.1785244-1-pbonzini@redhat.com>
 <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
 <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
 <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
 <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <27d19ea5-d078-405b-a963-91d19b4229c8@suse.com>
 <5b007887-d475-4970-b01d-008631621192@intel.com>
In-Reply-To: <5b007887-d475-4970-b01d-008631621192@intel.com>

--------------SS3m9n9G0zIP5yb22DVC4Q10
Content-Type: multipart/mixed; boundary="------------VKMwJJqlh6qjkFMGIZJ0kor4"

--------------VKMwJJqlh6qjkFMGIZJ0kor4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDIuMTAuMjUgMTc6MDYsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiBPbiAxMC8yLzI1IDAw
OjQ2LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gU28gbGV0cyBjb21wYXJlIHRoZSAyIGNh
c2VzIHdpdGgga2R1bXAgZW5hYmxlZCBhbmQgZGlzYWJsZWQgaW4geW91cg0KPj4gc2NlbmFy
aW8gKGNyYXNoIG9mIHRoZSBob3N0IE9TKToNCj4+DQo+PiBrZHVtcCBlbmFibGVkOiBObyBk
dW1wIGNhbiBiZSBwcm9kdWNlZCBkdWUgdG8gdGhlICNNQyBhbmQgc3lzdGVtIGlzDQo+PiBy
ZWJvb3RlZC4NCj4+DQo+PiBrZHVtcCBkaXNhYmxlZDogTm8gZHVtcCBpcyBwcm9kdWNlZCBh
bmQgc3lzdGVtIGlzIHJlYm9vdGVkIGFmdGVyIGNyYXNoLg0KPj4+IFdoYXQgaXMgdGhlIG1h
aW4gY29uY2VybiB3aXRoIGtkdW1wIGVuYWJsZWQ/IEkgZG9uJ3Qgc2VlIGFueQ0KPj4gZGlz
YWR2YW50YWdlIHdpdGggZW5hYmxpbmcgaXQsIGp1c3QgdGhlIGFkdmFudGFnZSB0aGF0IGlu
IG1hbnkgY2FzZXMNCj4+IGEgZHVtcCB3aWxsIGJlIHdyaXR0ZW4uDQo+IFRoZSBkaXNhZHZh
bnRhZ2UgaXMgdGhhdCBhIGtlcm5lbCBidWcgZnJvbSBsb25nIGFnbyByZXN1bHRzIGluIGEg
bWFjaGluZQ0KPiBjaGVjay4gTWFjaGluZSBjaGVja3MgYXJlIGdlbmVyYWxseSBpbmRpY2F0
aXZlIG9mIGJhZCBoYXJkd2FyZS4gU28gdGhlDQo+IGRpc2FkdmFudGFnZSBpcyB0aGF0IHNv
bWVvbmUgbWlzdGFrZXMgdGhlIGxvbmcgYWdvIGtlcm5lbCBidWcgZm9yIGJhZA0KPiBoYXJk
d2FyZS4NCj4gDQo+IFRoZXJlIGFyZSB0d28gd2F5cyBvZiBsb29raW5nIGF0IHRoaXM6DQo+
IA0KPiAxLiBBIHRoZW9yZXRpY2FsbHkgZnJhZ2lsZSBrZHVtcCBpcyBiZXR0ZXIgdGhhbiBu
byBrZHVtcCBhdCBhbGwuIEFsbCBvZg0KPiAgICAgdGhlIHN0YXJzIHdvdWxkIGhhdmUgdG8g
YWxpZ24gZm9yIGtkdW1wIHRvIF9mYWlsXyBhbmQgd2UgZG9uJ3QgdGhpbmsNCj4gICAgIHRo
YXQncyBnb2luZyB0byBoYXBwZW4gb2Z0ZW4gZW5vdWdoIHRvIG1hdHRlci4NCj4gMi4ga2R1
bXAgaGFwcGVucyBhZnRlciBrZXJuZWwgYnVncy4gVGhlIG1hY2hpbmUgY2hlY2tzIGhhcHBl
biBiZWNhdXNlIG9mDQo+ICAgICBrZXJuZWwgYnVncy4gSXQncyBub3QgYSBiaWcgc3RyZXRj
aCB0byB0aGluayB0aGF0LCBhdCBzY2FsZSwga2R1bXAgaXMNCj4gICAgIGdvaW5nIHRvIHJ1
biBpbiB0byB0aGVzZSAjTUNzIG9uIGEgcmVndWxhciBiYXNpcy4NCj4gDQo+IERvZXMgdGhh
dCBjYXB0dXJlIHRoZSB0d28gcGVyc3BlY3RpdmVzIGZhaXJseT8NCg0KQmFzaWNhbGx5IHll
cy4NCg0KSWYgd2UgY2FuJ3QgY29tZSB0byBhbiBhZ3JlZW1lbnQgdGhhdCBrZHVtcCBzaG91
bGQgYmUgYWxsb3dlZCBpbiBzcGl0ZSBvZg0KYSBwb3RlbnRpYWwgI01DLCBtYXliZSB3ZSBj
b3VsZCBkaXNhYmxlIGtkdW1wIG9ubHkgaWYgVERYIGd1ZXN0cyBoYXZlIGJlZW4NCmFjdGl2
ZSBvbiB0aGUgbWFjaGluZSBiZWZvcmU/IERpc2FibGluZyBrZHVtcCBvbiBhIGRpc3RybyBr
ZXJuZWwganVzdCBiZWNhdXNlDQpURFggd2FzIGVuYWJsZWQgYnV0IHdpdGhvdXQgYW55b25l
IGhhdmluZyB1c2VkIFREWCB3b3VsZCBiZSBxdWl0ZSBoYXJkLg0KDQoNCkp1ZXJnZW4NCg==

--------------VKMwJJqlh6qjkFMGIZJ0kor4
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------VKMwJJqlh6qjkFMGIZJ0kor4--

--------------SS3m9n9G0zIP5yb22DVC4Q10--

--------------eh2kZetL0id6wh0cV6D67V5G
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmjlFj4FAwAAAAAACgkQsN6d1ii/Ey8p
3QgAlcpsM1b65HZ+nYJ9qmO1fgoCaS6uqm8EKvecyh255Jo8fAoEZ0QSdojiEY4duquiYUYzysis
yBqVWceul+ft46KPhSZZqaOH98FUzTBJ+WDucPEgDn//t5lv9RPj1CfExm1Uc9Cz7BphIAJqrkCR
iz3jV47eFYnNu91PU1aCCm3YWI2rrInx5UL0hW9Y+lENUQwHcDkPLWtjaOLyOWHEY4La6eUhpRqv
zgrlV+C+HWAYZjZOtBwKbUp1aE6pNsZY225/0TF7GnUeQWo7H4cjHWRE2XLB9akZVPLPDZvt/xNw
FzjEvecvltRhgIexjtnHj3FoRV1MBABWxTNXpP/fMw==
=roL9
-----END PGP SIGNATURE-----

--------------eh2kZetL0id6wh0cV6D67V5G--

