Return-Path: <kvm+bounces-38569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BEFFA3BCB9
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 12:26:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AC2A1894F2D
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 11:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3871DEFE3;
	Wed, 19 Feb 2025 11:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awGPmIjN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82211B4F0C
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 11:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739964369; cv=none; b=YYPWeGdyBaMTdtIwmwm8SFlLAvOIwvdHfVjowNnZ/yg3Yt/XGwpouKWyaUZGgGmcH5z1owntiOE4Pjeem4IjvoAOjJUmHBoY0NuDxWMPqG1YB4knEEBsSEQIPoXVtup27uGrhVfAzuyerIueHKnulN74e2+1DEJkp3+ayU2WDgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739964369; c=relaxed/simple;
	bh=iApStDCJvUfCeXee8yeyXgBT4rT/rvhjLJdgWWFCNRM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E9eXTkFUjBJLGuzxwGGFw4q8VxttEcair2jv/6wKbA44i9M/V7ynt+agaDL+grCoVKRLv6+s7UX3egu09PFiMADT/eHipZpKp51yAZ1yLidz+r779ZjATX1dGPgdxS9ZF7POJ/MCoSbq8RHNOmNI5/iM9YCZM08MRJ9I/P5l8sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=awGPmIjN; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38f265c6cb0so2983200f8f.2
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 03:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739964366; x=1740569166; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iApStDCJvUfCeXee8yeyXgBT4rT/rvhjLJdgWWFCNRM=;
        b=awGPmIjNZeu54BzIk96XdYcw2uXJFIJN/DmXMGDoasXEkXS1kjLchk2c+m/oN9LaTT
         nN36gjHE8Pd7+Z9e8teD5vaBXEVK32ZI+9sB7fmYUaTeXCaYuHaQQ7uLi5jJ14gBtrkV
         SbwCprD4VCqg/jQGZrvSMVUNpTKEiiK7A/CNLx543wOWxSwe+HY9PmwRg4GpC9V3RyUU
         4jYwFlPcDHlAkkUUJFLz0QmjZn5kKIOROOXo/L+I2RwxsOgSKAbTf9yLA00kXRaRxB/O
         OTrDR7GQ/PQ4tyLcKcs9mS4CGZi3JCQmWD0UV5E9c++bqCwvLeOZvmKW1WMKHpN3ly9i
         Z3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739964366; x=1740569166;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iApStDCJvUfCeXee8yeyXgBT4rT/rvhjLJdgWWFCNRM=;
        b=gGF584PZWjY4tUMgE21BT5+LqyaQ+sf2QMRD2xYppgPiaEyWP8HTNaHlNHJeJ78b06
         96UdvRQdG3OOdEF6z+h/Y38f9LpMdZJs0MmgK8jknqbrbe7AqnS6k/fNCThc0qkGmlCb
         xdTdOWezGGOoXWC5cNI7kQw50mLz7oWHXTHgBxTyIXjrG5dGJPaGMhlxPqrm7xr73BmE
         bxrnFvTZJHblmJg7J1unf7n6IKkzouJr1gErg+E9FoYjeAI9O8Yk4/Y1XwOYmVq6bX2k
         N/cFkEnyW1SByIusXB3Sop4OVl+5R9umQLwVtlkPDKscl9mgrZOBhWvrx76ZqrQIMvu5
         8mAw==
X-Forwarded-Encrypted: i=1; AJvYcCUL8TlF6wuPvfMI7GoWuySKiE0ihfazy6KGoXGl9BAg1Bx1NcwrJsU0JVw77g8Ylx/JYh4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2rN3N/wZphQuU5IN0zLIPGuzLmLXLrUT7LuOBiyVh1hBxE+Gw
	u88L29FQlH56y2OTVPhZ8kx/2wLneF3W70c8u/UyWI+Nwyv+lN3K
X-Gm-Gg: ASbGnct5iPvXUHHTjYFIZa7J53quv9GTUB3g69hSGJK4XZwe+AKao9zhCFU1qWuXGKk
	JkRouBwndhQSwl8iIQ4V7926hGnTrs/j0WUcWdObPORIRQdLDPRvkYk8lEZ3lWE4TRuMgJ2X6n+
	i2boHPhlkyDmGRbmcS4RNmCQs0uT19L77AEsR9X8gv+DJY9R4grX7G1Z/tjjf/3nCyT+pJ63AA6
	+TWA+e8UkUlCsovDmzwCfLYX2c26O6wsiTU3WqXbu5gGiIgF7TGtJSq1YcIm+JzQmmR0jTjcYOA
	uVGXlkPO2im+LHOoAoH01EI1T5jo+Apvkg+7PwkBykwVMI2Rx6MaPCIN/8T4Gbia3Td/FBTw
