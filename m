Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F66419E9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 03:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408315AbfFLBSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 21:18:09 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41522 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406608AbfFLBSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 21:18:08 -0400
Received: by mail-oi1-f195.google.com with SMTP id g7so7257197oia.8;
        Tue, 11 Jun 2019 18:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nSDY8zFKF7PHOkb9LEHVAO61FULkhNk92Ig0WDAkMeo=;
        b=Fak8lK+4PNF9fTphDDAZgqPro0aWiW8+A1NlJtFHUsSkFFzto70eTDEOmYx+vU+Gcb
         IGC4MMxyC6DlqpylYL/43ZaCCZfEWok0L/KwJAqYHHPikQH7pbIsSJVPd5uICx+/4MJM
         LVeEiUXzkEHfmdxk8TaJ80bbulOZFI7e8SnfyfTsuyh5M5P6n9X03Bn+acaym/QH69hh
         IJ1VIjtBel3XjtrALGiDcDIjetB/S2sDRTwLH0R4ZlKOVEUIMVAR00CtpxZyXLi2gEte
         hrO8ozymXOWlDHv3X8nErfVdUe3OOcBxOGNv0F5SmjAeBGRxUTjfgmj7ez6kZVT9oFZW
         Wk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nSDY8zFKF7PHOkb9LEHVAO61FULkhNk92Ig0WDAkMeo=;
        b=ZM0DRNI62J4dnQECvgA6Ac87+Jgi4l1vM4mb0LFEr9TPvIma4ekmKvv96rLfRMMfY7
         PmH4vR7XAF0gLh+b/UPVpvXKUm1JF7QwnB1AikPSNfuKIfDnfeDwi5BtpbPoMU9L44XY
         B6EuJpLEpPjsVJ3URC3NcTMuQlLU92SKkKYf1YJrOhcYd6WfmzYaT06iTcM/O28UN5p3
         2geCS8QpBAGSbQCzkePhzyDkuqmzSdSztmtIa2nuLxCimp4zbhKhRgGBuDyQitT6x4Tq
         fw4HjzkUKREeMdeGpb2lMevs3ckCscfB6sdtUDVFNRFGbuWFaJwIFq4N8PkotIzg6lyW
         fjaw==
X-Gm-Message-State: APjAAAVa1ADofxpvAcPVNPO/6olLYeWAVxKE4aJ13VcvgYHhnyXuUzDI
        6pNFXsJH4swEG5j2KZXaKetoHgc1G6jLFhEDHFQ=
X-Google-Smtp-Source: APXvYqxOePRL5Ast7RADB3O0vCgjL79/XpjmQIDrsy0dacjkgNNOLQ/cxOC3E7txveiyXCan4jJtl65RR5rjp+2kc6I=
X-Received: by 2002:aca:3305:: with SMTP id z5mr15303551oiz.141.1560302288094;
 Tue, 11 Jun 2019 18:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <20190610143420.GA6594@flask> <20190611011100.GB24835@linux.intel.com>
 <CANRm+Cwv5jqxBW=Ss5nkX7kZM3_Y-Ucs66yx5+wN09=W4pUdzA@mail.gmail.com>
 <F136E492-5350-49EE-A856-FBAEDB12FF99@gmail.com> <CANRm+CyZcvuT80ixp9f0FNmjN+rTUtw8MshtBG0Uk4L1B1UjDw@mail.gmail.com>
 <153047ED-75E2-4E70-BC33-C5FF27C08638@gmail.com>
In-Reply-To: <153047ED-75E2-4E70-BC33-C5FF27C08638@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 12 Jun 2019 09:18:51 +0800
Message-ID: <CANRm+Cx6Z=jxLaXqwhBDpVTsKH8mgoo4iC=U8GbAAJz-5gk5ZA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019 at 00:57, Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Jun 11, 2019, at 3:02 AM, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > On Tue, 11 Jun 2019 at 09:48, Nadav Amit <nadav.amit@gmail.com> wrote:
> >>> On Jun 10, 2019, at 6:45 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
> >>>
> >>> On Tue, 11 Jun 2019 at 09:11, Sean Christopherson
> >>> <sean.j.christopherson@intel.com> wrote:
> >>>> On Mon, Jun 10, 2019 at 04:34:20PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=
=99 wrote:
> >>>>> 2019-05-30 09:05+0800, Wanpeng Li:
> >>>>>> The idea is from Xen, when sending a call-function IPI-many to vCP=
Us,
> >>>>>> yield if any of the IPI target vCPUs was preempted. 17% performanc=
e
> >>>>>> increasement of ebizzy benchmark can be observed in an over-subscr=
ibe
> >>>>>> environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-funct=
ion
> >>>>>> IPI-many since call-function is not easy to be trigged by userspac=
e
> >>>>>> workload).
> >>>>>
> >>>>> Have you checked if we could gain performance by having the yield a=
s an
> >>>>> extension to our PV IPI call?
> >>>>>
> >>>>> It would allow us to skip the VM entry/exit overhead on the caller.
> >>>>> (The benefit of that might be negligible and it also poses a
> >>>>> complication when splitting the target mask into several PV IPI
> >>>>> hypercalls.)
> >>>>
> >>>> Tangetially related to splitting PV IPI hypercalls, are there any ma=
jor
> >>>> hurdles to supporting shorthand?  Not having to generate the mask fo=
r
> >>>> ->send_IPI_allbutself and ->kvm_send_ipi_all seems like an easy to w=
ay
> >>>> shave cycles for affected flows.
> >>>
> >>> Not sure why shorthand is not used for native x2apic mode.
> >>
> >> Why do you say so? native_send_call_func_ipi() checks if allbutself
> >> shorthand should be used and does so (even though the check can be mor=
e
> >> efficient - I=E2=80=99m looking at that code right now=E2=80=A6)
> >
> > Please continue to follow the apic/x2apic driver. Just apic_flat set
> > APIC_DEST_ALLBUT/APIC_DEST_ALLINC to ICR.
>
> Indeed - I was sure by the name that it does it correctly. That=E2=80=99s=
 stupid.
>
> I=E2=80=99ll add it to the patch-set I am working on (TLB shootdown impro=
vements),
> if you don=E2=80=99t mind.

Original for hotplug cpu safe.
https://lwn.net/Articles/138365/
https://lwn.net/Articles/138368/
Not sure shortcut native support is acceptable, I will play my
kvm_send_ipi_allbutself and kvm_send_ipi_all. :)

Regards,
Wanpeng Li
