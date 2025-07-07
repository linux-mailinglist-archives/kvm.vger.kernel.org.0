Return-Path: <kvm+bounces-51638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B816AFAA55
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5477B1768AC
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DA025A2DE;
	Mon,  7 Jul 2025 03:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Uw8F2oXo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4817E792
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 03:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751859871; cv=none; b=mFw53TfJuVz3nIzk3BTO/HkEAc4zSvzuQoDQ7/pI03Dkaa1jOWIuV5ylvopkRnWNtmjv4qfECV3ouNmDySBDWNF1lxfhZVhlB7lN7hRg53/4Hkp2dwdyCNgQSjBJkeIu5QdZ8PiMNiMGgUD4k/qZ+nv3WaICV4qt2YReLTFJh2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751859871; c=relaxed/simple;
	bh=v+lWgSyoOtCf+VjdFCWVDMbMmwGujDRm79XmRjvY/vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0Rck2Hv6LhH6I7b/HtghNa75RYMPxMd2AGxB2jBn1F5ekYsPCXs3x1NMLfVdWFP2tsGbmqPNCEurSWVK/1NhjRcmOhpiklEYPVb0E7mRV3UsXeZtXmTBKK0wKre86wOBIKwyBB8Zuz0f84TB4JlfWnz4s7L2adf6wb5HEt4YRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Uw8F2oXo; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7426c44e014so1988757b3a.3
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 20:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751859869; x=1752464669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9T7JAbV7vhWy0qtdBRWYfecJwaqMI3weyY2as/tnrU=;
        b=Uw8F2oXoYUXS1o3vVGFxIGBl2LBpQAFca6MBWcobKIlzgXEXbXaz+06Ie4JkmR+KCY
         E8HVCXv+7nHpryizyOVUbTiODNcup0N6KqdN10TnOk3QJp04rp579+sz7rHrihuEQ/8m
         M/qXVOovBjB/1D7D+Uwugutn5q8s80wPaie5s2XCWppL6rmGtMK4Djdbn5tiOXWADwB4
         wkEW2wahocnywgBMYpF+F9z065v8S9zzSLaPfTfPVqKCutSfz4QxeETjVDNa1KQEDEcV
         97opmWCwkXpjk5qb/Hg6D/+c4uClttOc86UUeecsPVewuoVVenaDV4mfzbJGRn5T54J5
         Xp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751859869; x=1752464669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9T7JAbV7vhWy0qtdBRWYfecJwaqMI3weyY2as/tnrU=;
        b=ca1RmQvJMTTrf4v8I2RHX4yR919IqkHobWlh6kr1WoSjfryxpKwulNLZl5TXbTEdgV
         cIADxsbd44MdCMxXVkeuhZ1y2vOF4CjpV25yAa2vt8Jpw/FJDnzqi5E6m8TZXQrBqVwm
         kAf+wTuUQGVE/X/PJIs+8VJOx+fCZ1zyP7VBOKGgN9hpy0e53QypdE7haarq5ynuyNJ3
         UTyvqarVWgmas7ImvLauh2JDuWFfpjC04DbVD+7Z0nSPvTp9QVHNGH/wQLSesVml71/K
         ecGoiOTk/2aCMjZigUQvNg8nypuFF1UcHdtFlO9JNevusDVIl0MA/77TzOvwVqT3PXiH
         XKZA==
X-Forwarded-Encrypted: i=1; AJvYcCWHec7H6XUC8WCZz3vabmghVRcJ4RCKcqnbzZ+HE5xzuGjLsK5vfX+c7gH5d/lSm1m5wL4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy71H+jAiSMJ2KcOyZ7mvAGLb/lNGXDQpU6IZjPFnq8KQ/dBTFf
	KVYZ5lxm/okKhuAqu0SX3Fu7AEtF3gwvgKk5wKys4b4LuVQzB/GvdkJDyiEW4BCmkPs=
X-Gm-Gg: ASbGncsQYJNeyAbhv9lPEdgIIJBE2jWJAq0DDooZZ31jb5ZJbsmdcJgbXLkiuP70KzX
	TOQL98HybfhIqQ9sU0JK57J9wZDVFbt4CczJpyUEONZF/BUW/gIIW6AE8VQs80OVfMEI2l4GgGL
	XRzZF896K5k8MkPFF6gyVlcRMr2Z5loT5lRLpIBoLx4qbWpkUI3NluUL3zcfsliekZCADK635e5
	EYbvRh4kO0sZYnQDP4mdS79j3cuisZtzqd6LRJlktZRuToHIud6paniNM1R+YgFfcnbZ8wM7zyd
	ApRRIwYOc99zKrPVKZm5VejNnh7XnYWlER2BVW4r3OMpwSQpdozdoOAQeffkYPKSTmvNJ6GfaCU
	lWqrwN6pYvKDLig==
X-Google-Smtp-Source: AGHT+IFhikC4ANTNT4wO7MH/YDAPzkIkD1KcHaFO9YiTTHdwtSqlnsVb8YiTPSRI5B9f3J+BTMiLgw==
X-Received: by 2002:a05:6a00:1828:b0:748:edf5:95de with SMTP id d2e1a72fcca58-74cf6f309d2mr7682954b3a.10.1751859869592;
        Sun, 06 Jul 2025 20:44:29 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce429a003sm7735262b3a.112.2025.07.06.20.44.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Jul 2025 20:44:29 -0700 (PDT)
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
Subject: Re: [PATCH v2 5/5] vfio/type1: optimize vfio_unpin_pages_remote()
Date: Mon,  7 Jul 2025 11:44:22 +0800
Message-ID: <20250707034422.60153-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250704171123.GK904431@ziepe.ca>
References: <20250704171123.GK904431@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 4 Jul 2025 14:11:23 -0300, jgg@ziepe.ca wrote:

> On Fri, Jul 04, 2025 at 10:47:00AM +0200, David Hildenbrand wrote:
> > >   static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> > >   				    unsigned long pfn, unsigned long npage,
> > >   				    bool do_accounting)
> > >   {
> > >   	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> > > -	long i;
> > > -	for (i = 0; i < npage; i++)
> > > -		if (put_pfn(pfn++, dma->prot))
> > > -			unlocked++;
> > > +	if (dma->has_rsvd) {
> > > +		long i;
> > 
> > No need to move "long i" here, but also doesn't really matter.
> 
> It should also be unsigned long as npage is unsigned

Yes, unsigned long is a better choice.

Thanks,
Zhe

