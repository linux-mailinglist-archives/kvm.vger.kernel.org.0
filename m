Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581156D69F4
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 19:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbjDDRNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 13:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbjDDRNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 13:13:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB394D3
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 10:13:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w5-20020a253005000000b00aedd4305ff2so32931099ybw.13
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 10:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680628401;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T/fNwrurE48O/1eTwQGB8Ds9ILJ80eHcPBktl9HBdHM=;
        b=aeb/yOzd0oiIvDH2EfAyc0VJZD8YZBGfhz6URHONfjwOWUOsFEOacdCbxGekZ6cTms
         asmCZUoJo9kZoCh5Jhfdq5g7X8bXy869ngF023t+xBwEs/W4B7+2j/AWbCYeZUOmMbUW
         pIWkVL2oFgzmlS7PyjM+GrhRoKRkAgyMS/g7cIvk307vsdvUuxI/8tFKO9tLqP9LNZNA
         LQYETwNlTc89j2SAB+iOPQ4lybIvr9JWvJ6/egYbrbxIaWuWPEjYsyNHJarNM2LtwMNX
         F682eqjFmS3cBHLJgCmKLHciahxH/hRxFViBCSwF6q6r8JcPpdaM1sf/vvsSXWrCvxD0
         /WNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680628401;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T/fNwrurE48O/1eTwQGB8Ds9ILJ80eHcPBktl9HBdHM=;
        b=7blIDGfm/EsGpA4wIOVLiw/oWfhWG2rpttQZSXGQe1kVQEhn+xEKhC71ZLbJsaV/mO
         5o7k4M5+uxHqdhGc9RVdXcHqPgFnvXNiGcGjBChAM+HbmvUD562fyVd/FmRS9NSQnK+v
         9yJRn3vrdGiDVfcmm1efTgUWdrQWPw9TnBrTE8JmqZBR6XoTgPWvexhOZKHvAtz0fySV
         HFOPM/L5v+Gb4qcHaIFySm/5R9Ww1an0rLYHN15o8YOVDJP1g36TnB+Zs/bG0hxlwxi4
         14TJOrxUysiV4dJfHuMlX21iLME+wTxxPbWlzUiqc4L5nriDjHnzrZeXiwsFYZd6cXWG
         jSow==
X-Gm-Message-State: AAQBX9dcFwUnBkJ9tn5L140B8W4S9gO94vnkvWpQP8zuOzNOugI/hm9B
        DQBOPDKefITGTlf3wZ5zZskvxdyVg+E=
X-Google-Smtp-Source: AKy350Y+UilTb+9y9inS03ug/PDTwwYtCaV5/ZxpY2Vue35MBOQJsFT9avkw7JnvpjXVrP5r3HDSr8S2T/A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:df10:0:b0:b75:8ac3:d5d2 with SMTP id
 w16-20020a25df10000000b00b758ac3d5d2mr2349341ybg.4.1680628401072; Tue, 04 Apr
 2023 10:13:21 -0700 (PDT)
Date:   Tue, 4 Apr 2023 10:13:19 -0700
In-Reply-To: <a6ac4f81-f7de-1507-9be2-057865cdc516@grsecurity.net>
Mime-Version: 1.0
References: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
 <20230220104050.419438-1-minipli@grsecurity.net> <a6ac4f81-f7de-1507-9be2-057865cdc516@grsecurity.net>
Message-ID: <ZCxarzBknX6o7dcb@google.com>
Subject: Re: [PATCH] kvm: initialize all of the kvm_debugregs structure before
 sending it to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>,
        Xingyuan Mo <hdthky0@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023, Mathias Krause wrote:
> On 20.02.23 11:40, Mathias Krause wrote:
> > VirtualBox and QEMU, OTOH, assume that the array is properly filled,
> > i.e. indices 0..3 map to DR0..3. This means, these users are currently
> > (and *always* have been) broken when trying to set DR1..3. Time to get
> > them fixed before x86-32 vanishes into irrelevance.

Practically speaking, KVM support for 32-bit host kernels has been irrelevant for
years.

> > [1] https://www.virtualbox.org/browser/vbox/trunk/src/VBox/VMM/VMMR3/NEMR3Native-linux.cpp?rev=98193#L1735
> > [2] https://gitlab.com/qemu-project/qemu/-/blob/v7.2.0/target/i386/kvm/kvm.c#L4480-4522
> > [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/kvm/include/x86_64/processor.h?h=v6.2#n722
> > 
> > An ABI-breaking^Wfixing change like below might be worth to apply on top
> > to get that long standing bug fixed:
> > 
> > -- >8 --
> > Subject: [PATCH] KVM: x86: Fix broken debugregs ABI for 32 bit kernels
> > 
> > The ioctl()s to get and set KVM's debug registers are broken for 32 bit
> > kernels as they'd only copy half of the user register state because of
> > the UAPI and in-kernel type mismatch (__u64 vs. unsigned long; 8 vs. 4
> > bytes).
> > 
> > This makes it impossible for userland to set anything but DR0 without
> > resorting to bit folding tricks.
> > 
> > Switch to a loop for copying debug registers that'll implicitly do the
> > type conversion for us, if needed.
> > 
> > This ABI breaking change actually fixes known users [1,2] that have been
> > broken since the API's introduction in commit a1efbe77c1fd ("KVM: x86:
> > Add support for saving&restoring debug registers").

Are there actually real users?  VMMs that invoke the ioctls(), sure.  But I highly
doubt there are actual deployments/users that run VMs on top of 32-bit kernels.

I like the patch, but would prefer not to mark it for stable, and definitely don't
want the changelog to incorrectly assert that there actually users that would
benefit from the fix.

The only reason we haven't deprecated support for KVM on 32-bit kernels is because
we want to be able to test nested TDP with a 32-bit L1 hypervisor, but I'm starting
to think even that is a weak excuse.   The only potential problem with using an old
kernel in L1 is that we _might_ not be able to test newfangled features.

> > Also take 'dr6' from the arch part directly, as we do for 'dr7'. There's
> > no need to take the clunky route via kvm_get_dr().

This belongs in a separate patch.
