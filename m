Return-Path: <kvm+bounces-44373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B23A9D60A
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 01:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D2DD1BC83BD
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 23:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01AA82973A3;
	Fri, 25 Apr 2025 23:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G5hIu74y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFEB296D2D
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 23:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745622736; cv=none; b=WDZ3KjL9hkIh8t4uH+YTLtNkHXXUgURrcF05JPgFqUFzdkbGRN6E2GsCZKvlQ6dbxz/YpF6RY0bJHwPIi7ZRirdVdt3ns7znfUIPpdrXQItpnjnjJxjOeSJGyj81sezYS05drueHXHZPcPJAApwuQGce0UG/7Ud5DRqdBURor8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745622736; c=relaxed/simple;
	bh=KKOE815L05yON6K5PU7GKf7a7Uf9E2zDGle9wQ9DKME=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q1hqUrr8n0ewDbgqTCblHWo0B1SCvy4Jpw1DfocmbnV8QZHzspY9P57OkwSbzpH4j2FnlbHgoIO6YL/CQWF0r58xpgFtXGjU6zKmsF+hLBnewdnndYh52wp03nRSk3bA0FVOnKukOpGqufRDPykT5BFypIIDRv2xZQeiFXibnxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G5hIu74y; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-227e2faab6dso24816905ad.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 16:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745622734; x=1746227534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3r7P7UY8cYUR61rlcLCipPUdZOMuPUlw12jrZODPDcQ=;
        b=G5hIu74yvYyEtmsIJq0bKkp+oH3rKGdiToYyzrQyqe4ccEamDvWtgcvjgOHqcwZ+6y
         Nd1m6SqgLUz658ZO/ca46wQSwF1h7JrwHhCEER5jYvOCNyHLJoHuPfX7W8+6T/vYJwXs
         PNKlRTaxVDn4oErwtVjhAdj9BhVHryrxEMtqJOoGYA1Yyy88qoaGUodvkVFcueetRL1P
         4T67j3/E688WGg0/WY8qHffTzHVGYjhqY9v7fzol97CvHFhZYYOuyfLdU4Oo0Z37Rg1B
         yq9K3GGPCOL9MPJSlRDTFU5BT/fbXh0KmFWvDJvtZnor6otrz/CbBeCRuqoQbgQf4cR/
         ADuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745622734; x=1746227534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3r7P7UY8cYUR61rlcLCipPUdZOMuPUlw12jrZODPDcQ=;
        b=FXer7YaNwVy9vGx/Jdu2ivCEzX4lwuOVhvUMSDkwcdqIcQObtTls/UmSs+sLwJqXD8
         8mmfAdQp0wSRSrKB35du8Yeeh7Go6DV8a3hSr8GYPKStXhsg5f/pKvH/NgCEdH3GtiMy
         MHC8xXiDv1eVob0msQbGppZAeQdcdAc7GMbnFyhrtn2Po3ZeSPBxMh+LiC9xu628WJLW
         +btCS17jagMa7tNVhvbZeMIJBe6B9J8sHm9Yc2wm1HZg1N6BAKd0SE1Wv2DLsBXhVGv2
         m3smev9HPukoacNXvZIGPFxE/7ggUSbpNAzXQTpZ7ptfIokRHW+aTM7G+TUPafGDTSZi
         Odlg==
X-Forwarded-Encrypted: i=1; AJvYcCWg9LG/E0iQpwDbXK2bi/EYneR/CZnlfmVlLaC9XWO9OTXfwmNjNfqwX2rw9YAoELW0Phs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO8RFUecBvlg2+7xUUU0oMvvPTNgkUX7KOs9n3TDWNWA93JrLv
	9Bz8MtTHsTw4MLpl0M2pCfyV8689n+qI1LhfEFHXJq9cf/+69OyWBlY6Hmb7KAhrUkMCMmCVaZt
	+1g==
X-Google-Smtp-Source: AGHT+IHcUNoic9IbPgXUI4x5fMfwjOit8nwFdr8BU580JFK37mK8J56Q3Njm7OD0w5D9d+xa8tMXUJ8ix1U=
X-Received: from pgam20.prod.google.com ([2002:a05:6a02:2b54:b0:b16:149:d369])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a68:b0:224:6ee:ad
 with SMTP id d9443c01a7336-22dc6a89478mr20052065ad.44.1745622733974; Fri, 25
 Apr 2025 16:12:13 -0700 (PDT)
Date: Fri, 25 Apr 2025 16:11:00 -0700
In-Reply-To: <20250401163447.846608-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401163447.846608-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174562143766.1001424.10208731170484769772.b4-ty@google.com>
Subject: Re: [PATCH v2 0/8] x86/irq: KVM: Optimize KVM's PIR harvesting
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 01 Apr 2025 09:34:39 -0700, Sean Christopherson wrote:
> Optimizing KVM's PIR harvesting using the same techniques as posted MSIs,
> most notably to use 8-byte accesses on 64-bit kernels (/facepalm).
> 
> Fix a few warts along the way, and finish up by adding a helper to dedup
> the PIR harvesting code between KVM and posted MSIs.
> 
> v2:
>  - Collect a review. [tglx]
>  - Use an "unsigned long" with a bitwise-OR to gather PIR. [tglx]
> 
> [...]

Applied to kvm-x86 pir.

Thomas and other x86 maintainers, please holler if you object to taking this
through KVM (x86), or to any of the patches.  I want to start getting coverage
in -next, and deliberately put this in its own topic branch so I can rewrite or
drop things as needed.

[1/8] x86/irq: Ensure initial PIR loads are performed exactly once
      https://github.com/kvm-x86/linux/commit/600e9606046a
[2/8] x86/irq: Track if IRQ was found in PIR during initial loop (to load PIR vals)
      https://github.com/kvm-x86/linux/commit/3cdb8261504c
[3/8] KVM: VMX: Ensure vIRR isn't reloaded at odd times when sync'ing PIR
      https://github.com/kvm-x86/linux/commit/6433fc01f9f1
[4/8] x86/irq: KVM: Track PIR bitmap as an "unsigned long" array
      https://github.com/kvm-x86/linux/commit/f1459315f4d2
[5/8] KVM: VMX: Process PIR using 64-bit accesses on 64-bit kernels
      https://github.com/kvm-x86/linux/commit/06b4d0ea226c
[6/8] KVM: VMX: Isolate pure loads from atomic XCHG when processing PIR
      https://github.com/kvm-x86/linux/commit/b41f8638b9d3
[7/8] KVM: VMX: Use arch_xchg() when processing PIR to avoid instrumentation
      https://github.com/kvm-x86/linux/commit/baf68a0e3bd6
[8/8] x86/irq: KVM: Add helper for harvesting PIR to deduplicate KVM and posted MSIs
      https://github.com/kvm-x86/linux/commit/edaf3eded386

--
https://github.com/kvm-x86/linux/tree/next

