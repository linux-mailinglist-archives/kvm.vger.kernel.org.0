Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEF64A7D04
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 01:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348616AbiBCAsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 19:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbiBCAsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 19:48:36 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAA6C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 16:48:36 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i65so787278pfc.9
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 16:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tvI7fO4FdN1qnQSTQV2t/JyDHECKHJFE6Mt0BZi3oXw=;
        b=PUkcqbVs/5C+/P9S1O37qRPR8J+w8/3Sv7FD0o0+QV+dGqTxlEdKbwfuJQMRXn93bN
         I3n0QrsqkCoCNr4oRwZ0k6O5MJ5I9l664m9Qx5DxEVQhhgiMYueYzpnyg5AwYbZYhYSk
         +RR8g+ZuZWDdpbyFw+l3R1rm5sKvT09Le4hNMEoJZRHzcCsIe9W3HRtL3JqUvU7aweuB
         8FU1LSuVtDSCREeTLtzRCV4g8C4a/Hwz8ntBVeD8Ovm8zWcaBlUyaqltm0FKeMWTirzi
         ZRY/NsEDdCLYBS2ZFPDLBPUt+ZVHHDb3jgneyVWrIHzWCaZ+CSVKxhyH7oRw2co9gHzW
         cJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tvI7fO4FdN1qnQSTQV2t/JyDHECKHJFE6Mt0BZi3oXw=;
        b=Kin5XSXnWr7PwaE+xmZVZQx1fA03GxH2+iw/FYSlt8JM/L9uW/3HBzdwiEtyl01hCd
         XrPodB1A4AV6heIPzquK4xMdGOTwSVR8lpSq8VT9h8P15YOkQs+zDS0Cgqr0VgG+ixRB
         GE1EGE9O5Gm/E3YVz2xRLE052s+0SMqtqlgH2qh3RywMjtPTCMbSm5it1yxchk1dDGWx
         Y54zfTOtKwKBp+JExcGahmBrb/y1TK1ebf4OH1ULE609uIZo1k5NkBxCqqK72WTxhSEp
         7XZkRp5Fi29lSHN3i5CxWZJm8RREpMRAPMwX4Z4lW+CiWu2K982oZWw+bNCx/7SghtHX
         mamw==
X-Gm-Message-State: AOAM531aFkFsnlk/KfE5I1dEF7u45Vl8fVPdqjSbgtGdOp78ZWIpksDT
        BYcuocV2ovPV54YWsV7n0tpXXA==
X-Google-Smtp-Source: ABdhPJwUd55lNB4tjnQCiXkl7cwaZ7kB8Jid16LVk5POwXNvuUenmSm10s2Ugu7uj7tuRF4R49r/wg==
X-Received: by 2002:a63:8ac9:: with SMTP id y192mr26429572pgd.598.1643849315931;
        Wed, 02 Feb 2022 16:48:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q4sm12459952pfj.113.2022.02.02.16.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 16:48:35 -0800 (PST)
Date:   Thu, 3 Feb 2022 00:48:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
Message-ID: <YfsmX25dYIWAVgfo@google.com>
References: <20220202230433.2468479-1-oupton@google.com>
 <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
 <Yfsi2dSZ6Ga3SnIh@google.com>
 <CALMp9eRDickv-1FYvWTMpoowde=QG+Ar4VUg77XsHgwgzBtBTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRDickv-1FYvWTMpoowde=QG+Ar4VUg77XsHgwgzBtBTg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022, Jim Mattson wrote:
> On Wed, Feb 2, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Feb 02, 2022, Jim Mattson wrote:
> > > On Wed, Feb 2, 2022 at 3:04 PM Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > Ultimately, it is the responsibility of userspace to configure an
> > > > appropriate MSR value for the CPUID it provides its guest. However,
> > > > there are a few bits in VMX capability MSRs where KVM intervenes. The
> > > > "load IA32_PERF_GLOBAL_CTRL", "load IA32_BNDCFGS", and "clear
> > > > IA32_BNDCFGS" bits in the VMX VM-{Entry,Exit} control capability MSRs
> > > > are updated every time userspace sets the guest's CPUID. In so doing,
> > > > there is an imposed ordering between ioctls, that userspace must set MSR
> > > > values *after* setting the guest's CPUID.
> > >
> > >  Do you mean *before*?
> >
> > No, after, otherwise the CPUID updates will override the MSR updates.
> 
> Wasn't that the intention behind this code in the first place (to
> override KVM_SET_MSR based on CPUID bits)? If not, what was the
> intention behind this code?

The MPX side is from commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
when guest MPX disabled"), which was a miguided "fix" to workaround an L1 KVM bug in L0.
And also to workaround an L0 userspace bug (failure to set VMX MSRs).

The PMU bug looks to be a similar snafu, it appears to workaround a userspace bug
(again, failure to set VMX MSRs) in KVM.

But once userspace started taking ownership of VMX MSRs, KVM's hack-a-fixes just got
in the way :-/
