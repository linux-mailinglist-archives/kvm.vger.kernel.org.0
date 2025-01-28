Return-Path: <kvm+bounces-36809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A472A21422
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 23:27:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BDAA1884F7A
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 22:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8525E1DF74F;
	Tue, 28 Jan 2025 22:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="suRb04e7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E01219C566
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 22:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738103234; cv=none; b=JhCvXas3bNJsyKAdMwP3BgJuWDTG8PmTRi1SD2sIWWLz/FcSxtfr7vNrJZwxySN4lF1w85Gv+QLn9NVgKfjS8nRbP34sRM0gzYE+06XT7VcXpwGij7sxzL2ppPPBIeSO/deM3TuBzaeGm+jHnSckGHvGmLYyztUxutFOndc2AA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738103234; c=relaxed/simple;
	bh=1oPsq/wPc1Em+Hg0p1lVXpPB57NYp/vl2OLeJ/UDojs=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Kv4DNIRHcFwccm62s4x8Cb9gYxOOU8p8vy3X0DcztoAeY3t42lHw9ISidqY5Nuwq/7op9yohRy/qFwck84R8XezgjThoofOBpyWpWP/6cKTsexYnKKoDbN0weQ803fJmxr3E7h3EvWDR6GKKB+NSuGGdyNlOqBunkA7NC4L+mcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=suRb04e7; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-2a01cedda36so5238427fac.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738103232; x=1738708032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1oPsq/wPc1Em+Hg0p1lVXpPB57NYp/vl2OLeJ/UDojs=;
        b=suRb04e7SfXF8u8MOYFvubsCnUNrS+V1PPdrz1SnFhVkuOlJdbD4l5lNjia4diFrMl
         s8jnXU2uSBrTvccksY1xwZRK2jh1+qY4i+/qJRhRJcRaMrklfljbDHF4DE0CCsglKoyJ
         129x44pGA3OfIzllSFYnAp533BO9c5Ltnfrx7K+QcjnXq+bAAzX+B7na69uE9gXrH/ME
         oXVMiS3gyvzPk/zDBOpYZby/XHTJW8b5HP2aK1m/ORxk4wXgo/l7YAsSSIRea70TVecL
         IGcE2ksUoMLC3HzrW+rycwy+9dFhy2USdun3WwN113WdCIjl3z1ubn9DW3PJ3Yb9kWME
         qcMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738103232; x=1738708032;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1oPsq/wPc1Em+Hg0p1lVXpPB57NYp/vl2OLeJ/UDojs=;
        b=Vnzt3lfyi1+XfJcnajmEkxCHjhHKqUuHHHBpqWfhjhRSlUqBKuYWahQCjbool1l3BV
         mxqbT+z9tLPNlbK5cdgqS+kLm9A9xHCJPIOECKQQqkBP7G8mPJUM0xdJaY9zPKfApZBz
         wpubSA6d95J8ut6AtvLiSzDq4ieXy+yEnhE99aIx/04DdoJfM77BfV+c6DnU5KsVS7li
         MXgcjzHnid5GbvjoUnNKLJlhZ28ub+sJUQLGOawupBSQ2g+PgDDN5v3fLDsmHJpMBkKm
         M9u5oiZxUxT3MStfhhrX1avfwHKyXAkCT3XKPL2qa18+NXsSR5lMdUc+8vpYHy4dnmu3
         KEEg==
X-Gm-Message-State: AOJu0YxMOFmzZW6n7niOFyVHr11y+dXNFOQgLICfX9kkt94TMOCmSGrI
	90mF0Ugc2iIeGXPNRhbUAv+rDh/7yL5wKYnvm30FdZ62trT4ebEYXhWmye0ejcP3wlhzYujGk5d
	IiGU5kv3R+GZUdyCfhjIv7A==
