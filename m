Return-Path: <kvm+bounces-72867-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ME/uCtG6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72867-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:18:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6A8216082
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C390F3093DCB
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239A83E51D8;
	Thu,  5 Mar 2026 17:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OeYN8Hiw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F9A3DBD6F
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730770; cv=none; b=eY35OndAZIW/3JhAfXfR3osOx/lk9ZDNQVYPNl8gQVrPJ1VJajfL068noXmfiDVonsLB7/AlwzkOd/+cjHcVjgGCp48ugAosSCKw27VK9g5C//02bgW5uKXSSTtign7e0tISK39nsTDrc2YflLZ4A2e/z6/70LvHqvsyWgEHip8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730770; c=relaxed/simple;
	bh=ZaBb4JNwBVgVwOLsXtYZ0XbkOEfJ9ksmC7f7Vu/tW6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q2Zn0rS0DEcUOIRVAaMYn9bQGSuxKEt7BGxSyepANWixlUDXEjVMly3iRIhLQ8Bu1bCm2otXiIcz2UvfK8aYbwH/U/I8r96oZmogUdyVJW4zsaVe9W4i33UxwdjlJhIDnOkfCwIvGoTJvi8aGQ+Qf3SLEbwNi/g1/cH3OjTzjAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OeYN8Hiw; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so5247373a12.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730769; x=1773335569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1DMtEmZw22gwZCFk8s6N2UxKC05S+mS3q4aVnmQqn4U=;
        b=OeYN8HiwqaF/EHJZnB56e3wr3y1nTpYRjYn4FhS49cdbuVhJ0WBDVx8byFpH4UWngV
         nT0Ft5flxF+qjEyxIuNOk12qqi7OWGBeyAz78K1NK5oheOYBdsSm+ocifBAicgyooMRQ
         TkV8jEeN9szS4yQRHoGUjuC54ey2QNi2Mm/QMLy2rNxKYJpNCC8vSANgbZhHjqpS8nsO
         dx1W7eWMsa11dwovH68RcxE2cuLB1K2uKkRFwsjCf8T3XNSBGqqDtK89p87OlNmXOT8N
         hImPfjryXYW4vfUMjsC8OPFed64Adv6dW3iOeboun+3skI7m/9zx869RLK2ewqSL55Co
         Eepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730769; x=1773335569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1DMtEmZw22gwZCFk8s6N2UxKC05S+mS3q4aVnmQqn4U=;
        b=oFryZQi5baqhf8yV+Uly7Eu/SUO1v4umb1X3/PJqiJHk+qIf95Qr+uuAF1uFAq6gy9
         LmnUBFkliqOxyGiDQgjhhFVneqO0xDxrCEznLyaGGHGFowzbFC95txpPQtdHOWTSEWwp
         5gvZ0yb77bFKrdP83NmBSy3lSYq9YgmZRWnPP302PLb1AOcSba4roiW5FFAPDeJ6dlKR
         U6Culc/bf1C86kErCjisA3h8wMucLw9o/EcZcn97XxgDCuZp7Lq2Sj0GGE6tf158ESW4
         eCcRFbDmT4QjxrZMlkqbn/pND7oASaUs83aZeBYWqqErArssLRQ5LtUlh0Kb8CyLhWqR
         zG/A==
X-Forwarded-Encrypted: i=1; AJvYcCXk3dba9N3HY7phhWlsFWSh+6uVDeWnLwRZEky9L9FPAeqCmydrBjnV7pTfRVf6bHv9t1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC4DOVObC8NuESa7855gcvBAweIA2FTItIWKkn8beZOfCM7Txn
	JpPlk8xazkQeRh6DvMwMMSfe/yOHbrYG5rP6V1MgC9iVJwyJ0wHWyMtSC73VrudOLNdO1+f1uma
	zmWMxAA==
X-Received: from pfbbk2.prod.google.com ([2002:aa7:8302:0:b0:7fa:f279:2d1d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b15:b0:829:8e38:65f
 with SMTP id d2e1a72fcca58-8298e380cebmr1843029b3a.8.1772730768467; Thu, 05
 Mar 2026 09:12:48 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:23 -0800
In-Reply-To: <20260225005950.3739782-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225005950.3739782-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272749875.1550510.3992327395685137590.b4-ty@google.com>
Subject: Re: [PATCH v3 0/8] KVM: nSVM: Save/restore fixes for (Next)RIP
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: CB6A8216082
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72867-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, 25 Feb 2026 00:59:42 +0000, Yosry Ahmed wrote:
> This is a combined v3 of series [1] and v2 of series [2], as patch 1
> here is a dependency of patch 5. Without patch 1, NextRIP is not sync'd
> correctly to the cache, and restoring it for a guest without NRIPS is a
> bug.
> 
> The series fixes two classes of save/restore bugs:
> - Some fields written by the CPU are not sync'd from vmcb02 to cached
>   vmcb12 after VMRUN, so are not up-to-date in KVM_GET_NESTED_STATE
>   payload (fixes in patches 1 & 2, tests in patches 3 & 4).
> - Ordering between KVM_SET_NESTED_STATE and KVM_SET_{S}REGS could cause
>   vmcb02 to be incorrectly initialized after save+restore (fixes in
>   patches 5 to 7).
> 
> [...]

Applied to kvm-x86 nested, with the mess of fixups.  Thanks!

[1/8] KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2
      https://github.com/kvm-x86/linux/commit/778d8c1b2a6f
[2/8] KVM: nSVM: Sync interrupt shadow to cached vmcb12 after VMRUN of L2
      https://github.com/kvm-x86/linux/commit/03bee264f8eb
[3/8] KVM: selftests: Extend state_test to check vGIF
      https://github.com/kvm-x86/linux/commit/2303ca26fbb0
[4/8] KVM: selftests: Extend state_test to check next_rip
      https://github.com/kvm-x86/linux/commit/e5cdd34b5f74
[5/8] KVM: nSVM: Always use NextRIP as vmcb02's NextRIP after first L2 VMRUN
      https://github.com/kvm-x86/linux/commit/8d397582f6b5
[6/8] KVM: nSVM: Delay stuffing L2's current RIP into NextRIP until vCPU run
      https://github.com/kvm-x86/linux/commit/a0592461f39c
[7/8] KVM: nSVM: Delay setting soft IRQ RIP tracking fields until vCPU run
      https://github.com/kvm-x86/linux/commit/c64bc6ed1764
[8/8] DO NOT MERGE: KVM: selftests: Reproduce nested RIP restore bug
      (DROP - your wish is my command)

--
https://github.com/kvm-x86/linux/tree/next

