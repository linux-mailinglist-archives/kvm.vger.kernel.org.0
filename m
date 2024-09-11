Return-Path: <kvm+bounces-26545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA633975724
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:30:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13C1DB29D46
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95FBE1AB6DD;
	Wed, 11 Sep 2024 15:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rcx/j3vp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAE319F127
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726068591; cv=none; b=Q7uIOHf44yAjfXLT1GtL9SBnQil8euvjaKKXFeKvcG1v/Nl20QmBSL8GSQ1bMeESiKn+QF4ijEfLIjOH3F3PQKbZKN43N8E4ZGhzCqzmtTcKBd+5QKEGA2C/SrjcmQhr9hF+TzJWUmjNpC72pJaBJzZHNVzbru66aO9FPfq5nRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726068591; c=relaxed/simple;
	bh=V6m6vNQT7mJMu+b2f7V4GrIIRmDUGYZa9xv/2BTcLJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RRAstDqw4NquIUkJbFWqdjksJynZ6lRKdKRrEJzUBEaq5oNw6doeiykKD8fqGXTjnyi1GM/JptOJx09u8PrQ+EMA5QMtMI9hKzzFTyXE54JkqGiJHGsG2YQFwVJBzmawfXomCkFN6MnHMENmchmoLeKEVe2YgOgGJRnOfX5E2GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rcx/j3vp; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7191f58054aso561856b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726068589; x=1726673389; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V6m6vNQT7mJMu+b2f7V4GrIIRmDUGYZa9xv/2BTcLJk=;
        b=rcx/j3vppGH9lagKLq0SEY815HRpO1lmlNg35RIKIWQeKpNQoVnQcpvenGv5AQT1Kx
         cms2gO8dluA2CoU8C1Bs3rUFxIeeYNJ+gkMP/GIg7TdagQUN33rmJlBUEjF8uecmksnE
         a9j66BmQ28Hn/OsgCD00rKhAQDIWPwIIWiRA+FPyvoq4AH2xSVDMB9MHN7tGW7ysyW3B
         sdlLyGyc6mCDVjPNHMQA+fJuSYQqb/E51EJWLwPzk0jbriYQy7VfzlpnFjnAcM7Fm8SC
         7or9eZn/QGjk2TeCagNFfiJA8xjimdtPoPBoLwWQipUxCAQZs14oW0PJbgmHYAXTEHFq
         P78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726068589; x=1726673389;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V6m6vNQT7mJMu+b2f7V4GrIIRmDUGYZa9xv/2BTcLJk=;
        b=fFhf5k+wdmidkh6kTS42hJuZ0MTm4d/d9VkCBG2njSLRFPMFLe+kU5k0rIbp7wqYWR
         oD6EWwsGSmaY8gE7W/dWaeoYyAuVr4XuRrE68xImnrA6xxuL39oFIum/OOTR1CsNV5QQ
         VvNTsGpW+lTMgBer4rA2TEhymIGLmhFe36gVuZsuBF72G40g91k7ui1PjhuLVehazBoC
         6X7gDyIq9wAng+wBkDy8tr9mYIEX0vBo+5G2/BfyIs1dwOjAtKCzmyiFUQ5fa640kcGH
         gW+jAZqTLGhH26j2XjK5+ZMUkc5nfg2xq8aGYSgHXjGrlFbddvX93U7EsFjvCAWCEOR9
         jyrw==
X-Forwarded-Encrypted: i=1; AJvYcCUe5D6zMjBCnC0khU3J91fLiufvW8YnPXcfbUCSSHcTbVWhk9NiGadNpG2DL0N3FQVuInc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywhtorn2ybkTuytHMRvZLxDCiCFVeMZHxQQN6cuiGZVjK9D5+3/
	MevRDg353MSVieq6o2ZAKAhbgDYD+udpbQwSOzNUoMvHw6LL2CJgTAJk4if9Kkc=
X-Google-Smtp-Source: AGHT+IFOkNi5En1U6atzM/outL/IcTJ5jnm+OY7uZvi8WoE+fRnOsRoNmau22JwZlSN5pOufV3D+eQ==
X-Received: by 2002:a05:6a00:8584:b0:717:9296:b45f with SMTP id d2e1a72fcca58-71916e47608mr4240873b3a.8.1726068589407;
        Wed, 11 Sep 2024 08:29:49 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::9633? ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71908fc8253sm3115128b3a.37.2024.09.11.08.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 08:29:48 -0700 (PDT)
