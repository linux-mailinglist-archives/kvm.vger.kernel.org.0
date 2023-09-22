Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B7A7AB559
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjIVQAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjIVQAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:00:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D47C102
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:00:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FCAC433C8;
        Fri, 22 Sep 2023 16:00:42 +0000 (UTC)
Date:   Fri, 22 Sep 2023 17:00:40 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        zhukeqian1@huawei.com, jonathan.cameron@huawei.com,
        linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 6/8] KVM: arm64: Only write protect selected PTE
Message-ID: <ZQ26KE2bzEFYUpMc@arm.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-7-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825093528.1637-7-shameerali.kolothum.thodi@huawei.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 10:35:26AM +0100, Shameer Kolothum wrote:
> From: Keqian Zhu <zhukeqian1@huawei.com>
> 
> This function write protects all PTEs between the ffs and fls of mask.
> There may be unset bits between this range. It works well under pure
> software dirty log, as software dirty log is not working during this
> process.
> 
> But it will unexpectly clear dirty status of PTE when hardware dirty
> log is enabled. So change it to only write protect selected PTE.

Ah, I did wonder about losing the dirty status. The equivalent to S1
would be for kvm_pgtable_stage2_wrprotect() to set a software dirty bit.

I'm only superficially familiar with how KVM does dirty tracking for
live migration. Does it need to first write-protect the pages and
disable DBM? Is DBM re-enabled later? Or does stage2_wp_range() with
your patches leave the DBM on? If the latter, the 'wp' aspect is a bit
confusing since DBM basically means writeable (and maybe clean). So
better to have something like stage2_clean_range().

-- 
Catalin
