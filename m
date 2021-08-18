Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31433F0812
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbhHRPb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:31:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239585AbhHRPbz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 11:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629300679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2Vcuo60gzD2ThQioHKoJVOsvstJGVPwB2LeKWFl+fkE=;
        b=WjTU3k+O/GNrNzUdfROk0FIWoTJVAmJHQ5iFhOKQz/2luM+ux5wG4SNn/IejdnmbTrRtcR
        ry88FxF/2CIV/tWInde310KrpXGeveUR6YNkqNQOvfJ9x4iynOuBVVdX6ZjItTIqcuF8E7
        eBFRJovMRIfhc8ZTouz4iCiO2z4mbf8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-hQ1449CSOYqZwfBPsuS4jw-1; Wed, 18 Aug 2021 11:31:18 -0400
X-MC-Unique: hQ1449CSOYqZwfBPsuS4jw-1
Received: by mail-wr1-f71.google.com with SMTP id z2-20020adff1c20000b0290154f60e3d2aso707060wro.23
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 08:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2Vcuo60gzD2ThQioHKoJVOsvstJGVPwB2LeKWFl+fkE=;
        b=AqFUqMcdnFZRkesi+0fg73i9actAy9/MnIIRL90W3porG2Wwtt4hMnfI59MA/kHqzy
         gPoaR7wSlniA5nbOQiMeIGMCKwPlLeoJJ1/Nmi3IJBQzkaX7pqe3SGIkFV54YU5gwiBu
         XAk585FEbVwe/UAhwhr+ztAun3YzkHyVhRcMvtc5WxxTp+pjOz8UQ62pSWQgGQm3gFr1
         09nWxd/4ZWhE4k5QqI6TDkCokCwZGgDiIuhPC/ES9QlvcYdRL+pguNxT7xSIyRAC6+xS
         9MP6zHXGvb9aIjCVFyGSZsvy13KM08bh+twW45Kir1UizhDoLGGuNSWqnWwgHJEYnKtC
         RCTQ==
X-Gm-Message-State: AOAM531TWvujGhgOsfzhjc3oGxTj6qdeWpiHW45n0w0RBEoyN5g04TMf
        qCs8fuDBB1OTQuxcYq4hurwR4J3ownXjDzljLGxXQ4x8IJxd0lSl3Xx62DJG4SAewpqLro6aiN8
        l+UEgPxohrfqs
X-Received: by 2002:a5d:58ce:: with SMTP id o14mr11109134wrf.319.1629300676370;
        Wed, 18 Aug 2021 08:31:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx61kJvQVKTPNPAFU8BGU6rsKDqn+ts/ihZnRItKrHELkW/ZhebZlm/GEpxu7mNDjAvqg/Zrw==
X-Received: by 2002:a5d:58ce:: with SMTP id o14mr11109100wrf.319.1629300676202;
        Wed, 18 Aug 2021 08:31:16 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id y66sm144608wmy.39.2021.08.18.08.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 08:31:15 -0700 (PDT)
Date:   Wed, 18 Aug 2021 16:31:13 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        tobin@ibm.com, dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YR0nwVPKymrAeIzV@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <20210816144413.GA29881@ashkalra_ubuntu_server>
 <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
 <20210816151349.GA29903@ashkalra_ubuntu_server>
 <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
 <20210818103147.GB31834@ashkalra_ubuntu_server>
 <f0b5b725fc879d72c702f88a6ed90e956ec32865.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0b5b725fc879d72c702f88a6ed90e956ec32865.camel@linux.ibm.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* James Bottomley (jejb@linux.ibm.com) wrote:
> On Wed, 2021-08-18 at 10:31 +0000, Ashish Kalra wrote:
> > Hello Paolo,
> > 
> > On Mon, Aug 16, 2021 at 05:38:55PM +0200, Paolo Bonzini wrote:
> > > On 16/08/21 17:13, Ashish Kalra wrote:
> > > > > > I think that once the mirror VM starts booting and running
> > > > > > the UEFI code, it might be only during the PEI or DXE phase
> > > > > > where it will start actually running the MH code, so mirror
> > > > > > VM probably still need to handles KVM_EXIT_IO when SEC phase
> > > > > > does I/O, I can see PIC accesses and Debug Agent
> > > > > > initialization stuff in SEC startup code.
> > > > > That may be a design of the migration helper code that you were
> > > > > working with, but it's not necessary.
> > > > > 
> > > > Actually my comments are about a more generic MH code.
> > > 
> > > I don't think that would be a good idea; designing QEMU's migration
> > > helper interface to be as constrained as possible is a good
> > > thing.  The migration helper is extremely security sensitive code,
> > > so it should not expose itself to the attack surface of the whole
> > > of QEMU.
> 
> The attack surface of the MH in the guest is simply the API.  The API
> needs to do two things:
> 
>    1. validate a correct endpoint and negotiate a wrapping key
>    2. When requested by QEMU, wrap a section of guest encrypted memory
>       with the wrapping key and return it.
> 
> The big security risk is in 1. if the MH can be tricked into
> communicating with the wrong endpoint it will leak the entire guest. 
> If we can lock that down, I don't see any particular security problem
> with 2. So, provided we get the security properties of the API correct,
> I think we won't have to worry over much about exposure of the API.

Well, we'd have to make sure it only does stuff on behalf of qemu; if
the guest can ever write to MH's memory it could do something that the
guest shouldn't be able to.

Dave

> > > One question i have here, is that where exactly will the MH code
> > exist in QEMU ?
> 
> I assume it will be only x86 platform specific code, we probably will
> never support it on other platforms ?
> 
> So it will probably exist in hw/i386, something similar to "microvm"
> support and using the same TYPE_X86_MACHINE ?
> 
> I don't think it should be x86 only.  The migration handler receiver
> should be completely CPU agnostic.  It's possible other CPUs will grow
> an encrypted memory confidential computing capability (Power already
> has one and ARM is "thinking" about it, but even if it doesn't, there's
> a similar problem if you want to use trustzone isolation in VMs).  I
> would envisage migration working substantially similarly on all of them
> (need to ask an agent in the guest to wrap an encrypted page for
> transport) so I think we should add this capability to the generic QEMU
> migration code and let other architectures take advantage of it as they
> grow the facility.
> 
> > Also if we are not going to use the existing KVM support code and
> > adding some duplicate KVM interface code, do we need to interface
> > with this added KVM code via the QEMU accelerator framework, or
> > simply invoke this KVM code statically ?
> 
> I think we need to design the interface as cleanly as possible, so it
> just depends what's easiest.  We certainly need some KVM support for
> the mirror CPUs, I think but it's not clear to me yet what the simplest
> way to do the interface is.
> 
> James
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

