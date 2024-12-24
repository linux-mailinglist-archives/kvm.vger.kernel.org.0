Return-Path: <kvm+bounces-34370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BBD89FC27D
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 22:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E4D9162D20
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 21:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD78212D67;
	Tue, 24 Dec 2024 21:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CplfYiCc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31823EA76
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 21:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735074466; cv=none; b=Usdac5uriWUHdRBJGQBq5ozNADIzPWKkzLue8x2a9r2O4RDXivnh+MNfGg6fJIkNnbhIhPR5l4I0NgzRW9ZrZK19w5pN2WGAaoCfrgLbZRC1OwPxpHnU3l5NLSFoxp5yjthhCvShBO9OHkRnRA+LtGu3Hc9BCwUm/DwY9Ja4Rnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735074466; c=relaxed/simple;
	bh=cu8feJKg9gSJ6HmweoHxeTuCpE8orjL+HPupLligW6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IsAKKoFmjJa5p5emZ+jTFKY+PQOor0Um2LZp4VAtY27PHFCc5A6gLTsKVXvaJEpyXk7Zwjzg2qY4jiIe8B88mkAOFWO7FGkrc1sgaE6zvVJRx5B31RR1wOn8QUABHfS65cW5xwir78qEaqFOkJEHXAqg2DoJf2J3l1+WxHpZqYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CplfYiCc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735074463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sZs6YfEI3/l5tOpZdRufVPmaqDWxkIbDThpOmOAjfL0=;
	b=CplfYiCcpsQ4mScETrvJjvnZznQtM+dCkpDaGGGB0/zejpvunna5mvyRYUhdrqpPo5QDbg
	bh+Wp6k83dB5T4oqWfEA1OdLnFO9HyPD6DWBbz+yNay1TghCjTH8RNWfPY4a0F+EykrKd9
	I27oUTvypBFhPGKVwmyhdhu53oJORCc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-4oYYAqa9OAyr9ku-Ot_jTA-1; Tue, 24 Dec 2024 16:07:41 -0500
X-MC-Unique: 4oYYAqa9OAyr9ku-Ot_jTA-1
X-Mimecast-MFC-AGG-ID: 4oYYAqa9OAyr9ku-Ot_jTA
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7b35758d690so1081196885a.1
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 13:07:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735074461; x=1735679261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZs6YfEI3/l5tOpZdRufVPmaqDWxkIbDThpOmOAjfL0=;
        b=XuCtFWUKaq1c3FtAJcH3oskh9RAp6lrygE7r9RohTh641U+1vDWEq908cc66HzyHPf
         XCXgkqH6Y0WWloF39wP1clXVOeTQ36oOP/1YlEvlZdv6USy66/Nw2mnMZ36IQJotG3KJ
         NxAVhlCTvf12KSrIreXTZ+pNZFI5Hz3Ll5wJGwwKFK0AVDeLiCz7x6ufZBseluXyqOvE
         /C++SMH1XiGZDHl+5nPa5ZQoRtzo7oIzqMR3/XPMuMH1cs4sX47h10uQ+jpRG6Y801DO
         IU+J1ejLXzvcY6RTInFzqP8Q1UzpFiby6L2xOuHyWd2TdQLi/SXaaD9D2iJjpvYHMerS
         QuBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWIOhJLqo5RK21/ZwyFFOMWAvYjbriXQD6OKPnH1TuCp1yjYGsrIzJC1iJ3I7CcF2DtWw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJy/OCqA/omriD7mervLSjoANMWP+N4PssaH5tFDZNck2YWlxz
	zRki1R6ziWiaagCMAOtdVRxH0m75ONMCPI6MV6F1yWsclnkVXME9py9b9b2ZKjpAsAEy98D2S+v
	peuh2ZO/B65pzK/EZdNPgDJhbR5DIcACLts6+cgzQAgNaBI5w+A==
X-Gm-Gg: ASbGnctTnVtodz56/w6+7frBR8ApVwaRq9Ajj5mbolmhlZRbtbMvgutyQpNESUJVvVp
	yDfpmykbREel7GtUdWCIaRmcy0bz8N+bbfkKCUVs3nZiRQ/FDXqDMesc5I0/fBoGhn9CJIPrhmV
	RYY2iKqU2xZroFoyuAz387VfMLKfnzLgLKe1fenpF2uOTAkOZUu8sD+4HIS/KKE/l7MFEZC/FnT
	BpZQtxn2GNu02Hw57nPSyQ3ecNJ5M5g+rzVFOyJFt1ocXB9dQpD0FWkkdrzdoP3EjgxCTtffxIB
	96HItbGGL9agV67nIg==
X-Received: by 2002:a05:620a:4113:b0:7b8:626b:7ab with SMTP id af79cd13be357-7b9ba75eccdmr2798803285a.19.1735074460862;
        Tue, 24 Dec 2024 13:07:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnN/zY/woHUhG5osGnG+exxCB/UJU+6pyhc9ubSIWO3+84Rcn5ofakxvIKipqBFvygMHhkKw==
X-Received: by 2002:a05:620a:4113:b0:7b8:626b:7ab with SMTP id af79cd13be357-7b9ba75eccdmr2798800285a.19.1735074460495;
        Tue, 24 Dec 2024 13:07:40 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46a3e676f26sm56608011cf.19.2024.12.24.13.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2024 13:07:39 -0800 (PST)
