Return-Path: <kvm+bounces-44594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13F7FA9F815
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 20:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81DC5189DC46
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 18:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DBE2951C9;
	Mon, 28 Apr 2025 18:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q7suKjt0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D34260B8A
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745863782; cv=none; b=tRpmC5k/DUNI9fbNU9la5z6teVxBgw1MGZL/cvsNKCz5BEyURm3VM42c7iDpx1hR4veB51ynZy5/WP67u6SOnXWrxYHRJHGP8kHJ0CkSQghAQyANyOFKeF00wM7cb0MczyhvrTDw9Xov8jWK6+TZAC0I63fokKCPs0Y3LklBNUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745863782; c=relaxed/simple;
	bh=Tp/iIl9Q/zHH79Zmt5OXH8Ujx60iyEVCTPY1h9qYcFE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=faDlzF9c2b8Qxe3FPzLs1CygqUVXXlK0/xPvDLCbAbBp/JIIkLIcvkAHudGY9Xm7B9z5sO5+A0W6c+Vb2r43VyNZd1Qzj/subsEAoGvMS8xMlk673iyZx+cxyHJl7b35L5r9xIyPSNvDLBlIMVIAdpc3t0UMCjV8e23/dZWszPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q7suKjt0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff58318acaso7625095a91.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 11:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745863781; x=1746468581; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tp/iIl9Q/zHH79Zmt5OXH8Ujx60iyEVCTPY1h9qYcFE=;
        b=q7suKjt0MCnoSNjT7lqdUE+P4SVeM5wIPR7GIMRErateXWyeV5zJRdgq1oTsHE0qEk
         zGF9nGnYs7XQ9Y/Ckr6rq+UVGnP/XCXmy33VWOBgyPvsorypiD0lXIPr2UDl3z8cmQVC
         0kRYxefMcqZPhcgye/3BevPsTGfDUwvmhksfmph5pSTxaHZWVdLaPjz1hpnqmMl0tP8o
         lyRnrsfBIBG21K6Osy3skKXFXwZ67qHvSf90g6mWIaYwVT3mAK26jJHJfZ5VIXooe/6f
         oBqADrTHGzPP50VAsBtFZYcv2A3kpLfoIOfnpRi0xYlBpQ+ve/DfcLpflHK44+6doJrv
         mh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745863781; x=1746468581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tp/iIl9Q/zHH79Zmt5OXH8Ujx60iyEVCTPY1h9qYcFE=;
        b=BkkmMPHqK5alqCXM7GhXL+cXTWteUl0ySGLihmIQleslknzXnGEOICMXg9/TtNPtbi
         uux4KMxCh+aS9mZi5QgPMqZ8C1ZHEXdSKiBshS7ol6m3TwVGT41IHQa6m4BGEfqGo6MY
         bnlUFUm2+T2GoaJS0uOKTDHfcy8mYDu0lv/+f0yQmx9/ZImObA8gGEWsSHylgzyfI0mY
         t1C1TyRXBJfpGtHmX1zHoula7zi2+4pBMqSe+Cn8RXM16hkTSbUNFNNhi1ksXwSa5Zs/
         sIGxQEn9fUMx9Jm5lrUVULPVqp18pfX5gPQNQWprl1gU2Cc2GzpL45QVG2S2FORX+pf4
         wuLw==
X-Forwarded-Encrypted: i=1; AJvYcCWuBVvs5/yRcv0X4V7wfLPNQmnpIIYPaNKHJuKlmFeRwEBD1JORfvke6B0ts+zYwTgfpFU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZJcU+KW7Ht9x2y8bvPVF1J+P3rz+6oG95rXLyo0zj7L3hzcA9
	GX/bgr3tosdAG4sReMIXF3W9UqE0yvPqNiU4/m0PF46sF2opwFMp0RnTNP4eDf4ODOLhmB9bIQI
	CQQ==
X-Google-Smtp-Source: AGHT+IG1aAcjSNzcjUnMtXPJEVikbQf0GuZAZa9ivU+BSsf6ZyacI9MZyufqcmANUeFXs4QrkN9zsIjMW5c=
X-Received: from pjoo7.prod.google.com ([2002:a17:90b:5827:b0:308:867e:1ced])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dcb:b0:2f6:f32e:90ac
 with SMTP id 98e67ed59e1d1-30a21552b2dmr1206424a91.11.1745863780872; Mon, 28
 Apr 2025 11:09:40 -0700 (PDT)
Date: Mon, 28 Apr 2025 11:09:39 -0700
In-Reply-To: <20250418115504.17155-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250418115504.17155-1-lirongqing@baidu.com>
Message-ID: <aA_EY8CR2kxi3X5T@google.com>
Subject: Re: [PATCH] KVM: Fix obsolete comment about locking for kvm_io_bus_read/write
From: Sean Christopherson <seanjc@google.com>
To: Li RongQing <lirongqing@baidu.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 18, 2025, Li RongQing wrote:
> Nobody is actually calling these functions with slots_lock held.
> The srcu read lock is required.

I vote to delete the comments entirely, the srcu_dereference() precisely communicates
both what is being protected, and what provides the protection.

