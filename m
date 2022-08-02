Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217AC5884A2
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 01:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiHBXF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 19:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiHBXF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 19:05:57 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EB1BE28
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 16:05:56 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x10so14087152plb.3
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 16:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=wkXcbAtsTpJ1ukb80aJGh/l5z35GVyN0XfgbZ64+jZU=;
        b=jfWsNf0gfrmanpRM9FP43I36ax0jnpdeIKl5U+wS3BKqUpR0kfxXYSvjE8BVEljJri
         5IfnHo+OsNMn3s1BtlEx5AACSzeovNt8aVl6Z1QyJRFSd6ENcVqbJr8I2Xh4+eDEaWWP
         dHVc2OjSmiPvrYZL2VZmd5AF/8dJxPMLw4H6y7giZfeGXSJSdaZNQceOxgvdDQLISxW/
         AthBPaNquvOKJWkgNWPycUa7PvPfwn9q4qSEb4QS2aO+pN8m04W+1w3oM87Z8z4e5j6n
         jhSqVcNty6aRQkhQ/CDEXt7C8zYtwX+0/wujjiIr6gZmYCau20munqZRnqW2gPkgcDj+
         Po6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=wkXcbAtsTpJ1ukb80aJGh/l5z35GVyN0XfgbZ64+jZU=;
        b=j1708yTHqvZ3zkNlnWkf9rFdYPU8fecy7030NyA4PIDfmdF+m8EUz36SnQvV1p6Md3
         fif0QkB59TBZb6+2U2pwD1F/8wIYT4ZAirenqMxY85hFgpB/ClyFffb5CQx7H+cF+8dv
         9B5ZjRQXodeO887GF2oiH8dmAKaWVZXPuuGHfZQT85d6SSepZ0d8ybXPj7x0QzvP5cs6
         nBfLpU83jsioY6FoY1udHZKaKDy7kUFCA1gNDhd4kjosmnQV3TpN//I0GqJ8nY8HaJWc
         IBql0ochgP//Sfbg83MH+2DgKhVMWZmvgCwBQPjjJnURIq3RJ/eZgeDvpj+is3vVUFaf
         DvjA==
X-Gm-Message-State: ACgBeo1CKdjNgw4vQFakpYNJObhT37kq5kqwErQQIB9pH/MUvTjrzyYR
        n+8OH5osz25c61bx2aqE3qjy4A==
X-Google-Smtp-Source: AA6agR5sGknDEK7qmInIe6vO3XynoXQDjKnAl4JMHB6e+1hOUeBQIKAUDAOuFg3LXjEaFbOkJbXvSA==
X-Received: by 2002:a17:90a:f481:b0:1f2:43c:a61 with SMTP id bx1-20020a17090af48100b001f2043c0a61mr1909436pjb.134.1659481555927;
        Tue, 02 Aug 2022 16:05:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t2-20020a1709027fc200b0016dafeda062sm221174plb.232.2022.08.02.16.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 16:05:55 -0700 (PDT)
Date:   Tue, 2 Aug 2022 23:05:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
Message-ID: <YumtzyBgNLWGh466@google.com>
References: <20220728221759.3492539-3-seanjc@google.com>
 <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
 <YuP3zGmpiALuXfW+@google.com>
 <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
 <YufgCR9CpeoVWKF7@google.com>
 <244f619a4e7a1c7079830d12379872a111da418d.camel@intel.com>
 <YuhfuQbHy4P9EZcw@google.com>
 <4fd3cea874b69f1c8bbcaf19538c7fdcb9c22aab.camel@intel.com>
 <YumT+6joTz2M1zZP@google.com>
 <ebbccf92d7ab97bd79dac5529f109aa5b92542ab.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebbccf92d7ab97bd79dac5529f109aa5b92542ab.camel@intel.com>
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

On Wed, Aug 03, 2022, Kai Huang wrote:
> On Tue, 2022-08-02 at 21:15 +0000, Sean Christopherson wrote:
> > On Tue, Aug 02, 2022, Kai Huang wrote:
> > > But we are not checking any of those in kvm_mmu_set_mmio_spte_mask(), right? :)
> > 
> > No, but we really should.
> 
> I can come up a patch if you are not planning to do so?

Hmm, I'll throw one together, it's simple enough (famous last words) and it'll
need to be tested on AMD as well.
