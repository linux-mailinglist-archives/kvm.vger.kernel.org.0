Return-Path: <kvm+bounces-31974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3EB99CF6EA
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 22:18:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07607B2E352
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 21:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DD71E2310;
	Fri, 15 Nov 2024 21:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gK7bl69G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B28B18B463
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 21:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731705330; cv=none; b=W7R0IRIqdqdJUf4R7ramrwqURk1VWq5QWofYH+un7zY1IJdHdIN93F9SdHO0QLqjW0m671ffkpiCSD5NWBSypsGqd3SVcI1xPqhcx90tIr1neoRE8UIg2ijE3Dy+L6cXnChNdavqH3x3pEfLDSgT+Q0hPeqJjBGnF1fzGfMV51Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731705330; c=relaxed/simple;
	bh=trwmvmbAnZgaQ6EZSEOh8Une0rIcrMhZwDzqFcj8pxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqMfDGvsNb2gcNVisYs/nqbXCunS6j7lfOiqi/LY52+VJG2DCTjypMWtd9MEULQjRk820H9dBS6K68RsUpcwc2yzgX8jHsG6yQubIVJFUYDK4ht/Wj35+XSvobGYvcVuyI7FyalTW4fAe5qCZxrEx+bZVnxeHrLULDFCSFbblc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gK7bl69G; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20ca4877690so2715ad.1
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 13:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731705328; x=1732310128; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nM0MnCaJJLmdERpqY9PV6u9+AmwEyhjWFW3qkZDsAPA=;
        b=gK7bl69GId3r0X7PUijoBLLiddfYPjpJU8MqocSjDPGFFkNCq793cCVxJxT7OQgxWO
         SfP14NPt79PsC4pPH1CObk0+LCVKifzrQ+I0A3iD//0H19WaTVOz5h8Di1r9KVGJ9JxJ
         SijKzQla+EAdpz3qKcbU4m0NzL+8qLiOs0wUEw06WrdUZ4ZJunmCPcctx1FEzL4ymZAU
         o92gtkg5rz6WnRAo2ulCXFaobXyXA9A06HCjS8HyVGpOSj1teOeV2Pn3v0NO/wKN1G37
         4vloJpJjR2XRy40Ml4THqdunhA4KPgiofMEXKN30e1SpME3w2+M8l2xGfNxqaTtHvjdM
         EEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731705328; x=1732310128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nM0MnCaJJLmdERpqY9PV6u9+AmwEyhjWFW3qkZDsAPA=;
        b=n4GtxNPaWKBf0O9SwS6rSsjnL6kl9zJ4WrBHz8XfkVii5Rzruvu545WYDBQnMG26Gu
         4syrYmo1vXZz9P9C5+naZgaVDTVb0Q044nigWdABXFL4KWC6AH5TIwT431xBH4DN8zTg
         WaZ9AUyKzxJNgDPGNYfSLaXLGHRAt76tNcSQ8XfSTKfPnXcbL3eEY6aO0j8Pstj1zwBm
         OzfV9+gijcBDCCHqYL2HuMe5bQjegpN9zPN4vO4OrE95AMzVO8OsjLQRVdr+6gjYuaGs
         7/sPSMGz6OsAeKn5fAnPrpLJcRdyDvg2lX234Gk37NaHO3WVV+f3pHwNg8RWWpuMZaOX
         kfQA==
X-Forwarded-Encrypted: i=1; AJvYcCXbm/e2qwBMKY5RZFP1+37p4t7GfsMBsJy6AGgTsbGCD2kP7Y0SmQ7MOcBC1nNf+XrGMEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrQUG7R0VGzzz1JMK+qW5XpdQqZdsB/VeFrKKyTEDbCS7Uz4Ru
	Q+tOxwJpqWX0YbMTp2OaO90ZYQxCr0sp09ThGNTWR1zujRjL7QzpyQoohH8pzg==
X-Gm-Gg: ASbGncsIPTz2jYvSLdpuO7zZyjN8yD+wD4TZFHTU+UWcZKFF8I9VwUQe6xzjpVZO7Wj
	EQjfsBcfuq3cOZJw7nUiKPGw50AGUzsMIJhKUtL6y37+sj7Ol6b/kkvdu5wxQYCV5awFpUye4pP
	bSPpXhPpZAcogje313+v5CZGIewkEnNGjS9zs9746l63RJql2DOL98f0tgrcrLUeQsY9P4yGWTX
	Ulwp/CAcMXV5WNqkCQ/MJqVsfDQNkW81W4Xonzyo37LjOA69+lnMiolbFLiOmhiNzugpOAQrYU3
	VvFseH9D
X-Google-Smtp-Source: AGHT+IG54m6rEFmImb5DSUuRdJgzvPLf5+rPUGSAVLO9hy0QHwDB3d2opaLJ5cQwhz6bZyjkGDS1Kw==
X-Received: by 2002:a17:902:f68d:b0:206:a87c:2873 with SMTP id d9443c01a7336-211ee1f5f05mr310055ad.5.1731705327532;
        Fri, 15 Nov 2024 13:15:27 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f8c1c2deb3sm1746337a12.23.2024.11.15.13.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:15:26 -0800 (PST)
Date: Fri, 15 Nov 2024 13:15:23 -0800
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Anup Patel <anup@brainfault.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] KVM selftests runner for running more than just
 default
