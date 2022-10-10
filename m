Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81615FA15D
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 17:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiJJPre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 11:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJJPrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 11:47:33 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3E0192BE
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 08:47:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h10so10738736plb.2
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 08:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=38bkz2rj37yvg1FSVn1XpCc0RJZgvKfJA19ixr+HjcM=;
        b=A7kqGOi3cfYOzH7oYGqQKrWNaSZVNvw/nwUPC5t+48TQV1GsjNC16tNK7adzelH83c
         pqLYro3M6TgFZe63cGWcxX5REZuNJV3B+Lhj9jy1bFIv3657YN4Zmanvd0ZIFBgbTGj8
         Lv5Y0RHzsBdN9/5G9zLGxEJUUm4vQmcJ3zhfcWjkEn0YeZfwDyLJkqZOPZ4dt2nrSM+p
         rbHVTExrIZVLN9fi3DfmRCK9JTk0x6SS3RskMlNCVBUpe9d2KqmfA4vZi1FmdcoMs6wb
         duhsxeaY/BaIAo6hFbTrvruXX+W5oZRMeufyMFtc8ZsP/S6STYwTgEM4ZYP7BejJmtLN
         0a2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38bkz2rj37yvg1FSVn1XpCc0RJZgvKfJA19ixr+HjcM=;
        b=6+KaTwHdTxmxY/8FtmPYbCeWnSUP5ts8cz87fZre3z3OJtbJ7AmKkzVUFUZ0RajOd9
         0THAXpWMpnVPIv9+hIlzQHfFDrcKClwuuxy1RW1hUmG2I380QC8f5PdS6vbOG0NgYoch
         WiOPTzugqYMNaY3B5D72dHg0AWkP1pJjM3tEs08o+Cqwy8K/7SUpbWkhX2cpN4DHmleT
         pRQml2LvRE8iZbL/db5FIxq+Ka//QFZRsgduxFqn5tnX9aL1GfCRtPXP7CN9n6oWpJvs
         Y91+qLhfl5Wj2xgnsH4XplVnPW5jKXYYUkR5qWqSHgKxZcPPpjTYlD9NhEtYG7qfVD8q
         AvLw==
X-Gm-Message-State: ACrzQf0uR+U8MDJAuLepuaL+Fi1ksiLfk3M4w6vCEdWPDiG/CqIus4N5
        RJ9YxUefDPolZ2WXXAoHMmw3Ng==
X-Google-Smtp-Source: AMsMyM6nNgmhzoALWM8NcrPXTiKt+HGyxyokTFa7ipEsSFipUgFfhUAde23YgwvaC3hiQ/fEuahnag==
X-Received: by 2002:a17:902:d4ce:b0:177:fe49:19eb with SMTP id o14-20020a170902d4ce00b00177fe4919ebmr19457744plg.170.1665416851787;
        Mon, 10 Oct 2022 08:47:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090322cb00b0017f72a430adsm6789207plg.71.2022.10.10.08.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 08:47:30 -0700 (PDT)
Date:   Mon, 10 Oct 2022 15:47:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v6 5/5] KVM: selftests: Add selftests for dirty quota
 throttling
Message-ID: <Y0Q+jmx/4YG7dwGX@google.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-6-shivam.kumar1@nutanix.com>
 <Y0BwDSIqPYCZZACm@google.com>
 <5feedb0e-202a-8624-601d-0058dd102c8e@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5feedb0e-202a-8624-601d-0058dd102c8e@nutanix.com>
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

On Mon, Oct 10, 2022, Shivam Kumar wrote:
> 
> 
> On 07/10/22 11:59 pm, Sean Christopherson wrote:
> > On Thu, Sep 15, 2022, Shivam Kumar wrote:
> > > +	TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of pages
> > 
> > Clarify _why_ the count is invalid.
> In the worst case, the vcpu will be able to dirty 512 more pages than its
> dirty quota due to PML.

Heh, I know that, I wasn't asking a question.  I was saying that the assert should
tell the user/developer running the test why the count is "invalid", i.e. why the
assert failed.  Put yourself in the shoes of a random developer that's new to KVM
and knows almost nothing about dirty logging and isn't even aware PML is a thing.
Write the assert message for _that_ person.
