Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972C74CA920
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 16:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiCBPfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 10:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiCBPf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 10:35:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1799CC6262
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 07:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646235285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QGFEqUfF08Ay8YfxfHzxFFjx43+q2fu6XbpJ32ujXXg=;
        b=cRPbjuz4ayzbKtaJBVHhnbELJXTakdKrWzGEeMDvnEtJjobm4eoNebAK2RsAHNslfFaXrF
        18U0alctB7l4umai6WaLo72rbN/JeddlBsePiD5jqd6D36Yh7EJhgnd0r6FY8ayCci8my9
        Rb84OH50116VJEc3/G6I4Xn4IYQpkDQ=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221--SuDklpHO0WPvYA14KXInA-1; Wed, 02 Mar 2022 10:34:44 -0500
X-MC-Unique: -SuDklpHO0WPvYA14KXInA-1
Received: by mail-oi1-f200.google.com with SMTP id bh17-20020a056808181100b002d4f3396ec3so1232512oib.9
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 07:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QGFEqUfF08Ay8YfxfHzxFFjx43+q2fu6XbpJ32ujXXg=;
        b=iWHv3l9W76PlkP9murZwx/z70+Dg6qJqtR3UfZIsYXDkWl0cWY7hWUi9II2SCcnWtf
         TL+6pynjIOXZX4chSowWiMbIG1pwBR8vWG/vnDMrd1Qx15YwJo6wD49R3pirklEviFj6
         k6Vm1Ir3Hgydf0naFClFlvf9xtIloTpceTlKqyjiQKVsu3nK+wnptGbi3Zq5U3/jR5Jn
         5elEoz6IBX6N9pLXUlJ7sQ1/Pe/RCIU+8JBkPZ9uW9ELNKQEVrCSIM96YfqJA+hWqo15
         NETcEWsSgCTnAwz3Gl0l5rfe4XB3xyq1LmMEKI7QNdRCSSW476SCP2FBEPSeca5QakUO
         wQoA==
X-Gm-Message-State: AOAM530vfgdto4ajMvCWxD0u+bBOpMsMsQDNTnVhRF/2p+V484yin2v/
        3RfLw2O8R6pnfB3q9TJx1ulrIjXeyYucCM7RJSAI9IgQU/WDQBQrwzJE2WWNBcKj4s2v4II4qg9
        ht5XP75+LEIvd
X-Received: by 2002:a9d:64d2:0:b0:5a4:44c:1e76 with SMTP id n18-20020a9d64d2000000b005a4044c1e76mr16173656otl.324.1646235283223;
        Wed, 02 Mar 2022 07:34:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFL7AIz+XMoO0pSy0ljQcZTQYiU1hM7aen/H7PCgOUAQayBKEf+UxF/GZqjnBMxmMJL8tbTw==
X-Received: by 2002:a9d:64d2:0:b0:5a4:44c:1e76 with SMTP id n18-20020a9d64d2000000b005a4044c1e76mr16173643otl.324.1646235283005;
        Wed, 02 Mar 2022 07:34:43 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l34-20020a9d1ca2000000b005acea92e8absm8053452ota.42.2022.03.02.07.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 07:34:42 -0800 (PST)
Date:   Wed, 2 Mar 2022 08:34:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Message-ID: <20220302083440.539a1f33.alex.williamson@redhat.com>
In-Reply-To: <20220302142732.GK219866@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
        <20220224142024.147653-10-yishaih@nvidia.com>
        <87tucgiouf.fsf@redhat.com>
        <20220302142732.GK219866@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Mar 2022 10:27:32 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Mar 02, 2022 at 12:19:20PM +0100, Cornelia Huck wrote:
> > > +/*
> > > + * vfio_mig_get_next_state - Compute the next step in the FSM
> > > + * @cur_fsm - The current state the device is in
> > > + * @new_fsm - The target state to reach
> > > + * @next_fsm - Pointer to the next step to get to new_fsm
> > > + *
> > > + * Return 0 upon success, otherwise -errno
> > > + * Upon success the next step in the state progression between cur_fsm and
> > > + * new_fsm will be set in next_fsm.  
> > 
> > What about non-success? Can the caller make any assumption about
> > next_fsm in that case? Because...  
> 
> I checked both mlx5 and acc, both properly ignore the next_fsm value
> on error. This oddness aros when Alex asked to return an errno instead
> of the state value.

Right, my assertion was that only the driver itself should be able to
transition to the ERROR state.  vfio_mig_get_next_state() should never
advise the driver to go to the error state, it can only report that a
transition is invalid.  The driver may stay in the current state if an
error occurs here, which is why we added the ability to get the device
state.  Thanks,

Alex

> > > + * any -> ERROR
> > > + *   ERROR cannot be specified as a device state, however any transition request
> > > + *   can be failed with an errno return and may then move the device_state into
> > > + *   ERROR. In this case the device was unable to execute the requested arc and
> > > + *   was also unable to restore the device to any valid device_state.
> > > + *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
> > > + *   device_state back to RUNNING.  
> > 
> > ...this seems to indicate that not moving into STATE_ERROR is an
> > option anyway.   
> 
> Yes, but it is never done by vfio_mig_get_next_state() it is only
> directly triggered inside the driver.
> 
> > Do we need any extra guidance in the description for
> > vfio_mig_get_next_state()?  
> 
> I think no, it is typical in linux that function failure means output
> arguments are not valid
> 
> Jason
> 

