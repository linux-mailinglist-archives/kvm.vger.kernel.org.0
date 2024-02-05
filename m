Return-Path: <kvm+bounces-8045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE8A84A792
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 22:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC90F28D8FF
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 21:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120EF126F35;
	Mon,  5 Feb 2024 19:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h+iUiexR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91B7126F19
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 19:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707163003; cv=none; b=X7aXv3BK2+oul+LNnhrPvB8r+UckDgoZisH1VUgtX8lIZdn+Tv0Vg80SnGA5XL8fV6EHO7P7wZ3I/AhrHXyeAeVlDVBoET8DaU2U1tNaEtk8nxyPbunmIYl7j4mhkPCocJ21sUP2iYdcmjYvhaDjcj/yAjpNQxjpTf3ls8A+ZeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707163003; c=relaxed/simple;
	bh=02WevOzR7F1ml83hrSRGnJAm+ID6GOUPZ73AbMLz23g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GOPaFVHd7ahFLbf22RdOv3dEDtXr0aiXAly6d433iNdgCp4u8UJdn89edb8flk/FG8pwA9m2HpgZUaolku7+qXv+vCUGHu2vq5FpRkqqVVGcsTbzqu5DtP17e871iZPOeQoVCzzb+OqYdo0XGlqB/WdtqJm1o5axe384iBrbyes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h+iUiexR; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6ade10cb8so7324223276.0
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 11:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707163001; x=1707767801; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+DTrYIkl7AT71yg6HmiI+abi1ye8K0UNowyZnbjoLdM=;
        b=h+iUiexRo6Ateci5ZSTA0KtpMA85EJeDGz94E+7uIhoK0nqm9T1ESJUmK4D6peJxhk
         NQ3NNtHLd8apOG5thd9TTqbuZeAOf95gE6Bd81OHQJuxLNKuC8oCWnmlD9mlD/cYgULK
         hI99Ex1L9mIqtzw/c9mmLdrqUBHok2RHT4nrMe9OjkWxI6NusCfoDUNJxVBtPevUw97/
         m6ElbTz3wlycyLqI7+DJV2cmYdUtz2hHlseuKJJFBZ2piVjk7suIaxavb0KV1+3s3fPV
         OGtwHHhK6GUl/w9ST3CQASOqXbV7gbk/G3YrsiSJnPA84ski6JQ35g9K6voZ8P90bZEA
         6wjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707163001; x=1707767801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+DTrYIkl7AT71yg6HmiI+abi1ye8K0UNowyZnbjoLdM=;
        b=UC5radwT0FvjsIwDz+w+2OKY9k0i8eHWLZdq7yCG/BGs/Z2910A8Kg/IpKD8Lgf1VC
         CqGWTumEKTKZciK+ibVz7wxRYphfgQIirVs3by3bAAqzjOsDzvKddDf1fG2p4Jii0Gnc
         nucVxrhCOaQxO19wQXtcGtX/iPYfaqIEV5/dgNfKHGEebM+eYT4GesMA5mJf1a0en1XA
         E9qHevs0MX/6zkX9sc5KDRCeJ1Hv5pP8vzqzSX+we7zMPobwphVW8ACHaxUgWl9WObUl
         /pUZ8+yEO6osZdsZyT0WPvHMPpoY/BXuNdUs+gJ9sQjnpOn4iGilCQXIM9Q6SFV2hMq2
         E26A==
X-Gm-Message-State: AOJu0YxIf1Icf0D7U6qIFmB/fneAThM3ImmByjPZsATYTjnrCMXaT22k
	c2rUWNgkdhSoOnUw+EU6HZrP7fmgZUy1rFNpYHI91BYINWd1YtHUBpMHOtMbMsN10n29qYHcjVK
	Abw==
X-Google-Smtp-Source: AGHT+IEo0T5iGmQc0qy1LFrIp+gQ5qjOdl3u69OaxCF7rFqPrH8fm5Bfv8wVZHEzVTMDhVnHv+fG0+ZUEOI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2208:b0:dc6:c9e8:8b0d with SMTP id
 dm8-20020a056902220800b00dc6c9e88b0dmr1746802ybb.1.1707163001056; Mon, 05 Feb
 2024 11:56:41 -0800 (PST)
Date: Mon, 5 Feb 2024 11:56:39 -0800
In-Reply-To: <20240203124522.592778-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203124522.592778-1-minipli@grsecurity.net>
Message-ID: <ZcE9dyQ3SOuUZ8Kv@google.com>
Subject: Re: [PATCH 0/3] KVM: x86 - misc fixes
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 03, 2024, Mathias Krause wrote:
> This is v2 of an old patch which gained an info leak fix to make it a
> series.
> 
> v1 -> v2:
> - drop the stable cc, shorten commit log
> - split out dr6 change
> - add KVM_GET_MSRS stack info leak fix

In the future, please post unrelated patches separately.  Bundling things into a
"misc fixes" series might seem like it's less work for maintainers, but for me at
least, it ends up being more work, e.g. to route patches into different branches.
It often ends up being more work for the contributor too, e.g. if only one patch
needs a new version.

