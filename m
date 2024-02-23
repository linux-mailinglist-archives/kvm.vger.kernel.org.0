Return-Path: <kvm+bounces-9558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C692F861954
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80F6D285A1F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2CB2134740;
	Fri, 23 Feb 2024 17:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3yQ4ffSH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852E712DDB0
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 17:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708960; cv=none; b=l1KEf9hID1iVw4abwO6mwpJFReXoV5wT9rWY5jyT61gIAHw47hjafJSJFAZQZgemb89VSZi7NVXJBuNSO9LFozM9Kt+LZxxmLUG+o+HdKeneDTazcngj/dPYOCi6Wx183if2M0nqggw+pEqjUN8lrrob+lCj5Jq123h6mNSLw/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708960; c=relaxed/simple;
	bh=xI1CYXpRQxNW6RhypQf+M8k1lJvk1Cdwf26jKyWxh9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k84hyx7/ylXApTobiR+QYMwm/XtoLK9nRROGRfc7Bo+V9sERQ0zNNn+zm3560VJCHYc9bHWz6nwwFEwmHMsi3vIJzG4N1DLxehQc/OaepyTR6KeCFelD18qVxXLTyuHI09BI4GESyMpX/pT8CDalvXmhvv35917dbiPl7UatsQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3yQ4ffSH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60832a48684so16483797b3.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 09:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708708957; x=1709313757; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fbdOsTQ4/aB9Xs+//i/yYaDnT36ysQWNMNiNUj7P11E=;
        b=3yQ4ffSHhQXMfao1E8/GViA4MRnYrQRIn75v76OQeDmZM4vJdccsjiq3T2LHkNF/1q
         LwTyjQy/Yz93PPSXdYiVkwBZjnM6EaBVAJTui83MFM4t771Kr3ihpJHfYk/CveHTnOXG
         798E6PIgkQrnPJq2nGNBi7croB8u3KQ+VMiD9Zpwbry9HENX4+y9/1RB8P8lIktyDA0F
         7bxjNQgnbI/qgeEvNRUzV8PgexiujJCkz+g3SN5jPRiuNLXvYuta4HLTAymnlKUzaXI7
         m4vI6+doksz5Kq7NK+BAnDVXozfdWjSt0vPndXNGtVVHLTlG9+3buUPhoBV+UmVE8ycs
         TgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708708957; x=1709313757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fbdOsTQ4/aB9Xs+//i/yYaDnT36ysQWNMNiNUj7P11E=;
        b=fBBxQA5C02xpKCGu2m/XRlFZCf3470ouFGitbfLsujZs+0vLGHBUxeI2Ko18NOcFON
         NB281Q3AJLvQrg0AsbpTrW4B00Uci3Skpl7QE2yn1r/8zQgZd1yOa4ypz4XjrIhPQmaJ
         jvnCBC7qCvXjILI+3Eo9Qbtxr0Nq9R5JRm2PSf8/aNmUlFRM2+4ZiJ0Kvw8dL2D3dHJy
         jXj96Dn5+4lungE9Lta9tTgQ+guQF0eVZXRjIkphBZVJxl3NK+2ILWLV9wbWoIG6vDG1
         Mhh+sWQr8WwwbKjivlBZUruztsyT2yJtGcJ0XGPgznxByAsxULf1PyG41YFk9MUF8VI8
         odUg==
X-Forwarded-Encrypted: i=1; AJvYcCU642a8YkDLgQIFQATqkiF2gNAixA8Co1DLMgUu9+WdxqgKJ5WzmC1NkOC6nJF3e/knULW1o5Vgs7PNo2dU6haFE80y
X-Gm-Message-State: AOJu0YwDc5GzMe27fWTvuneKR1G8Qvtj5j4MqTbcLmHy7FWgRDKxdUOj
	BOyhCRPqgREu/OWwbOUjzh+e6MqIAZcKWfIWTdIj2E7ZoW36s/9jaTpd/Ow3dR9pC+e+v7plEvQ
	WIg==
X-Google-Smtp-Source: AGHT+IHeGqi5Ue4Mu/H0ONtSYTiMAMvd1xoMjQat2ATYVRSjmG8qzOUsUnCLF3i9BZNHa5xBRqZlvKBRdPU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d592:0:b0:608:21cf:ef0 with SMTP id
 x140-20020a0dd592000000b0060821cf0ef0mr84992ywd.4.1708708957651; Fri, 23 Feb
 2024 09:22:37 -0800 (PST)
Date: Fri, 23 Feb 2024 09:22:36 -0800
In-Reply-To: <20240223104009.632194-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-10-pbonzini@redhat.com>
Message-ID: <ZdjUXCITwbAWe7LT@google.com>
Subject: Re: [PATCH v2 09/11] KVM: SEV: define VM types for SEV and SEV-ES
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> @@ -3193,3 +3199,16 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>  }
> +
> +bool sev_is_vm_type_supported(unsigned long type)
> +{
> +	if (type == KVM_X86_SEV_VM)
> +		return sev_enabled;

Oh, I almost forgot!  This is the perfect way to solve the mess where sev_enabled
is true, but all ASIDs are binned to SEV-ES[1], which sefltests doesn't currently
handle because the info isn't surfaced to userspace[2].

So it'll end up like this?

	if (sev_enabled && min_sev_asid <= max_sev_asid)
		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);

[1] https://lore.kernel.org/all/20240131235609.4161407-1-seanjc@google.com
[2] https://lore.kernel.org/all/ZdfQ4jI8yT-bvbV4@google.com

> +	if (type == KVM_X86_SEV_ES_VM)
> +		return sev_es_enabled;

