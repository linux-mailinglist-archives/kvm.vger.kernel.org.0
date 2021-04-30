Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2906D36FF63
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 19:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhD3RWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 13:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3RWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 13:22:48 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEBCC06174A
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 10:21:59 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 66so31885524qkf.2
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 10:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+9rWhtzunmITNkfQzgdQCvmwXrSdrc+GU3FyMI5Hcyk=;
        b=EO7uIkj+DIIyYver4/uR9iKguEwe43MR0FbmUqyFoMGO9d2WeaJbu1oleFdgjXajqd
         6rXN5RjAcXefjtyDJBpDAxijTgOvGr5AqIwM+1+Ss4hYgCRmLwsNVd5UJ77uXKeBTCIy
         tIZ3hpUoCn9tnUvQILPwq+fYrqHYlFNSjZCUwAqvPUr/V9xDq75fMJnbt+V8iR0py5Ss
         c3zxEyg5OqDjaS7gmDGUK2/Ag3wCIrUpJzlS6CK1k64zKP9shiDXVlfJOunNCBVCwJTB
         rm6IMuy+BJkv2z8wfGmw153J1vZE25ijxlQ8ant3UDvOSm+owaN/C6mP3zoiBFQ903Ut
         40/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+9rWhtzunmITNkfQzgdQCvmwXrSdrc+GU3FyMI5Hcyk=;
        b=UBNxEe18JLR+KWc93DPApN9SkhfHUPxSJ03ag0PAC5DKs8qecVzCEV7+6BzANLB0ti
         X/0RU8zKzXUwtYdgJeB210m2i0gpn7XdFpEXQpx6AC/3F1JE7zjbYUMIfdQQ3gdJctfE
         Y02U2AoNQo3a2lCDuWFtO2s5XDGGc+3/UzeEY4vQ4t/EZtKnBKYJExEqBY/nPfZfxuDx
         V26G3NUK5YmD6L4TMTX5sRlG0H4QEDhM2g6GiU1U8PQcl4ghuNIU//CozRakNF8Y7Nzk
         RT0TMa2sidbcfmQgqc6hl705hyapbSLO4RD+u50JuLz4YK51GPWONIFgbxBEfFyY++3S
         wxnQ==
X-Gm-Message-State: AOAM532pVKg2C63Tag4HtLABg8HPKWGYCuqDlyiug55DvpzAUBOtThBK
        x21qojp84/z4RszCmRAsHKEMCejV/jYIhDjC
X-Google-Smtp-Source: ABdhPJwkx9QpWa1xfdqzrQaKUH3PAUfZfzMWr5ByRllKLVC+0yrOcnaLbCpzYtDtGQbDKooEe+5HUg==
X-Received: by 2002:a37:a315:: with SMTP id m21mr6659955qke.106.1619803318922;
        Fri, 30 Apr 2021 10:21:58 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id o23sm1935582qka.16.2021.04.30.10.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 10:21:58 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lcWpx-00F0Op-9s; Fri, 30 Apr 2021 14:21:57 -0300
Date:   Fri, 30 Apr 2021 14:21:57 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] vfio/mdev: remove unnecessary NULL check in
 mbochs_create()
Message-ID: <20210430172157.GY2047089@ziepe.ca>
References: <20210429095327.GY1981@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429095327.GY1981@kadam>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 12:53:27PM +0300, Dan Carpenter wrote:
> Originally "type" could be NULL and these checks were required, but we
> recently changed how "type" is assigned and that's no longer the case.
> Now "type" points to an element in the middle of a non-NULL array.
> 
> Removing the checks does not affect runtime at all, but it makes the
> code a little bit simpler to read.
> 
> Fixes: 3d3a360e570616 ("vfio/mbochs: Use mdev_get_type_group_id()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Update the commit message
> 
>  samples/vfio-mdev/mbochs.c | 2 --
>  samples/vfio-mdev/mdpy.c | 3 +--
>  2 files changed, 1 insertion(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

There are problably several of these code removal oversights.

Thanks,
Jason
