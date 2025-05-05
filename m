Return-Path: <kvm+bounces-45456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53B55AA9C37
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33E621A80903
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA54C26B08C;
	Mon,  5 May 2025 19:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q/kHWfbh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C1D2638BA
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746471947; cv=none; b=so2jvlcPmdnZ0GSPN3VdI3J6LRfQTP3tfJE2zto7JcQ3nDYmuHU3drVyoIt5BrzU23lHtsOfWLnHfP2BmZCf57yRTtJaGEag5INiCOwSZbegDwf3OAbzjlYNWe95xSVzSCEA5Ugjiir/t/KGFNmnf4tNwxOoNX+8msCx6QOqupE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746471947; c=relaxed/simple;
	bh=ln/n/A7vDkSHNwU9VZoPwGfRXDYa7Qag+aGXjW75oWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYHu8lkLWzjv5X0JcUkz75ZEvkUavOeORX4W7pNixNq/69uZ7SDvjlwndRA9BvQn2h+ImMBSVOO1hullMmIPZbB9b+IecIlM61RB4Ynd9KB6SKAx3lytmWOitRtnOA/TVL/W9d8GKKQUWTWtk/DFJrBqHvqxw8qdAbYly6dW2cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q/kHWfbh; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22e1eafa891so29905ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 12:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746471945; x=1747076745; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nxc3AA271rP0clF1WTv1WRpUSSHlH6QI7su8jxLA6Qg=;
        b=q/kHWfbhw19KZs0ECLnNfYLptmiz6BVkj3wOcteGCjrAYfwizDSy+lYcxpqGjwQ1ba
         wfQVsbwTATJC2fYsNQ9QF6dxFsjV5anI/8Jxn5mNT5EE4hMuldRpMmnkqtL7qkOds0AW
         aqyikvatBGFOu7zzsUrbggRABQlMHyQf7Q/17BbuZ47ERcmHVI8FZ2zwzbvWbi/Gpjg2
         z+9+7zts5Z1VMiDME0UjPP5FFMZPa7/U+ER8LN0/iPjTFxj+j50dZnpvsDKc6ll5tWU4
         zJGovmoZSpVjL48Zvq/SNqdP1yeW0qcTXIWLBKRJAM+oEKYixAEwWCk7DHeWgH7yJvds
         DKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746471945; x=1747076745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxc3AA271rP0clF1WTv1WRpUSSHlH6QI7su8jxLA6Qg=;
        b=uNIE5crhHgYmk98s/jRsbPUJihMlUEUu26tO0UHG8jG1/xrqqgJJYDtKV0VU2TyZ2D
         KEnu9cRjzpLEI6lZ0vT/maqln7q2WAkNk3/mFJI9LeBl54uBC3Odcm1YFH246kDZiyOk
         zH/N0ahfO/6vINRec8dr2pprzvgQ619y8r38YjeBDoni4XEAR+PYd/Vt/bf9Ts0ytBoO
         /BrqrHVW6wZUkqFnbYREoHjm47pqxM/6RQkfDK1vKEBcQM8Q3+yZ6M5rVkQKWNJtsr0D
         gtIa+YkNDFh1tx4Sg4YFMbPVI77H4eOJ96kwgbWBv9ijOUgSuxnT8V39RaGj2+YB9910
         MZFQ==
X-Gm-Message-State: AOJu0YwlHK9geQLg8EkTqTkg5OxfCd5nii6Yhn9uMkbRrB+blMOYPK04
	UXf+xQU1dZg8rVOy8mN4NtEtAqs48Uadcq7tq0aNhqEcJC3eCKZhAH/XuLiWhw==
X-Gm-Gg: ASbGncvsG8rq0pSN6uKeFmrje+0Cc0Iu7lmzcVcfHR1xg/mk6VsRWD161da+9+iX67g
	kwGCgqJaWjtWnqjpsItdDDLBfcufYDbQpL5QEgrGbFGhgi+G0Urc4kYayS2J+k4hSBmu3tpjmZb
	qTOcfxKWGKkfwEvDM/5rbwsdsIfCN9JZ39z/DtJOuDL9cptT+GGuqm1yVxcHiR1CLA7/AOtbEbr
	euQSMQz8Oq6ghpDDPo8p0WUMq96SslLQYC813YS4j2HtQI4ou12rSvK6vYcrh3viBZv1yCHr+hF
	9+CbYGIp4Yu25HwkMuLEfVqH0OXYt+cU9m9U4GqeJ01xlRmwPArdDx1m6QKFt+P54GVymcLozYo
	=
