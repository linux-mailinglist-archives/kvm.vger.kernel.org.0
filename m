Return-Path: <kvm+bounces-39025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE08EA429BE
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95D733B86C3
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6BB82641D8;
	Mon, 24 Feb 2025 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o+y3U0zw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B959D2661B8
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417969; cv=none; b=FyO2cfajeTN8tRudBaVBz+orAXTXAh4iAmdJym0T1t0DVUu2KzP9LfpR9G/U+U3tZ5w8huIn3frudRCLX+KseadHc28oiD6ayrvj5rnEYWOZh6s8HY8ksNUt3cpqYtJJKVZiNz5BFw+dPIqwXhqYRHm3dIBQR3SD3lipc9Gf7Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417969; c=relaxed/simple;
	bh=WnfisraZspVYgn/eznzJRgoOId0wUyb5CscGmAewz+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jjie1UZG1b6oO3eNrQzPpe44MQkHTV+sfL9Xv9bOm+VDTo1EEtFZU8V2GreIknMDRFZNOB35vOrG22A7MPH8VPNaaEVcko5A4zCiMJu9JQiYAEZu8coZ+qXM1cvE2gp3Xq7r/i3soYkktA666784ZKdLlVEN1i+HlcY9wRkMitQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o+y3U0zw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1a70935fso9707511a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417967; x=1741022767; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bfgkwYsDHtH/FPEIQlozn9SjGXCYga46lg8p/xM2j+s=;
        b=o+y3U0zw8+1+WJR8MhkkWRH/AvOir0fEwAUiRRs6w/yQIj22IQhDFP2gyKxTO3e69A
         RnDkLRh6G35yri69ranSk6Vm51xAYe5sYl+P221u/MTHPHn7kElHsCXkrx9yLpNzwXDf
         qKsm0KfjwV/mI1997MWRoag/tDjszL8dSMhZ3sZKbsoVFQF0gvbqR/vdr4RzAKUqY4pV
         lZ/lzpkBZYSZRKw8rdHyVlHNMkM72E+czqTnkOSUHHDOmdRI0JtmJImf1cYXzSy0phm0
         YtB93scgGQfi0hi/28LeA7RZ7aK7BG6cImRkv5PqsA6T7l4QdJxWC0Z+5fB+WgNsa7It
         Q8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417967; x=1741022767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bfgkwYsDHtH/FPEIQlozn9SjGXCYga46lg8p/xM2j+s=;
        b=vpUFWXWaIWSrkrN5mB/JS/KNUGNxByKAzpQEIWMAz8xaSdbMajUII01erhGFGnGsP9
         7J6TmeCn4GJDHlmyek0SSazzMmO9M2Mzu4OqLJnNN1HAnWEYnRjTH+e+O2x3BcB8VOZm
         m4yBZpTRjAblbVPjIbzKpJflKH3FwJhCLVE0RBi4ddnIFpeWXBvTPoclThnTuKgLgF2H
         icIEDKtrSORKBVRoymBubsu/sEAkITWC4poXNVw3RflT7myonhieiQdrfDR72av9tJVg
         kG6ZUNqp86N92kVUfMl3tfEkn2iKxSRf/4NxVbmjK+fc3cX6C2vt+1fk4KfAt96bIVKu
         /x0A==
X-Gm-Message-State: AOJu0YzSrz7xQTr9fHZl+p8MEv0jf3MV4Jl79brOR7KBc1lo1MI4MR4q
	xhyNIBgWBaIJ/OP4AFAVulR2TBWZFueWdfW2Pg0Z+9K4kqGEKimIx+eRBNlioY/YsuKMhsVbwkN
	DRA==
X-Google-Smtp-Source: AGHT+IFpfl6wo9950jfjtaXrVb3RDekWsyFGFGlYsCVbKyAVhBu+xeOThfcDCQjL1Es38hxUTLznv5JRNXM=
X-Received: from pjbok4.prod.google.com ([2002:a17:90b:1d44:b0:2fa:26f0:c221])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2250:b0:2f6:be57:49cd
 with SMTP id 98e67ed59e1d1-2fce7b1a4f3mr24110033a91.25.1740417967063; Mon, 24
 Feb 2025 09:26:07 -0800 (PST)
Date: Mon, 24 Feb 2025 09:24:11 -0800
In-Reply-To: <20240823221833.2868-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823221833.2868-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041731148.2349187.6282603538112461550.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Force host-phys-bits for normal
 maxphyaddr access tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 23 Aug 2024 15:18:32 -0700, Sean Christopherson wrote:
> Explicitly force host-phys-bits for the access tests that intends to run
> with the host's MAXPHYADDR, as QEMU only forces host-phys-bits for "max"
> CPUs as of version 6.0 (see commit 5a140b255d ("x86/cpu: Use max host
> physical address if -cpu max option is applied")).
> 
> Running the access test with an older QEMU, e.g. 5.3, on a CPU with
> MAXPHYADDR=52 and allow_smaller_maxphyaddr=N (i.e. with TDP enabled)
> fails miserably as the test isn't aware that bit 51 is a legal physical
> address bit.
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo).  Thanks!

[1/1] x86: Force host-phys-bits for normal maxphyaddr access tests
      https://github.com/kvm-x86/kvm-unit-tests/commit/b8e135d6bb48

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

