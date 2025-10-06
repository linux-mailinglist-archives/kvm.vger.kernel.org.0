Return-Path: <kvm+bounces-59542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 546E6BBF154
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 21:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0000134B27B
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 19:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542042DE71B;
	Mon,  6 Oct 2025 19:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TE2t7rHO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12472248F58
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 19:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759778222; cv=none; b=Hx2aQYC93hGu+fk44rw2e5i6ocA6awEkWfxMm3T2p2GhKJ7W6KUG57t97TVtqmQDld+EeLwx4UKHBO5s+7IuiJXlRMnZ4DJqiBrZaoV8FqFhZPNaRs50KjucpWFeOzp0gfcdgZUoP/hjJdJeQnDCHiAl1pJEAvlua7tVh54jhwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759778222; c=relaxed/simple;
	bh=cM60IkBOfzroK8/Hzvuzyt9qlRtbHMsJ/OSo9179Sq0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N5rm0GaEYd4Cdt7ed/cCpWGd08UN1/Glfn2z0rSHcfdZrwyu7qzW0nZTfqeyzQqJkzYOAx+rUayHoh0Oa9DYS7TlyHaZR0cEwHDNU4kd5LGgPtXJGkxcVLz5/z7Ydl13UTNNCscnyyvHjRgW6gKEoJAOn9w2iPxqF0g/NKgoBq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TE2t7rHO; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2699ebc0319so50741205ad.3
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 12:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759778220; x=1760383020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UmP4P4nLLPuVhrMlePaQHRElG0BD9VdigM6MdStk+fU=;
        b=TE2t7rHOVPb0OBN8svNnP6LY+cJXj2jyZBEYy1ljGiQLaiHX/Pt3U2gRJgynz2IFzQ
         3h17ZJp2tLA16kvmUjVSf4pzX+WhuUAe2cgmUQXHiky6URyU+1NgDcPILwALgOjpAB+N
         pB/F9jQBbBkLBPIcVdPuk456KmszUQHeQnybTlMn9Tl9HF2fv+gRFg4ZfR/0PSsIfxGp
         j6v91Fxm3MwFV56dVWkOQ0FP7J7ea2PX8RmkyDQeSABj0IjQSLc/ZCOQxQNhOtMTrI2m
         pPPVrU1lptz63wBFZIBEaAdbsUKbK0td5gscTTxR0HObsDnXgzY3uUK7x+7s/xTtdBSH
         r0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759778220; x=1760383020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UmP4P4nLLPuVhrMlePaQHRElG0BD9VdigM6MdStk+fU=;
        b=KGH8IK5iJ9ITRgU59dvUx9D3hxtXy6nSUPM/N5J1YKKv5lteJ5a1zh2h/unus+Kpo/
         +etVtJ0PGDN4CBhx7KP4AtUvx6keh160OJrDNHMi+J7fzszdy3QkK5dZqWGkFQwir7/C
         EwxT7R40E2wOW/CVarrECLGkUCQXXySM5kVU8UZY4KTZr33orfZh5eUUxry9TJb+/Eb9
         qXECFYK+o2nkW+EAWdjclgFTdzXXRCqtSd7ThqTaXqmaz0khPmsqg3bO6/yuzqvA37lz
         fnviWVtCN9SQ+qJmhtZUPBr8KpXYWI68o66Xp640xw1Rpd8Q4UK/mI2bePytXYSsDbFD
         +HrQ==
X-Gm-Message-State: AOJu0Yxw8fb4O85ezjLeC96OQwt0pruOXkrHIF9xwuDRJb5EjG4bVd5a
	Kn7xgjssBoL9Bf/FbuYCwQ+RcuYLu0CnzvuYh7Jli9p5N+C6RzbPKBH251OPNTeSuPZRG4kGHAJ
	t0vt2KI2dWsJmHbOwB2SF0y1csg==
X-Google-Smtp-Source: AGHT+IFyvieDVAJzpWWfH+/pCoaAH28kEGEsXDjiF6l+kpgp/Oi5CGPOiOvnSAUYzLGP6ggwRAbOwNW8BRrqhE15cA==
X-Received: from plau17.prod.google.com ([2002:a17:903:3051:b0:27e:ed03:b5a5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:11c6:b0:262:79a:93fb with SMTP id d9443c01a7336-28e9a61a8a9mr128039295ad.32.1759778220362;
 Mon, 06 Oct 2025 12:17:00 -0700 (PDT)
Date: Mon, 06 Oct 2025 12:16:58 -0700
In-Reply-To: <20251003232606.4070510-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-2-seanjc@google.com>
Message-ID: <diqzplazet79.fsf@google.com>
Subject: Re: [PATCH v2 01/13] KVM: Rework KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FLAGS
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Rework the not-yet-released KVM_CAP_GUEST_MEMFD_MMAP into a more generic
> KVM_CAP_GUEST_MEMFD_FLAGS capability so that adding new flags doesn't
> require a new capability, and so that developers aren't tempted to bundle
> multiple flags into a single capability.
>
> Note, kvm_vm_ioctl_check_extension_generic() can only return a 32-bit
> value, but that limitation can be easily circumvented by adding e.g.
> KVM_CAP_GUEST_MEMFD_FLAGS2 in the unlikely event guest_memfd supports more
> than 32 flags.
>

I know you suggested that guest_memfd's HugeTLB sizes shouldn't be
squashed into the flags. Just using that as an example, would those
kinds of flags (since they're using the upper bits, above the lower 32
bits) be awkward to represent in this new model?

In this model, conditionally valid flags are always set, but userspace
won't be able to do a flags check against the returned 32-bit value. Or
do you think when this issue comes up, we'd put the flags in the upper
bits in KVM_CAP_GUEST_MEMFD_FLAGS2 and userspace would then check
against the OR-ed set of flags instead?

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/api.rst                 | 10 +++++++---
>  include/uapi/linux/kvm.h                       |  2 +-
>  tools/testing/selftests/kvm/guest_memfd_test.c | 13 ++++++-------
>  virt/kvm/kvm_main.c                            |  7 +++++--
>  4 files changed, 19 insertions(+), 13 deletions(-)
>
> 
> [...snip...]
> 

