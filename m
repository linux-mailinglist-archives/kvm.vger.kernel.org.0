Return-Path: <kvm+bounces-68283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C334D29692
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 01:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0B4E330146FD
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8878A2FAC12;
	Fri, 16 Jan 2026 00:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wiMG1GNB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E5A2F617D
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 00:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768523295; cv=none; b=Bysm9GLT/FhTn3TdOFNJxf/Ic3A7lnBvMFCrytwR6/LWHNk3/vTmRCu1cTMJ5wg0lUIJwnicUMRvN4djDNbwcrFktpEzyiuODPo392XfCtd+FZ/UaJuAco9zqsgoU8S1RH0WBwWkwr7O3LZcq1BQuf8aTaFEQ7X7eQNGbElJzAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768523295; c=relaxed/simple;
	bh=Lmy3mZnt0Vu9pVGkhbQTjA5pav6lA8DVFWZaRKKzjLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FD7qMzzlMtGiqbWrN0Cq/MF7n5aPax5JFwRbgCg/DkT6NK+BerCzqJXtlKlHibPutVDavUNfB3v2DbhbYlHDK0fE6pcaT83TN29csvNZ4cjZmfjjsmsxwiA/cr1Q99J0z+NEh3UrbcNMHI0dHXtsGoB2ifJVZQlPJH4/pr87nnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wiMG1GNB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so12486265ad.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 16:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768523294; x=1769128094; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FjqiIW+WWu0wwGyaB/IaSBLpDSEVKShn11xECYjiLIQ=;
        b=wiMG1GNBi8u6qYu8LeStoW43M9sZ+goLJH5efkMaKAmdvM3gyyYzIy5GMmKVW0lYbP
         AOz6CnR43SsmzRstZ/Y12QHVDO/CR6VDTGRSrLH1D03obO9cGAg6NY0Pl4ZxJgrcmJyE
         twhm9f4pPTSWthcbjo9m10V6QX7w7rykRnHZ6MP0uNrxf0HzzD8EpCM0z1knWp9sIl/c
         nZifSS7mEg75AxQid4eTnNlYYT5MM2Z+nGpZlmWt7Dkhals4LWwOZ4Nj/Pr4/FSPBGJa
         Q4orzI4CFPkOmm8YWaTX1h6fhd3JLGZNQbIZtg8wlfj0gnYr0Wy38KA8YM4SdeCWDt1M
         Y19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768523294; x=1769128094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FjqiIW+WWu0wwGyaB/IaSBLpDSEVKShn11xECYjiLIQ=;
        b=CqAhJ8vjYPhyZJksi8bOVN3T742Xjv118O8yv3g/gEgyZ9UxTJBMGNCQYNInoKDTeP
         7M8dCHiCh/gxXs6fSeVt4MLaQBsj5f5kKoiMG+NGQxlpcmcaqg4pDVUIvWhc19GsNkLp
         0jXvA4iXtAf4q57MDMuhm13ffowa8zPbHx8P1sh6POTHYdxGUIKpbLVqBhMcn/V+tFud
         /dBC/vlvnAwaJ/5OX6XuN1Pf5PzrAaGzlNivR9RiveAk0i/xXb76/1OkU+hOK94ZRuC5
         BU5gx4l+/q3kiwv3mhQavbYi8T5oNKoa0cqGsjq3DQOhM9SjhFKRfiCyXsSq/Zo1v5LO
         8dCg==
X-Forwarded-Encrypted: i=1; AJvYcCUiyba2a6Gyr5VNGvUgmwvhW12d5wdEuapuK6xQ+oGFlsLPmQ0+qDoEZRvK8cLZ/s5VqyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzraf4VX0MQW5f1LWQkt4eutUrYQ1rcpBff0qu0k9ltA7XDwwZZ
	XZzvK1C1Ad6Fj4mFnM3mUKL2upm/KFk99zFeKoqZHc5VYVqQVDnrbkRMm4g6yhRvwQbs0gm5taZ
	PsvYP2g==
X-Received: from plmm3.prod.google.com ([2002:a17:902:c443:b0:290:b136:4f08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a2e:b0:2a1:1f28:d7ee
 with SMTP id d9443c01a7336-2a7189737e7mr7953675ad.57.1768523293863; Thu, 15
 Jan 2026 16:28:13 -0800 (PST)
Date: Thu, 15 Jan 2026 16:28:12 -0800
In-Reply-To: <20260106101646.24809-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
Message-ID: <aWmGHLVJlKCUwV1t@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, dave.hansen@intel.com, 
	kas@kernel.org, tabba@google.com, ackerleytng@google.com, 
	michael.roth@amd.com, david@kernel.org, vannapurve@google.com, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 06, 2026, Yan Zhao wrote:
> This is v3 of the TDX huge page series. The full stack is available at [4].

Nope, that's different code.

> [4] kernel full stack: https://github.com/intel-staging/tdx/tree/huge_page_v3

E.g. this branch doesn't have

  [PATCH v3 16/24] KVM: guest_memfd: Split for punch hole and private-to-shared conversion

