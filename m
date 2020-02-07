Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96958155C90
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgBGRFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:05:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49539 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726956AbgBGRFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581095104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W/mzwS+af3IHrG/BFwWznCkZFHf8eWaEKxp9UaXyBTw=;
        b=GKDS7DGLwyM58djj2/+w5epqUJNUTfhIFPOufZENcFqUcDCCC2Sd3Lz4vzwiKWqPnUK1Vg
        eV5aFbtLbVt/f1/UvwMg3coQzLt4Fdm+wqGs2nCn4odqPSvY5U+IIJzJxbL5whCYQC7BpY
        VxyluW+JCx/JEle+WHxA72ztE/fXDk4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352--6n3MruRO9mjJrZ7Fj6sPQ-1; Fri, 07 Feb 2020 12:04:46 -0500
X-MC-Unique: -6n3MruRO9mjJrZ7Fj6sPQ-1
Received: by mail-qk1-f197.google.com with SMTP id 24so1834788qka.16
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 09:04:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W/mzwS+af3IHrG/BFwWznCkZFHf8eWaEKxp9UaXyBTw=;
        b=oMgJFL8U+sTV8bm6hUhhrTaI/0bmWV7O3iKawUcCmIYlaRmKNu3/MEO4rCLRJKD0Bb
         MsKyVlPrgFhdRbXN9rkCvSy4yaXhGqlqBSX96/jftKuMcLpbYlveV9U4G+xkuzMdH+jk
         sB4BjWg/ymezRnvGCf2nUGSnZBn4q6NzhsGjYQZjKUPG8BqNyiyvwt1ZvyoXQuTs7om0
         kXJK87OGtyeFVp3XPO4ExoxItUUjRuo92lWTAexSYZiGFP0CvWVpPTqHYuJT3J7QctRu
         i6vNK1JuKMYWz0cYID4ReWGZjsdyY1wLWJaGnX1qN29Ziy24/T0n4Jke9q71+wPiVIny
         VRIw==
X-Gm-Message-State: APjAAAXrqj8p0V8SzmSUM4NHoO9VnqkNzBw0E8ik+f9r6DIeQHSFjCFc
        jr8POE8oQWwkGLhueOQ1ksV/hBZzIES9mxscSerfQeTCcPWsSpyce+Sx4Aq3jcg+FuenQn2sRKU
        xoaKeUPxmAK8j
X-Received: by 2002:ac8:540f:: with SMTP id b15mr8284825qtq.237.1581095086455;
        Fri, 07 Feb 2020 09:04:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqw1G0WIFJFzF3ZaR8RGw77pX9iDrwBoxVk9+CVkdk7fCeK283mLiW1K0rb7VbrSqZfB/uogkQ==
X-Received: by 2002:ac8:540f:: with SMTP id b15mr8284804qtq.237.1581095086189;
        Fri, 07 Feb 2020 09:04:46 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id z11sm1575949qkj.91.2020.02.07.09.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 09:04:45 -0800 (PST)
Date:   Fri, 7 Feb 2020 12:04:43 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: Disable preemption in kvm_get_running_vcpu()
Message-ID: <20200207170443.GB720553@xz-x1>
References: <20200207163410.31276-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200207163410.31276-1-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 04:34:10PM +0000, Marc Zyngier wrote:
> Accessing a per-cpu variable only makes sense when preemption is
> disabled (and the kernel does check this when the right debug options
> are switched on).
> 
> For kvm_get_running_vcpu(), it is fine to return the value after
> re-enabling preemption, as the preempt notifiers will make sure that
> this is kept consistent across task migration (the comment above the
> function hints at it, but lacks the crucial preemption management).
> 
> While we're at it, move the comment from the ARM code, which explains
> why the whole thing works.
> 
> Fixes: 7495e22bb165 ("KVM: Move running VCPU from ARM to common code").
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

