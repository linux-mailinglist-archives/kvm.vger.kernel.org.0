Return-Path: <kvm+bounces-26189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED5B29728AD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B131C286277
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 04:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CED15FA7B;
	Tue, 10 Sep 2024 04:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tv43ppdS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201A41514E4
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 04:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725944293; cv=none; b=DGgoWMMHnEUpHB/uGwD8yQAX/UHVOimYU0SVgcfkpomzBpHI/h5FBEfETomO9A8JXpWbep0oPtXcgkJ8LfZTEJlxKR/DghrH2ekdQ4kFjhJfNVxz3/jI4xHqUP/+4C/FLPVQcwB9AEkrtkoy6BDbkpfBZIHouoDDWzOAyxNyGDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725944293; c=relaxed/simple;
	bh=hRP9EOjlVmHgdQR2msW8evL+g5mWAVEDR+BggMQmsNo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ezb7S9Jv8vJYM0PhzZR/4HhAoq+fxeidbn/6Ludhq4sUISJ4JrNxgo2niZR+pVe2XFig5RQ2UcqTyzs6wjjEJ7FdKLYnH/2b01Lg2OB+r27PEPRxWOZcYbL/09KG4+MbnbHaoOIXOMqjpZoO9hck2qvptxkZaVaqgYql57t34ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tv43ppdS; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1aa529e30eso11562832276.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 21:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725944291; x=1726549091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F6vjzTgXltx1fPYsxVo4tYdvoWWLG0pjK0gDo/oyaeA=;
        b=tv43ppdSSqTeIJJSjaK5XE5i5CSm6RdE6sfz/3XuN6gVbdgGYEfEHZ+KWXCwt1/ePh
         u1jTO9kbMbNFbaDzb7+CfWH6KbOOn9AdZ3Qq+CClle0OJ3JRY1CC2HoXNAIGOwmdj0cW
         CEqzXo/O0oiSV2MkN9S5ETB1K0v7cq+7sBHyXGNT8mH6UFXPWBalgZdh4I3CgtJ0Mxp3
         U6kG2IzW/0HEd5QXvWld85PtinIa2duLwOlhcM0Sa8LE7wGaM2ku7AtBLaeNcSd+w3Rj
         yfKCGm9BBRPOfgEdMdnrqW/QCL8jq7AacUHn4lnhnKHAOgA47dFstURF0o2dr9XYLLT4
         V2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725944291; x=1726549091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F6vjzTgXltx1fPYsxVo4tYdvoWWLG0pjK0gDo/oyaeA=;
        b=oC+CMPChoeQDqe+PD4OK7LUk/drH0NB16qdDZDGFI8W1uy+Qhd58Xbd2uCRTHit35K
         4zQb1HXNN18BwXbw+mg3w8l2CR1D49Pv6gLaPGxR8VZgbC2gRRmFJWgzTkkUsiz7oQHq
         5AhRx5sdFdMAYcJoYbPnELuvl9/0VxqDOCclMUyttyOrfApPmvoi7uxEs7ZRVjNEBUDl
         TDb3DB+/NPunsFNhW5xU8uBGQEeprmtMFdTb6dTGcGNkx82KLy0GbDvQAmndgGmUiVhu
         uSAZsTdkyx6UU5etSn086hgcZkgRlKCxqDC2Ab/3emr3aUDaJl+rXwMYdlXBuYl5j0WG
         7mXw==
X-Gm-Message-State: AOJu0YzMiToMWU0PyGx/lB7cRp/OBrOilXQs850Utg+YLRzL475g8KwL
	gX/5r04wsseQYgmS+R99mYdSAEf9VD4lgSYzDRu5rqrRhIqtBckVyuynV8LvaVcJwenXk37K4va
	qZQ==
X-Google-Smtp-Source: AGHT+IF4rNg9cz0eICN3q6fWIPCxA+V7sJd3ueh3vdqJRU244zjCYSUaRe7DMjSxQ/T6Q/MHyh+PjY77HGI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d3cd:0:b0:e1d:20cf:aec5 with SMTP id
 3f1490d57ef6-e1d34a4dfa5mr73111276.9.1725944291064; Mon, 09 Sep 2024 21:58:11
 -0700 (PDT)
Date: Mon,  9 Sep 2024 21:56:30 -0700
In-Reply-To: <20240906161337.1118412-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906161337.1118412-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <172594250394.1552483.14960866497505256647.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Forcibly leave nested if RSM to L2 hits shutdown
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com, 
	Zheyu Ma <zheyuma97@gmail.com>, Kishen Maloor <kishen.maloor@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 06 Sep 2024 09:13:37 -0700, Sean Christopherson wrote:
> Leave nested mode before synthesizing shutdown (a.k.a. TRIPLE_FAULT) if
> RSM fails when resuming L2 (a.k.a. guest mode).  Architecturally, shutdown
> on RSM occurs _before_ the transition back to guest mode on both Intel and
> AMD.
> 
> On Intel, per the SDM pseudocode, SMRAM state is loaded before critical
> VMX state:
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Forcibly leave nested if RSM to L2 hits shutdown
      https://github.com/kvm-x86/linux/commit/3f6821aa147b

--
https://github.com/kvm-x86/linux/tree/next

