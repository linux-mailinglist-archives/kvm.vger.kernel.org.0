Return-Path: <kvm+bounces-18830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D818FC00E
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9BA31C22885
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E2C14F13C;
	Tue,  4 Jun 2024 23:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oJW1vHPG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2353B14D28E
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544401; cv=none; b=oPQ/a7QFxSG4Q5rPO9egkISXw8siFS8w8WvO9YUKXBowbdiEcaVFUrheOYD3vQ7ma4P6/Z4iI6OzS9BqVa62pTzXFyOSaSOpP7WdZy5CVBgBYbNFWEGulH+cJs8CwmX139aP75QtXFkf5H7Y1i4BPc/lxtAm8EEiMHrf05rZPak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544401; c=relaxed/simple;
	bh=ZkUU2s7YT2yjYFDYrFKN0OyDTFEWJ3XnBoulxDsjwm0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mp37t7oGrUeQWAgviYpdhQd4CCkh5uK8mzahni+04HQ2JA7Onnt728RdGfw5STCPuTCVrJ5PEn7B/SZtFcouZCev7Fw52sVHoVA+F9Inl9F69VvQq6U0+mot3LoGqoPTcb0tQeBj44B8wh8+1JtUtqKi1lGrvDKDl1UHU6ggSLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oJW1vHPG; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a3dec382eso5165187b3.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544399; x=1718149199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SE7huESKi5HuBouKDmqrLhttjeAwWKTCKSgfCkXoz4M=;
        b=oJW1vHPG8NiO3anCS5PKnK3QeAGkt4/Kw32b+mkuzMsFDXuZG9Vulnp77K5EgOOhJB
         T8ewBZb/FIAeamk/vkCU65HATC/AH5mamtY5qxphMYLiNjvY4qKFJpkXmmoQMeF5Zo9Y
         t+YeKHA2Gjcyq2OCvuiB0O8nkQBdGb7SeWfNRbJjckMAxYUm5euSN35GNCQhn3hh4bwt
         fgqL4c7Wq+iPAcV3h3fAnCtHD1Amgc5E18zy3JKNcTFmt9JCmfGdGwzpGEAeBDtgz6kN
         FwVTqaLiWRd01crOT+uNnJXVnudzWEdmB8UuuNxo/7A3HGuRA8tg26ozpCUBMCevmNXJ
         dVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544399; x=1718149199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SE7huESKi5HuBouKDmqrLhttjeAwWKTCKSgfCkXoz4M=;
        b=LefwVezg788C+eB+eB4xSHu8PAts/r+sLbXKGZJadUv5y28YTiRSatqdR8rnK/RBX8
         LpWmns7fuhi7eNWCEzrI4bJkUD5TLCCZeGWll5GxisMaBjhdoLXhJhmlSG6n1TyJ2uWi
         CZpzKQw8YmpZr8gwrCMRrtyltLfKVEkStUg14WLyNXMxKK4Yy3wcaZR7HEzRps7pO1Yv
         ocpekic/mIO1sDwUIpC6Kt0vf83sag+T8zSlMv5drVOiQXQEpJXcfZVgzXNsToO1aY52
         SkKqJzegYBOO12pJUg6BuR033n3cs6paRwQb1ISVu8lKpQLEBzH0IFDZXbvZjCcOvawo
         2ziQ==
X-Gm-Message-State: AOJu0YwtsaHAKsQts2dDS4+ybl18ItgZxigcQK+cagbWIAyWxL5g67Ja
	9Efq8+g5u8A5lhXcwwMEJAi/cLVqQFTVPQytqYnKooxFfwD/vN+QN06HeWY7S3gyJ1B3Bj8EOLl
	8XQ==
X-Google-Smtp-Source: AGHT+IFEUfCRDeqFSOjfCbxwRuJDNVLj1qRCvp9i4iWFvxVDCc1hcitsMhTyH4opoA5K/hQxiokX37nuRys=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c906:0:b0:618:9348:6b92 with SMTP id
 00721157ae682-62cabc4cd34mr9648967b3.1.1717544399227; Tue, 04 Jun 2024
 16:39:59 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:53 -0700
In-Reply-To: <20240602235529.228204-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240602235529.228204-1-linux@treblig.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754329970.2779150.530235553362373493.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: remove unused struct 'memslot_antagonist_args'
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, shuah@kernel.org, 
	linux@treblig.org
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 03 Jun 2024 00:55:29 +0100, linux@treblig.org wrote:
> 'memslot_antagonist_args' is unused since the original
> commit f73a3446252e ("KVM: selftests: Add memslot modification stress
> test").
> 
> Remove it.

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: remove unused struct 'memslot_antagonist_args'
      https://github.com/kvm-x86/linux/commit/f626279dea33

--
https://github.com/kvm-x86/linux/tree/next

