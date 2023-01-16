Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D273766C351
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 16:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjAPPJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 10:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbjAPPIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 10:08:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8036C2FCFD
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 06:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673880930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g48LKw/EQzyimcflA0uDUwRnS8dI8OL8jQyceWm5H5M=;
        b=PughXJ7o8kHmymIdqGuvEVsMHz7v1jxsYtvLoBuvYizxxas0HaC5Exr2ubBjlyBlk6OM0f
        sJX8PSPTYIMofJ72fOBWZwRKA8y874Sii1J47x0B4Q4alYW1hjFbIeJTjMQmd7LUcmKymW
        Sd3wMNEjAWGyeMR8mmV3SAMKsmFhm4g=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-428-slGqoWorO7ieOnZ9h4NLyw-1; Mon, 16 Jan 2023 09:55:29 -0500
X-MC-Unique: slGqoWorO7ieOnZ9h4NLyw-1
Received: by mail-ej1-f72.google.com with SMTP id nd38-20020a17090762a600b00871ff52c6b5so394951ejc.0
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 06:55:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g48LKw/EQzyimcflA0uDUwRnS8dI8OL8jQyceWm5H5M=;
        b=V14R8bW3p8VS4ModYGUarqNmr3yUAe0w3MRHE7QOSs9QdvWZOyixpVMjKEhB62CaA6
         6V5/gMZ0U5+ZWgSxhRwr7Mrf6L1yTroUA8fgkd2xsyCfXi3HuiXDsMGtqnaTfKXeUPHK
         F8Pbw4VnQAoxN0XtZJcs6gAmAXtB6tGFumLcal5DhuD6EQ2CVwWsFr4QNTs1FMW9gJcF
         tsPVU2lvBBeDgHeOWAz6fUqWbT9CKiQukI3UZ+7ac32NQjvxldEsDRc8trllyg++0AAr
         kAEhrXtMRkdicXzddLpl+5NW71VokU9VAvOtyAj1xvEXttHu+mpDQkILJ1tT2HGY7hj4
         RXmg==
X-Gm-Message-State: AFqh2kq0VclWmWFU9518f2SwTiM8oa4enODEvsqv7GbXWAHWLK8me9dk
        fP00sqWmRivJ+9Pw3BJ2+QIzMxDhHLcHJsiImM128gHTbOQ9RwnggJTAwjZ0SHkqJ+pu1bCFVYp
        2O3XtTFgQWPm7
X-Received: by 2002:a17:906:8478:b0:84d:373b:39da with SMTP id hx24-20020a170906847800b0084d373b39damr29113663ejc.40.1673880928387;
        Mon, 16 Jan 2023 06:55:28 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsse3LgRug+Pp9ZoWtZxmVwLzZ7+mUuv4JYFK2PzosFJrEZ0QAORQ3jcyrTsWEYEH4Absw9GA==
X-Received: by 2002:a17:906:8478:b0:84d:373b:39da with SMTP id hx24-20020a170906847800b0084d373b39damr29113641ejc.40.1673880928211;
        Mon, 16 Jan 2023 06:55:28 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a3-20020aa7cf03000000b0049019b48373sm11543707edy.85.2023.01.16.06.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 06:55:27 -0800 (PST)
Date:   Mon, 16 Jan 2023 15:55:26 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     linux-kernel@vger.kernel.org, amakhalov@vmware.com,
        ganb@vmware.com, ankitja@vmware.com, bordoloih@vmware.com,
        keerthanak@vmware.com, blamoreaux@vmware.com, namit@vmware.com,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Lewis Caroll <lewis.carroll@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>, x86@kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2] x86/hotplug: Do not put offline vCPUs in mwait idle
 state
Message-ID: <20230116155526.05d37ff9@imammedo.users.ipa.redhat.com>
In-Reply-To: <20230116060134.80259-1-srivatsa@csail.mit.edu>
References: <20230116060134.80259-1-srivatsa@csail.mit.edu>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 15 Jan 2023 22:01:34 -0800
"Srivatsa S. Bhat" <srivatsa@csail.mit.edu> wrote:

> From: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>
> 
> Under hypervisors that support mwait passthrough, a vCPU in mwait
> CPU-idle state remains in guest context (instead of yielding to the
> hypervisor via VMEXIT), which helps speed up wakeups from idle.
> 
> However, this runs into problems with CPU hotplug, because the Linux
> CPU offline path prefers to put the vCPU-to-be-offlined in mwait
> state, whenever mwait is available. As a result, since a vCPU in mwait
> remains in guest context and does not yield to the hypervisor, an
> offline vCPU *appears* to be 100% busy as viewed from the host, which
> prevents the hypervisor from running other vCPUs or workloads on the
> corresponding pCPU. [ Note that such a vCPU is not actually busy
> spinning though; it remains in mwait idle state in the guest ].
>
> Fix this by preventing the use of mwait idle state in the vCPU offline
> play_dead() path for any hypervisor, even if mwait support is
> available.

if mwait is enabled, it's very likely guest to have cpuidle
enabled and using the same mwait as well. So exiting early from
 mwait_play_dead(), might just punt workflow down:
  native_play_dead()
        ...
        mwait_play_dead();
        if (cpuidle_play_dead())   <- possible mwait here                                              
                hlt_play_dead(); 

and it will end up in mwait again and only if that fails
it will go HLT route and maybe transition to VMM.

Instead of workaround on guest side,
shouldn't hypervisor force VMEXIT on being uplugged vCPU when it's
actually hot-unplugging vCPU? (ex: QEMU kicks vCPU out from guest
context when it is removing vCPU, among other things)

> Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Wyes Karny <wyes.karny@amd.com>
> Cc: Lewis Caroll <lewis.carroll@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Alexey Makhalov <amakhalov@vmware.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: x86@kernel.org
> Cc: VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: kvm@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org
> ---
> 
> v1: https://lore.kernel.org/lkml/165843627080.142207.12667479241667142176.stgit@csail.mit.edu/
> 
>  arch/x86/kernel/smpboot.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 55cad72715d9..125a5d4bfded 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1763,6 +1763,15 @@ static inline void mwait_play_dead(void)
>  		return;
>  	if (!this_cpu_has(X86_FEATURE_CLFLUSH))
>  		return;
> +
> +	/*
> +	 * Do not use mwait in CPU offline play_dead if running under
> +	 * any hypervisor, to make sure that the offline vCPU actually
> +	 * yields to the hypervisor (which may not happen otherwise if
> +	 * the hypervisor supports mwait passthrough).
> +	 */
> +	if (this_cpu_has(X86_FEATURE_HYPERVISOR))
> +		return;
>  	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
>  		return;
>  

