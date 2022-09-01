Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F6A5AA099
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 22:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiIAUDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 16:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiIAUC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 16:02:59 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B017095AE2
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 13:02:58 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c2so18071420plo.3
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 13:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Dt/7n6dH7yedv6I+pVNjMvqmur2tTJcsNeQOFpTnn2w=;
        b=d2/ldD38Ak7n7aLxMOpM2B9iWtjEXLVY5IwtSlO+I0X9anFNCkVoou7fYV0GbJznZD
         u1JWN+ZjTeF3cYdPad73SSTxT0xZ0zFEyl7JHsK3jCcND0KLzM4CYiTe7Jg2ra5WB58M
         cEWuyTUpjDV5XnKn2PAzKlLDIK2PrXgwVK5jZvYxbTXjpdVIfUvbWdBYye+A7RhKOPJX
         vvkAo5VlUa2PQtfRDW8qT3qHEs0ZayoFTgYLiZVmLieVhEDfS5z+62otUvBgiz5ON3jZ
         IHzZTpvciEQ/fN9UCg5FHIJXyVNB6a7DbysqN6U9iTb7cioCM7wm34FT5OYOH5bJOsFj
         yh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Dt/7n6dH7yedv6I+pVNjMvqmur2tTJcsNeQOFpTnn2w=;
        b=S0gTT1xAIzYXW6juOj6k2FkXLUrbh+2PfQm163qspy8cghebGyw/vXxx4CypvnLTKk
         SaRP5eWqiS46JksDzFRsevRNe16hn1gzehmH6sHY+nUu+STtBhKaenB9GkP1gnLofdgD
         NsXs2CqpqPwtKWNoOZA395c/i/WSwX4wIjdH0b4yNfDIaelpAITV0FjqvCduPWCHxQiG
         ZbeVzvExc58yC/5q75ygkS5uvuJLxJ3fSHEwUxtXE+ARzp89VRMLWsQMBktHBIaH/4hG
         2Tym4HkoHDZlKo/RZssiW1P1tN4CBZy61tfrHbhQGO1F7jOBdrLqESDSB1WXzxNXGj/X
         pVig==
X-Gm-Message-State: ACgBeo0Pnkj00sx2G6TVgG0HQUGJi6I4cyFNxmD1vx7svJ3oI1BUbAyN
        JQB1K4C9SrNw2gGGavI1rbS+mg==
X-Google-Smtp-Source: AA6agR4sqGaDwtDERmmixOPG41voyi1zrtn7ZyOciOz2aeu/3kcyMWhie6sUrqZegnRXI0PqO04hKw==
X-Received: by 2002:a17:90b:1bc6:b0:1f5:313a:de4b with SMTP id oa6-20020a17090b1bc600b001f5313ade4bmr886025pjb.4.1662062578020;
        Thu, 01 Sep 2022 13:02:58 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z27-20020aa79e5b000000b0053825055227sm9761982pfq.99.2022.09.01.13.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 13:02:57 -0700 (PDT)
Date:   Thu, 1 Sep 2022 20:02:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 08/19] KVM: SVM: Remove redundant cluster calculation
 that also creates a shadow
Message-ID: <YxEP7ZBRIuFWhnYJ@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-9-seanjc@google.com>
 <7281e42323b53a016cf8545b7a4547d70d87efce.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7281e42323b53a016cf8545b7a4547d70d87efce.camel@redhat.com>
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

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > Drop the redundant "cluster" calculation and its horrific shadowing in
> > the x2avic logical mode path.  The "cluster" that is declared at an outer
> > scope is derived using the exact same calculation and has performed the
> > left-shift.
> 
> Actually I think we should just revert the commit 
> 'KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible'
> 
> 
> I know that the patch that intially introduced the the avic_kick_target_vcpus_fast had
> x2apic/x2avic code, and then it was split to avoid adding x2avic code before it was merged,
> resulting in this patch to add the x2apic specific code.
> 
> But when I fixed most issues of avic_kick_target_vcpus_fast in my 
> 'KVM: x86: SVM: fix avic_kick_target_vcpus_fast', I added back x2apic code because
> it was just natural to do since I had to calculate cluster/bitmap masks anyway.
> 
> I expected this patch to be dropped because of this but I guess it was not noticed,
> or patches were merged in the wrong order.
> 
> This is the reason of shadowing, duplicate calculations/etc.

Ooooh, I completely missed that x2AVIC was already supported.  I saw the code, but
between the fixing the first bug and unwinding everything everything else I didn't
see that the end result ended up being a full revert.

So yeah, a full revert is definitely in order.

Thanks!
