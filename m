Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B7A7D64F2
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 10:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbjJYIZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 04:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbjJYIZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 04:25:19 -0400
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [IPv6:2001:41d0:203:375::b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4D69C
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 01:25:15 -0700 (PDT)
Date:   Wed, 25 Oct 2023 08:25:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698222312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vVwFanUFLa3Y0XsNMbD4ttfz3IZO8tUM2EvaVKR7O1E=;
        b=ipjYx7POmr2jCZv3GijEQff2XjhT7nOE6t4JnGveCvZKoSbLaxoi5ed0p0iA31pP20ax8Y
        Jnh6ZZXF3WmxKRGdI7wOtZZVDnbDn5IOa08TwOc9qANUOObSXCBiAz5ab2Xmzd28SOBAP6
        HYSFWTPFYS34IdTLnrCZ20/rRrdYfEo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Stop printing about MMIO accesses where
 ISV==0
Message-ID: <ZTjQ43gpJUvfh6rG@linux.dev>
References: <20231024210739.1729723-1-oliver.upton@linux.dev>
 <86il6v3z6d.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86il6v3z6d.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 09:04:58AM +0100, Marc Zyngier wrote:

[...]

> While I totally agree that this *debug* statement should go, we should
> also replace it with something else.
> 
> Because when you're trying to debug a guest (or even KVM itself),
> seeing this message is a sure indication that the guest is performing
> an access outside of memory. The fact that KVM tries to handle it as
> MMIO is just an implementation artefact.
> 
> So I'd very much welcome a replacement tracepoint giving a bit more
> information, such as guest PC, IPA being accessed, load or store. With
> that, everybody wins.

Aren't we already covered by the kvm_guest_fault tracepoint? Userspace
can filter events on ESR to get the faults it cares about. I'm not
against adding another tracepoint, but in my experience kvm_guest_fault
has been rather useful for debugging any type of guest fault.

-- 
Thanks,
Oliver
