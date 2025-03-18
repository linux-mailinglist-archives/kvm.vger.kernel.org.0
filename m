Return-Path: <kvm+bounces-41466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C372A68028
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E0A63B6629
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49BF2063FD;
	Tue, 18 Mar 2025 22:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="So/tduDU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC6746426
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742338717; cv=none; b=LUYITyxNOnVqwa2wfdVLOjJbOQG+36G67tRtJVR8F64xoJDEOeD7rSNH3dyYf4QaNmNGoDwjcEXbiU2NO0w1/KwIhcHZK/dfK7k/2C/lDTBuAFrHrZ2ZWNaa4nUJNyL34RJWnQCyJQKjqV3mtHo3xryLyru7OtaRAe1c0cTZnvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742338717; c=relaxed/simple;
	bh=W93rpVZsHi97qPuHO/U/FnMIMFGbqK6KiMYoGPhb3pA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yel+YSpqICT/4kr4/Aip86aiTj0XFXr3dILnHDlr+nJxd4iZNeQr5Y761oQ69KBE0+wZpSwXXmD7coK/ixAI7fUhxFAjhKrs08r3pWZ679bOs5fIgIdQ4Vq6Y4qjxFnAvZJKdKqcO0CwnpqQYXxKABjm/T1H1jfWqhuND4yUxcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=So/tduDU; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-225e3002dffso69605575ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742338715; x=1742943515; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W93rpVZsHi97qPuHO/U/FnMIMFGbqK6KiMYoGPhb3pA=;
        b=So/tduDU9f+FLRHMrxzQ/NEZlMinTLi7+D4zAReFB4obbXb+oYADFDNVmaT6dkZ4Ce
         NEOQKos4kU39lFj7Tor9arEBr4uOKT5pBkhkeckelHw+juoTMAmn+Py+tGvYZpp/bGGU
         dKCAAORqEo+S+L9AjIxWX9AMo61xUG1athQN4OjKAr2ICYl/a1jx8K651FM2wdmXE/Mb
         9/j2xoKFNPKNgmhupgtNUdtVdtONHlPR0TV7+tTsH03b2G9DoX0Gw9mVxEVUSXJ7Gr7r
         MEiUh/A2fnsmu9dZtlOTd2l1oGiUO3Hif3wlh4Vcs138dGIFN6xhk8ga2yk753NNvEgu
         30lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742338715; x=1742943515;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W93rpVZsHi97qPuHO/U/FnMIMFGbqK6KiMYoGPhb3pA=;
        b=R6RqSHQOz2abXYW11Rlf26Wf3KsIuQ0dFsxKk4gG8ADM3h7J3+zAiU+QIV9d+CnQ3d
         xf4HoUYo57+KjWhQxIkNQd5Bei3zhBJbeX/6aDnlPH3CLnL3tNS00/pLlnQRjTBuxorF
         m0PYrh0FDnWjDBiLzY+LtePXgZl+NuoRyh0Al1vfiu3fG/S4Y3/EEvD0GM3Dmuzo7aWU
         +kBFuWqD5XWyW4pfa/6Xaq/32uorGHc6ZmpV7EGCdGGeVVXQn8HSrg9PqrTZTSZ64Jb0
         rWq/wNVxSJFbzUgqha6f//jNjjKVxkU1th20qy4XP34GAV+gSM29SrmNOB2frDPLFtkt
         NJLw==
X-Forwarded-Encrypted: i=1; AJvYcCWupWKYqyhhjqrl9sl8tTIGQplgJIWLjSwXI4yfUgp0AQuhH4Rhise2vEumKcRjndWW/is=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOD3NfVKZj62qdP3D76fRfFPm58NP2NIwZBt4s/iT1VUo49ccR
	rGHCk/t2eyUNcO097kd+/QM0wMw+Pnm3XgcXQqPnYTrr6zQDhiOoAZyq4mWAfVM=
X-Gm-Gg: ASbGncsD+WzX5SjnfGTOfO0keQZaZNA7NaZXnFq6q001CEt2S+K3MKY+shZDtbgfsyC
	GnV/wzfxaTywA7s4bDkJVYOpIvtGqoDXmol8I9N7smWlXvewPtat+5kPt4awe0b9Q0xrDYjeCJk
	bmUcdXM0nBwsvT6Udy4BTPz1KlChGy/r40zeo4GS1zvTMw+bjtkaHmOUtthFZjp+y+50CwSmE6q
	2qfHYXInMAmQcsTE9K3lqYPVEFWeqQo53hV15hTmL15RG+hoZj1qpLRDJ/0v6GImtNzYNOGP3Fh
	auRZ9lX1IyogGaPWKQA7bJcUiZU+y+vrs7auoSUSi8ZHV/TL8XwPkKAG1w==
X-Google-Smtp-Source: AGHT+IGgATHzA5mk2h2ZORMhsVXPw1HXuieiJoAjLgmzG5rkU4wbf2UiZAhgaj9NQ6le0L1eNMvUqw==
X-Received: by 2002:a05:6a20:1605:b0:1f3:388b:3b4b with SMTP id adf61e73a8af0-1fbeb4ab598mr756431637.15.1742338715563;
        Tue, 18 Mar 2025 15:58:35 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9fed33sm9684412a12.37.2025.03.18.15.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:58:35 -0700 (PDT)
