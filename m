Return-Path: <kvm+bounces-39727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53893A49BA9
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 15:15:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1235B1889901
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 14:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A009226E17C;
	Fri, 28 Feb 2025 14:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XtmBb5H8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3818BE7
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740752123; cv=none; b=j4rxmXw++Kkk21MxQN6FAAHm8Irm+D4UuRDjmkRAodhcmwW+NVos2wEK0O6ex73sGPZ20jghr4y5pI/z4+r49cnSnIxa7yM+ANBLhGKgl3VmI/iLj1sBasYRQWu2NwTm/yJMBzNoOo4qeLNo0fMSwByPTQxlYKdwsujbbDoL9Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740752123; c=relaxed/simple;
	bh=uI3gw1E4h1w8OZiZE65zRuvLc3js117NH0a6bu/n0Ms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SY9O0zaxOHO3O0EXYynC9F7KAT2em2+dngO2e7PCdyZ58su4nRyQmLb5IlHMi/6bCoZ4/ghwdxC6ci8BpTAYwEvWI5B2790FfG3nt3GwTEVWN58jw6O46tdm9Yhxt3Kc+GDFwBEs1TV5SYQRuoqKfABizCAQKOfQGdptPQA3kPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XtmBb5H8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2234bf13b47so42103455ad.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 06:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740752121; x=1741356921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K4n7HNs3ibqC0TSGgnmvAohC3oIZe4ftAirZaMZ4Klc=;
        b=XtmBb5H8jsRTV3GrexS+obCv0LYhJM6kkNtbqqqWk6pU1BavprVYD3+3TCjpZiJ3I5
         18vpmpc2oI4yCN8sSWOLd6PBnFccwRipYevKO2mIqgWDT+zWmnDCPKw69WvPUWj/UniD
         rKIJLbeBff7uOiCHXpSMbk6QF8KWq5zQIMx3sOQY1v7EH9xqYBEzQcpvuS4uB55c523I
         33/D6KuUs3MpBEYuff5ijUiZb21V7xiRA5dr4Ls1dObDt9zlsRjIvzqI97adjMc2VWYd
         4Q7Hf6YiWah+vyiIndty0yzsWd37G/vN+VQq6KlTBjz9BT22wTv1+Rrn0Myn5xDuUfaC
         5CDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740752121; x=1741356921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K4n7HNs3ibqC0TSGgnmvAohC3oIZe4ftAirZaMZ4Klc=;
        b=JBDmbx3oSkUOVR/oryS3mOLFDoLE22XHyg/HImPgMhl4Shnp2tmicEpG6W3jpfaWAV
         lYY5Rx/D0Hi99aNXp6TjznxHm9VIEFQH5I2sl3T4ob0GmBSLfJSB/jdulKqzxhnWD5tG
         jMVXdSA9N09TmDwJ6at5KX08lhkWc6pcu3kgaOlmjlOHNzy4xMmezz+FK0ZNA0M/rUey
         MWZUgVFq6LwZgPpKVXYSjtV/QPXrM2mzPHxy6nzcJo23wZCB0zRSP2xI6Y3U5d1mNLjN
         q9cPsErdocTaUYC6vEbYBXpAOdr5ZH4eBUh7jWMKb50eM9KUztFJHumBMj4b0at5Y/Gi
         IgYw==
X-Forwarded-Encrypted: i=1; AJvYcCU6x4s3vIF9Skcq5MKjsmWvcvlOhTJlae7rpGfWhQn/qbeMbDzhXgXK6ZPHqmQ3L1W7zrk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAqZcV29UicKYGJW/TkoPLvaLCR83iNvx+x76N5azax/JNJRZ5
	7TDSxSfeT6JRmPXCZ9RMwYMsuykGryLRSgUMEIEB/U3yrG4My3j52ejTLrnKZim9BrXC75zc4si
	rGg==
X-Google-Smtp-Source: AGHT+IFY0wutMLV/vSJQL/rvmkdGeXbcSA+g8Izv57AkofI4AiY7LTCObNflznrkj5jSTghAERF/NgqP0cM=
X-Received: from pfbdk18.prod.google.com ([2002:a05:6a00:4892:b0:730:7e2d:df66])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e88:b0:732:6222:9edf
 with SMTP id d2e1a72fcca58-734ac3311a7mr5471270b3a.5.1740752121585; Fri, 28
 Feb 2025 06:15:21 -0800 (PST)
Date: Fri, 28 Feb 2025 06:15:20 -0800
In-Reply-To: <CAPpAL=zmMXRLDSqe6cPSHoe51=R5GdY0vLJHHuXLarcFqsUHMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227230631.303431-1-kbusch@meta.com> <CAPpAL=zmMXRLDSqe6cPSHoe51=R5GdY0vLJHHuXLarcFqsUHMQ@mail.gmail.com>
Message-ID: <Z8HE-Ou-_9dTlGqf@google.com>
Subject: Re: [PATCHv3 0/2]
From: Sean Christopherson <seanjc@google.com>
To: Lei Yang <leiyang@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, x86@kernel.org, netdev@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 28, 2025, Lei Yang wrote:
> Hi Keith
> 
> V3 introduced a new bug, the following error messages from qemu output
> after applying this patch to boot up a guest.

Doh, my bug.  Not yet tested, but this should fix things.  Assuming it does, I'll
post a v3 so I can add my SoB.

diff --git a/include/linux/call_once.h b/include/linux/call_once.h
index ddcfd91493ea..b053f4701c94 100644
--- a/include/linux/call_once.h
+++ b/include/linux/call_once.h
@@ -35,10 +35,12 @@ static inline int call_once(struct once *once, int (*cb)(struct once *))
                return 0;
 
         guard(mutex)(&once->lock);
-        WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
-        if (atomic_read(&once->state) != ONCE_NOT_STARTED)
+        if (WARN_ON(atomic_read(&once->state) == ONCE_RUNNING))
                 return -EINVAL;
 
+        if (atomic_read(&once->state) == ONCE_COMPLETED)
+                return 0;
+
         atomic_set(&once->state, ONCE_RUNNING);
        r = cb(once);
        if (r)

