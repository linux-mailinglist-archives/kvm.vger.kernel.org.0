Return-Path: <kvm+bounces-59651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B57CCBC641F
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 20:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E5CC19E3C2B
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 18:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF632C028D;
	Wed,  8 Oct 2025 18:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bMF8+uJx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AD7296BDF
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759947226; cv=none; b=HlLvYsferXwV17pXURd1gb9fRAmEgNZfAg6d/6ly7eCs2Pk85boslPWaq0AVsRRcSu14bglaK4AchfjcKqTL2t4Yl89da+S8AMuVMp2O4wdeNJRWgARYc44dPPcGZMx3diA7JgMot/mPCta9K/iHo/AnDXC0hiWotMiyvCd/ZKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759947226; c=relaxed/simple;
	bh=hjdf8zyDN6GfR8sGi/PWuW8O1E6vUFvOutVGya4OCXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CPz/K2YGEnSc0yisMUWq24Vy9lJCODC99Rx3QOvOVoRQdqmxd6e3FRbDnLzeY4ZpFCGxb+e8HNX0DOQDBeRI+sOd3Ja797FZrrN8o0578kr543OpOGHJQfAaaAtoAlZy/VKzGdRH0Zp4tTP46Qmpn2VjUz1NoYjkpp/G5+5L/NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bMF8+uJx; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb7322da8so20884766b.0
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 11:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759947223; x=1760552023; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hjdf8zyDN6GfR8sGi/PWuW8O1E6vUFvOutVGya4OCXM=;
        b=bMF8+uJxAyOTgTfYYPhGOChlabWbVke3gofA+DDmFO4+1I8WxGn4nfBMya7muEZCso
         scas1LQ35zJIDOX2MYtO8Letx2tvWc3JVcX0OT5MVGDsdKezFzFR1ALSCkwyTFu27LcX
         XF66UAZJW/DpXM7iNFVUHaWWoDuClQBKgeWwwaAKTi98NiBtdwHRWxVMzTzqXx2Zgpi0
         BPlTJd8hYhzaLDJpB9iW30+xR1AaWxSniuxN5OK6TTyvtdkZosaazNqpWEdvoHqZMJNF
         sMHc4iMNxrP/aAadzkGjOsxgLD35zWvTFOCFTYTJCeBIge2n4sCxY4xleBWvRAA5o6E9
         0U0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759947223; x=1760552023;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hjdf8zyDN6GfR8sGi/PWuW8O1E6vUFvOutVGya4OCXM=;
        b=Ij4Re9Xa7egi/VdmaMDXDSX+6xpN5Oo6MIPmT7i5PmHgoIUMAuUt9JzQRW5/N5I+0L
         W5Js8URyOKAjNYjUzscnVQVqJhVMxrK/cOtAmO1O+sXknXcprpdpA43XiiwuN+Q8/E71
         24PSvT1AW1KZFCb8R87ah7272sCGl6bdkSNvwKr4hrRLd4n6Obj2+ozxxTk8bt8d+Ap4
         oIx6eR9dtk+U+nYbIJveBhd6X5td1J8s6MhNUkZDAjMBD05FRLsU3tiMmSfmTC14xe1r
         FxAom7MMyzYVfUajm4AEuagmswYLwUsGepu+tj70o9ElkRX79ls4XvsIG1iUA5e3nuL5
         zDBw==
X-Forwarded-Encrypted: i=1; AJvYcCW7B5K1qjcFU/VrQeUTe9neKNCS9AxWYS0JUUxg6f/cF2lhQZRQ2dgpwiRy4hsvXGOvlFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdOTbNxE1sSv40WNA1vjrDdDC0Bwa+ovieXpb+diUW8t1v+psR
	NAf4FRP32E+3V04/Q0z8T4DliImzOLyaaFr4R5Om3IXLbziuv/D76l6GCKTLbYSa6Ao=
X-Gm-Gg: ASbGncuS9WI/axq/P225uFHkbPn/h25oKvbGak/t85YBusEv23VMmuWaS+BbcF8jTMM
	IcqQpdL7pXMbI5zLR+wUyf3/6g0wrBK4vyJlE+ezUWkul46DSMXerQKRDBTerFJ3kTY1UCWNJXH
	8g8KcUkcyLub0qJ2uYndo4CJruPGXfG+KMvzQUPn+i2vm/BjjJocJZEjg5vf1davroflolPWGSy
	6iu/vmNzr+AcBWigGNPiMMb/LB0AMeuKNtsmilLzZFVS7X4qp8TpJcbL9OM2r3kztbgw5WZlFES
	oRy533N+PjEAnOsYkiIPAmMfgB8d4tiGJ35cJhlUkcY1NjFumsEDRk4Lfm3QWzDhD9/D2ak6Ogd
	D9pOeajiBJTBlX+d1hg9/OdeE+vfKPAg624NjplwalhMcm7Nl83V7yW5EWe0C8wHhbTOEdzSdWf
	zVQ2jaKa2cgzlx2xbsfonyg+6S2MXoUJ+ctLJAslP7+FI2vBvbF8Pb4dD1Za9nvqgeULsrA9tew
	5PWvXE=
