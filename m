Return-Path: <kvm+bounces-25608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB61966D6F
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B1EF1F2448B
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2B61B970;
	Sat, 31 Aug 2024 00:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yUdi/g8f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6241B815
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063677; cv=none; b=oUZBJQdRhsYyllHiHrp1nb//z+RWHvwE6bh6GHNTRnyD7bg+4AIQsW0gc9FGnqUZnlFfc+S5UkcHHcWdQNLZshvqc05bJR691A9deyaS5Duwsjf+rq5e9v9cud+zdpjrenM/ky6dXY9oNVFwePGcHDPvNgcTNAX5pLdLH0C6qXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063677; c=relaxed/simple;
	bh=8Nkda4M6GW/GFPhbyZoNtRQ9Zs8BsVt8f9A6+Jegnik=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H2BejW0+h4sJSeLFo1x9M+cFfO18YQ4p5OqPdosmuAknU5f1MnzeHT9cGmUhTUaIBJ8psa9ao6B35ej/qwNYMC9L38zLjTJrT3C92ZhaqoGwQABCP4+9tSu33uO9rGYXn/k0VwxdnNCvAhx33n3iFkLQLHEQFujQa82iTBCi02Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yUdi/g8f; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d3d45c308fso2314904a91.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063675; x=1725668475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cMgQaudxr4J/6Rw/Ugn77ELKpct5vFB3BePzAq1Kny4=;
        b=yUdi/g8f/yXA3OEdb/m3q0KG/1HnQdsFU8I1Xn1B50yC8YzED5uFpRdU1h48WTqsX3
         pzDCevPuKGtfkbFYS6GXQ6Vllw9ABKoAHQdlZtmDaYvvr3TY49jqcfgmKplmMOndcY4N
         LGWhmVMdWNU0VNlNcJIV8sPYd3UK9u0B39QAU2lS10GzkI4ZayJGNp4rRTFkYab84VyD
         VR+c+kwhXs/x7O3f2QWO7eUj9WJBittC7okwIFVnAc/2LZ4UEncvkttMJI4moIdydffj
         bRj6uz97jd6puAPtndt1Wmy9SD25lrJSiBJ9XPfcA+91JwmSS9I5a7gW2LA97bwCnh+v
         /EdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063675; x=1725668475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cMgQaudxr4J/6Rw/Ugn77ELKpct5vFB3BePzAq1Kny4=;
        b=lElofwa+7jrbKHy3vbnynHjGnV3QYpNF7ld3sRiTM0HIDEJ5LeJwhPLR9Kc7Cw4Dv5
         KBFTA2bVqYNitWaXIY1oD8/ZEYsqLEPRv/Niblt8IOFvo33GmBS0Tuhd4aWWwm9ssACR
         m5CE/dST2nGgBdTFidHGDdgDbrojcTCKvsdncspAxXKIw5hrWoLz+P//NOz4FyewisFa
         onT3l60Et4bbNT4c962MBn+jz0wv2k+7sJuQIA27Tw+39g7TwUeyTujGgNSCXxcXt3DD
         brB06LTvDcwkJ2XcNQKIR9DIjvi+Fc54c6A+rRDk/eZPRP3UsaMW3wwHIrdt14JVsoiG
         18xg==
X-Gm-Message-State: AOJu0Yy803fIzrx57i99Rs06+1CTqPJ1Ug+UKE5hgV9cb7CIyon9DhSY
	Z/XEVGQneEvXYIHdB+Ng4H7C4xSukNSBIXepGIPu6PWKM2GVeS5iBvPp5jnUFYNKf/VUZ4i5sQ9
	U6g==
X-Google-Smtp-Source: AGHT+IGHPAth3Odv/1fyvFXsQ6a6cOh/6c7Pc1YRYmloVg4ApwcWdTNEKcK5OuRp6hsqbhF1nbDaV/8wJko=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:5143:b0:2c8:e660:6769 with SMTP id
 98e67ed59e1d1-2d86b85569cmr32103a91.8.1725063674377; Fri, 30 Aug 2024
 17:21:14 -0700 (PDT)
Date: Fri, 30 Aug 2024 17:20:51 -0700
In-Reply-To: <20240828181446.652474-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240828181446.652474-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <172506365309.339538.5291166487767889409.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: Coalesced IO cleanup and test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Ilias Stamatis <ilstam@amazon.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="utf-8"

On Wed, 28 Aug 2024 11:14:44 -0700, Sean Christopherson wrote:
> Add a regression test for the bug fixed by commit 92f6d4130497 ("KVM:
> Fix coalesced_mmio_has_room() to avoid premature userspace exit"), and
> then do additional clean up on the offending KVM code.  I wrote the test
> mainly so that I was confident I actually understood Ilias' fix.
> 
> This applies on the aforementioned commit, which is sitting in
> kvm-x86/generic.
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/2] KVM: selftests: Add a test for coalesced MMIO (and PIO on x86)
      https://github.com/kvm-x86/linux/commit/215b3cb7a84f
[2/2] KVM: Clean up coalesced MMIO ring full check
      https://github.com/kvm-x86/linux/commit/e027ba1b83ad

--
https://github.com/kvm-x86/linux/tree/next

