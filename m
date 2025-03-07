Return-Path: <kvm+bounces-40401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7901A57165
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:19:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 457903B13BA
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081B3253B46;
	Fri,  7 Mar 2025 19:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="klkIkGt9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA67121E0A8
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374940; cv=none; b=vDoiSjHtbK2feekv/ljjYHeO4dgY8QtlPSgBJqZmmGHTRgHGh8/skwB/OHL9Bo9xJLlJrcxLG7VdJ/5JsU58aWmbK3q1HWm4HRBO+e2NI8LGQ5vAbGlRGZzSFfTsSXPG6gczswM6hxFSPPc0UEj8ulq9hXIhcpkfBTYdordOV2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374940; c=relaxed/simple;
	bh=QqCDeIdxVx+sY8BGYg8mEWyfybpFwVxZ0VNk7LmcKUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mCdEQz1FGMcVcIMOIHkVFqh2N81meudkjthZgAqAygd7aS2m6FNHfp4PqvoCYPrcHzEr+D6um8R/m/wFU/A30H43SAQrU5Us4XqOBAjTnInsD4eje21F2V4WZMT6qmmLvNMiGq/v2BuK0JLnmSJ8wl8iHdtbJvX7nn0654M11Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=klkIkGt9; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-224341bbc1dso14127155ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374938; x=1741979738; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QqCDeIdxVx+sY8BGYg8mEWyfybpFwVxZ0VNk7LmcKUo=;
        b=klkIkGt9zciBMXxiY71l5oDZLOK3nz71guXhoodJuLgchjl4egi0vTdeF8GAJp0V82
         GUBzVHXrmEY+w/WHMnt3WV0iisorMCH+igwHVnN19oBqoIXtrzoPoEVkqnJ0hLdDOE/6
         1iKnUKKDuV58rXiuMlkoHZVdejTs5MAkbfI8hYD69Q8Dq8/qsuq3MhTQB9Pe5hu1fKGb
         wJ9wqHovU1e53haGLc3ohF73WsbQ265+4cSnewl26dxyRjQs88D0AAEuQ5RoSQRkdkf0
         /Nk+eb7+5x+A2O5dva2Ew1SvDmZzzK36qnOwd1YtxJxTMq9auqZRV5xTegiPtixfttcf
         9A0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374938; x=1741979738;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QqCDeIdxVx+sY8BGYg8mEWyfybpFwVxZ0VNk7LmcKUo=;
        b=njeogHekdz9ZXIsDtVZgOnU0grRvSNqQi/Cxpp7KsJdyaPDOyvOnNGRXL1cXvoZ7/r
         D1LS5WUIyCgkIkVhvOvgmLJTL0TfkBLW1CIKrtTR7j4lXbt/XRyvDCtfckZ3dDSldHC0
         KYGCmHZP1qhR59mIm4FLOHbPbjPLXjvfS+kOI0WSKZ+AUU+xCFBYQKUYS6YkBw0jPZPA
         vgnFADTAw8Gf5YQ7cZEjhvk+/Ju7D5jqiaQAH+La8oitx1KnsQee06ZcIAQOx3+NsQJ5
         3lZehweobXVNenl2vIO3aPpgDBMs+JYZi3zsAfQrvy2m6KIbFqOtvDz3smKOphEUkkCV
         iWQg==
X-Forwarded-Encrypted: i=1; AJvYcCUbTTXSjoRl9esUEGfAa+MechCh3IZcaCIfFVehd4a5sRDeJNIrQtvGj1+ybMWiwhxARgc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFu268imsxAXitphA7zex5atmnnoDDEerL/HNlZqzjBXFJcDHB
	juTmJJJCD7OhyzSszhvSo3Eh2UzfNRRet7i9TiuiJmS7ytn55EfiEqR/W180KWA=
X-Gm-Gg: ASbGnctikUZ9Y+i/ybPJ/gDiXDloJLV34n3enq8bGprPn6+IBtuJEESQdlGcKVvVo0q
	d1MMT/CjRKChbEPvgDsNOsggVMvlcr3XHJwbPU0yZ8rw8TZZJ58oKjGA54jObu9h3O2s8rnuUEo
	+ZRYWiiX+QOfwkpaw1hJ+V6KFJjE6CBhYzYbtptYP7D0HOi9lXxYUNdoP4ni/Uaj57EpjC/Yxkf
	jOEwV0jO8VkFaVUV+a54vemhaBmZha3b7m/ptzEI+KkdvIyGa5rlDQ9CIIwSrnBxxs2d9bIAkli
	Ur+C4Jr3h9+1KB8ECTM1cmVKhRK4Nu/h1pCJTUU5VVRC9AVloy8CWTIM3A==
