Return-Path: <kvm+bounces-24192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7658B952205
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 20:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 324E7284D8B
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2CA1BE245;
	Wed, 14 Aug 2024 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vceOGFuy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEA41BD4E2
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 18:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723659879; cv=none; b=WR+rgUJ2wpu6UG9IVwdN6SveVdnqrw0oF01cINXA3AsxpKepR0HBlgT02FkjTnA/FHE3zK4+u7p/wvps4SaFT3nSoaVeqnuNUlaJDJH2bW1Sy3Lp02f+wTnP1/Xhb1g8dKIWp4zDVHshv/sDOuTRrwdMXg0yP0800lD4RMH3FOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723659879; c=relaxed/simple;
	bh=fUPdp1FJP9o6RPzeUXh0crfnPnpeOC6DOpOpQNM1eGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FIYYRiPHsxUzw2bc/wnNhFRm/mJJGULTXy+leEQfJt3BgUsDiLFSVeDMGTyuwotz1XTzFXihlfa0Xbs2Hbd/G2UfOqz1N0o947G2hQgL+1jEGeYv9doHyiSlGhaz2maBs4swl04PK3ZNJSNVqDfeWIMMc0gh1XiPSBHRa3EwfAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vceOGFuy; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a7a94478a4eso220601566b.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 11:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723659873; x=1724264673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgcHiPfghS6i54uArWpbh4/aE1GPzyWbEj0Bz9CZ81s=;
        b=vceOGFuyc5GXRn9jO3qeyt3GlIrkJC7KDr2u/F/TzUNUNln3eqy/RtQzf11qj6ID/h
         dDkbGCPzsCU/PD4XB8LiZLx93kXnkwv0IwcsecwtFAUmOz5YW5DeTBqM3PixkXziJK3K
         idVoq4cpT7yVFJvM2A8yBaq0ipnREVtDuQtLX0y9Cv2R1Ewq/XdkUH0l7nntCFBlVGDD
         rzfJ79gyRMuSUEwsWt6yc2NNCTnXvu6UbWNu74iAjfiXJRBQGdKQI4bNnFqdXfhTPOVs
         hgLBwH/msBDf1ZVK9iP7YpX25uweLd7C1x3/597QLYP2GOptu4ruuF/1qN9NRl7e+6nu
         qbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723659873; x=1724264673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgcHiPfghS6i54uArWpbh4/aE1GPzyWbEj0Bz9CZ81s=;
        b=mEcrOllriQ9fQzL9ymeqxoPPOodWr9bfS/+xq/ETdK8CIvSBbRl439iUftD4WnKweu
         pBm3Oc6E87b0pKiYT5wOj3Q+qjMJsN31NfDNa3rNaXXHoIGNdaSq55+fWceNOIvGgXBb
         cPbHB7RML1dyOBaLXUAwWLOvpGzi9avvrTqXF3rxGoM715L2M+AyNh4vLwjhQeWlygaF
         oQV6Q2DjVmMO/2eVaxfhXfudBLbYWIOe2XtD8pDKnAMmHqceiEK6+vx+InamypE06fY0
         16hofkmpwZjZWzKKbgMepVi3v9KwiB7kKdoyGfacdlcEmH85RLq9Yt3v/nHBL1tG6Y0K
         1+bg==
X-Forwarded-Encrypted: i=1; AJvYcCX4xZzFchG5L8K7S3BseEZlNjnW8bM93qrEhUOpvL40cqRhFI+lIP+j3xekUd26+yPauxRcusgBz1ZP3dJBOQvbB/9C
X-Gm-Message-State: AOJu0YwWx0eXvQrhn39/KhkWYWg/rO/nnqVjtPApA51MWDnZGx7JsoYq
	gklB5BmRsbqscZgaYpuAGOuxGjdP3wjilXLsBV+v3oaBxJ09bSafbTpzu9sGawVNWCjDpP9jsAk
	CfM4dvAjqOfB/UpRL/cmnqO7zkrYu1aV0KUlf
X-Google-Smtp-Source: AGHT+IEuVeVZJ3rSBIB5OeRdUr94JEf8OV3NfVjLFDKBu9xzaqHB1bnQJOXdTCu5jNStYLiHlAVBEgjlFrDB6wDlfTE=
X-Received: by 2002:a17:907:2cc6:b0:a7c:d284:4f1d with SMTP id
 a640c23a62f3a-a837cd582d8mr39310866b.28.1723659872437; Wed, 14 Aug 2024
 11:24:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240812171341.1763297-3-vipinsh@google.com> <202408141753.ZY1CSmGo-lkp@intel.com>
In-Reply-To: <202408141753.ZY1CSmGo-lkp@intel.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Wed, 14 Aug 2024 11:23:55 -0700
Message-ID: <CAHVum0ddyzHs+7Zv1SaL9Ox5qY7V4bjciPsnj21HekAavz_x4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
To: kernel test robot <lkp@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, oe-kbuild-all@lists.linux.dev, 
	dmatlack@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 2:33=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Vipin,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on 332d2c1d713e232e163386c35a3ba0c1b90df83f]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Vipin-Sharma/KVM-x=
86-mmu-Split-NX-hugepage-recovery-flow-into-TDP-and-non-TDP-flow/20240814-0=
91542
> base:   332d2c1d713e232e163386c35a3ba0c1b90df83f
> patch link:    https://lore.kernel.org/r/20240812171341.1763297-3-vipinsh=
%40google.com
> patch subject: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging =
to TDP MMU under MMU read lock
> config: i386-buildonly-randconfig-005-20240814 (https://download.01.org/0=
day-ci/archive/20240814/202408141753.ZY1CSmGo-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20240814/202408141753.ZY1CSmGo-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202408141753.ZY1CSmGo-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    arch/x86/kvm/mmu/mmu.c: In function 'kvm_mmu_possible_nx_huge_page':
> >> arch/x86/kvm/mmu/mmu.c:7324:29: error: 'struct kvm_arch' has no member=
 named 'tdp_mmu_pages_lock'
>     7324 |         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>          |                             ^
>    arch/x86/kvm/mmu/mmu.c:7335:47: error: 'struct kvm_arch' has no member=
 named 'tdp_mmu_pages_lock'
>     7335 |                         spin_unlock(&kvm->arch.tdp_mmu_pages_l=
ock);
>          |                                               ^
>    arch/x86/kvm/mmu/mmu.c:7340:31: error: 'struct kvm_arch' has no member=
 named 'tdp_mmu_pages_lock'
>     7340 |         spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>          |                               ^
My bad, didn't check for 32 bit build. In next version, I will take
the lock in tdp_mmu.c.

