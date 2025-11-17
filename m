Return-Path: <kvm+bounces-63382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 99FFEC64CC5
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 6016528BDB
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 15:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8243B333737;
	Mon, 17 Nov 2025 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wq0D2B6f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F78248166
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763392020; cv=none; b=kwpsMGvQGAu4cukbPKeWJ5yn5oGTmjE33YTKqyY1oFEa9XmaQAvZEcbPFz+62IfrckbJ+m6eZQmNgK7zagvxfjA/80zaE+3CyV3X32quyXGwD2Ibkx4nRkrlHumeViNt6lJZhqxM8yqGUO47P4tyw1yjal67IenH5k04nhhvD7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763392020; c=relaxed/simple;
	bh=ZVCe+1ZisPI9dqGUCn3xqHobEuFAysrEV1InQvFbmIs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WXD7qtzun2jVFbDmsnd4492er/NaXd0uXNGlZOk/FiiTORIjBPOOfTUAYy16lj7iznjG6GNf8B0i9s0oBn0zwnVYxdp+UdwCZpxGlrvKpt/iw9OTTdOUAlrib/XAikvanlr8tESWebikuqpZM8+vcrYpnkdr/WNuImq6RP4pZH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wq0D2B6f; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34176460924so4201326a91.3
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 07:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763392018; x=1763996818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aKWMjY1G5dJf/3LgpKl/NETW+FjIuUMvWMw9eVSgzUo=;
        b=wq0D2B6f1V51nU4oHfitWHu7jnwBFngossWWGk4P5zhV4Islx91MODW4B3oC04qsKm
         RT+Ec800shpB/jh1FGa2c/agkG9+aRuBMnCQ4UscOMmZm132/Ih5bx5UyHo5HMoA/Qoz
         KpG/ROZe5sgubBF/smsw+NJ9Uj7wOoDa6++VseXJNqWQ4z8OlSwyNA0PafjScRxF61uv
         q2AKSbZke7Kn0ecU6WKFqhUg5+aEmVRYRjzQ2UD4OvhUQ0xKx4o55yyGf0VVWzAZy7gj
         B6pOnzChBwgAv+wuNCGWdZ9RqlLr53Yns1CJcIF2Ym6otvoqf65WeROVxGNwGaGdbZzC
         XuRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763392018; x=1763996818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aKWMjY1G5dJf/3LgpKl/NETW+FjIuUMvWMw9eVSgzUo=;
        b=F7UTg0DZyZ36mNRJKDwsc+YmH2ADPO2wHB6M92jmT1AfMWHF+WuiD9FOnKkmXtRqKP
         unwfku+YNuL+A83qNY66Os2aiJh4m8pqIyT1lNM8ZsD55V06gQvTL/8VNz9EjKm8wrAK
         oyUe07blzniCLQKOoCQxpZWrM7loox9bNPxfHXKs2wf7RiF1mPFqujthDQn1y93jZFo3
         Rrk2IMYHXtY1kDv/YnwupUkQcMeRP3XGS/T0Stf39bhMI8jjzKFGInuZDdxJcczdZm8z
         XaHPdFJ1zBogGR8dxRO1fqynpIix2AWlY14g9zBNACllFcifuEt9UjXRYUeNQIamK+vj
         zJLw==
X-Forwarded-Encrypted: i=1; AJvYcCUsGplCk91i6Oj+zUJNxSjArdwOjTFDSWjk0BBJg4reJZeL9mMbje6VvS36d4rrlQIQME0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6vmK5k6GLfz6w6wMT/SolF2vZx5ab2gf/bwRbNRuNSDuL6yYS
	aOrkoYhAIliFjfCO5Jyftucfnpz/EOHR/9KN//oEH5JDa1OcS2NKeamngs2rNaJdNv9D/YcCeV/
	5VvsZtQ==
X-Google-Smtp-Source: AGHT+IFOxUuzIgKh1JwbIAjKu49ctjZJknsV5hB6eqARol3NYY+tbG9o+hSzpMZk0suFg7lO7U0MuSnvVVA=
X-Received: from pjbbg15.prod.google.com ([2002:a17:90b:d8f:b0:340:9a17:4b10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c06:b0:32e:64ca:e84e
 with SMTP id 98e67ed59e1d1-343f9ea0b0dmr14224737a91.15.1763392018493; Mon, 17
 Nov 2025 07:06:58 -0800 (PST)
Date: Mon, 17 Nov 2025 07:06:57 -0800
In-Reply-To: <20251115110830.26792-1-ankitkhushwaha.linux@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251115110830.26792-1-ankitkhushwaha.linux@gmail.com>
Message-ID: <aRs6EbV2gnkertzA@google.com>
Subject: Re: [PATCH] KVM: selftests: Include missing uapi header for *_VECTOR definitions
From: Sean Christopherson <seanjc@google.com>
To: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Nov 15, 2025, Ankit Khushwaha wrote:
> The exception vector constants CP_VECTOR, HV_VECTOR, VC_VECTOR, and
> SX_VECTOR are used in ex_str(), but the header that defines
> them is not included. Other exception vectors are picked up through
> indirect includes, but these four are not, which leads to unresolved

That means your build is picking up stale kernel headers (likely the ones installed
system-wide).  The "#include <asm/kvm.h>" in kvm_util.h is what pulls in the kernel
uAPI headers.

Selftests uapi headers are a bit of a mess.  In the past, selftests would
automatically do "make headers_install" as part of the build, but commit
3bb267a36185 ("selftests: drop khdr make target") yanked that out because there
are scenarios where it broke the build.

So the "right" way to build selftest is to first do "make headers_install", and
then build selftests.

Note, if you build KVM selftests directly, tools/testing/selftests/lib.mk will
define the includes to be relative to the source directory, i.e. expects the
headers to be installed in the source.

  ifeq ($(KHDR_INCLUDES),)
  KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
  endif

You can explicitly set KHDR_INCLUDES when building if you install headers somewhere
else.  E.g. my build invocation looks something like this, where "$output" is an
out-of-tree directory.

  KHDR_INCLUDES="-isystem $output/usr/include" EXTRA_CFLAGS="-static -Werror -gdwarf-4" make \
  INSTALL_HDR_PATH="$output/usr" OUTPUT=$output

