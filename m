Return-Path: <kvm+bounces-58654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 288BDB9A33A
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:15:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E5D21B26926
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576153064A0;
	Wed, 24 Sep 2025 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8utXVBS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738822E54DE
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 14:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723329; cv=none; b=SotJOMjPAtqwZH8zmxUuwNaNge1IUbOSiO8jNYb8OXAqzue0A7RbkgtdMVm56atWZL0S8n3AGxPYoOOUGH+DKLZIgtYckZPiIF/b03J3AET/3LqXJIxl3ED9fIoBgCNb0+Xre5ewDtWkYwSN1IHQCprAql7IbroP6EXbKltj+AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723329; c=relaxed/simple;
	bh=8x/a1GocoIuKUB2MR0bfUWVaGRwNGm8boFywixMv9iY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ilumfFc/ap5wU93edbUm+V3xx4OZyBOfXqS5eGw4P7McVBtcoFXMQQiyrdvY9PO85/CqDhWcd0CB3HVHvIIO0q2ZDzeqeaNMEydklUn9jqqGKIRM2WaUFxMwWAQnJSafdzwCiqp6TVBLRSjAOCrMjm2sq6j7944Xw8yF8T/WhIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8utXVBS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AD5C4AF09
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758723329;
	bh=8x/a1GocoIuKUB2MR0bfUWVaGRwNGm8boFywixMv9iY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=e8utXVBS2zdU3FVL2UJV9oa1UA9gnUCJluGU4Ji9puH1rZcJKxWtp560I/bfyGK6o
	 +w5nqWN+iorox6pd1nHvRuMdBm5y9Jpiv+jY+wJq+by6dET3bevyn2TQyL81/MLnNP
	 FNuETyOrkltttrKx+gcgEO+aRGltqAGd4VKRFBWIwjxvH1qy0htPMZPtRdBd6cMqBj
	 bxIUPBIUDjjqP0f5jLdPoU6vmYEanlR1tQjqSVo6VsWrI/eFMhhxXq+J6QMU3lYFIq
	 7MAIXhMX4MvLtmGECwO1qEpZxtd3PsvR4xxXHCfSlml5U5MLy+QG7zTV7hfrhPGqcm
	 rO9WmygCGnZPQ==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-57d5ccd73dfso3623162e87.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 07:15:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWjn4yoWJE5Xf+uMXl4fV9PrjJtA1Dtqw/NbDU24ybocAEbQ/5wGzGgQI4a8kEKIp0uaSI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBoNf0iDOkY0BgUmgGmvdHcp2Of6B63IXFttGzdjAI07I7UqH9
	KLhBtpzzRFSr1M/tqCw61n6EgYMf+As3JTE+Wh/vWjq+yylOV51ITSqIQeYsORt7jSHSj9u1nAe
	J6fnWkhzoLkjGDuAD+y/psDa3v2gA/8k=
X-Google-Smtp-Source: AGHT+IErDLsHMdDLVzUH1ZX2J4cnoHf7hNp13ElYIVV4bvw1+B8Yn8AcLV1rJoYooM59nSKNFU2EirbL4L2VLGZ3shU=
X-Received: by 2002:a05:6512:2526:b0:57b:8675:e2e5 with SMTP id
 2adb3069b0e04-580711f9202mr2473517e87.15.1758723327533; Wed, 24 Sep 2025
 07:15:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e8ace4cc-eb22-4117-b34d-16ecc1c8742d@amd.com> <aNPxLQBxUau-FWtj@google.com>
In-Reply-To: <aNPxLQBxUau-FWtj@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 24 Sep 2025 16:15:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHxUVowtCqBCKRE2_dv4TSUK6Kgwd46RzjjskAW8qYjHg@mail.gmail.com>
X-Gm-Features: AS18NWAUEo6pqjdazcDv7mkIZqKNSwqM6gixIoj99CIpz3VS7Pjl51sMhqvtA50
Message-ID: <CAMj1kXHxUVowtCqBCKRE2_dv4TSUK6Kgwd46RzjjskAW8qYjHg@mail.gmail.com>
Subject: Re: AMD SNP guest kdump broken since linuxnext-20250908
To: Sean Christopherson <seanjc@google.com>
Cc: Srikanth Aithal <sraithal@amd.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>, 
	Ashish Kalra <Ashish.Kalra@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, 24 Sept 2025 at 15:25, Sean Christopherson <seanjc@google.com> wrote:
>
> +Ard and Boris (and Tom for good measure)
>

Thanks for the cc, and apologies for the breakage.

Does this help?

--- a/arch/x86/boot/startup/sev-startup.c
+++ b/arch/x86/boot/startup/sev-startup.c
@@ -44,7 +44,7 @@
 /* Include code shared with pre-decompression boot stage */
 #include "sev-shared.c"

-void __init
+void
 early_set_pages_state(unsigned long vaddr, unsigned long paddr,
                      unsigned long npages, const struct psc_desc *desc)
 {

