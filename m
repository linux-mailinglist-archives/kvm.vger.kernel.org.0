Return-Path: <kvm+bounces-35026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CDBBA08E16
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:34:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 769471684F2
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5277C20B1E1;
	Fri, 10 Jan 2025 10:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GoIYUXIR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C879318FC80;
	Fri, 10 Jan 2025 10:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736505270; cv=none; b=JcYTeo9MuSRUx5m3anOasa93Qd5D/NPG1fI9JtDOxNYlSRv7lWk+L4g72gQ5IgL2fQ9kQLaY35yx+uUHU6oNdUByY8XatHt4zZm8tdwolX906qx39m7hPh5oVulJ7ZjmHY/Vj+ymIZhFOAguArclozQTpEYcYHdHUuFE/ur7V30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736505270; c=relaxed/simple;
	bh=8y5od9wGCl2rjYnyuE4gE7l3UK17+xq3Ve6vWOWE8no=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mT9sEO+TAy0SsffY5AOXhUDVZEW0HpapulVsXBCD6nyaKEhMKrLRPMk7k0Q1TOnFswJ2kOcojELOjPLCiGXxR8vUOSJTkqN5rCjG+wfozYFE5kyOZJxjUq8Alqs9HNXgwZGDC+WLN8kXEOZo5kI1lnF0o5UY1m7CpAiq4rR+wiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GoIYUXIR; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d90a5581fcso3070715a12.1;
        Fri, 10 Jan 2025 02:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736505266; x=1737110066; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8y5od9wGCl2rjYnyuE4gE7l3UK17+xq3Ve6vWOWE8no=;
        b=GoIYUXIR5yFFkhgPfCojYjJPeND41V3D6D6xbtSjHzgVosqFrzX9hzZmyJwcTRTwCA
         xfsmcvRgEBSMPxrIlLNt6+IGnJDX8eHLuM1YiCTp8qn0FD1j2OnWiur/zrAI1hUNkICe
         bAgYni2BhgTgTPz4r06fjMq/09XkqTOTT0vWGotZ2ehqoZIU/I2E4pePe7KeKHFtZU4t
         SlVNsb2zqdl5lXdFjYMfQB9Np7t2q6EReab7Baqz2HTw1lzWrk6mrA/neSFFCtCcrt7O
         HNcE11rh+mpaQwjogHhmgfHzBmPPh1d/nb+0Zebo5qvC+JG6YHoHwrcfIGrioFfS5esM
         uBnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736505266; x=1737110066;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8y5od9wGCl2rjYnyuE4gE7l3UK17+xq3Ve6vWOWE8no=;
        b=M6o76ujbuv9x9LbXeXqhP9cfGADO6wvT1WpioxaOOZOG90/Kon8+wRbruhL0dOTSEN
         9ofdtegGG8SfD/FP6q5+GLC/AtVJ78OmF0nu6hlCDPuWA6vSG/zw2A6nEm6EyEyA8X5H
         TS7HvNrHtqONC4AAh5zeAKgSlu2tVZVAmwYLAOAtT0HvahM6/VV8ZcKkU2c8TKgEhoPw
         3wBZcQb8ul3cY0kaMw7VleElxIk3IQeYD48WABMgvT5i3dGUwTzWZD8vZvzJYzTg3g2L
         YCTigFULrzVwaeoalJQLNnRYaXygMJOM2KeTA7+Vr4puFkCV5w6xj/fty7j7D9rlUEJl
         tnxQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5jxbaAe5NYW4t+K85bs484rDk4CGTj8Dpfta03wZlLbStCtAy6spOyDj6LNmwgCCpG7l1ZSme2d2c4+Rf@vger.kernel.org, AJvYcCUE0ntG4e63PdhMmZTbycp10/buJKXTgc3dS4LaIP0mjax0vlk1twHA896biVfeMuM/BZk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjkPY0+xn3jDuK0bhxEtRb8vGHz8pM1XOsHFLDpBaK+htxzWjB
	87sjivnzr00MiKNjXNlyAEJSFH6mjPMOuG9kvAAWLla3bbz0gfp1
