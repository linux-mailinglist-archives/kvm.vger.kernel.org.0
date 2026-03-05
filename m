Return-Path: <kvm+bounces-72854-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SOahJgy6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72854-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:14:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CCED4215F6E
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 56E173041ED2
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A8C3E1229;
	Thu,  5 Mar 2026 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j6XZYwSO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250DC3A0E98
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730663; cv=none; b=OaVyRHOUU0xEoDAnda4FyKR2wDyijI4vMGLXm+4eCx+H9dfsWxhNVXhvHqUjthb1BlsPSHqy14a5frjbJpSONSNrucM5/gC3JH1aVw469nJKcvGb6Ub8sMsuNCsXeohLNaFvMNvT8H5lcvJ2rCPuozBkhYUsZKdbj9WVr4Bbl7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730663; c=relaxed/simple;
	bh=vwgoh1YpPCNmEVw+tt+RGy4f+rv+AHH7GLlM+0zF37Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dUetmJhHsETSWK6+7WkNwHUNeaNYiKT6Df3spRoO4T6j9oLrQIVROOaPof8PgOGksr/4VTSuF0dekX+BEfufRyVsFB/CvkZmyfEZwHICwWCm/uhVytnRtm/NAWcx/52EyqAwiEiOK489Lee1dURUGy1BrPn8Q9KaHb4yJer63iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j6XZYwSO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35984ef203bso4873959a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730661; x=1773335461; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjP5vV9RH9OSKAjVvneHEnYGM5u56iDo3DZIIc/IaHE=;
        b=j6XZYwSOjxQvX3YLRI+YDcMCPa3j5sW6EMSSaQhPsWArkQsnJqreqpaJ27A93spmNw
         7KrdhygbosdJGZWvt+7/TElXYW15BBkhIppl/1t3MtrRWQ9HWiEx4XaNTwctJm5xTdS+
         FIfG1gBa504CP/8JPHhk/Rvd28/k1UJwTEPe9oIo+1WYPPgoPWyJIWL8KBRNcTKXWFKx
         z7YVQcM4PF82le0d/YGWWX5B2x3JH/iCkf8QFyHpq+0Dq4foPb5HgEkYF6NxxGgAl6xp
         FGQpbNwq+QUBbZyQyoXXqMdF7fReA0i8d/gPeCOD3h3LSLPyNrbCnYh15XoQmQD66L57
         oRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730661; x=1773335461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjP5vV9RH9OSKAjVvneHEnYGM5u56iDo3DZIIc/IaHE=;
        b=p5UkikDbfTlqH/bBXZUoO8MH022C2oWsSK1dfuyFEezH1N/5twhen9VtbDxcZN9dJV
         42sXwS7Mkd3hZxivpND4aen4bVfrvE+QKeY1gaRBdcDKAj64w0n4sF0lYFKeShnUHL6N
         MCIqSYvoie74wXJW/86omF7h2trWmg4KJ/8Q2PEERxBM7A4tP4qbNm7oepDbS3milzra
         Pu1K3s96NmR8Cg8uZvw31InGFe5CLR+NhS1tqikbJkbEf0BC2m++ZGcMU29FYodqe5FL
         llbgBJXEdjvdysEyyPXdnn5yuuN0WtVthIA09vn36/Wzrb9VUmh95wC6kwZ2xrQSd0eU
         f8dA==
X-Gm-Message-State: AOJu0Yxosl5iOk+ugGKTgcUtTmtr8i78INxv1u2QAu3VB4BPvruP5o8x
	lT5+oqeBYYkvXP581Cwmma45zNjIcq00Jfl5ApoyIFex4pmuoZrqXxf5t6gH0hSxvG1DqROeFwD
	RhTfEXA==
X-Received: from pjj5.prod.google.com ([2002:a17:90b:5545:b0:359:974a:3d42])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:510f:b0:32e:528c:60ee
 with SMTP id 98e67ed59e1d1-359a6a52fb0mr6143772a91.24.1772730661449; Thu, 05
 Mar 2026 09:11:01 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:57 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272739326.1549300.4569691006460007231.b4-ty@google.com>
