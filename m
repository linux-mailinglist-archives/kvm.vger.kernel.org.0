Return-Path: <kvm+bounces-19864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0DD90D5DF
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 16:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE28A1F21703
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 14:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D25139CFE;
	Tue, 18 Jun 2024 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ugFny4E1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BA82139C1
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718721259; cv=none; b=Tk0Q17EEt4rzoQdctivNIqWam3ZoSV9H4SWN3CJTeo7jWJpKjhZmoQP65a3XyHoB4uUh+CgRi8EP/kE5z5q5v5KjP0ILx3+6nuAkoHni0U2Fzc385u0/R+9bEdUujT284kDf9g4rdhWESWgKEDBhkDk3WwDO1UxuPNyA6Ho8MoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718721259; c=relaxed/simple;
	bh=yqIFQcKxXGEMDkvNg3xeGa5fyRgqgp+DUsjUnWY1/Gw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YIbqWFNlvsZ0NATs9uxIRmm+AnbJwnd7IJhbimzD/rD6KtzxSGb0ZSCUKLlxYQpvnFn+AlXKndifskpR+1bo9vOGetOsyM0zw/2q0HHKikrIhEuK9VDFnnzhfsv8+CNwX31LCXiNVeAbPct+BfBgZYMDUG+ZJ48ibVnNxwzgOEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ugFny4E1; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7060b6e7e78so1601706b3a.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 07:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718721257; x=1719326057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yqIFQcKxXGEMDkvNg3xeGa5fyRgqgp+DUsjUnWY1/Gw=;
        b=ugFny4E1ZpmxeXR9M5fq1Cq3EOKLFTRBJYLZqPBCARM9VEHm83FrLYdfyXBtn1AHBN
         hJBrTCQeEnvyueXvP8AtYbFasqvWrXQvlgHDR1ZAeLjP1pb3/932n5oJ6JPivbBQM5pw
         fjgSXMzxnF9SlubA8i69Cgjy7tv1YZ8s2BYu0aANQMoVQE1uuEd/tAalGoSJOM2Xyny4
         cUsLmmxayIgmA6QEr+VjvFWbyQWSlh61sK/goCDtxmimbiATMaxJWdwmyGRX4sYDMiAb
         f/rJTilVu9gEarjCdBofWx2GdElcZBrahu8UByJUKgwL0YvrggJVyr1XcDO2yClVfetY
         jx5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718721257; x=1719326057;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yqIFQcKxXGEMDkvNg3xeGa5fyRgqgp+DUsjUnWY1/Gw=;
        b=Jhdl77Wmgo+RaiJqVrLL3Q94XA461URuNjdSWgqJvWtpEonwPX9EVMgIdT0gvM1nk8
         hewwA81zJ/Jrtn282mkojhNO6SgPftW2NjZLzgF+NJb/C92nAUGP0mBuLT1pSUqvxozK
         w9+hXD+oAMbTO2IALAnt6DTImSNhOSHc3Hv1cNuDJ24N8N7IododII3GwoOmBB6dRl5v
         Og8tQFMqms7P1bRWUMO7TpYxCzFyrvbhUYqnN8Qi9g1v3N83cebOXzT9Sply4iQzcskY
         laLxV2PpYIKl2v/yT65lCMbgzHYTgDOI40f82cD+7rs10XHPVg+cCkFO3IBMgf7yfmM4
         m4Nw==
X-Forwarded-Encrypted: i=1; AJvYcCVeea9oR7I2o4dNbEeM6tC/EJVEPIiplF/f82sWYDopOBXmpSNjopMQPrOVgFo7pNjrhPi1g95GuLD0PKhakEXGhguq
X-Gm-Message-State: AOJu0Yz7jzyjONLlmol66FlpANe3LYvHVoTVaWa+x8dQ4D51P93hcmb5
	a0F12OmTL7XmgU/o5iInrflFq+wAze1suXyuPKTFYABtlavRBT+C8XkA+lWHAoJwgigi+hQ0EOU
	Pwg==
