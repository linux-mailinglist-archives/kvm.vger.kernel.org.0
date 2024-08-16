Return-Path: <kvm+bounces-24455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EE4D955380
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 399B01F21F02
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 22:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F032D1482F5;
	Fri, 16 Aug 2024 22:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M+KNaI25"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A622313AD32
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 22:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723848471; cv=none; b=kNRmXvi/qzkxPmtqohXhsEQFsMNgmmmUx2GTQ6Fe58Aeq1jC+pDUqFYS81gchhZ7gZ5amQtMZmt5cxLa6bXx+c8nma8PkB1nHBA7k5up7tXAJm6MFkwK/QwqZrzTuP/PJjNoybWWqoEdbfb2U2YO7nA8S+hHvEz5fPakwTzLydk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723848471; c=relaxed/simple;
	bh=NCtt4uG7luCn1UHr133h5Og1wWNAgMrd6d/e+y3W9h0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cSWGXuxdvCZcvQKa40X3tB7YGJbGTNKB+985Sf/AJ/M1O/h4nyjJtv6uU12Vafzua6wy09FqGqK/BHP8869ntg3PJrlS2wa+3r7WnqbQjgb/L85d+Lxrms1I+B/Njl9zTC8Aw9AIxOZW9d/ewK0CWE0Bgb8bWOErQ+YtESPOaYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M+KNaI25; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6506bfeaf64so37021797b3.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 15:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723848468; x=1724453268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qx2xpqcSpC4cFoxJ3aEKOULQV/1IY5MYlZGNVDIdPWA=;
        b=M+KNaI25y14dyFU+nUmudV/ScDpNau0XTHXDTKMh1oG1rGMVtttKEwz3pwXoRCEas9
         zLt9r5lAe0GDBMV0gTXhUAloDGmk94hqSLpf4CJl6zCam1rwe4rbnpJ/VgOmfCMWr6Ba
         iGxfLuVGPlZ8QtrYvSxS5PAAEM1Hlpolw0RJbcQMtYp8dF6F1FvQ0jFE0Gj8G3dXxVnb
         wQqkx/Km6uz7fWaDfxIJhyaqz5/PUZltLCPWgCVnQuU4U2EB3bKV9V7B0pfh+NgQ261O
         nt1MxG1+TnDq9awd0L92sIV/Gt+O2v7nLG5cokYLrlF1/Xv1oXEDv+1fopBTNAjge75h
         8GLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723848468; x=1724453268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qx2xpqcSpC4cFoxJ3aEKOULQV/1IY5MYlZGNVDIdPWA=;
        b=akgqBmJjH5kb82exLCpn1Fwy0C+bOR+nr3MotIygUjg3spw2ccLZct+baaW1MbCQD4
         93m3ASkjr/+pCtnA3ITu2vhwurMiYo2pWygQ1xtvhnWz862eOv/NEo1SRhqI4+ghYf/B
         tdDk1+6m/y8oTSAn3837FEU5K83+3gkmh2MqZVXErWFfOXIYu+06Yh83z4/ZQGWgjsr+
         r55j32tcg8j1eCcvPVjcrrvMZqsSvNX6GFbRlQ47cZD3hr1GS9l+GNNrcMP1hDxS1+s7
         PZCqGfGx9GzqKncTyrqDLsEf3wXnRxUbedm7jDvPjU85WHV6vIZVv0VuS45bnMKM+IW0
         U3Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVLsQJ9Pp+Xy1KJm6Oer0k5jQ1dHcSHx4tUwvWiRJDTOl85yO/qCFE53ykMeOKiVafrldHK8YWj8FKey87kfh/W+hGZ
X-Gm-Message-State: AOJu0YzX5ZLQgzNnye4dtccc0BNaYueXTCmweNkSLbNtF2d0sq2gcQVt
	6S/vpk8avKoPnh0x4bj2VO3PGxCAPSfFfTCqIgv2Uf4/4sAoU0uOZV4iivh907kW4cmaUykDW76
	ibw==
X-Google-Smtp-Source: AGHT+IEvwcxqpYtiL376cvIj3JHrLSqTvEq8J04/jlIE1T9J+0gyo2k3z2/2o9DseE+PZHCWw22pnTT8aVU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1005:b0:e0b:f69b:da30 with SMTP id
 3f1490d57ef6-e1180f70d60mr302559276.9.1723848468610; Fri, 16 Aug 2024
 15:47:48 -0700 (PDT)
Date: Fri, 16 Aug 2024 15:47:47 -0700
In-Reply-To: <20240805233114.4060019-2-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com> <20240805233114.4060019-2-dmatlack@google.com>
Message-ID: <Zr_XE6NG1c-rNXEl@google.com>
Subject: Re: [PATCH 1/7] Revert "KVM: x86/mmu: Don't bottom out on leafs when
 zapping collapsible SPTEs"
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 05, 2024, David Matlack wrote:
> This reverts commit 85f44f8cc07b5f61bef30fe5343d629fd4263230.
> 
> Bring back the logic that walks down to leafs when zapping collapsible
> SPTEs. Stepping down to leafs is technically unnecessary when zapping,
> but the leaf SPTE will be used in a subsequent commit to construct a
> huge SPTE and recover the huge mapping in place.

Please no, getting rid of the step-up code made me so happy. :-D

It's also suboptimal, e.g. in the worst case scenario (which is comically
unlikely, but theoretically possible), if the first present leaf SPTE in a 1GiB
region is the last SPTE in the last 2MiB range, and all non-leaf SPTEs are
somehow present (this is the super unlikely part), then KVM will read 512*512
SPTEs before encountering a shadow-present leaf SPTE.

The proposed approach will also ignore nx_huge_page_disallowed, and just always
create a huge NX page.  On the plus side, "free" NX hugepage recovery!  The
downside is that it means KVM is pretty much guaranteed to force the guest to
re-fault all of its code pages, and zap a non-trivial number of huge pages that
were just created.  IIRC, we deliberately did that for the zapping case, e.g. to
use the opportunity to recover NX huge pages, but zap+create+zap+create is a bit
different than zap+create (if the guest is still using the region for code).

So rather than looking for a present leaf SPTE, what about "stopping" as soon as
KVM find a SP that can be replaced with a huge SPTE, pre-checking
nx_huge_page_disallowed, and invoking kvm_mmu_do_page_fault() to install a new
SPTE?  Or maybe even use kvm_tdp_map_page()?  Though it might be more work to
massage kvm_tdp_map_page() into a usable form.

By virtue of there being a present non-leaf SPTE, KVM knows the guest accessed
the region at some point.  And now that MTRR virtualization is gone, the only time
KVM zaps _only_ leafs is for mmu_notifiers and and the APIC access page, i.e. the
odds of stepping down NOT finding a present SPTE somewhere in the region is very
small.  Lastly, kvm_mmu_max_mapping_level() has verified there is a valid mapping
in the pr imary MMU, else the max level would be PG_LEVEL_4K.  So the odds of
getting a false positive and effectively pre-faulting memory the guest isn't using
are quite small.

