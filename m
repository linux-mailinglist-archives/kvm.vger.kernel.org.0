Return-Path: <kvm+bounces-40780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 414CAA5C6EA
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65D8A3B62D4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E144825E828;
	Tue, 11 Mar 2025 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fSbyvX+g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADA525DB0A
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706646; cv=none; b=lbUemC0pY7LwT6x3S85FbKQnGzCKTN3yLbklEoCTQaRZMXKkN7GmmrYzwZy+vd+tykjXb/4QSunHNCaVfCzUI+7iuz5pB8wFuAR3WcshqPoD/VGUtAnFBW5q4nPJUOlfrhWQjvwxzbld4Ro6pvkx4by7wPLb36SSJD1Fzlqn1BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706646; c=relaxed/simple;
	bh=9SkM+QBVMzm9A6N98427a8lsiY/0Sg+B4uvqfE1GeA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nWCL0ZA5kjURatvY1CezxXN7/w2YmxrErYGYEpqmkVPchMqb3axqiz/iApRh1GydmxycULqKbLgJHObMZs4mrfYpxGlOh5/E6QsJTiNS0CjAdOEPToMJ4GCkYbtX4/7mqhmNk85x8HyY4AYlgoRoKYIfQjoaqf5NIq7NdlTWh9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fSbyvX+g; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2fa8ac56891so8437702a91.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741706643; x=1742311443; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9SkM+QBVMzm9A6N98427a8lsiY/0Sg+B4uvqfE1GeA4=;
        b=fSbyvX+gYi7SgCL4uBP0zm7eUP4K37XBBaO25r+evJMHjkLmfs7bERA5Ppt18d6lJO
         LeDUKLSpSbeAt0fv7OhPAUvSFU9QfwPXWwD15Kl+4wkwMUyoYbtkCDQWbJM1ehSH1Sbw
         P7Nt7CR5TPpA8tZBh0Ip13qj8bx+vj6bT0j/ywU2pnftGA9QS7DcqGn7NGr2VzIhW2m4
         Naf+Sw2Qa2L8AEWeWIstbVFJ7GZokqumZMtbL57Vmc0dIFBHw28BcXf2kFQPjmEfPZaI
         L/1c03u4pOdFiRxDSlIZKcT/2zGtswXs49GmbPu/oC8TlxrnyUYkE2QvW4XmaFL4lFAF
         FsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741706643; x=1742311443;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9SkM+QBVMzm9A6N98427a8lsiY/0Sg+B4uvqfE1GeA4=;
        b=HAmFPf/CgHPeNjyS+H/dUdbQeKfeS1uaOwDZVwWzy1mbZht4/8K7sHIDEdTLEFI+//
         m9j9222vzxlZq6wro46DUb+xVLj962afrlo5kS+LDh3gH507MVca6wHDGgdQXa+CFFma
         H6aO4oj4HWT1fgQ6wyet0KYrSQHHWdtE1Q0+g4BZkQwyuZe8dgN+OaNdklKMLh1OuPGF
         v+flxM6gehT/0zqzK0nnbRoA4utwV4YiyIEErxjiTzd+j/AorDapFp2yem4OiIFNGtU+
         YIS9klDTSSRQfjyVli6AAULu8fKo638cpUqZ3orck4CXLvNzondHODU0h+q3UsO4T/zz
         3bCw==
X-Forwarded-Encrypted: i=1; AJvYcCXF9pAQoKxCe0iii9k48nREF50ZaKibq27fuLKJeebgpcW3mYeEzQWp0TA093rdIWdKKXE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMXLwT9jh1VqWuXmSUzpTv61x32eaDBzwiqguP/KupKEVNEuGw
	bV7Jgm6slefsB/89u2G9+vEX6wjr+D5snZTS2AuBPyLqR5EisPaLZCrKdmhrzOw=
