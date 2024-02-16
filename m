Return-Path: <kvm+bounces-8884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CBAE858357
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:03:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8686B24865
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 17:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A86130E3A;
	Fri, 16 Feb 2024 17:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UgfCPNZb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F7B1E86B
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 17:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708102980; cv=none; b=kH3nt1zLuej+8a+yPuf++ExG/Ft5p0PqeBDQAZuXJlMAY1DIfXhhjB5J1Q/scdwvBkashotEEUsrh/4Q/7ocAZpYiDmU1WaqMM6g697mWprh71VnC9HnkWGNkKUIEdoAkJq3bbkyd/cf7aVt7xW33aiGAj/0QdhyRiOnhRqkxpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708102980; c=relaxed/simple;
	bh=zwGqJ2fkeXVi3yXrrkK8rAprQjwepMa3oWgrp7ecopE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EvDemqdd5IMmK7toHXj+actEJSwDgHtZ1owpevikCPXveYPSnBXoEnh2Mez4rVlvaTBueZIPbpueqix/B8i6b5B5KQ4zwh6cFX6Bg9X38Av06fMRPZxqlG3vrgs8HziVvVA1H3NuD9ZY0xQwvklcMsdJBe5U79msabNOXoMEDY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UgfCPNZb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708102977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XCF50IBRGmP/fByMsTs/u54G4bp+bCTmfaSrPpKQ1uo=;
	b=UgfCPNZbRMvIv2dg5V0Z40DEqaer0tkkohm+MRNpVMaAd4CXPZQUtYd3f/+UREHbsYz9Qp
	p3HOXEqtRuYmby/9ioSvqytwQwcilQ5EKc4StLloXMfeVXhe2A6/w7LttNiDdr7T0TIhN/
	rbhO+kLtAeSaMqbqaDHF4VfOdcdIqIg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-giRYvwykO5eZdQQCivptcw-1; Fri, 16 Feb 2024 12:02:56 -0500
X-MC-Unique: giRYvwykO5eZdQQCivptcw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d0be4e5cf2so10995551fa.0
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 09:02:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708102974; x=1708707774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XCF50IBRGmP/fByMsTs/u54G4bp+bCTmfaSrPpKQ1uo=;
        b=RWwPsyjTSl0Xq4NkViwg1kU/R9iFFMfus9YN9FEmYR2k4840ErsePEWZDCC9L6mcot
         s/AV0v9gmAg6FgrDPQY6CItrb8TndShxzQcEtNbl7x6OF0981qC04QIjM6RMnf950tgP
         w5j9U8k/v1ytQ+u/k7Caqd3XceoHATghhwlbWe5Rfx0ShezFEDTDZOuaQhhZz3pIJdwJ
         hsmnHrgwreedxzej7G7wAUjwZVroIIjTP9zQY2wm3l3iXSgZqW+tc09HFDGY9CsWvVPH
         gRNRnCum7S/91AtdMgJIaMOSCllafH/vaY9ZuntCw8UHLJsHoNRr+E9VYRIbC9cMlnj6
         Shtg==
X-Forwarded-Encrypted: i=1; AJvYcCVZcnFy35H368lh4f7PAh8w0xEmyUfaWr2XUd3uBbo8aisiFDa5sXYYN+tBt6FCllVrlFVX2BcX5xPVwlSUNcrNhFrv
X-Gm-Message-State: AOJu0YwLlQ2WUDqsTEBeIC0QoP04nW7/+dpBnyLOJPDSKWnwW1BDRnfL
	PCmTgP+B+GiMiYD6c6JymA29W0uANY/G18GcvPqA9f7xWkixHq3MlYpN88mGIEhnWbU3ddpOfhx
	3Qy8VHGSVIfYO82fdXf+2zypDazC5Kw2lLiTHQdeSXoWIWB+eCJYOkAJiHUCuhkivKbE6VMes6c
	NOez0nyuOtsecAxZVYApIUDMwt
X-Received: by 2002:a2e:8812:0:b0:2d0:99b7:e68c with SMTP id x18-20020a2e8812000000b002d099b7e68cmr3187977ljh.15.1708102974552;
        Fri, 16 Feb 2024 09:02:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGGN6nw3gQobDUDZcnFDlf7+jbQOPBJzQ28faqnSRYOwwYW67ZgndKNx5rvCkm2md+nuH+eEh+bF32F9J7zeB4=
X-Received: by 2002:a2e:8812:0:b0:2d0:99b7:e68c with SMTP id
 x18-20020a2e8812000000b002d099b7e68cmr3187960ljh.15.1708102974223; Fri, 16
 Feb 2024 09:02:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215152935.3093768-1-maz@kernel.org>
In-Reply-To: <20240215152935.3093768-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 16 Feb 2024 18:02:42 +0100
Message-ID: <CABgObfZAr77NxyoMCih1+hVQ9=Usu9p+yqkoqdCBQSuWwPvv1Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.8, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Ricardo Koller <ricarkol@google.com>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2024 at 4:29=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Hi Paolo,
>
> Another week, another very small pull request. This time, the bug is
> irritating enough that I want it fixed and backported right away. It
> has only been found by inspection (thanks Will!), but once you've seen
> it, you can unsee it.
>
> If you haven't pulled the previous tag [1], you'll get both for free.
>
> Please pull,

Pulled, thanks.

Paolo

>         M.
>
> [1] https://lore.kernel.org/r/20240207144611.1128848-1-maz@kernel.org
>
>
> The following changes since commit 42dfa94d802a48c871e2017cbf86153270c866=
32:
>
>   KVM: arm64: Do not source virt/lib/Kconfig twice (2024-02-04 13:08:28 +=
0000)
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.8-2
>
> for you to fetch changes up to c60d847be7b8e69e419e02a2b3d19c2842a3c35d:
>
>   KVM: arm64: Fix double-free following kvm_pgtable_stage2_free_unlinked(=
) (2024-02-13 19:22:03 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.8, take #2
>
> - Avoid dropping the page refcount twice when freeing an unlinked
>   page-table subtree.
>
> ----------------------------------------------------------------
> Will Deacon (1):
>       KVM: arm64: Fix double-free following kvm_pgtable_stage2_free_unlin=
ked()
>
>  arch/arm64/kvm/hyp/pgtable.c | 2 --
>  1 file changed, 2 deletions(-)
>


