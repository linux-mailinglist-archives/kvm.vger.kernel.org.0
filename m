Return-Path: <kvm+bounces-20576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B1B91995B
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 22:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9034EB24DDB
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 20:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE151940B5;
	Wed, 26 Jun 2024 20:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="3WE2z3Aa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123FB1940B7
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 20:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719434468; cv=none; b=QC8ad5xqDaM/iPqKegSsSEDr1tgPycO+APYCOVwPdLD9j9aLjg1qquq50ltmK0ncTs/1le5M/dzBHN7lhdjt7DIgpxY2q65QLqSvLK6AQu/AOUnrt78w3vjStEcrEg75tEwCYizJVBLytvlCgkWajI/TFXuZ0J0YvQXN4MPM5b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719434468; c=relaxed/simple;
	bh=qsh8GM7rmgPgv/T2+aRZxiz6dVPWlf2/jKN650uItuk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QsO9djfeNeCeGGNThe8mwknlwLHdhwmC71dcRGkFeN41w55bL127RVRKErzIasskgKz1VBd+Mm7mPHF31C8L8K6CXkNNUmSs1rQ7jcGGIWtWR1iuI0WH4Xc5EjvZrG++MaT/R30ch8ciUBlecdmVMW6MK1SR2V7R8bNKdIUj15o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=3WE2z3Aa; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52db1a5b3f8so1031496e87.1
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 13:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1719434463; x=1720039263; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GvqpZm+deOZ11Eji88xBj8E0l9mzRvWeVq0FD6NU9YA=;
        b=3WE2z3AajBs9zKwvfvMxQvxqRbk2iQFzx2E1ld5vv4GmtehXa6s+1L+O2x1nrt85Hn
         fs71lX0bfQ2eNkNVp/pVb+9A+DBetmHMj4Horfb8/hc2VHPe8cR93I3FMnW34WIcZJLs
         sFyOLDHbeF3Ay5mYJpd2WdxUzSA/kQdKELJBg0yrmb+Vd8Vri/K8AR+0bXab0vZCVLXb
         VknWqhEuDhPehm84F8Uj773Clp7SY+B/SiU1IY5eASMxyTCsyL+UmiCRgs/PS4nqsRnJ
         O798Bd/QsvroD0ijda5MPHN+VX8+mn8LvGKepBowaJENmBAHUub4t/JXJ+pSvng9vyJw
         M5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719434463; x=1720039263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GvqpZm+deOZ11Eji88xBj8E0l9mzRvWeVq0FD6NU9YA=;
        b=RIW2xh6Dq+VPxjmyBDxWfqTHVXQpEPhmzVQFO1mgfToxMhPiDaUq/LyPghTXBhZrNN
         hUI4vVOPPqSmxoMGlAjJYqChkxba4omnGpctSsvgOJk5VPYihR371WlUT196drKG0bRW
         JhsXi5F7kuEDSDMnKsUfkisURxuAAS+D/Mzc9p6Q8nyDn93bUq2KZq9HfnPgNl1v5yMi
         gzYKJ/ehgIccms1pnSDP11asOHXjZTHLA0mphtqxBWo6RH8j9Of/uedlYrUTa9SStX7D
         Q5sZ6io/tbXXsCwqUKAB66mvg6PMvNua4UzllnHSFxaIFByq47XUH0wwDFVffOY0Ok2p
         gpNQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+UTQOxK0dGkCvrVCHOsIG7eALljxSL/+2WlQGzntQcKFzy/gzX5rjsd4YojcWNWsZK+HhwCYLchTJX/6JVDuv4czz
X-Gm-Message-State: AOJu0YyqP7IO8MoPSvGEFaHHuUE2N4Ew/xXc2pV7reSWS0JgpnZpHnST
	YXjXKK89GkMoKYBwW9t+lH+P3cGrYCw9QdKn9zfP2IEGYY1IagaFsjmLHYEr1t0GU6JR5USQXLI
	sYQn8yaNCDHi9soHVmPzG2imp9SmwMQdJPzSmeg==
X-Google-Smtp-Source: AGHT+IENbv1JB8KrYfz9k4cJJbNQpQvc3N1XgF/oP1hbnTMuUKfGE8n6eqcvVdPstQafQqQTqXppzX65dn8nHDLTa8k=
X-Received: by 2002:a05:6512:a90:b0:52c:c4b3:7e95 with SMTP id
 2adb3069b0e04-52e7038ba94mr23119e87.18.1719434463152; Wed, 26 Jun 2024
 13:41:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com>
 <20240626-misc_perf_fixes-v3-2-de3f8ed88dab@rivosinc.com> <96ff4dd2-db66-4653-80e9-97d4f1381581@sifive.com>
 <CAHBxVyHx9hTRPosizV_yn6DUZi-MTNTrAbJdkV3049D-qsDHcw@mail.gmail.com>
 <20240626-eraser-unselect-99e68a1f5a3e@spud> <20240626-spyglass-clutter-4ff4d7b26dd4@spud>
In-Reply-To: <20240626-spyglass-clutter-4ff4d7b26dd4@spud>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Wed, 26 Jun 2024 13:40:52 -0700
Message-ID: <CAHBxVyEg2uKKdikXib77JDmCKs8qDGJHvj3stsFgCgO0U9omRg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] drivers/perf: riscv: Reset the counter to hpmevent
 mapping while starting cpus
To: Conor Dooley <conor@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Conor Dooley <conor.dooley@microchip.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2024 at 9:39=E2=80=AFAM Conor Dooley <conor@kernel.org> wro=
te:
>
> On Wed, Jun 26, 2024 at 05:37:07PM +0100, Conor Dooley wrote:
> > On Wed, Jun 26, 2024 at 09:18:46AM -0700, Atish Kumar Patra wrote:
> > > On Wed, Jun 26, 2024 at 6:24=E2=80=AFAM Samuel Holland
> > > <samuel.holland@sifive.com> wrote:
> > > >
> > > > On 2024-06-26 2:23 AM, Atish Patra wrote:
> > > > > From: Samuel Holland <samuel.holland@sifive.com>
> > > > >
> > > > > Currently, we stop all the counters while a new cpu is brought on=
line.
> > > > > However, the hpmevent to counter mappings are not reset. The firm=
ware may
> > > > > have some stale encoding in their mapping structure which may lea=
d to
> > > > > undesirable results. We have not encountered such scenario though=
.
> > > > >
> > > >
> > > > This needs:
> > > >
> > > > Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> > > >
> > >
> > > Oops. Sorry I missed that.
> > >
> > > @Alexandre Ghiti
> >
> > What's Alex going to be able to do?
> >

He is collecting the fixes patches in the RISC-V tree and pinged for
revision for this patch last week.

> > > @Palmer Dabbelt : Can you add that while picking up
> > > the patch or should I respin a v4 ?
> >
> > b4 should pick the signoff up though. "perf: RISC-V: Check standard
> > event availability" seems to be missing your signoff though...
>
> Huh, this doesn't really make sense. I meant:
>         b4 should pick the signoff up, though "perf: RISC-V: Check standa=
rd
>         event availability" seems to be missing your signoff...

Strange. I modified and sent the patch using b4 as well. It's missing
my sign off too.

