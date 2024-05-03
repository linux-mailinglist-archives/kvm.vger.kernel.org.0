Return-Path: <kvm+bounces-16549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41F4A8BB663
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBEDC283218
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622E056750;
	Fri,  3 May 2024 21:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AX7jmaB+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3756854BD8
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 21:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714772847; cv=none; b=vCJ5eqcxectExkPmV+6xWTRv1V8alOAKCQP4wTU+JKHRUwBiPn+diWegNSEWZX2muQcUWLv9/ePe9F/gEU3l1O+9bLiaI4fo1gF8ib/FoYJ62YgvpWZTstbVyk3TqsLkUs6BwcXL0cshyppZIqqqH7Tb4TJUoXE6Ta9wOxVvcHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714772847; c=relaxed/simple;
	bh=7vIHot/zZ5cFNzfgHcYFZ0omvFDlKOCx44Kmqgg9rKc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YQoaU8ctjnHOgNo81zYrI/esse4Xnyl74Kn5Xcxdh8Iy+Ju/7eUc2J0v5z8nCYjJGEJI5AS44k0HNrfsH5vKXA6x9Y1QB2XplC45zqtiDC6Y6tugSVuDZNNDQar9z8NlIkgtlE4BmNVdNyCYLw9lzU2hSr+FVrOjOFPTHcejpo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AX7jmaB+; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cfd6ba1c11so79605a12.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 14:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714772845; x=1715377645; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ew0UVNQBCxGa1IBF/GdCeKaoEE06xBYgK5JUyIdRUg=;
        b=AX7jmaB+/h+AGSlYkg+3Yv3v+7MRMsqEoR6XUFHj/QBvtMcyFth0W8LmkxvlBUGble
         JhssWQ6wslc2BQL3S7V7fpeccDkByAGgfvY6gsbzDyT6WAdF4ExV7Y6d/O/xAMTK8zNO
         m3cjv1oO7BnxkdzMseKVECDp1E9aFjUFUE9ZhXvQGgL3An6tkje3XU0hrZV2X1myQgzt
         eGjq55Q3/04gH1CSAipwkSkjfCdsZqLm7wu6BKhiUbPKGpYnrqcUXk02FQp+tZgao/Hy
         Ltb7ytL5JVFWjwCqWVN5vbH793ACEXz/w0oodg8ZknBVUQeAYrh4QsP1w99tMrtcu1nl
         zdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714772845; x=1715377645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ew0UVNQBCxGa1IBF/GdCeKaoEE06xBYgK5JUyIdRUg=;
        b=EnIaDQBL7h9OJyLiWR3I/BCXKDaHm6PYA6Ld87vhrHSBUFoVa6AB80T2q19cdK/qg0
         j2mUaC1Q+U/8cKPIeBTvks8lB5fJAZoL3/c7w4nDasvskBAA42AmDDC7We49OOaMPjmk
         MtiTF+P+AwosANcIpWNbC/3MSmfTbkmGWMJS5CQSriA3nLGVyIcXMiYIvKmrVpsV6tji
         9NtPZC3DqlSIMBBHNeJhSCxs4z0a0TYPjptXIXznFzXWg1yKcjvD9r7GjYnR8ONg0PgR
         pY9UR9r+7FVrhrRS7NYH7++BSHZ50W2WTgZmCfxPNtcMQ/hgrCMNJV58FwT538C2giRI
         Ng7w==
X-Gm-Message-State: AOJu0YxfCNVq0pEoUFTjzsotblQKuNqdctMNumS2gjRjWDbCiRFlcccd
	URoI3LLIANw1JkGo33qZB57j5Nknb928bqVm9fGXAFB+DSAG1SRQQu0XojbbadyQl80gxNFK3wn
	O+w==
X-Google-Smtp-Source: AGHT+IGAQfxrBmGUL6g62HFmK8YrYjNTl4Xymu23x3cWXe8g7J6SefYdAbO6AERmhDMTdmB21aewhsKY5Mc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:34c7:0:b0:600:90b7:43ea with SMTP id
 b190-20020a6334c7000000b0060090b743eamr8773pga.6.1714772845390; Fri, 03 May
 2024 14:47:25 -0700 (PDT)
