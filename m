Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2394E9F5C
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 21:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245432AbiC1TEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 15:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245425AbiC1TEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 15:04:05 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACA2633B0
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 12:02:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so145151pjb.4
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 12:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dhGOVKb9V844LyshAqhDj5/BrH7dOz55cb0nSa/g+AI=;
        b=mbyainUX7U9+PGRKvsG6MkdGVAraaJJxQoF1i6MIBe+WIc39mfspIaC7yE9nl9xIm/
         HT9FKTPfF7oE40F5O3vgolnL7UAc5NalFgMeuPp5fPRUA9iHou8VcEVn7F3wN4a0KjUb
         uiH4zRG5RRJ20rQojcdFUmt2wgtG3IKHqT92MpFZ3oObaoRueCy13H5h8z2IY6aMrqVI
         RpUiTJ6qJpJdmGwDdaVMcUnlGcD8iKlkMzE4/xXnGhKqeKrUUvLB3I9WH4RbGxLmrNEv
         XmTjBxxEnaQc74jCdX3keX/ogcZKcnaJj9tNYx8ubOz94BSSrWjsDrRLrd1oH4O11xIz
         7L0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dhGOVKb9V844LyshAqhDj5/BrH7dOz55cb0nSa/g+AI=;
        b=FAsKJbI/KNjSlm8GFH/GjH2WAESm8XsurH7eB9JuospU2sUnagVQmKuAdUn6Wi7uxb
         hsl7bJoujQ8vMK6ISHGU5gBBjIhPHYYuD7bGo9D8ZP3Tptr0opxyQXzX0kWgahMG2v14
         wkyCvYK1pDFC52B8zEnh2J2pTBGDcSq1LBeeq1uKJoApBZZ4M0davlVNNX8Ysge7kgua
         gq2Z9Ma8V/C6+zqkRU+lVKsfiryO9Ri8p8/7XtIm2wEcUHMzt/3kZK0iXeJtYHaBbJkk
         l2t3XPMxRG8qAwsXjn7jNBm5JtLa7lSE1yw/Wxa0OYA6B6L9Ke0BaCeeCQ3pONDUxR1l
         mbRg==
X-Gm-Message-State: AOAM532pSUFAGQ2FHVYmMHcPAf7/fCDAUVnip0Jrlwlf8vRT41YHOv/w
        QbFhQEJxJ5wxb2N1BqkZqnwtbw==
X-Google-Smtp-Source: ABdhPJyPcEQSb9YWAxCjR6tmvyHD19VhWLbrkj0LPTRLxwkDA3sS6e6UBZXuI16SCQuxnisLLZr8Eg==
X-Received: by 2002:a17:902:d904:b0:154:a967:2b83 with SMTP id c4-20020a170902d90400b00154a9672b83mr27020146plz.124.1648494142870;
        Mon, 28 Mar 2022 12:02:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 21-20020a630115000000b00382a0895661sm13622059pgb.11.2022.03.28.12.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 12:02:22 -0700 (PDT)
Date:   Mon, 28 Mar 2022 19:02:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
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
Message-ID: <YkIGOmog8QCYyg/1@google.com>
References: <20220311055056.57265-1-seanjc@google.com>
 <20220314110653.a46vy5hqegt75wpb@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314110653.a46vy5hqegt75wpb@gator>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022, Andrew Jones wrote:
> Also, I see at least patch 1/105 is a fix. It'd be nice to post all fixes
> separately so they get in sooner than later.

Yeah, and I'm pretty sure there's at least one other arm64 bug fix buried in the
series.  I'll get those extracted and posted separately.
