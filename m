Return-Path: <kvm+bounces-44286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDA4A9C4C6
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F8224C37A2
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A88D23D2B6;
	Fri, 25 Apr 2025 10:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TgxQPfbF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9660723A58B
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 10:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745575723; cv=none; b=sq2M35sl/sWITdPj07Ft5MfePRDWqT9ntMYNhaKxQvdgeKp4Uy/hhsVW6rhs4dOxaJYz2cAwcqY48PCEE5KMEXkRllfam70fNoKLiSRRUUVx75Pn6gTuQkEMPelHXlE1Jvdoz6byVgXsUfCkKv1sBhD38OxwsugLeXCbl9xhLWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745575723; c=relaxed/simple;
	bh=xQKK3OcwSXAQmSMxY7ZPonWOs2FqcDKLKCnyPwhUYyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rt7vEZUmxAAWOv4c33xOMHB28DXHMPRvjSEAa4cIRxTtnPM83OCs8PAUIirKslwLw9WKmafAw2cb9sZpkzdAbJynFWog8y+qqkQST06/mHNI7nMOopck++5MturOwIajiS9cSfXkpst5lJ1Se6URnd10dYO47dM82s9lCj8lNvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TgxQPfbF; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39ee623fe64so1953300f8f.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 03:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745575719; x=1746180519; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xQKK3OcwSXAQmSMxY7ZPonWOs2FqcDKLKCnyPwhUYyM=;
        b=TgxQPfbF28tRJMXoFKH5A8ir6WWi+7nCCvttZp7tMUGkZpZx/Y6bg6644H419/TO+R
         xrV5XoJFI3B2wEXAVXm7lbBo1XBJiA9hFK91HnNh/GIT+NS2HpyyfOKvu/6n1sZX6TqI
         D1uYqkM/q6Tsg91I7uC6u1irD9C0Jg/DysSNauXqXS9zNunH/WzlW9dg4M4XrvL7HU/l
         J3M92qrVIUJEUAc8aIGBF6hRj4aOBq0CW+yInNXq1zpYSWKGk775mz5rs/4udZt51KA4
         RjLnkdlNuGV/V2bwFN3ySdtl5D0HkN6zvtGdSS+gt654Nk1FxUifmziB3KQzOF9n5wk+
         wMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745575719; x=1746180519;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xQKK3OcwSXAQmSMxY7ZPonWOs2FqcDKLKCnyPwhUYyM=;
        b=DevKwQAU2S7GL31gXKGjFin83wYxASIn4wNgICPbB6UR/EDymROzu4gOJrmM/THgvE
         oYaXt0Z7nikbC3aFBYhNk4vA0IhzSNmGPO1YGNt/Bcus7DoOf4RNUCT/PbGo7Wmbwiak
         lw41uKcrnyJbDfVFQckeFj6SInj5M/F6mQx5tUjv9dZihYZyxsaXcp/DF9TWaBi8aUPx
         /aDuvzpZox2k/nCxHOt0MP0Wr6K6jiI2Mm/lc70D5Pt4ClWBUeA+sKP90dZmYOkA4jlV
         pNu7XYUVJybx19paiT9dlIcxUBwugE0DBdt1QDSxiW7FgAr7PKNr0hwCPekuM6l3uFGd
         0iqw==
X-Forwarded-Encrypted: i=1; AJvYcCXaem7zuhK/yB+JXViSq0t14wFeF5/CIJsDD7ot4Vn/uHQ2sjtr6Jz4yBMOlAyTFl0R4bQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQSLAldtREvOuRlEXuqJtDXEux+2dBTktrFd8cttcB27oqbRYt
	vkc35XujoWfQCpE3i5Klg/Ad7xCh8KmEVzwHt/0RoPI/h7VraTPP+hKx3JPQSls=
