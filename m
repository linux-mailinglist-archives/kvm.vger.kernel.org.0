Return-Path: <kvm+bounces-26924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC883979105
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 15:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87F7B281E11
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 13:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ACD91CF7B7;
	Sat, 14 Sep 2024 13:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V0nmaUBl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9EF1993B0
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726320926; cv=none; b=cm1JTVmteSGouVm7RaosY27Rr5K7JRthok5rdl894rafu23bIaaoLQw09NtiTH8BjA8iqOVUUB9Z+lzJXGWR9fR6Vdmnyxnv1yGXMLm6GaOSMHPuActlBcbepOTmJtvwTIwFcZAa0duhVO5TGra8B1/PFbZgOd7WAP7EwaiUDtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726320926; c=relaxed/simple;
	bh=iL2sP6qDwiloz5Ja9a59YqgaEE/yyEL18B1Y0Gzn43I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L0iS5DKmd4dX+1CrkxSq+7/N4eglmN6GYWHnP8i+35FHE6lCPiY9gWHmGbp0L8GcIWv2YX/DhB2xISepJ5wgMZcYaQyILI0GBhhQ1ufO0wwQgQOtfPGyDa8QVA4lbeVfV05TC9/QBiXq8JAbqIaNryvHnj6/YxjTKPR+QBKiBow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V0nmaUBl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726320924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ld0UP3PRmivVuoJrwDe2lnCU/nD5gTvPPRMst7Yu8i8=;
	b=V0nmaUBl/NYz1czGPInBYX2A4kCWeAoj/P5nigDMI2k/5e2OcxWuNFTdATJr8kJBsFHKqy
	Dg05Wpi/uXVZmBwgfEUVAB4wT/OouRroS2DHVytJZEwofDailsYKLeZTFy+rD+7u1fhxmO
	Nnizvz4/ZSmVvzyWHL9zldmzMWcdZx4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-uXglgwx3M_ayZyU_tGT_bg-1; Sat, 14 Sep 2024 09:35:22 -0400
X-MC-Unique: uXglgwx3M_ayZyU_tGT_bg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42ca8037d9aso12515175e9.3
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 06:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726320921; x=1726925721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ld0UP3PRmivVuoJrwDe2lnCU/nD5gTvPPRMst7Yu8i8=;
        b=AtEoRyTEcrbPF6vlF57WuZ8copmRWqQDEaYpTziDR9+Uw3yiNA8NiLsWZz6j4alSVI
         444kmMiA2BJpgVtfCBetzpME4Fp+L+QFJAsPvltD/1EsrL5UJSrxqqruhSIrieornYuV
         LCMKANOAOuY/ffXM+66vFgc6JVRl0BzVzdQjuDrH23jE7j2fHdabdBTBzqk0DcCJqHUo
         MI3b55sPGqeiotWdh8hyQj0lMAJvx5lIkSsP6zMmu6ilqADRfQ4Z/Z6mKlxo6FkREO+g
         GaTp4XUUKEv2HONnhEwFFcGAzfBDNU+Vt600rhadhVEkAojS6LLKQ8kpBdxwYwkkVBoG
         WuEw==
X-Gm-Message-State: AOJu0Ywa8XqpEsGZppP4n81ALNdOg5GVc/P14nT0dhqW9zGyi48m8aaM
	7MSwPYwOoSTJq+Cd5L8b3RnYbAjMeK2/+ZhK47Ypn3mMU+vxhVCKFie+NC+vdlnKgfcr2l/M5HX
	RL+cCJ+F9Ov6Mrz+o0OGjkO6N07tPQcSIreOUHG2zT6WAfh4pgABCsq2X0jMAl+A9jxyb4wgSr2
	sPgAgS5k1HDIaBuOmaLnouzFU3
X-Received: by 2002:a05:600c:1d05:b0:42c:c08e:c315 with SMTP id 5b1f17b1804b1-42d90827159mr52190435e9.16.1726320921116;
        Sat, 14 Sep 2024 06:35:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZa1HkPyf/nXwY2gWJhrKbQjj1W29fkvwKM7sq40Mkj6VbUZM6phKBtQENBljHgDCxGxGqupkWYE2snthe8oA=
X-Received: by 2002:a05:600c:1d05:b0:42c:c08e:c315 with SMTP id
 5b1f17b1804b1-42d90827159mr52190275e9.16.1726320920644; Sat, 14 Sep 2024
 06:35:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com> <20240914011348.2558415-2-seanjc@google.com>
In-Reply-To: <20240914011348.2558415-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 14 Sep 2024 15:35:09 +0200
Message-ID: <CABgObfZh0PX5CMa-Jbny82GvSS9oV6uPxYugoi0n7Vrv=yj5Rg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Common changes for 6.12
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 14, 2024 at 3:14=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Fix a long-standing goof in the coalesced IO code, and a lurking bug in
> kvm_clear_guest().
>
> The following changes since commit 47ac09b91befbb6a235ab620c32af719f82083=
99:
>
>   Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.12
>
> for you to fetch changes up to 025dde582bbf31e7618f9283594ef5e2408e384b:
>
>   KVM: Harden guest memory APIs against out-of-bounds accesses (2024-09-0=
9 20:15:34 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVK generic changes for 6.12:
>
>  - Fix a bug that results in KVM prematurely exiting to userspace for coa=
lesced
>    MMIO/PIO in many cases, clean up the related code, and add a testcase.
>
>  - Fix a bug in kvm_clear_guest() where it would trigger a buffer overflo=
w _if_
>    the gpa+len crosses a page boundary, which thankfully is guaranteed to=
 not
>    happen in the current code base.  Add WARNs in more helpers that read/=
write
>    guest memory to detect similar bugs.
>
> ----------------------------------------------------------------
> Ilias Stamatis (1):
>       KVM: Fix coalesced_mmio_has_room() to avoid premature userspace exi=
t
>
> Sean Christopherson (4):
>       KVM: selftests: Add a test for coalesced MMIO (and PIO on x86)
>       KVM: Clean up coalesced MMIO ring full check
>       KVM: Write the per-page "segment" when clearing (part of) a guest p=
age
>       KVM: Harden guest memory APIs against out-of-bounds accesses
>
>  tools/testing/selftests/kvm/Makefile            |   3 +
>  tools/testing/selftests/kvm/coalesced_io_test.c | 236 ++++++++++++++++++=
++++++
>  tools/testing/selftests/kvm/include/kvm_util.h  |  26 +++
>  virt/kvm/coalesced_mmio.c                       |  31 +---
>  virt/kvm/kvm_main.c                             |  11 +-
>  5 files changed, 283 insertions(+), 24 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/coalesced_io_test.c
>


