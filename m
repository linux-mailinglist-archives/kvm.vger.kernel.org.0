Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255432168A8
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 10:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgGGI4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 04:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGI4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 04:56:43 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90164C061755;
        Tue,  7 Jul 2020 01:56:43 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id x2so844409oog.5;
        Tue, 07 Jul 2020 01:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZZzWL/xc4mBiRyert9mLtVE7SP6XFUEzRJKwc2vJTLo=;
        b=jphMRn6XES2wHadQ9X4fBtjp8+n0umR28p140tNHzFSURfwd1MVe/wmCIAILZL7jGT
         p+lW5yC6ATOc2IOYSYMY3m1koCA8cZJV4fStFv5YQu+g+ckpCcyAgqYNCEzoZ8mqc1TC
         q2V+CJH7Pz04jC2EDKO/Mxo4HKKbaihO51C/HyejKT9ULWcED7zUgjAnaZGV9aVe7UL9
         ud3e+bJBvh3WL3dMd5Epb2hlSe8thXGzx1dPxWkVByykFkAN13eDvhtpajehOnBCostg
         5HZ+RRIGghzmxZWg8MYqobGGMltBfQZU0zTh8WSXSgmjeL7K7BX95zJQxSDgHTj31Gda
         oTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZzWL/xc4mBiRyert9mLtVE7SP6XFUEzRJKwc2vJTLo=;
        b=Zm3d2G0vdLqr52lp8uvj4Hhy9bImH/VFdX7u32Z4YoNOuPeZK7x3UHf4aLdB/65Z4x
         3rRVZiZHItQhTQAN+nXM6ICZX7RKDRvjnFhW/uXbiXhVOikwu9WJHe2E1iV0nKvdkkim
         ff3NmCVcuDzNJ84f9HGU2gdLpF0udsmRPNB1UNucIIoVb+n+MZDKGMsf8xCY0RBTHWsa
         8PVsq5VWXXStbxFz0K28y2T1PZElQv7GMZxfY66GbUSmGvOBb4gdmiHv0+d/yd8OsqHR
         y1LC0ZRGOgqaXrN2LzXuI7CQAEX42uhgai2S2iVx6XBuAgLpWAi7UGDq3OPdOB3eU8QM
         eSJw==
X-Gm-Message-State: AOAM533CQgVuRxBjIr1CXNg86+5eli709CwKViwzsovzOCjUgPQbKJNI
        obvr5+xD6/GEfiszi/pQe0wJfH+DCdhce342Z8s=
X-Google-Smtp-Source: ABdhPJxfwqZPXXjIx+FHumcjPYrKlNWZZqej3ICA99IKgp/Wcn7Dr/HgQsD3Hrh6oJ4thvzuIwZ6TqbPQpEITg4w0OM=
X-Received: by 2002:a4a:b389:: with SMTP id p9mr11582417ooo.39.1594112201814;
 Tue, 07 Jul 2020 01:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200702174455.282252-1-mlevitsk@redhat.com> <20200702181606.GF3575@linux.intel.com>
 <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
 <20200707061105.GH5208@linux.intel.com> <7c1d9bbe-5f59-5b86-01e9-43c929b24218@redhat.com>
 <20200707081444.GA7417@linux.intel.com>
In-Reply-To: <20200707081444.GA7417@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 7 Jul 2020 16:56:30 +0800
Message-ID: <CANRm+CwyRPMCWO1wZhu_iv22+9uCE6_L3jnJ2_KEgMnA_Spfhg@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jul 2020 at 16:15, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Aren't you supposed to be on vacation? :-)

A long vacation, enjoy!

>
> On Tue, Jul 07, 2020 at 10:04:22AM +0200, Paolo Bonzini wrote:
> > On 07/07/20 08:11, Sean Christopherson wrote:
> > > One oddity with this whole thing is that by passing through the MSR, KVM is
> > > allowing the guest to write bits it doesn't know about, which is definitely
> > > not normal.  It also means the guest could write bits that the host VMM
> > > can't.
> >
> > That's true.  However, the main purpose of the kvm_spec_ctrl_valid_bits
> > check is to ensure that host-initiated writes are valid; this way, you
> > don't get a #GP on the next vmentry's WRMSR to MSR_IA32_SPEC_CTRL.
> > Checking the guest CPUID bit is not even necessary.
>
> Right, what I'm saying is that rather than try and decipher specs to
> determine what bits are supported, just throw the value at hardware and
> go from there.  That's effectively what we end up doing for the guest writes
> anyways.
>
> Actually, the current behavior will break migration if there are ever legal
> bits that KVM doesn't recognize, e.g. guest writes a value that KVM doesn't
> allow and then migration fails when the destination tries to stuff the value
> into KVM.
