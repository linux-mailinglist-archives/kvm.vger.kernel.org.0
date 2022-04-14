Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBF3500842
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 10:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240892AbiDNI22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 04:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240837AbiDNI2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 04:28:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BD963193C
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 01:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649924758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g0u6ONe9j1j6k19mj6sFChlmsxQ/kXNGxnIkwP2DTq8=;
        b=VxHRlFXaM4PpcEw/JDPcSezSJxHVU3i2sbdi9MuZa5xTkqrWzkgPZNigBl0R9tvzvWsCiC
        1qMCc/Uj8dNDi6aDgvudXE49f6WqczdLRSfKlUEBUQtu+wuTYDnPqyK25i1CvJVbv5tUQV
        mBGcQ45BrR8bfj9aPihIAp0bBVmNwhc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-n5SOGAeYOPuKtEzbx6aOuw-1; Thu, 14 Apr 2022 04:25:57 -0400
X-MC-Unique: n5SOGAeYOPuKtEzbx6aOuw-1
Received: by mail-wm1-f72.google.com with SMTP id p31-20020a05600c1d9f00b0038ed0964a90so1896439wms.4
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 01:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g0u6ONe9j1j6k19mj6sFChlmsxQ/kXNGxnIkwP2DTq8=;
        b=mn2zAjJjH6VtI+VdJTqNS0iUgS9RCH2iX7h6h8rb1locani2hsOoHXNu9MKxsZqPB1
         pJSkQb/ivoEC+yTxTZ1jvRVFaqnhb+LpwQbDbLjVcpim9NjK/kbhqJ7aXCyCoLLihI8U
         fRSDoKZDYWkg48Gz3INVuSnatYolIPnrsT7AmuYvQN5XblCUnFTEAN7pG0zlr7QFodHj
         UF+qnUX6b8J/38P0QY/Gogtm5NXXhV5rXeM9NhYbMZWEr/IX/85aBbZHFXCiY6qBGr7C
         KZxpmMileXZKJwYBiXuMK9nuyQKMiUdjGUQAwZLapeU7L0i33mFNgiV0hJ4iI2JSDKwv
         8L5g==
X-Gm-Message-State: AOAM533pETisoQL84BPSPBlha2R03FKDVC29g3PFHAjyJeXyXk9RicBd
        Zlrpygrw1M6nqd5Uo2OJrXEMMpweQdSqNkJn9/ZuN1xApzeQkqY5nfMySvkhed4Mq5o0fQDwisj
        dChZDLhRlay2c
X-Received: by 2002:a05:6000:1541:b0:207:8ee6:1417 with SMTP id 1-20020a056000154100b002078ee61417mr1217583wry.504.1649924756045;
        Thu, 14 Apr 2022 01:25:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJJiDAargXbObsVDj9G3u5k/2S0Fw8jMKh3LM9lqbK1deff4nEQkiYIkjtAou08aM/zPgZzw==
X-Received: by 2002:a05:6000:1541:b0:207:8ee6:1417 with SMTP id 1-20020a056000154100b002078ee61417mr1217567wry.504.1649924755808;
        Thu, 14 Apr 2022 01:25:55 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id n15-20020a05600c500f00b0038cfb1a43d6sm1349951wmr.24.2022.04.14.01.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 01:25:55 -0700 (PDT)
Date:   Thu, 14 Apr 2022 09:25:53 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Dov Murik <dovmurik@linux.ibm.com>
Cc:     Cole Robinson <crobinso@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: adding 'official' way to dump SEV VMSA
Message-ID: <YlfakQfkZFOpKWeU@work-vm>
References: <a713533d-c4c5-2237-58d0-57b812a56ba4@redhat.com>
 <462cbf77-432a-c09c-6ec9-91556dc0f887@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462cbf77-432a-c09c-6ec9-91556dc0f887@linux.ibm.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Dov Murik (dovmurik@linux.ibm.com) wrote:
> Hi Cole,
> 
> On 13/04/2022 16:36, Cole Robinson wrote:
> > Hi all,
> > 
> > SEV-ES and SEV-SNP attestation require a copy of the initial VMSA to
> > validate the launch measurement. For developers dipping their toe into
> > SEV-* work, the easiest way to get sample VMSA data for their machine is
> > to grab it from a running VM.
> > 
> > There's two techniques I've seen for that: patch some printing into
> > kernel __sev_launch_update_vmsa, or use systemtap like danpb's script
> > here: https://gitlab.com/berrange/libvirt/-/blob/lgtm/scripts/sev-vmsa.stp
> > 
> > Seems like this could be friendlier though. I'd like to work on this if
> > others agree.
> > 
> > Some ideas I've seen mentioned in passing:
> > 
> > - debugfs entry in /sys/kernel/debug/kvm/.../vcpuX/
> > - new KVM ioctl
> > - something with tracepoints
> > - some kind of dump in dmesg that doesn't require a patch
> > 
> > Thoughts?
> 
> 
> Brijesh suggested to me to construct the VMSA without getting any info from
> the host (except number of vcpus), because the initial state of the vcpus
> is standard and known if you use QEMU and OVMF (but that's open for discussion).
> 
> I took his approach (thanks Brijesh!) and now it's how we calculate expected
> SNP measurements in sev-snp-measure [1].  The relevant part for VMSA construction
> is in [2].
> 
> I plan to add SEV-ES and SEV measurements calculation to this 
> library/program as well.

Everyone seems to be writing one; you, Dan etc!

I think I agree the right way is to build it programmatically rather
than taking a copy from the kernel;  it's fairly simple, although the
scripts get increasingly hairy as you deal with more and more VMM's and
firmwares.

I think I'd like to see a new ioctl to read the initial VMSA, primarily
as a way of debugging so you can see what VMSA you have when something
goes wrong.

Dave

> 
> [1] https://github.com/IBM/sev-snp-measure
> [2] https://github.com/IBM/sev-snp-measure/blob/main/sevsnpmeasure/vmsa.py
> 
> -Dov
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