Message-ID: <4a965b71-0c58-4e55-a78b-7df8195f495c@linaro.org>
Date: Wed, 11 Sep 2024 08:29:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/39] hw/pci: replace assert(false) with
 g_assert_not_reached()
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
 WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
 Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>,
 Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov
 <imammedo@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, Fam Zheng
 <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Jason Wang <jasowang@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-20-pierrick.bouvier@linaro.org>
 <3a7fc1f2-1468-46a8-9075-7b1bf1bd6149@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <3a7fc1f2-1468-46a8-9075-7b1bf1bd6149@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8xMC8yNCAyMjo1MCwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IEhp
IFBpZXJyaWNrLA0KPiANCj4gT24gMTEvOS8yNCAwMDoxNSwgUGllcnJpY2sgQm91dmllciB3
cm90ZToNCj4+IFNpZ25lZC1vZmYtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJv
dXZpZXJAbGluYXJvLm9yZz4NCj4+IC0tLQ0KPj4gICAgaHcvcGNpL3BjaS1zdHViLmMgfCA0
ICsrLS0NCj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2h3L3BjaS9wY2ktc3R1Yi5jIGIvaHcvcGNp
L3BjaS1zdHViLmMNCj4+IGluZGV4IGYwNTA4NjgyZDJiLi5jNjk1MGUyMWJkNCAxMDA2NDQN
Cj4+IC0tLSBhL2h3L3BjaS9wY2ktc3R1Yi5jDQo+PiArKysgYi9ody9wY2kvcGNpLXN0dWIu
Yw0KPj4gQEAgLTQ2LDEzICs0NiwxMyBAQCB2b2lkIGhtcF9wY2llX2Flcl9pbmplY3RfZXJy
b3IoTW9uaXRvciAqbW9uLCBjb25zdCBRRGljdCAqcWRpY3QpDQo+PiAgICAvKiBrdm0tYWxs
IHdhbnRzIHRoaXMgKi8NCj4+ICAgIE1TSU1lc3NhZ2UgcGNpX2dldF9tc2lfbWVzc2FnZShQ
Q0lEZXZpY2UgKmRldiwgaW50IHZlY3RvcikNCj4+ICAgIHsNCj4+IC0gICAgZ19hc3NlcnQo
ZmFsc2UpOw0KPj4gKyAgICBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpOw0KPj4gICAgICAgIHJl
dHVybiAoTVNJTWVzc2FnZSl7fTsNCj4gDQo+IFRoZSB0YWlsIG9mIHRoaXMgc2VyaWVzIHJl
bW92ZSB0aGUgdW5yZWFjaGFibGUgJ2JyZWFrJyBsaW5lcy4NCj4gV2h5ICdyZXR1cm4nIGxp
bmVzIGFyZW4ndCBwcm9ibGVtYXRpYz8gSXMgdGhhdCBhIEdDQyBUU2FuIGJ1Zz8NCj4gDQoN
Ckl0J3MgcmVsYXRlZCB0byBob3cgY29udHJvbCBmbG93IGFuYWx5c2lzIHdvcmtzLCBidXQg
SSBkb24ndCBoYXZlIGEgDQpkZWVwZXIgYW5zd2VyLiBJIHJlcG9ydGVkIHRoZSBpc3N1ZSB3
aXRoICdicmVhaycgZm9yIGdjYyBhbmQgdGhlIHNhbWUgDQpidWcgd2FzIGNyZWF0ZWQgc2V2
ZXJhbCB5ZWFycyBhZ28sIHNvIGl0IHdhcyBqdXN0IG1hcmtlZCBhcyBkdXBsaWNhdGUuDQoN
CkknbGwgY2xlYW4gdGhlIGV4dHJhIHJldHVybiB3aXRoIGhhdmUgdGhvdWdoLCBhcyBwYXJ0
IG9mIHYyLg0KDQo+PiAgICB9DQo+PiAgICANCj4+ICAgIHVpbnQxNl90IHBjaV9yZXF1ZXN0
ZXJfaWQoUENJRGV2aWNlICpkZXYpDQo+PiAgICB7DQo+PiAtICAgIGdfYXNzZXJ0KGZhbHNl
KTsNCj4+ICsgICAgZ19hc3NlcnRfbm90X3JlYWNoZWQoKTsNCj4+ICAgICAgICByZXR1cm4g
MDsNCj4+ICAgIH0NCj4+ICAgIA0KPiANCg==

