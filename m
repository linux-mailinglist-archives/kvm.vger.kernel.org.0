Return-Path: <kvm+bounces-33442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BC89EB938
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 19:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0515D284286
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 18:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8FB2046BB;
	Tue, 10 Dec 2024 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BG9Kx6R7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D4F38DEC
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733854942; cv=none; b=ekLg9LGWrDXwOJ/HMBNlNZNpwJ5esOfEo0JCohB5Uzs+YmnpaARHHgtlChVK+5aQ4vHqb6gaxfQXjV56XCfOSGZisV4sdgEXEvbes8yzDDk5/5KQxjTeHwEz8OhU1pykeEzt3nmAUE6VIHEeLKcmxzP2drdaX2Z/3J0WqXRiy+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733854942; c=relaxed/simple;
	bh=1pHfdGZ8TK0Gn1cA1yV/fONw8m+PMIvPeERxVbGEHKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2W7LXqIguAmLzNWmFWnFq6H44XYfhiXOEdY69CxrpPKxmcWVYopZYnvAe9cf8Mtj6s8TqjO2EzqJ/i2Muyv9pYAU/mygU29z7qicIiDVAJrOvFlexmbToUZbOEJGq5D/afMIzYPkP0z5l2obcHeJeAhZFOXQmul6+Dysx2OWzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BG9Kx6R7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733854939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zOADznZ6shRkxpA6k9z+HUBrSDKj4HgVFQ54YvYLX9M=;
	b=BG9Kx6R7uMtILMmH66eyw6eVH//HQXDgdzNm+8ahpm1F6FEGdkzv7jKqTmqSWFdEfbRbaB
	qD9xnpMymPGY5IDwalNi234UYZJsFSKm5QZJSqGt9GaJBy/jYVZemluYpUyM8l9PGAsm3G
	i9OV58slS9DzMi8gu6/2gJjxx7TGXes=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-BkyZ42eTMBG-dVGdB6NNVw-1; Tue, 10 Dec 2024 13:22:18 -0500
X-MC-Unique: BkyZ42eTMBG-dVGdB6NNVw-1
X-Mimecast-MFC-AGG-ID: BkyZ42eTMBG-dVGdB6NNVw
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e03f54d0so2460144f8f.3
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 10:22:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733854937; x=1734459737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOADznZ6shRkxpA6k9z+HUBrSDKj4HgVFQ54YvYLX9M=;
        b=fAVATxZkP0FLmHIuCHqriloQv4eUM2uPWEoM0HM0e4RXgiOFqiTCrCD92nlBOhW0It
         NbyDwADwRWQHy/vLOJppcurhsnLowdI2l8PnfCdOhiIY/4oxUjatK3+uw6kmCfLlsKWs
         1zkDOHtfurgAth1JQK3cNKIE0SUDil//VGUOiMRUjSZpABJduYFA995Xr+5pDuuEWz0j
         WGS/F/40idkxP+Svk6jk4MKt8tP7+LPiFrryk+JrtoVz/3GtthwnJPMC4K+bau9M1sFr
         NWC7vGSIoyknVQyUJJBfX9kLpBYrmUQXUEk21WZJLe2HmAjEzuM+r5nPBqBynJrcrbhf
         2/Gw==
X-Forwarded-Encrypted: i=1; AJvYcCWijuqxS9xLmN2mhCeOtgqDMkb7LXxM/EmSC1DU/UN3Fy743t6Ou4D8Y+fiketnHJ6qkaE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+aoXee044axZqpiqpIDFpBtfpIPr3Y469qTKGRIusvgvGn9U0
	V64J5o3giBGlPe5SZ2cx5Jf0FUgHm205El/73SE2ErNjhjFTkKHDZp2AhKbu0bFsmhjhKrex0Gg
	EThmKruxsnETheVCgiCdEVLAr/oq+WnUc8Zo1/QEDZvhSuBQPXw==
X-Gm-Gg: ASbGnctpUCb6Z2UZDuAuFT9vBGtcKofS1gRDtRwPuxjYk4zJNpt5LUMqmIxFMU5+n+s
	A8RV2ePvDnBOtp2jmPnpFMBDUesGRes2sSpqkKkPoZgfz/vRLxMNmVtFuKtTo4aYBIpND+JiCw5
	cpL7llPD5v0jm+xw+Nea2GBcwZe0B9b9uhDeGKmVDT7VQgaeoixeQ0agk9eeEABeTM7A8Lw8OU5
	fmeKaVWtqIeDLru6vfuxj5Wu1IqNZ2thJmo8gDezjkBKrG+PVHBPP0L
X-Received: by 2002:a05:6000:184d:b0:385:fc97:9c63 with SMTP id ffacd0b85a97d-3864ce894a8mr101556f8f.9.1733854937416;
        Tue, 10 Dec 2024 10:22:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUJ77YDtXN6cvySvDYXOgTSlRflMAT/JOMpZp5d7B2OiXlMT2r6y/f/JDsGlP5KLnA6E2SuA==
X-Received: by 2002:a05:6000:184d:b0:385:fc97:9c63 with SMTP id ffacd0b85a97d-3864ce894a8mr101539f8f.9.1733854937041;
        Tue, 10 Dec 2024 10:22:17 -0800 (PST)
Received: from [192.168.10.3] ([151.81.118.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38637111f88sm10383997f8f.98.2024.12.10.10.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 10:22:16 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 00/24] TDX MMU Part 2
Date: Tue, 10 Dec 2024 19:21:57 +0100
Message-ID: <20241210182156.251791-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
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


