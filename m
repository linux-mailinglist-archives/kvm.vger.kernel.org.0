Return-Path: <kvm+bounces-55741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B67B35BE8
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 13:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 471643629A3
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 11:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E143002B9;
	Tue, 26 Aug 2025 11:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z1mtbv9S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E08F21D00E
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 11:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207413; cv=none; b=QPt+nGSS/iVsctdW8fcdZN5LHLZd1LD8l/p5JpbSCZuGa6kK/TrLqQfMIYC2Aw8j9lzvRYa6oBmQPLntsfSlER39rfiVAphJjCGT2X1cZ9z5yyc96x/+zCKvPWJ6RjpL9CLWn46lLANVPtlgMkgFTvZqpybjqDXczqb7yR0Gswk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207413; c=relaxed/simple;
	bh=CIOVPvJCXhO8Lq5JG1wwHhD1r5FTDjHoZtr02L1NTjI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e8IlCuQHM1Y/6HCLVw0hUqdx83EkrTXYE+wENih3PaXbFefyrR+UHOQAFSpxKqEDihKyojPB58mrjyMwhpT3rR0kqpWgQBIKqQ5ZiLRlfIywE5Ie/hJRo8EToeJCn3Xb+cNf6FurY/IWtMtPSDMvv3oeXAf6POTXerBej2NvPR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z1mtbv9S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756207411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8cBugJJub36Mrueq/357PIlWuiu3NshY04ejaBBzNfA=;
	b=Z1mtbv9SIm6Mid/KM7synJHyU0lWmLO/t12x10+hLgAKIVX88QHHdCuy5+66aoeHLEahv2
	FBlGhP4n9yUy6P6zmSzOl9U8Z7li6+/6hWF6Yqfp7wmyUKilR3cc1x01z9KqhXoV8iZVU2
	oynjulhKDDbrlT+8SsES+dQtKhJyMpY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-ceCD0ghkPu6adOVr5RYKZA-1; Tue, 26 Aug 2025 07:23:30 -0400
X-MC-Unique: ceCD0ghkPu6adOVr5RYKZA-1
X-Mimecast-MFC-AGG-ID: ceCD0ghkPu6adOVr5RYKZA_1756207409
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4b10946ab41so131906711cf.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 04:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756207407; x=1756812207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8cBugJJub36Mrueq/357PIlWuiu3NshY04ejaBBzNfA=;
        b=OdzWssw/AovxqE2JOcFzIYp/lIBnhFkzLGj/w+UeLtHtgP1NOYz41si6sICxrqCFu/
         WUpuR9U/UvioZMB2Ag2SMCD7ilBxtPCtNAX6BBspS8M55x0A57QpYLfTo610PLVslZoH
         LyMcz8ZBbAs9M7l0TRmFmrMgCIhxdRy8u6knDeuIVZJ29/v/wUwgKu97LnE7VBq5B1hS
         aDEyIQqXvOlw7VLlOR9GHWZs7gszGpYe9JgDu8qg25McwU8u4/OqUaJlCIlE+Gs2j4Wu
         dd3d9txkO7LjsCeXUy2it+lYnOO2WOCbs6iVfNlaPHoYXy3WEJanA6X/i2btlQK7TiV/
         cycg==
X-Forwarded-Encrypted: i=1; AJvYcCUXliyu+3rmG4QP2uhL/YoKURsTLKf2e0H7G+no+i9QXKylNTVEtDDiQaiifbhBMET3xtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzY8cj3berByLqFrMWMdYBxI+vKPb8KNrklg148gRmG/yB0zzGL
	3aJMgNqrlt4+WfiaYpo059cI1FYL97/Ht9p6YkNKfSwEiRK5oGEKQ3APfs7pAtXn0XKIAMn8YWC
	5lL4DWe+BY+A5nwdSX4iRd4zMcXI5yTaRY0jWwGr1VVoh+wKJkrqD7eo31qWvdA==
