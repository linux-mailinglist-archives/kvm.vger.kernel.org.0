Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFFD588EBD
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 16:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbiHCOhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 10:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiHCOhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 10:37:19 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FF215834
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 07:37:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f11-20020a17090a4a8b00b001f2f7e32d03so3817728pjh.0
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 07:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=DikMXzSPR9SB1FD1PEwSoIy3cN2RFBQwNnjtdcuFOQ0=;
        b=S64VuIqgqzzDNLrkVOdNeMD8S1BIgQJTXTL9EVQN5P2AciUhw995F9/p270iVgQLMI
         920PQ1iDEjy1dnCn/FbYQJLyHSd7W8SiPGWsZgpbI7Vboi5TSkmBY0EGBSRBweEkslio
         TWdOczuwSyPqyY2IPp5WbDMwXE5W7izNarKbzdrtlovvdvGmkIc2kNCGaD9NcE0+ClcP
         4zQ6ODFGb3TpWizdQZ7pXXiLuSd82vwBPlEq6F0wlgNOUhKkCL0EpPPnCfx0GvD31xVY
         9DofAAr5tCevBoazMR54Ij35ByHq8UGQ5nWdcaSkooA1paDp2yX/6nnp4auXs4HYodV4
         +Zwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=DikMXzSPR9SB1FD1PEwSoIy3cN2RFBQwNnjtdcuFOQ0=;
        b=X9tqjVxgej2a/dxa04hqhl66yXpbxgAeDMOXiJjP22k0MmkQt7EeaH4FkqcaVuzwpD
         Rkxs44SjhXmZsSbSOuyqvbZfMq3LQi3zrG86hqvWsWs/8WjvXYbt8OtfRD2O+vtgfsqq
         pP1GEOOtv9ttJcp4HdsU7jEqJmmKCOHARKGhecExW1j1DI3CE9JkCNyuB+zWadsyv5bo
         /4hU1okzVAcmCrgI6TK4+vBrzHMHLjiPKguKRc1bLed4LjADKxFT9XiaGBgHG7an5JXI
         f3kpMjzTbbttHjnpYrgrY8Hz7L+4yEzJR26H/BcC9+E/xaSpu0bStWxunUTOW0HrAx9S
         cfMQ==
X-Gm-Message-State: ACgBeo1qYXLMVV9HqZfrUZA28kQvfIlE2jDs/FgOm8SNpjJQ80SnrSCU
        bydjmBrNUDBqtc8n/VWahaJjcw==
X-Google-Smtp-Source: AA6agR5XUZVVwElKYa8DKSNzWnPhbFD0Bnq7xBVKLuT6SJx2yjjZW4uAM39Q3eDL2SeuU5LFV1CjTQ==
X-Received: by 2002:a17:902:6b4b:b0:16e:ef21:5664 with SMTP id g11-20020a1709026b4b00b0016eef215664mr14062872plt.122.1659537434815;
        Wed, 03 Aug 2022 07:37:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n4-20020a17090a4e0400b001f53e3863casm1679034pjh.10.2022.08.03.07.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 07:37:14 -0700 (PDT)
Date:   Wed, 3 Aug 2022 14:37:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: Refresh PMU after writes to
 MSR_IA32_PERF_CAPABILITIES
Message-ID: <YuqIFjlk5iDtVnRm@google.com>
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-2-seanjc@google.com>
 <cb631fe5-103d-30f5-d800-4748f4ea41fa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb631fe5-103d-30f5-d800-4748f4ea41fa@gmail.com>
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

On Wed, Aug 03, 2022, Like Xu wrote:
> On 28/7/2022 7:34 am, Sean Christopherson wrote:
> > Refresh the PMU if userspace modifies MSR_IA32_PERF_CAPABILITIES.  KVM
> > consumes the vCPU's PERF_CAPABILITIES when enumerating PEBS support, but
> > relies on CPUID updates to refresh the PMU.  I.e. KVM will do the wrong
> > thing if userspace stuffs PERF_CAPABILITIES _after_ setting guest CPUID.
> > 
> > Opportunistically fix a curly-brace indentation.
> > 
> > Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
> 
> Shouldn't it be: Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting") ?

Strictly speaking, I don't think so?  fw_writes_is_enabled() returns false if
guest CPUID doesn't have X86_FEATURE_PDCM, and AFAICT there are no other side
effects that are handled by intel_pmu_refresh().

> Now, all the dots have been connected. As punishment, I'd like to cook this
> patch set more with trackable tests so that you have more time for other
> things that are not housekeeping.

Let me post v2, I've already done all the work and testing.  If there's more to
be done, we can figure out next steps from there.
