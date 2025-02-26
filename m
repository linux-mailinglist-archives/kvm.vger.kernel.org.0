Return-Path: <kvm+bounces-39393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ABB2A46C1F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57B7616E134
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3A423ED7A;
	Wed, 26 Feb 2025 20:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kqAzMkkl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DA12755F2
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 20:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740600826; cv=none; b=fV9Up0l4mGj1m7x/ygErtQIzznaNW6AHLzdDHrxDW7kZXGos63IhmwqfNJLrG2C+GZFvjE+lZJOuBYL9MPhSJnzJHd/ni7aTHnV99iAGKhBZwgsMuINCsd1Y3HjPpEr/I8YK7L+59xW7hd3b7KdMoKZYGifZYUZ3+X9USmUUT6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740600826; c=relaxed/simple;
	bh=orgv02xasNMcG3m7QuMiIZlWbVZJKDsjvHGKqPb80dE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BsTc9L90vH7DhGR46yunNfhrncGTRPtDsq9SJtJrA5RawrfhStJsyoS5kVqkD21iWY8BEb+YceYL2reZg+fJT+Q5A2zSrl+/Smx4CQd3VlIZmbtV9FbPTEkW+4w/CjEOogxbMjbO4bDZRp5h4kVt4Q7uw0dxewlgUFsjqyPMasw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kqAzMkkl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc4dc34291so456920a91.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 12:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740600824; x=1741205624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KxehUgTHz1zTiTKWIUwPafHBvSaHS8puDzXDyL6MEmY=;
        b=kqAzMkklI7WrqoGtUkRooHdbhl0+fD8syXy79cYryL/Hee/98M//V1/fLCL2Upr37H
         mLHw+4sUaOXX4bXre8uPKlcEx0jzlOR3s+b5xLd3Tv4fC9xd4oEuiSoZrjthNx96tnIC
         +UYHXHS63Cp47DhVOX2W4kyU5Ie2uO/Sgvu2MmaziAGgrLPLZ0yKJu6llTM1LSTcYVfR
         cN1J1OMvk5SAhepFB5BOl7AlB01DJMMRPr9IaDvtIDoOWaTynvLlzBBMDGU5UoUXM0U3
         yvAYtImCrCHxIzPO7UuoJi3CcKpsdyFwdHMj70bYfk39VVszEiZeVH5OsAQ7Z4Rg4EUF
         051w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740600824; x=1741205624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KxehUgTHz1zTiTKWIUwPafHBvSaHS8puDzXDyL6MEmY=;
        b=jYp/GgVXkcn1oD1LWmuoVgncPxNowI2c5+sh0u8oOrbWkYtQ+zlyEL3NKN2hJzfmrN
         w98JhJ6akGuYpztlhwgN384ZeaFQskgdXh6xlCUWvFAnlF/Pt9e93sgvPlmByaSLIw59
         4h+KfeGHlYNwyHIvE7Bg+4Sq47aDbjVhV3pxlSid/XT2RNjIFVkV0hJ+9Q3LNaGgdAoq
         ygME7DYPkhOcfFOIWmhPg2sfKn1zK1ihybGcykBCBJrRlqoy++v9CxQ0l5QvbFr0IzOP
         E/mU3yARJFSf/xLDcu3YvZDjv5rHDvLrSm2AE4OSYL3O6TU9dK4S+RkLYp+qZrgMFR1I
         DBOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGjzL23mlTyYei8N3mmKCPclbtsf9tfy6XQsR1nEuT++raWUB1i8Ng5d4GV2JJMEmipYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiPjIz+TmX0d+dQyz04uPVcbYWPLxkDKoJeu5j2EU448fCvGgo
	k2ZzRLz6OhDwnjo4ayNsuwfPpCiyuGmPA3DRgtImt6Yo8vBno7oGhimB3v8WPG3D8V6I88IUpDt
	igQ==
X-Google-Smtp-Source: AGHT+IHicoYqkjL9RRgNen8MoIjG/DrdsSrEzzLYBuvIBt9STHGlwGCLvcuwxojtGCil5LIWk47Jve4NE/4=
X-Received: from pjc5.prod.google.com ([2002:a17:90b:2f45:b0:2ee:4b69:50e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fcf:b0:2f8:34df:5652
 with SMTP id 98e67ed59e1d1-2fce78beb41mr32112608a91.21.1740600824271; Wed, 26
 Feb 2025 12:13:44 -0800 (PST)
Date: Wed, 26 Feb 2025 12:13:42 -0800
In-Reply-To: <20250226024304.1807955-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250226024304.1807955-1-kbusch@meta.com>
Message-ID: <Z7919lMgDtbcl1CX@google.com>
Subject: Re: [RFC 2/2] kvm: retry nx_huge_page_recovery_thread creation
From: Sean Christopherson <seanjc@google.com>
To: Keith Busch <kbusch@meta.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, x86@kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> A VMM may send a signal to its threads while they've entered KVM_RUN. If
> that thread happens to be trying to make the huge page recovery vhost
> task, then it fails with -ERESTARTNOINTR. We need to retry if that
> happens, so we can't use call_once anymore. Replace it with a simple
> mutex and return the appropriate error instead of defaulting to ENOMEM.
> 
> One downside is that everyone will retry if it fails, which can cause
> some additional pressure on low memory situations. Another downside is
> we're taking a mutex on every KVM run, even if we were previously
> successful in starting the vhost task, but that's really not such a
> common operation that needs to be optimized to avoid this lock.

Yes, it is.  NAK to taking a VM-wide mutex on KVM_RUN.

I much prefer my (misguided in the original context[*]) approach of marking the
call_once() COMPLETED if and only if it succeeds.

diff --git a/include/linux/call_once.h b/include/linux/call_once.h
index 6261aa0b3fb0..9d47ed50139b 100644
--- a/include/linux/call_once.h
+++ b/include/linux/call_once.h
@@ -26,20 +26,28 @@ do {									\
 	__once_init((once), #once, &__key);				\
 } while (0)
 
-static inline void call_once(struct once *once, void (*cb)(struct once *))
+static inline int call_once(struct once *once, int (*cb)(struct once *))
 {
+        int r;
+
         /* Pairs with atomic_set_release() below.  */
         if (atomic_read_acquire(&once->state) == ONCE_COMPLETED)
-                return;
+                return 0;
 
         guard(mutex)(&once->lock);
         WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
         if (atomic_read(&once->state) != ONCE_NOT_STARTED)
-                return;
+                return -EINVAL;
 
         atomic_set(&once->state, ONCE_RUNNING);
-        cb(once);
+        r = cb(once);
+        if (r) {
+                atomic_set(&once->state, ONCE_NOT_STARTED);
+                return r;
+        }
+
         atomic_set_release(&once->state, ONCE_COMPLETED);
+        return 0;
 }
 
 #endif /* _LINUX_CALL_ONCE_H */

[*] https://lore.kernel.org/all/Z5e4w7IlEEk2cpH-@google.com

