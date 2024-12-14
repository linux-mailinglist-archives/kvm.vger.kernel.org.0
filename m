Return-Path: <kvm+bounces-33788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF329F1B4A
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41A1E16B181
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 00:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4417BE4A;
	Sat, 14 Dec 2024 00:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gL8yWSHN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B0B8F58
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 00:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734135519; cv=none; b=dffoShXWufF4Y3dTGF/3ap2UgLhtHLzwFGq3SwEpArTf37l4eVXh02+uE7Et9ch03zq9IWQFKAfjbkAT9ZY5u7T9lZ808WVCdidAnmoWhi2rBRP/NTP7rt8GoO5OOjylOFJiNweqKqOtQeqxyd1CC9xaNelX7EgVGSFva9C9Uro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734135519; c=relaxed/simple;
	bh=lApcg+XXZww9WwvnD0AMKer2n8WL8oN6MXtt3baYYwk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ePCkLbTwx3ORwuKjoA5/9rUsIVIdUZw1xrfO9cAFjBRvdrVXKKD//Vj0W0XI/fdiP0BgZzvo0CI/kRQUYM+aLd9E19k+7dRepxBfUD1LDDqb3b8hKfnLmoV3ZBln/MeVhPa9/uKjaovlqjki+ySFyRd8IgNiLhWCMn9ocdPcJqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gL8yWSHN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734135516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BGDfSsoL/iHf6CkmxjfloR3zp5vabdt6vbA+uv50OxE=;
	b=gL8yWSHNeHxMdtG3HySVBUWgPlBii0QFqWmIzQbzy2D7XPJA1ZY7ThBf7BtgC/28OAmA+L
	YsZVG6sPeVcBQwtKMjwIYKAEc6g8VEq5hyppPHGFLAqv+vO1E739OaukvSUKgWWVjtO63U
	14eaHxqIC7AUqZCNdd4xf1z3iAqdY2I=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-6l-eGyH8OHW3pPVL7aXG9w-1; Fri, 13 Dec 2024 19:18:35 -0500
X-MC-Unique: 6l-eGyH8OHW3pPVL7aXG9w-1
X-Mimecast-MFC-AGG-ID: 6l-eGyH8OHW3pPVL7aXG9w
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-844e344b0b5so169382439f.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:18:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734135514; x=1734740314;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BGDfSsoL/iHf6CkmxjfloR3zp5vabdt6vbA+uv50OxE=;
        b=wW+xyYJw4da7FnQwEiqvMuXe1Qwb/53qbWKt2be9KarEoD08gWjhIvw7Se3k7eV1lk
         f8WWAGvmG0mSUv5KRpN/Cfk9xIBUkYoqJ8PAthhWsN0uVk3+ThbTFMS1eCG1CipR5rDT
         thUHx2jvxGtwHWvRI8rDdV8LQNOzVk1ikFhDKYqwYTHQEd4ePAQs0xWbt1TahHofLluO
         U6pcHlNX8IVr620YqcG41frl2pgDq6VKno3UrhCQC6w9ytGV+DQK8DqJnovWB6WU3C9P
         VkY4FPnYZ5xTHsihuOwRb3DeaeGasYQPrLzOSzlSKRVE3JhjUC++ljgJmybDCbh+RBGd
         OIJg==
X-Gm-Message-State: AOJu0YzdSbCOl6xPL538ny9a+XhDQ3kGFYTRBK7k9tSYaFVMOkXTifCl
	zJlfzdDfT9ErGwI4MVZlruLXBojJ+umpFkDo7gxEUQ/p5bMzXJzas2zTA7vAkLyxiZ8kcgeTsOm
	mdAYCVmyCXnFGsWKHM2Z3QKhi6G7Eeg0gW0u3c6Cah7sDFW7s98b6FVOZWGEed8fyNsNxNXCj9W
	fHND10m27Y+jznaOa/jwfzyp7h3Of2UzzWKQ==
X-Gm-Gg: ASbGncvoTw4nAxEju1ZF7ym0LjbojaND47WJlfk8vFpPVpW1AHivaQ5P1Erp34Ifz1k
	gcqwJSqvhZjOtMVl+jkkTEohTY2WcdMz8C6KYMnFKpRasmXSm1A0iI/dP09LMQMTA4wNsidx0Yz
	gTD5zGM4I4W6i83Vd82q6v3dmy10mDJ50luCVdhv5fEdAnD8FJtpZo1n91bRUs4gloeBuV2RokK
	2Z+TnizBkZU8wyTLwnI4lg+f5ABFsFi04U50/Nn1r8XDKdq4ocaoF+l
X-Received: by 2002:a05:6602:6b8b:b0:83e:5860:5189 with SMTP id ca18e2360f4ac-844e88a1dd9mr499458439f.10.1734135514597;
        Fri, 13 Dec 2024 16:18:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1UnjiQm2T6wIp4WnMim9T3FpcGrTCc/ZS1z15n/iRnc56AFJSGhajOtvulMhtu2my8yUzvg==
X-Received: by 2002:a05:6602:6b8b:b0:83e:5860:5189 with SMTP id ca18e2360f4ac-844e88a1dd9mr499456239f.10.1734135514186;
        Fri, 13 Dec 2024 16:18:34 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e0f3ea0asm121930173.79.2024.12.13.16.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 16:18:33 -0800 (PST)
Message-ID: <af6a4b2a4ff81818e4c06a985d96423971f4101f.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] pmu_lbr: drop check for MSR_LBR_TOS != 0
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Date: Fri, 13 Dec 2024 19:18:32 -0500
In-Reply-To: <e8aff39851876ffd3a555dea6bd8157833c2a336.camel@redhat.com>
References: <20241002235658.215903-1-mlevitsk@redhat.com>
	 <3956ad6d2261105c479a68c55acc87bd94ab202d.camel@redhat.com>
	 <e8aff39851876ffd3a555dea6bd8157833c2a336.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-11-21 at 20:33 -0500, Maxim Levitsky wrote:
> On Sun, 2024-11-03 at 16:06 -0500, Maxim Levitsky wrote:
> > A very kind ping on this patch.
> > 
> > 
> > 
> > Best regards,
> > 
> >         Maxim Levitsky
> 
> Another very kind ping on this patch.


Any update?

Best regards,
	Maxim Levitsky

> 
> Best regards,
>         Maxim Levitsky
> 



