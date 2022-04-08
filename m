Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4214F9DCC
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 21:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbiDHTyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 15:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiDHTyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 15:54:01 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616FB1403EC
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 12:51:57 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id j17so7806312pfi.9
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 12:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+/pEd7g9sc537JcQUHMmtOGN8bVdoYIMIdp7gL4NXVE=;
        b=PeCCA4cXlctPtn0PwT8WPNO9iuN3Zx2eqNN7U28qU+csc6ly0jDQLJM9RWc2E2KVbJ
         AcUypMp0H+iw53GHXK5RvKZcP8/rkjWgfvdTjfeEnY9JIOitfRbYudZTS3OeAJfIKjxM
         uWwxNEXp7qaVn1XNTPUK6KRKStSZpigRp6RLbV/f7qCFJudh74rd+5+3/mBsCYKpDhQr
         b6MnEYR99I50+9xerR2G3OP8EPzSUpe/XS9ar0zUiH6TJmrdQO8VtaU0clsWQ4qTVfyQ
         Q7y9WQwRPVDbDiMvzFb+XVfc+9H/+wBfMYeWNQwluw8HVgoUp5aKu0AkxkABo0QFHfkt
         Lq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+/pEd7g9sc537JcQUHMmtOGN8bVdoYIMIdp7gL4NXVE=;
        b=5CuKw8wDhX7zev00Aq8K1M1/jJyxrKRoatsGhimnuQkjfYP5VNU0KTF5LV3pVSfKOO
         zpVPi6P2ak0veg9gdOlPsUl1X6zpHDniEVioT7yEWasYkE3ztiihssexUJjyMqGoODCe
         1Y3TJgDRve/KB5PFSopbxLVBZI9eI/LNdBuA0UXCn5fKEsw32TRwezgTcqY7E/a3R0iE
         eq09eoEHq/UZGsizPrY1n7rpz12Z0MWiY5A6MixG9erDRtCNPPuLn1CV6zJ7yuwQEUvw
         3PZde3u+V9MqaDur9HxHX6NUCvKZ5k6KOQtDcAZS+LnxOTvWWPe3lTjgtJKZAZL98tVY
         ZkDw==
X-Gm-Message-State: AOAM530+Pk8XTdPUg6SCX34hsB5t+kMb3fLaGT9dOF8yNUR53RxE0E74
        r6fY6wtzTsJWr30JLwR8dT5tnA==
X-Google-Smtp-Source: ABdhPJwPpu43BljXU9K8AZZjz8TjJeuS+SQLKh0qH/CIk0qQsuh7ASoLZtzI2XHsdurOpzw4rkCUUQ==
X-Received: by 2002:a63:4642:0:b0:398:b6b9:5f45 with SMTP id v2-20020a634642000000b00398b6b95f45mr17104239pgk.518.1649447516713;
        Fri, 08 Apr 2022 12:51:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k13-20020aa7820d000000b004fa72a52040sm26955599pfi.172.2022.04.08.12.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 12:51:55 -0700 (PDT)
Date:   Fri, 8 Apr 2022 19:51:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 02/11] KVM: selftests: Dump VM stats in binary stats
 test
Message-ID: <YlCSWH4pob00vZq3@google.com>
References: <20220330174621.1567317-1-bgardon@google.com>
 <20220330174621.1567317-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330174621.1567317-3-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022, Ben Gardon wrote:
> Add kvm_util library functions to read KVM stats through the binary
> stats interface and then dump them to stdout when running the binary
> stats test. Subsequent commits will extend the kvm_util code and use it
> to make assertions in a test for NX hugepages.

Why?  Spamming my console with info that has zero meaning to me and is useless
when the test passes is not helpful.  Even on failure, I don't see what the user
is going to do with this information, all of the asserts are completly unrelated
to the stats themselves.
