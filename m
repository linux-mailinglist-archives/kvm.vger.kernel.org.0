Return-Path: <kvm+bounces-45992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E210AB0654
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 01:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3AD63B897F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 23:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B91722D9F5;
	Thu,  8 May 2025 23:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j3bMqfmx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7841F416C
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 23:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746745461; cv=none; b=c/IpPiFNvV2CHRR9GsoAK5ELpiUN4PSlQMeghMr0q1xxc6BbfsASUsK7OYaV9doTiTmeA8W6Ia6K0YNPJtpRG+LRNICOwUDBztcaWe9kKafDQ9GC9RazQ9WN2hINi1aabYRFKdzEZffDwXEVNVyLu98YHqndVJ9lBkSpQeQskwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746745461; c=relaxed/simple;
	bh=erJZlkOCNdbv/CM5/d8Y8YwzyG2lJFJShmUNyHD+VF4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=tZYqFNioNYTauyaUIeyUeXwQzUK7Pr9cJ4SKSwT5V3ZarIlTvVV9UPhzQx+hE7mjNYS3Rp/09R9HefiG+JZ4ObBPs5ecbcNIggKopGYABzKQxiH6kGZnTUvHsSkY2z7oPvkuHbWXcMwKFcE71UyAxiS8N3dsO9txYiu7S34Ddhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j3bMqfmx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30abb33d1d2so2187281a91.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 16:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746745459; x=1747350259; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SM2XJe47CN2ZOM/67xIABCaNM4TaX2ab0ZhL0Ce0aCM=;
        b=j3bMqfmx5fU0R+dgFFAenFaArJlR8hbgChzkfW0iDpEPezHodQ+mI/fILf9ssToqqq
         hrduayTltGi0O6QTcKX6pUvA8Hmvgan5JZYBXsAchEY0ZMtAr8fwAhBIuqCVm8fG5EdY
         JRr7UuAaAKbfTRiQ58mCZzTqqrX3C1/1RAavRvBlwwwOwXxbfRY1wCoBhdMgdd8LYt8v
         7ydndUJZlZPLsw+ZOLU643OuVZxqU5jj6lq3yXrC4mAsjHWmrf753vd2no+f+pnsdwn4
         +8NI94MI6JfEcXsKmsC4kHsQRtro/m+H7n3dJUjFY9vki+uVmfeuRvLlpN7inBinLlE/
         DeiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746745459; x=1747350259;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SM2XJe47CN2ZOM/67xIABCaNM4TaX2ab0ZhL0Ce0aCM=;
        b=lK2YF7MQv0WgcYQMc3XAyrVUOxt80UePlNzqH76jJ4PLLl2tS134QChrfhkSoSrG5a
         BC9f/hmY3ZktE6j1tIueDSxgDvM/78HDIDF+WJGJjERvn86tQNFyxHAUS4Ner+ts3Ov8
         +WFFNgDYs8WRUn/LdonEojNPcRA/oi47WvM9fH0p784VjAEZF+asmZZeVnXhOUg6Rhbf
         GFpfX4aPN2+MxiL71RERi9bqwntwhAYrZ8C7rm/0CwIxWvL4U2UrlpoQd9J3EXENzZFK
         V0rhQIUYFUl1ebDt160phYEdm5JtXeVCY82yIyd8oiqeNC0hDUQ/OGfmwQY42RxzYUcZ
         ihNw==
X-Forwarded-Encrypted: i=1; AJvYcCULO9mUR9nMWCrczUqXpvKImaCrHI2lb/qflzgdGsr/wWI2aIiu6GRW7kp2Z3GpBt/d+pU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0vja7pBFE2h+plsjC1fZyWi9qu/0GQrqg3dO/KF0oY1GWZu5r
	Rq85x9ZDl3M67xmt76dpxbnPqOZiVmE2xp3adMxnlJXxF8W+HRQuNA/ZoeePdiyEdAikPbdftVr
	vaA==
X-Google-Smtp-Source: AGHT+IF08fdBrYOn5rB4GiEOPUWwLd/6PgVtzInb7iYf7JX8cBQEQJ4TliUxH0+T2JuJCblZNQq5ljz3XKs=
X-Received: from pjuw5.prod.google.com ([2002:a17:90a:d605:b0:301:4260:4d23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3848:b0:2ff:6f88:b04a
 with SMTP id 98e67ed59e1d1-30c3d3e8509mr2094760a91.15.1746745459276; Thu, 08
 May 2025 16:04:19 -0700 (PDT)
Date: Thu,  8 May 2025 16:04:09 -0700
In-Reply-To: <20250506012251.2613-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250506012251.2613-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <174674537050.1513194.17959981986179733390.b4-ty@google.com>
Subject: Re: [PATCH][v2] KVM: Remove obsolete comment about locking for kvm_io_bus_read/write
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lirongqing <lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 06 May 2025 09:22:51 +0800, lirongqing wrote:
> Nobody is actually calling these functions with slots_lock held, The
> srcu_dereference() in kvm_io_bus_read/write() precisely communicates
> both what is being protected, and what provides the protection. so the
> comments are no longer needed

Applied to kvm-x86 misc, thanks!

[1/1] KVM: Remove obsolete comment about locking for kvm_io_bus_read/write
      https://github.com/kvm-x86/linux/commit/37d8bad41d2b

--
https://github.com/kvm-x86/linux/tree/next