Date: Fri, 3 May 2024 14:47:23 -0700
In-Reply-To: <20231102154628.2120-1-parshuram.sangle@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231102154628.2120-1-parshuram.sangle@intel.com>
Message-ID: <ZjVba9wOiIlhqjfi@google.com>
Subject: Re: [PATCH 0/2] KVM: enable halt poll shrink parameter
From: Sean Christopherson <seanjc@google.com>
To: Parshuram Sangle <parshuram.sangle@intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	jaishankar.rajendran@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Parshuram Sangle wrote:
> KVM halt polling interval growth and shrink behavior has evolved since its
> inception. The current mechanism adjusts the polling interval based on whether
> vcpu wakeup was received or not during polling interval using grow and shrink
> parameter values. Though grow parameter is logically set to 2 by default,
> shrink parameter is kept disabled (set to 0).
> 
> Disabled shrink has two issues:
> 1) Resets polling interval to 0 on every un-successful poll assuming it is
> less likely to receive a vcpu wakeup in further shrunk intervals.
> 2) Even on successful poll, if total block time is greater or equal to current
> poll_ns value, polling interval is reset to 0 instead shrinking gradually.
> 
> These aspects reduce the chances receiving valid wakeup during polling and
> lose potential performance benefits for VM workloads.
> 
> Below is the summary of experiments conducted to assess performance and power
> impact by enabling the halt_poll_ns_shrink parameter(value set to 2).
> 
> Performance Test Summary: (Higher is better)
> --------------------------------------------
> Platform Details: Chrome Brya platform
> CPU - Alder Lake (12th Gen Intel CPU i7-1255U)
> Host kernel version - 5.15.127-20371-g710a1611ad33
> 
> Android VM workload (Score)   Base      Shrink Enabled (value 2)    Delta
> ---------------------------------------------------------------------------
> GeekBench Multi-core(CPU)     5754      5856                        2%
> 3D Mark Slingshot(CPU+GPU)    15486     15885                       3%
> Stream (handopt)(Memory)      20566     21594                       5%
> fio seq-read (Storage)        727       747                         3%
> fio seq-write (Storage)       331       343                         3%
> fio rand-read (Storage)       690       732                         6%
> fio rand-write (Storage)      299       300                         1%
> 
> Steam Gaming VM (Avg FPS)     Base      Shrink Enabled (value 2)    Delta
> ---------------------------------------------------------------------------
> Metro Redux (OpenGL)          54.80     59.60                       9%
> Dota 2 (Open GL)              48.74     51.40                       5%
> Dota 2 (Vulkan)               20.80     21.10                       1%
> SpaceShip (Vulkan)            20.40     21.52                       6%
> 
> With Shrink enabled, majority of workloads show higher % of successful polling.
> Reduced latency of returning control back to VM and avoided overhead of vm_exit
> contribute to these performance gains.
> 
> Power Impact Assessment Summary: (Lower is better)
> --------------------------------------------------
> Method : DAQ measurements of CPU and Memory rails
> 
> CPU+Memory (Watt)             Base      Shrink Enabled (value 2)    Delta
> ---------------------------------------------------------------------------
> Idle* (Host)                  0.636     0.631                       -0.8%
> Video Playback (Host)         2.225     2.210                       -0.7%
> Tomb Raider (VM)              17.261    17.175                      -0.5%
> SpaceShip Benchmark(VM)       17.079    17.123                       0.3%
> 
> *Idle power - Idle system with no application running, Android and Borealis
> VMs enabled running no workload. Duration 180 sec.
> 
> Power measurements done for Chrome idle scenario and active Gaming VM 
> workload show negligible power overhead since additional polling creates
> very short duration bursts which are less likely to have gone to a
> complete idle CPU state.
> 
> NOTE: No tests are conducted on non-x86 platform with this changed config
> 
> The default values of grow and shrink parameters get commonly used by
> various VM deployments unless specifically tuned for performance. Hence
> referring to performance and power measurements results shown above, it is
> recommended to have shrink enabled (with value 2) by default so that there
> is no need to explicitly set this parameter through kernel cmdline or by
> other means.

I am by no means an expert on halt polling or power management, but all of this
seems like a reasonable tradeoff.  And even without the numbers you provided,
starting from scratch after a single failure is rather odd.

So unless someone objects, I'll plan on applying this for 6.11 in a few weeks
(after the 6.10 merge window closes).

