Return-Path: <kvm+bounces-24964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E0995D9DB
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 629F41F24BED
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE25A1C8FBD;
	Fri, 23 Aug 2024 23:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o2icpG3c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D02181B83
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724456890; cv=none; b=gKdJD2RILVHLnwKzIKWsMVBiu5JBxWctgPGy6kPJ17eQ/7fIMLX/DzI1zn9XdpU1dlJQ7PaMfSSDWQ51ntB/ipeqd6ddi5Wd3RxuRsZTCckVlRlYoyKdXsGNbf1zKrqrUGHNzeEJZR6OAQ6RX6rejqF36K1Uc4+lQK9Qg8Xeff0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724456890; c=relaxed/simple;
	bh=oSmbq6z0ziCtZ0dMsKHaagoYWZvjL9dtyiYNCMAxXr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UY9sugXkHxvvV9ZOhl2++7T0vvM8ADzqPQ+noaWVR+wM8r1qJZetK16Luboge6VV0zL73C79xBwyLRu7UxYAbup7C7vSSb4FbddsHRHqlv1Fk4m9mj3IkUGmW6Kr/I6/VhwCIpGl9e2OUk+1kiNtIls1bAtMXU+JYIcyV4Iyh8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o2icpG3c; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6addeef41a2so46824067b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724456888; x=1725061688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AxyFLhgxoPd6sz/HoxzIvpmesfoHe7yvpZJxs0846w4=;
        b=o2icpG3cTirst5hMKM3UN40UNeZvHh6elvREx5Afb5D/A79FLZsYYERcbquGBELHej
         hxdjoQpIULDhM9rwybPINcFfG1a0rL6gIxwMI3Hd/WHT8Q22NzuSVS0GXOMiJWXloLms
         +VM45EmsYaj8+nXUkcezZCq5loc66XlqBLMyETFeJNiePCrmQKWjzpst4qBf/oL19uE5
         AEQ5rGQhE4kOKkw2AwO/lFS3/6K4TaGepyyQKDccRc7c7sa7BJPyq2uXiEr4nJMZQTsf
         rx2MeUt4mI6Kj7wAscUWc/xQkAiHuWxs6KGbLOzVQlbbBxWd6JyzzfimucKD9l3hhUn+
         SLLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724456888; x=1725061688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AxyFLhgxoPd6sz/HoxzIvpmesfoHe7yvpZJxs0846w4=;
        b=NmL1S+sqC4JlLz1bTwg8WOUq948BmMCJDmF1Zp7xQkPIM0VNVzivc/p0OJ3TbVyvce
         MMa80QJNWPE8Jd+fWclAl2CUWt5mrSGCHHDeH7tY4UDLOmwldM3ge4KtPIVZCyD8YUNx
         JTohdO3wYMgwcEBDG/X9oyDQvxsXWuSxLJappfZxCpoMTEtRjO07dMcdaLFRujeVUVIf
         PUqMHYDzmreLQbTS19swuTAeAq1Al5ITvfhqoSaPQTRvJFvxAdns13PZEInqGFhq+t7K
         sF1UmAutvB85vLGpqTqcB92K/SytSFUtwYLQxSRYH28wgpBI/C3Nz/wKoD2Ra4a8Ammf
         /Hpg==
X-Forwarded-Encrypted: i=1; AJvYcCXPwy/ENWfAGROgM7/pP0rikS1DT9CMCznkqUIjXjIVcI6v7vR1k5Pe9r/8jDIvCMer9Nw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvGTNfiGxiXkpTk7XTSG6ah9sYJEfjADa/kYTXhIhInrE4aWtu
	fYMBegplujQfzO+JXFXohKhgZ6BXDJ8B76XAOfLqsuZ2AUc0MUQqRpUpaRbmEpfsScfCvRLuJb+
	LEw==
X-Google-Smtp-Source: AGHT+IGriFwrY53DJsXOKPNHIdEQ0VvSJ/xLt17bqfF4xHKMdbDUQ8XkKefBNCjUHxS6knQ7UhpQ232Mvb0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:180a:b0:e11:62b4:36bf with SMTP id
 3f1490d57ef6-e17a83c8714mr61480276.4.1724456887951; Fri, 23 Aug 2024 16:48:07
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:37 -0700
In-Reply-To: <20240712233438.518591-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712233438.518591-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172442171206.3955037.12407652634764433628.b4-ty@google.com>
Subject: Re: [PATCH] fixup! KVM: x86/tdp_mmu: Rename REMOVED_SPTE to FROZEN_SPTE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: yan.y.zhao@intel.com
Content-Type: text/plain; charset="utf-8"

On Fri, 12 Jul 2024 16:34:38 -0700, Rick Edgecombe wrote:
> Fixing the missed Removed/REMOVED.
> 
> 

Applied to kvm-x86 fixes, with an appropriate shortlog, changelog, and metadata.

Thank!

[1/1] KVM: x86/mmu: Fixup comments missed by the REMOVED_SPTE=>FROZEN_SPTE rename
      https://github.com/kvm-x86/linux/commit/e03a7caa5335

--
https://github.com/kvm-x86/linux/tree/next

