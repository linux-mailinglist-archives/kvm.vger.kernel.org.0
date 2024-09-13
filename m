Return-Path: <kvm+bounces-26871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76716978ABF
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 23:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A929F1C2309A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 21:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F4C15B11E;
	Fri, 13 Sep 2024 21:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gtJ6EV/a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571AC7F460
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 21:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726263813; cv=none; b=nRCKi/yzXjzTwVOTPUZgRCud0WSty3ZIZTVzNofrFxsgJVJz/lQyzfptkBwVAJXqw/YT6sSpdeN9mKMsna2utKtKdiKO/i6RcmlzAhwZ4CRASFz67ox4gsKXp2lUTguK+iK6qUqvYDw/RdoWrEb70SPcm3pI+at3eo5Y3Q+sAi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726263813; c=relaxed/simple;
	bh=bk82V1U5kTAx1SY/5tuRyITbnhOFpVWWLqc2nc/Pu3Q=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XMYFs2m4ARNyGCGmx81cdBRQwNp9qNWz5KCmBnuOEPayfV9raJW2CMlJ4b1MxWshcVickzBPT6kYf2WG4ujfZm01FPNv6RtKZZwcxTMYJxbQ7RsDbjgDckH3+e2LEwo/wkTV0t+Dxo93vMNWFZFnEboRRdi7Q5KmZgTwl3enalY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gtJ6EV/a; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6db7a8c6831so67536337b3.3
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 14:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726263811; x=1726868611; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/0mDpSwOiDoKlD9ZIJPXguglqEeR5Ja+A+8PpPcziKs=;
        b=gtJ6EV/aeA+1rLKOgmcz7Jc9vuTRfpMm1NY17e4gqAvBUqdpk8hlWaeTZcYc6/msuk
         Qoa7Q2IHSC9ZB1HQuugIq3oo+OaLN0wJsGFVO3ZXx5Q98AxbEgYovdIQ5Eu0Wrqf+fXG
         2TtQ4cjjzIIAXTqdxTAhT+rqlHk/GLQ2Y3ZXxpBV/IOTmwtaXVzpdLs/qKnwFr+P6SzI
         2eVb3Fz3ycrzFu8GsQV7xOlsPMT3WHWwA67OLyn0SAmKCtVcVZneC/YVqONBVvwhUag+
         IkMRj/h7JCq5JH+DPXzOAOY9z2dRYgqCBdpqz0MBmC7YI8MagbrRqQZ0Rihn/HMRndza
         kqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726263811; x=1726868611;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/0mDpSwOiDoKlD9ZIJPXguglqEeR5Ja+A+8PpPcziKs=;
        b=bUhXj3eLX/bk8HG+J3lix5oFhup62CaW4RmdzwL4iByHT6olrR154qxx3guNLuXlHx
         tGQ3lRHNQjKWkFM8lGEvM8e8qd0ievichATviEW2iSWwVNW4NLNOVH3RyhU4la3yLhyQ
         /TD8ZOIwRsMBCeHByrZkMCowOEaJvgphZGXNlEtgXiTwZ9+f9vlYs65QEhR5MnYJUd9+
         z0FjCbif/H95N6EI9vIDAzL26F7fVdiOg3yqzdwJWarEX+JWsR5k2NlMDaLjwvVK8ROe
         2ClaQMg67IS2MhTppAwrkFIcqh9lpuWvypDsXGe/RTqH4pKxpXMuLK5Z7BqwmdEjd90l
         0JZA==
X-Forwarded-Encrypted: i=1; AJvYcCUJJXpIZAqLnj/PYYaPGfGbVTtC8Q2BcAkGoVIPgQWDbk6iHC+3YvO7MvCVUyusJTki+Oo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx36+HX210m0MMii/hn1JU68mSdPvtMPj0CAdyxlpArEDjUY87V
	tuzTd64355Awyul5VoRuCuFW+KdETSscMlQitu0NYkzX9JpNDqXCRC4a2EY+Is1uPfXxlTn8OZM
	TqEXnbA==
