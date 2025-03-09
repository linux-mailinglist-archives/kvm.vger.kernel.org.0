Return-Path: <kvm+bounces-40525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05DA2A5817A
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 09:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3B233ABDD4
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 08:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B35518C011;
	Sun,  9 Mar 2025 08:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LffluGPg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8F718872D
	for <kvm@vger.kernel.org>; Sun,  9 Mar 2025 08:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741507897; cv=none; b=l4jIZBS4bW/BG7kep6FCzOXI5vpzOCYwpz8T86wZp8OkpjGgzUg60dX7CuZbqo2Oivmr6+QQNS8Qsk5DxxWfmrVQQRbM5YjXdVTMCR/o/j9PMuX3nlNt0nmAWAxNVjHXrQWjAGeR8+3P5Z+P3IvZa1xpqWX3oTjZtx1XME9khow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741507897; c=relaxed/simple;
	bh=Q6rj08KDrui8ypRPR7Rnc9Y9uhUc7RHUmj00WT8Y1T8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eLXZijLJ9G+NGIZpWxrK5aIsuvd8tHVbEWdLAf9IsUEdLm6lDbE9yvX+A6XpKN0IJjH8u4ln+7SCUZu3bnE6as8mIq4/yKk7YPUMA0IFtFZ8kSTVulyPu4nCkpIKW/6t4nYS6XFxB+g8qLaYBz3P3tFYP+Wkh2cHuMRZ43dAftM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LffluGPg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741507895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6D4nNiDsoCmfkR08WaPZur5Udci4/JXP8lfXTACJmTY=;
	b=LffluGPgiEsuCkwlWBxdhXUTNeZdr5D+hTpolf9mtyDeEN+ZlWTM5iubQYSFNbi+9YQ4MR
	JSxgmosRxUt2we/ARq20FYGB7U+ya7lL93O1qPD8geQBASKze+OftHyd/Wr4Nt+Eli4Fys
	70fvrPpa9v6vXT+d3gZmHSh/aQA/PMY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-PBVxtVtZML2iN8hqDLVpyw-1; Sun, 09 Mar 2025 04:11:33 -0400
X-MC-Unique: PBVxtVtZML2iN8hqDLVpyw-1
X-Mimecast-MFC-AGG-ID: PBVxtVtZML2iN8hqDLVpyw_1741507893
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-390eb06d920so2239489f8f.3
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 00:11:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741507892; x=1742112692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6D4nNiDsoCmfkR08WaPZur5Udci4/JXP8lfXTACJmTY=;
        b=frCQ6CM0h6fKFDQLOZAzFyGIgUdn/TyLkfFf59ZrnvV6lQ+LycqZNP1qOqQdqyv+1t
         LHT675nhVGCMdrhy5HY6N+x461Rvugup4xdNvjHiiyHWzA6ILxvbTm82vQ8JbHN3akId
         B5v4oTZoXrLlQBBqaqnklJXkVIHO2oRpNIfQURCLuNp3hvV5DpOfC6LWYVoOg558vo0B
         bKl4EqZtEHxtjru8F4VbeqdCpv5kuVh5z+WxNqP7BmrSXdRtEw1k4GEL+GoS7Rf/x/Zp
         e3ZuRwsTTLs5ExrX5dYVNXdDN3ao6NxVriWdW8l/wjNM3IrSLtPNs0BVOpHocUFgqNaU
         7tTQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5sAk0uItvhWhJHFE6zKQ59N8Pg+L4KuG/EBfoy5qt2t54zWiyvJ3Ic7ALvkgHctjVhas=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhNC4T5HxJY3AqxyxLrvcbqp5SYyJRCRNwY/s+J/B1pPYHq/YF
	Mbqevbo1UYMISZv+neWKrPItcLtPZyDGxqCvTYiN9YF1V8SDw5K7QN+mqbbyfgU0U02ROlw57AC
	3/LMHkLJcd9l365A8mg2bLTD3Zw8m+KMnyVAtfktj5eiCQdEbtNP18oAu8m5eNbeLH2MwddiXpq
	eWFt/mK+PB/T9srhn50I4SZf/7
X-Gm-Gg: ASbGncuASdb2MHQGuin8/k4aM/Kx3UGUVtNnGlKQsBdFYXBIQjmF9yWGOq9c9t3TcxT
	KLKpdW65TU9nba/b7F1omFk+7yDKq1oZEQ359RBDMmcZXQNCL1cNmu+h70aepuYqapseUYaDkhA
	==
X-Received: by 2002:a5d:64c7:0:b0:391:11b:c7e9 with SMTP id ffacd0b85a97d-39132d6011emr7166823f8f.28.1741507891077;
        Sun, 09 Mar 2025 00:11:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiBPbgntPWPglpyH3yVJe7DtL/SqQ3tkdVqB05cSWbb15hmPwKqmctjqE5FygFtKO8OhuBCU8t4eAyP8z/ofw=
X-Received: by 2002:a5d:64c7:0:b0:391:11b:c7e9 with SMTP id
 ffacd0b85a97d-39132d6011emr7166753f8f.28.1741507889227; Sun, 09 Mar 2025
 00:11:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307161824.2373079-1-maz@kernel.org>
In-Reply-To: <20250307161824.2373079-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 9 Mar 2025 09:11:13 +0100
X-Gm-Features: AQ5f1JrP7IQ8OrSLUcslcCFYIM4kkq22dH0_bEGdv3OXLIuy8ZkTPSuW1cy68r8
Message-ID: <CABgObfaZQsPLvyYsuFzYJOwgEaJ40=yZ+TS29Lt_xZyT9oSKpg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.14, take #4
To: Marc Zyngier <maz@kernel.org>
Cc: Ahmed Genidi <ahmed.genidi@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Leo Yan <leo.yan@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 5:18=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's what I hope to be the last set of 6.14 fixes for
> KVM/arm64. This time, two patches addressing the two side of the same
> bug, where pKVM's PSCI relay wasn't correctly setting up the CPUs when
> in the hVHE mode. Thanks to Ahmed and Mark for fixing it.
>
> Please pull,

Done, thanks.

Paolo

>         M.
>
> The following changes since commit fa808ed4e199ed17d878eb75b110bda30dd524=
34:
>
>   KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2 (20=
25-02-20 16:29:28 +0000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.14-4
>
> for you to fetch changes up to 3855a7b91d42ebf3513b7ccffc44807274978b3d:
>
>   KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu() (2025-03-02 08=
:36:52 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.14, take #4
>
> - Fix a couple of bugs affecting pKVM's PSCI relay implementation
>   when running in the hVHE mode, resulting in the host being entered
>   with the MMU in an unknown state, and EL2 being in the wrong mode.
>
> ----------------------------------------------------------------
> Ahmed Genidi (1):
>       KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()
>
> Mark Rutland (1):
>       KVM: arm64: Initialize HCR_EL2.E2H early
>
>  arch/arm64/include/asm/el2_setup.h   | 31 ++++++++++++++++++++++++++----=
-
>  arch/arm64/kernel/head.S             | 22 +++-------------------
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 10 +++++++---
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 +++
>  4 files changed, 39 insertions(+), 27 deletions(-)
>


