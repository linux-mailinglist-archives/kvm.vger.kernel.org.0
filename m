Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EA84D5853
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 03:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345752AbiCKCqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 21:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345744AbiCKCqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 21:46:37 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792681A41E9
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 18:45:35 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so3655671pjb.3
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 18:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=47i1jj48gdh3ugZzKcCuj8iKYQMqov+4VOJuq+ofx1c=;
        b=EwsUUWwZsnckxs2a4ZBw8a9ZffO4o4ww26MBKNDANGiNO/8noFSkJHVfuhyqhy8B9p
         nkdYIVNy0ZeeYNaq6/8qCbC73vC+7gT4s54Si/VYAwu2ccJOTzFZLv/1+RDvHD7Jj+JO
         Ghg5aguK+r4EFNoq+afjB8BGxdwZYevnaXojB3+Ei4UbsMnM0xjAkSbGH3KaaVENaUxK
         +atuZ5iPE6xfqgYHjOZxBqODlc1/a52i6vibGuuzNSJh0ae5b3NCyoFc/urowJ/Vk0Sb
         xTaCBBJL9wd6HpZ+2eW2mWyGEPZjY4AjV7U7yTQJUcbjlZHlJghWHx1ahg9GEv+E+zNk
         Zb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=47i1jj48gdh3ugZzKcCuj8iKYQMqov+4VOJuq+ofx1c=;
        b=7BUJXjInpDr0ZWHxXatD4xOfwLPmMBXmArnP2lp0f9Rhd1S8jyHfLt2EgqX/38FMZo
         DQ/lnBEceCyoZGX6pIes579xMkuj8ZpR1jUwqaZo9HQrwy5Uv/Iuno1e9AOhCD97OMgI
         hCzTiFGi4//ZZpD88QIf1As4mSuX3hbbSDZYhHchUaftamlF4Vxv1QUfcBvft5tBpV4A
         gDLXJY7jiN/OyPLV1+l+z73EkX+rad2I/trgotOAYtj3Ok5TrnbHoLLNxzZp5Z4tKY/L
         c9uVaH9uTdGb35mWdFJkkE2wn+y5ouijPW2PRwqUxa4OitRo6vpxXM8VjRUWzlw6xrEs
         vjXQ==
X-Gm-Message-State: AOAM533HTYr/gipwVVM5719UMwSWktyd+YHeCucLOZRJyR/BgfL+t6Zm
        e2D1OOIrTnWqlpMdP7chw3ZDZA==
X-Google-Smtp-Source: ABdhPJxflJ3gDTpRwiLKqo8WKXUUCVF0L/GEoBXyngNxZCllT97T7WemfWcoM3I53cQCENyD2VayNQ==
X-Received: by 2002:a17:90a:cce:b0:1bf:6387:30d9 with SMTP id 14-20020a17090a0cce00b001bf638730d9mr19593474pjt.196.1646966734760;
        Thu, 10 Mar 2022 18:45:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g1-20020aa796a1000000b004f788397831sm693790pfk.217.2022.03.10.18.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 18:45:34 -0800 (PST)
Date:   Fri, 11 Mar 2022 02:45:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] KVM: X86: Extend KVM_SET_VCPU_EVENTS to inject a
 SHUTDOWN event
Message-ID: <Yiq3yqdUQ/aLz3yc@google.com>
References: <20220310084001.10235-1-chenyi.qiang@intel.com>
 <20220310084001.10235-2-chenyi.qiang@intel.com>
 <Yio4qknizH25MBkP@google.com>
 <5f2012f7-80ba-c034-a098-cede4184a125@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f2012f7-80ba-c034-a098-cede4184a125@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022, Chenyi Qiang wrote:
> 
> On 3/11/2022 1:43 AM, Sean Christopherson wrote:
> > On Thu, Mar 10, 2022, Chenyi Qiang wrote:
> > > @@ -4976,6 +4977,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> > >   		}
> > >   	}
> > > +	if (events->flags & KVM_VCPUEVENT_SHUTDOWN)
> > > +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > 
> > Huh.  I think we need to make this bidirection and add it to get_vcpu_events()
> > as well, and treat it as a bug fix.  In direct triple fault cases, i.e. hardware
> > detected and morphed to VM-Exit, KVM will never lose the triple fault.  But for
> > triple faults sythesized by KVM, e.g. the RSM path or nested_vmx_abort(), if KVM
> > exits to userspace before the request is serviced, userspace could migrate the
> > VM and lose the triple fault.
> 
> Good catch. Then the name of this definition is not quit fit now. How about
> changing to KVM_VCPUEVENT_SYTHESIZED_TRIPLE_FAULT?

I don't think the SYNTHESIZED part is necessary.  KVM doesn't make that distinction
for other events/exceptions, and whose to say that KVM won't end up with a case where
a "real" triple fault needs to be migrated.

I do have a slight preference for KVM_VCPUEVENT_TRIPLE_FAULT or KVM_VCPUEVENT_SHUTDOWN,
but it's a very slight preference.
