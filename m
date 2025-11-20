Return-Path: <kvm+bounces-64004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 632BBC76AA0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:51:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8DD6535EC44
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B1FD30F526;
	Thu, 20 Nov 2025 23:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DcXQ4x2z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EC52DEA7E
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682614; cv=none; b=hZ+3oX3T3Aga8QuyRcbk47KaB5aKTBtQ91o+0aer1pXcbTw3WcWX9pN30J7HUavwKwRsTu91qXISNMxSeG4B8JE2qLBDAem7dsH4SfAL7wjFthLsBLEICpo+s8V8EkAZ+sd0f7+J7bOm2VCWZ+DZ4G2MOLAYXNf8aUyVBGgTJ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682614; c=relaxed/simple;
	bh=u4SFnRoCGK4YW5z/86vpLMACb3jNFm+pdJNm27xqKeA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MnaZny4yQNDjOjg7jyGPt+x2XMsZ13yXDc1B/nHXkjEjEBr+JgHVTsDZEcclsuipscBY6B7QsbSlCx319lG0sLW7hnSHgivCaQJJhL1QgCqyL84glOrJ1J5dshJA0FQ3yxHB3I9MT7oA5vzaNd6sanmpMR6M7A6j1se8LkjgwB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DcXQ4x2z; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958c80fcabso44861015ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763682612; x=1764287412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DEHkMQX4gtwNVcUI8F9XdQ/Rl32hTdIYl7b3cTjYlTM=;
        b=DcXQ4x2zYGAHK5+OgvmXqzJqP0+GX0GPDhzFDT1lWHeLBDF7OukLVaDMcfLETnw3mZ
         wJ2vN2sOqHr6QBIt0t6Gj4psxhl47c9Gxke8KxBjcWqPgQfjplQkECYNNfP+H1I05t16
         Ry1roOSSGOqffRGid8ugP1poZuh90Qvcgk3VFnQ9k+DrygscH2GDTZpUI1MhUdEISqNg
         qmhbS/BeMAIpgMkxefP3mHjU10uuK0NQmKXKxwTd4pJ9zG+e+3v9kjQqE+IAB48qo/Ys
         8Geyq4wpTxhfVnN2i09rL7SEG0lDsrs37V86jhIIKi6WGQ+IwqJLR6TRylXQ80qNQa20
         /H+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763682612; x=1764287412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DEHkMQX4gtwNVcUI8F9XdQ/Rl32hTdIYl7b3cTjYlTM=;
        b=ReJQldqZaTcdL2aTbOOzF6HL0liSw2yMrU8U5qMHVubUowi8fr0YaE99wjEo6DSEoB
         D/vCtTv07OdjZ/HxkhWqmKnMnZVINqLSm5URCu3JQ6qoow4++O5sN75OaU3rZ/Wjbou1
         3hy/ZXNKmZOJDHHTToyei3W3YaPr1D9J+gbTvvenFESpAvHA62vQRc0fXBQX4qx4k0yI
         dR+FMf9QVXDedXOKQ8TObVu9WO/tHsx2Az+3PPHD07nmntELU/GfpWq1OpGqQ0M7Ighd
         Tn7KuEyXZaUUntOisZgU521Mqxj1sKRXa5f4DO2DKp+bjcxP0ULPAVUOs08kcBTBktkU
         wBBw==
X-Forwarded-Encrypted: i=1; AJvYcCUh4eMlZ0Y4Hc9cRLEFGPR0NqRX2F5cvacy8jZVTvfR2sz7CaP6qsVDU/kXRPUKkjY2uG0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/tLY2xJZsAh3/m0B2rCnprVEi9NLxSfXo3ZXk7qVaVkIC4byV
	EwEGRsz/iQb5kt/roCSD8QhXD8S8PwUf7r1UBMITTORyW9/5pAwTSd4EgyvWu1i/QXBRbu1/7HQ
	bnliMXQ==
X-Google-Smtp-Source: AGHT+IElAG6XWduHRi1Y/uUGHw6npqgKQj/yZIYSQQHOC0lTjn4Zhve1bS/jAYkG21kwmsZcXTrWW+By8+A=
X-Received: from plbmf11.prod.google.com ([2002:a17:902:fc8b:b0:290:28e2:ce57])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2408:b0:295:4d62:61a9
 with SMTP id d9443c01a7336-29b6bf353fdmr4214375ad.38.1763682612200; Thu, 20
 Nov 2025 15:50:12 -0800 (PST)
Date: Thu, 20 Nov 2025 15:50:10 -0800
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Message-ID: <aR-pMqVqhgzsERaj@google.com>
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> There are multiple selftests exercising nested VMX that are not specific
> to VMX (at least not anymore). Extend their coverage to nested SVM.
> 
> This version is significantly different (and longer) than v1 [1], mainly
> due to the change of direction to reuse __virt_pg_map() for nested EPT/NPT
> mappings instead of extending the existing nested EPT infrastructure. It
> also has a lot more fixups and cleanups.
> 
> This series depends on two other series:
> - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 on 57-bit L1" [3]
> 
> The dependency on the former is because set_nested_state_test is now
> also a regression test for that fix.

Uh, then the selftest change absolutely should be sent at the same time as the
KVM change.  One of the big benefits of selftests over KUT is that selftests are
in the same repo as KVM.  We should almost never have to coordinate selftests
chagnes against KVM changes across different series.

> The dependency on the latter is purely to avoid conflicts.

Similar to my feedback on your mega-series for KUT, don't bundle unrelated patches
without good reason (and no reason _NOT_ to bundle them).

I want to immediate take the patches that aren't related to the paging API changes,
but that's proving to be difficult because there are superficial dependencies on
Jim's LA57 changes, and I need to drop the vmx_set_nested_state_test changes because
they belong elsewhere.

Bundling these is fine since they're thematically related and do generate superficial
conflicts, though even then I would be a-ok with splitting these up (superficial
conflicts are trivial to resolve (knock wood), and avoiding such conflicts isn't
a good reason to bundle unrelated things).

  KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
  KVM: selftests: Extend nested_invalid_cr3_test to cover SVM
  KVM: selftests: Move nested invalid CR3 check to its own test
  KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
  KVM: selftests: Extend vmx_close_while_nested_test to cover SVM

