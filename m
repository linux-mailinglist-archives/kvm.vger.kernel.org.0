Return-Path: <kvm+bounces-24549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE8395734A
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 20:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31FFD281F40
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 18:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE7D1898F6;
	Mon, 19 Aug 2024 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GVlnf8jq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1089F4642D
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 18:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724092287; cv=none; b=G9pMLgccDBdOXCPkZzMvLawW/xhjkaJr76VV1l4ZZMsRP37OdDQ+3/HG6zvPGDo69T1FSyYqbACHvS5qW54eB45AEHCep407lsItrRV4XewiW8FY4x/7dQPes9FtLCXv5XlfMQtF5Fe4J0aRocPMy1PFidLo7ol9DYhFGZkUjhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724092287; c=relaxed/simple;
	bh=ZrWC8ayVISMEQlXc1POjz6UYuqoV+ZvS6YR7eJJYJC0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kirIshYcW8VPRADpPnAriwH/cj5rA1Ve2TBmdfncNwPF4R+lxngpbNNim91gVd0GPVC5ggvTpe3magqF20Vy8AvOjMsxC6Oy/Kuai2T4vqO40YHM65F50veF1xY1IqYEnDDlfHzVs6kzX247MxNSshA0689Nn8rktmykUZRmS8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GVlnf8jq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-713d24cf706so2362938b3a.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 11:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724092284; x=1724697084; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sZh6vj+JVTE3khn4nIDCIHCY6ZVRQDK1Dqe9+u7egds=;
        b=GVlnf8jq0VrrH0+8J7j+bLiEkyzgaLRE6UwGa3mfSTZhZ78oFwB0uSk2qfLEmEkDwD
         HbwXyY9BRjCE4M15se7FCG0mCQA2GgUfE8AGoCsVfbchaNWHSf4fbPoolmgJ9awSTLHO
         2DFE2nmNHm5jzsVEi+ubf33I9hsI8wl6TfwjI87MmYHMGXYqEfQo16Iv2Tb/eWdISQ2l
         G2qk1D0MPeWeoj85V8o1Qd6lgZUF33TflHahBCUXWe0JHukfcR6c9zV/jUFRHi5Tulo1
         c6Ycc12Fa6hbCwvej2wSZEFM40WfogKNW9br/v5rYCRYvCGzmS/00A2dgMXMb8RExWcB
         /hOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724092284; x=1724697084;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sZh6vj+JVTE3khn4nIDCIHCY6ZVRQDK1Dqe9+u7egds=;
        b=b7wcu5/EEabmb8djd00sMnQKApFQGZuHJZ6GY3A1FgbHdy+zfm8BPbuzYbEMCUycEA
         WhFOxIQQnIu/dciv6OYXjLvua4QoEanJ4xdy1ecA4R1Qm4+JCn9wrvC/ygc5PpMQWFcV
         h9yRGZZQIXD4XqX7BIn94FBMTa2dFaP6gQxFwQVTsJD/+xha5wu+gW9Nh5KBgbjz3cgr
         mJA/dD0ecEtu5pfBz0bCQiLOQp9AoZjE4CF9J88qpZ4+bXq5usbre0mCV0J06jEhUI5W
         QZ0yGYGThpam7eZ1jX14GsE1kCL/6J7fVphLBh6yQWi3blC4bMa6Ys08BoySpOdGokig
         tw3w==
X-Forwarded-Encrypted: i=1; AJvYcCWvv7umm9Jy/EO769xrab7Owv8JW2ahofHe9TNM3ChF/RUhYU33f5Iaa2cQUqjDG14JduQcjKyBjsqbfCjS6+76Yx/k
X-Gm-Message-State: AOJu0YyuSJaL0UqLsJU508cyUU9qBlKHxLl4zCv7X67XxW6Pk548oENQ
	d+IawFnn8zmGhO23AQPe2d7rByiU/GEyBGAs2SuYwkRVUxN5ovBXwAj2tFiAaa9FSBcfmI016Ym
	4JQ==
X-Google-Smtp-Source: AGHT+IGh8K54hv69rMrUmGxS9qgHX1Rbw16YYeuCjshOKbnSVF1r4Y1OnJ+4xCX8qHN+pt3Ztbq09K0kinA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8145:0:b0:710:4d4d:5ef1 with SMTP id
 d2e1a72fcca58-713c525b48bmr45627b3a.4.1724092284136; Mon, 19 Aug 2024
 11:31:24 -0700 (PDT)