X-Gm-Gg: ASbGncueAdiakduLRWMJkrSew5uIDb1RNuyXpucz1LxXbjCVD1eXEJ50vgSvQ2uDelN
	X26AoQ4/juGRiken5YoafTg6SSM3v6nvxsYiVh3ve64EWtCTqToxrGuU1YP0c3ITISLeRWqPmHl
	rRbEPvoQqhujs6LWTyrJz1qG1+zHpgJoPtNpgdLHZ/LXvnz0k/jToUYsC9+4U+cqDVyishcYy8K
	73ysws8fhwjGdM6G6o9SkfzBaYiB4PgB/mGXG8idm1GqcJYnXsRotGs5kmKTXLLgBbr03caywBR
	N9VHk6ueLodIgV4WhydOlOksgpTpkQ==
X-Received: by 2002:a05:622a:4c14:b0:4b0:7521:3ba9 with SMTP id d75a77b69052e-4b2e76f7ba6mr10849541cf.14.1756207407192;
        Tue, 26 Aug 2025 04:23:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXBfMGyjW9CyAOH5d4T0/t6MBzTl+/Lg0erCZk3HzO3qqTRnSeZRe3UaBUnknpkPBdAfe83Q==
X-Received: by 2002:a05:622a:4c14:b0:4b0:7521:3ba9 with SMTP id d75a77b69052e-4b2e76f7ba6mr10849241cf.14.1756207406777;
        Tue, 26 Aug 2025 04:23:26 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8ca8d93sm70688711cf.18.2025.08.26.04.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 04:23:25 -0700 (PDT)
Date: Tue, 26 Aug 2025 13:23:22 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, richard.henderson@linaro.org,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v2] kvm/kvm-all: make kvm_park/unpark_vcpu local to
 kvm-all.c
Message-ID: <20250826132322.7571b918@fedora>
In-Reply-To: <20250815065445.8978-1-anisinha@redhat.com>
References: <20250815065445.8978-1-anisinha@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Aug 2025 12:24:45 +0530
Ani Sinha <anisinha@redhat.com> wrote:

> kvm_park_vcpu() and kvm_unpark_vcpu() is only used in kvm-all.c. Declare it
> static, remove it from common header file and make it local to kvm-all.c
> 
> Signed-off-by: Ani Sinha <anisinha@redhat.com>

Reviewed-by: Ani Sinha <anisinha@redhat.com>

> ---
>  accel/kvm/kvm-all.c  |  4 ++--
>  include/system/kvm.h | 17 -----------------
>  2 files changed, 2 insertions(+), 19 deletions(-)
> 
> changelog:
> unexport  kvm_unpark_vcpu() as well and remove unnecessary forward
> declarations.
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 890d5ea9f8..f36dfe3349 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -414,7 +414,7 @@ err:
>      return ret;
>  }
>  
> -void kvm_park_vcpu(CPUState *cpu)
> +static void kvm_park_vcpu(CPUState *cpu)
>  {
>      struct KVMParkedVcpu *vcpu;
>  
> @@ -426,7 +426,7 @@ void kvm_park_vcpu(CPUState *cpu)
>      QLIST_INSERT_HEAD(&kvm_state->kvm_parked_vcpus, vcpu, node);
>  }
>  
> -int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
> +static int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
>  {
>      struct KVMParkedVcpu *cpu;
>      int kvm_fd = -ENOENT;
> diff --git a/include/system/kvm.h b/include/system/kvm.h
> index 3c7d314736..4fc09e3891 100644
> --- a/include/system/kvm.h
> +++ b/include/system/kvm.h
> @@ -317,23 +317,6 @@ int kvm_create_device(KVMState *s, uint64_t type, bool test);
>   */
>  bool kvm_device_supported(int vmfd, uint64_t type);
>  
> -/**
> - * kvm_park_vcpu - Park QEMU KVM vCPU context
> - * @cpu: QOM CPUState object for which QEMU KVM vCPU context has to be parked.
> - *
> - * @returns: none
> - */
> -void kvm_park_vcpu(CPUState *cpu);
> -
> -/**
> - * kvm_unpark_vcpu - unpark QEMU KVM vCPU context
> - * @s: KVM State
> - * @vcpu_id: Architecture vCPU ID of the parked vCPU
> - *
> - * @returns: KVM fd
> - */
> -int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id);
> -
>  /**
>   * kvm_create_and_park_vcpu - Create and park a KVM vCPU
>   * @cpu: QOM CPUState object for which KVM vCPU has to be created and parked.


