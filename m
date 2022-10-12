Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A62C5FC5D1
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 15:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJLNCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 09:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiJLNCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 09:02:42 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC488052B
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 06:02:41 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id y10so3265548qvo.11
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 06:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+2Nqrw9STp++2L4DsJMi6hkYyDKD/Hz0Oh8MYX6p0Y=;
        b=CTkA8daxSClsJkFRmJ62yhZEy0FtXUQuoq2kEht7XpVrZeTmAHnLdAAAUJHn7h41/f
         geMwWHNNfWZI9SolLo9mWrmd+qpYI0gZ/51yF3NM52R2STqave+jS8bDKa3pA/8sx+2v
         iYbUBphFEluEwCPfE/eJznt8ccOP+0iePi0NtR91OHqooe/mpe3utDS5Ta34TxWwDaUs
         CroF/jvH/6ufeM2DlHjGKH4x4KceSXy6KnVs4rzbRxTTsli4A9+5d1z59fGcBG/LsOQr
         NJ3ef2O31mVZJCMG0iXOHWBejmKJU72T/iw+irPkPj0EKrj68wDQ/mohGO+NZs8F8vHL
         qJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q+2Nqrw9STp++2L4DsJMi6hkYyDKD/Hz0Oh8MYX6p0Y=;
        b=3zUupnRDH/0Qai0W1mtHwBt/D6nXo4kpona5iW2qrFdF5JdViFzc406kSCSQ1cdZIo
         eRh7YuwmvWoOiHJ9p0BOD6jF2cvyJG6X8w0mrb0NxXvbM0Es3m9k3KqKFkbj1hCtTH+a
         6S7W90IOuli7hsEzUQSJ0GMkW1UkT96eQv5VHROq6bkVxxhadIKNAPZEwM/DUjg6NGtk
         xoI45uVwCfwvVVaZ8JyAnNhLL/FDTtzgsFT1ppokb5flUXNw3H2wLtzfDqDkmrXWvz2q
         bi2HhW5cWMNy1bGsrk3J+EtAxcNQBNd7Waqe6Z4ojKv9D82CHQilaAFqzMUBnWu1lwhl
         1+hg==
X-Gm-Message-State: ACrzQf2IeTtHDKXFSG/haa6pav2LVAu15EpXOiUFrvjLXq1HENTKiRuE
        94zimjLNfexf7rhLhFaaTxYTDw==
X-Google-Smtp-Source: AMsMyM4gic10KgpYSrCq8ohl+c7DgczEJyCmY5+V3wv8+9y1501BmIPAAsnLKawah6kgjln1sdVqKg==
X-Received: by 2002:a05:6214:dce:b0:4b1:b1e7:f169 with SMTP id 14-20020a0562140dce00b004b1b1e7f169mr22688725qvt.64.1665579760064;
        Wed, 12 Oct 2022 06:02:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id ca6-20020a05622a1f0600b003994bbe91bdsm7900801qtb.60.2022.10.12.06.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 06:02:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oibNV-001wVQ-HJ;
        Wed, 12 Oct 2022 10:02:29 -0300
Date:   Wed, 12 Oct 2022 10:02:29 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
Cc:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Message-ID: <Y0a65a9leWXpKfTo@ziepe.ca>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-5-nipun.gupta@amd.com>
 <87h71juxuk.wl-maz@kernel.org>
 <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
 <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022 at 10:34:23AM +0000, Radovanovic, Aleksandar wrote:

> For the MSI EventID, the HW interrupt logic assumes the MSI write value is 
> equal to the MSI vector number. However, the vector number is programmable
> for most (all) of the interrupt sources, which isn't exactly the same as saying
> EventID is programmable for a vector number, but can be used to emulate the
> desired behaviour, with a translation table in firmware. 

If you do this stuff wrong you will eventually run into situations
that don't work. Like VFIO/VMs and things.

> As for GITS_TRANSLATER, we can take up to 4 different IOVAs, which limits us
> to 4 CDX devices (should be sufficient for current HW use-cases). Also, it means
> that the address part must be the same for all vectors within a single CDX 
> device. I'm assuming this is OK as it is going to be a single interrupt and IOMMU
> domain anyway.

This is not at all how MSI is supposed to work.

Jason
