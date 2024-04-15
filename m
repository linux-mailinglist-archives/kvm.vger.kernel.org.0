Return-Path: <kvm+bounces-14677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 932E88A5906
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:20:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4829F281AFB
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 17:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C7D82D7C;
	Mon, 15 Apr 2024 17:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mf+g+9ZD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DAA2231F
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 17:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713201641; cv=none; b=TXotKHuY7dcrfkMoypzz5yMcA5tWF/7kXJ5mnDY11Z5PQnT0XshHCtFbBXgDDYmyOk2b1OHLlrcyI3CY3jlDY7KXf1L14YBJvEZSsSjz6AdjxHLsagnjYY6a8v1vm6RYBkSMMLGDN0AcQlhBIrVlF7YZhn/y1CVBsHDrhlq9Xsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713201641; c=relaxed/simple;
	bh=+XWBi++iNcZXJyax7xDLP2jxvwA7Uq5vAaC/wt7NaEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0TqdykX+DsYLhxU9N8pqYqBVaSne7Mcjp2XcouYjiw9RxYxk4y3wAj6XW6TftsWMdZWU2+ndUaZONiCK3Pe3sYGcEFyrihlJ+DNiWawVGQUKgC7Mm1AkqsjrMoXL49z4suVb+q5T5Pu47tcGcBr2kb8043IzS4AIQAhUguRqQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mf+g+9ZD; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5e42b4bbfa4so2027639a12.1
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 10:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713201639; x=1713806439; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7hpM39MWVFRUarD8XnpDjEbdNkHF9QWFz+ZHhRbPMdQ=;
        b=mf+g+9ZDz5RwKiphwupr8ycf1sPyY+TmLqro+f15PFLNQXh/1NB7+JMGH/HsQXgNrM
         hGW0jQ5HXi/sWf9YFjdGv6OwLyE17V9EP+KACKlth/NP0EY5qPA9HHSdBm8xPu4qxECN
         PHXAYb30PMyoJwXrUfERonNGnk2YzeJJ4kN46qIX852QTZYFb2uEKdGhW5Z3VeOrPA33
         GfynDvN6glRuascYLfuC+OMpAeskAVgt8XYDmAFpRt1iOy/gecm9UKG9dUstx15qYGfZ
         r7M2Iw0ChlG4AVbqdLL68JSm3ftzd6tEHTnUJkS0cCPZWtvCLqL0a+tggLI4rSkyHcdZ
         YnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713201639; x=1713806439;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7hpM39MWVFRUarD8XnpDjEbdNkHF9QWFz+ZHhRbPMdQ=;
        b=RkWdWEXc35cmPcPhjM9dPbX2Dwt3UCxWaefZfq1iecN3DkSPzSGmMZ891syPhZAenC
         aakbh/9Vi2qlXO9rQOV74vCJv9RXUDL8yvI28LDUxjirtoM3a2cArh+Os2pmxZvFeTR4
         mDDodiMrfcagnCRRXf4PNhUqYKwb1hVt78L9YWQrj3CeHD8DeQysChBn+6c4LUlezqdo
         /d9SVLSMwY5OZutiyE4W2SyQP/As28q/Uk1klbFH6wrJqyuG9wYbqnazwhIe6lW+Ft+R
         uB1OjMUoKBCtxNgbPJWtd4b7SaPGUHOBmJcynCg+un3oiGf/2lAsCODfkMn4JZO3TR5e
         rQKg==
X-Forwarded-Encrypted: i=1; AJvYcCVw6SmN3C/xMih5arC9Flg1i+cjV1yq6cyxH89GpoiRB+dwONs1bLC0Oitzt5cOnP0jfSt/aBb4d9H2eBrtaU8V2FR4
X-Gm-Message-State: AOJu0Yw9F8Qw1RpIkOPotowvOFpuze5C6rEvQI9dxXEig/h2qKfvmGNr
	X4/6YSbq3RWoG/nfRf1OKAgYubQKu4o0nJy4/BN1aBAUC2QlbF6w5xYB1qe77A==
X-Google-Smtp-Source: AGHT+IHztxxvOMhAxFHc0hYYt/0pGloFffazHYlbvbVcNhnvVZ1jlNIast5QsbzSe4/E1Ahj+MozwQ==
X-Received: by 2002:a17:90a:aa84:b0:2aa:48a6:5af6 with SMTP id l4-20020a17090aaa8400b002aa48a65af6mr1453078pjq.25.1713201639361;
        Mon, 15 Apr 2024 10:20:39 -0700 (PDT)
