Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F262D4BBF8B
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 19:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbiBRSfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 13:35:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbiBRSfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 13:35:05 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18E11A4D45
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:34:48 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id om7so9293191pjb.5
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6ui+XdqQ+V/acH1rGOlyzDTKLEuaung66NwvBtj6LuE=;
        b=X8Yel7V2IYImut8lQ0/DhVg5Kkg4WbtG3wN/JWTFXB8siwNd9e/xyeaRYAtT6WZRqQ
         VM+Vd8LSykDzBvCWff30AJNihA3q3n0MDibbC4Vw0Ag8nJjg0uLvqeKy4EcdZqT3p1Ly
         8+Dq+n7P0DgbbNzZex+aB8SU6M+ZJ5XeSDzbQrJPlUFMcqJV9UWauyV4i8vG2W5Zes4c
         DqwTa5sb2uf3y5IE1mWKfTpv0yJvvX+XnRQ04u44SXHSpw+B9U++KYBmqh8FUJPQsjr1
         cWHWxoSZEIld6gQAdIZ2X2zZENXG6WKvoO7Jn3MdLOtzyINhfbhFi5bqy0gjvzU6E08N
         mdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6ui+XdqQ+V/acH1rGOlyzDTKLEuaung66NwvBtj6LuE=;
        b=n+nMUJdLME+EGjMQOoJXVRGFt/Y+6UQiBNcefoToQGa4BsRfWEvG6tdUeIIz22IVX2
         nDSOnXljPGm1PWkv/TiBjgWiJJdY/6ieRy1eTsLuO6ty7MfeEQ3gEgZjw3f/EaaNl/ZI
         MUDyV9l27yE2dLMU+TyibNRhV7aP0P/LtdLSNSzOZBWXB61W0nvqTna+LTGpqz90OJNg
         W8jSOTlJJhp4HUCoFy5/5dhxfaJzDqpR4fqzlUviCZfiE5Cn6WJ0YdW5eJagNOkg7Zl6
         XFmbyRsE4NtFEvqQ0Ee5nOWPg5z4GWyfvFIk3oO4Ft1Mr74YRHa+KZCSO2YiGW01z3WM
         ykvQ==
X-Gm-Message-State: AOAM532fKPLDo1BH0H4zGjFNYKqEIIvimEahI32hr56TrKzfjfoLR/GQ
        fM8Pb8y8zD/2StNo1Pd5VwNvjLZaIEY7Tw==
X-Google-Smtp-Source: ABdhPJxVv/mRb2EhPSozftkcIU8eYn58a6qBEj8s0jA/yOkyFR7Djbb4fHuOjFvBLzo8ayCyt0EVlQ==
X-Received: by 2002:a17:902:9348:b0:14d:8ee9:329f with SMTP id g8-20020a170902934800b0014d8ee9329fmr8484514plp.80.1645209288178;
        Fri, 18 Feb 2022 10:34:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h5sm3519418pfc.118.2022.02.18.10.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:34:47 -0800 (PST)
Date:   Fri, 18 Feb 2022 18:34:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     maz@kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        kevin.tian@intel.com, tglx@linutronix.de,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/6] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <Yg/mxKrB5ZoRBIG+@google.com>
References: <20220216031528.92558-1-chao.gao@intel.com>
 <20220216031528.92558-6-chao.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216031528.92558-6-chao.gao@intel.com>
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

On Wed, Feb 16, 2022, Chao Gao wrote:
> The CPU STARTING section doesn't allow callbacks to fail. Move KVM's
> hotplug callback to ONLINE section so that it can abort onlining a CPU in
> certain cases to avoid potentially breaking VMs running on existing CPUs.
> For example, when kvm fails to enable hardware virtualization on the
> hotplugged CPU.
> 
> Place KVM's hotplug state before CPUHP_AP_SCHED_WAIT_EMPTY as it ensures
> when offlining a CPU, all user tasks and non-pinned kernel tasks have left
> the CPU, i.e. there cannot be a vCPU task around. So, it is safe for KVM's
> CPU offline callback to disable hardware virtualization at that point.
> Likewise, KVM's online callback can enable hardware virtualization before
> any vCPU task gets a chance to run on hotplugged CPUs.
> 
> KVM's CPU hotplug callbacks are renamed as well.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---

For the KVM bits,

  Reviewed-by: Sean Christopherson <seanjc@google.com>

Someone with more knowledge of the CPU hotplug sequences should really review this
too.
