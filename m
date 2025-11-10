Return-Path: <kvm+bounces-62587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B760AC494CD
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 21:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E4403B2B7D
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 20:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27CCB2EF662;
	Mon, 10 Nov 2025 20:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hs6EgrmQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ENPZoCy0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E412F25F8
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 20:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762807500; cv=none; b=s9KkKhPSRRCIB4zEIpEYDdZoDDx/C/UUr7/QVMamkTkfD7GpkQB42hIdWR/P5L5TY61Uoq/E8hFmCqI2E7z00TmVIKEsNN8Ph9O/RvSRNSR9X1B6OLCja10UvzsSdAe1bjXTHdpN4oUx1G9GZamQhymJsGW4ygpjV6Yx2QVdRHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762807500; c=relaxed/simple;
	bh=0QmLAhB4Dr1WEPpk3887110fcGYJhxEIE8hNtWv5p9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UyJqtR0+J4bZtaQP/PMAy14rZX3/8JYBuMElnLdZw0inVv9nMqyPkaPRaLUeD1ziX1tf9Iwxb78ag/Bcbm+SsGAz4CFKaeP0kwGVjBTd7u2DSmYQaScNpytYSuxXNUM0YzaPVtTkqSo8YT8T0R82uq6E5YJardxxhDBTBhX8Y2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hs6EgrmQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ENPZoCy0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762807492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0QmLAhB4Dr1WEPpk3887110fcGYJhxEIE8hNtWv5p9w=;
	b=hs6EgrmQIDgnDTOH7X/W5iJLUuSMn956wLRjDslN9bsxZqROrb8sJdr4M4L9FeHVhMjMFC
	eUUnjGer0cyJtroCaon+WbUM4sPT/qj3awCpvtB2JR/IzB0wgsaDt5+g4cPfSwAmtNPkVz
	lKCDsEk/LNUL4TdgWoktVk53THTvGdQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-dvrcDgHhNsiaWmu2p5CElA-1; Mon, 10 Nov 2025 15:44:51 -0500
X-MC-Unique: dvrcDgHhNsiaWmu2p5CElA-1
X-Mimecast-MFC-AGG-ID: dvrcDgHhNsiaWmu2p5CElA_1762807490
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso588845e9.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 12:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762807490; x=1763412290; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0QmLAhB4Dr1WEPpk3887110fcGYJhxEIE8hNtWv5p9w=;
        b=ENPZoCy0Y5Ucx0OvtHBoir7oqkL46BKyCGz7Zxun3iFZX/mSB3M6LpZjJA57ajn9cC
         e2TfJS3KMPUTYeSyloLORAd4hz4RtbJdRynZQhOXuc0HMMcNZ1FgXayFx4dHe5lFpttT
         SFA8yl0HT1/at5uM7af+H5XO111q0G3WRV+TCi4bfRao2kv8Dhc67RowED1y8XGs3jae
         9oaUDq/AtmDcBmNlholvzzPGe/I+sq0Rhxacn0eccv0wCFxOl88i0QxB1CXEW2jVQ4Ol
         tw1GAs+Okn7W1fN4Yf05GfxoavGAqmAYSf3vrbkgcX/ZpBE7rIBUShcH9LG2w1hPNq5V
         V65Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762807490; x=1763412290;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QmLAhB4Dr1WEPpk3887110fcGYJhxEIE8hNtWv5p9w=;
        b=aKIiQLRORna292QPS/QuPaeYLUlNGWx1llKIrejr3E6T8NPMqB1YKEUpf1ZR+Cwy6O
         X31P21yAQ2YgQBtDudN6Z0qNjjs1kWhsj/F94ad0wyZALTZ0A3L71LgakXRqH8hnO+49
         yWyPozKwXk1RLJn5QO1om/OiDCRuMa8KTJV+eqirdr4KdnxIn18V1F6nW27+loMH/3bO
         zwI8bqb08qDG5v/gCfPFN5CMBjFuxcojHMiQToIms8z+Jc9s+RnP5S+36VZqWvOTi6r6
         vm2pcEbDly24tL1oDHgz5nyU0smw/NIp9G7ubKsk+TT0uQrsuk/ZjHdEKEXQ/rvy4xPO
         pn6g==
