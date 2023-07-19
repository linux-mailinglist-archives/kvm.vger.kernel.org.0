Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58753758D79
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 08:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjGSGLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 02:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjGSGLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 02:11:04 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C6C1FE7;
        Tue, 18 Jul 2023 23:10:43 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b89bc52cd1so36767765ad.1;
        Tue, 18 Jul 2023 23:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689747043; x=1692339043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pU0qdX1zjclqQ1Al6JJUTxVgam+qJOuCC65TIbBSrT4=;
        b=NrZcGaJpj0rPP53dHrJXfP9oHbhqtB0JXL2v/o6AaAUGaCjZBtpX9+ILoAAPE6j2HA
         Fnojg/SFcXU8Ju6G9dUA8HbReNapA3Ij6F2q8m+2k5LCOf4dQhSSApOcQ/PDz0PuC/ze
         +dIo89neaMj3Wle0NlGTW+iQ6DJY3eMV56Aa00tsNe2VqkHjpSXwqTlua/Dao0E0FZ1s
         G3oVWD100FS9kU6jp4TecfIsaOuZDdRbKCQfFlv+dR8oBaYYc1TeJAtrM6I0kBr1Lnzi
         /6xPtKY5I/TuJYX+Cc36Zqgra/qqnJuvM26AdhWIQ1DQZzXq0LozBBk1eu9wYuWSP4x+
         18nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689747043; x=1692339043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pU0qdX1zjclqQ1Al6JJUTxVgam+qJOuCC65TIbBSrT4=;
        b=Bfq1vnYsAlN8DDXAao4PIAC/osnn5mCRflggSjjYsnov582Ig5BsPfXGTeirIZ6w7V
         /cls8ZEOE96CSpuYFvw1R3PPwN1FtLY1aTduXLEicGnGWMGZ4HIRupoOPJL6o6Jvda32
         vAVobpZbHeFftN942YN6TUD/biyXz6N3uzYNUCBycohbl8sYUg9+kHq9jtePW6eiciab
         xoptR5vSi3cXbHHIjEIpg/uxKNrJG7olI82e17T44lI5dqtAIbBTPDYaJg9cSrku4bmE
         0rOaDNZ8Mhtb5maNgcm0YvglhKakr+fXu8uKkLMo1fQnGP2rsuY8wim1UoW0Kdh6nGNG
         /KkQ==
X-Gm-Message-State: ABy/qLZZKqeVYzyzdlHq/9s3tSbgmVcaHNbEVIRYh683GUMygrb0BeyT
        xg3z1WZPXEQhXMX7NfRQmA4=
X-Google-Smtp-Source: APBJJlGYCBLZ7Iswp6MrmL5lkpOf9RvJdTjI8I2Q5gGYBy7ceH4ltyqe3Z1k9cok6Q2SW1RG3oNz4A==
X-Received: by 2002:a17:902:d382:b0:1b0:f727:bc41 with SMTP id e2-20020a170902d38200b001b0f727bc41mr14917234pld.42.1689747043276;
        Tue, 18 Jul 2023 23:10:43 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:798:b6f:a67a:7ac1])
        by smtp.gmail.com with ESMTPSA id z16-20020a170903019000b001b83dc8649dsm2915121plg.250.2023.07.18.23.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 23:10:42 -0700 (PDT)
Date:   Tue, 18 Jul 2023 23:10:39 -0700
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
Message-ID: <ZLd+X7Zcnlq52Tp+@google.com>
References: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
 <20230714224538.404793-2-dmitry.torokhov@gmail.com>
 <BN9PR11MB5276BCE644231C440053AA118C39A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BCE644231C440053AA118C39A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 05:32:27AM +0000, Tian, Kevin wrote:
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Sent: Saturday, July 15, 2023 6:46 AM
> >
> > @@ -165,30 +161,26 @@ static int kvm_vfio_group_add(struct kvm_device
> > *dev, unsigned int fd)
> >  	list_for_each_entry(kvg, &kv->group_list, node) {
> >  		if (kvg->file == filp) {
> >  			ret = -EEXIST;
> > -			goto err_unlock;
> > +			goto out_unlock;
> >  		}
> >  	}
> > 
> >  	kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
> >  	if (!kvg) {
> >  		ret = -ENOMEM;
> > -		goto err_unlock;
> > +		goto out_unlock;
> >  	}
> > 
> > -	kvg->file = filp;
> > +	kvg->file = get_file(filp);
> 
> Why is another reference required here?

Because the function now has a single exit point and the original
reference is dropped unconditionally on exit. It looks cleaner than
checking for non-zero "ret" and deciding whether the reference should be
dropped or kept.

Thanks.

-- 
Dmitry
