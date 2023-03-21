Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E246C3BE3
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 21:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCUUeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 16:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCUUd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 16:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B477EC
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 13:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679430781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3SoZAa/8xF1VxHMtjBD+X/WJ+O7TFOveLIe/Nw8esJs=;
        b=MRjPiEFl8ezAoiYAyhnhV+Jm8fUKCS2uJ7RNpkhDeGYKyuNOzzMNZ4i9Y77YWXnJem1YZt
        gBuLcGCDeD9S4KhrKqGoVtKZHyzx+Z+JBPIt+qAq5WGOgKA73mbsBiT+XhNSzTTAPmHf5h
        tvVXjfvtXFyJ7qyR0M6paFKzPSWM+PU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-plD77xZdMYGc9NCJU9NIxA-1; Tue, 21 Mar 2023 16:31:26 -0400
X-MC-Unique: plD77xZdMYGc9NCJU9NIxA-1
Received: by mail-io1-f69.google.com with SMTP id f15-20020a05660215cf00b00752dd002fd1so8279300iow.3
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 13:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679430686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3SoZAa/8xF1VxHMtjBD+X/WJ+O7TFOveLIe/Nw8esJs=;
        b=wYClmbIolFz3EiZnxSyPJFJXsWmolOSlXq6O8HJ/YvM7r7T4bKO0GKPFSLVzEN/Esq
         KFJnmV6m4FEpZh01WRbCxdFtqTwzOHBXAGky685Vy+FdakE74OnwI92C623BOIKrBjHQ
         lBUfypAE0xh+KuQG0GSN736qGiYNteGq/yCy++xThAJaZIBz5eTKBqft4FlXXmUl/tk+
         I1YmA5k02s2ODe7n+3l+NWc8JB+tiX2IVBlI3UUJ58K+7ljQFMDnAvDa+oyOvTvYQ+My
         Hso3X9VJW7lfmmjruLj3i91T1qUTnqgGPzVt/LOvhNeNAgiMr6qldufTMcD8JekCb9Ga
         x5Ng==
X-Gm-Message-State: AO0yUKX0dJMVro2Mc/O/dGGZZJCA1O12ZFVGzFtc+wwCqJUEfMfR8XVC
        RS+tRdKEDbB6nZajRJk7E27VuVM8w1klMo80LNzejof/qLpcILBgAsXpyfp1sRUSz0imRBPLHHZ
        PXapvnKn7xdHs
X-Received: by 2002:a92:c503:0:b0:323:2c83:3064 with SMTP id r3-20020a92c503000000b003232c833064mr2697672ilg.31.1679430685843;
        Tue, 21 Mar 2023 13:31:25 -0700 (PDT)
X-Google-Smtp-Source: AK7set8RsLy22yUQqFdiRovisP4m8BeCD6yBQhPuFmJnLrNBzHBGAk/zi9QQ6dulBCbOIg4UjodPLA==
X-Received: by 2002:a92:c503:0:b0:323:2c83:3064 with SMTP id r3-20020a92c503000000b003232c833064mr2697633ilg.31.1679430685539;
        Tue, 21 Mar 2023 13:31:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id dl9-20020a056638278900b004051a7ef7f3sm4305251jab.71.2023.03.21.13.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 13:31:24 -0700 (PDT)
Date:   Tue, 21 Mar 2023 14:31:22 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array
 in VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <20230321143122.632f7e63.alex.williamson@redhat.com>
In-Reply-To: <ZBjum1wQ1L2AIfhB@nvidia.com>
References: <20230308132903.465159-13-yi.l.liu@intel.com>
        <20230315165311.01f32bfe.alex.williamson@redhat.com>
        <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230316124532.30839a94.alex.williamson@redhat.com>
        <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230316182256.6659bbbd.alex.williamson@redhat.com>
        <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230317091557.196638a6.alex.williamson@redhat.com>
        <ZBiUiEC8Xj9sOphr@nvidia.com>
        <20230320165217.5b1019a4.alex.williamson@redhat.com>
        <ZBjum1wQ1L2AIfhB@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Mar 2023 20:39:07 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Mar 20, 2023 at 04:52:17PM -0600, Alex Williamson wrote:
> 
> > > The APIs are well defined and userspace can always use them wrong. It
> > > doesn't need to call RESET_INFO even today, it can just trivially pass
> > > every group FD it owns to meet the security check.  
> > 
> > That's not actually true, in order to avoid arbitrarily large buffers
> > from the user, the ioctl won't accept an array greater than the number
> > of devices affected by the reset.  
> 
> Oh yuk!
> 
> > > It is much simpler if VFIO_DEVICE_PCI_HOT_RESET can pass the security
> > > check without code marshalling fds, which is why we went this
> > > direction.  
> > 
> > I agree that nullifying the arg makes the ioctl easier to use, but my
> > hesitation is whether it makes it more difficult to use correctly,
> > which includes resetting devices unexpectedly.  
> 
> I don't think it makes it harder to use correctly. It maybe makes it
> easier to misuse, but IMHO not too much.
> 
> If the desire was to have an API that explicitly acknowledged the
> reset scope then it should have taken in a list of device FDs and
> optimally reset all of them or fail EPERM.
> 
> What is going to make this hard to use is the _INFO IOCTL, it returns
> basically the BDF string, but I think we effectively get rid of this
> in the new model. libvirt will know the BDF and open the cdev, then fd
> pass the cdev to qemu. Qemu shouldn't also have to know the sysfs
> path..
> 
> So we really want a new _INFO ioctl to make this easier to use..

I think this makes it even worse.  If userspace cannot match BDFs from
the _INFO ioctl to devices files, for proof of ownership or scope, then
the answer is clearly not "get rid of the device files".

> > We can always blame the developer for using an interface incorrectly,
> > but if we make it easier to use incorrectly in order to optimize
> > something that doesn't need to be optimized, does that make it a good
> > choice for the uAPI?  
> 
> IMHO the API is designed around a security proof. Present some groups
> and a subset of devices in those groups will be reset. You can't know
> the subset unless you do the _INFO thing.
> 
> If we wanted it to be clearly linked to scope it should have taken in
> a list of device FDs, and reset those devices FDs optimally or
> returned -EPERM. Then the reset scope is very clearly connected to the
> API.

This just seems like nit-picking that the API could have accomplished
this more concisely.  Probably that's true, but I think you've
identified a gap above that amplifies the issue.  If the user cannot
map BDFs to cdevs because the cdevs are passed as open fds to the user
driver, the _INFO results become meaningless and by removing the fds
array, that becomes the obvious choice that a user presented with this
dilemma would take.  We're skipping past easier to misuse, difficult to
use correctly, and circling around no obvious way to use correctly.

Unfortunately the _INFO ioctl does presume that userspace knows the BDF
to device mappings today, so if we are attempting to pre-enable a case
with cdev support where that is not the case, then there must be
something done with the _INFO ioctl to provide scope.  Thanks,

Alex

