Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD93493EB9
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 18:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353522AbiASRCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 12:02:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243684AbiASRCW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 12:02:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642611741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ahQMiXbH1Jqvjp7e2uPCr+IpogzTLVBiu5OQ3/CX8M=;
        b=izkZB9uUTNky62/HGLUgCGszNWt9Mbwu5ScRjhZ2CQL7Fjrm0jft5pHSuC9zaTipT231Zv
        mTvMf/BpNBmuijxDPQkc/jUfbjFnRwmV4cdoQr1nkV+zZLItYoeoEJNIfMHwhWSaPIDiPs
        oP3wjSjfI2r8dCp1LrVh7i3FAoW5HsQ=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-PFnbcqrnOQeIAEeWLMKeDg-1; Wed, 19 Jan 2022 12:02:20 -0500
X-MC-Unique: PFnbcqrnOQeIAEeWLMKeDg-1
Received: by mail-oi1-f198.google.com with SMTP id o9-20020acaf009000000b002c84fff9098so2076857oih.17
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 09:02:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ahQMiXbH1Jqvjp7e2uPCr+IpogzTLVBiu5OQ3/CX8M=;
        b=rOtT6S02mDHAbZUev/txWRI3g5rec+VZ/mp6Zcv8hUNLgMMn6HIkgRnJbE/IHOYuwc
         AHp7/9z04j7erBRNY9m4fBTwdHMi5WnKDBy1J0P/0KZ6dbUsb2o3kn89S1IdQEPb+lZj
         IsqtZd8ylBTlxzybi+MS4q4bcOQWWJ5VmessZPegHBqnu7JElPwQ1/UzyLZ9z5ghNwqb
         Kj5KsjgXL/dKbEErckpogF4UKXGz3ssxqXarYDUHt6yCHguVIWtFrNvsHaZ34Zhq6IVo
         tBUpuGQNKfoWSUWimh5LR0fGQUDNOuuToWEXYH01llvep2lc6Z4YlfHU/FicZJxMru6V
         4V9w==
X-Gm-Message-State: AOAM5300heAGytQhjp8AcGlrNYtzUnLC1xDbDmSLwQRttc6zcSfElPrT
        Ju+9ZJ/4rZ+SYye6wZcPEnSDM7DO5EFh9lAQorNiXg8RiLxwPHlMLq5VMJnC7MNP2bfFXvlNsmL
        SxY5T4eZQ54ix
X-Received: by 2002:a05:6808:f91:: with SMTP id o17mr2504182oiw.137.1642611738991;
        Wed, 19 Jan 2022 09:02:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz3VPKcnLANIlM3FHHCGcHE6krFWo8OHNhl7zH8DTqLxZLqyvViC1GVid2mIXBMa8Of5BSsmw==
X-Received: by 2002:a05:6808:f91:: with SMTP id o17mr2504159oiw.137.1642611738756;
        Wed, 19 Jan 2022 09:02:18 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y4sm139883oov.32.2022.01.19.09.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 09:02:18 -0800 (PST)
Date:   Wed, 19 Jan 2022 10:02:17 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220119100217.4aee7451.alex.williamson@redhat.com>
In-Reply-To: <20220119163821.GP84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
        <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
        <20220118210048.GG84788@nvidia.com>
        <20220119083222.4dc529a4.alex.williamson@redhat.com>
        <20220119154028.GO84788@nvidia.com>
        <20220119090614.5f67a9e7.alex.williamson@redhat.com>
        <20220119163821.GP84788@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Jan 2022 12:38:21 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jan 19, 2022 at 09:06:14AM -0700, Alex Williamson wrote:
> > On Wed, 19 Jan 2022 11:40:28 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Jan 19, 2022 at 08:32:22AM -0700, Alex Williamson wrote:
> > >   
> > > > If the order was to propose a new FSM uAPI compatible to the existing
> > > > bit definitions without the P2P states, then add a new ioctl and P2P
> > > > states, and require userspace to use the ioctl to validate support for
> > > > those new P2P states, I might be able to swallow that.    
> > > 
> > > That is what this achieves!
> > > 
> > > Are you really asking that we have to redo all the docs/etc again just
> > > to split them slightly differently into patches? What benefit is this
> > > make work to anyone?  
> > 
> > Only if you're really set on trying to claim compatibility with the
> > existing migration sub-type.  The simpler solution is to roll the
> > arc-supported ioctl into this proposal, bump the sub-type to v2 and  
> 
> How about we just order the arc-supported ioctl patch first, then the
> spec revision and include the language about how to use arc-supported
> that is currently in the arc-supported ioctl?
> 
> I'm still completely mystified why you think we need to bump the
> sub-type at all??
> 
> If you insist, but I'd like a good reason because I know it is going
> to hurt a bunch of people out there. ie can you point at something
> that is actually practically incompatible?

I'm equally as mystified who is going to break by bumping the sub-type.
QEMU support is experimental and does not properly handle multiple
devices.  I'm only aware of one proprietary driver that includes
migration code, but afaik it's not supported due to the status of QEMU.

Using a new sub-type allows us an opportunity to update QEMU to fully
support this new uAPI without any baggage to maintain support for the
v1 uAPI or risk breaking unknown users.

Minimally QEMU support needs to be marked non-experimental before I
feel like we're really going to "hurt a bunch of people", so it really
ought not to be an issue to revise support to the new uAPI at the same
time.

If a hypervisor vendor has chosen to run with experimental QEMU
support, it's on them to handle long term support and a transition plan
and I think that's also easier to do when it's clear whether the device
is exposing the original migration uAPI or the updated FSM model with
p2p states and an arc-supported ioctl.  Thanks,

Alex

