Return-Path: <kvm+bounces-60085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A0ABFBDFF96
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8507D4E822A
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2BA1301028;
	Wed, 15 Oct 2025 18:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wcvHuqQ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926D028FFFB
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551378; cv=none; b=qSrxhPDTKuojL/DTKSbHHByFhwkSzFn/l6HTRZXkKeZ3SJt0FzZSqi6PXndUhj9wlwyfy55nWWVMLDHuXS/5ZAAM/GAL3ReWWSYD1spBGAABy34VspYuRaiEcrpnnnF0VW71Es32upA6F7iciFqhvDUVIVrdPO90wSA4nJ+fmjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551378; c=relaxed/simple;
	bh=6QCPDCRExOZK4LEydNe0YLg6HUoYLOPH0Yj4jCsSxT4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bQGNo1VSQpUE8gFRiQdmDNK/VCrRF5U9hoobQpDwXcU9bZyJfquXk7YaNq11dhYuzqVq+cGhF9w7A2wHdOdhT1dTugoayNTvNcRGzstbDwP5Wt1Vq0GTh1Tx2fGHvxk93BXL4vc7LSPLatKPv9dNsKD4Eo4PPWxjOhv66CZ4r0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wcvHuqQ0; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5516e33800so14493945a12.0
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551376; x=1761156176; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ry5mAFjD93bwdmGtL1cu54P4wKF+ZVBcWUkmTraV/hs=;
        b=wcvHuqQ0Ybd1cRuBTUZq/mzFj6dC0hRk8hqnru0luWtQL5HhjXTX93Ep9zNY+dNEDy
         /2iQJTeiBD10BTJ0YSsH6VHoVlUGicVFs8vheriqHFRsEvuY4maKDYwulBYv/Mqpfe+D
         d25+4ukJZcxUr8NVNENh4+pve677+M/V/xhdV1O7g4UXoLkKKqoTqAc3cqLvKtJqL8DG
         cmxxpydW6WqYYW7KN/dh3GuFR4zBw96Mypi/iPB/1PLo88beYaJgFREyibvcaoHZfJhj
         DxwRRaR9pnU1KnV0+4aeDMwMxi/o2E8tKTe1YoNt4g/jgHAja4bKGkUlUOpU9UNYF1sv
         1XRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551376; x=1761156176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ry5mAFjD93bwdmGtL1cu54P4wKF+ZVBcWUkmTraV/hs=;
        b=JYaNbwwgxZedJePs/Q2hOehj+H+nhLh4zfY2FiBdafkn7va58bBrI8e06t2dtf69m4
         vTflG+RczKb2NMAuintGmrRbZfaQZUE1iBQXlO6+jnMtvpE0rnXujKulh4fPCoFzQZ4A
         2K4/2LHiMSb6LWMTUeR1WCMtf0Epm+bUJwdX6AjJ004k9eI+ZXUTyXAZ5JFnfYaJkjhI
         ukGbbQmLVEM/slxpWdAhKJcQggCerlz+nPf4PwQ/S/FbPuRhRuYPjcJAioRM56BYAh94
         vADRNz8GlWExj86KZgWHKWx36nAH73MU3KqASguvziXlZ+Q3fVTpQoynlxfxrnniiNYm
         3nLw==
X-Forwarded-Encrypted: i=1; AJvYcCXt6c/Z96MARSzImHuyqYle+zA0EDxyN1GVsSshA+stg9DIdOCzG748PAMrLtkyi0rye2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhnA8wyvGPbNe0e4ORLn3VxO9MjJqfEv2X+8zZXEoExpo6dz+E
	jhDTwoUI+8EHAzDRiZqikV6gPUuyN4bzH4+Mt+BkHLnDK9alK8fg4Zxi1kfj4kTqA4VWAVxPc3s
	gJ9ot/w==
X-Google-Smtp-Source: AGHT+IH7UnzOFjcdUsIUp5GNVhPuWQjIuGz93nimomrjkve04RPAdXgMZUvIZJRh+o+2q9OLLXkkT+y9Ia4=
X-Received: from pjbsc12.prod.google.com ([2002:a17:90b:510c:b0:33b:9db7:e905])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b87:b0:339:a4ef:c8b4
 with SMTP id 98e67ed59e1d1-33b513861d8mr38865281a91.28.1760551375781; Wed, 15
 Oct 2025 11:02:55 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:38 -0700
In-Reply-To: <20250905091139.110677-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250905091139.110677-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055121712.1529254.17045515819433949532.b4-ty@google.com>
Subject: Re: [PATCH 0/1] KVM: replace wq users and add WQ_PERCPU to
 alloc_workqueue() users
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Marco Crivellari <marco.crivellari@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 05 Sep 2025 11:11:38 +0200, Marco Crivellari wrote:
> Below is a summary of a discussion about the Workqueue API and cpu isolation
> considerations. Details and more information are available here:
> 
>         "workqueue: Always use wq_select_unbound_cpu() for WORK_CPU_UNBOUND."
>         https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
> 
> === Current situation: problems ===
> 
> [...]

Applied to kvm-x86 generic, with a rewritten changelog to tailor it to KVM.

Thanks!

[1/1] KVM: Explicitly allocate/setup irqfd cleanup as per-CPU workqueue
      https://github.com/kvm-x86/linux/commit/9259607ec710

--
https://github.com/kvm-x86/linux/tree/next

