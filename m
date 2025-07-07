Return-Path: <kvm+bounces-51636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0FCAFAA4F
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1621177976
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7065425A330;
	Mon,  7 Jul 2025 03:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="deDSSNVO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD94D72639
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 03:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751859523; cv=none; b=TKRANEaLRrFqSeQkjWxZewOHWlc36qfkqrKuu3pY/vvPnxSD9xOAOPZcc5TQYnbmAS+LJ00bj9fyyB2ctFalw3bdq92ZLsL6PSMmQTmr5rgu9Wmjq3W8mRUAozN6WRRxQXolwnqjJ58+KKcn0XAQVr6ozmvN6X7N7p6FXXTaP84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751859523; c=relaxed/simple;
	bh=xP2bREtdvnGbOLwW7B3gpwqiB0qIwzFyIIj2JKt5GFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffXYZtc56uUPYfegR3fvf9v4TmVuvzhLXhwqxYi52vYMYknhOmcx903zEhYveq7kq26r0v92rAdzrhLBt2+qHGY6+RTtfX3oCH6cBnT1A8/lM3eWT6IJXq22t4BoZjNrYIJ4ph0ojHkaXsoQU664C07VgBZ1Dgk5IAhizRq5UW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=deDSSNVO; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-74b50c71b0aso1324565b3a.0
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 20:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751859520; x=1752464320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYLAUdUJTR9rpX/RucDx6r9U6vpMoU3BznYDYTgd2Is=;
        b=deDSSNVO6EHM27EEpN5zgDVNe5cIYmIQsGgECnAysp1VJ2/Yu2+bsR6IK5GaCH7zyl
         fGJArFnmt74msAx+nmfNg/lunwta7LtPFFzr78d8v6g1TdgEjddnky+E1y2iUr2i3z0J
         30BuBXByTmYssYjdTLRSYUMxXM9KeRZth9qH9vdDYp60wA6BvIemGbmi9dguJDfFgRSn
         aws4ikGoTOzQmmkivWC8BN6yIYW+PG+mdSMGtefeip7QwGBSvPxM0BXJDFs1oiCEfVRB
         PT5i76wXrosq+nsrmwJvXEhQA1Ts82ecr9j7GACfKxGUAVJ6ako5rl5baVmvJYKalAU3
         dvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751859520; x=1752464320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYLAUdUJTR9rpX/RucDx6r9U6vpMoU3BznYDYTgd2Is=;
        b=sshvexz3QW6d81XF+oH9g8G7kB/3IbYypeDIXwr2EorexsOX/M4TBm57Rwa7swNMv5
         zax38kIGBm4xzI15FyKcoye756Y9QI5i2H5kxzxjOJ9trCWVpSIe4auejCFO8Li8HbrP
         8HhiJRl1H48CtBRxasMzVqVg5k51xvOP11pAGAbxrMkJWWumA/KGriZZyR3o54sJPqJL
         ssjNowxoUokasVWwZo3Fz0+tJ7hFuHdx8SNWHpRyoWjWXq7rqjtL0lwo27637DNfeCAu
         xLgGjPM7ogIHblOc9syhkG53E8hixCaYwlyBhmJhvmxXOJyasEAHrTjX8Y+93cy+eVWo
         EajQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQxE6C5B4bqAHHkSzu3lZPv8+HIxZ663LLg19aAKtPM9xYeARB24WG56mY5//IdqKtyMc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz40jQmW14NUztHZuPoyjjzknezOci0XRdQqdsedD4etbw+kTuM
	nerlbWIJOTEB6F+4NrISD0GUu33unx3zewTD9WPunaFgN2wn9ctGndCoxwjMfi5fl7E=
