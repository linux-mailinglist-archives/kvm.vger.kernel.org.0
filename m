Return-Path: <kvm+bounces-65656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED23CB31CD
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 15:12:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E5109314E4E9
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 14:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636733101B2;
	Wed, 10 Dec 2025 14:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XA6L4CjN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HX7zaZ8P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E006F1917F0
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 14:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765375662; cv=none; b=afx+yOr/zZ1wCUmmABzFUfdZS2pSyp1gnIKyUNvmzOvltmspXca9I8qBmOuabuXlhc6DuAgXlvPfyiqpP2fvFpvo00CfVQNcFEl58DosCFZPeESkBNXEuAE9Lf3pxRnz/m1udzI/4WdoyifelWqrXxOa6YeDfKPiYWNjS8e8mGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765375662; c=relaxed/simple;
	bh=EWi3grHBQfPa8q5/spQ/ZuH/8lqW+7LRu/RVZpc+ND4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=J/DKPGjzlRTdRsRtnW28zu6rz3dJXRxEv3yS0yBCT0P+x8xUNNXcwp8nihrc8enqJhrqTyuO7ijjV46wpz0rDfA9BWMb+5UTMvu5PIwgnu/228j4aNWdiGUk9KnRdbSS3QKO6N0iaf9sDcCIoj9q/hjnBcucipX0iqUbCYI0C+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XA6L4CjN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HX7zaZ8P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765375659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PMiPZXUtuktCOVm722m3AfqoLQZ8gTN/Ev3snLHnVc0=;
	b=XA6L4CjNlSFYoJ2F0xkJn2PEBYVF0ttQuoKQ2hCApH68a5bnIq5B7OcT68/IfkXcumVNA4
	d922WliehCNDuIe3hWZTjF5BLYuXSwbwAy+cHNy6+yO2yy+tMTMd71BFTzl66D+obMCXWI
	JOOUMKLx9B/o8PdjHrIfCrHapD5Av8Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-7DPLiZ_VPBuUJvhLnDFEpQ-1; Wed, 10 Dec 2025 09:07:37 -0500
X-MC-Unique: 7DPLiZ_VPBuUJvhLnDFEpQ-1
X-Mimecast-MFC-AGG-ID: 7DPLiZ_VPBuUJvhLnDFEpQ_1765375656
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775d8428e8so51219815e9.0
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 06:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765375656; x=1765980456; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PMiPZXUtuktCOVm722m3AfqoLQZ8gTN/Ev3snLHnVc0=;
        b=HX7zaZ8PQ8F/zVwr6Rij4MzIFDELDtAMURO6uGYBaPKmIIipi1gKKv3sYOR5cpDF+d
         0OFd1enIUz6+X0zRPh1yvOBq4/sAAGZ1kWnwYW0KtwUPyyWq3B0WvWPSd/zcpJItVvYw
         NGnaEGdkjLt6wCyG5+4+/H1jccdyhu9s+gdQQ1rNoXKIqjtwOOWl1KmgTaqoVTwAidzi
         8DlubAC2zdgOTZbpHcsOjpRoEr3nH1/7+RfMXciZfmNT0dRrkpkh2qJDT+gpxGZLqgRu
         xRaeRWKG14dZR1sG8g8TdfrtFnCeKkDRUkpterH0yIfQAFRyRUBuXI7V4uvFQyS8LYHb
         aNPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765375656; x=1765980456;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PMiPZXUtuktCOVm722m3AfqoLQZ8gTN/Ev3snLHnVc0=;
        b=JsC5zVE1GZGwa3B568B9N02oG6uH5evmBjQePmok+mGfEBWpv7nq018D2iyzov3kQT
         4KYDfPxpu6gCgnNCfzdOuPSGP7C9Ebhm6RwyU7BlZNKHDauAgbBfcc8RFeGhY9qt5DYp
         BJ30BHp/dviyiftzZubwtZSZ2i87J9DOCMlExRL1k+a7Aw94N5hrAplkoKsCy775rI0j
         CVSFU3G05476IKLAKYWXG9ji8bEy8+1ECP3uglUOVtICne+lHcYDfI+pxmDcydZFgRvy
         CwwopnroOXLR9aJuq0UfV/1dq/kIv9m4h1PYVXGUmX3dosV82qww1Pwvel9sYoeE34LT
         nn9A==
X-Forwarded-Encrypted: i=1; AJvYcCU96sl8PVEPWIt/oF5WMboko6aLxavcPVmyo81D93k6MnNE6ckQyCeHusdB0b8nui7ys7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIieTTlOgzS37LXyzJ1ikPla2r8TsjCrSCcViAnzy3/Y7TvBod
	Qh4r7e0oBeiWGmBreEcqUro42Cf/d7oHbUUZDqETMZdk+1JBDGBNRSEI8XisRwYE2nHTiYPYB+a
	qbRrY17AKZwGPNsphGEqrdDZtQoVR9SEmJAlKTJL/4uH5aTeRt+aqnw==
