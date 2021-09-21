Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A444134D4
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 15:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhIUNvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 09:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbhIUNvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 09:51:42 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F32CC061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 06:50:14 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id j6so19540652pfa.4
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 06:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0WNoquWEt8mutOmbOCoV1wQPSoJS/FZ/Q3rfxd6YML0=;
        b=geFV+ddC6/YCdASdIqiBnbtTKPD5Dbp7vqoMRdFTkYHU2Ju/AjdksSyI1qaXqhAbxU
         rvb4etkVzx4IXrCt8wqeCq5aRAS10rB173hExcTXpbLyZb3Il/19GoyfCS+Q8ZYkFROC
         Tds2rVh4BruB43ZML6T22je3lolT23RPc3BMzwF19Xi5zQas6/fFJNr43FG6Uo3vwyLY
         pMYMfCenFt3wgAjEeIDAqmgsYZkN/absLJSQyyrrP8wEb0PYyFhV85QBHm4wCEN+HJip
         Xsha0KON9PK/KQsztllZb/kF1lFHacMnf080cchyahUnhQ3zRR63Tak8O94rzeEZ/+qL
         DNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0WNoquWEt8mutOmbOCoV1wQPSoJS/FZ/Q3rfxd6YML0=;
        b=5QGN/AdrnMRJ2LZoLsxcx1dkeOavbBvxUmIcrwG9UiQZLJoKBNaqVzUmYLiZE70Igs
         pNhmz3165RlqCVF7/O8WpUKECubS1MR2lppEDhAPZ9TK/BHGMEgJFp4YjB5bmqnESqxE
         8wDjOxF91K8JOMFTSlZeICU2rsGDsiWcyq6MbvjieV7Yy93PIe1YbNbDzbYP7jfrQ8HV
         L0fHPyT3u2lguw6+/Pyu3nafQPgEwyjj8QAEGO+x4Z9wVYR70MadjglMGi/KBJQqgX1q
         9YpcDhpE65HoQzlbfXhnT87ce7apmcizto1lXHKszw8ar3haZExS2e9ozwl8VmyStP5k
         V8mw==
X-Gm-Message-State: AOAM530wL1NaVSdR0aeobhUydwAqeeJ2C/yEMUp8pfdhxVc6cfYaMzjt
        /6YbN7c+kOcqrOj9rThXZwUn0A==
X-Google-Smtp-Source: ABdhPJzIgq15wyKym8QyKRQUwSC+Cg0Ihn7WJlMRkOTS186gruiQxVnOjuZJ8X1WBUVtTopgR0jLcg==
X-Received: by 2002:aa7:92ca:0:b0:43d:e183:7e66 with SMTP id k10-20020aa792ca000000b0043de1837e66mr30823826pfa.11.1632232213645;
        Tue, 21 Sep 2021 06:50:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y3sm2801269pjg.7.2021.09.21.06.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:50:13 -0700 (PDT)
Date:   Tue, 21 Sep 2021 13:50:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@alien8.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <YUnjEU+1icuihmbR@google.com>
References: <cover.1629726117.git.ashish.kalra@amd.com>
 <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
 <YUixqL+SRVaVNF07@google.com>
 <20210921095838.GA17357@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921095838.GA17357@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021, Ashish Kalra wrote:
> This is simply a Hack, i don't think this is a good approach to take forward.

But a clever hack ;-)

> > Unless there's some fundamental technical hurdle I'm overlooking, if pv_ops can
> > be configured early enough to handle this, then so can alternatives.  
> 
> Now, as i mentioned earlier, apply_alternatives() is only called boot
> CPU identification has been done which is a lot of support code which
> may be dependent on earlier setup_arch() code and then it does CPU
> mitigtion selections before patching alternatives, again which may have
> dependencies on previous code paths in setup_arch(), so i am not sure if
> we can call apply_alternatives() earlier. 

apply_alternatives() is a generic helper that can work on any struct alt_instr
array, e.g. KVM_HYPERCALL can put its alternative into a different section that's
patched as soon as the VMM is identified.

> Maybe for a guest kernel and virtualized boot enviroment, CPU
> identification may not be as complicated as for a physical host, but
> still it may have dependencies on earlier architecture specific boot
> code.
> 
> > Adding notify_page_enc_status_changed() may be necessary in the future, e.g. for TDX
> > or SNP, but IMO that is orthogonal to adding a generic, 100% redundant helper.
> 
> If we have to do this in the future and as Sean mentioned ealier that
> vmcall needs to be fixed for TDX (as it will cause a #VE), then why not
> add this abstraction right now ?

I'm not objecting to adding a PV op, I'm objecting to kvm_sev_hypercall3().  If
others disagree and feel it's the way forward, I certainly won't stand in the way,
but IMO it's unnecessary code duplication.
