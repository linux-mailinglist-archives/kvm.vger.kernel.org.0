Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5557375B53C
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 19:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjGTRKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 13:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjGTRKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 13:10:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130B41A8;
        Thu, 20 Jul 2023 10:10:12 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b8b2b60731so6107815ad.2;
        Thu, 20 Jul 2023 10:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689873011; x=1690477811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1HxVqm6QdvDEhgAmZIzdUgqN5ps1HBMX/R5gvglFRS0=;
        b=CUnVP2R/iiwpjbeMsc4i4TDFynfvvkqT6gTKNeBxnlIjD9QVmKFoyQlmCLQSsVgHsx
         ToJLqSIN90f+DX3Qt3bR9vNgHXq6l+ZMT2IM9wyUzUoq8aybjTGrUfvhEcuShUyb+uOg
         6PURexEpO0+W5NAO5EtFyc+oaqPmZj+PBstcoltHr3vmblfLuSx7ywg0iqTcOfw/W+6E
         8wUHZBRcgE/pMdncAGE59V8cbSwo0Zhfn9McECy3OsIr9wDqNlOE+e0oNEBYOv8c3ngs
         XFc9ntZZLaP40fqAWQHEBpHVuWt2zLNcWHZE2mJ4ced4F0mvOmmVQ2ZgYYIgD4+FWCCZ
         kuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689873011; x=1690477811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HxVqm6QdvDEhgAmZIzdUgqN5ps1HBMX/R5gvglFRS0=;
        b=kmX1xEJYvi2HdDCby/f+SRkpvhew7pXIR2zXuwcLxBvNxRKlurmUpuyh71aVLyAwFM
         PM1DjN1daUMO7nGwrWxUWlfVfVodavGrQ/nql8MXhQ7o8vW519OzAJ6RufwmVqekVuxC
         o7t4Z8ms1lsrTDVJBObIGv6TYpGy52GElnX/UVMtd/u+zwnwoIrH1LGHsAZ1Q9K6Zjus
         zwu6Sj4nG8+zIYNIBidqL5cAtT7V9CS5zBeV8fU5Cj/7lFBmkKqoGHTTR3OOaw0lfvHQ
         ZjHpctohrlXF1F9n/EDzPzVomZxSowpfK8JHnHDnz6ef/kJITXDDgHbj0U9ausuhiAyd
         mTiQ==
X-Gm-Message-State: ABy/qLa/PyRMl6+ma2dm6aGotLtX1/Oe6y8mPRAwkAWVtTgsWreRFfRV
        yvElEWMizTZixo5wK6ZVirU=
X-Google-Smtp-Source: APBJJlHOAkab/v3d9POXGnLdckzd5EZN9dT9esc/1bexY14zdi9BZbINUWSaPkNsgIiaGCehrtfDWw==
X-Received: by 2002:a17:902:d485:b0:1b2:1b22:196 with SMTP id c5-20020a170902d48500b001b21b220196mr32439plg.48.1689873011077;
        Thu, 20 Jul 2023 10:10:11 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:e754:74d1:c368:67a2])
        by smtp.gmail.com with ESMTPSA id t6-20020a170902a5c600b001b9c5e0393csm1623345plq.225.2023.07.20.10.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 10:10:10 -0700 (PDT)
Date:   Thu, 20 Jul 2023 10:10:07 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Bradescu, Roxana" <roxabee@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] kvm/vfio: avoid bouncing the mutex when adding
 and deleting groups
Message-ID: <ZLlqb8Hk0S3AkEsf@google.com>
References: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
 <20230714224538.404793-2-dmitry.torokhov@gmail.com>
 <BN9PR11MB5276BCE644231C440053AA118C39A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZLd+X7Zcnlq52Tp+@google.com>
 <BN9PR11MB52763F0990CD23DB63AC36578C3EA@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52763F0990CD23DB63AC36578C3EA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 02:36:16AM +0000, Tian, Kevin wrote:
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Sent: Wednesday, July 19, 2023 2:11 PM
> > 
> > On Wed, Jul 19, 2023 at 05:32:27AM +0000, Tian, Kevin wrote:
> > > > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > > Sent: Saturday, July 15, 2023 6:46 AM
> > > >
> > > > @@ -165,30 +161,26 @@ static int kvm_vfio_group_add(struct
> > kvm_device
> > > > *dev, unsigned int fd)
> > > >  	list_for_each_entry(kvg, &kv->group_list, node) {
> > > >  		if (kvg->file == filp) {
> > > >  			ret = -EEXIST;
> > > > -			goto err_unlock;
> > > > +			goto out_unlock;
> > > >  		}
> > > >  	}
> > > >
> > > >  	kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
> > > >  	if (!kvg) {
> > > >  		ret = -ENOMEM;
> > > > -		goto err_unlock;
> > > > +		goto out_unlock;
> > > >  	}
> > > >
> > > > -	kvg->file = filp;
> > > > +	kvg->file = get_file(filp);
> > >
> > > Why is another reference required here?
> > 
> > Because the function now has a single exit point and the original
> > reference is dropped unconditionally on exit. It looks cleaner than
> > checking for non-zero "ret" and deciding whether the reference should be
> > dropped or kept.
> > 
> 
> A comment is appreciated. otherwise,
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thank you for the review! However I do not think any comment is needed,
if one is looking at the final source and not the patch form, the reason
for taking another reference is plain to see.

Thanks!

-- 
Dmitry