X-Gm-Gg: ASbGncvGwZvMzHGisXWnZroyg1U+Dpg8ifr5vhO3TB2TtBniui0VrRl5xoPToMRiw4H
	SaO7IoIgBLHXUdcJiJZGfvGvnBz6dmVfEEfVndpm00UgF8x7V62K3WjL4lmCuw6sJ0nJXpz+N3Q
	R3EytX1mELbNMfa2LrhKjLhEB5pWdWEL7WjAl4vTUCNUGBu+FXM6XgoxwTDxIA/v6G9yrrClMN3
	4nPhzvX5LTtjszZwihjfbS0GlM/wQlP1LX/MyoRrvfS640qcWuF6h8nVVLUyaKjM/SaKzQc/je6
	fp0n6LiKcq+CaQJwEOTsr7blihD7gj51A0YmsOLO3YxZ4yCZoSleHnVGG//Zjx7bZqmR
X-Google-Smtp-Source: AGHT+IFBs0+S+LkojiDrxva0/M3wYEnbIAEG3pIneKNxcshy9ERSmJz3RFAr2j7Us8awjWxYZcw3Bg==
X-Received: by 2002:a17:90b:1c05:b0:2ee:a583:e616 with SMTP id 98e67ed59e1d1-2ff7ce6d543mr28614081a91.9.1741706643713;
        Tue, 11 Mar 2025 08:24:03 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff4e773c7csm12057570a91.15.2025.03.11.08.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 08:24:03 -0700 (PDT)
Message-ID: <dbe403b1-a90a-4e32-a773-680539ce5550@linaro.org>
Date: Tue, 11 Mar 2025 08:24:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/16] include/exec/memory: extract devend_big_endian
 from devend_memop
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 xen-devel@lists.xenproject.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 qemu-riscv@nongnu.org, manos.pitsidianakis@linaro.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Anthony PERARD <anthony@xenproject.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
 <20250311040838.3937136-15-pierrick.bouvier@linaro.org>
 <b8073e25-ae8a-462b-b085-84c471a4bf5e@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <b8073e25-ae8a-462b-b085-84c471a4bf5e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xMS8yNSAwMDozNiwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDExLzMvMjUgMDU6MDgsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiB3ZSdsbCB1c2Ug
