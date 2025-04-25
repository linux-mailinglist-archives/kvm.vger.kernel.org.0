Return-Path: <kvm+bounces-44376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84E1BA9D633
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 01:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0340716F65B
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 23:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A906297A48;
	Fri, 25 Apr 2025 23:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F0lfLbsI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89102973D8
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 23:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745623426; cv=none; b=KXUWcxi5x2mdnDmfgi/B5EnOQLTZj2UOIrEyg4PtgNbztapMkxTaoHs5s3IYFK9H+QP/J6HGU+EMTUwgpYCn4kZxsU9IWeYj5Gbshcpokb3A2dSOJTLH5d0d4aKonzFSRccJlP74YISds/0dzLBH/uQ32HImm2YurWYdUHUy9d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745623426; c=relaxed/simple;
	bh=W/4u0lOWc81NccjcB9uXLRxjfQvmJccU9FvvMv7UnLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=if3Gdo2LwTL83rlTpHPN38X1WvwU+VUeZYXSzOv7YxfX84Uwzy7uNJWzlOaFfZSKHHTHAUziOAzuh1Ee34kReKq7DyUiD0D4YiW9Yo+JaUZtr2tilPfQ+fKVHK47QoBuIyfEfvRJgI+Ml/CcAwxnnlSgUx8Tvtr1pUvhuVj+scg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F0lfLbsI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-306b590faaeso2190502a91.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 16:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745623424; x=1746228224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2iS6vvTC2BG7KBzpZ2hrMru0/r0uhvHtjUyGqFDzSlk=;
        b=F0lfLbsI3rP8+2UlV2J8c2LtshROTUDxyr9nvtReO9TJEoILIbMazejyYmeAqR7gGh
         SyOz/Il0SgQP0l5MWzrc4v98FyyUszQF/NPbSmtbMsvxABNPUxyzQNz/XAraNV0aqobi
         csAkGQHdm2u1i/w6NiJQY8uLedXIyQgTN7USPPukp/i656/Ksi9YCpQuzSmWOCAQ1xtj
         fdTL5jqe/QLhLX8JJ7h7m9GdRa2Nj+ulHMgkdHwlRRJrmgLjWdWW+/TwDjKh+DCKoZ1I
         J3m/IORv7pknYmupsalCE4+QyHVzrtL/Lgpz9TjV6RPSq8XRRvbzZSh6OtI9KlcKPQ1L
         DLwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745623424; x=1746228224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2iS6vvTC2BG7KBzpZ2hrMru0/r0uhvHtjUyGqFDzSlk=;
        b=Nhb1eUEqtow7qLLZ9SqfVkpTubZ5sDveAhnTXPqJNiIa6004UMLidxuxi56/X/Vc2X
         JSJpbRj2iS/yWAjZ9op9Tf5h+TSWaK6Rm2/hTpiHmzR7ltW+DuGwl5IzE6VXN4IWFRN7
         dFWVqVJZ4jv6oHrN5OHpHBSVtssXdRwMJi4JrmFCJTIMEcXOblR4yW9q7seQ5Pj12rTp
         HJ4RXRPSg0N5Zups84z58qzt/f+eEH5j/zxsMSHQmvd7liWs58kYoSddrz48j98oUzTL
         bspuX/4CTvxEeBSr9MjashV/OqaaVTROB5obAwdW+/sQ4DC7fNsS370yZwYdff8/JOkC
         MWfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGMj9QC/ZNLp0h9Bu7t6HNOvUdYx/+cbZ01ZA+xZpboPE6JfvgoKDgmZ3UXjn7nE5+Sik=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxkaYnYNVbgKbGZKCT1uk3039Y9xVdoVtU0TRhs03/ce444W5q
	9CPUZeIkVbetYXvTN/dVuobeNiwHRTPD/87OhQRVSsfTFQlawIT4t3MO3iMyw6HGg/0ZfCP7Yez
	z/g==
X-Google-Smtp-Source: AGHT+IGE7Db7SsvC780U6iZxFCfU1flMB6i6zwPX8CAN+B1wZoleiriiDrI6HnQqyvwglWB85GjmXPxrcrM=
X-Received: from pjbsi3.prod.google.com ([2002:a17:90b:5283:b0:308:670e:aa2c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2544:b0:2f1:2fa5:1924
 with SMTP id 98e67ed59e1d1-309f7e60a39mr4757679a91.26.1745623423952; Fri, 25
 Apr 2025 16:23:43 -0700 (PDT)
Date: Fri, 25 Apr 2025 16:23:18 -0700
In-Reply-To: <20250310201603.1217954-1-kim.phillips@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250310201603.1217954-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174562133546.1000664.8086467435503867991.b4-ty@google.com>
Subject: Re: [PATCH v5 0/2] KVM: SEV: Add support for the ALLOWED_SEV_FEATURES feature
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, 
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Naveen N Rao <naveen@kernel.org>, 
	Alexey Kardashevskiy <aik@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="utf-8"

On Mon, 10 Mar 2025 15:16:01 -0500, Kim Phillips wrote:
> AMD EPYC 5th generation processors have introduced a feature that allows
> the hypervisor to control the SEV_FEATURES that are set for, or by, a
> guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
> that SEV-ES and SEV-SNP guests cannot enable features that the
> hypervisor does not want to be enabled.
> 
> Patch 1/2 adds support to detect the feature.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/2] x86/cpufeatures: Add "Allowed SEV Features" Feature
      https://github.com/kvm-x86/linux/commit/67e672eb2e89
[2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
      https://github.com/kvm-x86/linux/commit/51c4b387555d

--
https://github.com/kvm-x86/linux/tree/next

