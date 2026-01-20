Return-Path: <kvm+bounces-68632-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MFjGBhHgb2n8RwAAu9opvQ
	(envelope-from <kvm+bounces-68632-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:05:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 019A74AFC3
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5695B52E643
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 17:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E3C441054;
	Tue, 20 Jan 2026 17:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k6Xx19Fk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54C743E9EC
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931471; cv=none; b=G+xGLSdMjqDUkTGOwPcTfocDuRqwLIWqz2V1QvtjSAjm7JmQMNEo96idK7r37FTzSgQBHkOQQPQZI0Dy0buBripVg/ItpE/LIYbWQyIA4N7AGSoEFQeh91iv4JjXzS5eGgfKQ6kMUeZuD6vdP+Myhf9i2ojHPvn7obepeHRxyOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931471; c=relaxed/simple;
	bh=0fyWUfYqqDXkk6a8d2BPVvMOPi7EMx5O6okEC5JABzc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dz5bn0ja1ZZ12iZtgAO6QelDf9Di3mphN0t0fn4VvwwCj6+/PjJCI67hdv6ULELjki7J35rtW5o8HTAoAYDyXZH1zzPQY+Lgm+HSe2mgPF3/LaSE/TCq699hoMbi34SbSfinia8rvVIDis5hQMSTMM6hXCW020+UATlwo3oHoJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k6Xx19Fk; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a78c094ad6so2468285ad.1
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 09:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768931468; x=1769536268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PBYdCmT+L/+K4c9bKrSuTaHXyN4/euVT+SSxHGhM8vM=;
        b=k6Xx19FkclQ//uHxUw0AhpIgGORMQz7f6SteWK5J00Hk264H31FQBcf55fH1tFk83H
         OLwWvldYgEqZY2rGN1noNguWgmnzR7v9xyhQftkMVRghCBWdqjSozoqc5g+bh6PW4aEs
         LNjskWpL8m6kDtM0WCkQuxO9U2YD8ZUX309BZxbBIJfj30JE5wz5h1+APcrx1h8VHLGs
         PupBo9KvpFt2mI1C7z4E/eRhUyKpW+vTn4q2z/03mxwk5ztQKeW2W8XzVlNzlT7//ReR
         9MyVbc1ZFZylX0F618mctLGk3oqWo9DyQEpahqtn/pSRWojVc8GkTudH/HNW27MSth1o
         8FkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768931468; x=1769536268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBYdCmT+L/+K4c9bKrSuTaHXyN4/euVT+SSxHGhM8vM=;
        b=SEbT3pJtmstDlMEKMp9lY78o4lGParTKJtGIEoGqC9Xz98MF8nrCfOidKeIc+bLPpI
         qKtUus5K+0QPehHfXTI9jq0TNHm4ZmH1nw/Pb8p5WXGIQ83q4XCBhuR5+qFdl5agxR89
         JOpy+88CLGTerhuRwQ7z6avO0RqljPMQgS8t2bE3GfpdRLnoBaZk+V22ED/AcYwUXCOD
         Hd8/Flgf1f51s+JAUpzhcR93E+M3sjTWWEFsgCT21cSJUkjKEYFjm8Ok5RdtEaNkDTFI
         FF7WC5uSWgrJoqT1iBGOzvGqE8oi/Rx4Y9t49H4sizHWGfA/P3BsztLVx9xL60MihgX2
         QoBA==
X-Forwarded-Encrypted: i=1; AJvYcCUvWSELxXQ1pvksNy+c2+rlZHc+r2AIpU28+l0MsDesN4DCHoEqQJ1LEE8rP7eI+V2Ytfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKaK1HXp/KaV+xqtPMcGXVFjVrz6Rjv1wIj13rsb9Qt7taJQV/
	a1HZ4ufo+dU/7gviiu1zUdW9WkavAkgt6UX0GflXUwTwOc8zocEEdbJitP9rYOpV42uWMVJGHFj
	RYY0ruQ==
X-Received: from plim9.prod.google.com ([2002:a17:903:3b49:b0:2a1:5cb9:cd71])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c5:b0:295:c2e7:7199
 with SMTP id d9443c01a7336-2a76ad6be42mr22284945ad.29.1768931467769; Tue, 20
 Jan 2026 09:51:07 -0800 (PST)
Date: Tue, 20 Jan 2026 09:51:06 -0800
In-Reply-To: <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
 <aWrMIeCw2eaTbK5Z@google.com> <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
Message-ID: <aW_Aith2qkYQ3fGY@google.com>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce kvm_split_cross_boundary_leafs()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fan Du <fan.du@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>, 
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Chao P Peng <chao.p.peng@intel.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Jun Miao <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spamd-Result: default: False [0.04 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,redhat.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,linux.intel.com,suse.com,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[29];
	TAGGED_FROM(0.00)[bounces-68632-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 019A74AFC3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Jan 19, 2026, Yan Zhao wrote:
> On Fri, Jan 16, 2026 at 03:39:13PM -0800, Sean Christopherson wrote:
> > On Thu, Jan 15, 2026, Kai Huang wrote:
> > > So how about:
> > > 
> > > Rename kvm_tdp_mmu_try_split_huge_pages() to
> > > kvm_tdp_mmu_split_huge_pages_log_dirty(), and rename
> > > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() to
> > > kvm_tdp_mmu_split_huge_pages_cross_boundary()
> > > 
> > > ?
> > 
> > I find the "cross_boundary" termininology extremely confusing.  I also dislike
> > the concept itself, in the sense that it shoves a weird, specific concept into
> > the guts of the TDP MMU.
> > The other wart is that it's inefficient when punching a large hole.  E.g. say
> > there's a 16TiB guest_memfd instance (no idea if that's even possible), and then
> > userpace punches a 12TiB hole.  Walking all ~12TiB just to _maybe_ split the head
> > and tail pages is asinine.
> That's a reasonable concern. I actually thought about it.
> My consideration was as follows:
> Currently, we don't have such large areas. Usually, the conversion ranges are
> less than 1GB. 

Nothing guarantees that behavior.

> Though the initial conversion which converts all memory from private to
> shared may be wide, there are usually no mappings at that stage. So, the
> traversal should be very fast (since the traversal doesn't even need to go
> down to the 2MB/1GB level).
> 
> If the caller of kvm_split_cross_boundary_leafs() finds it needs to convert a
> very large range at runtime, it can optimize by invoking the API twice:
> once for range [start, ALIGN(start, 1GB)), and
> once for range [ALIGN_DOWN(end, 1GB), end).
> 
> I can also implement this optimization within kvm_split_cross_boundary_leafs()
> by checking the range size if you think that would be better.
> 
> > And once kvm_arch_pre_set_memory_attributes() is dropped, I'm pretty sure the
> > _only_ usage is for guest_memfd PUNCH_HOLE, because unless I'm misreading the
> > code, the usage in tdx_honor_guest_accept_level() is superfluous and confusing.
> Sorry for the confusion about the usage of tdx_honor_guest_accept_level(). I
> should add a better comment.
> 
> There are 4 use cases for the API kvm_split_cross_boundary_leafs():
> 1. PUNCH_HOLE
> 2. KVM_SET_MEMORY_ATTRIBUTES2, which invokes kvm_gmem_set_attributes() for
>    private-to-shared conversions
> 3. tdx_honor_guest_accept_level()
> 4. kvm_gmem_error_folio()
> 
> Use cases 1-3 are already in the current code. Use case 4 is per our discussion,
> and will be implemented in the next version (because guest_memfd may split
> folios without first splitting S-EPT).
> 
> The 4 use cases can be divided into two categories:
> 
> 1. Category 1: use cases 1, 2, 4
>    We must ensure GFN start - 1 and GFN start are not mapped in a single
>    mapping. However, for GFN start or GFN start - 1 specifically, we don't care
>    about their actual mapping levels, which means they are free to be mapped at
>    2MB or 1GB. The same applies to GFN end - 1 and GFN end.
> 
>    --|------------------|-----------
>      ^                  ^
>     start              end - 1 
> 
> 2. Category 2: use case 3
>    It cares about the mapping level of the GFN, i.e., it must not be mapped
>    above a certain level.
> 
>    -----|-------
>         ^
>        GFN
> 
>    So, to unify the two categories, I have tdx_honor_guest_accept_level() check
>    the range of [level-aligned GFN, level-aligned GFN + level size). e.g.,
>    If the accept level is 2MB, only 1GB mapping is possible to be outside the
>    range and needs splitting.

But that overlooks the fact that Category 2 already fits the existing "category"
that is supported by the TDP MMU.  I.e. Category 1 is (somewhat) new and novel,
Category 2 is not.

>    -----|-------------|---
>         ^             ^
>         |             |
>    level-aligned     level-aligned
>       GFN            GFN + level size - 1
> 
> 
> > For the EPT violation case, the guest is accepting a page.  Just split to the
> > guest's accepted level, I don't see any reason to make things more complicated
> > than that.
> This use case could reuse the kvm_mmu_try_split_huge_pages() API, except that we
> need a return value.

Just expose tdp_mmu_split_huge_pages_root(), the fault path only _needs_ to split
the current root, and in fact shouldn't even try to split other roots (ignoring
that no other relevant roots exist).

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9c26038f6b77..7d924da75106 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1555,10 +1555,9 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
        return ret;
 }
 
