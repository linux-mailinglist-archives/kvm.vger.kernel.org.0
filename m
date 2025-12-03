Return-Path: <kvm+bounces-65204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 490CEC9F1D6
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 14:24:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 63C77345C3E
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 13:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83B62F746C;
	Wed,  3 Dec 2025 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KKBDNM+D";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="N3bUEzLl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF172F6914
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764768258; cv=none; b=bJ5F+Q6yjsN4QjrWPx2K8AwMCTQmBLhSV2xYI1XV3JlI/hCnwpWTO4KCs/7ylm0XblSFbpfRQajdWVYsh4sOdLi1gl4oXhZyJ7BSX0YhjGkM6DP/KWiuCYCAcBhNYGisM5B2EK40V/YyJC1PF0SSgYKsXVw0gl5GM3Boq0XJeP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764768258; c=relaxed/simple;
	bh=vYbwrKiuy/nqRHww2lZyrm0K8+XZvOpvTaTp/vfjgjU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FfqudEHUXhezoPAE3kwvFRr4+TEfXePEAxRdDtFS6BPBEbXsel17m5SOcpfKY/L/2w0D133lzXS+qQgptJ0wU0lcBOflngVFJVYn7CVsf9RjmriqloJOdVJjd+2Z5eilfRQUgV/bzN+juM+PeYisJPfo8GVNTtCWF0lW/xMLuV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KKBDNM+D; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=N3bUEzLl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764768255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9vREb+ITR5XR/PgvDVqxuLRZqNTAuz/fXzGrnGKDL5s=;
	b=KKBDNM+D1SxSV1BNg2lOhQo3jm33NKg9Jlrg12v846pb4wIxpSZ7u0buid9CI9XZ9v01HW
	GRmpYVTIUcgO19CITHYE12Q3qbrwLaZmeBGiqcJtgKY/n20FP12lnv7atVIG15qRMIgyoz
	n6N2m58Ox4Z+bDPcnlyq/2e7USRr8Og=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-zlgXh10UNamAdwqiANkvrw-1; Wed, 03 Dec 2025 08:24:14 -0500
X-MC-Unique: zlgXh10UNamAdwqiANkvrw-1
X-Mimecast-MFC-AGG-ID: zlgXh10UNamAdwqiANkvrw_1764768253
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b3155274eso3477104f8f.0
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 05:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764768253; x=1765373053; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9vREb+ITR5XR/PgvDVqxuLRZqNTAuz/fXzGrnGKDL5s=;
        b=N3bUEzLlPkzCxeoKNAV9HDKZUrRlUbn/mR0zOMVas88rsG1w19rZbqJWmKlPNoJWWi
         Wri2oOPnwt7GS5vvrIye4UV45o6jrFike+Ongd6a93nm739+WZrucmsVvOLpOQEPxKck
         abcN/lMe9RZ7LOkxbYj2tZMRo6qXbYacgWt/dmm9GfqlsraePRXXQFFHz0JL4uyPkrB0
         rzIQvZM1gHnDX3ysRzjl4WBewCJn1TAdEc0Wn+CRvyi0Z0Fo3tM6tcYCnZ3ABkY4P62c
         Wm69GWQk9hkz3svCjy1zUbkGraf3PlQ62E1fdaBKqGm9kg4AfO/g5pA4yPfGeaD/o/hQ
         /Q7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764768253; x=1765373053;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9vREb+ITR5XR/PgvDVqxuLRZqNTAuz/fXzGrnGKDL5s=;
        b=Y96F9aRjUQ2Jmr118DxzFcB1dRcy1Y2tutG6ZL687fvn0krDJLN2FGTHyMej6KP3zR
         drodGKjPfPzH9E05hANcW+zQK6bI8Xo7tZMXI0pmBkOCX17IKwn1u2uiloyUcC29hj76
         AMH1m5oSqHTkV7tYD/Bpfmf3czd63xG31vw3Vunze0xjuXBb2I6u5WkhbBTYbAeegUL2
         /3szpOSzzGszv9OTwktFwPln6K7uqDP0ByWm8xH834VH3J3d3VHx1p/TW3OkpLo2jjul
         3I4BDLzDuThfOCXjUV3GiXt3/cC3sy2AiQCyBCRZY3bAPlXLsan6Nc+VxFFyUIZyGUXe
         AWtg==
X-Forwarded-Encrypted: i=1; AJvYcCXPoGXs/PrqfL2mBl2jaa19Lh1DQBBvt2oJHnWwJPmrpIoyMPEygnRCg4WFULidTO6e1KA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/IEanpnESMctqS2Sco7Uu4tMWs0vfMTdduPytn6kCxQH/W6FA
	LZZ33XdL5BZqbObeg9mI7lbLHkXqF4AjE0TilQTJlQJHCDOP05MhoMJPQgKVEPi/zFmuLb7b9bx
	LbZdgwUNrTUdVlUYvVfQvDJ+HH9z8l5CGh7h99ijBJchVag2216wYUqvESEIWzA==
