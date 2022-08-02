Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2DF588092
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiHBQ6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiHBQ6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:58:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CD7A1DA5F
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659459479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Sf7xaFUIqQVtpLiuiI2Kns8z145D4xmx0GqEdCs7Ts=;
        b=g1u5W4fFAuhontCUnqN6VPakeG7eQYRYJHj7USuDY8fU4cd/4dA7feNjCIfRDPs36irDmz
        PCqxV181oq+TKXGBI8q0aLVWffMukhmHkzJ43KBQ+dVcaaf+srGDSvo1+RS7dXeJ1nqkHg
        0jiazBBxJq/BnFFbxXg/XBU4cOHlPho=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-EuWPRNsXNBKFoygEmW1J_A-1; Tue, 02 Aug 2022 12:57:58 -0400
X-MC-Unique: EuWPRNsXNBKFoygEmW1J_A-1
Received: by mail-il1-f199.google.com with SMTP id g8-20020a92cda8000000b002dcbd57f808so8941126ild.4
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 09:57:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/Sf7xaFUIqQVtpLiuiI2Kns8z145D4xmx0GqEdCs7Ts=;
        b=ZXoRs04t8gSNxId6jobRzebkwYF4S2vzuJF+kvmfvYhVFH1fB5zCPh82V6M97PckWk
         lnb17c1LLPeY4kD65XjmlRM0HyK7PHlSb4lyHLx5zr2tyJbL6tT6J2OgQqVFeqZEDC5Q
         28GXBJdbAIp1/TLEuWXthp5UpJkUl2qfUT60xG5V1wE7erKiD7+ADwhQmA0EL4IxMwLX
         Qe5eqJw65MUxAxMvZq/z8UUzyJlP0JoAPV/H+6Qkn/i5W/KDX7AdB8VtNp/sdEhL0Gwr
         2Q9XiYM1p802DjD/Rt+UYWXXig/MBUK5bd+Nj0OIUERmlTYTKN0nt+I5n5NbhczeDFZj
         AI5g==
X-Gm-Message-State: ACgBeo2BD5UfvqymW/EJbLc4l405Gxk8jM+9bKPWxj+1lDaJ1KBM4fsa
        jZap2oJ/NxO36bfbaioJBShRft+2DCysfomEokWW6rCBEZhDw1OMuidrAhnNC/rCVBtAFR8xAFL
        cSBKcSSl9/vLb
X-Received: by 2002:a6b:e718:0:b0:67b:e58e:62b5 with SMTP id b24-20020a6be718000000b0067be58e62b5mr1327077ioh.211.1659459477642;
        Tue, 02 Aug 2022 09:57:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7SM1Fo83pmOnXeawObkD2CKYJwTzQpO19H6onptGimabnX3ve2O1kmOgR36aceuJ0ijGx7JQ==
X-Received: by 2002:a6b:e718:0:b0:67b:e58e:62b5 with SMTP id b24-20020a6be718000000b0067be58e62b5mr1327066ioh.211.1659459477432;
        Tue, 02 Aug 2022 09:57:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s6-20020a02c506000000b0033ca8eb3736sm6620480jam.167.2022.08.02.09.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 09:57:57 -0700 (PDT)
Date:   Tue, 2 Aug 2022 10:57:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
Message-ID: <20220802105755.2ee80696.alex.williamson@redhat.com>
In-Reply-To: <YulSOK+YKjV2634b@nvidia.com>
References: <20220719121523.21396-2-abhsahu@nvidia.com>
        <20220721163445.49d15daf.alex.williamson@redhat.com>
        <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
        <20220725160928.43a17560.alex.williamson@redhat.com>
        <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
        <20220726172356.GH4438@nvidia.com>
        <f903e2b9-f85b-a4c8-4706-f463919723a3@nvidia.com>
        <20220801124253.11c24d91.alex.williamson@redhat.com>
        <YukvBBClrbCbIitm@nvidia.com>
        <20220802094128.38fba103.alex.williamson@redhat.com>
        <YulSOK+YKjV2634b@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Aug 2022 13:35:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Aug 02, 2022 at 09:41:28AM -0600, Alex Williamson wrote:
> 
> > The subtlety is that there's a flag and a field and the flag can only
> > be set if the field is set, the flag can only be clear if the field is
> > clear, so we return -EINVAL for the other cases?  Why do we have both a
> > flag and a field?  This isn't like we're adding a feature later and the
> > flag needs to indicate that the field is present and valid.  It's just
> > not a very clean interface, imo.  Thanks,  
> 
> That isn't how I read Abhishek's proposal.. The eventfd should always
> work and should always behave as described "The notification through
> the provided eventfd will be generated only when the device has
> entered and is resumed from a low power state"
> 
> If userspace provides it without LOW_POWER_REENTERY_DISABLE then it
> still generates the events.
> 
> The linkage to LOW_POWER_REENTERY_DISABLE is only that userspace
> probably needs to use both elements together to generate the
> auto-reentry behavior. Kernel should not enforce it.
> 
> Two fields, orthogonal behaviors.

What's the point of notifying userspace that the device was resumed if
it might already be suspended again by the time userspace responds to
the eventfd?  This really muddies the single-shot vs re-entrant
behavior.  If userspace allows the kernel to re-enter low power, then
they don't need to be notified on every wake.  If userspace wants to be
notified on wake, userspace can also re-initiate low power entry.
Thanks,

Alex

