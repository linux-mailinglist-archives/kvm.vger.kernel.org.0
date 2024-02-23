Return-Path: <kvm+bounces-9472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A3F860861
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4B86285BAE
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E3B1643E;
	Fri, 23 Feb 2024 01:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GaX+A1cq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB25E168B9
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652222; cv=none; b=hk/eV2LZTC3/eIzdKmrcj9ROKyv4Tv6xLZcnqZ4tyGhkYhRChVUlnea7mq3fkv7TF9yCjxf4VZmFRIGqpk8IdmuwNGfgp8sz1edOI8pV4y88YvHY/SL37lagywijRy2EyzPt4EgNP8a/fGo5Co266SlKbf8ReY+xq4pJhXIInx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652222; c=relaxed/simple;
	bh=VXpwlfK71J4KbEEFIeZ7tUQyBMbEOHN9OdsL7t/D7hk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uWDYUfjF/OOpmtjlxSwS+fhVSzjTCTCEB4trzuhR1ew7FCPPpXCOKUTvGlUD7qNg3XXVJAPMK/5u9xa3DaJTQF4/5ILAEsDkfpdlptTRdvwLWiTRyB7+ZxXHCWTSEfjkuyRhpJnAYZS0plD2RrIR+Hal9aw4TB2IqWgbHYJhP2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GaX+A1cq; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so557197276.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 17:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708652220; x=1709257020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g+GUOl5V+17CoJouuTsco7mvhC5Ywx7x7NMBcMgxpQI=;
        b=GaX+A1cqEB/8VOjHGr4AHtPllv2dxCv5jCm957uGDtKL1T3Ka0Ypfcr4uk2L+GIjwT
         5JHEVmTzjA7WuwphheJVCv+5MtljthjXv5dCkE2d6C78d5Whln54ELHes2zO6+kKRf+9
         k3WyUYWrEtt/+khNw/Gg8zAMGBDQmL3G1X809d88NxD/rVwgyH4vD58Vgz/J5bkw77fs
         h+Z9amKp2mqP9UnjTZ7BYXWuTOMOBMyLL8Hjs49ipV3iFlzMM1ojTZP7y4B8R8X08usm
         xHX/aZvz+MUaRfdwDpGZNVhpTg8/M2WQlK69JIMDvaJI8eGjwpeZ7sf4TW5AT3REODIU
         GAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708652220; x=1709257020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+GUOl5V+17CoJouuTsco7mvhC5Ywx7x7NMBcMgxpQI=;
        b=dghkYtrtbUECEob/L9Co1HvLozWUCn0o9kPiWtv4Lad4ebyv3XlWfkLzEowXpuQI8Q
         HQfHpd2UTU+11I/3kpL2NSp42z0UTQHsqxWZWDQh29tdcXLcmLqQ0XQA/EsPWBDFr33G
         MGM7v8DiFE9+EOL/lkoUcLDMU2Qgmvy4gQtc98qYrqeofrLe3ovm93nwmfXNG2ajxHsI
         u76f0ZMFuScCekMAMzbHQ3K2VuHy7P8Wd5sfrAfenBjbbUFabX7ReTpgCyWWyHvzIZw1
         70BYb5gK9g8J25X4LIpGfIGMCare3zwYZJQEeJ37JNrTxbwmN3tLkDFwlQpsOXw/m5wQ
         G1sA==
X-Gm-Message-State: AOJu0Yzv7ekEgqiz623kAf45lTXl/HPPIKAN4tPczWKKTTUzAsTT3RAC
	olXabvolCgMHspHBrvp0F6VdTOAokziutCWiiGPOq5dM1WOs7RKO6GG2Hj2+BsKtC1DnXFV2F0o
	q1w==
X-Google-Smtp-Source: AGHT+IE6j9Q8ldQJogtuiWU9nF0CUi0jjFOCBiv1P76aQruSkWj7RbwizXHz4RiGug8hb8qauQu2sf4lRzc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b120:0:b0:dc2:466a:23c4 with SMTP id
 g32-20020a25b120000000b00dc2466a23c4mr219620ybj.4.1708652219843; Thu, 22 Feb
 2024 17:36:59 -0800 (PST)
Date: Thu, 22 Feb 2024 17:35:52 -0800
In-Reply-To: <20240110002340.485595-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110002340.485595-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170864656017.3080257.14048100709856204250.b4-ty@google.com>
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yi Lai <yi1.lai@intel.com>, Tao Su <tao1.su@linux.intel.com>, 
	Xudong Hao <xudong.hao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 09 Jan 2024 16:23:40 -0800, Sean Christopherson wrote:
> Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
> enumerated via MSR, i.e. aren't accessible to userspace without help from
> the kernel, and knowing whether or not 5-level EPT is supported is sadly
> necessary for userspace to correctly configure KVM VMs.
> 
> When EPT is enabled, bits 51:49 of guest physical addresses are consumed
> if and only if 5-level EPT is enabled.  For CPUs with MAXPHYADDR > 48, KVM
> *can't* map all legal guest memory if 5-level EPT is unsupported, e.g.
> creating a VM with RAM (or anything that gets stuffed into KVM's memslots)
> above bit 48 will be completely broken.
> 
> [...]

Applied to kvm-x86 vmx, with a massaged changelog to avoid presenting this as a
bug fix (and finally fixed the 51:49=>51:48 goof):

    Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
    whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
    enumerated via MSR, i.e. aren't accessible to userspace without help from
    the kernel, and knowing whether or not 5-level EPT is supported is useful
    for debug, triage, testing, etc.
    
    For example, when EPT is enabled, bits 51:48 of guest physical addresses
    are consumed by the CPU if and only if 5-level EPT is enabled.  For CPUs
    with MAXPHYADDR > 48, KVM *can't* map all legal guest memory if 5-level
    EPT is unsupported, making it more or less necessary to know whether or
    not 5-level EPT is supported.

[1/1] x86/cpu: Add a VMX flag to enumerate 5-level EPT support to userspace
      https://github.com/kvm-x86/linux/commit/b1a3c366cbc7

--
https://github.com/kvm-x86/linux/tree/next

