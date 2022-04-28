Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90453513D96
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352307AbiD1Vbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiD1Vbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:31:37 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDACF68FAB
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:28:20 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id t25so10853821lfg.7
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bkwm56G8Y7QJPuweRPoHg97Ydlf3HkBjvFlQy90GFK0=;
        b=j8ecA+fwUBStisq2hVVSQX9H3Ciop/uqbnHdnf1SMFF/1XkCfjkVrAtyh5SnH9akNz
         GO5NYXKun+J6QCK9Q+710N91SKx/ESs113lcZsqgC64vTmpAtRwsKUGV9OC64Mu0w4VX
         pVvaPK/EqFG6BNnpRhnFxfPMiXpOhZQN/pCJ7X7qenHKoKr8jEAc0TM6PCtcm5evBLZL
         629zl38T512N5R50MLrLToZQkDK/+bX78EDXw6ZDpfB48rnkSeJ4mXImDOWMU01GfqFx
         RDLVOcbY07YAjVjTDVETO2tfbQkJOLUbf3VtQFaFfB+AJo5dY6808gcdODScgpL7UYpl
         6xag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bkwm56G8Y7QJPuweRPoHg97Ydlf3HkBjvFlQy90GFK0=;
        b=L1JtMuWaVjJIfUURAp8harmY18PEHqDGPld7vKDWZYFtrETdIrcahPGEJi6ecEg+aB
         6ps1CGhNZnd53BwQxnVABbHw5Twf4TCkMvWteIgCDHgFNbU3MMmY0IO4rd5XnVWq2iBN
         xOOeS2Az2XIDO6+Cd739/cjbgAtyLG3DqGEKrz3R+Ct0VgNgk9Fk04TKztBf6aSiEJgx
         9j0DUFEPAEW/ZlghThEicp/PhOnsg3/DW/pQj0UV+2/PQAaZB4Nlxf33vuaNJB4CFnmF
         vGwRrOISiIdxBFoOq0KVL0FAKfy7qA91qd2pftWXwN0iNoRlXST1taPw/SSgta64ysaw
         0jOw==
X-Gm-Message-State: AOAM531VXPtoZV8MAOxTiQJ9YHdViDIJFexIrQpSysEBOmoFOiTEAwPW
        iM7h2eNMVTzN0J5gyR/2eZmAJuyp8re8BUzvS0/w/Q==
X-Google-Smtp-Source: ABdhPJzWKOj0CHH3UKDJnrvYLX5uCYVGltmTThXG3JneGx/DprH2BuRoU+iqLBFi6Wkf4UHNQBiYAkO6d11eKTZ9YyY=
X-Received: by 2002:a05:6512:c01:b0:448:6aec:65c5 with SMTP id
 z1-20020a0565120c0100b004486aec65c5mr25924602lfu.193.1651181298953; Thu, 28
 Apr 2022 14:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220407195908.633003-1-pgonda@google.com> <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com> <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com> <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
In-Reply-To: <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 28 Apr 2022 15:28:07 -0600
Message-ID: <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Apr 27, 2022 at 2:18 PM Peter Gonda <pgonda@google.com> wrote:
>
> On Wed, Apr 27, 2022 at 10:04 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 4/26/22 21:06, Peter Gonda wrote:
> > > On Thu, Apr 21, 2022 at 9:56 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >>
> > >> On 4/20/22 22:14, Peter Gonda wrote:
> > >>>>>> svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
> > >>>>>> source and target vcpu->locks. Mark the nested subclasses to avoid false
> > >>>>>> positives from lockdep.
> > >>>> Nope. Good catch, I didn't realize there was a limit 8 subclasses:
> > >>> Does anyone have thoughts on how we can resolve this vCPU locking with
> > >>> the 8 subclass max?
> > >>
> > >> The documentation does not have anything.  Maybe you can call
> > >> mutex_release manually (and mutex_acquire before unlocking).
> > >>
> > >> Paolo
> > >
> > > Hmm this seems to be working thanks Paolo. To lock I have been using:
> > >
> > > ...
> > >                    if (mutex_lock_killable_nested(
> > >                                &vcpu->mutex, i * SEV_NR_MIGRATION_ROLES + role))
> > >                            goto out_unlock;
> > >                    mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> > > ...
> > >
> > > To unlock:
> > > ...
> > >                    mutex_acquire(&vcpu->mutex.dep_map, 0, 0, _THIS_IP_);
> > >                    mutex_unlock(&vcpu->mutex);
> > > ...
> > >
> > > If I understand correctly we are fully disabling lockdep by doing
> > > this. If this is the case should I just remove all the '_nested' usage
> > > so switch to mutex_lock_killable() and remove the per vCPU subclass?
> >
> > Yes, though you could also do:
> >
> >         bool acquired = false;
> >         kvm_for_each_vcpu(...) {
> >                 if (acquired)
> >                         mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> >                 if (mutex_lock_killable_nested(&vcpu->mutex, role)
> >                         goto out_unlock;
> >                 acquired = true;
> >                 ...
> >
> > and to unlock:
> >
> >         bool acquired = true;
> >         kvm_for_each_vcpu(...) {
> >                 if (!acquired)
> >                         mutex_acquire(&vcpu->mutex.dep_map, 0, role, _THIS_IP_);
> >                 mutex_unlock(&vcpu->mutex);
> >                 acquired = false;
> >         }

So when actually trying this out I noticed that we are releasing the
current vcpu iterator but really we haven't actually taken that lock
yet. So we'd need to maintain a prev_* pointer and release that one.
That seems a bit more complicated than just doing this:

To lock:

         bool acquired = false;
         kvm_for_each_vcpu(...) {
                 if (!acquired) {
                    if (mutex_lock_killable_nested(&vcpu->mutex, role)
                        goto out_unlock;
                    acquired = true;
                 } else {
                    if (mutex_lock_killable(&vcpu->mutex, role)
                        goto out_unlock;
                 }
         }

To unlock:

         kvm_for_each_vcpu(...) {
            mutex_unlock(&vcpu->mutex);
         }

This way instead of mocking and releasing the lock_dep we just lock
the fist vcpu with mutex_lock_killable_nested(). I think this
maintains the property you suggested of "coalesces all the mutexes for
a vm in a single subclass".  Thoughts?

> >
> > where role is either 0 or SINGLE_DEPTH_NESTING and is passed to
> > sev_{,un}lock_vcpus_for_migration.
> >
> > That coalesces all the mutexes for a vm in a single subclass, essentially.
>
> Ah thats a great idea to allow for lockdep to work still. I'll try
> that out, thanks again Paolo.
>
> >
> > Paolo
> >
