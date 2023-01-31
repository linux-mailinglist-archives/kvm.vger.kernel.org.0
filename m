Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801EB682151
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 02:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjAaBSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 20:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjAaBSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 20:18:21 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AA4EB64
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 17:18:20 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z1so6144846pfg.12
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 17:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nnGMVzde5byvHYv17zn6FGm6u3wHPxyGxlsrl0lhE4k=;
        b=gS0UsTJncWvJRfQYP2inbr0w8Mu5L22CyzmfbiAUp4QGhqcYv8bfopuKXmpnPhn60D
         j7Dp9z24RyPgxOKgbgXGB+7ucB1mepqL6e6kBB3mG/4prdlzc55q5buz/8HMzcfC4JH/
         gbvvzqjuqYmQuezVRVJ61lOEwbGna5b+/05CTJuZ+gahL0an2W1MckQeEF0wZ2C1TrYu
         1/wf+9L9E1vXfLPWqlXVklOubKKHzRRNn6fSe81pA375Z1fkulDNSG2RDWalOdATwxNY
         nQj3gDyIuAteYyGe/zpDLMzrsSVDJYAXrxmeeKi5q5jf+hii7FkGWgIu3Wb9YE/L0amr
         /0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnGMVzde5byvHYv17zn6FGm6u3wHPxyGxlsrl0lhE4k=;
        b=LwtJOBpvz+bfY9ykgVCFGde/W12xVHgdZbOM17RIcOb/Fco5VGsyhJEVrdu/zVll5K
         VEDsOPAJJGGBL/dj/cPVVt2X3cxPPyxj31o5rQT3v/PBFafP79ujusknpv3kEtRvu3oU
         MSOEyNDjcQj9VzzSONbxwzuRcVJZlQ3BnLTNFiDF/ihkpQyB8/GR6Y5MwffKzFvhy6Sw
         pb97PcIyIQXEdfbRInKwyZlsjlJD3el7yBEjwHWE5GGDjHdW79T9fR+jZj9g/0UhfZPF
         WfDo6EKWRmqICgOf7pK5sCO/lOeQfGJQMmDvPqpkH+GzOWYCpRl5EZhAe1CI+hGFQvlt
         h07A==
X-Gm-Message-State: AO0yUKX3vQQJ2h0n5F+mdUVPh3lDK7t+dn/23L6eejr55oB6aSiWzoga
        LhkuuUSOPPdt1xaKg/huk9fhSg==
X-Google-Smtp-Source: AK7set84RIWN7hVEPNjMKdYDJlU9OE3wecVWlKxUY5LLjtg26d7CD6T9yaGuw2Qq10wRBRGhv6rL6w==
X-Received: by 2002:aa7:858a:0:b0:576:9252:d06 with SMTP id w10-20020aa7858a000000b0057692520d06mr1040361pfn.0.1675127899947;
        Mon, 30 Jan 2023 17:18:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f18-20020a056a00229200b0058bca264253sm8040903pfe.126.2023.01.30.17.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 17:18:19 -0800 (PST)
Date:   Tue, 31 Jan 2023 01:18:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is
 enabled
Message-ID: <Y9hsV02TpQeoB0oN@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi>
 <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org>
 <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9g0KGmsZqAZiTSP@google.com>
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

On Mon, Jan 30, 2023, Oliver Upton wrote:
> I think that Marc's suggestion of having userspace configure this is
> sound. After all, userspace _should_ know the granularity of the backing
> source it chose for guest memory.
> 
> We could also interpret a cache size of 0 to signal that userspace wants
> to disable eager page split for a VM altogether. It is entirely possible that
> the user will want a differing QoS between slice-of-hardware and
> overcommitted VMs.

Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
guarantees for all VMs on a system are better met by enabling eager splitting
across the board.

There are other reasons to use module/kernel params beyond what Marc listed, e.g.
to let the user opt out even when something is on by default.  x86's TDP MMU has
benefited greatly from downstream users being able to do A/B performance testing
this way.  I suspect x86's eager_page_split knob was added largely for this
reason, e.g. to easily see how a specific workload is affected by eager splitting.
That seems like a reasonable fit on the ARM side as well.

IMO, we should try to avoid new uAPI without a proven need, especially if we're
considering throwing something into memslots.  AFAIK, module params, at least on
the x86 side of things, aren't considered immutable ABI (or maybe it's just that
we haven't modified/removed one recently that folks care about).
