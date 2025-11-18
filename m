Return-Path: <kvm+bounces-63620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 63EBFC6C01F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 52376355466
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78442324703;
	Tue, 18 Nov 2025 23:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zabCpEyI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E6B30FC07
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508512; cv=none; b=K477nIuoIqk9Du2bG28wsnKwULEKsoPmiYRfQkWXFPD6o8Ods0sUo6yocBEjSe/R5bxcTOCr/D+oxeVd4+qc60kBL8PQOV4kI2dlJIkAh/N7j7ognESEuL/7M94fhqN0ySF1PIhtnFnpMoNcSa+O7NG9HibDAMUIZlYyedFZc5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508512; c=relaxed/simple;
	bh=q1ptivJz6D4DNMabiCY1wVz95iqj6GnJQ7GldF/+6U4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qRzRKc+VFQ2F1avVtXO8eyi2KUj8IXkmwDY+W0obIYMyZiAjhvACZvUV+2e2iycjWsC4XTjCUf4AfQIEmN6cBmTkaTBsKxicN4XOZpyfMneaUGUcSPWSr0JPK440GZMqOJqior5iaVYQk9DRyNZkk1yw1mfe5xXI1Z6AXhI1MjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zabCpEyI; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2982dec5ccbso107489985ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508510; x=1764113310; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=htjVngniKPfjN2k3nlNCRTEvGTx431La5h3SreCcn5M=;
        b=zabCpEyI68hqbi/M2Cs3eEbDj655tPCwXuPZjUH8/58isi7GVuVujByjRWpz8Tp1yn
         MDWBz4r2TFJDZZd0ysQSxJJ+bg/yUtas9ZhfRRdbnvv8cGj7jvuOGQ1OcJfhFxu/6IaN
         3EA1UZMGD/Iu4rxzhrk2Pnq1FWf0gi3qxUNKva9y769W+UOoTHER8rHrOi9ADldc9fgb
         UMAIlYswujh6obSWCp0RtxW/295U0+W9AayNi6XBqwVA7u3VqMBiq+unJx5VCajrybao
         JKsyAOMrqf+wuhprxwsFLtHdo4Z8ddcP0plRcA/CeC2yY6v53yArPdSaCvmagqFW5Ssm
         BzTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508510; x=1764113310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=htjVngniKPfjN2k3nlNCRTEvGTx431La5h3SreCcn5M=;
        b=DKtSaFiFZXR61w7B32vkBJO9j+kQ+Ypdi0lUaCApQsdw0Lft7noBEoUy1nUaYWJK7H
         mb7rZmv2xmTK9neS8qzqZClZCEdtAY4Kq1Lhuo/EgQZOz9uoB6giXm9NTWgLOIunUjEZ
         W1APMKVxZeRAmnPlxwKP3uxvHPcK/hrHLU8cJ++1GoJZjYRzqbqezae48AeVxF6xl58F
         8KGy5Mf5tHj5TCJo1BUTtER9gc9GzRGTzyhsFTLceaV19lnewg2vyfvZ1Rly/6+9a5/X
         TsQ6qZJ2TxoD1Ol1UOz0mTQOEpAO6b7luPstcFiTZryFZ8gjTwj3YXUwSbTWGTA8hZ9Q
         cuyw==
X-Forwarded-Encrypted: i=1; AJvYcCWcYLdXq1JWClda6a4JJ/ZenFVHxXbHpE3n0lljPIGrDyhW16m99kHS3VobPSdpjxb63RI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yycc2vDsJz6QCjPPIFdq2AMpUt/RDnvmF84LlI6ALkpxnCJEFvO
	E+2eY+0aT4H4NUt8nC8iIVc6BqyCrt8/Dnu0ll37H/bxdlOrR6uUE5HBA1irnsu1HN3BWxDHaC3
	LFqvv1w==
X-Google-Smtp-Source: AGHT+IGRwywskTiaB+9UIChqbvYZhdIZZyYBEDYSXpeft/pDEprGhxIvD5eywHxsXL2yEbGStSsOymAw6YA=
X-Received: from plbjf21.prod.google.com ([2002:a17:903:2695:b0:29a:1de:14aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41d1:b0:295:7f1d:b02d
 with SMTP id d9443c01a7336-2986a6da8a4mr232101165ad.22.1763508510205; Tue, 18
 Nov 2025 15:28:30 -0800 (PST)
Date: Tue, 18 Nov 2025 15:27:52 -0800
In-Reply-To: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350842093.2286875.3442084125951747095.b4-ty@google.com>
Subject: Re: [v2][PATCH 0/2] x86/virt/tdx: Minor sparse fixups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 03 Nov 2025 15:44:35 -0800, Dave Hansen wrote:
> Changs from v1:
> 
>  * Add Fixes/Reviewed-by tags (Rick)
>  * Add some "backwards" KVM changelog blurbs
> 
> --
> 
> [...]

Applied to kvm-x86 tdx, with the scopes changed to "KVM: TDX:".  Thanks!

[1/2] KVM: TDX: Remove __user annotation from kernel pointer
      https://github.com/kvm-x86/linux/commit/228add34dc2f
[2/2] KVM: TDX: Fix sparse warnings from using 0 for NULL
      https://github.com/kvm-x86/linux/commit/27376465e945

--
https://github.com/kvm-x86/linux/tree/next

