Return-Path: <kvm+bounces-24322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABFD953962
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:46:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEAA71F26250
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF1E252F70;
	Thu, 15 Aug 2024 17:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="US2QvTY4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4778D5103F
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 17:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723743813; cv=none; b=msstvd5zgK3oYA+4F8dKxHgzFt+9YyaDQhUonb/Pxl0DUbPhcDOVA86vSwG+D9qJW9FZUyOviZDTHj89MJa6qEw9FUhlNja7ghO9G2pwz6tjdWo8Ip9qtw0sMi5K6fttcxnEHcHZhJWCGMJeeIYi5meguO94Msmbo3z4JSP65ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723743813; c=relaxed/simple;
	bh=Qzx+J2Rjorlia6Ijm2PzI08MkOLH9bUdtHYX95Om4z0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S4qPxtHvdj0Vvr+sunB166ig8cz/cH1PlpMMLbzwRU6EhrIx64xFcXT3RaW+0CmEzvUT37GNEWqjw+fql5BCxqpit+RmChj3SOHPAfXqQITRWiNXpOq3ItBH4z6VlzF1BsepZQjHG7IvNhdBOHmje90o+E9v7Oj/x/WoVFY47nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=US2QvTY4; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-201ee6b084bso10170415ad.2
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 10:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723743811; x=1724348611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qzx+J2Rjorlia6Ijm2PzI08MkOLH9bUdtHYX95Om4z0=;
        b=US2QvTY4oDlXwvkAj8+4O0p3+J6xypOj0EP1XPYJuhjlHeuBAr7l5Ch3pl5riQ4bxa
         KsqrQ1aiga2m5iq6lTywckAhxXX9WtHYo5aAWAhtSdYokFdZdZrGhWarcMGonhdyY55P
         QEVDnzKqb3/HTjrVlZ/2ygdUdqPb73thYIjTVvmQc5ACH5SV9LjYPuJxEVEdbP4l9hVM
         e4bvkNrPEa7ybA41z54l9YVj3SXaYapIeeowmiOoELrNiccGBNUHV5m0nN44P5xBKn2D
         WTEbVKYMkHs6vm4pdumVamDSJyrdCUbbvWkXBgGgNZdva6PnvtboI+6eIhdf8BCJ2LzF
         Kn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723743811; x=1724348611;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qzx+J2Rjorlia6Ijm2PzI08MkOLH9bUdtHYX95Om4z0=;
        b=ICm7/pZde6FpqucVZ3JXuqr0pBr8v8PLwvndtKf6ZDCGe14oSc8/ac/1X9mtt5Sh8n
         22Dx8wvz5Y65VgIxzQXtAf4CX79Lkw1kKz3wSXqaZaG0gdnnaRD3gPZdldxMb2fUYOD4
         5OfZCEUQeathKq7BpcHE5dQDIP6YoB6+nM3y1PtNS1wUv40qSFIO4lILVWaEl+RC1xR9
         jrBpCT/6eurW7L/+mSHICN1YzTokD+kkegvZPO2gCEksPZR/+qv2MqEH62FDfjBWwho/
         h+KLYAZcUktbu2Vu39B7kt7ycKNxRCUHICS4m85MOR5mclU886UY6kSK4nsg5boezHTt
         Noog==
X-Forwarded-Encrypted: i=1; AJvYcCVjkdibn3/efXkXSP+uzndvZdfuYqIaVp2f+WvuVdUW7xDKV/9UIUDvp1SOUOHwueFPwyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YymDuiJ++QsIlmu0CVe2KL3Ga+A/1TIXVg3EaJzBLBCk34GZ5Lo
	MhWsDzDwavKejsUEi/NHo3Fg8z+/AMr5HdVinUtQahpsfxnqubTQZPYmwUWtcmQ=
