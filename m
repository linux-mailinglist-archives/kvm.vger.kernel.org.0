Return-Path: <kvm+bounces-28815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C817899D941
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 23:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F182CB20AFA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 21:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BB01D5ADD;
	Mon, 14 Oct 2024 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M/5WUshH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CF91D5AC3
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 21:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728941832; cv=none; b=MxNRtUqSXR1qbZuUZk0LBED83J3lZLwg2ZjvIow7qG1oortY1rkjvl4IcxQVgItIE+4h93DdiIY16UsWf1Db1H+SHLkOsvK6jCv2py4e9Yrozc/Wp9C3/FWBF4lQ37CBNpSr5eXLUxcCiZJMuhbXHvoeMMhHxT7Lrr09eeR4jE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728941832; c=relaxed/simple;
	bh=UZ7vFmuj7aA04u/XR8qWW7WKERkbXZDItctTNquH8aY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iav/7Fa1aH0Ln+2MgSRNvSRrafsvDsG12TR4xiHu4GYjxkjf6YuRdOZbU9WF+FvXgg2Vn52e+7soMjPvF1KJIxeGu90uUc9PoET6dJiX2K2HcOEb58KHab3EcB5DtH+ip9Yxt6YhSgoQ2/gS9PHBd07uCql+tvh7y34Ruq8WpkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M/5WUshH; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso3899697a12.0
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 14:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728941830; x=1729546630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Mf2eoBzQNoQVgZvqWYA1GulBOYq8ED7ogP6FPDfmi0=;
        b=M/5WUshHwVatfiWGGuvPj5aEcmoM7QUE8PPnO5Fsiac3tWCfDbhwl4/OVUbu5NX3Cd
         N2R93UyNbZGKclP8HAg6QKGQl6w13Xs/A+EyYvGq5ijy5W5qMAJOQ3RQfvkaVTUo5/9Z
         TBayvXkJhnMJ1SiiuKGheiZEGpLtTWcMNvUCDKBJcwI97B/567ECsZfE4IGpoUX0mTcR
         Stp+JCV4/0Oooh4qTFrDmA5cQ6Q2GPGJQ/egFFMlDIGipUnVmevaA7RnMuatzyuFEGwV
         +MKb8ioR6YsLHx1CCdgMhz6nT2RldgMPXf8mpo8dGMxNovTuOIG9gGa/eWjju4WZ/SmJ
         rYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728941830; x=1729546630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Mf2eoBzQNoQVgZvqWYA1GulBOYq8ED7ogP6FPDfmi0=;
        b=wOUuMo3AL3aKXhJzxx2RzF0mgNnoGjbIOrjpLJwcUwaAtOPzlPoj6a87+b9ddPerPW
         /uhvinYx3Ur4z+xbZHfAnZsoy8RZDNRzTTDSgR34sdqfwpSaiPY2vNOikb9ET4YhBD0U
         0R7BvGmkIGAUfZ7cDtX0133HpJ7T8HEtNQRgK63lLT5HjaqLyTRGHplb6EBdwMGksmB/
         cj9x3GrtOYEC96R0iTOWLDVC8owh3SUsXwjmVW06aXNha7TZjHep6WcrkcFojNw1VLrT
         /itsl/RGemqw++8yqWEcI+b1hf9bzfYOsBcM2bO96VJz4NO6Jfx+ILadDoF95XSKKUkK
         n7lw==
X-Forwarded-Encrypted: i=1; AJvYcCXaVs8llOoLpjNxLF+UpzWoa4hCKUB7Xq2+MwPCTQBzTpCUBGmvWg65FsB7Ud0qEsppivs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWI/IA7426Uy14r6zHXkn2QeY+1GFERv15MGmmZbtWx6JtbHLp
	BjMnGpzdIs5oJJMUbZXGiBMvqH7va9aUrGQ6MTQWQqcE+eE20+K2se/qzMgxBEdIiLpnhUAqsja
	sMA==
X-Google-Smtp-Source: AGHT+IFTc+rIqSRjWJcaRw8kndrZyrrco4sjKuLnct+lf6dsqkIx8K6CIKBvF3FvIoSW3fNH38TrodlWkBQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:2306:0:b0:7e6:c505:689e with SMTP id
 41be03b00d2f7-7ea3f903460mr21417a12.4.1728941830059; Mon, 14 Oct 2024
 14:37:10 -0700 (PDT)
Date: Mon, 14 Oct 2024 14:37:08 -0700
In-Reply-To: <20241014105912.3207374-17-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241014105514.3206191-1-ryan.roberts@arm.com>
 <20241014105912.3207374-1-ryan.roberts@arm.com> <20241014105912.3207374-17-ryan.roberts@arm.com>
Message-ID: <Zw2PBJsC99L4y_7c@google.com>
Subject: Re: [RFC PATCH v1 17/57] kvm: Remove PAGE_SIZE compile-time constant assumption
From: Sean Christopherson <seanjc@google.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Hildenbrand <david@redhat.com>, 
	Greg Marsden <greg.marsden@oracle.com>, Ivan Ivanov <ivan.ivanov@suse.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Marc Zyngier <maz@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Matthias Brugger <mbrugger@suse.com>, 
	Miroslav Benes <mbenes@suse.cz>, Will Deacon <will@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

Nit, "KVM:" for the scope.

On Mon, Oct 14, 2024, Ryan Roberts wrote:
> To prepare for supporting boot-time page size selection, refactor code
> to remove assumptions about PAGE_SIZE being compile-time constant. Code
> intended to be equivalent when compile-time page size is active.
> 
> Modify BUILD_BUG_ON() to compare with page size limit.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
> 
> ***NOTE***
> Any confused maintainers may want to read the cover note here for context:
> https://lore.kernel.org/all/20241014105514.3206191-1-ryan.roberts@arm.com/

The patch should still stand on its own.  Most people can probably suss out what
PAGE_SIZE_MIN is, but at the same time, it's quite easy to provide a more verbose
changelog that's tailored to the actual patch.  E.g.

  To prepare for supporting boot-time page size selection, refactor KVM's
  check on the size of the kvm_run structure to assert that the size is less
  than the smallest possible page size, i.e. that kvm_run won't overflow its
  page regardless of what page size is chosen at boot time.

With something like the above,

Reviewed-by: Sean Christopherson <seanjc@google.com>

