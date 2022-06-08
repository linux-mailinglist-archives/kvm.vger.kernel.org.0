Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8163D543BA2
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 20:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiFHSls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 14:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiFHSlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 14:41:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE45D15735
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 11:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60D5361C1A
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 18:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C728C34116;
        Wed,  8 Jun 2022 18:41:41 +0000 (UTC)
Date:   Wed, 8 Jun 2022 19:41:37 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
Message-ID: <YqDtYULvAMQVp1pC@arm.com>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
 <CA+EHjTx328na4FDfKU-cdLX+SV4MmKfMKKrTHo5H0=iB2GTQ+A@mail.gmail.com>
 <Ypl5TdMN3J/tttNe@google.com>
 <87v8tgltqy.wl-maz@kernel.org>
 <CAMn1gO7mP_QTb+fkfvc6qQoN0aU6TwkExU-Wj+VR6rjBsmhs1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMn1gO7mP_QTb+fkfvc6qQoN0aU6TwkExU-Wj+VR6rjBsmhs1g@mail.gmail.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 05:20:39PM -0700, Peter Collingbourne wrote:
> On Sat, Jun 4, 2022 at 1:26 AM Marc Zyngier <maz@kernel.org> wrote:
> > But the bigger picture here is what ensures that the host cannot mess
> > with the guest tags? I don't think we have a any mechanism to
> > guarantee that, specially on systems where the tags are only a memory
> > carve-out, which the host could map and change at will.
> 
> Right, I forgot about that. We probably only want to expose MTE to
> guests if we have some indication (through the device tree or ACPI) of
> how to protect the guest tag storage.

I think this would be useful irrespective of MTE. Some SoCs (though I
hope very rare these days) may allow for physical aliasing of RAM but if
the host stage 2 only protects one of the aliases, it's not of much use.

I am yet to fully understand how pKVM works but with the separation of
the hyp from the host kernel, it may have to actually parse the
DT/ACPI/EFI tables itself if it cannot rely on what the host kernel told
it. IIUC currently it creates an idmap at stage 2 for the host kernel,
only unmapped if the memory was assigned to a guest. But not sure what
happens with the rest of the host physical address space (devices etc.),
I presume they are fully accessible by the host kernel in stage 2.

-- 
Catalin
