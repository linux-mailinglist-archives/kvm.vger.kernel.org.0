Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E86B4B13A6
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244877AbiBJQz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:55:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244238AbiBJQz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:55:28 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EA0F9
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:55:29 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id c3so2337566pls.5
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aHkpjoNN8ySVWIDIeZjjrNMPbf0s7AEZhe1LvK/WaNM=;
        b=V9+ZpoYyW6lIuozdvdNCH3gztoB82wbqQMQcwTDfyaWhotIthyRvbWN5lBfeXrGPEr
         /FtaIGAGu9ilHyKrWjDoSxhpxc97Vx5CRh24fY9bX+MEHnf7VuYJsPIrIusIoxv7zuux
         /DMxZsAXco08o6ivkspD85ezUTJWsN0wvjKgUvSaaR6XxcDEPR/bo9vWHhsxDBUTW9x+
         /XRnye/IXFvwHPb0oDETqy6lZ3xpdm2xrqmgnxlsbfOSZh4I6Id4RhHdCy56EgA2OWIf
         X5nBNSjeocUYtljWKm3wJao7xLEzmSM/fDEQXos/JB139zqj42J4eehzFxE/mAibwBcU
         pi+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aHkpjoNN8ySVWIDIeZjjrNMPbf0s7AEZhe1LvK/WaNM=;
        b=Q95SLwoyWfMSGJmFF7K8sY7yaqnkizw7ss0H47w/vdfsqVA74Hx9miEHUqrX0c8kRl
         N5dLXEoZuSdg604US1bd9lQjYVnOk5zXjsolydmb68CpbP0C9aH2z5ZstT8OwRyspqSK
         SnZBb+mqJSKKN4B9g4oZqQO4I7pFtPNO7+Z2ri3qyKwLgX7fIeBTkyAK1q3GCRzuELCX
         uesW1eb0hWYU1QNzbTv6zpsp/NjklsLY7pEo8SfAqTfAYrzFaxX5RZRKKa77tYJJN54v
         g8erpouZ8r6EzbB2MMvr+2jetMhT8JbQCN6FUnBQl6duI0pGkapHurV3fEywb8+Ajwiu
         JAZw==
X-Gm-Message-State: AOAM533QBcFWgE1/FaASZZfD4CYVp/I43kneEk4Ofui1LmWvg1WKT567
        lG6ozNLddWgc0noBaNh4kIL2SNAl9h8JNQ==
X-Google-Smtp-Source: ABdhPJyWd39q89sv/QN1DnaGaPIp+eF0nNg7mJ0gIvXor06TwVELd9CNyqhGCHZI6v496MQCxT28dQ==
X-Received: by 2002:a17:902:e885:: with SMTP id w5mr8771523plg.156.1644512128738;
        Thu, 10 Feb 2022 08:55:28 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y30sm3729019pfq.142.2022.02.10.08.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:55:28 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:55:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 00/23] KVM: MMU: MMU role refactoring
Message-ID: <YgVDfG1DvUdXnd2n@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <YgGmgMMR0dBmjW86@google.com>
 <YgGq31edopd6RMts@google.com>
 <CALzav=d05sMd=ARkV+GMf9SkxKcg9c9n5ttb274M2fZrP27PDA@mail.gmail.com>
 <YgRmXDn7b8GQ+VzX@google.com>
 <40930834-8f54-4701-d3ec-f8287bc1333f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40930834-8f54-4701-d3ec-f8287bc1333f@redhat.com>
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

On Thu, Feb 10, 2022, Paolo Bonzini wrote:
> On 2/10/22 02:11, Sean Christopherson wrote:
> > In a vacuum, I 100% agree that guest_role is better than cpu_role or vcpu_role,
> > but the term "guest" has already been claimed for "L2" in far too many places.
> > 
> > While we're behind the bikeshed... the resulting:
> > 
> > 	union kvm_mmu_role cpu_role;
> > 	union kvm_mmu_page_role mmu_role;
> > 
> > is a mess.  Again, I really like "mmu_role" in a vacuum, but juxtaposed with
> > 	
> > 	union kvm_mmu_role cpu_role;
> > 
> > it's super confusing, e.g. I expected
> > 
> > 	union kvm_mmu_role mmu_role;
> 
> What about
> 
> 	union kvm_mmu_page_role root_role;
> 	union kvm_mmu_paging_mode cpu_mode;
> 
> ?  I already have to remove ".base" from all accesses to mmu_role, so it's
> not much extra churn.

I'd prefer to not use "paging mode", the SDM uses that terminology to refer to
the four paging modes.  My expectation given the name is that the union would
track only CR0.PG, EFER.LME, CR4.PAE, and CR4.PSE[*].

I'm out of ideas at the moment, I'll keep chewing on this while reviewing...

[*] Someone at Intel rewrote the SDM and eliminated Mode B, a.k.a. PSE 36-bit
physical paging, it's now just part of "32-bit paging".  But 5-level paging is
considered it's own paging mode?!?!  Lame.  I guess they really want to have
exactly four paging modes...
