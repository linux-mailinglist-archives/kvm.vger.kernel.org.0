Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEDE718F08
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 01:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjEaXXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 19:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjEaXXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 19:23:07 -0400
Received: from out-37.mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B0C98
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 16:23:05 -0700 (PDT)
Date:   Wed, 31 May 2023 23:22:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685575383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SXIoTlecMC6VxxSME1sHTXGjADcYTmN1y7mvnJvjlhM=;
        b=lyfbrHT4Q4zo1L0ArqeQIdJoep5zRjHJ2OLTTh3iRuaDrDCmyrt6ZdUnmT8D0VRFrnKrfd
        Fay41KvYXJP8CWHfKOE6M8su7vw1n8IEhIPvIvj0EphIHYOG0Ve9WKW9yduPpl6rDOCxtx
        CeLsU8HW8TNpYdjp9DmTE9Euk9lTN+Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com
Subject: Re: [PATCH mm-unstable v2 04/10] kvm/arm64: make stage2 page tables
 RCU safe
Message-ID: <ZHfWzX04GlcNngdU@linux.dev>
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-5-yuzhao@google.com>
 <ZHJHJPBF6euzOFdw@linux.dev>
 <CAOUHufa74CufHziHSquO5bZwbFXz2MNssBzW+AH7=Xo5RCnQ0A@mail.gmail.com>
 <ZHZQdQAApIrw6fBu@linux.dev>
 <CAOUHufZOkBmZJgCU2xW2B8S3P3TWERHezy0xKWY9_TeyV9K7Rg@mail.gmail.com>
 <ZHef0VsZvZ1Vnz0u@linux.dev>
 <CAOUHufZrfnfcbrqSzmHkejR5MA2gmGKZ3LMRhbLHV+1427z=Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOUHufZrfnfcbrqSzmHkejR5MA2gmGKZ3LMRhbLHV+1427z=Tw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 05:10:52PM -0600, Yu Zhao wrote:
> On Wed, May 31, 2023 at 1:28 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > On Tue, May 30, 2023 at 02:06:55PM -0600, Yu Zhao wrote:
> > > On Tue, May 30, 2023 at 1:37 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > As it is currently implemented, yes. But, there's potential to fast-path
> > > > the implementation by checking page_count() before starting the walk.
> > >
> > > Do you mind posting another patch? I'd be happy to ack it, as well as
> > > the one you suggested above.
> >
> > I'd rather not take such a patch independent of the test_clear_young
> > series if you're OK with that. Do you mind implementing something
> > similar to the above patch w/ the proposed optimization if you need it?
> 
> No worries. I can take the above together with the following, which
> would form a new series with its own merits, since apparently you
> think the !AF case is important.

Sorry if my suggestion was unclear.

I thought we were talking about ->free_removed_table() being called from
the stage-2 unmap path, in which case we wind up unnecessarily visiting
PTEs on a table known to be empty. You could fast-path that by only
initiating a walk if  page_count() > 1:

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 95dae02ccc2e..766563dc465c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1331,7 +1331,8 @@ void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pg
 		.end	= kvm_granule_size(level),
 	};
 
-	WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level + 1));
+	if (mm_ops->page_count(pgtable) > 1)
+		WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level + 1));
 
 	WARN_ON(mm_ops->page_count(pgtable) != 1);
 	mm_ops->put_page(pgtable);


A lock-free access fault walker is interesting, but in my testing it hasn't
led to any significant improvements over acquiring the MMU lock for
read. Because of that I hadn't bothered with posting the series upstream.

-- 
Thanks,
Oliver
