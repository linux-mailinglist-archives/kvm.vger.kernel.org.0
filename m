Return-Path: <kvm+bounces-51042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E05A7AEC635
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 11:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4AA75600BC
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 09:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3905722618F;
	Sat, 28 Jun 2025 09:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LVitHtmN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2D41EDA3C
	for <kvm@vger.kernel.org>; Sat, 28 Jun 2025 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751101900; cv=none; b=pt5yvMGKiyffL31ZJcRYDuvdLR08xVi6HmSUOVimtmqsiLC9akEAJdwokFMXwSfxdVSk/op94vg11HO7DW8mUvbWYJJa15Hxty4LAG+aJBu0uZJgyp7jGBJXjE3xq7sakPLX9TuMlWYXf8zyMbNLTymkgY+VA9KqSvNdv+H56nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751101900; c=relaxed/simple;
	bh=KfPm4wm3PtMlCWOzis/9i8PJfSdakpRDxZoXRQL7/lM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LmniWNvW8D56nZfKGFHX1sIIdLfy7huheGLAppCaKJf+VPjoQcCg8Qz3ajQ9sao93lM4SZdD3Yx6DqcbfW1oWya+56gLKXJMXIQgRfyGZSqcNqvO6UyzIyBxhx1VxjiMmUStJwduBLS5OlHIG9+NUJRL1MIPtwcik+PBCdFrVcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LVitHtmN; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a4f379662cso449077f8f.0
        for <kvm@vger.kernel.org>; Sat, 28 Jun 2025 02:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1751101895; x=1751706695; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7FcA6TIn+EjFxyCRTXdDsd/VPb9sZm58PfnwqNwHunQ=;
        b=LVitHtmNGUMoh00oVhED4VGXXfNLMLGwsj5OBAgV1DvMPPIzF5iDMGGB6uIQcjEx9S
         7LcOAqkoFU+TuYlfO16hX30W4CWiAD7+/Y6rsmZbdOk6dSxZ0jb8Ep86aZsmIhniMrw2
         mNrOwJ5P5yU/qS7qLscV4X2yKdh9TuzrrGujAl7QRNKaapIhpftMvrZkLZC6wW6+nuCk
         PnAGSh2ifT+nTC4u/Q+s4rjSSTjLNq76tR+m7WsH049LVM/s/jYT3FBIyuLtFf+tEu+t
         Zzsi+1sV/3EOR/g/B5PJ9HGMZONea8eEjHpJXMPmmvQwWZ4+vhSMcSSBeBq2phmC+axB
         C2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751101895; x=1751706695;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7FcA6TIn+EjFxyCRTXdDsd/VPb9sZm58PfnwqNwHunQ=;
        b=RioagarM9LsTsaev1M2duFvA2o0dlQ76fQIk8k3Xwefa4qONJ+KGbIkkZzgQoA44gO
         PfbH18SBATe74yxFhVcwEeOrWxrMuJxgRCaYAladwarBwq5N1P2dtRUUVlYxmxcXuDLc
         AknJG9K5r8gPsevMrduQMQubaFbuUO7Cahy5ClgV95xHllOwRJt9H0iSdHJ4mh1JR3Pm
         cwWtmdLSp/9PaXJ3RQdMPT9tbdOlbdFBoO7DYQ19+XANK7VJ/RcsCjq+gTnfCsPzSN8n
         Rsd3MNPkrd38SA/JFWs+DeKmE1Htg7PMmYAyBzvsnkvPgDbWFL15AZ6z39vO5exHT0NI
         shrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3lbq4ppvQAtPJxRp0H9VxV+pgKxcubhhxgofD0anoBbF0+A7bzql/5gssgYcQ44xbVRU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxKMHjSyvXzmO49Oi+cEXrc/G6ZSyXVQ0QypmwztwxM+tzhu8D
	lPCphPO9qEq0f7U4iop8VolI5aqgBJ+cXYUOz06GVoYGO8V2dcZTCBcuYJ25wNRcuF4=
X-Gm-Gg: ASbGnctfCQ6zUNF60RE51eC257Q9tiTtTW7V9W90E4yJKt7R1Gv+PHi4IcV7oot8Mmy
	Qzp5QQtt4isMjUNegEZTNScfOxdjKZEC6uTtjcJkdOrXNchP4MXenASJlSu2WuZj3ijt+IsFJ4Z
	Z3TYwMCFrMrhoJaVFBYy/flY/c5/e+3wXQnY+VPtKDLx1Zj82+EM2slPDq6mBJER/A/S1/mj7sM
	GstLH6b7pvi/5+P6Zc2OLGZP/AzB4nl+xtB9wbo82GKccmwwfgRf4fOcyMMKGprvwtZ3rhyPx02
	a1GWCBKyLZiorutf9S8yZsR6hNXBF+eyP4V5Q3UcnhC+wdtOMCYWB7h5TD/VPUbDZx9IWg1TbW5
	2YTNm/oDUR0aclM0=
