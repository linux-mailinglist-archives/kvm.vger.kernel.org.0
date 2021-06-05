Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A8039C73C
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhFEKGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Jun 2021 06:06:50 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:40648 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhFEKGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Jun 2021 06:06:48 -0400
Received: by mail-pl1-f175.google.com with SMTP id e7so5910104plj.7
        for <kvm@vger.kernel.org>; Sat, 05 Jun 2021 03:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2kfc/aUPwnTdhzCNytjgqFr2bbR5n0+oAS9lEPwRsCE=;
        b=EQclQEKG5s5ma8+a2tAF2oxc20nQzVAltE6r/UTnrmkn7pyyb+1O4aC45h+eAQmvEl
         hzQ748quieqUks+LMXQ9SSEAh0VNYZc/YnYaLdFIJpw8t4PcxfehaEhwaiLLFYqHUMZm
         nSsCWd/WEOU/oSQFP2l620iqx2hPMdX8sUrjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2kfc/aUPwnTdhzCNytjgqFr2bbR5n0+oAS9lEPwRsCE=;
        b=PybUTVKoNOfXrn3i30efbNX15HgaW4OOntlzXAV9Mv8e3WQKttNRjRxU81qOPFeH+4
         qULseN0IlgC5l55QSlnCJJfAlOwLTC8LM/rsaV83y0+kP9A0HEVm2bhDIhBYsmoWQfsG
         JzUSNTSsVxG/B8Xq5we2o+L+bft4A6Pd+akVvZvjJZ5tOfXoAse/U32gk2wwGzEYfoy6
         OavTuEjEWQabPzskbCLVFa79nxLCFWP0kxLEEB9Up+iVuOQ/bw/5skxbGFyfBzoTX+E1
         uObo8OyilSkmFxWm2r1bU5s59TBSYPwi4CrYowJpqbW0IYkPxa049ZwT64AVkhH9qQJL
         gDRA==
X-Gm-Message-State: AOAM530iTNf3/PqNESE9WBU4e1Ttkx2mgTSifUpbeA+IkyU8kbYhTIFy
        r8Dbk/FnSjU0eEqE3+DKy3PaLQ==
X-Google-Smtp-Source: ABdhPJzBpTv6ENeG7LO/XB6NHveLxN/fD1mK3I8y3kccdgfwy4g3Ww4SnC8Zc2Bz4lko7adzfzo6Ug==
X-Received: by 2002:a17:90a:e654:: with SMTP id ep20mr9433635pjb.168.1622887425979;
        Sat, 05 Jun 2021 03:03:45 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:5981:261e:350c:bb45])
        by smtp.gmail.com with ESMTPSA id d66sm3487856pfa.32.2021.06.05.03.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 03:03:45 -0700 (PDT)
Date:   Sat, 5 Jun 2021 19:03:40 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] kvm: x86: implement KVM PM-notifier
Message-ID: <YLtL/JPvGs2efZKO@google.com>
References: <20210605023042.543341-1-senozhatsky@chromium.org>
 <20210605023042.543341-2-senozhatsky@chromium.org>
 <87k0n8u1nk.wl-maz@kernel.org>
 <YLtK09pY1EjOtllS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLtK09pY1EjOtllS@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/06/05 18:58), Sergey Senozhatsky wrote:
[..]
> > > +static int kvm_arch_suspend_notifier(struct kvm *kvm)
> > > +{
> > > +	struct kvm_vcpu *vcpu;
> > > +	int i, ret;
> > > +
> > > +	mutex_lock(&kvm->lock);
> > > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > > +		ret = kvm_set_guest_paused(vcpu);
> > > +		if (ret) {
> > > +			pr_err("Failed to pause guest VCPU%d: %d\n",
> > > +			       vcpu->vcpu_id, ret);
> > 
> > Is it really a good idea to fail suspend when a guest doesn't have PV
> > time enabled? I also wonder how useful the pr_err() is, given that it
> > contains no information that would help identifying which guest failed
> > to pause.
> 
> No opinion. What shall we do when we fail to suspend the VM?
> VM's watchdogs will trigger and maybe panic the system after
> resume.

For the time being kvm_set_guest_paused() errors out when
!vcpu->arch.pv_time_enabled, but this probably can change
in the future (who knows?). So shall I check vcpu->arch.pv_time_enabled
in  kvm_arch_suspend_notifier()?
