Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75FE365C41
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 17:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhDTPdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 11:33:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232504AbhDTPc7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 11:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618932747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VzIaFG2wDVdYEizwLnnsRmeoa1MCm+iU4UbjuWNpwW0=;
        b=anQNL0wjSuL+tM5fUdujq03WYaqY6ZeMd0MNBcTP2U6f2d3oO5DF3aTtX/rHPNZ2pMFXfx
        kY4MnYw7F8BZHyFfJLVL1l7b0UNIZeDExyfh8mgp2y9PmuNwJEw4hRk6eEtLIpCa5zqqjU
        deAmLd2xi06YJfFlIm7uOhg+4S8HQqY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-CXMuNUbKNYKwuJsbh16QLA-1; Tue, 20 Apr 2021 11:32:26 -0400
X-MC-Unique: CXMuNUbKNYKwuJsbh16QLA-1
Received: by mail-qt1-f198.google.com with SMTP id y10-20020a05622a004ab029019d4ad3437cso11282087qtw.12
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 08:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VzIaFG2wDVdYEizwLnnsRmeoa1MCm+iU4UbjuWNpwW0=;
        b=ui0tBaKTyPeLyoBlrS4BJmIA7cAKn5Vgs6aAT56VS5N8xNmdpOJUyvlF2rLBu0iOVJ
         5OPyCHUWAzvSfXwOIplMwGL2kAN9A6dIbhChj9NSI3p/v6BvZtKbScDpHoJbPcs3pdHl
         gamK8SpaLSz4IAL8CznJ1y2Vo96yncgxKbEN840em7QIwiBwLGq2vSgJU5LWb/FGKyVa
         WbzobWImmvNAV5vYRcrlZbcaxN5drI70H8JJoFgmUaip3tMQVNTc/i1Ej7Aga0E2QlMA
         sIzwzctGq4aMpKIKiBMDpk9ZJbd7J4WjMJO12gn5OfYhSKx2iClbzIWNV/6FM6S0Aqo/
         /XOw==
X-Gm-Message-State: AOAM531MNcuksbz8/bHLzeFa6EEBmJDpj/uNTnzv+DhlO8C9onEw5wvb
        HskaGivusI4qlpLEr+SqlXeS+VnLREJY6G9iOEuYeIslWbNsPMu91i/cXnOpJixGNFL1KL0yGRu
        uteMXMxJ1x88b
X-Received: by 2002:a37:e108:: with SMTP id c8mr18492837qkm.499.1618932745573;
        Tue, 20 Apr 2021 08:32:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTKbZtJzki1RdMo4jaIwSDT4vU8zynoJCipKGsXfaSJHphwrc9cgg+bXzWrjtb96DzF1vjiQ==
X-Received: by 2002:a37:e108:: with SMTP id c8mr18492812qkm.499.1618932745353;
        Tue, 20 Apr 2021 08:32:25 -0700 (PDT)
Received: from xz-x1 (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id f8sm4135429qkh.83.2021.04.20.08.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 08:32:24 -0700 (PDT)
Date:   Tue, 20 Apr 2021 11:32:23 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Always run vCPU thread with blocked
 SIG_IPI
Message-ID: <20210420153223.GB4440@xz-x1>
References: <20210420081614.684787-1-pbonzini@redhat.com>
 <20210420143739.GA4440@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210420143739.GA4440@xz-x1>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 10:37:39AM -0400, Peter Xu wrote:
> On Tue, Apr 20, 2021 at 04:16:14AM -0400, Paolo Bonzini wrote:
> > The main thread could start to send SIG_IPI at any time, even before signal
> > blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
> > blocked.
> > 
> > Without this patch, on very busy cores the dirty_log_test could fail directly
> > on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).
> > 
> > Reported-by: Peter Xu <peterx@redhat.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Yes, indeed better! :)
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>

I just remembered one thing: this will avoid program quits, but still we'll get
the signal missing.  From that pov I slightly prefer the old patch.  However
not a big deal so far as only dirty ring uses SIG_IPI, so there's always ring
full which will just delay the kick. It's just we need to remember this when we
extend IPI to non-dirty-ring tests as the kick is prone to be lost then.

Thanks,

-- 
Peter Xu