X-Google-Smtp-Source: AGHT+IFASicqsLQoC4gNxHelYC0aG3lNabvqq0UOOhgv1HOFYapFQUFpIvWUjmSTv3Puo5pNrUg8AQ==
X-Received: by 2002:a17:903:46cd:b0:223:37ec:63be with SMTP id d9443c01a7336-22e34dee32bmr461265ad.4.1746471945198;
        Mon, 05 May 2025 12:05:45 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522fa16sm58920035ad.239.2025.05.05.12.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 12:05:44 -0700 (PDT)
Date: Mon, 5 May 2025 12:05:38 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
	pbonzini@redhat.com, anup@brainfault.org, borntraeger@linux.ibm.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, maz@kernel.org,
	oliver.upton@linux.dev
Subject: Re: [PATCH 1/2] KVM: selftests: Add default testfiles for KVM
 selftests runner
Message-ID: <20250505190538.GA1168139.vipinsh@google.com>
References: <20250222005943.3348627-1-vipinsh@google.com>
 <20250222005943.3348627-2-vipinsh@google.com>
 <aBJXabTuiJyRZb-O@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBJXabTuiJyRZb-O@google.com>

On 2025-04-30 10:01:29, Sean Christopherson wrote:
> On Fri, Feb 21, 2025, Vipin Sharma wrote:
> We definitely auto-generate the default testcases.  Relying on the user to remember
> to add a testcase, and on the maintainer to remember to check for that, isn't a
> winning strategy.

Good idea, this will help in at least automatically run the default tests.
Also, if tests are in the selftest kvm source directory then it will
give an hint to developer/maintainer that they missed writing a default
test file for a newly introduced test when they run git status.

> 
> But, I do think we should commit the default.test files to the repository.  If
> they're ephemeral, then several problems arise:
> 
>  1. For out-of-tree builds, the default.test files should arguably be placed in
>     the OUTPUT directory.  But if/when we add curated testcases/, then we'll either
>     end up with multiple testcases/ directories (source and output), or we'll have
>     to copy testcases/ from the source to the output on a normal build, which is
>     rather gross.  Or we'd need e.g. "make testcases", which is also gross, e.g.
>     I don't want to have to run yet more commands just to execute tests.
> 
>  2. Generating default.test could overwrite a user-defined file.  That's firmly
>     a user error, but at least if they default.test files are commited, the user
>     will get a hint or three that they're doing things wrong.
> 
>  3. If the files aren't committed, then they probably should removed on "clean",
>     which isn't the end of the world since they're trivially easy to generate,
>     but it's kinda funky. 
> 
> So, what if we add this to auto-generate the files?  It's obviously wasteful since
> the files will exist 99.9999999% of the time, but the overhead is completely
> negligible.  The only concern I have is if this will do the wrong thing for some
> build environments, i.e. shove the files in the wrong location.

We can get the current path of the Makefile.kvm by writing this at the top
of the Makefile.kvm:
	MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

Then MAKEFILE_DIR will have the source directory of Makfile.kvm and
testcase will be in the same directory.

With this we can modify the below foreach you wrote by prefixing
MAKEFILE_DIR to "testcases".

Does this alleviate concern regaring build environment?

> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index f62b0a5aba35..d94bb8330ad1 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -198,6 +198,13 @@ TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
>  TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH))
>  LIBKVM += $(LIBKVM_$(ARCH))
>  
> +$(foreach tc, $(TEST_PROGS), $(shell mkdir -p testcases/$(patsubst %.sh,%,$(tc))))
> +$(foreach tc, $(TEST_GEN_PROGS), $(shell mkdir -p testcases/$(tc)))
> +$(foreach tc, $(TEST_PROGS), \
> +  $(shell echo $(tc) > $(patsubst %.sh,testcases/%/default.test,$(tc))))
> +$(foreach tc, $(TEST_GEN_PROGS), \
> +  $(shell echo $(tc) > $(patsubst %,testcases/%/default.test,$(tc))))
> +

This looks good.

> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 1d41a046a7bf..550b7c2b4a0c 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -9,4 +9,5 @@
> >  !config
> >  !settings
> >  !Makefile
> > -!Makefile.kvm
> > \ No newline at end of file
> > +!Makefile.kvm
> > +!*.test
> 
> Let's keep the extension wildcards sorted alphabetically, i.e.:
> 
> # SPDX-License-Identifier: GPL-2.0-only
> *
> !/**/
> !*.c
> !*.h
> !*.py
> !*.S
> !*.sh
> !*.test
> !.gitignore
> !config
> !settings
> !Makefile
> !Makefile.kvm
> 

Okay.

> > diff --git a/tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test b/tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test
> > new file mode 100644
> > index 000000000000..5db8723f554f
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/testcases/aarch64/aarch32_id_regs/default.test
> > @@ -0,0 +1 @@
> > +./aarch64/aarch32_id_regs
> 
> I don't see any reason to make the paths directly consumable with a leading "./".
> Spoiler alert from the next patch: the location of the test executables needs to
> explicitly resolved by the test runner.

I will remove this.

