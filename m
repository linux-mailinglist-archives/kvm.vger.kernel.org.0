Return-Path: <kvm+bounces-20895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DCD9260D3
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 14:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17A651C20DA0
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 12:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E7417A5AF;
	Wed,  3 Jul 2024 12:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P7QCLfwU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DA1178CFA
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720010930; cv=none; b=WQ2E8RuI/bHxjeM7hvHDEvkvyBMakHS18qL0k61T1+oOd8zrvs85IMFRXh+UbZ9LeQ+I0C7t/n789oc0+d7ja7gJlz3hdx8iLlm85BdTBjYJSxEeB88JC/rCLQrfA+7SUQqNv3DHT17ENQEKP4/+LHnVIiLoxoATd5BPhc2UCDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720010930; c=relaxed/simple;
	bh=nOrLYdaQKWbCBzur09331cdOZ260WekYtYvlyXlVvNg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KtkYNO96xqgA90lwrONVuiDPqIyJLP/ccn/hTNu1PV7CYkj73JQZPnTbnO7wPIghopDkJ5T4igkRQnFCaq/d8C6qj9EkFao9GFOj+3CJi6avUik1P1zqEg3ky6SGtcOmpevSjpqmZsLT10QNVNdBEZXc65ofwh1Nx14mXTb/rPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P7QCLfwU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720010927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2MEP5KBKlMKx9T4CmY7WwoI0xWCk7Wv3Ry4wWTTbIMQ=;
	b=P7QCLfwUcz3mg2A5ElG0ooCZzvadMZYJQAY+KS5kE9t26MDPBMjQjMeIVsODzCMY0DCEJe
	Ep41J0lxy3oVja+gVxtNGpFAqxAWuEZ+B4IoZ6kbPZ0+Ce8G1w7kNVvkv7sURdc29q/d8S
	McbqP4YFFDZhyIzrpg868ivJMZwIMfI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-O8VzTocHNsyewNKIF9r0bw-1; Wed, 03 Jul 2024 08:48:46 -0400
X-MC-Unique: O8VzTocHNsyewNKIF9r0bw-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ec62b1fb18so56359461fa.3
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2024 05:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720010924; x=1720615724;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2MEP5KBKlMKx9T4CmY7WwoI0xWCk7Wv3Ry4wWTTbIMQ=;
        b=TH93baPlfUcNxbYdZENGNJ2U7rQOrM8bg20OTh0QS6n61IkHGwlMWt4grRgY/UBmvG
         CIuFw3OP/Pw1zNFcItL7hRUNrWfmYG0AtLzFrQ6WBrflFRlYRA7U3YUo4PB66K/9hTf0
         oaFuwDHayH9UQY6PWkCJm8equwftLXMYUviaHSa82ymCHRypWxq8R87LEP4xqANjmcuN
         z6gykU9kJB6BC1GLvAoio7VQbKI1Il7rpO/0591yI0GcsDToY+CXiAYIknkfPhGoG25b
         D9ngBgVD64N6TjnkEL72QHh6xQe3OfxRNvF6Evnhk+zoT3qEnrPi6Sfr573KKiKkPCeP
         OOFA==
X-Forwarded-Encrypted: i=1; AJvYcCUBVrcnOgwgOGq+goGSvaigeRvwTAZvFyF7H4wlX99RGnbgM4XD1RYQarcGYD0trY8LXozSWB6y5gB9TAOKJcoVIQhF
X-Gm-Message-State: AOJu0Yz/6U7d3jxqauBEce1eBtLCGu2NWT1UzfUNzvNgUJVtJnG6n/ev
	vLsirpRWs8nxRAtrrqRx05Mb8vJS31jGTi5B7glqnG8TQacza2K+9thJI0WcA8G8LReTbeZS/mI
	bsHOL5GcU2Os4rMVqkz7S+GdQyXFP//vUJJx6uzxloxPU4kyO/w==
X-Received: by 2002:a2e:a7c2:0:b0:2ee:45f3:1d13 with SMTP id 38308e7fff4ca-2ee5e704e51mr78434031fa.47.1720010924682;
        Wed, 03 Jul 2024 05:48:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFP5TqWKFAuIwTILcZtQfViw3L54aF8RKuLImctjrV+bIlLQQRnHKZJF7c8esvbcZCiclXd1w==
X-Received: by 2002:a2e:a7c2:0:b0:2ee:45f3:1d13 with SMTP id 38308e7fff4ca-2ee5e704e51mr78433691fa.47.1720010924256;
        Wed, 03 Jul 2024 05:48:44 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a0d8cd8sm15773145f8f.27.2024.07.03.05.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 05:48:43 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, seanjc@google.com
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org,
 nsaenz@amazon.com, linux-trace-kernel@vger.kernel.org, graf@amazon.de,
 dwmw2@infradead.org, pdurrant@amazon.co.uk, mlevitsk@redhat.com,
 jgowans@amazon.com, corbet@lwn.net, decui@microsoft.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, amoorthy@google.com
Subject: Re: [PATCH 00/18] Introducing Core Building Blocks for Hyper-V VSM
 Emulation
In-Reply-To: <D2FTASL4CXLN.32GYJ8QZH4OCR@amazon.com>
References: <20240609154945.55332-1-nsaenz@amazon.com>
 <D2FTASL4CXLN.32GYJ8QZH4OCR@amazon.com>
Date: Wed, 03 Jul 2024 14:48:42 +0200
Message-ID: <87ikxm63px.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Nicolas Saenz Julienne <nsaenz@amazon.com> writes:

> Hi Sean,
>
> On Sun Jun 9, 2024 at 3:49 PM UTC, Nicolas Saenz Julienne wrote:
>> This series introduces core KVM functionality necessary to emulate Hyper-V's
>> Virtual Secure Mode in a Virtual Machine Monitor (VMM).
>
> Just wanted to make sure the series is in your radar.
>

Not Sean here but I was planning to take a look at least at Hyper-V
parts of it next week.

-- 
Vitaly


