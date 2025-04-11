Return-Path: <kvm+bounces-43181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D1BAA867EC
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 23:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49A00465FB6
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 21:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7017E293B7C;
	Fri, 11 Apr 2025 21:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lyYEmkt+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055BA258CCE
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 21:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744405961; cv=none; b=XgX+lsvo7qz+JDUrCWka3x7NuVfxpdVelIE387JWdIRw2fO/ReiKZz1d8EdCEMp48EVJ9oD+5FQIeW06e8tjze20UIjUSeNo1lFApA7Ua0bPgpgep0j/Ga4w6cSepvG4rO6EhOZw6Sti5Xcja2qJ1gxKKl56+v8Yu1b35vLrWPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744405961; c=relaxed/simple;
	bh=HIoeRzZ4XL/sqMS6l6dsp3lLVoJy7wnMtD2NyOs3WuM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jv3YBja79YY0Ai4p77z8v0E1XFbyS/hthjDWvFx6Ub99yYkNMjs7PYJGMH3o4+yLBxFS/ajVS6Rv6buLUN6soH8HhLb4FUBG3pBvRpm4nMZrmBufzLKlahNrCTSQs7tIwWuHH2SvM8FCT/QxjEdgNfjX4MzULFqaNcz1CR1mKPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lyYEmkt+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff68033070so2173017a91.2
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 14:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744405959; x=1745010759; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fTerkmabK1RPmin6YSGz3yw/UPXy21WADjby6VaDxu0=;
        b=lyYEmkt+4W/qmYTbqLfgcKWygcpTCT+AcNxQPJV4qwTs3wfz/+CvHP/PqFpPfgL09i
         rcopAT+whi4UWNcTSg/HVJeSGrj0CA7gBa5NcQ6FyN8uBirYoUYvwN6XuxZUeCPIFFrN
         lGdqvfm+/X9XO2lbFwqd8SlNNNyaukBAURqDTv3xyPDYmqcWdAKAbyu2aou2gZRCpscc
         hRPihAiiaeGODqPuibtDr2NjQsJwvkyJdrduBduRFKMZERwp4Kpp0ouTEVYMS0XpY7Du
         SWLjrZkqUJoQMBIDI45oqQJADgO9Q4T/feG3mimLQsZrBdkgn3b+SfKOzMG6xROfsmGp
         tx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744405959; x=1745010759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fTerkmabK1RPmin6YSGz3yw/UPXy21WADjby6VaDxu0=;
        b=aH2YzXGO3mmAImcUKEsoVW4xJ5wLGC0DWhEAL0ITCB097Y5w9MPksZL3RMnmd8Zy9h
         elyazwdwMuBVTiMJeu0AfHLjoDuev7wzGWltIVQdohv5LncsziFYoH4y/pz41fekHkIV
         KJiBQJMGTiPyImxi2sEc/Xm2krIV0eoHYloiArgcRayJpy3JFVoglXgIHRNT/cFaxETf
         XttSATdlslTJcsAWOeudZK9ZHcC4xU7ueP9czIcbZLkPvbl01hnDKsm/J+z751gPnRTG
         YBxbXtJawyEeh5J49ziG61zzwUwiI3eTVBgqvLbz/IJSpjz5wfVHarDqraMYSBhhC9eV
         eQ6w==
X-Gm-Message-State: AOJu0Yzugwxn8EwBBxvoRHcxsO3BiefSA3zHJea9aGlrR2yMBbJqIIWx
	z7udCkUrrbXAfhKQEFhHGCCHMNmVKZsSjDDq/p02XNdkuXN7eqT6WqAy0etHOZZLGzoz2AK1lxU
	oWA==
X-Google-Smtp-Source: AGHT+IHCwmlsejUy/39yMP4wbG3Y4o+uj+/0NvNbE4QYI/YW+78TKNJvJdox+x120ZMs4bTF49FtEDiDTlU=
X-Received: from pjtu11.prod.google.com ([2002:a17:90a:c88b:b0:305:2d2a:dfaa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5403:b0:301:9f62:a944
 with SMTP id 98e67ed59e1d1-308237cde17mr7424213a91.33.1744405959367; Fri, 11
 Apr 2025 14:12:39 -0700 (PDT)
Date: Fri, 11 Apr 2025 14:12:38 -0700
In-Reply-To: <20250331213025.3602082-2-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250331213025.3602082-1-jthoughton@google.com> <20250331213025.3602082-2-jthoughton@google.com>
Message-ID: <Z_mFxiXcWKcxRo8g@google.com>
Subject: Re: [PATCH v2 1/5] KVM: selftests: Extract guts of THP accessor to
 standalone sysfs helpers
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yu Zhao <yuzhao@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 31, 2025, James Houghton wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Extract the guts of thp_configured() and get_trans_hugepagesz() to
> standalone helpers so that the core logic can be reused for other sysfs
> files, e.g. to query numa_balancing.
> 
> Opportunistically assert that the initial fscanf() read at least one byte,
> and add a comment explaining the second call to fscanf().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Needs your SoB.  It's a bit absurd for this particular patch, but please provide
it anyway, if only so that I can get a giggle out of the resulting chain of SoBs :-)

