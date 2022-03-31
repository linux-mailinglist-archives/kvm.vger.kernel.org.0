Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9CB4EE227
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 21:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbiCaT4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 15:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240886AbiCaT4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 15:56:08 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A12A60A84;
        Thu, 31 Mar 2022 12:54:21 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q19so618581pgm.6;
        Thu, 31 Mar 2022 12:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vwYbxEvOFzQZ3DfFjQoUndJHwl8sC80wy2uGif/41uE=;
        b=QKzz3hwvxOS8I5FsifjjQB7LMh51VWqYRaLXy9QTs8T+LML+JUK/+/HareIvwQusHM
         PTmuDTi2YUxPUwYCK5Q/uJrxD9QpDn2B39x5Bs+juLPoYsSDBhZ9zUphpvGzTbFDi4vR
         GYVfcs8VpcmBQcRBFQQdh83gJfYD2JxsJ7ZByfBjhdSYt7hY1TahBmVj+6MkZQvVolE5
         I3QBUlsVjdEAg/j1IXZ3XP+6A/JURnZJxwGJZwCaklkhfKVVF1XhwOZF1/buOTliUiql
         7CfBPe9wz9XCXClc21sug9R6hvtb0bcnmGJ5Jw2ZCvV/55jrd+iJTO7bnABy0jj35wdW
         8few==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vwYbxEvOFzQZ3DfFjQoUndJHwl8sC80wy2uGif/41uE=;
        b=TVqtIPcd2nk447/CxkhV8Qe+Gb6sKkxqn7SIB/nD9Y4gGsU3pAz1K+nMqa3EEmI+Yk
         vk96/Av7COxM3FSWPctj4ZyPsbEWBOsGIT3vjYTcsXtJ1qhfZ8D7V4Zq3oVuIlKKJ8Zt
         11xO/w5seV0hOV/Uwuk6zjJf4Xavv6vom/XUPT+s21w5ZahJ1GCU0r+vZfEvsYy1yP2q
         6mkXnykIvgyITlcbc7UgviDnbGwn91MhzMEAUcTgkXhmWIfivJZDDahrosGZw8sUQXVK
         HkgmswvoF4ua2co25jQSbnUGLdc/tojaSZlOfDLdsFlaKXS3Bdl82LO1EYG9d8Jk8ovI
         JNcA==
X-Gm-Message-State: AOAM5303AD386QLP9ID7Md6aRslZK9DdsOKpnfXhaVLux3/mU7cL9XDM
        9kuzFbTD4wcdvGGMBhG5vG4=
X-Google-Smtp-Source: ABdhPJw053091D9MqO5RSZUJy8UyPWhs/hLZBSYlI5FEYxBaDT8GAo2/s2AmaYMb9sOklX3icFDTdw==
X-Received: by 2002:a05:6a00:810:b0:4fa:e71f:7e40 with SMTP id m16-20020a056a00081000b004fae71f7e40mr7196865pfk.15.1648756460698;
        Thu, 31 Mar 2022 12:54:20 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id e19-20020a637453000000b003821bdb8103sm152830pgn.83.2022.03.31.12.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 12:54:20 -0700 (PDT)
Date:   Thu, 31 Mar 2022 12:54:19 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 021/104] KVM: x86: Introduce hooks to free VM
 callback prezap and vm_free
Message-ID: <20220331195419.GB2084469@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <af18a5c763a78af2b7de6e6e0841d9e61a571dc4.1646422845.git.isaku.yamahata@intel.com>
 <03d3c1ac92cee3b0e8e325da0f703d1dd9657b4b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <03d3c1ac92cee3b0e8e325da0f703d1dd9657b4b.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 04:02:24PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > From: Kai Huang <kai.huang@intel.com>
> > 
> > Before tearing down private page tables, TDX requires some resources of the
> > guest TD to be destroyed (i.e. keyID must have been reclaimed, etc).  Add
> > prezap callback before tearing down private page tables for it.
> > 
> > TDX needs to free some resources after other resources (i.e. vcpu related
> > resources).  Add vm_free callback at the end of kvm_arch_destroy_vm().
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h | 2 ++
> >  arch/x86/include/asm/kvm_host.h    | 2 ++
> >  arch/x86/kvm/x86.c                 | 8 ++++++++
> >  3 files changed, 12 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 8125d43d3566..ef48dcc98cfc 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -20,7 +20,9 @@ KVM_X86_OP(has_emulated_msr)
> >  KVM_X86_OP(vcpu_after_set_cpuid)
> >  KVM_X86_OP(is_vm_type_supported)
> >  KVM_X86_OP(vm_init)
> > +KVM_X86_OP_NULL(mmu_prezap)
> >  KVM_X86_OP_NULL(vm_destroy)
> > +KVM_X86_OP_NULL(vm_free)
> >  KVM_X86_OP(vcpu_create)
> >  KVM_X86_OP(vcpu_free)
> >  KVM_X86_OP(vcpu_reset)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 8de357a9ad30..5ff7a0fba311 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1326,7 +1326,9 @@ struct kvm_x86_ops {
> >  	bool (*is_vm_type_supported)(unsigned long vm_type);
> >  	unsigned int vm_size;
> >  	int (*vm_init)(struct kvm *kvm);
> > +	void (*mmu_prezap)(struct kvm *kvm);
> >  	void (*vm_destroy)(struct kvm *kvm);
> > +	void (*vm_free)(struct kvm *kvm);
> >  
> >  	/* Create, but do not attach this VCPU */
> >  	int (*vcpu_create)(struct kvm_vcpu *vcpu);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f6438750d190..a48f5c69fadb 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11779,6 +11779,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >  	kvm_page_track_cleanup(kvm);
> >  	kvm_xen_destroy_vm(kvm);
> >  	kvm_hv_destroy_vm(kvm);
> > +	static_call_cond(kvm_x86_vm_free)(kvm);
> >  }
> >  
> >  static void memslot_rmap_free(struct kvm_memory_slot *slot)
> > @@ -12036,6 +12037,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >  
> >  void kvm_arch_flush_shadow_all(struct kvm *kvm)
> >  {
> > +	/*
> > +	 * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
> > +	 * tearing down private page tables, TDX requires some TD resources to
> > +	 * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
> > +	 * kvm_x86_mmu_prezap() for this.
> > +	 */
> > +	static_call_cond(kvm_x86_mmu_prezap)(kvm);
> >  	kvm_mmu_zap_all(kvm);
> >  }
> >  
> 
> The two callbacks are introduced here but they are actually implemented in 2
> patches later (patch 24 KVM: TDX: create/destroy VM structure).  Why not just
> squash this patch to patch 24?  Or at least you can put this patch right before
> patch 24.

Ok. I'll squash this patch into it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
