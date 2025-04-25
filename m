Return-Path: <kvm+bounces-44378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0D0A9D630
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 01:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7B501B68B72
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 23:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F07297A46;
	Fri, 25 Apr 2025 23:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mcrIBV58"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24122973C9
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 23:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745623453; cv=none; b=TOzWhe0FfH1fbv1cCq1/c7MCWFy9W+41ZDaPIFByGPXVNHgQ6+wDgJ2jKVs7j7gzy5vrHvUSUCD1IHAxBoT/saulLbYiMw1LB69hesvtXEgLg6p+8utyNV0Ls1tQm5XaF1FRuC59G2xix0AtBnkWNh23N+AI9aj2ZtSDXic0hzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745623453; c=relaxed/simple;
	bh=eU23Khxo6QVrG+xcpZQb6AudzGFSiClXqZNoEgUpAbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W7d+GqYXiRbNIIbE+Qbes2x8e1pWpB7kbi5Aj4QEgG48eq0oat8+PO+jdjXxm7l++YUjxvMpHXfiYdGmmOuS9H2IN3Yfj5meXEU9191/yf5k2A6lPUD79G2P2rCffdTwz6Fv+SGR57gBSVg3cUFVvJB6AVh7KGFnBqetMVvPjpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mcrIBV58; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-227a8cdd272so23833515ad.2
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 16:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745623451; x=1746228251; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7FXtnJ9UyaGmOcl1sXGT6vD1s14MbjAk7SQ/VduIgwo=;
        b=mcrIBV584i0SlsF6/GGN287cnMqMeb3Y6SX/X6K7+NG4J/l2xSnte6RGdB8fpzkrp2
         udCiunnRxfUhG9fqhZ/IjDBzCr2V655g2EsdazClLhkpWXHmhwrBmbagIkRfcwYPyYq6
         zwg7YCJ2kzL9yJN/FM+6YZf3xZQMZqP5gUeCDlujaowfy+5bFj/CorhNNhzL3aj/TDD7
         jlJ/mlBM/Wry5mBM7gG3vfWVUy5WGOAvzgHVBv1sCdosu1VsQnF92pUDPWlNn4W2l7A+
         AHPbgWrG7Ljej63EkFUwx2vT2mM7UXrmnUb9gqcmteLNWrXNpMgfVE0xHoNoweLN0YsV
         HbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745623451; x=1746228251;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7FXtnJ9UyaGmOcl1sXGT6vD1s14MbjAk7SQ/VduIgwo=;
        b=Uzjj13v9hknYR+7tUpfzsr3qh+UalKn5mpyTfSgeQZVeSrEgcvlSGYln0B6KTkqBCx
         TgKTH6RdoVSpXwQiPvSFke3gb9DdlaH6CjHWqXRPd5Ze8zqW8yBBYBsgo53dGbCs91hb
         JHIkF+Gq5bDVediZ9xz1/s61ZSQjAxf1JgGidzdLkSy/BllG//SfrHLsuEnIwPu06dmR
         POjdip3Is7AsSR8umGZJTxuuDBcYE1EJRHNdMj8huHAViOmWy9mOIfSvKDsEs+S/CVWP
         YlYPavBsAYCO/1qT0H6mIa/nu3upNad//yrWlyCSdNMGXdst5eo7cocdYcjbxjKXZLcy
         6sMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWelSnMH883ro58EBhmnDPni1G22bajncuM55T+BDkh2E96Yr5HBVkFGyCRfJdUl8TpTYY=@vger.kernel.org
X-Gm-Message-State: AOJu0YycsIZXNpzuCCwkEiQd2nnQ6bcp3ts/s3/VocXjx7xYWJi7uFDh
	5VISyPhbkG+LaI4ftga6MZT3TZ/sgrL+KySbcARMjlhgs6gCSCY0BIz6JA3br9qIuD6LyNOovUl
	xZQ==
X-Google-Smtp-Source: AGHT+IFpg5xsm7tH3r5zXRSMp+yzbOmBsQ4tpIU1CxtM705zYwh9a5V2gKapCV+AKq69RjR5EvTVKI5SHhg=
X-Received: from plge14.prod.google.com ([2002:a17:902:cf4e:b0:22c:360d:9a60])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4d1:b0:224:76f:9e59
 with SMTP id d9443c01a7336-22dc69f3b0fmr18926575ad.10.1745623451047; Fri, 25
 Apr 2025 16:24:11 -0700 (PDT)
Date: Fri, 25 Apr 2025 16:23:22 -0700
In-Reply-To: <fe2c885bf35643dd224e91294edb6777d5df23a4.1743097196.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <fe2c885bf35643dd224e91294edb6777d5df23a4.1743097196.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174562142846.1001255.4839400657801617260.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Fix SNP AP destroy race with VMRUN
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 27 Mar 2025 12:39:56 -0500, Tom Lendacky wrote:
> An AP destroy request for a target vCPU is typically followed by an
> RMPADJUST to remove the VMSA attribute from the page currently being
> used as the VMSA for the target vCPU. This can result in a vCPU that
> is about to VMRUN to exit with #VMEXIT_INVALID.
> 
> This usually does not happen as APs are typically sitting in HLT when
> being destroyed and therefore the vCPU thread is not running at the time.
> However, if HLT is allowed inside the VM, then the vCPU could be about to
> VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
> a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
> guest to crash. An RMPADJUST against an in-use (already running) VMSA
> results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
> attribute cannot be changed until the VMRUN for target vCPU exits. The
> Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
> HLT inside the guest.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Fix SNP AP destroy race with VMRUN
      https://github/kvm-x86/linux/commit/309d28576f0a

--
https://github.com/kvm-x86/linux/tree/next

