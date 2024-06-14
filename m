Return-Path: <kvm+bounces-19721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B836F909381
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C63791C22783
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF1A1A38EF;
	Fri, 14 Jun 2024 20:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MOJoi9Ws"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2781F946
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718397393; cv=none; b=IBFxB/UT61GvyC283mBodJrem9u4sYZx+4DbxF3IkU4x1wDnGnswQ7i5Hhyr3Gmfl2osto6gIVnwsjvpv9KEv3ZN4KYHmAcPsdPXndLNb7H7aQuc1HpiZlh93AqmBZqYLHH28vCWVXoe5KTMO1DFTIIknus89lAA1LU9OW2sGnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718397393; c=relaxed/simple;
	bh=CU7xMDSKoOqQH2eJfiDd+hpi9P1RW19rWaxgyBdPGT4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KTj/bsapCMYNdzfO7bb4/Q5xtelcNWf8cY47EmkuSOPOYR3IMERXSMHb7L4OqKUcCbIEwv9K4iW7twQ0z13QJGU3OyE2mOD3aRFc4RkEK4WWxNkcsLaoXqblFc20qW9ggAl6X9Z21jvmbhuzVB3TmsYkh+cvSSL976H9Lq07Djk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MOJoi9Ws; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-632cdb75d5aso13617767b3.0
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 13:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718397390; x=1719002190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EarhHYqHLw4rRLHnmmYNAj6On7awbkYpFByE7/7MBAI=;
        b=MOJoi9Wsh9xT3Ss4HI27RbNvoOEjHTxc6wQ52wkRlYJ8KjXta/UzqWefBPgKG3xqCR
         gBS3BOjqmizuSRHEBvbgV37R6MHDFAice4ZFUUEdQ9H2c5gV3VT7IY05ZDNLFwmzJDaN
         pLmo/Y5nFIouazRqX67IaGIFfQZWKVK5ALz3u5e6ckaMiHL1xHIviIl3DNlDCMD3xd0E
         w//8vb8KWh4WIa8zOuXQEmJLz5HNynOnrdut3rELeuI3JgW6b5gO0FXdAitKKEWyrzW3
         8AvLQ4CQXbjIip6G8ZBq7y4PPdGqUV1KO2ONuiHRPYfYt5gzVZaoi7emtC2K3DWz/nA+
         5vFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718397390; x=1719002190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EarhHYqHLw4rRLHnmmYNAj6On7awbkYpFByE7/7MBAI=;
        b=W6Tp1WuvRJawFX2OQDxut74Dw8H0XVzif1ysUJKWDWrnUaBIgiAe7Q8YBO2yR12bDs
         MJn65AKJ1oDqAl2o6HX2RBXwDRz0Aa8gzYBQU31j5E1WhjPt94ajf2RYeu1FyrFSLuYv
         Xj9Y/aWKeqkyimGfu2J0HIMdWFR8WxXJEj738HAzkR7tZ3YYOaUOS/rTx9k5xfLDrweA
         fo+jyAgPrEC5V8H0jie+C1LpJB9rNWaGPQg3XOdRoatYr2lmhEZkvnx/PnJ3dTVrufEH
         SEIGQAiUaK8NksDuOfuj/ga0ZgT8U81A8688Zsj2m2PA/YzOvtR/70HCvnZc8XWsjsmA
         /IIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3Zl35liagtNiCh/vVafBj/or5a2V8YiKaMQpEPF05PlYuMP7UX+/d5ubl4TgVhkIddcTfs03O5my60SetI13pU+Di
X-Gm-Message-State: AOJu0YyerIAZGNvKRO/g6egwzC4dhcl1+1YNLZ0a+/tQEML+d2p/Wwkb
	t9g6heMLPPGvXOLpPWU47FEXglzxYuh2LfBU4vu0f6SVYu2pW4Oe58kXnSTvSUKLMBNFgoVCW/T
	evA==
X-Google-Smtp-Source: AGHT+IHUixvgKxJp4GOOWmnZl+Rl3r+JtVPe24pTqqz1meq9WEOuM+QSzAgipem4yK2UHpOAupJPBCPkK5M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d81:b0:62c:f01d:3470 with SMTP id
 00721157ae682-632248103f6mr9051487b3.6.1718397390025; Fri, 14 Jun 2024
 13:36:30 -0700 (PDT)
Date: Fri, 14 Jun 2024 13:36:28 -0700
In-Reply-To: <e45bffb8-d67c-4f95-a2ea-4097d03348f3@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240612215415.3450952-1-minipli@grsecurity.net>
 <20240612215415.3450952-4-minipli@grsecurity.net> <ZmxxZo0Y-UBb9Ztq@google.com>
 <e45bffb8-d67c-4f95-a2ea-4097d03348f3@grsecurity.net>
Message-ID: <ZmypzAkNLr3b-Xps@google.com>
Subject: Re: [PATCH v2 3/4] KVM: Limit check IDs for KVM_SET_BOOT_CPU_ID
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 14, 2024, Mathias Krause wrote:
> On 14.06.24 18:35, Sean Christopherson wrote:
> However, this still doesn't prevent creating VMs that have no BSP as the
> actual vCPU ID assignment only happens later, when vCPUs are created.
> 
> But, I guess, that's no real issue. If userland insists on not having a
> BSP, so be it.

"struct kvm" is zero-allocated, so the BSP will default to vCPU0.  I wouldn't be
at all surprised if VMMs rely on that (after looking, that does appear to be the
case for our VMM).

