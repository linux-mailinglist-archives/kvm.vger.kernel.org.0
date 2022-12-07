Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED966464F3
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 00:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiLGXV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 18:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLGXVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 18:21:25 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542E72AC41
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 15:21:24 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id k3so4735435qki.13
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 15:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=axedT4rtG43h/6SvQLH8htjZ6eotsOC4BNVL1rNL//s=;
        b=J/C2GGkqlndESy5Iv13XgeaNXIxtmPrIyw9jg3fiunFymNOWM/wP15YqaaKggsypGy
         5UAktL//7VEcMpVD/DDjv5VEl5iaC4iNBjmOouW/YljbfqvlM/HtbfkgY1PtfcK8fvvx
         yY1DuCbVKMKNvc2GRn+DjDavNtqLivGDoJAg8WzGAzCtb/gRVXBswjTLpAsTizwszcWp
         tILG58wDxw51elZLC5oPrXggWQL9ObPQao4m7TrcRKBcOWIFhBpLsm0CMNe2w3CjBirM
         ojcrYYXw05D2NX+TGmOloyEcmdYmbWwkrnrLfp9Pm2FF8Addkuw97okEQox81kBKdppy
         TFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=axedT4rtG43h/6SvQLH8htjZ6eotsOC4BNVL1rNL//s=;
        b=X06DnVxNmbFnhBAh/OcEe5SgX3B1NvJtrmb1tOrwfiaVu6t/5VrJ/FZyrPuVyTo16B
         wGTdpjZA4gYuf7k11Voe17r72mGs8i4C2YGQFXa0nXibenmVH5rPeyJvEN9XJhe5NHsF
         PaKQPg++T8VVysZ1r523xtGOnagor3fKfPa3DYXDLM8dt96DwyMt8czLMWjwKlUpQcTQ
         B+rrMq1bj72khG/VcBlGc/Q+cUnYHW9ApYp124IddS86Xr1sUpXPzwCMznhXX0FGkuwK
         KavxJUc6dZX94vMHHJPCAk9wCXfECnP7QFiIKwLjldhRZP/lV3TIv3PaSxbJSQg21rcp
         d0OQ==
X-Gm-Message-State: ANoB5plVYs+VTWt0tddPIhFQGRhO3OEBZLkMuls/xB3YGplIHLWveq1a
        w1NFqX5+TcyFhSAvh1gehC2CJw==
X-Google-Smtp-Source: AA0mqf7/227tLAq8XJp7VAX89BClUKXjZS09fJVe1iQQbbj7UnyyxxaMQ0Kdv9zAeq5RikParUtCFA==
X-Received: by 2002:a37:705:0:b0:6fe:c477:2544 with SMTP id 5-20020a370705000000b006fec4772544mr10599706qkh.577.1670455283465;
        Wed, 07 Dec 2022 15:21:23 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id fu24-20020a05622a5d9800b0038b684a1642sm14127831qtb.32.2022.12.07.15.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 15:21:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p33j7-005QoR-Vz;
        Wed, 07 Dec 2022 19:21:21 -0400
Date:   Wed, 7 Dec 2022 19:21:21 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, steven.sistare@oracle.com
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <Y5Ef8Ua2eu00ZbzJ@ziepe.ca>
References: <167044909523.3885870.619291306425395938.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167044909523.3885870.619291306425395938.stgit@omen>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 02:45:18PM -0700, Alex Williamson wrote:
> Fix several loose ends relative to reverting support for vaddr removal
> and update.  Mark feature and ioctl flags as deprecated, restore local
> variable scope in pin pages, remove remaining support in the mapping
> code.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
