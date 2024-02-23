Return-Path: <kvm+bounces-9525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A2C8614C9
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 295D5B2237D
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 14:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED6F567D;
	Fri, 23 Feb 2024 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g6A6twrN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0788E37C
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708699979; cv=none; b=YHEd+oGEdDBjUcB8Pc4i9HkEz9UMlanKmJwmwSHh9AAZuu2hJzJUOt+mkeXru61/FhvvYC6yq4QtMxuY/NYxTtBzVIKhDRsmnDhxfp5NBFmGOhZCVg0qbTr2kqpwuPPkItgUdOsg338zO6CS2B5QefQCcvw0IwCuvTwmSLFMYzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708699979; c=relaxed/simple;
	bh=sgx0r1cn9JSy0yPc7VwhrZv9QBTVEh5xLqCzgNCv6v8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V5YcMhl9yqAHJCp5jb4GzGMoNcRTTPsevKkuNKysj+n/7z94treGDOKBJdM4j6oX8kEMSnKvtGV6fE3exsjZ87lHYLX1nW/hsGK1L72BU/z5ufr1JKgJkbrh033uxggZoJSRvV/Lyjjqtr6D02P1LkInLu4kB3wzePc1hALUZpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g6A6twrN; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso330516276.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 06:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708699976; x=1709304776; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l+Bp0j81YCtt42ZPmce2E9eJ5egKQ53HbTyLQykPyKo=;
        b=g6A6twrNqwBZfmb2TSFOpBGFS5fHhoy7Aj226PIEwoCwLZxU+I1uhA9PhkEjgYogzI
         emVFX18YWO6Jfi6d5WufvSmJXgo+yEUzGviz1wC3a81ZWu1vqfjOCzmFS3YmsSJebaC4
         /tgQF4ApSEqlYXkG3uK21HzY1DECFQd9ggTWpzHUJ4E6rbcgX/gIbnFhy4qY+dGaBqIC
         BbaHgkEzy130mYcXUIea+08AwDaRc8ep1W971abun5TiWqOsvTVCMRYGD9Qt/Xfa6LLY
         2rFDRGSYwjEQM2tMPB2WiIDCukXgFV1gVPnKEiV+IAaKHdzd5ab3Tk23NqKzR6S3HIft
         1lhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708699976; x=1709304776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+Bp0j81YCtt42ZPmce2E9eJ5egKQ53HbTyLQykPyKo=;
        b=j6Ntfqd7KgwGChvGP4X/RlgViINv5G4wLjnZT5H+g8w39MF4jzHtqRqH2i83YScAow
         YDD2NOFIJBpvM0w2vIcNCK28JZ+53r6CggbdWJD1pvdlIoZyqbqBRItooS05HPVjcKrp
         WsBX9uZaYT1lpw1QoPCik1U/idIcOD45pirdqmPiX7V+fs8fBx67a3Ptnq/EQOapyNcE
         75OxriWGMLI+0HGkO0OqpQgbVatmH6iOPdt36SAHTugUnQyhQF5i97/7qEBeA+1Z5H2a
         2b5K/GGN0hQir2ZgEtMW4P8hjJOCRinJN7nmLE/K0V4ffsYnySu9/kD6BaOI1s5mMxPk
         5/9A==
X-Forwarded-Encrypted: i=1; AJvYcCUX5JEzcEzcJbmvrM+gRPn9/q2c4P5n1IAty9N+mRmzZEj4MAbtA7QlP1d/GzYLNctirvx/ZrB7uMmTiCqXYAwyKkJr
X-Gm-Message-State: AOJu0YxU2hhxkxxce14xz4YmY0X/fmO5yISn5HqUwPuqJp2PLHbUfEU5
	sA7qjaIy8f4e2E8vyMoB7U3iodR1kxbYxeuZtK+7ZNKStVSvaRSaejqLfsBJUOvmaOPcsO/SsqC
	y6A==
X-Google-Smtp-Source: AGHT+IFsKbhlFnATB5gYLc7WLIJP1veqgO3O5Q/ZIxfdoCHH26QD03eVbmQtjtv74Gd85+YzuQm8LGSj9MY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9bc8:0:b0:dc7:4ca0:cbf0 with SMTP id
 w8-20020a259bc8000000b00dc74ca0cbf0mr972ybo.3.1708699975965; Fri, 23 Feb 2024
 06:52:55 -0800 (PST)
Date: Fri, 23 Feb 2024 06:52:54 -0800
In-Reply-To: <20240223104009.632194-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com>
Message-ID: <ZdixRhEuGs9btjJa@google.com>
Subject: Re: [PATCH v2 00/11] KVM: SEV: allow customizing VMSA features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> Paolo Bonzini (11):
>   KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP
>   KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
>   Documentation: kvm/sev: separate description of firmware
>   KVM: SEV: publish supported VMSA features
>   KVM: SEV: store VMSA features in kvm_sev_info
>   KVM: SEV: disable DEBUG_SWAP by default
>   KVM: x86: define standard behavior for bits 0/1 of VM type
>   KVM: x86: Add is_vm_type_supported callback
>   KVM: SEV: define VM types for SEV and SEV-ES
>   KVM: SEV: introduce KVM_SEV_INIT2 operation
>   selftests: kvm: add tests for KVM_SEV_INIT2
> 
>  Documentation/virt/kvm/api.rst                |   2 +
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  81 +++++++--
>  arch/x86/include/asm/kvm-x86-ops.h            |   2 +
>  arch/x86/include/asm/kvm_host.h               |  11 +-
>  arch/x86/include/uapi/asm/kvm.h               |  35 ++++
>  arch/x86/kvm/svm/sev.c                        | 110 +++++++++++-
>  arch/x86/kvm/svm/svm.c                        |  14 +-
>  arch/x86/kvm/svm/svm.h                        |   6 +-
>  arch/x86/kvm/x86.c                            | 157 ++++++++++++++----
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/kvm_util_base.h     |   6 +-
>  .../selftests/kvm/set_memory_region_test.c    |   8 +-
>  .../selftests/kvm/x86_64/sev_init2_tests.c    | 146 ++++++++++++++++
>  13 files changed, 510 insertions(+), 69 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/sev_init2_tests.c

FYI, there are 4-5 minor conflicts with kvm-x86/next, and going off my memory, I
think the conflicts come from ~3 different topic branches.

Given that this is based on kvm/next, I assume it's destined for 6.9.  So maybe
rebase on kvm-x86/next for v3, and then I'll get my 6.9 pull requests sent for
the conflicting branches early next week so that this can land in a topic branch
that's based on kvm/next?

