Return-Path: <kvm+bounces-14048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 574BE89E6B6
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC72D1F22632
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AE963E;
	Wed, 10 Apr 2024 00:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GZzzWR4H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E103A19E
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708430; cv=none; b=BKwbvfBt4FqgFnUkXywFAqvxH6bY+Z3K1Gmdhsw5xg4c0uMAeY4QFBVE60WF1xwli1EUmAq0LJ1HBz06vk3L7v9gwsFYUg3WD2D5+o786iwk4ZhZ9gJY78nI+JE3jFk2okepqNAmiso20Yi6V0glv5DCYkh8EBZCr1lmV1Vn8Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708430; c=relaxed/simple;
	bh=kuJQWjJaE2OOAcB7+Mj7bSmqNkugL/GwYSdQp3xFQmE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VEutTzCVSvK66yeN4Kj6rjd7NBmOB8Red9HIPlkOKzK0KtdVESQdNfwt8eGLbTvY6GbQfQc1+DOMO9OxUL4tY5NzCxoK5Z/PsjtJonC5L0jegnF1kkF+iznYCxlSbqA1bIGuukzEbV59H83V/gdymrSUOyyu2v9jAKN2YkiOxtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GZzzWR4H; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6182f7f7fc9so20676927b3.3
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708428; x=1713313228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rAKPNUoQGPaQKahi3jTZ7ES/C/RE/TCbwkXna9U00WU=;
        b=GZzzWR4H394iWePssEmOOKfNlhDnrcbzs/nkAbNI0kqWFOr5RMc/RpWnJ8JlDVkUN1
         z90YAX/rcE2GUJLs3OFuA5Tu7BqW+7uHHuOZ7HmHHfbtCnG6rOIqh5fEyJgQ7auqGOe8
         ywjKjq8ztYQo1g3p4u9pp2VofvjlcLRSzy9rJWCZl4GotYxkpbCv7h2nqoIIvqvNACte
         NhmSDfr5i9+5u9Jr6gSiCmu12+1yZIJRHFmbMKcj5i0G0lnUKDiZ6DF650QUC3wBQxMF
         3lp+S1ssBxXUc77jjejwxGZ+E7iol4W+thLFRv17AghjOYa3qWVk2prJUe5FTILbx2iV
         P7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708428; x=1713313228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rAKPNUoQGPaQKahi3jTZ7ES/C/RE/TCbwkXna9U00WU=;
        b=hciIgL/t9G3yX+k4xZRm2fgQwa9HYTtXMWaWYNXC57jwfr2qWyCSVuDsCvH0FQ+VWu
         7M7z3WLCzzj5aMRS1ZP5T3tZjl3ImcHwo2eK8nK+h9aV6VGRThKoFLJWdR2X4/ODKkGJ
         eISrbSW2OGM/LTdJR/dkQsiBfYuMJVFtiCmGouo2BRGklD+9JRHuZLI/BneffAU3eTFv
         DqI5HJUDrrzCnnh8itu70fkzNBROP8p52yWTL7XZQvE5ca3WxemDZA95JdiXHU3WX9F/
         vVF7HwG2yrzoLPsM1ID2hiA7RuWL1e5q4YyTHSBDjyOtuMsTxidTqtyWINvurRDB2mSM
         K/dA==
X-Gm-Message-State: AOJu0YzPgy1nMGCxRm8b0CBFeX7v52cYjunp1LPEhmYPeYMIims2lsOe
	4MQYGI9TKeIvGr1DxJVItMW5419kskUlYhK62MC2k+ehIgEnT4Ww0XVRI0hNjSD/gOVh+cNV4Zt
	MTQ==
X-Google-Smtp-Source: AGHT+IFiLrCcF2gPZk1+gsLvsRjqTLlCh84H6en3uOOmmqdRwlLNqKPZGV+CxW5PP5zgT0hIJbuV6emeuMc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cc4d:0:b0:615:1d0d:eaa8 with SMTP id
 o74-20020a0dcc4d000000b006151d0deaa8mr341965ywd.5.1712708428045; Tue, 09 Apr
 2024 17:20:28 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:19:44 -0700
In-Reply-To: <20240305003742.245767-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305003742.245767-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270407761.1586889.5401391360531652033.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Drop unused @may_block param from gfn_to_pfn_cache_invalidate_start()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>, Paul Durrant <paul@xen.org>, 
	David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="utf-8"

On Mon, 04 Mar 2024 16:37:42 -0800, Sean Christopherson wrote:
> Remove gfn_to_pfn_cache_invalidate_start()'s unused @may_block parameter,
> which was leftover from KVM's abandoned (for now) attempt to support guest
> usage of gfn_to_pfn caches.
> 
> 

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: Drop unused @may_block param from gfn_to_pfn_cache_invalidate_start()
      https://github.com/kvm-x86/linux/commit/b326ec064c9a

--
https://github.com/kvm-x86/linux/tree/next