X-Google-Smtp-Source: AGHT+IHO4GoG2sgK+6xMBq4Vb71Q0ebwnYgTFEJFZx5Anp6ScKPbOz0MS147AgD7hzS9YE9vpsFirIGsyhtL
X-Received: from vipin.c.googlers.com ([35.247.89.60]) (user=vipinsh
 job=sendgmr) by 2002:a05:690c:338e:b0:64b:5cc7:bcb7 with SMTP id
 00721157ae682-6dbb6acf2ebmr4310177b3.1.1726263811318; Fri, 13 Sep 2024
 14:43:31 -0700 (PDT)
Date: Fri, 13 Sep 2024 14:43:14 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240913214316.1945951-1-vipinsh@google.com>
Subject: [PATCH 0/2] KVM: x86/mmu: Repurpose MMU shrinker into page cache shrinker
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: dmatlack@google.com, zhi.wang.linux@gmail.com, weijiang.yang@intel.com, 
	mizhang@google.com, liangchen.linux@gmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

This series is extracted out from the NUMA aware page table series[1].
MMU shrinker changes were in patches 1 to 9 in the old series.

This series is changing KVM MMU shrinker behaviour by emptying MMU page
caches which are used during page fault and MMU load operations. It also
incorporates feedback from the NUMA aware page table series[1] regarding
MMU shrinker.

KVM MMU shrinker has not been very effective in alleviating pain under
memory pressure. It frees up the pages actively being used which results
in VM degradation. VM will take fault and bring them again in page
tables. More discussions happened at [2]. Overall, consensus was to
reprupose it into the code which frees pages from KVM MMU page caches.

Recently [3], there was a discussion to disable shrinker for TDP MMU.
Revival of this series is result of that discussion.

There are two major differences from the old series.
1. There is no global accounting of cache pages. It is dynamically
   calculated in mmu_shrink_count(). This has two effects; i) counting will
   be inaccurate but code is much simpler, and ii) kvm_lock being used
   here, this should be fine as mmu_shrink_scan() also holds the lock
   for its operation.
2. Only empty mmu_shadow_page_cache and mmu_shadowed_info_cache. This
   version doesn't empty split_shadow_page_cache as it is used only
   during dirty logging operation and is one per VM unlike other two
   which are per vCPU. I am not fully convinced that adding it is needed
   as it will add the cost of adding one more mutex and synchronizing it
   in shrinker. Also, if a VM is being dirty tracked most likely it will
   be migrated (memory pressure might be the reason in the first place)
   so better to not hinder migration effort and let vCPUs free up their
   caches. If someone convinces me to add split cache as well then I can
   send a separate patch to add that as well.

[1] https://lore.kernel.org/kvm/20230306224127.1689967-1-vipinsh@google.com/
[2] https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/
[3] https://lore.kernel.org/kvm/20240819214014.GA2313467.vipinsh@google.com/#t


v1:
- No global counting of pages in cache. As this number might not remain
  same between calls of mmu_shrink_count() and mmu_shrink_scan().
- Count cache pages in mmu_shrink_count(). KVM can tolerate inaccuracy
  here.
- Empty mmu_shadow_page_cache and mmu_shadowed_info_cache only. Don't
  empty split_shadow_page_cache.

v0: Patches 1-9 from NUMA aware page table series.
https://lore.kernel.org/kvm/20230306224127.1689967-1-vipinsh@google.com/

Vipin Sharma (2):
  KVM: x86/mmu: Change KVM mmu shrinker to no-op
  KVM: x86/mmu: Use MMU shrinker to shrink KVM MMU memory caches

 arch/x86/include/asm/kvm_host.h |   7 +-
 arch/x86/kvm/mmu/mmu.c          | 139 +++++++++++++-------------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  14 ++--
 include/linux/kvm_host.h        |   1 +
 virt/kvm/kvm_main.c             |   8 +-
 5 files changed, 78 insertions(+), 91 deletions(-)


base-commit: 12680d7b8ac4db2eba6237a21a93d2b0e78a52a6
-- 
2.46.0.662.g92d0881bb0-goog


