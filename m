Return-Path: <kvm+bounces-51992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4980CAFF401
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 23:39:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3836F3A7F94
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 21:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F37323E344;
	Wed,  9 Jul 2025 21:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y296VOx0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139A8221710
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 21:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752097149; cv=none; b=YHZhJP/23ryyWlpcpl5DUQV+m+J8kvgc7FB0nOk5KoBRMNIOTdi4DTDrCgWwjgoyijvZ0eJuJl/gojlc6RZJHjz2N3JpmoY7uSRATQM0yj0ZYm26SkxW1ptCZxVt9MuwnpRqHBlcdalmAsupjQO5FcqVCV2nKj+qH/L1v/PIz9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752097149; c=relaxed/simple;
	bh=GODhRmDiVJiCnZUnkaX8NW89MJRIIVn4pvNiMuRjOq8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sPyVVKhATW19+NCUIjL/izKROXGbQRwWRZHDCosJr0Iz7wfO6jyShjXjBSsXEn7rZgpDBTDAqGIZ75xF30WXitvcaQhfwHpHJM/zNNCniJp/WcxankE7jQSqO/qzKxBc17Z4gbylss+fkk/AiNBJxFWrAz0nEXzc5tN+a/303lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y296VOx0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3141f9ce4e2so529539a91.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 14:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752097147; x=1752701947; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRjFnmCzYN+qn8kF+o9IzfpkXQ4+JquW4HupC73fftA=;
        b=Y296VOx08prQDUbgf6MjuyRgedbJQGEMVHxpB4a9zJmOHXPvclNjmF+ZEjZpSpwWFW
         PEo1jaAqSjP3PPA+AENpDq5fRCVM1NG6B7wYJpHnz+EbE1D09aGNYDau3HRnfUEdCUej
         KRlskOYrpRCOooM5GdlP+NAv8rZD9mWb1thpviaQHhcU+qDS3fp6q/yCtU1oNYYgTKsV
         miB0bQztHYUTROhBvkqjVhQthgc7+Cljiq/TljGXWIZm2QHKEY1uRv/lTIb9EeJneTbk
         8DTwz0+a23pC1HQQjlQlaBfSQr+JZ1YYBrS0BKbyqwvrGSKkv9u5r6NghqhxYybR2g6P
         E75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752097147; x=1752701947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRjFnmCzYN+qn8kF+o9IzfpkXQ4+JquW4HupC73fftA=;
        b=f7S6ygJiUTSFWGBCROnpeShXRbAgO/UGCWGaID3iDjai4SZ8ntVZFyNhv47LiUMZmp
         4VxKLufODvzLvlu+Dy/ZzUWFqp0KqGq7aLtevJGmy1hRiTwtkKJYtwOql674paLLzXYN
         hhpCfaoX3XoE52JSRMaFYF3siRLSXkhrgeVwINbBQPrYzGAq0uJCdUwIz+S6YCvLK7Lu
         ElAZu7qEBiAufEnbt8AQQoiemoF+YSr52Fox6RAAFxBrMPO8jZSyITfB0xCfGKjaJQ5X
         b49hWQiOEVRw+Eyg1x/bC1vjPrtzgHzt9nPgfQeji4iyhTJnJgQhxY0HkL5V59GOvbED
         h0Dg==
X-Gm-Message-State: AOJu0YzWbmlmLnyp81d7pjXp0yKzkXTIm0EHa2DEh0FspKSMRTzGR14M
	DgA9bonAt4OR0JdgbkiKGF50HUz7dSDS8N9vneYCitjQlAiswhBWD7E0EAITgoHFTECYTLcSWk7
	wB7evvg==
X-Google-Smtp-Source: AGHT+IGqLtd25jQcDPlbBnyHm57aZXVZqGANjf8aQ+PHIDAz5DerrzktIfl+GNc39oHL/0frC4tukw2+CLQ=
X-Received: from pjbqn6.prod.google.com ([2002:a17:90b:3d46:b0:312:2b3:7143])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5344:b0:313:62ee:45a
 with SMTP id 98e67ed59e1d1-31c3ef2308emr245837a91.13.1752097147476; Wed, 09
 Jul 2025 14:39:07 -0700 (PDT)
Date: Wed, 9 Jul 2025 14:39:05 -0700
In-Reply-To: <20250606235619.1841595-3-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-3-vipinsh@google.com>
Message-ID: <aG7heUe_zBf83tlJ@google.com>
Subject: Re: [PATCH v2 02/15] KVM: selftests: Enable selftests runner to find
 executables in different path
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> Add command line option, --executable/-e, to specify a directory where
> test binaries are present. If this option is not provided then default
> to the current directory.
> 
> Example:
>   python3 runner --test-dirs test -e ~/build/selftests
> 
> This option enables executing tests from out-of-tree builds.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/runner/__main__.py    | 8 +++++++-
>  tools/testing/selftests/kvm/runner/selftest.py    | 4 ++--
>  tools/testing/selftests/kvm/runner/test_runner.py | 4 ++--
>  3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> index b2c85606c516..599300831504 100644
> --- a/tools/testing/selftests/kvm/runner/__main__.py
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> @@ -29,6 +29,12 @@ def cli():
>                          default=[],
>                          help="Run tests in the given directory and all of its sub directories. Provide the space separated paths to add multiple directories.")
>  
> +    parser.add_argument("-e",
> +                        "--executable",

"executable" is kinda odd to me, as that suggests a single, specific executable.
-p/--path seems more aligned with how this concept is typically described in Linux.

