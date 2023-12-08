Return-Path: <kvm+bounces-3944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F7380ABF8
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:21:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 339921F2122C
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3CD47A5E;
	Fri,  8 Dec 2023 18:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AMDsXDON"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DA690
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 10:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702059685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nLSlZUtE+vJwKxCXyAw/ZXA+/0tHeruZDXjXe1PSA+M=;
	b=AMDsXDONt7TI2+1pc2NHsdoIDDue+oU9sG8Igex3ImnWYFxZBk5y6ptHtwE+x0qH8PTSsz
	VOgkTZexKLP8sgrN1SbCeEZNZp20kNJsV1i/VJdf6R923cBTfJfq+W3yGm9k8Hw5/klRUD
	qsKiXlTKyQmP/otO7pfCiXMGY9pRQ/o=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-YF9lLumYNo2kqbemvGF3jw-1; Fri, 08 Dec 2023 13:21:22 -0500
X-MC-Unique: YF9lLumYNo2kqbemvGF3jw-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1faa81282d1so4634485fac.3
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 10:21:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702059681; x=1702664481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nLSlZUtE+vJwKxCXyAw/ZXA+/0tHeruZDXjXe1PSA+M=;
        b=gZW4ulQA2ENtDO+xqiu4JXy+CApVy7jS3nyMMeRU9yoRojjhS31Arp9DYmCcpp2Xly
         DPtoagMS23apQFmCrjsK29FxgfdbzJ6EGPveMvS+a13dfS3dpAV7WYsSMvLy2ERQNP8J
         eT7pgwyuYo8MmvOEBxCgGT2hg41RVHawnIAaYShfLXT+dsWM4DoS322+1drZWseylr1A
         Nu3vxV4KrAV2s/UM9lu0n+gtGw/rmC+HFtUyNRJT/RCQDixokcIVx5s7lg1CY6ikKcZL
         GZItuscga+trqTCwfENqnqJrDqO9rQs8pLhRuBTGjapupXyjktea48J3KxlS1cpWPXo3
         xdxA==
X-Gm-Message-State: AOJu0YzK3hUadR8ZagCH/ikcXfdXBk2tjqR5o4iNHQXqFWxOlpwCdYtX
	Q+Lvmvh/mbJ+CmQBBXXMLw15GKk9dtlg3o8ZE2hqisp/QY4sQ4OZC0u2YWKWr3yPRU/d7c4BDSY
	2Cq9jeXUqkAe9RxT1TWPfD3YB9yJRbNwU5Hw2YTM=
X-Received: by 2002:a05:6870:71d6:b0:1fb:34a7:ebbd with SMTP id p22-20020a05687071d600b001fb34a7ebbdmr566703oag.1.1702059681263;
        Fri, 08 Dec 2023 10:21:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbZzm5wC8wbpVxKq67MC5ECzNPzJFHkvrILIXuTMUoBGMt7D79VxJBXO0NVoVtV46/R206KUxojGA6kEUpH2c=
X-Received: by 2002:a05:6870:71d6:b0:1fb:34a7:ebbd with SMTP id
 p22-20020a05687071d600b001fb34a7ebbdmr566694oag.1.1702059681015; Fri, 08 Dec
 2023 10:21:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208021708.1707327-1-seanjc@google.com>
In-Reply-To: <20231208021708.1707327-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 8 Dec 2023 19:21:08 +0100
Message-ID: <CABgObfbgs0z0Pe37T=TJprEkq0dZngSxKKKVnM74xHg6eFGegg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: selftests: Fixes and cleanups for 6.7-rcN
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 3:17=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Please pull selftests fixes/cleanups for 6.7.  The big change is adding
> __printf() annotation to the guest printf/assert helpers, which is waaay
> better than me playing whack-a-mole when tests fail (I'm still laughing
> at myself for not realizing what that annotation does).
>
> The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b=
2f:
>
>   selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:5=
8:25 -0500)

This would be a 6.8 change though.

I singled out "KVM: selftests: Actually print out magic token in NX
hugepages skip message" and "KVM: selftests: add -MP to CFLAGS" and
pulled the rest into kvm/next, which means we'll have a couple dup
commits but nothing too bad.

Paolo

>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.7-rcN
>
> for you to fetch changes up to 1b2658e4c709135fe1910423d3216632f641baf9:
>
>   KVM: selftests: Annotate guest ucall, printf, and assert helpers with _=
_printf() (2023-12-01 08:15:41 -0800)
>
> ----------------------------------------------------------------
> KVM selftests fixes for 6.7-rcN:
>
>  - Fix an annoying goof where the NX hugepage test prints out garbage
>    instead of the magic token needed to run the text.
>
>  - Fix build errors when a header is delete/moved due to a missing flag
>    in the Makefile.
>
>  - Detect if KVM bugged/killed a selftest's VM and print out a helpful
>    message instead of complaining that a random ioctl() failed.
>
>  - Annotate the guest printf/assert helpers with __printf(), and fix the
>    various bugs that were lurking due to lack of said annotation.
>
> ----------------------------------------------------------------
> David Woodhouse (1):
>       KVM: selftests: add -MP to CFLAGS
>
> Sean Christopherson (7):
>       KVM: selftests: Drop the single-underscore ioctl() helpers
>       KVM: selftests: Add logic to detect if ioctl() failed because VM wa=
s killed
>       KVM: selftests: Remove x86's so called "MMIO warning" test
>       KVM: selftests: Fix MWAIT error message when guest assertion fails
>       KVM: selftests: Fix benign %llx vs. %lx issues in guest asserts
>       KVM: selftests: Fix broken assert messages in Hyper-V features test
>       KVM: selftests: Annotate guest ucall, printf, and assert helpers wi=
th __printf()
>
> angquan yu (1):
>       KVM: selftests: Actually print out magic token in NX hugepages skip=
 message
>
>  tools/testing/selftests/kvm/Makefile               |   3 +-
>  .../testing/selftests/kvm/include/kvm_util_base.h  |  75 ++++++++-----
>  tools/testing/selftests/kvm/include/test_util.h    |   2 +-
>  tools/testing/selftests/kvm/include/ucall_common.h |   7 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
>  .../testing/selftests/kvm/set_memory_region_test.c |   6 +-
>  .../testing/selftests/kvm/x86_64/hyperv_features.c |  10 +-
>  .../selftests/kvm/x86_64/mmio_warning_test.c       | 121 ---------------=
------
>  .../selftests/kvm/x86_64/monitor_mwait_test.c      |   6 +-
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c      |   2 +-
>  .../kvm/x86_64/private_mem_conversions_test.c      |   2 +-
>  .../kvm/x86_64/svm_nested_soft_inject_test.c       |   4 +-
>  .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   2 +-
>  .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c |   8 +-
>  14 files changed, 78 insertions(+), 172 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/x86_64/mmio_warning_test.=
c
>


