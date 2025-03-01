Return-Path: <kvm+bounces-39791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 35609A4A7BC
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:58:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C380189C941
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 01:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 322DB198A2F;
	Sat,  1 Mar 2025 01:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3fHT3md"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839F717A2F0
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 01:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740794292; cv=none; b=jV62I4GL5OwMI2fTNN0LJdti8Y4D8os9OpYOeynfnsN+Lu6O4QhpcTeCRn8kN5o8ox11F144RuGYmPOXmpYtuc2Z0kj44FwGkW52GMqbNTAC8fFUAOap/Mnxhx7f4y73YIoQhjwCM6uNY8E3o6qu6Os8buEQsQRedvhhJQ+RT08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740794292; c=relaxed/simple;
	bh=kEDclhow7/2dMewcPPCcm8KpJgAP5iy4v8Dp4xuatyY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kx8aSBA6NdhBrHK83mmvvAb4PCBGxevWX4WoG0ehQQw0Q0Jn2MJOtPtNyGz2T4wMVuUKPdM3nZrZ742xwbQnEL1sbpojebWE6Z+Xi6rP805SF2kdRC6512HKv8WZmzU2QwhyDEVYdxAwVfCXR15Od8X2ZqNSwTGK3EbtIRgiIsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3fHT3md; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740794288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrUFtURkrk23cDvKk5L+52QjpEx0HNlammbx4W6zE+s=;
	b=f3fHT3mdDcAHZLwPhJu2cMzj0bSxVrgqbGfdna/nPPKmbxhM/f5726aEmH7B63Iswr4fut
	ZYn9P9C/96xdTor3I4HzKbP7QyGJYhVi10qiKVXATQcwI8d/sTJsHgnFOH9VH0/x00+pKt
	O9onn3U1YrE1m6mMse+BL/Q9f/8AyOc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-KqOk-HdSN3CLRQwDs0nQHQ-1; Fri, 28 Feb 2025 20:58:06 -0500
X-MC-Unique: KqOk-HdSN3CLRQwDs0nQHQ-1
X-Mimecast-MFC-AGG-ID: KqOk-HdSN3CLRQwDs0nQHQ_1740794286
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e67c58f0f7so32918846d6.3
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:58:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740794286; x=1741399086;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KrUFtURkrk23cDvKk5L+52QjpEx0HNlammbx4W6zE+s=;
        b=CjbSzQbQ1TNwhdRSChDaum12qTUDNobbo3bGz0KMPgZmHY9NgzYMs6rBbYTGPw8Z0P
         3cpJ0nt7GNkLYgCDMBsk+o31K/Ew8NlxfbUOYTNona+1gj80Fy1cXFfbKJQMbBPG4BUq
         dLsd7Cj78PeUpqCsh35/7ORXoYHACtlMzXtk3oyMg1L0Tv/dX4CyK6Gy8GXJBjF8Bek8
         jv/xH8UIvlUS/Q44xb2fa/r3UciTACs3T+2lR0bieXRUhjon+k5Su8vhfEKsytzTebQS
         U/x5dZ8PQ5ldp+MgF2r7tPEJRix2h+35kGmLL3wJKbp8L50abrdg7ICCDH9VIyyOd3H9
         qcBA==
X-Gm-Message-State: AOJu0YzwDWy2OB5jyXTyGLTd6mgsutJGNK5Moaa9I8MgQlBM46svulM6
	gu4r5L7v+pHkN1SHTJXCYTpfyrWA8Q982HLM4nG0nh/UMuEeTYmABbzLkeCuOlagAR/s2Iap1ZE
	Y3DKI3NjU8lWGo5H1fALckYZwkqWl4kK2MVVMF+rRKzanJwwYTQ==
X-Gm-Gg: ASbGncto90mxMfvdNgWc6GBEdJ98Dl3P5ItZwDzfDmtd8X6rAWNL7aq990ypzm6fygp
	3PBvtepivzPfypxVK9km0RjCdLJaxeZkxjFuWRvrfpAD+HdJ3rVQIEU58ee0aSvX9GGO6/MGre1
	pAHGSoCUc7EMFWZrJw7lV4LNMKKBl2IgUuL32V6BBPAMyknmDr8p+o/JVUJdsMHSkOlR+Mr3jtH
	LCa2mrrknM/jUwkEckS8MPULZu5YtrZszq03FquKoUhM0HKl4h3aovNZ8xXeBxyVczsk8knAv02
	5BpQS9wpxjc5xbQ=
X-Received: by 2002:a05:6214:2f03:b0:6e8:af1d:b12 with SMTP id 6a1803df08f44-6e8af1d0b31mr35061316d6.19.1740794285994;
        Fri, 28 Feb 2025 17:58:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHZPZ6v2IkGLfObb5MGs0WXLJy4Yw5NYy7QNF0RxkrMEW8so/B2hqlKmCYl/y+iZKPFdiRb3w==
X-Received: by 2002:a05:6214:2f03:b0:6e8:af1d:b12 with SMTP id 6a1803df08f44-6e8af1d0b31mr35061116d6.19.1740794285665;
        Fri, 28 Feb 2025 17:58:05 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8976608f2sm28476866d6.53.2025.02.28.17.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 17:58:05 -0800 (PST)
Message-ID: <0ca86313d7fc0360009888243b1493c2bd44fb7b.camel@redhat.com>
Subject: Re: [RFC PATCH 08/13] KVM: nSVM: Flush both L1 and L2 ASIDs on
 KVM_REQ_TLB_FLUSH
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 20:58:04 -0500
In-Reply-To: <20250205182402.2147495-9-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-9-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> KVM_REQ_TLB_FLUSH is used to flush all TLB entries for all contexts
> (e.g. in kvm_flush_remote_tlbs()). Flush both L1 and L2 ASIDs in
> svm_flush_tlb_all() to handle it appropriately.
> 
> This is currently not required as nested transitions do unconditional
> TLB flushes, but this is a step toward eliminating that.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 1 -
>  arch/x86/kvm/svm/svm.c    | 4 +++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 0e9b0592c1f83..0735177b95a1d 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -491,7 +491,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
>  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
>  	 * things to fix before this can be conditional:
>  	 *
> -	 *  - Flush TLBs for both L1 and L2 remote TLB flush
>  	 *  - Honor L1's request to flush an ASID on nested VMRUN
>  	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
>  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9e29f87d3bd93..8342c7eadbba8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4044,7 +4044,9 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
>  	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
>  		hv_flush_remote_tlbs(vcpu->kvm);
>  
> -	svm_flush_tlb_asid(vcpu, svm->current_vmcb);
> +	svm_flush_tlb_asid(vcpu, &svm->vmcb01);
> +	if (svm->nested.initialized)
> +		svm_flush_tlb_asid(vcpu, &svm->nested.vmcb02);
>  }

This makes sense.

Note that this doesn't really flush the ASID used, but rather ensures
that we will flush it on next entry via that vmcb. (because of new asid,
that will be picked, or because we set tlb_ctl in that vmcb)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

>  
>  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)



