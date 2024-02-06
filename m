Return-Path: <kvm+bounces-8094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E9884B06E
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:55:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30051B2316A
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6DC412C804;
	Tue,  6 Feb 2024 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T/GXRNXm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E89012D148
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 08:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707209659; cv=none; b=LIJF9qzAGP6Ti1xsl5Q7kF0Q7QBNoT2AbG9yv9LUUz1ieUXAJ4Zg17CHvj+14AZU/CcjmbVQAkaWIlM1FVObd/ERx0TIailUT/bLkabZY6iXP9m/THqAx/3o9auYAH4wvt7qS9fMbt+pY+tniakiybqqcl78bEjEVvdTsPvt5is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707209659; c=relaxed/simple;
	bh=aazENfqtOUGTlV9wdum2yY1QQawhdPN8d0nGlVzMOS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V80YzKKv0IH3WYNoqeDwsLTuiw8ON5BOibulcV4tIfGHWm1lNtguyis2ULSFGrKFvwgAnyXLgW8ivp26ak2aY/Ml9++iPnnx02vWukpK/YhtdnXhUWDE2Ghtg3T3caQ7WY64VXwzIPuuZGjCqdJyaShzkEwfDLTOcF4NdZnXnaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T/GXRNXm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707209656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D6jeTGXlTgd7sq1RCPaLQ4vJaHshuSOrnrjXVHXXGG4=;
	b=T/GXRNXmLmzDfF6hFn0PLaen42iG3czA7SeLM4RM6ckkVjuw35bWsy8N0l7OjRcgLhD9qv
	SAV69E8lrddCkPscryrAu/rDrVUq5p1yQ5pvJM0hLVsosAwLJ7oinsJA247ZgkxxZreZph
	SUr3/etJ3XkVdh59I8PsBhbEuyX60BU=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-oP3GhnDPM3eYDKwBC82-Nw-1; Tue, 06 Feb 2024 03:54:15 -0500
X-MC-Unique: oP3GhnDPM3eYDKwBC82-Nw-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6e029a8a77fso245662b3a.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 00:54:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707209654; x=1707814454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6jeTGXlTgd7sq1RCPaLQ4vJaHshuSOrnrjXVHXXGG4=;
        b=he9v5PHya/gGdAnmRJNTcZz1JOOq7cQRSJydr0OZC0JI+RrWpQjbgUR/G9sjps/PG5
         bQ8gwMrQg7SVAC5cNLiq766F94gZ/yfgj3LJ66GyDX4aEBOYV3PrLbNHuAx/1Hp9NzLI
         mfjGmcTlgUU3hhPzNroipPd3puDtTbAqZLftvO6S+2aeUGZf3DvKd3HfAXJkQpndporb
         cB7mbg5NLy9IhTfW0K1OoaU80lF+t5SM4Q/Nnb82cnH0PS3fsKf4WXQfXgE2Hc15fq2r
         aR972mw9f+2nnLFsSVOGEdgELeHVVPreyjk/HSxerxn1YvIEgZAclEPf+sDeu4P5g1au
         /g9A==
X-Gm-Message-State: AOJu0YxNNC6QlBN6O+d3QL1JzOEdd1YEGBfxtF6d6UMXrsKUrnPHMmJ8
	HrriDhkAb8G9coHu2mZq/aujYwQmB/Id3JomRXS1CwwTb6tdfDCcy9eu+6I3RFQwiqbYAH9FIaQ
	WZBK+lnzVMEIw8YcuXHDGkQlNp5hcaFkU5TdS13PK1fns2Vn0/Q==
X-Received: by 2002:a05:6a00:6ca1:b0:6e0:4576:f7e0 with SMTP id jc33-20020a056a006ca100b006e04576f7e0mr2247685pfb.2.1707209654355;
        Tue, 06 Feb 2024 00:54:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvN3y4+2Rw5wySrw+h3tMkLwaaLTuYCiyjGtL1y1ARDrZzfL7lEreaHm2OW4eOTmHSrywPIg==
