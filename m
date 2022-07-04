Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693C3564DA6
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 08:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiGDGWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 02:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiGDGWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 02:22:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82E8D6377
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 23:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656915733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w4yN5Zty763Hq+nXi9QxVE0HKoTohjtCixEdlzzySCo=;
        b=h3lsq+Xq4IIZOZtHsYN6DX07wJofeyn0GurRN/ONoKaUyJv/uV1b3j5BGsHn+e7hKLnt8Y
        jxUMQ2nAmdnAd+adx8o+TXbzBRR3xNaaf80KJZ5ROIeqImeGOa+8N4GPqDM181h1o3MgDv
        emRst/WxSToSZ3Zzb35t1QgGLStSrdI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-v3YM6NJVMYOiZ-tDU55pVA-1; Mon, 04 Jul 2022 02:22:12 -0400
X-MC-Unique: v3YM6NJVMYOiZ-tDU55pVA-1
Received: by mail-wm1-f69.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so3657928wmr.0
        for <kvm@vger.kernel.org>; Sun, 03 Jul 2022 23:22:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w4yN5Zty763Hq+nXi9QxVE0HKoTohjtCixEdlzzySCo=;
        b=uB2CQSjZo5w54AMhomXSaRLezVel1Nz1eLdCMlCvnc1eDbUndj+AE+E9iEkYbzLmDg
         cQmErJdOebVhfm9hFSfOU+m5JzqFwJnbK8lLL/aMJ90xBenmq/ucsxqDTyoKL0awcv3o
         KGLjHIcovpqzGX7L6+ASmEoUbm2M4F+l58cYYfenMF+GgqTAlEy6hytnw22/eC+obNYt
         +67d8qHZHr0j4lf+247rBrKlP8Y9Xw+6IG4sTrx3PqOaV0b87o1IeGZOfxnuecsV8vV8
         sBC1w0B7ZLs9qpuOyZqnIHeXEscvNQ8Li2fvp7UnMCmZZ6/lgKCZpgGzGHb/l0l/8371
         7arA==
X-Gm-Message-State: AJIora9z8JcBlpHZc7buxhRxOTQGj+CfY8MtcN8Rgnr0p/z3IMEB46Qy
        Y5fak4KLPG/2yy61diYNG3dkJ3kmu2GIRmr3g/wdtvI6++IM4szM3rnN8/IX8P0pT3NeVDG26MI
        Mhbrp6Imc3W4I
X-Received: by 2002:a5d:4387:0:b0:21d:6983:13fc with SMTP id i7-20020a5d4387000000b0021d698313fcmr3928709wrq.696.1656915730996;
        Sun, 03 Jul 2022 23:22:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v5n38T2ZOszfGvZ5G4OUbtnwwbSZSx7PamIw2e0xfqqOoITQOPCURZq3WhZI490y8B9npKeQ==
X-Received: by 2002:a5d:4387:0:b0:21d:6983:13fc with SMTP id i7-20020a5d4387000000b0021d698313fcmr3928689wrq.696.1656915730781;
        Sun, 03 Jul 2022 23:22:10 -0700 (PDT)
Received: from redhat.com ([2.55.3.188])
        by smtp.gmail.com with ESMTPSA id g3-20020a05600c140300b0039c96b97359sm18771641wmi.37.2022.07.03.23.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 23:22:09 -0700 (PDT)