Date: Mon, 19 Aug 2024 11:31:22 -0700
In-Reply-To: <CALzav=cFPduBR4pmgnVrgY6q+wufTn_nS-4QDF4yw8uGQkV41Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812171341.1763297-1-vipinsh@google.com> <20240812171341.1763297-2-vipinsh@google.com>
 <Zr_gx1Xi1TAyYkqb@google.com> <20240819172023.GA2210585.vipinsh@google.com> <CALzav=cFPduBR4pmgnVrgY6q+wufTn_nS-4QDF4yw8uGQkV41Q@mail.gmail.com>
Message-ID: <ZsOPepvYXoWVv-_D@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Split NX hugepage recovery flow into
 TDP and non-TDP flow
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2024, David Matlack wrote:
> On Mon, Aug 19, 2024 at 10:20=E2=80=AFAM Vipin Sharma <vipinsh@google.com=
> wrote:
> >
> > On 2024-08-16 16:29:11, Sean Christopherson wrote:
> > > On Mon, Aug 12, 2024, Vipin Sharma wrote:
> > > > +   list_for_each_entry(sp, &kvm->arch.possible_nx_huge_pages, poss=
ible_nx_huge_page_link) {
> > > > +           if (i++ >=3D max)
> > > > +                   break;
> > > > +           if (is_tdp_mmu_page(sp) =3D=3D tdp_mmu)
> > > > +                   return sp;
> > > > +   }
> > >
> > > This is silly and wasteful.  E.g. in the (unlikely) case there's one =
TDP MMU
> > > page amongst hundreds/thousands of shadow MMU pages, this will walk t=
he list
> > > until @max, and then move on to the shadow MMU.
> > >
> > > Why not just use separate lists?
> >
> > Before this patch, NX huge page recovery calculates "to_zap" and then i=
t
> > zaps first "to_zap" pages from the common list. This series is trying t=
o
> > maintain that invarient.

I wouldn't try to maintain any specific behavior in the existing code, AFAI=
K it's
100% arbitrary and wasn't written with any meaningful sophistication.  E.g.=
 FIFO
is little more than blindly zapping pages and hoping for the best.

> > If we use two separate lists then we have to decide how many pages
> > should be zapped from TDP MMU and shadow MMU list. Few options I can
> > think of:
> >
> > 1. Zap "to_zap" pages from both TDP MMU and shadow MMU list separately.
> >    Effectively, this might double the work for recovery thread.
> > 2. Try zapping "to_zap" page from one list and if there are not enough
> >    pages to zap then zap from the other list. This can cause starvation=
.
> > 3. Do half of "to_zap" from one list and another half from the other
> >    list. This can lead to situations where only half work is being done
> >    by the recovery worker thread.
> >
> > Option (1) above seems more reasonable to me.
>=20
> I vote each should zap 1/nx_huge_pages_recovery_ratio of their
> respective list. i.e. Calculate to_zap separately for each list.

Yeah, I don't have a better idea since this is effectively a quick and dirt=
y
solution to reduce guest jitter.  We can at least add a counter so that the=
 zap
is proportional to the number of pages on each list, e.g. this, and then do=
 the
necessary math in the recovery paths.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 94e7b5a4fafe..3ff17ff4f78b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1484,6 +1484,8 @@ struct kvm_arch {
         * the code to do so.
         */
        spinlock_t tdp_mmu_pages_lock;
+
+       u64 tdp_mmu_nx_page_splits;
 #endif /* CONFIG_X86_64 */
=20
        /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 928cf84778b0..b80fe5d4e741 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -870,6 +870,11 @@ void track_possible_nx_huge_page(struct kvm *kvm, stru=
ct kvm_mmu_page *sp)
        if (!list_empty(&sp->possible_nx_huge_page_link))
                return;
=20
+#ifdef CONFIG_X86_64
+       if (is_tdp_mmu_page(sp))
+               ++kvm->arch.tdp_mmu_nx_page_splits;
+#endif
+
        ++kvm->stat.nx_lpage_splits;
        list_add_tail(&sp->possible_nx_huge_page_link,
                      &kvm->arch.possible_nx_huge_pages);
@@ -905,6 +910,10 @@ void untrack_possible_nx_huge_page(struct kvm *kvm, st=
ruct kvm_mmu_page *sp)
        if (list_empty(&sp->possible_nx_huge_page_link))
                return;
=20
+#ifdef CONFIG_X86_64
+       if (is_tdp_mmu_page(sp))
+               --kvm->arch.tdp_mmu_nx_page_splits;
+#endif
        --kvm->stat.nx_lpage_splits;
        list_del_init(&sp->possible_nx_huge_page_link);

