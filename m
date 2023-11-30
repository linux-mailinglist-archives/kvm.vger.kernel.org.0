Return-Path: <kvm+bounces-2831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE097FE658
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 02:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77AB1282327
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 01:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5443279EC;
	Thu, 30 Nov 2023 01:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xm3gWY18"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E3F1A3
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:44:18 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5c5daf2baccso6201587b3.3
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701308658; x=1701913458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gMxLUnirB9hlBqYifVKy9Kl1l6BWOFWxKcWyIczHOPQ=;
        b=Xm3gWY18Q8gpN1ZnDnYiEKqDPyrNMMgw3AVG48JYnOEDUQD2hmSws0V6yAu5cTWLSR
         ZegNu8i92pzD9TGFPvxJb84gk2bxp5hLNfyfbqHSDqJ8wEVdfHekO9pPstqx+aXPTAjt
         khgo7Ynyv/IaJU40dIz7pluESgUbW1ZFMxBqZ8+hJIvttg4Y0LoPfzOf4xcl2zIA0/Hc
         3hoNuxV85lRlQNxVCZ73wz3gtiqCTwkQaw5KhaWEV/3VcphIipItEreMSYs/AdxvEMyN
         Yt18ipquE7eupqBRyRCHyyyPGO2lran5XVrE8s7ruZFgaxMZQrllWnFMLWLlZJwb6N5z
         eChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701308658; x=1701913458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gMxLUnirB9hlBqYifVKy9Kl1l6BWOFWxKcWyIczHOPQ=;
        b=Ef1bYzcCeGdBvq+pzmPh25L1J5VpPrPj1UIkem6y/OvHt206SVSr+SwXjRNgPE5dQT
         B4Gz1obUgbpi9vtb8owRT5HTU5FscdH/1T/9npTbIlHZT9S67uybkk9Uyac62zld/eVU
         YHshaogbaoxFP6WFFVNGLdvaBt5BB0yfNbPit8KGVHdTdzL4D5pp1LPi8la40KyX9H0p
         uRQcJk5NS17Vj/i1gXHhIvfVOa1OeF0+7N9Cz7TzA59zpuEmGh5ymvAl00e6+r+AbKBS
         PtRXu5YqfgESRkCThJUbQOGu7jPJaBbkEAqoiFdthii8CZR8C9hf/GQLf36ZERo2tQdN
         iemQ==
X-Gm-Message-State: AOJu0YwI2Bb+v2LkSvr2Rd+MVbsdXNrCP2SoSgV1hZIJuJiLakpoXUxN
	VNxmZE+qgfK6rqqL0WzsXK5SE6pRVMg=
X-Google-Smtp-Source: AGHT+IH0VbxQs9f0utAeUg0aQHLKSIYznR55H8CyelgDvZ+FQgLUjl/M/snSfGWBq/yvxlw5sJ4ZnWjJu/U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3209:b0:5cc:234f:1860 with SMTP id
 ff9-20020a05690c320900b005cc234f1860mr577492ywb.3.1701308657947; Wed, 29 Nov
 2023 17:44:17 -0800 (PST)
Date: Wed, 29 Nov 2023 17:44:08 -0800
In-Reply-To: <20231018192325.1893896-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231018192325.1893896-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <170129829387.532906.5566625091888881968.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks
 iff HYPERV!=n
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 18 Oct 2023 12:23:25 -0700, Sean Christopherson wrote:
> Declare the kvm_x86_ops hooks used to wire up paravirt TLB flushes when
> running under Hyper-V if and only if CONFIG_HYPERV!=n.  Wrapping yet more
> code with IS_ENABLED(CONFIG_HYPERV) eliminates a handful of conditional
> branches, and makes it super obvious why the hooks *might* be valid.
> 
> 

Applied to kvm-x86 hyperv, thanks!

[1/1] KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks iff HYPERV!=n
      https://github.com/kvm-x86/linux/commit/0277022a77a5

--
https://github.com/kvm-x86/linux/tree/next

