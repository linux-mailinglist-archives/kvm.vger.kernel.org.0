Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F60A3F1518
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 10:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbhHSIXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 04:23:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236854AbhHSIX3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 04:23:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629361372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3RUvVH4hlrm7njxKuul053rmb1kpEbBf4sJ3JmkcGns=;
        b=QehdK6IKt4lX4v6ns2SHujA+zeKZrcivgeQv3CUx3N3Pi+iPMCru1phycJ28mRP+QhI2HS
        BspSPwOzGW357mAHRe/AxFdVE+QIPwTPWvEXoXNI2iO3SkMgl3EUkTE78mEkdkCKKBTynN
        eJDhtvxM3mBT9r1Nze1AfN8BKtlw0ws=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-cRvUUfntNmmIcUfkCmGRKg-1; Thu, 19 Aug 2021 04:22:51 -0400
X-MC-Unique: cRvUUfntNmmIcUfkCmGRKg-1
Received: by mail-wr1-f71.google.com with SMTP id q19-20020adfbb93000000b00156a96f5178so1429257wrg.11
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 01:22:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3RUvVH4hlrm7njxKuul053rmb1kpEbBf4sJ3JmkcGns=;
        b=StomaQna5KZDcoa5fpB1mU8lDpj3QJksahd4xOX26XPfiay3sDvgriEdZVbuM5KSG7
         VMvaMcGz5py8lXNgD7MLW/B/OUiBknBUlbp8ra8TJ3Wr+VLLiRMcChTkDL0cH0C2KGOC
         Hsw5oQtMOa19taBFopPSJwW8kwfo+56dYY+eTwcX3vuhuwLssp2embgKnqF//J43d6xz
         1oTV94/decmuYWlXVrGA6w+fMHVfBr2dysH3D5w5SwKLUYtROtDOMfOPCtrfej2Oxkkw
         V7Sq/4iFOsV3Y6HZtYu9hF0GF6J2++Sy9hG7xu8oqPmYdXW4eZpsW6DnMyVVe5gCwzWE
         7VgQ==
X-Gm-Message-State: AOAM530k+yBREQnL2UtoTqRHyU3HamurUBpMocIO/plNbB9qfLVrMFFm
        YySYP0plVIjXgoq6/rsLwc3HyaVTOcgNRJkwlUGww14yHdf3Q9VGANlVVM2Y+XZGkpmYXitEPn1
        uwUky4JDesg4h
X-Received: by 2002:a05:600c:a49:: with SMTP id c9mr12268479wmq.159.1629361370631;
        Thu, 19 Aug 2021 01:22:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqncaYM3iV0vzPV1ldTAYyMmARPm2+WDbp9axtWT7GFnS3Ia7cksTVRG7kGcq3hTWPfY7HaQ==
X-Received: by 2002:a05:600c:a49:: with SMTP id c9mr12268465wmq.159.1629361370407;
        Thu, 19 Aug 2021 01:22:50 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id a77sm7515035wmd.31.2021.08.19.01.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 01:22:49 -0700 (PDT)
Date:   Thu, 19 Aug 2021 09:22:47 +0100
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
Message-ID: <YR4U11ssVUztsPyx@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
 <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
 <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
 <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
 <YR1ZvArdq4sKVyTJ@work-vm>
 <c1d8dbca-c6a9-58da-6f95-b33b74e0485a@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1d8dbca-c6a9-58da-6f95-b33b74e0485a@linux.ibm.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tobin Feldman-Fitzthum (tobin@linux.ibm.com) wrote:
> On 8/18/21 3:04 PM, Dr. David Alan Gilbert wrote:
> > * Tobin Feldman-Fitzthum (tobin@linux.ibm.com) wrote:
> > > On 8/17/21 6:04 PM, Steve Rutherford wrote:
> > > > Ahh, It sounds like you are looking into sidestepping the existing
> > > > AMD-SP flows for migration. I assume the idea is to spin up a VM on
> > > > the target side, and have the two VMs attest to each other. How do the
> > > > two sides know if the other is legitimate? I take it that the source
> > > > is directing the LAUNCH flows?
> > > Yeah we don't use PSP migration flows at all. We don't need to send the MH
> > > code from the source to the target because the MH lives in firmware, which
> > > is common between the two.
> > Are you relying on the target firmware to be *identical* or purely for
> > it to be *compatible* ?  It's normal for a migration to be the result of
> > wanting to do an upgrade; and that means the destination build of OVMF
> > might be newer (or older, or ...).
> > 
> > Dave
> 
> This is a good point. The migration handler on the source and target must
> have the same memory footprint or bad things will happen. Using the same
> firmware on the source and target is an easy way to guarantee this. Since
> the MH in OVMF is not a contiguous region of memory, but a group of
> functions scattered around OVMF, it is a bit difficult to guarantee that the
> memory footprint is the same if the build is different.

Can you explain what the 'memory footprint' consists of? Can't it just
be the whole of the OVMF rom space if you have no way of nudging the MH
into it's own chunk?

I think it really does have to cope with migration to a new version of
host.

Dave

> -Tobin
> 
> > 
> > 
> > > We start the target like a normal VM rather than
> > > waiting for an incoming migration. The plan is to treat the target like a
> > > normal VM for attestation as well. The guest owner will attest the target VM
> > > just like they would any other VM that is started on their behalf. Secret
> > > injection can be used to establish a shared key for the source and target.
> > > 
> > > -Tobin
> > > 
> > > > --Steve
> > > > 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