Message-ID: <20241115211523.GB599524.vipinsh@google.com>
References: <20240821223012.3757828-1-vipinsh@google.com>
 <CAHVum0eSxCTAme8=oV9a=cVaJ9Jzu3-W-3vgbubVZ2qAWVjfJA@mail.gmail.com>
 <CAHVum0fWJW7V5ijtPcXQAtPSdoQSKjzYwMJ-XCRH2_sKs=Kg7g@mail.gmail.com>
 <ZyuiH_CVQqJUoSB-@google.com>
 <20241108-eaacad12f1eef31481cf0c6c@orel>
 <ZzY2iAqNfeiiIGys@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzY2iAqNfeiiIGys@google.com>

On 2024-11-14 09:42:32, Sean Christopherson wrote:
> On Fri, Nov 08, 2024, Andrew Jones wrote:
> > On Wed, Nov 06, 2024 at 09:06:39AM -0800, Sean Christopherson wrote:
> > > On Fri, Nov 01, 2024, Vipin Sharma wrote:
> > > > Phase 3: Provide collection of interesting configurations
> > > > 
> > > > Specific individual constructs can be combined in a meaningful way to
> > > > provide interesting configurations to run on a platform. For example,
> > > > user doesn't need to specify each individual configuration instead,
> > > > some prebuilt configurations can be exposed like
> > > > --stress_test_shadow_mmu, --test_basic_nested
> > > 
> > > IMO, this shouldn't be baked into the runner, i.e. should not surface as dedicated
> > > command line options.  Users shouldn't need to modify the runner just to bring
> > > their own configuration.  I also think configurations should be discoverable,
> > > e.g. not hardcoded like KUT's unittest.cfg.  A very real problem with KUT's
> > > approach is that testing different combinations is frustratingly difficult,
> > > because running a testcase with different configuration requires modifying a file
> > > that is tracked by git.

I was thinking of folks who send upstream patches, they might not have
interesting configurations to run to test. If we don't provide an option
then they might not be able to test different scenarios.

I do agree command line option might not be a great choice here, we
should keep them granular.

What if there is a shell script which has some runner commands with
different combinations? There should be a default configuration provided
to ease testing of patches for folks who might not be aware of the
configurations which maintainers generally use.

End goal is to provide good confidence to the patch submitter that they have
done good testing.

> > 
> > We have support in KUT for environment variables (which are stored in an
> > initrd). The feature hasn't been used too much, but x86 applies it to
> > configuration parameters needed to execute tests from grub, arm uses it
> > for an errata framework allowing tests to run on kernels which may not
> > include fixes to host-crashing bugs, and riscv is using them quite a bit
> > for providing test parameters and test expected results in order to allow
> > SBI tests to be run on a variety of SBI implementations. The environment
> > variables are provided in a text file which is not tracked by git. kvm
> > selftests can obviously also use environment variables by simply sourcing
> > them first in wrapper scripts for the tests.
> 
> Oh hell no! :-)
> 
> For reproducibility, transparency, determinism, environment variables are pure
> evil.  I don't want to discover that I wasn't actually testing what I thought I
> was testing because I forgot to set/purge an environment variable.  Ditto for
> trying to reproduce a failure reported by someone.
> 
> KUT's usage to adjust to the *system* environment is somewhat understandable
> But for KVM selftests, there should be absolutely zero reason to need to fall
> back to environment variables.  Unlike KUT, which can run in a fairly large variety
> of environments, e.g. bare metal vs. virtual, different VMMs, different firmware,
> etc., KVM selftests effectively support exactly one environment.
> 
> And unlike KUT, KVM selftests are tightly coupled to the kernel.  Yes, it's very
> possible to run selftests against different kernels, but I don't think we should
> go out of our way to support such usage.  And if an environment needs to skip a
> test, it should be super easy to do so if we decouple the test configuration
> inputs from the test runner.

Also, keeping things out of tree won't help other developers much. I want
majority of that configurations which maintainers/regular contributors
maintain locally to be upstreamed and consolidated.

> 
> > > There are underlying issues with KUT that essentially necessitate that approach,
> > > e.g. x86 has several testcases that fail if run without the exact right config.
> > > But that's just another reason to NOT follow KUT's pattern, e.g. to force us to
> > > write robust tests.
> > > 
> > > E.g. instead of per-config command line options, let the user specify a file,
> > > and/or a directory (using a well known filename pattern to detect configs).
> > 
> > Could also use an environment variable to specify a file which contains
> > a config in a test-specific format if parsing environment variables is
> > insufficient or awkward for configuring a test.
> 
> There's no reason to use a environment variable for this.  If we want to support
> "advanced" setup via a test configuration, then that can simply go in configuration
> file that's passed to the runner.

Can you guys specify What does this test configuration file/directory
will look like? Also, is it gonna be a one file for one test? This might
become ugly soon.

This brings the question on how to handle the test execution when we are using
different command line parameters for individual tests which need some
specific environmnet?

Some parameters will need a very specific module or sysfs setting which
might conflict with other tests. This is why I had "test_suite" in my
json, which can provide some module, sysfs, or other host settings. But
this also added cost of duplicating tests for each/few suites.

I guess the shell script I talked about few paragraphs above, can have
some specific runner invocations which will set specific requirements of
the test and execute that specific test (RFC runner has the capabilty to execute
specific test).

Open to suggestions on a better approach.


