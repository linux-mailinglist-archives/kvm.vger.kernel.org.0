Return-Path: <kvm+bounces-3706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7098073B4
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFAF01C20E19
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D303A3FE4F;
	Wed,  6 Dec 2023 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BrW55YqZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0473BD59
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 07:30:48 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cf74396cbeso33943285ad.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 07:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701876647; x=1702481447; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IAZC2v4ypuvtxPizjFSSQnZMRXpvkMqeXdIpFeNZXFU=;
        b=BrW55YqZMX2Au/uTycnICp19hhBsn731+hTYhq9CyX4la756i4t5t4XaYdcuHbjD/+
         CRf+UPIcTd3jZOJrKIDUDb+hKQlCNXPFr8oiMNtJavsohPEvqg9gIZVtYVz+6wT8JYOV
         VIS5rPZrQ6IobJmfE9AVOFpKJy332/w3sthF4SbBdNeGvnAGt7quba05FYWCkKecCUGE
         rsXCZNdKjlKAfLSWmEldh2d+tcyEI3zjjru5zwLv3ogqjw1Gfx3jmVNvkBXNnr4F3534
         YNwsXd0Z2F7kvUMAQNNxedIahvI08wanlguV9MH1Ozaac7MHvkpEemxla5ekZAnwvxx7
         Uz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701876647; x=1702481447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IAZC2v4ypuvtxPizjFSSQnZMRXpvkMqeXdIpFeNZXFU=;
        b=Lop/oirJG6KOxykLrZM5HOz25Wn5wqvMblJHptt1RgK6okr2y4SqeD50zSUilgNshu
         AKjD9cmZb1WtnbKb9pNPIxJXjEfjWUk9IrO2hfAdJGNJAJc/F0Am1AA/DoAIKhdlvVsX
         tSR5lyDlIrTNk8fKeGgTLKGP6mW6kKkGoEQpIlbF40LrSubdYr772fFcTa/d4DSKJNgm
         JUVUdHvKAaTmeuX4H2FZ4wtWy+F+C03g+mKYToaWVSjrHqj6XfnsFei+/Dv/wOJe5tjt
         V8K8sBqhaMc7OatsX2v1vSiRL5ge0i7eSpjASYI4+T/m40MevhkgFXjtV3RVNromut0s
         T9Ig==
X-Gm-Message-State: AOJu0YyAxf0MHD7bl7GjoSRNbGNgAYqkAWcUC5yw+UJWTyLnWrYASH/Y
	9mZdbpTWi9/0qryLiaKAXzsv6YbvoxY=
X-Google-Smtp-Source: AGHT+IHPAp7FETKY164sZ7rMnNRMfbZoTS7QEpWZ7Kkr5cqKmyV8OSEzsF3xjQ7jtKwDTxKq28GGWikNrao=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:3304:b0:1d0:c3e7:d4c with SMTP id
 jk4-20020a170903330400b001d0c3e70d4cmr13136plb.2.1701876647461; Wed, 06 Dec
 2023 07:30:47 -0800 (PST)
Date: Wed, 6 Dec 2023 07:30:46 -0800
In-Reply-To: <20231206032054.55070-1-likexu@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231206032054.55070-1-likexu@tencent.com>
Message-ID: <ZXCTppx4II1sbRAl@google.com>
Subject: Re: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andi Kleen <ak@linux.intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

Please don't make up random prefixes.  This should really be "x86/pmu".

From Documentation/process/maintainer-kvm-x86.rst:

Shortlog
~~~~~~~~
The preferred prefix format is ``KVM: <topic>:``, where ``<topic>`` is one of::

  - x86
  - x86/mmu
  - x86/pmu
  - x86/xen
  - selftests
  - SVM
  - nSVM
  - VMX
  - nVMX


...

New topics do occasionally pop up, but please start an on-list discussion if
you want to propose introducing a new topic, i.e. don't go rogue.