X-Google-Smtp-Source: AGHT+IEIDVxGLXVm3UmjmbM8mUbnyzLAfNCR28Hflo5cJ5BeFFsWEiBDrkN+xT4GAJfkjmR43EDCmQ==
X-Received: by 2002:a05:6000:1786:b0:38f:4b2c:2464 with SMTP id ffacd0b85a97d-38f4b2c2755mr8437478f8f.55.1739964366054;
        Wed, 19 Feb 2025 03:26:06 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:64f1:54a0:5dc5:6dd1? ([2001:b07:5d29:f42d:64f1:54a0:5dc5:6dd1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b434fsm17836924f8f.16.2025.02.19.03.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 03:26:05 -0800 (PST)
Message-ID: <71f051114ab5db2a94506b4d8768ebfa79033590.camel@gmail.com>
Subject: Re: [PATCH v7 19/52] i386/tdx: Track mem_ptr for each firmware
 entry of TDVF
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
Date: Wed, 19 Feb 2025 12:26:04 +0100
In-Reply-To: <20250124132048.3229049-20-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
	 <20250124132048.3229049-20-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI1LTAxLTI0IGF0IDA4OjIwIC0wNTAwLCBYaWFveWFvIExpIHdyb3RlOgo+ICtz
dGF0aWMgdm9pZCB0ZHhfZmluYWxpemVfdm0oTm90aWZpZXIgKm5vdGlmaWVyLCB2b2lkICp1bnVz
ZWQpCj4gK3sKPiArwqDCoMKgIFRkeEZpcm13YXJlICp0ZHZmID0gJnRkeF9ndWVzdC0+dGR2ZjsK
PiArwqDCoMKgIFRkeEZpcm13YXJlRW50cnkgKmVudHJ5Owo+ICsKPiArwqDCoMKgIGZvcl9lYWNo
X3RkeF9md19lbnRyeSh0ZHZmLCBlbnRyeSkgewo+ICvCoMKgwqDCoMKgwqDCoCBzd2l0Y2ggKGVu
dHJ5LT50eXBlKSB7Cj4gK8KgwqDCoMKgwqDCoMKgIGNhc2UgVERWRl9TRUNUSU9OX1RZUEVfQkZW
Ogo+ICvCoMKgwqDCoMKgwqDCoCBjYXNlIFREVkZfU0VDVElPTl9UWVBFX0NGVjoKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBlbnRyeS0+bWVtX3B0ciA9IHRkdmYtPm1lbV9wdHIgKyBlbnRyeS0+
ZGF0YV9vZmZzZXQ7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4gK8KgwqDCoMKg
wqDCoMKgIGNhc2UgVERWRl9TRUNUSU9OX1RZUEVfVERfSE9COgo+ICvCoMKgwqDCoMKgwqDCoCBj
YXNlIFREVkZfU0VDVElPTl9UWVBFX1RFTVBfTUVNOgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGVudHJ5LT5tZW1fcHRyID0gcWVtdV9yYW1fbW1hcCgtMSwgZW50cnktPnNpemUsCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+IHFlbXVfcmVhbF9ob3N0X3BhZ2Vfc2l6ZSgpLCAwLCAw
KTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKClNob3VsZCBjaGVjayBmb3IgTUFQ
X0ZBSUxFRCByZXR1cm4gdmFsdWUuCgo+ICvCoMKgwqDCoMKgwqDCoCBkZWZhdWx0Ogo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGVycm9yX3JlcG9ydCgiVW5zdXBwb3J0ZWQgVERWRiBzZWN0aW9u
ICVkIiwgZW50cnktCj4gPnR5cGUpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGV4aXQoMSk7
CgpTZWN0aW9uIGVudHJ5IHR5cGVzIGhhdmUgYWxyZWFkeSBiZWVuIGNoZWNrZWQgYWdhaW5zdCB2
YWxpZCB0eXBlcyBpbgp0ZHZmX3BhcnNlX2FuZF9jaGVja19zZWN0aW9uX2VudHJ5KCksIG5vIG5l
ZWQgdG8gY2hlY2sgdGhlbSBhZ2FpbiBoZXJlLgo=


