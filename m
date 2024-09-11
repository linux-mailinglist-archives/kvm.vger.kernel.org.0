Return-Path: <kvm+bounces-26548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BFA975739
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A8871C21C91
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0506F1AC8A2;
	Wed, 11 Sep 2024 15:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CZKrXpkz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51E41AC458
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726068853; cv=none; b=SDSO2y91YOSBOi2TdteD+bkb3aWLk0gyxcTiwgDQd6oGjE4+88Usq2UZweVStLWW6CpES7hygDuVX0lGeOHnlZq/n6+qEPn7NE+p5I6XSTZdop9xBX9FGwu7T5Pu6s9ygqdecQDVvnUSwKFd7EUxfQpbyugm2qa2SX9RlL8pEEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726068853; c=relaxed/simple;
	bh=eA+709nEJaGWuuqo4euF6T+QcJULW+fZtN6qnIYUmcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A8clQmNK1U3SoAKlaXvgpsmGBB7VDS0e0RNZcZ8YVhLWX2wWL6AFu8SZYg9vPS4bvWxNCDYAA2xxLgJD5CKcG70ih3jRHqX81PBvZhxl5B/cs8/lU0M8d7/55T2y1XiGpYYzuaIsdjkPrjxPRWtzz+JzjP22qUYhkS+fbw+Xfg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CZKrXpkz; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-718d91eef2eso760007b3a.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726068851; x=1726673651; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eA+709nEJaGWuuqo4euF6T+QcJULW+fZtN6qnIYUmcY=;
        b=CZKrXpkzdJo74UImz5txF+UZ55gPeiDAV/0AVIkPhjk7emynUSZXFVSLjZdohLe7Wd
         uStNealuAvBMDYqgl1aO0bP2XcfoyUukZFK00s1M4qaqPAvGUqUTDk2i6MoGO+0qmuzK
         +7Me1NUjYZqhSVYVAgspU6DzXY8flpbEfu2X2L6pr1ornug7Dk9GoUoMd1Yc57Vupvty
         pFJMn9dh4NvbclVZHAWgonYE01i7lZ4VcEk0oPw35zJrkgrbjJrQjdKEYFSJzQB83mS0
         BNbp6O+RK9ah20HFQ1Eyk9guaAX7pEwlbpfO5ATf72O0M0Y4eehKEb051NKERMnM+x9y
         qEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726068851; x=1726673651;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eA+709nEJaGWuuqo4euF6T+QcJULW+fZtN6qnIYUmcY=;
        b=WkVuTc6u7PmTsZtv0FgruN4iK72E1eUNJYHnPCuSFW8fOyN9b4H5VO2uZayioZRJv2
         jVWzSdzoAYYyCMrpjspH9ibioDk9a1FWUfsrEZmx0PMnLSBje1H6LYcZHQpIK0GVGVBe
         BDgvqi6X6MUSGUyFMi5fR7e3n1XgktNKB8LE1QWJRh8Tyo9p17o5KtF6P8qa6QHEVYk6
         XwEVaHh49dLuNPDAb5Nhrq8n5r0Fkh56RxuJq4TB8eGnPgkmRzfOQhONQyVgUTWNTQTV
         4SHp+2UwggJNPnaMugUDtkxc2G1z7HgQf1IJrwlNm/Aoc+zIXXgf4Hgy6uzRwxTmQnaW
         GubA==
X-Forwarded-Encrypted: i=1; AJvYcCXC37Wd1SdPoA5x0rSBOD1HLtLuOv3cO/ISVf993PC32qMhVZpJ/bcOdS7WQAoUJ4CWuK0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0brHCFwUS7bYpTsKumv4zPVmFEF6rHn0WCyrfqC554Tl4vs7P
	bN4YtmipI5wBwW8eqptSEHO9jrOjl81h9SVKQJpbyZBqJ21F8Qa/1oG6MOBjbSE=
X-Google-Smtp-Source: AGHT+IFppOMwSoql1QLOJ+22ancIMUpNoJdbhH59Q3aBWEWte2FEb8Yn5UIVH+O8hp1Oz/TnqhIL4A==
X-Received: by 2002:a05:6a00:2f9b:b0:718:d4e4:a10a with SMTP id d2e1a72fcca58-71907ea941emr10052359b3a.4.1726068850740;
        Wed, 11 Sep 2024 08:34:10 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::9633? ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm3222002b3a.93.2024.09.11.08.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 08:34:10 -0700 (PDT)
Message-ID: <b58a2188-3652-4a7a-af10-c7f32b2c6f62@linaro.org>
Date: Wed, 11 Sep 2024 08:34:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/39] Use g_assert_not_reached instead of
 (g_)assert(0,false)
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
 <cd6c5970-9a1c-4d58-b8af-483909c3c0ca@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <cd6c5970-9a1c-4d58-b8af-483909c3c0ca@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8xMS8yNCAwMTozOSwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDExLzkvMjQgMDA6MTUsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+IA0KPj4gUGllcnJp
