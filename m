Return-Path: <kvm+bounces-40399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72953A5715A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:17:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DACCA189ACA9
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D9F2505AF;
	Fri,  7 Mar 2025 19:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W/l+ftuy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8C62561C4
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374902; cv=none; b=fMKaJnZF2reLKrLaVSdTPZDeqoPTx9kwywxx3uxDKtbcbkrR8gAjB3fwWhlbx8JFFBUl7H7tMXFOXjZ6jvHLLrtuzG2PJG9DeiRitmg+k7bG3Uis7WCThsaJRR+BKoAVCf8g/JO24vdUuhARL4i9d7pjt36E9ihK54FrGYWEsE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374902; c=relaxed/simple;
	bh=ofp3lIgWhJlI+W74KkGN0cIXfacVx3s4ofrNFqbS9aQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SSMH7VewDnN+YinxuKc+WQKw6f6jQiB0UrcHSLIhJaXnp5HQ9v9upKqfAtrcifgdNJnqTsizxFq+9lQpXMvUph/m3MIYkKBMTSz0hiaV9qDUNDoFhm/LX0UHVNto9+P7f6iOl4D8vUmzFNbb6JRPAbwd4g3kwi2tFoS3LNf6ok8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W/l+ftuy; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f42992f608so4072299a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374900; x=1741979700; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ofp3lIgWhJlI+W74KkGN0cIXfacVx3s4ofrNFqbS9aQ=;
        b=W/l+ftuyesoBfs+g/W6KIjxBq2I/UzvHFYSQyiiuF3EKIBpZmzi0ByhDqH7fzPJnuz
         nOoFeQiapVuYYs0USFBlx9blX96gX5A0I5ABacVli+CzXHFgZdzQ7UdDnDazpBwlBgv3
         /Bqnleg5qslMcBgp4Klff7Ya3k5CXpEdspzxFM+Hw44nJx52y2S2l8o03wPSOsBPGo0W
         mlgog5bwCCP//LT2oMNSQllu+7S9c6Fu9LFbRbCJDDLGuEq4GwE1EVcdUlClfhmdYLd1
         dfvDqZ8Vi2Lj25R6LTn2AR1Ctb4yQ/4fxFb+9feAwqsV0jtKX5cgF7rta+WuAlf4IQ+y
         5CKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374900; x=1741979700;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ofp3lIgWhJlI+W74KkGN0cIXfacVx3s4ofrNFqbS9aQ=;
        b=O3sgRUzy4JRyQ9cKJdqqByGhI7euCRy47IVwoLvc/MN17nc3PlALn4yEWx519wM/VG
         tClS1ZdmeiB2LqxreDLAPU/d4F6rIA4Jn/fVGCuzAnSH+MO81CPm8VLPQ9E0D01Q6y4t
         6jwgVX64Yb+UW+YfmO2/ysk8bS2yk+GRlELPBsn2Ercsrl5gFk++auBQ7C9AZo6xgPSo
         DZOLumV3hW7kPfbuhl//w9Z0YjPwsvzOhwQfKWh3afNkXVl37eMn9dxuZyv1ti0TdNQA
         b3biQ5uuFk8PvWCiaAvj/W9oXWbW/CAPZFRYmNmbyMLyCH9iLwy8/VKPUHG0LkbgOioQ
         brFw==
X-Forwarded-Encrypted: i=1; AJvYcCWupLE3HGvwiX4TxBnv1ri76kOkBmnHJ7QczoFpEx9O9qh8B4g8tEtFMl71VwR2HKYOivQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yykzso7FSvuE8mW7hWj8VadHG7U4BJeuMOUXWzukBLXvCOXIJ4Q
	a6cRAPosKGZiaGmzf68Yc0XUNUZtb3nLeUicWLv8R07NOfIAGQMpFIIfU4c5sJA=
X-Gm-Gg: ASbGncu3GS4KoObz93xbibxEDbknF2kSnx1CWFpvnxZnTivFHIJ5pd/CjbxEtwDseXh
	5wbPDfxBZ4be3BfT9RPqdQCS4GkzxnckRncNLJghw8uHGVgokB0OPrjqgrLnt3jQvNKhE4er3yo
	Dv40fMA5a4MInugOrF5kqKhqg2UrogLYJk1N31l/6wbwucc8udEvMAMuRE7cP0ACGKfU5rU0D45
	QCoOHmB1dYNiqZ/Js4eswEYPsCF8QvkdvncwF/vLOcl3ALXyN1NdRfA8UFknDwL7dnxH2a6l4wJ
	HBuXTW6Ro9uqyzkrmqxSE6m5lXofJhY0WH6tpJ2lADQ8Nn318VqrMKPLfw==
X-Google-Smtp-Source: AGHT+IFumWQakier/Zrq1NKxQVuU8mKCzVTuS9e63eP54WYdDSOTwVpwYCN3lB4CTfz5lr+l3Kb7Tw==
X-Received: by 2002:a17:90b:4ad0:b0:2ff:6fc3:79c4 with SMTP id 98e67ed59e1d1-2ff7cef5cdamr6843613a91.27.1741374900071;
        Fri, 07 Mar 2025 11:15:00 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff4e826141sm5300523a91.48.2025.03.07.11.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:14:59 -0800 (PST)
Message-ID: <02102ee8-dd7f-47af-afa4-d113d461249c@linaro.org>
Date: Fri, 7 Mar 2025 11:14:58 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/14] hw/vfio/spapr: Do not include <linux/kvm.h>
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, qemu-ppc@nongnu.org,
 Thomas Huth <thuth@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Zhenzhong Duan <zhenzhong.duan@intel.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Daniel Henrique Barboza
 <danielhb413@gmail.com>, Eric Auger <eric.auger@redhat.com>,
 qemu-s390x@nongnu.org, Jason Herne <jjherne@linux.ibm.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 David Hildenbrand <david@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20250307180337.14811-1-philmd@linaro.org>
 <20250307180337.14811-3-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gPGxp
bnV4L2t2bS5oPiBpcyBhbHJlYWR5IGluY2x1ZGUgYnkgInN5c3RlbS9rdm0uaCIgaW4gdGhl
IG5leHQgbGluZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1
ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4NCj4gLS0tDQo+ICAgaHcvdmZpby9zcGFwci5jIHwg
MyAtLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9ody92ZmlvL3NwYXByLmMgYi9ody92ZmlvL3NwYXByLmMNCj4gaW5kZXggYWQ0
YzQ5OWVhZmUuLjliNWFkMDViYjFjIDEwMDY0NA0KPiAtLS0gYS9ody92ZmlvL3NwYXByLmMN
Cj4gKysrIGIvaHcvdmZpby9zcGFwci5jDQo+IEBAIC0xMSw5ICsxMSw2IEBADQo+ICAgI2lu
Y2x1ZGUgInFlbXUvb3NkZXAuaCINCj4gICAjaW5jbHVkZSA8c3lzL2lvY3RsLmg+DQo+ICAg
I2luY2x1ZGUgPGxpbnV4L3ZmaW8uaD4NCj4gLSNpZmRlZiBDT05GSUdfS1ZNDQo+IC0jaW5j
bHVkZSA8bGludXgva3ZtLmg+DQo+IC0jZW5kaWYNCj4gICAjaW5jbHVkZSAic3lzdGVtL2t2
bS5oIg0KPiAgICNpbmNsdWRlICJleGVjL2FkZHJlc3Mtc3BhY2VzLmgiDQo+ICAgDQoNClJl
dmlld2VkLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5v
cmc+DQoNCg==

