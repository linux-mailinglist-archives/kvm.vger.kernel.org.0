Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0FF617025
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiKBWAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKBV76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 17:59:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7827E003
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667426335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=19jAwIpz25mwhFPQXkoppeGvWvIpF/x47prNgyjimyE=;
        b=BI+GGbTYeNsi1ZH2K/6+3tgGbMWHCAAFFR+qffe8Nr0N34iMIRbNO5EK49s4Unzj7/WYuT
        yGlaczHgdP6z9ZW5KUO6whijHe7FqD3CdBMSMxj+ixeMWQll0bQJAcTtz6Uh4EVGNLjQdf
        sL5wd4FCXfr1MKPtCVaAJtXoMNfc0I0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-106-5RCDTmjtM7KhJGjL3ZgxjA-1; Wed, 02 Nov 2022 17:58:54 -0400
X-MC-Unique: 5RCDTmjtM7KhJGjL3ZgxjA-1
Received: by mail-il1-f200.google.com with SMTP id j7-20020a056e02154700b003007885e7beso204478ilu.20
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 14:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=19jAwIpz25mwhFPQXkoppeGvWvIpF/x47prNgyjimyE=;
        b=Vgs+ZE73GQ9NaJMN4AW8VBT03QFfQ8lQwTvNicMsrfq8hZvOrY+YQFXJJDYNkEHwpn
         Tzg17OzS5BpGqhfSSQZO7u4vJiDzcC7jCP9tKEHjgrK5IsnHRnxdkHPE7Rwcz3h39KwQ
         pLWV/iNaXqiouP7OwXKB6kYs+YNJQWtOFeuQtvf4PYzsRpcbvzczDB8wAtVjHXpIPFC7
         bLi6hHTxAjHKVxJc2rqLsVFB0szRG3QofHhDrUAim6Pke6JFLleUihCucffUz1GUgAdo
         DBIMpGg2PxEHFSyx3EklXX4Ok0IPWjekWwXtdgvrnqa7+Md+ReHxFTPuUAhZqYCAyIFG
         AtVA==
X-Gm-Message-State: ACrzQf08IHxE4T8lPQVfEcQtQaC7uV8ZXQeuTCiCbSH+qjYWGrE5YEAO
        jgit95iBc4SdlkNBj4FE7Oy1EeWtNNijbgzDz5KDfUru5xT73d6pDp05QHaMXEfMurxlA/wSmbw
        4TOo1MO3CsvZY
X-Received: by 2002:a92:ca07:0:b0:2fa:ad2a:cd4c with SMTP id j7-20020a92ca07000000b002faad2acd4cmr16089253ils.292.1667426333620;
        Wed, 02 Nov 2022 14:58:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5dmswFcGZVPd7FynLZuU25I7XELgnvq1kGCPuVlRNq3vtiq4su1jgHneL5/uAlkRlVy4x+2w==
X-Received: by 2002:a92:ca07:0:b0:2fa:ad2a:cd4c with SMTP id j7-20020a92ca07000000b002faad2acd4cmr16089244ils.292.1667426333375;
        Wed, 02 Nov 2022 14:58:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r17-20020a056638045100b003743cc92b27sm5207589jap.157.2022.11.02.14.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 14:58:52 -0700 (PDT)
Date:   Wed, 2 Nov 2022 15:58:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: Re: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
Message-ID: <20221102155851.2d19978e.alex.williamson@redhat.com>
In-Reply-To: <CAKkLME3bR++sWFusGdxohD3ZCgBDj7rjsjMZs=RvaYYfaJskng@mail.gmail.com>
References: <20221026194245.1769-1-ajderossi@gmail.com>
        <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
        <Y2EFLVYwWumB9JbL@ziepe.ca>
        <CAKkLME3bR++sWFusGdxohD3ZCgBDj7rjsjMZs=RvaYYfaJskng@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Nov 2022 06:14:24 +0000
Anthony DeRossi <ajderossi@gmail.com> wrote:

> On Tue, Nov 1, 2022 at 11:38 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > I've been meaning to take a deeper look, but I'm thinking vfio_pci
> > doesn't need open_count at all any more.  
> 
> I spent some time looking at it, but I'm not very familiar with this
> area.
> 
> None of the fields in vfio_pci_core_device look usable as a substitute
> for open_count, but calling pci_is_enabled() on the PCI device might be
> sufficient. pci_enable_device()/pci_disable_device() appear to be called
> in the right locations in vfio_pci_core.

I think that could work too, but of course it's PCI specific.  If we
had a vfio core helper to get the open count for the device set, that
would make it more universally available.  Thanks,

Alex