aXQgaW4gc3lzdGVtL21lbW9yeS5jLg0KPiANCj4gSGF2aW5nIHBhcnQgb2YgdGhlIGNvbW1p
dCBkZXNjcmlwdGlvbiBzZXBhcmF0ZWQgaW4gaXRzIHN1YmplY3QgaXMgYQ0KPiBiaXQgYW5u
b3lpbmcuIEJ1dCB0aGVuIEknbSBwcm9iYWJseSB1c2luZyAyMC15ZWFycyB0b28gb2xkIHRv
b2xzIGluDQo+IG15IHBhdGNoIHdvcmtmbG93Lg0KDQpDYW4geW91IHBsZWFzZSBzaGFyZSB3
aGF0IHdvdWxkIGJlIHRoZSBtZXNzYWdlIHlvdSAob3IgdGhlIHRvb2wpIHdvdWxkIA0KcHJl
ZmVyIGluIHRoaXMgY2FzZT8NCg0KSXQncyBqdXN0IGEgc2luZ2xlIGxpbmUgc3ViamVjdCAo
c2F5aW5nICJ3ZSBleHRyYWN0IHRoZSBmdW5jdGlvbiIpICsgYW4gDQphZGRpdGlvbmFsIGxp
bmUganVzdGlmeWluZyB3aHkgaXQncyBuZWVkZWQuDQoNCj4gDQo+IE9ubHkgdXNlZCBpbiBz
eXN0ZW0ve21lbW9yeSxwaHlzbWVtfS5jLCB3b3J0aCBtb3ZlIHRvIGEgbG9jYWwNCj4gc3lz
dGVtL21lbW9yeS1pbnRlcm5hbC5oIGhlYWRlcj8gT3IgZXZlbiBzaW1wbGVyLCBtb3ZlDQo+
IGluY2x1ZGUvZXhlYy9tZW1vcnktaW50ZXJuYWwuaCAtPiBleGVjL21lbW9yeS1pbnRlcm5h
bC5oIGZpcnN0Lg0KPiANCj4+IFNpZ25lZC1vZmYtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBp
ZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+IC0tLQ0KPj4gICAgaW5jbHVkZS9leGVj
L21lbW9yeS5oIHwgMTggKysrKysrKysrKysrLS0tLS0tDQo+PiAgICAxIGZpbGUgY2hhbmdl
ZCwgMTIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9leGVjL21lbW9yeS5oIGIvaW5jbHVkZS9leGVjL21lbW9yeS5oDQo+PiBp
bmRleCA2MGMwZmI2Y2NkNC4uNTc2NjEyODM2ODQgMTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRl
L2V4ZWMvbWVtb3J5LmgNCj4+ICsrKyBiL2luY2x1ZGUvZXhlYy9tZW1vcnkuaA0KPj4gQEAg
LTMxMzgsMTYgKzMxMzgsMjIgQEAgYWRkcmVzc19zcGFjZV93cml0ZV9jYWNoZWQoTWVtb3J5
UmVnaW9uQ2FjaGUgKmNhY2hlLCBod2FkZHIgYWRkciwNCj4+ICAgIE1lbVR4UmVzdWx0IGFk
ZHJlc3Nfc3BhY2Vfc2V0KEFkZHJlc3NTcGFjZSAqYXMsIGh3YWRkciBhZGRyLA0KPj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdWludDhfdCBjLCBod2FkZHIgbGVuLCBN
ZW1UeEF0dHJzIGF0dHJzKTsNCj4+ICAgIA0KPj4gLS8qIGVudW0gZGV2aWNlX2VuZGlhbiB0
byBNZW1PcC4gICovDQo+PiAtc3RhdGljIGlubGluZSBNZW1PcCBkZXZlbmRfbWVtb3AoZW51
bSBkZXZpY2VfZW5kaWFuIGVuZCkNCj4+ICsvKiByZXR1cm5zIHRydWUgaWYgZW5kIGlzIGJp
ZyBlbmRpYW4uICovDQo+PiArc3RhdGljIGlubGluZSBib29sIGRldmVuZF9iaWdfZW5kaWFu
KGVudW0gZGV2aWNlX2VuZGlhbiBlbmQpDQo+PiAgICB7DQo+PiAgICAgICAgUUVNVV9CVUlM
RF9CVUdfT04oREVWSUNFX0hPU1RfRU5ESUFOICE9IERFVklDRV9MSVRUTEVfRU5ESUFOICYm
DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgREVWSUNFX0hPU1RfRU5ESUFOICE9IERF
VklDRV9CSUdfRU5ESUFOKTsNCj4+ICAgIA0KPj4gLSAgICBib29sIGJpZ19lbmRpYW4gPSAo
ZW5kID09IERFVklDRV9OQVRJVkVfRU5ESUFODQo+PiAtICAgICAgICAgICAgICAgICAgICAg
ICA/IHRhcmdldF93b3Jkc19iaWdlbmRpYW4oKQ0KPj4gLSAgICAgICAgICAgICAgICAgICAg
ICAgOiBlbmQgPT0gREVWSUNFX0JJR19FTkRJQU4pOw0KPj4gLSAgICByZXR1cm4gYmlnX2Vu
ZGlhbiA/IE1PX0JFIDogTU9fTEU7DQo+PiArICAgIGlmIChlbmQgPT0gREVWSUNFX05BVElW
RV9FTkRJQU4pIHsNCj4+ICsgICAgICAgIHJldHVybiB0YXJnZXRfd29yZHNfYmlnZW5kaWFu
KCk7DQo+PiArICAgIH0NCj4+ICsgICAgcmV0dXJuIGVuZCA9PSBERVZJQ0VfQklHX0VORElB
TjsNCj4+ICt9DQo+PiArDQo+PiArLyogZW51bSBkZXZpY2VfZW5kaWFuIHRvIE1lbU9wLiAg
Ki8NCj4+ICtzdGF0aWMgaW5saW5lIE1lbU9wIGRldmVuZF9tZW1vcChlbnVtIGRldmljZV9l
bmRpYW4gZW5kKQ0KPj4gK3sNCj4+ICsgICAgcmV0dXJuIGRldmVuZF9iaWdfZW5kaWFuKGVu
ZCkgPyBNT19CRSA6IE1PX0xFOw0KPj4gICAgfQ0KPj4gICAgDQo+PiAgICAvKg0KPiANCg0K