Subject: Re: [PATCH 00/14] KVM: x86: Emulator MMIO fix and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yashu Zhang <zhangjiaji1@huawei.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: CCED4215F6E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72854-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, 24 Feb 2026 17:20:35 -0800, Sean Christopherson wrote:
> Fix a UAF stack bug where KVM references a stack pointer around an exit to
> userspace, and then clean up the related code to try to make it easier to
> maintain (not necessarily "easy", but "easier").
> 
> The SEV-ES and TDX changes are compile-tested only.
> 
> Sean Christopherson (14):
>   KVM: x86: Use scratch field in MMIO fragment to hold small write
>     values
>   KVM: x86: Open code handling of completed MMIO reads in
>     emulator_read_write()
>   KVM: x86: Trace unsatisfied MMIO reads on a per-page basis
>   KVM: x86: Use local MMIO fragment variable to clean up
>     emulator_read_write()
>   KVM: x86: Open code read vs. write userspace MMIO exits in
>     emulator_read_write()
>   KVM: x86: Move MMIO write tracing into vcpu_mmio_write()
>   KVM: x86: Harden SEV-ES MMIO against on-stack use-after-free
>   KVM: x86: Dedup kvm_sev_es_mmio_{read,write}()
>   KVM: x86: Consolidate SEV-ES MMIO emulation into a single public API
>   KVM: x86: Bury emulator read/write ops in
>     emulator_{read,write}_emulated()
>   KVM: x86: Fold emulator_write_phys() into write_emulate()
>   KVM: x86: Rename .read_write_emulate() to .read_write_guest()
>   KVM: x86: Don't panic the kernel if completing userspace I/O / MMIO
>     goes sideways
>   KVM: x86: Add helpers to prepare kvm_run for userspace MMIO exit
> 
> [...]

Applied to kvm-x86 mmio, with the hardened version of the helper in patch 14.
Thanks for the testing!

[01/14] KVM: x86: Use scratch field in MMIO fragment to hold small write values
        https://github.com/kvm-x86/linux/commit/0b16e69d17d8
[02/14] KVM: x86: Open code handling of completed MMIO reads in emulator_read_write()
        https://github.com/kvm-x86/linux/commit/4046823e78b0
[03/14] KVM: x86: Trace unsatisfied MMIO reads on a per-page basis
        https://github.com/kvm-x86/linux/commit/4f11fded5381
[04/14] KVM: x86: Use local MMIO fragment variable to clean up emulator_read_write()
        https://github.com/kvm-x86/linux/commit/523b6269f700
[05/14] KVM: x86: Open code read vs. write userspace MMIO exits in emulator_read_write()
        https://github.com/kvm-x86/linux/commit/cbbf8228c071
[06/14] KVM: x86: Move MMIO write tracing into vcpu_mmio_write()
        https://github.com/kvm-x86/linux/commit/72f36f99072c
[07/14] KVM: x86: Harden SEV-ES MMIO against on-stack use-after-free
        https://github.com/kvm-x86/linux/commit/144089f5c394
[08/14] KVM: x86: Dedup kvm_sev_es_mmio_{read,write}()
        https://github.com/kvm-x86/linux/commit/33e09e2f9735
[09/14] KVM: x86: Consolidate SEV-ES MMIO emulation into a single public API
        https://github.com/kvm-x86/linux/commit/326e810eaaa5
[10/14] KVM: x86: Bury emulator read/write ops in emulator_{read,write}_emulated()
        https://github.com/kvm-x86/linux/commit/3517193ef9c2
[11/14] KVM: x86: Fold emulator_write_phys() into write_emulate()
        https://github.com/kvm-x86/linux/commit/929613b3cd1a
[12/14] KVM: x86: Rename .read_write_emulate() to .read_write_guest()
        https://github.com/kvm-x86/linux/commit/216729846603
[13/14] KVM: x86: Don't panic the kernel if completing userspace I/O / MMIO goes sideways
        https://github.com/kvm-x86/linux/commit/4f09e62afcd6
[14/14] KVM: x86: Add helpers to prepare kvm_run for userspace MMIO exit
        https://github.com/kvm-x86/linux/commit/e2138c4a5be1

--
https://github.com/kvm-x86/linux/tree/next

