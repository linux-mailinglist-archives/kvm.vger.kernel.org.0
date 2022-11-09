Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20554622097
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 01:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiKIAFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 19:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiKIAFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 19:05:06 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA015EFBF
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 16:05:05 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id q9so15206682pfg.5
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 16:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8mN4lJ0ugApMl1P1+zNxhl9RCm2csyd+rIUafb5kLio=;
        b=Ved11eCrNxyvfhZoDnk9yg1nEoH5NfSvLqbQQWkLH5gv7U3BpGORKcXovnYiMK0v0b
         ZSJmkaQmxqFPifBVIoDVlY5gYp0CiXA4BrrRrrUe0/A7qvgSmFISzkMljW0ZOz1lINow
         sH0rWbGMCHylbTsCaXEcKNRQZN17+MtUMq2LCR0l8Z5v86NGJNPMYetqm1q76nYCcJiw
         ambwzPDpVv9v72wkGNUN/OcDvzd57cKfSPqAX4jbiQb//z/0+hCgw1HkxeKdhpcQsicK
         UElHeJ0aV5lNcCgUUdKuY/qkz8GUWu9RwG2MJDk/dLFm5fUL4/t1o7Oh5BuyAkQEkunI
         IF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mN4lJ0ugApMl1P1+zNxhl9RCm2csyd+rIUafb5kLio=;
        b=EadhpDO3NbR4dw8BEkI5YDhHKq3Gr17cMWfKncZyWzC0HfNIfdZd6ClrNdZDrjZbKQ
         P4MdTiIUuKVYoI27KGMRoixbLJ5oF87XNR7pX9isRqxj5mNqFZkzyO/w1NOzK4S5261x
         TP6awE1Ge5aJYUrYRrFnI46XqjYhHCJgAPjZkfVt7F5g6HnG9crD6eEy2rIOaep1C0uC
         QR5nfiJ/yqr/c36oVFu7u86x8t5tunN0zYU/XHfJJnqA7qsbbC++Y+C5OZzh7bQ8ZU3T
         bZMkmWxrCu/OsaiMlUMZPL1u4qfBOdJPGn3rFYhgasr6LHDP9u7ODveWq1UMMK68K79v
         tAAg==
X-Gm-Message-State: ACrzQf2pLVmOL496idwWoB1Kw5FHgFyCGu163lmQS5QN5OaREYYiBVpI
        Y5og9llTO4q6CMoXrl9ALJ/WEw==
X-Google-Smtp-Source: AMsMyM6lqHfLRza4xpTYFG5OCmO3t7QpGSB8EMMMXUfcY2HCMAhGNyyP1NkF3U+FKGNN9RZhDBNBYQ==
X-Received: by 2002:a63:e153:0:b0:439:2fa3:74d1 with SMTP id h19-20020a63e153000000b004392fa374d1mr49274307pgk.85.1667952304721;
        Tue, 08 Nov 2022 16:05:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k21-20020a628415000000b0056bb06ce1cfsm7128531pfd.97.2022.11.08.16.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:05:04 -0800 (PST)
Date:   Wed, 9 Nov 2022 00:05:00 +0000
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
Message-ID: <Y2rurDmCrXZaxY8F@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com>
 <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
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
> On 11/9/22 12:25 AM, Sean Christopherson wrote:
> > I have no objection to disallowing userspace from disabling the combo, but I
> > think it's worth requiring cap->args[0] to be '0' just in case we change our minds
> > in the future.
> > 
> 
> I assume you're suggesting to have non-zero value in cap->args[0] to enable the
> capability.
> 
>     if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>         !kvm->dirty_ring_size || !cap->args[0])
>         return r;

I was actually thinking of taking the lazy route and requiring userspace to zero
the arg, i.e. treat it as a flags extensions.  Oh, wait, that's silly.  I always
forget that `cap->flags` exists.

Just this?

	if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
	    !kvm->dirty_ring_size || cap->flags) 
		return r;

It'll be kinda awkward if KVM ever does add a flag to disable the bitmap, but
that's seems quite unlikely and not the end of the world if it does happen.  And
on the other hand, requiring '0' is less weird and less annoying for userspace
_now_.