X-Google-Smtp-Source: AGHT+IF/P96bcBIOIK5sllGfH74SoX2PyG/tr4iAQvIfDjmKyQfVTMYQzsXTk/owBry2M4SMrE0i2A==
X-Received: by 2002:a17:907:c05:b0:b3b:d657:482b with SMTP id a640c23a62f3a-b50aa48b996mr498700766b.2.1759947222715;
        Wed, 08 Oct 2025 11:13:42 -0700 (PDT)
Received: from ?IPV6:2003:e5:873f:400:7b4f:e512:a417:5a86? (p200300e5873f04007b4fe512a4175a86.dip0.t-ipconnect.de. [2003:e5:873f:400:7b4f:e512:a417:5a86])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b408sm1694182866b.58.2025.10.08.11.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 11:13:42 -0700 (PDT)
Message-ID: <c68c29ba-fe81-4411-b976-7867120e38ca@suse.com>
Date: Wed, 8 Oct 2025 20:13:41 +0200
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
 <5d792dc5-ea8e-46d2-8031-44f8e92b0188@suse.com>
 <9d86698d-525e-4d8c-b3d9-b6a0e7634649@intel.com>
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
In-Reply-To: <9d86698d-525e-4d8c-b3d9-b6a0e7634649@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------88TN9Qu0LwT0sdO3vGystYyP"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------88TN9Qu0LwT0sdO3vGystYyP
Content-Type: multipart/mixed; boundary="------------6E6hAIMyTkTeY8O0gYJKrU9N";
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
Message-ID: <c68c29ba-fe81-4411-b976-7867120e38ca@suse.com>
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
 <5d792dc5-ea8e-46d2-8031-44f8e92b0188@suse.com>
 <9d86698d-525e-4d8c-b3d9-b6a0e7634649@intel.com>
In-Reply-To: <9d86698d-525e-4d8c-b3d9-b6a0e7634649@intel.com>

--------------6E6hAIMyTkTeY8O0gYJKrU9N
Content-Type: multipart/mixed; boundary="------------5DUUhHU7w0ujxSls9U5n0Mcf"

--------------5DUUhHU7w0ujxSls9U5n0Mcf
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDguMTAuMjUgMTc6NDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiBPbiAxMC83LzI1IDA2
OjMxLCBKw7xyZ2VuIEdyb8OfIHdyb3RlOj4NCj4+IElmIHdlIGNhbid0IGNvbWUgdG8gYW4g
YWdyZWVtZW50IHRoYXQga2R1bXAgc2hvdWxkIGJlIGFsbG93ZWQgaW4NCj4+IHNwaXRlIG9m
IGEgcG90ZW50aWFsICNNQywgbWF5YmUgd2UgY291bGQgZGlzYWJsZSBrZHVtcCBvbmx5IGlm
IFREWA0KPj4gZ3Vlc3RzIGhhdmUgYmVlbiBhY3RpdmUgb24gdGhlIG1hY2hpbmUgYmVmb3Jl
Pw0KPiANCj4gSG93IHdvdWxkIHdlIGRldGVybWluZSB0aGF0Pw0KPiANCj4gV2UgY2FuJ3Qg
anVzdCBjYWxsIHRoZSBURFggbW9kdWxlIHRvIHNlZSBiZWNhdXNlIGl0IG1pZ2h0IGhhdmUg
YmVlbg0KPiBydW5uaW5nIGJlZm9yZSBidXQgZ290IHNodXQgZG93bi4NCg0KQWgsIG9rYXks
IEkgZGlkbid0IHRoaW5rIG9mIHRoYXQuDQoNClRoZW4gd2UgY291bGQgYWRkIGEga2VybmVs
IGJvb3QgcGFyYW1ldGVyIHRvIGxldCB0aGUgdXNlciBvcHQtaW4gZm9yIGtleGVjDQpiZWlu
ZyBwb3NzaWJsZSBpbiBzcGl0ZSBvZiB0aGUgcG90ZW50aWFsICNNQy4gSSB0aGluayB0aGlz
IHNob3VsZCBjb3ZlciBpdC4NCg0KDQpKdWVyZ2VuDQo=
--------------5DUUhHU7w0ujxSls9U5n0Mcf
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------5DUUhHU7w0ujxSls9U5n0Mcf--

--------------6E6hAIMyTkTeY8O0gYJKrU9N--

--------------88TN9Qu0LwT0sdO3vGystYyP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmjmqdUFAwAAAAAACgkQsN6d1ii/Ey8M
HAf9EbcC86+tfaSTMSL6Aod8l6yuf5Tgqfl2oNvqpHUrCJXfMYCqYUD9czyVlFD9PwlAytM5dskw
88oF22V2cRsv8xqO+yVh5MACZsnWdvFGfvdI9zW+z8rXiWI3HfCrMLrED9uAzcOoEz99UE8yO14/
iJiOdgIM0D+sH53n7nsNjxOamN2xOFWp3Ee5LsFhaTmi4loNKVPxvoXmcVuhMCsWh5Dwb7w9YDdr
BCLCDRGgKQox/stOWofpaXp/bkmB1KGTgtMzadU+KpnoHC2EyeN7BwqTAiTx9Jqr/5UhQen0Wp/X
ompT1dgWq5vOq9G+5EbpA/tEm/f6j4Uqjw78HGtKtQ==
=swv7
-----END PGP SIGNATURE-----

--------------88TN9Qu0LwT0sdO3vGystYyP--

