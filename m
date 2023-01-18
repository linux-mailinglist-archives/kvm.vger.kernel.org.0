Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348FF670FD7
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 02:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjARBUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 20:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjARBUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 20:20:02 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6A34C34
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 17:16:53 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p24so35325261plw.11
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 17:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nR851gTQUNhuZ9nIqOBqdizsZwq4fVLd+DeaO/RL3js=;
        b=Hd6WMpGYSNQdq6x5bZEpXv1KX4X9pv/ZsFdwt6iPmRB17S3WL8F4pe+UYA/RvwFBR3
         2andNh8JioNmt1w7ODtXwzK2SSABlFcpVJjGhA3lXo57Qdz4CO/NjcHzNEBUi/OnTKxW
         ox1NhKj4dnSoXAC58rF53eQK0b+9PC/0eSIQyJEZCsjeZGR2T/cvR7n12txhLtwqtQwU
         ywpJ44DNPB9j7b4VkcHo7QNEXTEVyn342SF26e8/RVcMW+tpnEjG/Dg4Z3EMbYlLQ84R
         g73nmIgc0JdPGhARJM+p1pjjuvK0ZNYZNQcI3JKkcHE5UAbz/ASX5xecyba7HkLKLbwt
         4H0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nR851gTQUNhuZ9nIqOBqdizsZwq4fVLd+DeaO/RL3js=;
        b=zSku1aw8bAplSVD3bNY8SHMBU+c6QGoAPZwt17D2BZAOBudL0DA/Ea1EqhmrFzANAV
         2ncN2D1voA4T/M/cz2UhEEJQ/OEFUP7/HAI6fxVMGmCSssqa03xC5bXKO/hB7oWtHyJO
         pLYWdTYAkzHWd80IIsZNfeKQVBxqbyYpslI6apL+V3Miod7Fpb27F0TogAPUGEVN7UL8
         oLRMUn8h3a66XNbnxmjdQNkrW8+2L00HlSl2GHOQfdq07gR5hS6Y6QjzWuyru3DzIpMh
         nrBljnETO7VGC6GBkLrgUOeS70RzouqDhtrv0V0aTPxkHA679T5r2xQ2ZTHNLL+ayH7q
         aZwg==
X-Gm-Message-State: AFqh2kqth14z7ymrswX+Fdadl6n3cK1qowoVs1rV4jYxtpS7E9+gMTbZ
        HIHND1rxfqotJKJqx1dHUoR6lA==
X-Google-Smtp-Source: AMrXdXsY6+D7UtkQ8QiX1vkkhfrbiAxGDNZS2xOOMXN6r3s6A82c2NGSaWy3Rx6VWNBn2JQ5Ph2PHA==
X-Received: by 2002:a05:6a21:33a1:b0:ac:af5c:2970 with SMTP id yy33-20020a056a2133a100b000acaf5c2970mr2962127pzb.3.1674004612406;
        Tue, 17 Jan 2023 17:16:52 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t13-20020a170902b20d00b001926a76e8absm21827824plr.114.2023.01.17.17.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:16:51 -0800 (PST)
Date:   Wed, 18 Jan 2023 01:16:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "dmatlack@google.com" <dmatlack@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 025/113] KVM: TDX: Use private memory for TDX
Message-ID: <Y8dIgEhj1Zb1688t@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <4c3f5462852af9fd0957bb7db0b04a6f2d5639ee.1673539699.git.isaku.yamahata@intel.com>
 <b8f88a7b9b2ab00379e6b1afd6a7fdb409d35492.camel@intel.com>
 <Y8bPljsAF+lSnWtC@google.com>
 <9fa4473f76f20b94a8ba516defb3b33ac3e86e96.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fa4473f76f20b94a8ba516defb3b33ac3e86e96.camel@intel.com>
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

On Tue, Jan 17, 2023, Huang, Kai wrote:
> On Tue, 2023-01-17 at 16:40 +0000, Sean Christopherson wrote:
> > On Mon, Jan 16, 2023, Huang, Kai wrote:
> > > AMD's series has a different solution:
> > > 
> > > https://lore.kernel.org/lkml/20221214194056.161492-3-michael.roth@amd.com/
> > > 
> > > I think somehow this needs to get aligned.
> > 
> > Ya.  My thought is
> > 
> >  bool kvm_arch_has_private_mem(struct kvm *kvm)
> >  {
> > 	return kvm->arch.vm_type != KVM_X86_DEFAULT_VM;
> >  }
> > 
> > where the VM types end up being:
> > 
> >  #define KVM_X86_DEFAULT_VM	0
> >  #define KVM_X86_PROTECTED_VM	1
> >  #define KVM_X86_TDX_VM		2
> >  #define KVM_X86_SNP_VM		3
> 
> What's the  difference between  PROTECTED_VM vs TDX_VM/SNP_VM, may I ask?

Not sure :-)  

At this point, PROTECTED_VM is a handwavy "guest that can access restricted memory".
I think/hope it can be used in combination with existing SEV/SEV-ES APIs to allow
backing such guests with restrictedmem.

As for TDX_VM and SNP_VM, I'm speculating that KVM will need to differentiate between
SNP, TDX, and everything else.  E.g. if KVM needs to uniquely identify TDX VMs at
creation time, then adding dedicated VM types seems like the obvious choice.  Ditto
for SNP VMs.

That's partly why I want to smush everything together, to see if we actually need
multiple VM types.
