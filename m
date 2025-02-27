Return-Path: <kvm+bounces-39606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F11A4851F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DBFF3A931F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5AA1B3956;
	Thu, 27 Feb 2025 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BmsWTN3+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7831A8F89
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740673843; cv=none; b=RudH97IR0iQbVI2xXEQ/UjecfAJCbxRsgpzVUZ2gKquM+ifWzEa26ekYRa6usDceHUoLHDMSG+/wSyKoie4U6X+cKpMhtZ/FJTsKf7C0YM3fOOQW1cjMRIII41ftEBmq/24gIDA6mW3QSMbCLeOtrFSJFlA9fTAWcLu2MyIy81o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740673843; c=relaxed/simple;
	bh=uO1689xvk+TlKlzBCtodcTbVEduWVyIaWUSdWM4KIzg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r1DsnAqVCv0fwd0qIdgGsI4q1Y+/D9gtPHJ1UMUVxR2en4sxj1fg1R3uKMXKmtyMlN3CyZvpzZ0mbJKe/+Dlexyxa3LPdqMm+4/ipJeEvQ6xhAjCoF2yOEE2daFDvCeRXwttxaktoRndytfKLiM77XPHq6uw0IHf/eTTZX3MZfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BmsWTN3+; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abb7a6ee2deso175038966b.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 08:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740673840; x=1741278640; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uO1689xvk+TlKlzBCtodcTbVEduWVyIaWUSdWM4KIzg=;
        b=BmsWTN3+z3ucXHkha8bAYDKrmdfQJcZ9/1dTAp/FKn0nZYb/Tm4nBlvv8N+1xIV/as
         Zydy6CRsdcJo0SEWBsN/dHXS0MfaChU6rGft83IXwNeljSQgPNiDD6j/7CJkB4D7UIeL
         sjUC9apcwMR21kasoAdV8b48Kd4k9moJtRMo3NTVfYH+gAEbMSkPCVjrxdL5DMbAEunE
         p+x0aWVuKBPnfPmXLWUUELsEZOg3GzUaw0D2NmCciRNfwwPS0MAJFWErQupXQfd8t4pA
         2OaJRfkmYMYLmnZOrXz8J3YiSPrHqT61THxaPrv7pUqspXNZdQJw+sKHgHFLWhWTUR7F
         6adw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740673840; x=1741278640;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uO1689xvk+TlKlzBCtodcTbVEduWVyIaWUSdWM4KIzg=;
        b=Y4r4YEhJItoWWm+8/Deg47/qZk/VqbGxzceF2f0RDbNxdiiy0Awd5BJjzjqu0ilakt
         P992Jy2eQpgUZjMrxnE1qXNdMG3pew3v4inxiOW//4UkrBi7oU07dcvyCl0NIOuU1H9F
         C6NYgbphw1byh0UcP+TiDqyUPi4QD7/PtlOWOICElxoXUwBEXb/2CO7f5AvcvxVtpFFA
         SlRHTyzvfQWtVi0apbGCMIJoQjFW/BiF6KR5bj0yLqoh/YKOkAPBtBDgM5QnXHOk93FR
         MA6JER9E2clZXvfTspUsijFOrqxFXd08/gWB79UMd4V5ozfoan5SKTErkSMit+D4JhaL
         cb6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUs9PyqhMB7SaOs5CXyny43cqSeV1UwDS2xxmA0fxZI0bpvTfcwEn3bjBWrSS0XcGYq+KU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGxvUVK8SPQQQ2VFJqxa7XsugbyJxxDdYQht9W8XgUZJ9Sq+xP
	i3mIRjkz/G1fwhGSntm3/N1CGoiMjr4g0P5Q3XichMPVT5o5HgtP
X-Gm-Gg: ASbGncuDCH0VSChA0JsIxDHGV+dkDa1AFVuYDeFS9Y4E48ZYDUg13HnsNUKV2lhXu16
	zUO5Vz41hIQxu+rlMx+AHBIu5ZFAAtrT61N1MBwwsJr3tWZ3fCuGm9NFmrGsoSHpoEKLecuQ4dA
	H+INKTyajLbFflRU4XtLx6hvFyjYhiJSofsvafbSBCtR7NFHoRZJ83QyTq9RgU6ijcld9HiNw3B
	pNXsDJ0rCmVFNHEz3Pu88m7r7iF5qHXbL2s75JNzGrCE0r66uEbiEdx4+USjrNp6gP5Ub4tF+tm
	ACRkZs5amiUbadbZ6SWctSVLzoWLsaZw9xSA5aeofvUUecdJtbAbUX3YPU03/ZYo7CCDTFnFgAG
	f8g1lEhI=
