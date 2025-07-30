Return-Path: <kvm+bounces-53757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F57B16810
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 23:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A05EC18C5A92
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 21:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A06223DD9;
	Wed, 30 Jul 2025 21:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v2ehqj2B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFED1FBCB0
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 21:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753909885; cv=none; b=pAE2AYP7eVtV7U/4B91Mlop6EVvS3lb3rl2avW1SFDjmE9p4noQGicJ8EEDuY+FVkX9j6tRo+No2vJVJexxRDYUo61b/fC9JWKObqJEyITpfxIX3nsEUpmnrD/CFoAhA0xmR3B6vN5+oxA8FBaeZDh/zQEMLmHECN8SSGNcysG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753909885; c=relaxed/simple;
	bh=cVmFzsj3OpZTUi6FUzCWejRWJRm0o5ncvOdXgEoC+OE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ReUV5EJVsiVDcTKFfNKqjL9w5OzcRaZnoegzyGmWzA4HAQyNkhTFFtqN/3HI79HbrsfBNd+Et9BJ9Nqxzd5rz3tGjb9gKwayMhwQlOFMU87NLb6RHeJH/cj79LS9PaudgoF9pCrm2h5svAcEygtKPMEUQNPZrPt8AEhME8+ABGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v2ehqj2B; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b421892319cso149095a12.1
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 14:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753909882; x=1754514682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zcr0HAZVJL/wPM68//kB0QFOkcy4cqNgVvPP1uhkVrY=;
        b=v2ehqj2B8kahSbPAjtrhq5Gx5GsOrGx4NGAKgBnFM3FtBEeVNMzmrReJ1SZiUBwo4b
         BjzMoWUFhUCet1vUOyls2ea5sfZP2KAjHxx9jsd6bdsEbFbtCxNTcvCoH72E47N6lO1s
         kpUyDc9TvCit4qnrUg7hY2ApCIoYSII+OJUx/W52Y3wlKKTAJGgLSH7ovOjNWcjKIjU7
         rrJrxI4BheB3UzExcRZlYFCrzrNHyYlsaKSMtK/mupgD7Txg27UTsd0wbb1yikRd0F1K
         lHTPkXuey0ZNeqFquA1YjUmyJTEQLiSfmR0gW0cvUUNWVHQdSmPAYymdZYWbxdk0MP8W
         E+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753909882; x=1754514682;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zcr0HAZVJL/wPM68//kB0QFOkcy4cqNgVvPP1uhkVrY=;
        b=FgId6N/6EPx0rO2OuQN7PywZcVBsdbI1p1de5fWJ7uD4GeMb0IRKcn/op8xtdJwEc6
         djqFXK+jg2vXzgY1Dh5jZiojk0SeDDYX6MYOMPO1rllnBhUBBTDPqj5uTlKKSb4oDGGZ
         6QWEOZGqiVnb0hPR2WldpONbP+DJOodWsxCW/1RfLzz7PhxlCm1CkUpHvQNRcIGnl2Nw
         lpoBRGrlmb+Z5jRiPngLBeSgi2Buh0LPYyV6CTsr9U/GccBWAf7BS4KmgLymZKFdfZGH
         DImoD8uYElm2EX/7AQgFBkjNrEAwlAxnELICuOQZu/Eo2y0XuYE5L2hljsXBHD667mb3
         T72Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8q8bCOlPWM6iTLSD7+30fFjkPZ040Cs44gEWziR/5GP9pp+fjUkrEhQo+QdrUd5GTmNM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1SToLPp2WdtpXAbXSqoMMK5BSgtP1gSyhBI0avIZdY8N8QHQ7
	FRdRwLP/vS2zoemr2qsL7pCz2nntKkLbaSk1WuOeUfEOUYdJ63imF/W0grxHLrpUQNKOGJVzbJk
	d5fz8DbWlRH6oGjUn9+3JRQ==
X-Google-Smtp-Source: AGHT+IH81SELHZh+GPX7YKucdrOrQjsD2qC5Y2tfTvaMHB5OVH1Y4cxqU+ojrj5t1POmR4E8onsMP+EV8Hr7rDZV
X-Received: from pgmb10.prod.google.com ([2002:a63:1b4a:0:b0:b3b:d2a0:df40])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:12d3:b0:234:216b:cf98 with SMTP id adf61e73a8af0-23dc0e8609fmr7392654637.35.1753909881916;
 Wed, 30 Jul 2025 14:11:21 -0700 (PDT)
Date: Wed, 30 Jul 2025 21:11:18 +0000
In-Reply-To: <20250618042424.330664-6-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-6-jthoughton@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250730211120.4163536-1-jthoughton@google.com>
Subject: Re: [PATCH v3 05/15] KVM: x86: Add support for KVM userfault exits
From: James Houghton <jthoughton@google.com>
To: jthoughton@google.com
Cc: amoorthy@google.com, corbet@lwn.net, dmatlack@google.com, 
	kalyazin@amazon.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, seanjc@google.com, 
	wei.w.wang@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 9:24=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Only a few changes are needed to support KVM userfault exits on x86:
>
> 1. Adjust kvm_mmu_hugepage_adjust() to force pages to be mapped at 4K
> =C2=A0 =C2=A0while KVM_MEM_USERFAULT is enabled.
> 2. Return -EFAULT when kvm_do_userfault() when it reports that the page
> =C2=A0 =C2=A0is userfault. (Upon failure to read from the bitmap,
> =C2=A0 =C2=A0kvm_do_userfault() will return true without setting up a mem=
ory fault
> =C2=A0 =C2=A0exit, so we'll return a bare -EFAULT).
>
> For hugepage recovery, the behavior when disabling KVM_MEM_USERFAULT
> should match the behavior when disabling KVM_MEM_LOG_DIRTY_PAGES; make
> changes to kvm_mmu_slot_apply_flags() to recover hugepages when
> KVM_MEM_USERFAULT is disabled.
>
> Signed-off-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

This patch fails to remove the WARN in recover_huge_pages_range(). The
diff below will be applied to the next version of this patch, whenever it
comes.

This WARN can be hit by enabling KVM_MEM_LOG_DIRTY_PAGES and
KVM_MEM_USERFAULT, then disabling KVM_MEM_USERFAULT.

I've been having offline discussions with Sean about this series; I'm
waiting for him to rework the KVM_GENERIC_PAGE_FAULT bits. I'll dedicate
some more time to the QEMU side of things too.

Thanks.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1f..2d83ddb233a9a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1779,7 +1779,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
 	u64 huge_spte;
 	int r;
=20
-	if (WARN_ON_ONCE(kvm_slot_dirty_track_enabled(slot)))
+	if (kvm_slot_dirty_track_enabled(slot))
 		return;
=20
 	rcu_read_lock();

