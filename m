Return-Path: <kvm+bounces-14811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BA48A7299
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC736B20C65
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14799133987;
	Tue, 16 Apr 2024 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mA+oGCmb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01D81332A7
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713289497; cv=none; b=Xkz/MgWwwcNdVNKNqxHL2uAZtogAs3BWI5qvhc+BGLvyFonwZ2Wk5Rk5+0q94rHzwEsH7z1BZtWNmkQKdEworJHVPmoUt/nFA2TTGSY+J8I/paZCwGbj7cMJ8CrkKie3zyDm8h2r8P36mdRl3vcQTkfdFe8o0R2HdvaaDFOppJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713289497; c=relaxed/simple;
	bh=R0mb94B7cthOnnjsNOwSCFsFReubqgbTbWu0ZBeP1fw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jwgKeBxjkgI99jP25h7Lx0FTSJNGsnDscOjZoEzC7Dpswnd46MvVJySl4LkFdfiAjU1ZcY6vjMQtK+dfC815z0xCMSOCgsXUZEWx2eligHX9k9e6dJKalmIigHpv1v+acoxmFtSQ21Bj8zTSh05w5aW1Ug1Jzlm3suLzJ5tubH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mA+oGCmb; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso8869005276.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 10:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713289495; x=1713894295; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R0mb94B7cthOnnjsNOwSCFsFReubqgbTbWu0ZBeP1fw=;
        b=mA+oGCmb2u+NXC5QCIaQh+DobkMjvX/t5mKwLJ3eOfm+yWuLoZFyojmc0tYzy/L1xj
         zuDr9+CicQJ9/af+KQ/JYmxjkdrjSHyS5RGdk1dWmCeetH61FuotqOiUx6qoyjKSYlCU
         WAHPfuQhPKcVX9qb42jt0iCTzUoYZxE8gkfrYlHZT8JiDVNn71M0BCqK0FlM8Ea1022/
         OtwoyObx3dBOlnJdFzu0vsDvIoxcVKIQIeaHqiFroAODMzBj7EoQO38P5EjI09aroyAZ
         /77+MQw+UtFo/ZhpMY6WWb9FvDwCFsWu8Q4tDkWsS6lKQ8FglLair9rxNTRF14+Umypk
         m8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713289495; x=1713894295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R0mb94B7cthOnnjsNOwSCFsFReubqgbTbWu0ZBeP1fw=;
        b=bOJ73YjNo9eg/m/yFPNW3MJBbp7M9YjECl5FP654ccKWOlf0WwNygl94E0yGTNql2+
         NfYwE0oZEMqpVbacBT3SAb2HI5IjyCP4q8uZTghUaM8q3CWYu/6KDgT6dISrhFOFY34M
         K+shNb9y/Pn3oRljMOwrKQt74mmWhzCNR9E5dLBvqzK2PWCy/VvKz9yedjjLxhLcLYg/
         +0H+qKEJU9xaN2NWeFKWPr5g3lFCl0YmNyhDrdI5Rm/KbODsQeAM6ydkcn/WsTUSz2hN
         chbrORMyS2Xfa5e9y3xtreyIYEcjKgrAzTdkSoLGk/912kkq1mnICTy7GsqaAB/5wE8U
         EaTA==
X-Forwarded-Encrypted: i=1; AJvYcCWokxNOtp6AOJtxDHH5dpcURhdwXPzzc3AAIcxelz0oJwX/8mVy6de4904Ah++tiyuoccayoY4ioevTwBT36xM8N0vB
X-Gm-Message-State: AOJu0YxptBLZ1w9LrUUIVIzN+xAc5RF2Sesnde5p5QJ6ELs6i/QNmocR
	TFPU6ejvNzYjU4+itVrJBnJS8aSK2s0dpMWbsWM7gmF3mK4BeoL4k8Yu3BQZY1/eDA2XvhAPohc
	Fzw==
X-Google-Smtp-Source: AGHT+IHMvSQwoWeCpEgU2f3wZA2cAIExu8rOKibJAWVtKwIagoDwOg8Hjby7qlXXFsu/mILbyEgftN7G1Vs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:992:0:b0:dcb:e982:4e40 with SMTP id
 c18-20020a5b0992000000b00dcbe9824e40mr3838391ybq.12.1713289494924; Tue, 16
 Apr 2024 10:44:54 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:44:53 -0700
In-Reply-To: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
Message-ID: <Zh65Fbgdcyl6tiGr@google.com>
Subject: Re: [PATCH v10 0/3] Per-vCPU dirty quota-based throttling
From: Sean Christopherson <seanjc@google.com>
To: Shivam Kumar <shivam.kumar1@nutanix.com>
Cc: maz@kernel.org, pbonzini@redhat.com, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, aravind.retnakaran@nutanix.com, 
	carl.waldspurger@nutanix.com, david.vrabel@nutanix.com, david@redhat.com, 
	will@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 21, 2024, Shivam Kumar wrote:
> v1:
> https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@xxxxxxxxxxx/
> v2: https://lore.kernel.org/kvm/Ydx2EW6U3fpJoJF0@xxxxxxxxxx/T/
> v3: https://lore.kernel.org/kvm/YkT1kzWidaRFdQQh@xxxxxxxxxx/T/
> v4:
> https://lore.kernel.org/all/20220521202937.184189-1-shivam.kumar1@xxxxxxxxxxx/
> v5: https://lore.kernel.org/all/202209130532.2BJwW65L-lkp@xxxxxxxxx/T/
> v6:
> https://lore.kernel.org/all/20220915101049.187325-1-shivam.kumar1@xxxxxxxxxxx/
> v7:
> https://lore.kernel.org/all/a64d9818-c68d-1e33-5783-414e9a9bdbd1@xxxxxxxxxxx/t/

These links are all busted, which was actually quite annoying because I wanted to
go back and look at Marc's input.

> v8:
> https://lore.kernel.org/all/20230225204758.17726-1-shivam.kumar1@nutanix.com/
> v9:
> https://lore.kernel.org/kvm/20230504144328.139462-1-shivam.kumar1@nutanix.com/

