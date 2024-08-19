Return-Path: <kvm+bounces-24547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C548957226
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 19:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 800661C2126E
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 17:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7495C18756D;
	Mon, 19 Aug 2024 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XpN4KG0k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAF9446A1
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724088545; cv=none; b=lCQQbpPApVifDIpQNheUOVofPQfRruNj+64kvNaVr860PD7j3U7Ihu3XtrWzFgKYWrKd2yQGp8e0cPZC15GUE/ntrZEPw7RcHc3NDyosLEKmvafe2dgWs3UkAdPPfWZkGjQJqS6ubROvdVj2hvoaz9qHlj8TGid/lmoHRLRyXFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724088545; c=relaxed/simple;
	bh=454QMfBtiOfDLI3BVvVSyUbm3Tw1viG1/YcSujs389Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f2PNNQ5/hF5SEiN9u1dz86LRRGG5ZAawV4Cyl/SS92jRlU3QLvxY+ZRuzct6OSxfntDyZnJE9z2QxGmz+JrrC0baUDGV3a43hosq/leBwHATkWE0O4aFzzZabF8FxSBfXl3yIagajFgShrmKVGajvKrEwMNI71FAqWnU2fQQfnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XpN4KG0k; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37186c2278bso2602461f8f.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 10:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724088542; x=1724693342; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gI0RYGpSNPTo6JqkQ6a41zlNkjmfuHjvoCMeMlyi8rY=;
        b=XpN4KG0klckoGMDM4s6tzaq82bfXx25wqfciSaigJjoWGKpaDuQHnIvhuVEJA2a75d
         0mJ2ZYiaxdCTNxuLWneVYmzawiYLJs8J5Vz7aoWQUv2JFIw+af/dak52xi4/xW0qbjLa
         rBNP7y3Ce/dKOYOi7fmRl8UOfKIXYAGiKd+sqYJ61aP3BRsplpF8F+IQdjbwO8aDjy6P
         Wh3NL+vBLQNyqCSVKNV3s0RJENRfchYn8R+NgXTChgTIHG7kxtCr/afjTxK9ZxNiECKF
         AjwGfVUw/FEGX7g0b34Fh5h9uZfz/0VmP8AOsr29zy/U86gmbh7jQ/BAsrVwe2v7jURA
         pxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724088542; x=1724693342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gI0RYGpSNPTo6JqkQ6a41zlNkjmfuHjvoCMeMlyi8rY=;
        b=uI6hmqlfZjUiFs6T6qlLjWlaw4mwccR/e62mJlxVweSDjBhJziV1EbzZczeEBJAr0Z
         cGy77hy992OyjMIgngR4ZxuHNQSlfBrqr1oywUMgtlE7kZk/0CgSxQRpBLGwo5BXMOdZ
         9jBnFy8ORtcYAaHtxnZoDyKwy66qrl10PGalPE4xe2zvQQaC6u8M90NK1rAjOvXUaOS9
         9Qc4yGpUTiXhswPiNoPeFTS++mLJ8sy2kxEapVfIOLX1qCYhyAwFmauyNaVNKIC7yN2/
         /mQcCnpiB55YS4F9ADRc566zD+xOsQofOItcbZSgXFJW3BXP7GDpHZD+kJ6eOsrt0huT
         zkUw==
X-Forwarded-Encrypted: i=1; AJvYcCUOjol2rU3Hexd5yKoxPiqM6ujysj5aM5PPhnv9yQ0R5B/lGgqEj/II4xjdTNVgFlzFxUceHrH8+gUhhKtRzrayuG0f
X-Gm-Message-State: AOJu0YzTTLRllP7jEmQE0d3/vXLiwWAr/VImleMmEZkMdOms4c4tyBZF
	J4ZzuF/mn8efUHRPTPBa3ybbMuFvVAdiHbQoPUt/oiRsBALUJJAT1jsRwxcUEmSWvu5RaHnGe/9
	Cm/0GJRrUzOYMHjurON45mH67/SP9bV4sOfvu
X-Google-Smtp-Source: AGHT+IEM6P57fFQIalJzjEctjLU/SQmHFav4sr0Y6YJXhwaJQfxcJcR0xLhMUTpcBGUK6XdGK20cJldrnAfreXca/n4=
X-Received: by 2002:adf:e0c1:0:b0:366:ea4a:17ec with SMTP id
 ffacd0b85a97d-371c4a9be3dmr243128f8f.2.1724088541976; Mon, 19 Aug 2024
 10:29:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240812171341.1763297-1-vipinsh@google.com> <20240812171341.1763297-2-vipinsh@google.com>
 <Zr_gx1Xi1TAyYkqb@google.com> <20240819172023.GA2210585.vipinsh@google.com>
In-Reply-To: <20240819172023.GA2210585.vipinsh@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 19 Aug 2024 10:28:34 -0700
Message-ID: <CALzav=cFPduBR4pmgnVrgY6q+wufTn_nS-4QDF4yw8uGQkV41Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Split NX hugepage recovery flow into
 TDP and non-TDP flow
To: Vipin Sharma <vipinsh@google.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2024 at 10:20=E2=80=AFAM Vipin Sharma <vipinsh@google.com> =
wrote:
>
> On 2024-08-16 16:29:11, Sean Christopherson wrote:
> > On Mon, Aug 12, 2024, Vipin Sharma wrote:
> > > +   list_for_each_entry(sp, &kvm->arch.possible_nx_huge_pages, possib=
le_nx_huge_page_link) {
> > > +           if (i++ >=3D max)
> > > +                   break;
> > > +           if (is_tdp_mmu_page(sp) =3D=3D tdp_mmu)
> > > +                   return sp;
> > > +   }
> >
> > This is silly and wasteful.  E.g. in the (unlikely) case there's one TD=
P MMU
> > page amongst hundreds/thousands of shadow MMU pages, this will walk the=
 list
> > until @max, and then move on to the shadow MMU.
> >
> > Why not just use separate lists?
>
> Before this patch, NX huge page recovery calculates "to_zap" and then it
> zaps first "to_zap" pages from the common list. This series is trying to
> maintain that invarient.
>
> If we use two separate lists then we have to decide how many pages
> should be zapped from TDP MMU and shadow MMU list. Few options I can
> think of:
>
> 1. Zap "to_zap" pages from both TDP MMU and shadow MMU list separately.
>    Effectively, this might double the work for recovery thread.
> 2. Try zapping "to_zap" page from one list and if there are not enough
>    pages to zap then zap from the other list. This can cause starvation.
> 3. Do half of "to_zap" from one list and another half from the other
>    list. This can lead to situations where only half work is being done
>    by the recovery worker thread.
>
> Option (1) above seems more reasonable to me.

I vote each should zap 1/nx_huge_pages_recovery_ratio of their
respective list. i.e. Calculate to_zap separately for each list.

