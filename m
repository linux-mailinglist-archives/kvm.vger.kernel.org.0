Return-Path: <kvm+bounces-53778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B439B16D2F
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EE143AB26B
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCDC28D8C9;
	Thu, 31 Jul 2025 08:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T8FNtaWT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565F51E1DFE
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949308; cv=none; b=rxDulR/yucUGXKDpzfjkOxvGC9OVNl0jRl4kM62uD34vBCSg9LJPKMmBleEi2xRAYUOs5RGry0NmlIsSv+jpArXxjaGP56LdeA7SXXNZSSh9JsgEDffPU+bWj4IaBVtHiTR7Ik7D7Yo0Kcd8S65vk4+a9j6ulRK9eUzPr3FJzc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949308; c=relaxed/simple;
	bh=e5Hocw5GiE127jmgexsLYEDO3B9Flp3i16mxz7Kb7EU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U+gAieDO1ZdAsdTTAUWuUKYohRRjd2NbKhpPizHfuhyCTx5KY47o7m4WuTJcziaz1k7kALEIkRhwUnsbHV3QO7qYKC8Pq5/DOYuMEAkjKvlqm+KjQQX5t3AsyNelRiwPp8ycYdg+OQGFx6PWtzVeB21CVcb0aL3YGGdJm9Uw+W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T8FNtaWT; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4aef56cea5bso60951cf.1
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949306; x=1754554106; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jeno8f5+usJMV/ac339wMG/DF96hWxCd1z1Rm4i7gbQ=;
        b=T8FNtaWT/pKrGr3ueeNCqCSatd0l8pxAyn6D+Z/CxtMpT1n9j1VgcgJtLLul78pc+8
         f4wvqMX7lCiQc/xnv/ZFfOE3ocJ3nBHVybZSlQT0eedFGkVB9Q1hvbILRDLQ3mj5OV50
         IiBPqxOIukPYG854KtUBrpO50SbB0/BjyT6s5tiBnoR4VMIFrEYNOwpfGztA9BQKGk5M
         rMMYm8eWNOZzuco802yqyUM+3L3hUOq1NxlNXtKs6SH1OXXveELt6wDANT6U9QAMHAUI
         p+2zZ5gZVQ25ANDw+lu8k/QhfK2rCZfivQz2ndDg3futpaW/jYlZKCUmLUK5JrVhSpER
         edSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949306; x=1754554106;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jeno8f5+usJMV/ac339wMG/DF96hWxCd1z1Rm4i7gbQ=;
        b=ZUYeveyYfP96EGZrs1gutDaMnVg+J7clG9T9ySrQweHY5PS2pSpUWKIe2AHqHQ09FN
         J/JogOpc1IDYLQRZPv85r+Kd63HvGMwT/HmeTQPW0qN1h+wtgQqGkGkhclxSiB8iVc2o
         qRZP8K1t8I97+sz+Fiqiu4ezUKt1GZDE/XO7f0LzkebzqwX0B8VKoNXUUQnhm0uFjuhC
         ZD2gPx9Fn04bnfzBwe5DLl9huFjmF5KMkJR3+Gi9z3RDQyhAgQ41SrZ02cXskWAMwip6
         IxVNS2r9snE6GvLYE2Ebd7QPdJp4x8Uc67+nBcmg9rsNxL5RNHvHcUFjLSirijpxP6kS
         xIGw==
X-Forwarded-Encrypted: i=1; AJvYcCUrUgkvBOLki9WlYvWL6S4NU/mNc5aWJQKaTnwkBtDGu8sFqWw4tv08j0GZswjfgtahd6I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx95MCPC+V//EkxjJac6+H7eaiVrMmpULKsoDyO4/3RBnIqvqrn
	KlFxBIawnD6wOb8ASUkR6geJmx3EXy/RQB+R1yJSQOCwZuu7r3X+TTFVyTtMQpjm03Wm++xYTVo
	4gjnjlFSzMJbyYHM/8AnJQccH46741QcWKWDCnFDb
X-Gm-Gg: ASbGnctYmOKttXRKmfPefMVOH3vMXYJFII8hsEzmhHJbbDQm0MD0PwhMz2QwJWM6YH+
	nQZqkKfwRSuqop2O9BNkYF/1lLYuM5gl+Y0lgtT5ia+piBGTY2oNrQ0n6FpfqSY5OVbWLEJhXu8
	hDL4RGV/p3X6tUH8Z2A3DTTlsnRhSooClCgep//yp3+3uN3RI4Pf5m5MnVFOfUtU2Bf36tpC765
	jofpNI=
X-Google-Smtp-Source: AGHT+IFbmVQN1x5b+62iRQ3U8XZDUkGVQZbiaLNVWtLXncLKF5qCofgpdoCiMDPvbq7m8yKnT95C2PAE3uUVd0hLcc4=
X-Received: by 2002:a05:622a:13cd:b0:4a6:fc57:b85a with SMTP id
 d75a77b69052e-4aeeff89123mr2556921cf.14.1753949305731; Thu, 31 Jul 2025
 01:08:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-5-seanjc@google.com>
In-Reply-To: <20250729225455.670324-5-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:07:49 +0100
X-Gm-Features: Ac12FXy0R_yNTeBd7qrXPHZNFcLfR6ujjjzcWA_Yc7EECI6d3AjDyGMKsJvuKKg
Message-ID: <CA+EHjTxHk4hsPXDiUY2nOfGdT9GjPvu7YdNKApkUJK4RjBKB4Q@mail.gmail.com>
Subject: Re: [PATCH v17 04/24] KVM: x86: Select TDX's KVM_GENERIC_xxx
 dependencies iff CONFIG_KVM_INTEL_TDX=y
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
> Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
> from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
> KVM.  There is no need to enable KVM's private memory support just because
> the core kernel's INTEL_TDX_HOST is enabled.
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---


Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/kvm/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 402ba00fdf45..13ab7265b505 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -95,8 +95,6 @@ config KVM_SW_PROTECTED_VM
>  config KVM_INTEL
>         tristate "KVM for Intel (and compatible) processors support"
>         depends on KVM && IA32_FEAT_CTL
> -       select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> -       select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
>         help
>           Provides support for KVM on processors equipped with Intel's VT
>           extensions, a.k.a. Virtual Machine Extensions (VMX).
> @@ -135,6 +133,8 @@ config KVM_INTEL_TDX
>         bool "Intel Trust Domain Extensions (TDX) support"
>         default y
>         depends on INTEL_TDX_HOST
> +       select KVM_GENERIC_PRIVATE_MEM
> +       select KVM_GENERIC_MEMORY_ATTRIBUTES
>         help
>           Provides support for launching Intel Trust Domain Extensions (TDX)
>           confidential VMs on Intel processors.
> --
> 2.50.1.552.g942d659e1b-goog
>

