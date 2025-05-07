Return-Path: <kvm+bounces-45711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16BE2AAE0B5
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B06A89820F3
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 13:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C995F288C2C;
	Wed,  7 May 2025 13:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H7lx5aFo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8821D26D4FC
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746624447; cv=none; b=V8UoZJrN3UzQ0yWqymDpwZfXTf6+5oDEeOL69GMBTXgUqXceZ5V8yDj8/7VlGY6JUFpjBYxS0IxIdc2PRLV3hsU/tnTw7eoST/C5bYaDlG4wnWDyLSEkXHHTXGDEASKpYG1utX9JS7ccxH6RgY5+4dTh16HuGhKmqJC0ynUI4o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746624447; c=relaxed/simple;
	bh=PxAjyfOf8hPgQt9F9TV/HNrwcFAoJEq0cKrdWA8Er38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nQXz7aZXpRYvRgsk9kYuKrjSGdtZiqx2RLXc10f/6E3KGvjAmOK5wFl5YTl0tBSIR0aAPFSd4c9nM9AUiXu8Rc+3AvlbndqpXlG2QziPAjJ/wK+2J0asCqIAsR6JnmPn/QPUeNjsDG+9K3aTa2+uCvQHZjTK092yaV8s0owHgXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H7lx5aFo; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b2a25d9fso4575085b3a.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 06:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746624445; x=1747229245; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gn4ouDHYMf1rQDJgdtIk3JcH002Nvu2EKgt6CdyYxYc=;
        b=H7lx5aFoV5/7b52OU1AnPsrTuBUty9+HKYAkh+k3WJ0+9SPlbW5PkDJHxApSBO0Par
         hIU9JxKy1Z0R98T8KXqxtbkmsk/2QVu5VbhA7SgOuAxQUpYIuBEMyk86eBYneCjADyLA
         I7j2VS2o6bvqNSU51ToOFYFe9eKBTUXSnlcV5TAbA8rBgvzBmdaUIidXMl4rCYpYfku9
         mWgkgRPqOuf8/DXJ6dCAG8cNVguUugscT3wnlw7m+0+4QWzK5VNKgs9u1f5ZuF0TKsVz
         /tUcbhnY3IvRwuAWUZmklBS5N8nq2JlpON4o2K5X8eIw0gnY3QFHUH/GPliF9t7CZmNF
         ZmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746624445; x=1747229245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gn4ouDHYMf1rQDJgdtIk3JcH002Nvu2EKgt6CdyYxYc=;
        b=Er0uztkAnN1etFmYAAHlhmc/IpwS3EwZxReoyrCkCMKnEJi1XSaJgghH/5RZMQeheL
         upQrRi3I9H1V3P/NS1ZmYyUKi5POf82wQlnRbQkpG7K5bgW0u06aKNBYiWrI07SSQ6M4
         kYve2NpgraBToBR3gTbQ1mD8S1Bil6E8tjySAbm0r83GHJsfRryOHyOKGKYCIDYL+JFK
         ciueOr5C6XJI7yKF5qZOQjlse4zMW117qbeDxU+wQj38TJI852QtbU7kJqp5m1iu1ByG
         uMgPNEqXUeIUKHxtx/Bugl4Q7nWioyreLhbsIibQUT4sE7lIwdE5zukO879xccNRBeFb
         k1nA==
X-Forwarded-Encrypted: i=1; AJvYcCW0UmuihykVtYFWy7QvfWeP6l4navK2D598eGu4XsxxTVk58xAWSBPDBtiUQWyrSj9A7PY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8Tz507QEJ6sFPqQ4RHjMi3FPs4UU0C47zHgSU2d3+oDx9IQJy
	uSn8FylwO+FqOSiZ/1gm/Qqc8H//8EDSDEX3Rb2ouLMmE1CiXWX8dlJgsVHwqIebPuMxDj4xdL5
	4Kg==
X-Google-Smtp-Source: AGHT+IEPjV7nnxIQdSAnye71UsJYJwQylTYuYdPxkCgubdgOAyiIVlZOePc56cd6g1wSD8shZczYh2GfBm8=
X-Received: from pfbit5.prod.google.com ([2002:a05:6a00:4585:b0:736:5012:3564])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:920a:b0:1f5:87a0:60ed
 with SMTP id adf61e73a8af0-2148be10ddbmr4868825637.19.1746624444753; Wed, 07
 May 2025 06:27:24 -0700 (PDT)
Date: Wed, 7 May 2025 06:27:23 -0700
In-Reply-To: <aBOznhkrLZ0Z_3Xw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430224720.1882145-1-dmatlack@google.com> <aBOznhkrLZ0Z_3Xw@google.com>
Message-ID: <aBtfuy82Ze7G4vdm@google.com>
Subject: Re: [PATCH] KVM: selftests: Use $(SRCARCH) instead of $(ARCH)
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Muhammad Usama Anjum <usama.anjum@collabora.com>, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, May 01, 2025, David Matlack wrote:
> On 2025-04-30 03:47 PM, David Matlack wrote:
> > Use $(SRCARCH) in Makefile.kvm instead of $(ARCH). The former may have
> > been set on the command line and thus make will ignore the variable
> > assignment to convert x86_64 to x86.
> > 
> > Introduce $(SRCARCH) rather than just reverting commit 9af04539d474
> > ("KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR")
> > to keep KVM selftests consistent with the top-level kernel Makefile,
> > which uses $(SRCARCH) for the exact same purpose.
> > 
> > While here, drop the comment about the top-level selftests allowing
> > ARCH=x86_64. The kernel itself allows/expects ARCH=x86_64 so it's
> > reasonable to expect the KVM selftests to handle it as well.
> > 
> > Fixes: 9af04539d474 ("KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR")
> > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> If this approach seems reasonable I can also send another patch to share
> the definitions of $(ARCH) and $(SRCARCH) with the top-level Makefile so
> that we don't need any custom Makefile code in KVM selftests for this.
> 
> e.g.
> 
> From: David Matlack <dmatlack@google.com>
> Date: Thu, 1 May 2025 10:30:26 -0700
> Subject: [PATCH v2] kbuild: Share $(ARCH) and $(SRCARCH) with tools/
> 
> Pull out the definitions for $(ARCH), $(SRCARCH), and $(SUBARCH) into a
> scripts/arch.include and use it to reduce duplication in Makefiles under
> tools/.

Yes, please.  However, SRCARCH might be going away in the kernel's Makefile[*].
I recommend holding off on anything until that discussion is fully resolved.

[*] https://lore.kernel.org/all/cd541739-4ec5-4772-9cef-e3527fc69e26@app.fastmail.com

