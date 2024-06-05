Return-Path: <kvm+bounces-18979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C648FDA65
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DF751C20F77
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2878316F0C7;
	Wed,  5 Jun 2024 23:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ECi1Jp7m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8A816EC15
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629742; cv=none; b=IoeMnDR1YrYjiFWU4iTOa9UU01t/Qw2ZwdZWKdbZQvc/uxdi/1jXdouJLwORtlep1CAnj5VgKXLpFd3FDfvQncyhAyHd7/q1KwNE6cgL+HRtRuIn+8A3OdNzOmdtjEjwi92tHvu8dxqnW37xNHLExYnp0Ueg8KAQd/MMhJEl8y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629742; c=relaxed/simple;
	bh=tr+d1AsA4zLVQ1VTdutsfx/dBdiCeRGGNTvqdd1rVrU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VKhe5gt8HuHQ6k241yYFPsnIxvx25GThuvKKdADNXxUux0E3uD88Fom82TnTgJz/yxlS6suh9fS1gV1vwyEWxZkl20Wa/avNZgQ/p2qaER+Y25wekRItz5J6dFXuNCyDPmecgvC8Ajri4+LQoget6BEZUw67HptmK2ZXMnxwjYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ECi1Jp7m; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f6582eca2bso4270955ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629740; x=1718234540; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5AfeNoW3x/7faaqjnJdKUebZivim/etMhlguAr2reOA=;
        b=ECi1Jp7miEjLNhlXHu5ZifJ7eil85Qx3Ki9NczZltq/BHN8V3rzMafjT1NjBLsM4nR
         Sq0DnxzdFDZ8moJwzkfRMpu9BbVB1vwoinjBlSuTXLN4Jqx0lNOx61UW5xhRuZeIRi6q
         ijJ7P/tjNvWQT/6Pe2nXDWJ2cOFbDv+EWOs/wqXWzTbP3yTAB+lgsuZTPKEeEbCiPlB2
         PhzD2JlA8Xjth4ZKaEhNj++KDMSXTNN676iXxgBJXtQOCmtPxE6wfGVoHp0WhX8F6xmT
         BvM9Yde1V2wGvkCCEAAOV59JnTRGWqyU6mGq9LVrgkUdzF1SrTNk6gLs58YvJMOGaray
         xtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629740; x=1718234540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5AfeNoW3x/7faaqjnJdKUebZivim/etMhlguAr2reOA=;
        b=A+ZFT0QA+ckEjT/hNOfTONVyrK760aB62T6fPhwKQAARvOaS3CtUPnkl/48lK/Fiu0
         I+Hwy017zXXIbx2CG2ySMAOlek5dzy+S+2vMXc3/BRM5SnOCnQqyg7225r+5eguembOR
         GtELLtcoYRm4bawLt+AaJ64cZaq5Ll2/yC4YS8C8pbKDGypjgdTl7IZnSaz1zjAThVg4
         G7SY3IZH4yBuc6WjExPAapNjLk6fBj8RQnMhgKmdRZj4Z9yHqJeLgfdDuP8OgZ7B8QBY
         VshXDbpBTcpr2OM++179A4mc+xlEGG7qL9+eKjgd3l4W/FGNjP1x3Jq+7b+AWWU4scM8
         egIA==
X-Gm-Message-State: AOJu0YwdYKvmU1b+FJMglcZk4uVaTAFH2aW9nbYM0akcQh2ndg/o9mtf
	pRx7M8gJ4DAyX1vsDbGLmLILJj2JcfEjKPGAesE8eNkOUISM4h/9Q0FPGwE2bGP09grZN7vQb0z
	iuw==
X-Google-Smtp-Source: AGHT+IEDRuaJSNsAaEqOuzPl07WmDF9SelgC59Eu8iV28gdZtn3WvPZ48K2gVHerE+50ePC016jWnBaclMI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:188:b0:1f6:6c64:a7ac with SMTP id
 d9443c01a7336-1f6a5908e93mr524985ad.3.1717629740199; Wed, 05 Jun 2024
 16:22:20 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:20:52 -0700
In-Reply-To: <20230913235006.74172-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230913235006.74172-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <171762781627.2911336.14105226953015178413.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Fix test failures caused by CET KVM series
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Yang Weijiang <weijiang.yang@intel.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 13 Sep 2023 19:50:03 -0400, Yang Weijiang wrote:
> CET KVM series causes sereral test cases fail due to:
> 1) New introduced constraints between CR0.WP and CR4.CET bits, i.e., setting
>  CR4.CET == 1 fails if CR0.WP == 0, and setting CR0.WP == 0 fails if CR4.CET
> == 1
> 2) New introduced support of VMX_BASIC[bit56], i.e., skipping HW consistent
> check for event error code if the bit is set.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/3] x86: VMX: Exclude CR4.CET from the test_vmxon_bad_cr()
      https://github.com/kvm-x86/kvm-unit-tests/commit/b518eb1397f4
[2/3] x86: VMX: Rename union vmx_basic and related global variable
      https://github.com/kvm-x86/kvm-unit-tests/commit/0903962d63f5
[3/3] x86:VMX: Introduce new vmx_basic MSR feature bit for vmx tests
      https://github.com/kvm-x86/kvm-unit-tests/commit/9b27e5d66846

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

