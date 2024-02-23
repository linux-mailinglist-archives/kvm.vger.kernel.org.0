Return-Path: <kvm+bounces-9562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A6C861B09
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 19:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 371671C25E03
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E73E140391;
	Fri, 23 Feb 2024 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FVyjajRx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B932812BE83
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708711426; cv=none; b=uhelsk6vTVRqI2mQktKx1vvZAqAq7TiiI9RlItfFePR9WjlEKugDQgwMwv9jAfXhjqVi9ABxWeGHFWoY91FBXQgQCXxJVyVB87mUiOrFI8dhE/GHNJmjG+sJKCQmpDIcMe8zvF42TQN99M5Ep/ps+HZSVT4EKUGvNoEtaOryb28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708711426; c=relaxed/simple;
	bh=DdRMPpgG9Tb6SaT0/ZIVpJjpD80lyxQTMLWdPoxSyYI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CrylvXlbm+Nl8JUkfNsEkQYJcpKqLC2Yvz4bgzAJ/xX2B3iadJpkVRK3yCfwSWcuk1Cmah/6NTHvinPq2yCEcFygZVdOfGR/dih0CVUBEFfeHFymNYgi0fFoArBwYByxoddyizTa438qhLQ+MB6RQjuUcZ0shrx4jmSCMzvpoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FVyjajRx; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-607e613a1baso11743697b3.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708711424; x=1709316224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y5GBsdPl7urgMkjHsKUTWfcFYRbv5pqvr/pTSqxUepM=;
        b=FVyjajRxnwkquAmZ8B94NIdYQSDOyMgj9jWJEi7lCx7ZkvSkH+O2msI+5xpYQ3i96y
         2u+WY1k5ahJrM+Cxgj1ctdZUjJVlEm/VVO6ocOiJ3MZkO3YEc2eIZnGBm/LydY6LP2EO
         jN1IH9UqU4gTtIaCo/h1SVyb4WbgoU0vLmY3PvxjN3dJSkQ3J/t/ZHcNt0/cwk6KF8OM
         9OMNLMvt8Dhl9xYbNf9Bp5GmQG9McO5pBGncKGv9JIdS8HEDltUudWn/cPi7NZC1OqEN
         eixnrHCUIuAny5ilAG7P05BRN1ywcZu9JSaiLphqoO65mOtEyrEWfaPB+hnxu83TjGFQ
         Fwtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708711424; x=1709316224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y5GBsdPl7urgMkjHsKUTWfcFYRbv5pqvr/pTSqxUepM=;
        b=YqylZmhNbQklBHMV+O+wqYCxTSHb8Moo2U96RUpmqT/AFZ4Epw2o5L2F/yu18plpcr
         J5H9IltuZeMeppF79RCnZjyy7seu2xKyFXE3rZwF0sSewPlz/NOhIc3EPNKhvzrCgZOe
         dQpOweYJPoxk8yZl2ORAvahWM3xftp9FjZ0ShSh60aZGYAKsXTLO5ABN68UE97Fc6MZW
         tMHWfQtJxLHoyz1mZ4Gwc15CKIpdDkiKidC/e21lU+UReYMt3pm2VcdZfhr+gYAlJ2iv
         OeEULbIJVjDKHjp+e1e/XzlmOxhn1XeDsdz/Eg4ri7qwPMKy0zRIi2aaGPS6Qt3xOJ2d
         TwBg==
X-Forwarded-Encrypted: i=1; AJvYcCWc5tYAdg9ayijm6R1B8Lxa7AKy6aWhM/CrQ/2gSjIO3WfG5+Sp3leeY3zlv1dqTnHvoE/UlaRUH7uX+zCxw934uS0H
X-Gm-Message-State: AOJu0YyDhSA8imT9Gm4zypIJHJfALbJX81DgREAivsXIaigsjIDjKe97
	sEXb4gfkDtfC3Y+FGpCMKkbQ+dHAb4v3f+F08Cv4+lq0+LGwdl6emBWKkm+IvUA573x1FmlRfLe
	EBg==
X-Google-Smtp-Source: AGHT+IFWV3CfQ94wgLPhbMGbDfgw7i7VWpWYNFZJz5bzHf5O44Xtwf6QXZWVPyjjqZKenQtiCT2ymWP+BkY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d9d4:0:b0:608:a901:469a with SMTP id
 b203-20020a0dd9d4000000b00608a901469amr123120ywe.1.1708711423876; Fri, 23 Feb
 2024 10:03:43 -0800 (PST)
Date: Fri, 23 Feb 2024 10:03:42 -0800
In-Reply-To: <f6296a0c-df91-4de8-833e-dc13b9286a2e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240221072528.2702048-1-stevensd@google.com> <20240221072528.2702048-10-stevensd@google.com>
 <f6296a0c-df91-4de8-833e-dc13b9286a2e@redhat.com>
Message-ID: <Zdjd_loCXRAV3aVb@google.com>
Subject: Re: [PATCH v10 7/8] KVM: x86/mmu: Track if sptes refer to refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> On 2/21/24 08:25, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> > 
> > Use one of the unused bits in EPT sptes to track whether or not an spte
> > refers to a struct page that has a valid refcount, in preparation for
> > adding support for mapping such pages into guests. The new bit is used
> > to avoid triggering a page_count() == 0 warning and to avoid touching
> > A/D bits of unknown usage.
> > 
> > Non-EPT sptes don't have any free bits to use, so this tracking is not
> > possible when TDP is disabled or on 32-bit x86.
> 
> TDX will add support for non-zero non-present PTEs.  We could use this to
> use inverted bit 8 to mark present PTEs (bit 8 set for non-present, bit 8
> clear for present) for both shadow paging and AMD NPT.  This would free bit
> 11 for SPTE_MMU_PAGE_REFCOUNTED.

Ooh, that's much more clever than where I was headed, which was to abuse the PAT
bit (kernel configures 0400 to be WB), which would actually be quite elegant if
(a) the PAT bit didn't move around or (b) the kernel used a non-zero PCD or PWT
bit for WB :-/

