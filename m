Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF137CD1A4
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 03:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjJRBKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 21:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjJRBKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 21:10:15 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C6CB0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:10:14 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5aaae6f46e1so4121712a12.3
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697591414; x=1698196214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E16mHWskjTK/3B68Q/Af3Teg1/R8lnVGjDiVWL3Gi8c=;
        b=XxajgS6DEeyskLQvwZCq4+hzkNK3/lfws5r3oQW+RYnw1cUNQRQ9Kg5K16vDWNnPNI
         YtjXOsod+tCYYiFHg3UG+nWORmehgOBNKWh4u5bjGVC5yHCOvPmRyjbiSCaQ7woanc5T
         U2DJLNWabXj0YEqKMt9R7MkrIPNDxosa/6HkNY8Sle74XM4dtNGsK8XMMdDj2+hjaaBh
         iohbD/a80XQ6ZaurfgjXQUwmQ0ddWtzLwh5yjLWcznMWbqBqZXuFm1gdjYrlVLSd+Y1K
         ZIdDaoq6Phr2xk670Ul/pqyCMVNmDZjbe3p/p7JDL0L3xJEnN0KaPw4VNhpqa6Z+Gssl
         Re2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697591414; x=1698196214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E16mHWskjTK/3B68Q/Af3Teg1/R8lnVGjDiVWL3Gi8c=;
        b=frVOmQ0q3vMS4FPBsjLERPSf7iMNWv+aqy7fUwLbRAGeQhv5cm7cwA2QqCFesAd23s
         wgMC1KeUWYrRzkvbgC7zecdrnvy40tIJSdhx7OIkiVDPF1ufQbkjMxwfTljkFN0/BlG+
         lr4rocYQOlDZ0EwKO3chwT4c3Zkmlx6SjiLpIno3l0N6B488qG7xYchZivpJ+MknxS+j
         NxXz/zf+ZrJ7yvhqQ7wbGpHsUNJzvFnrBFx9TleGplcrDoCOpxH/6hRDFfQjFSfAYcmy
         URycNJaghZwLZ0QQypnD68lw2x4TB3nqW/nHof3WEDc/Wq1X0LXRH36IWKnGzoA+Ehxq
         ljXQ==
X-Gm-Message-State: AOJu0YxjU5egHToumWpSFW8ku1GDKAuEZ44mOXOueWdpW3mMGIicPqq8
        DmkQ7zNxKz1OJwyGg0bvzYvSxC+yq90=
X-Google-Smtp-Source: AGHT+IGHyYI6m11j74GgAMpc6cp+2vjYXNqQ9yFJFAolNqis+S4xnhwYV0x/iBUJz9i94LnYDn3tHaUP2g4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab54:b0:1ca:7295:8127 with SMTP id
 ij20-20020a170902ab5400b001ca72958127mr78911plb.13.1697591413896; Tue, 17 Oct
 2023 18:10:13 -0700 (PDT)
Date:   Tue, 17 Oct 2023 18:10:12 -0700
In-Reply-To: <20231016184737.1027930-1-michael.roth@amd.com>
Mime-Version: 1.0
References: <20231016184737.1027930-1-michael.roth@amd.com>
Message-ID: <ZS8wdNtAoSvH_jpX@google.com>
Subject: Re: [PATCH gmem] KVM: selftests: Fix gmem conversion tests for
 multiple vCPUs
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vannapurve@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023, Michael Roth wrote:
> Currently the private_mem_conversions_test crashes if invoked with the
> -n <num_vcpus> option without also specifying multiple memslots via -m.

Totally a PEBKAC, not a bug ;-)
 
> This is because the current implementation assumes -m is specified and
> always sets up the per-vCPU memory with a dedicated memslot for each
> vCPU. When -m is not specified, the test skips setting up
> memslots/memory for secondary vCPUs.
> 
> The current code does seem to try to handle using a single memslot for
> multiple vCPUs in some places, e.g. the call-site, but
> test_mem_conversions() is missing the important bit of sizing the single
> memslot appropriately to handle all the per-vCPU memory. Implement that
> handling.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  .../kvm/x86_64/private_mem_conversions_test.c        | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
> index c04e7d61a585..5eb693fead33 100644
> --- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
> @@ -388,10 +388,14 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
>  		gmem_flags = 0;
>  	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
>  
> -	for (i = 0; i < nr_memslots; i++)
> -		vm_mem_add(vm, src_type, BASE_DATA_GPA + size * i,
> -			   BASE_DATA_SLOT + i, size / vm->page_size,
> -			   KVM_MEM_PRIVATE, memfd, size * i);
> +	if (nr_memslots == 1)
> +		vm_mem_add(vm, src_type, BASE_DATA_GPA, BASE_DATA_SLOT,
> +			   memfd_size / vm->page_size, KVM_MEM_PRIVATE, memfd, 0);
> +	else
> +		for (i = 0; i < nr_memslots; i++)

The if-else needs curly braces.

> +			vm_mem_add(vm, src_type, BASE_DATA_GPA + size * i,
> +				   BASE_DATA_SLOT + i, size / vm->page_size,
> +				   KVM_MEM_PRIVATE, memfd, size * i);

But I think that's a moot point, because isn't it easier to do this?

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index c04e7d61a585..c99073098f98 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -367,6 +367,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
         */
        const size_t size = align_up(PER_CPU_DATA_SIZE, get_backing_src_pagesz(src_type));
        const size_t memfd_size = size * nr_vcpus;
+       const size_t slot_size = memfd_size / nr_memslots;
        struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
        pthread_t threads[KVM_MAX_VCPUS];
        uint64_t gmem_flags;
@@ -390,7 +391,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 
        for (i = 0; i < nr_memslots; i++)
                vm_mem_add(vm, src_type, BASE_DATA_GPA + size * i,
-                          BASE_DATA_SLOT + i, size / vm->page_size,
+                          BASE_DATA_SLOT + i, slot_size / vm->page_size,
                           KVM_MEM_PRIVATE, memfd, size * i);
 
        for (i = 0; i < nr_vcpus; i++) {
