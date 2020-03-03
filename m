Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EFC178219
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 20:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbgCCSIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 13:08:50 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:36674 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732307AbgCCSIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 13:08:48 -0500
Received: by mail-io1-f65.google.com with SMTP id d15so4671124iog.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 10:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bf0F9jShQ+1SAJ86EUg24NgoBWAimsu/bT/Rh5FZG1s=;
        b=CuwQcN7zp2rH8kV+uXmvxUI3vOrGBbokokTvMGaXk2y43oL3dTQDTUuv1z5mN3c5ND
         OooyyZhHmEZvJQyA+4IQacdQJEFpkr6bBiK4NUl9k6wW85p3AlIir3ibFMmMtY6Qq9TD
         fqESkINb02EOI4DRbF1ngP014GhCRPZbkXT/qwU80zXE1dPrV9JErVfnk+031gOZdgsK
         QRNnTMsLgxL7szlQe0aB9Eaa89Y4rxak0iTnEtWM9Izz5KWxI73nxblN5DgWTLBv0L4z
         amz6EmCibPpY+0h/AZaFzFcjGrMUBZG0cIsit1uvIT/NqO6tdRFUDS4UWqge63nz8lnN
         uOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bf0F9jShQ+1SAJ86EUg24NgoBWAimsu/bT/Rh5FZG1s=;
        b=BOQCA/HcSilICM29ZmTe//2DjocxQQM91C9vFmOJsDvYQe0MgG2X2CDzRwACZ2dwc1
         ZhnpX2iy5ricNemY2nIZwCTbfbBtUmnuZS+/zo6Ny3P539RMDhqhyvwl/X+qM8t11d+Q
         /B+b11hLTmaXMkNsaS8HW1OupVniuWYOUEPwYG3wtGaWLa70tmgsSoSOapwwMmYOS7NN
         n0bnK4Ad6aGh+++F/+fwyhn06ryF/mBjUDzmWznY9jofQnUj3I60/kS/BqWPJ3TAjozL
         F/3dlqCraa1/KZZwo0UrfJ519huEoFIpB/8CpKtoTD0LFyT0qjgBU0YezwrUwopd3BtI
         GGiA==
X-Gm-Message-State: ANhLgQ1QW1zsilksW/YqjVQ/M2JR9+CDQoo8cKzq0dg8kQGnTguK4F5j
        I/uZPhdKp+LOqkEiDg2TzWJO2VWINBoyE/S8bespTg==
X-Google-Smtp-Source: ADFU+vsDQKW3R25VEwr3nSycpnRKEuPn9Ka8m2GJ4Ff+Y0C3ACVegdgxU99TJEZiTKPoBSL+tFKcVLL9KbINqFJnp/M=
X-Received: by 2002:a6b:4e15:: with SMTP id c21mr4776187iob.119.1583258927645;
 Tue, 03 Mar 2020 10:08:47 -0800 (PST)
MIME-Version: 1.0
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-3-sean.j.christopherson@intel.com> <CALMp9eThBnN3ktAfwhNs7L-O031JDFqjb67OMPooGvmkcdhK4A@mail.gmail.com>
 <CALMp9eR0Mw8iPv_Z43gfCEbErHQ6EXX8oghJJb5Xge+47ZU9yQ@mail.gmail.com>
 <20200303045838.GF27842@linux.intel.com> <CALMp9eSYZKUBko4ZViNbasRGJs2bAO2fREHX9maDbLrYj8yDhQ@mail.gmail.com>
 <20200303180122.GO1439@linux.intel.com>
In-Reply-To: <20200303180122.GO1439@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 3 Mar 2020 10:08:36 -0800
Message-ID: <CALMp9eRUPP_89mNwRTMpm6vg2jcaYNvj7R5yLK6HhLrub-iAEg@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: x86: Fix CPUID range check for Centaur and
 Hypervisor ranges
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 3, 2020 at 10:01 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Mar 03, 2020 at 09:42:42AM -0800, Jim Mattson wrote:
> > Unfathomable was the wrong word.
>
> I dunno, one could argue that the behavior of Intel CPUs for CPUID is
> unfathomable and I was just trying to follow suit :-D
>
> >  I can see what you're trying to do. I
> > just don't think it's defensible. I suspect that Intel CPU architects
> > will be surprised and disappointed to find that the maximum effective
> > value of CPUID.0H:EAX is now 255, and that they have to define
> > CPUID.100H:EAX as the "maximum leaf between 100H and 1FFH" if they
> > want to define any leaves between 100H and 1FFH.
>
> Hmm, ya, I agree that applying a 0xffffff00 mask to all classes of CPUID
> ranges is straight up wrong.
>
> > Furthermore, AMD has only ceded 4000_0000h through 4000_00FFh to
> > hypervisors, so kvm's use of 40000100H through 400001FFH appears to be
> > a land grab, akin to VIA's unilateral grab of the C0000000H leaves.
> > Admittedly, one could argue that the 40000000H leaves are not AMD's to
> > apportion, since AMD and Intel appear to have reached a detente by
> > splitting the available space down the middle. Intel, who seems to be
> > the recognized authority for this range, declares the entire range
> > from 40000000H through 4FFFFFFFH to be invalid. Make of that what you
> > will.
> >
> > In any event, no one has ever documented what's supposed to happen if
> > you leave gaps in the 4xxxxxxxH range when defining synthesized CPUID
> > leaves under kvm.
>
> Probably stating the obvious, but for me, the least suprising thing is for
> such leafs to output zeros.  It also feels safer, e.g. a guest that's
> querying hypervisor support is less likely to be led astray by all zeros
> than by a random feature bits being set.
>
> What about something like this?  Along with a comment and documentation...
>
> static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
> {
>         struct kvm_cpuid_entry2 *max;
>
>         if (function >= 0x40000000 && function <= 0x4fffffff)
>                 max = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
>         else
>                 max = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
>         return max && function <= max->eax;
> }

I can get behind that. The behavior of the 4xxxxxxxH leaves under kvm
is arguably up to kvm (though AMD may disagree).
