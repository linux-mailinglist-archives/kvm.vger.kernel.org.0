Return-Path: <kvm+bounces-45671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A02A4AAD1D9
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 02:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4988617FC55
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 00:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA0538472;
	Wed,  7 May 2025 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rR7uu1kp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D364A2D
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 00:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746576420; cv=none; b=Zd+oV2qC/yuQ3pYFo+XCWdYhgGtjwR4zcB9BjGaqXZKZZavvFd9CwokCEmi/AK5w4VI85zCcgqNTa/mhnugTVlf4/GRFbbbLSxvxXdsEUJnxwLntswd/VN0P92DjIQBeoDUWYEqMNr5d6pRB+pL60NUhkgIgcJz0FALkZBTr9cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746576420; c=relaxed/simple;
	bh=B/Q1rqo7fV2BZ1TxyIdMZoX0YUYdDfRp12zBu+jtqb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i6LnYWfXWE0NN4rdJqFyn8RgsRk33xLfWyFEdXKHSg0amcrc7rP7eiuK8SfHg+/bMsnq+NlB3k7gFd13W3BIRlQu2bC90kLot2pVk8E1xJ1wvFvWGln8eehDjYUWUVMgywhBYrJXaKYdPpHe6MQsA4P66QbHKOwdi9Y8KQVhlIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rR7uu1kp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ab4d56096so72992a91.0
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 17:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746576418; x=1747181218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=btn3LhqGUmuW2q5LXm3m4DGAhqR2o0uzT2Xd87u051w=;
        b=rR7uu1kpVYFXvhjvvl10Lxwq58At7fHL+9D6BjFYf37cuUz6bpKL4NLEXKNA+zR2kl
         QpPSn6NpkON3DkCvAyrt4RuU4DOu4gZwaZE+OLnWvaPiNwzUkayqwsuPLanSEKXjUwQs
         pzdPF0gwLnqp6tlm2pbS8c7VjHZE4z0Smc9AN5Rc9W0kZq0zrfsxjRphDtbvvHxfMU1Y
         A+0SPqTDSkTMYEKIrb6RZEuoUKzSjSrpJDdLEahaLYGc+S9VcNb1OwzQseXVlI0GaayL
         jub344ms6tnR62ey40sMOLB/e5uSsBcNj51SbY5EgMczx3VnDltPJPyTW9FJs6FxbFsJ
         5Q7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746576418; x=1747181218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btn3LhqGUmuW2q5LXm3m4DGAhqR2o0uzT2Xd87u051w=;
        b=VnBGPeor+jc0K2bby52Ftco7qu9mHi5W5FwBh+uQfgQsGrMSB5Y0h8Np3YRq44SLSx
         +HmSnuQycpPNptVrx67onZueOYHaXjbS++QwKbBQdwHwy/ahMRGs9NMDU+rrSs6VgCU+
         sbqCTwSeD29zGlf3VB03W69kYrhfdtjmYZtuTapFAcpSDARROqiO09M4Hr7Trwn7oO+n
         cMEoc187b4DWLcxaBFZKXyfv0QDDyx2Cyj8ehppPH5y/Yh/kMrUY7cUVaUYK5PPLgobZ
         IrU1r1fAx9mnlFE9PqiWoxj6S/FyZtLmd2h6deeex6vlJKgFdigLmqLY6i2RGWf8Ov/f
         AQbw==
X-Forwarded-Encrypted: i=1; AJvYcCUZQ/NSIJPS1bxVMJvKcop1NsIcFxOv1kgDa1O8WuVSCbESng26vR/RzK2ShhrNCtUEL1o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSaf1cmKvuAiMVYaHTFwX0onfNKc9P0G/OrbpaAoHTbcVvt9Fz
	LFUlN2fVBq2+9XgVJX9ngd1V2QAZ/IZeX6LUyKor9Dc2yrsZ9bK8ZFXqeE05iBDs9ZfQQMCwku/
	aSQ==
X-Google-Smtp-Source: AGHT+IE5kiyt3mLLPMmlAjvZ9sp27wxLvnJ1rcyvQV12u4OmcEbBS1ad1jPVl9wL0g7JEjpFk80jEUXWV/s=
X-Received: from pjyf14.prod.google.com ([2002:a17:90a:ec8e:b0:301:4260:4d23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc5:b0:2fe:99cf:f579
 with SMTP id 98e67ed59e1d1-30aac15ed4amr2041810a91.4.1746576417804; Tue, 06
 May 2025 17:06:57 -0700 (PDT)
Date: Tue, 6 May 2025 17:06:56 -0700
In-Reply-To: <20250109204929.1106563-7-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com> <20250109204929.1106563-7-jthoughton@google.com>
Message-ID: <aBqkINKO9PUAzZeS@google.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, James Houghton wrote:
> @@ -2073,6 +2080,23 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  				   enum kvm_mr_change change)
>  {
>  	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +	u32 new_flags = new ? new->flags : 0;
> +	u32 changed_flags = (new_flags) ^ (old ? old->flags : 0);

This is a bit hard to read, and there's only one use of log_dirty_pages.  With
zapping handled in common KVM, just do:

@@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
                                   const struct kvm_memory_slot *new,
                                   enum kvm_mr_change change)
 {
-       bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+       u32 old_flags = old ? old->flags : 0;
+       u32 new_flags = new ? new->flags : 0;
+
+       /* Nothing to do if not toggling dirty logging. */
+       if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+               return;
 
        /*
         * At this point memslot has been committed and there is an
         * allocated dirty_bitmap[], dirty pages will be tracked while the
         * memory slot is write protected.
         */
-       if (log_dirty_pages) {
+       if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
 
                if (change == KVM_MR_DELETE)
                        return;

