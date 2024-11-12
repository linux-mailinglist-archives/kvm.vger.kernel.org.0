Return-Path: <kvm+bounces-31659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B27A9C6193
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 20:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31F5C1F24476
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 19:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A94219E26;
	Tue, 12 Nov 2024 19:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B/JZF92Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5496E219E57
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 19:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731440023; cv=none; b=lolSJzuwCAyjgZTZu90kI/KBo6QjHFeO2mGcb9ROdAP8Bv5zXPv6rtSOo5cRG9vh505iO6Ya/7i9ta7aEJydus8Ozn+CZst5rNAVyPzEPZlfdQ+LNeHr4mGkKQF9ZpFb5/HgR7q2gNoUqzoc3Xc7clJSsy/zeQgmQZHFpxoJooU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731440023; c=relaxed/simple;
	bh=6C41LX4i9cTx1gh70EBFDyV45Diih+RA+d+s5h63nro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DGlM6HHMiArmwtX8wO1MWQsGhIB3dJSu55l3lw77c/nM+rm0q4rGaZ3wvPiD77JJBvYA4MGdTKCZAaM4uWh+DnBQx5X1ii/iQ9ZhPucg6GiikrPR7DtnHgu1vukIt/PvAj0DstOy28/oLSnBzcznvHWCnh5ebmHtlBaV7TVgOao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B/JZF92Z; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eb0a1d0216so40418227b3.2
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 11:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731440021; x=1732044821; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DY8XtbI4B5jvo0O8PmvLtsCSOMCPMY0S/opKq4djRSg=;
        b=B/JZF92ZZ78fLYjLCjvQJA4kERsYT0lsXr5A3of2i3ShTLPBvV0/nYaEo7YeR4g2Hv
         rcnUiRjKvs/sPo4ao9ME5nV7P5npSEXr7STVzTX6VmHDfkG18KrmlbeFbA2L2PyYoGqy
         TxBDl4MLYLLu9jnL4OVUhmp1vyaJo/cAEp6AqbXgHpBqrs+/tqTYZK1jtE/obpu002Bk
         GiMGkrjA1FwWqx0kK640NcEgO2hN96SPkoYluC5VgZbfM5BuO3oV8KXYyN5cviSPrmrp
         7OSQuhgjONrUZd+1O3w1gWHPGDioLBwbOCpFy1woQ+T92aDzO0hOKYN/Ug6ebmxdYFVn
         uldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731440021; x=1732044821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DY8XtbI4B5jvo0O8PmvLtsCSOMCPMY0S/opKq4djRSg=;
        b=MziKfJPj8FWi4XsKKL6ylWjH42cHsAw/d9YOfMCmbqcL+LarvOHXjsAH9kp8LksPtS
         CmColrB5uODQrJXtq1Oc3qPqaugP9DtZXM4EVRC167F5hvHTgAzmg0dKUqNsBq9uCAjx
         l/nLmwqvfdsK09A6LIcw0L1FFGsRl/ljpdpENfBrTWwYoGr2JurOo4stE599OTIc0Jr9
         K798zMrGUBP1Ps4qM99i+UGxkMO2x4CxVmq6CQLicXGuPEb46V5THTwTEVIGa8n8DHtW
         1ywnGU8ofrYnb0EyCG5GjDN8UMUiQg19/FBbjxxt7qrFaVFUT3eNfK/tp57i7ay1lTfr
         8eHQ==
X-Gm-Message-State: AOJu0YybUuB2BMH2k2byjeQgxOgXHHPqTbyJ3/w5CULVljNGm6DWS+xG
	DJqGIKDr3IwIbaHEDTWylr4faNlFeaYCBr+IbwKQmzAIhrWQ3mgPS7+j8raJt5azks0d04+4EHb
	3Eg==
X-Google-Smtp-Source: AGHT+IEfiBnG43gqjtPlri+V2asF4S1cpViCIopZffwXn6FSbMi2vaF5IgSBd31XWNhwa69IX48SXk7pAsA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:addc:0:b0:e30:cee4:1431 with SMTP id
 3f1490d57ef6-e337f8465a7mr51655276.1.1731440021500; Tue, 12 Nov 2024 11:33:41
 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 12 Nov 2024 11:33:31 -0800
In-Reply-To: <20241112193335.597514-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112193335.597514-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241112193335.597514-2-seanjc@google.com>
Subject: [GIT PULL] KVM: Generic changes for 6.13
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull two changes that coincidentally happen to be related to vcpu->pid.

The following changes since commit 5cb1659f412041e4780f2e8ee49b2e03728a2ba6:

  Merge branch 'kvm-no-struct-page' into HEAD (2024-10-25 13:38:16 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.13

for you to fetch changes up to 3e7f43188ee227bcf0f07f60a00f1fd1aca10e6a:

  KVM: Protect vCPU's "last run PID" with rwlock, not RCU (2024-10-30 14:41:22 -0700)

----------------------------------------------------------------
KVM generic changes for 6.13

 - Rework kvm_vcpu_on_spin() to use a single for-loop instead of making two
   partial poasses over "all" vCPUs.  Opportunistically expand the comment
   to better explain the motivation and logic.

 - Protect vcpu->pid accesses outside of vcpu->mutex with a rwlock instead
   of RCU, so that running a vCPU on a different task doesn't encounter
   long stalls due to having to wait for all CPUs become quiescent.

----------------------------------------------------------------
Sean Christopherson (3):
      KVM: Rework core loop of kvm_vcpu_on_spin() to use a single for-loop
      KVM: Return '0' directly when there's no task to yield to
      KVM: Protect vCPU's "last run PID" with rwlock, not RCU

 arch/arm64/include/asm/kvm_host.h |   2 +-
 include/linux/kvm_host.h          |   3 +-
 virt/kvm/kvm_main.c               | 143 ++++++++++++++++++++++----------------
 3 files changed, 86 insertions(+), 62 deletions(-)

