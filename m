Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A767A4DE5
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjIRQDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjIRQDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:03:21 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC6F35B5
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:59:33 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3add37de892so683800b6e.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695052524; x=1695657324; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lj5dxmdz31KH6AK++Iu1oSHNEdMOKTOEa8EzHyb8OO4=;
        b=mAlG9Wo/6Yb6wH7+3WDqvnhWL/XgCrNW1T9p+UbWkn80AarYjXlKXSJu7QYprqxN8L
         WiN+0LSjjc8HuN5/rmbhnxCzJYCdPc9Tjyl3FvcIZDG+IfsLmvNLNjWDJYqOXDm81tFD
         ggnV3FsaYH4ukAkmi4bQFYqlkYCHlQC/W5iQp6HOHX/+OBQybRY8YDYxxR44j03Uafkr
         6hmb9phX4yGiIfGLnA6qPVekl48BI9WY0F4loIMd2E68BjAMX79rFXSM/bX2HiOlCX/3
         4Dhx/AlxkK52FrQL5LNipWiPowqnqdvOipxPXatC+kdYZR7mZmrBl+DUexHsKKghKsDf
         v0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695052524; x=1695657324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lj5dxmdz31KH6AK++Iu1oSHNEdMOKTOEa8EzHyb8OO4=;
        b=sbaGmCvQoPAAPZR2SgH0TOg1ajYv49rpw/ulBIMAdz6vwURO4t5P+BceLp6kmMf/O5
         iajlsDO4MjTPe71arwIEPgEz0UwAZ9UnvibDmtMYXVn0yzZ32XWSNfQjBV0f5u01TIOb
         TT8dpwav0X3tV7j2A77S/a1P8wRIwT5Si9WFYqQ8PKx0wohK8SEVPljybZCoRg+yyM/z
         DPs98qU0T1H5lScigjKfbDe+NsdFukULuPW+FSGygX6cysGuzUSrommJSgMYD76OeXn3
         3YNDhUa8xAsJv1kDh2JpjEnwokDWrufJusIVaaCz32fE+l7kEldZUxrAzbdpueiO4Yj6
         oAzQ==
X-Gm-Message-State: AOJu0Yy79XJHamfs2RLWgX6R/KrxiPo01jqgZ6sFxyk8xwFUVR9rFJBK
        nsF5k5S1KfTFb4O5rECEfq7iX+w8tc3hWUuAoDw=
X-Google-Smtp-Source: AGHT+IFNhLbse4fMScsyVGa4C7/zZePvwAGFSXOes1CURAA9QoCkvaC8bU10ioWe6oH7Sby42aFfXg==
X-Received: by 2002:ad4:4110:0:b0:64f:91de:3aab with SMTP id i16-20020ad44110000000b0064f91de3aabmr9453857qvp.29.1695046626845;
        Mon, 18 Sep 2023 07:17:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id w26-20020a0ca81a000000b00655e2005350sm3491584qva.9.2023.09.18.07.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 07:17:06 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiF3h-00054J-Oj;
        Mon, 18 Sep 2023 11:17:05 -0300
Date:   Mon, 18 Sep 2023 11:17:05 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, tglx@linutronix.de, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
Message-ID: <20230918141705.GE13795@ziepe.ca>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914191406.54656-1-shannon.nelson@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 12:14:06PM -0700, Shannon Nelson wrote:
> The new MSI dynamic allocation machinery is great for making the irq
> management more flexible.  It includes caching information about the
> MSI domain which gets reused on each new open of a VFIO fd.  However,
> this causes an issue when the underlying hardware has flexible MSI-x
> configurations, as a changed configuration doesn't get seen between
> new opens, and is only refreshed between PCI unbind/bind cycles.
> 
> In our device we can change the per-VF MSI-x resource allocation
> without the need for rebooting or function reset.  For example,
> 
>   1. Initial power up and kernel boot:
> 	# lspci -s 2e:00.1 -vv | grep MSI-X
> 	        Capabilities: [a0] MSI-X: Enable+ Count=8 Masked-
> 
>   2. Device VF configuration change happens with no reset

Is this an out of tree driver problem?

The intree way to alter the MSI configuration is via
sriov_set_msix_vec_count, and there is only one in-tree driver that
uses it right now.

If something is going wrong here it should be fixed in the
sriov_set_msix_vec_count() machinery, possibly in the pci core to
synchronize the msi_domain view of the world.

Jason