Message-ID: <b107adfe-83fa-4e56-a26d-3c8a7eb3ac49@linaro.org>
Date: Tue, 18 Mar 2025 15:58:34 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] exec/cpu-all: allow to include specific cpu
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-5-pierrick.bouvier@linaro.org>
 <35c90e78-2c2c-4bbb-9996-4031c9eef08a@linaro.org>
 <7202c9e9-1002-4cdc-9ce4-64785aac5de4@linaro.org>
 <0c6f23d5-d220-4fa7-957e-8721f1aa732f@linaro.org>
 <172a10d0-f479-4d6c-9555-a9060bdf744e@linaro.org>
 <ac79c5f1-d7ea-4079-b042-3805063fddba@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <ac79c5f1-d7ea-4079-b042-3805063fddba@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xOC8yNSAxNTozNiwgUmljaGFyZCBIZW5kZXJzb24gd3JvdGU6DQo+IE9uIDMvMTgv
MjUgMTU6MjUsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBPbiAzLzE4LzI1IDE1OjIx
LCBSaWNoYXJkIEhlbmRlcnNvbiB3cm90ZToNCj4+PiBPbiAzLzE4LzI1IDE1OjE2LCBQaWVy
cmljayBCb3V2aWVyIHdyb3RlOg0KPj4+Pj4gVGhpcyBkb2Vzbid0IG1ha2UgYW55IHNlbnNl
IHRvIG1lLsKgIENQVV9JTkNMVURFIGlzIGRlZmluZWQgd2l0aGluIHRoZSB2ZXJ5IGZpbGUg
dGhhdA0KPj4+Pj4geW91J3JlIHRyeWluZyB0byBpbmNsdWRlIGJ5IGF2b2lkaW5nICJjcHUu
aCIuDQo+Pj4+Pg0KPj4+Pg0KPj4+PiBFdmVyeSB0YXJnZXQvWC9jcHUuaCBpbmNsdWRlcyBj
cHUtYWxsLmgsIHdoaWNoIGluY2x1ZGVzICJjcHUuaCIgaXRzZWxmLCByZWx5aW5nIG9uIHBl
cg0KPj4+PiB0YXJnZXQgaW5jbHVkZSBwYXRoIHNldCBieSBidWlsZCBzeXN0ZW0uDQo+Pj4N
Cj4+PiBTbywgYW5vdGhlciBzb2x1dGlvbiB3b3VsZCBiZSB0byBmaXggdGhlIHNpbGx5IGlu
Y2x1ZGUgbG9vcD8NCj4+Pg0KPj4NCj4+IElmIHlvdSdyZSBvayB3aXRoIGl0LCBJJ20gd2ls
bGluZyB0byByZW1vdmUgY3B1LWFsbC5oIGNvbXBsZXRlbHkgKG1vdmluZyB0bGIgZmxhZ3Mg
Yml0cyBpbg0KPj4gYSBuZXcgaGVhZGVyKSwgYW5kIGZpeGluZyBtaXNzaW5nIGluY2x1ZGVz
IGV2ZXJ5d2hlcmUuDQo+Pg0KPj4gSSBqdXN0IHdhbnRlZCB0byBtYWtlIHN1cmUgaXQncyBh
biBhY2NlcHRhYmxlIHBhdGggYmVmb3JlIHNwZW5kaW5nIHRvbyBtdWNoIHRpbWUgb24gaXQu
DQo+IA0KPiBJIHdvdWxkIHZlcnkgbXVjaCBsaWtlIGNwdS1hbGwuaCB0byBnbyBhd2F5Lg0K
PiANCg0KRGVhbCwgSSB3aWxsIGNvbXBsZXRlIHRoZSB3b3JrLCB3aGlsZSBiZWluZyBiYXNl
ZCBvbiB5b3VyIGN1cnJlbnQgc2VyaWVzIA0KKHYyKS4NCg0KPiBJdCBsb29rcyBsaWtlIHdl
IGhhdmUsIG9uIHRjZy1uZXh0Og0KPiANCj4gKDEpIGNwdV9jb3B5IGlzIGxpbnV4LXVzZXIg
b25seSwgYW5kIHNob3VsZCBnbyBpbiBsaW51eC11c2VyL3FlbXUuaC4NCj4gDQo+ICgyKSB0
aGUgVExCIGZsYWdzIGNlcnRhaW5seSBkZXNlcnZlIHRoZWlyIG93biBoZWFkZXIuDQo+IA0K
PiAoMykgVGhlIFFFTVVfQlVJTERfQlVHX09OIGFzc2VydGlvbnMgbmVlZCBub3QgYmUgZG9u
ZSBpbiBhIGhlYWRlciwNCj4gICAgICAgc28gbG9uZyBhcyB0aGVyZSBpcyAqc29tZSogZmls
ZSB0aGF0IHdvbid0IGJ1aWxkIGlmIHRoZSBhc3NlcnRpb25zIGZhaWwuDQo+ICAgICAgIFBl
cmhhcHMgY3B1LXRhcmdldC5jIGlzIGFzIGdvb2QgYXMgYW55Lg0KPiANCg0KWWVzLCBJIG5v
dGljZWQgaXQsIGFuZCBjaG9zZSAjaWZkZWYgQ09NUElMSU5HX1BFUl9UQVJHRVQgd29ya2Fy
b3VuZCB0byANCm5vdCBtYWtlIGEgY2hvaWNlIG9mIHdoZXJlIHRvIG1vdmUgaXQuDQoNCj4g
DQo+IHJ+DQoNCg==

