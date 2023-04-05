Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE1E6D8647
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbjDESun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbjDESum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:50:42 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC005589;
        Wed,  5 Apr 2023 11:50:41 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u10so35283929plz.7;
        Wed, 05 Apr 2023 11:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680720641; x=1683312641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xlj9MvtrRwOeTcO7knJBKCWUfWxq060k2AQocc18m2Q=;
        b=coqhcAjgyMnUintDYevE+TsSCvqBzsg3PnoJfFifTOGuBpkhfJOnD6z89vVQxIcn/s
         YLWfK4AYOtpTxaDIHjAkWgVj85ZmHSLw2WetNg3/lJggNXCVA2uDlBdfL4/Fuqo+NLCN
         aRC+NSamrzro17/NoJd0mG0EutFZMAwvI0dUIgSaYuVMeNuBGjm5ry0vo9aB9UyqA1qc
         iKVJ/xx/RJg1DUOGzWDGxIg899T7+yPNKmMzzBoX1bu70jJWy0uAmrpn9xhZ1EoSJfXE
         xz8B+U3GtQSRAvQl07pgumKr7RC6eBfq+4kC7rSoUIKFyFZvssTN1SlMhgPTCHxoxgAy
         lq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680720641; x=1683312641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xlj9MvtrRwOeTcO7knJBKCWUfWxq060k2AQocc18m2Q=;
        b=xH45yE4UmTDrJ0QIaLX7XESQmYhcwyQewZV30ebfPqeLCjQzZDb1BvBquNB/NYZvEU
         jaXkHuSl6bvEzjlnAFdv9y29yJ74tADbNev/WziYLola8jsziFQuVaH6TJeWylYwx218
         8MlYKu+1GdRnKN1orffxWkVaMqZef/InAI1e9M4HI7RuNp0C/iphVM9fByUyzaSdi8M9
         oN8XRKMYiqsQGhrVoLoRlG/1VZxZCrPCfhBaEzAHHOFQcIX7bZ/VqYJEzJzfkDgWmPgZ
         WxJsL7hjZBGfB9R0o9RQA8OZrqZtXsAL9uTDjYIeL8qdLUmIZWqCLorZfR6X3zZk8siT
         rlwg==
X-Gm-Message-State: AAQBX9cyonmwhNmey9+tm5ntvT1/VckzhmcF333fUAJR0Xs5YTBMYKoA
        CXy3lOIsw4MI+LcqtitCw/jeWYpUABs=
X-Google-Smtp-Source: AKy350a6VgrZl+jknrqHKt5IvOkEKPAL9+GVa6hRtPEhYXk+dx7QKx7yr7LyndvOzYJzV8xUtu8ckA==
X-Received: by 2002:a17:902:e5c8:b0:199:1996:71ec with SMTP id u8-20020a170902e5c800b00199199671ecmr9325176plf.16.1680720640725;
        Wed, 05 Apr 2023 11:50:40 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902c18600b0019ca68ef7c3sm10447979pld.74.2023.04.05.11.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 11:50:39 -0700 (PDT)
Date:   Wed, 5 Apr 2023 11:50:38 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v13 020/113] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20230405185038.GH1112017@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <22eed5c3e61c8a05a8870f2b40f89f954a8112ef.1678643052.git.isaku.yamahata@intel.com>
 <20230404222335.000079ee.zhi.wang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230404222335.000079ee.zhi.wang.linux@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 10:23:35PM +0300,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Sun, 12 Mar 2023 10:55:44 -0700
> isaku.yamahata@intel.com wrote:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX requires additional parameters for TDX VM for confidential execution to
> > protect its confidentiality of its memory contents and its CPU state from
> > any other software, including VMM. When creating guest TD VM before
> > creating vcpu, the number of vcpu, TSC frequency (that is same among
> > vcpus. and it can't be changed.) CPUIDs which is emulated by the TDX
>    ^ This sentence seems broken. "

Here is the revised one.

TDX requires additional parameters for TDX VM for confidential execution to
protect the confidentiality of its memory contents and CPU state from any
other software, including VMM.  When creating a guest TD VM before creating
vcpu, the number of vcpu, TSC frequency (the values are the same among
vcpus, and it can't change.)  CPUIDs which the TDX module emulates.  Guest
TDs can trust those CPUIDs and sha384 values for measurement.

Add a new subcommand, KVM_TDX_INIT_VM, to pass parameters for the TDX
guest.  It assigns an encryption key to the TDX guest for memory
encryption.  TDX encrypts memory per guest basis.  The device model, say
qemu, passes per-VM parameters for the TDX guest.  The maximum number of
vcpus, TSC frequency (TDX guest has fixed VM-wide TSC frequency, not per
vcpu.  The TDX guest can not change it.), attributes (production or debug),
available extended features (which configure guest XCR0, IA32_XSS MSR),
CPUIDs, sha384 measurements, etc.

Call this subcommand before creating vcpu and KVM_SET_CPUID2, i.e.  CPUID
configurations aren't available yet.  So CPUIDs configuration values need
to be passed in struct kvm_tdx_init_vm.  The device model's responsibility
to make this CPUID config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.

> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index af4c5bd0af1c..68e8d544afe5 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -565,6 +565,7 @@ struct kvm_pmu_event_filter {
> >  /* Trust Domain eXtension sub-ioctl() commands. */
> >  enum kvm_tdx_cmd_id {
> >  	KVM_TDX_CAPABILITIES = 0,
> > +	KVM_TDX_INIT_VM,
> >  
> >  	KVM_TDX_CMD_NR_MAX,
> >  };
> > @@ -610,4 +611,27 @@ struct kvm_tdx_capabilities {
> >  	struct kvm_tdx_cpuid_config cpuid_configs[0];
> >  };
> >  
> > +struct kvm_tdx_init_vm {
> > +	__u64 attributes;
> > +	__u64 mrconfigid[6];	/* sha384 digest */
> > +	__u64 mrowner[6];	/* sha384 digest */
> > +	__u64 mrownerconfig[6];	/* sha348 digest */
> > +	/*
> > +	 * For future extensibility to make sizeof(struct kvm_tdx_init_vm) = 8KB.
> > +	 * This should be enough given sizeof(TD_PARAMS) = 1024.
> > +	 * 8KB was chosen given because
> > +	 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(=256) = 8KB.
> > +	 */
> > +	__u64 reserved[1004];
> > +
> > +	/*
> > +	 * KVM_TDX_INIT_VM is called before vcpu creation, thus before
> > +	 * KVM_SET_CPUID2.
> > +	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs. The user
> > +	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with this
> > +	 * values.
>                    ^
>                      It would be nice to have one more sentence to talk about the
> consequence if QEMU configures different CPUIDs in KVM_TDX_INIT_VM and the later
> SET_CPUID2.

Here is the updated one.
	/*
	 * Call KVM_TDX_INIT_VM before vcpu creation, thus before
	 * KVM_SET_CPUID2.
	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
	 * TDX module directly virtualizes those CPUIDs without VMM.  The user
	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
	 * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
	 * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
	 * module doesn't virtualize.
	 */

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
