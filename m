Return-Path: <kvm+bounces-59658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9EAFBC6CC3
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 00:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADA8B1897B04
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 22:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C172C21CF;
	Wed,  8 Oct 2025 22:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p63Ul3tv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E149125782F
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 22:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759962752; cv=none; b=Dnk9pQofCad+HmeLkqrTrlCh2E7WyMbU80ZSFK6vWNroxSpsu+tIp+3nEj1ncNZfHWV+WrkbMB/A0yM3mkJU4w2H+TMzzDAcKYpnemmx1mMjpqxoVhSpBZkzaCh3+j3cMM9S3EhZqEli4kXPMazCaXmA1bTZHo8iTkD4opdPNmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759962752; c=relaxed/simple;
	bh=QLJvDD80Ts+jq/Te/fByXHFw2lX7qriJtxUTxcdfGYk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V3HxFaa4ifA0vkXo+NymNF6XwgjPbJS9iWYJncvDx9pU1WkjB5xuK5/PXTm4owHNOl5XvSlzHhMPOsAUmGsNhoaFGyssTuj2UgGL5rrR/NT+CBi2YOVQMkFLwDeZM3IXUQavNV1I1urF+VPRTW+oG2zrWF6bDnv4zwzmi80tL2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p63Ul3tv; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-635c9db8a16so437377d50.0
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 15:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759962750; x=1760567550; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQg/oGPX3QlPO44vwiPmFn7QHJjEMDGpRp1ZFhGCDj0=;
        b=p63Ul3tvVv7UXIhLQOrEO8Q+8x0ggDdXHHumYvlIk5LVRcGyaEwvb0cdCdRj9dTd79
         xbsmJKRhxeb/WxQAoiiqbhZx4+G0ZEnmL45MA0WsCnEThlskv668oE8OrIgOpV7NuxTd
         jSekOhApeJS2/kn/TnFQ85KWtemB+ptXyuh11P/V5QlgzG5CrcQws9H9g89c+fhCOQ2x
         18v5XsHEm7fkzaRQ5z7RIAuVGJZOZzn5KF+IaYWDFv+3XIRoKYmbF9FRfmfsokCrXw25
         GYqHEjKhyrdYMptloNaIkZpqlM+fUNqysJlNjJ4ALDi8GYeDAUjjYIie7hSBpy9Jw8Us
         ZTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759962750; x=1760567550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQg/oGPX3QlPO44vwiPmFn7QHJjEMDGpRp1ZFhGCDj0=;
        b=geGevDWXW+a3FdA43lHa3AItQm5wLY5WMRkqIR0+dzHUsGUUKi1aEHEtfJtcC/Gf75
         IeMkjwlfFR54FIiH13s0RIzV7rgzWQLnysuMqW9wuCd2BH2q0hSpfV+d0wkq3NIs6oWX
         4axhdJDoqqvohj70r8uf2FKu2U4kyIFht8j3PD6+n/4hxOR2g07aEFyfD09ybBakMPU1
         82oA1epwK4+PsJ5dWvctURH2h8FhQIHDVI7vzjrvmbd72L83sBUGwv4i1VdkawHT1iXw
         TmyqPZhMQmoXDmjfOWQ4cR2KNat+J6LZZtjXlkdR3sUEcNElSSc1F0FXYZ1sQOlQcs1B
         TFtA==
X-Forwarded-Encrypted: i=1; AJvYcCWO1IynuTC29eqYlDSd5KOXvV6gaCtxSiQYKUYBhVB5q4mUGLYLZ3ziZXXR6onuW8xlaZk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4ooluqJZnJhn2EDJZn7nHYKwuLSNPkHuc7faoUQo57wbNQra6
	mkYVm4lYaH4ZkTsW8bIStQq/qsquXUpudygeNkFmKCnFtWnx3RVImbD1rMG7RkfQoMSbUJFa2AC
	c/4eajI2VlG3r4PpyHikkRwdlRRQCmFNkIYQ66bVlycjAh8UeqLaXSTnJ