X-Google-Smtp-Source: AGHT+IGnzx+k5zUhuX3NZ/2GZWiR3bSe6+YntnIe5LSV9c49LIusJsWpQguDAWG9zDWnLdX6/aAelQ==
X-Received: by 2002:a05:6a21:3990:b0:1f5:52fe:dcf8 with SMTP id adf61e73a8af0-1f552fee0acmr2561235637.26.1741374938061;
        Fri, 07 Mar 2025 11:15:38 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af40411619dsm1571828a12.14.2025.03.07.11.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:15:37 -0800 (PST)
Message-ID: <0075174b-a5ee-4516-b9d8-c81e57d862ec@linaro.org>
Date: Fri, 7 Mar 2025 11:15:36 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/14] hw/vfio: Compile more objects once
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
 <20250307180337.14811-5-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gVGhl
c2UgZmlsZXMgZGVwZW5kIG9uIHRoZSBWRklPIHN5bWJvbCBpbiB0aGVpciBLY29uZmlnDQo+
IGRlZmluaXRpb24uIFRoZXkgZG9uJ3QgcmVseSBvbiB0YXJnZXQgc3BlY2lmaWMgZGVmaW5p
dGlvbnMsDQo+IG1vdmUgdGhlbSB0byBzeXN0ZW1fc3NbXSB0byBidWlsZCB0aGVtIG9uY2Uu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1k
QGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgIGh3L3ZmaW8vbWVzb24uYnVpbGQgfCA2ICsrKy0t
LQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvaHcvdmZpby9tZXNvbi5idWlsZCBiL2h3L3ZmaW8vbWVz
b24uYnVpbGQNCj4gaW5kZXggOGUzNzZjZmNiZjguLjI5NzJjNmZmOGRlIDEwMDY0NA0KPiAt
LS0gYS9ody92ZmlvL21lc29uLmJ1aWxkDQo+ICsrKyBiL2h3L3ZmaW8vbWVzb24uYnVpbGQN
Cj4gQEAgLTE0LDEzICsxNCwxMyBAQCB2ZmlvX3NzLmFkZCh3aGVuOiAnQ09ORklHX1ZGSU9f
UENJJywgaWZfdHJ1ZTogZmlsZXMoDQo+ICAgKSkNCj4gICB2ZmlvX3NzLmFkZCh3aGVuOiAn
Q09ORklHX1ZGSU9fQ0NXJywgaWZfdHJ1ZTogZmlsZXMoJ2Njdy5jJykpDQo+ICAgdmZpb19z
cy5hZGQod2hlbjogJ0NPTkZJR19WRklPX1BMQVRGT1JNJywgaWZfdHJ1ZTogZmlsZXMoJ3Bs
YXRmb3JtLmMnKSkNCj4gLXZmaW9fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJT19YR01BQycs
IGlmX3RydWU6IGZpbGVzKCdjYWx4ZWRhLXhnbWFjLmMnKSkNCj4gLXZmaW9fc3MuYWRkKHdo
ZW46ICdDT05GSUdfVkZJT19BTURfWEdCRScsIGlmX3RydWU6IGZpbGVzKCdhbWQteGdiZS5j
JykpDQo+ICAgdmZpb19zcy5hZGQod2hlbjogJ0NPTkZJR19WRklPX0FQJywgaWZfdHJ1ZTog
ZmlsZXMoJ2FwLmMnKSkNCj4gLXZmaW9fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJT19JR0Qn
LCBpZl90cnVlOiBmaWxlcygnaWdkLmMnKSkNCj4gICANCj4gICBzcGVjaWZpY19zcy5hZGRf
YWxsKHdoZW46ICdDT05GSUdfVkZJTycsIGlmX3RydWU6IHZmaW9fc3MpDQo+ICAgDQo+ICtz
eXN0ZW1fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJT19YR01BQycsIGlmX3RydWU6IGZpbGVz
KCdjYWx4ZWRhLXhnbWFjLmMnKSkNCj4gK3N5c3RlbV9zcy5hZGQod2hlbjogJ0NPTkZJR19W
RklPX0FNRF9YR0JFJywgaWZfdHJ1ZTogZmlsZXMoJ2FtZC14Z2JlLmMnKSkNCj4gK3N5c3Rl
bV9zcy5hZGQod2hlbjogJ0NPTkZJR19WRklPX0lHRCcsIGlmX3RydWU6IGZpbGVzKCdpZ2Qu
YycpKQ0KPiAgIHN5c3RlbV9zcy5hZGQod2hlbjogJ0NPTkZJR19WRklPJywgaWZfdHJ1ZTog
ZmlsZXMoDQo+ICAgICAnaGVscGVycy5jJywNCj4gICAgICdjb250YWluZXItYmFzZS5jJywN
Cg0KUmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGlu
YXJvLm9yZz4NCg0K

