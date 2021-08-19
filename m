Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADFD3F234A
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhHSWiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbhHSWiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:38:10 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C04C0613D9
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:37:32 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id a21so6867234pfh.5
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tCnq1WlSNiRYKzPwytn3MzcQ1Lkp1WmNneU5mRv3dkc=;
        b=MO+Heg/d1jN14yoOSFtKY1U3uoK2zWyazv0LWTrRyBRJpoipKzhfD1AB0jCuGaLgm2
         lirbnesrK3Ln0BTf7s6W6NQDpUfjRJvPZF1j1rIamGLDEY3xVjfonofmPqnwucBax/EV
         H088Mustltub4bYHEygj8cXsyaW39+83NS5m6tiBZ2ZNnkRbiKQ5oPWeVqDdguy12BnS
         T7nSshQMaRHmJD3H9L+E6cvo1oaEBrRql0A/sbaamkrBrhYVbE/zTswE03sOk7dXzCEq
         YtvcU0PaS6p/S0U8I5EIPjH0VmKNpJqh7rzwbJe8svDRvZ69QeiVVvkpjRoFCAtnMqc5
         HBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tCnq1WlSNiRYKzPwytn3MzcQ1Lkp1WmNneU5mRv3dkc=;
        b=BFuw2bucm0hVfTAqAVSlMHmWCLozbLB/ZAvj1B2Q1KTBf7CUFvbX09Cl5nMOuXw783
         d5Lfotf630pXV7LBrBciCzhJhqjkEYD11EW6PN3O1pnJ9z6KcxW9yOGHaNG9cYo4TL96
         +M/3Z8kAAEryjMYsj1YbzbkmwTJP5ttH14osRDTww9TT/MnYq7TWepEuPHVE7A75z3B3
         2yd2WhxEq4keDEZ7wFBjEk7P+sKLlzxMwEbtODPYfKcnVcDJszvwWoYoZQr6qoBLMYsf
         IrtWULNslmsyE8ILI1s07z0c+JFOcOOQJG7tdVe+zuIc34Afnj2IQ2xHo5y/uZPsmFNd
         02Mw==
X-Gm-Message-State: AOAM5302UZnyldv3O6py/4dRtN0jYFpGKyF+VpoLYt8R5pwHBYyRVbKh
        Tu76bQltedZk9xNcfMHS32j/bN8frh9Aaw==
X-Google-Smtp-Source: ABdhPJzMUo9cEroMWEw/EWD4MXTPNUwZJnaw2AGSZrF976SOGPdz5s2AB3O/OGm/d6nq0s59S6zf8g==
X-Received: by 2002:a62:1c84:0:b029:39a:87b9:91e with SMTP id c126-20020a621c840000b029039a87b9091emr16520648pfc.7.1629412651710;
        Thu, 19 Aug 2021 15:37:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p18sm5301646pgk.28.2021.08.19.15.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 15:37:31 -0700 (PDT)
Date:   Thu, 19 Aug 2021 22:37:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Cannon Matthews <cannonmatthews@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] KVM: stats: add stats to detect if vcpu is currently
 halted
Message-ID: <YR7dJflS7yBR52tL@google.com>
References: <20210817230508.142907-1-jingzhangos@google.com>
 <YRxKZXm68FZ0jr34@google.com>
 <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
 <CAJfu=UcwHWzqCvTjniAMkGj1mmjw9QCy5a-fGJ2mxTK8EFW7Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfu=UcwHWzqCvTjniAMkGj1mmjw9QCy5a-fGJ2mxTK8EFW7Dg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021, Cannon Matthews wrote:
> Since a guest has explictly asked for a vcpu to HLT, this is "useful work on
> behalf of the guest" even though the thread is "blocked" from running.
> 
> This allows answering questions like, are we spending too much time waiting
> on mutexes, or long running kernel routines rather than running the vcpu in
> guest mode, or did the guest explictly tell us to not doing anything.
> 
> So I would suggest keeping the "halt" part of the counters' name, and remove
> the "blocked" part rather than the other way around. We explicitly do not
> want to include non-halt blockages in this.

But this patch does include non-halt blockages, which is why I brought up the
technically-wrong naming.  Specifically, x86 reaches this path for any !RUNNABLE
vCPU state, e.g. if the vCPU is in WFS.  Non-x86 usage appears to mostly call
this for halt-like behavior, but PPC looks like it has at least one path that's
not halt-like.

I doubt anyone actually cares if the stat is a misnomer in some cases, but at the
same time I think there's opportunity for clean up here.  E.g. halt polling if a
vCPU is in WFS or UNINITIALIZED is a waste of cycles.  Ditto for the calls to
kvm_arch_vcpu_blocking() and kvm_arch_vcpu_unblocking() when halt polling is
successful, e.g. arm64 puts and reloads the vgic, which I assume is a complete
waste of cycles if the vCPU doesn't actually block.  And kvm_arch_vcpu_block_finish()
can be dropped by moving the one line of code into s390, which can add its own
wrapper if necessary.

So with a bit of massaging and a slight change in tracing behavior, I believe we
can isolate the actual wait/halt and avoid "halted" being technically-wrong, and
fix some inefficiencies at the same time.

Jing, can you do a v2 of this patch and send it to me off-list?  With luck, my
idea will work and I can fold your patch in, and if not we can always post v2
standalone in a few weeks.

E.g. I'm thinking something like...

void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
{
	vcpu->stat.generic.halted = 1;

	if (<halt polling failed>)
		kvm_vcpu_block();

	vcpu->stat.generic.halted = 0;

	<update halt polling stuff>
}

void kvm_vcpu_block(struct kvm_vcpu *vcpu)
{
	bool waited = false;
	ktime_t start, cur;
	u64 block_ns;

	start = ktime_get();


	prepare_to_rcuwait(&vcpu->wait);
	for (;;) {
		set_current_state(TASK_INTERRUPTIBLE);

		if (kvm_vcpu_check_block(vcpu) < 0)
			break;

		waited = true;
		schedule();
	}
	finish_rcuwait(&vcpu->wait);

	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
}

