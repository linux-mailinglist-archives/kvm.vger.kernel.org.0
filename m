Return-Path: <kvm+bounces-58700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F2CB9B8FB
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D00B3188C8E1
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40DFE3191D7;
	Wed, 24 Sep 2025 18:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="htg/smbd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104ED229B16
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 18:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758739535; cv=none; b=se3MfOgCOqQxEqd7CvoSgto4ww5lqfZGjMyx2K2mLRqYKgOIPyfEz5s59Ekl5EAxde/r7LvDyfishFkC7TNRIpiay7LhG4BYNtI/IPkf4gLG1JO3AO7vlec2hw/Ro0eUrcH9E60EiG+M8wH1T2PQiEP80+CAnodIMFwYIfhq6Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758739535; c=relaxed/simple;
	bh=vrPS3FrZXCObU9xbj2Kr1lt01FSI3RQMF3JUALQpUqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TxNdHl1R2YsJ40ufMHGZAMMh1I7tk9jwMvaCmuls99f5HGDjYQZZedcqg1tAg8Q8OF3Twhfw36rw6d99YNgaYFs4eXEA6Fii3rGdfffFA6jzeC1UbwlVIX59f3XDLUTMBj7EiXnARVcXcjVxS0xrU7d0/+yxKMqE6UkAS14ifc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=htg/smbd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee4998c4aso137333a91.1
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 11:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758739533; x=1759344333; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hB5Y4r4rf1lehr6FQtEOmozlH00Twktr9vU7PqamHQU=;
        b=htg/smbdWD9z611RaEZrKg44EJNy6NpeaIB/P1lDiWORJ/EkHofZtKjQyLd5kAkUwR
         lxpwvnC7r+cpnmrcn/4TbztCCKRf82xNoHE365PCuFnSl1aDZy2d9ZM+ET/wZnlI1Xb2
         nxdtdA2rKUi4O1+a4mTPxh4ugxt7uSGe3Hh9KfaWjg8YdvkkU1ZG63Gm6XRQQDgzek1b
         WGk/H3W/5UyUt3f/xV4DJJpeTNVoLsulsqJu63dnSUIEQqPDWkRXPZIbiO45Ck7tOwkz
         K058tuk+XnxREd9xOHjLkrrm3Mzicj49fRk7E+76n6rnh7cvSrquNfMyOhPHFS8rGo94
         u1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739533; x=1759344333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hB5Y4r4rf1lehr6FQtEOmozlH00Twktr9vU7PqamHQU=;
        b=Yi8ARZmNAfE2QRj5k7lRtrw/B1r6pqRdnQTUpK/+wAk9lmvxV+YHQ23iWxANi2WZ/6
         u2epwwQNBvnc70IYDdUiF2bZpDIWudqlPLjAdboR3CUXN+WyUepcu19S7lWH2kBopS/z
         HYjZ/lvelCUx49ZLbidH/oMVPle2MWsC2kLRk39GnFvQU8NIlRAfQlLe3B4D6411KXT8
         oc0OrgYz9JpI+X40VPl4I+VIYNIfdcGjvhbSr0SBiylrIJSfU93zn7W15o4i7+yiX0kT
         zoxRGc9k+n+NSYoQOWzKWigynvKWrnXnyH1HQPJ3vu6C+JCguOjlHZO+Aw1GpACCk3GA
         4EgA==
X-Gm-Message-State: AOJu0YxbS8CMwgYpA6LpIbVxPf/9M60Glp8GAFO1SzlorsW2nyjOdKw6
	4RtD/rlsVv8yHfVO5mLPXpaQ3AjrR2awIKYFmiVbeB5yzzwtWEDYPME00gxGc5z1AVjPGESv4Kg
	LsNvFjA==
X-Google-Smtp-Source: AGHT+IEh0mqwW4Zok+OWIvmwE7+RJDlDgyy+51Q9hwEsOLuS9L6xhBhguqHptFn2ySqV6wYcmNX8Bvzg728=
X-Received: from pjyf4.prod.google.com ([2002:a17:90a:ec84:b0:32e:aa46:d9ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c1:b0:32e:7340:a7f7
 with SMTP id 98e67ed59e1d1-3342a272c3cmr621593a91.2.1758739533283; Wed, 24
 Sep 2025 11:45:33 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:07:45 -0700
In-Reply-To: <20250919215934.1590410-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919215934.1590410-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175873642529.2146862.15667445717361040728.b4-ty@google.com>
Subject: Re: [PATCH v4 0/7] KVM: SVM: Enable AVIC for Zen4+ (if x2AVIC)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Fri, 19 Sep 2025 14:59:27 -0700, Sean Christopherson wrote:
> Enable AVIC by default for Zen4+, so long as x2AVIC is supported (which should
> be the case if AVIC is supported).
> 
> v4:
>  - Collect tags. [Naveen]
>  - Add missing "(AMD)" for Naveen's attribution. [Naveen]
>  - Make svm_x86_ops globally visible, to match TDX, instead of passing in
>    the struct as parameter to avic_hardware_setup(). [Naveen]
>  - s/avic_want_avic_enabled/avic_want_enabled. [Naveen]
>  - Print "AVIC enabled" in avic_harware_setup() so that it's close to the
>    "x2AVIC enabled" message. [Naveen]
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/7] KVM: SVM: Make svm_x86_ops globally visible, clean up on-HyperV usage
      https://github.com/kvm-x86/linux/commit/44bfe1f0490d
[2/7] KVM: SVM: Move x2AVIC MSR interception helper to avic.c
      https://github.com/kvm-x86/linux/commit/eb44ea6a7aac
[3/7] KVM: SVM: Update "APICv in x2APIC without x2AVIC" in avic.c, not svm.c
      https://github.com/kvm-x86/linux/commit/a9095e4fc436
[4/7] KVM: SVM: Always print "AVIC enabled" separately, even when force enabled
      https://github.com/kvm-x86/linux/commit/ce4253e21fa8
[5/7] KVM: SVM: Don't advise the user to do force_avic=y (when x2AVIC is detected)
      https://github.com/kvm-x86/linux/commit/ad65dca2ca4c
[6/7] KVM: SVM: Move global "avic" variable to avic.c
      https://github.com/kvm-x86/linux/commit/b14665353162
[7/7] KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support
      https://github.com/kvm-x86/linux/commit/ca2967de5a5b

--
https://github.com/kvm-x86/linux/tree/next

