Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A032BBE70
	for <lists+kvm@lfdr.de>; Sat, 21 Nov 2020 11:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgKUKQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Nov 2020 05:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbgKUKQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Nov 2020 05:16:25 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1D0C0613CF;
        Sat, 21 Nov 2020 02:16:25 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id j14so11278045ots.1;
        Sat, 21 Nov 2020 02:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CfD4qCQ+49oMsxdJc7IK/6WOEpohcQtenHzH8FlfyRE=;
        b=JF3p/OCNodcLdDTJcqO7kRZDP5iwZv+x0xXQK41LiD+SZKTO1SnD9F9TC3ONOFKuZG
         U4kABs3ZPIz7naEfwag/JiTvqG/9+wKV3HIQM/JyXRXZbLmnr9VNbqi6La5leghgCv9w
         TsG6VVC+LRSJW222Wda3AxWmLqjBK2bKcBCkoqvrKE2qLqoz1EGwEU5hPuDEqagSt5iA
         5GZdeoJmodruZrfdZjri+bhkm7p/XQP78OfvW0H3afh1XJQlnJl6JCYE84SwDTPFNinm
         50CwSd9Ln5buo9sziidETyMtEhq6hsXmLswyKqfmg3EGTVLJAjzxlfk7jIDsfMipzhuo
         xcsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CfD4qCQ+49oMsxdJc7IK/6WOEpohcQtenHzH8FlfyRE=;
        b=SB3gkbxUnuvQCp9+2rJgeCxJx/kEXHIjybwvk44exEDgReoeb0hd/pP+lbks3YFQsH
         8JuTo+qMFIwHwHq6iEaBwwdpdyAkRUyKhfU9ZLyvpSV7oh/loGlzqfYc2JWX4MnkI1RU
         PqN2sgCltPs28Tv0Ptt4ev92YGpmZQ54agkcVd3nl8ejLjWcRByyBk9jW7HLNnten+se
         /01ZC1sV0wHlYWY7vdmUuHWoPabkqul1FVVIQIhL9w6RMGP/PCu8Tk9cFdsV8MWKpkOl
         87giozbO2ZWm1GXi90R3SkZVWYyxOIL5p4MLzON7q/enFFA/Ofv37DH1rthA5jgIQsgT
         cjLA==
X-Gm-Message-State: AOAM531P4u7LZJX/qimnsC3FUfyldSzvuU/Kv4ZsCXlaqXHMhWcdh/kx
        ofA2zirhRtKZ5A8JeIbjIoRb4m1JDhxwFHIXiQc=
X-Google-Smtp-Source: ABdhPJwbWqIY6E2BNtMA32fQAIHCjlUN6aHKKi/wWDD0jzHnOSkXJPtriY6z17kkUPmnf3jQjaq/XzOLnrNEouBrIQ0=
X-Received: by 2002:a05:6830:210a:: with SMTP id i10mr16558234otc.145.1605953785126;
 Sat, 21 Nov 2020 02:16:25 -0800 (PST)
MIME-Version: 1.0
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch> <20201119144146.1045202-5-daniel.vetter@ffwll.ch>
In-Reply-To: <20201119144146.1045202-5-daniel.vetter@ffwll.ch>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Sat, 21 Nov 2020 12:15:58 +0200
Message-ID: <CAFCwf12vUjaUAKYYnXSOFeB_yYzjnChNSWyx+FopGXS0W-1rGQ@mail.gmail.com>
Subject: Re: [PATCH v6 04/17] misc/habana: Use FOLL_LONGTERM for userptr
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Omer Shpigelman <oshpigelman@habana.ai>,
        Ofir Bitton <obitton@habana.ai>,
        Tomer Tayar <ttayar@habana.ai>,
        Moti Haimovski <mhaimovski@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Piskorski <ppiskorski@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 19, 2020 at 4:41 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrot=
e:
>
> These are persistent, not just for the duration of a dma operation.
>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Oded Gabbay <oded.gabbay@gmail.com>
> Cc: Omer Shpigelman <oshpigelman@habana.ai>
> Cc: Ofir Bitton <obitton@habana.ai>
> Cc: Tomer Tayar <ttayar@habana.ai>
> Cc: Moti Haimovski <mhaimovski@habana.ai>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Pawel Piskorski <ppiskorski@habana.ai>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/misc/habanalabs/common/memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/haban=
alabs/common/memory.c
> index 0b220221873d..d08c41b90fec 100644
> --- a/drivers/misc/habanalabs/common/memory.c
> +++ b/drivers/misc/habanalabs/common/memory.c
> @@ -1298,7 +1298,8 @@ static int get_user_memory(struct hl_device *hdev, =
u64 addr, u64 size,
>                 return -ENOMEM;
>         }
>
> -       rc =3D pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE=
,
> +       rc =3D pin_user_pages_fast(start, npages,
> +                                FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
>                                  userptr->pages);
>
>         if (rc !=3D npages) {
> --
> 2.29.2
>

This patch and the previous one (03/17 misc/habana: Stop using
frame_vector helpers) are both:
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>

Thanks,
Oded
