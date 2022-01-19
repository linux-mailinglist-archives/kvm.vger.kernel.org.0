Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BEB493DEF
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 17:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356028AbiASQGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 11:06:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237164AbiASQGT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 11:06:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642608378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dym7CtyyerhummccxKV1mfvGjmrgBZCrTIdM3qhOC1M=;
        b=SFoJQMwvZAnUVjn2dHDwWdKXi8bejuoIkV+8xHRZ/GEJOt/HkfWiK/kjjtA321ehmATdCu
        k2WUID12cmQeajit1ihoxDx3y9xKXLLN12wdGcuI3DvBlYS5IuGshiMUEjvvgSnhNVxu+S
        o7519nrEVO60m8fih+L4rtZEscUsuoU=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-g_gGmkU9N9u1Ujhk0Mtc-Q-1; Wed, 19 Jan 2022 11:06:17 -0500
X-MC-Unique: g_gGmkU9N9u1Ujhk0Mtc-Q-1
Received: by mail-ot1-f70.google.com with SMTP id v21-20020a05683018d500b00590a3479c4eso1728945ote.11
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:06:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dym7CtyyerhummccxKV1mfvGjmrgBZCrTIdM3qhOC1M=;
        b=mtX10VBkEUHBM8eZtk6P5mUp58pckItaZ/QFvQ2jkZtdnbTIAMsSPJpwqf4hvID+s/
         SW4sidbCk+UFVYXKKa6lpIa5oIXNil6iu3XAOPVAB0Sxz74hxow1LKUfcc1hoXuwBxvK
         VIC11sO7KBzbJXgLDR7+KmVUtd3CTQp5BkVIuJEQuXbkRARg38+lpXxHnfS95NFqMayH
         bwisGTkyOzG04QlfLnpgazTlouQtvfFj7zkHkg1p7fnPjzbm+SYD0Bcl9Ql+i6mLeR+H
         SvXrfwQxc1EyU3EY75SFXoILBoKQj9LjWMF0cXyNsu7SmnmFTldh9irzKxleS0IFgZE6
         w/lA==
X-Gm-Message-State: AOAM532f5DGl8C0L97gs9OI9VzxgneOOrjNrFi1DjtBsDTYjoElyptR5
        fDSY5S9G7h6V0ptlolzv2I4P4ciUs6VHTcURjeJEJ+J1ksmyZoK6aI779ubeWrmlEhF7MD74kzK
        mPH4k6XVG42kH
X-Received: by 2002:a9d:ea6:: with SMTP id 35mr25098028otj.304.1642608376746;
        Wed, 19 Jan 2022 08:06:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzc7qSkVTxDYipMdp/uD4dST+vXIvHVcS1EVuIoh5E0YVVKCbDcyp8yCdHn/bekIvmMyobnrg==
X-Received: by 2002:a9d:ea6:: with SMTP id 35mr25098010otj.304.1642608376449;
        Wed, 19 Jan 2022 08:06:16 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p11sm116100oiv.17.2022.01.19.08.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 08:06:16 -0800 (PST)
Date:   Wed, 19 Jan 2022 09:06:14 -0700
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
Message-ID: <20220119090614.5f67a9e7.alex.williamson@redhat.com>
In-Reply-To: <20220119154028.GO84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
        <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
        <20220118210048.GG84788@nvidia.com>
        <20220119083222.4dc529a4.alex.williamson@redhat.com>
        <20220119154028.GO84788@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Jan 2022 11:40:28 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jan 19, 2022 at 08:32:22AM -0700, Alex Williamson wrote:
> 
> > If the order was to propose a new FSM uAPI compatible to the existing
> > bit definitions without the P2P states, then add a new ioctl and P2P
> > states, and require userspace to use the ioctl to validate support for
> > those new P2P states, I might be able to swallow that.  
> 
> That is what this achieves!
> 
> Are you really asking that we have to redo all the docs/etc again just
> to split them slightly differently into patches? What benefit is this
> make work to anyone?

Only if you're really set on trying to claim compatibility with the
existing migration sub-type.  The simpler solution is to roll the
arc-supported ioctl into this proposal, bump the sub-type to v2 and
define the v2 uAPI to require this ioctl.  The proposal presented here
does not stand on it's own, it requires the new ioctl.  Those new p2p
states are not really usable without the ioctl.  Seems like we're just
expecting well behaved userspace to ignore them as presented in this
stand alone RFC.  Thanks,

Alex