X-Gm-Gg: ASbGncs6xeF1PHwLd7BxW0UAx+auwLqjUgdfksnh1JhPcNDoDd6hY/g6lF9fImxZqsO
	w8TXImVVK6xXppCMBcDsUplLSjDz8QZSZULAPw62Cw+QljAd71+8T0em41s/4OwOHMn/Rq130An
	O926PxIwFF/EPfZSdDgtcWhDYTtUJqvK8elf8a6a6fqGFZAQAlbUO2+OEZh6rwXByHKrpsKkgXJ
	n0kgT/svMGiR7J7b2nRiOpGAEO1YYuIvrTAdW1N6j+Q3h2V1AAn0T5YPa3P+taikqfaXtGHLZ34
	IZfko6TlCTlpgjfkAitoNdDR1yEBHtnzhMLyMkksoTv5hL0xYShyUCTFWEkK7VpfptD+/BFqhOW
	/JvHqJQ==
X-Received: by 2002:a05:600c:8183:b0:477:9c73:267f with SMTP id 5b1f17b1804b1-47a83864325mr26322665e9.33.1765375656189;
        Wed, 10 Dec 2025 06:07:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMWCNZLH1nzNhtBEfhq6wY9mkwogjcrfiy6bbJu9YorLkV8n69bL+TNF+MvKZgfQ5ph31upA==
X-Received: by 2002:a05:600c:8183:b0:477:9c73:267f with SMTP id 5b1f17b1804b1-47a83864325mr26322305e9.33.1765375655768;
        Wed, 10 Dec 2025 06:07:35 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d3319ccsm36875153f8f.34.2025.12.10.06.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 06:07:35 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Ryosuke Yasuoka <ryasuoka@redhat.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/kvm: Avoid freeing stack-allocated node in
 kvm_async_pf_queue_task
In-Reply-To: <20251206140939.144038-1-ryasuoka@redhat.com>
References: <20251206140939.144038-1-ryasuoka@redhat.com>
Date: Wed, 10 Dec 2025 15:07:34 +0100
Message-ID: <875xae4ehl.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ryosuke Yasuoka <ryasuoka@redhat.com> writes:

> kvm_async_pf_queue_task() can incorrectly try to kfree() a node
> allocated on the stack of kvm_async_pf_task_wait_schedule().
>
> This occurs when a task requests a PF while another task's PF request
> with the same token is still pending. Since the token is derived from
> the (u32)address in exc_page_fault(), two different tasks can generate
> the same token.
>
> Currently, kvm_async_pf_queue_task() assumes that any entry found in the
> list is a dummy entry and tries to kfree() it. To fix this, add a flag
> to the node structure to distinguish stack-allocated nodes, and only
> kfree() the node if it is a dummy entry.
>
> Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
> ---
>
> v2:
> Based on Vitaly's comment,
> * Update comment in kvm_async_pf_queue_task
> * Set n->dummy false in kvm_async_pf_queue_task
> * Add explanation about what token is in commit message.
>
> v1:
> https://lore.kernel.org/all/87cy4vlmv8.fsf@redhat.com/
>
>
>  arch/x86/kernel/kvm.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index df78ddee0abb..37dc8465e0f5 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -89,6 +89,7 @@ struct kvm_task_sleep_node {
>  	struct swait_queue_head wq;
>  	u32 token;
>  	int cpu;
> +	bool dummy;
>  };
>  
>  static struct kvm_task_sleep_head {
> @@ -120,15 +121,26 @@ static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
>  	raw_spin_lock(&b->lock);
>  	e = _find_apf_task(b, token);
>  	if (e) {
> -		/* dummy entry exist -> wake up was delivered ahead of PF */
> -		hlist_del(&e->link);
> +		struct kvm_task_sleep_node *dummy = NULL;
> +
> +		/*
> +		 * The entry can either be a 'dummy' entry (which is put on the
> +		 * list when wake-up happens ahead of APF handling completion)
> +		 * or a token from another task which should not be touched.
> +		 */
> +		if (e->dummy) {
> +			hlist_del(&e->link);
> +			dummy = e;
> +		}
> +
>  		raw_spin_unlock(&b->lock);
> -		kfree(e);
> +		kfree(dummy);
>  		return false;
>  	}
>  
>  	n->token = token;
>  	n->cpu = smp_processor_id();
> +	n->dummy = false;
>  	init_swait_queue_head(&n->wq);
>  	hlist_add_head(&n->link, &b->list);
>  	raw_spin_unlock(&b->lock);
> @@ -231,6 +243,7 @@ static void kvm_async_pf_task_wake(u32 token)
>  		}
>  		dummy->token = token;
>  		dummy->cpu = smp_processor_id();
> +		dummy->dummy = true;
>  		init_swait_queue_head(&dummy->wq);
>  		hlist_add_head(&dummy->link, &b->list);
>  		dummy = NULL;
>
> base-commit: 416f99c3b16f582a3fc6d64a1f77f39d94b76de5

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


