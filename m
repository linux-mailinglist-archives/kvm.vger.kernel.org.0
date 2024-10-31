Return-Path: <kvm+bounces-30227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04A019B83B8
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9EE8FB21B54
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B431CBEA2;
	Thu, 31 Oct 2024 19:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lGrOt4cO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA15C1CB53C
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404435; cv=none; b=pAvJzD6KNXgesDvm9tGmAdxXiBf3MhdqyEAK6mXgGckX8jMeO4CO1sP4JsvzKNP4J5Lk/1Qbl4kEbRq5L/1Ih0ybK8V6V87Tow7+zw9LR1rJXg1bQPosqyEJn8ywumTfSBUJTtyt/tH6O7EWWYbfFQ3XEC5xVcE+AVFt1dyooh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404435; c=relaxed/simple;
	bh=PdWqS76TntBj1o5y/ERo5t4OfLQCPNhFCHC/bosJaZU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PuBUNZYsFpphJEKEcAhnSYoOv5Mk3l66C4pUUpPmbxUPvAWh/vY7IwYDAOBaelQ5BhXYi+jz0G4N6QaKInPpHWfndFbyxB3dO+5oUaKpwzyvLKCDam7hBrPvVSIWrvdD9cmJS+R77pOWKYjRh2qjYEi//Tb0ODcD0Qv4BmVXzBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lGrOt4cO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea258fe4b6so27118017b3.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404433; x=1731009233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gjbSgVjCkY0HoMuRTmWdgWHPQ8ANMkSeaY47F/g0Jas=;
        b=lGrOt4cOtD1WX6ItktkFQaCxJcQt1n0zpWE4TxS7GzpCd7VnYeNuMFy0s1BWyYIQCG
         D3sc0nluaCHdlnxrkNxaorHc5Hy6MAvXdN8WlnN71HphbX6vPIZlGxjtJCT2adDCteBZ
         ALJLzsAirXHFWnMW279eBU/jMLrnHc6mPbUegau9z4iSreMomFkOFMifxaXr04d1Y7FF
         owvzM5qPgj0AA2gqE6AG73Xidi2ffGgmDoCKYMzFBuD7nI2SEYIjuvpDEAW7yHnAAOn4
         HuuFY0kOq5E//DLSUthzSg+0IyuaJOsUx80MZrXbw9jw6wt8ZuP5CQDX6lrTrwvhphFD
         UYxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404433; x=1731009233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjbSgVjCkY0HoMuRTmWdgWHPQ8ANMkSeaY47F/g0Jas=;
        b=Otd6yWjEoJJRRKFnl+yOV2fnJQ49f7ueAapp4Tz9NsHVpoOaOU6w/i4gDxrKCs7Ir5
         L+oLygcgDuvWBTGbmWPLfqHDP6+XJs5s5/3p22lHPA/ub+qAj+6cwKga7dJXNtrrzotz
         PUkfQYPXvJxYNSxDepj18MdzCQ8dD9igt9+10VGjHNvT/FVlMwdetqZlDsNn+iv9knfb
         PBlFlWvrltRJFS6TjjHFNd6jXtWj6WP3bsgn2nuNvRHnYWGKkbwtU11HK2m67F5OQgdL
         CZE9MtxNbVL/aUPQ/jD+L1sXT5Ku3AmN+5OnqSBSTT4s4uEGEdd+XzWHU3XhIrdXb/GZ
         rBrw==
X-Gm-Message-State: AOJu0YwOQ4kC7AFnwIbdzd68MeK8s1NLeBveEpmX5k5Y5owPIve4DlcR
	ISDStSk5YtlWMea8Ck1Iql9O0N5E0W2UhpefqfSVmppwPEzRQ7kZFgDRqYP+5PXYrziiPTwm/8g
	PsA==
X-Google-Smtp-Source: AGHT+IE7o4sC1NJhy0BlEpH5scKVHImtCn1rOQ+RAwKY6xUxYUqqBj6/HkcqkBw17+DYOQTnbgDPsbRkiz4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6811:b0:6e3:14c3:379a with SMTP id
 00721157ae682-6ea6479f2f6mr161017b3.0.1730404432792; Thu, 31 Oct 2024
 12:53:52 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:31 -0700
In-Reply-To: <20240802202121.341348-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802202121.341348-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039526970.1510316.4428336973275011540.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Rework core loop of kvm_vcpu_on_spin() to use a
 single for-loop
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 02 Aug 2024 13:21:21 -0700, Sean Christopherson wrote:
> Rework kvm_vcpu_on_spin() to use a single for-loop instead of making "two"
> passes over all vCPUs.  Given N=kvm->last_boosted_vcpu, the logic is to
> iterate from vCPU[N+1]..vcpu[N-1], i.e. using two loops is just a kludgy
> way of handling the wrap from the last vCPU to vCPU0 when a boostable vCPU
> isn't found in vcpu[N+1]..vcpu[MAX].
> 
> Open code the xa_load() instead of using kvm_get_vcpu() to avoid reading
> online_vcpus in every loop, as well as the accompanying smp_rmb(), i.e.
> make it a custom kvm_for_each_vcpu(), for all intents and purposes.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/1] KVM: Rework core loop of kvm_vcpu_on_spin() to use a single for-loop
      https://github.com/kvm-x86/linux/commit/7e513617da71

--
https://github.com/kvm-x86/linux/tree/next

