Return-Path: <kvm+bounces-40404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12054A57171
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DB58189C016
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38824254B1C;
	Fri,  7 Mar 2025 19:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p7V17WzF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D3D21ABB5
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375026; cv=none; b=LKSKJatx/GdtAnqkJ9JS7uurg28bxmd63WoM+HNsxskYtUFIDZfbvjAMn4ymBwGhU2EFDfZxtccvjOceN7CixYCF1IR/eugiimMVvGeNsnjl+qqDuwsoNPTX7DewsVxV7Y9NCUld89m2czjRn7Dwvss9hcI+ib9yBbwCsXCGGa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375026; c=relaxed/simple;
	bh=TzEbOmVXQDlnSwoPF3mwpzDJqDbMB8350tOtQgJiO80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DH0QI/xY0QiuKb74hx2khdUSG2Xj8TTZDk6YSOOb2IC/3U7eTVV6VGG+q3XQ2iLtjEIiwXzhiBE5uC6HG675hQ0KZ6phrTMeqT75FEmOrQauBVO2B2vx/QQIOI4N85mkP9zpLYfsrQ1I1yN+yS95Ycuc2yHALrZluYj1nEpt/iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p7V17WzF; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f42992f608so4075218a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375024; x=1741979824; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TzEbOmVXQDlnSwoPF3mwpzDJqDbMB8350tOtQgJiO80=;
        b=p7V17WzFxcXVgz4XuVTd48v+FEn7143tekEiB5mSWkREurVCI3RDG1zpfcjiYfi7nf
         JVKtgO2Yu1Am6wfu0PmpoujV5brN5X5BzJX6OzaPUy39b0WGkd9uzLS9LwbOcqgFgmQ/
         mMr0v+UE3u6qW5IShZ9/s+WeBCS3NGMl48DiW/nzVPaqslLBUlB/2DdArgcmqZAz4nc7
         LdECzKnGX7g+5bM22vgWexoeKUL6AWyHZ3gBTMiM8jrjbWyeq6laAFG1hZFmIhd2F72c
         hXHUeeixPPA2mzTREeVrzRAfp+slRbiEFFF7fLd9RHyWd+QYXy7pouZ3bSheqfIqtKzx
         cqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375024; x=1741979824;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TzEbOmVXQDlnSwoPF3mwpzDJqDbMB8350tOtQgJiO80=;
        b=Oo93MrWYAYQdIAeMJOalRehQKjQwwo09/hURp3y8+DkO4auzyw7zrSdS4AhA9bXuu8
         LWCFtpgg2eAPPxb4s9eoCy+Yyq+PWhXx4zY7fXdRKa2xMxkZLGqgbozkaTTdm8/DfmtX
         hUl03zgQ5UaeiMZXkGT6VhD6DQViiqz83rR3xXdgFEtNCs3+WdvMsG47hSjUSvLLc0dD
         dtg2B2GeoONVEo5VFi3BCfeyX2aEAdgZO6R6XchvHujQR4T3kmCdp4yX1GF7boDRk2im
         43XfpZJ9BHsDZyzMRCpD/j4Smg6Cb6mASHkVUdZrtHGXkppJFRFeyCTDtcx2BAS7Xvkw
         88SA==
X-Forwarded-Encrypted: i=1; AJvYcCU+PH7FyTKe/9ILXA9WykKHz1RyV+OAzt2iOPbyCfF5y/Cq2XO0bgmTS4xhLoRc0fJ5g30=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMXdNqgWDoJTwozKasJsHyKDszn953qTJzETBVdKrrXtm3tX8I
	9KuKLHmLeYMsXKnrD8lJlfoig+XjHjs/3so3RE0ckCftnuKEDWdKme++ZcU5X00=
