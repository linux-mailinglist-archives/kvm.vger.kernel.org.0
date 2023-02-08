Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1117F68FA5A
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 23:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjBHWoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 17:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjBHWoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 17:44:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2FB1A94B
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 14:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675896194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0DGnMsd6uzzMNKUzgtHw1et4SDPC0G9pBMtrAjEIfwU=;
        b=EpbtnpV9fft+GEOoIWaGhsRdxSvyyshHt7Y5u2mH7+DI0CFZms0OGSvxNepi5S5pfyaBvC
        Cqmv45pVBF2hRIT3fk9cgLPoAe1xho+q0iJTQpHyWVX79731BPTx3XLP9bO72P3mt9ilbH
        iIBSr7rQTqGx2o6JxLt/Enoe4Vc10lc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-418-8xelV4vDOYW3FwMEBfAEMw-1; Wed, 08 Feb 2023 17:43:12 -0500
X-MC-Unique: 8xelV4vDOYW3FwMEBfAEMw-1
Received: by mail-il1-f199.google.com with SMTP id o12-20020a056e02068c00b00313fe7757dbso230254ils.13
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 14:43:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0DGnMsd6uzzMNKUzgtHw1et4SDPC0G9pBMtrAjEIfwU=;
        b=HhicB1YN2STvChSKvyZVCd0FDY8GIteN9s4rsz2JFN3CmSVcoZWZ6bp5l7gH25eWMe
         Ic8KWYU3uCCxCFSmVLoyHrUY1j+WQYOAgD1w0J59wMeNJDjB9A56qi8aO5wznm+2RqWZ
         1NknNmcbbmZSczWFMfZnXru5NSI1GATVvX1AxXxCs1EFdEQJRmZ0mZmF4pmqMRb8+qqN
         0wLzEXiAUEhwl8hzvA3pNaJgWhab9F9rlsS6sayZ0iKXdMNEVgxtuIpqlzJy5EJbHuDu
         +9KKY7pfgSsSImIRjuaMqEeTHwfZWxU9GNZ6vYaitlomhojbrZ421mKTflanw6K00sSJ
         askw==
X-Gm-Message-State: AO0yUKXo7bcawXzNn5+AQgLEev8URpt3vSVthol9pkTCAM4Wn7tFVgX3
        23dxlSZyqdCM3dyvqBV6QfRuFA5lLUhsLqJSkJq7td7vMm+5jsoFInxbLtdC1WXoLOL8oe9ZHd4
        AzWDLTIQeDZs0
X-Received: by 2002:a6b:e306:0:b0:717:6e2d:34f0 with SMTP id u6-20020a6be306000000b007176e2d34f0mr7300717ioc.11.1675896191833;
        Wed, 08 Feb 2023 14:43:11 -0800 (PST)
X-Google-Smtp-Source: AK7set+9d+V9ot2flKn6Eg5HaBZz5uBMAMoUDOPuVHHG8Sz+1kwRf1cbBK0Z6arIAG22OWYn2EoG0A==
X-Received: by 2002:a6b:e306:0:b0:717:6e2d:34f0 with SMTP id u6-20020a6be306000000b007176e2d34f0mr7300699ioc.11.1675896191593;
        Wed, 08 Feb 2023 14:43:11 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p1-20020a0566380e8100b003bf35a3cc3bsm4240532jas.85.2023.02.08.14.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 14:43:10 -0800 (PST)
Date:   Wed, 8 Feb 2023 15:43:09 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Seunggyun Lee <sglee97@dankook.ac.kr>, bhelgaas@google.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] pci/mmap: add pci device EBUSY check
Message-ID: <20230208154309.2bd82a15.alex.williamson@redhat.com>
In-Reply-To: <20230208221010.GA2489371@bhelgaas>
References: <20230207113949.17943-1-sglee97@dankook.ac.kr>
        <20230208221010.GA2489371@bhelgaas>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Feb 2023 16:10:10 -0600
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc VFIO folks, Leon]
> 
> On Tue, Feb 07, 2023 at 08:39:49PM +0900, Seunggyun Lee wrote:
> > When using a pci device through the vfio-pci driver, other software was
> > also able to access the pci device memory through sysfs.
> > 
> > To prevent this, when mmap is performed through sysfs, a process of
> > checking whether the device is in use is added.
> > 
> > Signed-off-by: Seunggyun Lee <sglee97@dankook.ac.kr>
> > ---
> >  drivers/pci/mmap.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
> > index 4504039056d1..4c9df2e23e03 100644
> > --- a/drivers/pci/mmap.c
> > +++ b/drivers/pci/mmap.c
> > @@ -25,6 +25,8 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
> >  {
> >  	unsigned long size;
> >  	int ret;
> > +	if (pdev->driver)

Maintain the blank line after variable declarations.

> > +		return -1;

Surely there's a better errno value for this.

> >  
> >  	size = ((pci_resource_len(pdev, bar) - 1) >> PAGE_SHIFT) + 1;
> >  	if (vma->vm_pgoff + vma_pages(vma) > size)

Regardless of the above, what's the point of this?  There are already
checks for LOCKDOWN_PCI_ACCESS in the sysfs and proc interfaces to this
function, so we can already activate restrictions to protect this
scenario via kernel config, kernel cmdline options, or runtime with
securityfs.  This is redundant and a blanket restriction as implemented
here seems liable to break some obscure use case.  Thanks,

Alex

