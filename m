Return-Path: <kvm+bounces-13400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E55B1895ED3
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 23:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D09C1C244C2
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 21:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C68415E5D9;
	Tue,  2 Apr 2024 21:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GHylZesS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDA615E5D5
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 21:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712093824; cv=none; b=NvATljjlb83OruLig/H2nlajgzeIepWk9+ZrU2SYUPVaxXBMZlNIfvgXr/nThek0ajCS4H5fVp4mPkJU9whD7APSRcM4hpqeSe7hurb1Krm9RoGnqgMCRKBT9x/8/DS753SByXy2iBjykbX3BB+EYbfA6A102HMOYnzeM+xKZ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712093824; c=relaxed/simple;
	bh=E6tG90k1iNeBh8VAlo6f3lun9gyxfGsIogBSxv06NO0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Mi/ox8xV6KiaZA2LngQNPfstURbZwifE6aWs13TiOYQqJeRW2JuOHmmEBA4EOPgGGUuYhyoLYZTthAbvE69CAAR3uUJU+sXLL1IMwGJNI9Aj/sjA5Bpc/N8flZ8LSJCzI8uf+kheM+5SAu8sMKIpqQkbtQ+B5sesMm0YAyq0XmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GHylZesS; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a20c33f06so65234137b3.2
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 14:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712093821; x=1712698621; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wMJAkhavDDMxybE735uuw66TAkIC9TkbFyNgBhbGt7E=;
        b=GHylZesSjkA6NJp7nNl4V1MqGlKzWKu69aVgzROUIqlwcqu4Az5lhTDJOnYBuXqosx
         y0dDNWoWHFZ0tIDRHHMi0ZtBRBSOUnobNlwV/jYYcdHAtZ40KJ+1I5iVuCJ0EZTIfVD7
         104A5ABDqepa5QzdF/9BV6mve7oaJq15XlFMs1R8AHKzoEXeYJzpOUQRswPn0AeypaLc
         NWa+LrVlk/fdYRy7tS+FTWYfoCSbk7Rk/po7R9YvTINRn5uPNAok+fGJCkGuHcHC02GL
         Z7OFBhpzWhnlbaSyAAOxKyjgDGE2oFW7YqHRT8MDZSYOzHMcvob8D9jQ1eLVuAXmgt11
         3pOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712093821; x=1712698621;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wMJAkhavDDMxybE735uuw66TAkIC9TkbFyNgBhbGt7E=;
        b=FJnJohtIxM/5bzPg7FMrPwMa7grTRMJN8Att1+rN2dT9ArZO0xrbjHetLq4t8sKNOa
         4ZlvjK0a9yRjumuj981jS/DKRV9Ht0QU9CzIV3rzmJ2A2gfT6EvkiTzUOuG2fk/FJsWP
         TqqeOdpVacpOt3IHDynZaWSmJFYqt3SoqZvUKTQSK8EVHNZAdMc+0ittZUBs/8E8EmNG
         bZTKN7G7lC2wmMQs8/eie3z395w82c2ZTGol5Vv9YEQ1I1c4SXEn1n8otqEWwpK1J4eW
         0WVSw72OYaaE4a9PjxpQCrE/hO+2v+QVHRsSXJJKFyKMWAtdsXEtTtWevXt6tRzcrDjx
         Tzjg==
X-Gm-Message-State: AOJu0YzmjPpJ5GN2zolxjwnmtJYGFO/SBQvkpKO2OEnRPv/mXqaHg55r
	sI1yP7G2GvaxYkKZIBcK72uhBwSywussAWA7lSKhM2me3LhEPcyYW04MdYbzzIqZxx+piQw5C0P
	ewZXi+m+8Bg==
X-Google-Smtp-Source: AGHT+IHHdMSye5n0Ll5L+vBRM+o0sPguUS34mMP+Pz2VICxQ7XVCEF8BDDseIvlIT0MwdKN8vBlDszcYp2L6FQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:a9a:b0:615:5113:9d3f with SMTP
 id ci26-20020a05690c0a9a00b0061551139d3fmr128276ywb.4.1712093821684; Tue, 02
 Apr 2024 14:37:01 -0700 (PDT)
Date: Tue,  2 Apr 2024 14:36:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240402213656.3068504-1-dmatlack@google.com>
Subject: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG to avoid
blocking other threads (e.g. vCPUs taking page faults) for too long.

Specifically, change kvm_clear_dirty_log_protect() to acquire/release
mmu_lock only when calling kvm_arch_mmu_enable_log_dirty_pt_masked(),
rather than around the entire for loop. This ensures that KVM will only
hold mmu_lock for the time it takes the architecture-specific code to
process up to 64 pages, rather than holding mmu_lock for log->num_pages,
which is controllable by userspace. This also avoids holding mmu_lock
when processing parts of the dirty_bitmap that are zero (i.e. when there
is nothing to clear).

Moving the acquire/release points for mmu_lock should be safe since
dirty_bitmap_buffer is already protected by slots_lock, and dirty_bitmap
is already accessed with atomic_long_fetch_andnot(). And at least on x86
holding mmu_lock doesn't even serialize access to the memslot dirty
bitmap, as vCPUs can call mark_page_dirty_in_slot() without holding
mmu_lock.

This change eliminates dips in guest performance during live migration
in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested with
1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, which
would also reduce contention on mmu_lock, but doing so will increase the
rate of remote TLB flushing. And there's really no reason to punt this
problem to userspace since KVM can just drop and reacquire mmu_lock more
frequently.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anup Patel <anup@brainfault.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
v2:
 - Rebase onto kvm/queue [Marc]

v1: https://lore.kernel.org/kvm/20231205181645.482037-1-dmatlack@google.com/

 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb49c2a60200..0a8b25a52c15 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2386,7 +2386,6 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
 
-	KVM_MMU_LOCK(kvm);
 	for (offset = log->first_page, i = offset / BITS_PER_LONG,
 		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
 	     i++, offset += BITS_PER_LONG) {
@@ -2405,11 +2404,12 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 		*/
 		if (mask) {
 			flush = true;
+			KVM_MMU_LOCK(kvm);
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
+			KVM_MMU_UNLOCK(kvm);
 		}
 	}
-	KVM_MMU_UNLOCK(kvm);
 
 	if (flush)
 		kvm_flush_remote_tlbs_memslot(kvm, memslot);

base-commit: 9bc60f733839ab6fcdde0d0b15cbb486123e6402
-- 
2.44.0.478.gd926399ef9-goog


