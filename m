Return-Path: <kvm+bounces-59788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E60BCE9DB
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 23:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7A4D6350C17
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 21:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528B1303A1F;
	Fri, 10 Oct 2025 21:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oYbVRhIn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6A2302CA7
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 21:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760131852; cv=none; b=pph7Ks1q4DSzbAU4pTbUYzoVGhkytJ/74G2478gWJw1GJGlyP0t5xVqBJG5bHkgt8UQlagmtqsHNphXtl7jaIWo98qTMOcO5XeYxfKYcJIs/Ct7K+KgK4rstx0cUOmMfhE3iOGurmJ8RIXkt3g/cnzmPoHMxensB+lOs+t0gHSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760131852; c=relaxed/simple;
	bh=x8ZdD9t8xaKyanN3XNVD+r2/6u9tMr0Y+7qjId0Z1kc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TRJwLiFRLe8tvWtftvFAoePZCtQ34gfH2km0y2WNJJ7DhA9V9cGo73Nq4MBRUTEPpDA4kRi7MxpTwdcCk2qbB1aGHl8+VV57wFyBCaA9LcjIr/QQFYMXaZJUO5AF8Q1c3jWgsR9plCFBtgdbmQ7HJxN1LnmxvhGs5i6L8Vocw6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oYbVRhIn; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b62ebb4e7c7so5439893a12.3
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 14:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760131849; x=1760736649; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EL7WGjbXjGss0nIK+61duSt+Dw39EYfognGEJJFlik=;
        b=oYbVRhInqgq18OMJSlpNIK6xXgyZU5lspp0gO3E9ECvlppFs3s6M127qJHEk8DoMXe
         uaSVFLA6FKtGd1tiZefyhclq6HOp0Bvxa2xMt1aIb2Hk8I9lSOzinOhTnP1WyiMfU86k
         sM4u2CBKs7cpIlRkNOnyirtewa8fAMtTfnnk9hTWcoyrKfl7/XmohJq/avbKsdZFFsyI
         DKwCQqlFHioY7/7NsMCFtzZYrWzt406sUFVfWGqCsxYrXrOcCdeZV49QuXFnwZAlqrdK
         ogi83FdD+9AWTRCKTPNWMSbIvQkWjisHLYj5WaBnoZbLudOiNTkdGzpIj8dHKtCvqTbD
         YlAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760131849; x=1760736649;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EL7WGjbXjGss0nIK+61duSt+Dw39EYfognGEJJFlik=;
        b=wvWdt8HvRuz9aGrgye2Vjaj+p+yuTwsNVSCzXOfCHMynMQC9MQdrRSXvvFfNwFEX3j
         KKHBJy4Z2B1t2HUBXMweXiWRmesnahV/NRbO1xvvTDgjoF8Du9Mly5JjpKGOhaQN6kU3
         fiy7Kwqn79vp1kS9ZvqQqOapHQacxf1munlguE/FPacgKE+3jNVlDdYXPiDcUW7VMpxt
         y/y/A5lnjbUyTw5uEf8hW75uG2+/VOhRal12/Nw/J6/mP0F9JYCbteLhIjwxmtjMWELY
         LOypOxjlmC1xjjFugB1NOqhSb3fSjNFUYU8BdG9Gv76LiIGHFELgMHtFfYIqQG21LkjJ
         IwhA==
X-Gm-Message-State: AOJu0Yx1GWS6s7F3/eu8B7saPq5hWVHYPUW2zIQHHKUL3v6RMHYeuwPn
	9N/agrJN+VKjA97KEb2PbqKsN8IUrLLegf4gmyuYgRdkMKD+M41F6xqS4M0XQlEfh7i2Dk+ATku
	5CGwtqA==
X-Google-Smtp-Source: AGHT+IHhbLvCYGsBh6ODhMnEDvAuta6cPkH1KNgVvHSQ9KHYqVszyeRaOArV3kO5lGiA3vXVq/dSXjWdUKY=
X-Received: from pjbga18.prod.google.com ([2002:a17:90b:392:b0:32e:c813:df48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b0d:b0:32d:d5f1:fe7f
 with SMTP id 98e67ed59e1d1-33b51118e6amr20842431a91.15.1760131849296; Fri, 10
 Oct 2025 14:30:49 -0700 (PDT)
Date: Fri, 10 Oct 2025 14:30:36 -0700
In-Reply-To: <20250924174255.2141847-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250924174255.2141847-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <176013138845.972857.17974431872471984207.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: selftests: Test prefault memory during concurrent
 memslot removal
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 24 Sep 2025 10:42:55 -0700, Sean Christopherson wrote:
> Expand the prefault memory selftest to add a regression test for a KVM bug
> where TDX's retry logic (to avoid tripping the zero-step mitigation) would
> result in deadlock due to the memslot deletion waiting on prefaulting to
> release SRCU, and prefaulting waiting on the memslot to fully disappear
> (KVM uses a two-step process to delete memslots, and KVM x86 retries page
> faults if a to-be-deleted, a.k.a. INVALID, memslot is encountered).
> 
> [...]

Applied to kvm-x86 fixes, with a massaged changelog to call out that it's
KVM's retry logic, not the TDX-specific zero-step logic that is being tested.

[1/1] KVM: selftests: Test prefault memory during concurrent memslot removal
      https://github.com/kvm-x86/linux/commit/1bcc3f879127

--
https://github.com/kvm-x86/linux/tree/next

