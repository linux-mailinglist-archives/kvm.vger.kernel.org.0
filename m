Return-Path: <kvm+bounces-11546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D977987818A
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:24:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D32BD1C221C4
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F7641A92;
	Mon, 11 Mar 2024 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JwYCEpQp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC93F4087D
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710167017; cv=none; b=MAaXVNbhIM7NTN4ljDBrWKXnoJu1LEXjAIPzZ1vQpM7rRN4ECv2M1QF3/Q/w2myHLlmDn1kTRIS9D1WB45jFJZsYRz37VOdSfydpGg2Y/OlIj40X/YPQsTpyFttuRkRs042F/2Vh35UFIinki9MdXSBbPdpNCAQfvodcA3J6aAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710167017; c=relaxed/simple;
	bh=fa9XFAx9obZMO3B1JrvGxK3phLC5+gaUosXQRL9JBXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kqt4nvRNEJaTjuvoI2/mOH2n+DuBzoHCHqD4LR5xHW5xhrPST19YUmEU1UOnoGUKgiAU7j9ppxkGq/q5l0d61keN9TzzNlwBpLufFLDKhJ7N7Wz+k9lBqszYddPgZuB5iVwfe/4c02g8fYZa5cL1fLqyf7zk4cu8X42dJTVpnik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JwYCEpQp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710167014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mcf3zxaA2/sjs65yJU+BuOcFQDAU/c/WjG2T49wjTRk=;
	b=JwYCEpQpTKzQ5KbqK4DnINB0tiZX0pRGJntn3jj1fk1qwOLsI5aiUHLWV2DruHWactmIwz
	+o1WdOqDL657AWmnjvG9Zmx7HgdvAfkYpBjNdUJwIqIUBx1OfwiOsec/CXopg5F1nvA9q+
	ysWb3vxLo3fINslGvW2VlVQklmqaivs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-Y48KUpC7NsGfk_VTU5NxKg-1; Mon, 11 Mar 2024 10:23:33 -0400
X-MC-Unique: Y48KUpC7NsGfk_VTU5NxKg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-513b15ac588so656765e87.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710167010; x=1710771810;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mcf3zxaA2/sjs65yJU+BuOcFQDAU/c/WjG2T49wjTRk=;
        b=csGtLQShF1kjowcEghV8eKwnKWkz8Ymy1Y2EjrX9pk95EGh+BMY74j/08q6IVLrEpE
         vJ1otoY6y+YV/B9Sq4cyYQ9duwYt2vDEoO72AZczr2eaSa4RvcrVfl4R9ExyVythniSR
         la0FRoLXYvz5sGclmJtHi+nerdOszMIhvxV8dXuREP+8i4Ir7uBV2cj9XqHbElNzoJ3W
         zRD+eER/UurzjPmd6roUCf1Lbf+vbLmMnRtoJL7vQR2ibwG2m0RIZ+QTLtmnZUnALtlI
         d/avQER4mT0yCxVWgIgH4uxFUZlnS8V4P98UNXIG8xtDcC1zYd6pvGfHOjNC6baoHo0V
         CZog==
X-Gm-Message-State: AOJu0Yxxrs5ZXrwRJpW+ANZpvtbcg4KxK+2kWcwWwZfdq7jANLhM0Tyo
	cv27xxyn8zU/Fyfc+8Sk3mz88XQy6vQq0SKvTjMjTzkBYCPATu4SdwdcKNSPUOa+RP9TKWfn5Ll
	fYpr3BqPfY7o8jNSoMS+XdTFjSR3mHlNKK+bdwW0DI/plR3eSHkZu8iVhRQ==
X-Received: by 2002:a19:3807:0:b0:513:8f53:cab0 with SMTP id f7-20020a193807000000b005138f53cab0mr4566951lfa.27.1710167009754;
        Mon, 11 Mar 2024 07:23:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4GtFvDr6xQlX8J6xMadJVdLCHI39/5fwrh+GPsoGYKQ0Np7yncZS/GYTcv4UgbIHFDYe5+Q==
X-Received: by 2002:a19:3807:0:b0:513:8f53:cab0 with SMTP id f7-20020a193807000000b005138f53cab0mr4566943lfa.27.1710167009369;
        Mon, 11 Mar 2024 07:23:29 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id et8-20020a056402378800b00566a4dec01fsm2972343edb.11.2024.03.11.07.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:23:28 -0700 (PDT)
Message-ID: <bb3af2ec-fc5b-433d-aa43-ea4d9a2b8863@redhat.com>
Date: Mon, 11 Mar 2024 15:23:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: Common MMU changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240308223702.1350851-1-seanjc@google.com>
 <20240308223702.1350851-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240308223702.1350851-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 23:36, Sean Christopherson wrote:
> Two small cleanups in what is effectively common MMU code.
> 
> The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:
> 
>    Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.9
> 
> for you to fetch changes up to ea3689d9df50c283cb5d647a74aa45e2cc3f8064:
> 
>    KVM: fix kvm_mmu_memory_cache allocation warning (2024-02-22 17:02:26 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM common MMU changes for 6.9:
> 
>    - Harden KVM against underflowing the active mmu_notifier invalidation
>      count, so that "bad" invalidations (usually due to bugs elsehwere in the
>      kernel) are detected earlier and are less likely to hang the kernel.
> 
>    - Fix a benign bug in __kvm_mmu_topup_memory_cache() where the object size
>      and number of objects parameters to kvmalloc_array() were swapped.
> 
> ----------------------------------------------------------------
> Arnd Bergmann (1):
>        KVM: fix kvm_mmu_memory_cache allocation warning
> 
> Sean Christopherson (1):
>        KVM: Harden against unpaired kvm_mmu_notifier_invalidate_range_end() calls
> 
>   virt/kvm/kvm_main.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 


