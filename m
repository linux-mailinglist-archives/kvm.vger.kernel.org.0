Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F0E6FB911
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 22:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbjEHU6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 16:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbjEHU6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 16:58:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C35198D
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 13:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683579439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PF08ivr9oSEP89wN8+cQKlEYL8DT1MNWzBoIvN2S2Vw=;
        b=MtXhua5EBUoB+9Z4yOWMtXCymf5TFSafkvbY2KSsEJaCB2+LBVeZc8EJHo3Qm96J2N2gwX
        R3iRZ97hdZoYWFwMBfI6c7vzQXINlW4IJxYxkNqpZDLO9VMQ4iATEVlCLraktNTllo9cx4
        PuO7E9K/jaxXeVHrhGSMrIcksfQilfk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-x2p9gZYdN3ulpRj6KBV79g-1; Mon, 08 May 2023 16:57:18 -0400
X-MC-Unique: x2p9gZYdN3ulpRj6KBV79g-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-763997ab8cdso745920039f.2
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 13:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683579437; x=1686171437;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PF08ivr9oSEP89wN8+cQKlEYL8DT1MNWzBoIvN2S2Vw=;
        b=PT5qBIPnQX0TvOQsHlSRZsQDPEne+MD4srqFMfGYPeDTksRI0XEQiDpL0AQGV8S2tv
         xJvE8j0u7ctOQZacfvqWXJqXDHBECd+suL9Vpy5xfmb+P5QxyQnbncMbo4BymmiVYL5N
         tKU4I/ndK7krX1tbWy7CCBXDdKFxC/Z5iw+TKdjIvJJCB8KRg7qC9b64Pv8J8+U8bTt8
         QPVLSs2vTEcLJttozyz8xhGQqR8HqxMluCXKTFt0qiy6TSTZMkbxZo6mtaEHdPrYZaKh
         fPnvJsVeoqJUFvdqFiNZghNi68ZbgUS8SSHcrMpFnd4kEq6Bh02CJGJYgMcjfp9Bq6ct
         EUJg==
X-Gm-Message-State: AC+VfDx388HIYTW/bQXuI0LgXDWxX0DthXv0TZ9h/swTxOaL9wrslach
        Vo8gB6A4+PnE/ZGnbh6nYn5w1pchTDW9+gQGpgwuiLrnhfpsW5VD026sdr5+Wn3T95TTUzyUWX2
        conRjdErE6Y/1H7qDAytA
X-Received: by 2002:a5e:8d13:0:b0:760:d6d2:fa61 with SMTP id m19-20020a5e8d13000000b00760d6d2fa61mr8286934ioj.7.1683579437207;
        Mon, 08 May 2023 13:57:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7YrMvnzexkIVya3O7RAWT/SHW6i9D8O1Nxy6GIXjeV8l8JY5b9qa8AlPCuaTDeX/E2NibREw==
X-Received: by 2002:a5e:8d13:0:b0:760:d6d2:fa61 with SMTP id m19-20020a5e8d13000000b00760d6d2fa61mr8286926ioj.7.1683579436982;
        Mon, 08 May 2023 13:57:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id cc6-20020a056602424600b0076c3189a8d9sm1890274iob.38.2023.05.08.13.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 13:57:16 -0700 (PDT)
Date:   Mon, 8 May 2023 14:57:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.tian@intel.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <20230508145715.630fe3ae.alex.williamson@redhat.com>
In-Reply-To: <ZFkn3q45RUJXMS+P@nvidia.com>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
        <ZFkn3q45RUJXMS+P@nvidia.com>
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

On Mon, 8 May 2023 13:48:30 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, May 08, 2023 at 08:58:42PM +0800, Yan Zhao wrote:
> > In VFIO type1, vaddr_get_pfns() will try fault in MMIO PFNs after
> > pin_user_pages_remote() returns -EFAULT.
> > 
> > follow_fault_pfn
> >  fixup_user_fault
> >   handle_mm_fault
> >    handle_mm_fault
> >     do_fault
> >      do_shared_fault
> >       do_fault
> >        __do_fault
> >         vfio_pci_mmap_fault
> >          io_remap_pfn_range
> >           remap_pfn_range
> >            track_pfn_remap
> >             vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)
> >            remap_pfn_range_notrack
> >             vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)
> > 
> > As io_remap_pfn_range() will call vm_flags_set() to update vm_flags [1],
> > holding of mmap write lock is required.
> > So, update vfio_pci_mmap_fault() to drop mmap read lock and take mmap
> > write lock.
> > 
> > [1] https://lkml.kernel.org/r/20230126193752.297968-3-surenb@google.com
> > commit bc292ab00f6c ("mm: introduce vma->vm_flags wrapper functions")
> > commit 1c71222e5f23
> > ("mm: replace vma->vm_flags direct modifications with modifier calls")
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index a5ab416cf476..5082f89152b3 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -1687,6 +1687,12 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  	struct vfio_pci_mmap_vma *mmap_vma;
> >  	vm_fault_t ret = VM_FAULT_NOPAGE;
> >  
> > +	mmap_assert_locked(vma->vm_mm);
> > +	mmap_read_unlock(vma->vm_mm);
> > +
> > +	if (mmap_write_lock_killable(vma->vm_mm))
> > +		return VM_FAULT_RETRY;  
> 
> Certainly not..
> 
> I'm not sure how to resolve this properly, set the flags in advance?
> 
> The address space conversion?

We already try to set the flags in advance, but there are some
architectural flags like VM_PAT that make that tricky.  Cedric has been
looking at inserting individual pages with vmf_insert_pfn(), but that
incurs a lot more faults and therefore latency vs remapping the entire
vma on fault.  I'm not convinced that we shouldn't just attempt to
remove the fault handler entirely, but I haven't tried it yet to know
what gotchas are down that path.  Thanks,

Alex

