Return-Path: <kvm+bounces-63205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E826C5D28A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 13:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 02BC54E2A6D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 12:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44EB1C5F10;
	Fri, 14 Nov 2025 12:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VtN5a8Wk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349E81C84BB
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763124028; cv=none; b=n3Ec185G7nAv8+ia/tNlNRyeGkXLR6y4QrAvpG5vc5YnN8R/KDbvV8oELrXr6+Fh1dxlbaB0GnBHTDM2DAAYdLZtrRVdoGt6DuJ7A0MRTt7MsGfTPydKiznADI1UNAI/Wqgqk+OGYQTRgtSi+aSVACx1lxOiIwLSndMO1udHvaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763124028; c=relaxed/simple;
	bh=1S7oMaiMrQhbrBE5JZaaD3PrCA7SNK04RmgkbjRg6zA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E5lnwxdfexYLEu5sUbKbFBZBERuLfoUgd+PZAmI6jbitK3lLTTWRO6eJEFmPKpVICGMpbwkBCPj/VuAnu+nNjqX3A6BNA5Vgkk6U6f7sPWCBo9ouMbSdaQUcgb4kNEMH4sOhWQ0OjjtGUM6dnztlFuzyNO1cXNbkcwSHlQOjq9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VtN5a8Wk; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4710d174c31so18987375e9.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 04:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763124026; x=1763728826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+mnkKCVTFBypK6JgR4pPkzvAmtwTh/tLRTgr+WHrD5Q=;
        b=VtN5a8WkpibviBOENU2EobEtxaW5KYk8vBneVGJPtHg695Otpx21pniKPZDdmL+ZDg
         3BNC2SvJmC8hkO4EHelmBT6nofPnVjpiev7UBA3z10GPgU3/Hh2vIcXLg60bhomU4ZQz
         QcFX4kZCcJ1O5o2MSRQiKkSoRrFgCWrpCd7QSff70mgpO/W9b7xjTMJp2MxG6ec3jrgS
         hBarAr0mqWZDRMkD+H4PxEImuwjygmW052RyLGpPfyphuQd/pvUUu+40LQEb43PUIah+
         DOtn7yTehM47JarTi+7L34sWIelHeTB3elHRxcmc4BfQA22+mE2vyZALSxHyRWhe6iwE
         /Mcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763124026; x=1763728826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mnkKCVTFBypK6JgR4pPkzvAmtwTh/tLRTgr+WHrD5Q=;
        b=xJov5+I0PrFHn/c3AdqvjMKb9v+xLDqGRFh1jfiS6N6b2NhF7GJoaDTjgjjSBovElJ
         rC/RAjsz8oMM082f1NQHVHBdBFH65aHH6aCCjfj5n5YC2MvqumGJu6h7JYxWU0YYKp/D
         YuDXbAItdg9+SXw3+tQpFAgTkS/U7+/7iRuZ3I3kmemBpVXA03JI4DFjQIOsjhPRCq2G
         p8ZD9zBKpb7Ut1fAWnaMH+D2zNi+mIsfrvnq/Ai2+oOD/WS6WG1V5ZK9ccaB190T4fin
         lFJ4P/oEOcqNHv91yDv88ch8Pyx10sxB3g5yLkXf6dMF4W8OytIUBXEHAwH4we9YNWuG
         BZeg==
X-Gm-Message-State: AOJu0YzqfLlDNNlYcXZWs8F+o2SqId9rZZbtDKfpJxV/igNpL7vwuP22
	H3Q4eygWJjKB/yfLSadFj7xzRGVqBHEL9uKrSe4n5VkWRBDomThmLUNvvzfOclMqoMrE9cbT4Ik
	whozUscy5/XsbzQ==
X-Google-Smtp-Source: AGHT+IE3n1k80MuyIwex32RymBBJ3wkzNS9chxunz1u2NCAGwFePOCUhGXCOZClPfDc3vS+fOvbMrhUciWJf9Q==
X-Received: from wmlu9.prod.google.com ([2002:a05:600c:2109:b0:477:3fdf:4c24])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f93:b0:477:5c58:3d42 with SMTP id 5b1f17b1804b1-4778fe588a9mr27893345e9.10.1763124025773;
 Fri, 14 Nov 2025 04:40:25 -0800 (PST)
Date: Fri, 14 Nov 2025 12:40:25 +0000
In-Reply-To: <20251113233746.1703361-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com> <20251113233746.1703361-3-seanjc@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DE8FAZGMBD9I.25XFWIKK74DI@google.com>
Subject: Re: [PATCH v5 2/9] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu Nov 13, 2025 at 11:37 PM UTC, Sean Christopherson wrote:
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>
> TSA mitigation:
>
>   d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
>
> introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
> CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
> (kernel->user also).
>
> Make mitigations on Intel consistent with TSA. This would help handling the
> guest-only mitigations better in future.
>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> [sean: make CLEAR_CPU_BUF_VM mutually exclusive with the MMIO mitigation]
> Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Brendan Jackman <jackmanb@google.com>

