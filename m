Return-Path: <kvm+bounces-13744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA89A89A2FA
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 18:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59E6E1F22670
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31AFF17166A;
	Fri,  5 Apr 2024 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ee3cuSZ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB086171649
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712336329; cv=none; b=SC62xty2qXbHLssNiGFZA7miVI35UMrarkxhfqsrFyiwmLwL2/Ps+k1nDApkTLdqBK4spCAraEmfn+W5c+dUKdRMHN8ZmGVO5lseEkLW3Yw9Zi1nyr2dI7DLy8d6KI2XJhbQeMiHpklv8AVKF3BOXgRZ+X3QgL4gv4a/lnHTP9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712336329; c=relaxed/simple;
	bh=kYxNSdByNJ1m5udrkC+/cqq0sc3hRu5OPcBDsIZ3Gf4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Hg5Q4AkNH8+sm0Wlro14baRFBawx7NEQ9EXhZ1S8ejVfGXSrU6uUWokwJb6Zo2tbsO1bLLSeqMmHZDr3GmxMZaAUoyVtCR9Ax7Xg77QXviTuhArxhh11APYPtE9GayXtN4PCCFwI4NdjCXI/cFusianREZY4VCSFVK3nZmPsYEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ee3cuSZ/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a2dbaacff8so1765693a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 09:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712336327; x=1712941127; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIaKqbHItjZpkeLlKYbk7Duobe/+p8JYcpNo0hsVcB4=;
        b=ee3cuSZ/PmCUOwcIJB2qvnULBvdJaPiOG+DLN7uGg9FlUZxfVpTFsTLbyh1vds0wd3
         K/yS2ySVGapxfJwvbgoJb0VsIPUUbPHoDqHgMaAqmUeysAsNBOObAcN3XWpfxcrU7JuT
         wrLexnldFYDw3uWwlEzQFUbcyfrc+eGzyICS1XmX6UY3fnwrB55yQopf5Q4T4wibpfPo
         m5ROP0ynkxcrMFiKnu7DAUNIazVMmb2O2xgS9rwwBWwPHs/c5qGWVz+epJZ3IwqZYQgk
         rwBKSM1pznyk3lQMO/ubBpmMNtRauGUwh2znJlkL37xqZ3eEO9onwao0zLd3lLluJWls
         jbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712336327; x=1712941127;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oIaKqbHItjZpkeLlKYbk7Duobe/+p8JYcpNo0hsVcB4=;
        b=vftgUlUFBr+6/Mp9LByeXDy77gHi3arGiQ7J8QpK4lMft6LtHrdE5yPhKkgn+3AdVC
         yM0Dz8Z0Az18xh+hN9ZR0gH/Wo5mH87I/XGtDnVrZJ1Nk5sgRVsYT+61hAnp2w5kzxCY
         2Q+W8dS/ywWnatKMTV3KEdFYuxpZjdBbuOne8Z0VyEGbAoWv9gMdD30wbBsimXChxTF2
         Td3w9AtrxYKG7CZH1w45RgcUTm/vftT50kJzpmMqQOXjX2JIDoPfqyTCxP04XI8fDl9L
         wcL9n943Xd21vdhrz20GIfHDpm5f8wRWEvzmHFxConrarp86tKS6xcaknewy5exPXYjq
         +fHg==
X-Gm-Message-State: AOJu0YxgrjSNC87n+lz91yb8+yQk/Lb78rqgrK1I7serNFxeMQZ0AAu3
	0XpitPbYnhkc+tD3O36pH/U/c0nes1pp76aTVYdOt40Gk6sDkLheWO8VPlqMKfgk5WvRIQKzPOM
	tbA==
X-Google-Smtp-Source: AGHT+IGoqd3TklGeYcqwAk8h7GLRYYheErNCawJpvvIGGiJhhWOdi5tZcUmwXbQAsDVZm3CxPiydDP/0hIs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cc0a:b0:29b:efaf:2bd7 with SMTP id
 b10-20020a17090acc0a00b0029befaf2bd7mr6740pju.2.1712336327275; Fri, 05 Apr
 2024 09:58:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Apr 2024 09:58:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240405165844.1018872-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Wei W Wang <wei.w.wang@intel.com>, David Skidmore <davidskidmore@google.com>, 
	Steve Rutherford <srutherford@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

 - Recording and slides uploaded[1].

 - Hold off on v20 for a few weeks, to try and land as much prep work as
   possible before v20.

 - Exactly how to slice n' dice the series to make it easier to review is TBD,
   but generally speaking the plan is to queue patches into a "dead" branch,
   e.g. kvm/kvm-coco-queue, when they are ready, to reduce the sheer volume of
   the series and thus help alleviate reviewer fatigue.

 - Don't hardcode fixed/required CPUID values in KVM, use available metadata
   from TDX Module to reject "bad" guest CPUID (or let the TDX module reject?).
   I.e. don't let a guest silently run with a CPUID that diverges from what
   userspace provided.

 - Ideally, the TDX Module would come with full metadata (not in JSON format)
   that KVM can (a) use to reject a "bad" CPUID configuration (from userspace),
   and (b) that KVM can provide to userspace to make debugging issues suck less.

 - For guest MAXPHYADDR vs. GPAW, rely on KVM_GET_SUPPORTED_CPUID to enumerate
   the usable MAXPHYADDR[2], and simply refuse to enable TDX if the TDX Module
   isn't compatible.  Specifically, if MAXPHYADDR=52, 5-level paging is enabled,
   but the TDX-Module only allows GPAW=0, i.e. only supports 4-level paging.

[1] https://drive.google.com/corp/drive/folders/1hm_ITeuB6DjT7dNd-6Ezybio4tRRQOlC
[2] https://lore.kernel.org/all/20240313125844.912415-1-kraxel@redhat.com

