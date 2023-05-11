Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803C66FF6C9
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbjEKQIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 12:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbjEKQIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 12:08:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0525B1BD1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 09:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683821232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5MGlLbnpCq0gqjV9LAs8cLD+kUlHrxgJjrFlgPMgwWE=;
        b=QPcrzxW6D4IfXWRo4IT26a+Cp+Jh8Xem3HAhit1DFK7JkCGUHT2SOyPZOb1+jioWGAUVbO
        EFJ/bb5qCu28WVR5aSctJAY7thI57lMets7FeVVGB9fSHRV7eGEOyHjU01ePsCcp96Ol/r
        Siv98mcw53lWikghthruVLbnkpX6/r4=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-zikvc4nQOLKqFsE8WFGzhg-1; Thu, 11 May 2023 12:07:09 -0400
X-MC-Unique: zikvc4nQOLKqFsE8WFGzhg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-76984376366so1292487939f.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 09:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683821228; x=1686413228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MGlLbnpCq0gqjV9LAs8cLD+kUlHrxgJjrFlgPMgwWE=;
        b=mEAzqA4ViTW7sc0g5csJyIOQuol6fcDlm+IR3HaDCc8nWv5fr3H2+JYJfqr+o90YuR
         ahzGdnaNhMOhXdo7nlMpC8Th+pLboI7Ug3oIe36X/ixf4YB51Qrt69VVBFGNAuWR7q3B
         BwszSRH2lhSo6qKa0vNO7FC/4J6mwB30lJWfctc5texD8d6oJJkDKfjM0SiRnvwD4iYx
         fEdm1WkCuXBleNBIWkfBTTR6tQo/dP9mhcR+rakwqe/17FWDisfFIopHQn9nsvoU69dR
         UTKo+XiuoO1rGZ1mAt+rQUkzwbPBB+EV5l0kzHbryaL1A9a7V75rh+J8Ch28dHqw58xW
         180Q==
X-Gm-Message-State: AC+VfDyqvGrquWyMlBX5At+HN+F8IMe9emS9mQ0OMxm8xdin5d5MBGRg
        LCoqfVhUDOSBbxEPQW5uIC0vowEHUNOlPfbxOtg8jBnj0W2tPmZaLfJQxRKC5iqYKZUFvBY9fNm
        bboHzLBTnKs5H
X-Received: by 2002:a92:d950:0:b0:328:6412:df0e with SMTP id l16-20020a92d950000000b003286412df0emr16457949ilq.29.1683821228644;
        Thu, 11 May 2023 09:07:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7tukUJrVj1wrrpEM6kkFdaC+CQrut3RZr54Ry8cX3nUsKWd1Ny0OxWMK0l+RwvVEhRXnT9IQ==
X-Received: by 2002:a92:d950:0:b0:328:6412:df0e with SMTP id l16-20020a92d950000000b003286412df0emr16457932ilq.29.1683821228395;
        Thu, 11 May 2023 09:07:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id cs11-20020a056638470b00b0040bd3646d0dsm4247854jab.157.2023.05.11.09.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 09:07:07 -0700 (PDT)
Date:   Thu, 11 May 2023 10:07:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.tian@intel.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <20230511100706.63d420db.alex.williamson@redhat.com>
In-Reply-To: <ZFwBYtjL1V0r5WW3@nvidia.com>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
        <ZFkn3q45RUJXMS+P@nvidia.com>
        <20230508145715.630fe3ae.alex.williamson@redhat.com>
        <ZFwBYtjL1V0r5WW3@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 May 2023 17:41:06 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, May 08, 2023 at 02:57:15PM -0600, Alex Williamson wrote:
> 
> > We already try to set the flags in advance, but there are some
> > architectural flags like VM_PAT that make that tricky.  Cedric has been
> > looking at inserting individual pages with vmf_insert_pfn(), but that
> > incurs a lot more faults and therefore latency vs remapping the entire
> > vma on fault.  I'm not convinced that we shouldn't just attempt to
> > remove the fault handler entirely, but I haven't tried it yet to know
> > what gotchas are down that path.  Thanks,  
> 
> I thought we did it like this because there were races otherwise with
> PTE insertion and zapping? I don't remember well anymore.

TBH, I don't recall if we tried a synchronous approach previously.  The
benefit of the faulting approach was that we could track the minimum
set of vmas which are actually making use of the mapping and throw that
tracking list away when zapping.  Without that, we need to add vmas
both on mmap and in vm_ops.open, removing only in vm_ops.close, and
acquire all the proper mm locking for each vma to re-insert the
mappings.

> I vaugely remember the address_space conversion might help remove the
> fault handler?

Yes, this did remove the fault handler entirely, it's (obviously)
dropped off my radar, but perhaps in the interim we could switch to
vmf_insert_pfn() and revive the address space series to eventually
remove the fault handling and vma list altogether.

For reference, I think this was the last posting of the address space
series:

https://lore.kernel.org/all/162818167535.1511194.6614962507750594786.stgit@omen/

Thanks,
Alex

