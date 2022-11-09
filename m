Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2939F6220D5
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 01:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiKIAc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 19:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKIAcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 19:32:23 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A5161762
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 16:32:22 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j12so15635537plj.5
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 16:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQ1jZB3m3JNgwDhXjvr6dpP648h3M6Z1s+n2GIXxEIo=;
        b=CRbqjBhRSNWKJ3gP6OhmCaglk6IoBDsubUDFV3xuv6NJpkfqtcN9cbk64wS63YwRkL
         RYJuhevVxMdwp6TpG2m6ovEqDuDi1rwnzTwbi5q6x6UW9LIRkegtLbQR6q5gkS9ZH0d4
         DlS9gO7IoPlW72kRJL68GlEhrzpniTOQ5j1auw/oqGpfNgGSlMSLVMCso9wiLUH0rjJK
         Ss723yFE+QJqxvL0FnZFGbqdioM536DIOSQ4ubJ6BvOmnJ4OXZokz2QYGvXy3+supDzP
         oyn6hCR3gkiZRzEElNgifAkcXPS+BZTIV1sfwb1ZkpZYjc64KOAyHnn3iNgBtCeNBj77
         byfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQ1jZB3m3JNgwDhXjvr6dpP648h3M6Z1s+n2GIXxEIo=;
        b=em99qF07NxYH+briD9asyZsJGn4csWtGJOIlOz+MUw0Mke/RZm/UdvDz5iaz8eOtzF
         vALl/isSS3kJWUJSozqM/bzTTvukZCGPixLbtV2ZmsXvu6Osv/MfK9Tow3XdpovLofnx
         qvZSQQsl3UKeVpy5vk4dZpRwpyyE5YUiW1AV5ePb8hgiOQUMMmldUrxbBuYvh81FOMfB
         SK2wUTHglAPVmLz9nR6785+xWCOspfxa0qLfmuCLDtIyKAdZMfPlFvHtXMTLnn5LinwV
         TzHEq3K8pW4EXHpTyXyPEzAOVxr9bi6csVCru4qyIAMo2fies1nqbossnShRVeAPpAq3
         sqqQ==
X-Gm-Message-State: ANoB5pmnjDsMQ0cNTwELNNoFSO4NU7yypA5Lhxdhle7DQr+Po1ZJKD3m
        /3+zUP932ztOG4X/NsIaNNmLfQ==
X-Google-Smtp-Source: AA0mqf47wfHd+WN4Dx8uEDBo8ewcqOBktb14YxfpMVMVZOcUCSxxNuC8Mn5JxqjFHWRaslv52qtr7A==
X-Received: by 2002:a17:90b:1e10:b0:217:4fd0:acbd with SMTP id pg16-20020a17090b1e1000b002174fd0acbdmr25583534pjb.235.1667953942140;
        Tue, 08 Nov 2022 16:32:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s5-20020a17090a440500b0020b7de675a4sm6612962pjg.41.2022.11.08.16.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:32:21 -0800 (PST)
Date:   Wed, 9 Nov 2022 00:32:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
        oliver.upton@linux.dev, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2r1ErahBE3+Dsv8@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com>
 <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
 <Y2rurDmCrXZaxY8F@google.com>
 <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022, Gavin Shan wrote:
> Hi Sean,
> 
> On 11/9/22 8:05 AM, Sean Christopherson wrote:
> > On Wed, Nov 09, 2022, Gavin Shan wrote:
> > > On 11/9/22 12:25 AM, Sean Christopherson wrote:
> > > > I have no objection to disallowing userspace from disabling the combo, but I
> > > > think it's worth requiring cap->args[0] to be '0' just in case we change our minds
> > > > in the future.
> > > > 
> > > 
> > > I assume you're suggesting to have non-zero value in cap->args[0] to enable the
> > > capability.
> > > 
> > >      if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> > >          !kvm->dirty_ring_size || !cap->args[0])
> > >          return r;
> > 
> > I was actually thinking of taking the lazy route and requiring userspace to zero
> > the arg, i.e. treat it as a flags extensions.  Oh, wait, that's silly.  I always
> > forget that `cap->flags` exists.
> > 
> > Just this?
> > 
> > 	if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> > 	    !kvm->dirty_ring_size || cap->flags)
> > 		return r;
> > 
> > It'll be kinda awkward if KVM ever does add a flag to disable the bitmap, but
> > that's seems quite unlikely and not the end of the world if it does happen.  And
> > on the other hand, requiring '0' is less weird and less annoying for userspace
> > _now_.
> > 
> 
> I don't quiet understand the term "lazy route".

"lazy" in that requiring a non-zero value would mean adding another #define,
otherwise the extensibility is limited to two values.  Again, unlikely to matter,
but it wouldn't make sense to go through the effort to provide some extensibility
and then only allow for one possible extension.  If KVM is "lazy" and just requires
flags to be '0', then there's no need for more #defines, and userspace doesn't
have to pass more values in its enabling.

> So you're still thinking of the possibility to allow disabling the capability
> in future?

Yes, or more likely, tweaking the behavior of ring+bitmap.  As is, the behavior
is purely a fallback for a single case where KVM can't push to the dirty ring due
to not having a running vCPU.  It's possible someone might come up with a use case
where they want KVM to do something different, e.g. fallback to the bitmap if the
ring is full.

In other words, it's mostly to hedge against futures we haven't thought of.  Reserving
cap->flags is cheap and easy for both KVM and userspace, so there's no real reason
not to do so.

> If so, cap->flags or cap->args[0] can be used. For now, we just
> need a binding between cap->flags/args[0] with the operation of enabling the
> capability. For example, "cap->flags == 0x0" means to enable the capability
> for now, and "cap->flags != 0x0" to disable the capability in future.
> 
> The suggested changes look good to me in either way. Sean, can I grab your
> reviewed-by with your comments addressed?

I'll look at v10, I don't like providing reviews that are conditional on changes
that are more than nits.

That said, there're no remaining issues that can't be sorted out on top, so don't
hold up v10 if I don't look at it in a timely manner for whatever reason.  I agree
with Marc that it'd be good to get this in -next sooner than later.
