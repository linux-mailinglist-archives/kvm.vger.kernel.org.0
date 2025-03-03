Return-Path: <kvm+bounces-39890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13120A4C436
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 16:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D2AD3A93FB
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11E621421D;
	Mon,  3 Mar 2025 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mWZCP8MB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0AE214213
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741014375; cv=none; b=RS2gogHP6009hd16otVKpaCpIxTk97XNW1lvwkALfLtpCJa1lsxq+817Hi4CgU7YuGbypJFBVwSwgfjUTdbIe6RP8M5kUlnLc+uGmVYzetaKpPqRkFrigi7SaIjMWbosqYn7+uHld1AO43W6sF5vokVe1glsdQ+XXu9BW7s80gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741014375; c=relaxed/simple;
	bh=P9F1ofeYrCy0v/tXEp86XKR4kq6FqY1je5tQrslWrMw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=EJ5iu0YXJNoZG1J3BET8mgu+T3yONC54UeSXq5f8todc+FXz0jj2ByZFs6VwrywM9AJUJhleKsqSBTgu/1GimZVjyEI3bMNgdMfetxxU/aaMWaHMtW/lAUkfiVjVNjjfFO93PxxfvSXb7sYOiq3hZKo/FmLlp+SktSQYNZS0bts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mWZCP8MB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4394c489babso25501065e9.1
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 07:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741014371; x=1741619171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RDvNDSBHwWtbzP2LN4FrATbN6y8fQnYjZO4RYaZIKfs=;
        b=mWZCP8MBfdoFBfGai6cClbCLNUNo0smjyWA5IriDHlBKye375ROh7xFRukdMODFiLq
         dbZ1oI8eo6jd0N08P/NIbYxEwKU3tu/pAQ4RsLe7+PvkQQh4u9tsMaTSFxGssaQUxSWh
         0x34vxTcedXrBah5+wbxb9rq8cLRkcTNXU4ptjeAUsejN3ofYmxYoX5PrrTS5B5Ax31m
         iBwiEn8CMEtpGmkggLqw9H4fk4qDgjHbVuq+VmM7wMLO/7/ev7+aDO2QrXBxGjPqXHqw
         lDmFYDdwJdzodn5xWRVInztzlPlIWNQIwZ9IG8HYlnQiPD7i47ie6Rwffy5WN0FFuwJd
         hI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741014371; x=1741619171;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RDvNDSBHwWtbzP2LN4FrATbN6y8fQnYjZO4RYaZIKfs=;
        b=WFGalqJ+C/P26mn3XX+nmiktUyYTRw0bDgTradO8qyYD9TgerYg93OqLUMk5mWYlOh
         i4rQIAU9t6Lmq6WlXmaEskMwuZPqtGpTidK24xR4G+ZaKDPMAsUggQtHfZ81uKFvLCYD
         w3gCP6jCJWZxxwbN4C7Ey5bkDRz7vvCNM67etAE7nAW9aaql017nEB7as6+xWogq1X+1
         5Ruhy+Tyu3mjTGOfBKmc51FcdCT8TERMAcI/ygwZGYam7l8ENK1LZV7cm5bl1P8TIOjZ
         CVbZUJyKoYu67QBvBiBmoe2v8kuIs8fqg6/FqWL5DmeZSqKwG3dKif6HtbTeQvb4GR8a
         T7Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWba2kOfvguEmR81hefSaEkw2ARgHwZqpvNfwXFjdmlNqHhGwprFABsVzU/YpIUBtXeYY4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx19aLwwtJuqap6z1XW47PxlUtumT4K33ZP1uYXx7Aq5vFt8BzD
	8DkcbkwpGn6VzKB89S/0HCioRKWVr3KGeWNHFFapsCz5QuL7ZraJDk7SypUePj8pEmDh8dNoEmA
	6I7r+BiZdEw==
X-Google-Smtp-Source: AGHT+IHoEuw10xjAFK3YffNpBzL0FGxTUI0tpeWG2zIYS0277Gf09Ura44LMHf5llA6zU5CoNjFRM4Oo2iaZhw==
X-Received: from wmbjh6.prod.google.com ([2002:a05:600c:a086:b0:439:9558:cfae])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a48:b0:439:99ab:6178 with SMTP id 5b1f17b1804b1-43ba66da248mr109415265e9.6.1741014369703;
 Mon, 03 Mar 2025 07:06:09 -0800 (PST)
Date: Mon,  3 Mar 2025 15:05:56 +0000
In-Reply-To: 20250303141046.GHZ8W4ZrPEdWA7Hb-b@fat_crate.local
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250303150557.171528-1-derkling@google.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Patrick Bellasi <derkling@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Patrick Bellasi <derkling@google.com>, Sean Christopherson <seanjc@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Patrick Bellasi <derkling@matbug.net>, Brendan Jackman <jackmanb@google.com>, 
	David Kaplan <David.Kaplan@amd.com>
Content-Type: text/plain; charset="UTF-8"

> On Wed, Feb 26, 2025 at 06:45:40PM +0000, Patrick Bellasi wrote:
> > +
> > +	case SRSO_CMD_BP_SPEC_REDUCE:
> > +		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> > +bp_spec_reduce:
> > +			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
>
> Probably not needed anymore as that will be in srso_strings which is issued
> later.

Good point, the above can certainly be dropped.

> > +			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
> > +			break;
> > +		} else {
> > +			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE_NA;
> > +			pr_warn("BP_SPEC_REDUCE not supported!\n");
> > +		}
> 
> This is the part I'm worried about: user hears somewhere "bp-spec-reduce" is
> faster, sets it but doesn't know whether the hw even supports it. Machine
> boots, warns which is a single line and waaay buried in dmesg and continues
> unmitigated.

That's why we are also going to detect this cases and set
SRSO_MITIGATION_BP_SPEC_REDUCE_NA, so that we get a:

  "Vulnerable: Reduced Speculation, not available"

from vulnerabilities/spec_rstack_overflow, which should be the only place users
look for to assess the effective mitigation posture, ins't it?

> So *maybe* we can make this a lot more subtle and say:
> 
> srso=__dont_fall_back_to_ibpb_on_vmexit_if_bp_spec_reduce__
> 
> (joking about the name but that should be the gist of what it means)

I can think about it, but this seems something different than the common
practice, i.e. specify at cmdline what you want and be prepares on possibly
not to get it.

> and then act accordingly when that is specified along with a big fat:
> 
> WARN_ON(..."You should not use this as a mitigation option if you don't know
> what you're doing")
> 
> along with a big fat splat in dmesg.
> 
> Hmmm...?

After all the above already happens, e.g. if we ask for ibpb-vmexit but the
machine has not the ucode. In this case we still have to check the
vulnerabilities report to know that we are:

  "Vulnerable: No microcode"

--
#include <best/regards.h>

Patrick Bellasi (derkling@)

