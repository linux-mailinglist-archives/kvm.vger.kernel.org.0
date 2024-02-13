Return-Path: <kvm+bounces-8579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCFC85269C
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 02:38:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 953C9B25A4B
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 01:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAE722615;
	Tue, 13 Feb 2024 00:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VWQuaStS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B1617FE
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 00:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707785837; cv=none; b=QMn4yMZLVLiJRSymm/KaFmHDdP65M5IAueivNUY5Nx/uRBgDMdnePw90Oy/6ZZ6Gxv9Fw/K+nTCw16Ec/6jEljx3/uAt3BeHo7SNjxOVpTPfPDOlq1JNEj5AHXqCDuYfZadhPekr0+B+5VhVcK6wmcL3KhO/v1TsatAauTJAl8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707785837; c=relaxed/simple;
	bh=xTXIDHG2wJphSzrFpnX801otcYVQ7IDuiyEbbp9hOk8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gVuQYN5ZV/gS+GUWzhwiQ27whzg3g1wnSIPmLW+7uS+uqbTfEeIZLKYvCpmK+mFxnW94WYJvQ085WjrFQ7sxkwpdS2NAA0jlYuCjKL+shiBWycJ0qs8+w0fWttNkWDiEJFCjrve+N3oNmAhRTLjbFxNgX7ZqIgG1psV37jauKDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VWQuaStS; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e0a461e125so1832158b3a.3
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 16:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707785835; x=1708390635; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JBIur676zT6P6eG98QMheQvfYDK752Rf+DKu7jIji2U=;
        b=VWQuaStSiUdUA7/CqEV4VucfLSFTRVqNm3lPt7gxYs7AkZZ1xrjoSja9yGdF3FPVdJ
         +KxcF/utFfhTIohf9gFBnthhTOYV0bBxTnbeGDxaaksUJnGcCUjYwxExOpOUUhhVGLIP
         IEq+Z0W77D9EeyxjWoY44LU4xm7O9JbltbWOnQi3hBNQOx5EStIX0ULf3V1IYsTWPLEp
         0h6uNBKcrH0u8QxJNX1ndYYzd3ZNWf9umErjRcnsinDqLvnRNTP+5w1JrW0AaOVxIYx2
         1u444yhCPGD+PqDVYzpLSGCSsMgwAJqqH/zXtZ4bWTAMWF9pl9u86iK4QBBebqw5b8Nb
         TYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707785835; x=1708390635;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBIur676zT6P6eG98QMheQvfYDK752Rf+DKu7jIji2U=;
        b=rN8XX6DnzuJK64CMMYBrVIJ3ZscTGoYw+W6joOTg6lrZF2eLf98RfOxUs5OmxE46jx
         08kdOhp34MVIVgEqj18/9NPKwkvgKHXWbKhMASBra/S29yYRElMkrEvzm/FwLueBZ/pz
         eHtvFRwq8UovcClUm6gS5Z1WLMVu7LgilXUZT5+w5/kBBZ3P+eqWVCS0gOclv1l2VzqC
         kCxtGsxUHNekN0qgg+ELMq5h0f8OAEBfNWQleddCu1QK31dAhgFtlWQTKLF4wmN9ffNN
         skyo7KIst0Z0x0SPpET5wYxpQn0v9u52TukLXBgU/c8w8NUim6aCwU3fjAO8TPfucLV3
         dJMw==
X-Gm-Message-State: AOJu0YxZeeotCVu/vpURIjvu+6jYmEEbZMhLrd+6a04vrSmiTdaRHmHG
	/+We96j2l/dAQ2or0PHkiw5Yp057Fg5+i8iO9sYD4yHF2LbuikPpRcUrApSrsmbO2/JJ6zJapXo
	whA==
X-Google-Smtp-Source: AGHT+IGkT++R3hxv+8HWbuPSSQjWt7Da93fgLYOCgw6aiV7tvgUL+Wq5ZRgmR8ln7k1UmOJhD4eSF98azzA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:939c:b0:6e0:f6ed:cf32 with SMTP id
 ka28-20020a056a00939c00b006e0f6edcf32mr53269pfb.5.1707785835275; Mon, 12 Feb
 2024 16:57:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 12 Feb 2024 16:57:10 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240213005710.672448-1-seanjc@google.com>
Subject: [GIT PULL (sort of)] KVM: x86: fixes and selftests fixes/cleanups
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

I have two pull requests for 6.8, but I goofed (or maybe raced with you
pushing to kvm/master), and based everything on 6.8-rc2 instead of 6.8-rc1 as
you did.  And so of course the pull requests would bring in waaaaay more than
just the intended KVM changes.

Can I bribe you to do a back merge of 6.8-rc2, so that my pull requests don't
make me look like a complete idiot?

It's not the end of the world for me to rebase, but I'd prefer not to throw
away the hashes and the time the commits have spent in -next.

FWIW, the two tags are:

 https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.8-rcN
 https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.8-rcN

