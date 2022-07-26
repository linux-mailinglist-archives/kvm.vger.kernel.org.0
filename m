Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1B2581986
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 20:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiGZSPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 14:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGZSPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 14:15:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1818B65AB
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 11:15:37 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 70so13961315pfx.1
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 11:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jonilkYeLeji6w0q1utqHOw7NcUFd3AQwKuUxxy5xkk=;
        b=EVbixTL9gnqd1y7HrB/47zqS9vmyDYH2HYAHNiUzmJmN8mNiY7yNJBaN7G6RDKtlpS
         ZxS0cLaQj4T0l1pQskWYrh7aL/ivz5tEaFrU+KE3OLSc+gUkfSOATT5WMuu3mbYQX8V5
         n3zIy/jvCCsL0OVXKEseq2ZqWQtgHRRJs+C6Qr6JrdyIHXHMiiFOovVlSRGok7yCa1Ib
         eXyvZGLsVKGTZ4I5qRXgReoQV8cyuX63pjZZs0vBn3URjvuBWKMTBb1Y2MK8OisN5wk5
         d79tOlFdbEKkBqHD4+7fFp7BNH0sBvhhSiuRXMjVF/JmDgXa7X2B1i8PQy0S7GNQYG/A
         pZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jonilkYeLeji6w0q1utqHOw7NcUFd3AQwKuUxxy5xkk=;
        b=XHVtjSvw1zjRKAzbkuLO6wYNGxNxrbWVfmTapwtql/KRFJr+4KDzF4juY2mH2Vml3I
         nRtPDiperl3NiozBdUtSH715KctZR+vAcGCus1ed2FSKBMdqX4HcivceI4YigM0wFbJr
         ozbdDx4i0FEsUKbSgA/ZFUWmy/hLlxv3VvM5cFUl4ee0S+07fxtaQj5AaknIKCXZylw1
         YcJjEwtsZDCljJ1W9GAqpsG8X0MQAF8tf7mdf1Ubp7T0nXsUUYIZpBKg8vuF2n3uzWfa
         WSm2TC42uEahzoDUX+zbQslQtR+FKOgDHB3yUJZfEtTI23mx/TnK6UW+FHacaSwwzGG4
         6NYg==
X-Gm-Message-State: AJIora8cXeJeXMS3nzVXh8YrWTecNitRdw1fr4ZJmpfJdQzH9VTZ0DMm
        jScfF0JtRgg5FoamjxtK4kKPyA==
X-Google-Smtp-Source: AGRyM1vnVXo3+810BCIhz5D/T/ksU1Pu4bBF1aFjn4F0TJjOtSO9l4FEKf24qxLQjMCiaACEfgAS/g==
X-Received: by 2002:a63:8ac3:0:b0:419:c3bb:7d99 with SMTP id y186-20020a638ac3000000b00419c3bb7d99mr16188219pgd.57.1658859336401;
        Tue, 26 Jul 2022 11:15:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 30-20020a63185e000000b0041296bca2a8sm10145376pgy.12.2022.07.26.11.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 11:15:35 -0700 (PDT)
Date:   Tue, 26 Jul 2022 18:15:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com, maz@kernel.org,
        bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YuAvQ0C8ZprtJ4US@google.com>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
 <Ytir/hbU9neBaYqb@google.com>
 <YtrcCeHqBcwy+Mf6@google.com>
 <YtrqVwSK42KbKckf@google.com>
 <20220723082201.ifme5dipygt5r2wx@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723082201.ifme5dipygt5r2wx@kamzik>
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

On Sat, Jul 23, 2022, Andrew Jones wrote:
> On Fri, Jul 22, 2022 at 06:20:07PM +0000, Sean Christopherson wrote:
> > On Fri, Jul 22, 2022, Ricardo Koller wrote:
> > > What about dividing the changes in two.
> > > 
> > > 	1. Will add the struct to "__vm_create()" as part of this
> > > 	series, and then use it in this commit. There's only one user
> > > 
> > > 		dirty_log_test.c:   vm = __vm_create(mode, 1, extra_mem_pages);
> > > 
> > > 	so that would avoid having to touch every test as part of this patchset.
> > > 
> > > 	2. I can then send another series to add support for all the other
> > > 	vm_create() functions.
> > > 
> > > Alternatively, I can send a new series that does 1 and 2 afterwards.
> > > WDYT?
> > 
> > Don't do #2, ever. :-)  The intent of having vm_create() versus is __vm_create()
> > is so that tests that don't care about things like backing pages don't have to
> > pass in extra params.  I very much want to keep that behavior, i.e. I don't want
> > to extend vm_create() at all.  IMO, adding _anything_ is a slippery slope, e.g.
> > why are the backing types special enough to get a param, but thing XYZ isn't?
> > 
> > Thinking more, the struct idea probably isn't going to work all that well.  It
> > again puts the selftests into a state where it becomes difficult to control one
> > setting and ignore the rest, e.g. the dirty_log_test and anything else with extra
> > pages suddenly has to care about the backing type for page tables and code.
> > 
> > Rather than adding a struct, what about extending the @mode param?  We already
> > have vm_mem_backing_src_type, we just need a way to splice things together.  There
> > are a total of four things we can control: primary mode, and then code, data, and
> > page tables backing types.
> > 
> > So, turn @mode into a uint32_t and carve out 8 bits for each of those four "modes".
> > The defaults Just Work because VM_MEM_SRC_ANONYMOUS==0.
> 
> Hi Sean,
> 
> How about merging both proposals and turn @mode into a struct and pass
> around a pointer to it? Then, when calling something that requires @mode,
> if @mode is NULL, the called function would use vm_arch_default_mode()
> to get a pointer to the arch-specific default mode struct.

One tweak: rather that use @NULL as a magic param, #define VM_MODE_DEFAULT to
point at a global struct, similar to what is already done for __aarch64__.

E.g.

	__vm_create(VM_MODE_DEFAULT, nr_runnable_vcpus, 0);

does a much better job of self-documenting its behavior than this:

	__vm_create(NULL, nr_runnable_vcpus, 0);

> If a test needs to modify the parameters then it can construct a mode struct
> from scratch or start with a copy of the default. As long as all members of
> the struct representing parameters, such as backing type, have defaults
> mapped to zero for the struct members, then we shouldn't be adding any burden
> to users that don't care about other parameters (other than ensuring their
> @mode struct was zero initialized).

I was hoping to avoid forcing tests to build a struct, but looking at all the
existing users, they either use for_each_guest_mode() or just pass VM_MODE_DEFAULT,
so in practice it's a complete non-issue.

The page fault usage will likely be similar, e.g. programatically generate the set
of combinations to test.

So yeah, let's try the struct approach.
