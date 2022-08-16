Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE46F5964D6
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 23:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbiHPVnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 17:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237039AbiHPVnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 17:43:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49F21D1
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 14:43:11 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p18so10375523plr.8
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 14:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=fHoaQuQyrNOHA1CxVanqB+3Y6dYUWxDy7qrwrkskMNM=;
        b=j03HDlXVQVJ9go7wU3LUhqLEtXGqZRIIx4a+gV3xfUzmx9FveQlrGHP0cTzS7hAEtA
         0AjKIumdLifjWu/ZY/c2QAI61e/LU4mar+fa2w3AODG4eMxptX6kBdFI8h73MyZX6I8g
         rJgjPVNJEVsU/H9aK8ViD/wvirZ2qf7HdntLAv7f7S0V9YSuVPBZbiDRJZdY4e2oqasO
         SyFyFfJuGeKSqFv7/fWyEYC/o4XYjiflNKFmwj/fUUkxdY3TpwUBwjiEgov0is4uN1oH
         Hx3EgJthTnCPgv9hmhQqqeArchhQ2hiGmmnGEJi8QkErohO2PFDJ2+rlAOU/8AHNBiB7
         V+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fHoaQuQyrNOHA1CxVanqB+3Y6dYUWxDy7qrwrkskMNM=;
        b=LCciZ2QnvxzN4sxQ8LmeqrDBPnfUKJTlLLB6Cz29OKLJg9k4y7m56aqsGNnoA3zECl
         f6F7FfGuQ1apeXLA81h3k9eWA28UADq0p0L5I+Tt22INPkxrjf2+7wX0JKr2gPaijwAW
         3xNl8Q3A33OObKi2SEyRuIIvS5q66WBWwHArezafA/mF92Q+d1rog7yIbm0NcjiNF0sq
         Cn6qthv0cnUv4r7a/RlqzhHcMGIeu8hOXmcFfQHF5VXTtImESHGosQ6hThFILW5l8zEg
         LCcsTp+qsmL8bUjP2S+QFlzUdZlshZ3b8DSc6IZWmkKJxYd5OENwJiybULN4J++1Q/AZ
         rfMQ==
X-Gm-Message-State: ACgBeo2VCloO9M0TfqUSNsNDXvni2u2rHr8q0lRnnegd/baUbXtnvuLS
        zl9+p4DxGozknbxyFi9Zo8WchA==
X-Google-Smtp-Source: AA6agR4aqvIq74t1vyp7m/HiiEbuxiLefbEN5Ecig7re+ePSp2kvKMMY09q7oON6KvCRY2iBzeP+Cw==
X-Received: by 2002:a17:902:d2d1:b0:16e:eeac:29ab with SMTP id n17-20020a170902d2d100b0016eeeac29abmr24111405plc.125.1660686191203;
        Tue, 16 Aug 2022 14:43:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m7-20020a1709026bc700b0016bf5557690sm9533377plt.4.2022.08.16.14.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:43:10 -0700 (PDT)
Date:   Tue, 16 Aug 2022 21:43:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/3] KVM: Unconditionally get a ref to /dev/kvm module
 when creating a VM
Message-ID: <YvwPa5GuR8gjQdpc@google.com>
References: <20220816053937.2477106-1-seanjc@google.com>
 <20220816053937.2477106-3-seanjc@google.com>
 <YvvNfTouc22hiLwo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvvNfTouc22hiLwo@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022, David Matlack wrote:
> On Tue, Aug 16, 2022 at 05:39:36AM +0000, Sean Christopherson wrote:
> > Unconditionally get a reference to the /dev/kvm module when creating a VM
> > instead of using try_get_module(), which will fail if the module is in
> > the process of being forcefully unloaded.  The error handling when
> > try_get_module() fails doesn't properly unwind all that has been done,
> > e.g. doesn't call kvm_arch_pre_destroy_vm() and doesn't remove the VM
> > from the global list.  Not removing VMs from the global list tends to be
> > fatal, e.g. leads to use-after-free explosions.
> > 
> > The obvious alternative would be to add proper unwinding, but the
> > justification for using try_get_module(), "rmmod --wait", is completely
> > bogus as support for "rmmod --wait", i.e. delete_module() without
> > O_NONBLOCK, was removed by commit 3f2b9c9cdf38 ("module: remove rmmod
> > --wait option.") nearly a decade ago.
> 
> Ah! include/linux/module.h may also need a cleanup then. The comment
> above __module_get() explicitly mentions "rmmod --wait", which is what
> led me to use try_module_get() for commit 5f6de5cbebee ("KVM: Prevent
> module exit until all VMs are freed").

Ugh, I didn't see that one.  The whole thing is a mess.  try_module_get() also
has a comment (just below the "rmmod --wait" comment) saying that it's the one
true way of doing things, but that's at best misleading for cases like this where
a module is taking a reference of _itself_.

The man pages are also woefully out of date :-/
