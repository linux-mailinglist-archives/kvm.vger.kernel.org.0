Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEF26FB93F
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 23:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbjEHVSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 17:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjEHVSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 17:18:33 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A927CC;
        Mon,  8 May 2023 14:18:32 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so4593047a12.1;
        Mon, 08 May 2023 14:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683580712; x=1686172712;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9LwMl3SaVI5b8sezFDQVcUBEvYrPsuHk5i8fgGhI70=;
        b=VnZpj7UtLLQN1MVZaO2CuRaY3odcXC+WBgYW9KWN/w9/VXk6wLeA7D1NEdYk6jV+HX
         DWf8qshGPFNZj941PGYl3HMs7BsglKDubIHyB2cu6JX9aJHWSmWkd04ZZQCoeJ1+e7oF
         ar01CAoLFDbyQSUwF2CM7kSJAOquacbgm0yu/q/b+BBOBFmWy3UX4pAvScPcp4CgcosN
         iZ+a7aQaAOewg2e8HZYUy5EFOwapCajY+WAuuu6x7lgeBas+blLC3BoKJ+cO4ao+hj7m
         rZw3/QyeMFZnXwmVso3KjgETAhuYfsE9n44XEhP7V21lESmh8csZDADslV51SUPOJRVM
         zbQg==
X-Gm-Message-State: AC+VfDwwnbqC5lX+qH4e9narT1TMVQPXk9bKH3hfJC9ISFE0TafuuGpa
        0ObwRReKIcCPRfvgN/HeX/o=
X-Google-Smtp-Source: ACHHUZ6kteuJnNZnZsRe+bisWrFQUndJSqajeCoEM2/rFLcMVskwkNxu1jPZifG3ayQwvJCBSdGnnA==
X-Received: by 2002:a05:6a20:1591:b0:f0:ec64:f3de with SMTP id h17-20020a056a20159100b000f0ec64f3demr15058351pzj.25.1683580711711;
        Mon, 08 May 2023 14:18:31 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id c35-20020a631c23000000b00513ec871c01sm6699252pgc.16.2023.05.08.14.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 14:18:31 -0700 (PDT)
Date:   Mon, 8 May 2023 21:18:29 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        =?utf-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?utf-8?Q?=C8=98tefan_=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 6/9] KVM: x86: Add Heki hypervisor support
Message-ID: <ZFlnJRsJh2fX3IJb@liuwe-devbox-debian-v2>
References: <20230505152046.6575-1-mic@digikod.net>
 <20230505152046.6575-7-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230505152046.6575-7-mic@digikod.net>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023 at 05:20:43PM +0200, Mickaël Salaün wrote:
> From: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> 
> Each supported hypervisor in x86 implements a struct x86_hyper_init to
> define the init functions for the hypervisor.  Define a new init_heki()
> entry point in struct x86_hyper_init.  Hypervisors that support Heki
> must define this init_heki() function.  Call init_heki() of the chosen
> hypervisor in init_hypervisor_platform().
> 
> Create a heki_hypervisor structure that each hypervisor can fill
> with its data and functions. This will allow the Heki feature to work
> in a hypervisor agnostic way.
> 
> Declare and initialize a "heki_hypervisor" structure for KVM so KVM can
> support Heki.  Define the init_heki() function for KVM.  In init_heki(),
> set the hypervisor field in the generic "heki" structure to the KVM
> "heki_hypervisor".  After this point, generic Heki code can access the
> KVM Heki data and functions.
> 
[...]
> +static void kvm_init_heki(void)
> +{
> +	long err;
> +
> +	if (!kvm_para_available())
> +		/* Cannot make KVM hypercalls. */
> +		return;
> +
> +	err = kvm_hypercall3(KVM_HC_LOCK_MEM_PAGE_RANGES, -1, -1, -1);

Why not do a proper version check or capability check here? If the ABI
or supported features ever change then we have something to rely on?

Thanks,
Wei.
