Return-Path: <kvm+bounces-58912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FAA7BA597E
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 08:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 310574A1860
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 06:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DEE257422;
	Sat, 27 Sep 2025 06:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kjzr4HOB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E311254855
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 06:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758952971; cv=none; b=uIU4Vfiux4t1xEf+pwQZI22cR3oB+SA01GWqwQ8L7jewaEC4+wGJChOzg9hkJ0s2hCYulC/Pif2532Nl2TkkOjMacVmy1Dvjw3oCZvZP2YtKZQdoEbbqvZZf2xuzBW5EEamGzNKNenmdAOxvVm3dbQD4vVBs7p4mFXrdIgRXIk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758952971; c=relaxed/simple;
	bh=zCVl73JMB1ILRN0jM2f4aqDdL5c6hRSipsaHR6tah9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tDNi/cmF0/Tcc4Rk0i8fBRYqSKG5x+cKRn5OrbB54fAAkKQ4hpHjP9KaJXnfCIE3N/8yre1W3Dg1XHtp3UvyxBAg/fYiAZwGorxgbIbaU6QXRZ+7+DUOEVd7ZLISb0FXVq7qAnvMqLAcyCXAKCrNl9sFRYEyVKZc7RClqjCXP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kjzr4HOB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-329dca88b5aso3999078a91.1
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 23:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758952970; x=1759557770; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EZz9pdPxtkQCQg0LwPC7a9M9+XqgI2y1Onp5LAdJY54=;
        b=Kjzr4HOBQCl4MwfaqGIScTaKZ3yQv7ScjD/ZZlFTf2JjhmakiM6jgI9WJNKTi3tEtP
         wPKhAiOmL/ueKi3lH/cu1MUwdHbIIBRSoEfPZ5AcwFoLY+vMBCXhKptTEMpV0Y/CsBYK
         +mu6lmQQIoRj0RC7ElPvdG+5ssuuPMAYzWfD1Xrr5q3Fw1ETlvCWMlzkeLCzDD9YD9ZA
         A5gZtKuLdLILk2n4iMM31UBid52xYr6DSgKcP2BYFcyigiyoqKgBgb9GSJVR3kq/8gms
         X+n+S1QEuhLC39XHAE/bTgKYwAwGZNthKgbuz6zVyJ4Otu/Ii1GxDllbk4cmJTlj9J4O
         uu1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758952970; x=1759557770;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EZz9pdPxtkQCQg0LwPC7a9M9+XqgI2y1Onp5LAdJY54=;
        b=HkjxESR09uzaK9BXazmeDKMZQaos0xJcIYf3skPES2SZT/0alE0qTje9B4d5mDACnr
         ZHO6YgMxUE2YuHoMUhIKXCCh4zVLI80Nx83noEh+SySS4izOJwbM/KMsHB2l5nO5Im41
         fHHn+ASIfdflJREdpb7NKLwa9+INF9b4Fk4ll1H97/gxphBjufmXrZxKPsWkdB2os3nA
         f5tfY+4gkhWjIiF2T4CTYahV0SsBmRC3hKk1csDNMUGSEsz4LuikI2mITjtFHcsFzQfP
         H+NkfFkgdvF1RRAvTftyqj209/xnisz0p9E3GpTRO4k9osGhTLYA7RBLXP+/ymjLRILj
         mtgg==
X-Forwarded-Encrypted: i=1; AJvYcCVahIrMxezreZ20LKFXwijlX7R32TYYItfkjRSVJixHHNc0tiPSr+YMnbcm6GDMK14VM10=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuQBAFTcxXZcukQ8m7z2UWlPypXJ6rsUKdYPmEWL5U2LfeF2F0
	asrLBm6A5Wo339uhzmuuvb74K/c/crOaeVLemRnn2MEHkforZvLQEX1wIWI+2PTxjaWjzPYz5x1
	X2gGldQ==
X-Google-Smtp-Source: AGHT+IG+O2/UkKI29OQKSSuWam69+x9DRDtxFfKKLWwebRfAoiKlUD2jq0l73MqVAHzrMbEcLiUIcTj1iZg=
X-Received: from pjst22.prod.google.com ([2002:a17:90b:196:b0:330:7be2:9bdc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b43:b0:32e:72bd:6d5a
 with SMTP id 98e67ed59e1d1-33454f56a18mr9327831a91.1.1758952969598; Fri, 26
 Sep 2025 23:02:49 -0700 (PDT)
Date: Fri, 26 Sep 2025 23:02:32 -0700
In-Reply-To: <20250919003303.1355064-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919003303.1355064-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175895291958.2931667.5042104101547847294.b4-ty@google.com>
Subject: Re: [PATCH v2 0/5] KVM: Export KVM-internal symbols for sub-modules only
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Holger Dengler <dengler@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 18 Sep 2025 17:32:58 -0700, Sean Christopherson wrote:
> Use the newfangled EXPORT_SYMBOL_FOR_MODULES() along with some macro
> shenanigans to export KVM-internal symbols if and only if KVM has one or
> more sub-modules, and only for those sub-modules, e.g. x86's kvm-amd.ko
> and/or kvm-intel.ko.
> 
> Patch 5 gives KVM x86 the full treatment.  If anyone wants to tackle PPC,
> it should be doable to restrict KVM PPC's exports as well.
> 
> [...]

Quite belatedly (forgot to send the "thanks"), applied to kvm-x86 exports.

[1/5] KVM: s390/vfio-ap: Use kvm_is_gpa_in_memslot() instead of open coded equivalent
      https://github.com/kvm-x86/linux/commit/66d1a7ac946c
[2/5] KVM: Export KVM-internal symbols for sub-modules only
      https://github.com/kvm-x86/linux/commit/d66078b8c990
[3/5] KVM: x86: Move kvm_intr_is_single_vcpu() to lapic.c
      https://github.com/kvm-x86/linux/commit/16e53ef18450
[4/5] KVM: x86: Drop pointless exports of kvm_arch_xxx() hooks
      https://github.com/kvm-x86/linux/commit/26caf4d04e01
[5/5] KVM: x86: Export KVM-internal symbols for sub-modules only
      https://github.com/kvm-x86/linux/commit/aca2a0fa7796

--
https://github.com/kvm-x86/linux/tree/next

