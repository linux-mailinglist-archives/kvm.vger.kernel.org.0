Return-Path: <kvm+bounces-14049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B6289E6B7
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E701E283E10
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FAB39B;
	Wed, 10 Apr 2024 00:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DdSQLwvn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0893619E
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708467; cv=none; b=CrYOt4ioE7xpnv6kaZRF/v9lyGgMEOivC0wlEYj1MaxRdhLbC76v6X8d7IIo9yBRir526KEY0++5Gk0H1qTm6qh/s3OlzZrwIIUx8zLhZAFdlLTn2J1LRKbC5BUqBJSMK99knmv0PmHTgzdZk3J/hIcNllEIkpp9eQ8SZmhIM1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708467; c=relaxed/simple;
	bh=nvDmKcqgZYU/OYfaKUhpOLSwCsZryNI7cthDCd2CKBM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P9ICqI/xVd0xBF8IEjYwcu4gvl9IlLLTZT3JIv/ufinCMG+kAuQ9PYwqtOVggNcYRn76LO0vcgw3t2IktTHaMinYGte4VGWuA9vKboh+I3DwCOY7vaZiF9kRpC10KRz+UDdvS6+g+JBxtk6IwMZGv4rZ9qlfqTxOTMtd8cuu4SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DdSQLwvn; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5ce12b4c1c9so3969430a12.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708465; x=1713313265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sB8TObMn2LzyNJKKLxOJUwJM9wTkM/WYNATrUKjs+Gk=;
        b=DdSQLwvnlZ/mC/0/Ua/yi9s9oi7VRfZRUVlQgAZVjXjLuPpS5gz36sb+V9uR8SkE5Y
         Dx6z2qD3CYqPtfBlshn+291TVDEj7F96QNESc5cnuP05gTvzSGkkAPZ1AN7b74/YAeop
         5PRtIALzxev7hBNNTPjy+Ei9780Fi+GPzIvewgbZUGIIv8/gkL2DlueSqGUT8mI7G1pn
         KRIkN/pc8bzl5fRwUCrPDt0TnTE3LZTNxw6ZqKkZYIc4lqfO2vwNRPpdTAU7SPuH0XxR
         fEJWoTOjG4p3DwTTqv5f41PnTdb/35IAbMI+fsMhZYPwpSKNkRGOkd1adIxOqrzJi78M
         2FjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708465; x=1713313265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sB8TObMn2LzyNJKKLxOJUwJM9wTkM/WYNATrUKjs+Gk=;
        b=n1fUZtqNob0IhvAtVAFsl3aHzPMXhbg6mj6lpkRRJxE13Usy1vBr0QN685a2Xc43U5
         Yj5ShUFGfgh7X0rsr6dJhADF2FvdQ8tDxd3CpGhZ/AEtpz9OzDxr6xohojMgXlRdYSu2
         4RsAh1P3qlS2ZmtbEyVuDR0Z9TVn+ASm0bpaa7FWGIJJxT8j+ofw97VKcmTY73rxfMT1
         PjV68M03aSDjUlYKtJfsH8yRk2xEQizy24s3xhYmkBsuuiBUW7o8h7J5s0ugDw8YvVR0
         SDxu/GhEQRpyF18t/Ho9CCd/btwROHPJVXw8U406XmXI8kVEltdyCfWK03pLh4eHuO/r
         tKXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmY7BVqJGIuL7Lumf9qyjHSPn5aBFVWx2vHyoXI+3Jq1jHKixPQ3vFtvCrLp4NxkwWtZfuPi/h992hJZvH3Z2RdN7v
X-Gm-Message-State: AOJu0Yx3HFOxfBIJLmC6drJ7/n2tw1YaLlkzIQXu7cHjrorYXigL9s0C
	HcYDIjXf/RGIS5p4zffkusaaoim6tXrDnLKhMyvht+4iiMU4GX6KqrSD34Rzwpt+b6hRN5lhE9a
	VOQ==
X-Google-Smtp-Source: AGHT+IFjH6w0Pze5H1cHo/Xc/jOJhLTcuS83dS5VOg9J1IvpNVkCfl2XKYF62JEhUaXYDBmtvq28KE+rWPc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ec04:0:b0:5dc:8645:fd8 with SMTP id
 j4-20020a63ec04000000b005dc86450fd8mr3162pgh.1.1712708465026; Tue, 09 Apr
 2024 17:21:05 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:19:46 -0700
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270376781.1586271.10159724514702496320.b4-ty@google.com>
Subject: Re: [PATCH v7 00/14] Improve KVM + userfaultfd performance via
 KVM_EXIT_MEMORY_FAULTs on stage-2 faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Anish Moorthy <amoorthy@google.com>
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, dmatlack@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"

On Thu, 15 Feb 2024 23:53:51 +0000, Anish Moorthy wrote:
> This series adds an option to cause stage-2 fault handlers to
> KVM_MEMORY_FAULT_EXIT when they would otherwise be required to fault in
> the userspace mappings. Doing so allows userspace to receive stage-2
> faults directly from KVM_RUN instead of through userfaultfd, which
> suffers from serious contention issues as the number of vCPUs scales.
> 
> Support for the new option (KVM_CAP_EXIT_ON_MISSING) is added to the
> demand_paging_test, which demonstrates the scalability improvements:
> the following data was collected using [2] on an x86 machine with 256
> cores.
> 
> [...]

Applied 1,2, and 4 to kvm-x86 generic, and 10-12 to kvm-x86 selftests.

I skipped all KVM_CAP_EXIT_ON_MISSING as per our decision to hold off until we
see the KVM userfault stuff.  I skipped the docs patch because it would require
more massaging than I wanted to do when applying.  And lastly, I skipped the
"Add memslot_flags parameter to memstress_create_vm()" patch because it would be
dead code without the exit-on-missing usage.

Please take a look at the selftests commits in particular, as I did a decent
amount of massaging when applying.

Thanks!

[01/14] KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
        https://github.com/kvm-x86/linux/commit/ed2f049fc144
[02/14] KVM: Add function comments for __kvm_read/write_guest_page()
        https://github.com/kvm-x86/linux/commit/a3bd2f7ead6d
...

[04/14] KVM: Simplify error handling in __gfn_to_pfn_memslot()
        https://github.com/kvm-x86/linux/commit/f588557ac4ac

...

[10/14] KVM: selftests: Report per-vcpu demand paging rate from demand paging test
        https://github.com/kvm-x86/linux/commit/2ca76c12c48b
[11/14] KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand paging test
        https://github.com/kvm-x86/linux/commit/df4ec5aada9d
[12/14] KVM: selftests: Use EPOLL in userfaultfd_util reader threads
        https://github.com/kvm-x86/linux/commit/0cba6442e9e2

--
https://github.com/kvm-x86/linux/tree/next

