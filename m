Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCC4729D9F
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241332AbjFIPAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 11:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241662AbjFIO75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 10:59:57 -0400
Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [IPv6:2001:41d0:203:375::38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A64E50
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 07:59:56 -0700 (PDT)
Date:   Fri, 9 Jun 2023 14:59:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686322794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tjX8DzT+VkdDDHfdUii6WZAg+8YtJ/Le8qPqCL2aFIg=;
        b=W1j3MzafFpna6foeRceMZoNVh+mGTUjdhwuAw8nMLJT3L1F1f2IJN6Mf9KJOvSOuRuiO6Q
        1jLF5iAJd183k0VguYGNXFIS9TJy6XND+BMHrqBRkf04HI+VKUCz6lKW9nd+kjPKJMf2f1
        PgNbT9fvR4pH0UChxo/8rFuqqN6KiH4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] KVM: arm64: Skip break phase when we have FEAT_BBM
 level 2
Message-ID: <ZIM+ZgFji/H3Y/9U@linux.dev>
References: <20230602170147.1541355-1-coltonlewis@google.com>
 <20230602170147.1541355-4-coltonlewis@google.com>
 <87sfb7octw.wl-maz@kernel.org>
 <ZH5VQMEoiHEITmF4@linux.dev>
 <20230608172112.GA1606@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608172112.GA1606@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Will,

On Thu, Jun 08, 2023 at 06:21:13PM +0100, Will Deacon wrote:
> > IIRC, Colton was testing largely with permission relaxation, and had
> > forward progress issues b.c. the stale TLB entry was never invalidated
> > in response to a permission fault.
> 
> Would the series at:
> 
> https://lore.kernel.org/r/5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com
> 
> help with that?

Heh, that's a rather interesting patch :)

I don't think it is directly related to the problem Colton encounters,
though the symptoms are similar. This crops up when KVM uses a stricter
permission set than the primary MMU, like lazy X for deferred I$
maintenance and write-protection for dirty logging. KVM policy led to
the stale TLB entry, so KVM is the one that needs to initiate the
invalidation.

-- 
Thanks,
Oliver
