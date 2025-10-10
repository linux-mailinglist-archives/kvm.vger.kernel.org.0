Return-Path: <kvm+bounces-59786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53665BCE9D5
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 23:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DF933B91F5
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 21:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F103302CAA;
	Fri, 10 Oct 2025 21:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hA2jaENo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A2B2749F1
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 21:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760131842; cv=none; b=TYfrsdOdswFFAE92RzO1i6XV/4S0FyQw3Ukn2C2ACUG7kbde6h5fySLz6N5kzoAj6kb32VL3aM/ZJkO5VqPf/MY+K1b+/mwc6I9a102+aJCmyQjav7RjDOjEpd1jLc/qN0QpgwsTYkAyYsaLwNGHajX6hIk0U4mMTJrmFFFVkvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760131842; c=relaxed/simple;
	bh=8/p7tRrQjkWsIDoGrp+Q/dZhfHbhdeZtiwno3OQBCi8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ahrkzm1GefktkK3l+0d8l6gVF7kn3Ci3zjvmKPyo9MvSN4i0+4mNoZHmD47Wq+QYMU/UzOfYLN2n9MvoxUVde7iyjbfVK4B7ohvFV68OWJ9DfXVvBG76Z3vKQxsUD0o1pW3IlsmOKYS/rjo/GLf3ZcIDFRRrhNZtCR/xw/Pk3Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hA2jaENo; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b60968d52a1so8623732a12.0
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 14:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760131840; x=1760736640; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGidvreBdRrQ9/e+QABa4XqhsTH5hvZRquUKr+ibx5g=;
        b=hA2jaENokK0aNDL9+jMmbO7XlkY2L6ddh18eK7j6YlyMnaclZ+iAhuXqOmFzKfpcfO
         4otQ3Y4KhhzOejtqIgf26687JrPLoBjJWuraP/1eacEYYTek9bjC9Ww4f2F0G4V3ZgYN
         ejpW0DH5yOty0M29VhSxSIx61mH4Jvty56g4HfAPz8RiqYPRR8egB9AHWr59r5GLlOc0
         qWmYCNM/iJ34OEbqakv437BBHFPUIS/cGtY2c0CHPhupZi4pswVTvzIxZFHQr/GY/mP4
         LkpZP4iBnC+1DjlMItKPcsuoogU+mHwCEGiIzBLxwqVtJY/G3NdlbCrjxH7wSSEOllPG
         zTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760131840; x=1760736640;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGidvreBdRrQ9/e+QABa4XqhsTH5hvZRquUKr+ibx5g=;
        b=OuokwQeRh3l1ThJCIts4agkBKSVtchoB0oWXLUSiiiqLg6a21QGBqHmyrwDJ56WHJO
         pJVxEWw6GwdIh8kijM7zRKvae0jid9/E6IF8aPupsoFq7Ah6lAJzv7PBk6GCbzr8Hm+6
         RTpsO+8Ex4krccAfAnaI9HaL57Ocjzd6iI67DrX3oB0XYZMqFYUr7BFUtmXtJOHY/nLX
         2ZsqerCwWFY3yKhfqCtN1P2rbhMIN+JCtoNZgCF88Y9dtQuKuXWEEMrH+8dQ99hMCPua
         1NXOcyPWkbL8gNThAQwMnrVjpLvLr2z+lCRyMw+S5F37QHNh6QOIu/Ql0OXrG0hcd5IM
         dzeg==
X-Gm-Message-State: AOJu0YyQGdo0/dmVJhnSOueqgMOU8C85AevSAvDjIFNtkK7vqy0znXUI
	TB9SfMG8SLP5c2DF7qACHhuQQBYB7vjVo15X1yAX/0AZ0lNJ0c77Jbj5iyN1BOK4M9Su8oAMZZ4
	GJLKgDg==
X-Google-Smtp-Source: AGHT+IEcoM39c7Mj6p6VihhWMNZc1Lv9bgkpm92KunbjLNVZrSA/4FpGt5gG4aPbYdD2+ok2Z9TplqyvzX0=
X-Received: from pjso12.prod.google.com ([2002:a17:90a:c08c:b0:327:dc48:1406])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e05:b0:32e:64ca:e84a
 with SMTP id 98e67ed59e1d1-33b51162572mr20174140a91.12.1760131840262; Fri, 10
 Oct 2025 14:30:40 -0700 (PDT)
Date: Fri, 10 Oct 2025 14:30:32 -0700
In-Reply-To: <20251010005239.146953-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251010005239.146953-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <176013142377.973380.7356596643115609309.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Fix the warning in perf_get_x86_pmu_capability()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Dapeng Mi <dapeng1.mi@intel.com>, 
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 10 Oct 2025 08:52:39 +0800, Dapeng Mi wrote:
> When load KVM module in Intel hybrid platforms, the warning below is
> observed.
>
> [...]

Applied to kvm-x86 fixes, with a different shortlog and changelog.  I wanted to
call out that the fix is for hybrid CPUs, and that snapshotting PMU capabilities
for non-hybrid CPUs even if enable_pmu=false is intentional.

Thanks much!

[1/1] KVM: x86/pmu: Don't try to get perf capabilities for hybrid CPUs
      https://github.com/kvm-x86/linux/commit/034417c1439a

--
https://github.com/kvm-x86/linux/tree/next

