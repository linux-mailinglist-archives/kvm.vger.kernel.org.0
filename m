Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49FA7AB69F
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjIVQ7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjIVQ7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:59:23 -0400
Received: from out-198.mta0.migadu.com (out-198.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E47198
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:59:15 -0700 (PDT)
Date:   Fri, 22 Sep 2023 16:59:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695401954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y6/hQEMPVHQkW+VGeoG3f+C/qAx++wI6UHGjk2uuU5Q=;
        b=PKtkMDQtsJGBrPV3WbBf4dphx8J+NtrxPNNLjB6ssrYvNm6jqVgfH/aiga5EoTAXARCkWU
        8N2mYGpI8ms+vfz5Sw349w/Fe85OH20Qy8UdurnX8iOd9YD7Czm3pBbpIYFFEaqHakIQzd
        jAEIhbt4CP2AZuvrHMlsXMwZcmggyOs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, zhukeqian1@huawei.com,
        jonathan.cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 6/8] KVM: arm64: Only write protect selected PTE
Message-ID: <ZQ3H3JZHnxIVCIF6@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-7-shameerali.kolothum.thodi@huawei.com>
 <ZQ26KE2bzEFYUpMc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQ26KE2bzEFYUpMc@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 05:00:40PM +0100, Catalin Marinas wrote:
> On Fri, Aug 25, 2023 at 10:35:26AM +0100, Shameer Kolothum wrote:
> > From: Keqian Zhu <zhukeqian1@huawei.com>
> > 
> > This function write protects all PTEs between the ffs and fls of mask.
> > There may be unset bits between this range. It works well under pure
> > software dirty log, as software dirty log is not working during this
> > process.
> > 
> > But it will unexpectly clear dirty status of PTE when hardware dirty
> > log is enabled. So change it to only write protect selected PTE.
> 
> Ah, I did wonder about losing the dirty status. The equivalent to S1
> would be for kvm_pgtable_stage2_wrprotect() to set a software dirty bit.
> 
> I'm only superficially familiar with how KVM does dirty tracking for
> live migration. Does it need to first write-protect the pages and
> disable DBM? Is DBM re-enabled later? Or does stage2_wp_range() with
> your patches leave the DBM on? If the latter, the 'wp' aspect is a bit
> confusing since DBM basically means writeable (and maybe clean). So
> better to have something like stage2_clean_range().

KVM has never enabled DBM and we solely rely on write-protection faults
for dirty tracking. IOW, we do not have a writable-clean state for
stage-2 PTEs (yet).

-- 
Thanks,
Oliver