X-Google-Smtp-Source: AGHT+IEieK15RRdhkv3VLcBWkDEEYiMW0pWKIu4xrmAZJSQy94UpJqgpyFEJrxtpPSx+ZFMLNkTO+w==
X-Received: by 2002:a05:6000:64b:b0:3a6:d5fd:4687 with SMTP id ffacd0b85a97d-3a8f482bd31mr5409951f8f.18.1751101894480;
        Sat, 28 Jun 2025 02:11:34 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e62211sm4876004f8f.99.2025.06.28.02.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jun 2025 02:11:33 -0700 (PDT)
Date: Sat, 28 Jun 2025 11:11:32 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Jesse Taube <jesse@rivosinc.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Atish Patra <atish.patra@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Himanshu Chauhan <hchauhan@ventanamicro.com>, Charlie Jenkins <charlie@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v6] riscv: sbi: Add SBI Debug Triggers
 Extension tests
Message-ID: <20250628-c9c23ff68a38206820e40b51@orel>
References: <20250618154452.2136345-1-jesse@rivosinc.com>
 <20250627-c6a984395c94f8281954ab21@orel>
 <CALSpo=bFJyf+Y1w-a7U++Zx_yCH8h6nP7dToAPBGPnYciHbVkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALSpo=bFJyf+Y1w-a7U++Zx_yCH8h6nP7dToAPBGPnYciHbVkQ@mail.gmail.com>

On Fri, Jun 27, 2025 at 12:06:02PM -0700, Jesse Taube wrote:
> On Fri, Jun 27, 2025 at 6:02 AM Andrew Jones <andrew.jones@linux.dev> wrote:
> >
> > On Wed, Jun 18, 2025 at 08:44:52AM -0700, Jesse Taube wrote:
...
> > > +     report(shmem->data.tdata1 == tdata1, "tdata1 expected: 0x%016lx", tdata1);
> > > +     report_info("tdata1 found: 0x%016lx", shmem->data.tdata1);
> > > +     report(shmem->data.tdata2 == ((unsigned long)&test), "tdata2 expected: 0x%016lx",
> > > +            (unsigned long)&test);
> > > +     report_info("tdata2 found: 0x%016lx", shmem->data.tdata2);
> > > +     report(shmem->data.tstate == tstatus_expected, "tstate expected: 0x%016lx", tstatus_expected);
> > > +     report_info("tstate found: 0x%016lx", shmem->data.tstate);
> >
> > These don't need to be split into report/report_info pairs because the
> > report is checking for a specific value. We only split when report is
> > checking for some nonzero value and we also want to output what that
> > specific value was for informational purposes.
> 
> I'm a bit confused. Should it only report_info when the test fails?
> 

Usually, and that's what we do in sbiret_report().

I haven't been very good at describing my idea about this nor really
implementing it consistently throughout the framework. The idea is
that when platform specific or SBI implementation specific values are
involved that we should avoid putting them in report() strings in order
to ensure we can capture output from a successful run, where INFO lines
have been filtered out, and then subsequent runs can have their filtered
output directly diffed with that originally captured output, even if we
run on another platform / SBI implementation. I don't think we can achieve
that right now, but I try to keep it in mind when reviewing to avoid
making things worse. Besides the sbiret_report() approach we can also
always output values with report_info if that information may be useful,
i.e.

  report(check(value), "no values output here");
  report_info("value is %d");

or, with an expected value output

  expected = getenv("SOME_VAR");
  if (!report(value == expected, "value matches expectation (%d)", expected))
     report_info("value is %d");

The second approach won't allow diffing output captures arbitrarily, but
should still allow diffing for targets with the same configurations,
described by the environment variables, allowing the report lines to
contain more information.

Looking at your use above again, then, assuming the expected value is
something we want to always output, like in the environment variable
example, I guess there's nothing wrong with it. We could just avoid
the info lines on success with the if (!report(... guarding them.

...
> > > +void check_dbtr(void)
> > > +{
> > > +     static struct sbi_dbtr_shmem_entry shmem[RV_MAX_TRIGGERS] = {};
> > > +     unsigned long num_trigs;
> > > +     enum McontrolType trig_type;
> > > +     struct sbiret ret;
> > > +
> > > +     report_prefix_push("dbtr");
> > > +
> > > +     if (!sbi_probe(SBI_EXT_DBTR)) {
> > > +             report_skip("extension not available");
> > > +             report_prefix_pop();
> > > +             return;
> >
> > Could rename the 'error' label to something else and goto it from here
> > too.
> 
> Is `dtbr_exit_test` ok?

Sure, or even just exit_test, since this is a dbtr-only function.

Thanks,
drew

