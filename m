Return-Path: <kvm+bounces-40778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3950A5C5A1
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1015D7A359E
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F8725DD0A;
	Tue, 11 Mar 2025 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BJ0Gpdpw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24EB25E82D
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706215; cv=none; b=duHCvJjsIrofLlvKJ4fq/jKpHqzfgj2RaQJvu6V2ytTUSFu2LzHeqXx03DIbaQfgUjq5t1D+7Nx8aeY/VrZ8doSp48c3uyx3CI7R+o+Fs/fOZA9yV+3fqCMKBlDxMnFbbjfnUIbfI7hM/Qy7aLQYbBF9lhf5dNXDWR5V3jltLsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706215; c=relaxed/simple;
	bh=X8LOGG4uU8FOZpUEyBqgQ5KobC97qVpoXve38nvbWcU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l8Ygney6H8q3ONAP7ew1pxeIK3DPRyvblFv9bDGyplJ7VWfWAF3U6WyfoWeo9ffakpVfffkpFObf+c0s60oEVX2WWzVpwcCLdBcrBjopYabd0GWOKRwIjiwPLV4ULxlPOs5f78j9wHzBvUrIOYdL+cupTh38IGWvSVV4A0fbiX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BJ0Gpdpw; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223fd89d036so110449985ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741706213; x=1742311013; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X8LOGG4uU8FOZpUEyBqgQ5KobC97qVpoXve38nvbWcU=;
        b=BJ0Gpdpwx+xlnCGUUEib7QAXOxSZOlqlrE6kpV0g0H7isIyF7mQBq9/Xu+2n757Bvv
         eaGAB69PlV53jbUvk4MOH7tPi8lKZVirCN2syhIFvwO9xnUB6HfiCZg9mFvjdDFMjrCP
         7seytMCAR+8BUMHGkImfXMGymTazZv0B59CsUamvcG0YQ6C6dJk2M3COPkpee3Mwdmhv
         HiwstT6pHYwqKeii7b94O26KvRkqBmGQKhcB6xj8C+SFl8TpxWrSgDQV7q+y5O3HdqCi
         6Qn1YRulEyAabVtFhokh2dm6DFx44zX9wbIygMMjsjSvEcZJjPv9rJVZqJpIIyKmaNx9
         tfFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741706213; x=1742311013;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X8LOGG4uU8FOZpUEyBqgQ5KobC97qVpoXve38nvbWcU=;
        b=OyyvhiMAp+StPG3O9jRa3jO4YWUuYJjYkH/5Kgy0Oc5K3LYSAOoC9NY43cQ3XMWzx8
         wmn7+/iKJSTAUUh9Oe+g3KDEISxPLI4wlQ1ZRYQkVeIxggVGCf9d+mkQKtlHZRpPhIp4
         DNpiK59Urh5kCtxawkUqiX30WSjgXb/UCBLW3LJj8nuznc4IL6pOFY0BbXa8o7rHAqzO
         3mmkuV+UvTlDtMUtOzfhkVCcunjr7bo9F6x46Q5IA7v05eOlOMY/GqH3C6DkVkroOF2t
         PMfCX5xQ/ap8lNPipqiUa0/hFgQuQw0+KXEp5eSoPfiYZchm9nEbKVuYD9zjCtPfYWnV
         Xn3A==
X-Forwarded-Encrypted: i=1; AJvYcCUUO5ytzkBICvkq4WXzy+ZLx7WcEfRIO9k9nTCQLYMGTA/s6tsZxiH/gemxruBZfwbr6/w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxECqthJBizlbvoswdJvl/9aM3y/f6J1pNvRaRqfF6ZdMIviG4e
	n8QC96F2C3aT6ayKh8dBl2RcCalLCQxuAXNwxHEo81nnEjNOPDO8Qy7q7X2lt+0=
X-Gm-Gg: ASbGncukl+I6XlYtJIdpuzTJFDMx9dsmB/oG6KaWF3nS1uqNzRb68LTBxnxtccApQT9
	ueDcNH99UfeWorm2bQfndSOyMbcq9SabVDns2jiOVzHJS9kppefbJO/g6Bne/InPfzirHYHzBGN
	pj2e1Mqec+1SJIdE4O0sCQEIM3kOhrA2RZkYXWMHOR7If6axL67GU0Fl80gVx8kFyRKnVrejxoL
	C0k7WlaEW2mhOX9z6KAnFrw6gKdOVlovX9qqAKUXDCUpKK4oLwavBm2CIOH353TQbHA7uw+IQaQ
	66wuVPnA1NLWLT+JjEhRjSQo4w/FyK93RCs6qQGgGG+BFThhya4y6iw7xw==
