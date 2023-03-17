Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB916BF2B0
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 21:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCQUf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 16:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCQUf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 16:35:56 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1717338B7B
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 13:35:55 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z16-20020a170902d55000b001a06f9b5e31so3311282plf.21
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 13:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679085354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UXsBpvu+OuXSXbXFftwLSxcJAZvI16z2uey0luentL4=;
        b=YG07QohNbJFr1k0yWgkwrvovQrIymvrbExAV+y2cWUzyicaQBhwOvv351sqlUJ3Yr8
         wllEXKKrhzdl5A3PySiaI/fuC4pdNBKkFKuXvUTK1l/VSS6nRl0Dvoheq1d0xcCMoaJF
         LG8egdRWteX8nhVNA3SD2AUK8PdseAG81Co7a1eLjBpPvIc/b/cOHc5eMW+4ywRQ90iS
         ipYjQUpQSRkavm7MvR2zoag33cB0VZfTG6jdDb+zd8jsWpFEBFFI/OswoPOTr6LF+Yx3
         gqdmD6tT0Ifdz7MQZ1N2uXQuPY2/TFOO47ATsQLZh0XV2ygDLZOSJztRk/jAL9zspap0
         97Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679085354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UXsBpvu+OuXSXbXFftwLSxcJAZvI16z2uey0luentL4=;
        b=Jg2T96xACicmm12NCspW89jlvm38E1kCoUyVNAws/FJl9WXWbc0Zvg9oQMsV2sjiiO
         e9VvTHUKIC7IjfXBBus0TUbGCtLU2pbhezw5LY/RfHu+0nmKUsGzmob6a1Wa9ItH5/3G
         CQbQr8ud+6q99lLT63loEopn8NBLNaJswRsc5qiLj952ZRiFzY2XuquGi5Gdv+EQ/3Tk
         6MzVUj6d6DUj+4h5S9fSfErnfWcC4OVGYTE8CQ7Ud5E3FcYbI5x9UeHhd3oeD4oOm5te
         zAXiZZNHvfwqd9O1e3/QhfPz1+kgdXDGJUUitpULFnqyhv1C0/iZFZ4oUzmWEfrMSd4b
         L/4Q==
X-Gm-Message-State: AO0yUKUONEPCWijA2NLOyD/BVzwnvAocksd4LPc6/9kATBO6cHlfu5Az
        AJg+ysV3RyP8aNYQ1ulLHDJxUaDsUVI=
X-Google-Smtp-Source: AK7set/j88wg/IQLJq3hFyknq8nCI76+LdGEaCNy4pG14wWBjjQXjGngEvD0YahO+f/vw158LmkWT6W/+80=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3c87:b0:23f:1caa:233a with SMTP id
 pv7-20020a17090b3c8700b0023f1caa233amr1374526pjb.1.1679085354594; Fri, 17 Mar
 2023 13:35:54 -0700 (PDT)
Date:   Fri, 17 Mar 2023 13:35:53 -0700
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
Message-ID: <ZBTPKZlQMxXOltW1@google.com>
Subject: Re: [WIP Patch v2 00/14] Avoiding slow get-user-pages via memory
 fault exit
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     jthoughton@google.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023, Anish Moorthy wrote:
> Still unsure if needs conversion
> --------------------------------
> * __kvm_read_guest_atomic
>   The EFAULT might be propagated though FNAME(sync_page)?
> * kvm_write_guest_offset_cached (virt/kvm/kvm_main.c:3226)
> * __kvm_write_guest_page
>   Called from kvm_write_guest_offset_cached: if that needs change, this does too
> * kvm_write_guest_page
>   Two interesting paths:
>       - kvm_pv_clock_pairing returns a custom KVM_EFAULT error here
>         (arch/x86/kvm/x86.c:9578)
>       - kvm_write_guest_offset_cached returns this directly (so if that needs
>         change, this does too)
> * kvm_read_guest_offset_cached
>   I actually do see a path to userspace, but it's through hyper-v, which we've
>   said is out of scope for round 1.

To clarify: I didn't intend to make Hyper-V explicitly out-of-scope, rather Hyper-V
happened to be out-of-scope because the existing code suppresses -EFAULT.  I don't
think we should make any particular feature/area out-of-scope, as that will lead
to even more arbitrary behavior than we already have.

What I intended, and what I still think we should do, is limit the scope of the
capability to existing paths that return -EFAULT to userspace.  Trying to fix all
of the paths that suppress -EFAULT is going to be ridiculously difficult as so
much of the behavior is arguaby ABI, and there's no authoritative documentation
on what's supposed to happen.  I definitely would love to fix those paths in the
long term, but for the initial implementation/conversion, I think it makes sense
to punt on them, otherwise it'll take months/years to merge this code.

Back to the Hyper-V case, assuming you're referring to the use of kvm_hv_verify_vp_assist()
in nested_svm_vmrun(), that code is a mess.  KVM shouldn't inject a #GP and then
exit to userspace, e.g. the guest might see a spurious #GP if userspace fixes the
fault and resume the instruction.  And just a few lines below, KVM skips the
instruction if kvm_vcpu_map() returns -EFAULT.

As above, ideally that code would be converted to gracefully report the error,
but it's such a snafu that the easiest thing might be to change the "return ret;"
to "return 1;" until we fix all such KVM-on-HyperV code.
