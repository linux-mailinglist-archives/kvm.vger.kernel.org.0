Return-Path: <kvm+bounces-56634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2BD9B40F2B
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 23:14:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DAC87A3CEF
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 21:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C7A35A298;
	Tue,  2 Sep 2025 21:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXaLC+Cc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6409135690C;
	Tue,  2 Sep 2025 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756847601; cv=none; b=dDobtOUFF9pSqbROnC8//SBNXk3rZhv2rAzET1eHS7EL1yatXnyff0VxCc1C85mCT+OsVnOgvU0cvnt5M/FhfKvsk4jUSDYjCgt5iVMro+Se7ufFvUtVGcBOR8a2bvg6O+iD/T73q6AipXTRMU4VcESvITfRMvl2WcyhTnUJgqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756847601; c=relaxed/simple;
	bh=pyDdBcVW0v9+xpIUz0AG9q7DuTI1Ozvq1geLOWJVPxI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=ZeGpE/VzaLwqFaRHn1OwMOiIDOcxb3qvEiW+qH8FGp1ysPxjbak/AYyvtaG1bGsiXh6gGFsaKFKbC9SAf3eEVmHX2ZS70+qRYAX+Yxcng/zw7xGycgzzgjx5rugRRwIqiFtu67fMpH/3Ju/0uEirnG78iWRK7ebPuWgGlQsuD6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bXaLC+Cc; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e8704da966so368365585a.1;
        Tue, 02 Sep 2025 14:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756847598; x=1757452398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CILSsYdSSQh7NUkrEKe1sZhsPfN00oaTeV/5x25EmIk=;
        b=bXaLC+Cc+eMadTQgwN+tlr7GmH5ED/39h5D5rp6DuRqMS5eGOvx1QO2pPwsB1NChKN
         UU5y1lu9p9inq2jkRJYz42MIeLO3/rdZjOOoys6Qq1ylTHOdzFgtVc4OPeaFhDJT03lV
         KzzC+IEAdjl5PTicjfiaK1lv6xJClMNFzlILdpouXf2L3PzVk0VsT9E57p9sAdbQJZAJ
         kG2l5sk7U3a5UMpz+xo5xZv75zdnwjgplEzHjIhvwZ33YPytJZOreT9DdhAHKY3w/BG6
         izht17CmKGipVDSte9zeRcyTxqRznjVpvKHXy9CzNKXgVTfbfvOcJ50w9zHW4gE+5TJJ
         wqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756847598; x=1757452398;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CILSsYdSSQh7NUkrEKe1sZhsPfN00oaTeV/5x25EmIk=;
        b=XSWi88wxZhVCjyqcjyOTNWGwzd90Ku2tNPmvXSuku7+WS1O1ZTfIM55bbwL5d5xt9p
         FfTnc6TTM2g8qBnBNt0xQhEeJnS+I27m1YpoaY4Fc7umknnVuS8r7LrJyWhKO7wvI1iJ
         URPfWozSyUnmMK5VBkrVx8Pm5cI7jk5oatzEG0YDdpehcuMHoO34fuY6LpGCGtWqu0ep
         ZvB4efWjoo56LEuRR01Sr1/Vbz/JLJK6s4/N+aZbi8d6/lf8RURaX9MkC1yNn/rQiGI6
         utW4jaMh0PFSP67llx2XGZIWXcK6mJHJ4mAJyespKBc//G+3Ra7ctXPL7LNdieRgHBE8
         WmIA==
X-Forwarded-Encrypted: i=1; AJvYcCVK3vlEWa6hwzSCEuXUaE6qlp9MRlXvzM7IQhw99Ww7IzquNxKexYHFnB8DUkXlg4fvZCqz4n9Z@vger.kernel.org, AJvYcCWcqqNoaVgmLMs8CHU4YICdeTmzJze40wZm1yLHkoqfIH6ut4bMmN2ZsTZJdL8ogah7JOU=@vger.kernel.org, AJvYcCXQpWmVDpEJFy3U6HD7J23Q1BTa3XTfx+qtqp6Z4HnXdvPROT1Zr3YeONhZuJTwn9SBu41sU8KBphWzpt39@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0j6M7cYOpk7Dks2tj6hNhkhV+Ya3kxJ5fm2MpoyNzK6fx5Fp/
	xrpnEaMttcslCWIy66J690HvFO7v/tOKm7TZlnd24TtVahC/kUGj6nI129wiDQ==
