Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B5B6E28C8
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjDNQ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjDNQ4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:56:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BBF4230
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:55:55 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n3-20020a170903110300b001a50ede5078so11652910plh.8
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681491355; x=1684083355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/CHSlTSd3N8g44bYo+dzvuKpfboW/yvp0BrTP/tMkTE=;
        b=dV95e0sZyjnS6hOCoSmYE4HHtgh8oBiwz76SZWvJGB8ksgh3z/Hk42+hzRlELv4pY3
         eOYGg/2rRkvWAPOBAcecfJrf0UpuLLeHKlK2dG3YtTFBirK3mAxPJnIn2Qn0UBKavn8U
         vIIBNyvRHXvVJqekReX1XbAIeomHB6DC+vjJ6KG8A+AH2412vT+pkwBBmFhNQ/lRlbCr
         rt4ZtujWcy+yJtbQibYk+YjWA7QDr8ndcPmk1XBkHHurmUAb01lF3B5lOKRYNby9cK7j
         BLjrHltpt775eTCGO9Ku+YkAGUvtvJAKuuHp6MOHWqf62LY/mk4QqYhO3bVLasDciat+
         RGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681491355; x=1684083355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/CHSlTSd3N8g44bYo+dzvuKpfboW/yvp0BrTP/tMkTE=;
        b=IeiWrTwlgHqPU2u/UB3tPZ+bXv6OdED4sifUCYzGen1L2QJZsHkG25cuFgAWijb9OI
         DWE73G3A3FOBVNHu+srXg0Y1EBb3/LzaalvagcCiJAZshw7sywjaxq5c6OQC82VZJHfl
         4iVExg1v1pOcs507sIoO1KWMav949sEfkHitn6Saxiidi9xJ124jm/X1avkAqpOa1Ng4
         8DnJSdrWvnADetKul1lev8cQkOnOo+oLGloS2idxUsfUExYnyb9jz4vv+Y+q75UmtUvH
         bA5Q4kMKUUWt4NswFVQg5M6Woho0iaEhp9D2ccfLAdTHf3vHbNrFf9rjQkauCTx4TwXs
         QSeQ==
X-Gm-Message-State: AAQBX9frDS1sisHilAfuUJRlu3qBliTKJWL+xuMGRm6Wc+QxDkHjK6GB
        Rs9xr21pM3E2qNI4NA3ZheDz7EsLQ6I=
X-Google-Smtp-Source: AKy350adQowQwr3yxq3+IS2GGOLLapJUyeAl/BrmgjtSTRz1FWIGg26Fs6Ub5ZHTWEJYNBqfqo6Z0of1QQk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:a619:0:b0:51b:3c11:fb17 with SMTP id
 t25-20020a63a619000000b0051b3c11fb17mr984161pge.12.1681491354873; Fri, 14 Apr
 2023 09:55:54 -0700 (PDT)
Date:   Fri, 14 Apr 2023 09:55:53 -0700
In-Reply-To: <7332d846-fada-eb5c-6068-18ff267bd37f@linux.microsoft.com>
Mime-Version: 1.0
References: <20230413231251.1481410-1-seanjc@google.com> <7332d846-fada-eb5c-6068-18ff267bd37f@linux.microsoft.com>
Message-ID: <ZDmFmfPWmGxX855M@google.com>
Subject: Re: [PATCH] KVM: x86: Preserve TDP MMU roots until they are
 explicitly invalidated
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 14, 2023, Jeremi Piotrowski wrote:
> On 4/14/2023 1:12 AM, Sean Christopherson wrote:
> > Preserve TDP MMU roots until they are explicitly invalidated by gifting
> > the TDP MMU itself a reference to a root when it is allocated.  Keeping a
> > reference in the TDP MMU fixes a flaw where the TDP MMU exhibits terrible
> > performance, and can potentially even soft-hang a vCPU, if a vCPU
> > frequently unloads its roots, e.g. when KVM is emulating SMI+RSM.

...

> Thank you, I just tested this and it works wonderfully! Is this still on time for 6.3?

This is too risky for 6.3, but I am comfortable applying it for 6.4.

> In case you need it:
> 
> Tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> 
> I'd also like to get this backported all the way back to 5.15 because the issue is
> already present there. I tried it myself, but this was before async zap and i'm
> doing something wrong with refcounts:

For 5.15, I think our best bet is to just disable the TDP MMU by default.  There
have been a _lot_ of relevant changes since 5.15, I am skeptical that this patch
can be backported to 5.15 without pulling in a big pile of changes from between
5.15 and 6.1 or so.

I added you to a related thread[*] about TDP MMU backports for 5.15, let's continue
the 5.15 discussion there.

Thanks!


[*] https://lore.kernel.org/all/ZDmEGM+CgYpvDLh6@google.com
