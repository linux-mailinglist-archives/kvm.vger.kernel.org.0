Return-Path: <kvm+bounces-65063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B6911C99F98
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 04:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 245C74E25ED
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 03:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327C129BDB4;
	Tue,  2 Dec 2025 03:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B1QXDvL2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lyfcAQ4w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F851274646
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 03:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764647300; cv=none; b=Jqkb+yZkRkIMleKzwfjnK6yI5xrzggdM4MPQJoZtRIupX7D52MxhqtQl5w35HmQxTZuTl5MbQxPEprLugLZymXYpsay280rpEsIrCitN/62BEkDZ1gj3xlTIqMkcos/racFiquga53X76BHzzfbvBliYaOFtlfS6+aRBUz8oeEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764647300; c=relaxed/simple;
	bh=ZMfx66bdpaJivIFLmf32uKiPzwqpTL0M5QjJ0HjLuts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJcTgvUgbeTsMGs/UD8zDjVTaUrc9mKmUTA25bKD9SdkoCmY60Iinkua6R2mSIw7ic69UfdZ804m9oybW9+MITBssmjvVT9GGoiocvzMfhsG7d9JO7koqAHiMBE0J2xNuYAvIwe0x88aiPrFpENHft9IH0qGZrZ2J4tDUhPajnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B1QXDvL2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lyfcAQ4w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764647297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H18A+0RmYy7qzAd6no2pQnFAn6q5fxVYh0auTgIufyI=;
	b=B1QXDvL2cpAg+C6l6SZWonY2NM9rVBkT8iG9xKsnv5/MSY8jsLrA2sQObY/NXOwEAeBtk+
	y8szKhrfqKtn5B7m+ekjEByIb6EpYTD09eQLepF4qu5YEF9vlzqvdIq6tDT9YXrZBuaRAX
	Zyz9Eqv6BkXalcR7TlKhnv6yi9vds2c=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-Cv2aX32GPxGZgFKMlvCQUA-1; Mon, 01 Dec 2025 22:48:16 -0500
X-MC-Unique: Cv2aX32GPxGZgFKMlvCQUA-1
X-Mimecast-MFC-AGG-ID: Cv2aX32GPxGZgFKMlvCQUA_1764647295
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-297dfae179bso103268605ad.1
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 19:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764647295; x=1765252095; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H18A+0RmYy7qzAd6no2pQnFAn6q5fxVYh0auTgIufyI=;
        b=lyfcAQ4wOAHkIrObkX7rppETAs9q5CM7vGPlvtjApeGDNozp1lWBJXT2hKalW64nOp
         3Z0AG4mcpdYUNutaZOt6k9MXoDoqBNiSI4EYBicPHJQpSVdk5I962mQrnUa4yErsq1Bi
         Bw09xIz9nW+gsSWfQUfs0ulTg9An1Oi3PQtqE1xUCyWPRUVLH4fx2t4RczI1KSQDhzPR
         sEpaLgN07u9e37poc4UQjjZviJ0rC5oxlOfVOlaCIAMffSdehEo8clqkvtbdQTfhrvwP
         DE3Qoo7EadJB5yH5NIQPH1DyTRE1f+4fDNVXlg5yF9tgXR83FED0VzRZ66TVKsV7havb
         7Ehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764647295; x=1765252095;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H18A+0RmYy7qzAd6no2pQnFAn6q5fxVYh0auTgIufyI=;
        b=be8yUI1raHCO0BSzRV1ZXVPBotMHdnVL6ajEKY75/lEXJRD39JtTY1bkn/mboGSI9h
         YtwsbQo9JfQJ3UAJW3zgMbXhgwLLcuPVS+M+t5dhO/4ybakbUvwTa+6esTO14e5qj8wa
         3LJ/XdWPN4mQXykfF6MqpiXdy9NElzZYXGewElFTvp2LsoFlRykSjN79Yv/183V0XLKC
         55WYhkU15zlqkKxkpCqvKhqMC576m6ruOPl7jN3ZBgzK3d6/BNMfPacUtUNUHh1zgS37
         TAn5LTRRYXjW8Grmi7MXa91jZXnFN+ZkpBk8sdR1oPFNex839j+9BImtKHr+8SzRS7/u
         poFA==
