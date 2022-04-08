Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BD54F9616
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 14:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbiDHMuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 08:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbiDHMua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 08:50:30 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA87996A3
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 05:48:26 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id b33so4659296qkp.13
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 05:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VQDI6YuAr8Eowoco7O858WVzXH3UkvuYAnRhC5A1scM=;
        b=aWdwJeUD/a4zIRed0XxjGwJ74BNKFq4B7EWPMeUNhdeY5dJDzcb3riXc6hBpMpVD5G
         GheWkYvfEpgEmKVdPZECt2I2HbY1Sfm0HOaNxsvQfQFPVYs9y1e5x1QE5V3K8F/n2T2R
         dxMa64HX3TMuHD/uIKXUgWlm5hAY1L9/dt29oPX2IKpwwjh7lZ6exu/d0DeikubO2po1
         A6AuK8MDLCkex64rjVBcdClMdJtIU6d8+B+bA0IaFnCox9kDbXi9Y33pd4zKQ76MizSb
         hDu71MPFRVq0bUGbopVKGwnusYQ5foX2jGOXKyTkRm8CUSsZqFdud7vzMSNPBsNjiFOv
         HOtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VQDI6YuAr8Eowoco7O858WVzXH3UkvuYAnRhC5A1scM=;
        b=aQENhPOxghI+bSQHqVgzPKMPkYgRsUQyMtrJOPRKTN1CiY56JwiA/bCBSbHADuZOrL
         Fnnp1c8GvzzTGnm+wqMMDMIqcZDwhx6uHxwVlQhLDs4xgpk6togB8wd5xi1Dq674cWCi
         wyiOFgjyEw/18K7fFyvuDoCy9rmzOGW+xSs+b+jgXWb7jDV2mNwMz75+WLhxeKdKN150
         3FQr9cj5hhocobiUu4XEwq7bjjBle2l6wKDimZ751trKfwqW77T5hRLt8dafPo9eEq7k
         yLjKCUQYW4w8grvMO7e9GeDEWR0Tls6S+mslMnYNyEGeeotM2AqZ3TOX4KGRwJPmcDtA
         6TMQ==
X-Gm-Message-State: AOAM533TL0GlYPOmR6PUUBzpqnQzR9gQpETvyw/PvGE+Ujt9HU6cmcfK
        5OjCc7C61K+IaY/kcUSV/RvOsw==
X-Google-Smtp-Source: ABdhPJwTiOGFNTDsV2ncSsHyu47DcJ64QqNfBV6JNjBfrtkBcDpHD2Er+HjU3PwNrV5kQJVKAriQBw==
X-Received: by 2002:a05:620a:bce:b0:662:e587:fbbf with SMTP id s14-20020a05620a0bce00b00662e587fbbfmr12558832qki.757.1649422105456;
        Fri, 08 Apr 2022 05:48:25 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id v3-20020a05622a014300b002e1dcd4cfa9sm18777436qtw.64.2022.04.08.05.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 05:48:24 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nco2K-00Eytz-9H; Fri, 08 Apr 2022 09:48:24 -0300
Date:   Fri, 8 Apr 2022 09:48:24 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 14/21] KVM: s390: pci: provide routines for
 enabling/disabling interrupt forwarding
Message-ID: <20220408124824.GZ64706@ziepe.ca>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-15-mjrosato@linux.ibm.com>
 <9a551f04c3878ecb3a26fed6aff2834fbfe41f18.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a551f04c3878ecb3a26fed6aff2834fbfe41f18.camel@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022 at 03:39:19PM +0200, Niklas Schnelle wrote:
> On Mon, 2022-04-04 at 13:43 -0400, Matthew Rosato wrote:
> > These routines will be wired into a kvm ioctl in order to respond to
> > requests to enable / disable a device for Adapter Event Notifications /
> > Adapter Interuption Forwarding.
> > 
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >  arch/s390/kvm/pci.c      | 247 +++++++++++++++++++++++++++++++++++++++
> >  arch/s390/kvm/pci.h      |   1 +
> >  arch/s390/pci/pci_insn.c |   1 +
> >  3 files changed, 249 insertions(+)
> > 
> > diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> > index 01bd8a2f503b..f0fd68569a9d 100644
> > +++ b/arch/s390/kvm/pci.c
> > @@ -11,6 +11,7 @@
> >  #include <linux/pci.h>
> >  #include <asm/pci.h>
> >  #include <asm/pci_insn.h>
> > +#include <asm/pci_io.h>
> >  #include "pci.h"
> >  
> >  struct zpci_aift *aift;
> > @@ -152,6 +153,252 @@ int kvm_s390_pci_aen_init(u8 nisc)
> >  	return rc;
> >  }
> >  
> > +/* Modify PCI: Register floating adapter interruption forwarding */
> > +static int kvm_zpci_set_airq(struct zpci_dev *zdev)
> > +{
> > +	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_REG_INT);
> > +	struct zpci_fib fib = {};
> 
> Hmm this one uses '{}' as initializer while all current callers of
> zpci_mod_fc() use '{0}'. As far as I know the empty braces are a GNU
> extension so should work for the kernel but for consistency I'd go with
> '{0}' or possibly '{.foo = bar, ...}' where that is more readable.
> There too uninitialized fields will be set to 0. Unless of course there
> is a conflicting KVM convention that I don't know about.

{} is not a GNU extension, it is the preferred way to write it.

The standard has a weird distinction between {} and {0} that results
in different behavior.

Jason
