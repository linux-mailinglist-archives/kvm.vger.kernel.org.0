Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FCE7A5698
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 02:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjISAdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 20:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjISAc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 20:32:59 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EED110B
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 17:32:53 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-417ab9cb14cso16043001cf.2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 17:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695083572; x=1695688372; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uC6YGyKXcnf0ZAk7QuLksP57uWGOURRVxE1L6y9FOWQ=;
        b=hZYuFiyd8COuYTGlLOTXZBTZG/kBDtRIBm7brVGmgq2pbXLUJ9kCsdxaEuj97RugcN
         VXXdPgtWzaQG2NURpovk+8Z03XWYVqHCyda6JB7t5aykBzk3sROloX2y3djqJ/3Fx+y6
         NMPHsJwCG5gar1gKmRg7IqcDOJY05uOIXgB+V+r7XdtBUC+Qx97qD12HDAWi44up/AO9
         3Hah4RYSFf0cchXScrPCiU6S+BxbwmzkWGd1WRIH1smb1FY1QslAEgqNpucifnfCo8F8
         2ez0waeWegO1Lsltzwphm7KNJ7PpQDou6wq1M34jvufENPQY5ItzcTiGSsOs54zO1sb6
         ErrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695083572; x=1695688372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uC6YGyKXcnf0ZAk7QuLksP57uWGOURRVxE1L6y9FOWQ=;
        b=xQxp+A1/GbDfTnWZ6/bgDqeIlNiUmJ6RaOPk9S94glwwnSmxS3WciDRBoZGDKVvWK8
         My65Z6D0IbEUePtaird1nxohDcZjYE2jckKgQTCCgTp4c5QD236i/HMWAW5qKKE2vUun
         RxngNFSjNkH0AeQKxKCzB002eNIUQD67A2XIHqogoNEqNlso9wjLeEnyxO5bQx266SVR
         jSl2MlkTrB88Dlx4/ItViy/YVOoKuQYekpbWjMaikUD1m5k2xGWVTNqEk53zcJmTmaYT
         ogZ/e9CAslV87BIduMAw14npRdHJokEv0iW7cWHCFzbcCRhKMUUqxv6t5fwMFwXd5+tC
         k2/A==
X-Gm-Message-State: AOJu0YyIjZqPJG8R4Zxg4g/MoJhqmIK5uYAcTWuPfDpGUTKgWUUY2bkb
        n0nQkdr0mjJfQIg+J0r71Of6/w==
X-Google-Smtp-Source: AGHT+IHUwUnVXdRE+P7F+W5SrPHKnsNpeK3dYsvgedqvuujtXsCLSRVQ/NHMCa4nUgRXVRunmiYpdA==
X-Received: by 2002:a05:622a:354:b0:417:a974:889e with SMTP id r20-20020a05622a035400b00417a974889emr10170137qtw.2.1695083572636;
        Mon, 18 Sep 2023 17:32:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id l24-20020ac84a98000000b0041519614354sm3411395qtq.7.2023.09.18.17.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 17:32:52 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiOfb-0008Eo-Hk;
        Mon, 18 Sep 2023 21:32:51 -0300
Date:   Mon, 18 Sep 2023 21:32:51 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
Message-ID: <20230919003251.GR13795@ziepe.ca>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca>
 <87led3xqye.ffs@tglx>
 <20230918233735.GP13795@ziepe.ca>
 <87a5tjxcva.ffs@tglx>
 <20230919000215.GQ13795@ziepe.ca>
 <874jjrxb43.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jjrxb43.ffs@tglx>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 19, 2023 at 02:25:32AM +0200, Thomas Gleixner wrote:

> > I don't think we need to try and fix that..
> 
> We might want to detect it and yell about it, right?

It strikes me as a good idea, yes. If it doesn't cost anything.

Jason
