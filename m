Return-Path: <kvm+bounces-64229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ED938C7B668
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:57:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C42E34EA899
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A792F4A16;
	Fri, 21 Nov 2025 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0CleckKC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF652D8367
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751363; cv=none; b=UGr8yw+J4z2lWuGBR1rjc9jA684+Bs4E5QRKypU+oVXpwz71Bd3KFk1WeDkYblk7Z7YIqPfdVP7FFfT7znY1nbPSPh+3IKv3GAgXZx18M6FrrSumh1rTWJ6BXNbYIoGNpX/lfRjJqszdA85P1fGB/krEqPk9wYjIsfr5v+2HYzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751363; c=relaxed/simple;
	bh=y8Y+l+R0+Mr7Q0oJxV2U9bxdXXvFwXqMipyNSdeBj3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iGE+c6B7RS5XidIXX2n7j4LA7G3gKM4yvd738/MYcAR2+uB7fEBSSKUNpSmAB+naebwhtX0Ktt6Nq7zC79k18nlTkaRhTN5eYi4T2AMs0HMHdVEAX4TB1vfFFrpbNl+995mUmL3HsTThF7+I6pZI5mxOeOp+5mYAwCjbeckPjak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0CleckKC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7c240728e2aso5334180b3a.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751361; x=1764356161; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hijixliDNQ7/ixg8IdvsUsyQ4drtkqdaCs7R9DRt7SM=;
        b=0CleckKClU1omFPsk1vPZxMExHcwnhxX46j/cGsBzDm7H5zbq30jUWrbr97hYoq8ax
         YkUsTo49L1WUmUeuqOCJmWnjt1CdP7zzCcj0cQ7hrwj3EePjwtODESg9X9uaxXJFvsHk
         LdVZcuLpGzOpfNpovUnyCFv0B2FhLBig8NShwlOXfIjwKrjDzXHFJzq34nLsLlvpK86x
         74tw49iborfYuwLDp/9mjrFEMlqDD8dwCNKJPEe/6rQpBIOSsZmSbVM5YxxPI+S8yJCC
         kDeD5DNWoZHi3PhFyOIg4IQ/9NSbnlSIRh/2JQ5/0NRJGSfigPUkMt1n/BXRveNb4FqN
         iv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751361; x=1764356161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hijixliDNQ7/ixg8IdvsUsyQ4drtkqdaCs7R9DRt7SM=;
        b=wqtHrNMhOMvprnJQbO/hfYNIQBqNmwWRUfyy9sr6UgLUfkVieWSZrSN8wgySdnIRsW
         /f+t+v7hrEKkjNm9Emv9zeAxXO+myhqD0mEF01qXFRfHVuvgsgitBgzLNyuRazalDvPa
         nZi+NMzQEC5vxVVZ+qK8VBJRqX5dlduOylfJxyFyfmBEi3+8kLIbnXhrJU5QxiZHtKdT
         NSlVtqtBzRepFtnqEeCmnorkooPQGVfIey3JTUedCoJY0vno6X7saiaCTRTqJnacslfh
         /xcQxxG4HtrqBu71SXEvCct/ZDJPH9sRDnW03dpWM3GBEHmxe5MOOIp5L4RR1f6OVqNe
         iEMg==
X-Forwarded-Encrypted: i=1; AJvYcCVhoiAyPzYmPhzAe0zPq4rqMsVbcmk8wTfZoNb/dZaEh5lb8ZRenOnmOP/KIZP5YbWuPx4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw16UUU8QRZbBW/GBVR9ZaVbYDO8lcoPV9m0hNdRwTpxylo5rLD
	eseFDG+aOp3TdjYhy90O1uKy+m42p1ZfLYnERRwoM1h2LsCSLrqyfMB26D0DduyH97OFcIvnm2u
	ge/8jBA==
X-Google-Smtp-Source: AGHT+IEpHsfODw/5oKAEJa6B2KeaHpZVLXVHpEq51iG7fs0o8+Cnzxb+eaehlJ6h5/OEy0aWTcL/FSRuYpg=
X-Received: from pgaq186.prod.google.com ([2002:a63:43c3:0:b0:bc7:7e3d:b3c7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6da3:b0:34f:a16f:15ad
 with SMTP id adf61e73a8af0-3614edd99bemr4587005637.53.1763751361362; Fri, 21
 Nov 2025 10:56:01 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:27 -0800
In-Reply-To: <20251114003633.60689-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114003633.60689-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176375121958.289343.2959701026298528628.b4-ty@google.com>
Subject: Re: [PATCH 00/10] KVM: emulate: enable AVX moves
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kbusch@kernel.org, chang.seok.bae@intel.com
Content-Type: text/plain; charset="utf-8"

On Thu, 13 Nov 2025 19:36:23 -0500, Paolo Bonzini wrote:
> Over a year ago, Keith Busch posted an RFC patch to enable VMOVDQA
> and VMOVDQU instructions in the KVM emulator.  The reason to do so
> is that people are using QEMU to emulate fancy devices whose drivers
> use those instructions with BARs that, on real hardware, would
> presumably support write combining.  These same people obviously
> would appreciate being able to use KVM instead of emulation, hence
> the request.
> 
> [...]

Applied to kvm-x86 misc, with massaged shortlogs to make it obvious these are
x86 changes.

[1/10] KVM: x86: Add support for emulating MOVNTDQA
       https://github.com/kvm-x86/linux/commit/c57d9bafbd0b
[2/10] KVM: x86: Move Src2Shift up one bit (use bits 36:32 for Src2 in the emulator)
       https://github.com/kvm-x86/linux/commit/3f3fc58df502
[3/10] KVM: x86: Improve formatting of the emulator's flags table
       https://github.com/kvm-x86/linux/commit/3d8834a0d1c9
[4/10] KVM: x86: Move op_prefix to struct x86_emulate_ctxt (from x86_decode_insn())
       https://github.com/kvm-x86/linux/commit/1a84b07acaa4
[5/10] KVM: x86: Share emulator's common register decoding code
       https://github.com/kvm-x86/linux/commit/7e11eec989c8
[6/10] KVM: x86: Add x86_emulate_ops.get_xcr() callback
       https://github.com/kvm-x86/linux/commit/f106797f81d6
[7/10] KVM: x86: Add AVX support to the emulator's register fetch and writeback
       https://github.com/kvm-x86/linux/commit/4cb21be4c3b0
[8/10] KVM: x86: Refactor REX prefix handling in instruction emulation
       https://github.com/kvm-x86/linux/commit/825f0aece084
[9/10] KVM: x86: Add emulator support for decoding VEX prefixes
       https://github.com/kvm-x86/linux/commit/f0585a714a75
[10/10] KVM: x86: Enable support for emulating AVX MOV instructions
       https://github.com/kvm-x86/linux/commit/ebec25438f3d

--
https://github.com/kvm-x86/linux/tree/next

