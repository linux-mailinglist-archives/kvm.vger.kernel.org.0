Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1417070E9
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 20:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjEQSiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 14:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjEQSiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 14:38:23 -0400
Received: from out-19.mta1.migadu.com (out-19.mta1.migadu.com [IPv6:2001:41d0:203:375::13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C351A170B
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 11:38:21 -0700 (PDT)
Date:   Wed, 17 May 2023 18:38:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684348700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VADbWaPZL/zhG2c6e1p0Yiznf8RS4MLXiOGMohKfvKA=;
        b=GWmFapC3pwKy3Ow+nUV3D64O7mk+VdhbZc858Oi8uuSE0uzaH2+gjVww3a7aY5Mw3iJubu
        wB5AO/sqcmBiX/UcCRAZhKal9bEET8CI6G99QT6xQcLruQBHF2xwU2XmmDY9tekozCrLMt
        TDt3uQjvT1SpM8xNmJI7kMt3xOQyqHo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Message-ID: <ZGUfFn0jai9n4eSF@linux.dev>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
 <20230404154050.2270077-9-oliver.upton@linux.dev>
 <87o7o26aty.wl-maz@kernel.org>
 <86pm8iv8tj.wl-maz@kernel.org>
 <fd9aee7022ea47e29cbff3120764c2c6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd9aee7022ea47e29cbff3120764c2c6@huawei.com>
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

Hi Salil,

On Wed, May 17, 2023 at 06:00:18PM +0000, Salil Mehta wrote:

[...]

> > > Should we expose the ESR, or at least ESR_EL2.IL as an additional
> > > flag?
> 
> 
> I think we would need "Immediate value" of the ESR_EL2 register in the
> user-space/VMM to be able to construct the syndrome value. I cannot see
> where it is being sent? 

The immediate value is not exposed to userspace, although by definition
the immediate value must be zero. The SMCCC spec requires all compliant
calls to use an immediate of zero (DEN0028E 2.9).

Is there a legitimate use case for hypercalls with a nonzero immediate?
They would no longer be considered SMCCC calls at that point, so they
wouldn't work with the new UAPI.

-- 
Thanks,
Oliver