X-Google-Smtp-Source: AGHT+IGzelRPWfeFipIB/F4GaEgnsqOh8sVGlh9zTp8YJ9TfIpAv4bd/zArwblq6NyDWvfMjBBuh1A==
X-Received: by 2002:a17:906:f597:b0:abe:bfdd:e68c with SMTP id a640c23a62f3a-abf25d94352mr9995066b.4.1740673839926;
        Thu, 27 Feb 2025 08:30:39 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:d6d5:ac54:57ce:812a? ([2001:b07:5d29:f42d:d6d5:ac54:57ce:812a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c6ed6d0sm147202666b.107.2025.02.27.08.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 08:30:39 -0800 (PST)
Message-ID: <c5418f363998a7416bf3667de7a9f3536634d3ad.camel@gmail.com>
Subject: Re: [PATCH v7 28/52] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Daniel P." =?ISO-8859-1?Q?Berrang=E9?=
	 <berrange@redhat.com>, Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?=
	 <philmd@linaro.org>, Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Marcelo Tosatti
 <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>,  qemu-devel@nongnu.org, kvm@vger.kernel.org
Date: Thu, 27 Feb 2025 17:30:38 +0100
In-Reply-To: <20250124132048.3229049-29-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
	 <20250124132048.3229049-29-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI1LTAxLTI0IGF0IDA4OjIwIC0wNTAwLCBYaWFveWFvIExpIHdyb3RlOgo+IGRp
ZmYgLS1naXQgYS9zeXN0ZW0vcnVuc3RhdGUuYyBiL3N5c3RlbS9ydW5zdGF0ZS5jCj4gaW5kZXgg
MjcyODAxZDMwNzY5Li5jNDI0NGM4OTE1YzYgMTAwNjQ0Cj4gLS0tIGEvc3lzdGVtL3J1bnN0YXRl
LmMKPiArKysgYi9zeXN0ZW0vcnVuc3RhdGUuYwo+IEBAIC01NjUsNiArNTY1LDYwIEBAIHN0YXRp
YyB2b2lkIHFlbXVfc3lzdGVtX3dha2V1cCh2b2lkKQo+IMKgwqDCoMKgIH0KPiDCoH0KPiDCoAo+
ICtzdGF0aWMgY2hhciAqdGR4X3BhcnNlX3BhbmljX21lc3NhZ2UoY2hhciAqbWVzc2FnZSkKPiAr
ewo+ICvCoMKgwqAgYm9vbCBwcmludGFibGUgPSBmYWxzZTsKPiArwqDCoMKgIGNoYXIgKmJ1ZiA9
IE5VTEw7Cj4gK8KgwqDCoCBpbnQgbGVuID0gMCwgaTsKPiArCj4gK8KgwqDCoCAvKgo+ICvCoMKg
wqDCoCAqIEFsdGhvdWdoIG1lc3NhZ2UgaXMgZGVmaW5lZCBhcyBhIGpzb24gc3RyaW5nLCB3ZSBz
aG91bGRuJ3QKPiArwqDCoMKgwqAgKiB1bmNvbmRpdGlvbmFsbHkgdHJlYXQgaXQgYXMgaXMgYmVj
YXVzZSB0aGUgZ3Vlc3QgZ2VuZXJhdGVkIGl0Cj4gYW5kCj4gK8KgwqDCoMKgICogaXQncyBub3Qg
bmVjZXNzYXJpbHkgdHJ1c3RhYmxlLgo+ICvCoMKgwqDCoCAqLwo+ICvCoMKgwqAgaWYgKG1lc3Nh
Z2UpIHsKPiArwqDCoMKgwqDCoMKgwqAgLyogVGhlIGNhbGxlciBndWFyYW50ZWVzIHRoZSBOVUxM
LXRlcm1pbmF0ZWQgc3RyaW5nLiAqLwo+ICvCoMKgwqDCoMKgwqDCoCBsZW4gPSBzdHJsZW4obWVz
c2FnZSk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoCBwcmludGFibGUgPSBsZW4gPiAwOwo+ICvCoMKg
wqDCoMKgwqDCoCBmb3IgKGkgPSAwOyBpIDwgbGVuOyBpKyspIHsKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAoISgweDIwIDw9IG1lc3NhZ2VbaV0gJiYgbWVzc2FnZVtpXSA8PSAweDdlKSkg
ewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJpbnRhYmxlID0gZmFsc2U7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB9Cj4gK8KgwqDCoMKgwqDCoMKgIH0KPiArwqDCoMKgIH0KPiArCj4gK8KgwqDCoCBp
ZiAobGVuID09IDApIHsKPiArwqDCoMKgwqDCoMKgwqAgYnVmID0gZ19tYWxsb2MoMSk7Cj4gK8Kg
wqDCoMKgwqDCoMKgIGJ1ZlswXSA9ICdcMCc7Cj4gK8KgwqDCoCB9IGVsc2Ugewo+ICvCoMKgwqDC
oMKgwqDCoCBpZiAoIXByaW50YWJsZSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIDMg
PSBsZW5ndGggb2YgIiUwMnggIiAqLwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJ1ZiA9IGdf
bWFsbG9jKGxlbiAqIDMpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZvciAoaSA9IDA7IGkg
PCBsZW47IGkrKykgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1lc3Nh
Z2VbaV0gPT0gJ1wwJykgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBicmVhazsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0gZWxzZSB7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNwcmludGYoYnVmICsgMyAqIGks
ICIlMDJ4ICIsIG1lc3NhZ2VbaV0pOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
fQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAoaSA+IDApIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIHJlcGxhY2Ug
dGhlIGxhc3QgJyAnKHNwYWNlKSB0byBOVUxMICovCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBidWZbaSAqIDMgLSAxXSA9ICdcMCc7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
fSBlbHNlIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJ1ZlswXSA9ICdcMCc7
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+ICsKPiArwqDCoMKgwqDCoMKgwqAgfSBlbHNl
IHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBidWYgPSBnX21hbGxvYyhsZW4pOwo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIG1lbWNweShidWYsIG1lc3NhZ2UsIGxlbik7CgpUaGlzIGZhaWxz
IHRvIG51bGwtdGVybWluYXRlIHRoZSBtZXNzYWdlIHN0cmluZyBpbiBidWYuCgo=


