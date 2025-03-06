Return-Path: <kvm+bounces-40282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B608A559F2
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:40:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DA25177DDA
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 22:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E129227CB21;
	Thu,  6 Mar 2025 22:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hCtkViQd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9EB1F4185
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 22:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741300831; cv=none; b=ksCIByB8Aga5JOo/mz7jS8qhKBameJfty4oPgCoA/7kMOaMBqnLqZGcxILZoGt3HgkkK90EF41fJbcSvtY74P0hC8pJXw7fh5giOa+svFApnHrzd3zSjhv6o1co0NE57C/wgW1vlURuViZk9D7ibFgfB6q9vjU/Dh+6YyC6++9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741300831; c=relaxed/simple;
	bh=5wgvyjqfSSFbzTIm6MSjQdiHQSjDlgIq0rnpnyaG52A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N96ePjHxSEaU4P2WNnaaphy0H+JkISg7bABlpMAei/O82Xirx7ovYLAuGyj1lLu+rGgzOuL/AZOl42EYUSqsnbeUZEapmCBJw2mss+eFpGgsxquwldgcDqAIE8+omwpFtdkySfJkymuC0DOh9jr3lhX5aHyKYWVca/QzUFR9k5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hCtkViQd; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22349bb8605so23801245ad.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 14:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741300829; x=1741905629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5wgvyjqfSSFbzTIm6MSjQdiHQSjDlgIq0rnpnyaG52A=;
        b=hCtkViQdf0VFUYc62Qn7XGygMO6+VLDMW7xmvi2wu3k7MAfwXAk+8fp9QqRXU4ySwG
         RPQwmHGCnHAces9r/8T7vp96ko2kN3b0tP+dZ4+0sl3ICqDu/cnFx59GqAPQBd6heJJi
         Q7I+F6rP4bSC6r1Cr1L4a/iocZtMQt1tMvch3x+UdDCDUCbb9AnGQt26R6QOLm3SQbXD
         qCG7+EVH0BMXoJmyk/NC5RwRCVojWWHmEtDFYxn7pfAWH9OHuuIi24A6R4lYGQmqYmMo
         VJfC3ZsW5h5yYwR05f0nxqUw7XXW/t+oIsRrJc0TTioxqMFwfzgI3B6QiUaqHsl3OlJT
         pMMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741300829; x=1741905629;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5wgvyjqfSSFbzTIm6MSjQdiHQSjDlgIq0rnpnyaG52A=;
        b=tu5O70WxQ7g5Kn+Y7dZRx8zhjkn9Sjcww7mZqAbhspCpcUe4ckepbC+R1Tj7TMeAx3
         d6w1fqSHtBs+EtixV9FXAvDqei06SLCN9T8NcwZXiA6gkRFWTeptuEXYz1tQoJSjwG4T
         fwJEES35m9+sgI/nw5srbRL7WsWzQBJs6wz9eyt0Lcrf7avmNBf+en08LX4Bf6dkpO84
         81EFnJJpR2zL7Ih5Bt4EOjh7rB+y5iQLnU7+IPCC+zQnfP8LQ7iqi2gNkOf9L7+Sl4x/
         i0ZiRQSBZuwqOcAa7yJR7PHCSS+KKFPlhhu7coXn4I8Kqu9Cbkqk3q+AxCBpplPwBoKI
         +d1A==
X-Forwarded-Encrypted: i=1; AJvYcCX9WXZ6eSQbVeWOuIphXL5WcQHEY0P7mMQeqGThr1ZXucakArKozua7rus7BFT0+qRbS2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFDmcgjK9eAEl8ZfT85z2bb7b45CY+VWts+VlODO7orTJ9h6mw
	x9nkxga9VNYAFaVh/nIJS9gNcENY39ZMjGu6Zi7XR3XOUqM/jykDd/ujaY+8FOU=
