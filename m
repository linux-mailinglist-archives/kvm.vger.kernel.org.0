Return-Path: <kvm+bounces-30379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BE579B9958
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 21:21:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D70D7B2132C
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824251D89FA;
	Fri,  1 Nov 2024 20:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nhys4nrw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE913155C9E
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 20:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730492505; cv=none; b=r70NO7ex006nzSmJb5x0st6iVcgggWyJioq6WAhe35FHWARQy4b9cUxODON6TpVRS2PG5NTV1zIASDVdhYwOR8P62BIDOmRBhhucjZB+EFjODBiBRXumISN3YJu0ht0rjuyqNaoLAJyIk3HGqvdBBPDoASgTy4mgZ3eo3TqCV3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730492505; c=relaxed/simple;
	bh=89rOcnEfbrh++Q72N8Ey9wdXk4mOjuMF6EhTiVkFG14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Poprfvjj2F4Sj+PL2u32rghzd84cIDDhZ53O5/yuQGf98m8lLwvWhH81wcUiL0zWANEw72m/wwQJ3eypeT4uBhxDr4nnhAo8GgZcvLQ2xTfM6Ek+Pd7io2iYRKU3MxFN4DZ5GSihoUAowtBeNNdBbC6W70JYwUWkdvokpvyS9H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nhys4nrw; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539e617ef81so1001e87.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 13:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730492502; x=1731097302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89rOcnEfbrh++Q72N8Ey9wdXk4mOjuMF6EhTiVkFG14=;
        b=Nhys4nrwo/oDndicU3kISoK3Ooi2KtObnjE8UuDMWV7nHZBThPp0jb9h3TkoSvsgVb
         BGuR3lACL0hEdulEeZsRdOYks+tL7jvuSfHLndNItQUM9xjITaiWjkhYlXvJA4q6kFrU
         aQsil1KgMeojEr2cUA3Ugl5m8yld3dreuQlA2IHh29tlyHOx29ROge0fimgcuxfR1diV
         nnF+Yv0zbu5UwPx41XyFeSxFsEocJ03teji9q31FP1kTbN7TSJAPJ0UlHSUQcmDmoLZc
         Fq7qrIysSAhs0kohy1wowlfSmKp8KY5YBvQMf+3DyCcePwiSVZuPGLXmNNJYnYq5htIq
         P/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730492502; x=1731097302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89rOcnEfbrh++Q72N8Ey9wdXk4mOjuMF6EhTiVkFG14=;
        b=HzMWENSpH2MJZoaTQ8HODN+9KBnnGectUMAqRZ4ETs+3t4o+MYSthMHwKacto2Zb3z
         wnzIaHKKIbCCmJqCEGTlnvH97ntQU7nU8iFnLQRyj6n+Yz28dEnw1CDy0WXwVG5IgpLX
         5nhejg4qWJn3faeqzV9p0YF6EE8zqw0EZ3UwcZJR/9Bp00W0RpNP+qqEU/L4+pGKCo3q
         cDzhttZ6VqbO7q47W2I4yG7ZpQjwAhah/tPhsq8v0k4wCNJK/6hbp2VBLB9x/4QdYzQI
         IEbBAnmvcyLDVdHb4AOwYmV/VwMWKMO036b21b297gVIic/7pg7z+chYUI54raU3w11C
         1zAA==
X-Forwarded-Encrypted: i=1; AJvYcCW20hJiNtwLDvtN3OR+5g+YM0BAk6hY7lnOBy1z7/OOhFVlsNcGuX41RT8Xj9de3Xi4PVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhhktp+FD83H3JJMYVsZfYj3sWuxE6jQBlvhAx5y9OYEQqmh7N
	5jrKtoJhSqwB1R8S4vpWQdhgMB2cCMGsCVfpZk8K8NFmyPvfHPwidTnXQ7qW9TPGMUvXYF3MCYf
	ava32iNLxDuTnSNDt8siRg4wwaE2cLdXDZ0BT
X-Gm-Gg: ASbGnct0Mj/rf0d/jA1a5ifu7SGVqhrGPyV0GTP+vI4/LLdTAqEejuWvofKQGaJLbbN
	rUcgFd0pwmdjaDsvMWwaFHnXfUJVSDQoRYImn9g+R9sVMl9WA02yco6Wz4bxD
X-Google-Smtp-Source: AGHT+IEAPJzx2uQHlMIrHXN6W0szDXgPd+rVEi3ZiRYWj3r6Jmyd0vqoU74+2xiJQDlbqX7Vkd98+vpJ1dRqIr9DhKI=
X-Received: by 2002:a19:690d:0:b0:52c:dd42:cf57 with SMTP id
 2adb3069b0e04-53d6ab62d5amr102033e87.0.1730492501694; Fri, 01 Nov 2024
 13:21:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241101201437.1604321-1-vipinsh@google.com> <20241101201437.1604321-2-vipinsh@google.com>
In-Reply-To: <20241101201437.1604321-2-vipinsh@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Fri, 1 Nov 2024 13:21:04 -0700
Message-ID: <CAHVum0eZ1z4NfmQEmr2T34LFY9EEhM0rdkEEx_yxF-zijhmLYA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] KVM: x86/mmu: Remove KVM mmu shrinker
To: seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc: zhi.wang.linux@gmail.com, weijiang.yang@intel.com, mizhang@google.com, 
	liangchen.linux@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 1:14=E2=80=AFPM Vipin Sharma <vipinsh@google.com> wr=
ote:
>
> Remove KVM MMU shrinker and all its related code. Remove global
> kvm_total_used_mmu_pages and page zapping flow from MMU shrinker.
> Remove zapped_obsolete_pages list from struct kvm_arch{} and use local
> list in kvm_zap_obsolete_pages() since MMU shrinker is not using it
> anymore.
>
> Current flow of KVM MMU shrinker is very disruptive to VMs. It picks the
> first VM in the vm_list, zaps the oldest page which is most likely an
> upper level SPTEs and most like to be reused. Prior to TDP MMU, this is
> even more disruptive in nested VMs case, considering L1 SPTEs will be
> the oldest even though most of the entries are for L2 SPTEs.
>
> As discussed in [1] shrinker logic has not be very useful in actually
> keeping VMs performant and reducing memory usage.
>
> There was an alternative suggested [2] to repurpose shrinker for
> shrinking vCPU caches. But considering that in all of the KVM MMU
> shrinker history it hasn't been used/needed/complained, and there has
> not been any conversation regarding KVM using lots of page tables, it
> might be better to just not have shrinker. If the need arise [2] can be
> revisited.
>
> [1] https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/
> [2] https://lore.kernel.org/kvm/20241004195540.210396-3-vipinsh@google.co=
m/
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>

FYI, I carried forward David's Reviewed-by from the previous versions.
Extra change from the previous version is removing registration of KVM
MMU shrinker in kvm_mmu_vendor_module_init() and mmu_shrinker object
along with its callback functions.

