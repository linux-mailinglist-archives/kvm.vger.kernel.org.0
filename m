Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF97B50C15B
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 00:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiDVV7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 17:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiDVV7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 17:59:00 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC762B6F70
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 13:41:56 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id y85so9848314iof.3
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 13:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PIHedjvBDUsd4o0hzUsuDNj6ptFVTAlpQe59DURQa44=;
        b=oPO5Yme2y6EXk+fi6Lg8OhVIAVnIWkQGaDDC9BX04q6vbLeGn9fa4C+0nNAI1KB3Ap
         GJ3lDkeLxz/RC2Mn+I0BJbJ/SIcCy3bkUVoidHCqveVWxNpOniChJSHEjoXOUv3v3hEK
         ttEB6l7t9bxij3rfjOiWbcpjsBWLHC8NYvFw48qjT/lcQV79kYwH7HvuHrqnzfqm2VhL
         jmbhjaqlWtqQLTXWVnSmIL7dtVKNqaQgoLSPeES5HDckhkWXKBxiE3YsewOYkDwjCvdc
         wRZSzh0E0v/26h84z5+gDanAse3uW30/Q8TyYTi046k7NDB4ay0Wi/dpb949ukm52o+K
         ZEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PIHedjvBDUsd4o0hzUsuDNj6ptFVTAlpQe59DURQa44=;
        b=JtJr5RqJlpMk/W/iMBDOVQ0jbBCbtfhCyp7EwUtn9W8GO1c9Ap7GBz4fbspMuVX2c1
         9QQEtZ7nGzOtMC/qQP08aagXj4hlJMdT+WdSwRmiqUzZG2wTpQKAWW7aFQMyfJBRFvZc
         qRoISmBbtCLgpuY8A/Uyo7wwRJjYH64oKDWZqzVXEAqHoH1VSp+Ax7NTJ7Stm+pV2Vli
         MYG7QZcCj7C8pm1Qp5/ocGwx1hafIigI0bngqPhcPLOBYgKs13kdA5/WdGJVKvu6blwp
         ZKq5D81A1RefxvUXg9jn+KErKrMLAqRX+rW2logc+0IEoc985w9is38YdLFoVeyoGGPD
         4eAQ==
X-Gm-Message-State: AOAM533w145WyugE5G6fJIsZcSapUbvnB7iKbFUHQBGJepWNgybR44uj
        3s+BSXkWReHiL/Wh0p1f9znUcg==
X-Google-Smtp-Source: ABdhPJy+APL9BkWInbd+QFDrmKyPHiSNDP9EVCz9Mw0NDYDizkUIV8IR5t71M6VANKddfh1vSizGaA==
X-Received: by 2002:a05:6638:35a0:b0:32a:8f99:fa03 with SMTP id v32-20020a05663835a000b0032a8f99fa03mr3002986jal.8.1650660115087;
        Fri, 22 Apr 2022 13:41:55 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id w3-20020a92d2c3000000b002cbca0cd15fsm1970376ilg.8.2022.04.22.13.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 13:41:53 -0700 (PDT)
Date:   Fri, 22 Apr 2022 20:41:47 +0000
From:   Oliver Upton <oupton@google.com>
To:     Quentin Perret <qperret@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YmMTC2f0DiAU5OtZ@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
 <YmFactP0GnSp3vEv@google.com>
 <YmGJGIrNVmdqYJj8@google.com>
 <YmLRLf2GQSgA97Kr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmLRLf2GQSgA97Kr@google.com>
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

On Fri, Apr 22, 2022 at 04:00:45PM +0000, Quentin Perret wrote:
> On Thursday 21 Apr 2022 at 16:40:56 (+0000), Oliver Upton wrote:
> > The other option would be to not touch the subtree at all until the rcu
> > callback, as at that point software will not tweak the tables any more.
> > No need for atomics/spinning and can just do a boring traversal.
> 
> Right that is sort of what I had in mind. Note that I'm still trying to
> make my mind about the overall approach -- I can see how RCU protection
> provides a rather elegant solution to this problem, but this makes the
> whole thing inaccessible to e.g. pKVM where RCU is a non-starter.

Heh, figuring out how to do this for pKVM seemed hard hence my lazy
attempt :)

> A
> possible alternative that comes to mind would be to have all walkers
> take references on the pages as they walk down, and release them on
> their way back, but I'm still not sure how to make this race-safe. I'll
> have a think ...

Does pKVM ever collapse tables into blocks? That is the only reason any
of this mess ever gets roped in. If not I think it is possible to get
away with a rwlock with unmap on the write side and everything else on
the read side, right?

As far as regular KVM goes we get in this business when disabling dirty
logging on a memslot. Guest faults will lazily collapse the tables back
into blocks. An equally valid implementation would be just to unmap the
whole memslot and have the guest build out the tables again, which could
work with the aforementioned rwlock.

Do any of my ramblings sound workable? :)

--
Thanks,
Oliver
