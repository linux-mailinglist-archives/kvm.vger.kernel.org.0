Return-Path: <kvm+bounces-30992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDAE9BF27A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C16D1C2492E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA150205143;
	Wed,  6 Nov 2024 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oyH3Lifk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573AB204F62
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730908983; cv=none; b=Yeb6+V2AMNS5zsb49umVtllhSlDZEKb58/i0SLCB+zZ877TL/x2/0yl+VzGftbJZqyaAwVJYuNho4XIYug1YAE5+5kkOgoMupO+GqUQqJAtHqzx3lBVRXOkk4dWvRxRsxQ4IT33nxhQHk71pn/N0wJJ00pMZQPmhUEqZjM4XrdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730908983; c=relaxed/simple;
	bh=fy73WYxUR+ZmNc8sSrPwJ2tbcofwPeB7De60X6vc7XY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W5vTaFHw2g0j8CP0rsO8r3nXUj6EPyZ4GPEY7FtZtPs/Y8Hrt0CnTJECkvFE1pXJ+KvVPGANNtzeLikr84COCKtTsJ0axX/AaHQ/0iXG5cNwu96IhDri/8gti8qoGGLatplCrhKV2KeOM4yJCnI3CHi1UdJx2zAKMnH9QpNs1+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oyH3Lifk; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30daaf5928so13179099276.1
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 08:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730908981; x=1731513781; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zI3XSt+XPzxc5D/EPI03QfzSGcXyo1d3P9ZN8DQChnE=;
        b=oyH3LifkylZtDT1Dz2FeLBp2RpYA4iN8cigyt6jZJHC+p5g9lkCscg1UiGYrVzcxt5
         TNrFOGibff/pEd/sGiP0xzOnAKiZEKT9oJj45kBZLzgLihwRAPnr1qvg3CFDTvDOtfs2
         YZk5GjKBWKIpbpSII+RRVfowIjerq46pVNoPH7ZzMUCOfWzTzjx3vjNwurEK/ZALdjVJ
         Tq6HcBQKudQKlo3ZGwfs02xU5YGfQ51PIGGIb9Fpe94TFgBbpphaSmUs3zm97v+7jyZ3
         QiSiCz0foMJPmqjrM2PuMDshSrTXDBE0cXL1aZWfPZT1+seNmL5ZEBBhSkPlppaCaVWa
         TzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730908981; x=1731513781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zI3XSt+XPzxc5D/EPI03QfzSGcXyo1d3P9ZN8DQChnE=;
        b=iMsx4FS83fr9W2PmuuYPyRHSOHmOOmtJQyXeSgR95nZlz5jRSUXjwg6IYTuxlC6RFM
         mD8phT7TzQKki2ig1GpVGN+xVDSFK757TQ+MlrXeer2uFkRT7C7xLgo5pfo6DSyalWWF
         v3tG+ksYhmgdE6ky84AIRSxgDWIaW8zkJUwQZQL4tHK9SpkDNChPXR98CLe2ka9pu55H
         3Vlw6W85B6am2C/38sJ/tS/zumBSBhhHrymrskTJI6myshsXraznvnxV4YclGTl04Q/d
         U5M62VpPgpVijIelXxhtcbzi7y8N0rALbAYgBQqqd0VljLgzwOAXfBh1uhgC01/qmPIB
         queg==
X-Gm-Message-State: AOJu0Yx1riEn43uJm2WwHFm2d4Bbnza+iEzdxSwnIVLqnSaWyptWGPjC
	n7BebJAxofUAJKZFFMhN4cEWaIMZo9PHy6cyDB3XyTqXJHPtiB9IKrUR0oX9p+TS1sCd89gs6rI
	vjQ==
X-Google-Smtp-Source: AGHT+IEq9ITkWQadcHY2Ncx7sHT1F5ugGt9OXwzI9QKpoVzCnOmo8Ay6t2SxdqenV51dMXJLprT+QVoeYmE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:e04e:0:b0:e30:cd7e:c0b5 with SMTP id
 3f1490d57ef6-e30cd7ec150mr48674276.3.1730908981267; Wed, 06 Nov 2024 08:03:01
 -0800 (PST)
Date: Wed,  6 Nov 2024 08:02:42 -0800
In-Reply-To: <20241031203214.1585751-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241031203214.1585751-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <173078661182.2102830.10430525599582052471.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Propagate error from snp_guest_req_init() to userspace
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="utf-8"

On Thu, 31 Oct 2024 13:32:14 -0700, Sean Christopherson wrote:
> If snp_guest_req_init() fails, return the provided error code up the
> stack to userspace, e.g. so that userspace can log that KVM_SEV_INIT2
> failed, as opposed to some random operation later in VM setup failing
> because SNP wasn't actually enabled for the VM.
> 
> Note, KVM itself doesn't consult the return value from __sev_guest_init(),
> i.e. the fallout is purely that userspace may be confused.
> 
> [...]

Applied to kvm-x86 fixes (yesterday, I forgot to send the thank you mail).

[1/1] KVM: SVM: Propagate error from snp_guest_req_init() to userspace
      https://github.com/kvm-x86/linux/commit/e5d253c60e96

--
https://github.com/kvm-x86/linux/tree/next

