Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96DF5E6CFE
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 22:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiIVUZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 16:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIVUZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 16:25:39 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3666D33D9
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 13:25:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v186so2481864pfv.11
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 13:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=cNYKHjCXGHwA6gkDe3m1/Mipnx1ERqXA6xSU0q3Y+ZY=;
        b=lMppMlY3TXx+2JubIDlxi3jCLHZUazHVJWaD2U71k1qmwj+gjmzer+3MnvCj0gsNb7
         OpaTnF/oCXgzTFSMj75M9qbqov2TAtTo1KYACVBI6BqTjZaE6Q84ZIJMYDPsqOhy1SgP
         1AG65abpY8FTpFMDA3yZkedWrpaMiY2g7BrTHrAG/vT71zvEq0llw5e2vDagl+p1hCag
         9RP8eYvAIssm2TslekZgISJUmkCq1ryS7p26hsZkwO2Km3FSFIR4YpISsBDyfpnn7AJN
         1xgGw87IbqxgiVrsqfc1EcLBHdgYQPi6vHi/HDCKCO2lrs2L8EpP2FOowS0BwgvIXbet
         hw2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=cNYKHjCXGHwA6gkDe3m1/Mipnx1ERqXA6xSU0q3Y+ZY=;
        b=uCx+IsgBsIMifXoQ+GmGrMIRlxOheOFnT+QvLSwvv7/6uXdz3UsYnFqN5qEA3vYlia
         a9iFe3RVQEEc70KvTCrLTciuKbDWDr9L5pcLYTnpepdv2gc9jXH6LpzjbxfwWpKELP7N
         SeWGfJ41YDU8+b7kWJdrT3jizWXddgV7RiAbAXVmoGIYjQygBZ4LBoDMquzb+BbAV6Gn
         jW3xjpOWmTrHosogGpuT5V0/YQK0hELGx1Dl5kz+N3ZLuHbu1Kkd3ddBGkW8Lkbk/nYp
         uRDl3XL7tAUN/K1yLJMlrQAfEX2Smi+xB2jab6GB5siNBjHQrVqldr0vdF78v2Jh3+1l
         Jw6Q==
X-Gm-Message-State: ACrzQf0S03EpDgsvOCt6AFzNWv799rewu30NBVT0N/XYicLatm55Okfk
        Id8EeIC9SOIzEUP/lbsnHRdRyA==
X-Google-Smtp-Source: AMsMyM4fhHNxOFdOFgBnADpcIe7DbJBMYYMbH6058a3uazv9hRKVPfD+O/+VPtKVB3q84AOWjesaOA==
X-Received: by 2002:a65:680e:0:b0:43c:f0f:4554 with SMTP id l14-20020a65680e000000b0043c0f0f4554mr4097366pgt.469.1663878337390;
        Thu, 22 Sep 2022 13:25:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i22-20020a17090acf9600b002008d0df002sm175975pju.50.2022.09.22.13.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 13:25:37 -0700 (PDT)
Date:   Thu, 22 Sep 2022 20:25:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: selftests: Check result in hyperv_features.c
 test only for successful hypercalls
Message-ID: <YyzEvar3EXBG9Cbe@google.com>
References: <20220922062451.2927010-1-vipinsh@google.com>
 <87fsgjol20.fsf@redhat.com>
 <YyzDmYAhWkMRt6E4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyzDmYAhWkMRt6E4@google.com>
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

On Thu, Sep 22, 2022, Sean Christopherson wrote:
> The bug Vitaly encountered is exactly why it's pre

Premature send :-)

What I was going to say...

The bug Vitaly encountered is exactly why upstream process _strongly_ prefers
splitting patches by logical changes, even when the changes are related or tiny.
Bundling the fix for the egregious bug with the enhancement makes it unnecessarily
difficult to grab _just_ the fix.  In this case, Vitaly was on top of things and
there was minimal fallout, but imagine if the fix was for KVM proper and needed to
be backported.  Some unsuspecting user would grab the "fix", apply it to their
kernel, and suddenly be presented with previously unseen failures.
