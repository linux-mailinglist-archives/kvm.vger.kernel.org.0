Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631125FBDF7
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 00:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiJKWum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 18:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJKWul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 18:50:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975A720F5C
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:50:40 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z20so14568664plb.10
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TbMJWEdPmfNeD0kB+jWHSuutd5si9I9mcn62ZSQ6ebk=;
        b=EXwvrG72/XgRccZJF0450rqTfdzfHvKeCIUy1TkXACWGjIgySzQzW9UMgVepeUouUC
         f1XHj3SN6upvcHME3O3xUiRhEorvlY0PEYQ/rKyl6NF3r20py4TTyryxb4yTplAKZ6lg
         QCdfk4AUdEdks/E1qLrWM/ZbVVfLqgmoPwjBy63WY6xr7ACQ2GUphD/VZxytYJ/yl9CP
         Hbq/sATKbkpfdzqMyu15ltynXJI63odYrnORh13mppv66RV7bSH2q+QFy0fJrTG7RNfM
         6H65HEnU7CS1CTTaRffc9lRyPJTpyz71hB2jMi/jD0iG6xYa5tBPk92YXeKC2BG32aWs
         mPxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbMJWEdPmfNeD0kB+jWHSuutd5si9I9mcn62ZSQ6ebk=;
        b=oX5QbtVmpZrDisfB3USox+ij+ttpBDqBL1qovu9zEwiRzjuCFD49flwWBWjIBSUb8U
         UlTKqtBJ2RucIHW8u1cRI71lU0VogC6l+ktV0mfuFD8V61z/3A4+Sb9kKlZG/Xxv3BO6
         ihEHCh+ND3BOklZL6y7Zk/JkkeT8fCvr7cwzxmZZftxXAe65dKx12zjWbajRW4ec73Li
         63lcdX6uN7XERd4gihkvo1NNeX4WhPH5ItadWy6Bxw1CHnjeqC46uU95Ze5nE5nEcoZf
         p1kcNzPwSyfiZPTfCCJsTY6E53IcK8lnjoKHF4HjyPsLz7frkH+RR9pzOLcyttihMSmR
         S8Mg==
X-Gm-Message-State: ACrzQf1FmypYJPQWznQfvlpKiNo4/Lz1E6l+p1qd4U+rChnDDvORmehQ
        2Uz0DJ0I1Y3CFqEIQPmdTZZaNg==
X-Google-Smtp-Source: AMsMyM7HcrjWn/0gr8m9HBM3NPMfpNqj/jVFu77GnXRjqwOs0nxgjAIOsce2gWlRdmTzISieYuDhjA==
X-Received: by 2002:a17:902:e801:b0:178:11e9:2ba2 with SMTP id u1-20020a170902e80100b0017811e92ba2mr25127237plg.26.1665528639885;
        Tue, 11 Oct 2022 15:50:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d29-20020a634f1d000000b0043a09d5c32bsm218734pgb.74.2022.10.11.15.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 15:50:39 -0700 (PDT)
Date:   Tue, 11 Oct 2022 22:50:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 3/3] KVM: selftests: randomize page access order
Message-ID: <Y0XzO/MZjMICCjt3@google.com>
References: <Y0W0V5hsTkKLg59D@google.com>
 <gsnt7d162e2i.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsnt7d162e2i.fsf@coltonlewis-kvm.c.googlers.com>
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

On Tue, Oct 11, 2022, Colton Lewis wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Oct 11, 2022, Colton Lewis wrote:
> > > Sean Christopherson <seanjc@google.com> writes:
> > > > Ya, I'm trippling (quadrupling?) down on my suggestion to improve the
> > > > APIs.  Users
> > > > should not be able to screw up like this, i.e. shouldn't need comments
> > > > to warn
> > > > readers, and adding another call to get a random number shouldn't
> > > affect
> > > > unrelated
> > > > code.
> 
> > > Previous calls to PRNGs always affect later calls to PRNGs. That's how
> > > they work.
> 
> > Ya, that's not the type of bugs I'm worried about.
> 
> > > This "screw up" would be equally likely with any API because the caller
> > > always needs to decide if they should reuse the same random number
> > > or need a
> > > new one.
> 
> > I disagree, the in/out parameter _requires_ the calling code to store
> > the random
> > number in a variable.  Returning the random number allows consuming the
> > number
> > without needing an intermediate variable, e.g.
> 
> > 	if (random_bool())
> > 		<do stuff>
> 
> > which makes it easy to avoid an entire class of bugs.
> 
> Yes, but it's impossible to do this without hidden global state at the
> implementation level. That sacrifices reentrancy and thread-safety.

The above is super quick pseudocode that wasn't intended to be taken verbatim.
From my original suggestion in patch one[*], throw the seed/metadata in a opaque
struct, e.g. ksft_pseudo_rng (or kvm_pseudo_rng if the code ends up being KVM-only).

The intent is to hide the details of the rng, both so that the caller doesn't have
to worry about those details, but also so that the guts can be changed at will
without having to update callers.

[*] https://lore.kernel.org/all/20220912195849.3989707-2-coltonlewis@google.com
