Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB065D239
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 13:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbjADMQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 07:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239028AbjADMQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 07:16:23 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F6012AB3
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 04:16:22 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id i185so1124305vsc.6
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 04:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tMTz73H2HiKDVHeJUWHzZGOUv0E67l6Qx4QTwGQGXow=;
        b=Y+GY413mSjalVDt8GwNEovY++Wnm/pe/LxKzzYoVVgXNo3AUWlnhvQJ/rhPEPc73hc
         MQMIOIND2igjxN+/5ejzg357Sx5alm6B+fuk7b6e7VxRLBxMhttW6KEXf8f0wRf+PvAA
         g9Xpi/WTHbgNAjtqF77viDgW+lLworl9sL/pIxCIqdCW96ibuM0ouQgO9x2VQ4WANuLN
         AHmkfnQUOZ6KVnmbhtg6fBasSBTj/ZPKURLZ+sMhOcsW0eRXxwZKJyHj56+g3qzntRj8
         u2YsLjEgyS1m++vj0biOYUka/68qrJpGwr5/prDMxKKyRN/7TCMH3FEgqFXxpqCa3fnF
         9iMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMTz73H2HiKDVHeJUWHzZGOUv0E67l6Qx4QTwGQGXow=;
        b=2zE/BvfPVQ22OWwnieoErobhq13M8s7mjZyQSkEtng0qMRRMakWTjbLgNi10MHvIVJ
         aDDzapqgk0nCEOasvP0dVfWa76iVOENXGPF3YE4q/tParqR+xsEYK/Xs7vOTY7MNslxV
         fVhYjj9WximGJJn+qp3VoyThRKXDJ+yKqWeBRAZ6GGurKBegsAUbqlFCbmqq+PcR8l7h
         6iQyV9ENuzQxrM/c1aRznTp3VArCskrjhP0XQe9Da5jrX/muobWS2i4ZFvwnj2dZNfMT
         kE9JR9geDpD9993kGDAFWom1mhBnuGgvOg1DF5mMZ/3RtOZHoQB5A6hcBRyO+RL1rmW5
         wtHA==
X-Gm-Message-State: AFqh2kolO4VMwmZV/DWQNjzj8580j7KNGtMuf9xBXy+xspPZORZDzJjp
        aFG8CYObRvZ0AOiVTowcFQK/ug==
X-Google-Smtp-Source: AMrXdXsI7IQb2hPC4bpp9sMd36je7bb9SmI3NUdx/zQE9URIoZtVn86xJGR7y0ZiqwKhRydoyR0k+A==
X-Received: by 2002:a67:ad10:0:b0:3c6:2c4:8cd1 with SMTP id t16-20020a67ad10000000b003c602c48cd1mr17585654vsl.9.1672834581480;
        Wed, 04 Jan 2023 04:16:21 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id bs7-20020a05620a470700b006b61b2cb1d2sm24239206qkb.46.2023.01.04.04.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 04:16:20 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pD2gu-001iia-1v;
        Wed, 04 Jan 2023 08:16:20 -0400
Date:   Wed, 4 Jan 2023 08:16:20 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Christian =?utf-8?Q?Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>
Subject: Re: [PATCH 1/1] vfio/type1: Respect IOMMU reserved regions in
 vfio_test_domain_fgsp()
Message-ID: <Y7VuFJFUHtkqA9ZM@ziepe.ca>
References: <20230102093452.761185-1-schnelle@linux.ibm.com>
 <20230102093452.761185-2-schnelle@linux.ibm.com>
 <Y7S8loyvHyjAmNdh@ziepe.ca>
 <4e8d3f53af2f73a464e4ffc4a9a28c8d31692369.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e8d3f53af2f73a464e4ffc4a9a28c8d31692369.camel@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 10:52:55AM +0100, Niklas Schnelle wrote:

> The problem manifests only with ISM devices which are a special s390
> virtual PCI device that is implemented in the machine hypervisor. This
> device is used for high speed cross-LPAR (Logical Partition)
> communication, basically it allows two LPARs that previously exchanged
> an authentication token to memcpy between their partitioned memory
> using the virtual device. For copying a receiving LPAR will IOMMU map a
> region of memory for the ISM device that it will allow DMAing into
> (memcpy by the hypervisor). All other regions remain unmapped and thus
> inaccessible. In preparation the device  emulation in the machine
> hypervisor intercepts the IOTLB flush and looks at the IOMMU
> translation tables performing e.g. size and alignment checks I presume,
> one of these checks against the start/end DMA boundaries. This check
> fails which leads to the virtual ISM device being put into an error
> state. Being in an error state it then fails to be initialized by the
> guest driver later on.

You could rephrase this as saying that the S390 map operation doesn't
check for bounds so mapping in a reserved region doesn't fail, but
errors the HW.

Which seems reasonable to me

Jason
