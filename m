Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D62544C4B
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 14:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245649AbiFIMkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 08:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245648AbiFIMj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 08:39:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9B3237CD
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 05:39:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A153FB82D8E
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 12:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D90C34114;
        Thu,  9 Jun 2022 12:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654778394;
        bh=2sxp4DpFykxJ8DisCp9DafR7LVoXs39xN1coXMPUrBI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NRpfdbtfAQQHQTjMP1gpRjidIg1JYSsZQh1BDV/OvrrGruBxXaTM/VViGwUwaoUzh
         y2vG+GZI3ufGDztIiDe6SEoeYa9xaRbBJ/5MQzsWUfPja1rPBMAQQDJHoj3J70wZOm
         HjvpzNZtgCKaatENGUTWtX36/cuOdyBBbJW3LDbrMeVjDWpE+jBzDp/saTJosnsh1X
         eRVqCzWH0SkHarfdYr571lOcQhLTAC3p8ASxXKHMMQHpVNsMdDbc96N4IDv8eLqLQ6
         RAzI+x14QZ0gXvfiI429YqBAc1UK6JZFnUrfI+PpFpLhAddgi2zvxdhLNtNTLczhoI
         WH/MjAsCx3kRg==
Date:   Thu, 9 Jun 2022 13:39:48 +0100
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: Re: [PATCH kvmtool 00/24] Virtio v1 support
Message-ID: <20220609123948.GA2599@willie-the-truck>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 07, 2022 at 06:02:15PM +0100, Jean-Philippe Brucker wrote:
> Add support for version 1 of the virtio transport to kvmtool. Based on a
> RFC by Sasha Levin [1], I've been trying to complete it here and there.
> It's long overdue and is quite painful to rebase, so let's get it
> merged.
> 
> Several reasons why the legacy transport needs to be replaced:
> 
> * Only 32 feature bits are supported. Most importantly
>   VIRTIO_F_ACCESS_PLATFORM, which forces a Linux guest to use the DMA
>   API, cannot be enabled. So we can't support private guests that
>   decrypt or share only their DMA memory with the host.

Woohoo!

> * Legacy virtqueue address is a 32-bit pfn, aligned on 4kB. Since Linux
>   guests bypass the DMA API they can't support large GPAs.
> 
> * New devices types (iommu, crypto, memory, etc) and new features cannot
>   be supported.
> 
> * New guests won't implement the legacy transport. Existing guests will
>   eventually drop legacy support.
> 
> Support for modern transport becomes the default and legacy is enabled
> with --virtio-legacy.
> 
> I only tested what I could: vsock, scsi and vhost-net are currently
> broken and can be fixed later (they have issues with mem regions and
> feature mask, among other things). I also haven't tested big-endian.

If these are broken, then shall we default to legacy mode and have the
modern transport be opt-in? Otherwise we're regressing people in a
confusing way.

Will