Date:   Mon, 4 Jul 2022 02:22:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
Message-ID: <20220704021950-mutt-send-email-mst@kernel.org>
References: <CACGkMEsC4A+3WejLSOZoH3enXtai=+JyRNbxcpzK4vODYzhaFw@mail.gmail.com>
 <CACGkMEvu0D0XD7udz0ebVjNM0h5+K9Rjd-5ed=PY_+-aduzG2g@mail.gmail.com>
 <20220629022223-mutt-send-email-mst@kernel.org>
 <CACGkMEuwvzkbPUSFueCOjit7pRJ81v3-W3SZD+7jQJN8btEFdg@mail.gmail.com>
 <20220629030600-mutt-send-email-mst@kernel.org>
 <CACGkMEvnUj622FyROUftifSB47wytPg0YAdVO7fdRQmCE+WuBg@mail.gmail.com>
 <20220629044514-mutt-send-email-mst@kernel.org>
 <CACGkMEsW02a1LeiWwUgHfVmDEnC8i49h1L7qHmeoLyJyRS6-zA@mail.gmail.com>
 <20220630043219-mutt-send-email-mst@kernel.org>
 <CACGkMEtgnHDEUOHQxqUFn2ngOpUGcVu4NSQBqfYYZRMPA2H2LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtgnHDEUOHQxqUFn2ngOpUGcVu4NSQBqfYYZRMPA2H2LQ@mail.gmail.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 12:23:27PM +0800, Jason Wang wrote:
> > So if there are not examples of callbacks not ready after kick
> > then let us block callbacks until first kick. That is my idea.
> 
> Ok, let me try. I need to drain my queue of fixes first.
> 
> Thanks

If we do find issues, another option is blocking callbacks until the
first add. A bit higher overhead as add is a more common operation
but it has even less of a chance to introduce regressions.

> >
> >
> > > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > >I couldn't ... except maybe bluetooth
> > > > > > > > > > > but that's just maintainer nacking fixes saying he'll fix it
> > > > > > > > > > > his way ...
> > > > > > > > > > >
> > > > > > > > > > > > And during remove(), we get another window:
> > > > > > > > > > > >
> > > > > > > > > > > > subsysrem_unregistration()
> > > > > > > > > > > > /* the window */
> > > > > > > > > > > > virtio_device_reset()
> > > > > > > > > > >
> > > > > > > > > > > Same here.
> > > > > > > > >
> > > > > > > > > Basically for the drivers that set driver_ok before registration,
> > > > > > > >
> > > > > > > > I don't see what does driver_ok have to do with it.
> > > > > > >
> > > > > > > I meant for those driver, in probe they do()
> > > > > > >
> > > > > > > virtio_device_ready()
> > > > > > > subsystem_register()
> > > > > > >
> > > > > > > In remove() they do
> > > > > > >
> > > > > > > subsystem_unregister()
> > > > > > > virtio_device_reset()
> > > > > > >
> > > > > > > for symmetry
> > > > > >
> > > > > > Let's leave remove alone for now. I am close to 100% sure we have *lots*
> > > > > > of issues around it, but while probe is unavoidable remove can be
> > > > > > avoided by blocking hotplug.
> > > > >
> > > > > Unbind can trigger this path as well.
> > > > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > > > so
> > > > > > > > > we have a lot:
> > > > > > > > >
> > > > > > > > > blk, net, mac80211_hwsim, scsi, vsock, bt, crypto, gpio, gpu, i2c,
> > > > > > > > > iommu, caif, pmem, input, mem
> > > > > > > > >
> > > > > > > > > So I think there's no easy way to harden the notification without
> > > > > > > > > auditing the driver one by one (especially considering the driver may
> > > > > > > > > use bh or workqueue). The problem is the notification hardening
> > > > > > > > > depends on a correct or race-free probe/remove. So we need to fix the
> > > > > > > > > issues in probe/remove then do the hardening on the notification.
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > >
> > > > > > > > So if drivers kick but are not ready to get callbacks then let's fix
> > > > > > > > that first of all, these are racy with existing qemu even ignoring
> > > > > > > > spec compliance.
> > > > > > >
> > > > > > > Yes, (the patches I've posted so far exist even with a well-behaved device).
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > > patches you posted deal with DRIVER_OK spec compliance.
> > > > > > I do not see patches for kicks before callbacks are ready to run.
> > > > >
> > > > > Yes.
> > > > >
> > > > > Thanks
> > > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > --
> > > > > > > > MST
> > > > > > > >
> > > > > >
> > > >
> >