X-Gm-Gg: ASbGncvrOTxKsfU2bq3Dd5JKhc7hTv5GEi3rfwbQqHz24O7A9GutOUDABoOthY1E6vp
	sRPAIaAs1MKcAulT0P+MD63bqL30ItvpKuen0I0W9udlInKX7XbbISQBtgEZX+MxCF11fab1dq6
	Us/3oAdV/5BP9aRgxcAnaZ8DhKbmdREnO752rZ5uskZOa/+EmrF0ljhBp7yWdWeP5INcehqU0cF
	HhwSIhIJB0/aREtOpQMq/qVBUD8IT/5Wm6ghL1YSx44yYQTx/GLexnwje9Pi512CJblZas/DLWc
	gfz6P3Ymb6MSJCkcsl1JOSU5KcYru1y0ztLX2wgvBw4EbmWnX9bQekmoxH+uqxqsyNJkGV6K/GW
	tnHc0Fg==
X-Received: by 2002:a05:6000:1785:b0:42b:3b8a:3090 with SMTP id ffacd0b85a97d-42f731795e4mr2101847f8f.23.1764768253384;
        Wed, 03 Dec 2025 05:24:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTisZSQWjiFpFJ+4ztc6Q4evV6afH6I/PNjUh5d9NriJFXnm03EZSq4BU+p0zusnXG8gtNIw==
X-Received: by 2002:a05:6000:1785:b0:42b:3b8a:3090 with SMTP id ffacd0b85a97d-42f731795e4mr2101820f8f.23.1764768252955;
        Wed, 03 Dec 2025 05:24:12 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa5d02sm40052483f8f.36.2025.12.03.05.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 05:24:12 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Ryosuke Yasuoka <ryasuoka@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com
Subject: Re: [PATCH] x86/kvm: Avoid freeing stack-allocated node in
 kvm_async_pf_queue_task
In-Reply-To: <20251122090828.1416464-1-ryasuoka@redhat.com>
References: <20251122090828.1416464-1-ryasuoka@redhat.com>
Date: Wed, 03 Dec 2025 14:24:11 +0100
Message-ID: <87cy4vlmv8.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ryosuke Yasuoka <ryasuoka@redhat.com> writes:

> kvm_async_pf_queue_task() can incorrectly remove a node allocated on the
> stack of kvm_async_pf_task_wait_schedule(). This occurs when a task
> request a PF while another task's PF request with the same token is
> still pending. 

The important missing part here is what the 'token' is. exc_page_fault()
sets it to (u32)read_cr2() so indeed I see possibilities that two
different tasks will generate the same token.

> Currently, kvm_async_pf_queue_task() assumes that any
> entry in the list is a dummy entry and tries to kfree(). To fix this,
> add a dummy flag to the node structure and the function should check
> this flag and kfree() only if it is a dummy entry.
>
> Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
> ---
>  arch/x86/kernel/kvm.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b67d7c59dca0..2c92ec528379 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -88,6 +88,7 @@ struct kvm_task_sleep_node {
>  	struct swait_queue_head wq;
>  	u32 token;
>  	int cpu;
> +	bool dummy;
>  };
>  
>  static struct kvm_task_sleep_head {
> @@ -119,10 +120,17 @@ static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
>  	raw_spin_lock(&b->lock);
>  	e = _find_apf_task(b, token);
>  	if (e) {
> +		struct kvm_task_sleep_node *dummy = NULL;
> +
>  		/* dummy entry exist -> wake up was delivered ahead of PF */
> -		hlist_del(&e->link);
> +		/* Otherwise it should not be freed here. */

I think we can merge these two comments together and write something
better, e.g.
	/* 
         * The entry can either be a 'dummy' entry (which is put on the
         * list when wake-up happens ahead of APF handling completion)
         * or a token from another task which should not be touched.
         */

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


I think you also need to do 

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b67d7c59dca0..0a84a3100e72 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -128,6 +128,7 @@ static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
 
        n->token = token;
        n->cpu = smp_processor_id();
+       n->dummy = false;
        init_swait_queue_head(&n->wq);
        hlist_add_head(&n->link, &b->list);
        raw_spin_unlock(&b->lock);

now as kvm_async_pf_task_wait_schedule() allocates struct
kvm_task_sleep_node() on the stack and thus 'n->dummy' can be anything.

>  
> @@ -230,6 +238,7 @@ static void kvm_async_pf_task_wake(u32 token)
>  		}
>  		dummy->token = token;
>  		dummy->cpu = smp_processor_id();
> +		dummy->dummy = true;
>  		init_swait_queue_head(&dummy->wq);
>  		hlist_add_head(&dummy->link, &b->list);
>  		dummy = NULL;
>
> base-commit: 2eba5e05d9bcf4cdea995ed51b0f07ba0275794a

Sorry for delayed reply!

-- 
Vitaly


