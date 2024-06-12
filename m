Return-Path: <kvm+bounces-19375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F7C0904843
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:20:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA7651C22E58
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904C34A12;
	Wed, 12 Jun 2024 01:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rfgMf/Rx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862A810795
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 01:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718155174; cv=none; b=lPdXQ8j/HkwXj8DvO1d1+LGFuSE8cEwmoprRJNr3IW3ywQ6lOqd2p45okXDmDkX4/KvGaCYtFISzFXwBJEXuhEo6DjjnLWln++3xeVaGYvi5s+RMPmw69pSdbTHNrxs4kh6A+Uu9r6fvUZbGNsQWEcBK0IC0opdi8DHKJFqpxzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718155174; c=relaxed/simple;
	bh=01On2/EVecp/FpY2MPxFsS9f5SUR4JP7vCiq48Sf3QM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dqbMExjI3Ou3RnEaN38NwUShK5F0K+94Qf7Y0yE/MJYyAl/0SsuPHfZE/2SvJvOCJVZ4UfVS9tZYZryKQ3yspmVzrZdAuGY373B1r9fdJ42z3NHK+RjAooE31cuGkh72lQQjtNrK3TqHj0Ni9yjptZN9aHJK88shDr0LHwumNW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rfgMf/Rx; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f6ea6afba0so2718565ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 18:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718155173; x=1718759973; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dpt7pOC6j5Ad67mZsPPp978WnRTmoVaVrsPf3/HpPSQ=;
        b=rfgMf/Rxk0Fw+ii+N0a/TGkL9avtYFr0oawmOfQAImxaVv6qHbuaMCEUqC1HQI9p1k
         /YhsxwW8Id/mCjs7SoYyRBBYtYLeboZYGhYFn+WUTM5hPlhL6LT2eVfKvpMOpHMhMS+5
         Kam1lErtWTWs6wwn0SaNtjnoxoltjE4fqbLA46ADO2HlQPdtuQ8S/BtiuvK7MItZGznT
         5EBHcPa1b2uQD95JNlv6PBFft5d3Wqkt1vhVl8Rj989pBQkcwIfjy84fB/y20akMSS7Y
         ubgtwnPWqJG6L2+3HiYbSAmp4SmQXCjBQIiPjbvRmApCpNQQp9bmNNM1oJTkCvyg5pxo
         TeTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718155173; x=1718759973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dpt7pOC6j5Ad67mZsPPp978WnRTmoVaVrsPf3/HpPSQ=;
        b=vCdM/Bys/T/MgY846nBDOcC2+Um99iJbz9dudUhg77mooAMOFg/PlIrrJeI/77UO9I
         h8D0OfKjvjupNni+6y+nG/2VlcLKIO/645vPshtXhYmVZIPamweztUZUn6Ndfwqm1tWl
         sblIrw4BXYjjJSIXwM7jSKkFQf/qiQBUWxsgdsShZiPlKCjGAdWxKunITyawDdLeJUaH
         3hUGa0s6GXbtpk+Rv72sJ3dtA/Z2jvEOm8iZ68fH/ES8+i6CjYDUssOmEvFpQiwCf+Ak
         zMYytbf7VFVCpbp6BEU4ZUrmw1ZrBhSLccpBHvsVIHMExwtCjQ8snGDIFAspO+ySo6oX
         i0xQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfzo0bV4M0i21vV4ABxi+cu6MGB8cJ9g9MDKLRFoviBMglqr3kciu7v/P62CwXh9VFrkwYCWnNCcdKjlMBKL9rzg+6
X-Gm-Message-State: AOJu0YzXzPZijextooJh2QL02XEnqDBcI+U1tAL0SpWSmaWrbF995y5X
	f4lhZZ+cESB2si/wmcIXMpwzd5eSQxStvHdp67RsKY3ICjrKdhf6jqEbpfxiwkev1PkJSJ+qFqN
	VgQ==
X-Google-Smtp-Source: AGHT+IFacOJgoQzjKofsQnSKGWaTN0dSvkvFf7Msi15ZsbtxDiubwj9jgMosm5e8+6Xxaijsg5R5zHNcy8I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e882:b0:1f7:1046:d68e with SMTP id
 d9443c01a7336-1f83ad55c76mr214055ad.2.1718155172838; Tue, 11 Jun 2024
 18:19:32 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:18:32 -0700
In-Reply-To: <20240506075025.2251131-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506075025.2251131-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <171803734657.3359701.7956342663823858498.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Remove unused declaration of vmx_request_immediate_exit()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, isaku.yamahata@intel.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"

On Mon, 06 May 2024 15:50:25 +0800, Binbin Wu wrote:
> After commit 0ec3d6d1f169 "KVM: x86: Fully defer to vendor code to decide
> how to force immediate exit", vmx_request_immediate_exit() was removed.
> Commit 5f18c642ff7e "KVM: VMX: Move out vmx_x86_ops to 'main.c' to dispatch
> VMX and TDX" added its declaration by accident.  Remove it.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: VMX: Remove unused declaration of vmx_request_immediate_exit()
      https://github.com/kvm-x86/linux/commit/d5989a3533fc

--
https://github.com/kvm-x86/linux/tree/next

