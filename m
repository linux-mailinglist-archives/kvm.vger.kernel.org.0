Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309815FDC33
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 16:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiJMOOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 10:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJMOOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 10:14:43 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CB59FDF
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:14:41 -0700 (PDT)
Date:   Thu, 13 Oct 2022 16:14:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665670479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YTnR3sTpueMD1WOCKjn13lgOyfXnFgP1FGLusy0IRdQ=;
        b=o8iWPUfoQGziwzej5BerN5CcyiIwIgIJX1BIPhpwk1A3iUth1ltoEDYJ5RgytnN8fxDsFE
        09J30ihjCMewpdUEKnz7/NFKmvIhtCq9EUwJd3uexhjD1ECAFaFNPxcaBIzPTV7p96Oxaz
        1WNityOODlONHfzCXCTeiTbpZu7U+44=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oupton@google.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v9 09/14] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
Message-ID: <20221013141431.datybmwzfdeqxobv@kamzik>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-10-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022 at 01:06:23AM +0000, Ricardo Koller wrote:
> Now that kvm_vm allows specifying different memslots for code, page tables,
> and data, use the appropriate memslot when making allocations in
> common/libraty code. Change them accordingly:
> 
> - code (allocated by lib/elf) use the CODE memslot
> - stacks, exception tables, and other core data pages (like the TSS in x86)
>   use the DATA memslot
> - page tables and the PGD use the PT memslot
> - test data (anything allocated with vm_vaddr_alloc()) uses the TEST_DATA
>   memslot
> 
> No functional change intended. All allocators keep using memslot #0.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  4 ++
>  .../selftests/kvm/lib/aarch64/processor.c     | 12 ++--
>  tools/testing/selftests/kvm/lib/elf.c         |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 57 ++++++++++++-------
>  .../selftests/kvm/lib/riscv/processor.c       |  8 ++-
>  .../selftests/kvm/lib/s390x/processor.c       |  8 ++-
>  .../selftests/kvm/lib/x86_64/processor.c      | 13 +++--
>  7 files changed, 65 insertions(+), 40 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