X-Gm-Gg: ASbGncu+sTBFhWNj340bMWl8tHMav3PY5GZtrvnkqZC+f8R8+MZ86M2LRp9nZjY8Pm7
	s5DcGHhwld4m243gPqq36RzksXQK0S6QFiL6MTRb/butwbtti/VTqKUuNvvHdrBkJJbEVue40/x
	W9S6a8/JZLa1OLhFChqwF7KOtpqI13NDwEhjerB+MHVLjrzhyklWoyygdE1LO3jKTFeJ6hKr0FG
	uQeKUDvH+dmrcYsRCJTW9rJtwOK+HxE1O94KsmAJfXUK52Fh7+aqFYRBM0OtJZXg/DlmYjmyPXL
	/T7r6KVw5Z3MP2DYz0sF19Qt3YoFMUtYQo8=
X-Google-Smtp-Source: AGHT+IEZOJJvSwdTrV/oSq2keRhBx2g89RsZqGW/dDVtDxWuzFTSF0e+ee/gkWx/NqGMqnAHRuK+Lg==
X-Received: by 2002:a17:907:3f95:b0:aa6:730c:acd with SMTP id a640c23a62f3a-ab2ab6a8f3fmr996730566b.16.1736505265752;
        Fri, 10 Jan 2025 02:34:25 -0800 (PST)
Received: from [192.168.73.113] (mob-176-247-58-172.net.vodafone.it. [176.247.58.172])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905ec66sm155545766b.18.2025.01.10.02.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 02:34:25 -0800 (PST)
Message-ID: <173ba3b7c890f1ec523853b3a12859eb309cd563.camel@gmail.com>
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>, rick.p.edgecombe@intel.com
Cc: isaku.yamahata@gmail.com, kai.huang@intel.com, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 reinette.chatre@intel.com,  seanjc@google.com,
 tony.lindgren@linux.intel.com, yan.y.zhao@intel.com
Date: Fri, 10 Jan 2025 11:34:24 +0100
In-Reply-To: <7574968a-f0e2-49d5-b740-2454a0f70bb6@intel.com>
References: <dcb03fc9d73b09734dee4110363cace369fc4d4c.camel@gmail.com>
	 <7574968a-f0e2-49d5-b740-2454a0f70bb6@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI1LTAxLTEwIGF0IDEyOjI5ICswODAwLCBYaWFveWFvIExpIHdyb3RlOgo+IE9u
