Return-Path: <kvm+bounces-21393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6BF592DD2B
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:50:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0474D1C203BB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F60915FA68;
	Wed, 10 Jul 2024 23:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TxVFDFfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167DF15EFA5
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720655355; cv=none; b=Ze3Bz7LcZ/WwAxX++PNrsBDd7ntiEWTlZWASJbsUlYnfsfR+0iE3lFBFWReLcL56DiVIOZIJk2McnWhlCWKH4R+B4MYhwYFidQvHQ3X1IcuUc8O9UCBlXXbuCUcS5BKP7y8D8pHt12dlxfQPDFGsbDGbCazo/LD0msuq+swP9Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720655355; c=relaxed/simple;
	bh=WpUWnTWcQ9yZbCFEuArGMs4Fxk919PYBB/xOGitk7xM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ll6rFYWqtLgkOkA7HSKR8WH5EanONWQ/R29YdTTt/OtRZt9fyGhys5gT2FZ6e+wIZwz0h/JiJFHWIZs1Pxqe3rebHbKrWs7rV6ayMOUUKsNbVE3bC5I0yKUE2coIGuluSXySgTfDQWZ6KeKmZVELmkX7mlHZse09CdnMLDPXhu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TxVFDFfZ; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-44a8b140a1bso131891cf.0
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720655353; x=1721260153; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WpUWnTWcQ9yZbCFEuArGMs4Fxk919PYBB/xOGitk7xM=;
        b=TxVFDFfZrvROa1IKZ3G5x2ZkEvq9G8gQk4z8oeAb/KpPpPvQOH/gIU0KLHUwUU6GFn
         zHjX3/emlwa1Wq8KkRnLm/gAk7ZSpGZd+0D0hWyGHNdvypxPkVvYAwNkIG7hDC0jmwns
         6BwPHSONhiwDP92nugSYgG/1eVSF9OzY4SWiAe45CXyIaey6oVcoW7jc7pvnOLXgCnNK
         AR5QwzdR+o+LAOiRAiEgiegcIRa2yNMefFsu/Zjn+6Ok0C22D+4MxmqggJiAH2ljTTCy
         rHuCbdu4xAxVsXkUPgUR1XYB3+y2/ecAqd96rNfabcyRGfdJAU47FpwBR8yJMOjCJI9u
         H6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720655353; x=1721260153;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WpUWnTWcQ9yZbCFEuArGMs4Fxk919PYBB/xOGitk7xM=;
        b=OwV1dsIjZGfBe8MhrJmHMkM5NWgwgV/557GMOQNGf+JK/RGzdUVvcXUokvPRb/CBJC
         Hi1z+QLi7Y3IeSQ4I6fRArEsIjTVfSJKj8VRxxf63jycMl/Q2YG26ztzpiGazREf056k
         8kx/t1BaiQchhXZtHvx4fa7/6l7xTFCV11NzSMUvBl0GE6/A7txMrFPsp6VRgHPz/Q1G
         qQ2UNrGVEf7gPOU2j2I5UYMCUc9TaYZt37Kh8AZxX27w8m1uqCa4Lfznbw2K0v/Hiree
         U10HNcrSUZ1Ruk3UvMtd3qW/nRATytgy4Pmuwaw5VkrweJLjioSYExoZjIum67NGEJcG
         B5Kg==
X-Forwarded-Encrypted: i=1; AJvYcCWgDno07tS7rzd3yIcrmoT8wKFPg4lv7ql2EJYnTOpMF91E8PosHmf74Mhwjb+z+1bKsfjDvpVsasNAOqy9hH5oZjpS
X-Gm-Message-State: AOJu0YwrfWw5d7f0l8UcXOLOxVYOm3v25YvSpW6UYqy+f91QTby64Q85
	DqanrilRmSim+dzBIWd7YllX9MKy2HCy5zi0Gh+jbbuNJU+AQxHyUgKFhgzyNBkYXuINgYO1FG0
	SIOQuSMIeMmP4hs7trhRBVNuGUVSEENpULqAf
X-Google-Smtp-Source: AGHT+IEuslvTU7O114maCMu6s7q1QatazKYK4Au3LHFSN1TQt2fd6q24xfMVdE/dWH6oyRO5MWqPuiKjKkMbsPD4dqw=
X-Received: by 2002:ac8:7386:0:b0:447:ec33:f488 with SMTP id
 d75a77b69052e-44d0aa4788bmr1329661cf.4.1720655352838; Wed, 10 Jul 2024
 16:49:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 10 Jul 2024 16:48:36 -0700
Message-ID: <CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
To: Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Ah, I put the wrong email for Peter! I'm so sorry!

