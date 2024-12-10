Return-Path: <kvm+bounces-33443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8AC9EB93C
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 19:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08AAC188A145
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 18:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463F72046BB;
	Tue, 10 Dec 2024 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pe7xxDAr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26F838DEC
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 18:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733854965; cv=none; b=awknMTBhz/pbInNuNIQLlJOdHyHSuGeKjZ7MuN5jXVP6PHDCqbA2Q0WOqVZv5MnQ52Sw2IaDk2sxZCa9p8ZW+tSSycCo/iOy26VO7/g/jCfOHZVK6lbv2YgbkWcSZgc2+Ljywouhc8rTeN6UkA9q2vKbbIt2yT0Sxu87K+QN+NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733854965; c=relaxed/simple;
	bh=1pHfdGZ8TK0Gn1cA1yV/fONw8m+PMIvPeERxVbGEHKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbZlzypGEZ1NJxSlOMg5lTJMlLSn4iVDif410OBQq5zXAdF1Tu/a5bEzwsqNx9Dtp3LcjYOCoBnujfFq7p78NsugQHzEXxW1W6slCcToI8W9kGdT9UxkGyDtIdYjy9Z3Nk+F3Yd0Do3ibNyvWCNJWUVEml3hbMXllpMHMWFVlPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pe7xxDAr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733854962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zOADznZ6shRkxpA6k9z+HUBrSDKj4HgVFQ54YvYLX9M=;
	b=Pe7xxDArcDojh6IVvvqU2+FII1ftLaZBOYbQ6mu71vr1/GN7BHQC2TbmLVsPzDVbVZXSYl
	/LtFrBhSmXFr6jlOjBY4t2LXTSWiIRnl0F9WfAWRLxE/5DjKvH+4h5gSHEYjk7Bu8cm9ZC
	wAHc1YEOLhU35OQZNGG5AzJMNu0YP0A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-xvR9Sa6WNAazDG5s9Xo5qw-1; Tue, 10 Dec 2024 13:22:41 -0500
X-MC-Unique: xvR9Sa6WNAazDG5s9Xo5qw-1
X-Mimecast-MFC-AGG-ID: xvR9Sa6WNAazDG5s9Xo5qw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4361a8fc3bdso3078995e9.2
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 10:22:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733854960; x=1734459760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOADznZ6shRkxpA6k9z+HUBrSDKj4HgVFQ54YvYLX9M=;
        b=Mqiq8xBKHLihbHhSvItMaTHkL+MICobPa+GP0NaraJF9VH03Duam2+trTf00Ytt9gC
         Tqj/cwes9AXhi1bbJ2TD1/fGrwMxSkIQmVXHG7nUo7NT7lX5xJnS4Lj9TzoeWzKPKSMK
         oO5S9KxYRk5heJsNxWyEuMhmUj8lI24Wxkj2lwUB9IG/C6fQjX4giKRXbbTWsu7OdoEP
         tUIP4d/an3hK6BfD3oSSe38A56xl5o/ahP+GTCmYynFinsCBJNRpc4ePYnLrqnsN2bib
         KHyqcA+rPN1WEF/cK345E68UefERRZ/TMYJ1CQk9ceOV7oukyszI/0RXGluGFaeTKz0I
         q/Fg==
X-Forwarded-Encrypted: i=1; AJvYcCUhM2ydu3j7OYsaxHtqjKvl4QmDDGzL1XHnsI6PYUzVzzS9EUGW9M1Emuqfmhhzaf2Wisc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTXvwgDIXAzNMLT6ZBTvsqXC++w21k0zhK6bNK4q+d69t9CUQ+
	khFPCElaSV8heb0RjBba3eIt5qBmnTwBfNJJs8WGSNLMXmN7sPwsgfs9henaeZPpujHsyW5Bmwo
	T8VpOrPvX5XjJ/fiCQbq8zPWYs1JatEMX7PWFxjBaXIJgNbfBuQ==
X-Gm-Gg: ASbGnctnbqV3kgr56Y4cACsIb66N7DoXmyNsIOXBEJfJBa7s18woHoBDNiDJwy6TGWX
	0tdE8qMBfK4v1/QPvLwIhjSY2hpHRNXnfgsNYeb4aPS3ds+Un7sljbQBSG2mVobJUzcY5gkiVrG
	hNZLzhDnEQXeCrv9AjnZ/xf1LyqO4Hhr7CYdfkaz1Ycly42T8JXSu7TfI3pWWfx6qpsH6cT5eA2
	yeIv/ntOUjWIvCA/X2CKcnMpRAxld8RodoFDrbAPlediTTs+jV5dRWx
X-Received: by 2002:a05:6000:2805:b0:385:e3c5:61ae with SMTP id ffacd0b85a97d-3864cea5716mr78555f8f.31.1733854960350;
        Tue, 10 Dec 2024 10:22:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHA80j/yrBcVlJPBL9NjcvqMe2Tjew3KpXlix2cTpx5h1/Gz71wdXKtYr6Szqo6cSyw10sEYg==
X-Received: by 2002:a05:6000:2805:b0:385:e3c5:61ae with SMTP id ffacd0b85a97d-3864cea5716mr78540f8f.31.1733854960024;
        Tue, 10 Dec 2024 10:22:40 -0800 (PST)
Received: from [192.168.10.3] ([151.81.118.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38634bb1669sm11209482f8f.60.2024.12.10.10.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 10:22:39 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Date: Tue, 10 Dec 2024 19:22:28 +0100
Message-ID: <20241210182227.251848-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Applied to kvm-coco-queue, thanks.  Tomorrow I will go through the
changes and review.

Paolo


