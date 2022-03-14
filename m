Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494644D805C
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 12:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbiCNLIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 07:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiCNLIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 07:08:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56D8C47ACD
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 04:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647256023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BLRs68CPmtcOOmJUEUtuz0QjAh+LK/7FJhncH6x/EEo=;
        b=Yjdeum6tofEFIr369Ht4TQAXUBeRO14UkhtfK76AHcnywvcBLzxZ6thmqtPltGwKxFL6N7
        uX/kT84qvgstCttDRyHwP/IZiFwAXGX5YPZfzao4s4ybrXjtymDaS+P4UFM5vJbZQrM5aj
        18aMc2Ahbu71zq9C+8sb7m76Afic/t8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-XXWd30KjPuuitN9HEWXHrA-1; Mon, 14 Mar 2022 07:06:57 -0400
X-MC-Unique: XXWd30KjPuuitN9HEWXHrA-1
Received: by mail-wm1-f71.google.com with SMTP id v184-20020a1cacc1000000b0038a12dbc23bso483635wme.5
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 04:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BLRs68CPmtcOOmJUEUtuz0QjAh+LK/7FJhncH6x/EEo=;
        b=V0N519XC/4mI0Ey8beHtRAvoiI98W1BKZ7RQNIF6+xKyvCIxEk7svZo/97hPbLG0Ua
         nLAHH3TNbYBJxBeVRx6T4bHJPzezp/OBoWCIFaqZXnV0ZvEqS7LDWkVFLGXidZtDy70G
         N7OeAkNLqS3CdChRem45X98PxwolBlJEj1gwFH0Z+lsaQgwipzQXNlBMrWCt5kfakAFy
         D5BEqN4LhGcVS4Me3EL9kcQQy2FNfyOvu34EoZndE/yn/f52VatT3/ZGBgHKc9EPIVBJ
         g3Rmte5IYyqGXPGZmKDYr8QgYl5j9B4ZQmHSyvUPf5lnq+DVof6ee8p2TdNCBmXKrdg9
         T93g==
X-Gm-Message-State: AOAM5326PMufxihXw5C8HmFRjwr5VHHDQPtqjIj5jHIkLlzsVma0W0tO
        AdIiHDuO04tMlCwlVpYDiekAj4mjmDe7Gg6tm6b/Bhi9UfBQZJQk49/nyUkhEjSWbVYOTLSatWL
        EeyFejngXAhuu
X-Received: by 2002:adf:9d88:0:b0:1fd:872a:3a0a with SMTP id p8-20020adf9d88000000b001fd872a3a0amr15620424wre.579.1647256016150;
        Mon, 14 Mar 2022 04:06:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDX2/Els7mxEyTxNLaQi6KS3CEEUZl7kN4Gi+HlG0m0rhAIBD9QQawS/L0DgWyElEpRqGYyw==
X-Received: by 2002:adf:9d88:0:b0:1fd:872a:3a0a with SMTP id p8-20020adf9d88000000b001fd872a3a0amr15620397wre.579.1647256015917;
        Mon, 14 Mar 2022 04:06:55 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id t184-20020a1c46c1000000b003814de297fcsm17674129wma.16.2022.03.14.04.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:06:55 -0700 (PDT)
Date:   Mon, 14 Mar 2022 12:06:53 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 000/105] KVM: selftests: Overhaul APIs, purge VCPU_ID
Message-ID: <20220314110653.a46vy5hqegt75wpb@gator>
References: <20220311055056.57265-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311055056.57265-1-seanjc@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 05:49:11AM +0000, Sean Christopherson wrote:
> First off, hopefully I didn't just spam you with 106 emails.  In theory,
> unless you're subscribed to LKML, you should see only the cover letter
> and everything else should be on lore if you want to pull down the mbox
> (instead of saying "LOL, 105 patches!?!?", or maybe after you say that).
> 
> This is a (very) early RFC for overhauling KVM's selftests APIs.  It's
> compile tested only (maybe), there are no changelogs, etc...
> 
> My end goal with an overhaul is to get to a state where adding new
> features and writing tests is less painful/disgusting (I feel dirty every
> time I copy+paste VCPU_ID).  I opted to directly send only the cover
> letter because most of the individual patches aren't all that interesting,
> there's still 46 patches even if the per-test conversions are omitted, and
> it's the final state that I really care about and want to discuss.
> 
> The overarching theme of my take on where to go with selftests is to stop
> treating tests like second class citizens.  Stop hiding vcpu, kvm_vm, etc...
> There's no sensitive data/constructs, and the encapsulation has led to
> really, really bad and difficult to maintain code.  E.g. Want to call a
> vCPU ioctl()?  Hope you have the VM...

Ack to dropping the privateness of structs.

> 
> The other theme in the rework is to deduplicate code and try to set us
> up for success in the future.  E.g. provide macros/helpers instead of
> spamming CTRL-C => CTRL-V (see the -700 LoC).

Ack to more helper functions. I'm not sure what the best way to document
or provide examples for the API is though. Currently we mostly rely on
test writers to read other tests (I suppose the function headers help a
bit, but, IMO, not much). Maybe we need a heavily commented example.c
that can help test writers get started, along with better API function
descriptions for anything exported from the lib.

> 
> I was hoping to get this into a less shabby state before posting, but I'm
> I'm going to be OOO for the next few weeks and want to get the ball rolling
> instead of waiting another month or so.

Ideas look good to me, but I'll wait for the cleaned up series posted to
the KVM ML to review it. Also, I see at least patch 1/105 is a fix. It'd
be nice to post all fixes separately so they get in sooner than later.

Oh, some of the renaming doesn't look all that important to me, like
prefixing with kvm_ or adding _arch_, but I don't have strong preferences
on the names. Also, for the _arch_ functions it'd be nice to create
common, weak functions which the arch must override. The common function
would just assert. That should help people who want to port to other
architectures determine what they need to implement first. And, for
anything which an arch can optionally adopt a common implementation,
*not* naming the common function with _arch_, but still defining it as
weak, would make sense to me too.

Thanks,
drew

