Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5025D589E10
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 17:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbiHDPC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 11:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiHDPC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 11:02:27 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7BA14014
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 08:02:26 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pm17so14231740pjb.3
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/+Qu4SA+U5B19qotIneyUe7lEJqXtlaY9V1J6vW6hl0=;
        b=OYcFFrRtycrYUKktAjeEsW1kLlLOtu0wXntfNIQmIpeMcZcpfNVtlxuOWAtptenSKi
         MeqWNoSX06S1Po1tn26CkikmWJpvX/NhsGelThRkHwNOiduJkoE3nMa2rswoJRamVSXs
         +/Q1/BzRovfs/vlWWEbZaVgLiCnGcfn9TTk9+Gq5nAZEKQr4g6VfjN1Sj5KdZSLXX2uJ
         PdqtiDjB822mcSa0/R8dckWnd0Q11xJzOk71ZuufRyQH/OaW3qZIYk9ZbTZSxcgt823i
         cGTIo/3lA8ri/EDTT3U30XxL1NXNpwHKIeEP3GCPZHfe2dRF1MKAJy/MReXePcYH7xDJ
         2rFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/+Qu4SA+U5B19qotIneyUe7lEJqXtlaY9V1J6vW6hl0=;
        b=0PEA5WvPjJAclNn4GrXx3aA6wajB8dv9imH+Ntc+RvVzZf7zA8pzF6pVWIFYlZK5xp
         r4Bjrqm5f8JD7aU/5DpumiMuibsRWfqNWqwLeSJbp719U6mWk92SP/9oGlgomPmXwVXo
         W251Z1twD/C3cCOP9caCzAE1iT9yK5mmAtGIZFJuosmROnYBIA83f/9c8epHUAE2cVQN
         /eUn6VP5SqLcO+CKkG61XhZvnmPToeDEFYWe7o5Xf+HHWPKaQ4Y2Hb/pqME4yK31bSlG
         y5HChQ+oKfqpF4QyQHDt4ayoF4ViV5l/IRTATBKTL3o54Zc4UBC72qecy4KAZLtEoDqK
         zBuA==
X-Gm-Message-State: ACgBeo3/WeWzvhVQzkDlCnHtsS6trUarGRw6QmjHDv6W4s7+x67Dsh9t
        boFcy62Kn+8XGoTbYluhvL3Z5g==
X-Google-Smtp-Source: AA6agR4MChB8vbuAqSp7lVDmPN3qP8fuuYpPFNg5PLTQgTPMCRw1qtbT1WJkSXuP3OjIl+IBsp47YQ==
X-Received: by 2002:a17:903:2685:b0:16e:da0a:9d8 with SMTP id jf5-20020a170903268500b0016eda0a09d8mr2305106plb.42.1659625345968;
        Thu, 04 Aug 2022 08:02:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h10-20020aa796ca000000b0052d1275a570sm1114348pfq.64.2022.08.04.08.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 08:02:25 -0700 (PDT)
Date:   Thu, 4 Aug 2022 15:02:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: X86: Explicitly set the 'fault.async_page_fault'
 value in kvm_fixup_and_inject_pf_error().
Message-ID: <YuvffeDKpwL6y+R6@google.com>
References: <20220718074756.53788-1-yu.c.zhang@linux.intel.com>
 <Ytb/le8ymDSyx8oJ@google.com>
 <20220721092214.tohdta5ewba556th@linux.intel.com>
 <20220804031436.scozztchwd6iqxbv@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804031436.scozztchwd6iqxbv@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 04, 2022, Yu Zhang wrote:
> On Thu, Jul 21, 2022 at 05:22:14PM +0800, Yu Zhang wrote:
> > On Tue, Jul 19, 2022 at 07:01:41PM +0000, Sean Christopherson wrote:
> > > On Mon, Jul 18, 2022, Yu Zhang wrote:
> > > > kvm_fixup_and_inject_pf_error() was introduced to fixup the error code(
> > > > e.g., to add RSVD flag) and inject the #PF to the guest, when guest
> > > > MAXPHYADDR is smaller than the host one.
> > > > 
> > > > When it comes to nested, L0 is expected to intercept and fix up the #PF
> > > > and then inject to L2 directly if
> > > > - L2.MAXPHYADDR < L0.MAXPHYADDR and
> > > > - L1 has no intention to intercept L2's #PF (e.g., L2 and L1 have the
> > > >   same MAXPHYADDR value && L1 is using EPT for L2),
> > > > instead of constructing a #PF VM Exit to L1. Currently, with PFEC_MASK
> > > > and PFEC_MATCH both set to 0 in vmcs02, the interception and injection
> > > > may happen on all L2 #PFs.
> > > > 
> > > > However, failing to initialize 'fault' in kvm_fixup_and_inject_pf_error()
> > > > may cause the fault.async_page_fault being NOT zeroed, and later the #PF
> > > > being treated as a nested async page fault, and then being injected to L1.
> > > > Instead of zeroing 'fault' at the beginning of this function, we mannually
> > > > set the value of 'fault.async_page_fault', because false is the value we
> > > > really expect.
> > > > 
> > > > Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
> > > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216178
> > > > Reported-by: Yang Lixiao <lixiao.yang@intel.com>
> > > > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > 
> > > No need for my SoB, I was just providing feedback.  Other than that, 
> > > 
> > Thanks! It's a very detailed suggestion. :)
> > 
> > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > > 
> > 
> > @Paolo Any comment on this fix, and on the test case change(https://www.spinics.net/lists/kvm/msg283600.html)? Thanks!
> > 
> > B.R.
> > Yu
> 
> Ping... Or should I send another version? Thanks!

Shouldn't need to send a new version.

Paolo, can you grab this for 6.0-rc1?
