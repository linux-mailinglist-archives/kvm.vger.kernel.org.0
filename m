Return-Path: <kvm+bounces-29521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D809ACD8B
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03528B21DD7
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731851DE4CE;
	Wed, 23 Oct 2024 14:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LwTdGWse"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F9E1AA7B8
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729694444; cv=none; b=YdfrNX2Jrv7VPZ8+o6JiMbiDFnefHUR4VEOBvVsL7tHr/udstoVfXgPB7tPDvrXu8JBCJMsyVqEk0cgRZ/c6cLPOqL0o9n/oYgnEUlLf9XqvlfCX4OUBfNfqvk62x0p3Fxdoq65DP/WsnJCUH1r2SyjHaDcI/uG6giDxikWWzcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729694444; c=relaxed/simple;
	bh=rXSw6rl/FwxpR6S5sCi2ByVVB/wREw8k7WfMCp80FK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DMgysJq6S7QfURWYY0P0IVYsFobcPUtl19ytbwHN7oSooxnoHEw5rDQDd8npTYp30o669HxVLxHJnvuv7RYE2X2rTw1+yxRd+1rl0s+TaCzYRVdz1c5LO8ggRsYFIMKTZQU1ORaDF6a8q+ALGxplQYUN2o5MnUhdydkP+hAaC0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LwTdGWse; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso998483666b.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 07:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729694441; x=1730299241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQ4elgHTyflOH9Bv96H4ahOZ9KYE4KjTj/LIpTd+d0s=;
        b=LwTdGWseEPUy2q/kp06IPq7Qs5jWiN7xkY+6r9sIHakcgPNvBngyapuAp2V9UZhuBx
         LC1F7YgumEzLV+soqsDN4+jBdnUouReY/6w0DFylvjupsBfNz9yq73vCqvum/NzjuCG4
         GxfvJtraS5IGNvN98aUWtbDR/LAcEoPa47cBm2w+7pm/pH49KGLhMLTnP3akO4qyTMlJ
         Fwsb6zn8Am22Zz80Kj7GTDnW2RHdJmhoqO42MKsHFXgso9spGslHYeQyR147StXMfz65
         OKKEl53wHPFgYGhuKqDgn7OWbPkYQT4MdQ1V08UUaL0UdHXF8G+e4D4oXLQMv0Z7WNAo
         rg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729694441; x=1730299241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nQ4elgHTyflOH9Bv96H4ahOZ9KYE4KjTj/LIpTd+d0s=;
        b=MMhMbK8mvTK9A0TqAX4FF0xLVidVau0+WnIzxsfpJabJHJc9UHLh8NmwxxBmHuBE3Z
         u+tPWETkXfnCEtXaij6DdGG1p9fGVptZ/A0Ki/fvAXHrT65ahBHgsR/RKFInzCnOys3u
         d45IrsY3/WMV+0kEzZKYlaCvmOh9dXLIo/4N19DHS8dtgcG0H2usbfSgb7knn+TDWmGN
         EM1NupJDLSq0OBrkSZe6+CjiRc2jF2I//eGUEqffk6J2IC3MRQHHnrt6vd/ibI1YUNrO
         VyaxMd8wECTB0rdRF6xqAxDSy4u1yrvg8v+mZATkdRJyLl9HHt0Ox1De3KjsDUxEo73y
         cH6g==
X-Gm-Message-State: AOJu0YyjwrAGCe8zwNy0bIQ0c0AVbTUooySnWxRJNDKgHzvYyY0yR4Vj
	mlAVz067DZNxl0Udx6WNpIDD7ZLOBPN9qvT8rpuOl51XYGLZvZxB0d+qXLLVR/f9bYZbeLQ/JOM
	GdK+xUQMXLeVJm5vd8bMsnabik2N808Yj
X-Google-Smtp-Source: AGHT+IFoTYG8aNvvOAAPnxmacwy/akRQP7JIK+uMhuZfzdW+re4pMJ1TW9q7pv02Zp0yuLny4+v90aYo6ozMoQMRfls=
X-Received: by 2002:a17:907:1c17:b0:a99:5d4c:7177 with SMTP id
 a640c23a62f3a-a9abf84b9a1mr242863266b.6.1729694441027; Wed, 23 Oct 2024
 07:40:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240921100824.151761-1-jamestiotio@gmail.com> <20241023-13ecdc4f251cd2d070c9ee5e@orel>
