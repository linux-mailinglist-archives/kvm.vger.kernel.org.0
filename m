Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166047B6D0D
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 17:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjJCP1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 11:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjJCP1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 11:27:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EDEAB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 08:27:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4321CC433C7;
        Tue,  3 Oct 2023 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696346861;
        bh=zvhtwQEt0J0fH9rgJYn3rsSiY1LehpRMhyqhElHbbWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rx+9OxKVexfBBb8YEEW7EA07U73mZapsv/VwQYYwOxOEs2jBcPqa7SryHOOlG04oQ
         eWEIBSz53L8s8cEBlxncmLBEaOjBcdl4VJTSHvaSV4CnF5iczi25T8Z4XNfXzg9ZNh
         Z/VYNO0Uip9mRJD6YqUmpNB1zGeUNV2EeV8fX2uplr3RfQbs82UHqb/Gx5gz1h4oah
         LB2yD4f5ETrgqVWA8eJTurOqLl4vfMV+i1HGXjnJnjpR7IbEBuwP3q6OjyDNfatzej
         FKSxcDIHYjavcI75zmHCKUxP/pQeiILdFRkGkBeEtdSHen8QhEOU7+kznLx7G5YHyV
         P0/im2ArVYgOw==
Date:   Tue, 3 Oct 2023 08:27:39 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc:     nipun.gupta@amd.com, nikhil.agarwal@amd.com,
        alex.williamson@redhat.com, ndesaulniers@google.com,
        trix@redhat.com, shubham.rohila@amd.com, kvm@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
Message-ID: <20231003152739.GB63187@dev-arch.thelio-3990X>
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
 <1fbe8877-aaa5-1b6f-e18c-1d231a31d2e7@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1fbe8877-aaa5-1b6f-e18c-1d231a31d2e7@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023 at 09:40:02AM +0200, Philippe Mathieu-Daudé wrote:
> Hi Nathan,
> 
> On 2/10/23 19:53, Nathan Chancellor wrote:
> > When building with clang, there is a warning (or error with
> > CONFIG_WERROR=y) due to a bitwise AND and logical NOT in
> > vfio_cdx_bm_ctrl():
> > 
> >    drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
> >       77 |         if (!vdev->flags & BME_SUPPORT)
> >          |             ^            ~
> >    drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to evaluate the bitwise operator first
> >       77 |         if (!vdev->flags & BME_SUPPORT)
> >          |             ^
> >          |              (                        )
> >    drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand side expression to silence this warning
> >       77 |         if (!vdev->flags & BME_SUPPORT)
> >          |             ^
> >          |             (           )
> >    1 error generated.
> > 
> > Add the parentheses as suggested in the first note, which is clearly
> > what was intended here.
> > 
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
> > Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support")
> 
> My current /master points to commit ce36c8b14987 which doesn't include
> 8a97ab9b8b31, so maybe this can be squashed / reordered in the VFIO tree
> (where I assume this commit is). That said, the fix is correct, so:

Yes, this is a -next only issue at the moment and I don't mind this
change being squashed into the original if Alex rebases his tree (some
maintainers don't).

> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Thanks a lot for taking a look!

Cheers,
Nathan

> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >   drivers/vfio/cdx/main.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> > index a437630be354..a63744302b5e 100644
> > --- a/drivers/vfio/cdx/main.c
> > +++ b/drivers/vfio/cdx/main.c
> > @@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
> >   	struct vfio_device_feature_bus_master ops;
> >   	int ret;
> > -	if (!vdev->flags & BME_SUPPORT)
> > +	if (!(vdev->flags & BME_SUPPORT))
> >   		return -ENOTTY;
> >   	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
> > 
> > ---
> > base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
> > change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278
> > 
> > Best regards,
> 
