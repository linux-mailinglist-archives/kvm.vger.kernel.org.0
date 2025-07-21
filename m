Return-Path: <kvm+bounces-53046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B82E4B0CE49
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 01:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65FE21AA0888
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71AAA246786;
	Mon, 21 Jul 2025 23:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oAMjTC+q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA6E232386
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 23:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753140995; cv=none; b=VawJdwp8Lo3T+upCQPX5Q1e9UfxHp1mt2i8ebcJxx33bhIvmssEYZg8HHcjbfg53cZmztPTKfF+KT5wNIUV6oiPyFyrK45C4RC6caiX+Y78nhGHg4eHFL+d2f0shWZk/z2x2A+HntI6rY9lMiQvCM1LA57ykgzw4grCVui3qoIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753140995; c=relaxed/simple;
	bh=75dMwOD9AhRAfD3iv6MD69VKM7Uns0ZEiqNvuewGj/w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MCYpVZq4XfW6BTpWbwjyJjV+jEAR64EXl5Z+fywcPmw+8/A0LE8cYsKVIgxNibqV6gg7ZoWztisnN2Eal5PNwwd98XQ/2AJu88hHGSLHulEjL0zY/EZSWW1IZvYugta5doOCL4UFFvlPS/zglAIOBIYgoCHfmZ3jjYQFFY9EYg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oAMjTC+q; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fcbd76b61so5535839a12.3
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 16:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753140993; x=1753745793; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5YthwGXG3vj6QbGejtobQA1vVh1doihtlZSxEX69D84=;
        b=oAMjTC+qNJlZAgcNToEI6LxX3pWG2b4W3irkJY8lxXAGcmxrT+nuUojFcLYOyFeCne
         bCOj2nEtlwFH27OJOcix5mQ8KWVzufqkFx2WilQ2Y94Ui0qzYWDlt5CJf6L3mVNZoXcr
         6n+VDZK9E6xqudI3wr3yu2UnBDjgQfzM4cvL0jVa+1V35baDwe8onCU0i9buBOj7SBM3
         /nXypEy1a9RdgkPS0EJ/GKJgjCGmn4YuVvn5DC1aOmWC4F6gkUwLuZbNFEZgnmB6mowm
         cvqQgweJ3/WAacO2B2W8jaDSVXOu4Uc69ZB5MdNXL6mxVNpTe+kd+0xKpVgFrYgDmus/
         gTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753140993; x=1753745793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YthwGXG3vj6QbGejtobQA1vVh1doihtlZSxEX69D84=;
        b=qS9U4eoKbAcr06n29MFpU9au2FPh4n9G32vn0HYYF9Y2K6rUAjSa5XDQJUf3XHTUjh
         LvYlUwf5mdVuUS7Y7HNQKn4MiwF4IwFoZShio0o0XrNwGiwehfZ7P3FPBJKpmghGw0zT
         6VJToC9jbsJrsiHipO1RJgc6y4yG/s8PeGQDP4sjjoI0j9PT37LDFsDmt+kVsrwQbEvc
         b9rAJaRyWnqAEjOOwQUAxnfjdDnUtUmLjkE2OmJ8AbWWouhtTxd5szO7UbCzSC6Pdnqy
         vu84JTg5QWvGfCqSBVFSdV51SJnrBCRt/PxcohQCK9OULxD0mmsb2zgBBhYoIn5Tkg7j
         DWPA==
X-Gm-Message-State: AOJu0Yxe07olyeNBT8YQVYPybW7F3Az6XDgnKJaCyngro+8lKuAKiBhG
	A606ClPKL8grOHIUJCcYaES78Xa3vjiHfpCVnWnQyuKNubmQEKONopnkzmcyd9m9gqlFbTtMmXD
	pK3p94A==
X-Google-Smtp-Source: AGHT+IE9g3Dc400fJRZPtwB8je6BnCrNs3sMZht75tqkWzv4R0BO7MR7AIhpIUbUXri1mozX0W2ey+JTujw=
X-Received: from pjtu4.prod.google.com ([2002:a17:90a:c884:b0:31c:32f8:3f88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a4f:b0:31e:3848:c9ee
 with SMTP id 98e67ed59e1d1-31e3848d027mr4301574a91.9.1753140993732; Mon, 21
 Jul 2025 16:36:33 -0700 (PDT)
Date: Mon, 21 Jul 2025 16:36:29 -0700
In-Reply-To: <20250718181541.98146-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250718181541.98146-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175314043500.309494.16326805597766494871.b4-ty@google.com>
Subject: Re: [PATCH v5] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 18 Jul 2025 11:15:41 -0700, Sean Christopherson wrote:
> Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
> which enables more efficient reclaim of private memory.
> 
> Private memory is removed from MMU/TDP when guest_memfds are closed.  If
> the HKID has not been released, the TDX VM is still in the RUNNABLE state,
> and so pages must be removed using "Dynamic Page Removal" procedure (refer
> to the TDX Module Base spec) which involves a number of steps:
> 	Block further address translation
> 	Exit each VCPU
> 	Clear Secure EPT entry
> 	Flush/write-back/invalidate relevant caches
> 
> [...]

Applied to kvm-x86 vmx (again).

[1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
      https://github.com/kvm-x86/linux/commit/dcab95e53364

--
https://github.com/kvm-x86/linux/tree/next