X-Gm-Gg: ASbGnct4dZYE7aomEcpQSvANbWQaMjeTuzld3GHIgcAharTZ4wtHjPjxX05QQnegfMk
	nqIiG1tbdPYXY7eXYvFRYv5/IPoER+iqMnpVrgxI3V2UlmbYtIQucBYaQ9UqW2KXjmdsikhFxUP
	YY2ZTQiXsg1rqDNsNpyZypFObVItwJkZrRyjeJyvzfBrf1MDSXcoYeck2RiWUvew/vgYrCh5MLB
	8x3BGpoe15z8hj8HQDOZurVeyhHrABzDzgp4/JcoLs26eGMvs8/ykAmTfNWHz2e/hPKYSQjc5EQ
	0Zg=
X-Google-Smtp-Source: AGHT+IHIwhJ1jTa6pSoNA6/xh10XCnJ12TGkOcCTYPDGo29d1Uylhw3j/X7DZaX30WkFO3YvYercS8T1QZ1hYdEvctA=
X-Received: by 2002:a05:690e:1551:20b0:635:4ecf:bdcc with SMTP id
 956f58d0204a3-63ccb964b4bmr4231044d50.46.1759962749615; Wed, 08 Oct 2025
 15:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250930172850.598938-1-jthoughton@google.com> <202510041919.LaZWBcDN-lkp@intel.com>
In-Reply-To: <202510041919.LaZWBcDN-lkp@intel.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 8 Oct 2025 15:31:53 -0700
X-Gm-Features: AS18NWACWefjyXnJ3mzO_5c1LrSHUfnzIGfip6tiGf7K_b7r41zRxk-Vv_BIoCI
Message-ID: <CADrL8HXOPOhWXa9o36m5wh-YJyVoMOXyj4R0_7EdUQ6nhJ-avQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: For manual-protect GET_DIRTY_LOG, do not hold
 slots lock
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, lkp@intel.com, oe-kbuild-all@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 6, 2025 at 12:33=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> Hi James,
>
> kernel test robot noticed the following build warnings:
>
> url:    https://github.com/intel-lab-lkp/linux/commits/James-Houghton/KVM=
-selftests-Add-parallel-KVM_GET_DIRTY_LOG-to-dirty_log_perf_test/20251001-0=
13306
> base:   a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
> patch link:    https://lore.kernel.org/r/20250930172850.598938-1-jthought=
on%40google.com
> patch subject: [PATCH 1/2] KVM: For manual-protect GET_DIRTY_LOG, do not =
hold slots lock
> config: x86_64-randconfig-161-20251004 (https://download.01.org/0day-ci/a=
rchive/20251004/202510041919.LaZWBcDN-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0=
227cb60147a26a1eeb4fb06e3b505e9c7261)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202510041919.LaZWBcDN-lkp@intel.com/
>
> New smatch warnings:
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:2290 kvm_get_dirty_log_protect(=
) error: uninitialized symbol 'flush'.
>
> vim +/flush +2290 arch/x86/kvm/../../../virt/kvm/kvm_main.c
>
> ba0513b5b8ffbcb virt/kvm/kvm_main.c    Mario Smarduch      2015-01-15  22=
55     n =3D kvm_dirty_bitmap_bytes(memslot);
> 82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  22=
56     if (!protect) {
> 2a31b9db153530d virt/kvm/kvm_main.c    Paolo Bonzini       2018-10-23  22=
57             /*
> 82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  22=
58              * Unlike kvm_get_dirty_log, we never flush, because no flus=
h is
> 82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  22=
59              * needed until KVM_CLEAR_DIRTY_LOG.  There is some code
> 82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  22=
60              * duplication between this function and kvm_get_dirty_log, =
but
> 82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  22=
61              * hopefully all architecture transition to
> 82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  22=
62              * kvm_get_dirty_log_protect and kvm_get_dirty_log can be
> 82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  22=
63              * eliminated.
> 2a31b9db153530d virt/kvm/kvm_main.c    Paolo Bonzini       2018-10-23  22=
64              */
> 2a31b9db153530d virt/kvm/kvm_main.c    Paolo Bonzini       2018-10-23  22=
65             dirty_bitmap_buffer =3D dirty_bitmap;
> 2a31b9db153530d virt/kvm/kvm_main.c    Paolo Bonzini       2018-10-23  22=
66     } else {
> 82fb1294f7ad3ee virt/kvm/kvm_main.c    James Houghton      2025-09-30  22=
67             bool flush;
>
> flush needs to be initialized to false.

I'll fix this and the other bug about not documenting the new
parameter, my mistake. :(

I think in a v2 I'll also merge kvm_get_dirty_log() into
kvm_get_dirty_log_protect(); might as well.

