Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BD05A9C2B
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 17:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiIAPuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 11:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiIAPuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 11:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D734DF34
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 08:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDE8AB82837
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 15:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8EDC433D6;
        Thu,  1 Sep 2022 15:49:59 +0000 (UTC)
Date:   Thu, 1 Sep 2022 16:49:56 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 1/7] arm64: mte: Fix/clarify the PG_mte_tagged
 semantics
Message-ID: <YxDUpACQHmjbihnx@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-2-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-2-pcc@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 12:30:27PM -0700, Peter Collingbourne wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> Currently the PG_mte_tagged page flag mostly means the page contains
> valid tags and it should be set after the tags have been cleared or
> restored. However, in mte_sync_tags() it is set before setting the tags
> to avoid, in theory, a race with concurrent mprotect(PROT_MTE) for
> shared pages. However, a concurrent mprotect(PROT_MTE) with a copy on
> write in another thread can cause the new page to have stale tags.
> Similarly, tag reading via ptrace() can read stale tags of the
> PG_mte_tagged flag is set before actually clearing/restoring the tags.
> 
> Fix the PG_mte_tagged semantics so that it is only set after the tags
> have been cleared or restored. This is safe for swap restoring into a
> MAP_SHARED or CoW page since the core code takes the page lock. Add two
> functions to test and set the PG_mte_tagged flag with acquire and
> release semantics. The downside is that concurrent mprotect(PROT_MTE) on
> a MAP_SHARED page may cause tag loss. This is already the case for KVM
> guests if a VMM changes the page protection while the guest triggers a
> user_mem_abort().
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
> v3:
> - fix build with CONFIG_ARM64_MTE disabled

When you post someone else's patches (thanks for updating them BTW),
please add your Signed-off-by line. You should also add a note in the
SoB block about the changes you made, so something like:

[pcc@google.com: fix build with CONFIG_ARM64_MTE disabled]
Singed-off-by: your name/address

-- 
Catalin