X-Forwarded-Encrypted: i=1; AJvYcCVj+98PWCmCBLbWaysafwurF/9yFLPTR2GY/a4/aRPeqZgpe2gG1aZROq2pVswql+PjKVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDvr7onWHBnMyPBSqGShbAoSi5IocJGcnN7E/prv8as16TrvwL
	XHRY1xtLMparqfXRrhEuJ/OWhtZSh1jRkD6hCQY/Yp75KcIJT9UhN3tqcWX0YoHQwPA0CeMZdZx
	K82Sxjm4Ce7uUs4nxMAI9IWBeEHgo1yehgoB6vnt2/vs8XcHhTrsBSg==
X-Gm-Gg: ASbGncv0QPAmtTvlzXpZ2Vqx4Eel7rkZOyrnDwZiURQKXmTaEjPVx3TH7YmSIlXshfA
	q9csq6AWRLbrqF5YBX5IfAzcyYF8HMIj0Osw21SOknXBf9nMKrViGJoj0SpZfb3Vu/+4wolSEQn
	KfTKPTAtcZBXl0nzEGHRSoHrFvO8dfbeCxIxURT8HIR/Bq/MHd1q2quA3AaPXdFspjiNwLKa2vP
	n/+GzStEF3aCdCsCdb41JB2tGkjboU/KNVyroSEu3yROe/ojM8YfMp03MFjEu+2vXbT7ThODSim
	73RpVU6i9LieAP6+xYBNd5Pnw2Tnvlz7O21fUr7z8Nx27jCUnQ6QwKAbSjC9mMRvrJVRROkjuDZ
	VC40u
X-Received: by 2002:a17:903:4b04:b0:297:f527:a38f with SMTP id d9443c01a7336-29b6bec3fcfmr425510415ad.18.1764647295287;
        Mon, 01 Dec 2025 19:48:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGO/Mnp57Xj9CDlhkU9TdtnPMdRJNu7iIsNI+FeGU9EsPa5P4IulqY35znPbwdyF9adk2BbZQ==
X-Received: by 2002:a17:903:4b04:b0:297:f527:a38f with SMTP id d9443c01a7336-29b6bec3fcfmr425510275ad.18.1764647294921;
        Mon, 01 Dec 2025 19:48:14 -0800 (PST)
Received: from zeus ([2405:6580:83a0:7600:6e93:a15a:9134:ae1f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb559d6sm138403325ad.94.2025.12.01.19.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 19:48:14 -0800 (PST)
Date: Tue, 2 Dec 2025 12:48:10 +0900
From: Ryosuke Yasuoka <ryasuoka@redhat.com>
To: pbonzini@redhat.com, vkuznets@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Avoid freeing stack-allocated node in
 kvm_async_pf_queue_task
Message-ID: <aS5hekMmIrsJPK-L@zeus>
References: <20251122090828.1416464-1-ryasuoka@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122090828.1416464-1-ryasuoka@redhat.com>

On Sat, Nov 22, 2025 at 06:08:24PM +0900, Ryosuke Yasuoka wrote:
> kvm_async_pf_queue_task() can incorrectly remove a node allocated on the
> stack of kvm_async_pf_task_wait_schedule(). This occurs when a task
> request a PF while another task's PF request with the same token is
> still pending. Currently, kvm_async_pf_queue_task() assumes that any
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
> -- 
> 2.51.0

Hi all,

It's just a gentle ping on this patch.

Please let me know if thare any changes required. Any feedbacks are
welcome.

Here is a original patch's link:

https://lore.kernel.org/all/20251122090828.1416464-1-ryasuoka@redhat.com/

Thank you
Ryosuke


