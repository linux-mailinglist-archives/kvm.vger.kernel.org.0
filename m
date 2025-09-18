Return-Path: <kvm+bounces-58041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A32B865FB
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 20:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9718448594F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E1B2C326F;
	Thu, 18 Sep 2025 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="djmzn6Dt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2702C031E
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758218758; cv=none; b=K/R/W80eD+D4KjTWN+9lQm2g8OO+0wfT1iDDdlwf50lPexf/YCQIRExFyTR5rnO5LhioDu2XfVgH7xKN2PhAh2+6aYiUcIpM6AbCs0HMA82iH9mTUyd/lRu4tlqA4TejqMfrpD47C/Qp3g53KvSDZbQz1doUmJa5C9tb8ZK2hgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758218758; c=relaxed/simple;
	bh=+dUsv89Yhi7YjhJ/iCxyZ2JyhOt4WwrZMl4JV9BWTqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sniq1h9d5sf9uu02Y3c3jInSG05sRvC7MMVq/6pe2c+ZcD+nPecrVEVrF2FZ4xBdYlRZrI74O8zHW66QSf7OxbbUhAnspETrtjXp/SpNkkGvE8eAapZvqe1YqvR4SnnyzIjWZKEC1DHge8hr4JxG1DVzmJWggntj0TJFAzz5yw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=djmzn6Dt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so1295498a91.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 11:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758218757; x=1758823557; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=InY5LETIHJUcjWRe8AE+uV69XFL68bNcdyq/PlTUSNI=;
        b=djmzn6DtnFwZ947UySlPbTmFFwMUQ1NUxpskBrSDeSa8J2M4HsSJXSzDH4bmdvd0gp
         Ykb1r1O5qwm6TbM60FmIQEnezUbD13WiABgF03wpEJv5TKyRUWeP58lygutpgF6RLF04
         wIrQqpirLQPAnz/idv8k/fbMgzYJv9oDfCIKU8EhPxgRV3wJ01kx+y/LFDiDM05u8R9T
         owEzxgiZ+YPxt4vR8p6JYz0cKlYOX4s3LE8o3Ks5kO26cYmC0sCbUYn4KFLNAd/5/9Tu
         /yk9nxz+AnRXnfIEibROYfbgXOZeCXtpDRd5v9De1htNUxDQouJ6dCPS7G4EXhcmRdS0
         9Dnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758218757; x=1758823557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=InY5LETIHJUcjWRe8AE+uV69XFL68bNcdyq/PlTUSNI=;
        b=biiJXuV1Wu9F9/wzgwBXY+Leaf9zptPGZbEP0wmYpDfpZfE8TRZxMnxw+NbXdTFjJQ
         5/YZQp3q72Shmk/o51WCEq7LBvnAJv3FCtiv7SPwh72lbLm4JF7TUXUXV+tFXR/Pc0Bq
         xI2hSeDpjLoU4Qoq2siqr7hDE4bMEzFnPfZW+VCW4xPlOffwertPJtETSZh+yxEdzs8h
         /Xwf+4ywgxE4yuzOxrgtp3FyHjsDJchM52DgJQwsZv7lyeQisdbvuCW4tJRIwEAhowu/
         hkATG3hVooSbjiJ0fbfOzcIu732k4A4Fbj5xv0ALmouXZbihlUCXj0CbTAEf8aP2YAz/
         qi+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVbW1jNBiWH3zvxyubTpqLbOP8nrM/QQrU3pxJjk80XUgc3xXAMHT12Gmoa+Y70SXa+Zxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcTiGlb29VN0jDpBsDWSLtPt5qzKWRSXtZ2JxH+v1hERMPg7OK
	YYTGS+lqTUk3KoVAAgRUSRcqoYrEeeZOxXd/1LJSO+Ti2nzK7N0X2YevyCYngePENbc4YXhZBLl
	RCoqdpQ==
X-Google-Smtp-Source: AGHT+IHhoyL6/icyFsBgGw/f+v43uy0snIS15sT/dYaXEHSdYoNFOTXD4bkN/E00b8oY2M2jzOiq/6uLP70=
X-Received: from pjbee7.prod.google.com ([2002:a17:90a:fc47:b0:330:523b:2b23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:528d:b0:329:e2b1:def3
 with SMTP id 98e67ed59e1d1-33097fe6b7fmr300025a91.10.1758218756667; Thu, 18
 Sep 2025 11:05:56 -0700 (PDT)
Date: Thu, 18 Sep 2025 11:05:55 -0700
In-Reply-To: <c140cdd4-b2cf-45d3-bb6a-b51954b78568@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-20-seanjc@google.com>
 <c140cdd4-b2cf-45d3-bb6a-b51954b78568@linux.intel.com>
Message-ID: <aMxKA8toSFQ6hCTc@google.com>
Subject: Re: [PATCH v15 19/41] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 18, 2025, Binbin Wu wrote:
> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> [...]
> > +static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
> > +{
> > +	return	vmcs_config.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
> > +}
> > +
> 
> I think "_cc" should be appended to the function name, although it would make
> the function name longer. Without "_cc", the meaning is different and confusing.

+1, got it fixed up.

