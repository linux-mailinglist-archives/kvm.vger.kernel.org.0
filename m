Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0261AB264
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 22:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437918AbgDOUSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 16:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437881AbgDOUSN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 16:18:13 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C55AC061A0C
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 13:18:12 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i19so18556762ioh.12
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 13:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dR2h0gq3ejJ5VBhwigmx2y7h5s9vsfme7qcpTRLcloA=;
        b=oawhZTJSUy6vbBGKrFGkbipToUdbwMb5EXgv0QVPku2cGvTxDHGPI6ZlnR9bTQnl2P
         Pnexn0773BQNmy1Obrej/zkmdP7bvDyY/kOHBw0b3yMpDxdFCh9/gEs+6GbC33FkeG0B
         RuzH8j7yTfQ95TSp9SLVyx/YVFbFTZGIRa4/p44ejRogMp10GCITwS24XRuqs46RQ3qS
         cE8kIY0lSdgrG0XAkfPYqQyetaeLUUQGp/O8dRsXTb9J6YaR4X3UYyUwur1xIfixFsBm
         LKdNEF1nY1dumU/74nMNfm78tgcH5jaM0HovV5b/foJAIxlCuSv3Zin9U9CmX7w5o2oN
         VrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dR2h0gq3ejJ5VBhwigmx2y7h5s9vsfme7qcpTRLcloA=;
        b=UIYLlsa78nXHf1PAgZJvbmb8BfERQ6Pxu+u4fVmdth/bU+TC3drxbG8Wx6/CBmgSxf
         Cn4OwQI1CQHCOI0nfYkDTFC+ZJwuQ7rF5DekD+BifEd4c+9ibvx0ALyw7CCsmDCrKbPr
         jNShR2gDJa9OTEG1tISR4rDIfPLhC9Ph1IYSLq4L6Jp2ps4q+/Opc1qj+IBVBIpQ7cq6
         F4k2euydKow2F5lPNqdH5xqckPd2iMfBsJ/igF7B0Mds/9F0hiNMWEA0+4Zx1frNspD5
         mnPt3xBfa3xYPwuZ+r7xkCA8N0RPtrZ0wnT5PkEreGHhQ9cMB4dHBS4QGyDVUxzdI9FG
         obmw==
X-Gm-Message-State: AGi0PuZlws3xRAK3ur/wF56hE2zSb3wN7L8UwVy0bvsxdaKPxxp19ULH
        ZYGkbL+e67V0GAd37IfusJLYAWAp+Bv4JEH3F3HJeasuBwk=
X-Google-Smtp-Source: APiQypITwupvXa7V8Ctq3WfMulTlOkb7jqPnPkQzHmlQV4/sDp9ZuvJ6LjeX+5T7hxbFgnW2vrO40gjcNab2g1UKkrE=
X-Received: by 2002:a6b:c408:: with SMTP id y8mr27530656ioa.12.1586981891789;
 Wed, 15 Apr 2020 13:18:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com> <20200415193016.GF30627@linux.intel.com>
In-Reply-To: <20200415193016.GF30627@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 15 Apr 2020 13:18:00 -0700
Message-ID: <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest"
 VM-execution control in vmcs02 if vmcs12 doesn't set it
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 15, 2020 at 12:30 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Apr 15, 2020 at 02:30:46PM -0400, Krish Sadhukhan wrote:
> > Currently, prepare_vmcs02_early() does not check if the "unrestricted guest"
> > VM-execution control in vmcs12 is turned off and leaves the corresponding
> > bit on in vmcs02. Due to this setting, vmentry checks which are supposed to
> > render the nested guest state as invalid when this VM-execution control is
> > not set, are passing in hardware.
> >
> > This patch turns off the "unrestricted guest" VM-execution control in vmcs02
> > if vmcs12 has turned it off.
> >
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index cbc9ea2de28f..4fa5f8b51c82 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2224,6 +2224,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> >                       vmcs_write16(GUEST_INTR_STATUS,
> >                               vmcs12->guest_intr_status);
> >
> > +             if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_UNRESTRICTED_GUEST))
> > +                     exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;

Better, I think, would be to add SECONDARY_EXEC_UNRESTRICTED_GUEST to
the mask here:

/* Take the following fields only from vmcs12 */
exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
  SECONDARY_EXEC_ENABLE_INVPCID |
  SECONDARY_EXEC_RDTSCP |
  SECONDARY_EXEC_XSAVES |
  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
  SECONDARY_EXEC_APIC_REGISTER_VIRT |
  SECONDARY_EXEC_ENABLE_VMFUNC);

> Has anyone worked through all the flows to verify this won't break any
> assumptions with respect to enable_unrestricted_guest?  I would be
> (pleasantly) surprised if this was sufficient to run L2 without
> unrestricted guest when it's enabled for L1, e.g. vmx_set_cr0() looks
> suspect.

I think you're right to be concerned.
