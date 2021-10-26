Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EDE43B676
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbhJZQIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbhJZQIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 12:08:10 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F691C061348
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 09:05:46 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m21so14597620pgu.13
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 09:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=axyf08WviySN11iZLF7pvcbPVr9Tk/PFM+tNndTNVYI=;
        b=iQePVTdEuB5QnnlJAY720k5hCNqaxfpMurUaWOwF+FPvFIZoOykBdAirl6QjrY8Frt
         JsqnuTXYwc0MP1v7Qyp6of1Y86z3Qj+o8ugyOwFFBKmjWF8/aDwgNRThupbtvaZZcINN
         zPsRp5SBeJgAaiNnnO6O5vXWdSlErH4Rj75vnN/M0e0svhyEvewS+3s8AG1vHtjKTMH1
         NFgScKAf3Bh/xOm8z8gyklXr12Hc2wD/bmGCqPMUdOh+FcNIVv1rAjQwV7wm8rs8duOP
         mXLeB7qvJXu6G+QxV4ORE35i/+kDLuQy4+wXyMRV59D9ifTzza3/uYX9lCGHANL1qAtE
         p1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=axyf08WviySN11iZLF7pvcbPVr9Tk/PFM+tNndTNVYI=;
        b=V0AJFZ8AFGSgOCsmS2MwazU0VGiLAKDe1p3GuoNmqYAAmABW49UVii26Cd7iP2IR7z
         XAwvvUjccw7Vi7dnFmn3syAUB4GgcuPvBJnniQa54yu9NVIaz9yrT3PofyOcG7mFdIVG
         6Gx5ycgDevVzcCGmXTl/cwwL59xfD1dlBRdrXo1UKcXZwIHXAuMSctZy91Fw1GZm92tR
         2ev2hnYFKQJvD4TnBbp8D8zock4nAND3eXveT5tfEpe03gh53rdgWbnZmpOzzGuRi/MF
         8U8K7VJy+AR6mChNaRGsj7Bz7/TJB56CiF5ghsRd5kRWLM0qKEEok1XJZrrYhsBKVO7T
         werg==
X-Gm-Message-State: AOAM533QKpPtnb2eCO6YM4sIDlA0EL+URuaQkDPBlwDCgXSdQZocPtJx
        bovk9fJWW71VD5u6azkR2MLRjg==
X-Google-Smtp-Source: ABdhPJywtsSkU09RjTNkq24ufBF3SpaN0884fTa3A2AzTzL/F0k/mBinDVj3Qo8rwkpkLQMzQwvUcw==
X-Received: by 2002:aa7:90d0:0:b0:44d:b8a:8837 with SMTP id k16-20020aa790d0000000b0044d0b8a8837mr26863459pfk.47.1635264345797;
        Tue, 26 Oct 2021 09:05:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c15sm13900622pfv.66.2021.10.26.09.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 09:05:45 -0700 (PDT)
Date:   Tue, 26 Oct 2021 16:05:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, mtosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] KVM: x86: Take srcu lock in post_kvm_run_save()
Message-ID: <YXgnVdHCMZQDFRx6@google.com>
References: <606aaaf29fca3850a63aa4499826104e77a72346.camel@infradead.org>
 <YXgTugzJgJYUu01A@google.com>
 <f1dcf1af7e50649c66054ccf04c0052bb09d7f71.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1dcf1af7e50649c66054ccf04c0052bb09d7f71.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 26, 2021, David Woodhouse wrote:
> On Tue, 2021-10-26 at 14:42 +0000, Sean Christopherson wrote:
> > What about taking the lock well early on so that the tail doesn't need to juggle
> > errors?  Dropping the lock for the KVM_MP_STATE_UNINITIALIZED case is a little
> > unfortunate, but that at least pairs with similar logic in x86's other call to
> > kvm_vcpu_block().  Relocking if xfer_to_guest_mode_handle_work() triggers an exit
> > to userspace is also unfortunate but it's not the end of the world.
> > 
> > On the plus side, the complete_userspace_io() callback doesn't need to worry
> > about taking the lock.
> 
> Yeah, that seems sensible for master, but I suspect I'd err on the side
> of caution for backporting to stable first?

Agreed, dirty-but-simple for stable.
