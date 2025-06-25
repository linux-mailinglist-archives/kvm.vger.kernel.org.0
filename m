Return-Path: <kvm+bounces-50763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60973AE9112
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8881189D980
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D92B2F3C14;
	Wed, 25 Jun 2025 22:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RAe6HYud"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088FD2F3C11
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890437; cv=none; b=mzXf7z6Z8hPnQJzW98/lQbEXAJ/ctDJJGgfeaC3ZfUNIquHJ9Z+i2YC3vrkUuCoNsnvaVII7gUGFrWUdVQ19a/qFhNZNWpX35aEev0hdSPb7EuZlG5JK6C6uBxftIxnMpUIvnyNkeS3O1wxXfAERNJgHaCyNhTB8InPDnZ/HGZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890437; c=relaxed/simple;
	bh=SJTTshElcz4YKEFpktu6YHhF9M5xQBdck5cNqKIQSnA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MrQUqeh04QdVVAoijgozJ8ZeNRgtzzv75i5X0+Bbd/LQaUQf3rvsLfIJm0mW341Aui5PQJkhDMnjNUBgwIemQES/di1KZrgKbl2vCFKjOVIaZDVQZh0nA86JGt5SjbDnR8c8b6u1v74sVdCUQIcEAC4LKptbFUl1UR15uMnhRg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RAe6HYud; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ef4fb5fdso243152a91.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890435; x=1751495235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CpUqVVV7KfIPY82047Vzd+2D5AAvwzq4x0iVdv/BQVk=;
        b=RAe6HYudpjoroAcO3SSb141TcO4xDaJik8AmWYPPcd6Hb/gD1c5Jw0AVxrqf77hewy
         zfTEsNDAz/IZkSOsgnTPE57RFjioVVu+aLPwLTUIfrEKEVT5eNTWCFzoMF5lFUrvaUEc
         wDfBIUG1/7x6KHxwwLSJDtdBphNwCJrPczQLqL+87HKpGXa62PqOlppzNumFUSK0/nFs
         okKNDg2hVNpKI0wS63uZuvOwAn1M0PUgwNdBZ/dOGtRHVhUxmCZTe371/V/7sY3F3W1G
         pEV5mMdSbhaXf9jH2KFGS4i66kIiXT5sxI/GURPUYVRqxdOJOTZ5jmbEzYfHhRx0AWkN
         qkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890435; x=1751495235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CpUqVVV7KfIPY82047Vzd+2D5AAvwzq4x0iVdv/BQVk=;
        b=pvbP8ATElcjQILIb8ANfoAQlANfPQiPkjFm0q57rEWh1hixsIOA5jQ0NatFH5yzgY4
         Xradk94GWyzyiksXwAGKoid6e/VFCFPUVRG+1H81gL4E705VaDtPOREdn1c0/9NhtSVH
         GckkC9Bu+KNKwinW6jLuvy/BhzHYjR5Xf8nCNFS7Sx9Zro82gPHUCCWfVqYy4KeBZO6q
         GIuf/8evNPhLuhZuDslTng8TgCSk5uuX7fqYfzltnNk9Lfo7a2DgRtm3jRGjKHldbO2W
         LfqLpSuU/tdg9gEdsU+J5wk8E8b5DvXKYiu2+cwowXR3rlcM1mxpBxiFUiDXyAZ/X0Qf
         7tJw==
X-Gm-Message-State: AOJu0YwIOlEmvvZ5lJti8Q1kw/UAAkXe1uzI/vRJ8HPpVvt4Jbv8jN+V
	N8ZltuLbrzTjKPvRJxYwW7/iXcRflU8MF9aD3IgjX1Otce7H/+0DV4UAzuNK+yvlKMXbj/pGPLF
	ZJQV68g==
X-Google-Smtp-Source: AGHT+IFvrZ9N/TZME96MEzMk+n6bW8N5EzYdhXmn0e0MFvOMMQqxHorY8wmklg1KPF6/co5YwpN4iAotXuo=
X-Received: from pjbtd5.prod.google.com ([2002:a17:90b:5445:b0:313:551:ac2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:520f:b0:2fa:157e:c790
 with SMTP id 98e67ed59e1d1-315f25d69c7mr6873542a91.5.1750890435355; Wed, 25
 Jun 2025 15:27:15 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:41 -0700
In-Reply-To: <20250605192643.533502-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192643.533502-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175088941700.719432.8505387164025679036.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] x86/msr: Add SPEC_CTRL coverage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 05 Jun 2025 12:26:40 -0700, Sean Christopherson wrote:
> Add test coverage for SPEC_CTRL, which detects the bug pointed by Chao[1]
> when running on hosts with V_SPEC_CTRL.
> 
> Note, this applies on top of the X86_FEATURE_XXX cleanup[2].
> 
> [1] https://lore.kernel.org/all/aEE4BEHAHdhNTGoG@intel.com
> [2] https://lore.kernel.org/all/20250529221929.3807680-1-seanjc@google.com
> 
> [...]

Applied to kvm-x86 next, with X86_FEATURE_STIBP gating STIBP (thanks Chao!).

[1/3] x86/msr: Treat PRED_CMD as support if CPU has SBPB
      https://github.com/kvm-x86/kvm-unit-tests/commit/5cd94b1b09aa
[2/3] x86/msr: Add a testcase to verify SPEC_CTRL exists (or not) as expected
      https://github.com/kvm-x86/kvm-unit-tests/commit/70445405573d
[3/3] x86/msr: Add an "msr64" test configuration to validate negative cases
      https://github.com/kvm-x86/kvm-unit-tests/commit/55c6fc875a60

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

