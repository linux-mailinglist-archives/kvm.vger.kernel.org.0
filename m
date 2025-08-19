Return-Path: <kvm+bounces-55064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E6BDB2CFCD
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2DEC68616E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EC7257829;
	Tue, 19 Aug 2025 23:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RKwdUhZv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1F021A420
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645486; cv=none; b=sgDaLP4Ln/xqJtabAq7bRUUHJZY7gWUi5jPZ5g6kxkx6fxfb15jYarggpXArf9sV7XBYs4/QpzqGi9osGbG9KWuseYbrJj0AtTR7v2kNbn6AwZRoGdIoCh+JtkWaMyzKmQ+PjS/1LuoZRM7+FPt7vSyiTx2lJoZ+YyJ0KEdGeXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645486; c=relaxed/simple;
	bh=iQpC1dmPhTOAg1r0GZTbuO+umdDTALhHHffAOhsYA8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OJdPNubDQHplI/ShOTJ2M9/8jylHV+uG5yKKVpivBBKrQkICK3PgRDNKLMirgF2vFhTvHQv6DhUvScgpldzRbUiaMpclJgwUirVZYXWBmV0FSfwy2L86ZWxxqm5GwR2cWhN1b1PiPdzh2fpI2dG9qJMIl2UNSWQjS17ZTU7Fq6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RKwdUhZv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3234811cab3so4265596a91.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645484; x=1756250284; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S+V991O/AuXpO0gXNfjqfpn+pvMgCmUt0NMp5HsGA9w=;
        b=RKwdUhZvslsMh2TElkrvlvdtdORbQw7dUrdie63bskUmapDXFJQSVRKyWGJqfGDspB
         WgthT9l23YCPbofbWdqARgYmA1uU+dShIbPs3hFHT14XA/Wk7tQIyZiGbMim064RgdOf
         ePAlmDfmGRDRfIO8B7c8+BZEMtTaaIz99wdjUX0cw0CcgLJNfM1dUcDn3vEr+PKBL8Ic
         /pv9FeeAIz+iehu3t7hMknB90hx077yM5+wXBmbNjKSH5/Lc8KgqnGKThj98MEyYhDkD
         vH6EAPiThim+UZyMX1Nf6502NMrHOqgBhi3Up+CrA3NSNz4wEsLxKQRKuZfaDCMLB6uR
         MfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645484; x=1756250284;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S+V991O/AuXpO0gXNfjqfpn+pvMgCmUt0NMp5HsGA9w=;
        b=SLME9AOL9GtKWqMPctlUuwBL/D6QFYGeXhBsp/ElZlUpMxxSlu/r3Zq8r2NUCpLLPV
         UVxyKzq53QOnENug+5WGkZWaqQAW2CP4DtKMp4A45Un+lyIixZNfeGqzV2exu+sMWqyy
         dJEg0CQIHemazQumcpMpbN0QCrZTD1THgvkoKMREu/5ULtBpKCi3+xhWDkNqKCFBEXxb
         X7HDaLj8RPxhRqFvCP4hjATPIxdXkDVZ8guBqxPLzxRhoOlEpueadmyVnMh/oxRDcFwU
         6bQK6IUNNzWElKqwwAnCEZOGiLavAy5pYFrPkwbG1ovxkp0Co3H/aYodkhwb97FlTHOX
         YzdQ==
X-Gm-Message-State: AOJu0YwK+L4Xb32tvgPaRTE+lOfS/LDLESk2TvjcLhkpzI2F9NdLknOY
	wNt2ArB+vGdoNmMqJrylSSqdmHATMH6bi/xuPRXx3ZZx5ZAUAshrOTH2X8bAYSOrmZjh4IRlpjQ
	qiFfsaA==
X-Google-Smtp-Source: AGHT+IEmqhWm+Rgp/lPlIxJDqGsLB2fjNqO8MG9Owq8liURqmpXeLdJm0a1eGITJhg85sYLWrdIRlLj9egw=
X-Received: from pjbpt16.prod.google.com ([2002:a17:90b:3d10:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d86:b0:31f:22f:a23e
 with SMTP id 98e67ed59e1d1-324e1400f2amr893027a91.27.1755645484200; Tue, 19
 Aug 2025 16:18:04 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:12:17 -0700
In-Reply-To: <20250806225159.1687326-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806225159.1687326-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564464954.3065741.7104560070190898929.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Move Intel and AMD module param helpers
 to x86/processor.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 06 Aug 2025 15:51:59 -0700, Sean Christopherson wrote:
> Move the x86 specific helpers for getting kvm_{amd,intel} module params to
> x86 where they belong.  Expose the module-agnostic helpers globally, there
> is nothing secret about the logic.

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Move Intel and AMD module param helpers to x86/processor.h
      https://github.com/kvm-x86/linux/commit/e2bcf62a2e78

--
https://github.com/kvm-x86/linux/tree/next