X-Google-Smtp-Source: AGHT+IGy0FWb0inV+zTv8LG3647k9pDnEZPw+izVbNQR75Eo9w1/uQrFaOyKI3sg/7Ymn8GD4oqkMg==
X-Received: by 2002:a17:902:e84a:b0:202:117:929f with SMTP id d9443c01a7336-20203f52adamr5520275ad.57.1723743811592;
        Thu, 15 Aug 2024 10:43:31 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::b861? ([2604:3d08:9384:1d00::b861])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f02faa77sm12632285ad.58.2024.08.15.10.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 10:43:31 -0700 (PDT)
Message-ID: <90c9de4b-5f4f-4614-8ceb-26a156c0cba5@linaro.org>
Date: Thu, 15 Aug 2024 10:43:29 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] meson: hide tsan related warnings
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, Beraldo Leal <bleal@redhat.com>,
 David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-s390x@nongnu.org,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-2-pierrick.bouvier@linaro.org>
 <CAFEAcA-EAm9mEdGz6m2Y-yxK16TgX6CpxnXc6hW59iAxhXhHtw@mail.gmail.com>
 <Zr3g7lEfteRpNYVC@redhat.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <Zr3g7lEfteRpNYVC@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC8xNS8yNCAwNDowNSwgRGFuaWVsIFAuIEJlcnJhbmfDqSB3cm90ZToNCj4gT24gVGh1
