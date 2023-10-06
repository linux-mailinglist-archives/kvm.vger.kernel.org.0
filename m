Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC6F7BB002
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 03:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjJFBQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 21:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjJFBQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 21:16:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30FFD6
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 18:16:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d8153284d6eso2300428276.3
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 18:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696555011; x=1697159811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jd5KxEqEwY2iqG9q8MvnGaf7JmKJ2HuMOoFFZ0hbqA8=;
        b=SVY4b76bYUYMfoXuEmJf3k2FR1jcMSAnsA6OLo8zwPKgmYN3BYRn2ZWvsN46pn6vTY
         ou0OQMGmyzVR7+IQk5mHMMF/TT6nz0dsjb6RLTI0Ekwki8Xq3+mgxqTp4yhF/gGvibQy
         4Gl6bnD6HuQfYjy4BiKv42trsQiNAtuJQPF1rH4cz4NdBiXm0OVJwV81mieNp/SuqwMJ
         AWqNZWrcZO9mGKDcwZB+Js5wW3HR55N0pelh/viy8I72JmA+ARC9nTY2EnYQQmCAjiee
         /sNy7wiHfz1OCF8BeLBV/g7b9IQ43PrT2v6YOGpEaWTDa0Qrx5E6aga3vJB/KE+1NKeC
         IWJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696555011; x=1697159811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jd5KxEqEwY2iqG9q8MvnGaf7JmKJ2HuMOoFFZ0hbqA8=;
        b=fZRhCSpj3vdSxRHNmEVoK08uO9idQ5LxKaBIwMQcKsYM57YFkPvLqNopQxb9C0LhGX
         ziR3Xm9OM5LrjvB8G0uoBLSxNpv8/EWBTKEjdBZk8Cp9V60cJsD/Ef1Asw8vmuAw7FMN
         ywNNf75OcKWweF7PebE+Op8Bzb51h26AeVUG1023Gr2Qo2svt84hodKEugQi3393Jb7o
         zPaNLMoAx+7vZexFPHwV8OPrkhnGmYadAf14rb3DV866K8c18cZo3/VShZ/PK0OHthNO
         ycQKhFPs4UqWIVnm0iduiTkJLOxwsSSSfLmAKw76x3YoRubZ/U3ZS0z3I8gD9b1WvtXd
         EnsA==
X-Gm-Message-State: AOJu0YzExX7S9V350yze4Y8xrvOCqatCmdtetPIkMKEaGbkRBh2cp4vz
        d22SuhXtFv/h+Nof9QYNR78DmM9v41U=
X-Google-Smtp-Source: AGHT+IHfG8E/0LJ9G93D45hP8patkOPnQ0VmZvmttke/y2ua8eemwq7tU907u2qwiUzAuKPPgEAJ1HKQOxw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:180e:b0:d77:984e:c770 with SMTP id
 cf14-20020a056902180e00b00d77984ec770mr114742ybb.5.1696555011194; Thu, 05 Oct
 2023 18:16:51 -0700 (PDT)
Date:   Thu, 5 Oct 2023 18:16:49 -0700
In-Reply-To: <CW0NB512KP2E.2ZZD07F49LND3@amazon.com>
Mime-Version: 1.0
References: <20231001111313.77586-1-nsaenz@amazon.com> <ZR35gq1NICwhOUAS@google.com>
 <CW0NB512KP2E.2ZZD07F49LND3@amazon.com>
Message-ID: <ZR9gATE2NSOOhedQ@google.com>
Subject: Re: [RFC] KVM: Allow polling vCPUs for events
From:   Sean Christopherson <seanjc@google.com>
To:     Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, graf@amazon.de, dwmw2@infradead.org,
        fgriffo@amazon.com, anelkz@amazon.de, peterz@infradead.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023, Nicolas Saenz Julienne wrote:
> Hi Sean,
> Thanks for taking the time to look at this.
> 
> On Wed Oct 4, 2023 at 11:47 PM UTC, Sean Christopherson wrote:
> > This does not look remotely safe on multiple fronts.  For starters, I don't see
> > anything in the .poll() infrastructure that provides serialization, e.g. if there
> > are multiple tasks polling then this will be "interesting".
> 
> Would allowing only one poller be acceptable?

As a last resort, but I think we should first try to support multiple pollers.

> > And there is zero chance this is race-free, e.g. nothing prevents the vCPU task
> > itself from changing vcpu->mode from POLLING_FOR_EVENTS to something else.
> >
> > Why on earth is this mucking with vcpu->mode?  Ignoring for the moment that using
> > vcpu->requests as the poll source is never going to happen, there's zero reason
> 
> IIUC accessing vcpu->requests in the kvm_vcpu_poll() is out of the
> question? Aren't we're forced to do so in order to avoid the race I
> mention above.

Reading vcpu->requests is fine, though I suspect it will be easier to use a
dedicated field.  Requests aren't single bit values and most of them are arch
specific, which will make it annoying to key off of requests directly.  I'm
guessing it will be impossible to completely avoid arch specific polling logic,
but I'd rather not jump straight to that.

> > @@ -285,6 +293,9 @@ static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int req,
> >                 if (cpu != -1 && cpu != current_cpu)
> >                         __cpumask_set_cpu(cpu, tmp);
> >         }
> > +
> > +       if (kvm_request_is_being_polled(vcpu, req))
> > +               wake_up_interruptible(...);
> >  }
> >
> >  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
> 
> I'll use this approach.
> 
> So since we have to provide a proper uAPI, do you have anything against
> having user-space set the polling mask through an ioctl?

What exactly do you mean?  The mask of what poll "events" userspace cares about?
I doubt that will work well if KVM supports more than one poller, as preventing
them from stomping over one another would be all but impossible.

> Also any suggestions on how kvm_request_to_poll_mask() should look like. For
> ex.  VSM mostly cares for regular interrupts/timers, so mapping
> 
>   KVM_REQ_UNBLOCK, KVM_REQ_HV_STIMER, KVM_REQ_EVENT, KVM_REQ_SMI,
>   KVM_REQ_NMI
> 
> to a KVM_POLL_INTERRUPTS_FLAG would work. We can then have ad-hoc flags
> for async-pf, kvmclock updates, dirty logging, etc...

What all does your use case need/want to poll on?  Mapping out exactly what all
you want/need to poll is probably the best way to answer this question.
