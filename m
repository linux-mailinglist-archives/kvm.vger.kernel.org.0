Return-Path: <kvm+bounces-47216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 971F2ABEA7C
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 05:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4DD11BA7EB3
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 03:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC2E22DFA8;
	Wed, 21 May 2025 03:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="esXC/s7o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983BC3597B
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 03:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747799136; cv=none; b=jbdR+AXgXzf7D6Dily9sIi5FtqpbT0MagwgJLQRt5DWbzmp24JpDr6UWEGizvxQe4rPy5t9gJRLIEn69+/FdHgUJ65/yViE8RR75zerl7K9qtkRzD1RXRhT1tvwsMtZ5OnGqIT8yfo2dDsNbt/mKqH0tHI5xd5yffeB+MGxxq2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747799136; c=relaxed/simple;
	bh=O1nUeuyf60caQs4YipXkwwtXoVtAAWz1hiZeNTf7u8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSX9d9TuBQ3cIJr1NI/SYmDOC+vGDr4/snyOekWvjceRNknO5+Sk/QETMgggyQ4Up/AFTLSs7YaazuCnnWNbgif8y8wtwo4Xgn/+hfNDztPPBBlGDM1urClNpfg3uqpR5QjjQA03z0tDdxhKajA/9p/kakUwBDNXAPBcA+S/3ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=esXC/s7o; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-742c46611b6so4457515b3a.1
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 20:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747799134; x=1748403934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o7hEoH+zcw9qfhoA2RR7ZUMoaHFS8IYXKKvYv1G1J4U=;
        b=esXC/s7oDNaC4Lb9sctnmNwZ/lp43kX5EFSj4WTJkS1yCHDIH9vUR3NHBgord6BcC2
         tm7ul5//vRCrevpgSPI7PANY5GGCNaVGYuOjkWz8h9NrIhUlaRiJvSuPr4h6Qol3tWjr
         5dAuAaNJeYrtCMdc6EIRng1eh4RUs+j3ktTnsVCayZDIxokWXCF+O9j8u50rFMRmVo1I
         OpcauIaBoLhFbWyH/QTC0V7Xub5zx85qs1DVLwHoxhIW72nlFwW5n5+pkcHXWxR7xPxg
         yAP3FUuDtsF4MFuU4zkR+i8Ss2RtTk34XaHU1iwgo3gb1SS2yFO+VBnurmCy67SqGCUD
         XPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747799134; x=1748403934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o7hEoH+zcw9qfhoA2RR7ZUMoaHFS8IYXKKvYv1G1J4U=;
        b=g1R+MXrKEApc7VGsfyg2L0WOYE/lR8HEhAKMZfdz2E/5AONQvGY3ELFlv2GDHaQfUJ
         qsDGGblHz/AlwXgzVCP0q0xbRX38cHaxJ4qk2VfHK9d3gGCXZDEilISxLvCdr2MBeJ1G
         i9Ug5xaxuWiv1MLobqeoSC7EO0ZQBsbKvmF1XJe6jKmfyC1J98QwjfaBZAmXeFzVR634
         MyUUpdWxMowk9xDO8LhJ+OGY1uV2UPgoOI65jqiek3YI+ALQt4rLVqd6RvOlRe1q0/zt
         TmakZqu/yxxjP56RR4DjUWJuzVJmM0a5XdQiIDNN/EB/3BriN8lVQAsQei3b6dUNR4zP
         u3ZA==
X-Forwarded-Encrypted: i=1; AJvYcCXZICtvTPI0Weeq6SnA7F1X2oIoUM/kBl69nM5zZSlxP77+cfLhg2Y3/lK/S7WmdYUmDWg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1oUhmrN850lUUN1svJ6JPprxo1NIpp+whwQ2EAAnAhJKVrBCV
	rrldKZVwKn7Ci19cbh4bucClwELDsIhSeU8KSfYHXHuJ1suDvjL917Iano9jEAUCee0=
X-Gm-Gg: ASbGncsMd+AVln1aIROGCWSejTxEsLWFbjkTtJV10+ES+GmeAEbbNdOL2nsp7R4Ee2x
	3GVmfKf9FTiq80ggN0oTJc2FzsIUUFCTLLqTzweDX5ifq9ivVDObi9pdkr9Fpdc7Ewup6avF5yY
	KbElOx7JehILqGHAx7ih7Mn0wP1XcRU0EcYJx6vpTI7t+5p/5Bs+jRaZOlhknE3swDFREjM8+PR
	OCkD10c9vYEEAESmevBHLW0ZlFKuCgLNzpg1C1u8uC6Ym7U7zGyYENvUtYS/dV+QqerrYSmQYoR
	TAMhR+1IYTVv1s/KxsTMLsl7hGayqOyyMN1GiTFUaQeeObfWiKsuuOY6wu47naWm/lVIpIXpC1L
	fuw==
X-Google-Smtp-Source: AGHT+IHVAeIGc5tGCopyE1Gs/q/I9hs3854vPW79q21Hs67M9n3WZLDyg+LCqQHMBAq0cvQEEuAojw==
X-Received: by 2002:a05:6a21:6f83:b0:215:de13:e212 with SMTP id adf61e73a8af0-2170cb325a4mr29600337637.15.1747799133868;
        Tue, 20 May 2025 20:45:33 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb0843d1sm8845883a12.49.2025.05.20.20.45.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 May 2025 20:45:33 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	muchun.song@linux.dev
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge folio
Date: Wed, 21 May 2025 11:45:27 +0800
Message-ID: <20250521034527.74170-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <3f51d180-becd-4c0d-a156-7ead8a40975b@redhat.com>
References: <3f51d180-becd-4c0d-a156-7ead8a40975b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 20 May 2025 19:38:45 +0200, david@redhat.com wrote:

>Subject: "huge folio" -> "large folios"
>
>> 
>> When vfio_pin_pages_remote() is called with a range of addresses that
>> includes huge folios, the function currently performs individual
>
>Similar, we call it a "large" f

Thank you for the reminder. I will correct this error in the
next version.

Thanks,
Zhe

