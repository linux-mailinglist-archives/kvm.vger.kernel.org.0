Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC6D5A2AA5
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 17:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245369AbiHZPKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 11:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244437AbiHZPJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 11:09:02 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7970CDD4EC
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:08:35 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g19so1846659pfb.0
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=rDCiGRameoc44J7lHWbl0JPQBn/IEONwz9o9l1i/k5o=;
        b=VQf8EKuL0X7CTzQMT9/lmQ+1rlvFbqSdWJ43L2omf4zYAogNVKx+E1+/4NxJWp71SJ
         upBbQVhWVUJgfYiXHlKIPENQcY4w5U5t2RiKYJ1PfGxVKiRSReXEYab8Qccb52pLO1Gz
         9k6Yu3mGdHw96K7FOVQvnspayt0a1/FKDnVi8LZ03IepA9Ug+67nWgCGDqoT3JkI05xu
         nbk0SFMOuytiK/CcgApCgKitlSaJ+nc/lkDgP+Tj82x0OHPOdPl7qO+otN0tngOpDBh8
         nQw21ypSGxxW1TEWOIRpqxxDz8wh9kWTKp1xo+SGr3tJ0u90VX3TrVPkKVczUhCGQoZz
         /e2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=rDCiGRameoc44J7lHWbl0JPQBn/IEONwz9o9l1i/k5o=;
        b=YSepokWUw2mqAtNVybdgtyyCvDCYV0nCqQg/Mj31mdfVYZR3opdMGPmoD4Ll+hevz+
         dGGphsM4v1z/nzzZUvsmqbQGks+V2EYuZk7vAY1i2JFkd28rdwvu6mN8syYoX0IWEuLH
         b8KiO5V7Kmk+3TehuY0/tI+woAmcFbrhKi7K6VY56F7WTYPEgDvDJx10/ZhpvBQw9t+B
         bl5o+kaqgX4lAaOBNnxKg7E+kShPXWOZdzIsSBmUJFtVUMOgAETQlpV4ar/0XDiTZndc
         EMqpG0D67SSCgBO2zG81Hvfv/EPkBkFYFYUpw+RBi0hWQpahQHjRedP0IqhyfnH9x2at
         H3KQ==
X-Gm-Message-State: ACgBeo24b7N0svRJptq0rFokTxkyxXJ23wH7qaSVVNYr4dNZTLr3NRfx
        EZHPwuhDiCW4gBRvL/xSJqzuHg==
X-Google-Smtp-Source: AA6agR5uCZ7VBJfvhJmt8rw74pIfwFba099AydbeQHgPwVRGBIy1lChlBYYL7MzvcFd9dTtAf6OYiw==
X-Received: by 2002:a63:f704:0:b0:42b:7fa6:19bd with SMTP id x4-20020a63f704000000b0042b7fa619bdmr1671900pgh.283.1661526514860;
        Fri, 26 Aug 2022 08:08:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z15-20020a170902cccf00b0016c0eb202a5sm1693664ple.225.2022.08.26.08.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 08:08:34 -0700 (PDT)
Date:   Fri, 26 Aug 2022 15:08:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] KVM: VMX: Stop/resume host PT before/after VM
 entry when PT_MODE_HOST_GUEST
Message-ID: <YwjhaPdvmklwXf9B@google.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <20220825085625.867763-3-xiaoyao.li@intel.com>
 <YweWmF3wMPRnthIh@google.com>
 <6bcab33b-3fde-d470-88b9-7667c7dc4b2d@intel.com>
 <YwecducnM/U6tqJT@google.com>
 <4e383b85-6777-4452-a073-4d2f439e28b1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e383b85-6777-4452-a073-4d2f439e28b1@intel.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022, Xiaoyao Li wrote:
> On 8/25/2022 11:59 PM, Sean Christopherson wrote:
> > But ensuring the RTIT_CTL.TraceEn=0 is all that's needed to make VM-Entry happy,
> > and if the host isn't using Intel PT, what do we care if other bits that, for all
> > intents and purposes are ignored, are lost across VM-Entry/VM-Exit?  I gotta
> > imaging the perf will fully initialize RTIT_CTL if it starts using PT.
> 
> Personally, I agree with it.
> 
> But I'm not sure if there is a criteria that host context needs to be
> unchanged after being virtualized.
> 
> > Actually, if the host isn't actively using Intel PT, can KVM avoid saving the
> > other RTIT MSRs?
> 
> I don't think it's a good idea that it requires PT driver never and won't
> rely on the previous value of PT MSRs. But it's OK if handing it over to
> perf as the idea you gave below.

Yep, my thought exactly.

> > Even better, can we hand that off to perf?  I really dislike KVM making assumptions
> > about perf's internal behavior.  E.g. can this be made to look like
> 
> you mean let perf subsystem to do the context save/restore staff of host and
> KVM focuses on save/restore of guest context, right?

Yep!  KVM already more or less does this for "regular" PMU MSRs, though in that
case perf hands back a list of MSRs+data.  But for Intel PT I don't see any point
in having KVM do the actual MSR accesses.  Tracing has to be turned off _before_
VM-Enter, so using the MSR load/save lists doesn't buy us anything. 
 
> I would like to see comment from perf folks on this and maybe need their
> help on how to implement.