X-Gm-Gg: ASbGncs5wdlEgg5LStTOfrouFfwpjFIP3TQ2jarN+O1OIRLPqSrlICekAtGRTppZAuE
	+vhAfkr39JDbH5XdbdpaqjdElkfWzO367G0vD+bkj/oxrugYsRW5+itsUAxHsKJe5JnE7R1nKki
	lDLx0/cCjM12DMuKjClM4TUYNolkcBFR+hVAz6J8AjBUfTYHwd/an5GCdDBe6MmbDVGcqM1+w0t
	XR/wg+VWWWQ3bBhmVTUyxX1Jj0iid2gzaG8V+UMvL0G1bo8fQ2hclKotXQRKNubc4F7cMvtnNLa
	HuSH4/OuaBo0rGjBnFpL2kP4LYyFVxcpiUy4ktTxHqe+Di4xEWkyuJH1rQ==
X-Google-Smtp-Source: AGHT+IGmTJmzUvFzEPcruXwZyIQW6yWjOjJ8NYJviz1AlqgPMQI9qYaa3LUE5w2TJ0ZfNZOJTGEOog==
X-Received: by 2002:a17:902:f645:b0:223:4d5e:789d with SMTP id d9443c01a7336-2242889f262mr18156565ad.19.1741300829645;
        Thu, 06 Mar 2025 14:40:29 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109fefa6sm17755115ad.106.2025.03.06.14.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 14:40:29 -0800 (PST)
Message-ID: <18fd9ebb-dfe0-403f-994a-e542e890eb4e@linaro.org>
Date: Thu, 6 Mar 2025 14:40:28 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] hw/hyperv/hyperv.h: header cleanup
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, philmd@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 richard.henderson@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-3-pierrick.bouvier@linaro.org>
 <871pva4a5g.fsf@draig.linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <871pva4a5g.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy82LzI1IDA0OjI3LCBBbGV4IEJlbm7DqWUgd3JvdGU6DQo+IFBpZXJyaWNrIEJvdXZp
ZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4gd3JpdGVzOg0KPiANCj4+IFNpZ25l
ZC1vZmYtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9y
Zz4NCj4+IC0tLQ0KPj4gICBpbmNsdWRlL2h3L2h5cGVydi9oeXBlcnYuaCB8IDQgKysrLQ0K
Pj4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+
Pg0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvaHcvaHlwZXJ2L2h5cGVydi5oIGIvaW5jbHVk
ZS9ody9oeXBlcnYvaHlwZXJ2LmgNCj4+IGluZGV4IGQ3MTdiNGUxM2Q0Li5jNmY3MDM5NDQ3
ZiAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvaHcvaHlwZXJ2L2h5cGVydi5oDQo+PiArKysg
Yi9pbmNsdWRlL2h3L2h5cGVydi9oeXBlcnYuaA0KPj4gQEAgLTEwLDcgKzEwLDkgQEANCj4+
ICAgI2lmbmRlZiBIV19IWVBFUlZfSFlQRVJWX0gNCj4+ICAgI2RlZmluZSBIV19IWVBFUlZf
SFlQRVJWX0gNCj4+ICAgDQo+PiAtI2luY2x1ZGUgImNwdS1xb20uaCINCj4+ICsjaW5jbHVk
ZSAicWVtdS9vc2RlcC5oIg0KPiANCj4gV2Ugc2hvdWxkbid0IG5lZWQgdG8gaW5jbHVkZSBv
c2RlcC5oIGluIGhlYWRlcnMsIGluZGVlZCBzdHlsZSBzYXlzOg0KPiANCj4gICAgRG8gbm90
IGluY2x1ZGUgInFlbXUvb3NkZXAuaCIgZnJvbSBoZWFkZXIgZmlsZXMgc2luY2UgdGhlIC5j
IGZpbGUgd2lsbCBoYXZlDQo+ICAgIGFscmVhZHkgaW5jbHVkZWQgaXQuDQo+DQoNClN1cmUs
IEknbGwgcmVtb3ZlIGl0Lg0KDQo+PiArI2luY2x1ZGUgImV4ZWMvaHdhZGRyLmgiDQo+PiAr
I2luY2x1ZGUgImh3L2NvcmUvY3B1LmgiDQo+PiAgICNpbmNsdWRlICJody9oeXBlcnYvaHlw
ZXJ2LXByb3RvLmgiDQo+PiAgIA0KPj4gICB0eXBlZGVmIHN0cnVjdCBIdlNpbnRSb3V0ZSBI
dlNpbnRSb3V0ZTsNCj4gDQoNCg==

