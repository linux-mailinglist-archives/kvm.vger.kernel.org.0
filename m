Return-Path: <kvm+bounces-50107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C890AE1EDB
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7B567AA0CF
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563E92DFA20;
	Fri, 20 Jun 2025 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="n1MQp5cB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A23E2C374B
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433962; cv=none; b=Pmia9XdOzL4NqCvn4IauQHI5lndyICQ4/4q4XS3JB1WJS18v4arKTEJJlqQ04uiwNXa+nK7QU2V7vINLgCw/MyMFCagOjKH7YiGuR/PNS0VMZtrbSg2l+neYsMhWUa2nG+bXuwPrcpd4r6h525NuxQgPczi/T4D1ReYBiUEpywU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433962; c=relaxed/simple;
	bh=U6vqVTXGPTKQvzs69O/olgbrp4rz/AnLDJXDRo9QnGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9OTnQfbzV2Gipf36vNfe8Y4jgu7CsL4am/S0TjMLGt1pY8Iz16/CrDdKmGuesBM6YS9X7zTcMWNtPIrdo60EsJWdMeu00Rb3pTVppZSRA63rAkXEvPi7pkNluQKE3S11Yo3Y1h6Fbr7mkQanU9LTpJb/YsEjhGYbQXN3xd302c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=n1MQp5cB; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a4fb9c2436so1042480f8f.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750433959; x=1751038759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGTAxJcNDUhON5iQ40iumsO1ksjg8HVSQ3VHVSZPbOM=;
        b=n1MQp5cBsupppWNBqZyEWrKd8UXtie5GhCrsBB2LDMg5tk/2ybrYpXqxjQYJQ5OC3g
         jdBIjGvIBlByTsZEK3rGPs/2hvYds7o2PDVewOya+o9wOoVqkcPMZ8VboAEL8uSDU7Hz
         T94yjYjS79KaOw+16vTnlqntbNrEjq6/vk7DZFMGjO38z+VbTomq5gxyQNQmTgnXzY17
         LLoOaUagWWnPBAKGJsZOYviNmZ8JP37hjKMTK9sHFN0/O34xIu5YZgCHBa9NzTXnbDVn
         ndVXWP2Fe38GbtXhewU4hFyiw8uFti2eiHrmBgpXiKXQNbU4tMdh9A0cKk+v/twBH2fK
         NySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750433959; x=1751038759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGTAxJcNDUhON5iQ40iumsO1ksjg8HVSQ3VHVSZPbOM=;
        b=sy2p7UOrRXhcQ+WTstuIMMj4j2IYas2SEn1l/KtV9ppDkdrLZiWS6Z6i9cneBKPNFR
         rlrQajgHTuIbKcy9yEaRKqO6pkMG/IqR4yWIywXrd62GCXRBZ9/V1L9LUkW04q6GQUYj
         GKLjAXGHVe1M5QDSWbwAyomgLT4JqclY3agfqdFtbhKEQLoExKElp41ph7XnB38YkI1T
         10kFSOBsOs/+n4p1duqNXPhJi7mKROi/by2X59bq05vplvMa/DGK5LX41NTmfDqp4sUl
         cjKGCArr9bimBvsJmaSntumPFeh6axII+4SN19suRVevsCxDi/rddxJiCDhGuhwY0UPT
         RszQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq3B8/DUW8OnFbkT62hQo65GCv97qtr8wQaIP53jMNWZwxc0bDdC7YdSrC/kN+a2hUrnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL8FwHnRGyTWUBHqrvFihhGu+bEZR2JVIBt/1JOIlZlxriNdRw
	A+B3dgyohSFk6+GRHmslZP4Wy6yan7a0i063V5MI6e2+OTHsmFWyMoXlROmfdBXh3E4=
X-Gm-Gg: ASbGncuqB4FnWtLtWmhZoUQY39xwJfqlaIoH1ECo/dgl6Iisp1Oa00+KgDvAE3ckXIS
	1jeT2jBJwBztEoUgZ2QGjoRv3PTtc4XYh6AMNNwUZ+RG4QlWsHpW3rXlkYGaRzjP6QQPEazGa+m
	xbC/21EYy4sBbYemAGtaNaR0qzJibbUpFYsTdBu5yt1+zB/R7ZhqDrb6zIrPf5tRlk+w7LvaKkM
	hoKx9tVj5f7wNqP0eG6Yu9nrhrdAANrRPCpTvYI/N1jZZral1j65vjUPkpLWHN0fZ4Y7osraCWX
	RnQcDsHfgkpQG3RnGuFK+M/Gb6p0oWbHEgUV5R27oFSpXKgrJtKcMdvFguq6I9W6Wbc/Yn+maPu
	bA1fo90AgPV8jWHICcqXElDOqW6URSiiyOnmw0rhAzPYLtIoMYvEKfEQ=
X-Google-Smtp-Source: AGHT+IFmDrKCzKegx/QN5f7DSCw7WuKlkCQnJNvc/V8Vvd8wvKnJiwJNYojlXlvTJ296NREg4220Dw==
X-Received: by 2002:a05:6000:178a:b0:3a5:1cc5:4a17 with SMTP id ffacd0b85a97d-3a6d12e0cecmr2817755f8f.42.1750433958750;
        Fri, 20 Jun 2025 08:39:18 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm2323815f8f.83.2025.06.20.08.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:39:18 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 3/8] x86/cet: Use NONCANONICAL for non-canonical address
Date: Fri, 20 Jun 2025 17:39:07 +0200
Message-ID: <20250620153912.214600-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250620153912.214600-1-minipli@grsecurity.net>
References: <20250620153912.214600-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The #CP exception handler finishes by triggering a general protection
fault (#GP) and letting the test framework around run_in_user() handle
the cleanup part. The #GP exception gets triggered by jumping to a
non-canonical address.

Use the NONCANONICAL define we have for these instead of using a one-off
value for it.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cet.c b/x86/cet.c
index 2d704ef8e2a2..83371240018a 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -9,7 +9,7 @@
 #include "fault_test.h"
 
 static int cp_count;
-static unsigned long invalid_offset = 0xffffffffffffff;
+static unsigned long invalid_offset = NONCANONICAL;
 
 static u64 cet_shstk_func(void)
 {
-- 
2.47.2


