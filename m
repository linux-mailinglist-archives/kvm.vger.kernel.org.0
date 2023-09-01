Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E36878F82A
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 07:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244147AbjIAFsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 01:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjIAFsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 01:48:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EB3E50;
        Thu, 31 Aug 2023 22:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pkd0pAbWgDU4JojB1jD/cDurZU5oiSztqR2SAYfaUzc=; b=W9nEYYvVkDvunhIiMI948M3Fy6
        J5wL6Ppe/OWQ/mir51ZsDtZtIah5yjpBlFG1W29jocw7lIBrgR37bgSOp7ytjpscwmZD76NHxCbfB
        be7NgWx8my303rkC+boYNJPMQ6Iu6uY2zS4M6I8b3zGUHKvGqk+uXdpXdS1FiTkivn+n8RPP4XLWv
        mif2lh7+gzNmjkoGHlZXm2uWJTl9d4thu5QwF6btHkfHbRhnE2Ue0kJrKy5EQfmCWne6gvD+cQDHK
        2O9nDqiKZZUeG/L2h7NeFtGW2WrcghUTFysJ7TC7+I1fs2GmZGHlxfmUYc0unR1MBUPEtgrmGZZMu
        MhMv1vkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qbx0b-00GVeJ-1r;
        Fri, 01 Sep 2023 05:47:53 +0000
Date:   Thu, 31 Aug 2023 22:47:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Ankit Agrawal <ankita@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZPF7CYel75P3fBY2@infradead.org>
References: <20230822202303.19661-1-ankita@nvidia.com>
 <ZO9JKKurjv4PsmXh@infradead.org>
 <ZO9imcoN5l28GE9+@nvidia.com>
 <ZPCG9/P0fm88E2Zi@infradead.org>
 <BY5PR12MB37631B2F41DB62CBDD7B1F69B0E5A@BY5PR12MB3763.namprd12.prod.outlook.com>
 <ZPCd2sHXrAZHjsHg@infradead.org>
 <20230831122150.2b97511b.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831122150.2b97511b.alex.williamson@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 31, 2023 at 12:21:50PM -0600, Alex Williamson wrote:
> There's really never a guarantee that the thing we're exposing via the
> vfio uAPI has mainline drivers, for example we don't consult the
> nouveau device table before we expose an NVIDIA GPU to a Windows guest
> running proprietary device drivers.

As I said in my initial mail there's a huge different between a simple
passthrough like vfio-pci that doesn't care about the actual device,
and a driver like this one that is completely device specific.
