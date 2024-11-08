Return-Path: <kvm+bounces-31332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AC91A9C27B8
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 23:45:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 21E02B22787
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 22:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283DF1F26E6;
	Fri,  8 Nov 2024 22:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LNGX66GS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E2A192D76
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 22:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731105919; cv=none; b=px7ZriOy9xAbyDonfnvJclvW40MoTNCFo7frLQoE/dgs3Mhg6Zu6vIHlYfHwW9MQPEVQldzU8PbzZOSow85Ez9YwOvdRNXM5cEFVv9EY31HEE/cQ16tb0PT09ID5DMKBdO+drFc+e5gaIo0Uo3bjnSysLrcQG58XMYnkHA6Fozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731105919; c=relaxed/simple;
	bh=VJOHr6pLH52nLdtup1E2zosFidmBhr4gFI+cehtqUZo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dxGv1+ZO0/p1w0m3SAqNFAox3Q5QBcuY7mjaIP/uFUnpfu120MLcASonZRy874p9ZYOCzjKL9PCNSwsd8XN/NZb2o9rKrCHkLbCcRZ16Z/inYq2oc7CxGysMa11nk4MTLvGcuzEru7gMMGjFaLkRXHREip5ual9b8kBR+9r5oII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LNGX66GS; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e3313b47a95so5357740276.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 14:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731105915; x=1731710715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k3xf4ICT1HLEEjjHW7v8PG1MES5H37LOIRN6Xle54KA=;
        b=LNGX66GStyinrepnCe9GJnZbAGz8SLAfua6zCeq8wRvYNX1Azbb/Sj6vWvnrBwBjWA
         HsXSk468lC0SkY3pliP7ZTVpHTo1LpBK7QVhRMxLjBifAZFji1keEsgophGKJ/M2uUSx
         tHmTzu0j9AVBllzff66rpoG3VJwCbbRrG5ReTmu5U8tufaIFCUReawR53cRYvtnoM4P9
         ssl1WPBSp+fIzKp0a+e+BPzqwhbnQ0FAEAbMF1TZel3dp56Pnspd8aEVfEe8LvEbAJM1
         IaSkPSM0SOI3hUv5Ztu1rTRds4959b7QtNOdERwrtf/kOgFMgyVUeC0OK0fKAolqZhgQ
         iQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731105915; x=1731710715;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k3xf4ICT1HLEEjjHW7v8PG1MES5H37LOIRN6Xle54KA=;
        b=H3KvKkfG9C44eSsA5gqrXY9IMIJLyVK4UVyynkIN1O97YRvD4Z3aOb4kk90LTBVZkL
         0G+mR9jR89o6feC3+m6M3/e4iCN/i+NIHzAhE2jzl2r6GDtdBGqcCmLns9StanqWGgi3
         H9dNTii9zMzMcwJnT9/xSf0yrAxaGXu4dHqTCRmJmf/cyk+a7oxwPzWl0ihuziZXAOrU
         Gjzka391jbT5f9r2eBP3h3sLvLfde5Ji+V6Ueh+iMCi2SQ1p+ox75XHB8BZl96UI45GE
         uEeAAtNqO7XevuccCmbscyv88Eh8l+gqSbObDAxlT0O4KqPiz4YZ6672+x0eeRTI4T0E
         C1RA==
X-Forwarded-Encrypted: i=1; AJvYcCVgRPZDqtdC8A7+YuWoiZi+eNaGWATWLjxnZpzboXiiM8O6fbGJdEBffoGc7T0AM8Q3Doc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1nBgbz0if0hvzcDEp7TbhRQLINmlYkcgwnhBwEGP5nMmRB8Vz
	uiXcolZKGABihipHsyyKyyRvVSeVQ3+xM/wpZSWAlG5RROmxbWOLNnhtcvO62imci8G1rKGrRsj
	DYQ==
X-Google-Smtp-Source: AGHT+IGCSVtE+1R9XBNFFNqX8pkttvkmLYFQyPVUgZrgW3CVTQDdGkU6v+To7f5XBAZcgJYJuQNBftfUplQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:bc84:0:b0:e2b:d0e9:1cdc with SMTP id
 3f1490d57ef6-e337f908f8dmr5594276.10.1731105915426; Fri, 08 Nov 2024 14:45:15
 -0800 (PST)
Date: Fri, 8 Nov 2024 14:45:13 -0800
In-Reply-To: <CADrL8HU3KzDxrLsxD1+578zG6E__AjK3TMCfs-nQAnqFTZM2vQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-5-jthoughton@google.com>
 <202411061526.RAuCXKJh-lkp@intel.com> <CADrL8HU3KzDxrLsxD1+578zG6E__AjK3TMCfs-nQAnqFTZM2vQ@mail.gmail.com>
Message-ID: <Zy6UefSlo8vwHxew@google.com>
Subject: Re: [PATCH v8 04/11] KVM: x86/mmu: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: kernel test robot <lkp@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, oe-kbuild-all@lists.linux.dev, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2024, James Houghton wrote:
> On Wed, Nov 6, 2024 at 3:22=E2=80=AFAM kernel test robot <lkp@intel.com> =
wrote:
> >
> > Hi James,
> >
> > kernel test robot noticed the following build warnings:
> >
> > [auto build test WARNING on a27e0515592ec9ca28e0d027f42568c47b314784]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/James-Houghton/K=
VM-Remove-kvm_handle_hva_range-helper-functions/20241106-025133
> > base:   a27e0515592ec9ca28e0d027f42568c47b314784
> > patch link:    https://lore.kernel.org/r/20241105184333.2305744-5-jthou=
ghton%40google.com
> > patch subject: [PATCH v8 04/11] KVM: x86/mmu: Relax locking for kvm_tes=
t_age_gfn and kvm_age_gfn
> > config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/202411=
06/202411061526.RAuCXKJh-lkp@intel.com/config)
> > compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20241106/202411061526.RAuCXKJh-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202411061526.RAuCXKJh-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >    arch/x86/kvm/mmu/tdp_mmu.c: In function 'kvm_tdp_mmu_age_spte':
> > >> arch/x86/kvm/mmu/tdp_mmu.c:1189:23: warning: ignoring return value o=
f '__tdp_mmu_set_spte_atomic' declared with attribute 'warn_unused_result' =
[-Wunused-result]
> >     1189 |                 (void)__tdp_mmu_set_spte_atomic(iter, new_sp=
te);
> >          |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~
> >
>=20
> Well, I saw this compiler warning in my latest rebase and thought the
> `(void)` would fix it. I guess the next best way to fix it would be to
> assign to an `int __maybe_unused`. I'll do for a v9, or Sean if you're
> going to take the series (maybe? :)), go ahead and apply whatever fix
> you like.

Heh, actually, the compiler is correct.  Ignoring the return value is a bug=
.
KVM should instead return immediately, as falling through to the tracepoint=
 will
log bogus information.  E.g. will show a !PRESENT SPTE, instead of whatever=
 the
current SPTE actually is (iter->old_spte will have been updating to the cur=
rent
value of the SPTE).

	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
				       iter->old_spte, new_spte);

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f5b4f1060fff..cc8ae998b7c8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1186,7 +1186,8 @@ static void kvm_tdp_mmu_age_spte(struct tdp_iter *ite=
r)
                 * It is safe for the following cmpxchg to fail. Leave the
                 * Accessed bit set, as the spte is most likely young anywa=
y.
                 */
-               (void)__tdp_mmu_set_spte_atomic(iter, new_spte);
+               if (__tdp_mmu_set_spte_atomic(iter, new_spte))
+                       return;
        }
=20
        trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,


