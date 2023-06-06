Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5314B723BED
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 10:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjFFIfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 04:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237105AbjFFIeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 04:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD991E68;
        Tue,  6 Jun 2023 01:34:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5536612B8;
        Tue,  6 Jun 2023 08:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EF9C4339B;
        Tue,  6 Jun 2023 08:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686040464;
        bh=IBidPa4YTyIF5atWcJcRcHpMTfYQvXCVIu3C1ReCwe8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FtdmKnJTbh0Th4rLzQVdzsyHI4nobuWxYORj11iWeWhGlMgvLcF7mRuKDFP/3SjWj
         E5Za6vAzdwMhU2Fl7W+Yd14DBVHDobnBWLRAmob+EsEIFyB5d80PGYjA3JIjQUBajb
         InBHOAv0cNMXRLtMH0xOOu4RRhUp3kA2MYZeOzlJOygnQC7JmPUZ5PDtqTXJfHRnP2
         1AWELankUVH81S+2sDfidjLYiiUjlwt7jNuRuO9T4Eih88JdAH2XgOt0pTjw3cIR7b
         lmQCCanbigXkSgQ/AIlWp5wfiem/MA7KeHluPdl6au2zq8eAq591Yb0A87DeofIIFq
         Tf4L4UWn/XCBw==
Date:   Tue, 6 Jun 2023 16:34:15 +0800
From:   Tzung-Bi Shih <tzungbi@kernel.org>
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
        Oliver Upton <oliver.upton@linux.dev>,
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
Subject: Re: [PATCH mm-unstable v2 01/10] mm/kvm: add
 mmu_notifier_ops->test_clear_young()
Message-ID: <ZH7vh1GmsV+UCPwv@google.com>
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-2-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526234435.662652-2-yuzhao@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023 at 05:44:26PM -0600, Yu Zhao wrote:
> +/*
> + * Architectures that implement kvm_arch_test_clear_young() should override
> + * kvm_arch_has_test_clear_young().
> + *
> + * kvm_arch_has_test_clear_young() is allowed to return false positive, i.e., it
> + * can return true if kvm_arch_test_clear_young() is supported but disabled due
> + * to some runtime constraint. In this case, kvm_arch_test_clear_young() should

Is it a typo here?  s/kvm_arch_test_clear_young/kvm_arch_has_test_clear_young/.

> +static inline int mmu_notifier_clear_young(struct mm_struct *mm,
> +					   unsigned long start,
> +					   unsigned long end)
> +{
> +	return 0;
> +}
> +

This looks irrelevant to the patch but a fix for commit 1d7715c676a1
("mmu-notifier: add clear_young callback") instead.