-static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
-                                        struct kvm_mmu_page *root,
-                                        gfn_t start, gfn_t end,
-                                        int target_level, bool shared)
+int tdp_mmu_split_huge_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
+                                 gfn_t start, gfn_t end, int target_level,
+                                 bool shared)
 {
        struct kvm_mmu_page *sp = NULL;
        struct tdp_iter iter;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index bd62977c9199..ea9a509608fb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -93,6 +93,9 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
                                   struct kvm_memory_slot *slot, gfn_t gfn,
                                   int min_level);
 
+int tdp_mmu_split_huge_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
+                                 gfn_t start, gfn_t end, int target_level,
+                                 bool shared);
 void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
                                      const struct kvm_memory_slot *slot,
                                      gfn_t start, gfn_t end,

> > And then for the PUNCH_HOLE case, do the math to determine which, if any, head
> > and tail pages need to be split, and use the existing APIs to make that happen.
> This use case cannot reuse kvm_mmu_try_split_huge_pages() without modification.

Modifying existing code is a non-issue, and you're already modifying TDP MMU
functions, so I don't see that as a reason for choosing X instead of Y.

> Or which existing APIs are you referring to?

See above.

> The cross_boundary information is still useful?
> 
> BTW: Currently, kvm_split_cross_boundary_leafs() internally reuses
> tdp_mmu_split_huge_pages_root() (as shown below).
> 
> kvm_split_cross_boundary_leafs
>   kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs
>     tdp_mmu_split_huge_pages_root
> 
> However, tdp_mmu_split_huge_pages_root() is originally used to split huge
> mappings in a wide range, so it temporarily releases mmu_lock for memory
> allocation for sp, since it can't predict how many pages to pre-allocate in the
> KVM mmu cache.
> 
> For kvm_split_cross_boundary_leafs(), we can actually predict the max number of
> pages to pre-allocate. If we don't reuse tdp_mmu_split_huge_pages_root(), we can
> allocate sp, sp->spt, sp->external_spt and DPAMT pages from the KVM mmu cache
> without releasing mmu_lock and invoking tdp_mmu_alloc_sp_for_split().

That's completely orthogonal to the "only need to maybe split head and tail pages".
E.g. kvm_tdp_mmu_try_split_huge_pages() can also predict the _max_ number of pages
to pre-allocate, it's just not worth adding a kvm_mmu_memory_cache for that use
case because that path can drop mmu_lock at will, unlike the full page fault path.
I.e. the complexity doesn't justify the benefits, especially since the max number
of pages is so large.

AFAICT, the only pre-allocation that is _necessary_ is for the dynamic PAMT,
because the allocation is done outside of KVM's control.  But that's a solvable
problem, the tricky part is protecting the PAMT cache for PUNCH_HOLE, but that
too is solvable, e.g. by adding a per-VM mutex that's taken by kvm_gmem_punch_hole()
to handle the PUNCH_HOLE case, and then using the per-vCPU cache when splitting
for a mismatched accept.

