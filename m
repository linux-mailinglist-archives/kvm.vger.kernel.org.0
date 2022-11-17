Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96B062E280
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbiKQREF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiKQRED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:04:03 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537D817588
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 09:04:02 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id 4so2226112pli.0
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 09:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NbGjMXnNRTWTxJ9YNQhElal9r0Svh+g4mznlOcVIq5U=;
        b=eHArN0z1+CIykremaYKFVK7M3B1IMquDGNl8UP/KANaLJD3hsQYQZLC1nSgTfJUJng
         QhcmPxuEnp2HeNzqYclpr9I7kUDbMyZ/kC502myMY3HtgObq8tPIw+qqyRMmdB+jX7Wr
         dxS+n9fWTRx55Zw3JWg4tvjtVMmdriZvJavQGKSK4smv10j6pDseGB1c5Rj7JDM4sthU
         gowCDSW72AUs5K1o4YAzeF8q8jph/m65Goa4U7fTTpw5OtVH1fFHy7lIgBrE4QQcudRj
         76vH0wH8lbTgKkoOmLz0Wm10dA4tO5sPboyNZCJhfYYykP3+AlnQHKWCkvemELC3dKn7
         8VNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NbGjMXnNRTWTxJ9YNQhElal9r0Svh+g4mznlOcVIq5U=;
        b=1mIXbiYXHVHKUoAza9yC2+HyMQZ1v1ciiqbhdxXZNhNJumtkktCsw5if3ZI5NJVBAX
         VQNcGY/vL/v0UabrHxR5AexaeXqvZo5Hu9Q6aE24lKGvgaXo3fypvAWhtmJirOIoLUoL
         ouBINcQRfDRJTScaVt09pu3bHU6vd3JHA5iTibUskn/hd6LbNjsEbawK85D4YXO1ywdR
         doR42MFoZcKxiYHmO0ibO9/73oY+ZhvE02TPDyS0ZTmxhj0Pm95U2MA6jDg2HJAxfXXh
         YEH/aWUuhblYVtts2Z7VQHiRMdXkvGqLyE6L+T0G9vID0Ohs1k7UAt6Xk0eRMTCB6VK1
         T1Og==
X-Gm-Message-State: ANoB5pkEhZNhzQyLqrMsvsatnZysv+MPI3ZvmK4R4Afnb2DY1EULRUEP
        YEpPciyp8pkqR8eE0/TSUugO1w==
X-Google-Smtp-Source: AA0mqf4mHc0YCj7VrJ+5yTi2Zu4eGxMzwiS7yVl7aPkDfrJy4isI8qzr6TWwW2Atgwxm2caYXrhprg==
X-Received: by 2002:a17:902:6b0c:b0:188:abcc:249f with SMTP id o12-20020a1709026b0c00b00188abcc249fmr3640950plk.44.1668704641659;
        Thu, 17 Nov 2022 09:04:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902f14900b0017f7628cbddsm1634972plb.30.2022.11.17.09.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:04:01 -0800 (PST)
Date:   Thu, 17 Nov 2022 17:03:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86/mmu: Do not recover dirty-tracked NX Huge
 Pages
Message-ID: <Y3ZpfU3pWBNyqfoL@google.com>
References: <20221103204421.1146958-1-dmatlack@google.com>
 <Y2l247/1GzVm4mJH@google.com>
 <d636e626-ae33-0119-545d-a0b60cbe0ff7@redhat.com>
 <Y3ZjzZdI6Ej6XwW4@google.com>
 <323bc39e-5762-e8ae-6e05-0bc184bc7b81@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <323bc39e-5762-e8ae-6e05-0bc184bc7b81@redhat.com>
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

On Thu, Nov 17, 2022, Paolo Bonzini wrote:
> On 11/17/22 17:39, Sean Christopherson wrote:
> > Right, what I'm saying is that this approach is still sub-optimal because it does
> > all that work will holding mmu_lock for write.
> > 
> > > Also, David's test used a 10-second halving time for the recovery thread.
> > > With the 1 hour time the effect would Perhaps the 1 hour time used by
> > > default by KVM is overly conservative, but 1% over 10 seconds is certainly a
> > > lot larger an effect, than 1% over 1 hour.
> > 
> > It's not the CPU usage I'm thinking of, it's the unnecessary blockage of MMU
> > operations on other tasks/vCPUs.  Given that this is related to dirty logging,
> > odds are very good that there will be a variety of operations in flight, e.g.
> > KVM_GET_DIRTY_LOG.  If the recovery ratio is aggressive, and/or there are a lot
> > of pages to recover, the recovery thread could hold mmu_lock until a reched is
> > needed.
> 
> If you need that, you need to configure your kernel to be preemptible, at
> least voluntarily.  That's in general a good idea for KVM, given its
> rwlock-happiness.

IMO, it's not that simple.  We always "need" better live migration performance,
but we don't need/want preemption in general.

> And the patch is not making it worse, is it?  Yes, you have to look up the
> memslot, but the work to do that should be less than what you save by not
> zapping the page.

Yes, my objection  is that we're adding a heuristic to guess at userspace's
intentions (it's probably a good guess, but still) and the resulting behavior isn't
optimal.  Giving userspace an explicit knob seems straightforward and would address
both of those issues, why not go that route?

> Perhaps we could add to struct kvm a counter of the number of log-pages
> memslots.  While a correct value would only be readable with slots_lock
> taken, the NX recovery thread is content with an approximate value and
> therefore can retrieve it with READ_ONCE or atomic_read().
> 
> Paolo
> 
