Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D9E4CB245
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 23:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiCBW0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 17:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiCBW0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 17:26:39 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A82E4D08
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 14:25:55 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so3165942pjb.0
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 14:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g7EzPTbKYLqO23m3ywH5y06sJN6hD3WoKEJqYdmdBo8=;
        b=a9yHIBRHVnkkbeJTPV3c7G5nXhO7+BJASkO0lFCAY8yXyU+/uaBydkqUomDxsuecPC
         b+DLOTNSKvcGdpbIcWKyXEMs939C8QZvZ67peRNpPBbJc/tWDaIlBFvMn6C4H76PxOpI
         Tb+o/c/TYtDJYPyfJE+K4jkP72YTPt28V5ipJSdnOI/iSDZI4oT4ENpdNOUkfpx8DarH
         YkiPc2l4g/2iXH2u7O/wZyJ0SfrGr7PDkS6CL0VgM/O74V3NG8CSPZqdfc7QgsR0f639
         vQTihqM4qujlCo0NR3ubWH0Jl2hh5WhNmm3wUj8OglcB0xe51c+ubeRXs7rJCEGTZ+GT
         K8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g7EzPTbKYLqO23m3ywH5y06sJN6hD3WoKEJqYdmdBo8=;
        b=h+otWmRE6Vv+VpK2W3vjMs19OKxtWSI5VF0x/xsMr6hPnQi91Hz+P+RYUFdYUPzBvy
         GUOnRQRUCUG9pXvc8fPp3VHAeAotRwVlJS99312P3/Ovpg0dLsBv0JafvZ3Fvw2AobqR
         uzFrGhVH9PLBKZVPDB+fogfIVh3ZCQXmWOq64AAbSPiXF8sYWNNccttlUC5FeStnaCAg
         m1o31nW/v9GnTJsFILQwnAfA0PF+j/PJhOU6MOmh1GKmM+kklzCjLu4w6A3nd66tah0O
         QyJaM8kHdjcSWLMFOKPaL8ahjKf4YsXtOTV5gRqI8Ti8n/jvoLyI4GU6hw0/sDhB8PqQ
         TNRw==
X-Gm-Message-State: AOAM533rA+6clFBQhqd4wtK7a7uy5SXKjKB2T4EOT4Pa5gID5cvCUo8F
        AEGlIFKU80SuO/bXaxBrSEHbsg==
X-Google-Smtp-Source: ABdhPJxh60e2JCqYRzDosRtR/WPg4G8rMpZ4yODgVrKuRP5vrYsN/D9bp4drrWD5DdfQRADr/oEbjw==
X-Received: by 2002:a17:902:7109:b0:151:8311:d3b5 with SMTP id a9-20020a170902710900b001518311d3b5mr10511752pll.13.1646259954286;
        Wed, 02 Mar 2022 14:25:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g1-20020a056a000b8100b004f111c21535sm181713pfj.80.2022.03.02.14.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 14:25:53 -0800 (PST)
Date:   Wed, 2 Mar 2022 22:25:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via
 asynchronous worker
Message-ID: <Yh/u7l+q2xZRx/KR@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
 <Yh+xA31FrfGoxXLB@google.com>
 <f4189f26-eff9-9fd0-40a1-69ac7759dedf@redhat.com>
 <Yh/GoUPxMRyFqFc5@google.com>
 <442859af-6454-b15e-b2ad-0fc7c4e22909@redhat.com>
 <Yh/X3m1rjYaY2s0z@google.com>
 <94b5c78d-3878-1a6c-ab53-37daf3d6eb9c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b5c78d-3878-1a6c-ab53-37daf3d6eb9c@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> On 3/2/22 21:47, Sean Christopherson wrote:
> > On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> > > For now let's do it the simple but ugly way.  Keeping
> > > next_invalidated_root() does not make things worse than the status quo, and
> > > further work will be easier to review if it's kept separate from this
> > > already-complex work.
> > 
> > Oof, that's not gonna work.  My approach here in v3 doesn't work either.  I finally
> > remembered why I had the dedicated tdp_mmu_defunct_root flag and thus the smp_mb_*()
> > dance.
> > 
> > kvm_tdp_mmu_zap_invalidated_roots() assumes that it was gifted a reference to
> > _all_ invalid roots by kvm_tdp_mmu_invalidate_all_roots().  This works in the
> > current code base only because kvm->slots_lock is held for the entire duration,
> > i.e. roots can't become invalid between the end of kvm_tdp_mmu_invalidate_all_roots()
> > and the end of kvm_tdp_mmu_zap_invalidated_roots().
> 
> Yeah, of course that doesn't work if kvm_tdp_mmu_zap_invalidated_roots()
> calls kvm_tdp_mmu_put_root() and the worker also does the same
> kvm_tdp_mmu_put_root().
> 
> But, it seems so me that we were so close to something that works and is
> elegant with the worker idea.  It does avoid the possibility of two "puts",
> because the work item is created on the valid->invalid transition.  What do
> you think of having a separate workqueue for each struct kvm, so that
> kvm_tdp_mmu_zap_invalidated_roots() can be replaced with a flush?

I definitely like the idea, but I'm getting another feeling of deja vu.  Ah, I
think the mess I created was zapping via async worker without a dedicated workqueue,
and so the flush became very annoying/painful.

I have the "dedicated list" idea coded up.  If testing looks good, I'll post it as
a v3.5 (without your xchg() magic or other kvm_tdp_mmu_put_root() changes).  That
way we have a less-awful backup (and/or an intermediate step) if the workqueue
idea is delayed or doesn't work.  Assuming it works, it's much prettier than having
a defunct flag.

> I can probably do it next Friday.

Early-ish warning, I'll be offline March 11th - March 23rd inclusive.  

FWIW, other than saving me from another painful rebase, there's no urgent need to
get this series into 5.18.
