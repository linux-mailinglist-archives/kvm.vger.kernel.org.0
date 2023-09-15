Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D8D7A1705
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 09:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjIOHMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 03:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbjIOHMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 03:12:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5923419A5
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 00:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694761901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=APHr7dSzwK5FTJvctTPY4ky9uCY4MRx06g7O1O86zP0=;
        b=VjqrKeK1A9QTnIeuihuO5vHyRcvV7Q+MUTzXa2el+2uNzbbmZLl4/bxF91HX8MCyAt/+mL
        GwPuVkrzgITuTE+o4t8WfKXFC+lo2LDM9Wh4OWw7FgF9yIHJf7qnJs80h5dSR5XTexShiD
        YP8/+NF533wh0BCvRoRl+Zl+8lL/9qQ=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-9iUl9Y_GOmKme_f4VVXgjQ-1; Fri, 15 Sep 2023 03:11:40 -0400
X-MC-Unique: 9iUl9Y_GOmKme_f4VVXgjQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1d661636928so511602fac.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 00:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694761899; x=1695366699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APHr7dSzwK5FTJvctTPY4ky9uCY4MRx06g7O1O86zP0=;
        b=oJTC0RSZHyLUvvLMpgUUwNmWu9CZ/DC0Y7YNQdJKwFkeBYQaa52DlalEpYG1skNSFD
         0CWPuk/afYYkpjczipNLb51V+Cx3s8anjVxq/Q9etpJP8QdvvjlMsJtD/wnNRYlsiaPz
         v+ZSls99beDN1SFUQDJwn1FsQSVS1RgIyDrW4uMB3kM5RYDGsvpsWS6VydyWLIuvHFfD
         lMo0F42wimRUD6q2kPE86Bs5UTwbdo1KyO50Rsv7OUveqR9sTTmkRNjTASQGmBOBMrbl
         lLqJzdStQUJoi0eTrZCHdYt/XM5BMvsS+pQ9eAD6HF11Q3R2HeBQUAOl1JjNgvOA0dzh
         JhTA==
X-Gm-Message-State: AOJu0YzKEkCtWwcBUZpxlh1dNc6hOFV2Al4f77pndFwOkesmI3cv1AKR
        Lqw+XNR+ChiKlpnUT3X3uHLpbIqFfgYx4gdKe0KEebrl92BPuZpmluhzlzlXvDquHWvUrBouca1
        6isyjRkGuoVBF
X-Received: by 2002:a05:6870:4612:b0:1d5:1a99:538f with SMTP id z18-20020a056870461200b001d51a99538fmr897689oao.15.1694761899405;
        Fri, 15 Sep 2023 00:11:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFrB9lY2yXM24KcdsjQMUoOBiTDc784MzEkkFsobwp+XSj6iwKteM3KHz/31uvrAHcexGY0w==
X-Received: by 2002:a05:6870:4612:b0:1d5:1a99:538f with SMTP id z18-20020a056870461200b001d51a99538fmr897678oao.15.1694761899161;
        Fri, 15 Sep 2023 00:11:39 -0700 (PDT)
Received: from redhat.com ([2804:1b3:a803:4ff9:7c29:fe41:6aa7:43df])
        by smtp.gmail.com with ESMTPSA id dd14-20020a056871c80e00b001d0d4c3f758sm1623507oac.9.2023.09.15.00.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 00:11:38 -0700 (PDT)
Date:   Fri, 15 Sep 2023 04:11:33 -0300
From:   Leonardo Bras <leobras@redhat.com>
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dgilbert@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Message-ID: <ZQQDpRTQ6HHr8vLp@redhat.com>
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com>
 <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 05:11:50AM -0400, Tyler Stachecki wrote:
> On Thu, Sep 14, 2023 at 04:15:54AM -0300, Leonardo Bras wrote:
> > So, IIUC, the xfeatures from the source guest will be different than the 
> > xfeatures of the target (destination) guest. Is that correct?
> 
> Correct.
>  
> > It does not seem right to me. I mean, from the guest viewpoint, some 
> > features will simply vanish during execution, and this could lead to major 
> > issues in the guest.
> 
> My assumption is that the guest CPU model should confine access to registers
> that make sense for that (guest) CPU.
> 
> e.g., take a host CPU capable of AVX-512 running a guest CPU model that only
> has AVX-256. If the guest suddenly loses the top 256 bits of %zmm*, it should
> not really be perceivable as %ymm architecturally remains unchanged.
> 
> Though maybe I'm being too rash here? Is there a case where this assumption
> breaks down?

There is no guarantee that it would be ok to simple remove a feature from 
the guest. Maybe it's fine for 99% of the cases for given feature, but it 
could always go wrong.

> 
> > The idea here is that if the target (destination) host can't provide those 
> > features for the guest, then migration should fail.
> > 
> > I mean, qemu should fail the migration, and that's correct behavior.
> > Is it what is happening?
> 
> Unfortunately, no, it is not... and that is biggest concern right now.
> 
> I do see some discussion between Peter and you on this topic and see that
> there was an RFC to implement such behavior stemming from it, here:
> https://lore.kernel.org/qemu-devel/20220607230645.53950-1-peterx@redhat.com/
> 
> ... though I do not believe that work ever landed in the tree. Looking at
> qemu's master branch now, the error from kvm_arch_put_registers is just
> discarded in do_kvm_cpu_synchronize_post_init...

This is wrong, then. QEMU should abort the migration in this case, so the 
VM is not lost.

Of course, with this issue fixed, there is another issue to deal with:
- VMs running on hosts with older kernel get stuck in hosts without the 
fixes.

Thanks,
Leo

> 
> ```
> static void do_kvm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)
> {
>     kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE);
>     cpu->vcpu_dirty = false;
> }
> ```
> 
> Best,
> Tyler
> 

