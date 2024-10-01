Return-Path: <kvm+bounces-27786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30C9098C39B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 18:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3D371F2398A
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 16:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509181CB528;
	Tue,  1 Oct 2024 16:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gZ3XCU+u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167A61CB33D
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727800890; cv=none; b=S3lpnCvV6pJ2GzZ0QyriqSKvX3zy1rIjSri6g3jRK1ix6kym1DgwSxjB2f8XsUCLxoQaiT0nxX+e3HOiNICkU2EMXSJknMzn/PwjctTCGDfMDFTQGCBJ0HtaMmbW44H1hjQxKoOe71pXAINZeg7sJI0+JvdV6lj3d7SecRpAAj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727800890; c=relaxed/simple;
	bh=+jkyghh59xKMjZU+NbWVLGYubWbREKsEtCY/7RDZWJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kCkdKt6uP1ana1GQqcAuB0+2a2XPd2YWZMdKkZprNf6LuW+/KoxiexSjb9OQHz4IWgidxpXvj7nbPWRqq14bORP+rB2bT0WbhX7GB7YYeT0GQs43iFpxmXRSOYn8aZfpyd6xTfmBwq4JPCWB+gSTPILok3bY/+O9shUK3//IIXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gZ3XCU+u; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e2555d3d0eso63289937b3.1
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2024 09:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727800888; x=1728405688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5SgvFUZ0l32mNtnLi+B64uXI+aFBZc2L8UZwkiGU+28=;
        b=gZ3XCU+uYa+SYRI3cF9x2LMUbO6QXzCSbfPZIfT9MD8tsAGF8No1QmLiX66zCBumte
         r7X71G1ldpoL27sCo2bgPLttQrWYb+UX28G/uRajM/IQjDvdasWZgjbD1BM6b/X1oQLu
         aiPDNnC+GlEHruwo4mRtdKp+MsKQqnrjO2ZqLeL9leiH1A5Ecq6TxtY7vMi/RsIGERYc
         XJ4GSPB6EHOpKVMtzumW3ZjdC06cT+Xv+DtlR+IBf4Ez+2f3VcXO0AeqSU2F4qLG4gVQ
         ey0WZk0+D7jSSmJJNNXLFDhQfzxskoXhFYjJSue7wM0Hzq2ciLuyTNbyRR1dz74Boloc
         IM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727800888; x=1728405688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5SgvFUZ0l32mNtnLi+B64uXI+aFBZc2L8UZwkiGU+28=;
        b=jiaFQz7rKbnruim68KnxLlqHtpsli7g5HKJfZPRzk4L7BWAHbtRI0LRm0iAC3vEIoN
         2UPNZ5ldiGABNBojyh/10tmlBWSCr/D8zUWI/1YhCoVQTqF0eaLb7LCow2mOYqzHamaD
         +4QzKYu/Aj1e/PPIdwAdUbmsim2kIcRHGAoc5pupmOOdTlBcZ2aSaD7FAVcf57Q+4X6+
         2QDcqek6I8/KNiulfvkhlDRdqxmqCGAh+e6SqdbjiplSIm9ICeaKA7DFaF17wdWdIyxJ
         3fLZRR4OEM/3k7UF3y1PnUUvwjjCEJ/VHlK7J89At+WJOO8Zghe9l1FqKD/q3gFOtZ5N
         ZACQ==
X-Gm-Message-State: AOJu0YyCqieXEIAePQQMs+y15NSJJAy3gtWWunLG52T+XJvKWeTBN7EG
	oUBnFrrmP//M8zItxE0gJbuFMNhpSYyDYsR2jhenrvLrrfuWGoGxNyr63QmqfpGIbsOff/k87sj
	NFw==
X-Google-Smtp-Source: AGHT+IHmFdl+55S7IDy0xeVjWu3kw9xgQ6F6bPYxyY0wCyWqpm+n/FjY6pMqElJJTCVMRNqkjSGzVAZMI9g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:fd4:b0:6b0:57ec:c5f9 with SMTP id
 00721157ae682-6e2a298509bmr85077b3.0.1727800887949; Tue, 01 Oct 2024 09:41:27
 -0700 (PDT)
Date: Tue, 1 Oct 2024 09:41:26 -0700
In-Reply-To: <20241001063413.687787-2-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241001063413.687787-1-manali.shukla@amd.com> <20241001063413.687787-2-manali.shukla@amd.com>
Message-ID: <ZvwmA-Z_T44zcSJZ@google.com>
Subject: Re: [RFC PATCH v2 1/5] x86/cpu: Add virt tag in /proc/cpuinfo
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de, babu.moger@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 01, 2024, Manali Shukla wrote:
> Add support for generating Virtualization feature names in capflags.c
> and use the resulting x86_virt_flags to print the virt flags in
> /proc/cpuinfo.
> 
> Currently, it is difficult to check if a feature is supported in _KVM_.
> Manually querying cpuid to know whether the feature is supported or not
> can be quite tedious at times.
> 
> Print the features supported in KVM hypervisor in a dedicated "virt"
> line instead of adding them to the common "flags".

First off, printing flags in a separate section doesn't magically connect them
to KVM support.  E.g. if you cut this series after patch 2, BUS_LOCK_THRESHOLD
will show up in "virt" despite KVM not supporting the feature.

Second, deviating from the X86_FEATURE_* syntax will make it _harder_ for KVM to
manage its configuration.

Third, this is completely orthogonal to supporting bus lock threshold in KVM,
i.e. belongs in a separate series.

