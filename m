Return-Path: <kvm+bounces-63160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CA1E3C5AD81
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BCB804EE0E7
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0307F246BBA;
	Fri, 14 Nov 2025 00:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="24vVf21T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFD63E47B
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081199; cv=none; b=FVs6wY+kaOs19xgDJV+o/OmlUOjKlX6Sv4Pv+FmlLuzccGQaXL8sulx7FSJage0wbXrYaEqd/Jb2VChuShDjkC12cRhuzBSK/Pd6QBQaUFZaHwLmePk8FnEu1xwfi72lYeWFwAfvqwIlT/J+1LSs/4KXDQSEFZQH8HBmoNkh0fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081199; c=relaxed/simple;
	bh=nmbKNMro6MZTXaDWQRL4nMdw/Xk8u52CGUuhUl6LVY0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VpGzqiKO/5Q4JXl6m5aDNqTfOncW2mlNGW9WxVm9LGREaIYEvFYgvaFfUJ7QHy6Mro/jFvyfaWEB8KP5b3BGy9UGZ2g2nqfkPBC7cmlLHxSdM7K67kGuEP/imhRQbBAzgcsoZmnVhr5FlIZnh9Rrn5UZIcim4O1FuhgxJ+J9vBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=24vVf21T; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34385d7c4a7so1407647a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081197; x=1763685997; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uDj7CvwbWETtOWttFV8wxECqduFOZCdbeBiaXuQNabI=;
        b=24vVf21TNiVR7HpDAArvnegJYaoIhMxlERYuP5uqiRDZ+MLPGRTjfbIQmWdxWWcMy7
         Ikn8+KUdJCS60KKONZsHycH4H2wDIeTPzFmtXhuXn1USWRHbkWLs13aXEj6iBRCzfhUg
         fv8JonjmyUwk2W7tappY+bdPHP6Yxav2ecaQUdvX0Ki9hcrAUVTAvmak+1TH/qltu+Wu
         q0MHOfIyxxHHy2ni6j1R9Tjltwy+QzEeCPjIFdYx62Z/PwjokDnI/W4EonEwhrG1GF7j
         m9EiUJM9KTG62UJkF5SQOVK2SzIO6/Y5dFpQzCzUX3Vo3dYAg92Lmhp2sszAVMFszlwQ
         Zrvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081197; x=1763685997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uDj7CvwbWETtOWttFV8wxECqduFOZCdbeBiaXuQNabI=;
        b=rQdgQgg0PnUqHkSso8ACMsIA5YmSo6t4teHhxG/WrHT9LcLlvWz4toR6I6NxcSJ7g+
         lETLzVftcRhiHtJSwK6SF/1eVnMkzSgSBrksGo3kh7Q82mkadMadpFP9gJ7e0nfGjzIZ
         0LpLmyr2bvwTFJPW9OMFcxFhBMj8TDnXfvMz0uS/bMrlZNFIgmNt+3Qw6yqve0GCzfje
         2y5lbS7Q7cJeNhfvSHnv1lTvLkA7y4gX4jBJ6JpdYRqWnwPN6tEDB1jMGus6FlLSjZ0s
         K2beukPqHsaN6FSvJz0zGHjBG5wbm8AACyR67j09IWn7oR4Z+QeZKvH7JDo6RxcVfzp+
         y8nw==
X-Gm-Message-State: AOJu0Yw+7h6dBON03lsOe7NDWuV9dsU3EGvXGf9JFi2ih640lspGswis
	m3hIPRDBjirjKOz0L7bSWvoNE4CyqiE5rz/a3w4uNjdI0yROOP+Wg950pUVhxs9n5piU7KYQUYA
	1lz8UIg==
X-Google-Smtp-Source: AGHT+IFvWxC5jOH/W7eS+nx6SQqbPD99U8lJhPUWnbz/npn1mBEdcUauKA+rus1zvm7yDcrcnsd0aUY+nko=
X-Received: from pjbpv11.prod.google.com ([2002:a17:90b:3c8b:b0:33b:e0b5:6112])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:548c:b0:340:29a3:800f
 with SMTP id 98e67ed59e1d1-343eacb9cdfmr6087762a91.15.1763081196994; Thu, 13
 Nov 2025 16:46:36 -0800 (PST)
Date: Thu, 13 Nov 2025 16:46:03 -0800
In-Reply-To: <20251106210206.221558-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251106210206.221558-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176305665095.1602845.9274238002903506152.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Use "checked" versions of get_user() and put_user()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="utf-8"

On Thu, 06 Nov 2025 13:02:06 -0800, Sean Christopherson wrote:
> Use the normal, checked versions for get_user() and put_user() instead of
> the double-underscore versions that omit range checks, as the checked
> versions are actually measurably faster on modern CPUs (12%+ on Intel,
> 25%+ on AMD).
> 
> The performance hit on the unchecked versions is almost entirely due to
> the added LFENCE on CPUs where LFENCE is serializing (which is effectively
> all modern CPUs), which was added by commit 304ec1b05031 ("x86/uaccess:
> Use __uaccess_begin_nospec() and uaccess_try_nospec").  The small
> optimizations done by commit b19b74bc99b1 ("x86/mm: Rework address range
> check in get_user() and put_user()") likely shave a few cycles off, but
> the bulk of the extra latency comes from the LFENCE.
> 
> [...]

Applied to kvm-x86 misc, with a call out in the changelog that the Hyper-V
path isn't performance sensitive, and that the motiviation is consistency and
the purging of __{get,put}_user().

[1/1] KVM: x86: Use "checked" versions of get_user() and put_user()
      https://github.com/kvm-x86/linux/commit/d1bc00483759

--
https://github.com/kvm-x86/linux/tree/next

