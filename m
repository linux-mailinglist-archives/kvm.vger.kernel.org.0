Return-Path: <kvm+bounces-14056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5613689E6C7
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8D3E1F21759
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD044A12;
	Wed, 10 Apr 2024 00:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KpCFOrZx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D4B8C1E
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708594; cv=none; b=XYHyeMgYlYrbol0pzMywFSfDexz8jw58DAfKRX4CD8p6Cnug5RWHIxuWa0sYGoSJjXHBRR0mbk0eTNhXlsTdtyJ6R+k6aznay6x+1EHXTB1nBYy94YUuybMisNZvIcMBoZn2/uneLJ4i8pu0APIil+Qg0VXBqmprPEEVsn8pcUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708594; c=relaxed/simple;
	bh=3eu1Qe4PMa3bnntPXg4L7chuLuE2AEuX2iOgmahG7eE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jl7sI9xLPRdHoZ8DJrW23KPDgx5di2Why6y4aq8N7yS/V5x4iGoLktyXiGbzIsuGI5u0Hvm1XCXL+6PJSaHyei2ZB1npJLTbB04Y+9uszUQJlyY7OM3Ju8EFYw9qAqgCDwah3N+9Bv9xFqOzZ+7PPBBha8EyG2wGh5vTdyII00I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KpCFOrZx; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e41a654c7bso19265665ad.2
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708593; x=1713313393; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=28lDu6txVDJUSpWthdWC1Dj1Rlfmeg6/3/6iNxGTIqk=;
        b=KpCFOrZxGptwdOWQZnjCbrQrM5WkGXQwlmrb0f+EAth0XOlVU8dCfpv9+70DqfuNM1
         o185I7sVk+BAItf3NoT+mxD/kR3hm0qF97ZvVgBvHeWqj/PzrVN8IZR/2aPxHdHA0kPA
         BMSxQVKIjgUgrqs4guh8U7ecch/8dg5Q9TumSk6GMGu9TXRCWqHwmbOro9+qVSUUVI58
         /TLYcs3N7M7qF7JoS8MGDDSt9E+iJm4O5M9cPi6CYvNLxyamj3JKvQEZJI2sd/PgVlS1
         LTaPPuqzSTAZ8lc8vS6rymTR7R5RTKTF1iLpvVtzi2GNKNLh9bJOzdTY5Qlc/CgAznrn
         Fyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708593; x=1713313393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=28lDu6txVDJUSpWthdWC1Dj1Rlfmeg6/3/6iNxGTIqk=;
        b=hA0WdMYPqcFcoKpOSUIe5M0CGlOBcyDJis8OMiLFM7L3hu1crFK1Xw6fEqlDOp6M4s
         5AcsajqRK0220k65uJvVIQiYNkxzSNU8EI/bPUGFSlgmxf1AypSYgyNxbnLTTbadDrp5
         6t3mYWFSynt9WZ5X6fU3WT7Qco/CmESIGrA6mlmPCcou4dOBLzI6KDvSH1cOmHJsi05W
         LoOiRq7I3WTzMmfSu3iSpvdZw4hrPVlGdU+xWe/OguTSq9EP7XBzrLlT2QKdxmOu0mec
         DAmPJU4pTH5ROZ3nzocTTo+gUGGPu/VPSoKqYI0BYulKEZh3XIxFPtLYQopC6EezoYWa
         v2ng==
X-Gm-Message-State: AOJu0YyWdMdpo4AMpRCEDktY8o3K5qar15IpniNChMhD2P2L6WnVxu6r
	2YLXAg718cMBA9TWL+MPGkGtsGphcX4fO7TL27J6zgXXSPFAXC7tqP+d/sBI5zLLFGWbeIpGIbs
	drg==
X-Google-Smtp-Source: AGHT+IHmo4wQwlYcsQz+pURXNU+Tpt11cQYRWEckqOHYPPXzGzfW2iV427+NtDA4LvFGvkhNRAm02GTEU8s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32d0:b0:1e3:e0bc:70cf with SMTP id
 i16-20020a17090332d000b001e3e0bc70cfmr70909plr.9.1712708592809; Tue, 09 Apr
 2024 17:23:12 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:20:01 -0700
In-Reply-To: <20240209221700.393189-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209221700.393189-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270506415.1590135.3971044080210389220.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: nVMX: nEPT injection fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 09 Feb 2024 14:16:57 -0800, Sean Christopherson wrote:
> Fix a minor bug where KVM doesn't clear EXIT_QUALIFICATION when injecting
> an EPT Misconfig into L1, and then move exit_qualification out of
> kvm_vcpu_arch to avoid recurrences of the bug fixed by commit d7f0a00e438d
> ("KVM: VMX: Report up-to-date exit qualification to userspace").
> 
> Sean Christopherson (3):
>   KVM: nVMX: Clear EXIT_QUALIFICATION when injecting an EPT Misconfig
>   KVM: x86: Move nEPT exit_qualification field from kvm_vcpu_arch to
>     x86_exception
>   KVM: nVMX: Add a sanity check that nested PML Full stems from EPT
>     Violations
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/3] KVM: nVMX: Clear EXIT_QUALIFICATION when injecting an EPT Misconfig
      https://github.com/kvm-x86/linux/commit/0c4765140351
[2/3] KVM: x86: Move nEPT exit_qualification field from kvm_vcpu_arch to x86_exception
      https://github.com/kvm-x86/linux/commit/a9466078687f
[3/3] KVM: nVMX: Add a sanity check that nested PML Full stems from EPT Violations
      https://github.com/kvm-x86/linux/commit/23ffe4bbf807

--
https://github.com/kvm-x86/linux/tree/next

