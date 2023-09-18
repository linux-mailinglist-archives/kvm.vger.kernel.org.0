Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0767A49DE
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbjIRMkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241551AbjIRMkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:40:08 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D41E9F
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:40:02 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-76dbe263c68so194957685a.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695040801; x=1695645601; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zj7R4MqD+4gW8A6fnkAfuuqO+18Hs8aMyw+H+x1HxN8=;
        b=crUc0EzLroJkQbVFBOsItsYr1HLQD2riaD0qtvyV+7Zqi/pGMSC50Hsfj/KB4WehRQ
         TaLdd2ipYy3jXqy/atoREGecG7XAQc/SR5W+cycMqkHdKIOWzkMJDFCGNtkktEIWjz0X
         0xu5Oz08bGvSqDF5KFzD2kUCD0TuNhQiRarz/30jep3Btc3K7LrAuZFGbbglBBiiYU9W
         z/ltJ5i7TFtPr7AHfW7ucDun9t2jeDONuhxTFmtVDPs9qmtw6W82HuZGFfZprxKsHbWz
         gYwKaBwlQnqZJaPeJ4GebKDnLTSyc6ACe5QLgvPi4TWPJPm1QLhglIF5YS1FlsqNZzV4
         Ormg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695040801; x=1695645601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zj7R4MqD+4gW8A6fnkAfuuqO+18Hs8aMyw+H+x1HxN8=;
        b=b6bVWYq4urXbrQn1xmBzRZUH1DsvLfDMkBV3x/+0LgJUcCQiq8QligmPFNs4EHG6Xh
         8DjcwEF0uyKcnOJd4AcgMjHam4gvWNXuDi5GrCLb3FwJPLcZCFT2WJiyaFT6Jh/33l8/
         c+/F+Jq1b3SEuQ2zudiaAoZiWR/w5yoEpcrbp6Zv3L07y2CLkQ8lwvip47j1WHLzx+/G
         8NR79Y9JMTqizI18ufF4f+L3uT7gqhm3AF8vy1t4ASdezJTTVwI1qAPonhhixoCQVGjK
         aTXAw9LofJIymUT5/OG3Dgoo7R/m7ZLSf+gEox6mgNdqjSjJ68RWy6+u06cyEbZaq6rs
         IzDg==
X-Gm-Message-State: AOJu0YzciuKBJYdzVuI7DF1vvTvhzqvQywO9+OZcqL5ZI+c5jnEBtVQP
        Yf1kZPfQ1lRQNJbmPIekkaNj/A==
X-Google-Smtp-Source: AGHT+IEcv0qE4M4jo2rCl851+S9CmbO6Vad2hVtKFtek2cuEzQB+x2yvhvfhgkJNlojCYZZBbQ7Ybg==
X-Received: by 2002:a05:620a:2944:b0:76f:5b9:3f29 with SMTP id n4-20020a05620a294400b0076f05b93f29mr11358576qkp.2.1695040801514;
        Mon, 18 Sep 2023 05:40:01 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id v5-20020ae9e305000000b0076d9e298928sm3094857qkf.66.2023.09.18.05.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 05:40:01 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiDXk-0004AT-Au;
        Mon, 18 Sep 2023 09:40:00 -0300
Date:   Mon, 18 Sep 2023 09:40:00 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        oushixiong <oushixiong@kylinos.cn>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/pds: Use proper PF device access helper
Message-ID: <20230918124000.GB13795@ziepe.ca>
References: <20230914021332.1929155-1-oushixiong@kylinos.cn>
 <20230915125858.72b75a16.alex.williamson@redhat.com>
 <BN9PR11MB527624CEBA0B039CD62A8F428CF5A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527624CEBA0B039CD62A8F428CF5A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 16, 2023 at 09:53:29AM +0000, Tian, Kevin wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Saturday, September 16, 2023 2:59 AM
> > 
> > On Thu, 14 Sep 2023 10:13:32 +0800
> > oushixiong <oushixiong@kylinos.cn> wrote:
> > 
> > > From: Shixiong Ou <oushixiong@kylinos.cn>
> > >
> > > The pci_physfn() helper exists to support cases where the physfn
> > > field may not be compiled into the pci_dev structure. We've
> > > declared this driver dependent on PCI_IOV to avoid this problem,
> > > but regardless we should follow the precedent not to access this
> > > field directly.
> > >
> > > Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> > > ---
> > >
> > > This patch changes the subject line and commit log, and the previous
> > > patch's links is:
> > >
> > 	https://patchwork.kernel.org/project/kvm/patch/20230911080828.6
> > 35184-1-oushixiong@kylinos.cn/
> > 
> > Kevin & Jason,
> > 
> > I assume your R-b's apply to this version as well.  Thanks,
> > 
> 
> yes.

yes
