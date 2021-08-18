Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C633F0B66
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 21:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhHRTFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 15:05:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229558AbhHRTFJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 15:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629313474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RKRaR8ialZrJcZ2q5uYwpXQ6txvGrMjrVXBzyK2J2jo=;
        b=Mlj1Yvgwf0s3ZM3jNG9lVvlwjU86oQkIR/7l4RXPEo6qWcxw1P+YHCU4E5vps4WAsA8Utv
        pB3Mf25lQrsogh02wGtnDBBAYSKo3M/HeTVQAoqsRGzw5b99pPfuQ6OTGGBuilYrU4ICSZ
        EZVLabEirFGRc53OMQLaTe8Ozf51tlY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-Y7BPqjTBMvmHHXneobN2BQ-1; Wed, 18 Aug 2021 15:04:32 -0400
X-MC-Unique: Y7BPqjTBMvmHHXneobN2BQ-1
Received: by mail-wr1-f69.google.com with SMTP id m5-20020a5d6a050000b0290154e83dce73so873338wru.19
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 12:04:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RKRaR8ialZrJcZ2q5uYwpXQ6txvGrMjrVXBzyK2J2jo=;
        b=e55AlmJtmzcj9v0CcUcPevGDzZmyhMUWhfdp+bhfTEQae/Pmoi85WHLSlG7IFroll2
         ryrg53rDuhT3nBX9PywsRumpCBIyPx/QxLuMvcZG5fEpJt/su5dwsssVLJEma/o7Srbf
         z2eQ4BOIZ4+TzX2/oIEiqPL59aG9cWq89i0x6NtMItJJCwQ9t+hubohQeY4SD1iD/tk9
         64vkX1ceIzcn7/JLllG2VWKLjMIEqMLeiGotPeM9aolFHqtD+y8HGPQaE3D34LwmeG5H
         c57IGsSNVp+gU3IEC1oPTSxluFjyPknRsLfR3zG1KZqxoR/Zsiz3tAOCOYJdyWFGdDWh
         j9nQ==
X-Gm-Message-State: AOAM533nSDRNp3IA2QFFqJHUNHgRp8dHPMI2rkBQjAUHBYzgGcafPnAi
        Ukbtxn3LmjQzc2aAjfPJa+/rWuxOe13oNCs1OIWHGt7sWV7tqwfPV9je3G9s/gij5H48jtWDboC
        NRhfpOgMjF7MH
X-Received: by 2002:adf:9c8b:: with SMTP id d11mr12014206wre.43.1629313471464;
        Wed, 18 Aug 2021 12:04:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLdMDbMSjp9h1NdcljIpckt7ie6vJPkq0kBmu03yZevd4oVZWyroH52DVVQV60VqXHh9XvBQ==
X-Received: by 2002:adf:9c8b:: with SMTP id d11mr12014177wre.43.1629313471328;
        Wed, 18 Aug 2021 12:04:31 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id k3sm5996868wms.28.2021.08.18.12.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 12:04:30 -0700 (PDT)
Date:   Wed, 18 Aug 2021 20:04:28 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, tobin@ibm.com, jejb@linux.ibm.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        frankeh@us.ibm.com, dovmurik@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YR1ZvArdq4sKVyTJ@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
 <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
 <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
 <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tobin Feldman-Fitzthum (tobin@linux.ibm.com) wrote:
> On 8/17/21 6:04 PM, Steve Rutherford wrote:
> > On Tue, Aug 17, 2021 at 1:50 PM Tobin Feldman-Fitzthum
> > <tobin@linux.ibm.com> wrote:
> > > This is essentially what we do in our prototype, although we have an
> > > even simpler approach. We have a 1:1 mapping that maps an address to
> > > itself with the cbit set. During Migration QEMU asks the migration
> > > handler to import/export encrypted pages and provides the GPA for said
> > > page. Since the migration handler only exports/imports encrypted pages,
> > > we can have the cbit set for every page in our mapping. We can still use
> > > OVMF functions with these mappings because they are on encrypted pages.
> > > The MH does need to use a few shared pages (to communicate with QEMU,
> > > for instance), so we have another mapping without the cbit that is at a
> > > large offset.
> > > 
> > > I think this is basically equivalent to what you suggest. As you point
> > > out above, this approach does require that any page that will be
> > > exported/imported by the MH is mapped in the guest. Is this a bad
> > > assumption? The VMSA for SEV-ES is one example of a region that is
> > > encrypted but not mapped in the guest (the PSP handles it directly). We
> > > have been planning to map the VMSA into the guest to support migration
> > > with SEV-ES (along with other changes).
> > Ahh, It sounds like you are looking into sidestepping the existing
> > AMD-SP flows for migration. I assume the idea is to spin up a VM on
> > the target side, and have the two VMs attest to each other. How do the
> > two sides know if the other is legitimate? I take it that the source
> > is directing the LAUNCH flows?
> 
> Yeah we don't use PSP migration flows at all. We don't need to send the MH
> code from the source to the target because the MH lives in firmware, which
> is common between the two.

Are you relying on the target firmware to be *identical* or purely for
it to be *compatible* ?  It's normal for a migration to be the result of
wanting to do an upgrade; and that means the destination build of OVMF
might be newer (or older, or ...).

Dave


> We start the target like a normal VM rather than
> waiting for an incoming migration. The plan is to treat the target like a
> normal VM for attestation as well. The guest owner will attest the target VM
> just like they would any other VM that is started on their behalf. Secret
> injection can be used to establish a shared key for the source and target.
> 
> -Tobin
> 
> > 
> > --Steve
> > 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

