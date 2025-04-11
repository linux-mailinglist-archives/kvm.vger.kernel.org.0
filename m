Return-Path: <kvm+bounces-43173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46106A8640D
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 19:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0209C9C36E0
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 17:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7805221FD4;
	Fri, 11 Apr 2025 17:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1VrOb+0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43668221713;
	Fri, 11 Apr 2025 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744390912; cv=none; b=kNrPNVoPvpuWPte44JFLVN2H6jqSdBB3eMwlQ6rnHQWQXzXJaq/1Y6b8SXfVtof+tic9/1wKY/YSuR4YBoP+ChR+aD2OviO1HETQFP+32CCxbEYfVow1qlFNXM+jp4qm0s7e6Ff3+tK+h/y7Sowd44ZgVOudFxbeZnVnUR0Np/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744390912; c=relaxed/simple;
	bh=/KN5H4z7CroAIRt2BKniUi5Cpcgz5JCQepcfrafxVZM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e07KnRjxqqkLzOD5Y5sL8LmTLsxaArYrfaVjvVWI6lMAY9rz/BgqBMgw/a7yOnNtHoUkzM1T/OEg3yOuKZ3yIkms7FLy7L1GQntQFPttyZP3kldaowDsAA8gcEFpDgMZc6KSF9DBHheGyxJ/JaVp/jceKwkea+ddY4ywkYlI7yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y1VrOb+0; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso16546265e9.3;
        Fri, 11 Apr 2025 10:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744390908; x=1744995708; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/KN5H4z7CroAIRt2BKniUi5Cpcgz5JCQepcfrafxVZM=;
        b=Y1VrOb+0jNob7afsv68GcEOPVOMIR5vc715FL9ad3izc99uJSf5j1RlM/qhCRlIqMj
         G3sfr5c0y9AXJt06q+JdQt4kDpBBv0XqKjNFTAg7bLwXIEGvmtYvyP+aGkqiAwjkryc4
         XtLBUscPINx81m0DvmSM8aUYNeRB36h7IQJbUKNGO9EJs5fCjodcmSHZvmUwRocBPQSU
         V1XLUnKiim12zlsGHoLYzHFq0/+Z4PIbX6Ryxgl24q2Xy/NXMojxzWWWWykZl3RajhFh
         3umKhvoAY3WlLrqBmAUBMxOInQg1Y3J96wYGrk1HT4ncILLrmvpu0tGsbc+CGcxuYyvY
         CA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744390908; x=1744995708;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/KN5H4z7CroAIRt2BKniUi5Cpcgz5JCQepcfrafxVZM=;
        b=BXmSQmP1VtWsgM4L5iN3e7rPBmZo5+Fyp6/B9e7P5TdgCEQQuBqWF8m2qxA69ANw4M
         p8/8wR95rkP+uIloznxJnmDAgVhgeCjGpbacdE5SOnrrLiECD6FkxtHbo7XecmSqk6jM
         IGUm+8UUH1LtoLUqq+iBu0/MnRfO1VnSOKqnQPXsX2Sf+COZnkGeM6U+D8M/Pl6RXr+p
         9B39HCP5+cHCiprIFlu/E15/Id35MKKm3GSPnGOVczfuT3+TT7XIc2AMdkJ+t2f5obUj
         LI63S6d4rbfu7UvX/AHAt7JUX2FxS7n8+ER0JOU/1xVhzjZN6HZqTLlCnFgr+HNB2oiF
         bdQA==
X-Forwarded-Encrypted: i=1; AJvYcCWD2s9culBTnTnDpDjkbVI9bKccfzKL4ibH8Zmlzzcz3X7Vg3ZNIm+eF1GBqMvBp0Zj4lTZJdT2D/F8sKk6@vger.kernel.org, AJvYcCXQahWfplq6S218srZFG6h1Eo2Xzkj+6h6/KFNDf49A2A/oRzNECwoE0S2epCXQ99vJu44=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP6GYmtf3F/WaxPvfxKMsYZapfr+IbCftNYF1iDPSMreVpVIF5
	uEII8Pq0ecyOebrwUNTrLsCEKQ+q3EV+ZBIjswL9+3G6LeNZV82Z
