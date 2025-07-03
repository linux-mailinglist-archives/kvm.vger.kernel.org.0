Return-Path: <kvm+bounces-51479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E82AF727B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18A7F1C841B2
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10502E54AD;
	Thu,  3 Jul 2025 11:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="HsqVMXQX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880AD261591
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751542459; cv=none; b=i7XGKNlzbSk7AI8tLWVf5pxiocnmmgCDesb2pzASpSy1h8nLOaF1a8hCmK43cg482R/4E7PBkAfAKPWPry/2k44eX+WJh6dJgafnNv3nHWkBVyhYTxi5v3P6OD6Ju1EMKoGCtjFq6U43mbouXEfV+qRtxfsWY5konMV4RNh9rig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751542459; c=relaxed/simple;
	bh=xfHWw/4xeCnV4frnXxcZaPH9XjO9y3PSObid74MxSbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BM8S2aoyjjCGpG/w5BA5haMx/Kv8CGzO2LWx2ehmM5D/Po/H0PzLpRiSfi8zF5Xlf9v22uKsZEWYOF/TtyhYpxmWOuRNHgfIkTkelQk2URAnwJHCb7h87uZYgod07nqrwVJ5/sg9kMna20+NougA070b9v15QuqBxFdVWbxoHvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=HsqVMXQX; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-742c3d06de3so6564695b3a.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751542457; x=1752147257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKuqSD41yM47qtIosyJtUok1+70r4BndprRJCiZqgqk=;
        b=HsqVMXQXpeEvUIFargZQwfFp7GuJvs+0LRz1UiuwyS/eJGzUBsu0V7fEIEob8jieJl
         cW/Bchx96lM75+dZqU/yKB3EDhe5zeEkkUeIrwivhRlJCZ7S2GtdEc+onlDoKYPTOtjp
         m/inJpGkfxmgYq6F51ktZc/8kC+am1ICThMAmfE2+K1xVXPwQH6alfphNdvYHGcQtyc5
         R5+BkS7lc1+iUIu3CtIE/OorFOgCHyYV+7YLQK+e0thjJS9GONWesDYV4FSES9mXtZfs
         dlUTU3V/IQF4lTU3csyDnfQcvG3FFIFc8MGWCHuornzwElkPJ6d5TIfaCTap7ThT/WVh
         JpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751542457; x=1752147257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rKuqSD41yM47qtIosyJtUok1+70r4BndprRJCiZqgqk=;
        b=W4slDqhyZ4apgPmjKNnjHkMafl85p2NxnFXXq5Fsmxd9Zpg3f23p1lNUUau4GqQpp1
         zz89fSFqlAsDK8BrcuyjaVpaRpv1Sa/2Qe2+EtituqW9LNudLEOi8qLYnosfbLZ+mY57
         08RWU4kF5pWcU7KCeVLFgrHiLct+6WesEfHpS+yS2E2SHEYSJcgTyMtVA0xyUsllfIIa
         SHaH6yhQeHHdKjAJxMwsJMqmT94K++5yVI5xpl+npxmDPWx6r63jZOX7CMsOpsKXzZEq
         vXjwL2nCrtTdFfskUeDp/wwtHzx3eNXkblzus6t5bAD4/jQyW9ee3lSOi1Fl2AK5vuvp
         aQyw==
X-Forwarded-Encrypted: i=1; AJvYcCXaLXDiECGGXqf/sIy8b/3W4p1KCXGqe+DwMEghixfretlxHXk/9SqJjfLRKpiJmbwe8Rw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeWgbPhglosqM2LZoUVMUKnyju3lNCnnERyM8erEpViNViu1oX
	kuOnStzO5sagHVJXwfoU4L1ZzGb+VDqA4256H7b27+JT/S6KKBX6nNDjoU7Bssd7kbo=
X-Gm-Gg: ASbGncvo4PpO9Pqs0JzFJi14shvK7oS4OgKKoZqBPx3I4PJU8af6exT8PazNO1aYIGn
	KPr97VfzLCz/Z6Cmp6KZGRYA5GqOApp5FRTBNGKiwekbZUZhtws2KCTm7DA5S6ck3GhZN+H5PVB
	O8rjch1Ldlj6hJdBZi7NjlsA2uOZKcqDm0CjfcUZ3TzCPjM/kZrvqBn7h5ExY1SlyweOzBfJYnl
	p+PjYdNL+IxrvVh9+bjbCkKHVnN8ay2idvYZAWoFw1RWIWEifz4oKIap/1FBcjYRHgS2VB4t8jw
	Ad5gA966fh6I9l1HIrRFEMneN38f4lQ8n7qCSzo82rAUKiyNv3/pJ2esajrL4Hpy1whgjNQeqh9
	eq+OMnbQS6Tbu
X-Google-Smtp-Source: AGHT+IEaIcX4g7FJqZ33HWQn8jLj6CTJN7wIjTiYoZNHvn71uhXUfhBCcEbREOtjdOaQlb8z5oxu8Q==
X-Received: by 2002:a05:6a21:999a:b0:21f:4459:c032 with SMTP id adf61e73a8af0-2240aafc33amr4657333637.18.1751542456824;
        Thu, 03 Jul 2025 04:34:16 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31db02esm15080898a12.63.2025.07.03.04.34.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:34:16 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH 0/4] vfio/type1: optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote() for large folio
Date: Thu,  3 Jul 2025 19:34:10 +0800
Message-ID: <20250703113410.66696-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <664e5604-fe7c-449f-bb2a-48c9543fecf4@redhat.com>
References: <664e5604-fe7c-449f-bb2a-48c9543fecf4@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 3 Jul 2025 13:06:26 +0200, david@redhat.com wrote:

> > +static inline unsigned long contig_pages(struct page **pages,
> > +					 unsigned long size)
> 
> size -> nr_pages
> 
> > +{
> > +	struct page *first_page = pages[0];
> > +	unsigned long i;
> > +
> > +	for (i = 1; i < size; i++)
> > +		if (pages[i] != nth_page(first_page, i))
> > +			break;
> > +	return i;
> > +}
> 
> LGTM.
> 
> I wonder if we can find a better function name, especially when moving 
> this to some header where it can be reused.
> 
> Something that expresses that we will return the next batch that starts 
> at the first page.

Thank you. Given that this function may have more users in the future,
I will place it in include/linux/mm.h instead of the vfio file. Once
I've addressed the comments on the other patches with Jason, I will
resend a new patchset.

Thanks,
Zhe

