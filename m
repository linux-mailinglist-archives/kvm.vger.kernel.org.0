Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242F87D5A77
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 20:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344127AbjJXS3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 14:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344023AbjJXS3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 14:29:32 -0400
Received: from out-194.mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7EAB9
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 11:29:30 -0700 (PDT)
Date:   Tue, 24 Oct 2023 18:29:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698172168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RRSsi4LGt8MbQ4KLys+pDJGRcAZu1kNaXtLuROXhy8I=;
        b=o2ccfekA1HV281+lY8Y0GgD/IkzTQy9l7dRQ8lCqmeGVbXZztnbjZPYgWv0boTaT/0A0zU
        /qMVkE7LYziezD4yn/SxMSZSzRODCztlZNMqwe5H+fBmtZa30v4Mbk0X0wbaPufcOb1WUK
        1WnpesWP8+SiqFIiCjXtUOqldYEa5pI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 11/13] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
Message-ID: <ZTgNA-yXZeA8ScjU@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-12-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020214053.2144305-12-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 09:40:51PM +0000, Raghavendra Rao Ananta wrote:

[...]

> +#define INVALID_EC	(-1ul)
> +uint64_t expected_ec = INVALID_EC;
> +uint64_t op_end_addr;
> +
>  static void guest_sync_handler(struct ex_regs *regs)
>  {
>  	uint64_t esr, ec;
>  
>  	esr = read_sysreg(esr_el1);
>  	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> -	__GUEST_ASSERT(0, "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx", regs->pc, esr, ec);
> +
> +	__GUEST_ASSERT(op_end_addr && (expected_ec == ec),
> +			"PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx; EC expected: 0x%lx",
> +			regs->pc, esr, ec, expected_ec);
> +
> +	/* Will go back to op_end_addr after the handler exits */
> +	regs->pc = op_end_addr;

This sort of game is exceedingly fragile, and actually causes the test
to fail when I build it with clang. The test body is written in C, so
you don't know if the label you've chosen as the return address is
actually the next instruction after the sysreg access.

A64 instructions are guaranteed to be 32 bit, so we can just increment
PC by 4 here.

-- 
Thanks,
Oliver
