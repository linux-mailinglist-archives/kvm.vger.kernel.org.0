Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64614613D72
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiJaSho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJaShn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:37:43 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE40C12626
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:37:42 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 17so7169641pfv.4
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f6MbXeIWosdo9vjybEQsKSPNjMNkH/5gETThTzJuRxM=;
        b=ifJ30Qw9zH1n5BLrQVMy7hdWESTFOw8wJ2HSn6qNh3U+liDp/R/z+GplGkoxnPV/UY
         qXhhEHS+beDVFqBDNUXNkhLzLr2DwkNDcrV+mcqs6LaEyHDyqKOOQURhryUKd8/gnX1e
         QQ1MwnyfFwibqEzjjFPeybANull9eEad6ZPAgzHUdKtIW/mHO6d6j5JBXT+/asnFOwZe
         RVY0fJlFs4PIqtIofsqBXOzdXsf+3lCYs29JqTSnn/Z6UtkcErPZnGopBK/SQm7yTtiF
         6KiXoEdstRYKnLKJWF+caRGK+ARqJQdn51FigSRyspkHFhTaVLpEh//+fxVfCCsjPqGR
         8OXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f6MbXeIWosdo9vjybEQsKSPNjMNkH/5gETThTzJuRxM=;
        b=ie5BwilpG4Icujbyb25oVv8XG+FAml9YmhOIGx3MGivhZ0B25dF0bce18ZvWKRHRnA
         zlt2EzzXfZo0FVr46+Y/z4cIIB5Xm5kZkD7FHygeLpEemyGVRz7TjTJFY4EhB6awz6xx
         aSIzHmN4i3sofXxH7jWo8I8/aCdRqhGSvi3wVJ7d3EQAX02SplP29c8HijNvzzNfdCXl
         MNhQe3xaCrzxAS6lWipkAUGu6v0zP00ZA+N/Nai6/kIuF89uqUcbMMl6h4+CctRd/6re
         0Lx/sTnnhD7u+Yvspk5LDxuoUH8dzLFCU2TCwl1qM/F1tEDJxDmXv/BDIc/uDti9PRLm
         owog==
X-Gm-Message-State: ACrzQf341p7sOrC08KHbdGdnNu7n93u72MgeI5RhsSF5E9uD7LBinzfQ
        mXtVIPawBfvaMQ8jba10BGtx7g==
X-Google-Smtp-Source: AMsMyM6VJGBxz/aTzJrHwRoh84jG9YIrU9HH1O77gAN8mIN+XdEFhDksuBODyWDoXkQ7EtFPIsYBCQ==
X-Received: by 2002:a63:1861:0:b0:462:4961:9a8f with SMTP id 33-20020a631861000000b0046249619a8fmr14010645pgy.372.1667241462128;
        Mon, 31 Oct 2022 11:37:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bb8-20020a170902bc8800b00179f370dbe7sm4732278plb.287.2022.10.31.11.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:37:41 -0700 (PDT)
Date:   Mon, 31 Oct 2022 18:37:38 +0000
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
Subject: Re: [PATCH v3 10/10] KVM: selftests: Add a test for
 KVM_CAP_EXIT_ON_EMULATION_FAILURE
Message-ID: <Y2AV8hF0NLNc7vAm@google.com>
References: <20221031180045.3581757-1-dmatlack@google.com>
 <20221031180045.3581757-11-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031180045.3581757-11-dmatlack@google.com>
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
> Add a selftest to exercise the KVM_CAP_EXIT_ON_EMULATION_FAILURE
> capability.
> 
> This capability is also exercised through
> smaller_maxphyaddr_emulation_test, but that test requires
> allow_smaller_maxphyaddr=Y, which is off by default on Intel when ept=Y
> and unconditionally disabled on AMD when npt=Y. This new test ensures we

Uber nit, avoid pronouns, purely so that "no pronouns" can be an unconditional
guideline, not because "we" is at all ambiguous in this case.

  This new test ensures KVM_CAP_EXIT_ON_EMULATION_FAILURE is exercised
  independent of allow_smaller_maxphyaddr.

> exercise KVM_CAP_EXIT_ON_EMULATION_FAILURE independent of
> allow_smaller_maxphyaddr.
> 
> +static void guest_code(void)
> +{
> +	/* Execute flds with an MMIO address to force KVM to emulate it. */
> +	flds(MMIO_GVA);

Add tests to verify KVM handles cases where the memory operand splits pages on
both sides?  Mostly because I'm curious if KVM actually does the right thing :-)
It'll require creating an extra memslot, but I don't think that should be too
difficult?
