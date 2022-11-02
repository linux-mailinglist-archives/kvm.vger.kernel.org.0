Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6476172F6
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiKBXnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiKBXms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:42:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1A01839D
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:38:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so236401pjk.1
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v8g09QGXGwajJFxJiM8SthqcbKDhMxi+OJTAU6EZzow=;
        b=iPajeQMEZLvseF55MhfR7MZ9XLva8tybd1z572+hm7kMERTfaFfdrb/tsuov0x5C9b
         9kB0dNXn0xh9woMo/Z2OTrnJ0mC7dPy4OkThNpxxeGDj2rhIGrDtsABCG11Bb8GLTIPh
         tNNHHHjqWHArfQ94z3luJSpHnVRaxDtr5r+L43GO50Ns6we5Frisw/Wh5iA48hVj7+SE
         JIXxppdhM+hDxXGWbyP0R9OrawnTvtABiM6mrwzEtaFRQB0lyAV+RSVbWC2fUeDjmWOK
         51+fpE9eeVMyeaZlT0M3AimEBtD5vXZMb3TMLaxILtFlqiHiwp6YSjnXqsB0RWefrigC
         WFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v8g09QGXGwajJFxJiM8SthqcbKDhMxi+OJTAU6EZzow=;
        b=7WTqQtum8tLB5zGXWJ6rwSPtS3VusNIaHShYfBHX6JKtLaENU0D+IguBH8JGarJYfb
         Ri9yb1oZXjuH8i0A7MpSA9BwHVHobAla4nLyoROf7yCorxnHW+gUghjAX7ocgM3blbUV
         giH7j1YXU0KUDVVOfJujZLjHYmA7z3MYq7TyOpe4mi0dk505gNEnUdvDCQusW3XWiOwj
         5MwHpL7qbauB4t73d7c8KDSKnN92PGROCU4wyGhViwQYn17jj55iYMGDOD71PwK7klen
         ENz0ikFW9HV699T66KgPJ9+RDAWgo0yE2jZ98aLyp6SVyJMG229cQZy0ydNE1UMG5r7l
         cfRA==
X-Gm-Message-State: ACrzQf10ZcF/eVmlGgofNVJOo2gfoHUwatfE50vFfqizg7uYmRktDVzL
        9LUjR7oEIijryzhqyMQM9KrQIA==
X-Google-Smtp-Source: AMsMyM6zlNHKTS/waUpXVcPPqP4mUOVtnO/r1fS+90eZU6QmyimkTsHBcvXN/FBIS7WneieUHmj3jQ==
X-Received: by 2002:a17:90a:7d0a:b0:213:ee54:a707 with SMTP id g10-20020a17090a7d0a00b00213ee54a707mr17337602pjl.206.1667432309328;
        Wed, 02 Nov 2022 16:38:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902ea1000b001837b19ebb8sm8934984plg.244.2022.11.02.16.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 16:38:28 -0700 (PDT)
Date:   Wed, 2 Nov 2022 23:38:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v9 0/4] randomize memory access of dirty_log_perf_test
Message-ID: <Y2L/cWBjAtGheXNw@google.com>
References: <20221102160007.1279193-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160007.1279193-1-coltonlewis@google.com>
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

On Wed, Nov 02, 2022, Colton Lewis wrote:
> Add the ability to randomize parts of dirty_log_perf_test,
> specifically the order pages are accessed and whether pages are read
> or written.

David, or anyone else that's intimately familiar with dirty_log_perf_test, can
you look over the changes in patches 3 and 4?  They look good to me, but that
doesn't mean a whole lot :-)
