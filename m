Return-Path: <kvm+bounces-30623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34EFC9BC4ED
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:53:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BED9AB2126B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B0F18BC06;
	Tue,  5 Nov 2024 05:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WxQJwWW0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C739126BEE
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786025; cv=none; b=AzXfb7zosJ4h8MChrfUEtYgyQNGCa1qV+ocl6PMBvUi4YGyrXPta8vkB9T3RGCaHCKmFjVW5YwifhPvL9Oj2T6olNaTPZ8e31QUkzR3FJlayzXjiaDNQmdjdJRKqsozWEM23jltQkEl+lOTGgJgmSQJeIYVwQay7cl1C3Pj2XVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786025; c=relaxed/simple;
	bh=eFIgYsyVXpLfwNZ0WDZ01Ek7Ywd6Wo8hby6mzO9UQ28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bK//40h0L4w7lmrWHOPJJc7QGOPNh3VfDd6nPcobqbcvoxAJKHVfQiAd11jFqoV8Rv2c4cxRhYZEXwI6xGSKlU8hNwjGPQN1O3B7ir9pJ3xAEUmAYht3YXkrB0kHBRWze4u/7dOavxmZRgBzEZ/Nl79RXr7QWTnYHPNvD6PtIhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WxQJwWW0; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7edbbc3a9f2so3488609a12.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 21:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786024; x=1731390824; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CATQgkxqet+kiiFl27IyAPicUnMOKGQVJB4zHUMIsJU=;
        b=WxQJwWW0bBorU/RgtNaMe/adMlP+7npWNLuq4eubpBdbJE0XBldq+PudesMj1/17MM
         FFU9uKodsG4EPHCPn5NjZackp2T2ltuinh40BUYacp0sQuU2yzD2gYR4n59TDucxGnWV
         0xMB9XYH7mDY9Ee7f2jUIC/wz7jBNqzWnK5HmfCzaiLF+FPwWjV2OiG3hKPZR6z39JX+
         i2YehwmsULwsfbyN6ehX5pyLx6Gcm3aagbCl2L9PgWFgIs8Vo2F1nUcJeFwnycf8We63
         ImPEadZ5hG99y6KtG94zt941YT+/awVjM3uK7rEuVBb7gpMGSy09KxUAFqYJvuk96B/S
         vPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786024; x=1731390824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CATQgkxqet+kiiFl27IyAPicUnMOKGQVJB4zHUMIsJU=;
        b=dZL8vqUuFlkw0M3ia/l7iyFEmOaB4aCCw3HfvoCDZjImbYpg5Ey/M09OD85VLht8Ta
         UBsXp/2k27474aGMOSY7+rJazjJzbrDYSqj8HrFIKcxaZe+JG7Pb2MsTQ75cf9ihCH/K
         JCWYyeyyEo73DmGDJfaK16tO3ub3Ci889plPB51CmgaAwinjqP/EKZFD2cR2wnOquDXs
         K8xL4OrXFQaobtUK0z4IIVjaKZkRKrTyqXMtdMvOJPm/6dw+EZs654HfcK+YS+ifLy7x
         MAdREvSjO0+U1jP6N00fn74HGNGyKjBABGcZB7xavFyx9zMNGwdOeL9PN+VsZ+25LVuE
         BPwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQpqlhqVbiMAhPFvfRwmCoYesX9dddgdtzzaeb68hOJG+uUEV7D2QIqxy325T0vCXlJdk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNKzaq9yfgaC4SxJEFaHVuKWZfUOdJaOvJVI2rb8YfRKxGCe0w
	+HderCe67c8xydLCjEk9goaHQ4UxUqkyfH+DQcfnnpgIzYjxUo1g/uetW7ThI52T5CsiBxZfXEm
	s1A==
X-Google-Smtp-Source: AGHT+IE6j+o01T6Bqwps+9UMPoL+PueNwC77slv8kXJ3ii1dNkE6QY41DyYsvleelHQM84FbAugxCqQ87JE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a65:4389:0:b0:7ea:618:32b8 with SMTP id
 41be03b00d2f7-7edd7c9109bmr51755a12.10.1730786023765; Mon, 04 Nov 2024
 21:53:43 -0800 (PST)
Date: Mon, 4 Nov 2024 21:53:42 -0800
In-Reply-To: <173039504313.1508539.4634909288183844362.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241024095956.3668818-1-roypat@amazon.co.uk> <173039504313.1508539.4634909288183844362.b4-ty@google.com>
Message-ID: <Zymy5hjgMSMT64uI@google.com>
Subject: Re: [PATCH] kvm: selftest: fix noop test in guest_memfd_test.c
From: Sean Christopherson <seanjc@google.com>
To: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Patrick Roy <roypat@amazon.co.uk>
Cc: chao.p.peng@linux.intel.com, ackerleytng@google.com, graf@amazon.com, 
	jgowans@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Sean Christopherson wrote:
> On Thu, 24 Oct 2024 10:59:53 +0100, Patrick Roy wrote:
> > The loop in test_create_guest_memfd_invalid that is supposed to test
> > that nothing is accepted as a valid flag to KVM_CREATE_GUEST_MEMFD was
> > initializing `flag` as 0 instead of BIT(0). This caused the loop to
> > immediately exit instead of iterating over BIT(0), BIT(1), ... .
> 
> Applied to kvm-x86 fixes, thanks!
> 
> [1/1] kvm: selftest: fix noop test in guest_memfd_test.c
>       https://github.com/kvm-x86/linux/commit/fd5b88cc7fbf

FYI, I rebased "fixes" onto 6.12-rc5 to avoid several pointless conflicts in
other patches.  New hash:

[1/1] KVM: selftests: fix unintentional noop test in guest_memfd_test.c
      https://github.com/kvm-x86/linux/commit/945bdae20be5

