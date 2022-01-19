Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEDA493FF5
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239739AbiASSbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356799AbiASSar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 13:30:47 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E676EC061574;
        Wed, 19 Jan 2022 10:30:46 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v11-20020a17090a520b00b001b512482f36so585208pjh.3;
        Wed, 19 Jan 2022 10:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pILDFV1B0pcs8CFlfnc4VuEEfnu7s3r3AjaWa+U4qlU=;
        b=G/3SbGpYSVIOIGF7kh+kzHoGUA5tjQNhhwD8Ct/g4lU1Vu7oi22nFS+AZudtTGWnr3
         rrhbbDLZytfxj5YVdB3iT4iolvT7lMZWM+MNINx7AQydBvXsMdbYOmkzq2tgcTNbGPWu
         Qpa+33b4JH7QozpPtVL7r0KodsrkmTOGQP2niwVLRhBjZo9fy3C+npjUu6X50dKpWeEM
         yKN/XtEo/mnaJhpjliB+QNljmjRXxQlYGPfYEPyyoxvCI5hzEnSFX540cpRZtqmRW9A+
         Ji9zM1OR2SJi0kJeAZdohbNCC1kjFVNUXaYGmn8+JxFeoizkJJ86x1FDWsXiU1XNd3oN
         hbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=pILDFV1B0pcs8CFlfnc4VuEEfnu7s3r3AjaWa+U4qlU=;
        b=P+gfIXQ/w3gcd9K9hH95DJdaGm1f1GDfa5g+fk9whB24Xlm9ALRubYXyEBbSET1AqI
         99I/wPfI4JLZ7LW41NXdfluCC6hT/JdO8URVNi/fAYvmSufOi2bNAEkjSRofYn6Bixqc
         TPCL7jQHMLFYJkt5oZtnpO3k33VE3SAJz56EW/3quBViwQU22korY4X+QGazBrMwkqrk
         b/c11qg6loPSgVzizO4V6CzuziaiJ2jXnItng2FRT8VMq/YZE2Bup8qgbeHuL+TutkzQ
         uLsTwvLhpAeNeGoBeW/zeMW05YLKHzRBonIKl/CiDGVHDcDQCKwUi/qiaXLTYUiJYrFx
         88tQ==
X-Gm-Message-State: AOAM532oa8LPwmjK9VqrvCeLK2SdBCq/vj+PrKdlaMneA3coG4EhAc5F
        Qn9oRJs1fFCqcwKk/KnjHz8=
X-Google-Smtp-Source: ABdhPJwyGwotVAkWmz3BsMf7Fv2uH9oDXZUXNCwmEF/EdbNauj90GncquVipF0USQAD+rXlnrhLtAw==
X-Received: by 2002:a17:903:2342:b0:14a:e540:6c83 with SMTP id c2-20020a170903234200b0014ae5406c83mr7261385plh.69.1642617046283;
        Wed, 19 Jan 2022 10:30:46 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id b5sm373150pgl.22.2022.01.19.10.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 10:30:45 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 19 Jan 2022 08:30:43 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vipin Sharma <vipinsh@google.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        seanjc@google.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Message-ID: <YehY0z2vHYVZk52J@slm.duckdns.org>
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org>
 <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 07:02:53PM +0100, Paolo Bonzini wrote:
> On 1/18/22 21:39, Tejun Heo wrote:
> > So, these are normally driven by the !populated events. That's how everyone
> > else is doing it. If you want to tie the kvm workers lifetimes to kvm
> > process, wouldn't it be cleaner to do so from kvm side? ie. let kvm process
> > exit wait for the workers to be cleaned up.
> 
> It does.  For example kvm_mmu_post_init_vm's call to
> kvm_vm_create_worker_thread is matched with the call to
> kthread_stop in kvm_mmu_pre_destroy_vm.
> According to Vpin, the problem is that there's a small amount of time
> between the return from kthread_stop and the point where the cgroup
> can be removed.  My understanding of the race is the following:

Okay, this is because kthread_stop piggy backs on vfork_done to wait for the
task exit intead of the usual exit notification, so it only waits till
exit_mm(), which is uhh... weird. So, migrating is one option, I guess,
albeit a rather ugly one. It'd be nicer if we can make kthread_stop()
waiting more regular but I couldn't find a good existing place and routing
the usual parent signaling might be too complicated. Anyone has better
ideas?

Thanks.

-- 
tejun
