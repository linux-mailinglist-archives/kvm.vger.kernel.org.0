Return-Path: <kvm+bounces-20705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8A691C95F
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D50FC1F23D0D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A40612F5B3;
	Fri, 28 Jun 2024 22:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DvXQQ4eg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C39823CD
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719615411; cv=none; b=adDsNIHmD5MUG1749iWEOUo36iY7T5CnVIoFs3G1oKNeiaB2mxujUJ2J5li0x6Hz8FN3fMLpoyv6epRGox8gkZE/1NiogyRUE1fypt0Yle5div02jPcUx4nRqOqVMbjJVPPCJ/XlKztnx2A75Ky6UG8jKNzQBKB6cyrg9fvhbjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719615411; c=relaxed/simple;
	bh=/95xVCWbm3t7YOVXqDkLboZ53C0OpBAqJPDDngxswyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eoNvwFkhh7vhFAmtmDoO8wYout80qFhM/kUpbJf0Pb0YAhDI1qIU3zHckZuaD1PQCmXMNi3v5d1JC2UnoHi59zlJ9pSIiOBOQQfaSPGP2hb137rK9V1S6S3BXw7oyTpw5abckag3u7lKBGb2bY1/u/TTG2czjgSshf5fpFsLuoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DvXQQ4eg; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-706a87c62a4so961098b3a.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 15:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719615409; x=1720220209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BrzQMotGRkcotbLCLtHhohCQXvG4H2zp0GaZ+YJKEmc=;
        b=DvXQQ4egg3/X4wpL34XdHZrdKBhFUuisVUXdoq2Nc1G6h+Ypnbp05gFZNwHTn2Ym0Y
         8EkMKNReiaY1fixoXz5cE6oVeYp0+p6mB7+LJsXVnfZ9HRHnCDP8rvCVRb2444IVkybF
         JTGv4QFI5wgCGFZ2340/z7TGgR1mpbjYPWLqMRQdbjIPOwqqAWSjOxAbOravwLi5lbDb
         67oTVx6YaxQcUsriOjDodX/3eH3oVTDK4nUdSkb4wJhr31ZW8i/B6jA0c/beEIXInWXe
         4OEe74ej95bY5gRNnuIY21lKDGFR6FFJnHnfzxjYIf1bt2lK06LuEkPgKuiGmz6ETgHS
         EALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719615409; x=1720220209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrzQMotGRkcotbLCLtHhohCQXvG4H2zp0GaZ+YJKEmc=;
        b=PjZuC7da+qoBmbW8nR/aqV76C/pKCiyJavEdVPFckqem3e6PxipqjRFWL17PowgZ9A
         X9o2EZWurRvkDzABm140TCXhvNOur0mMCKHpmZtYecf0Nah2smXpEuQBZBEyeFOiT5kO
         IWrjHme4SXQmEOSyqYMT135IoZ4BCbUjfNNU8JTogGxWOITg5/YaEZBBgDMmnnmxsFof
         ldMdt6KRxzlp6toRJj2YweU8Rv98Qu5DyJymKpYdNGbtMbu5s45kKG7D3nmlIGYxl+m2
         QXDNrUh7t5lCx3j5rNOwd1E3u5hYKdW3umGQThApfyDeMFn24/SzIjZE41BOgYRNAZpL
         PRqg==
X-Gm-Message-State: AOJu0Yy+DXzfnVWQPiUHr7qODXy8grGooR3bXyORMZIdDQY03oz1tamk
	geR5A3W7AwmDK8+TAF6vfJS1FUE3VfmpEq7jujefU68IE5Ax8GvFPriwr51pGFOSJjRL3mwggu5
	Fdw==
X-Google-Smtp-Source: AGHT+IHjjNFn6x00E94c9EEhfaVJtnscf0oMNDv0skTLcGCcmAGv48P1/+4wcAHD2P1pLHWR10rR3ydjG4k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6c93:b0:706:3421:740d with SMTP id
 d2e1a72fcca58-7067455298amr194274b3a.1.1719615409520; Fri, 28 Jun 2024
 15:56:49 -0700 (PDT)
Date: Fri, 28 Jun 2024 15:55:30 -0700
In-Reply-To: <20240627021756.144815-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240627021756.144815-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <171961447393.238177.16381669170137224353.b4-ty@google.com>
Subject: Re: [Patch v2 1/2] KVM: x86/pmu: Introduce distinct macros for
 GP/fixed counter max number
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 27 Jun 2024 10:17:55 +0800, Dapeng Mi wrote:
> Refine the macros which define maximum General Purpose (GP) and fixed
> counter numbers.
> 
> Currently the macro KVM_INTEL_PMC_MAX_GENERIC is used to represent the
> maximum supported General Purpose (GP) counter number ambiguously across
> Intel and AMD platforms. This would cause issues if AMD begins to support
> more GP counters than Intel.
> 
> [...]

Applied 1 to kvm-x86 pmu, and 2 to selftests.  Thanks!

[1/2] KVM: x86/pmu: Introduce distinct macros for GP/fixed counter max number
      https://github.com/kvm-x86/linux/commit/f287bef6ddc2
[2/2] KVM: selftests: Print the seed for the guest pRNG iff it has changed
      https://github.com/kvm-x86/linux/commit/ea09ace3f8f3

--
https://github.com/kvm-x86/linux/tree/next

