Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0795AB873
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 20:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiIBSnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 14:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiIBSnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 14:43:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4899A1144D5
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 11:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662144183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xmufxSBBQcTrd+3JoNDIyWVS1rtnXN5eoVt7O6zwIMA=;
        b=BMcmt9jSYcKiOftx0eUdMIWMpHivWMNu4atDX9ZYifq+fXUkezOq3/NdroQqvxqocb8QAO
        YBvTSVrqJKpc+LanoBlBz2o0OBmfmzjY11Di3dJ3qsj9tdHfeUuru6L5SD16NLAgKP/sfg
        VLl7cfUxEiW8X7JJObAV6plyJnwsEc8=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-372-6YCjE0OMPUucQPmtJIPAMw-1; Fri, 02 Sep 2022 14:43:02 -0400
X-MC-Unique: 6YCjE0OMPUucQPmtJIPAMw-1
Received: by mail-io1-f72.google.com with SMTP id p8-20020a5d9848000000b0068e97cc84b1so1824500ios.23
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 11:43:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=xmufxSBBQcTrd+3JoNDIyWVS1rtnXN5eoVt7O6zwIMA=;
        b=VuCwOOeiDbECGNBDvc/VCtR+UOE6ug6ZuuCaVYKpv4qkJEacxIBoC59UbDzbjZCFjh
         8JeqlYPER/pw70liP9BzyJUR1FG2IrIFX1j1QxBb0gtYz/OnYWOAOVZYjdP5xTT14WAT
         KpRdq81+TFtnGJ3Vo2cWhsP6SciAhnbQM4EcnRsV41WFaPwz6KxgLrBumo/cHvGKEbdC
         LHJArc3mj/v+bhQKBN+z0T3UchoF1tCwxDC9NVX8SbGjByOnzgE7ksk/VcyijtV/CgKq
         tGscqId+S3NTONECNAz7wLywHepZgdPli+97Wbz2vEDlpKVaHGjeoJBS/faA0eg1Yvh3
         8qng==
X-Gm-Message-State: ACgBeo085hDdb9J7+DfLgb0ss1PTm2YCU81/KXaU/+WGEYiZtbnkuAc4
        DMw0s2X1TRuDp3o3eDSNTYDC0Dg9v5eoHj7F6VKB4iWrcgfFSSnwAkU0frXdBQn3Fq0fyyjCMKI
        jDVz9QO7V1vSA
X-Received: by 2002:a02:93e1:0:b0:33f:1c51:3fee with SMTP id z88-20020a0293e1000000b0033f1c513feemr19483528jah.171.1662144181530;
        Fri, 02 Sep 2022 11:43:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6hPjY1pvVSyxZCMjoW6U6N6RRRlysGUzoVjaEowCMXe5gwI63Fs6zQbU0ECABhmJgD8Jx6RA==
X-Received: by 2002:a02:93e1:0:b0:33f:1c51:3fee with SMTP id z88-20020a0293e1000000b0033f1c513feemr19483516jah.171.1662144181220;
        Fri, 02 Sep 2022 11:43:01 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x6-20020a056602160600b0067b7a057ee8sm1126680iow.25.2022.09.02.11.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 11:43:00 -0700 (PDT)
Date:   Fri, 2 Sep 2022 12:42:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v2 0/8] Break up ioctl dispatch functions to one
 function per ioctl
Message-ID: <20220902124233.662b83b5.alex.williamson@redhat.com>
In-Reply-To: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
References: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Aug 2022 17:15:55 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Move ioctl dispatch functions for the group FD and PCI to follow a common
> pattern:
> 
>  - One function per ioctl
>  - Function name has 'ioctl' in it
>  - Function takes in a __user pointer of the correct type
> 
> At least PCI has grown its single ioctl function to over 500 lines and
> needs splitting. Group is split up in the same style to make some coming
> patches more understandable.
> 
> This is based on the "Remove private items from linux/vfio_pci_core.h"
> series as it has a minor conflict with it.
> 
> v2:

Applied to vfio next branch for v6.1.  Thanks,

Alex

