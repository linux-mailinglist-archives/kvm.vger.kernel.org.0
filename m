Return-Path: <kvm+bounces-24456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 494DD95538E
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 753981C21A2E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 22:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8670E146596;
	Fri, 16 Aug 2024 22:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ofh8Ed8L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC22140E29
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723849156; cv=none; b=Yzb0OxkA4ffaOFDHu2xwEHDgB2TAHUkOZ7dHXeSS7NrSVHUFndbpa4dUPgFZJ3yTlbnxS6iBrFxYXm09Rulb/xRN/MDhFUPyINxIKDE8f8zKVRbvahCm+QIA++7flwsFYIXpJpGgr/u33O00Ex1LsZ0bMRGCCQAviyxIO45xNzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723849156; c=relaxed/simple;
	bh=MJs2a21yAaqbtR36kVTBt+DPGz0l0wyzYftG3vvf3t8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qd/DkJMkl0T/x9UUpwz5a6FvaZnbTkxI1Bq6H+JW0RJBybqy8ZAzIVWYvDRiuFcGTgxS9/KVM59LCmuQEwyqiOl8uOXZUJpMAA/aR2duxUadyObRF6Vni+IpkrX7JHr4M3MrR8wlNnjqYFOkC7QDuvo4D4q/Q6T9Sjcsnj0mkAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ofh8Ed8L; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-672bea19dd3so42795827b3.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 15:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723849154; x=1724453954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6OigZl0tBlIvn+LyfmlGZPjZ8Rd3zNNzd+iuerO/zdw=;
        b=ofh8Ed8LtJObjpPNPZwS5rUSfm4TaWr597j443IPNSW58ea/eOXePXdSRBxq5mR6gl
         0KcG9INyVAUYkabl1R9kktS4U4JAzbWVI8q7YtMXkidR/H8rwYtRQYWF5zfhmorSe/Dc
         TqGOSTEJ3TrnkPwGm+UcCO/2Gp7NXVNvwn1o53QaA40CL930ivBhbXeHY81Mm8mF6JlL
         hqTbtRAO4m9Ny9+z9YPNHLfsOQomZVbouO8XqL2N7bF0WUYpWK3eDZKYbH3HNgljRlwR
         IYaZPedxhQm9b1Er2ZUnC0VdPwMlNuvl5Cbc5eFaPhSP9hDV8jRmPVm4jOnFh681NvQm
         BLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723849154; x=1724453954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6OigZl0tBlIvn+LyfmlGZPjZ8Rd3zNNzd+iuerO/zdw=;
        b=ceiLoVmvswlxViSSJQQD0AGNDArytxbi4L1aI357E/6xu+8cngGlfQWSKIR9CaLloz
         E0QQX2ETk7VcJ9ana+v4IrIzO6hz20/iCn/hnV0LIkBBZzewuTFZhr5xOMTKHC+W4o0M
         lsMMqPOxa1g44TWvf7t9H4UKwjzjLZVjrpkYBfKPzoy3CsmFvGfswv0ifXwr6gtkoPt3
         +Hnt+sYhCp/Oft9ZWJFVJOVJS8XfK2z20WrunrS5gVt0uDNn6VgI1/p+YgPDxdMzPR9H
         5fSRW+WBtQnYPL3fGUEXY66g+b5mevQ0vof22G8xb+mPl0v6pdF2Q2kwctZkdECfYmhT
         j50A==
X-Gm-Message-State: AOJu0YyXDzCnoSV9PlynogdDFJLoA0INU9noIRqsNDZuC3B1ghJ7lNea
	/mMZdIal3drQxTW2UbCXMo4E7gtG3g8vkNUGs0TNjTecH6nF9IbAEhumJ0pSUHNgMCT+2kyYN9z
	M1A==
X-Google-Smtp-Source: AGHT+IEBjklcX/YjjkCqt7TUIQQPn/5VaTiXo1FTpq7Fi5uIK9LBoTkBv7DIWbdiZ7fQsq0WqKSltBd9lwc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2a87:b0:673:b39a:92ce with SMTP id
 00721157ae682-6b1b7c6a599mr999877b3.3.1723849153801; Fri, 16 Aug 2024
 15:59:13 -0700 (PDT)
Date: Fri, 16 Aug 2024 15:59:12 -0700
In-Reply-To: <20240802015732.3192877-3-kim.phillips@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802015732.3192877-1-kim.phillips@amd.com> <20240802015732.3192877-3-kim.phillips@amd.com>
Message-ID: <Zr_ZwLsqqOTlxGl2@google.com>
Subject: Re: [PATCH 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
From: Sean Christopherson <seanjc@google.com>
To: Kim Phillips <kim.phillips@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Kishon Vijay Abraham I <kvijayab@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Kim Phillips wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> AMD EPYC 5th generation processors have introduced a feature that allows
> the hypervisor to control the SEV_FEATURES that are set for or by a
> guest [1]. The ALLOWED_SEV_FEATURES feature can be used by the hypervisor
> to enforce that SEV-ES and SEV-SNP guests cannot enable features that the
> hypervisor does not want to be enabled.

How does the host communicate to the guest which features are allowed?  And based
on this blurb:

  Some SEV features can only be used if the Allowed SEV Features Mask is enabled,
  and the mask is configured to permit the corresponding feature. If the Allowed
  SEV Features Mask is not enabled, these features are not available (see SEV_FEATURES
  in Appendix B, Table B-4).

and the appendix, this only applies to PmcVirtualization and SecureAvic.  Adding
that info in the changelog would be *very* helpful.

And I see that SVM_SEV_FEAT_DEBUG_SWAP, a.k.a. DebugVirtualization, is a guest
controlled feature and doesn't honor ALLOWED_SEV_FEATURES.  Doesn't that mean
sev_vcpu_has_debug_swap() is broken, i.e. that KVM must assume the guest can
DebugVirtualization on and off at will?  Or am I missing something?

