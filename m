Return-Path: <kvm+bounces-38559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01A8EA3BB4C
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 11:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AEFB18969DA
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 10:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 687CF1BC9F0;
	Wed, 19 Feb 2025 10:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESs2rOs7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F191E1BD01F
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 10:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739960101; cv=none; b=ba/mK6PutsFzpH5PtY0Wm1nXOtoBSx3dEvVHo9izmZOScwEsOTSmRG+iirieWwU5jsKl6+Nk+eXVwOx1zku7tbQl56Iw3oe1o0LOFUsln2sYzCp/JzI0TwO29Q+N3Ebc/TXPeTJ6lEPC/p9z6QoYXJ/I65arwIkpRA5zvGLrITM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739960101; c=relaxed/simple;
	bh=pBdezJomEBdTTOtXU+AfpHqre+lwyUBQ4DYIvVkVfSA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mXCwvSGYEV95aXg7NYLOdjIeGZqPSK2wr/C2Bv41uTeBKEvmFuNTzge0lydsxKN9Fwb1SrghJ+BQK5wIMSU2VFzQxHgPs+t4N6TUESTLkNO/ebHSLbCjqZFo0AuxGKmJTWGb13yvyL94qRUN/TFG2hlZpHu2W6bUdvK0fuh3EIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ESs2rOs7; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38f378498b0so3254219f8f.0
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 02:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739960098; x=1740564898; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pBdezJomEBdTTOtXU+AfpHqre+lwyUBQ4DYIvVkVfSA=;
        b=ESs2rOs7yLLoXse6YzX8tcJDd+f9fklE4ufMXWT0B7/XoNJS8mN3DgJrpKR7EOa/fk
         2hqBXI9kZdPy9bMkFMQC/H+H0qKSfrj/W5kZS7LqROYop+I6nl574kFw5IdhDYq/p153
         U7zRm87BdnFRvq6saK5cCpEQYSbFAj1B3suC0NMgYqLKfXFA0kqNK3G084stRdff+Fi8
         DxkwgH+SPGFJzr7/p16X7WUtM80Z0Rx22uZxJLO4Bz4gYSEeD7vEL78FaVIDe8O16Of/
         J4rlRi+1a2mycBFXnBDPF0QH27pWO9GntDs4CLCuLHolm+CO3hYXxqrOr9ErbYAZgsSE
         D7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739960098; x=1740564898;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pBdezJomEBdTTOtXU+AfpHqre+lwyUBQ4DYIvVkVfSA=;
        b=hBGrTbKoTJYSKGiMhbbCOrezzWkNi0p9QLUuKhOIpEOUdYnJnvh552hUxZ/68J2Jb/
         FuLTSl0IQuN80cvfdAQe/5r5S8efc6BWqj7lj3NLLL68C0O1GtLEQ4sgPmwzK7hv/K9H
         9+pqvrwLBcTWSvjTuECccTGtt811e87RS/FcYNll9B4xp3FuxE1Tnff1hQRCelZm4dd/
         67ZeBOaQZO81ihKCK9Pir9b/cNwMNGvK65XKen3znDS9j55veabJU6uGxs6RlgPkVTTt
         0d6S5A69sep3y6JgWyKY/lr7NAroYPg55acDGOBhlappNnfBZ4Romu1W+iLvHUYi0o8f
         uQFg==
X-Forwarded-Encrypted: i=1; AJvYcCVUhhrowIWEmBqOClLi2X0wk5Jb9m5xLtHKUvlT/EfpoGU/cUfGhDhONol2O+Ue486tr28=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2auAGTRc0U/3OClLO3W1CZXAPVS//s8ZA/kzQXS2Bp8YXruxW
	A39O+YC7Z3wXbrLne+Hng5ahN1r18jpv3QyjY0Jtug/MvMqo2cvj
X-Gm-Gg: ASbGncurQKMiwJr5/3B0EmrJD9N/hrW5/tS6b6qKrzbc/CK6jvuZb+OxITXQNBqUxk+
	vj+Y71xru1AqPuK8bRnp30eJcahGg591J/EE20wlkXeUfC14F5fCTy4j8cWs9MUzFex3/p9DR2p
	gyNx9+izneiYba8TGtmNEEzTl+pUMMzFQaDV1GGO/Umtl0R6vHctqkzW48Em8wJdT08/8LiSzWq
	Ph/6XwBU+F8DBQEbhh/IaPJuWw6Pm7FSohMAeY9OXbcQsQ3Sv749QOcS4RqPeyf6wx3CGmr66Dk
	v5WEFYJlY12b7HXb7cFcjbJt7YPqWttK4m5eIGs7jOlR3Pk+lkSf1fTNRjA0Vg4KckVtGaot
