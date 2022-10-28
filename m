Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22766111B5
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 14:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJ1MlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 08:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiJ1MlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 08:41:13 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34714A598B;
        Fri, 28 Oct 2022 05:41:10 -0700 (PDT)
Date:   Fri, 28 Oct 2022 14:41:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666960867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uwq+zmSdnqq2Sr5nY8C7NJ4QIwQ8tuXe2XZg/eKYTNo=;
        b=bMzgzIte5Sgpjg9yV+fLPcM9dYBTnCWA3Lfo1jei3kYs5ber0FVotAze9Z655Uo0mfk35G
        Mz/tKNn7YGKAC1bbXpFrm/a1+9YYweqlHkVt55CZAWUpiga2K1422ZkTmmIkIsC74eJtDN
        AtnJ1VXiz9k2KAJhA7Ow6XSw/4stfAM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 00/18] KVM selftests code consolidation and cleanup
Message-ID: <20221028124106.oze32j2lkq5ykifj@kamzik>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <Y1mlJqKdFtlgG3jR@google.com>
 <DS0PR11MB63731F2B467D4084F5C8D9B5DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1qnWFzekT27rYka@google.com>
 <CALzav=c4-FWVrWQebuYs--vbgnyPjEwZxfjSS1aMSRL3JMbWYw@mail.gmail.com>
 <Y1rNm0E6/I5y6K2a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1rNm0E6/I5y6K2a@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022 at 06:27:39PM +0000, Sean Christopherson wrote:
> On Thu, Oct 27, 2022, David Matlack wrote:
> > On Thu, Oct 27, 2022 at 8:44 AM Sean Christopherson <seanjc@google.com> wrote:
> > > I like the idea in theory, but that'd be a daunting task to set up, and quite the
> > > maintenance nightmare.  There are probably thousands of file => scope mappings
> > > throughout the kernel, with any number of exceptions and arbitrary rules.
> > 
> > I was thinking about proposing this in checkpatch.pl, or in some
> > KVM-specific check script. It seems like the following rule: If a
> > commit only modifies files in tools/testing/selftests/kvm/*, then
> > requires the shortlog match the regex "KVM: selftests: .*". That would
> > handle the vast majority of cases without affecting other subsystems.
> > 
> > Sean are you more concerned that if we start validating shortlogs in
> > checkpatch.pl then eventually it will get too out of hand? (i.e. not
> > so concerned with this specific case, but the general problem?)
> 
> Ya, the general problem.  Hardcoding anything KVM specific in checkpatch.pl isn't
> going to fly.  The checkpatch maintainers most definitely don't want to take on
> the burden of maintaining subsystem rules.  Letting one subsystem add custom rules
> effectively opens the flood gates to all subsystems adding custom rules.  And from
> a KVM perspective, I don't want to have to get an Acked-by from a checkpatch
> maintiainer just to tweak a KVM rule.
> 
> The only somewhat feasible approach I can think of would be to provide a generic
> "language" for shortlog scope rules, and have checkpatch look for a well-known
> file in relevant directories, e.g. add arch/x86/kvm/SCOPES or whatever.  But even
> that is a non-trivial problem to solve, as it means coming up with a "language"
> that has a reasonable chance of working for many subsystems without generating too
> many false positives.
> 
> It's definitely doable, and likely not actually a maintenance nightmare (I wrote
> that thinking of modifying a common rules file).  But it's still fairly daunting
> as getting buy-in on something that affects the kernel at large tends to be easier
> said then done.  Then again, I'm probably being pessimistic due to my sub-par
> regex+scripting skills :-)

How about adding support for checkpatch extension plugins? If we could add
a plugin script, e.g. tools/testing/selftests/kvm/.checkpatch, and modify
checkpatch to run .checkpatch scripts in the patched files' directories
(and recursively in the parent directories) when found, then we'd get
custom checkpatch behaviors. The scripts wouldn't even have to be written
in Perl (but I say that a bit sadly, because I like Perl).

Thanks,
drew
