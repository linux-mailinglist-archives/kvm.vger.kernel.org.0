Return-Path: <kvm+bounces-38567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25FC9A3BC41
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 11:59:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6E6917117C
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 10:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7313C1DE8A8;
	Wed, 19 Feb 2025 10:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ErbOKozA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2263B1B425A
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 10:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739962731; cv=none; b=mTDe1iDMWO5knt/InQwl3mlqW+VbJHoU/QGoc49Arb4x/85wkqcHoTOtauxcOWkrjpxmHkhSGyqNZu58iB+ZXsEg+oe6l5twJMnBwdjQhujK4huk9To2jvy7uuim/TnhetrcwQscSrWI9IEipuuU5r1TBS+cqgHYreFljc3e9Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739962731; c=relaxed/simple;
	bh=hWa0KcU05B95Kj4EgP8ZhPIrYp6WCMUxD6IImKVDfu8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B4pOQCmJuj0vKy+QRKzflvisZRFYNXwFgNJ0Tsrg0z3O3X9F/whVE+wQHNaoSS15mv2rCO9vLwPLWArTDfkOtwNsYDR68gIGozRVFP5I5izxtFM2+L4fZ+DPfzCjFpKSphkcMc165XBW18B3njwo0WZb0WAJaQXIybPWSGEFllc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ErbOKozA; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-38f2b7ce319so4130148f8f.2
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 02:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739962728; x=1740567528; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hWa0KcU05B95Kj4EgP8ZhPIrYp6WCMUxD6IImKVDfu8=;
        b=ErbOKozAKQNGWVhJH5ygZ5f9ZYzyyItFBE+6/4V0xFzE22/dhYebxZ7EZNYRLvUbDV
         nYQimc62fEp3tOx1C52Xa2+yVk2Z4dG8ZZyq3fg0AZpaXnSnAGtZSaJqfsQCzb6kDvZG
         nVkSWAWpgJJMOd1Sl+mGzixYwWqkjM0OO0IayGyuf+CpHepQB8HUuCAm7EAiGbhCYo8W
         6zMtoQI9sQ62+mn0mVuUqwkU2J4lPIkiC1fvhiqhfxlVBuarSL1xAYWSdwSNnFGqmhWt
         x3bvIm56k0XopHqw4++Rk16RYX0su2XYj7gnYqXgrJH9rq7CuMNd56jHUdYGnGQFq3JV
         niwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739962728; x=1740567528;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hWa0KcU05B95Kj4EgP8ZhPIrYp6WCMUxD6IImKVDfu8=;
        b=AZxLjvHG8pMQnaiJ23Zf5sJGxqX/V51YAEXPZdAF/6r2MAfzEwiQu0hz4VM0p2OSLd
         Tb8lGMYzMktVAfe6f9tFex/8F8xa1m6XM/xn4TigOfoqqr0dKiPlIJziwCUg25xcvQ1U
         wx1jl8aXAlyN0f9/RprJwPhM6+FZsDHT2V2Opx+MEPo3cETwPgCx2gOqqzVX9hLlHCPx
         VbW/kf84GPRTNd6m/yFMo/okRer7qb03v3m7Sr6J2m5CCUJS1LpP8aCKCSgcrQ09nuQH
         S7mnUqMjnRKWjbGkFAGRiQFgQGVm0PFMTWH5uNeak2f/6HEfGc2a+ACmlzSYfrvosLhW
         GcIg==
X-Forwarded-Encrypted: i=1; AJvYcCVnnczT+2lKE9MvxOXz8Xi6CD5B+Hc8gPOGnRe3CdS6JDwOsYASm0PRgShlOCAUjbdtx8s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyES1YJv4X5OT6QhKBu+xGel+pZgmVmxRcu82BC04kExC6heTnq
	RVbFf3fMZq7T1e+YIF/e+O+NSdLB77w1a3b37SWmVwJB9pk+r8oW
X-Gm-Gg: ASbGncs96MfcEtM0AqlzAfNdI6nfbPQENmhHumD0nuowXubqoYhMyIsW/354Ulb5fNt
	niP1jvs69N/CdauTsIC6hYTuHsNEzjpWhx1wRSIdkQtzEz3pSxbeAREnZNb+8GyS/2mwyLJpB6j
	PzfHgpo5Zm9Oizbm5fGFNvRLNLdbBlt9TXwHJLk+ZutfPbPYeCb/FEbExXiR2Cta513CXEC/sAh
	AidZ4r1NDoahPxEP7pQQ+YnESmOcMn2zXRQ3giQkxc/2bL2UG1wVgTzlQZhytCW5tsP50YDO2Ys
	dnobMLIoTpuNfS7KWpHl291UNktOQiWudhwtWUVwtIDn5tmFuMqWqcdlc0QS9eFkmmZVghvA
