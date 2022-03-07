Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F084D0B47
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 23:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343819AbiCGWkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 17:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236084AbiCGWkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 17:40:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3946457B9
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 14:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646692795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJJnjNEDLDCxgTnNZiuLduAW9RdSuGCDd7yDQswPSHQ=;
        b=XjYpj5w0WyYp59YoxpO90KpD2P4RXY749mo/qsLlPgajXgarGewhuTmLV1JEmXh0VAFJl4
        VORHKlaLQ6i/6P0xTYCi6O3UjP475+kRXTxTcN6K/ALlK118xx0ypCjY6YMr4UKbNFSwTd
        +OiXSHHUxkQZMsTrYT2ON6oCAQlkdRc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609--3mJ3mUcMOazpaVPHAQ9lQ-1; Mon, 07 Mar 2022 17:39:54 -0500
X-MC-Unique: -3mJ3mUcMOazpaVPHAQ9lQ-1
Received: by mail-ed1-f71.google.com with SMTP id i5-20020a056402054500b00415ce7443f4so8525127edx.12
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 14:39:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oJJnjNEDLDCxgTnNZiuLduAW9RdSuGCDd7yDQswPSHQ=;
        b=nGOJ8bePQsjZ3zSigRr1PeJ2S0Fw+hiR645wgzwxKfKk2Z4LBpEou5t0xWYg2z+qUS
         5G/CzpBOlCtubHJBaMCF3UTp0+RCfvw9FUovw25IpOI6jDkcxw0STfbFkKTMeBjdR9Ac
         AJ6uMUV06JfT5TZKc9f2aTTQdClGTzCKCHM90GaQ3Ybe5AgHYlLpfR/j1ZupY30+BSSc
         GKjcUhFt9uaKNVHJYXXmjexLsgIbdmROkHTQ2Csb3o83OhIEvWqrnOE52neuuD9wb5ms
         sZHHP4/OWbIwv+k3/5h15FZpz+yn90otilGl4+VAu112ymhXFjG4wVCM0yB3m1KWDTkV
         z4Rg==
X-Gm-Message-State: AOAM530oVPiqZap2fyUqu+Vcr4zY9TYtoMxikLQmFA/mtGmb6Z3Cxfrj
        d40+iSUZpbvM+qI+loawDKT/7xBP/SM2g3a5D5QjeJi0ZuGk25tQAt6JhMJcMulMz41LIiLEhRQ
        bMgslSqE2wQ7N
X-Received: by 2002:a50:f68b:0:b0:415:a36c:5c0b with SMTP id d11-20020a50f68b000000b00415a36c5c0bmr13019184edn.272.1646692791965;
        Mon, 07 Mar 2022 14:39:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHmg2BC0xk8nWy9xaqU2GCk4lH6furT6guufXi8TPI/KI61k1O7Q5pN2MxtI0peMXSX0VM9Q==
X-Received: by 2002:a50:f68b:0:b0:415:a36c:5c0b with SMTP id d11-20020a50f68b000000b00415a36c5c0bmr13019168edn.272.1646692791770;
        Mon, 07 Mar 2022 14:39:51 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id gf17-20020a170906e21100b006da960ce78dsm4913346ejb.59.2022.03.07.14.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:39:51 -0800 (PST)
Date:   Mon, 7 Mar 2022 17:39:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220307173807-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiZeB7l49KC2Y5Gz@kroah.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 07, 2022 at 08:33:27PM +0100, Greg KH wrote:
> On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> > 
> > Also WARN() as a precautionary measure.  The purpose of this is to
> > capture possible future race conditions which may pop up over time.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > 
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/vhost/vhost.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 59edb5a1ffe28..ef7e371e3e649 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >  	int i;
> >  
> >  	for (i = 0; i < dev->nvqs; ++i) {
> > +		/* No workers should run here by design. However, races have
> > +		 * previously occurred where drivers have been unable to flush
> > +		 * all work properly prior to clean-up.  Without a successful
> > +		 * flush the guest will malfunction, but avoiding host memory
> > +		 * corruption in those cases does seem preferable.
> > +		 */
> > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> 
> So you are trading one syzbot triggered issue for another one in the
> future?  :)
> 
> If this ever can happen, handle it, but don't log it with a WARN_ON() as
> that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> you want that to happen?
> 
> And what happens if the mutex is locked _RIGHT_ after you checked it?
> You still have a race...
> 
> thanks,
> 
> greg k-h

Well it's a symptom of a kernel bug. I guess people with panic on
warn are not worried about DOS and more worried about integrity
and security ... am I right?

-- 
MST

