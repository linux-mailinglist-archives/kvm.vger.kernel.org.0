Return-Path: <kvm+bounces-18813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57ED68FBFD7
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DF3D1F24439
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9021411F3;
	Tue,  4 Jun 2024 23:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1LcqSMmo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D49914D708
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717543801; cv=none; b=eKySntHQT+ci/SqJjBjHjFmliZA7LERX7vufVfHyyRFePJ0Dfq6FlBphZW9ZcFtINYOKn6QXt9FyAsOOxORiplpp5A7PSsWS1qH1PtiIemOfkEuTM1ycuSy9Bmzey5I7ix27hw5B3U48Zz713iYxoNScX+GjUly9xktVYsTTTco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717543801; c=relaxed/simple;
	bh=1CPZiA6INEmChoO2tlzga4qjDWKQ0cNAe7c521uB/7c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pvLhGHQBF1gCRVP/Z/qGvn4J+OdDxJ+R31bnH49KPRDNmGTjT47iJnRNM5bvYZHS48KMNnHdRIrc8iVt3DCX/0vBHQshJx2qncK5O0Oo22wpHLY245dHAj+IjczIQiow9Qb4wCdzlsZspWj7JtqUdPTim1lf5CX5Bmj0VTjq9vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1LcqSMmo; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df4da3446beso10070020276.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717543798; x=1718148598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+/IPdu4hj/yme/dZChtUZ0C5WW7ZBS7c2TXbVWC3Z68=;
        b=1LcqSMmobeYC4Jy1Qg5C9cbrL0jfBdE9nFFil6Q00DOeWSpfhrLBN70QhIz12LdaJe
         LWNKm17Fzbz6l6kfYS/64wKmqLNT1aCoHEX/wXJNrsZWPweFj9Wp3tgpsIU47zau2cDx
         ePLP8UlFK770uy/Fj0ndWXIIUXyeOZJIulMHS0JD5qk19c/c5WutGTK+qlZ+eErw56ho
         okhGCZL9Eyj5CZf93CtVu26LGiVqFgDBaAoEXLMlHYxDdfDNstCYAd8NuzBcgZ5e9qyv
         Uz+e5DJGNcyzC/QUfCUy5FiHkk+hmFm+EL8f+eyGfJwwz8es25r3OVqn777oj9PvMOn6
         JVWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717543798; x=1718148598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+/IPdu4hj/yme/dZChtUZ0C5WW7ZBS7c2TXbVWC3Z68=;
        b=uL1H7PuO0VkX+Lnhd6CxXrk/jNcafaiQCagAL1PXiJWEHk0fC8oZ2+o1HAFnllvFz+
         QNemwMm0qzb6Wir32ydOKElycSHP4pfSjEQubuCqsKEpBYP631mDQDXdOqBsyso2/PkW
         ZYx3lUGfvTSOKaAQlD2xK0Cnpr+/jvzcyA7A0x7RafvQU3qh/mgkzO/yUppc7Mox65/+
         6XQL1RghO8Ub7trrNJU6CchaYjNUuGGAZCqG2MqqiVFDNXq7LD9KgPA3AkAq9m8YvMNR
         /HVP+D62oRJQZPSW2IUjmp8ZAFnqBjt/Cw0rFtwPxbGTUM7N4Spqs4AmdsKRhVPVUWSc
         Aw8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMutVoQVWXBwGIDmvXrsHmSug7aaMOGVjJP9sk4HZnnIhOklWzAs/Uwh18Bj4siptnZAZbF/2il8Me0JHhUNeWGZGg
X-Gm-Message-State: AOJu0YwerrEKB1o3IfGsdCjzAxAfh6QK8KunNOgwe0g2P31QjISn/MSw
	59i+EL7pscJJuk5Xxv0LkUoWF0JqjAlgD0CMNLB6/4rweTp7WCZnjKPp8CKsz9+wpxrMgQWMks9
	sAg==
X-Google-Smtp-Source: AGHT+IGWy/dyLJ4FnbW/sIxAuLzeg0PeUt9GTxXukMmEsdG4x3vVbjO7Imu4Mq7Fov4av9rDNrt2uEjNDwI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100a:b0:dfa:56fa:bb4e with SMTP id
 3f1490d57ef6-dfacab2fef9mr183043276.1.1717543798579; Tue, 04 Jun 2024
 16:29:58 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:21 -0700
In-Reply-To: <20240513014003.104593-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240513014003.104593-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754268137.2777430.1222935014468693201.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: selftests: x86: Prioritize getting max_gfn from GuestPhysBits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>
Cc: pbonzini@redhat.com, chao.gao@intel.com, xiaoyao.li@intel.com, 
	yi1.lai@intel.com
Content-Type: text/plain; charset="utf-8"

On Mon, 13 May 2024 09:40:03 +0800, Tao Su wrote:
> Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
> max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
> dirty_log_test...) add RAM regions close to max_gfn, so guest may access
> GPA beyond its mappable range and cause infinite loop.
> 
> Adjust max_gfn in vm_compute_max_gfn() since x86 selftests already
> overrides vm_compute_max_gfn() specifically to deal with goofy edge cases.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: selftests: x86: Prioritize getting max_gfn from GuestPhysBits
      https://github.com/kvm-x86/linux/commit/b24f5cf7b2ae

--
https://github.com/kvm-x86/linux/tree/next

