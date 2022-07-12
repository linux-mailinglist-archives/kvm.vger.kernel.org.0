Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732F9571608
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiGLJqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiGLJqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:46:51 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFC1A43AE
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 02:46:50 -0700 (PDT)
Date:   Tue, 12 Jul 2022 11:46:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657619209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mnXWUrIfGOW0Je0O0P1V4KP3f52Jsjrq+7JY38apOwQ=;
        b=mRKpQiTadNkQhambM7s0HxVay8Z7Sy/N4GJWSBXENM36+8p1e5BFZlgqBzBtclfqCIAMwF
        +RUIpJLttjNd7uWyrKOMX4CaC9oBRFzVe2pdtbz0y50SRGcAUSZH2e8vefttwIMk4w7gdy
        FlJJU/Jvnxg37DblqsEsgAzrFDN0OZc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v4 07/13] KVM: selftests: aarch64: Construct
 DEFAULT_MAIR_EL1 using sysreg.h macros
Message-ID: <20220712094648.nkm57lq7eapdfh5h@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-8-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 02:32:51PM -0700, Ricardo Koller wrote:
> Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
> with macros from asm/sysreg.h.  The index macros can then be used when
> constructing PTEs (instead of using raw numbers).
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 25 ++++++++++++++-----
>  .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
>  2 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 6649671fa7c1..74f10d006e15 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -38,12 +38,25 @@
>   * NORMAL             4     1111:1111
>   * NORMAL_WT          5     1011:1011
>   */
> -#define DEFAULT_MAIR_EL1 ((0x00ul << (0 * 8)) | \
> -			  (0x04ul << (1 * 8)) | \
> -			  (0x0cul << (2 * 8)) | \
> -			  (0x44ul << (3 * 8)) | \
> -			  (0xfful << (4 * 8)) | \
> -			  (0xbbul << (5 * 8)))
> +
> +/* Linux doesn't use these memory types, so let's define them. */
> +#define MAIR_ATTR_DEVICE_GRE	UL(0x0c)
> +#define MAIR_ATTR_NORMAL_WT	UL(0xbb)
> +
> +#define MT_DEVICE_nGnRnE	0
> +#define MT_DEVICE_nGnRE		1
> +#define MT_DEVICE_GRE		2
> +#define MT_NORMAL_NC		3
> +#define MT_NORMAL		4
> +#define MT_NORMAL_WT		5
> +
> +#define DEFAULT_MAIR_EL1							\
> +	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |		\
> +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |		\
> +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |			\
> +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |			\
> +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
> +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT))
>  
>  #define MPIDR_HWID_BITMASK (0xff00fffffful)
>  
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 8dd511aa79c2..733a2b713580 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -133,7 +133,7 @@ void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  
>  void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
>  {
> -	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
> +	uint64_t attr_idx = MT_NORMAL;
>  
>  	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
>  }
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
