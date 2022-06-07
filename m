Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42253FB75
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 12:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240537AbiFGKhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 06:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbiFGKhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 06:37:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804AFEC3C8
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 03:37:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28224614F4
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913C3C385A5;
        Tue,  7 Jun 2022 10:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654598223;
        bh=y6Lwj9r5Vh8YDtEUV48nsmOM+Zw9mDLiGs1H2FyFf5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FLbRk8w+P8//Oca7WjNGQ0iZI4tpCOEA4DI704KgESW4PnToLJjBN5Mq6KIvwXB1M
         LlG6sK49arSxZYqSSA9+EZTo5QpL7xUCI16/scacWxlb4mnumS5mAgTaCibI2i3X2X
         q80MyldkBByEaH6F4mY6n3kcruVaKaozNwe/x7zMc3+q/0RqLczNNnmZN0PDwEWztu
         3pbJzD2FHx8WnBCxItbExcunQ2zn6NXKM+vYF/lHoI2hlSWpcCVA3VzTQDDznoSUXb
         x/6xjq6QjpLZ6IRwlAh2ws017Yy9s3HmESWNr+ID2hndR7BngrMezoZH6/4U9x0xyT
         qsjCSxkQ6hScA==
Date:   Tue, 7 Jun 2022 11:36:58 +0100
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 2/4] virtio/mmio: access header members normally
Message-ID: <20220607103658.GA32508@willie-the-truck>
References: <20220601165138.3135246-1-andre.przywara@arm.com>
 <20220601165138.3135246-3-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601165138.3135246-3-andre.przywara@arm.com>
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

On Wed, Jun 01, 2022 at 05:51:36PM +0100, Andre Przywara wrote:
> The handlers for accessing the virtio-mmio header tried to be very
> clever, by modelling the internal data structure to look exactly like
> the protocol header, so that address offsets can "reused".
> 
> This requires using a packed structure, which creates other problems,
> and seems to be totally unnecessary in this case.
> 
> Replace the offset-based access hacks to the structure with proper
> compiler visible accesses, to avoid unaligned accesses and make the code
> more robust.
> 
> This fixes UBSAN complaints about unaligned accesses.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/virtio-mmio.h |  2 +-
>  virtio/mmio.c             | 19 +++++++++++++++----
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
> index 13dcccb6..aa4cab3c 100644
> --- a/include/kvm/virtio-mmio.h
> +++ b/include/kvm/virtio-mmio.h
> @@ -39,7 +39,7 @@ struct virtio_mmio_hdr {
>  	u32	interrupt_ack;
>  	u32	reserved_5[2];
>  	u32	status;
> -} __attribute__((packed));
> +};

Does this mean that the previous patch is no longer required?

>  
>  struct virtio_mmio {
>  	u32			addr;
> diff --git a/virtio/mmio.c b/virtio/mmio.c
> index 3782d55a..c9ad8ee7 100644
> --- a/virtio/mmio.c
> +++ b/virtio/mmio.c
> @@ -135,12 +135,22 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
>  
>  	switch (addr) {
>  	case VIRTIO_MMIO_MAGIC_VALUE:
> +		memcpy(data, &vmmio->hdr.magic, sizeof(vmmio->hdr.magic));

Hmm, this is a semantic change as we used to treat the magic as a u32 by
passing it to ioport__write32(), which would in turn do the swab for
big-endian machines.

I don't think we should be using raw memcpy() here.

Will