Y2sgQm91dmllciAoMzkpOg0KPj4gICAgIGRvY3Mvc3BpbjogcmVwbGFjZSBhc3NlcnQoMCkg
d2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICAgaHcvYWNwaTogcmVwbGFjZSBh
c3NlcnQoMCkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICAgaHcvYXJtOiBy
ZXBsYWNlIGFzc2VydCgwKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgICBo
dy9jaGFyOiByZXBsYWNlIGFzc2VydCgwKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkN
Cj4+ICAgICBody9jb3JlOiByZXBsYWNlIGFzc2VydCgwKSB3aXRoIGdfYXNzZXJ0X25vdF9y
ZWFjaGVkKCkNCj4+ICAgICBody9uZXQ6IHJlcGxhY2UgYXNzZXJ0KDApIHdpdGggZ19hc3Nl
cnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgIGh3L3dhdGNoZG9nOiByZXBsYWNlIGFzc2VydCgw
KSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgICBtaWdyYXRpb246IHJlcGxh
Y2UgYXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgIHFvYmpl
Y3Q6IHJlcGxhY2UgYXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4g
ICAgIHN5c3RlbTogcmVwbGFjZSBhc3NlcnQoMCkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hl
ZCgpDQo+PiAgICAgdGFyZ2V0L3BwYzogcmVwbGFjZSBhc3NlcnQoMCkgd2l0aCBnX2Fzc2Vy
dF9ub3RfcmVhY2hlZCgpDQo+PiAgICAgdGVzdHMvcXRlc3Q6IHJlcGxhY2UgYXNzZXJ0KDAp
IHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgIHRlc3RzL3VuaXQ6IHJlcGxh
Y2UgYXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgIGluY2x1
ZGUvaHcvczM5MHg6IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3aXRoIGdfYXNzZXJ0X25vdF9y
ZWFjaGVkKCkNCj4+ICAgICBibG9jazogcmVwbGFjZSBhc3NlcnQoZmFsc2UpIHdpdGggZ19h
c3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgIGh3L2h5cGVydjogcmVwbGFjZSBhc3NlcnQo
ZmFsc2UpIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgIGh3L25ldDogcmVw
bGFjZSBhc3NlcnQoZmFsc2UpIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAg
IGh3L252bWU6IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFj
aGVkKCkNCj4+ICAgICBody9wY2k6IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3aXRoIGdfYXNz
ZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgICBody9wcGM6IHJlcGxhY2UgYXNzZXJ0KGZhbHNl
KSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgICBtaWdyYXRpb246IHJlcGxh
Y2UgYXNzZXJ0KGZhbHNlKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgICB0
YXJnZXQvaTM4Ni9rdm06IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3aXRoIGdfYXNzZXJ0X25v
dF9yZWFjaGVkKCkNCj4+ICAgICB0ZXN0cy9xdGVzdDogcmVwbGFjZSBhc3NlcnQoZmFsc2Up
IHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgIGFjY2VsL3RjZzogcmVtb3Zl
IGJyZWFrIGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgICBibG9jazogcmVt
b3ZlIGJyZWFrIGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgICBody9hY3Bp
OiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgIGh3
L2dwaW86IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAg
ICAgaHcvbWlzYzogcmVtb3ZlIGJyZWFrIGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkN
Cj4+ICAgICBody9uZXQ6IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hl
ZCgpDQo+PiAgICAgaHcvcGNpLWhvc3Q6IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9u
b3RfcmVhY2hlZCgpDQo+PiAgICAgaHcvc2NzaTogcmVtb3ZlIGJyZWFrIGFmdGVyIGdfYXNz
ZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgICBody90cG06IHJlbW92ZSBicmVhayBhZnRlciBn
X2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICAgdGFyZ2V0L2FybTogcmVtb3ZlIGJyZWFr
IGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgICB0YXJnZXQvcmlzY3Y6IHJl
bW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICAgdGVzdHMv
cXRlc3Q6IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAg
ICAgdWk6IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAg
ICAgZnB1OiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4g
ICAgIHRjZy9sb29uZ2FyY2g2NDogcmVtb3ZlIGJyZWFrIGFmdGVyIGdfYXNzZXJ0X25vdF9y
ZWFjaGVkKCkNCj4+ICAgICBzY3JpcHRzL2NoZWNrcGF0Y2gucGw6IGVtaXQgZXJyb3Igd2hl
biB1c2luZyBhc3NlcnQoZmFsc2UpDQo+IA0KPiBJJ20gcXVldWluZyByZXZpZXdlZCBwYXRj
aGVzIDQsNSw3LDEwLDI3LDI4LDMwLDM2IHNvIHlvdSBkb24ndA0KPiBoYXZlIHRvIGNhcnJ5
IHRoZW0gaW4gdjIuDQo+IA0KPiBSZWdhcmRzLA0KPiANCj4gUGhpbC4NCg0KSnVzdCBmb3Ig
dGhlIHNha2Ugb2Ygc2ltcGxpY2l0eSwgYW5kIHRvIG5vdCBtaXNzIGFueXRoaW5nIChvbiBt
eSBzaWRlKSwgDQpJJ2xsIGtlZXAgdGhvc2UgaW4gdjIuIFdoZW4gcmViYXNpbmcsIG9uY2Ug
bWVyZ2VkIG9uIG1hc3RlciwgdGhleSB3aWxsIA0KYmUgc2tpcHBlZCBhdXRvbWF0aWNhbGx5
Lg0KDQpUaGFua3MsDQpQaWVycmljaw0K