X-Gm-Gg: ASbGncuomKHw3IThA1n8jP1SNe29Z/6Pz+Ue32FYA1WPCMjhnEYKh6CHsAbCb1Nzwtu
	karAsPPDBH6TrlaHEDi6V8vNl+yIcURYC6vaL3Vqo/QadICjX8zM/0Gwz9P7KAdrJucCJuZsjU8
	NgKTIs84JjucY7/Pzoc1B1h28FsGNBn2Tu9zN7UPnFUynZ3f9/kJeNosKGvRiF38Iqk03nt6T0e
	B7QtbQmQX1D32eaHUPggwiVMW3Tg8zrz42flbuUt2I6JZXWGnNgsB1SuDFj1LFwylAKWBzHdfgz
	kKj7AsT+Xdl4r3Tjxq6xCoD7As/cmLCx53AV91rmESpRF2E3nPtGxViBcYAIcb3hY956TIZWEuf
	LEegsYDv/7ufMng==
X-Google-Smtp-Source: AGHT+IHQ+vMn4AUfTUfzbidm8jT0R/lnwjN3Q065ykEjKC8AayhHkU7jvtK+lcztQOyY68HYaP5uQQ==
X-Received: by 2002:a05:6a00:4f8b:b0:746:2a0b:3dc8 with SMTP id d2e1a72fcca58-74ce8aca411mr12735141b3a.17.1751859520171;
        Sun, 06 Jul 2025 20:38:40 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce4299c3dsm7789475b3a.116.2025.07.06.20.38.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Jul 2025 20:38:39 -0700 (PDT)
From: lizhe.67@bytedance.com
To: jgg@ziepe.ca
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v2 1/5] mm: introduce num_pages_contiguous()
Date: Mon,  7 Jul 2025 11:38:33 +0800
Message-ID: <20250707033833.59970-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250704171015.GJ904431@ziepe.ca>
References: <20250704171015.GJ904431@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 4 Jul 2025 14:10:15 -0300, jgg@ziepe.ca wrote:

> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 0ef2ba0c667a..1d26203d1ced 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -205,6 +205,26 @@ extern unsigned long sysctl_admin_reserve_kbytes;
> >  #define folio_page_idx(folio, p)	((p) - &(folio)->page)
> >  #endif
> >  
> > +/*
> > + * num_pages_contiguous() - determine the number of contiguous pages
> > + * starting from the first page.
> > + *
> > + * @pages: an array of page pointers
> > + * @nr_pages: length of the array
> > + */
> > +static inline unsigned long num_pages_contiguous(struct page **pages,
> > +						 unsigned long nr_pages)
> 
> Both longs should be size_t I think

Yes, size_t is a better choice.

> > +{
> > +	struct page *first_page = pages[0];
> > +	unsigned long i;
> 
> Size_t
> 
> > +
> > +	for (i = 1; i < nr_pages; i++)
> > +		if (pages[i] != nth_page(first_page, i))
> > +			break;
> 
> It seems OK. So the reasoning here is this is faster on
> CONFIG_SPARSEMEM_VMEMMAP/nonsparse

Yes.

> and about the same on sparse mem?
> (or we don't care?)

Regarding sparse memory, I'm not entirely certain. From my
understanding, VFIO is predominantly utilized in virtualization
scenarios, which typically have sufficient kernel resources. This
implies that CONFIG_SPARSEMEM_VMEMMAP is generally set to "y" in
such cases. Therefore, we need not overly concern ourselves with
this particular scenario. Of course, David has also proposed
optimization solutions for sparse memory scenarios[1]. If anyone
later complains about performance in this context, I would be happy
to assist with further optimization efforts. Currently, I only have
a x86_64 machine, on which CONFIG_SPARSEMEM_VMEMMAP is forcibly
enabled. Attempting to compile with CONFIG_SPARSEMEM &&
!CONFIG_SPARSEMEM_VMEMMAP results in compilation errors, preventing
me from conducting the relevant performance tests.

Thanks,
Zhe

[1]: https://lore.kernel.org/all/c1144447-6b67-48d3-b37c-5f1ca6a9b4a7@redhat.com/#t

