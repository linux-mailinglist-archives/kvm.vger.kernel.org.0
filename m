Return-Path: <kvm+bounces-36683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09597A1DD00
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29C6318842EA
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1691953BD;
	Mon, 27 Jan 2025 19:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WQZ8KxQV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACD818A922
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 19:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738007875; cv=none; b=gvCsF1spRRrzTEkCffQkTTyrLMv7Kz1HIbyUrhtxqppHV0hwLZAc5wgIBWcTWNL5XgK8gmSvZHWhlPE9A6rwQusDCEREiX8xNHVN5fd1Fa+Oh+FtCVou6/FfIl9XAp8kWWRQAr5KH3A2sfPPxqB/EwUnr7XR+as8RpotOWjgxXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738007875; c=relaxed/simple;
	bh=rCVoQ0kWD9ecrq4YQLFmB3J9K8uWgBwHN4sBLF+mnXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kf1WEmmP3gJG/5nvXrgX9NcuT5ZxTve2EK5eWzS7gETLU1IuQR+xoTX5vR4w8SFcusWZ0ldw1N0bv8RFThA5MGJ4g1vfNxpMuv3i7muBm7zO98E4ees2yC8HSAnLblHGxbmIREJqZF1NKW2hi4vwXdhND5oVZxsyJ/ZpuQQRKCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WQZ8KxQV; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e549be93d5eso8571230276.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 11:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738007873; x=1738612673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BD4W32nk1YfTXoTOZqM8TKMDtJ3bzb2MpD3C2Sm3Phk=;
        b=WQZ8KxQVVMQkpOMlDooD4NJCNOh9ggJypxVUE5oPitNqkoleu1T50PhiFH/MX+FefB
         wzIvjvQFFkFhM9nZxPQvgHvoJyG11d2tRuYAMFDkkxB5qvMQeIXoa1ddWletcPXESu6e
         yTMwzyZPvWAwO+x0bWDn4YvDuuHspm1TzEqft0ofQJTj3Q1FujiRQ0Olgt5rhUKEh4Ct
         Xr05TmLAAKaK3jY6Q7XZBcV2nNz0wQ6A2xOz8Xcvejxv4vNnxJTetwJpcWgF6GImee2i
         geUiuOpt6WNk9xyxcxcSO7YwGJxrtIPaCH/KGSrvSvdKGbagtHmNMF0G9RGvOcpVMuwa
         VD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738007873; x=1738612673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BD4W32nk1YfTXoTOZqM8TKMDtJ3bzb2MpD3C2Sm3Phk=;
        b=QvgDt88pK9ksqW0vkF31mNbzo52qP9wycjOV86inruKAFRUmxR6kB8EQ2C4Go2n7cM
         dE+9dRxd0IjFD7U01BVhnKV2TxvUKg3NDMjN4vSWPxEOQnbK2maZ5bvYGH3ks+boD6Ul
         ePnxuddI7HN8wg9oeyYqtvbNTiwWl95VjygjyPjIWT+MLY1p3jiOJIFcpcMDHcj+zjWW
         AVR9bda6DuMfRJ0j/9CUnApGlS/S4RvFKGDTREg894Lc7zie2gCh5roq+nP6IKMvyAt1
         Z30fjVwg4iTbfvTXaD3RpWDgTl4lmpRecof5sV4VAZgJJHlCvZb27MjzlbsE689h7cql
         6/Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUvAUCgjJxJCBAg1wX3bnIO1AxwkECXcFKLj5T1U67krIEupbLDiq76urDNaBpMP1YW/Ho=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrwM7+gQzj9JmmVen5rcp/iGz9bto4RXc3dnpf03UjD+2aMapZ
	5lPuJRqkULjDnyg8xC2raXXqOO6vNqtkOc6zgLCCaQjqRDQiDVsRJOZoRTpShcQVCbGqeCHDORp
	cU++Qxu7FmlgeN5mxgQt76J3lyvdW0aRFkU7F
X-Gm-Gg: ASbGncsZy+u22veRrO8uTCKP2nNJOlYHny31fIKIAEE113raKv5N9dz7gWhE/M2M6op
	+RMg+R0h26iwo/Fryw87tJLP8bsluq6BxqANxjDmq7pW0h6PMATEh0q9y4umMBgIIHDpf+fJT9R
	EjAGhVXgm6VNPAeVmj
X-Google-Smtp-Source: AGHT+IFGms+4LOqbZa5UorMJu4dRQMEmjcaqJrd6Tjl7RAbiXRTligBW6OnPplM/pHrZqruSmAgAluHugFoIARFeMDw=
X-Received: by 2002:a05:690c:314:b0:6ef:5abd:d0d with SMTP id
 00721157ae682-6f6eb510b15mr313157307b3.0.1738007873042; Mon, 27 Jan 2025
 11:57:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-5-jthoughton@google.com>
In-Reply-To: <20241105184333.2305744-5-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 11:57:17 -0800
X-Gm-Features: AWEUYZnwv933RnIxGpbsFF-SomVviIpqxjKxJHPN1nWZKzl8FvqiyhQqT7HvIho
Message-ID: <CADrL8HV3nNaKXkhX5zC2hN5+44AOZtoCvL83_x8kbkTVB3rHhg@mail.gmail.com>
Subject: Re: [PATCH v8 04/11] KVM: x86/mmu: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yu Zhao <yuzhao@google.com>, Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Venkatesh Srinivas <venkateshs@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 10:43=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
>  static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4508d868f1cd..f5b4f1060fff 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -178,6 +178,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct=
 kvm *kvm,
>                      ((_only_valid) && (_root)->role.invalid))) {        =
       \
>                 } else
>
> +/*
> + * Iterate over all TDP MMU roots in an RCU read-side critical section.
> + */
> +#define for_each_valid_tdp_mmu_root_rcu(_kvm, _root, _as_id)            =
       \
> +       list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)  =
       \
> +               if ((_as_id >=3D 0 && kvm_mmu_page_as_id(_root) !=3D _as_=
id) ||     \
> +                   (_root)->role.invalid) {                             =
       \
> +               } else
> +

Venkatesh noticed that this function is unused in this patch. This was
a mistake in the latest rebase. The diff should have been applied:

@@ -1192,15 +1206,15 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm =
*kvm,
        struct tdp_iter iter;
        bool ret =3D false;

+       guard(rcu)();
+
        /*
         * Don't support rescheduling, none of the MMU notifiers that funne=
l
         * into this helper allow blocking; it'd be dead, wasteful code.  N=
ote,
         * this helper must NOT be used to unmap GFNs, as it processes only
         * valid roots!
         */
-       for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
-               guard(rcu)();
-
+       for_each_valid_tdp_mmu_root_rcu(kvm, root, range->slot->as_id) {
                tdp_root_for_each_leaf_pte(iter, root, range->start,
range->end) {
                        if (!is_accessed_spte(iter.old_spte))
                                continue;

This bug will show up as a LOCKDEP warning on CONFIG_PROVE_RCU_LIST=3Dy
kernels, as list_for_each_entry_rcu() is called outside of an RCU
read-side critical section.

