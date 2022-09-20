Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3965F5BDED0
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiITHwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiITHva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:51:30 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40681163
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 00:51:05 -0700 (PDT)
Date:   Tue, 20 Sep 2022 09:51:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663660264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=adQjsppu4f1Y67G2a4MebDdYXgGJe2ubXNkO3qZkbwo=;
        b=xk1eBGaKG1NcZUEjlbXiaufZBSA5rBzaGdToMJpTFdtE6QoaX7b9OKy2t4MRc0qCHgflFL
        sPXSkp4aca37XBWhSwmRBA3DvYxIY6dOAj+R0Isg/8CojlQbdmveE/zizsDqAKoG/l3vCT
        ySiKgR08XMLNxy+GBzmmwkcT0LSULNQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v7 08/13] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
Message-ID: <20220920075103.34qzxqxhu3puq72r@kamzik>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-9-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920042551.3154283-9-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022 at 04:25:46AM +0000, Ricardo Koller wrote:
> The previous commit added support for callers of ____vm_create() to specify
> what memslots to use for code, page-tables, and data allocations. Change
> them accordingly:
> 
> - stacks, code, and exception tables use the code memslot
> - page tables and the pgd use the pt memslot
> - data (anything allocated with vm_vaddr_alloc()) uses the data memslot
> 
> No functional change intended. All allocators keep using memslot #0.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 +
>  .../selftests/kvm/lib/aarch64/processor.c     | 11 ++--
>  tools/testing/selftests/kvm/lib/elf.c         |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 57 ++++++++++++-------
>  .../selftests/kvm/lib/riscv/processor.c       |  7 ++-
>  .../selftests/kvm/lib/s390x/processor.c       |  7 ++-
>  .../selftests/kvm/lib/x86_64/processor.c      | 13 +++--
>  7 files changed, 61 insertions(+), 40 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