X-Gm-Gg: ASbGncu7y0KyfoTNEw65DVEcfK2TDsA+Z5750AHPAphNutDz4p05Cs28xfXTZoO/uCp
	8DQE69g9If7Vnu6+ycUAgzR6aXfOtCUfRSSfcoTV71KPKJcj9512pOl+31ZYcavFq+DuPGIZOy6
	qqkrwdzaKPG2ear5dnoOQ5tAikrPaUx7T1cq8am0gBhqviHAc5fA5zWxMV8mqeAzVyaOAZchb4v
	LXBBPcAprNofzE4ft5NtMWAA6p8cj3IrxrBbnCIem1SCM04GzLtGf+99gilqOa95LT/3anpkMc5
	9pamzxFmm5NeXnpiP5UDvBMtCFcY5QIKndGtlFWFcy2k24eOOhedteVbgkESCUDsJ29XP7+etJW
	aapvizPGhR+t7+/Dg8PHZgA8mqTOvqBr97JBuywBPalaCOoYZWxQgYkFFV8EQN5pN52MrNslyT6
	tqQykvCnQbaWiY
X-Google-Smtp-Source: AGHT+IGfwGyYEQSsZhuRIBBjRHJpONNrkZUKk6/vfwU6F4j3sS0Cahrn3/lz445Kl8YoSSsb3MXbyw==
X-Received: by 2002:a05:620a:6919:b0:7e8:902c:7f90 with SMTP id af79cd13be357-7ff26f9fdc9mr1389884185a.15.1756847597958;
        Tue, 02 Sep 2025 14:13:17 -0700 (PDT)
Received: from gmail.com (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4b48f652814sm1143791cf.12.2025.09.02.14.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 14:13:17 -0700 (PDT)
Date: Tue, 02 Sep 2025 17:13:17 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>, 
 willemdebruijn.kernel@gmail.com, 
 jasowang@redhat.com, 
 mst@redhat.com, 
 eperezma@redhat.com, 
 stephen@networkplumber.org, 
 netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>, 
 Tim Gebauer <tim.gebauer@tu-dortmund.de>
Message-ID: <willemdebruijn.kernel.6b96c721c235@gmail.com>
In-Reply-To: <20250902080957.47265-2-simon.schippers@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-2-simon.schippers@tu-dortmund.de>
Subject: Re: [PATCH 1/4] ptr_ring_spare: Helper to check if spare capacity of
 size cnt is available
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Simon Schippers wrote:
> The implementation is inspired by ptr_ring_empty.
> 
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  include/linux/ptr_ring.h | 71 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index 551329220e4f..6b8cfaecf478 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -243,6 +243,77 @@ static inline bool ptr_ring_empty_bh(struct ptr_ring *r)
>  	return ret;
>  }
>  
> +/*
> + * Check if a spare capacity of cnt is available without taking any locks.
> + *
> + * If cnt==0 or cnt > r->size it acts the same as __ptr_ring_empty.

cnt >= r->size?

> + *
> + * The same requirements apply as described for __ptr_ring_empty.
> + */
> +static inline bool __ptr_ring_spare(struct ptr_ring *r, int cnt)
> +{
> +	int size = r->size;
> +	int to_check;
> +
> +	if (unlikely(!size || cnt < 0))
> +		return true;

Does !size ever happen. Also no need for preconditions for trivial
errors that never happen, like passing negative values. Or prefer
an unsigned type.

> +
> +	if (cnt > size)
> +		cnt = 0;
> +
> +	to_check = READ_ONCE(r->consumer_head) - cnt;
> +
> +	if (to_check < 0)
> +		to_check += size;
> +
> +	return !r->queue[to_check];
> +}
> +
> +static inline bool ptr_ring_spare(struct ptr_ring *r, int cnt)
> +{
> +	bool ret;
> +
> +	spin_lock(&r->consumer_lock);
> +	ret = __ptr_ring_spare(r, cnt);
> +	spin_unlock(&r->consumer_lock);
> +
> +	return ret;
> +}
> +
> +static inline bool ptr_ring_spare_irq(struct ptr_ring *r, int cnt)
> +{
> +	bool ret;
> +
> +	spin_lock_irq(&r->consumer_lock);
> +	ret = __ptr_ring_spare(r, cnt);
> +	spin_unlock_irq(&r->consumer_lock);
> +
> +	return ret;
> +}
> +
> +static inline bool ptr_ring_spare_any(struct ptr_ring *r, int cnt)
> +{
> +	unsigned long flags;
> +	bool ret;
> +
> +	spin_lock_irqsave(&r->consumer_lock, flags);
> +	ret = __ptr_ring_spare(r, cnt);
> +	spin_unlock_irqrestore(&r->consumer_lock, flags);
> +
> +	return ret;
> +}
> +
> +static inline bool ptr_ring_spare_bh(struct ptr_ring *r, int cnt)
> +{
> +	bool ret;
> +
> +	spin_lock_bh(&r->consumer_lock);
> +	ret = __ptr_ring_spare(r, cnt);
> +	spin_unlock_bh(&r->consumer_lock);
> +
> +	return ret;
> +}

Please only introduce the variants actually used.



