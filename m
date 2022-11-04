Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C0B618DE0
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 03:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiKDCFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 22:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDCFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 22:05:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B921E700
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 19:05:46 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h14so3315790pjv.4
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 19:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VFUujnDa9hgM2VoxjeJ+chMz7zCherdpYz2zmraA5Kc=;
        b=OnQm2h3p9mixU2SQ5uaKg4GFFrx1jIknBKTscFV+IaDS0Q7k9ivjP1jktAtGDiunt/
         V7BMHJsOjYp5nAlmTmzdc40kZ7E8rIvgaZk9enT2uwTx5CdYM7YMbAA9wJ4KNwuJe0zC
         KTaIYjyN2ec4BfvrZmdehAv2hzDeekM28+eyGF/TSduGnjiyOBrzaYyguCdyf7au3l/U
         KuVZ4ZyYS32tZA96O5jwLJ/RPLGscVMi1eAhGUXhcZdXMG2UF5w2NZ8GV3kQWgUsiT6o
         EHAKRbwesbwsgGlOXgs6a+uJwGJwEgwzbmZln+cKcMETcTlQlASBEmSstvSAzqAwlddL
         qwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFUujnDa9hgM2VoxjeJ+chMz7zCherdpYz2zmraA5Kc=;
        b=G6YkmWZ6yGilxTEMihIISDjC0N21EBlNXlfBtP+scy3x1hjRdqV//kS2JJNkYAkkfl
         jdo4D4LjAflqLCgumCIiF+N2sRnCUhNzIzJvBLJ06ZRU5iwRosqCLLlnjp/aXDkc6i7Z
         CsBc61dJxv8KPdbWFo/5NHpP98LbKOV8/v6OsgY7x2zpTFqjmyy/hX4kojCLUpBkJKsO
         ZBHdgySeu2j2ookZg1c1b5HGacRMWZniURX7CQ2ZR7XjWwtgkL2OOE5/zEDJzuHiC5rf
         0R2LjIHS/wD5nVwJQGsZdS2Rq6ok0uGxHwkMlCBjrou8R7CjYaRiCpNyE1OXq558Jm9D
         h+Jw==
X-Gm-Message-State: ACrzQf1U8GHCydbB2Nisu96yfkfIZaqtbsvG6A1xe4S1Sl/W+cX20A0v
        0PKRMLDcjchWFaAUykiKTJ6y2w==
X-Google-Smtp-Source: AMsMyM4VFIUXp8AYn9jwQvjWGhVJWVRu4bKaUuSrhs9SKVgvvcs3QBB/XL7oIBCvzjYXmnoxfKm+rg==
X-Received: by 2002:a17:90b:1c82:b0:1ee:eb41:b141 with SMTP id oo2-20020a17090b1c8200b001eeeb41b141mr35262118pjb.143.1667527545809;
        Thu, 03 Nov 2022 19:05:45 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m6-20020a1709026bc600b0018853dd8832sm1381654plt.4.2022.11.03.19.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 19:05:45 -0700 (PDT)
Date:   Fri, 4 Nov 2022 02:05:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [RFC 1/1] KVM: selftests: rseq_test: use vdso_getcpu() instead
 of syscall()
Message-ID: <Y2RzdQVvZnS7wcMr@google.com>
References: <20221102020128.3030511-1-robert.hu@linux.intel.com>
 <20221102020128.3030511-2-robert.hu@linux.intel.com>
 <Y2MPe3qhgQG0euE0@google.com>
 <b7ae920f-dae0-b3f3-aba3-944cb73c19c2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7ae920f-dae0-b3f3-aba3-944cb73c19c2@redhat.com>
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

On Thu, Nov 03, 2022, Gavin Shan wrote:
> On 11/3/22 8:46 AM, Sean Christopherson wrote:
> > On Wed, Nov 02, 2022, Robert Hoo wrote:
> > > @@ -253,7 +269,7 @@ int main(int argc, char *argv[])
> > >   			 * across the seq_cnt reads.
> > >   			 */
> > >   			smp_rmb();
> > > -			sys_getcpu(&cpu);
> > > +			vdso_getcpu(&cpu, NULL, NULL);
> > >   			rseq_cpu = rseq_current_cpu_raw();
> > >   			smp_rmb();
> > >   		} while (snapshot != atomic_read(&seq_cnt));
> > 
> > Something seems off here.  Half of the iterations in the migration thread have a
> > delay of 5+us, which should be more than enough time to complete a few getcpu()
> > syscalls to stabilize the CPU.
> > 
> > Has anyone tried to figure out why the vCPU thread is apparently running slow?
> > E.g. is KVM_RUN itself taking a long time, is the task not getting scheduled in,
> > etc...  I can see how using vDSO would make the vCPU more efficient, but I'm
> > curious as to why that's a problem in the first place.
> > 
> > Anyways, assuming there's no underlying problem that can be solved, the easier
> > solution is to just bump the delay in the migration thread.  As per its gigantic
> > comment, the original bug reproduced with up to 500us delays, so bumping the min
> > delay to e.g. 5us is acceptable.  If that doesn't guarantee the vCPU meets its
> > quota, then something else is definitely going on.
> > 
> 
> I doubt if it's still caused by busy system as mentioned previously [1]. At least,
> I failed to reproduce the issue on my ARM64 system until some workloads are enforced
> to hog CPUs.

Yeah, I suspect something else as well.  My best guest at this point is mitigations,
I'll test that tomorrow to see if it makes any difference.

> Looking at the implementation syscall(NR_getcpu), it's simply to copy
> the per-cpu data from kernel to userspace. So I don't see it should consume lots
> of time. As system call is handled by interrupt/exception, the time consumed by
> the interrupt/exception handler should be architecture dependent. Besides, the time
> needed by ioctl(KVM_RUN) also differs on architectures.

Yes, but Robert is seeing problems on x86-64 that I have been unable to reproduce,
i.e. this isn't an architectural difference problem.

> [1] https://lore.kernel.org/kvm/d8290cbe-5d87-137a-0633-0ff5c69d57b0@redhat.com/
> 
> I think Sean's suggestion to bump the delay to 5us would be the quick fix if it helps.
> However, more time will be needed to complete the test. Sean, do you mind to reduce
> NR_TASK_MIGRATIONS from 100000 to 20000 either?

I don't think the number of migrations needs to be cut by 5x, the +5us bump only
changes the average from ~5us (to ~7.5us).

But before we start mucking with the delay, I want to at least understand _why_
a lower bound of 1us is insufficient.
