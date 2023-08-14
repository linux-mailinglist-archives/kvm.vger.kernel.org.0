Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE0777BF3B
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 19:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjHNRrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 13:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjHNRr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 13:47:26 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D72F10DD
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:47:25 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-56dfe5ce871so1572747eaf.2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1692035244; x=1692640044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/yNh4F2KqOT+gKhbfMAb20rsFiF8tD3IHTN/BfkK/o=;
        b=Nnz1d6Q95SoJZqyUmSGv/mULK+qIzASlvU7AAxuOXr7Ap6igT/sLL3+gSSpHpkoB9d
         nq0FRws0EU8HEIf/UAzptDEUWGEE34uxX7M7wdemum4vt+i8XK0yjWpnP6k6RLQOlYca
         dPoCaU+Az0Ez4ogVRalWR9rBLicAI0FE3KQlaJxmfFUU4xsacst0OFvU4PfESdDv6C0v
         rfdVU0Y3kbPD1Wx43UulHldGLfwHHgUYZeqWz8Gin+PoN2qtQ0YA5Zq2OVexuPN5Afyl
         oUMNjZX2i9gx+2K9cvLivBoiioPUR77MotF6WQlXmHva4gC2yxzxZ617LoiIvIfsnM8b
         F1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692035244; x=1692640044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/yNh4F2KqOT+gKhbfMAb20rsFiF8tD3IHTN/BfkK/o=;
        b=FC5NO3Z00q12eVyFtCZyDOH8gEZZabB9Ay3odCUbzHtF9xtyCI8gcmwMsgInn+gBsP
         /LGvucjtf/tzzue7CD5EL4RI0DnYAttHkggdE6XEYFloeU0vDG8deLhyuuP72dyrBBzx
         +v+4qSB/Sva2a/hJd0DCVTCFwPT3gPDoCyCesGDdCO1XWTzwkepWIA/xW+GMyqLgBhpq
         WstGRyTlukmHP5zmgy6EUmmzENzoO4Dsmh0kWhUZDV5L9hTUeENxU+JZ8F7dMGJcXtgy
         XYbwO/yCLQT2F/ZRkAXCVfFGU+zSE5Dz/GoQ8N7T39r5SSCPMRARo+yG0ZQdUddue3k9
         bS0A==
X-Gm-Message-State: AOJu0Yy3pcr8tEJe8hkm9cVaEi+gtCLvwWiZiFWBz7+oeLXSrZcSsMm0
        OBrkFHXIyrHj+RvNAiW7LAh4iQ==
X-Google-Smtp-Source: AGHT+IHKtophzNepnrOSKqJW2gtkKecjEJCHZKJbB96GaU/SIQr5jKKtpBh+9NCgIHhPr2b3svWbtQ==
X-Received: by 2002:a05:6358:c15:b0:129:c477:289c with SMTP id f21-20020a0563580c1500b00129c477289cmr8037336rwj.26.1692035244459;
        Mon, 14 Aug 2023 10:47:24 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id 11-20020ac8564b000000b003ef189ffa82sm3228482qtt.90.2023.08.14.10.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 10:47:23 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qVbf1-0070BL-2Q;
        Mon, 14 Aug 2023 14:47:23 -0300
Date:   Mon, 14 Aug 2023 14:47:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 1/4] vfio: trivially use __aligned_u64 for ioctl structs
Message-ID: <ZNpoq7emI19fApND@ziepe.ca>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-2-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809210248.2898981-2-stefanha@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 05:02:45PM -0400, Stefan Hajnoczi wrote:
> u64 alignment behaves differently depending on the architecture and so
> <uapi/linux/types.h> offers __aligned_u64 to achieve consistent behavior
> in kernel<->userspace ABIs.
> 
> There are structs in <uapi/linux/vfio.h> that can trivially be updated
> to __aligned_u64 because the struct sizes are multiples of 8 bytes.
> There is no change in memory layout on any CPU architecture and
> therefore this change is safe.
> 
> The commits that follow this one handle the trickier cases where
> explanation about ABI breakage is necessary.
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  include/uapi/linux/vfio.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
