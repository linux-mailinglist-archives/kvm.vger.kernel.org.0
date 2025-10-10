Return-Path: <kvm+bounces-59787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2550BCE9DE
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 23:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D67A3BA895
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 21:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B01303A02;
	Fri, 10 Oct 2025 21:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b1YD6n7z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A9B944F
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 21:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760131847; cv=none; b=nF0NJ8sp3yXi6qDn5CuY+o9ZsXq5lfe8WzB/EMmsye7WOwdzewNmhdFXAYHINkkd+xFtdogeRp9OkehtkFtGdNavOZbJNQFw8zI6dJI5JArHd7INtfAdrEG/BiEw4siUqy4BVL+cDdZtDgXrWU0VdGcY0nyrtQ+XmVN287llkLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760131847; c=relaxed/simple;
	bh=8zKyXaHOvmn3AJoM4OXjo5ZeZBPGV2jnNiJNSEkUuNQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UBdznrqLhlqZxWoetqOg9soWvo6AqTbBIjr8WzhKUxHE65/Jpg6ihcp63Vv5Dqk1Jb4AZo8U0T/DIPsuyhZN9N8odX5D1g7rLzRcWoaYjHxE3GJoMRdTnLxyjaplvoF4Qied/Zztdj/MbECnewP0oj2gYHSbdtiMcvmXX6Kd2R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b1YD6n7z; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so6611869a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 14:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760131845; x=1760736645; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fdza0wCNfmbut06x9h8ZEcd5rkvPKD5X3a2HlIm2klA=;
        b=b1YD6n7z8250tO0RyK5usSDxcPCanuvqfYf3GlDW0R1OSoA5TMSCwwOPqfmake81E6
         q39CIo2fdTojkyl4P8nWP++/HTLMpgFBgya4EDS1GrAp+oxKtVpIHVgnjKDngaDW/yQT
         9zw8yYAvjbwuaA/4HaL9MkKIxiGa5e6SX0u3T9Yhv+TgHIiuwwP5U/gTZOk0bPjgB57F
         GLms1d/qH5A7246d7GMdOzgApWa8h/+O+qJBf1pZPj1PcHxZyUKpNdo2ngJZ4klFnyp0
         FLgYb68dYDKnn/EzbD5N6mF4eLtrcvSWyg6ihLlJUwcIpaDV/x5vp8GbXul8VRua2EW2
         RKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760131845; x=1760736645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fdza0wCNfmbut06x9h8ZEcd5rkvPKD5X3a2HlIm2klA=;
        b=gnC8MBrKcSiMEqE1Z0EoGE68W61v1pA7Vdp9P7NPJioHN8uziBisDTLH8d1N7BDk7S
         qvBfihfocusie26taXBczt86QMEMJSce+tVYeDTlLuKbeukDAxOQ8V4v39stJ9RYBtio
         O3oxxIqsC09k6Dr5ylnQsJm6cvDyYPT/CQZ+43sE6HjgThLltTiJUUroxEoh3nKLOq3u
         1I25fhgNYPqFdEa9vcpsIeoCKeM3nQ9Yfu2XzyIu/3IWa/T6L1LelNWcUIr5JeV15th6
         yxh+VUoeVUxYOFcqSjXipkXz/BwII/JOl+U8o0BwcPWU2ikDDBFSLaChPQe/dQ0LzKnl
         820Q==
X-Gm-Message-State: AOJu0YwevQj1QtnRax5qybll/qvYhUbZATE7DHMPW/PRuNpMpHokJN9/
	lcIgNR3a0l89rY3IVWa7OHyL2QJultsMhFlxMLT0LtR6z6YW72yP6wWeEqwfIdUZ3vlm38XHlhh
	6C3nDuA==
X-Google-Smtp-Source: AGHT+IEygGJbr/jdLmJKPXL2+VbE83XJAixGp4cjBDCbyY0/1d/YUT7lEZRif22jY2RS+Di7munkUEut4XY=
X-Received: from pjbkz1.prod.google.com ([2002:a17:90b:2101:b0:32d:e264:a78e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d11:b0:32e:7270:94a4
 with SMTP id 98e67ed59e1d1-33b5116a3c5mr19014051a91.14.1760131844583; Fri, 10
 Oct 2025 14:30:44 -0700 (PDT)
Date: Fri, 10 Oct 2025 14:30:34 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <176013139711.972957.8677531848796740648.b4-ty@google.com>
Subject: Re: [PATCH v2 00/13] KVM: guest_memfd: MMAP and related fixes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 03 Oct 2025 16:25:53 -0700, Sean Christopherson wrote:
> Fix several flaws in guest_memfd related to MMAP support, the big one being
> a lurking ABI mess due to MMAP implicitly inverting the initial private vs.
> shared state of a gmem instance.
> 
> To solve that, add a guest_memfd flag, INIT_SHARED, to let userspace explicitly
> state whether the underlying memory should default to private vs. shared.
> As-is, the initial state is implicitly derived from the MMAP flag: guest_memfd
> without MMAP is private, and with MMAP is shared.  That implicit behavior
> is going to create a mess of an ABI once in-place conversion support comes
> along.
> 
> [...]

Applied to kvm-x86 fixes, I'll send a pull request early next week (I've had
these in -next all of this week, though the hashes will have changed due to
rewriting history to add trailers).

Thanks for the reviews!

[01/13] KVM: Rework KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FLAGS
        https://github.com/kvm-x86/linux/commit/d2042d8f96dd
[02/13] KVM: guest_memfd: Add INIT_SHARED flag, reject user page faults if not set
        https://github.com/kvm-x86/linux/commit/fe2bf6234e94
[03/13] KVM: guest_memfd: Invalidate SHARED GPAs if gmem supports INIT_SHARED
        https://github.com/kvm-x86/linux/commit/5d3341d684be
[04/13] KVM: Explicitly mark KVM_GUEST_MEMFD as depending on KVM_GENERIC_MMU_NOTIFIER
        https://github.com/kvm-x86/linux/commit/9aef71c892a5
[05/13] KVM: guest_memfd: Allow mmap() on guest_memfd for x86 VMs with private memory
        https://github.com/kvm-x86/linux/commit/44c6cb9fe988
[06/13] KVM: selftests: Stash the host page size in a global in the guest_memfd test
        https://github.com/kvm-x86/linux/commit/3a6c08538c74
[07/13] KVM: selftests: Create a new guest_memfd for each testcase
        https://github.com/kvm-x86/linux/commit/21d602ed616a
[08/13] KVM: selftests: Add test coverage for guest_memfd without GUEST_MEMFD_FLAG_MMAP
        https://github.com/kvm-x86/linux/commit/df0d9923f705
[09/13] KVM: selftests: Add wrappers for mmap() and munmap() to assert success
        https://github.com/kvm-x86/linux/commit/61cee97f4018
[10/13] KVM: selftests: Isolate the guest_memfd Copy-on-Write negative testcase
        https://github.com/kvm-x86/linux/commit/505c953009ec
[11/13] KVM: selftests: Add wrapper macro to handle and assert on expected SIGBUS
        https://github.com/kvm-x86/linux/commit/f91187c0ecc6
[12/13] KVM: selftests: Verify that faulting in private guest_memfd memory fails
        https://github.com/kvm-x86/linux/commit/19942d4fd9cf
[13/13] KVM: selftests: Verify that reads to inaccessible guest_memfd VMAs SIGBUS
        https://github.com/kvm-x86/linux/commit/505f5224b197

--
https://github.com/kvm-x86/linux/tree/next

