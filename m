Return-Path: <kvm+bounces-8557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0BF8516DD
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 15:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7604B1F21539
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 14:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DC43A8CF;
	Mon, 12 Feb 2024 14:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPchTUMv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7AB1E4B3
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707747511; cv=none; b=ithRlWT3cIKLswWKwgGM/sQKZNnPg3U0Q8qJgEm7978gmZOzliRzcTWa4hzea6guqMUSKACv3809DG19knqj4Ukij0PMCo88dBI5RGtWa9fISQQNmYla80qqOP+YTQAW3ZZX5XPxiFCD6LLJ0GSTyN3s1VX7gFsVUJk4Ky8Vrec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707747511; c=relaxed/simple;
	bh=ORaM05u+SQpYXSj+eXNwTONcLStVssJo6HLOruOJg0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D9GOcQHSKGfptKAqKpsu7J/6QM0tGlwFG6j3Tv8+X95JyVbi6MeKN0T0BS39Vv/Xt6WMIxJ6j/LGV8AHPVHtTuvWQODCgatiGbdWWnoz1e7P0j5SzeuhjfBbFoj8f+16cuznvyJ95iGDqKAuoc5GAysFCVuSsZTbGqD4IVQ4PYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PPchTUMv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707747508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W48aKMa8BxxJLlskfhsAFGXteeZPFQl7GxLayCGIEtY=;
	b=PPchTUMvl9Hv1kQ8a+bmHiI8hAWuDa1tZkuzYjRz7LOcRla/AL5tOC+JKy5FodcDRjWrtl
	5LMxLOvLBftOD1/8dtrRYvmuM1NEclPst2Avq3E7KLtDM9e0d7wy/t/Zbyn0YCFbJNh9VF
	kTPgz6GEr022GUgKNYUPFtTys2Y4SJc=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-guYiaeW-ONK_bIO979GiHQ-1; Mon, 12 Feb 2024 09:18:27 -0500
X-MC-Unique: guYiaeW-ONK_bIO979GiHQ-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-60492d6bfc0so41924507b3.2
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 06:18:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707747506; x=1708352306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W48aKMa8BxxJLlskfhsAFGXteeZPFQl7GxLayCGIEtY=;
        b=C13iCQMHaGwy8+p1PXEexAh4cexLJuaM+sbp5tji6Dy0kJW7ccZhtHeAf3Amm8zB0z
         3e7RGmaWIS79wdXV2HTpTrfssTHzQFPQ9WwtlBhv+/BkJyLigqk6ns7MQ4RrND6cLx7C
         DHBUVsGbEEMFawPUxXIo3HTXNW2prV04l4Hbzk8gtb3YPJ40hJIQeEoy+T7BCn+HjpRk
         IQdMDv73BA5EMRF4q45kKPlJEYerxTxIRUcRo95BgqDkpoJyRVIGVGQ0Y362EcnEyZO1
         B+3wXrdlRw9EmCSF5vVhFHEdrNUvWWwWtl0spODhOShaY2mdNMbPi/PYS484+mcFwW8a
         Ttsw==
X-Gm-Message-State: AOJu0YyIdXLCKNY1YcMW3c8mu8+nfCQ0eXw33gTUZSUZOZO3cH2BzCJP
	eDGbLTk7PdqhHgz+qu7/N0LKhJqR5ijRniJS+aHoFT9bdbVHE1y3wYdX2dqa3/qyRyIJxShIUcg
	UnVv03s6OUojtv8SVSmGyYPCRAROvMXzu/+mny1NQNDHPyr8TWYxqkix8yZ69Vra9Apk6XkI1D0
	fH8jAk+bHNmVayTpw0bZfCJ1Btx81/veXpwAQ=
X-Received: by 2002:a0d:e808:0:b0:604:9ba3:13d1 with SMTP id r8-20020a0de808000000b006049ba313d1mr3962565ywe.14.1707747506600;
        Mon, 12 Feb 2024 06:18:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEr9iriaDlN5vdu7HHXbv+WvkPOeyIm6i1I5aenOm4DuBm2bZsCuFFJQ/BqNH+IhMX4V+hLMHFdpKxBMHEsEqU=
X-Received: by 2002:a0d:e808:0:b0:604:9ba3:13d1 with SMTP id
 r8-20020a0de808000000b006049ba313d1mr3962543ywe.14.1707747506283; Mon, 12 Feb
 2024 06:18:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1705965634.git.isaku.yamahata@intel.com> <591420ca62f0a9ac2478c2715181201c23f8acf0.1705965635.git.isaku.yamahata@intel.com>
In-Reply-To: <591420ca62f0a9ac2478c2715181201c23f8acf0.1705965635.git.isaku.yamahata@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Feb 2024 15:18:14 +0100
Message-ID: <CABgObfaEz8zmdqy4QatCKKqjugMxW+AsnLDAg6PN+BX1QyV01A@mail.gmail.com>
Subject: Re: [PATCH v18 032/121] KVM: x86/mmu: introduce config for PRIVATE
 KVM MMU
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, 
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 12:55=E2=80=AFAM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> To keep the case of non TDX intact, introduce a new config option for
> private KVM MMU support.  At the moment, this is synonym for
> CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The config makes it clear
> that the config is only for x86 KVM MMU.

Better, just put this as:

config KVM_MMU_PRIVATE
    bool

but also add a reverse dependency to KVM_INTEL:

config KVM_INTEL
     tristate "KVM for Intel (and compatible) processors support"
     depends on KVM && IA32_FEAT_CTL
     select KVM_MMU_PRIVATE if INTEL_TDX_HOST
     ...

This matches the usage of kvm-intel-$(INTEL_TDX_HOST) in the Makefile.

Paolo

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index cd3de7b9a665..fa00abb9ab39 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -189,4 +189,8 @@ config KVM_MAX_NR_VCPUS
>           the memory footprint of each KVM guest, regardless of how many =
vCPUs are
>           created for a given VM.
>
> +config KVM_MMU_PRIVATE
> +       def_bool y
> +       depends on INTEL_TDX_HOST && KVM_INTEL
> +
>  endif # VIRTUALIZATION
> --
> 2.25.1
>


