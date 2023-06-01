Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C266271F236
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 20:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbjFASil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 14:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbjFASik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 14:38:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2A118C
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 11:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685644685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FFO3NBHLRNhHMW+sA5HqcRlT/v6inbyfTnFZ1a6R4OU=;
        b=gHwiilCX77hfKeCvrskDHJD2csI/8evH5eyt4hMUD0LcMKqNe90gUmQH4PBC0lP89L6N8Z
        1gq25w5AATw/cvH9HuM5Sq3aHXY3hwbHyS60Ai5BLJLvAzIOwSN+TtrzeA+PbLaJSBtyJa
        oUm7V04aSwGcJ5vfHiiWxEIpujnUYP8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-Ph9U0PHBPq6g3K7I4-NmAQ-1; Thu, 01 Jun 2023 14:38:04 -0400
X-MC-Unique: Ph9U0PHBPq6g3K7I4-NmAQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-62849c5e9f0so246956d6.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 11:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685644683; x=1688236683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFO3NBHLRNhHMW+sA5HqcRlT/v6inbyfTnFZ1a6R4OU=;
        b=NgeszuFPBfKI544KiRKYKP8gMBj/Wps3RVD2a04s62U2ENys22WXPQigF0ndHJM2CA
         3abgGu8m2bHGnw2UDiXIThyw3iTly+DCP/dbhPIlKGwLvuQ+8FGhh8uwEKJlrjmODJ9+
         4N5YItfRhLZs/QL/I9L1eBIX3PPqlJ7d/5WsCwF1neFTgofvoO2sZ4ZMaAy0pv+YNvW+
         6ZtWIpDiHoKI5/N3WvyJ6LgBeA0hVB/IV97iUw67ZwtkmggdnI/WtZHtkHejJaq0EMaE
         EBn4GlpPqs43TeV9brbqwIWz8tbXxZspkcDOyoqAkkbPQ0QUyY6tCgQ+AY2Wm2yKwDX6
         aY1A==
X-Gm-Message-State: AC+VfDwFTU8ZVsrjgbvRPyxU2I9TGsn5oLNt8OsBTAuVO9OAlTZV5hAy
        y0RC4Xu/2Zot2+U4sA9Db/LlT3omOXXa3Rv7wI3+qR9rtEacSOkvUBuNL/Yk8M4kgZuulDbz3gv
        dH/5zPHM0S6Y4
X-Received: by 2002:a05:6214:5014:b0:628:7a68:2642 with SMTP id jo20-20020a056214501400b006287a682642mr60463qvb.3.1685644682822;
        Thu, 01 Jun 2023 11:38:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6CONzq63xWF60vclFBIObzdxSqn7W7WY/8Q8ADMDhtRFMdtZvCVuNuOMUySF0RhDlaNXHyog==
X-Received: by 2002:a05:6214:5014:b0:628:7a68:2642 with SMTP id jo20-20020a056214501400b006287a682642mr60337qvb.3.1685644681220;
        Thu, 01 Jun 2023 11:38:01 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-62-70-24-86-62.dsl.bell.ca. [70.24.86.62])
        by smtp.gmail.com with ESMTPSA id df2-20020a056214080200b005ef54657ea0sm7862180qvb.126.2023.06.01.11.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 11:38:00 -0700 (PDT)
Date:   Thu, 1 Jun 2023 14:37:59 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>
Subject: Re: [PATCH] selftests/kvm: Allow specify physical cpu list in demand
 paging test
Message-ID: <ZHjlhwTbmYRoZuEa@x1n>
References: <20230503233812.2743269-1-peterx@redhat.com>
 <ZHfHGCfsz4dSQ62b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZHfHGCfsz4dSQ62b@google.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 03:15:52PM -0700, Sean Christopherson wrote:
> On Wed, May 03, 2023, Peter Xu wrote:
> > Mimic dirty log test to allow specify physical cpu pinning for vcpu threads.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/demand_paging_test.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > index bdb8e0748154..d709b65fda2f 100644
> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -220,12 +220,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >  static void help(char *name)
> >  {
> >  	puts("");
> > -	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
> > +	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a] [-c cpu_list]\n"
> >  		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
> >  		   "          [-s type] [-v vcpus] [-o]\n", name);
> >  	guest_modes_help();
> >  	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
> >  	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
> > +	printf(" -c: physical cores to pin vcpu threads (e.g. 1,2,3,...)\n");
> 
> This help really should be provided by kvm_util.c, e.g. this doesn't capture the
> "must pin all vCPUs" behavior, nor does it capture the "pin the main thread"
> behavior.
> 
> Something like this?
> 
> void kvm_get_vcpu_pinning_help(char *buffer, size_t size,
> 			       const char *optchar, const char *testname)
> {
> 	snprintf(buffer, size,
> 		 " -%c: Pin tasks to physical CPUs.  Takes a list of comma separated\n"
> 		 "     values (target pCPU), one for each vCPU, plus an optional\n"
> 		 "     entry for the main application task (specified via entry\n"
> 		 "     <nr_vcpus + 1>).  If used, entries must be provided for all\n"
> 		 "     vCPUs, i.e. pinning vCPUs is all or nothing.\n\n"
> 		 "     E.g. to create 3 vCPUs, pin vCPU0=>pCPU22, vCPU1=>pCPU23,\n"
> 		 "     vCPU2=>pCPU24, and pin the application task to pCPU50:\n\n"
> 		 "         ./%s -v 3 -c 22,23,24,50\n\n"
> 		 "     To leave the application task unpinned, drop the final entry:\n\n"
> 		 "         ./%s -v 3 -c 22,23,24\n\n"
> 		 "     (default: no pinning)\n", optchar, testname);
> }

Sure, I'll respin.  For the long term maybe we'll want to switch to libnuma
to take things easily like "1,2,5-10", but I'll leave that for later.

-- 
Peter Xu

