Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A8F65F6A5
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 23:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbjAEWXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 17:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbjAEWXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 17:23:18 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CA76B1BC
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 14:23:17 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c4so9428plc.5
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 14:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZUWI9B4Owwm465nJyIQW6HmnzWig8L33yKkIgBmosw=;
        b=K9f+2BQMqZtR5VH8+ECz8mesBL2ybcl/zaQ3bFlI5mtZ/hz4cF1gb/3ogwoX9PPRgl
         NckWtYkJnoE7FpHlxWSod9Xroqbi7TvW17pizpjs8wikv7HGtZlJmeJlmDRIQ/03KY3Y
         tnRBgmi5ybDUp8cBsjYKSDhIFX1q2pNnsNTQZfgIQSv0yhEcimONI1A1vWhHiyYecmes
         Q/267drc2xi2DqE5CcJYSWMEbCrXbA9NhPL3TPnXFzQtT+Fp8TvNTMG8j64mcfXmubJX
         5tH4kLRxYoZhXkdWKm+VHftCe6PMKlC6pBwtRKx+MlaL1kT/2kHXBwmRmtEL+0pxKTcF
         q89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ZUWI9B4Owwm465nJyIQW6HmnzWig8L33yKkIgBmosw=;
        b=dKrMswDXZQS5sgMO5FC6tGoq0w3e5UiaDENOG9U57EKS+7QlxsOzn5zImvtnS+CZs5
         bMHQQ8kI1lGFaCndribevgkMCp+eBy4WBdR/Lg8Z3gtU5n/oRokm18cRxileZZh/wBHF
         Mc/LYK8O6m2Itt55CMLfLwU9q7RrikQcYhtsiGX2ev9UmSupLN4XhFFpVW+atMcWWNRD
         lFNO2R7RCsdfHQeRbLutgZuBQ3Ipi/waBQjjqTLkeRZ8zRHxltuj26B23hwe1nj6Q48O
         vq7fHKKw6ol1l5P9/y5XZ+uBcSnmw0KcouJZKm6cIcEEbb1H9+yZn56ff6keikOauA33
         dr1g==
X-Gm-Message-State: AFqh2kqjnGKNziHJI0NT4pCKvSfIWGjkvuG7QwjTmaL9OQyi+K+R/vhw
        diW8E7eB2QNmIXUlS6tDciLG2Q==
X-Google-Smtp-Source: AMrXdXsCSCT5awBcuS5E75gCkeg3w/PQLlJVHtbF93EP/ViM28fZ2Nq8YfeoQwTeIwzE8wFK4X8/IQ==
X-Received: by 2002:a17:902:c153:b0:191:1543:6b2f with SMTP id 19-20020a170902c15300b0019115436b2fmr19439plj.3.1672957396726;
        Thu, 05 Jan 2023 14:23:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u9-20020a1709026e0900b00192dda430ddsm5742265plk.123.2023.01.05.14.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 14:23:16 -0800 (PST)
Date:   Thu, 5 Jan 2023 22:23:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, dwmw2@infradead.org, kvm@vger.kernel.org,
        paul@xen.org
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Message-ID: <Y7dN0Negds7XUbvI@google.com>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co>
 <20221229211737.138861-2-mhal@rbox.co>
 <Y7RjL+0Sjbm/rmUv@google.com>
 <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
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

On Thu, Jan 05, 2023, Michal Luczaj wrote:
> On 1/3/23 18:17, Sean Christopherson wrote:
> > On Thu, Dec 29, 2022, Michal Luczaj wrote:
> >> Move synchronize_srcu(&kvm->srcu) out of kvm->lock critical section.
> > 
> > This needs a much more descriptive changelog, and an update to
> > Documentation/virt/kvm/locking.rst to define the ordering requirements between
> > kvm->scru and kvm->lock.  And IIUC, there is no deadlock in the current code
> > base, so this really should be a prep patch that's sent along with the Xen series[*]
> > that wants to take kvm->-srcu outside of kvm->lock.
> > 
> > [*] https://lore.kernel.org/all/20221222203021.1944101-2-mhal@rbox.co
> 
> I'd be happy to provide a more descriptive changelog, but right now I'm a
> bit confused. I'd be really grateful for some clarifications:
> 
> I'm not sure how to understand "no deadlock in the current code base". I've
> ran selftests[1] under the up-to-date mainline/master and I do see the
> deadlocks. Is there a branch where kvm_xen_set_evtchn() is not taking
> kvm->lock while inside kvm->srcu?

Ah, no, I'm the one that's confused, I saw an earlier patch touch SRCU stuff and
assumed it introduced the deadlock.  Actually, it's the KVM Xen code that's confused.

This comment in kvm_xen_set_evtchn() is a tragicomedy.  It explicitly calls out
the exact case that would be problematic (Xen hypercall), but commit 2fd6df2f2b47
("KVM: x86/xen: intercept EVTCHNOP_send from guests") ran right past that.

	/*
	 * For the irqfd workqueue, using the main kvm->lock mutex is
	 * fine since this function is invoked from kvm_set_irq() with
	 * no other lock held, no srcu. In future if it will be called
	 * directly from a vCPU thread (e.g. on hypercall for an IPI)
	 * then it may need to switch to using a leaf-node mutex for
	 * serializing the shared_info mapping.
	 */
	mutex_lock(&kvm->lock);

> Also, is there a consensus as for the lock ordering?  IOW, is the state of
> virt/kvm/locking.rst up to date, regardless of the discussion going on[2]?

I'm not convinced that allowing kvm->lock to be taken while holding kvm->srcu is
a good idea.  Requiring kvm->lock to be dropped before doing synchronize_srcu()
isn't problematic, and arguably it's a good rule since holding kvm->lock for
longer than necessary is undesirable.  What I don't like is taking kvm->lock inside
kvm->srcu.  It's not documented, but in pretty much every other case except Xen,
sleepable locks are taken outside of kvm->srcu, e.g. vcpu->mutex, slots_lock, and
quite often kvm->lock itself.

Ha!  Case in point.  The aforementioned Xen code blatantly violates KVM's locking
rules:

  - kvm->lock is taken outside vcpu->mutex

In the kvm_xen_hypercal() case, vcpu->mutex is held (KVM_RUN) when kvm_xen_set_evtchn()
is called, i.e. takes kvm->lock inside vcpu->mutex.  It doesn't cause explosions
because KVM x86 only takes vcpu->mutex inside kvm->lock for SEV, and no one runs
Xen+SEV guests, but the Xen code is still a trainwreck waiting to happen.

In other words, I'm find with this patch for optimization purposes, but I don't
think we should call it a bug fix.  commit 2fd6df2f2b47 ("KVM: x86/xen: intercept
EVTCHNOP_send from guests") is the one who is wrong and needs fixing.
