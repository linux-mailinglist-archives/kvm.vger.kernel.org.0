Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344E35F39DD
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 01:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJCXb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 19:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJCXb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 19:31:56 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD03915A34
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 16:31:54 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id f23so11045265plr.6
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 16:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ipeRx9vfN7Vi60GSthGSXnH8xPrXk9tPweBtxgyHIaM=;
        b=SfIaYiI/8wuos9B8EmfgVUptX+pDIUu8C309HDpUNVg9LF1GXQfXPvpJDhMFdq8x+m
         oyGo38Mqi6WmS+4PnnMUQi9tLI083kH6dd1WdSzltJuJWMy+yTi97f3dJlk01ZGEmakl
         /ppUzJGZWUZaPVXs9b6rHXdOI5CBfNR84z8/fIqU2Xw951+LsMkpgrumFy36i5/kNPiQ
         1yITua/pnfosUI1mhe9Bi58+bH27bWIaFO04pFnQPPoerxAYvYWsw4caEcDcFm6/1rDh
         /55uFomoM3G0H8jeiDZbs7Vz2kpQLFWMDuuJ3qQSR6pNQ71pylPCszH0V1/y/dFYzv1S
         T7bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ipeRx9vfN7Vi60GSthGSXnH8xPrXk9tPweBtxgyHIaM=;
        b=GWj8jSqClfQC60UqZHTjGBMchQtZTElRbJ0bCWMeSoF8+aqOmdpZkE/kw2oOswjQTX
         cwTv+wc5VowmfB85YVFKHqivXkrY058X5N8p4TI4r6JTwGU7LHa0kZ3cwu7IvCSQIC5I
         8PoQ9X3lcxdyG7TJ5dGpj6ZvG32uF1ULNPV4ZzLuDpEGMvwLBAJHaSCMv8AqVNHGGifW
         UfhOUPuB7/4snRSGgBaIhVvE+TSNkNJfKP/+3cPGeGtpz0+kgy1yddRa3tTr32cwBiac
         1P+l+voy+Ivr39/itcKZr2evywopVA0cOeIXMlYHP/omfS2nWY6FOxVsQES+ubV8IKiZ
         BzSA==
X-Gm-Message-State: ACrzQf1t2vxYewSk+58ymuRAJ6E3oYQB6sJhlYg3z4T1/fyFM9QnUve4
        Ed9ujjfSNgg7vY5KY138hDWLuA==
X-Google-Smtp-Source: AMsMyM5okC3wZZzyq7+dvwZZS5Y+HoEUQmsEnFD31SSkmo4TPs9pKUQoj9XSDMneZqqIcUiruCpbng==
X-Received: by 2002:a17:902:820a:b0:178:456e:138 with SMTP id x10-20020a170902820a00b00178456e0138mr24283035pln.145.1664839914212;
        Mon, 03 Oct 2022 16:31:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 21-20020a630a15000000b0042b291a89bfsm7048731pgk.11.2022.10.03.16.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 16:31:53 -0700 (PDT)
Date:   Mon, 3 Oct 2022 23:31:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: selftests: Fix and clean up emulator_error_test
Message-ID: <Yztw5p+Y5oyJElH2@google.com>
References: <20220929204708.2548375-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929204708.2548375-1-dmatlack@google.com>
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

On Thu, Sep 29, 2022, David Matlack wrote:
> Miscellaneous fixes and cleanups to emulator_error_test. The reason I
> started looking at this test is because it fails when TDP is disabled,
> which pollutes my test results when I am testing a new series for
> upstream.

This series defeats the (not well documented) purpose of emulator_error_test.  The
test exists specifically to verify that KVM emulates in response to EPT violations
when "allow_smaller_maxphyaddr && guest.MAXPHYADDR < host.MAXPHADDR".

That said, the test could use some upgrades:

  1. Verify that a well-emulated instruction takes #PF(RSVD)
  2. Verify that FLDS takes #PF(RSVD) when EPT is disabled
