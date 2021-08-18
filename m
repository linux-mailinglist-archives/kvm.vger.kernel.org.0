Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D603F0843
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239978AbhHRPoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:44:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230360AbhHRPoJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 11:44:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629301414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L9XsdG57Mi9fqdOK1OUJnUMTmL7H16XFYw0UC4znLZo=;
        b=BciLRQ36ShtIFgGd3fBgd46HkgeqEUaLVqjjv5fnKb3s5Yct0xqxDb2PSWI8Bi9yLuRa4I
        SqAcO/Iv5gM2KTBdX3BvxJl9m1aWzE5ycNpSTCe4odPf30TlVGQ+EJs9MudIpfZ0mTL5zj
        TBUKubBB7tO671lEyP22DcltacZYOKM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116--KYnFeGyPd-y1hr_r38Q8w-1; Wed, 18 Aug 2021 11:43:33 -0400
X-MC-Unique: -KYnFeGyPd-y1hr_r38Q8w-1
Received: by mail-wr1-f72.google.com with SMTP id k15-20020a5d628f0000b029015501bab520so724027wru.16
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 08:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=L9XsdG57Mi9fqdOK1OUJnUMTmL7H16XFYw0UC4znLZo=;
        b=XYfSlPb7YIUMnQOJ6w7QeHzX6YNMGRPnwp1h8hSIkBM8HdVfWrCN3nmvq6oC5VPzb1
         /2bwz7YE4IIlaxQokYNb9x8P3EVdExXxk5wjB46zlGgZm5/b/Cmyt6dGarUIx6xDPR0u
         5Zyp/QB/3NYjr56GREd9qZjU5i/L+/zyKB41Cnf3pjShH3aHFlVXHogUsq47Y3iOiLs9
         j9tpsUNsW9MpNDbbUWx07B0ILQ81MZt34FKd0CX4/FLeDLvPBr5/i9q55QDdevfolvn/
         kXAapar23mYYtec35oyiBB3a0JrEXBWD8bWkcexPoPI2iUnUmrwqwv8WyPrmjzeO9m9S
         tN7g==
X-Gm-Message-State: AOAM531qxXW1pmxQooudCoQ+qeXWk8ZY23Y1w/waqtRiJhS6qIh4VKge
        O0/r7xHmta9LBbSfcsPNErG7UlLT9LXC94fmBjNVEO4fz6uYAgaEpd7b5U+q/mvuaMkIsxHPdbG
        t8uYBZQfweqlc
X-Received: by 2002:a5d:674b:: with SMTP id l11mr11356166wrw.357.1629301412132;
        Wed, 18 Aug 2021 08:43:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0QLznTozFHj6dO5NFZppXGV148A/UjiKNLlJKdwsUvNNAdEIUrsiMCURfRCpVi7cNzBvvMw==
X-Received: by 2002:a5d:674b:: with SMTP id l11mr11356149wrw.357.1629301411981;
        Wed, 18 Aug 2021 08:43:31 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id b10sm228285wrn.9.2021.08.18.08.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 08:43:31 -0700 (PDT)
Date:   Wed, 18 Aug 2021 16:43:29 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        tobin@ibm.com, dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YR0qoV6tDuVxddL5@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <20210816144413.GA29881@ashkalra_ubuntu_server>
 <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
 <20210816151349.GA29903@ashkalra_ubuntu_server>
 <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
 <20210818103147.GB31834@ashkalra_ubuntu_server>
 <f0b5b725fc879d72c702f88a6ed90e956ec32865.camel@linux.ibm.com>
 <YR0nwVPKymrAeIzV@work-vm>
 <8ae11fca26e8d7f96ffc7ec6353c87353cadc63a.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ae11fca26e8d7f96ffc7ec6353c87353cadc63a.camel@linux.ibm.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* James Bottomley (jejb@linux.ibm.com) wrote:
> On Wed, 2021-08-18 at 16:31 +0100, Dr. David Alan Gilbert wrote:
> > * James Bottomley (jejb@linux.ibm.com) wrote:
> > > On Wed, 2021-08-18 at 10:31 +0000, Ashish Kalra wrote:
> > > > Hello Paolo,
> > > > 
> > > > On Mon, Aug 16, 2021 at 05:38:55PM +0200, Paolo Bonzini wrote:
> > > > > On 16/08/21 17:13, Ashish Kalra wrote:
> > > > > > > > I think that once the mirror VM starts booting and
> > > > > > > > running the UEFI code, it might be only during the PEI or
> > > > > > > > DXE phase where it will start actually running the MH
> > > > > > > > code, so mirror VM probably still need to handles
> > > > > > > > KVM_EXIT_IO when SEC phase does I/O, I can see PIC
> > > > > > > > accesses and Debug Agent initialization stuff in SEC
> > > > > > > > startup code.
> > > > > > > That may be a design of the migration helper code that you
> > > > > > > were working with, but it's not necessary.
> > > > > > > 
> > > > > > Actually my comments are about a more generic MH code.
> > > > > 
> > > > > I don't think that would be a good idea; designing QEMU's
> > > > > migration helper interface to be as constrained as possible is
> > > > > a good thing.  The migration helper is extremely security
> > > > > sensitive code, so it should not expose itself to the attack
> > > > > surface of the whole of QEMU.
> > > 
> > > The attack surface of the MH in the guest is simply the API.  The
> > > API needs to do two things:
> > > 
> > >    1. validate a correct endpoint and negotiate a wrapping key
> > >    2. When requested by QEMU, wrap a section of guest encrypted
> > > memory
> > >       with the wrapping key and return it.
> > > 
> > > The big security risk is in 1. if the MH can be tricked into
> > > communicating with the wrong endpoint it will leak the entire
> > > guest.  If we can lock that down, I don't see any particular
> > > security problem with 2. So, provided we get the security
> > > properties of the API correct, I think we won't have to worry over
> > > much about exposure of the API.
> > 
> > Well, we'd have to make sure it only does stuff on behalf of qemu; if
> > the guest can ever write to MH's memory it could do something that
> > the guest shouldn't be able to.
> 
> Given the lack of SMI, we can't guarantee that with plain SEV and -ES. 
> Once we move to -SNP, we can use VMPLs to achieve this.

Doesn't the MH have access to different slots and running on separate
vCPUs; so it's still got some separation?

> But realistically, given the above API, even if the guest is malicious,
> what can it do?  I think it's simply return bogus pages that cause a
> crash on start after migration, which doesn't look like a huge risk to
> the cloud to me (it's more a self destructive act on behalf of the
> guest).

I'm a bit worried about the data structures that are shared between the
migration code in qemu and the MH; the code in qemu is going to have to
be paranoid about not trusting anything coming from the MH.

Dave

> James
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