X-Google-Smtp-Source: AGHT+IG3JGOL9bs1zaJKnhpZD+RqiN+/G8Oc/GvkAyT1mttqJo9peSaQvwcPj9sY5qwVXrpoxbz2Dn+7FCQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3695:b0:706:1ae4:b49d with SMTP id
 d2e1a72fcca58-70628f80c1cmr94b3a.1.1718721257089; Tue, 18 Jun 2024 07:34:17
 -0700 (PDT)
Date: Tue, 18 Jun 2024 07:34:15 -0700
In-Reply-To: <ZnAMsuQsR97mMb4a@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240613060708.11761-1-yan.y.zhao@intel.com> <aa43556ea7b98000dc7bc4495e6fe2b61cf59c21.camel@intel.com>
 <ZnAMsuQsR97mMb4a@yzhao56-desk.sh.intel.com>
Message-ID: <ZnGa550k46ow2N3L@google.com>
Subject: Re: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKdW4gMTcsIDIwMjQsIFlhbiBaaGFvIHdyb3RlOgo+IE9uIEZyaSwgSnVuIDE0LCAy
MDI0IGF0IDA0OjAxOjA3QU0gKzA4MDAsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOgo+ID4gT24g
VGh1LCAyMDI0LTA2LTEzIGF0IDE0OjA2ICswODAwLCBZYW4gWmhhbyB3cm90ZToKPiA+ID4gwqDC
oMKgwqDCoCBhKSBBZGQgYSBjb25kaXRpb24gZm9yIFREWCBWTSB0eXBlIGluIGt2bV9hcmNoX2Zs
dXNoX3NoYWRvd19tZW1zbG90KCkKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoCBiZXNpZGVzIHRoZSB0
ZXN0aW5nIG9mIGt2bV9jaGVja19oYXNfcXVpcmsoKS4gSXQgaXMgc2ltaWxhciB0bwo+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgICJhbGwgbmV3IFZNIHR5cGVzIGhhdmUgdGhlIHF1aXJrIGRpc2FibGVk
Ii4gZS5nLgo+ID4gPiAKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoCBzdGF0aWMgaW5saW5lIGJvb2wg
a3ZtX21lbXNsb3RfZmx1c2hfemFwX2FsbChzdHJ1Y3Qga3ZtCj4gPiA+ICprdm0pwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqAKPiA+
ID4ge8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAKPiA+ID4gwqDCoCAK
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoCDCoMKgwqDCoCByZXR1cm4ga3ZtLT5hcmNoLnZtX3R5cGUg
IT0gS1ZNX1g4Nl9URFhfVk0KPiA+ID4gJibCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX2NoZWNrX2hhc19xdWlyayhrdm0sCj4gPiA+IEtWTV9Y
ODZfUVVJUktfU0xPVF9aQVBfQUxMKTvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgCj4g
PiA+IMKgwqDCoMKgwqDCoMKgwqAgfQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgIAo+ID4gPiDCoMKg
wqDCoMKgIGIpIEluaXQgdGhlIGRpc2FibGVkX3F1aXJrcyBiYXNlZCBvbiBWTSB0eXBlIGluIGtl
cm5lbCwgZXh0ZW5kCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqAgZGlzYWJsZWRfcXVpcmsgcXVlcnlp
bmcvc2V0dGluZyBpbnRlcmZhY2UgdG8gZW5mb3JjZSB0aGUgcXVpcmsgdG8KPiA+ID4gwqDCoMKg
wqDCoMKgwqDCoCBiZSBkaXNhYmxlZCBmb3IgVERYLgoKVGhlcmUncyBhbHNvIG9wdGlvbjoKCiAg
ICAgICAgICAgIGMpIEluaXQgZGlzYWJsZWRfcXVpcmtzIGJhc2VkIG9uIFZNIHR5cGUuCgpJLmUu
IGxldCB1c2Vyc3BhY2UgZW5hYmxlIHRoZSBxdWlyay4gIElmIHRoZSBWTU0gd2FudHMgdG8gc2hv
b3QgaXRzIFREWCBWTSBndWVzdHMsCnRoZW4gc28gYmUgaXQuICBUaGF0IHNhaWQsIEkgZG9uJ3Qg
bGlrZSB0aGlzIG9wdGlvbiBiZWNhdXNlIGl0IHdvdWxkIGNyZWF0ZSBhIHZlcnkKYml6YXJyZSBB
QkkuCgo+ID4gCj4gPiBJJ2QgcHJlZmVyIHRvIGdvIHdpdGggb3B0aW9uIChhKSBoZXJlLiBCZWNh
dXNlIHdlIGRvbid0IGhhdmUgYW55IGJlaGF2aW9yCj4gPiBkZWZpbmVkIHlldCBmb3IgS1ZNX1g4
Nl9URFhfVk0sIHdlIGRvbid0IHJlYWxseSBuZWVkIHRvICJkaXNhYmxlIGEgcXVpcmsiIG9mIGl0
LgoKSSB2b3RlIGZvciAoYSkgYXMgd2VsbC4KCj4gPiBJbnN0ZWFkIHdlIGNvdWxkIGp1c3QgZGVm
aW5lIEtWTV9YODZfUVVJUktfU0xPVF9aQVBfQUxMIHRvIGJlIGFib3V0IHRoZSBiZWhhdmlvcgo+
ID4gb2YgdGhlIGV4aXN0aW5nIHZtX3R5cGVzLiBJdCB3b3VsZCBiZSBhIGZldyBsaW5lcyBvZiBk
b2N1bWVudGF0aW9uIHRvIHNhdmUKPiA+IGltcGxlbWVudGluZyBhbmQgbWFpbnRhaW5pbmcgYSB3
aG9sZSBpbnRlcmZhY2Ugd2l0aCBzcGVjaWFsIGxvZ2ljIGZvciBURFguIFNvIHRvCj4gPiBtZSBp
dCBkb2Vzbid0IHNlZW0gd29ydGggaXQsIHVubGVzcyB0aGVyZSBpcyBzb21lIG90aGVyIHVzZXIg
Zm9yIGEgbmV3IG1vcmUKPiA+IGNvbXBsZXggcXVpcmsgaW50ZXJmYWNlLgo+IFdoYXQgYWJvdXQg
aW50cm9kdWNpbmcgYSBmb3JjZWQgZGlzYWJsZWRfcXVpcmsgZmllbGQ/CgpOYWgsIGl0J2QgcmVx
dWlyZSBtYW51YWwgb3B0LWluIGZvciBldmVyeSBWTSB0eXBlIGZvciBhbG1vc3Qgbm8gYmVuZWZp
dC4gIEluIGZhY3QsCklNTyB0aGUgY29kZSBpdHNlbGYgd291bGQgYmUgYSBuZXQgbmVnYXRpdmUg
dmVyc3VzOgoKCQlyZXR1cm4ga3ZtLT5hcmNoLnZtX3R5cGUgPT0gS1ZNX1g4Nl9ERUZBVUxUX1ZN
ICYmCgkJICAgICAgIGt2bV9jaGVja19oYXNfcXVpcmsoa3ZtLCBLVk1fWDg2X1FVSVJLX1NMT1Rf
WkFQX0FMTCk7CgpiZWNhdXNlIGV4cGxpY2l0bHkgY2hlY2tpbmcgZm9yIEtWTV9YODZfREVGQVVM
VF9WTSB3b3VsZCBkaXJlY3RseSBtYXRjaCB0aGUKZG9jdW1lbnRhdGlvbiAod2hpY2ggd291bGQg
c3RhdGUgdGhhdCB0aGUgcXVpcmsgb25seSBhcHBsaWVzIHRvIERFRkFVTFRfVk0pLgo=

