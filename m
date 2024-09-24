Return-Path: <kvm+bounces-27368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62157984572
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 14:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D187BB215E0
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 12:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A1C1A4F36;
	Tue, 24 Sep 2024 12:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D/5xXDbf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1B63C099
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727179452; cv=none; b=np/ooVCYhOOdYfJKIuzDY0SVF2DmdGhc9+GQtWU3MdBxWkh6LKeX3Q+pr7fBYfxXaLMdh08od5RjI3WDU5uUaHtsQqYN0Qe3E3qX5VQxCaqoCdQbaWepVeJi+0fgcEPuB+/F71BAML8WIHcxXjZbMtza1+K9ffSwlp2THiM57Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727179452; c=relaxed/simple;
	bh=9f9x5TXFk5tfcu5KU6qvQo0J67xm4FI85mVdI9vp2hM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=s0efmcyCgi7gSJWvE/bj0bOXVvHp9sWWuNzCx0nLGktdPtAA2VCvWfUj17snDt9WrB5aqlVv7wq7GZ1LAtmO9t4Hk7bpP7uG8KEpqhlClLAgM/zX+anyFDBZTDRvuP6MesyF2+niEwIZ7MI7Fr25uoLZZAmje0cEGLHCmQFNvEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D/5xXDbf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727179450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eHPGJh8pMJuTB4PDpPJ+WO9iG6StJszjggfTKj8UGgM=;
	b=D/5xXDbfzPHS47PM4yIjijoiHRm8mG+6sDRep7MeJbEUiAtxoPESdSIQUZL/1yV/MIgzpZ
	rbL2Qy4QCaY+8om4ctbtmClwOu9vl42ggYVexlXmlQxJ9DKmIlLUKwlguAYs7g6NCwqERY
	fPKc1p+cG1Ha2nDf2XJMw4WcJPa8aio=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-YF9sCk_BMSGtjKi9VAsDyQ-1; Tue, 24 Sep 2024 08:04:09 -0400
X-MC-Unique: YF9sCk_BMSGtjKi9VAsDyQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42ca8037d9aso36477365e9.3
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 05:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727179448; x=1727784248;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eHPGJh8pMJuTB4PDpPJ+WO9iG6StJszjggfTKj8UGgM=;
        b=j40l/VaSyAJC+yAJ90kr4XAAgA7cYQ9wHKuxAnJ6+z1vOWdLHot6/Bhar4+iv4DhEu
         4vPvlrvC+jE6aJkDuO6tnvSt/IoJm48Hs4i/QUuIPLR8EpIUSoNHssWfPr3nTmH3ipS6
         RPftNB31ULYyR3PAxumI8onhzwKljadQ4BjuqPhkVgK4hh8JjrdSsyFDJrr+C11QYOeP
         ubdiZJlakowu/eaKKM1VLTuDh5wUgDLdDsdcpeuAMKjtq4kv50txWdRO14mEkNYS/rza
         otWh4OYNqkrB7+YE4f9zkF+di8w0tyUkWUd7OHUduVHGTJKhzfaBfplaQkwhrt+9PXE8
         J4mw==
X-Forwarded-Encrypted: i=1; AJvYcCWQu0uyWMhOQZtfhQxusiPpLHpoRdhojleGbIwdGyVjoIYJBF7jKzf7nG990zM9ENP3Chc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi9y/biK0NQi9hgTiTYLC2xDSd5ZKxUFuPNZ2dFDPuc2uRqtHg
	5mKpUSfq2vxu7ZjjaFYqYQ9LgSTNrnTQbRI1R1pzOq6OPHDeIQG7Ai2mk8NUYhx5W2kId+7zhEq
	xHPddU9CIlorV0pRi8KgBMxInREvFoRyvQXNvMs+ZQpekkNUJZA==
X-Received: by 2002:a05:600c:1d1b:b0:42c:c08e:c315 with SMTP id 5b1f17b1804b1-42e7ac1c0dfmr118482095e9.16.1727179447769;
        Tue, 24 Sep 2024 05:04:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkwZoPOrtVWNrW1vej31s8KufRZ6MDtbVw9BSFK1If0z5Nh7q3q42jva/uYFt4EqX+A1Ahtg==
X-Received: by 2002:a05:600c:1d1b:b0:42c:c08e:c315 with SMTP id 5b1f17b1804b1-42e7ac1c0dfmr118481815e9.16.1727179447301;
        Tue, 24 Sep 2024 05:04:07 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e902b681esm20158575e9.37.2024.09.24.05.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 05:04:05 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Jan Richter <jarichte@redhat.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>
Subject: RE: [PATCH] KVM: selftests: x86: Avoid using SSE/AVX instructions
In-Reply-To: <2a62086810c14d0e88e38706a06aedde@AcuMS.aculab.com>
References: <20240920154422.2890096-1-vkuznets@redhat.com>
 <2a62086810c14d0e88e38706a06aedde@AcuMS.aculab.com>
Date: Tue, 24 Sep 2024 14:04:04 +0200
Message-ID: <87ikull0ln.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

David Laight <David.Laight@ACULAB.COM> writes:

> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Sent: 20 September 2024 16:44
>> 
>> Some distros switched gcc to '-march=x86-64-v3' by default and while it's
>> hard to find a CPU which doesn't support it today,
>
> I didn't think that any of the Atom based cpu supported AVX.
> I'm pretty sure one we use that are still in production as
> server motherboards don't support it.
>
> Doesn't -v3 also require support for the VEX encoding.
> Which removes a lot of perfectly reasonable cpu?
>

Well, distros making such decision are obviously not very interested in
running on these CPUs then :-) In this particular case, the distro was
Centos Stream 10 and they are very explicit about the decision:
https://developers.redhat.com/articles/2024/01/02/exploring-x86-64-v3-red-hat-enterprise-linux-10#new_cpu_capabilities_in_x86_64_v3

and 'gcc -v' tells me

Configured with: ../configure ... --with-arch_64=x86-64-v3  ...
...
gcc version 14.2.1 20240801 (Red Hat 14.2.1-1) (GCC) 

-- 
Vitaly


