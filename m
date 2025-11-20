Return-Path: <kvm+bounces-64007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 63A9AC76B02
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 68C984E4D7D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFB13126B7;
	Thu, 20 Nov 2025 23:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKU0KwCd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F5730BBA3
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682815; cv=none; b=NJjl8ufc2OkAO3aq9MWMnkkPFxZhKkSsnv7aYeTc7uTDshKBl4Cj3hWOzSMwGT7Gr6aN/IRN4UCa8obguNhTZzLEeAEsHCWwHNlE0DRtzTb1F7Jqlsmz5I5I1zTWm3NyWc8RF4amT0ie27AZu5kBzgUPcN16WDIJid0JzbaIzPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682815; c=relaxed/simple;
	bh=M4jRC71Wi4l4NsFh9zENY4MSBEm9elSXa4wBy84uayE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uYATsoo/0RXYs8nUIC6XMAZ63cbEPyVTUuim1+2pviIditMpvisHQenzqs7GTeBhqy9dNgOJxGXvxc3HUNrLmUaMeO8njzPWhnG1TmYv1ztsy/0lehWf3YYATqKEcDdim+4hf7veKelVUd8THv+vWA+riaRJycW7sLphu0gfPLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKU0KwCd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso1678368a91.3
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763682812; x=1764287612; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4NDZ1fQ+Ut8j1fVsSWL+jiZSKw4xJOxG+zZRftGIH0o=;
        b=sKU0KwCdo6nh3/hTLpwGelD36KpqzG5RVRwGjgZIUOgDPWjjQwb/ozjrkNW5hwP/fM
         DlQZXrpi6nIoH6qTOAbx1q0Mkglb4tsoZE+t4QFYun/LCdl7l/5KurXYoRMmB2TyGGD8
         DFgti2RtVgy7B8bYejjZLNb5Lrfe8fcecsF3oDk7jNsATTajRsJoMgcPzEYX4X+Y5cId
         LX9EZ/10kF6j7fEoyek0Kvadn8gmjMoPag+AeWvvtXnsXyQvgNA/KSy6dNBadA5Nqf2o
         J9h2LVPLsNq8sPQSiXOTdcg8l9OV8r+Uxb7I7Vkd/0jzt8YoJtLjUrcmBeTyjzoRvLCe
         NUEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763682812; x=1764287612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4NDZ1fQ+Ut8j1fVsSWL+jiZSKw4xJOxG+zZRftGIH0o=;
        b=HdoTBd1w0RBNFko2LNdvNaOtkIoK/hOmOwjaAHvXQLHz4MrLWtg8rBQZSTUW4IUktA
         byx6F9IenpNpsgWz2m8rmZaEvfN7iC51t+onOuyHAfwJH97UJ17n3tlhXJIplULzHHTr
         Syliz8UFI6AhvgnUrpqhg/P6IZoM4CDhyYxSfW5S5xOytzDp3Y8YddNyQuvlUrwKhwrC
         h4BgrYUez4L9TEsAoxS4QN2swXTiHBh1G3I6V1Dy8VnDbH5IkTWIHfCEhDrnKEtf045x
         TY62m2F96UO6EmUM7/HfiZg+5bFg+ku+DAR/JUgfoQ4iPTL1P/IXp2CGLS2v1vp2DydF
         /ziw==
X-Forwarded-Encrypted: i=1; AJvYcCVx5+AKFBmQpD8vyfN3lbh7kqQQ22+0bubmRFLA6qeaJa8nWAQ8tSojTtcKxXLfeme6eqo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzqr1gsdj2VwVUM//fLxa9At1ADdqK5FyHJxw2TSojEJyUnqx3X
	1XCf/RbG18oVZhSapkdHiMfbzgSNU6bN8Q8QWoIrlLZDvixWUgM8KAyLt+KV2Lboh7OhFpxKQmY
	02Kywtw==
X-Google-Smtp-Source: AGHT+IF11hZRQdKkVFZ8ks/tbv5FO+XVDtwwnTw3i9mxGjwyShF9EdVWe0nyuj41EKYi5HcOt0fXteGZ4IA=
X-Received: from pjblj2.prod.google.com ([2002:a17:90b:3442:b0:32b:58d1:a610])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e87:b0:321:9366:5865
 with SMTP id 98e67ed59e1d1-34733f517cdmr290604a91.33.1763682812551; Thu, 20
 Nov 2025 15:53:32 -0800 (PST)
Date: Thu, 20 Nov 2025 15:53:31 -0800
In-Reply-To: <20251021074736.1324328-4-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev> <20251021074736.1324328-4-yosry.ahmed@linux.dev>
Message-ID: <aR-p-2yEZPVMYniU@google.com>
Subject: Re: [PATCH v2 03/23] KVM: selftests: Extend vmx_close_while_nested_test
 to cover SVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> Add SVM L1 code to run the nested guest, and allow the test to run with
> SVM as well as VMX.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |  2 +-
>  ...ested_test.c => close_while_nested_test.c} | 42 +++++++++++++++----
>  2 files changed, 35 insertions(+), 9 deletions(-)
>  rename tools/testing/selftests/kvm/x86/{vmx_close_while_nested_test.c => close_while_nested_test.c} (64%)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index acfa22206e6f3..e70a844a52bdc 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -112,7 +112,7 @@ TEST_GEN_PROGS_x86 += x86/ucna_injection_test
>  TEST_GEN_PROGS_x86 += x86/userspace_io_test
>  TEST_GEN_PROGS_x86 += x86/userspace_msr_exit_test
>  TEST_GEN_PROGS_x86 += x86/vmx_apic_access_test
> -TEST_GEN_PROGS_x86 += x86/vmx_close_while_nested_test
> +TEST_GEN_PROGS_x86 += x86/close_while_nested_test

Unless someone vehemently objects, I'm going to tweak this to nested_close_kvm_test,
and keep Makefile.kvm sorted.

>  TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
>  TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
>  TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
> diff --git a/tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86/close_while_nested_test.c
> similarity index 64%
> rename from tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c
> rename to tools/testing/selftests/kvm/x86/close_while_nested_test.c
> index dad988351493e..cf5f24c83c448 100644
> --- a/tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c
> +++ b/tools/testing/selftests/kvm/x86/close_while_nested_test.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * vmx_close_while_nested
> + * close_while_nested_test

And of course zap this :-)

