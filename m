Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B537A1713
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 09:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjIOHOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 03:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbjIOHOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 03:14:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5963610E6
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 00:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694761999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ouP+ZP8Mbe0wZaRCaE13qGCiJURFQJ92+/y4fHbKuP8=;
        b=JdLmATjAu+utud2j6Me5RJvuSRhKFmFN+O7423//Zwgh4RhdqQRDWguox6Yy3QDujlqOQ9
        KtPOA1eJ/9qpBIQ1LJV97FnQ3q7n5Dcb7j/Loj1y3GtK7gzJjuOcd7fzbpgpDSjumalmVl
        iRo8S6ZWmwagybQgXX3He6TVLUg6JwE=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-lrserVNYO9ylFakdU8wRHw-1; Fri, 15 Sep 2023 03:13:16 -0400
X-MC-Unique: lrserVNYO9ylFakdU8wRHw-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6c20f3269e4so2293660a34.2
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 00:13:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694761996; x=1695366796;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouP+ZP8Mbe0wZaRCaE13qGCiJURFQJ92+/y4fHbKuP8=;
        b=KWfAadlQQHqlhpBw5BU2eE/8ONw+gQbQ4DpnDGkuYHocDAL7Vl8qJfLIcwJVCk2fpm
         5Vw8RtALaMA4BTJysfg9PNd+XeJW3B8WTvam3x6qCWsJT+G2qtGBHwWxOfs5Aojrdr1b
         3hQyqEjYSpTsj3dTUwFKLbzIU9/r/H2ogbRfGODW8tg1HP2BxDgi7ajX0lsnrT33UopY
         Eb3BOrBqXiq5SnIy0qLstIElYS9DAAQipFd7te6smJNSTElW6DwUiZdv+7Dpzu9ry3jl
         WXmh56EYd1G85MzVa849O2/EOJh9vBXShWQvndIVTi6UzW6xIYwcBvXej8SD+08Nrgs/
         fdcQ==
X-Gm-Message-State: AOJu0YxHLYE3xLkqn7VoMHjuT2I7d45jgSBkS91pdpzrvKL7f8+F6xde
        T8owS1nQQKGF2O2J+rRico3a4syJE/HkFVrK//3HS976oSKfRKym8HB4YiPfYKlPU3WcFpjVaup
        51d3ojU5ql7Kr
X-Received: by 2002:a9d:68da:0:b0:6bc:88da:af44 with SMTP id i26-20020a9d68da000000b006bc88daaf44mr781615oto.6.1694761995984;
        Fri, 15 Sep 2023 00:13:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpVrhOh7Vo+lEanWcrsNYHpYt/SL3pA60poShm0YciHWUK9jTEihaeETy+P4b98zP+SJhiQA==
X-Received: by 2002:a9d:68da:0:b0:6bc:88da:af44 with SMTP id i26-20020a9d68da000000b006bc88daaf44mr781608oto.6.1694761995743;
        Fri, 15 Sep 2023 00:13:15 -0700 (PDT)
Received: from redhat.com ([2804:1b3:a803:4ff9:7c29:fe41:6aa7:43df])
        by smtp.gmail.com with ESMTPSA id b6-20020a9d6b86000000b006b9848f8aa7sm1439011otq.45.2023.09.15.00.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 00:13:15 -0700 (PDT)
Date:   Fri, 15 Sep 2023 04:13:10 -0300
From:   Leonardo Bras <leobras@redhat.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Tyler Stachecki <stachecki.tyler@gmail.com>, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dgilbert@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        bp@alien8.de, Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Message-ID: <ZQQEBpJZ-_hg42Vi@redhat.com>
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com>
 <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
 <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 10:05:57AM -0700, Dongli Zhang wrote:
> 
> 
> On 9/14/23 2:11 AM, Tyler Stachecki wrote:
> > On Thu, Sep 14, 2023 at 04:15:54AM -0300, Leonardo Bras wrote:
> >> So, IIUC, the xfeatures from the source guest will be different than the 
> >> xfeatures of the target (destination) guest. Is that correct?
> > 
> > Correct.
> >  
> >> It does not seem right to me. I mean, from the guest viewpoint, some 
> >> features will simply vanish during execution, and this could lead to major 
> >> issues in the guest.
> 
> I fully agree with this.
> 
> I think the original commit ad856280ddea ("x86/kvm/fpu: Limit guest
> user_xfeatures to supported bits of XCR0") is for the source server, not
> destination server.
> 
> That is:
> 
> 1. Without the commit (src and dst), something bad may happen.
> 
> 2. With the commit on src, issue is fixed.
> 
> 3. With the commit only dst, it is expected that issue is not fixed.
> 
> Therefore, from administrator's perspective, the bugfix should always be applied
> no the source server, in order to succeed the migration.
> 
> 
> BTW, we may not be able to use commit ad856280ddea in the Fixes tag.
> 
> > 
> > My assumption is that the guest CPU model should confine access to registers
> > that make sense for that (guest) CPU.
> > 
> > e.g., take a host CPU capable of AVX-512 running a guest CPU model that only
> > has AVX-256. If the guest suddenly loses the top 256 bits of %zmm*, it should
> > not really be perceivable as %ymm architecturally remains unchanged.
> > 
> > Though maybe I'm being too rash here? Is there a case where this assumption
> > breaks down?
> > 
> >> The idea here is that if the target (destination) host can't provide those 
> >> features for the guest, then migration should fail.
> >>
> >> I mean, qemu should fail the migration, and that's correct behavior.
> >> Is it what is happening?
> > 
> > Unfortunately, no, it is not... and that is biggest concern right now.
> > 
> > I do see some discussion between Peter and you on this topic and see that
> > there was an RFC to implement such behavior stemming from it, here:
> > https://lore.kernel.org/qemu-devel/20220607230645.53950-1-peterx@redhat.com/
> 
> I agree that bug is at QEMU side, not KVM side.
> 
> It is better to improve at QEMU side.

I agree fixing QEMU is the best solution we have.

> 
> 4508 int kvm_arch_put_registers(CPUState *cpu, int level)
> 4509 {
> 4510     X86CPU *x86_cpu = X86_CPU(cpu);
> 4511     int ret;
> ... ...
> 4546     ret = kvm_put_xsave(x86_cpu);
> 4547     if (ret < 0) {
> 4548         return ret;
> 4549     }
> ... ...--> the rest of kvm_arch_put_registers() won't execute !!!
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> > 
> > ... though I do not believe that work ever landed in the tree. Looking at
> > qemu's master branch now, the error from kvm_arch_put_registers is just
> > discarded in do_kvm_cpu_synchronize_post_init...
> > 
> > ```
> > static void do_kvm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)
> > {
> >     kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE);
> >     cpu->vcpu_dirty = false;
> > }
> > ```
> > 
> > Best,
> > Tyler
> 