X-Google-Smtp-Source: AGHT+IFeAG2C9xR8f1M0hgf6V1daJ+fxDJUQydwjRBaY2ElBo17h0wGY5yg/cvc7a2DwDoaMiKoVVrkpEHs3u1ntTw==
X-Received: from oabpn27.prod.google.com ([2002:a05:6870:4d1b:b0:296:e327:5292])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:46a1:b0:29e:24c7:284f with SMTP id 586e51a60fabf-2b32f1b5a9dmr628806fac.15.1738103232354;
 Tue, 28 Jan 2025 14:27:12 -0800 (PST)
Date: Tue, 28 Jan 2025 22:27:11 +0000
In-Reply-To: <CAL_JsqLa9KmYjkVBpxwkQXfQyj53=dgj_9rijca5JGem46qZLg@mail.gmail.com>
 (message from Rob Herring on Tue, 28 Jan 2025 09:25:25 -0600)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt8qqu377k.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH 1/4] perf: arm_pmuv3: Introduce module param to
 partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: Rob Herring <robh@kernel.org>
Cc: kvm@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	pbonzini@redhat.com, shuah@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64

SGV5IFJvYiwgdGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KDQpSb2IgSGVycmluZyA8cm9iaEBrZXJu
ZWwub3JnPiB3cml0ZXM6DQoNCj4gT24gTW9uLCBKYW4gMjcsIDIwMjUgYXQgNDoyNuKAr1BNIENv
bHRvbiBMZXdpcyA8Y29sdG9ubGV3aXNAZ29vZ2xlLmNvbT4gIA0KPiB3cm90ZToNCj4+IEBAIC0x
MjE1LDEwICsxMjQzLDE5IEBAIHN0YXRpYyB2b2lkIF9fYXJtdjhwbXVfcHJvYmVfcG11KHZvaWQg
KmluZm8pDQoNCj4+ICAgICAgICAgIGNwdV9wbXUtPnBtdXZlciA9IHBtdXZlcjsNCj4+ICAgICAg
ICAgIHByb2JlLT5wcmVzZW50ID0gdHJ1ZTsNCj4+ICsgICAgICAgcG1jcl9uID0gRklFTERfR0VU
KEFSTVY4X1BNVV9QTUNSX04sIGFybXY4cG11X3BtY3JfcmVhZCgpKTsNCg0KPj4gICAgICAgICAg
LyogUmVhZCB0aGUgbmIgb2YgQ05UeCBjb3VudGVycyBzdXBwb3J0ZWQgZnJvbSBQTU5DICovDQo+
PiAtICAgICAgIGJpdG1hcF9zZXQoY3B1X3BtdS0+Y250cl9tYXNrLA0KPj4gLSAgICAgICAgICAg
ICAgICAgIDAsIEZJRUxEX0dFVChBUk1WOF9QTVVfUE1DUl9OLCBhcm12OHBtdV9wbWNyX3JlYWQo
KSkpOw0KPj4gKyAgICAgICBiaXRtYXBfc2V0KGNwdV9wbXUtPmNudHJfbWFzaywgMCwgcG1jcl9u
KTsNCj4+ICsNCj4+ICsgICAgICAgaWYgKHJlc2VydmVkX2d1ZXN0X2NvdW50ZXJzID4gMCAmJiBy
ZXNlcnZlZF9ndWVzdF9jb3VudGVycyA8ICANCj4+IHBtY3Jfbikgew0KPj4gKyAgICAgICAgICAg
ICAgIGNwdV9wbXUtPmhwbW4gPSByZXNlcnZlZF9ndWVzdF9jb3VudGVyczsNCj4+ICsgICAgICAg
ICAgICAgICBjcHVfcG11LT5wYXJ0aXRpb25lZCA9IHRydWU7DQoNCj4gWW91J3JlIHN0b3Jpbmcg
dGhlIHNhbWUgaW5mb3JtYXRpb24gMyB0aW1lcy4gJ3BhcnRpdGlvbmVkJyBpcyBqdXN0DQo+ICdy
ZXNlcnZlZF9ndWVzdF9jb3VudGVycyAhPSAwJyBvciAnY3B1X3BtdS0+aHBtbiAhPSBwbWNyX24n
Lg0KDQpZZXMsIGJlY2F1c2UgY29kZSBvdXRzaWRlIHRoaXMgbW9kdWxlIHRoYXQgaXNuJ3QgYWxy
ZWFkeSByZWFkaW5nIFBNQ1IuTg0Kd2lsbCBuZWVkIHRvIGtub3cgdGhlIHJlc3VsdCBvZiB0aGF0
IGNvbXBhcmlvbi4NCg0KPj4gKyAgICAgICB9IGVsc2Ugew0KPj4gKyAgICAgICAgICAgICAgIHJl
c2VydmVkX2d1ZXN0X2NvdW50ZXJzID0gMDsNCj4+ICsgICAgICAgICAgICAgICBjcHVfcG11LT5o
cG1uID0gcG1jcl9uOw0KPj4gKyAgICAgICAgICAgICAgIGNwdV9wbXUtPnBhcnRpdGlvbmVkID0g
ZmFsc2U7DQo+PiArICAgICAgIH0NCg0KPj4gICAgICAgICAgLyogQWRkIHRoZSBDUFUgY3ljbGVz
IGNvdW50ZXIgKi8NCj4+ICAgICAgICAgIHNldF9iaXQoQVJNVjhfUE1VX0NZQ0xFX0lEWCwgY3B1
X3BtdS0+Y250cl9tYXNrKTsNCj4+IEBAIC0xNTE2LDMgKzE1NTMsNSBAQCB2b2lkIGFyY2hfcGVy
Zl91cGRhdGVfdXNlcnBhZ2Uoc3RydWN0IHBlcmZfZXZlbnQgIA0KPj4gKmV2ZW50LA0KPj4gICAg
ICAgICAgdXNlcnBnLT5jYXBfdXNlcl90aW1lX3plcm8gPSAxOw0KPj4gICAgICAgICAgdXNlcnBn
LT5jYXBfdXNlcl90aW1lX3Nob3J0ID0gMTsNCj4+ICAgfQ0KPj4gKw0KPj4gK21vZHVsZV9wYXJh
bShyZXNlcnZlZF9ndWVzdF9jb3VudGVycywgYnl0ZSwgMCk7DQoNCj4gTW9kdWxlIHBhcmFtcyBh
cmUgZ2VuZXJhbGx5IGRpc2NvdXJhZ2VkLiBTaW5jZSB0aGlzIGRyaXZlciBjYW4ndCBiZSBhDQo+
IG1vZHVsZSwgdGhpcyBpcyBhIGJvb3QgdGltZSBvbmx5IG9wdGlvbi4gVGhlcmUncyBsaXR0bGUg
cmVhc29uIHRoaXMNCj4gY2FuJ3QgYmUgYSBzeXNmcyBzZXR0aW5nLiBUaGVyZSdzIHNvbWUgY29t
cGxleGl0eSBpbiBjaGFuZ2luZyB0aGlzDQo+IHdoZW4gY291bnRlcnMgYXJlIGluIHVzZSAoanVz
dCByZWplY3QgdGhlIGNoYW5nZSkgYW5kIHdoZW4gd2UgaGF2ZQ0KPiBhc3ltbWV0cmljIFBNVXMu
IEFsdGVybmF0aXZlbHksIGl0IGNvdWxkIGJlIGEgc3lzY3RsIGxpa2UgdXNlciBhY2Nlc3MuDQoN
Ckkgc2VlIHdoYXQgeW91IG1lYW4uIEknbSBub3QgZGVhbGluZyB3aXRoIHRob3NlIGNvbXBsZXhp
dGllcyB5ZXQuIFRoYXQncw0Kd2h5IHRoaXMgaXMgYW4gUkZDLg0KDQo+IFJvYg0K