X-Google-Smtp-Source: AGHT+IGVpmUfFf4EKFxE5EQ7BRJspLuZlpuC9K+zDXtaBJ110L1kEgPSGteUe0uewA53XqGlKtU4FQ==
X-Received: by 2002:a05:6000:1a86:b0:38f:2211:e628 with SMTP id ffacd0b85a97d-38f5878d730mr2603011f8f.20.1739960097984;
        Wed, 19 Feb 2025 02:14:57 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:64f1:54a0:5dc5:6dd1? ([2001:b07:5d29:f42d:64f1:54a0:5dc5:6dd1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b412esm17125485f8f.1.2025.02.19.02.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 02:14:57 -0800 (PST)
Message-ID: <6571727841685f4276aa7c814776ff1fdd162a0a.camel@gmail.com>
Subject: Re: [PATCH v7 08/52] i386/tdx: Initialize TDX before creating TD
 vcpus
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
Date: Wed, 19 Feb 2025 11:14:56 +0100
In-Reply-To: <20250124132048.3229049-9-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
	 <20250124132048.3229049-9-xiaoyao.li@intel.com>
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
ZmYgLS1naXQgYS9hY2NlbC9rdm0va3ZtLWFsbC5jIGIvYWNjZWwva3ZtL2t2bS1hbGwuYwo+IGlu
ZGV4IDQ1ODY3ZGJlMDgzOS4uZTM1YTlmYmQ2ODdlIDEwMDY0NAo+IC0tLSBhL2FjY2VsL2t2bS9r
dm0tYWxsLmMKPiArKysgYi9hY2NlbC9rdm0va3ZtLWFsbC5jCj4gQEAgLTU0MCw4ICs1NDAsMTUg
QEAgaW50IGt2bV9pbml0X3ZjcHUoQ1BVU3RhdGUgKmNwdSwgRXJyb3IgKiplcnJwKQo+IMKgCj4g
wqDCoMKgwqAgdHJhY2Vfa3ZtX2luaXRfdmNwdShjcHUtPmNwdV9pbmRleCwga3ZtX2FyY2hfdmNw
dV9pZChjcHUpKTsKPiDCoAo+ICvCoMKgwqAgLyoKPiArwqDCoMKgwqAgKiB0ZHhfcHJlX2NyZWF0
ZV92Y3B1KCkgbWF5IGNhbGwgY3B1X3g4Nl9jcHVpZCgpLiBJdCBpbiB0dXJuCj4gbWF5IGNhbGwK
PiArwqDCoMKgwqAgKiBrdm1fdm1faW9jdGwoKS4gU2V0IGNwdS0+a3ZtX3N0YXRlIGluIGFkdmFu
Y2UgdG8gYXZvaWQgTlVMTAo+IHBvaW50ZXIKPiArwqDCoMKgwqAgKiBkZXJlZmVyZW5jZS4KPiAr
wqDCoMKgwqAgKi8KPiArwqDCoMKgIGNwdS0+a3ZtX3N0YXRlID0gczsKClRoaXMgYXNzaWdubWVu
dCBzaG91bGQgYmUgcmVtb3ZlZCBmcm9tIGt2bV9jcmVhdGVfdmNwdSgpLCBhcyBub3cgaXQncwpy
ZWR1bmRhbnQgdGhlcmUuCgo+IMKgwqDCoMKgIHJldCA9IGt2bV9hcmNoX3ByZV9jcmVhdGVfdmNw
dShjcHUsIGVycnApOwo+IMKgwqDCoMKgIGlmIChyZXQgPCAwKSB7Cj4gK8KgwqDCoMKgwqDCoMKg
IGNwdS0+a3ZtX3N0YXRlID0gTlVMTDsKCk5vIG5lZWQgdG8gcmVzZXQgY3B1LT5rdm1fc3RhdGUg
dG8gTlVMTCwgdGhlcmUgYWxyZWFkeSBhcmUgb3RoZXIgZXJyb3IKY29uZGl0aW9ucyB1bmRlciB3
aGljaCBjcHUtPmt2bV9zdGF0ZSByZW1haW5zIGluaXRpYWxpemVkLgoKPiDCoMKgwqDCoMKgwqDC
oMKgIGdvdG8gZXJyOwo+IMKgwqDCoMKgIH0KPiDCoAo+IEBAIC01NTAsNiArNTU3LDcgQEAgaW50
IGt2bV9pbml0X3ZjcHUoQ1BVU3RhdGUgKmNwdSwgRXJyb3IgKiplcnJwKQo+IMKgwqDCoMKgwqDC
oMKgwqAgZXJyb3Jfc2V0Z19lcnJubyhlcnJwLCAtcmV0LAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJrdm1faW5pdF92Y3B1OiBrdm1fY3JlYXRl
X3ZjcHUgZmFpbGVkCj4gKCVsdSkiLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9hcmNoX3ZjcHVfaWQoY3B1KSk7Cj4gK8KgwqDCoMKgwqDC
oMKgIGNwdS0+a3ZtX3N0YXRlID0gTlVMTDsKClNhbWUgaGVyZS4K