LCBBdWcgMTUsIDIwMjQgYXQgMTE6MTI6MzlBTSArMDEwMCwgUGV0ZXIgTWF5ZGVsbCB3cm90
ZToNCj4+IE9uIFdlZCwgMTQgQXVnIDIwMjQgYXQgMjM6NDIsIFBpZXJyaWNrIEJvdXZpZXIN
Cj4+IDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+IHdyb3RlOg0KPj4+DQo+Pj4gV2hl
biBidWlsZGluZyB3aXRoIGdjYy0xMiAtZnNhbml0aXplPXRocmVhZCwgZ2NjIHJlcG9ydHMg
c29tZQ0KPj4+IGNvbnN0cnVjdGlvbnMgbm90IHN1cHBvcnRlZCB3aXRoIHRzYW4uDQo+Pj4g
Rm91bmQgb24gZGViaWFuIHN0YWJsZS4NCj4+Pg0KPj4+IHFlbXUvaW5jbHVkZS9xZW11L2F0
b21pYy5oOjM2OjUyOiBlcnJvcjog4oCYYXRvbWljX3RocmVhZF9mZW5jZeKAmSBpcyBub3Qg
c3VwcG9ydGVkIHdpdGgg4oCYLWZzYW5pdGl6ZT10aHJlYWTigJkgWy1XZXJyb3I9dHNhbl0N
Cj4+PiAgICAgMzYgfCAjZGVmaW5lIHNtcF9tYigpICAgICAgICAgICAgICAgICAgICAgKHsg
YmFycmllcigpOyBfX2F0b21pY190aHJlYWRfZmVuY2UoX19BVE9NSUNfU0VRX0NTVCk7IH0p
DQo+Pj4gICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+
Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2
aWVyQGxpbmFyby5vcmc+DQo+Pj4gLS0tDQo+Pj4gICBtZXNvbi5idWlsZCB8IDEwICsrKysr
KysrKy0NCj4+PiAgIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9tZXNvbi5idWlsZCBiL21lc29uLmJ1aWxk
DQo+Pj4gaW5kZXggODFlY2Q0YmFlN2MuLjUyZTVhYTk1Y2MwIDEwMDY0NA0KPj4+IC0tLSBh
L21lc29uLmJ1aWxkDQo+Pj4gKysrIGIvbWVzb24uYnVpbGQNCj4+PiBAQCAtNDk5LDcgKzQ5
OSwxNSBAQCBpZiBnZXRfb3B0aW9uKCd0c2FuJykNCj4+PiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBwcmVmaXg6ICcjaW5jbHVkZSA8c2FuaXRpemVyL3RzYW5faW50ZXJmYWNlLmg+
JykNCj4+PiAgICAgICBlcnJvcignQ2Fubm90IGVuYWJsZSBUU0FOIGR1ZSB0byBtaXNzaW5n
IGZpYmVyIGFubm90YXRpb24gaW50ZXJmYWNlJykNCj4+PiAgICAgZW5kaWYNCj4+PiAtICBx
ZW11X2NmbGFncyA9IFsnLWZzYW5pdGl6ZT10aHJlYWQnXSArIHFlbXVfY2ZsYWdzDQo+Pj4g
KyAgdHNhbl93YXJuX3N1cHByZXNzID0gW10NCj4+PiArICAjIGdjYyAoPj0xMSkgd2lsbCBy
ZXBvcnQgY29uc3RydWN0aW9ucyBub3Qgc3VwcG9ydGVkIGJ5IHRzYW46DQo+Pj4gKyAgIyAi
ZXJyb3I6IOKAmGF0b21pY190aHJlYWRfZmVuY2XigJkgaXMgbm90IHN1cHBvcnRlZCB3aXRo
IOKAmC1mc2FuaXRpemU9dGhyZWFk4oCZIg0KPj4+ICsgICMgaHR0cHM6Ly9nY2MuZ251Lm9y
Zy9nY2MtMTEvY2hhbmdlcy5odG1sDQo+Pj4gKyAgIyBIb3dldmVyLCBjbGFuZyBkb2VzIG5v
dCBzdXBwb3J0IHRoaXMgd2FybmluZyBhbmQgdGhpcyB0cmlnZ2VycyBhbiBlcnJvci4NCj4+
PiArICBpZiBjYy5oYXNfYXJndW1lbnQoJy1Xbm8tdHNhbicpDQo+Pj4gKyAgICB0c2FuX3dh
cm5fc3VwcHJlc3MgPSBbJy1Xbm8tdHNhbiddDQo+Pj4gKyAgZW5kaWYNCj4+DQo+PiBUaGF0
IGxhc3QgcGFydCBzb3VuZHMgbGlrZSBhIGNsYW5nIGJ1ZyAtLSAtV25vLWZvbyBpcyBzdXBw
b3NlZA0KPj4gdG8gbm90IGJlIGFuIGVycm9yIG9uIGNvbXBpbGVycyB0aGF0IGRvbid0IGlt
cGxlbWVudCAtV2ZvbyBmb3INCj4+IGFueSB2YWx1ZSBvZiBmb28gKHVubGVzcyBzb21lIG90
aGVyIHdhcm5pbmcvZXJyb3Igd291bGQgYWxzbw0KPj4gYmUgZW1pdHRlZCkuDQo+IA0KPiAt
V25vLWZvbyBpc24ndCBhbiBlcnJvciwgYnV0IGl0IGlzIGEgd2FybmluZy4uLiB3aGljaCB3
ZSB0aGVuDQo+IHR1cm4gaW50byBhbiBlcnJvciBkdWUgdG8gLVdlcnJvciwgdW5sZXNzIHdl
IHBhc3MgLVduby11bmtub3duLXdhcm5pbmctb3B0aW9uDQo+IHRvIGNsYW5nLg0KPiANCg0K
UmlnaHQsIGl0J3MgYSBjb25zZXF1ZW5jZS4NCg0KPj4gICAgICAgICAgICAgICAgQXQgYW55
IHJhdGUsIHRoYXQncyBob3cgZ2NjIGRvZXMgaXQNCj4+IChzZWUgdGhlIHBhcmFncmFwaCAi
V2hlbiBhbiB1bnJlY29nbml6ZWQgd2FybmluZyBvcHRpb24gLi4uIg0KPj4gaW4gaHR0cHM6
Ly9nY2MuZ251Lm9yZy9vbmxpbmVkb2NzL2djYy9XYXJuaW5nLU9wdGlvbnMuaHRtbCApDQo+
PiBhbmQgSSB0aG91Z2h0IGNsYW5nIGRpZCB0b28uLi4NCj4+DQo+PiB0aGFua3MNCj4+IC0t
IFBNTQ0KPj4NCj4gDQo+IFdpdGggcmVnYXJkcywNCj4gRGFuaWVsDQo=

