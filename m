Return-Path: <kvm+bounces-29206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D439A53C0
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 13:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8D271C20D71
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 11:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CBF18CBFE;
	Sun, 20 Oct 2024 11:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MdwiGdz0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8F184E0A
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 11:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729423938; cv=none; b=LdLW2oBtqbUvU74zJ1kbxttcK3GzUf4a3cQOgh2RUpj17rO1Yki59K7hs6JfGmsNXdiB3XM/csip2Qa7EEO/owoRUp/bgi+Rqqv/v8M8EF+PG00cm4sOfXOe0Bg9HYjxxQ1dxGH3WnHSUSCmJdCK+2S8YIAG76rCQuWjJC9AN1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729423938; c=relaxed/simple;
	bh=WYTnYtLUrp1UonGsCRaDfMccjMsa5EIq4iXmxBhDlM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tGC3f50PS4zKL7P3ohfb8aGuTIu0axMzEnyZwnwodfMIgFoxzGc9LVgRtcvhjqxMK4uWVOf6TI0rX8KsyuGdnGB90YPvgqzD0MDSDupWwr48x/emSnfjnNZitzR6neqLQtwsB/Q6GniaekN+bHQ0ObyHqeFyUNyeAfjk9OdTXH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MdwiGdz0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729423934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cR5Ak4fLmy8lCm0vtn/DmhtT5ICPa7cJEzdj3P8fRQI=;
	b=MdwiGdz02udTnlTtWIgdjQO5Jxzn6+96dokH3St7HmtQfREACB0qyT235UR04UHlUJ5tJy
	BDd90VgcCc0sru5CnsGClQ40eyOlXbs4BWQarJ0KHgN6NwCJUkBV/3t8k4t1OLRUEs6wyw
	0MlsQBdcogyaBczCehWB2xEufzM0GS8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-rW6vH71nNyGoVRmQUgN2eQ-1; Sun, 20 Oct 2024 07:32:10 -0400
X-MC-Unique: rW6vH71nNyGoVRmQUgN2eQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d60f3e458so2359821f8f.1
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 04:32:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729423929; x=1730028729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cR5Ak4fLmy8lCm0vtn/DmhtT5ICPa7cJEzdj3P8fRQI=;
        b=i+ST6BDvJ5rmCcVcjNANexRKcMI0EraDNCLZx9pmdx/kuU6muF0G3H99s+qDKXnRmW
         3X/2d10rJfdf3kFM4xO9tE8pYSRkWnEVSQre+YQipcg7PYEY4Ltk4yQUMQOkGjaz4wXK
         nmVSxjRbtf2QB836LOf9PBMmZhRWkBLP6pGQICQc/kEiqLLFXFIyigbcdI7gbG7LlmPu
         GvNjMYL/8JGYdhwnAylnW9+yKvgrpK/pERsVhXC2BJQnObSLVvxrYTQ8l5lXnCCeToxv
         fNS3PiMw0GqsELc5UsF1OeMl1AlR+fd0aV13K7t3KPFBpZFHXcPhvcS8Zj80g8lwd3FM
         v8Ng==
X-Forwarded-Encrypted: i=1; AJvYcCV2vID9jXhiFNQGCW6gRPdtOOBUxRAP08Fz/HtysRugwgeH2+NkUjNzRAVHIH1/2W8gaak=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmfODGICO+Nq8XsD5gqGxxc23gGAH5QAIODnEgrSyLcmAY1xtz
	I5PN7OYj7M3hFgTkqa8BEvCzG9XVtsuvgofUEY4VFIR8+qx5QsT8WrG6uw9c8JOXuaSxCmkmSOy
	bdn8/0vwtFzaaU3nNmOriStyehndS/16Pzslh3mphLoGDJhZrSW+d+U0zd3ujnc/ILnm0SfAsu3
	76otMScdUgakMatJol6ltsPnWyQ88KO79zHto=
X-Received: by 2002:a5d:46cf:0:b0:37d:2de3:bf8a with SMTP id ffacd0b85a97d-37eab4cbc1cmr7777081f8f.26.1729423928687;
        Sun, 20 Oct 2024 04:32:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhcTwGkAc85d3818flM3w9+1IWExGJgHFjEhLi36KDSMqNEFQFutB10iL0qeJciXQ9Ql/B197qipBgzP9G/0Y=
X-Received: by 2002:a5d:46cf:0:b0:37d:2de3:bf8a with SMTP id
 ffacd0b85a97d-37eab4cbc1cmr7777063f8f.26.1729423928364; Sun, 20 Oct 2024
 04:32:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241017090956.954040-1-maz@kernel.org>
In-Reply-To: <20241017090956.954040-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 20 Oct 2024 13:31:54 +0200
Message-ID: <CABgObfZpfARP6yg9LwQ=pitaenJetyp80KgK35xsKoAczVqQrg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.12, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, Gavin Shan <gshan@redhat.com>, 
	Ilkka Koskinen <ilkka@os.amperecomputing.com>, Nathan Chancellor <nathan@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024 at 11:10=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's another set of fixes for KVM/arm64, addressing another vgic
> init race as well as a build error (full details in the tag below).
>
> I notice that you haven't pulled [1] yet, so hopefully this will also
> serve as a gentle reminder.
>
> Please pull,
>
>         M.

Pulled both, thanks.

Paolo

> [1] https://lore.kernel.org/r/20241011132756.3793137-1-maz@kernel.org
>
> The following changes since commit df5fd75ee305cb5927e0b1a0b46cc988ad8db2=
b1:
>
>   KVM: arm64: Don't eagerly teardown the vgic on init error (2024-10-11 1=
3:40:25 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.12-3
>
> for you to fetch changes up to 78a00555550042ed77b33ace7423aced228b3b4e:
>
>   KVM: arm64: Ensure vgic_ready() is ordered against MMIO registration (2=
024-10-17 09:20:48 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.12, take #3
>
> - Stop wasting space in the HYP idmap, as we are dangerously close
>   to the 4kB limit, and this has already exploded in -next
>
> - Fix another race in vgic_init()
>
> - Fix a UBSAN error when faking the cache topology with MTE
>   enabled
>
> ----------------------------------------------------------------
> Ilkka Koskinen (1):
>       KVM: arm64: Fix shift-out-of-bounds bug
>
> Marc Zyngier (1):
>       KVM: arm64: Shave a few bytes from the EL2 idmap code
>
> Oliver Upton (2):
>       KVM: arm64: vgic: Don't check for vgic_ready() when setting NR_IRQS
>       KVM: arm64: Ensure vgic_ready() is ordered against MMIO registratio=
n
>
>  arch/arm64/include/asm/kvm_asm.h      |  1 +
>  arch/arm64/kernel/asm-offsets.c       |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S    | 52 +++++++++++++++++++----------=
------
>  arch/arm64/kvm/sys_regs.c             |  2 +-
>  arch/arm64/kvm/vgic/vgic-init.c       | 13 +++++++--
>  arch/arm64/kvm/vgic/vgic-kvm-device.c |  7 ++++-
>  6 files changed, 49 insertions(+), 27 deletions(-)
>