IDEvOS8yMDI1IDc6MDcgUE0sIEZyYW5jZXNjbyBMYXZyYSB3cm90ZToKPiA+IE9uIDIwMjQtMTAt
MzAgYXQgMTk6MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOgo+ID4gPiBAQCAtMTA1NSw2ICsxMTQ0
LDgxIEBAIHN0YXRpYyBpbnQgdGR4X3RkX3ZjcHVfaW5pdChzdHJ1Y3QKPiA+ID4ga3ZtX3ZjcHUK
PiA+ID4gKnZjcHUsIHU2NCB2Y3B1X3JjeCkKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiBy
ZXQ7Cj4gPiA+IMKgIH0KPiA+ID4gwqAgCj4gPiA+ICsvKiBTb21ldGltZXMgcmVhZHMgbXVsdGlw
cGxlIHN1YmxlYWZzLiBSZXR1cm4gaG93IG1hbnkgZW50aWVzCj4gPiA+IHdlcmUKPiA+ID4gd3Jp
dHRlbi4gKi8KPiA+ID4gK3N0YXRpYyBpbnQgdGR4X3ZjcHVfZ2V0X2NwdWlkX2xlYWYoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCB1MzIKPiA+ID4gbGVhZiwKPiA+ID4gaW50IG1heF9jbnQsCj4gPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc3RydWN0IGt2bV9jcHVpZF9lbnRyeTIKPiA+ID4gKm91dHB1dF9lKQo+ID4g
PiArewo+ID4gPiArwqDCoMKgwqDCoMKgwqBpbnQgaTsKPiA+ID4gKwo+ID4gPiArwqDCoMKgwqDC
oMKgwqBpZiAoIW1heF9jbnQpCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBy
ZXR1cm4gMDsKPiA+ID4gKwo+ID4gPiArwqDCoMKgwqDCoMKgwqAvKiBGaXJzdCB0cnkgd2l0aG91
dCBhIHN1YmxlYWYgKi8KPiA+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKCF0ZHhfcmVhZF9jcHVpZCh2
Y3B1LCBsZWFmLCAwLCBmYWxzZSwgb3V0cHV0X2UpKQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIDE7Cj4gPiA+ICsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgLyoKPiA+
ID4gK8KgwqDCoMKgwqDCoMKgICogSWYgdGhlIHRyeSB3aXRob3V0IGEgc3VibGVhZiBmYWlsZWQs
IHRyeSByZWFkaW5nCj4gPiA+IHN1YmxlYWZzCj4gPiA+IHVudGlsCj4gPiA+ICvCoMKgwqDCoMKg
wqDCoCAqIGZhaWx1cmUuIFRoZSBURFggbW9kdWxlIG9ubHkgc3VwcG9ydHMgNiBiaXRzIG9mCj4g
PiA+IHN1YmxlYWYKPiA+ID4gaW5kZXguCj4gPiAKPiA+IEl0IGFjdHVhbGx5IHN1cHBvcnRzIDcg
Yml0cywgaS5lLiBiaXRzIDY6MCwgc28gdGhlIGxpbWl0IGJlbG93Cj4gPiBzaG91bGQKPiA+IGJl
IDBiMTExMTExMS4KPiAKPiBOaWNlIGNhdGNoIQo+IAo+ID4gPiArwqDCoMKgwqDCoMKgwqAgKi8K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgZm9yIChpID0gMDsgaSA8IDBiMTExMTExOyBpKyspIHsKPiA+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChpID4gbWF4X2NudCkKPiA+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dDsK
PiA+IAo+ID4gVGhpcyB3aWxsIG1ha2UgdGhpcyBmdW5jdGlvbiByZXR1cm4gKG1heF9jbnQgKyAx
KSBpbnN0ZWFkIG9mCj4gPiBtYXhfY250Lgo+ID4gSSB0aGluayB0aGUgY29kZSB3b3VsZCBiZSBz
aW1wbGVyIGlmIG1heF9jbnQgd2FzIGluaXRpYWxpemVkIHRvCj4gPiBtaW4obWF4X2NudCwgMHg4
MCkgKGJlY2F1c2UgMHg3ZiBpcyBhIHN1cHBvcnRlZCBzdWJsZWFmIGluZGV4LCBhcwo+ID4gZmFy
Cj4gPiBhcyBJIGNhbiB0ZWxsKSwgYW5kIHRoZSBmb3IoKSBjb25kaXRpb24gd2FzIGNoYW5nZWQg
dG8gYGkgPAo+ID4gbWF4X2NudGAuCj4gCj4gTG9va3MgYmV0dGVyLgoKWW91IGNvdWxkIGV2ZW4g
c2ltcGxpZnkgdGhpcyBmdW5jdGlvbiBmdXJ0aGVyIGJ5IHJlbW92aW5nIHRoZSA3LWJpdApsaW1p
dCBhbHRvZ2V0aGVyIGFuZCByZWx5aW5nIG9uIHRkeF9yZWFkX2NwdWlkKCkgcmV0dXJuaW5nIGZh
aWx1cmUgd2hlbgp0aGUgc3VibGVhZiBpbmRleCBpcyBub3Qgc3VwcG9ydGVkIChkdWUgdG8gdGhl
ClREWF9NRF9VTlJFQURBQkxFX1NVQkxFQUZfTUFTSyBjaGVjaykuCj4gCj4gPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBLZWVwIHJlYWRpbmcgc3VibGVhZnMgdW50aWwgdGhl
cmUgaXMgYQo+ID4gPiBmYWlsdXJlLgo+ID4gPiAqLwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgaWYgKHRkeF9yZWFkX2NwdWlkKHZjcHUsIGxlYWYsIGksIHRydWUsCj4gPiA+
IG91dHB1dF9lKSkKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gaTsKPiA+ID4gKwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgb3V0cHV0X2UrKzsKPiAKPiBoZXJlIHRoZSBvdXRwdXRfZSsrIGNhbiBvdmVyZmxvdyB0
aGUgYnVmZmVyLgoKTm90IGlmIHRoZSBmb3IoKSBsb29wIHRlcm1pbmF0ZXMgd2hlbiBpIHJlYWNo
ZXMgbWF4X2NudC4KCg==


