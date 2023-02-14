Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85037696887
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 16:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjBNPzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 10:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjBNPzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 10:55:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B86193E3
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 07:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676390062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xb46HmzYSch6mL85Mc29IUcDhw17TwDxuJ7aIajpOQI=;
        b=Vr0iZY5qOMEEu5X8aVk5zyNvJiFSALxGQcrWXjWbtD3rHZ1EDsBOZ7l1bMpxCII+FO6W6z
        iHDDdHIU0vjCq1S4pLHXMvZz3G6+QbypFnoOqVkPWKFigVAfSSueCE6tFPfworkML4qYCF
        sRdz8oQN672a259ekoxSKhxW/oDDmfo=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-241-_9BP1u3wO16uMnGONONgFA-1; Tue, 14 Feb 2023 10:54:21 -0500
X-MC-Unique: _9BP1u3wO16uMnGONONgFA-1
Received: by mail-il1-f198.google.com with SMTP id g1-20020a92cda1000000b0030c45d93884so11690081ild.16
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 07:54:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xb46HmzYSch6mL85Mc29IUcDhw17TwDxuJ7aIajpOQI=;
        b=s6ExLwxh3sR95w2jy+H4YdFxVhM/1CjarOS/aB6HtRj4QtNHNZXX693cNkQCCrNZc7
         FDtv2EWHrsu0F+5c3MbaCWk7CcJWtuB3QLgJAyHcFEW69fEhb52jri58Xa0R40AbrMja
         OFSR2Joh92Zt3epeWFP6ts2xKbUQ4XeIUZUFajLfufm91IWPw9TfEAIXiZPoDDsHH2Dq
         LDneUwxWttA91NtPpskpLs/LCrZAAXpf4sdg4KzzGPOjnT7QFiOz5BNB6nlccMSTZKig
         iNNiEHm5pIwTFTkrdZM4Q2eVVidweEXQEitNak8FTkzyml+wb7WfdSret/rPXLIoaSPo
         lT/Q==
X-Gm-Message-State: AO0yUKUOdDrYXU3Lls1I5N32ynConnqXmHniDiF6gWqKqU4HWHK5ZYQ4
        fxEykdNFm+2fxpqLAB+jLqe3ybeKN/echQVM6B2Y/aJhoiyCj0M3xtrzy951TprkMJkGlBS28C6
        /8WIlDVFDPbUf
X-Received: by 2002:a05:6e02:20e4:b0:314:f7f:a369 with SMTP id q4-20020a056e0220e400b003140f7fa369mr4046632ilv.11.1676390060691;
        Tue, 14 Feb 2023 07:54:20 -0800 (PST)
X-Google-Smtp-Source: AK7set+yb7BFh0lx0KigAZF0OwR9/57RngCfPYMxWA+ojxz0Hlv7JuDsuFBdGIHTFwUQVEMWcfb2KQ==
X-Received: by 2002:a05:6e02:20e4:b0:314:f7f:a369 with SMTP id q4-20020a056e0220e400b003140f7fa369mr4046617ilv.11.1676390060461;
        Tue, 14 Feb 2023 07:54:20 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e10-20020a02a50a000000b003c4d64a4d10sm705354jam.4.2023.02.14.07.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 07:54:20 -0800 (PST)
Date:   Tue, 14 Feb 2023 08:54:19 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Message-ID: <20230214085419.4ac6d2c2.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529F0B20A73690C5650778BC3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
        <20230213124719.126eb828.alex.williamson@redhat.com>
        <Y+rGDeEMTB8FxjAH@nvidia.com>
        <DS0PR11MB7529F0B20A73690C5650778BC3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Feb 2023 15:15:28 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 14, 2023 7:22 AM
> > 
> > On Mon, Feb 13, 2023 at 12:47:19PM -0700, Alex Williamson wrote:
> >   
> > > I think it's too late for v6.3 already, but given this needs at least
> > > one more spin, let's set expectations of this being v6.4 material.  Thanks,  
> > 
> > Please let's continue to try to get this finished during the merge
> > window, all the other series depend on it. We can manage it with a
> > shared branch again..
> >   
> 
> Sure. I've updated the below branch to address Kevin's latest remarks.
> Fixed the compiling failure reported by Alex as well.
> 
> https://github.com/yiliu1765/iommufd/commits/vfio_device_cdev_v3


Sorry, I think this is an abuse of the merge window.  We have a new uAPI
proposal that's barely a week old and has no reviews or acks other than
Yi's, we have build configuration issues which suggests a lack of
testing, we're finding subtle implications to other existing uAPIs, and
nobody seems to have finished an upstream review, including me.

Code for the merge window should already be in maintainer trees by now,
the merge window should be for integration.  There are a lot of things
in flight and many more review comments coming in than we should see
for this to be a v6.3 candidate.  Thanks,

Alex

