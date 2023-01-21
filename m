Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0223E676281
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 01:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjAUAiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 19:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjAUAiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 19:38:54 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA1C5A82F
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:38:51 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id kt14so18005002ejc.3
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=19pWO7xChDtkSAGI4ECGJZ4keAzDCQso8oMam6OUV9M=;
        b=CHFCrxSlXrdhmZg3V0QMDAVuHmCFohERNl/3OMpUttNY/Tr1aKUqS1iHwMlXPgLr/2
         GXgGpWhKRaT3w4yVnIQazvAZIIVh2EvZA4Qw+ogVDE1qE3Zw4c3qbJJOjh+VBEVcKaYo
         OM7qD5oAIg8IIQjfwVEUGzsRrQXt1Cz6cdDXd27aN/tTXSYIbTFTghrSUkvsu2yYN+lB
         2MCHIeR2oxQhRPdG9djRd71l/yikNwb4SRy1HrD9VY8cJYZF3XdgDq+ox83znzmdATm/
         7Ln8XZ0uZq/g6NyIIjqwrsYAnZeYDS9Br3X99e9KLUMU9hPnB5kIYpPN1V9zQ0q+NhqS
         nO+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=19pWO7xChDtkSAGI4ECGJZ4keAzDCQso8oMam6OUV9M=;
        b=nJV54bvSWUgxuZemU3GnjendyjosKS0pPUc2SxLSlFDJsQ4NF3YF5VoOgwBNzlu68g
         HjbtkDBzYhUcSBVu6dW3Z7aPefG82kFR9Ukrr0fM9XbQlGWWHpwE1gOLiN7j4AdjsZca
         ryBCtxi/4+MLjfMCEsSbuhWtMpjJmBJ5bCJ6stDV9rlRFeWyj8HGzsjTrFhrwP7I+4kS
         tVxIyker4BQjvhuxIS5ZiO6FLwjmD6csSV5W9TAefwFtDQD7afayU6kKa6I6s8Drhtfo
         R/4sXqmmKL318ZXRS7HAuuCR+4HWfFPFAH3ujf1kLNR9uNwcWe/aPYtoUan57hD5nWjN
         H22A==
X-Gm-Message-State: AFqh2kr6cY4rG6YlzrzYc5GUP1Fng0oPeu/tLJjF4X6RKlAzpv3horZ+
        7H1be8hdY0x8hionF8FTq0965fu47KMQaOHzksxBNg==
X-Google-Smtp-Source: AMrXdXtEHJLojVyOnHBTY/B2Gpg3Wa9sCKEu7Vr8NJndGSKip072vgXb5Xh8+bcjdZbXft6BQEToovdk5jHgeQv4E74=
X-Received: by 2002:a17:906:e087:b0:870:450d:c2b1 with SMTP id
 gh7-20020a170906e08700b00870450dc2b1mr1514459ejb.45.1674261529375; Fri, 20
 Jan 2023 16:38:49 -0800 (PST)
MIME-Version: 1.0
References: <20221206073951.172450-1-yu.c.zhang@linux.intel.com> <Y8nr9SZAnUguf3qU@google.com>
In-Reply-To: <Y8nr9SZAnUguf3qU@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 20 Jan 2023 16:38:37 -0800
Message-ID: <CANgfPd9fLjk+H9aZfykcp31Xd-Z1Yzmd3eAC5PUGhd9za0hnfw@mail.gmail.com>
Subject: Re: [PATCH] KVM: MMU: Add wrapper to check whether MMU is in direct mode
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Jan 19, 2023 at 5:18 PM Sean Christopherson <seanjc@google.com> wrote:
>
> +David and Ben
>
> On Tue, Dec 06, 2022, Yu Zhang wrote:
> > Simplify the code by introducing a wrapper, mmu_is_direct(),
> > instead of using vcpu->arch.mmu->root_role.direct everywhere.
> >
> > Meanwhile, use temporary variable 'direct', in routines such
> > as kvm_mmu_load()/kvm_mmu_page_fault() etc. instead of checking
> > vcpu->arch.mmu->root_role.direct repeatedly.
>
> I've looked at this patch at least four times and still can't decide whether or
> not I like the helper.  On one had, it's shorter and easier to read.  On the other
> hand, I don't love that mmu_is_nested() looks at a completely different MMU, which
> is weird if not confusing.
>
> Anyone else have an opinion?

The slightly shorter line length is kinda nice, but I don't think it
really makes the code any clearer because any reader is still going to
have to do the mental acrobatics to remember what exactly "direct"
means, and why it matters in the given context. If there were some
more useful function names we could wrap that check in, that might be
nice. I don't see a ton of value otherwise. I'm thinking of something
like "mmu_shadows_guest_mappings()" because that actually explains why
we, for example, need to sync child SPTEs.
