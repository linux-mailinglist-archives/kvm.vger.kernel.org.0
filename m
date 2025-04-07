Return-Path: <kvm+bounces-42823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61DA8A7D873
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 10:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1B0D3B0812
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 08:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D41A228CB7;
	Mon,  7 Apr 2025 08:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EPh2MDY2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4522288CB
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 08:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744015763; cv=none; b=uhLAGLd3TuIUHsYNKmxybWvEfzzfMmdNSvPsK7aZlKidOxkdluLRj0soTbleBzh9FxSw8ep7xebpdl/979081xXEwcrxDj7R9tro8PpP491oZcnI0Ihm5N77r4Ei1zc19F29s75lm6ov+uwI/opLAfjR0dXr4WlbgBu3RU9bBZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744015763; c=relaxed/simple;
	bh=IZtLDURYDTq0b32MVRHTcY8RDwEllmanE9uQZcvW3gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SkDmRHpBRyeEp4pVWeSyLNToFkg5OWnk0L4sUPUtgr79kC0eRtgRx5RenpmRmiUpUJrw8Vg7rYC3gqww+n4lujJWoTX97T/fJbObWQdo0UOhwXDlEAkivL7zjVX1zhSeP2YRSnQ8PbZGH1g21BGc+Zz37Bh77DmvLj8tABatVjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EPh2MDY2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744015760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hpu5KqbXEO7FQHIb0ETZFO78MX8aCe7lEYNvf8XqmxY=;
	b=EPh2MDY295e/BmrhhJRCOQ0326XjOmpeysTfkGxk/ZLFfM9a1XYWS2j6P45SFr7wz/DHsQ
	Wxuo7XbOf66qAxyN6Ld6iq1tSpGFw/rv1KgZaeYDNh7otX4hPvq/my1UynsfkNYu5YCDEG
	AN33p+zTJuK1iU18rTdybczgFpTTRAg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-3S83W53KMIe75__MAwSCRw-1; Mon, 07 Apr 2025 04:49:19 -0400
X-MC-Unique: 3S83W53KMIe75__MAwSCRw-1
X-Mimecast-MFC-AGG-ID: 3S83W53KMIe75__MAwSCRw_1744015758
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43947a0919aso29109335e9.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 01:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744015758; x=1744620558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hpu5KqbXEO7FQHIb0ETZFO78MX8aCe7lEYNvf8XqmxY=;
        b=raASbzjlO08YRz+B/fvA5wFPzVeZRjpQZ0n0WhGB5O1tgbJn8d4OfbI/Yp7EQz3tFZ
         Y3FEZz4sBC5+NtVWbdUQc9QqL959AsfxPymDxRCwOaqxEJXmMVK2qmC0a3T3Z8ZY7nOi
         1o0Ug1H1BSoswCloQyXDse4aGMW1IsM+af1rXREJocGhuZYJ6ZYcDYOebtYY8LxA13VF
         HrOFd7vNGEsI29JZe2IUdmmucd1SP/wv9+NHLGZZ22/+DjskMq4yhbRo9oZWDvexsay2
         zp8QHDkZnCBq93SjP0DjFgwNwt9niRnl7FjmLvlY6WaWxnUSY/gb6ET/6A7V39CzXA/B
         b2jw==
X-Forwarded-Encrypted: i=1; AJvYcCVNKBQ4G/Uerk8oyGlCdLqPtvQ54UrxNrh5J9F4ZkBzJf/y7xX9F76Rqi5pQjzxp4hp6u4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9uTiHF97P0YQMvTc9qCt0z4f9D4ZPpZTMbY79Km1ZzJCFyAx/
	I+BY+wjH82rDDelkXEMm3nQBzhYkptbeMuwO+G0GPYSZSfjCrg8ud8OivcC4EnvBl0PN+V/ZSXz
	E0PGu29U8IraaGrSE1914qIOzfouvoJiLa/QfdaNwDxuXJd4cBg==
X-Gm-Gg: ASbGncuXZnvB0JGmHsWtPJ7yQL2dvZM16qMuekylR4wEYoBi6RKns9UtXbEXk1i73KD
	bdkg6Xk8wCaFAytp/D0MEYSuPh+Q2jfR5jrbvdJiUiLnIdI/vn04gwtvlVE8dZxM40wX4ex49Zw
	CM02PMLagnimnNSbnMH4DGtlRuxwiItR1yhvpaJhuay/Bi81BkYcxI84bphuBMveKks8NIL5Rtt
	yTgBipCWReRMWnlgxzH5/7cGHF52qNZbAHk+myBxXbQaMUvaEeSovi+pGHpx1zQQyPJ/ZRJRWxS
	NUi5VeKoPA==
X-Received: by 2002:a05:600c:3306:b0:43d:fa59:be38 with SMTP id 5b1f17b1804b1-43ee2aff1a0mr38130045e9.32.1744015758295;
        Mon, 07 Apr 2025 01:49:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNYPVVGEAhzNqS2UPVe5mcCou0C3HnRif0zA9AGHI8Xqo5GZ7Z22p9jJeCaR5blASlwYtuCg==
X-Received: by 2002:a05:600c:3306:b0:43d:fa59:be38 with SMTP id 5b1f17b1804b1-43ee2aff1a0mr38129915e9.32.1744015757955;
        Mon, 07 Apr 2025 01:49:17 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301a7586sm11552495f8f.38.2025.04.07.01.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 01:49:17 -0700 (PDT)
Date: Mon, 7 Apr 2025 04:49:14 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
	Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
	Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250407044743-mutt-send-email-mst@kernel.org>
References: <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
 <20250404153620.04d2df05.pasic@linux.ibm.com>
 <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
 <20250407042058-mutt-send-email-mst@kernel.org>
 <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com>

On Mon, Apr 07, 2025 at 10:44:21AM +0200, David Hildenbrand wrote:
> > 
> > 
> > 
> > > Whoever adds new feat_X *must be aware* about all previous features,
> > > otherwise we'd be reusing feature bits and everything falls to pieces.
> > 
> > 
> > The knowledge is supposed be limited to which feature bit to use.
> 
> I think we also have to know which virtqueue bits can be used, right?
> 

what are virtqueue bits? vq number?


-- 
MST


