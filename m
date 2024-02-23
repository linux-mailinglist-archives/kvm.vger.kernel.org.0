Return-Path: <kvm+bounces-9590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65AAF861F15
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 22:32:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EC68286B5C
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D191493BF;
	Fri, 23 Feb 2024 21:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SfLV2Ms4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245A8149382
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 21:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708723925; cv=none; b=i6PQBMEM47CO36q3HlOZxxkvz5hchOYHzQxGSEDEgZRf3Rm51REYCR4GH0MviIJnAArYJ4ZsdgRKk/73mh1fKJ7G5QsrXkSdMvKZCwM5HEwCLHVWwntzY9Mfj4GURz7e0NeN7FPkWkRZ74M+iaF1TeZJPF9qlOcsv1aWpy6zyDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708723925; c=relaxed/simple;
	bh=29kkunBsutguy6GvwVyorRTRKtbonmNkFfzqB8N7XEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=DYO4vbweNwVBRhGmFlYZBDjau3EhzVWl5yLDjELrMdrZVinara66TpuvCMiQQjPX16xSuGLZw/ThnaU6DFqjwdEhgMTSqLqn/2lXNyCZwI2QL+j4ensv2h4JySvKDJ36Eg9ModFTxOKxELN2SdcZPC1iSHLvNoCBQT6m2qtOUOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SfLV2Ms4; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-607e613a1baso15503567b3.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 13:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708723923; x=1709328723; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5T8kMbM3lvFCmU6raObYkuNJfKV9OA18TCvi8MEnNBs=;
        b=SfLV2Ms42xjATTNE0BMpqrPCFzRi35MdnFVV0fFjmY1fzQC4vkp16U0RlC7OFJpQbj
         IhiFDZmHPJEfdWbMFc37/wGXnNW8a9jhxqv8hPezRfNgcG7RbzYNzt9g4gaKGzfFy+IL
         WjI0blYQcgdaqu2W9DoW0i6sqnAmvWJJL+KYGUhs8dgdVEdd4/JZl62zdDihwCaA+w6h
         BLpi4gjJc6j2nOmnXZhOU/S60oSRHkgsPF2PUOgnnnEswFgQu0gCFj/hmHIdGWAc62sK
         2Kq64xuTptdkaZLHBLy94AOUJjuXo7qXdji3FjxMKSiKpL1EbJtkt/SM8JlxaABCRkP9
         Ssbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708723923; x=1709328723;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5T8kMbM3lvFCmU6raObYkuNJfKV9OA18TCvi8MEnNBs=;
        b=VDDDjpVvy8wMURIJA5FPVy8VOZUJaRzUeFoulkx/TAb3UN7YSuIdClqXxve7tB/drG
         s/HQ8hFe5Pu3Bmb4GewPu8GceLMg5NEA//wY+A4Gglg5jAmczU88s+H3eYPwzGw1CmkW
         qgDX8S+20+w79yQ+ifyaSuo95dtbrEJJdp59NCbIvfmRXpNfFgV6NxVFZBzG+EkgLR1u
         x4sR+y8mGPsNPEsmM+JupNRU5GDZZ+ShgDE5x3e1+Pd/muZeAuqiYYWheTTExW7JjAad
         B3mkOIxPyEme5DSMiNCc2L8x8H3JB8sFimDlgXgRQ+Rg7ScPanGfuZQYjR028hNNfBHD
         rWOg==
X-Forwarded-Encrypted: i=1; AJvYcCWxMEBtqOihVkYQFkNUe1rWkADLJvDVFv6Z8EUVvNcn0AygIhgxM/MaCy3bcIdqRUyvfuNSD3btmAGnX/zlgzEakVCa
X-Gm-Message-State: AOJu0Yzxy28fI3cXjDiLazmdayKJK7R1jKfcY6nbgdlmnMXKgfLfQKx9
	g8jXBV7pfAe8NFzqkCXsg4CvbBUnX7Bj3XGKTLXEcBCiTRACdmS819pm/hN6303m4+kndQGcveM
	TFg==
X-Google-Smtp-Source: AGHT+IHQsa2LAoeFm38m6iAgFlbUSvGJwmYQQ/4CTw9uBww3wjf6rnkg1DLsVSRa7HvqhL7ZI/R2B0/nSyg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d9d4:0:b0:608:a901:469a with SMTP id
 b203-20020a0dd9d4000000b00608a901469amr247453ywe.1.1708723923177; Fri, 23 Feb
 2024 13:32:03 -0800 (PST)
Date: Fri, 23 Feb 2024 13:32:01 -0800
In-Reply-To: <20240223211547.3348606-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223211547.3348606-1-seanjc@google.com>
Message-ID: <ZdkO0bgL40l10YnU@google.com>
Subject: Re: [GIT PULL] KVM: GUEST_MEMFD fixes for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Sean Christopherson wrote:
> Minor fixes related GUEST_MEMFD.  I _just_ posted these, and they've only
> been in -next for one night, but I am sending this now to ensure you see it
> asap, as patch 1 in particular affects KVM's ABI, i.e. really should land
> in 6.8 before GUEST_MEMFD support is officially released.
> 
> The following changes since commit c48617fbbe831d4c80fe84056033f17b70a31136:
> 
>   Merge tag 'kvmarm-fixes-6.8-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-02-21 05:18:56 -0500)
> 
> are available in the Git repository at:
> 
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-guest_memfd_fixes-6.8
> 
> for you to fetch changes up to 2dfd2383034421101300a3b7325cf339a182d218:
> 
>   KVM: selftests: Add a testcase to verify GUEST_MEMFD and READONLY are exclusive (2024-02-22 17:07:06 -0800)
> 
> ----------------------------------------------------------------
> KVM GUEST_MEMFD fixes for 6.8:
> 
>  - Make KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_READONLY to
>    avoid creating ABI that KVM can't sanely support.
> 
>  - Update documentation for KVM_SW_PROTECTED_VM to make it abundantly
>    clear that such VMs are purely a development and testing vehicle, and
>    come with zero guarantees.
> 
>  - Limit KVM_SW_PROTECTED_VM guests to the TDP MMU, as the long term plan
>    is to support confidential VMs with deterministic private memory (SNP
>    and TDX) only in the TDP MMU.
> 
>  - Fix a bug in a GUEST_MEMFD negative test that resulted in false passes
>    when verifying that KVM_MEM_GUEST_MEMFD memslots can't be dirty logged.
> 
> ----------------------------------------------------------------
> Sean Christopherson (5):
>       KVM: Make KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_READONLY

Almost forgot, just as an FYI, this has a minor conflict with your kvm/kvm-uapi
branch.  I've been fixing it up in kvm-x86/next, and IIUC you don't feed kvm/master
into -next, so I don't think Stephen will see a conflict?

>       KVM: x86: Update KVM_SW_PROTECTED_VM docs to make it clear they're a WIP
>       KVM: x86/mmu: Restrict KVM_SW_PROTECTED_VM to the TDP MMU
>       KVM: selftests: Create GUEST_MEMFD for relevant invalid flags testcases
>       KVM: selftests: Add a testcase to verify GUEST_MEMFD and READONLY are exclusive
> 
>  Documentation/virt/kvm/api.rst                       |  5 +++++
>  arch/x86/kvm/Kconfig                                 |  7 ++++---
>  arch/x86/kvm/x86.c                                   |  2 +-
>  tools/testing/selftests/kvm/set_memory_region_test.c | 12 +++++++++++-
>  virt/kvm/kvm_main.c                                  |  8 +++++++-
>  5 files changed, 28 insertions(+), 6 deletions(-)

