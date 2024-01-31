Return-Path: <kvm+bounces-7512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4684E84325B
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:59:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 794E81C24BFF
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 00:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8596D1FB3;
	Wed, 31 Jan 2024 00:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TUqpHVWg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C88A15C9
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706662771; cv=none; b=MzpRfQLfcI+Glehzct6HUu7mXLIF3dc4HIQwSJEky+YvkkUdiRUENoDZF8efGoNXPVhpn61n1jGsUwSUUvcQHYVNalGXOaGbZf3uCWeY7NIY1XJ/y3+io4lpi6llHM39xLBS54L95tY7gw5g/4XhhByy0K+g2XoPXvLXTAmAgAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706662771; c=relaxed/simple;
	bh=k3UJtZ2zdXlpKfmUISRN9bJoOsCVfPi9X4p4h+DW8jo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MhxL7kOYhP2e5yidITi487FRk2ULsM2BppPJ2CTvPeo347u2rhbE59PkbEUME94lhqTSK7qOZHO9G1SsnjcSjqBISwlk23DfL2Jf4FRjLZwsbEsvlNqmxEnZwfJl4Y4YREeozN8GOS1+XY/xXzl6k2ekJXVNYQa3cfD0G9Z+5/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TUqpHVWg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cec8bc5c66so2580260a12.1
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 16:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706662769; x=1707267569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DRYWEyJ8nP7GDr/8zEO30BzEfVkSVrMjTBb0exa158c=;
        b=TUqpHVWgZDMCfkQNVrWqEWS9UJmGmbbZQWNHl4en59He7sV8+0osELWQ5eKAPZYu5L
         b7W+Qh4E1s4KEIZWeNNTNRbua2MHX6JQzAXnF6YID9zJcJvfdwJgX8y8cXZSSisP7Ab4
         FSl122Gp2TE78/j2carXDkwd66VKUpOgw2h3te5q41ZnIv/B0xE13z6GqS835FH4PZxU
         NVmAbizP3zmnBavun9vPYx+DsUXZKdw73CemLqRtWznpAA542RemNvNxOesMsowkgirn
         ldKDTS69TTk4nIpXkqdQJRfmK2MyMRLcfy3rj6JKdUsv9hYoaXzJEdZNt02D80d0KXei
         bewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706662769; x=1707267569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRYWEyJ8nP7GDr/8zEO30BzEfVkSVrMjTBb0exa158c=;
        b=fAa+OWafZO054NAbBtJZ+PbMmSyGEYJKrvL/OzUvi+LdGsinieG2FeJRURHe54ED9K
         xIaFIMBe2Ltae1J5gPUYj0/v8W+qTK8DzXeEZrCXB+tX6yOdTru7JSpAPVJHUSqqrz56
         AsBXBDq5RedsUFdkL5kGus7OJUhLuJLlK9P1hxpgXCSxZIUTeOMrIemE76Dxv/vVM2+I
         Q0O45QD5pohhUgbZgQ6fR91Q5mlwnKz20zE/3hLmSjelmOtzxyXdaeVE9GfHYKCky5Mx
         +sct7NoqaJhK5ZJdoF7XnSGAoduqNfd8LutR50YLtxCshS97fychbbucc66Pv2DmLfJY
         NnNg==
X-Gm-Message-State: AOJu0YwEroAefk6T6bIaHFCF7CUHuiuIfxkqOp/tBf3JBErbl5tu2R2T
	FwCjNIHYbyqG4C29iqzi6fQPB/XLKqTo2oHw1k3863V+FsQ8usQPt17xMGnt+cAfxtMPDE7rjGr
	Pqg==
X-Google-Smtp-Source: AGHT+IFEI3SoLvPTNxPIT/3ZKANZjSVRIrD9gcH2Sle4VroShAJW+tvxcqtoldxoSebPtI3krvwO+r+o2e8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:48f:b0:5db:d9b6:2d52 with SMTP id
 bw15-20020a056a02048f00b005dbd9b62d52mr3335pgb.5.1706662769550; Tue, 30 Jan
 2024 16:59:29 -0800 (PST)
Date: Tue, 30 Jan 2024 16:59:15 -0800
In-Reply-To: <20240110004239.491290-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110004239.491290-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <170629112001.3098038.14027986117394347629.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Harden against unpaired kvm_mmu_notifier_invalidate_range_end()
 calls
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 09 Jan 2024 16:42:39 -0800, Sean Christopherson wrote:
> When handling the end of an mmu_notifier invalidation, WARN if
> mn_active_invalidate_count is already 0 do not decrement it further, i.e.
> avoid causing mn_active_invalidate_count to underflow/wrap.  In the worst
> case scenario, effectively corrupting mn_active_invalidate_count could
> cause kvm_swap_active_memslots() to hang indefinitely.
> 
> end() calls are *supposed* to be paired with start(), i.e. underflow can
> only happen if there is a bug elsewhere in the kernel, but due to lack of
> lockdep assertions in the mmu_notifier helpers, it's all too easy for a
> bug to go unnoticed for some time, e.g. see the recently introduced
> PAGEMAP_SCAN ioctl().
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/1] KVM: Harden against unpaired kvm_mmu_notifier_invalidate_range_end() calls
      https://github.com/kvm-x86/linux/commit/d489ec956583

--
https://github.com/kvm-x86/linux/tree/next

