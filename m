Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8543F1B97
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 16:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhHSO3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 10:29:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240460AbhHSO3P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 10:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629383318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T5Fh0vjXWScKycfJq4B6wgoJybSBRWcWCsIYN/VXpLo=;
        b=bD/wQyS9Plcgn4XW5GV5H5jf89cF3vUFe7CWs5y2vF6/LJ4IrZ+kU0RDENaOs1KSry4+qi
        t1EdprF7aRr0jgWEhsvhK6PDTh46zUywUxMkwrvJxlTR3x911kQgloWV6E9ctYe3NgWDGn
        9d5eEMUwwEBbBjg3QEiz4MdCjrxUOu8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-2_a4CoTIOKG5JUJ7wqZB_Q-1; Thu, 19 Aug 2021 10:28:37 -0400
X-MC-Unique: 2_a4CoTIOKG5JUJ7wqZB_Q-1
Received: by mail-wm1-f70.google.com with SMTP id g70-20020a1c20490000b02902e6753bf473so3580379wmg.0
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 07:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T5Fh0vjXWScKycfJq4B6wgoJybSBRWcWCsIYN/VXpLo=;
        b=i8SyU9Xvq0Q0ZQvVVjyA8MeptVzTmynund9Y1WXV4UC8miSlpmaXR7UhH9Ttrli8nR
         zL1tPoE9WhYgcgyp2LHKmbKvmfrEpwSDVfnR97TL8aVvXnAgULiXex05m/p5zex9rraf
         WpRXBAM2wKh6jBgl8JL1FFc2avdHHPWyV79twPgXUeg1dvvTFktAg8FDuU+sHCeEokUH
         90eucVa1ie7F0EhDII/ab5SR0II+8v0lgWO/SyeB9+fwXDiWuXPFM+sJdPTYJqjtWR/V
         k8awcVA+PURWZ1KlOAL6yS1ZVysqm0zhbiOx8A8HRUZ6qHk6FfBpVXQoFrVAvYmdHLzE
         4xKg==
X-Gm-Message-State: AOAM530pYQxkQi5J1gCGNDZsPi24DLyrTzEp5Ol3YQp9PHe8eYbeajJj
        tfLK64qhkn3oq3cX5+FxLBrWdzo5fWQrPT7RCw6JFVJXsiCaxbo16+FIxy3CeFgIeclhtKUrw1n
        nhyh7yXWkaWss
X-Received: by 2002:adf:9063:: with SMTP id h90mr4359371wrh.121.1629383316077;
        Thu, 19 Aug 2021 07:28:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5BdZPD0p50QwmyWtpFISXnLDJIPMjDj5lkkZWFYj9AeSh/rs/TEqEYF/99+Jc01HnzN8azA==
X-Received: by 2002:adf:9063:: with SMTP id h90mr4359351wrh.121.1629383315881;
        Thu, 19 Aug 2021 07:28:35 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id s13sm7874559wmc.47.2021.08.19.07.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 07:28:35 -0700 (PDT)
Date:   Thu, 19 Aug 2021 15:28:33 +0100
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
Message-ID: <YR5qka5aoJqlouhO@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
 <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
 <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
 <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
 <YR1ZvArdq4sKVyTJ@work-vm>
 <c1d8dbca-c6a9-58da-6f95-b33b74e0485a@linux.ibm.com>
 <YR4U11ssVUztsPyx@work-vm>
 <538733190532643cc19b6e30f0eda4dd1bc2a767.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538733190532643cc19b6e30f0eda4dd1bc2a767.camel@linux.ibm.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* James Bottomley (jejb@linux.ibm.com) wrote:
> On Thu, 2021-08-19 at 09:22 +0100, Dr. David Alan Gilbert wrote:
> > * Tobin Feldman-Fitzthum (tobin@linux.ibm.com) wrote:
> > > On 8/18/21 3:04 PM, Dr. David Alan Gilbert wrote:
> > > > * Tobin Feldman-Fitzthum (tobin@linux.ibm.com) wrote:
> > > > > On 8/17/21 6:04 PM, Steve Rutherford wrote:
> > > > > > Ahh, It sounds like you are looking into sidestepping the
> > > > > > existing AMD-SP flows for migration. I assume the idea is to
> > > > > > spin up a VM on the target side, and have the two VMs attest
> > > > > > to each other. How do the two sides know if the other is
> > > > > > legitimate? I take it that the source is directing the LAUNCH
> > > > > > flows?
> > > > >  
> > > > > Yeah we don't use PSP migration flows at all. We don't need to
> > > > > send the MH code from the source to the target because the MH
> > > > > lives in firmware, which is common between the two.
> > > >  
> > > > Are you relying on the target firmware to be *identical* or
> > > > purely for it to be *compatible* ?  It's normal for a migration
> > > > to be the result of wanting to do an upgrade; and that means the
> > > > destination build of OVMF might be newer (or older, or ...).
> > > > 
> > > > Dave
> > > 
> > > This is a good point. The migration handler on the source and
> > > target must have the same memory footprint or bad things will
> > > happen. Using the same firmware on the source and target is an easy
> > > way to guarantee this. Since the MH in OVMF is not a contiguous
> > > region of memory, but a group of functions scattered around OVMF,
> > > it is a bit difficult to guarantee that the memory footprint is the
> > > same if the build is different.
> > 
> > Can you explain what the 'memory footprint' consists of? Can't it
> > just be the whole of the OVMF rom space if you have no way of nudging
> > the MH into it's own chunk?
> 
> It might be possible depending on how we link it. At the moment it's
> using the core OVMF libraries, but it is possible to retool the OVMF
> build to copy those libraries into the MH DXE.
> 
> > I think it really does have to cope with migration to a new version
> > of host.
> 
> Well, you're thinking of OVMF as belonging to the host because of the
> way it is supplied, but think about the way it works in practice now,
> forgetting about confidential computing: OVMF is RAM resident in
> ordinary guests, so when you migrate them, the whole of OVMF (or at
> least what's left at runtime) goes with the migration, thus it's not
> possible to change the guest OVMF by migration.  The above is really
> just an extension of that principle, the only difference for
> confidential computing being you have to have an image of the current
> OVMF ROM in the target to seed migration.
> 
> Technically, the problem is we can't overwrite running code and once
> the guest is re-sited to the target, the OVMF there has to match
> exactly what was on the source for the RT to still function.   Once the
> migration has run, the OVMF on the target must be identical to what was
> on the source (including internally allocated OVMF memory), and if we
> can't copy the MH code, we have to rely on the target image providing
> this identical code and we copy the rest.

I'm OK with the OVMF now being part of the guest image, and having to
exist on both; it's a bit delicate though unless we have a way to check
it (is there an attest of the destination happening here?)

Dave

> James
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