X-Gm-Gg: ASbGncuuRo7PjowvI1PO6e5OMfVbWgo5BulWLDbt9Awx58lBym4vRvAmKvIx+uhepmX
	0Nd5FE/b0Yd76s7tGwsWMvPE2r+Pyi2YB0QXTg6h7DjWb3UnuY5JRB8wx7Co1vWyfGodKZ6ltp1
	grTIxFkznYOJyhfoIECY995F2ccMMwn5UEmdAL2IxLNDVYYKNhdDiOhsCvqgyhpu4+xmPhsQen1
	MZMpOQRBE4+nkb5wAMh+dFOCP2N2P9LVefuIgYISjyJ45jPUV2qfGXCxVZ1LRH5Q51tSLO0Mf0y
	wVXTFs5rIXcmBg9XZ3qqEQnLgsfEMzY7mwOybaawULs+SB4U3eOCHbJ2Tw==
X-Google-Smtp-Source: AGHT+IFUGyuXXgaCFQ/kQBvTj8R3BVURDVdf+5unR3AF11B+xPkdApcT4KkZRjFsM6nojEJmjsYMtQ==
X-Received: by 2002:a17:90b:1d8e:b0:2ee:f19b:86e5 with SMTP id 98e67ed59e1d1-2ff7ce6fd4amr8066324a91.14.1741375024209;
        Fri, 07 Mar 2025 11:17:04 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff6933b039sm3418753a91.1.2025.03.07.11.17.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:17:03 -0800 (PST)
Message-ID: <24645792-462c-4e18-b4c9-912d649b7130@linaro.org>
Date: Fri, 7 Mar 2025 11:17:02 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/14] hw/vfio: Compile display.c once
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
 <20250307180337.14811-8-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gZGlz
cGxheS5jIGRvZXNuJ3QgcmVseSBvbiB0YXJnZXQgc3BlY2lmaWMgZGVmaW5pdGlvbnMsDQo+
IG1vdmUgaXQgdG8gc3lzdGVtX3NzW10gdG8gYnVpbGQgaXQgb25jZS4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4N
Cj4gLS0tDQo+ICAgaHcvdmZpby9tZXNvbi5idWlsZCB8IDQgKysrLQ0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9ody92ZmlvL21lc29uLmJ1aWxkIGIvaHcvdmZpby9tZXNvbi5idWlsZA0KPiBpbmRl
eCBmZWE2ZGJlODhjZC4uOTZlMzQyYWE4Y2IgMTAwNjQ0DQo+IC0tLSBhL2h3L3ZmaW8vbWVz
b24uYnVpbGQNCj4gKysrIGIvaHcvdmZpby9tZXNvbi5idWlsZA0KPiBAQCAtNSw3ICs1LDYg
QEAgdmZpb19zcy5hZGQoZmlsZXMoDQo+ICAgKSkNCj4gICB2ZmlvX3NzLmFkZCh3aGVuOiAn
Q09ORklHX1BTRVJJRVMnLCBpZl90cnVlOiBmaWxlcygnc3BhcHIuYycpKQ0KPiAgIHZmaW9f
c3MuYWRkKHdoZW46ICdDT05GSUdfVkZJT19QQ0knLCBpZl90cnVlOiBmaWxlcygNCj4gLSAg
J2Rpc3BsYXkuYycsDQo+ICAgICAncGNpLXF1aXJrcy5jJywNCj4gICAgICdwY2kuYycsDQo+
ICAgKSkNCj4gQEAgLTI4LDMgKzI3LDYgQEAgc3lzdGVtX3NzLmFkZCh3aGVuOiAnQ09ORklH
X1ZGSU8nLCBpZl90cnVlOiBmaWxlcygNCj4gICBzeXN0ZW1fc3MuYWRkKHdoZW46IFsnQ09O
RklHX1ZGSU8nLCAnQ09ORklHX0lPTU1VRkQnXSwgaWZfdHJ1ZTogZmlsZXMoDQo+ICAgICAn
aW9tbXVmZC5jJywNCj4gICApKQ0KPiArc3lzdGVtX3NzLmFkZCh3aGVuOiAnQ09ORklHX1ZG
SU9fUENJJywgaWZfdHJ1ZTogZmlsZXMoDQo+ICsgICdkaXNwbGF5LmMnLA0KPiArKSkNCg0K
UmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJv
Lm9yZz4NCg0K