Received: from google.com (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with ESMTPSA id az21-20020a17090b029500b002a0187d84f0sm7480255pjb.20.2024.04.15.10.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 10:20:38 -0700 (PDT)
Date: Mon, 15 Apr 2024 10:20:34 -0700
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during
 CLEAR_DIRTY_LOG
Message-ID: <Zh1h4gfOpImWHQsC@google.com>
References: <20240402213656.3068504-1-dmatlack@google.com>
 <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
 <Zg7fAr7uYMiw_pc3@google.com>
 <CALzav=cF+tq-snKbdP76FpodUdd7Fhu9Pf3jTK5c5=vb-MY9cQ@mail.gmail.com>
 <Zg7utCRWGDvxdQ6a@google.com>
 <CALzav=coESqsXnLbX2emiO_P12WrPZh9WutxF6JWWqwX-6RFDg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=coESqsXnLbX2emiO_P12WrPZh9WutxF6JWWqwX-6RFDg@mail.gmail.com>

On 2024-04-12 09:14 AM, David Matlack wrote:
> On Thu, Apr 4, 2024 at 11:17 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Apr 04, 2024, David Matlack wrote:
> > > > I don't love the idea of adding more arch specific MMU behavior (going the wrong
> > > > direction), but it doesn't seem like an unreasonable approach in this case.
> > >
> > > I wonder if this is being overly cautious.
> >
> > Probably.  "Lazy" is another word for it ;-)
> >
> > > I would expect only more benefit on architectures that more aggressively take
> > > the mmu_lock on vCPU threads during faults. The more lock acquisition on vCPU
> > > threads, the more this patch will help reduce vCPU starvation during
> > > CLEAR_DIRTY_LOG.
> > >
> > > Hm, perhaps testing with ept=N (which will use the write-lock for even
> > > dirty logging faults) would be a way to increase confidence in the
> > > effect on other architectures?
> >
> > Turning off the TDP MMU would be more representative, just manually disable the
> > fast-path, e.g.
> 
> Good idea. I'm actually throwing in some writable module parameters
> too to make it easy to toggle between configurations.
> 
> I'll report back when I have some data.

tl;dr

 * My patch likely _will_ regress migration performance on other architectures.
   Thank you Bibo and Sean for keeping me honest here.

 * I suspect the original issue my patch is trying to fix is actually specific
   to the way the TDP MMU does eager page splitting and a more targeted fix is
   warranted.

---

To evaluate my patch I tested on x86 with different mmu_lock configurations
to simulate other architectures.

 Config 1: tdp_mmu=Y fast_page_fault_read_lock=N eager_page_split=Y
 Config 2: tdp_mmu=Y fast_page_fault_read_lock=Y eager_page_split=Y
 Config 3: tdp_mmu=N fast_page_fault_read_lock=N eager_page_split=N

Note: "fast_page_fault_read_lock" is a non-upstream parameter I added to
add a read_lock/unlock() in fast_page_fault().

Config 1 is vanilla KVM/x86. Config 2 emulates KVM/arm64. Config 3 emulates
LoongArch if LoongArch added support for lockless write-protection fault
handling.

The test I ran was a Live Migration of a 16VCPU 64GB VM running an aggressive
write-heavy workload. To compare runs I evaluated 3 metrics:

 * Duration of pre-copy.
 * Amount of dirty memory going into post-copy.
 * Total CPU usage of CLEAR_DIRTY_LOG.

The following table shows how each metric changed after adding my patch to drop
mmu_lock during CLEAR_DIRTY_LOG.

          | Precopy Duration | Post-Copy Dirty | CLEAR_DIRTY_LOG CPU
 ---------|------------------|-----------------|---------------------
 Config 1 | -1%              | -1%             | +6%
 Config 2 | -1%              | +1%             | +123%
 Config 3 | +32%             | +158%           | +5200%

Config 2 and 3 both show regressions, with Config 3 severely regressed in all 3
dimensions.

Given these regressions, I started rethinking the original issue this patch is
trying to fix.

The dips in guest performance during CLEAR_DIRTY_LOG occurred during the first
pre-copy pass but not during subsequent passes. One thing unique to the first
pass is eager page splitting.

Ah ha, a theory! The TDP MMU allocates shadow pages while holding the mmu_lock
during eager page splitting and only drops the lock if need_resched=True or a
GFP_NOWAIT allocation fails. If neither occurs, CLEAR_DIRTY_LOG could potential
hold mmu_lock in write-mode for a long time.

Second, the host platform where we saw the dips has nx_huge_pages=Y. I suspect
the long CLEAR_DIRTY_LOG calls are blocking vCPUs taking steady-state
faults for NX Huge Pages, causing the dips in performance.

This theory also explains why we (Google) haven't seen similar drops in guest
performance when using !manual-protect, as in that configuration the TDP MMU
does eager page splitting under the read-lock instead of write-lock.

If this is all true, then a better / more targeted fix for this issue would be
to drop mmu_lock in the TDP MMU eager page splitting path. For example, we
could limit the "allocate under lock" behavior to only when the read-lock is
held, e.g.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7dfdc49a6ade..ea34f8232d97 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1472,9 +1472,11 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
         * If this allocation fails we drop the lock and retry with reclaim
         * allowed.
         */
-       sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, nid);
-       if (sp)
-               return sp;
+       if (shared) {
+               sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, nid);
+               if (sp)
+                       return sp;
+       }

        rcu_read_unlock();

I checked the KVM/arm64 eager page splitting code, and it drops the mmu_lock to
allocate page tables. So I suspect no fix is needed there and this is, in fact,
purely and x86-specific issue.