X-Received: by 2002:a05:6a00:6ca1:b0:6e0:4576:f7e0 with SMTP id jc33-20020a056a006ca100b006e04576f7e0mr2247674pfb.2.1707209654034;
        Tue, 06 Feb 2024 00:54:14 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXgojwDuPwoSHBcnxvnh4eUxUfIAR5xwz/+stE6MwvGDIrJpPrLbUkveKky3x9HiRB2n2p1QQJn3vNs1cUKlg09cGWSW9Kmtf6HTPl2KAc570ys1TaAvFpcXwJbRF+gT+wjBJoL5VRKai3yxT4vxgiG7QcWWDDT
Received: from x1n ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x16-20020aa79a50000000b006e03be933cesm1349409pfj.96.2024.02.06.00.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 00:54:13 -0800 (PST)
Date: Tue, 6 Feb 2024 16:54:06 +0800
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Fix a semaphore imbalance in the dirty
 ring logging test
Message-ID: <ZcHzrqpoUlUl5OhU@x1n>
References: <20240202231831.354848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240202231831.354848-1-seanjc@google.com>

On Fri, Feb 02, 2024 at 03:18:31PM -0800, Sean Christopherson wrote:
> When finishing the final iteration of dirty_log_test testcase, set
> host_quit _before_ the final "continue" so that the vCPU worker doesn't
> run an extra iteration, and delete the hack-a-fix of an extra "continue"
> from the dirty ring testcase.  This fixes a bug where the extra post to
> sem_vcpu_cont may not be consumed, which results in failures in subsequent
> runs of the testcases.  The bug likely was missed during development as
> x86 supports only a single "guest mode", i.e. there aren't any subsequent
> testcases after the dirty ring test, because for_each_guest_mode() only
> runs a single iteration.
> 
> For the regular dirty log testcases, letting the vCPU run one extra
> iteration is a non-issue as the vCPU worker waits on sem_vcpu_cont if and
> only if the worker is explicitly told to stop (vcpu_sync_stop_requested).
> But for the dirty ring test, which needs to periodically stop the vCPU to
> reap the dirty ring, letting the vCPU resume the guest _after_ the last
> iteration means the vCPU will get stuck without an extra "continue".
> 
> However, blindly firing off an post to sem_vcpu_cont isn't guaranteed to
> be consumed, e.g. if the vCPU worker sees host_quit==true before resuming
> the guest.  This results in a dangling sem_vcpu_cont, which leads to
> subsequent iterations getting out of sync, as the vCPU worker will
> continue on before the main task is ready for it to resume the guest,
> leading to a variety of asserts, e.g.
> 
>   ==== Test Assertion Failure ====
>   dirty_log_test.c:384: dirty_ring_vcpu_ring_full
>   pid=14854 tid=14854 errno=22 - Invalid argument
>      1  0x00000000004033eb: dirty_ring_collect_dirty_pages at dirty_log_test.c:384
>      2  0x0000000000402d27: log_mode_collect_dirty_pages at dirty_log_test.c:505
>      3   (inlined by) run_test at dirty_log_test.c:802
>      4  0x0000000000403dc7: for_each_guest_mode at guest_modes.c:100
>      5  0x0000000000401dff: main at dirty_log_test.c:941 (discriminator 3)
>      6  0x0000ffff9be173c7: ?? ??:0
>      7  0x0000ffff9be1749f: ?? ??:0
>      8  0x000000000040206f: _start at ??:?
>   Didn't continue vcpu even without ring full
> 
> Alternatively, the test could simply reset the semaphores before each
> testcase, but papering over hacks with more hacks usually ends in tears.

IMHO this is fine; we don't have a hard requirement anyway on sem in this
test, and we're pretty sure where the extra sem count came from (rather
than an unknown cause).

However since the patch can drop before_vcpu_join() by a proper ordering of
setup host_quit v.s. sem_post(), I think it's at least equally nice indeed.

> 
> Reported-by: Shaoqin Huang <shahuang@redhat.com>
> Fixes: 84292e565951 ("KVM: selftests: Add dirty ring buffer test")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu


