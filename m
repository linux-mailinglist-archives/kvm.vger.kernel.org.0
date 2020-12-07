Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B2E2D1EB6
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgLHAAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgLHAAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:00:12 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E597FC061794
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:59:31 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id b18so14325645ots.0
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ADhDNSNt6I8G4BtstjMfXOHtK2RWSiGfFOI+5bfvv/g=;
        b=vmxkKZSv7VtJpr+t5DKiSVA794FYtcGFDnbYWzkb632YWPmVzxoA6KiZkk9K9ZjCmK
         K+afPxSRTfRy7lbRd1heu0q0NEiNVE3YQgrrL1Go5S77wRwoWFpsIUtZ9hmNddMNv7iY
         MRcsv7KdtV7Qkd0buVKHVyc5DEMB7XUs3Iqt08298ZrD4FB3EiRYUnc6CoPsQtha8o8V
         ZI/b1YN2CYP3IAvVFA0ceq/8TjMIat1YlJlCWJ6XB5+dJw+MdwXGuA8M1+43WreAokso
         Ek6GISInoQc8aJHQsU/FCAnweyQnfiSt4cfS6mfSFNkcA8rejc1TIf5gOeLpjjPg9XOi
         8CDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ADhDNSNt6I8G4BtstjMfXOHtK2RWSiGfFOI+5bfvv/g=;
        b=WUMhtGzA/tdk8/DzXX1LN07kbVf4+AONU+U2m/5nzvq4huLttGGvF6ONFmZfCrRUPR
         Iv1KmH4DSaT/Twe1e1IOzyYEQJNbq24+EQMLZOkBXVMIFG4IQZXKQb+5n3lCCSLtmeCR
         OGApTf7gnosALRyRCZQK5qMHH4+u87QmBBiy+awSDrdKmo/cz0aFby5IrymxDPsSsn1P
         7cME8FAGiStQhImxOWEUWzj5O8hO/XSlaOwbQobyDAI1g3qjF6GV/N1vZCBU5qZRKHVx
         CkAqLJTjeI+snEQD1Rf4L8uT2xX+OvpGOHX21VBpB/xUVArPu3ZW/xsPGtGL7LStuAiI
         zLHg==
X-Gm-Message-State: AOAM530BOcmiaa7vOFHi6+bAgB6R30vqNITfjJawKlSQUGoGORbX6jVx
        DBP9HOaEU9h6JdQshpScEesdy8DxkrHbOhV+Zt+W9w==
X-Google-Smtp-Source: ABdhPJxVnIzHHS2bwBxnDCWUT4TZipV2qBZNEk39qhR5IcdxUxY4wTyuUeyLIUup9wRfLyQrxQPkpjsz+0beZ3xqopQ=
X-Received: by 2002:a9d:d01:: with SMTP id 1mr14556642oti.295.1607385571022;
 Mon, 07 Dec 2020 15:59:31 -0800 (PST)
MIME-Version: 1.0
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
 <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru> <20201008175951.GA9267@linux.intel.com>
 <7efe1398-24c0-139f-29fa-3d89b6013f34@yandex.ru> <20201009040453.GA10744@linux.intel.com>
 <5dfa55f3-ecdf-9f8d-2d45-d2e6e54f2daa@yandex.ru> <20201009153053.GA16234@linux.intel.com>
 <b38dff0b-7e6d-3f3e-9724-8e280938628a@yandex.ru> <c206865e-b2da-b996-3d48-2c71d7783fbc@redhat.com>
 <c0c473c1-93af-2a52-bb35-c32f9e96faea@yandex.ru>
In-Reply-To: <c0c473c1-93af-2a52-bb35-c32f9e96faea@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 7 Dec 2020 15:59:19 -0800
Message-ID: <CALMp9eSMt1DwXL=wE-xyHcOyCvZzzHdgZ=N9Pqdm1CW6aSzOKw@mail.gmail.com>
Subject: Re: KVM_SET_CPUID doesn't check supported bits (was Re: [PATCH 0/6]
 KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup)
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 7, 2020 at 3:47 AM stsp <stsp2@yandex.ru> wrote:
>
> 07.12.2020 14:29, Paolo Bonzini =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On 07/12/20 12:24, stsp wrote:
> >> It tries to enable VME among other things.
> >> qemu appears to disable VME by default,
> >> unless you do "-cpu host". So we have a situation where
> >> the host (which is qemu) doesn't have VME,
> >> and guest (dosemu) is trying to enable it.
> >> Now obviously KVM_SET_CPUID doesn't check anyting
> >> at all and returns success. That later turns
> >> into an invalid guest state.
> >>
> >>
> >> Question: should KVM_SET_CPUID check for
> >> supported bits, end return error if not everything
> >> is supported?
> >
> > No, it is intentional.  Most bits of CPUID are not ever checked by
> > KVM, so userspace is supposed to set values that makes sense
> By "that makes sense" you probably
> meant to say "bits_that_makes_sense masked
> with the ones returned by KVM_GET_SUPPORTED_CPUID"?
>
> So am I right that KVM_SET_CPUID only "lowers"
> the supported bits? In which case I don't need to
> call it at all, but instead just call KVM_GET_SUPPORTED_CPUID
> and see if the needed bits are supported, and
> exit otherwise, right?

"Lowers" is a tricky concept for CPUID information. Some feature bits
report 0 for "present" and 1 for "not-present." Some multi-bit fields
are interpreted as numbers, which may be signed or unsigned. Some
multi-bit fields are strings. Some fields have dependencies on other
fields. Etc.
