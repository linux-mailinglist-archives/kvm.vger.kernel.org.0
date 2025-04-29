Return-Path: <kvm+bounces-44810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDD8AAA11F1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 18:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8483E4A6915
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A03D24EAB2;
	Tue, 29 Apr 2025 16:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xs6mboXV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BB622AE7C
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 16:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945229; cv=none; b=P2UpkcyBLJLhYE8+OWbG01Mpm0M6ZolknQNSuSj2F8ymDUDm2w2M4Xea78toF037l8PxOZ0dKII70CwdoOWu8lwByP1aO6jJxy9Dh9+dNpG2/BTUwajkporZTF1jE5C5U+rYBNy8ewVHWDNqul21CO3qTacpP+O3r+gekrU/mGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945229; c=relaxed/simple;
	bh=qlFvxx4vXvnODB8SoWH3xuEvm1Y153RCIqWfvQ/U/y4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FNCfKUxC4sgOEDeEM+6jNVx0Bm4+3QciXdhW6GAN3BA0Fg/VBt74niGCL6XQGrXyX/3KGlklqmGCSbj9mzlvD5LLFWe44uhaOxhOUuCSPNp46BO1WkZF/R+idFhIm83qgxlSG1murIOjERUrQ2do0zBqnfePhrJQTJW+xYaYcMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xs6mboXV; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-224364f2492so44636765ad.3
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 09:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745945227; x=1746550027; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wW/3FZ3J3LaAvhXz6pT2crJdAdy3SR7TNiF8mMPwO1Q=;
        b=xs6mboXVlGD+BH2zve2YBAbk4KBGyCaNrvAwyNBDcfljAoG+r7IYuWims9T8x5P/dr
         Vm04r0EoeA1t3mfpLESBzm1qQtgNhrgsruiZhAcoPc51qD3VLqPrMVLhR9ahc0LYWi34
         8CWRJoR3ZNrBZPCsZHwkIrQh9C+PKhqcVbqeGkCudaWiouwPyZ3bjzDsEh45YgtjIB8Y
         F/CBN8n4UPXDLcorHhw3KHlZHcDjFHE8jg2d+J6WkBOmTdGIkNy+PPj26RqZWpBpvXxU
         bFNgkfCZ6WUUeCwh/JRSciT9j90ufh9ltvGR/zoSraID7tWarTKNq0hC0YbHHYpM0Mbo
         z9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745945227; x=1746550027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wW/3FZ3J3LaAvhXz6pT2crJdAdy3SR7TNiF8mMPwO1Q=;
        b=xG4g5Xpl84697g/G5I1cskUIZz9Hu6aSJXSqT4ixz0TjXXvQEQYTtxxyTWw8f4GNXW
         F80w2Ybii7NXmx61ZK6pM8EMyGgiHhWlzXxik4xEPAUjT/2duAtH35++3QwQFrH7bUDT
         RAkFJBHg4EgF5MHO06456JlabVXTlAED5eOmuFzeHxuyZsDjc+nG20mVKXO6d5fnyLhT
         PwYMtrFOqmbgkkioR3R/hDVn1r+srNQxCCBBdR+CM/N2x2il4RylTkrimTEUqEsNgh+1
         tqsBlTnyC22Jel15Pikbak0O6AsyVjb5ERsvcypPKBCf7XysZeqVIldxDJaaSDPM/EJt
         NzBQ==
X-Gm-Message-State: AOJu0YwZfqYw5FFfdChhJMkhB+mpAn33bYQ1BTYzd0CNT5B34snnDbNo
	jS41jSv+2+20bYSaTbdhfX3PZiu0rg3a5pmFDAMmHGSKOR7MJB5ECilEXv2knW1XTMzQSBvfeWt
	zww==
X-Google-Smtp-Source: AGHT+IGYwDoIc1CopaCdHjCVbP+lhIKe9ljwxlXcpMm19QspT63vXrrMoXbX4A+F0QMnlUB0WIYfJez9VZY=
X-Received: from pllo4.prod.google.com ([2002:a17:902:7784:b0:223:4788:2e83])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1249:b0:216:794f:6d7d
 with SMTP id d9443c01a7336-22df359328dmr941965ad.48.1745945227521; Tue, 29
 Apr 2025 09:47:07 -0700 (PDT)
Date: Tue, 29 Apr 2025 09:47:06 -0700
In-Reply-To: <diqzplgvxbsm.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250402002936.960678-1-seanjc@google.com> <diqzplgvxbsm.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aBECik9V2uAlFKGU@google.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2025.04.02 - No Topic
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, roypat@amazon.co.uk, 
	kalyazin@amazon.com, Fuad Tabba <tabba@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, david@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 29, 2025, Ackerley Tng wrote:
> 
> Would like to add an agenda item for 2025-04-30's PUCK meeting: KVM
> memory attributes vs guest_memfd shareability.

Does next week work for you?  I.e. May 7th.  I won't be able to make tomorrow's
PUCK (about to send a cancelation mail).

> guest_memfd tracks shareability to determine whether a page can be
> faulted by the host into userspace.
> 
> pKVM does not use kvm->mem_attr_array for tracking private/shared status
> of a page, and for Coco VMs like TDX, there seems to be duplicate
> tracking of private/shared status in guest_memfd's shareability and in
> KVM's memory attributes.
> 
> I would like to discuss a proposal for shared/private conversions to be
> performed through a guest_memfd (not KVM) ioctl instead of using
> KVM_SET_MEMORY_ATTRIBUTES, where Coco VMs using guest_memfd for both
> shared and private memory can be able to (with some other changes around
> KVM memory attributes) skip tracking private/shared in KVM's memory
> attributes.

Has the proposal been posted on-list anywhere?  I haven't been following the
guest_memfd threads very closely (understatement).

