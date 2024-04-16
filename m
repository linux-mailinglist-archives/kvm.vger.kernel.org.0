Return-Path: <kvm+bounces-14774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDDC8A6DC3
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 712831F21711
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABCA12BF31;
	Tue, 16 Apr 2024 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VSReux3z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2164812CD9A
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713276856; cv=none; b=KQ2tx+fXDdj+WI6+yw40C+LMWqUyokSocUwNKkhbL+pyfZreOJ90yGPZgNM9IivXaf+oeXKFT9TaAS6HVQv0KilijR4RJjA5wHJERGzUjQD/JhOSEM1KVvQoYuJcdMwTDBw/pE3H5LSXiLZ3Z8SVx8MqTWFbjkKxRzQHL37Zn74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713276856; c=relaxed/simple;
	bh=GighecX6rJ6JGOzu012hm3KDptDvyF3+8HrWZca/Cdw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i40maAgbHUGr6q8j8xr5Goz8v1xIZ2cpJqcQ8t+HZDVhhA4jKUEU1sSHrpoqDGdzEw4mhJ1JGvGWRsR2QHC0gyxZ1Qod5cRjo1kjUTX34Q5Qcvxy5n+4dIAB8vUlFEp/0acBaHtpksSkjjOLRXSazAjjrKGTqtoi7/NH+cu6WEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VSReux3z; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61ae546adf3so19997427b3.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 07:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713276854; x=1713881654; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ej7OrjPhk0wiBBvEHsh0nsImorEq6ZSEKe27QquR0Zc=;
        b=VSReux3zLUC1JVT7Ezq05qrBtDbjvJZQ2mZOO/RfwJoRFElcKxW+/fVVnYBYtHrFt0
         CZdk2RuqQzNQBeIU96v3VpQioNsYOqZ8E99VcAC+uL/ssxvu4e0+ZNuMoRWH5dCO/q6j
         8Vi1SQHHr5Q/MFPSev0n6yCdjpRU1gl6ss+cc09gfB2REr4A4F5LHMScBEcC2dVyebNP
         6o2BQMh5mQiXZF+NFOqZIOvHB/1aCtFMOek++NaoYHuMcv03PFO2MFkgUmqWNc/fW7CV
         fZ3U8H/R0Y4FPCmObG3FQ6eca56/DUKJLp0GPySfo4wX4YRjwAPQ+OhQJrUL2eeJnTCu
         2jxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713276854; x=1713881654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ej7OrjPhk0wiBBvEHsh0nsImorEq6ZSEKe27QquR0Zc=;
        b=kmqKopaZA3wS4LY1phsJFNIw/3dwXX08eJWJaxCsC/4zy49vcxSQMm3DGgtGoAeqoM
         Blz+/z87S2IJ/eOivXNhslhNqtBMpxLW6PWyJGu0X2Nx8xG0DIsi09XMsSErD+W9brLE
         RM1VzRJxfBgUzdJSX4q+Mj0P9V/RKlnf2oxBMbBiKRl4bimBMOrjxN4MQ3GR3Cy6/s14
         6wu83OJ1qAssdMEcnRYymXMXXZnestMjsaHqLcsn8GpOeYkyy8nkO1I7sdIiKQpW3ysH
         qeSMkRRD2M6hbnFdGIJSAs4eR8p9nAGNZofB0E1tVsftm0vm/q8Dd1cn26PjOUn6Tm4P
         knCw==
X-Gm-Message-State: AOJu0YwM29d1JAXbD6NBThEhX7wJ5sUNP/+NvViOXrPhMjrfxw2UzU24
	HAbfWnQtnB3maRs9LVTS3JeMRCDIF4/sRc3FKvNYFyJwluTKtwbenHwBl6IljafxQxpuxfcGIfW
	ixA==
X-Google-Smtp-Source: AGHT+IGX4WQQofRidh27535sxjboLKWCgXSJQwteLrK+9nRUgo9xVzQYvNMfT/ffbh4/9ripwH/vsWBXyp8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e60e:0:b0:615:577e:6af with SMTP id
 p14-20020a0de60e000000b00615577e06afmr3022887ywe.0.1713276854162; Tue, 16 Apr
 2024 07:14:14 -0700 (PDT)
Date: Tue, 16 Apr 2024 07:14:12 -0700
In-Reply-To: <a8340038-5dd7-4bff-8ef2-1dbe48ceaf49@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240313125844.912415-1-kraxel@redhat.com> <171270475472.1589311.9359836741269321589.b4-ty@google.com>
 <afbe8c9a-19f9-42e8-a440-2e98271a4ce6@intel.com> <ZhlXzbL66Xzn2t_a@google.com>
 <627a61bf-de07-43a7-bb4a-9539673674b2@intel.com> <Zh1AjYMP-v1z3Xp2@google.com>
 <a8340038-5dd7-4bff-8ef2-1dbe48ceaf49@intel.com>
Message-ID: <Zh6HtE_NTOSjCwAx@google.com>
Subject: Re: [PATCH v4 0/2] kvm/cpuid: set proper GuestPhysBits in CPUID.0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 16, 2024, Xiaoyao Li wrote:
> On 4/15/2024 10:58 PM, Sean Christopherson wrote:
> > On Mon, Apr 15, 2024, Xiaoyao Li wrote:
> > > On 4/12/2024 11:48 PM, Sean Christopherson wrote:
> > > > On Fri, Apr 12, 2024, Xiaoyao Li wrote:
> > > > If we go deep enough, it becomes a functional problem.  It's not even _that_
> > > > ridiculous/contrived :-)
> > > > 
> > > > L1 KVM is still aware that the real MAXPHYADDR=52, and so there are no immediate
> > > > issues with reserved bits at that level.
> > > > 
> > > > But L1 userspace will unintentionally configure L2 with CPUID.0x8000_0008.EAX[7:0]=48,
> > > > and so L2 KVM will incorrectly think bits 51:48 are reserved.  If both L0 and L1
> > > > are using TDP, neither L0 nor L1 will intercept #PF.  And because L1 userspace
> > > > was told MAXPHYADDR=48, it won't know that KVM needs to be configured with
> > > > allow_smaller_maxphyaddr=true in order for the setup to function correctly.
> > > 
> > > In this case, a) L1 userspace was told by L1 KVM that MAXPHYADDR = 48 via
> > > KVM_GET_SUPPORTED_CPUID. But b) L1 userspace gets MAXPHYADDR = 52 by
> > > executing CPUID itself.
> > 
> > KVM can't assume userspace will do raw CPUID.
> 
> So the KVM ABI is that, KVM_GET_SUPPORTED_CPUID always reports the host's
> MAXPHYADDR,

Not precisely, because KVM will report a reduced value when something, e.g. MKTME,
is stealing physical address bits and KVM is using shadow paging.  I.e. when the
host's effective address width is also the guest's effective address width.

> if userspace wants to configure a smaller one than it for guest and expect it
> functioning, it needs to set kvm_intel.allower_smaller_maxphyaddr ?

Yep.  The interaction with allow_smaller_maxphyaddr is what I want to get "right",
in that I don't want KVM_GET_SUPPORTED_CPUID to report a MAXPHYADDR value that
won't work for KVM's default configuration.