Date: Tue, 24 Dec 2024 16:07:36 -0500
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>,
	David Matlack <dmatlack@google.com>, Wang@google.com,
	Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
Message-ID: <Z2simHWeYbww90OZ@x1n>
References: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>

James,

On Wed, Dec 04, 2024 at 07:13:35PM +0000, James Houghton wrote:
> This is a continuation of the original KVM Userfault RFC[1] from July.
> It contains the simplifications we talked about at LPC[2].
> 
> Please see the RFC[1] for the problem description. In summary,
> guest_memfd VMs have no mechanism for doing post-copy live migration.
> KVM Userfault provides such a mechanism. Today there is no upstream
> mechanism for installing memory into a guest_memfd, but there will
> be one soon (e.g. [3]).
> 
> There is a second problem that KVM Userfault solves: userfaultfd-based
> post-copy doesn't scale very well. KVM Userfault when used with
> userfaultfd can scale much better in the common case that most post-copy
> demand fetches are a result of vCPU access violations. This is a
> continuation of the solution Anish was working on[4]. This aspect of
> KVM Userfault is important for userfaultfd-based live migration when
> scaling up to hundreds of vCPUs with ~30us network latency for a
> PAGE_SIZE demand-fetch.

I think it would be clearer to nail down the goal of the feature.  If it's
a perf-oriented feature we don't need to mention gmem, but maybe it's not.

> 
> The implementation in this series is version than the RFC[1]. It adds...
>  1. a new memslot flag is added: KVM_MEM_USERFAULT,
>  2. a new parameter, userfault_bitmap, into struct kvm_memory_slot,
>  3. a new KVM_RUN exit reason: KVM_MEMORY_EXIT_FLAG_USERFAULT,
>  4. a new KVM capability KVM_CAP_USERFAULT.
> 
> KVM Userfault does not attempt to catch KVM's own accesses to guest
> memory. That is left up to userfaultfd.

I assume it means this is an "perf optimization" feature then?  As it
doesn't work for remote-fault processes like firecracker, or
remote-emulated processes like QEMU's vhost-user?

Even though it could still 100% cover x86_64's setup if it's not as
complicated as above?  I mean, I assumed above sentence was for archs like
ARM that I remember having no-vcpu-context accesses so things like that is
not covered too.  Perhaps x86_64 is the goal?  If so, would also be good to
mention some details.

> 
> When enabling KVM_MEM_USERFAULT for a memslot, the second-stage mappings
> are zapped, and new faults will check `userfault_bitmap` to see if the
> fault should exit to userspace.
> 
> When KVM_MEM_USERFAULT is enabled, only PAGE_SIZE mappings are
> permitted.
> 
> When disabling KVM_MEM_USERFAULT, huge mappings will be reconstructed
> (either eagerly or on-demand; the architecture can decide).
> 
> KVM Userfault is not compatible with async page faults. Nikita has
> proposed a new implementation of async page faults that is more
> userspace-driven that *is* compatible with KVM Userfault[5].
> 
> Performance
> ===========
> 
> The takeaways I have are:
> 
> 1. For cases where lock contention is not a concern, there is a
>    discernable win because KVM Userfault saves the trip through the
>    userfaultfd poll/read/WAKE cycle.
> 
> 2. Using a single userfaultfd without KVM Userfault gets very slow as
>    the number of vCPUs increases, and it gets even slower when you add
>    more reader threads. This is due to contention on the userfaultfd
>    wait_queue locks. This is the contention that KVM Userfault avoids.
>    Compare this to the multiple-userfaultfd runs; they are much faster
>    because the wait_queue locks are sharded perfectly (1 per vCPU).
>    Perfect sharding is only possible because the vCPUs are configured to
>    touch only their own chunk of memory.

I'll try to spend some more time after holidays on this perf issue. But
will still be after the 1g support on !coco gmem if it would work out. As
the 1g function is still missing in QEMU, so that one has higher priority
comparing to either perf or downtime (e.g. I'll also need to measure
whether QEMU will need minor fault, or stick with missing as of now).

Maybe I'll also start to explore a bit on [g]memfd support on userfault,
I'm not sure whether anyone started working on some generic solution before
for CoCo / gmem postcopy - we need to still have a solution for either
firecrackers or OVS/vhost-user.  I feel like we need that sooner or later,
one way or another.  I think I'll start without minor faults support until
justified, and if I'll ever be able to start it at all in a few months next
year..

Let me know if there's any comment on above thoughts.

I guess this feauture might be useful to QEMU too, but QEMU always needs
uffd or something similar, then we need to measure and justify this one
useful in a real QEMU setup.  For example, need to see how the page
transfer overhead compares with lock contentions when there're, say, 400
vcpus.  If some speedup on userfault + the transfer overhead is close to
what we can get with vcpu exits, then QEMU may still stick with a simple
model.  But not sure.

When integrated with this feature, it also means some other overheads at
least to QEMU.  E.g., trap / resolve page fault needs two ops now (uffd and
the bitmap).  Meanwhile even if vcpu can get rid of uffd's one big
spinlock, it may contend again in userspace, either on page resolution or
on similar queuing.  I think I mentioned it previously but I guess it's
nontrivial to justify.  In all cases, I trust that you should have better
judgement on this.  It's just that QEMU can at least behave differently, so
not sure how it'll go there.

Happy holidays. :)

Thanks,

-- 
Peter Xu