X-Forwarded-Encrypted: i=1; AJvYcCVngBkicmVFOM6pTOxH4mt7Hdo8ZWDSZoMj4sVL3QLZhiz3SIAZwEgILgpv62z2FXzfhfY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ+1+bhm1WqMumBeuAUAESduGIjTp5Pw2mfJR3KQDeyPSjXNJH
	8ASkdLgri/o7LS5oCEe6q/sSLQ0JzDGrdU2I21WW2LDZYHYjnpiYoCKWo67dr3E24pXGHkl1TQu
	3OcNlSqHCaxmU38Gu8XqaiLaJKWuyMOHP79VeAxpUWH6TUOccjHuT2EJNWiW+9KHCNgF50Y4a/W
	LgCgIEyDhnrfRctY6wiGKob0z1IbFr
X-Gm-Gg: ASbGnctQpzLr/W6ubk0idFXslif7sfxF9IA9CDI0iSH4vxJ3pXdBCfpIr0wOmi9STuU
	rmz6Gct1uZjGkc95qbm3FxqJt2NcP3UY7M+bANnAGFga54V1QFqDHwvE3ZZq4GakltuGshyuZ80
	kcVeiUL7dwUi4Bi1E67zvtTlkvdm+olzTMd96+7d/DS+un42kGvMMIZXLYsZNeUzaLrtUKuADcB
	vKhzf7sVfbhEKfB5S+URyrl96RnPGA33sm9peouUX6ox0pU+kFp5/XdQ6dQsQ==
X-Received: by 2002:a05:600c:705:b0:477:81d8:df8 with SMTP id 5b1f17b1804b1-47781d8110dmr569385e9.19.1762807490025;
        Mon, 10 Nov 2025 12:44:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxgmlnkD4pZaOUZoaHUEyi4FhNrg7OIYNzNltbzPAiHrzD/ABZ6T0/DHHvTLeLO5rSzr5b0t7kC6amnCZvfAo=
X-Received: by 2002:a05:600c:705:b0:477:81d8:df8 with SMTP id
 5b1f17b1804b1-47781d8110dmr569225e9.19.1762807489677; Mon, 10 Nov 2025
 12:44:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220424101557.134102-1-lei4.wang@intel.com> <20251110162900.354698-1-lrh2000@pku.edu.cn>
In-Reply-To: <20251110162900.354698-1-lrh2000@pku.edu.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 10 Nov 2025 21:44:36 +0100
X-Gm-Features: AWmQ_bmE9lW1YJSBbubQWZMySQSyLd1I6Mr0gyYvS3wFNwWQ6M81mIDCY6FrJwU
Message-ID: <CABgObfZc4FQa9sj=FK5Q-tQxr2yQ-9Ez69R5z=5_R0x5MS1d0A@mail.gmail.com>
Subject: Re: The current status of PKS virtualization
To: Ruihan Li <lrh2000@pku.edu.cn>
Cc: lei4.wang@intel.com, Sean Christopherson <seanjc@google.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, Jim Mattson <jmattson@google.com>, 
	Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Il lun 10 nov 2025, 17:32 Ruihan Li <lrh2000@pku.edu.cn> ha scritto:
>
> Hi,
>
> I'm sorry to bother you by replying to the email from years ago. I would like
> to learn about the current status of PKS virtualization.
>
> In short, I tried to rebase this patch series on the latest kernel. The result
> was a working kernel that supports PKS virtualization, which would be useful
> for my purposes. Would PKS virtualization be accepted even if the kernel itself
> does not use PKS?


Yes, I think it should.

Virtualized PKS does not depend on host PKS, because it uses an MSR
rather than XSAVE areas (which are harder to add to KVM without host
support).

> Fundamentally, I don't think this patch series
> has to be built on top of basic PKS support. But I am unsure whether there is a
> policy or convention that states virtualization support can only be added after
> basic support.

No, there is none. In fact, the only dependency of the original series
on host PKS was for functions to read/write the host PKRS MSR. Without
host PKS support it could be loaded with all-ones, or technically it
could even be left with the guest value. Since the host clears
CR4.PKS, the actual value won't matter.

> One problem is that if the Linux kernel does not use PKS, we will be unable to
> test PKS virtualization with a guest Linux kernel. However, given that we have
> KVM unit test infrastructure, I believe we can find a way to properly test PKS
> virtualization for its correctness?

I agree. Thanks!

Paolo

> I'd like to hear from you to know whether I understand things correctly. Thank
> you in advance for any feedback.
>
> Thanks,
> Ruihan Li
>


