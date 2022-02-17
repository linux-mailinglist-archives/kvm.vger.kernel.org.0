Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034094BA429
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 16:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242374AbiBQPU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 10:20:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241364AbiBQPU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 10:20:27 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18B72B048B
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:20:12 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id p8so1368016pfh.8
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E/qkjmWNEnZc6u+WVzJydl20E3qWJRohZTmAyeZzY+U=;
        b=py+QBoqD26WDkz37LVm2Jj4dss7wTMxvEk2v5Tf/coMbChX7RCcVT1+mMnHHsrFvqm
         RaE7WD34IVqZlDaGBjTIaF1iY1hpFF0zgXC0N4MiGhXvSzGBUU6soej73EEI4L6E7i9N
         kiL7bht8NlbdSGvoNtqIWgSZT+zcuhCDl7mfhVKC67MtVSwWxPRXis6fOrmqksnMgz2o
         xFWNY7x58In3riZ0tyQQbfxGlpSZnZ0LxT3mWiaBWxUZxAS+aOGqJTiscjidyrXB87BD
         EGb8u1s1BJwymzTYfbCGVD19aDNoOXccC3SvzSXf1+8EZtoS8nQICVfa5V69K7vZBqcl
         wWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E/qkjmWNEnZc6u+WVzJydl20E3qWJRohZTmAyeZzY+U=;
        b=dJ+2MTWA8vjMEkRALfCASWRrFRQN31J67cR1Gf6fb++9QBn1X3TbagxooKzBH4qB+b
         olWHkOw1f9HWPJOUVPaa2Gp9AUvHWWwb+nAUTy16uOQWhCFGPS/7uZVfJowLLwebAn9f
         ne1QmQGyngBwADtY9u+9tZO4R559eXLkdPHtaXwg8qfsHfRZ23a/ySpVg6kLZus7pGnH
         Ke4EFmCt584IEBj2cL9Ar/hawZojfH3fD1cVxLvgSGtRTVVttcykcZl0dOkzcafdfzj2
         pVFbNPAhY3qQByoTqOCSFVpHwXYK2OMcfzAjUi1VzVcNS8kS9WFjopmOdTtmKanzj9Tx
         STrg==
X-Gm-Message-State: AOAM531KWZLLlG/w0KnVGHVN8Svwuraj8G7I5+v3JFUHEPYb6FkirGaI
        csmfFrjEaeWMY2zqZ4Tx2B3FfA==
X-Google-Smtp-Source: ABdhPJyMKkepjf+A/S7lnT1hwyefFB6YxnPGe+vL5Peanje2iauUEb+BeDslYLKSPd9ckS06hHVUog==
X-Received: by 2002:a05:6a00:1a88:b0:4c9:6871:59b2 with SMTP id e8-20020a056a001a8800b004c9687159b2mr3581139pfv.31.1645111212061;
        Thu, 17 Feb 2022 07:20:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g17sm4927698pfc.193.2022.02.17.07.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 07:20:11 -0800 (PST)
Date:   Thu, 17 Feb 2022 15:20:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Shukla, Manali" <mashukla@amd.com>
Cc:     Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, aaronlewis@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add routines to set/clear
 PT_USER_MASK for all pages
Message-ID: <Yg5np2qFj7ErxhYp@google.com>
References: <20220207051202.577951-1-manali.shukla@amd.com>
 <20220207051202.577951-2-manali.shukla@amd.com>
 <YgqtwRwYbJD5f9nA@google.com>
 <e9eba920-9522-6a56-4293-b60c0f1b77ed@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9eba920-9522-6a56-4293-b60c0f1b77ed@amd.com>
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

On Thu, Feb 17, 2022, Shukla, Manali wrote:
> 
> On 2/15/2022 1:00 AM, Sean Christopherson wrote:
> > On Mon, Feb 07, 2022, Manali Shukla wrote:
> >> Add following 2 routines :
> >> 1) set_user_mask_all() - set PT_USER_MASK for all the levels of page tables
> >> 2) clear_user_mask_all - clear PT_USER_MASK for all the levels of page tables
> >>
> >> commit 916635a813e975600335c6c47250881b7a328971
> >> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
> >> clears PT_USER_MASK for all svm testcases. Any tests that requires
> >> usermode access will fail after this commit.
> > 
> > Gah, I took the easy route and it burned us.  I would rather we start breaking up
> > the nSVM and nVMX monoliths, e.g. add a separate NPT test and clear the USER flag
> > only in that test, not the "common" nSVM test.
> 
> Yeah. I agree. I will try to set/clear User flag in svm_npt_rsvd_bits_test() and 
> set User flag by default for all the test cases by calling setup_vm()
> and use walk_pte() to set/clear User flag in svm_npt_rsvd_bits_test().

I was thinking of something more drastic.  The only reason the nSVM tests are
"incompatible" with usermode is this snippet in main():

  int main(int ac, char **av)
  {
	/* Omit PT_USER_MASK to allow tested host.CR4.SMEP=1. */
	pteval_t opt_mask = 0;
	int i = 0;

	ac--;
	av++;

	__setup_vm(&opt_mask);

	...
  }

Change that to setup_vm() and KUT will build the test with PT_USER_MASK set on
all PTEs.  My thought (might be a bad one) is to move the nNPT tests to their own
file/test so that the tests don't need to fiddle with page tables midway through.

The quick and dirty approach would be to turn the current main() into a small
helper, minus its call to __setup_vm().

Longer term, I think it'd make sense to add svm/ +  vmx/ subdirectories, and turn
much of the common code into proper libraries, e.g. test_wanted() can and should
be common helper, probably with more glue code to allow declaring a set of subtests.
But for now I think we can just add svm_npt.c or whatever.
