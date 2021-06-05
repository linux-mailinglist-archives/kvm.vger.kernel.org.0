Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FAC39C786
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 12:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFEKvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Jun 2021 06:51:40 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:41777 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhFEKvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Jun 2021 06:51:39 -0400
Received: by mail-pj1-f42.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso7352205pji.0
        for <kvm@vger.kernel.org>; Sat, 05 Jun 2021 03:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=puvKdnbjMWRss9Xc+jeycrE74wvzwgdG7JS/tm3IR6Q=;
        b=VNMp6zMbH6Ai/UggoxUb8JogjuT4S/q2uuPY4DIP7HPKXrHzIX+KooI9HZ1UZn30yB
         H8WrYZ4q+lcp6WyeRq/rpgSCfcJ87MRwrTwNBg8KG1YkvIKF6Pbxi6QpOQ07BZ9r3c7M
         5pM8UM2Uy6rb8+7j+Y4sKGgi6L1lhdvEuurmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=puvKdnbjMWRss9Xc+jeycrE74wvzwgdG7JS/tm3IR6Q=;
        b=ecWK4wI25UOHvY1idtabSBIifc37+b3MAqR7P08eF0vOgLvP069fTnhO5OPDCQ0jxa
         X71IF/R6cFPMLYNpzvPUr3RSSuVEzlu5Hq9uo5fgSHliFuC7HQOrdIkb2Qugl2VsmQWo
         VqhWlogEPTLiO8pXY++GlEOxTzCFd53ncOXYcetQp72tXQPdbfIngqXq4/rZRdyanxCI
         uTrAlj7G1LeQc0qpTkJYVzLfSUAfbJ+01FjwV+8tCAR1z949l5AXYgxRYjnJRTyendeb
         4wB6jMqnWivk8bx955EshR1zx5IctFG3P1tTFQF6VOovt/bCo14n/ebqc3x2xVPy7fKS
         zLNQ==
X-Gm-Message-State: AOAM533ATu347l1HWxbasNWetopMX/RtSGLcCBeZD++iYYFCKxG9IUB3
        9inrnacswi857XTF8bmOeg9owQ==
X-Google-Smtp-Source: ABdhPJxQenHO0csxkientjHPUyIKwoWUMZs3GjdceB3pQigyjUSVLp9kfLlM4L4bqXVJH20LFqMqyQ==
X-Received: by 2002:a17:902:e04e:b029:10f:133f:87c8 with SMTP id x14-20020a170902e04eb029010f133f87c8mr8260590plx.70.1622890131931;
        Sat, 05 Jun 2021 03:48:51 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:5981:261e:350c:bb45])
        by smtp.gmail.com with ESMTPSA id j12sm3921984pgj.14.2021.06.05.03.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 03:48:51 -0700 (PDT)
Date:   Sat, 5 Jun 2021 19:48:46 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] kvm: x86: implement KVM PM-notifier
Message-ID: <YLtWjiFb62RFLWzA@google.com>
References: <20210605023042.543341-1-senozhatsky@chromium.org>
 <20210605023042.543341-2-senozhatsky@chromium.org>
 <87k0n8u1nk.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0n8u1nk.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/06/05 10:00), Marc Zyngier wrote:
> > +static int kvm_arch_suspend_notifier(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	int i, ret;
> > +
> > +	mutex_lock(&kvm->lock);
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		ret = kvm_set_guest_paused(vcpu);
> > +		if (ret) {
> > +			pr_err("Failed to pause guest VCPU%d: %d\n",
> > +			       vcpu->vcpu_id, ret);
> 
> how useful the pr_err() is, given that it contains no information
> that would help identifying which guest failed to pause.

Do other printk-s contain such info? All I can see so far is
`#define pr_fmt(fmt) "kvm-guest: " fmt` which doesn't point
at any particular VM.
