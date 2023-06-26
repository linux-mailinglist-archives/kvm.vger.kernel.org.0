Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C382673EC25
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 22:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjFZUw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 16:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjFZUw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 16:52:56 -0400
Received: from out-44.mta1.migadu.com (out-44.mta1.migadu.com [IPv6:2001:41d0:203:375::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEBD10D
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 13:52:54 -0700 (PDT)
Date:   Mon, 26 Jun 2023 20:52:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687812772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X1L5ZJ3PrRKoApzZhudFyrD6ET1z6DiDInN2mn2qOoA=;
        b=av6vlVmWwH6Lmd2qCNew8YvpUoDOiGhnuZg5NYkW0fVMhEJGKEF1ML4mve6cyO4xGHvlEI
        4K1bAe1c3yvOeYTlymxOebdimsN1DbmlfWnIT1PdorkycXiZI0JrK7TjI+vUS0PVtquXnd
        g0nRwzgIZRzd80BTuICSOMXIcQRi/b0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v4 0/4] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2}
Message-ID: <ZJn6niA1RgAqu7DC@linux.dev>
References: <20230607194554.87359-1-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607194554.87359-1-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Wed, Jun 07, 2023 at 07:45:50PM +0000, Jing Zhang wrote:
> 
> This patch series enable userspace writable for below idregs:
> ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2}_EL1.
> 
> It is based on below series [2] which add infrastructure for writable idregs.

Could you implement some tests for these changes? We really need to see
that userspace is only allowed to select a subset of features that're
provided by the host, and that the CPU feature set never exceeds what
the host can support.

Additionally, there are places in the kernel where we use host ID
register values for the sake of emulation (DBGDIDR, LORegion). These
both should instead be using the _guest_ ID register values.

-- 
Thanks,
Oliver