X-Gm-Gg: ASbGncsjVLJENtwU60zi8DOgEVIMKrnOK8nH1GZ/eQF8vNiLP2uGZEqzJGmUndM0Jv2
	zaCHWU+Gut0uaXF35VO6x/KUDR1lhXjbgZE3oB5VKFfkSgXoFs5+seomgiHgzHh4G6inUKtkm07
	wnEFN0MwddQhJUbqujPpIJ+FgGrgiYEu6Ieq7aBW7mxiSMi+cx6kwDoV2sjzZseaW96oRus73tw
	lKPsJDsf3u9N44KIAaUhXWoPSP31DgTb8qqY2VoE7bSvkHfH9OjUvgZlBS8GpKl99JkO6zmC3PT
	Ymxl9/Ez2CCRluf8xVksT7iJvYuySHfMh7rkveqGuxSONuLtJzSA7lEADbHCVepjULUUtJV0sFL
	wSY9NOKqyP+4wQi29sQGo4ctShzMPK9m4j/P0fKT5vL+xU29IGHp/CW+GGAiXy6/aNA==
X-Google-Smtp-Source: AGHT+IGU4Q9aZFuS4tqffof5bxE63Nbzc5rbtd1cNrTdh+MkKy2ZMlM5eLt2/NojanWJQonzlqjKcw==
X-Received: by 2002:a5d:64eb:0:b0:390:fbdd:994d with SMTP id ffacd0b85a97d-3a074e37904mr1398442f8f.27.1745575718780;
        Fri, 25 Apr 2025 03:08:38 -0700 (PDT)