X-Google-Smtp-Source: AGHT+IEfixA7L2fnS5UNE8FbDPTHCcGVSGrEqusGAVylfXrcSrSOLbWL24c8Jlqg7HqGHL0V+epMxw==
X-Received: by 2002:a17:903:230b:b0:224:f12:3746 with SMTP id d9443c01a7336-22428aaeb0amr227978355ad.30.1741706213011;
        Tue, 11 Mar 2025 08:16:53 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a68b89eesm9616262b3a.104.2025.03.11.08.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 08:16:52 -0700 (PDT)
Message-ID: <de156b56-4ed5-4b04-95d4-81fc2953491d@linaro.org>
Date: Tue, 11 Mar 2025 08:16:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/16] exec/ram_addr: call xen_hvm_modified_memory only
 if xen is enabled
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 xen-devel@lists.xenproject.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 qemu-riscv@nongnu.org, manos.pitsidianakis@linaro.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Anthony PERARD <anthony@xenproject.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
 <20250311040838.3937136-12-pierrick.bouvier@linaro.org>
 <2aa408e2-a412-4eb6-b589-1bc2f5ac145a@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <2aa408e2-a412-4eb6-b589-1bc2f5ac145a@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xMS8yNSAwMDoyOSwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDExLzMvMjUgMDU6MDgsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBSZXZpZXdlZC1i
eTogUmljaGFyZCBIZW5kZXJzb24gPHJpY2hhcmQuaGVuZGVyc29uQGxpbmFyby5vcmc+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxp
bmFyby5vcmc+DQo+IA0KPiBJIGRpZG4ndCBmb2xsb3cgdGhpcyBkaXJlY3Rpb24gYmVjYXVz
ZSBSaWNoYXJkIGhhZCBhIHByZWZlcmVuY2UNCj4gb24gcmVtb3ZpbmcgdW5uZWNlc3Nhcnkg
aW5saW5lZCBmdW5jdGlvbnM6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3FlbXUtZGV2
ZWwvOTE1MTIwNWEtMTNkMy00MDFlLWI0MDMtZjkxOTVjZGIxYTQ1QGxpbmFyby5vcmcvDQo+
IA0KDQpUaGUgcGF0Y2ggeW91IG1lbnRpb24gd2FzIG1vdmluZyBjb2RlLCB3aGljaCBjYW4g
YmUgYXJndWFibHkgZGlmZmVyZW50IA0KZnJvbSBzaW1wbHkgZWRpdGluZyBleGlzdGluZyBv
bmUuDQpUaGF0IHNhaWQsIGFuZCBldmVuIHRob3VnaCB0aGUgY29uY2VybiBpcyByZWFsLCBJ
IHdvdWxkIGFwcHJlY2lhdGUgdG8gDQprZWVwIHRoaXMgc2VyaWVzIGZvY3VzZWQgb24gYWNo
aWV2aW5nIHRoZSBnb2FsLCBhbmQgbm90IGRvaW5nIGEgcmVmYWN0b3IgDQpvZiB0aGUgaW52
b2x2ZWQgaGVhZGVycy4NCg0KPj4gLS0tDQo+PiAgICBpbmNsdWRlL2V4ZWMvcmFtX2FkZHIu
aCB8IDggKysrKysrLS0NCj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvZXhlYy9yYW1f
YWRkci5oIGIvaW5jbHVkZS9leGVjL3JhbV9hZGRyLmgNCj4+IGluZGV4IDdjMDExZmFkZDEx
Li4wOThmY2NiNTgzNSAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvZXhlYy9yYW1fYWRkci5o
DQo+PiArKysgYi9pbmNsdWRlL2V4ZWMvcmFtX2FkZHIuaA0KPj4gQEAgLTM0Miw3ICszNDIs
OSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgY3B1X3BoeXNpY2FsX21lbW9yeV9zZXRfZGlydHlf
cmFuZ2UocmFtX2FkZHJfdCBzdGFydCwNCj4+ICAgICAgICAgICAgfQ0KPj4gICAgICAgIH0N
Cj4+ICAgIA0KPj4gLSAgICB4ZW5faHZtX21vZGlmaWVkX21lbW9yeShzdGFydCwgbGVuZ3Ro
KTsNCj4+ICsgICAgaWYgKHhlbl9lbmFibGVkKCkpIHsNCj4+ICsgICAgICAgIHhlbl9odm1f
bW9kaWZpZWRfbWVtb3J5KHN0YXJ0LCBsZW5ndGgpOw0KPj4gKyAgICB9DQo+PiAgICB9DQo+
IA0KDQo=

