Return-Path: <kvm+bounces-44004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD53A997B0
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 20:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A240A4A2969
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4340B28DEFE;
	Wed, 23 Apr 2025 18:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qdqVqxUj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA46628D82D
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745432278; cv=none; b=QhdFkQe0+SQAfHEWIXAKD2nswz50qD/XHsL8uYkGQY6zvWD+Mnju3z6AALy+VBS1cPhUWfyrylsW8JoJatlShWglvw9GNlFeTDeeuTJUOSq7kOEGKOQK+dEPoDYrOk4DtsVx0aT+WSEPhtxWDPBI7tNjrsd4sML2TMnL9pP9fq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745432278; c=relaxed/simple;
	bh=q7u07MQUp5cJa9EPfwKLKS4zrLrD1T+AP6Uf8KvM5qo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n7TrCuevYryfqYVc3k6hnqdqMcITyDCDbEX3+06EogKyyhjAQmqO9N2o5T0VgqRvIhIR83SXzFNUrOLOBo0wJnczxGJrUFrVl/5mLKVYGAZ6Df1qAfOb0/Ualnk4C4W3iUdGM49B0s18o3pDrJgoOQ939zh2dFTkqoOzq6S879I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qdqVqxUj; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73dff14aa55so66593b3a.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745432276; x=1746037076; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3X8ZkBIcM24q5um5UpSbyV9fzNqmEYZ5Cw4KyKY4LiA=;
        b=qdqVqxUj+BZ7WKHRxSa9PTgFHwWqWlUrPpH2Jf2eQwGU1DVDRxh/0O3KDLCRRekZB/
         VnDM/E9SHRLDASb4JZ0wHXscJzWYG1aGt1cXeoxN2r1EF1JXGjSKcFsJiksQhHjx7BSr
         Vql8fqfOpjhHDwRtn4OY1EQ+jrAMQNMQ71IP/EYTbl2gjSZ6dLcBk57mMKKExSg+TyBr
         0SGorZEq4AMf8MjrK51+I1z2w/4fISfMRBifxwH3Sqob+KXktEPnmkc1vCp8npKK9khr
         s3wRRRul8nsy5TKbdoo8R/6XX3zVhiyO4xvwyq5+pq0n4RJNfYxP99IYij4GIsls8W/o
         +xnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745432276; x=1746037076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3X8ZkBIcM24q5um5UpSbyV9fzNqmEYZ5Cw4KyKY4LiA=;
        b=u9Vx6ZvUFtD5P0FS6QFISjmY8Jb9+b6H0dLhqtRo7HXyHxQ7ExtMuD4fXj5x2vHLJR
         wLNxt7I3+2y4ekL9pV7ZiP4wPKejztvH6dCUtZxUZn+eXFF71aEntf6CUicdmYsu1nw6
         xA9veoDF6LQHBtSZIwf0AEkyjeEfECfrwDeEDgQ1vvBEv4DcJ7Fdc60FEBpk1BUVfH98
         zaFv4dR8GPf/SYs+cdb51tVEHaJ1Ur/RSpoSB5HfqZRDKJynTtIi3xOQ7ei6q3Ttj8LP
         E5Wf6jHr5pn4cdJywEVNfEEu9XkwsGWHFAfNvELdN0UqIJVbsh468B5RfmgsWYt46r/S
         Ow6A==
X-Gm-Message-State: AOJu0YxEshOAzzUHIMRqoysFiYKyWsfeR9A4MiIOVpg5ZZIOAjC7W2vH
	KLC1um672zv7Fhn+KGsbjd6otyN4PSVo+iV/9sNN9I8nG7eF9p5KxhCGQCAyPdJbeGSCJ4UGSx8
	wukjDeCuqkLskjdxi/+2gzw==
X-Google-Smtp-Source: AGHT+IEpaBfMRC9LQJ4Q/Km7YIvS2XcSs0JhmEZ4FmbRm8hmxGz8ovqyqRZwswE6usaGPhRJLjUod19RqG45BSwZKA==
X-Received: from pfan17.prod.google.com ([2002:aa7:8a51:0:b0:730:7e2d:df69])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8c02:b0:736:7270:4d18 with SMTP id d2e1a72fcca58-73e21bd5ccamr619882b3a.14.1745432276198;
 Wed, 23 Apr 2025 11:17:56 -0700 (PDT)
Date: Wed, 23 Apr 2025 11:17:54 -0700
In-Reply-To: <20250421183533.rnoif5ky37umyw3e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Z__AAB_EFxGFEjDR@google.com> <20250418001237.2b23j5ftoh25vhft@amd.com>
 <aAJsDVg5RNfSpiYX@google.com> <20250421183533.rnoif5ky37umyw3e@amd.com>
Message-ID: <diqzwmbazqr1.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: Untested fix for attributes vs. hugepage race
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Michael Roth <michael.roth@amd.com> writes:

> On Fri, Apr 18, 2025 at 08:13:17AM -0700, Sean Christopherson wrote:
>> 
>> That all looks good to me.  And to ensure we don't go off the rails due to bad
>> inputs (which are supposed to be fully validated by common KVM), we could add a
>> WARN to detect a non-exclusive range->end.
>> 
>> So this?
>> 
>> 	if (WARN_ON_ONCE(range->end <= range->start))
>> 		return false;
>> 
>> 	/*
>> 	 * If the head and tail pages of the range currently allow a hugepage,
>> 	 * i.e. reside fully in the slot and don't have mixed attributes, then
>> 	 * add each corresponding hugepage range to the ongoing invalidation,
>> 	 * e.g. to prevent KVM from creating a hugepage in response to a fault
>> 	 * for a gfn whose attributes aren't changing.  Note, only the range
>> 	 * of gfns whose attributes are being modified needs to be explicitly
>> 	 * unmapped, as that will unmap any existing hugepages.
>> 	 */
>> 	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
>> 		gfn_t start = gfn_round_for_level(range->start, level);
>> 		gfn_t end = gfn_round_for_level(range->end - 1, level);
>> 		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
>> 
>> 		if ((start != range->start || start + nr_pages > range->end) &&
>> 		    start >= slot->base_gfn &&
>> 		    start + nr_pages <= slot->base_gfn + slot->npages &&
>> 		    !hugepage_test_mixed(slot, start, level))
>> 			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
>> 
>> 		if (end == start)
>> 			continue;
>> 
>> 		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
>> 		    !hugepage_test_mixed(slot, end, level))
>> 			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
>> 	}
>
> Looks good! Re-tested with this version of the patch and it seems to address
> the original issue.
>
> Tested-by: Michael Roth <michael.roth@amd.com>
>
> Thanks,
>
> Mike

Would you be able to share how you set up a test to trigger this issue?
Thanks in advance!

