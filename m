Return-Path: <kvm+bounces-34089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3969F7251
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30BD91882022
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 01:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D45378F43;
	Thu, 19 Dec 2024 01:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aWex6iZ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F0E7081C
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 01:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734573008; cv=none; b=p9xNMxZJPUtt5PLUJyhHZ6xATv3qu56QeauUyoIDSwyGBX0KjszLtC+LRbgR8U4+Kq+uVtvx2H/qEcAqfQ8Kj0fy3TdUAG+zxmKW9iQ8z/mMbkXLVnhgg3rjUCFrCZ3+CkQGeMA8sF8KpdfO8yBjn/pVHNS39OY4sL+4Ryys2NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734573008; c=relaxed/simple;
	bh=b/roIV8zN1zj/RABmE6EFiwVk+pvAB3epGgpGvq143s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GdJ/4dJL+fzxc33CEVEs5MSejsuLuHLDEVNZ4O9Bi/9dDPzplew5DfmNx8Ct6/YRdcQUVIMf6Fg8tDot6DIRoE5Df0HH1oHhKeuM689a3Ki4gaX8OGz0JF3xZ/vGkow2jE+Jg12axkgAS748mTHTzRrBcj/mvE/0E9E+s28x8Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aWex6iZ7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efa0eb9dacso262939a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 17:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734573006; x=1735177806; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uvHvaiD2tpjZOtQVEG61Pywa9K0mF+xE5PrSyEqJFNg=;
        b=aWex6iZ7pLqPDUkJJv52GWr+ahvtUh7t2lO8SFlmYtsdUvzL1VmazZAuHxdCcPE5Sd
         04QrmWZ9P806gtsMNt/F0dSnBb1A2PhzuISJ7CFZ9px83bpVz0h0VMNa9Kc9FYjGlkG0
         VtB8XYoLn0FG/4xFTo7xCspIygPaIHMIJrvsQvRSCglciBT7HI62qtoQ/y1c+JFfd5g+
         gABd2GYrqPUuQckk5WWc8sj8JlVLUWCjU/zf0ZHsHJHPo5ehx1UA3WXlKMWyAmwHF/7P
         pyOBwqeIra4PjAllhZNNOAA1JGXaqFdmOwbFtLD7uZ8gVVrLBnT4CqVlHLzgWHmwHbzi
         TcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734573006; x=1735177806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uvHvaiD2tpjZOtQVEG61Pywa9K0mF+xE5PrSyEqJFNg=;
        b=D9uUyVjc8FzB0noMtlHdrNuTC/fF3ffqMIchb01m8qlJnEtesmvlmfh82fO1ua5rK4
         Sq9FntfKvKLK+ILShrJAtrB2PeDKqSUASQGxQgKVxBQsv3if2AmnTWcYja3P+728Q9Mk
         zsV4pXSZck5Wwyyk5bIzYvkNWHdk32lMIp7MXcQZk9+dPHZZyAjyOdrJUSEKcoqwjzc9
         F1m+lvUntxmwfcQ8byscd2jRVRkXhqYxGHpSAPZKzros7MiIhV3dnH2xsdjsN1b/eSxt
         Op6bkN0RBCp5KgTkW+KwMw6w5xKDfYQAm26cSUYhgxqfwkEqoZW887he/ERb2NsnU4Mw
         pV+A==
X-Forwarded-Encrypted: i=1; AJvYcCW5judbNbnY2qqrRlHK60v406U5WDt44pfmYNmKczPe1WH7rdOYD8u2yd+2Us22D2abmVE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGzlXcR1XyueZ0+9vsTOckHfPRHVNSJ29eQdeZgPK4WHRMNmri
	1WHeFojY+ITAZHqsqFuH8PKmf9vms27mrcc1HP4nzGItO89e4BednDaZPw0eLMgIRAeYjTaExq0
	ijw==
X-Google-Smtp-Source: AGHT+IGREDNh1aIqfj8IGdlJxpgX6fwqdxGoIEfOOEG1VwCIsrgh3RwsCZDl4ZlkFENcbSu8f+nd9wQZUfg=
X-Received: from pjbcz16.prod.google.com ([2002:a17:90a:d450:b0:2f2:e5c9:de99])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f0e:b0:2ee:ed07:d6d2
 with SMTP id 98e67ed59e1d1-2f2e938a7c0mr7465514a91.37.1734573006292; Wed, 18
 Dec 2024 17:50:06 -0800 (PST)
Date: Wed, 18 Dec 2024 17:50:04 -0800
In-Reply-To: <af58ea9d81bff3d0fece356a358ee29b1b76f080.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com> <20241214010721.2356923-8-seanjc@google.com>
 <af58ea9d81bff3d0fece356a358ee29b1b76f080.camel@redhat.com>
Message-ID: <Z2N7zN7252_85ttO@google.com>
Subject: Re: [PATCH 07/20] KVM: selftests: Continuously reap dirty ring while
 vCPU is running
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 17, 2024, Maxim Levitsky wrote:
> On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> > When running dirty_log_test using the dirty ring, post to sem_vcpu_stop
> > only when the main thread has explicitly requested that the vCPU stop.
> > Synchronizing the vCPU and main thread whenever the dirty ring happens to
> > be full is unnecessary, as KVM's ABI is to actively prevent the vCPU from
> > running until the ring is no longer full.  I.e. attempting to run the vCPU
> > will simply result in KVM_EXIT_DIRTY_RING_FULL without ever entering the
> > guest.  And if KVM doesn't exit, e.g. let's the vCPU dirty more pages,
> > then that's a KVM bug worth finding.
> 
> This is probably a good idea to do sometimes, but this can also reduce
> coverage because now the vCPU will pointlessly enter and exit when dirty log
> is full.

But the alternative is simply waiting in host userspace.  I agree that doing
KVM_RUN when it's guaranteed to get hairpinned back to userspace isn't all that
interesting, but it's arguably better than having that task scheduled out while
waiting for the main thread, and I definitely don't think it's any worse.