Received: from ?IPV6:2003:e5:870f:e000:6c64:75fd:2c51:3fef? (p200300e5870fe0006c6475fd2c513fef.dip0.t-ipconnect.de. [2003:e5:870f:e000:6c64:75fd:2c51:3fef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a53874a9sm19482305e9.34.2025.04.25.03.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 03:08:38 -0700 (PDT)
Message-ID: <04d47f21-6183-42d5-bc18-f23a8c3c2009@suse.com>
Date: Fri, 25 Apr 2025 12:08:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/14] x86/xen/msr: Remove pmu_msr_{read,write}()
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
 haiyangz@microsoft.com, decui@microsoft.com, dapeng1.mi@linux.intel.com
References: <20250425083442.2390017-1-xin@zytor.com>
 <20250425083442.2390017-11-xin@zytor.com>
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
In-Reply-To: <20250425083442.2390017-11-xin@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------VB6ybu8aisKH0gV6QqOmM4vy"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------VB6ybu8aisKH0gV6QqOmM4vy
Content-Type: multipart/mixed; boundary="------------ogFHbfX7pVv3PgDj6x3UIh47";
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
 haiyangz@microsoft.com, decui@microsoft.com, dapeng1.mi@linux.intel.com
Message-ID: <04d47f21-6183-42d5-bc18-f23a8c3c2009@suse.com>
Subject: Re: [PATCH v3 10/14] x86/xen/msr: Remove pmu_msr_{read,write}()
References: <20250425083442.2390017-1-xin@zytor.com>
 <20250425083442.2390017-11-xin@zytor.com>
In-Reply-To: <20250425083442.2390017-11-xin@zytor.com>

--------------ogFHbfX7pVv3PgDj6x3UIh47
Content-Type: multipart/mixed; boundary="------------6P0PQ6a4l4W0NIdcsPcChB8C"

--------------6P0PQ6a4l4W0NIdcsPcChB8C
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUuMDQuMjUgMTA6MzQsIFhpbiBMaSAoSW50ZWwpIHdyb3RlOg0KPiBBcyBwbXVfbXNy
X3tyZWFkLHdyaXRlfSgpIGFyZSBub3cgd3JhcHBlcnMgb2YgcG11X21zcl9jaGtfZW11bGF0
ZWQoKSwNCj4gcmVtb3ZlIHRoZW0gYW5kIHVzZSBwbXVfbXNyX2Noa19lbXVsYXRlZCgpIGRp
cmVjdGx5Lg0KPiANCj4gQXMgcG11X21zcl9jaGtfZW11bGF0ZWQoKSBjb3VsZCBlYXNpbHkg
cmV0dXJuIGZhbHNlIGluIHRoZSBjYXNlcyB3aGVyZQ0KPiBpdCB3b3VsZCBzZXQgKmVtdWwg
dG8gZmFsc2UsIHJlbW92ZSB0aGUgImVtdWwiIGFyZ3VtZW50IGFuZCB1c2UgdGhlDQo+IHJl
dHVybiB2YWx1ZSBpbnN0ZWFkLg0KPiANCj4gV2hpbGUgYXQgaXQsIGNvbnZlcnQgdGhlIGRh
dGEgdHlwZSBvZiBNU1IgaW5kZXggdG8gdTMyIGluIGZ1bmN0aW9ucw0KPiBjYWxsZWQgaW4g
cG11X21zcl9jaGtfZW11bGF0ZWQoKS4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogSC4gUGV0ZXIg
QW52aW4gKEludGVsKSA8aHBhQHp5dG9yLmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBKdWVyZ2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFhpbiBMaSAoSW50
ZWwpIDx4aW5Aenl0b3IuY29tPg0KPiAtLS0NCj4gDQo+IENoYW5nZSBpbiB2MzoNCj4gKikg
UmVtb3ZlIHRoZSAiZW11bCIgYXJndW1lbnQgb2YgcG11X21zcl9jaGtfZW11bGF0ZWQoKSAo
SnVlcmdlbiBHcm9zcykuDQo+IC0tLQ0KPiAgIGFyY2gveDg2L3hlbi9lbmxpZ2h0ZW5fcHYu
YyB8IDE1ICsrKysrKysrLS0tLS0tLQ0KPiAgIGFyY2gveDg2L3hlbi9wbXUuYyAgICAgICAg
ICB8IDMwICsrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgIGFyY2gveDg2L3hl
bi94ZW4tb3BzLmggICAgICB8ICAzICstLQ0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMTUgaW5z
ZXJ0aW9ucygrKSwgMzMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYveGVuL2VubGlnaHRlbl9wdi5jIGIvYXJjaC94ODYveGVuL2VubGlnaHRlbl9wdi5jDQo+
IGluZGV4IDYxZTUxYTk3MGYzYy4uNTI4YTJmNGRmMDUwIDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3g4Ni94ZW4vZW5saWdodGVuX3B2LmMNCj4gKysrIGIvYXJjaC94ODYveGVuL2VubGlnaHRl
bl9wdi5jDQo+IEBAIC0xMDkwLDcgKzEwOTAsNyBAQCBzdGF0aWMgdTY0IHhlbl9kb19yZWFk
X21zcih1bnNpZ25lZCBpbnQgbXNyLCBpbnQgKmVycikNCj4gICB7DQo+ICAgCXU2NCB2YWwg
PSAwOwkvKiBBdm9pZCB1bmluaXRpYWxpemVkIHZhbHVlIGZvciBzYWZlIHZhcmlhbnQuICov
DQo+ICAgDQo+IC0JaWYgKHBtdV9tc3JfcmVhZF9lbXVsYXRlZChtc3IsICZ2YWwpKQ0KPiAr
CWlmIChwbXVfbXNyX2Noa19lbXVsYXRlZChtc3IsICZ2YWwsIHRydWUpKQ0KPiAgIAkJcmV0
dXJuIHZhbDsNCj4gICANCj4gICAJaWYgKGVycikNCj4gQEAgLTExNjIsMTIgKzExNjIsMTMg
QEAgc3RhdGljIHZvaWQgeGVuX2RvX3dyaXRlX21zcih1bnNpZ25lZCBpbnQgbXNyLCB1bnNp
Z25lZCBpbnQgbG93LA0KPiAgIAlkZWZhdWx0Og0KPiAgIAkJdmFsID0gKHU2NCloaWdoIDw8
IDMyIHwgbG93Ow0KPiAgIA0KPiAtCQlpZiAoIXBtdV9tc3Jfd3JpdGVfZW11bGF0ZWQobXNy
LCB2YWwpKSB7DQo+IC0JCQlpZiAoZXJyKQ0KPiAtCQkJCSplcnIgPSBuYXRpdmVfd3JpdGVf
bXNyX3NhZmUobXNyLCBsb3csIGhpZ2gpOw0KPiAtCQkJZWxzZQ0KPiAtCQkJCW5hdGl2ZV93
cml0ZV9tc3IobXNyLCBsb3csIGhpZ2gpOw0KPiAtCQl9DQo+ICsJCWlmIChwbXVfbXNyX2No
a19lbXVsYXRlZChtc3IsICZ2YWwsIGZhbHNlKSkNCj4gKwkJCXJldHVybjsNCj4gKw0KPiAr
CQlpZiAoZXJyKQ0KPiArCQkJKmVyciA9IG5hdGl2ZV93cml0ZV9tc3Jfc2FmZShtc3IsIGxv
dywgaGlnaCk7DQo+ICsJCWVsc2UNCj4gKwkJCW5hdGl2ZV93cml0ZV9tc3IobXNyLCBsb3cs
IGhpZ2gpOw0KPiAgIAl9DQo+ICAgfQ0KPiAgIA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
eGVuL3BtdS5jIGIvYXJjaC94ODYveGVuL3BtdS5jDQo+IGluZGV4IGI2NTU3ZjJkMWEyZS4u
NmJlZTgzMDE4Njk0IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni94ZW4vcG11LmMNCj4gKysr
IGIvYXJjaC94ODYveGVuL3BtdS5jDQo+IEBAIC0xMjgsNyArMTI4LDcgQEAgc3RhdGljIGlu
bGluZSB1aW50MzJfdCBnZXRfZmFtMTVoX2FkZHIodTMyIGFkZHIpDQo+ICAgCXJldHVybiBh
ZGRyOw0KPiAgIH0NCj4gICANCj4gLXN0YXRpYyBpbmxpbmUgYm9vbCBpc19hbWRfcG11X21z
cih1bnNpZ25lZCBpbnQgbXNyKQ0KPiArc3RhdGljIGJvb2wgaXNfYW1kX3BtdV9tc3IodTMy
IG1zcikNCj4gICB7DQo+ICAgCWlmIChib290X2NwdV9kYXRhLng4Nl92ZW5kb3IgIT0gWDg2
X1ZFTkRPUl9BTUQgJiYNCj4gICAJICAgIGJvb3RfY3B1X2RhdGEueDg2X3ZlbmRvciAhPSBY
ODZfVkVORE9SX0hZR09OKQ0KPiBAQCAtMTk0LDggKzE5NCw3IEBAIHN0YXRpYyBib29sIGlz
X2ludGVsX3BtdV9tc3IodTMyIG1zcl9pbmRleCwgaW50ICp0eXBlLCBpbnQgKmluZGV4KQ0K
PiAgIAl9DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGljIGJvb2wgeGVuX2ludGVsX3BtdV9lbXVs
YXRlKHVuc2lnbmVkIGludCBtc3IsIHU2NCAqdmFsLCBpbnQgdHlwZSwNCj4gLQkJCQkgIGlu
dCBpbmRleCwgYm9vbCBpc19yZWFkKQ0KPiArc3RhdGljIGJvb2wgeGVuX2ludGVsX3BtdV9l
bXVsYXRlKHUzMiBtc3IsIHU2NCAqdmFsLCBpbnQgdHlwZSwgaW50IGluZGV4LCBib29sIGlz
X3JlYWQpDQo+ICAgew0KPiAgIAl1aW50NjRfdCAqcmVnID0gTlVMTDsNCj4gICAJc3RydWN0
IHhlbl9wbXVfaW50ZWxfY3R4dCAqY3R4dDsNCj4gQEAgLTI1Nyw3ICsyNTYsNyBAQCBzdGF0
aWMgYm9vbCB4ZW5faW50ZWxfcG11X2VtdWxhdGUodW5zaWduZWQgaW50IG1zciwgdTY0ICp2
YWwsIGludCB0eXBlLA0KPiAgIAlyZXR1cm4gZmFsc2U7DQo+ICAgfQ0KPiAgIA0KPiAtc3Rh
dGljIGJvb2wgeGVuX2FtZF9wbXVfZW11bGF0ZSh1bnNpZ25lZCBpbnQgbXNyLCB1NjQgKnZh
bCwgYm9vbCBpc19yZWFkKQ0KPiArc3RhdGljIGJvb2wgeGVuX2FtZF9wbXVfZW11bGF0ZSh1
MzIgbXNyLCB1NjQgKnZhbCwgYm9vbCBpc19yZWFkKQ0KPiAgIHsNCj4gICAJdWludDY0X3Qg
KnJlZyA9IE5VTEw7DQo+ICAgCWludCBpLCBvZmYgPSAwOw0KPiBAQCAtMjk4LDMzICsyOTcs
MTYgQEAgc3RhdGljIGJvb2wgeGVuX2FtZF9wbXVfZW11bGF0ZSh1bnNpZ25lZCBpbnQgbXNy
LCB1NjQgKnZhbCwgYm9vbCBpc19yZWFkKQ0KPiAgIAlyZXR1cm4gZmFsc2U7DQo+ICAgfQ0K
PiAgIA0KPiAtc3RhdGljIGJvb2wgcG11X21zcl9jaGtfZW11bGF0ZWQodW5zaWduZWQgaW50
IG1zciwgdWludDY0X3QgKnZhbCwgYm9vbCBpc19yZWFkLA0KPiAtCQkJCSBib29sICplbXVs
KQ0KPiArYm9vbCBwbXVfbXNyX2Noa19lbXVsYXRlZCh1MzIgbXNyLCB1NjQgKnZhbCwgYm9v
bCBpc19yZWFkKQ0KPiAgIHsNCj4gICAJaW50IHR5cGUsIGluZGV4ID0gMDsNCj4gICANCj4g
ICAJaWYgKGlzX2FtZF9wbXVfbXNyKG1zcikpDQo+IC0JCSplbXVsID0geGVuX2FtZF9wbXVf
ZW11bGF0ZShtc3IsIHZhbCwgaXNfcmVhZCk7DQo+ICsJCXJldHVybiB4ZW5fYW1kX3BtdV9l
bXVsYXRlKG1zciwgdmFsLCBpc19yZWFkKTsNCj4gICAJZWxzZSBpZiAoaXNfaW50ZWxfcG11
X21zcihtc3IsICZ0eXBlLCAmaW5kZXgpKQ0KPiAtCQkqZW11bCA9IHhlbl9pbnRlbF9wbXVf
ZW11bGF0ZShtc3IsIHZhbCwgdHlwZSwgaW5kZXgsIGlzX3JlYWQpOw0KPiArCQlyZXR1cm4g
eGVuX2ludGVsX3BtdV9lbXVsYXRlKG1zciwgdmFsLCB0eXBlLCBpbmRleCwgaXNfcmVhZCk7
DQo+ICAgCWVsc2UNCg0KQ2FuIHlvdSBwbGVhc2UgcmVtb3ZlIHRoZSB0d28gImVsc2UiIGlu
c3RhbmNlcyBhYm92ZT8gV2l0aCBkaXJlY3RseSByZXR1cm5pbmcNCmZvcm0gdGhlICJpZiIg
Y2xhdXNlIHRoZXkgYXJlIG5vIGxvbmdlciBuZWVkZWQuDQoNCldpdGggdGhhdCB5b3UgY2Fu
IGFkZCBteToNCg0KUmV2aWV3ZWQtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNv
bT4NCg0KDQpKdWVyZ2VuDQo=
--------------6P0PQ6a4l4W0NIdcsPcChB8C
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------6P0PQ6a4l4W0NIdcsPcChB8C--

--------------ogFHbfX7pVv3PgDj6x3UIh47--

--------------VB6ybu8aisKH0gV6QqOmM4vy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgLXyQFAwAAAAAACgkQsN6d1ii/Ey8v
Ogf+PRONHNGahmTCtDNZUX2Gy8abeuTUJJJHJyMlfT5cFckV+yhsYr1a7HlE3mRB56O40BZEoRa7
4+zHMaGgxXGReFHM9DxKSLkx9hQy0W7rzotkqHZB5RRTn5m318O+uj7xLL6FyOiDhMPR3sPfgcZx
m5zC6g63Xyz3HifjOtijdeAfFXfQ+rHqOVdDIRWTUy+rc3IasXWgnDXUAZqaVIK52giYpbkPqp3W
Wi63p54rGIvcSfHDzlSOSCabI8B3zRMM/35sJfAhmp+qlHn2tGpORVQuy/tW+GiwNnp2SXYQd6eW
kQF7lCDZKP9ldTY1cfMpxuqOuG670Z/7W8osbuh07w==
=5xyU
-----END PGP SIGNATURE-----

--------------VB6ybu8aisKH0gV6QqOmM4vy--

