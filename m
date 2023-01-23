Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA08678C13
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 00:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbjAWXhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 18:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAWXhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 18:37:07 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CDF2684B
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:37:05 -0800 (PST)
Date:   Mon, 23 Jan 2023 23:36:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674517024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O9OmVYl5JPIBMOqO4QTL0Ss3P7OHvD/38X/apKzN0wE=;
        b=P7BBf1bvqu72jKL6i5vughpUjGGbBds2m1XjLqEOJgkFE8U4RbTfir7CD9gljTB1tb7rYy
        JTfLd/GXXJ6BUTYA27XTHYE7I/5QQnHfZXGlo4pp1C4sG57N72ooE0xflk3CKMEt7Aen74
        Jhco61qVirW5a4KxEUrL0PUBuQFxLP8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [PATCH 4/4] KVM: selftests: aarch64: Test read-only PT memory
 regions
Message-ID: <Y88aFBBcsx7v/2qh@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <20230110022432.330151-5-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110022432.330151-5-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 02:24:32AM +0000, Ricardo Koller wrote:
> Extend the read-only memslot tests in page_fault_test to test read-only PT
> (Page table) memslots. Note that this was not allowed before commit "KVM:
> arm64: Fix handling of S1PTW S2 fault on RO memslots" as all S1PTW faults
> were treated as writes which resulted in an (unrecoverable) exception
> inside the guest.

Do we need an additional test that the guest gets nuked if TCR_EL1.HA =
0b1 and AF is clear in one of the stage-1 PTEs?

> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/aarch64/page_fault_test.c        | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> index 2e2178a7d0d8..2f81d68e876c 100644
> --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> @@ -831,6 +831,7 @@ static void help(char *name)
>  {										\
>  	.name			= SCAT3(ro_memslot, _access, _with_af),		\

Does the '_with_af' actually belong here? The macro doesn't take such a
parameter. AFAICT the access flag is already set in all S1 PTEs for this
case and TCR_EL1.HA = 0b0.

>  	.data_memslot_flags	= KVM_MEM_READONLY,				\
> +	.pt_memslot_flags	= KVM_MEM_READONLY,				\
>  	.guest_prepare		= { _PREPARE(_access) },			\
>  	.guest_test		= _access,					\
>  	.mmio_handler		= _mmio_handler,				\

--
Thanks,
Oliver
