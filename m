Return-Path: <kvm+bounces-14141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4016489FC73
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 18:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 718511C219FD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1388B178CF7;
	Wed, 10 Apr 2024 16:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y+Wlzit+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF6F178CD1
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 16:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712765173; cv=none; b=Y3P0LwreR/heSUZxXGhb5mLJDw315MR/WZIY7bIj3G5UZJ/gan/LIxuY1kIxQb52SJLsPKtrF3t6/ls2OHcZNQwCVqLW+tz5A0ahuOhYclakO3IIQUAR0RbPA6Bpq/vNprLA1AZCTNUSAHTS19hOAkPoBFRg6lLtvetTuTv2+jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712765173; c=relaxed/simple;
	bh=l0kAp7lLoQtgitGtip/ehHUxaJ1TKF0EEEKci4u8LEo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F0RiVcKce0w5awjf9HW/2bHfUd0lSnNnCf58+i+ngpzXWrA0Q7GoqU4d1ehDrGJad8iBFB9lzj+w0G7nJ1ittR11DJjNcfDnxi9vpPBkeqIK97bcuAqFdU6OZwA6DyBwb9MkO72mVmEM+sP8xLBRQUW4VPWg6nENuCggK5TIrlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y+Wlzit+; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4167fce0a41so18206145e9.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 09:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712765170; x=1713369970; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+RgEgwdXjPo24dzXWeCrYb0/hcpQSutXzqNG6CcwSA=;
        b=Y+Wlzit+MbjJgxtsgcGqZWPAMb9ZgBbzFsyNOTc9EUD5Z00j+b15dadG4pWVn2KFS9
         1W501hQnV+9OFQtxkcfRUF0M+/Z5v3d9XpQtGDIYfdgulvK7AU2h/+zi0Eyx7GxxIlUW
         t2y2rStXq0Ao0SAcf7kxxNcH5EKmsdWZcp2L94hRF1VecERCRBDZ20yY91M7qWqStEyV
         S6DaOOYfdrQv2i4wgcKnaVsf4HidWf/YwsvfZIdsq2wCFj7cMW87gcNDnG47p5xb5/hv
         3Qe37IB1+RARvsyIKWmlkf4PXIW89jwwo7jZsq1BZ9rnOlUowVmMiYGcPIQs43Fk+oAm
         O0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712765170; x=1713369970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+RgEgwdXjPo24dzXWeCrYb0/hcpQSutXzqNG6CcwSA=;
        b=CtPU/tmDl+trb/S6z6zuc7I7l5jf4BE6RSsUCJR00HpF/0ZgVbrEKeY1cOhFMYGVpd
         HG+9TYfkjwerQ2tkweAPSrZ8b4XJ/ySC8m71UVKI59+OUHaLrExrGy6kuPZKjBASjWMD
         dNqM59b2UfN66nzyW6g5CsTVoRHqMJ2RynI+TjR8YzHhDbLyuAzEbzBC1DjDI01oU9Od
         Whh3KjA0dMi52qcgMIyrC+3zIb6EHxjRDpTrdO4gjkiefAT9jhMfAN+c7ZY/pUDXbHa3
         nU87/m41k01LttfjXl8QtGjDnP9nrqlxghGWHjDVpBk/NX20mIclVimVUyHurltGUpCJ
         IPeg==
X-Forwarded-Encrypted: i=1; AJvYcCX1eNSBns0+bLKjvErosnLSRSY4vStCt3ELY5Zs65bLdARYcd/TshGUrt0BxKdVPAWDCxKFPLDTghcJVODF9HIdDYOl
X-Gm-Message-State: AOJu0YwRJbouPhYzdex+5E1H2Y1UEAqf5Ky8ZkfcIOD9+A1/pBHAMQSa
	+A/Jd+bdhEa93wRksn60SzgHFIXdx4UCgkB9ox10nL81d3zkFrc2boPQ5uu+bY7BHknqulwu20H
	dVi//nU9nQvdYuhYNi5lC7hOX9Ghdo1spbura
X-Google-Smtp-Source: AGHT+IFxDBmgmfms21bAMAQROP4lwXHQsupBFL6LHtaAJBesURODtq3ce1/c5fuaTmRjy8csSZCnOUkHBKx7pxPDq+Q=
X-Received: by 2002:a5d:6da7:0:b0:343:7f4b:6da5 with SMTP id
 u7-20020a5d6da7000000b003437f4b6da5mr93685wrs.17.1712765169740; Wed, 10 Apr
 2024 09:06:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240315230541.1635322-1-dmatlack@google.com> <171270408430.1586965.15361632493269909438.b4-ty@google.com>
In-Reply-To: <171270408430.1586965.15361632493269909438.b4-ty@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 10 Apr 2024 09:05:41 -0700
Message-ID: <CALzav=eK-FeCDvjrfcWUR_KYy29r8O8HP=+L=zdp-UAYhpp+QQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: x86/mmu: Fix TDP MMU dirty logging bug L2
 running with EPT disabled
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 5:20=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, 15 Mar 2024 16:05:37 -0700, David Matlack wrote:
> > Fix a bug in the TDP MMU caught by syzkaller and CONFIG_KVM_PROVE_MMU
> > that causes writes made by L2 to no be reflected in the dirty log when
> > L1 has disabled EPT.
> >
> > Patch 1 contains the fix. Patch 2 and 3 fix comments related to clearin=
g
> > dirty bits in the TDP MMU. Patch 4 adds selftests coverage of dirty
> > logging of L2 when L1 has disabled EPT. i.e.  a regression test for thi=
s
> > bug.
> >
> > [...]
>
> Applied to kvm-x86 fixes, with the various tweaks mentioned in reply, and=
 the
> s/READ_ONCE/WRITE_ONCE fixup.  A sanity check would be nice though, I bot=
ched
> the first attempt at the fixup (the one time I _should_ have copy+pasted =
code...).
>
> Thanks!
>
> [1/4] KVM: x86/mmu: Check kvm_mmu_page_ad_need_write_protect() when clear=
ing TDP MMU dirty bits
>       https://github.com/kvm-x86/linux/commit/b44914b27e6b
> [2/4] KVM: x86/mmu: Remove function comments above clear_dirty_{gfn_range=
,pt_masked}()
>       https://github.com/kvm-x86/linux/commit/d0adc4ce20e8
> [3/4] KVM: x86/mmu: Fix and clarify comments about clearing D-bit vs. wri=
te-protecting
>       https://github.com/kvm-x86/linux/commit/5709b14d1cea
> [4/4] KVM: selftests: Add coverage of EPT-disabled to vmx_dirty_log_test
>       https://github.com/kvm-x86/linux/commit/1d24b536d85b

This commit does not have the WRITE_ONCE() fixup, but when I look at
the commits in the fixes branch itself I see [1] which is correct.

The other commits look good as well, thanks for the various fixups.

[1] https://github.com/kvm-x86/linux/commit/f1ef5c343399ec5e21eb1e1e0093e73=
1dce2fa1e

>
> --
> https://github.com/kvm-x86/linux/tree/next

