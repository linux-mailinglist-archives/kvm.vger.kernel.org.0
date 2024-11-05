Return-Path: <kvm+bounces-30632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D95619BC538
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C4AD1F22D1B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4421D5CFF;
	Tue,  5 Nov 2024 06:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w5c4CXLK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E381D88DC
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786513; cv=none; b=DIoxrpF7/Wsfqr7rQ0eiwuWZQUcrH7VuKQkB3vlhWVK269HNd8Qcbg8p3NJcDC1JPaV0X4BZ5SPb9UrCDHAhIJP7W6hs03usyfOz9d6xDSVEB8x4ekCv1bNZDhdJzzXbqYWgMK1N3u0tCI6zYtrKrUCkM6kY5Ws+udPDO8arlvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786513; c=relaxed/simple;
	bh=/UlOrFTZSFlr0Nzg7BNU9vAMbBRUCMAOKdKubKzwGHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FxnvxbL6NKzyOLV5xySUdVI429gwG2GB9fV7881ioD8eoOcFAvxnt+Vp/0iSxnKgfYiY4UB9A1DNDzVfmPJTz4NK41agaEN4XG2Q1bJj743s2WYIU9HE1KITbx3iI6WuQUC5q0LQEMiNL/xeyiOh2tO9DCTPDf0dBNLWOslBBzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w5c4CXLK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ee3c2a2188so4624506a12.3
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 22:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786512; x=1731391312; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EFxRma95FJlL/AZ0ZFonjChFS5fjisz3cC7jq4qdDmw=;
        b=w5c4CXLK9uLT005PJlvIbNJmVGmWLKVyqrIopJZXfDCHYkOXe2feIxaKvh9ztNVR9W
         qg7hlFKANtH3266tQ3ho5sJz0AOplicb+USeeZg8NBIcmtl7GCtm06Zt+yJXWTAeauKE
         E6oGk6d81QtKJ2y9gUKqxsr5SZwKkbo7ZmaYt+gJun2pv+jk7Y1BKFAYrRTeZOvBQBRb
         eF5F4L7CoL5yP9cMy6WNqERhFntyaME4rzNaLXEzRLnRfVteXSGL6BbgpzhVoYrHXHAN
         Xo7QxYDSi/7foQmojesOeXv+ytLsc/4XYkmW4UFxPWbLfTzPoba45HLxJ4KpVDKmjwL1
         G9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786512; x=1731391312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EFxRma95FJlL/AZ0ZFonjChFS5fjisz3cC7jq4qdDmw=;
        b=eDtrdLTlZkNpxL5VtUvPb+sptnniOajNLyvaNacs67LjM+fVOSHwxistkmxmSo7AoN
         uhByP0lZKLgqipG3ywaxYVVVhLfuxWLMSv3kFPL/0tMLtZiHpjS9YW4SwhUvHjkSJVnW
         g90vQntdfXu49BstAotR0pJi1uxhlNaOOYLXKiPsqQ2BOmQpwP44yNCPOmgFEmGGC56W
         F1EGpHZlIplQgjM1zwnYg0/0034Wtgfi/j/VEFIx/WLpw3lhwn/PWBMykPTThpUhoXR9
         u4sUf8nCMRWMPkpKJBF76dzcAAI+uAqESwlT/+l1FRJNhjIdix7/SPEBikoZr23tjkQp
         7AKg==
X-Forwarded-Encrypted: i=1; AJvYcCUOi51u1mLDhX6V/9H9rxH2phqL1Yx8aklkcIjY2QqjFrNtvISH4GzW1bPav1jQIBHjYf4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDbHi7aBoDpGxn6whV7JQvvxwHuh2ME7TPFvHU9etgdiH733PQ
	1w6o/6Su74bBHekKECgSS76zSAHI4a3cifvzvHH8w52hdbNo4mk8X5EWsmS76EkGD3bLyLZIRFk
	IXA==
X-Google-Smtp-Source: AGHT+IH9T5jG5+lq53S2D8rKsYDIM5HfeP4IAZaAh9l7gKD/WhV0dE367bDM6wdTRwPCFZQ3eWzJ/JKJ50g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:2a92:b0:7d6:4cd5:32f4 with SMTP id
 41be03b00d2f7-7ee3a38c4a1mr23159a12.3.1730786511409; Mon, 04 Nov 2024
 22:01:51 -0800 (PST)
Date: Mon,  4 Nov 2024 21:56:11 -0800
In-Reply-To: <20241101201437.1604321-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101201437.1604321-1-vipinsh@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <173078270653.2038440.10448863177930046934.b4-ty@google.com>
Subject: Re: [PATCH v3 0/1] Remove KVM MMU shrinker
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Cc: zhi.wang.linux@gmail.com, weijiang.yang@intel.com, mizhang@google.com, 
	liangchen.linux@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 01 Nov 2024 13:14:36 -0700, Vipin Sharma wrote:
> Based on the feedback from v2, this patch is now completely removing KVM MMU
> shrinker whereas earlier versions were repurposing KVM MMU shrinker
> behavior to shrink vCPU caches. Now, there is no change to vCPU caches
> behavior.
> 
> KVM MMU shrinker is not very effective in alleviating pain during memory
> pressure. It frees up the pages actively being used which results in VM
> degradation. VM will take fault and bring them again in page tables.
> More discussions happened at [1]. Overall, consensus was to reprupose it
> into the code which frees pages from KVM MMU page caches.
> 
> [...]

Applied to kvm-x86 mmu, with the massaging and splitting.  Definitely feel free
to propose changes/object.  I wanted to get this queued asap to get coverage in
-next, but I don't anticipate any more MMU commits, i.e. I can fix these up
without too much fuss.  Thanks!

[1/2] KVM: x86/mmu: Remove KVM's MMU shrinker
      https://github.com/kvm-x86/linux/commit/fe140e611d34
[2/2] KVM: x86/mmu: Drop per-VM zapped_obsolete_pages list
      https://github.com/kvm-x86/linux/commit/4cf20d42543c

--
https://github.com/kvm-x86/linux/tree/next

