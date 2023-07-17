Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2D1756108
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 13:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjGQLDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 07:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjGQLDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 07:03:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DFE1B9
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 04:03:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 272DD60FE8
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 11:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E90CC433C7;
        Mon, 17 Jul 2023 11:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689591789;
        bh=YRtp4WYqjzv5RkGAPvm7xtN4TfJazJfwOWPP+hdnDHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ue6Tzz7wkN24ai2lC/tSHw+Coyg2zDx6mgkilxd8PcmBbNgHi676iKjTNN1Espuz3
         xff6ygFn8xWcsWCFgnxIZSs1xquBBY3u/weTfoylrRmITaEVRA2t2bu+bE7E5fVSF+
         W2OwusXWdxx4tp43T68qrOrANEDLKYuKvY2VOW7ZT3Rtu5fmeZ4ZYXlC3WpX6GwhF2
         9NV3d3JRZThlkxjiehmZwRWl4AnpCQWWx2mtvHvCV1CpzU0IbjIqoTu/mqTygAnFpt
         m9+jcTfCdHMhYuc/IB8Kqm3oep+KMp776FWljliG1pwvNazDzytC2JeIEx7MhRPtjK
         Y34cYWuYOpAyQ==
Date:   Mon, 17 Jul 2023 12:03:05 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        penberg@kernel.org, alexandru.elisei@arm.com
Subject: Re: [PATCH kvmtool v1 2/2] Align the calculated guest ram size to
 the host's page size
Message-ID: <20230717110304.GA8137@willie-the-truck>
References: <20230717102300.3092062-1-tabba@google.com>
 <20230717102300.3092062-3-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717102300.3092062-3-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 17, 2023 at 11:23:00AM +0100, Fuad Tabba wrote:
> If host_ram_size() * RAM_SIZE_RATIO does not result in a value
> aligned to the host page size, it triggers an error in
> __kvm_set_memory_region(), called via the
> KVM_SET_USER_MEMORY_REGION ioctl, which requires the size to be
> page-aligned.
> 
> Fixes: 18bd8c3bd2a7 ("kvm tools: Don't use all of host RAM for guests by default")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  builtin-run.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index 2801735..ff8ba0b 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -406,7 +406,7 @@ static u64 get_ram_size(int nr_cpus)
>  	if (ram_size > available)
>  		ram_size	= available;
>  
> -	return ram_size;
> +	return ALIGN(ram_size, host_page_size());
>  }

I guess we could avoid querying the page size twice if we also factored
out a helper to grab _SC_PHYS_PAGES and then did the multiply by
RAM_SIZE_RATIO before converting back to bytes.

e.g. something like:

	available = MIN_RAM_SIZE;

	nrpages = host_ram_nrpages() * RAM_SIZE_RATIO;
	if (nrpages)
		available = nrpages * host_page_size();

and then host_ram_size() just calls the two new helpers.

What do you think?

Will
