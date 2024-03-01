Return-Path: <kvm+bounces-10680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C5FB86E95F
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 20:20:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40D79286C94
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 19:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFD03AC26;
	Fri,  1 Mar 2024 19:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="lktGmRmB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [83.166.143.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DC739FF2
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 19:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709320813; cv=none; b=UPXNdF8EBNUlTsrmLfcwbMSj+dk7VzaYRQ6TCeAvcXxylufg2bGQaNnHZmMat7ODuzAoxs3wBMUAT+T1N98vH4Xr1AIB72v4i+Asif7MrxdtS7qnXrRq5Hoqcb9WS1Vnk1p55CQYRoFGiD4MgQ0dxO5kVrF4pxbjLRXOOuW+P8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709320813; c=relaxed/simple;
	bh=Swe/Qd9r++tAyJ9RTTXIMVdtbl0ZRCkDiMrhyMl4Y/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dA+Q50CC0zlsIs8nPAK0QVzdEuRw5YZelNEOgPubV4E3PbiLX5Bvtg7+E8i2LBtZ0g1YGLWgExOc5+PD9tWHucTXF4NZaSqU4lgb63FiWDOM/Ay/Up8wQ5rhZHYgTlYN7/G1bAxDSbplekzeTYh7dE66qtOteBmjuZOcOkjbjGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=lktGmRmB; arc=none smtp.client-ip=83.166.143.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TmdFs5ByrzWxc;
	Fri,  1 Mar 2024 20:20:01 +0100 (CET)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4TmdFr4x9XzMpnPn;
	Fri,  1 Mar 2024 20:20:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1709320801;
	bh=Swe/Qd9r++tAyJ9RTTXIMVdtbl0ZRCkDiMrhyMl4Y/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lktGmRmB5jUGmygRJXVx3w6EV3a0DZTb+fL0YMAQUVn6UY6tLSvUrsV71IIHpR5FX
	 qxh1iOBsRbD0j1QUslG9mjhRqgyWekJAvJVhwQjiv4OwW3RsUNfZ9wKQ7O5bHGYTk/
	 KGCYwD0LX3vUL7eYRcXxxH0H8C7z9+3+g9HzC8Tw=
Date: Fri, 1 Mar 2024 20:19:50 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: David Gow <davidgow@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>, 
	Kees Cook <keescook@chromium.org>, Rae Moar <rmoar@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Alan Maguire <alan.maguire@oracle.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morris <jamorris@linux.microsoft.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Marco Pagani <marpagan@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Thara Gopinath <tgopinath@microsoft.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-um@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH v1 0/8] Run KUnit tests late and handle faults
Message-ID: <20240301.gaiWei9eng4u@digikod.net>
References: <20240229170409.365386-1-mic@digikod.net>
 <CABVgOSnTfUBWcX4o68ZoZC+vZSEzUp=UikQM5M70ECyS44GfNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABVgOSnTfUBWcX4o68ZoZC+vZSEzUp=UikQM5M70ECyS44GfNQ@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Fri, Mar 01, 2024 at 03:15:08PM +0800, David Gow wrote:
> On Fri, 1 Mar 2024 at 01:04, Mickaël Salaün <mic@digikod.net> wrote:
> >
> > Hi,
> >
> 
> Thanks very much. I think there's a lot going on in this series, and
> it'd probably be easier to address if it were broken up a bit more.
> 
> To take things one at a time:
> 
> > This patch series moves KUnit test execution at the very end of kernel
> > initialization, just before launching the init process.  This opens the
> > way to test any kernel code in its normal state (i.e. fully
> > initialized).
> 
> I like the general idea here, but there are a few things to keep in mind:
> - We can already do this with tests built as modules.
> - We have explicit support for testing __init code, so if we want to
> keep that (and I think we do), we'll need to make sure that there
> remains a way to run tests before __init.
> - Behaviour changes here will need to be documented and tested well
> across all tests and architectures, so it's not something I'd want to
> land quickly.
> - The requirement to have a root filesystem set up is another thing
> we'll want to handle carefully.
> - As-is, the patch seems to break arm64.

Fair, I'll remove this patch from the next series.

> 
> >
> > This patch series also teaches KUnit to handle kthread faults as errors,
> > and it brings a few related fixes and improvements.
> 
> These seem very good overall. I want to look at the last location
> stuff in a bit more detail, but otherwise this is okay.

Thanks!

> 
> Personally, I'd like to see this split out into a separate series,
> partly because I don't want to delay it while we sort the other parts
> of this series out, and partly because I have some other changes to
> the thread context stuff I think we need to make.

I'll do that today.

> 
> >
> > New tests check NULL pointer dereference and read-only memory, which
> > wasn't possible before.
> 
> These look interesting, but I don't like that they are listed as x86-specific.

I was reluctant to make it more broadly available because I only tested
on x86...

> 
> >
> > This is useful to test current kernel self-protection mechanisms or
> > future ones such as Heki: https://github.com/heki-linux
> >
> > Regards,
> 
> Thanks again. I'll do a more detailed review of the individual patches
> next week, but I'm excited to see this overall.

Good, you'll review the v2 then.

> 
> Cheers,
> -- David
> 
> 
> >
> > Mickaël Salaün (8):
> >   kunit: Run tests when the kernel is fully setup
> >   kunit: Handle thread creation error
> >   kunit: Fix kthread reference
> >   kunit: Fix timeout message
> >   kunit: Handle test faults
> >   kunit: Fix KUNIT_SUCCESS() calls in iov_iter tests
> >   kunit: Print last test location on fault
> >   kunit: Add tests for faults
> >
> >  include/kunit/test.h                |  24 +++++-
> >  include/kunit/try-catch.h           |   3 -
> >  init/main.c                         |   4 +-
> >  lib/bitfield_kunit.c                |   8 +-
> >  lib/checksum_kunit.c                |   2 +-
> >  lib/kunit/executor.c                |  81 ++++++++++++++------
> >  lib/kunit/kunit-example-test.c      |   6 +-
> >  lib/kunit/kunit-test.c              | 115 +++++++++++++++++++++++++++-
> >  lib/kunit/try-catch.c               |  33 +++++---
> >  lib/kunit_iov_iter.c                |  70 ++++++++---------
> >  tools/testing/kunit/kunit_kernel.py |   6 +-
> >  11 files changed, 261 insertions(+), 91 deletions(-)
> >
> >
> > base-commit: d206a76d7d2726f3b096037f2079ce0bd3ba329b
> > --
> > 2.44.0
> >



