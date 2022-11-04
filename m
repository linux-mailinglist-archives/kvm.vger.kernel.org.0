Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CB1618DE5
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 03:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiKDCHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 22:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiKDCHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 22:07:13 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8CA23EA6
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 19:07:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so3491846pji.0
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 19:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OhgBJpvKym3ixiOquBO13X9bv9FJ8RdOygfXcKayM5E=;
        b=Dr7+/NuXdK3vxsoE0JPrHXvreLGZpeicwrXKGId2uKztZM9tSEYuX1zPs9AaJDjiIh
         9U1W00FA94+5em76hSifXqaIwRPghcAEcJtj7u0yoHS9ZVC90/6sLE8mQj8oZ7lb280e
         ZMEsEb3CyTcOOKsY1uXHihoy+FUF8T22NMzzEsKj28rKwfdADxY9Wms9/wcKVGrEpAiJ
         6/Oujvw/j4ZekeMIS0c76Yn5nbopv515XdjHreAxDOVP+H9iYTiuhC/mz9RY7X+A+dkV
         feq+d0kuPBDwIsAca9670gjmqU9vzHrvKEltGIHUzZvebggZdyTbK6MBRwV70CyAod7p
         I5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhgBJpvKym3ixiOquBO13X9bv9FJ8RdOygfXcKayM5E=;
        b=RCN4SMBK0/5SjWvfYH36bfCZP5fBR4rC5TigKPxHJLfpVd48cLHraMjki6QV5sKwU6
         10QbqUvjhuUz7mQW0mVURW6xBBDJ7c3PnJUsfsdpL8EvBrMHYS4upekGcFmLxVQSuiFE
         gxS2EZ1Iytidocx1AjN/CFDgfA389ftd+i4BElWqa9FJad0QKk9pZFrjBD4QbclaBR8K
         Ii7imFUgkTvR73c7zJNryNRN3mC+zN0wiV6jA9Gk+qIAjyYo0oBcKi5wF5vSfOjktwLq
         LtH+1uKPGt7VGfaye+HPqP/KIYJpZ8VPprH/Rc9Ex1qMJCsroOJA1QwxyJlCDheDHEVK
         9MvA==
X-Gm-Message-State: ACrzQf2WJgvb4BSNLF6me6iL3oeoL0eQLWWUT4UqNgTOJm0Syosf3SSK
        mBn5omlTCdx33CascqiByHv64Q==
X-Google-Smtp-Source: AMsMyM6pLLwPzJsbf3biUc+lcWu17GNOO7DMgpLCoky7Nu+B6JtWxuwqdZclgiYpTg0dTAz53lkRWA==
X-Received: by 2002:a17:90b:3504:b0:214:199e:7e6d with SMTP id ls4-20020a17090b350400b00214199e7e6dmr15812845pjb.192.1667527632424;
        Thu, 03 Nov 2022 19:07:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r17-20020a170902c61100b001867fb4056asm1372324plr.32.2022.11.03.19.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 19:07:11 -0700 (PDT)
Date:   Fri, 4 Nov 2022 02:07:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, gshan@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 1/1] KVM: selftests: rseq_test: use vdso_getcpu() instead
 of syscall()
Message-ID: <Y2RzzDUD8r17k+1i@google.com>
References: <20221102020128.3030511-1-robert.hu@linux.intel.com>
 <20221102020128.3030511-2-robert.hu@linux.intel.com>
 <Y2MPe3qhgQG0euE0@google.com>
 <b1279d088165d195ee22ce02ec869f9ae33248d8.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1279d088165d195ee22ce02ec869f9ae33248d8.camel@linux.intel.com>
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

On Thu, Nov 03, 2022, Robert Hoo wrote:
> On Thu, 2022-11-03 at 00:46 +0000, Sean Christopherson wrote:
> > On Wed, Nov 02, 2022, Robert Hoo wrote:
> > > vDSO getcpu() has been in Kernel since 2.6.19, which we can assume
> > > generally available.
> > > Use vDSO getcpu() to reduce the overhead, so that vcpu thread
> > > stalls less
> > > therefore can have more odds to hit the race condition.
> > > 
> > > Fixes: 0fcc102923de ("KVM: selftests: Use getcpu() instead of
> > > sched_getcpu() in rseq_test")
> > > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > > ---
> > 
> > ...
> > 
> > > @@ -253,7 +269,7 @@ int main(int argc, char *argv[])
> > >  			 * across the seq_cnt reads.
> > >  			 */
> > >  			smp_rmb();
> > > -			sys_getcpu(&cpu);
> > > +			vdso_getcpu(&cpu, NULL, NULL);
> > >  			rseq_cpu = rseq_current_cpu_raw();
> > >  			smp_rmb();
> > >  		} while (snapshot != atomic_read(&seq_cnt));
> > 
> > Something seems off here.  Half of the iterations in the migration
> > thread have a
> > delay of 5+us, which should be more than enough time to complete a
> > few getcpu()
> > syscalls to stabilize the CPU.
> > 
> The migration thread delay time is for the whole vcpu thread loop, not
> just vcpu_run(), I think.

Yes, but if switching to vdso_getcpu() makes the issues go away, that suggests
that the task migration is causing the tight do-while loop to get stuck.

> for (i = 0; !done; i++) {
> 		vcpu_run(vcpu);
> 		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
> 			    "Guest failed?");
> ...
> 		do {
> 			...
> 			vdso_getcpu(&cpu, NULL, NULL);
> 			rseq_cpu = rseq_current_cpu_raw();
> 			...
> 		} while (snapshot != atomic_read(&seq_cnt));
> 
> ...
> 	}
> 
> > Has anyone tried to figure out why the vCPU thread is apparently running
> > slow?  E.g. is KVM_RUN itself taking a long time, is the task not getting
> > scheduled in, etc...  I can see how using vDSO would make the vCPU more
> > efficient, but I'm curious as to why that's a problem in the first place.
> 
> Yes, it should be the first-place problem.
> But firstly, it's the whole for(){} loop taking more time than before,

Do you have actual performance numbers?  If so, can you share them?
