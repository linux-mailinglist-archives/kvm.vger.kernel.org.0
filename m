Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445B6613D38
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiJaSTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiJaSTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:19:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0088113D30
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:19:40 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so16663255pjc.3
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u9APqb4OjtRvwxHcX7TzTJP4vi6yLNpeXM9WvA6TsBM=;
        b=ntREl5J2NccQ8pu4JhBdJ0YhTiH4N2HVle+BjHN7MsbCJJoEMI+9ng/g0x/x7xpSF9
         JScLe70ngoEKqdqcdZc1DSzMKKKyGRdhf1JLulDtP0MbZ6zw9O6W/KRwjYCziJCEwiDy
         WDpeOu34vTRHMlotzIwW8BDRa6dwK9Cww4s7Xxksx3BogbNfG+OkLYWWfweASOtRRC9B
         8kODRgdUvdLAEwTMcSissAasCPAGQRDwUpqtXPiptdko0P91LZlaQDRHzqhzATkdqLBd
         nCcWSXVWeNItINNCMJEObiyuA2wEGRu1uyscVOT2I9Gc6aBaloRkTuhh2QEwFkuVwcTq
         9Q1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u9APqb4OjtRvwxHcX7TzTJP4vi6yLNpeXM9WvA6TsBM=;
        b=ZlqZoY6oxDNB7rnOnvTKKK+xgNMlVfp22VEX/U2yh6VLhOiZcxClR24Gs0CBEGrRDi
         Em7LIFz1NbyMClFF7Y42UtFTWIF221M85ohdiHXu+w61k2BNPNdCCIvyPfaZTu5QBbrP
         YmnZhCyhxxk3hliimaQ01JvGDs9o3wRUsPTTVWLsRpcui08gR4AVj7VpyvUCBxQCwpoV
         e82NilUka2C74qPeqvptwjsCCKk/jB3ASSgserTz/rPp8ArOWo695uhsmbI2dA5t1+np
         +nAXz21P11iqRLl6KdWQW7Y7nQXFZFetDg+cXNA83HX8YWpgf6zwbhjYCRG79rGYMaGG
         xIng==
X-Gm-Message-State: ACrzQf19UWXw2r1Kf5YMliKxv+A0QFwtJx8FIZ8NvgKHsv80xWar7YsS
        IVeEMTwV92YM6jaemdzhFTOU8g==
X-Google-Smtp-Source: AMsMyM4A5TbeTZOxEoT0qQ8o8QWqj2l6klx6Xa2lCFMejBuitV9MWaSdyVN8A2bxABzFeIoUZB+Nlg==
X-Received: by 2002:a17:902:ef52:b0:17c:f072:95bc with SMTP id e18-20020a170902ef5200b0017cf07295bcmr15321597plx.28.1667240380438;
        Mon, 31 Oct 2022 11:19:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y123-20020a623281000000b0056bf24f0837sm4887072pfy.166.2022.10.31.11.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:19:40 -0700 (PDT)
Date:   Mon, 31 Oct 2022 18:19:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 03/10] KVM: selftests: Delete dead ucall code
Message-ID: <Y2ARuHvIp6MUi2Oy@google.com>
References: <20221031180045.3581757-1-dmatlack@google.com>
 <20221031180045.3581757-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031180045.3581757-4-dmatlack@google.com>
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

On Mon, Oct 31, 2022, David Matlack wrote:
> Delete a bunch of code related to ucall handling from
> smaller_maxphyaddr_emulation_test. The only thing
> smaller_maxphyaddr_emulation_test needs to check is that the vCPU exits
> with UCALL_DONE after the second vcpu_run().
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
