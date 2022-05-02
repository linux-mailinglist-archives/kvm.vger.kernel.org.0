Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBBA51751F
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386567AbiEBQ4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 12:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386455AbiEBQ4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 12:56:04 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7147DFD21
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 09:51:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so13185610pjm.1
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 09:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FR217X+sFZL46Wxt9EvSsoLWknD7uWUFk7IHaZjgk18=;
        b=djimFbijDCzrFhkQD10nuWI4luGThhVdo3NKqwTf1z0IanLgpqjTqe/DI6RZcEDejz
         Qf1jiP21D8fkk0ZzrhzDOV5iH/DtZXFCbwcqKwx1Cx99AzkiloCknKreU2RtvlKPWn7h
         oJBXCr+s2GpO/iH6g2BQAr7G40owz2zIa1mfHBaKmzTuNawocY8S12g3ukdBFVNZxB1c
         R5K23bsvyrLH4Is4OewGMC/REV7wYO3GeZS69j/Mziy+q3wUcP425hltALfW4zYGrnBP
         qd3VQqOhyK6ZNrLxqa+0LDbXyRkbXF+eltDSGPRlVWvjM1xfwcnff5zAGcGUBUFt0i4M
         nqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FR217X+sFZL46Wxt9EvSsoLWknD7uWUFk7IHaZjgk18=;
        b=SKlVozPrJtcnd8QAj3BWOZiusiqckcl3tfwBj82XBFJDwHh9ExM+WbuOvwqiUZEK+I
         7D0nlDICGnRoyWrtcVnjOEa9LWzT1G+M/bUDnqpNiaAmbAYTXIsJ8cHhojz7zdFrMLrf
         SYNGQWW3KMBjn27nAXQ8sqFzyeZIQDvL3wXItVAmIuPdEeZw+aGE+A8JMOtoM+llBdNG
         yXCYDr0o/sv84HjxPKpjA+sH0p28DyFC9aMnAafxSzpXojrwlYIkl7VvFQWQrH026FDo
         U9QMEOeD4gjnVcC0RPtvSENRZWLsrmZs/cpEfO3iUMnB9Qqgt8k1thJ13nTtqheAWpUq
         GIdw==
X-Gm-Message-State: AOAM532PfvvEUSI3MSanzUTSOIcILO6BYTY3mgLx+Mr+iEKVweOkmr33
        kQs7HesnFz85idRhai1Zz52R+w==
X-Google-Smtp-Source: ABdhPJyfSMAkTbFQTeRCi6rt/IBnxILI+oALBStLdb+s/26rtdZP6M6Mk8zS2NlsKI8Ul6pW6MgH6w==
X-Received: by 2002:a17:902:a705:b0:156:9cc5:1d6f with SMTP id w5-20020a170902a70500b001569cc51d6fmr12597635plq.66.1651510318553;
        Mon, 02 May 2022 09:51:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c21-20020aa78c15000000b0050dc7628179sm4928026pfd.83.2022.05.02.09.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 09:51:58 -0700 (PDT)
Date:   Mon, 2 May 2022 16:51:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR
Message-ID: <YnAMKtfAeoydHr3x@google.com>
References: <337332ca-835c-087c-c99b-92c35ea8dcd3@redhat.com>
 <Ymv1I5ixX1+k8Nst@google.com>
 <20e1e7b1-ece7-e9e7-9085-999f7a916ac2@redhat.com>
 <Ymv5TR76RNvFBQhz@google.com>
 <e5864cb4-cce8-bd32-04b0-ecb60c058d0b@redhat.com>
 <YmwL87h6klEC4UKV@google.com>
 <ac2001e66957edc8a3af2413b78478c15898f86c.camel@redhat.com>
 <f3ffad3aa8476156f369ff1d4c33f3e127b47d0c.camel@redhat.com>
 <82d1a5364f1cc479da3762b046d22f136db167e3.camel@redhat.com>
 <af15fd31f73e8a956da50db6104e690f9d308dad.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af15fd31f73e8a956da50db6104e690f9d308dad.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022, Maxim Levitsky wrote:
> On Mon, 2022-05-02 at 10:59 +0300, Maxim Levitsky wrote:
> > > > Also I can reproduce it all the way to 5.14 kernel (last kernel I have installed in this VM).
> > > > 
> > > > I tested kvm/queue as of today, sadly I still see the warning.
> > > 
> > > Due to a race, the above statements are out of order ;-)
> > 
> > So futher investigation shows that the trigger for this *is* cpu_pm=on :(
> > 
> > So this is enough to trigger the warning when run in the guest:
> > 
> > qemu-system-x86_64  -nodefaults  -vnc none -serial stdio -machine accel=kvm
> > -kernel x86/dummy.flat -machine kernel-irqchip=on -smp 8 -m 1g -cpu host
> > -overcommit cpu-pm=on
> > 
> > 
> > '-smp 8' is needed, and the more vCPUs the more often the warning appears.
> > 
> > 
> > Due to non atomic memslot update bug, I use patched qemu version, with an
> > attached hack, to pause/resume vcpus around the memslot update it does, but
> > even without this hack, you can just ctrl+c the test after it gets the KVM
> > internal error, and then tdp mmu memory leak warning shows up (not always
> > but very often).
> > 
> > 
> > Oh, and if I run the above command on the bare metal, it  never terminates.
> > Must be due to preemption, qemu shows beeing stuck in kvm_vcpu_block. AVIC
> > disabled, kvm/queue.  Bugs, bugs, and features :)
> 
> All right, at least that was because I removed the '-device isa-debug-exit,iobase=0xf4,iosize=0x4',
> which is apparently used by KVM unit tests to signal exit from the VM.

Can you provide your QEMU command line for running your L1 VM?  And your L0 and L1
Kconfigs too?  I've tried both the dummy and ipi_stress tests on a variety of hardware,
kernels, QEMUs, etc..., with no luck.