X-Google-Smtp-Source: AGHT+IHXKJZTfwSLoxDWU99PQefFxQjd9dujVTOF/9TaLmnFIFk3O7jX4E7v8WovkAveBu/o59Cu3A==
X-Received: by 2002:a05:6000:1a54:b0:38f:4e50:8b0b with SMTP id ffacd0b85a97d-38f58796ab6mr2280770f8f.31.1739962728096;
        Wed, 19 Feb 2025 02:58:48 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:64f1:54a0:5dc5:6dd1? ([2001:b07:5d29:f42d:64f1:54a0:5dc5:6dd1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f7979sm17280250f8f.83.2025.02.19.02.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 02:58:47 -0800 (PST)
Message-ID: <7e8ef2dc3958bf9ea68ac3feb68fc216a9107411.camel@gmail.com>
Subject: Re: [PATCH v7 16/52] i386/tdvf: Introduce function to parse TDVF
 metadata
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
Date: Wed, 19 Feb 2025 11:58:46 +0100
In-Reply-To: <20250124132048.3229049-17-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
	 <20250124132048.3229049-17-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI1LTAxLTI0IGF0IDA4OjIwIC0wNTAwLCBYaWFveWFvIExpIHdyb3RlOgo+ICtp
bnQgdGR2Zl9wYXJzZV9tZXRhZGF0YShUZHhGaXJtd2FyZSAqZncsIHZvaWQgKmZsYXNoX3B0ciwg
aW50IHNpemUpCj4gK3sKPiArwqDCoMKgIGdfYXV0b2ZyZWUgVGR2ZlNlY3Rpb25FbnRyeSAqc2Vj
dGlvbnMgPSBOVUxMOwo+ICvCoMKgwqAgVGR2Zk1ldGFkYXRhICptZXRhZGF0YTsKPiArwqDCoMKg
IHNzaXplX3QgZW50cmllc19zaXplOwo+ICvCoMKgwqAgaW50IGk7Cj4gKwo+ICvCoMKgwqAgbWV0
YWRhdGEgPSB0ZHZmX2dldF9tZXRhZGF0YShmbGFzaF9wdHIsIHNpemUpOwo+ICvCoMKgwqAgaWYg
KCFtZXRhZGF0YSkgewo+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiArwqDCoMKg
IH0KPiArCj4gK8KgwqDCoCAvKiBsb2FkIGFuZCBwYXJzZSBtZXRhZGF0YSBlbnRyaWVzICovCj4g
K8KgwqDCoCBmdy0+bnJfZW50cmllcyA9IGxlMzJfdG9fY3B1KG1ldGFkYXRhLT5OdW1iZXJPZlNl
Y3Rpb25FbnRyaWVzKTsKPiArwqDCoMKgIGlmIChmdy0+bnJfZW50cmllcyA8IDIpIHsKPiArwqDC
oMKgwqDCoMKgwqAgZXJyb3JfcmVwb3J0KCJJbnZhbGlkIG51bWJlciBvZiBmdyBlbnRyaWVzICgl
dSkgaW4gVERWRgo+IE1ldGFkYXRhIiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBmdy0+bnJfZW50cmllcyk7Cj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlO
VkFMOwo+ICvCoMKgwqAgfQo+ICsKPiArwqDCoMKgIGVudHJpZXNfc2l6ZSA9IGZ3LT5ucl9lbnRy
aWVzICogc2l6ZW9mKFRkdmZTZWN0aW9uRW50cnkpOwo+ICvCoMKgwqAgaWYgKG1ldGFkYXRhLT5M
ZW5ndGggIT0gc2l6ZW9mKCptZXRhZGF0YSkgKyBlbnRyaWVzX3NpemUpIHsKPiArwqDCoMKgwqDC
oMKgwqAgZXJyb3JfcmVwb3J0KCJURFZGIG1ldGFkYXRhIGxlbiAoMHgleCkgbWlzbWF0Y2gsIGV4
cGVjdGVkCj4gKDB4JXgpIiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBtZXRhZGF0YS0+TGVuZ3RoLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgICh1aW50MzJfdCkoc2l6ZW9mKCptZXRhZGF0YSkgKyBlbnRyaWVzX3NpemUpKTsK
PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gK8KgwqDCoCB9Cj4gKwo+ICvCoMKg
wqAgZnctPmVudHJpZXMgPSBnX25ldyhUZHhGaXJtd2FyZUVudHJ5LCBmdy0+bnJfZW50cmllcyk7
Cj4gK8KgwqDCoCBzZWN0aW9ucyA9IGdfbmV3KFRkdmZTZWN0aW9uRW50cnksIGZ3LT5ucl9lbnRy
aWVzKTsKPiArCj4gK8KgwqDCoCBpZiAoIW1lbWNweShzZWN0aW9ucywgKHZvaWQgKiltZXRhZGF0
YSArIHNpemVvZigqbWV0YWRhdGEpLAo+IGVudHJpZXNfc2l6ZSkpIHsKPiArwqDCoMKgwqDCoMKg
wqAgZXJyb3JfcmVwb3J0KCJGYWlsZWQgdG8gcmVhZCBURFZGIHNlY3Rpb24gZW50cmllcyIpOwoK
bWVtY3B5KCkgY2Fubm90IGZhaWwuLi4KCg==


