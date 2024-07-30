Return-Path: <kvm+bounces-22689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E35E0942023
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FFBA28605A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 18:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C782418CC1D;
	Tue, 30 Jul 2024 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hKpi5eBE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A812818C900;
	Tue, 30 Jul 2024 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722365706; cv=none; b=QgFXymFOppD7SkOdrdqZagbLbJ3QOIpTreKkUZLVCo1NiJjFCmQN3I6018PTXPmtWrfTWBw79S145QZmEk5m7rgrsxACcZ+2iOxw7u/TaA6Dk2CQdtZbq7eSaxfbDtQH/FSOUZVRow96Ybc9tc/BgidOd05P7iaHBuD4u+8eidM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722365706; c=relaxed/simple;
	bh=gkAsGyAn23ZHk18oY7nwdT/kqQrSIPA5N6C5BvHvup4=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HcXtJGA5J2JWrUBD+xP9DExUopaltAsIDcrK9MVZ77LaoOGJn8JlXfGWXkNFqH3ygJz6eFVO5op4VyqHeBFQJcI198zk1PU//BDAYCh1SgQihc2yA7y3N2DIRcaYm1LlBb7OQDzz3NOXG7VnhOToHv8chVs89fg4KfY9cJRiqQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hKpi5eBE; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70d1c8d7d95so3063771b3a.2;
        Tue, 30 Jul 2024 11:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722365704; x=1722970504; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gkAsGyAn23ZHk18oY7nwdT/kqQrSIPA5N6C5BvHvup4=;
        b=hKpi5eBEKauParRoKmXZyXBpXezLjF3CzZFuUDmsV8lbiiDSLeyH4YMYe80FdM9EbH
         v7QDVn7KZDhOwVOhbP99nBnscC1xp/PZhL7OqhR10pFb+L7fLhhSvXRUSWbC9o15KKSW
         LpcJNKNB2FOAOT2f8J0BF1CaRgMYbJ1Uj+eI/lCVGLKSzTIXRPxZsPz+EvxX3nvHjrgO
         fKJPB4RzxvqQLgPNnAQVdDPJN/Kl0KFRVFlrlXK5jcNHVIoXfE9Fp25lIR1V0K6kSIQL
         eu8nSSSVjSGyv99+Ws6uwOEZAVafKFoH7lPUdylzPw9YIKxXuaWbPkcAWZqJ54Wtf68H
         E2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722365704; x=1722970504;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gkAsGyAn23ZHk18oY7nwdT/kqQrSIPA5N6C5BvHvup4=;
        b=OCKDDcWSmalWG3Odr2KZZV3E0HKRMKLrs0ZIMBzNJneONeSGknUM7puf387IfMmybP
         PWi5eeeMDahBAuOf93C5jxv0zkist6FRNCV3a7DvP4/Ki45R3SOXS9gEwCBbFxup24b+
         tVqsVFAAAc5pUL3g4+Z2FOeCYbP2NqSmfkc4xVXVtP16ec+YlxMoC9oRSPXd4DXzktNf
         XzsOpfg6wyIZergFoLS4s8BL/4fRv9zxDU+h1HkiE4ZRXUPyZ4JXrIFpvTCtwasPpkX7
         e2PQlOelPq0qw+7aELZLey+rUbjPLBTP5Qr6sPJZVqGrIRQhVB93K2bj2goFQ9ohJA2K
         3BhA==
X-Forwarded-Encrypted: i=1; AJvYcCXm3UNgfV83yAmbiijYNyiwRg5S3AoE9etwvE4OtnlYIVjVuap6aHdqL/Rz/0RUcu80NlTo7Ja8jryCyXYvol9jntNLU2/eEVzth6gdgjo9hn+jSH4Zwek75qBjN4gpGw==
X-Gm-Message-State: AOJu0Yxj7XpRiIKpbi3oRORC23SP2uQXrowoSjJTsV+HosHWKPUeoaYX
	ys56rkkQ/iCAsDuNwHWMJMtNGjdXwPxEjvPgyeAiFuglQkJ+KyGC
X-Google-Smtp-Source: AGHT+IG24Db8snQL11PjMMgEFIueB/WO93zvgt26ms7Bw0B7zKNsl38EnEPihdhP9qRIpA/ZEQ2UgA==
X-Received: by 2002:a05:6a00:850:b0:70d:2ca0:896a with SMTP id d2e1a72fcca58-70ecea40f66mr11275694b3a.18.1722365703739;
        Tue, 30 Jul 2024 11:55:03 -0700 (PDT)
Received: from DESKTOP-DUKSS9G. (c-76-133-131-165.hsd1.ca.comcast.net. [76.133.131.165])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead882b2esm9039627b3a.179.2024.07.30.11.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 11:55:03 -0700 (PDT)
Message-ID: <66a93707.050a0220.5f9eb.7cc0@mx.google.com>
X-Google-Original-Message-ID: <Zqk3BFd4aGaPGcWe@DESKTOP-DUKSS9G.>
Date: Tue, 30 Jul 2024 11:55:00 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH v1 0/3] mm: remove arch_make_page_accessible()
References: <20240729183844.388481-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729183844.388481-1-david@redhat.com>

On Mon, Jul 29, 2024 at 08:38:41PM +0200, David Hildenbrand wrote:
> Now that s390x implements arch_make_folio_accessible(), let's convert
> remaining users to use arch_make_folio_accessible() instead so we can
> remove arch_make_page_accessible().

For the whole series:

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

