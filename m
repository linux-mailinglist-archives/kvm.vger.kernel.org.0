Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811FC5EB316
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 23:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIZV2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 17:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiIZV2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 17:28:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9CEA261C
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:28:42 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j6-20020a17090a694600b00200bba67dadso8193491pjm.5
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=BSxwN1blbO9o4mvvlVqSk+QYYJi/P+H+Gku7okdIw6w=;
        b=oaiJ7NuxPxGbqm96aXsHRKz8mmI5aVzOWF52Lk+sYBMF1vQTjYGzPYC/Syo7aVaKsP
         tBc9PDB1wev9DSE95fHpNcRmKnX1bUCR9+qasbTyo8uFfy/rVBDrYGlTRsI4J7/73fID
         C47bD1+Gy94sDGiocZXnqmPbEfPSVoom3tWEGO1HnUFwnPWK6wxO1JokLHHtVhKUeRya
         gaLXpXOdKezvzq0VnV8w+alHU78xBA3Z2PmJo4RpSM7j87KROqyKY5x9jCXDDd0Rsb1f
         Xao7EUKLGoxfX2S6A85ZNKFea3Gkh0UZbTeONNnU/+hU/8VB4R0Jb7DL4OpDWMl0bN0u
         0T1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=BSxwN1blbO9o4mvvlVqSk+QYYJi/P+H+Gku7okdIw6w=;
        b=pzj4bSOpumlfodz6w8ALybvO8wA9oW5vU3k0VgwX3DU3YXux3MtZkp+GTZn+5MjPSd
         Btrx0cmY3ihSDJHOGz8xtyv/KcTwcRwHCvqSmSTWXWJsB06+4Io7fNkYZkT37o6MwBUY
         eFz9U2Dqxk6pvK51bZlRCJLSsJYzz1Zvn6HNcNv26w/e9Ghm6VecUfqEdmOu9+lboByD
         Ca0OarLCc9GiKtph6NdCA0PX2AG907P//hLwv5fTI1UCD2FdAnnJ3eAzqXFDO0asYJel
         aRaoTunFffgQ+sxAdQEbpYc8CBRK7IQEeeoNRYYO+wAui9VFGZrKHMx772Rxe+rgYMgB
         Jsfg==
X-Gm-Message-State: ACrzQf2LiyZKUr7Ymi5C6cY2DFVS/1tOGGdqh2vlpjGmW3IslDSxkY4t
        Ej0SjA7lAlRJEe5oftUW+44iGQ==
X-Google-Smtp-Source: AMsMyM6AOj3zqMG+GPdSN4AwTCkSWbU4QaG3nIR3j2iJMEGcwr7j7Ai63K2UpbYbdsGNWB39bnhmlQ==
X-Received: by 2002:a17:90a:c711:b0:202:5cda:765c with SMTP id o17-20020a17090ac71100b002025cda765cmr800921pjt.35.1664227721973;
        Mon, 26 Sep 2022 14:28:41 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k11-20020aa7998b000000b00537d60286c9sm12707916pfh.113.2022.09.26.14.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 14:28:41 -0700 (PDT)
Date:   Mon, 26 Sep 2022 21:28:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Message-ID: <YzIZhn47brWBfQah@google.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
 <YxtOEgJhe4EcAJsE@google.com>
 <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
 <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
 <dfcbdf1d-b078-ec6c-7706-6af578f79ec2@redhat.com>
 <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022, David Hildenbrand wrote:
> On 23.09.22 15:38, Emanuele Giuseppe Esposito wrote:
> > 
> > 
> > Am 23/09/2022 um 15:21 schrieb David Hildenbrand:
> > > On 23.09.22 15:10, Emanuele Giuseppe Esposito wrote:
> > > > 
> > > > 
> > > > Am 19/09/2022 um 19:30 schrieb David Hildenbrand:
> > > > > On 19.09.22 09:53, David Hildenbrand wrote:
> > > > > > On 18.09.22 18:13, Emanuele Giuseppe Esposito wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > Am 09/09/2022 um 16:30 schrieb Sean Christopherson:
> > > > > > > > On Fri, Sep 09, 2022, Emanuele Giuseppe Esposito wrote:
> > > > > > > > > KVM is currently capable of receiving a single memslot update
> > > > > > > > > through
> > > > > > > > > the KVM_SET_USER_MEMORY_REGION ioctl.
> > > > > > > > > The problem arises when we want to atomically perform multiple
> > > > > > > > > updates,
> > > > > > > > > so that readers of memslot active list avoid seeing incomplete
> > > > > > > > > states.
> > > > > > > > > 
> > > > > > > > > For example, in RHBZ
> > > > > > > > > https://bugzilla.redhat.com/show_bug.cgi?id=1979276

...

> As Sean said "This is an awful lot of a complexity to take on for something
> that appears to be solvable in userspace."

And if the userspace solution is unpalatable for whatever reason, I'd like to
understand exactly what KVM behavior is problematic for userspace.  E.g. the
above RHBZ bug should no longer be an issue as the buggy commit has since been
reverted.

If the issue is KVM doing something nonsensical on a code fetch to MMIO, then I'd
much rather fix _that_ bug and improve KVM's user exit ABI to let userspace handle
the race _if_ userspace chooses not to pause vCPUs.
