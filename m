Return-Path: <kvm+bounces-64009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 04A07C76AFC
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 13C2C2B18C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070D231577D;
	Thu, 20 Nov 2025 23:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0e44B1O3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05634C98
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682908; cv=none; b=a0Iss4jOLn1jE9JpNzUcvkZ86gn282LZ4Z9Ak1L33kFEpS1X+7S/ITags1Oh05jdC5ZUSYOYYNDY2i3DQ0bm3xB1b1I52zkExFZjB99nW/4Lc00S+yy0v5Nk2VO8mvJ2gH0IggynVC63PrrzJ4DEkD1RSkPpSC8EwdBFLezIRXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682908; c=relaxed/simple;
	bh=4zjy4k3vgeqSg0Yu40MRWtPhRy4GPFmjoybzqM+g/ic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f/9c+sU0zFjtS45PaPP9Cq35HUzgDspmF/AqCZIoZCu++Tn8vft3+4OEcy+OGbQxKNlG1iOWt7NVqBMsSP6UxT04lvbSG4jPdlO2SEuz+cw4mSeJW9ruF5RPBvROofr6qYJznifwjtD3Mn3fVJLPc6VAB58eeZ8Bgfen9W0ZLWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0e44B1O3; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297df52c960so42277005ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763682906; x=1764287706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s68Za4hFCTq+nn0V7gl7AkP7K1rYBg/9xd9l27wex74=;
        b=0e44B1O3ngmtngm+5a7ViT//h2PwAOj+/IKXBWLCZQ5sT5rtPdLqYospqqNsVfpOqZ
         II/bZ6ACpj+CzUJqckpsYD3+FupW/AyPnN4/UwnMdoy3SVQrZhC//JYnqQbljG5jEQP4
         /AVGNNQpoDv8Qge1XRROqmQtVStlWtHTQJLoG9YH5HegSBOgURhcOc0ztiV7NrDKTUXe
         VcE1oKlyM6YJWiQQybPSbgCz6J6+K+b03iqO2+NMbtTiB2tnEp9/l7bletLTJZZ+mSnq
         U9ZjDq9SDVxhORZEmS4UQS7a0erNbYVRgMo73Use/YiDPPmNy9zONV6d2HTSaRCcOmhV
         THiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763682906; x=1764287706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s68Za4hFCTq+nn0V7gl7AkP7K1rYBg/9xd9l27wex74=;
        b=rcqG42bX9xqHEuoSfOewlrWiPj67ZE/fJ7DkJKBW5FYPIuuuw2XXLtz2y+7OLTBarH
         vk2Q3ewdlPpaoKhUyiXC8maRPeIs2UHIZae98ZJv2oKVLnoR9DVryr/cx/WNigv6Z7s5
         F25By9HkFiu8XIIAQH2n6M7yK3uty4FehiwrpCYEe0M+4uJiK8md2Gvo6LnuUptB97P5
         1qh8Vftj4blF9rM8IB7AeSrmlqBtuqBgRyss4ETVgvozyyO9KcEBFYLhyOGNN741LN34
         5uBsdAr4WO3zzKnwnSIf8Y/hdgwB/sNuAZSX5za4/yk5ohtxLr97CCjVi78WmRyQaDTO
         5CYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQ9oMLNCnNty4W46yeCpyn/XPtNd2OPeZZYTK3LZ1bpr5yvnsRx6RersjsMlwEVXxzumQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo1uY53yDHlQcNmewPvWwIQV7KoZP0nUyNci/D2RuP01U+OIwI
	HONzL/J5ZJZKGDJZoZ6sigjHF4diVGcV96Q+VksM9JAL18yLVYt//8YzLd7t7GIMwja80UMSrSp
	PK+WiLg==
X-Google-Smtp-Source: AGHT+IGnE8+xz+DbZR1KrybADk4tLQE+xfefjHvMcNEQiKhOicLrhsjIp7gqnkx8TjVbUL6zV/W/BzjG2Ps=
X-Received: from pgac15.prod.google.com ([2002:a05:6a02:294f:b0:bac:a20:5eea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d502:b0:295:9cb5:ae2a
 with SMTP id d9443c01a7336-29b6be8cb22mr5202385ad.9.1763682906026; Thu, 20
 Nov 2025 15:55:06 -0800 (PST)
Date: Thu, 20 Nov 2025 15:55:04 -0800
In-Reply-To: <20251021074736.1324328-6-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev> <20251021074736.1324328-6-yosry.ahmed@linux.dev>
Message-ID: <aR-qWN9uIX3fl5QX@google.com>
Subject: Re: [PATCH v2 05/23] KVM: selftests: Move nested invalid CR3 check to
 its own test
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> vmx_tsc_adjust_test currently verifies that a nested VMLAUNCH fails with
> an invalid CR3. This is irrelevant to TSC scaling, move it to a
> standalone test.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |  1 +
>  .../kvm/x86/nested_invalid_cr3_test.c         | 81 +++++++++++++++++++
>  .../selftests/kvm/x86/vmx_tsc_adjust_test.c   | 10 ---
>  3 files changed, 82 insertions(+), 10 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index bb2ff7927ef57..b78700c574fc7 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -88,6 +88,7 @@ TEST_GEN_PROGS_x86 += x86/kvm_pv_test
>  TEST_GEN_PROGS_x86 += x86/kvm_buslock_test
>  TEST_GEN_PROGS_x86 += x86/monitor_mwait_test
>  TEST_GEN_PROGS_x86 += x86/msrs_test
> +TEST_GEN_PROGS_x86 += x86/nested_invalid_cr3_test

Almost.  A. B. C. D. I? E.  :-D

>  TEST_GEN_PROGS_x86 += x86/nested_emulation_test
>  TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
>  TEST_GEN_PROGS_x86 += x86/platform_info_test
> diff --git a/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c b/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
> new file mode 100644
> index 0000000000000..b9853ab532cfe
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
> @@ -0,0 +1,81 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * nested_invalid_cr3_test

Boooooh.

