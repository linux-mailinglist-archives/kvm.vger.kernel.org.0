Return-Path: <kvm+bounces-53779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDA2B16D31
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AF403B46B6
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7EDC211706;
	Thu, 31 Jul 2025 08:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U6t4/6Oj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E061D618A
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949337; cv=none; b=MXpywmKyn5ZmhD5X59fYnqSHSjn/TkOPKO1BCb7NYzVz4OAnQ46p2vH3l0OzWa/e3WukXIRQg55xpo2zodxCLMdoDT4IEwcOnvrWcu+JlH2HUE5jwqeHXvkWJI2KngtSE9xHBqOcAmgGqXskEEwQfnax75MzMzznacabtqnZiGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949337; c=relaxed/simple;
	bh=sOdpA6ePDmomXzo1Y2B+Mmkj9rNOUEog8vH9h84ed5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mQMReTu0hd+2QIHdYUQhRu3e+z1twpjpvfd2uRv8i7FG7TLm1P6CCsT/Gm2VfL2Jre2SSrytaPClV/ISFWpnj+lD4DEdRpHXcmcJUMyY2YimosVgGZgDYXawv7dBxeJ/o/fKNWUt4LfNpN4DPPTEyQgWa1IO5DqMa+v1I70pQRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U6t4/6Oj; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso274321cf.0
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949335; x=1754554135; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GnPE+sz1C/80U9yCW9/f/ei/+/2FFUemOvS6oEBnVic=;
        b=U6t4/6OjsX5U1G5ai8+ikOloVpbviPj9OuJXZ3x2wsSf+8t2Hul3wUkzAE8b20BGZ/
         bgj0A4OWRC/d3D+a2IUvsBf/5aGtJxmaNPJowlyffasSKficV9I9sBORINMhHPnddMnV
         /W5vA7UDtMqmHJfoLt/8uRF4cjeM8LAomz3s1TUJsz0D0pcPVy9DhyQPk6VzMQ4v8B/G
         uG+QlWb8jhklVswmcVBbL3BGsULdDzcy73TBGV0fc4rP6bJZiZoeOeF28O+0V7Mun/kt
         5hu4lbXJhk3Ujm2F/Vr0PmMsDTGojHeh5+drYoRivuC6GQ35KT+9lS4Qn9NvfI+Y4RK1
         Gt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949335; x=1754554135;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GnPE+sz1C/80U9yCW9/f/ei/+/2FFUemOvS6oEBnVic=;
        b=eBCofpr4rJxcbU8o9U905mCF6HcJn6jZJzFZZ7becv79puw2rZq1tXKq2p9VTeTAT2
         StxmKSIiRY0C+zeNnHQTiugUFeLGo1/PmDk/hlsyDylHzi6GoKCxE8Yt/+d50uHNG6v3
         GSkjkSBC5iZXycXb4pRtTiMeyp+TzWz3ITuu4gBiNlS7S2LGJemsyWO8b6aZqm4lcpb4
         5twzQlKkH5zg1InWzD3D8J0NMhQsEga7Z+duU1CtyO4NzWHYqQfSBSQ+JAapZ2Z8/JJf
         rKlDcutoghLQoQLgFb7ij+X0n+/kLuIj+rmh71m3hxGum94wT2LYtucpnrCOjFqM7yq0
         qjQg==
X-Forwarded-Encrypted: i=1; AJvYcCVDvJIUC7PfMzfiDcMDHc4LbSwTqWdTVLpnDLwFlg6GrVKZJt1sSNEejYVujS4waJXs2o0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjq8HlDfdKmIjFzmUVCU5/BcWB1CoXn3kT4Rz94UVQnjh+U6wf
	poP1vYQV2lp5LX2lyHobxviMrRBlh627QVRMHuDdqfFeTqcgH8sJt7YIx73zU4bxJY7oWF2iJDN
	SM5aFtQyeYSp8t1cwPTHqedT5eZUq9H2qCHBWkFVa
X-Gm-Gg: ASbGncslbOLYvWS2CDxHra8PuOH3pcZAJkSJTp6YDDfavBTT1aF+aKCXWqAJR000tOc
	FUKtc9oz7Jb3xc3x22cLA7gWgXsAiF2w1nv+TUMARgEAnK6zs1ZadL4vBRlB+RHyc6ohF0caiwH
	ipqmRpinaj/rnIs3hS/VXv/AVElGwqYWX0Qebl1H0HalOuZ95k4BjaoE9lqVwthsY1FgK8hyG68
	zwify8=
X-Google-Smtp-Source: AGHT+IFK/wJp553R4XjzZSWJ+dcd/8ojrcK2vt8dKw6Dg/D6YDKGLkDZhQfaq4WdtYxdsAtQNGiLyd6uqBH+0njZkJk=
X-Received: by 2002:a05:622a:178c:b0:4a6:f525:e35a with SMTP id
 d75a77b69052e-4aef1c6158fmr1665301cf.9.1753949334737; Thu, 31 Jul 2025
 01:08:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-4-seanjc@google.com>
In-Reply-To: <20250729225455.670324-4-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:08:18 +0100
X-Gm-Features: Ac12FXwMtfUYkRsjJ3iXPfnzRPX0pAHczqzVmU7Q3OVeBtET53NBzRBcYs_fBLw
Message-ID: <CA+EHjTyZx5pU6Qhe8HNw_ciGXDVfasaD6eBnofSfUJk3VnbzTw@mail.gmail.com>
Subject: Re: [PATCH v17 03/24] KVM: x86: Select KVM_GENERIC_PRIVATE_MEM
 directly from KVM_SW_PROTECTED_VM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>
> Now that KVM_SW_PROTECTED_VM doesn't have a hidden dependency on KVM_X86,
> select KVM_GENERIC_PRIVATE_MEM from within KVM_SW_PROTECTED_VM instead of
> conditionally selecting it from KVM_X86.
>
> No functional change intended.
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---


Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/kvm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 9895fc3cd901..402ba00fdf45 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -46,7 +46,6 @@ config KVM_X86
>         select HAVE_KVM_PM_NOTIFIER if PM
>         select KVM_GENERIC_HARDWARE_ENABLING
>         select KVM_GENERIC_PRE_FAULT_MEMORY
> -       select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>         select KVM_WERROR if WERROR
>
>  config KVM
> @@ -84,6 +83,7 @@ config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
>         depends on EXPERT
>         depends on KVM_X86 && X86_64
> +       select KVM_GENERIC_PRIVATE_MEM
>         help
>           Enable support for KVM software-protected VMs.  Currently, software-
>           protected VMs are purely a development and testing vehicle for
> --
> 2.50.1.552.g942d659e1b-goog
>

