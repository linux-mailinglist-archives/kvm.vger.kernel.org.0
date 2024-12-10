Return-Path: <kvm+bounces-33444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2A59EB93F
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 19:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBB651889AC3
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 18:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775212046AC;
	Tue, 10 Dec 2024 18:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3BfPAVf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECD738DEC
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 18:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733855028; cv=none; b=sUGbN1nU9Bn0UJTch4JFBoeHf70/Db5F2xaOUHaVfvlIPd0kPZ+kC6+IZGaeerh+UBHZ1IxxoAI70hPPDheLcxcHsyaAFT6Tq/nPiGGBuTAAKRcCOI7LgWrAqdubLchSLBOF68nBEBwLRtlz3GnVDv2KD9o9hrmAJYDY4B91qd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733855028; c=relaxed/simple;
	bh=7nhMPj/ozuoD9sVD9Ow1ZB9+eVVLEWg/CeyeINkPCXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTYK4aQGK+I9k3cdM7bLqUBKhMIY4JeZ+F7j2ycJDFWt4EjGk3n43N1OTbI0fnsSpMv74oTa1nfoIhkTXg2taHhM1TMkRnk9a42q62aCpXiJMP1zc2HNr0zLegz7QnjokXOJU+i/7ixFTWhm+E5KgOnHvtnNZEJO/9VZ2bD1yjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B3BfPAVf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733855026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nhMPj/ozuoD9sVD9Ow1ZB9+eVVLEWg/CeyeINkPCXM=;
	b=B3BfPAVfHeotfHg4s7PX2C2H3D8FMRuBbK+Lo9F/rTKHF1dgfZ0A88VyCs/MTnJiSNkKFX
	8aOJNRwOG7ILFcrNyAYpAP9y/3X1fwLYoJbX8uuhews0Qee8Yhp1AZLueCa/BaAKNn9P/x
	jDFqkL60Tj/2wyNx2+PsQFpq8E2tTNA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-zHviIP-YMhiIJ5jefUJZfQ-1; Tue, 10 Dec 2024 13:23:45 -0500
X-MC-Unique: zHviIP-YMhiIJ5jefUJZfQ-1
X-Mimecast-MFC-AGG-ID: zHviIP-YMhiIJ5jefUJZfQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-434fb9646efso19327325e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 10:23:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733855024; x=1734459824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7nhMPj/ozuoD9sVD9Ow1ZB9+eVVLEWg/CeyeINkPCXM=;
        b=ko8gtzMy0TliY3vluUcPgwGnZyMqlAZHwzBvzb6EEZtVGmGR8RJ9v0YhP/i3VlLhDP
         hIZ0sFsoegbXhADlGFd0ujBTqmpWqXfw+LrUpXxdzh6R7yj4I1xkFApFbAwiKHZJM/HJ
         Fy2AuacitWLDXsPEVw4Obe7kbKjnnFIs6cbHnqhZm/0eWtvfBzkNCusbcJfoLCX7A9Wi
         WA8AnuD8Gb8H9vTy+AS4E9dE2dkO9xP5419TiT0Jmsvx+XnOWhSa6n/yeWR3ta35hDMU
         frHIEGiMUjidc+qOc5sahvG4oxp+LmR07VgmH5x31cfA7iL3qSwzjJfTyx6sQG5fmQ3m
         4FWg==
X-Forwarded-Encrypted: i=1; AJvYcCU2PtfPm95DSDwpBavDPe6QNhSspdDIb+6OdksTiuFPgBjdnrw3puUqYFYUEHhzt7pW/9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvJ4V5NBEI633VM2XosH0CBjElIeg14/66GyPV9frEBV1d2ULL
	ZsHpMBbm3vENnPiHdyYhNWb1E2Rlj8EcI0nTC4fHutvJGg3huDm0py1TRCXp+rVfGnaH5JgFTb9
	SgCks/Bv0zyRrcdkw8si6+VIrtP7raxVJb9PEvRr701X+oLpEPQ==
X-Gm-Gg: ASbGnctvcBqDkg7RebCTFG6RwCfNSXGh9rbn+O7aa9Ttm09jEfVtuSdiKozqYEnu2lR
	yT+ruLz/O1pi5yxPHeoogHN0/0/+E3ZXum1L+O0sPfeO4SQx0rAnQIswE+kdGA4EQJ1FV5R7bnd
	IMJN5xdQUtYeP15tp40/j+5PYdJzoy44Vf/ZGzW3lFN3X5GgrhSBCQq8nmLiR/OHIwE0X1Ttu11
	J8fdt7pnDitpVOP5KZnf3gMJeWSCC04+XGQ/RQCWPrwUPPvrrdUdgLD
X-Received: by 2002:a05:600c:5101:b0:434:f739:7ce2 with SMTP id 5b1f17b1804b1-434fff3a13amr48639935e9.8.1733855024003;
        Tue, 10 Dec 2024 10:23:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGcBUe4tQxr/sYMsPdsIGolKvRnl6iAq8l42fK6nd/vXtSaWTjeFoSgTyan+aE+KKg/tDvXjg==
X-Received: by 2002:a05:600c:5101:b0:434:f739:7ce2 with SMTP id 5b1f17b1804b1-434fff3a13amr48639715e9.8.1733855023643;
        Tue, 10 Dec 2024 10:23:43 -0800 (PST)
Received: from [192.168.10.3] ([151.81.118.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434da0d26b0sm203807665e9.9.2024.12.10.10.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 10:23:43 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Date: Tue, 10 Dec 2024 19:23:11 +0100
Message-ID: <20241210182309.251904-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241121201448.36170-1-adrian.hunter@intel.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Applied to kvm-coco-queue, thanks.

Paolo


