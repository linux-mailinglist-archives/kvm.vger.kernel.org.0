Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8393F4AA3
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 14:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbhHWM1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 08:27:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41965 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233755AbhHWM1P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 08:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629721592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RJ0AqHRn6/2wVuM6tXEF47SarvthZwWj7KBw4eo8LnU=;
        b=KPOK/ZLHQq6ed4w4BT7cTdLfU/vl+Dz8/nRp97rsC9hxnIuBobGrE1Ala0pX0OEwRKoQ5p
        YgFeB+gEAiDXwvhKPL3dOjAfq61PEPKQE/x7+HDqytJg4sdTtJmCE57EAqrCiwKJwgKK6j
        5XBuukIx1x1PVZAY/qCXbIZ1vrpg3HI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-iy5vczT-MaWd_nfRRx5b_w-1; Mon, 23 Aug 2021 08:26:31 -0400
X-MC-Unique: iy5vczT-MaWd_nfRRx5b_w-1
Received: by mail-wr1-f70.google.com with SMTP id v18-20020adfe2920000b029013bbfb19640so4996121wri.17
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 05:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RJ0AqHRn6/2wVuM6tXEF47SarvthZwWj7KBw4eo8LnU=;
        b=n7GZzYq/GGMSEEfhDELokfN25mj3sE4/Hy8E/fAV8192xCd7D8viW9QToX4lkzpxFw
         P6P66CUHmLP6S0FipJKT9jVM4we2r8GAf12j3DGPoKhJ/ZgQrKaBr4qQyOB0oEk77sWI
         IugpIYxbYLwi3YK3uexM6MC94p8JNbKfql27jslL2qZig3cP7Vg0ACyRCsv7yBgV1/Qz
         w5uQ3MVyg1AvKS3xyFJViTNSVATACCC1zObSq6MMlCQbWW9/kqNyirzlMoL7j08nphH2
         ype69ayfFSXw+LCJdcOHi2dzT3fEUBE8eTxdfqb1k/2g8mbaGNYLoc1RwKRoNDCVbE1Q
         GGqA==
X-Gm-Message-State: AOAM5317/j7TCVF3I8VglgMHwiw2IrSFn4Kv2urXHcwMbCJTajkmvf9V
        Di9UKetH/WvVI3t3Hi/7H74SrKnFd90IDR9ISJyra4ffm3E1taGtmSerPlBhIe8hxuh7MBHv0v6
        zPqTQp4LrINID
X-Received: by 2002:a7b:c7cd:: with SMTP id z13mr10147543wmk.51.1629721590053;
        Mon, 23 Aug 2021 05:26:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWLrdzq7RAAw59P7YJ7wuwSOMa04Vxu2eLXc27mIUEoBjuTzPG0WAOjZHpS1Vxxbr90mRAOw==
X-Received: by 2002:a7b:c7cd:: with SMTP id z13mr10147527wmk.51.1629721589816;
        Mon, 23 Aug 2021 05:26:29 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id l12sm12703907wms.24.2021.08.23.05.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 05:26:29 -0700 (PDT)
Date:   Mon, 23 Aug 2021 13:26:27 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Tobin Feldman-Fitzthum <tobin@linux.ibm.com>,
        Steve Rutherford <srutherford@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, tobin@ibm.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, frankeh@us.ibm.com,
        dovmurik@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YSOT87eg4UjCG+jG@work-vm>
References: <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
 <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
 <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
 <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
 <YR1ZvArdq4sKVyTJ@work-vm>
 <c1d8dbca-c6a9-58da-6f95-b33b74e0485a@linux.ibm.com>
 <YR4U11ssVUztsPyx@work-vm>
 <538733190532643cc19b6e30f0eda4dd1bc2a767.camel@linux.ibm.com>
 <YR5qka5aoJqlouhO@work-vm>
 <d6eb8f7ff2d78296b5ba3a20d1dc9640f4bb8fa5.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6eb8f7ff2d78296b5ba3a20d1dc9640f4bb8fa5.camel@linux.ibm.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* James Bottomley (jejb@linux.ibm.com) wrote:
> On Thu, 2021-08-19 at 15:28 +0100, Dr. David Alan Gilbert wrote:
> > * James Bottomley (jejb@linux.ibm.com) wrote:
> > > On Thu, 2021-08-19 at 09:22 +0100, Dr. David Alan Gilbert wrote:
> [...]
> > > > I think it really does have to cope with migration to a new
> > > > version of host.
> > > 
> > > Well, you're thinking of OVMF as belonging to the host because of
> > > the way it is supplied, but think about the way it works in
> > > practice now, forgetting about confidential computing: OVMF is RAM
> > > resident in ordinary guests, so when you migrate them, the whole of
> > > OVMF (or at least what's left at runtime) goes with the migration,
> > > thus it's not possible to change the guest OVMF by migration.  The
> > > above is really just an extension of that principle, the only
> > > difference for confidential computing being you have to have an
> > > image of the current OVMF ROM in the target to seed migration.
> > > 
> > > Technically, the problem is we can't overwrite running code and
> > > once the guest is re-sited to the target, the OVMF there has to
> > > match exactly what was on the source for the RT to still
> > > function.   Once the migration has run, the OVMF on the target must
> > > be identical to what was on the source (including internally
> > > allocated OVMF memory), and if we can't copy the MH code, we have
> > > to rely on the target image providing this identical code and we
> > > copy the rest.
> > 
> > I'm OK with the OVMF now being part of the guest image, and having to
> > exist on both; it's a bit delicate though unless we have a way to
> > check it (is there an attest of the destination happening here?)
> 
> There will be in the final version.  The attestations of the source and
> target, being the hash of the OVMF (with the registers in the -ES
> case), should be the same (modulo any firmware updates to the PSP,
> whose firmware version is also hashed) to guarantee the OVMF is the
> same on both sides.  We'll definitely take an action to get QEMU to
> verify this ... made a lot easier now we have signed attestations ...

Hmm; I'm not sure you're allowed to have QEMU verify that - we don't
trust it; you need to have either the firmware say it's OK to migrate
to the destination (using the existing PSP mechanism) or get the source
MH to verify a quote from the destination.

[Somewhere along the line, if you're not using the PSP, I think you also
need to check the guest policy to check it is allowed to migrate].

Dave

> James
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

