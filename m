Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D6F4AFEB8
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 21:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiBIUtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 15:49:24 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiBIUtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 15:49:23 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8955AC05CBA4
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 12:49:26 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 10so3364737plj.1
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 12:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=usai5WVQErwk4Ew2fX/fOjUw6I8vvZIt0nVcprr1jB8=;
        b=VqQ4AQV9kyt+0LUwBHfYIcCdy6HaR52lzHPXQid7Q9Se19pBiE9Mi/rh3L+BTrlcsA
         3zhWV/p7cu/zpDWzo7seoNfyvraJeUxi6CYB6mkMUCbqqhUhq6m/rjbyx/IUrHKoVXof
         lSkYyXL/SVmmvlJQ902YhuNCzptvPCHTOSwCPPsN8v87m068+MhEZHA/NU8a1bXJaf9P
         uKu6stWAubyB61SmQAKl0PriItNTzKJNWLayosXH27IGEVSnYux3NhyrI5glY56g2pAl
         uGtJ7pB8scL4hzREiHv7FcQjA7rxLGqS4qtNTCbZKzEmQmICwvLEIphJRmERaAHp85uu
         QD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=usai5WVQErwk4Ew2fX/fOjUw6I8vvZIt0nVcprr1jB8=;
        b=4j8moypQgpDbt80DoXRncaW24RRpI5pCOM7sNCnmhATQKhpwBCEgid3GKZtfh8Luvw
         pqiVfyLsqZ7zdmQ16hKg0gbQRwCrT926OFK1kH5fsJqBjLDuB1r6s+O4IAS1B6dXRmbu
         2rJtHeDqMuF8glhkaYkEJ+tSAP50LuZ1AfntqtPiPNKxXfIt5pYaasXsEdJRW1kdpeKL
         7jT8RIiiKXjMDgC8QzSI2URg0qcJJQ62cPZNg6k5gVOYaNT8wubANthYV5RXLYVv6XC4
         PKk6Q2W5KR7VqHCvRNN1aRQiJ+NVe2moEPBE7lza+xUoXuAbBlpIpcB7qt5EtB/0acBh
         J10w==
X-Gm-Message-State: AOAM5330YhAo9tVeBudN24zs+/5eie0jj3UhxnGTgJDGWyAgajuo4FQM
        R/pnTDW+lgb+bvEV/e33KMKxAg==
X-Google-Smtp-Source: ABdhPJw/3lEaJcN7mZhLmzhDeUcjhx87dXVoMvRWh5thi6wmzVXTU+ApsU/9c7brBYgoM6y2N1AWpQ==
X-Received: by 2002:a17:90a:ab90:: with SMTP id n16mr5432152pjq.229.1644439765909;
        Wed, 09 Feb 2022 12:49:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j15sm22379244pfj.102.2022.02.09.12.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 12:49:25 -0800 (PST)
Date:   Wed, 9 Feb 2022 20:49:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] KVM: Do compatibility checks on hotplugged CPUs
Message-ID: <YgQo0SB59SCRUPQ3@google.com>
References: <20220209074109.453116-1-chao.gao@intel.com>
 <20220209074109.453116-6-chao.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209074109.453116-6-chao.gao@intel.com>
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

On Wed, Feb 09, 2022, Chao Gao wrote:
> At init time, KVM does compatibility checks to ensure that all online
> CPUs support hardware virtualization and a common set of features. But
> KVM uses hotplugged CPUs without such compatibility checks. On Intel
> CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX or
> vmentry failure if the hotplugged CPU doesn't meet minimal feature
> requirements.
> 
> Do compatibility checks when onlining a CPU and abort the online process
> if the hotplugged CPU is incompatible with online CPUs.
> 
> CPU hotplug is disabled during hardware_enable_all() to prevent the corner
> case as shown below. A hotplugged CPU marks itself online in
> cpu_online_mask (1) and enables interrupt (2) before invoking callbacks
> registered in ONLINE section (3). So, if hardware_enable_all() is invoked
> on another CPU right after (2), then on_each_cpu() in hardware_enable_all()
> invokes hardware_enable_nolock() on the hotplugged CPU before
> kvm_online_cpu() is called. This makes the CPU escape from compatibility
> checks, which is risky.
> 
> 	start_secondary { ...
> 		set_cpu_online(smp_processor_id(), true); <- 1
> 		...
> 		local_irq_enable();  <- 2
> 		...
> 		cpu_startup_entry(CPUHP_AP_ONLINE_IDLE); <- 3
> 	}
> 
> Keep compatibility checks at KVM init time. It can help to find
> incompatibility issues earlier and refuse to load arch KVM module
> (e.g., kvm-intel).
> 
> Loosen the WARN_ON in kvm_arch_check_processor_compat so that it
> can be invoked from KVM's CPU hotplug callback (i.e., kvm_online_cpu).
> 
> Opportunistically, add a pr_err() for setup_vmcs_config() path in
> vmx_check_processor_compatibility() so that each possible error path has
> its own error message. Convert printk(KERN_ERR ... to pr_err to please
> checkpatch.pl
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