X-Gm-Gg: ASbGncuagb61R5/8IPoBs+SMMnGx9Kqp4+6rOvDg4guBJn0kB84Em1oZISS+FNt5nF0
	Y4NMM/eapgu4cgWs7EUUrET0bbpGfiIQHPEaSEYqLbPKAu4amwmsNh4mzn+E8k3zRwR7bz17NCN
	Q10CwABpBPVDQmlMR8eGU5ZD0TLIIM6D9G2BDhJpqpPfGmPeRYiazdpkH/Ga3TMPhSKXAFn4DwJ
	PzbnCDTj6dSawoeQcIAeAth+MerStG4R6QrEG0aB7mgwkCHJ8mm5UaV2oEbfMxzPkbYq6K1jykX
	XPppIdPeILJ0/Y2LVdN3/nEzNUyCYupYDy1l7kWNpQnACyJiKTAAd8NpbiLcHVW/nDzkqMdcGGk
	gqtRMhOzfl9YVqm9yGexWWQ==
X-Google-Smtp-Source: AGHT+IFJSlr3fMFwLRozrYI4EVe3jtIuZE4RPCKujDG2hAxxfr6+yYavPIctDfrr4CDrTirY2dtkBA==
X-Received: by 2002:a05:600c:34ca:b0:43c:f5e4:895e with SMTP id 5b1f17b1804b1-43f3a928afamr31127085e9.1.1744390906560;
        Fri, 11 Apr 2025 10:01:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:be33:c0f9:503a:236d? ([2001:b07:5d29:f42d:be33:c0f9:503a:236d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2075fc6dsm93524705e9.28.2025.04.11.10.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 10:01:46 -0700 (PDT)
Message-ID: <521b5214803d404766cb576af2b90fe3ec8326f2.camel@gmail.com>
Subject: Re: [PATCH v3 14/17] x86/apic: Add kexec support for Secure AVIC
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, 
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com, 
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
 Suravee.Suthikulpanit@amd.com,  David.Kaplan@amd.com, x86@kernel.org,
 hpa@zytor.com, peterz@infradead.org,  seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org,  kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Date: Fri, 11 Apr 2025 19:01:44 +0200
In-Reply-To: <20250401113616.204203-15-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
	 <20250401113616.204203-15-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVHVlLCAyMDI1LTA0LTAxIGF0IDE3OjA2ICswNTMwLCBOZWVyYWogVXBhZGh5YXkgd3JvdGU6
Cj4gQWRkIGEgYXBpYy0+dGVhcmRvd24oKSBjYWxsYmFjayB0byBkaXNhYmxlIFNlY3VyZSBBVklD
IGJlZm9yZQo+IHJlYm9vdGluZyBpbnRvIHRoZSBuZXcga2VybmVsLiBUaGlzIGVuc3VyZXMgdGhh
dCB0aGUgbmV3Cj4ga2VybmVsIGRvZXMgbm90IGFjY2VzcyB0aGUgb2xkIEFQSUMgYmFja2luZyBw
YWdlIHdoaWNoIHdhcwo+IGFsbG9jYXRlZCBieSB0aGUgcHJldmlvdXMga2VybmVsLiBTdWNoIGFj
Y2Vzc2VzIGNhbiBoYXBwZW4KPiBpZiB0aGVyZSBhcmUgYW55IEFQSUMgYWNjZXNzZXMgZG9uZSBk
dXJpbmcgZ3Vlc3QgYm9vdCBiZWZvcmUKPiBTZWN1cmUgQVZJQyBkcml2ZXIgcHJvYmUgaXMgZG9u
ZSBieSB0aGUgbmV3IGtlcm5lbCAoYXMgU2VjdXJlCj4gQVZJQyB3b3VsZCBoYXZlIHJlbWFpbmVk
IGVuYWJsZWQgaW4gdGhlIFNlY3VyZSBBVklDIGNvbnRyb2wKPiBtc3IpLgo+IAo+IFNpZ25lZC1v
ZmYtYnk6IE5lZXJhaiBVcGFkaHlheSA8TmVlcmFqLlVwYWRoeWF5QGFtZC5jb20+Cj4gLS0tCj4g
Q2hhbmdlcyBzaW5jZSB2MjoKPiDCoC0gQ2hhbmdlIHNhdmljX3VucmVnaXN0ZXJfZ3BhKCkgaW50
ZXJmYWNlIHRvIGFsbG93IEdQQQo+IHVucmVnaXN0cmF0aW9uCj4gwqDCoCBvbmx5IGZvciBsb2Nh
bCBDUFUuCj4gCj4gwqBhcmNoL3g4Ni9jb2NvL3Nldi9jb3JlLmPCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHwgMjUgKysrKysrKysrKysrKysrKysrKysrKysrKwo+IMKgYXJjaC94ODYvaW5jbHVkZS9h
c20vYXBpYy5owqDCoMKgwqDCoMKgwqDCoCB8wqAgMSArCj4gwqBhcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9zZXYuaMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArKwo+IMKgYXJjaC94ODYva2VybmVsL2Fw
aWMvYXBpYy5jwqDCoMKgwqDCoMKgwqDCoCB8wqAgMyArKysKPiDCoGFyY2gveDg2L2tlcm5lbC9h
cGljL3gyYXBpY19zYXZpYy5jIHzCoCA4ICsrKysrKysrCj4gwqA1IGZpbGVzIGNoYW5nZWQsIDM5
IGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvY29jby9zZXYvY29yZS5j
IGIvYXJjaC94ODYvY29jby9zZXYvY29yZS5jCj4gaW5kZXggOWFkZTJiMTk5M2FkLi4yMzgxODU5
NDkxZGIgMTAwNjQ0Cj4gLS0tIGEvYXJjaC94ODYvY29jby9zZXYvY29yZS5jCj4gKysrIGIvYXJj
aC94ODYvY29jby9zZXYvY29yZS5jCj4gQEAgLTE1ODgsNiArMTU4OCwzMSBAQCBlbnVtIGVzX3Jl
c3VsdCBzYXZpY19yZWdpc3Rlcl9ncGEodTY0IGdwYSkKPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJu
IHJlczsKPiDCoH0KPiDCoAo+ICtlbnVtIGVzX3Jlc3VsdCBzYXZpY191bnJlZ2lzdGVyX2dwYSh1
NjQgKmdwYSkKPiArewo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBnaGNiX3N0YXRlIHN0YXRlOwo+
ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBlc19lbV9jdHh0IGN0eHQ7Cj4gK8KgwqDCoMKgwqDCoMKg
dW5zaWduZWQgbG9uZyBmbGFnczsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZ2hjYiAqZ2hjYjsK
PiArwqDCoMKgwqDCoMKgwqBpbnQgcmV0ID0gMDsKClRoaXMgc2hvdWxkIGJlIGFuIGVudW0gZXNf
cmVzdWx0LCBhbmQgdGhlcmUgaXMgbm8gbmVlZCB0byB6ZXJvLQppbml0aWFsaXplIGl0LgoKPiAr
Cj4gK8KgwqDCoMKgwqDCoMKgbG9jYWxfaXJxX3NhdmUoZmxhZ3MpOwoKZ3VhcmQoaXJxc2F2ZSko
KTsKCj4gKwo+ICvCoMKgwqDCoMKgwqDCoGdoY2IgPSBfX3Nldl9nZXRfZ2hjYigmc3RhdGUpOwo+
ICsKPiArwqDCoMKgwqDCoMKgwqB2Y19naGNiX2ludmFsaWRhdGUoZ2hjYik7Cj4gKwo+ICvCoMKg
wqDCoMKgwqDCoGdoY2Jfc2V0X3JheChnaGNiLCAtMVVMTCk7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0
ID0gc2V2X2VzX2doY2JfaHZfY2FsbChnaGNiLCAmY3R4dCwKPiBTVk1fVk1HRVhJVF9TRUNVUkVf
QVZJQywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFNW
TV9WTUdFWElUX1NFQ1VSRV9BVklDX1VOUkVHSVNURVJfR1BBLCAwKTsKPiArwqDCoMKgwqDCoMKg
wqBpZiAoZ3BhICYmIHJldCA9PSBFU19PSykKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgKmdwYSA9IGdoY2ItPnNhdmUucmJ4Owo+ICvCoMKgwqDCoMKgwqDCoF9fc2V2X3B1dF9naGNi
KCZzdGF0ZSk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsK
PiArwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0Owo+ICt9Cg==