In-Reply-To: <20241023-13ecdc4f251cd2d070c9ee5e@orel>
From: James R T <jamestiotio@gmail.com>
Date: Wed, 23 Oct 2024 22:40:03 +0800
Message-ID: <CAA_Li+u50w6bpjD=ppJaJY8i_i57drpDui-XQ_bMGAmZKuRZUQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v5 0/5] riscv: sbi: Add support to test HSM extension
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@rivosinc.com, 
	cade.richard@berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2024 at 10:23=E2=80=AFPM Andrew Jones <andrew.jones@linux.d=
ev> wrote:
>
> On Sat, Sep 21, 2024 at 06:08:18PM +0800, James Raphael Tiovalen wrote:
> > This patch series adds support for testing all 4 functions of the HSM
> > extension as defined in the RISC-V SBI specification. The first 4
> > patches add some helper routines to prepare for the HSM test, while
> > the last patch adds the actual test for the HSM extension.
>
> Hi James,
>
> Patch1 is now merged and I've applied patch2 to riscv/sbi[1]. I've also
> applied [2] and [3] to riscv/sbi so patches 3 and 4 of this series
> should no longer be necessary. Can you please rebase patch5 on
> riscv/sbi and repost?
>

Hi Andrew,

Sure, I will rebase patch 5 on the riscv/sbi branch and repost it.

Best regards,
James Raphael Tiovalen

> [1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi
> [2] https://lore.kernel.org/all/20241023131718.117452-4-andrew.jones@linu=
x.dev/
> [3] https://lore.kernel.org/all/20241023132130.118073-6-andrew.jones@linu=
x.dev/
>
> Thanks,
> drew
>
> >
> > v5:
> > - Addressed all of Andrew's comments.
> > - Added 2 new patches to clear on_cpu_info[cpu].func and to set the
> >   cpu_started mask, which are used to perform cleanup after running the
> >   HSM tests.
> > - Added some new tests to validate suspension on RV64 with the high
> >   bits set for suspend_type.
> > - Picked up the hartid_to_cpu rewrite patch from Andrew's branch.
> > - Moved the variables declared in riscv/sbi.c in patch 2 to group it
> >   together with the other HSM test variables declared in patch 5.
> >
> > v4:
> > - Addressed all of Andrew's comments.
> > - Included the 2 patches from Andrew's branch that refactored some
> >   functions.
> > - Added timers to all of the waiting activities in the HSM tests.
> >
> > v3:
> > - Addressed all of Andrew's comments.
> > - Split the report_prefix_pop patch into its own series.
> > - Added a new environment variable to specify the maximum number of
> >   CPUs supported by the SBI implementation.
> >
> > v2:
> > - Addressed all of Andrew's comments.
> > - Added a new patch to add helper routines to clear multiple prefixes.
> > - Reworked the approach to test the HSM extension by using cpumask and
> >   on-cpus.
> >
> > Andrew Jones (1):
> >   riscv: Rewrite hartid_to_cpu in assembly
> >
> > James Raphael Tiovalen (4):
> >   riscv: sbi: Provide entry point for HSM tests
> >   lib/on-cpus: Add helper method to clear the function from on_cpu_info
> >   riscv: Add helper method to set cpu started mask
> >   riscv: sbi: Add tests for HSM extension
> >
> >  riscv/Makefile          |   3 +-
> >  lib/riscv/asm/smp.h     |   2 +
> >  lib/on-cpus.h           |   1 +
> >  lib/on-cpus.c           |  11 +
> >  lib/riscv/asm-offsets.c |   5 +
> >  lib/riscv/setup.c       |  10 -
> >  lib/riscv/smp.c         |   8 +
> >  riscv/sbi-tests.h       |  10 +
> >  riscv/cstart.S          |  24 ++
> >  riscv/sbi-asm.S         |  71 +++++
> >  riscv/sbi.c             | 651 ++++++++++++++++++++++++++++++++++++++++
> >  11 files changed, 785 insertions(+), 11 deletions(-)
> >  create mode 100644 riscv/sbi-tests.h
> >  create mode 100644 riscv/sbi-asm.S
> >
> > --
> > 2.43.0
> >
> >
> > --
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv

