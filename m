Return-Path: <kvm+bounces-7499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B3F3842D34
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26CB82869DB
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 19:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C3071B2B;
	Tue, 30 Jan 2024 19:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uYfQn7Fi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB091E539
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 19:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706643808; cv=none; b=ejihfAytm5xZ5jE8HkosfrkvuMj26F1tLkhiNbOgizQSdTzrlbtDB8HHeou8eceWX/zQcR99MiKMlScGhRhFEQTtKkUGVkiZcVbyA4YUukbczZRWYX3xNjjgSs/FPnwbv6ISAIRTG4danYGdY0Edd6/haEfLKbQEHvuTVpXhCes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706643808; c=relaxed/simple;
	bh=vZHFwjdw3PGqkoBZtWT5WREDTSOE01DCGu8cbclWGKw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N8vIH4/GXTrjvTDsa4NwouOz/7oso2azNXrf5CagRlFOWuH4H8dY2rJroPmwZSoSy5TyPAaUOzlUbXsw92hIhqcycr1lHHvDzB5Lt10K9Jk8+wG8bTzzEpRLpscUvrFV/GiAvyo60QOPTjL5mhm7csINwWR0GduA1jTtIzLx+HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uYfQn7Fi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2958f059179so1298284a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 11:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706643806; x=1707248606; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cJ/Mw2QXjuhnR1oiDmM6jnD/EqTbm9PdZ3UZm8gJsPE=;
        b=uYfQn7FiSaHFUOg5Oj79i+k47ssSEQiGM6esRYkUDpKv3jgQk/MfVqwwlJsJ/dhulP
         0wMTi6eYmVdWi+6mcUpX+aFNVMr4fRMy2KEzfY940mOUto1e07KfF+VHe2dD95ql8H6g
         IuizUb/JyZn7g5DB6GzGzZNlk+3ZlllwkdmM/buPF6gGuY68ocbyGE3nRYCz5mWTrz7u
         tGdFsJEsW3FAVOBzHBJSCwR8wN7gMN5vTjzYD+XAn34aEKGbfwDI1pAshw7LHWyAkM9Q
         YSuXllG9A/lxx0IlXxTJnKwAXigJv52xWQQctY968ud6p2AaizlF4bwElycqf/pGZvg1
         TLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706643806; x=1707248606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cJ/Mw2QXjuhnR1oiDmM6jnD/EqTbm9PdZ3UZm8gJsPE=;
        b=bJ8VKuzEV/ppecYgZrQKwuoA75CNsZXN/BtzIhN2dJu8sqIHbeLCl9v7Gr/3CMrhit
         02aaqNJva9g5OFzlpMstLkbNdbNcKiotBPJzZEkoDtYbG4vGVYeQN0ABkpkVbtiVnMbk
         sv5SLf6EoyMIJEo3nH2pBk9Qtz89nEf6qSIT+/s86TU5ImYBvKEncvuehRpeG6KJ2lqJ
         8CZSsU4Fcedd3PxZXFyYv0jHKgnZrK4TxYIXGxX7qSdS6lrwXp70Io7Iz9eA+owkUmSQ
         YlMfsvXyndca2QYg8PA/zSHaZ1EPGPIRm6ub5NRRpxArKVxL4nfid6sAtiMB/XOPW1CS
         nL/g==
X-Gm-Message-State: AOJu0YyLFVFwooecIGj4Bu131K88BGbwlYhhSBg0jh3qHtWu0CD6zbN0
	pNlJtGNjwP9V6kbR5NUG1V3F/2Y29SJCoCMoc0tD5Gf8w27mwIu1b0tx2SXr+0VMJ1Yp4Ey0O0Q
	ijw==
X-Google-Smtp-Source: AGHT+IFA/rqilQHqtHzGtXv0lac3OkTpt8EOaujWVknya8Cx2+Mm+RSfrBuOd/yMu+7KjPynh7BG5gnS8g4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cf93:b0:28d:2946:982e with SMTP id
 i19-20020a17090acf9300b0028d2946982emr55349pju.2.1706643805972; Tue, 30 Jan
 2024 11:43:25 -0800 (PST)
Date: Tue, 30 Jan 2024 11:43:24 -0800
In-Reply-To: <20231218161146.3554657-5-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com> <20231218161146.3554657-5-pgonda@google.com>
Message-ID: <ZblRXDM92WAQepez@google.com>
Subject: Re: [PATCH V7 4/8] KVM: selftests: Allow tagging protected memory in
 guest page tables
From: Sean Christopherson <seanjc@google.com>
To: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 18, 2023, Peter Gonda wrote:
> SEV guests rely on an encyption bit (C-bit) which resides within the
> physical address range, i.e. is stolen from the guest's GPA space.  Guest
> code in selftests will expect the C-Bit to be set appropriately in the
> guest's page tables, whereas the rest of the kvm_util functions will
> generally expect these bits to not be present.  Introduce pte_me_mask and
> struct kvm_vm_arch to allow for arch specific address tagging.
> 
> Currently just adding x86 c_bit and s_bit support for
> SEV and TDX.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerly Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Originally-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  tools/arch/arm64/include/asm/kvm_host.h       |  7 +++++
>  tools/arch/riscv/include/asm/kvm_host.h       |  7 +++++
>  tools/arch/s390/include/asm/kvm_host.h        |  7 +++++
>  tools/arch/x86/include/asm/kvm_host.h         | 13 +++++++++
>  .../selftests/kvm/include/kvm_util_base.h     | 13 +++++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 27 ++++++++++++++++---
>  .../selftests/kvm/lib/x86_64/processor.c      | 15 ++++++++++-
>  7 files changed, 85 insertions(+), 4 deletions(-)
>  create mode 100644 tools/arch/arm64/include/asm/kvm_host.h
>  create mode 100644 tools/arch/riscv/include/asm/kvm_host.h
>  create mode 100644 tools/arch/s390/include/asm/kvm_host.h
>  create mode 100644 tools/arch/x86/include/asm/kvm_host.h

As I said in the previous version, kvm_host.h is a bad name.  There's also zero
reason to put this in tools/arch/<arch>/include, the header is specific to KVM
selftests *and* we already have per-arch directories.

