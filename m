Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33049518F3D
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 22:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbiECUtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 16:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbiECUtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 16:49:09 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C90222B1D
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 13:45:36 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h1so15663841pfv.12
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 13:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TSzGjUy5r8/JGNRZAvsaU0ZiOLuGPTmx6supYiah4ck=;
        b=fRAIMyt29f13AIoHcgDCG2DCy70tIP9dWPjGIdaC/yQO2824m0Y05WyGCIcSMMvBaM
         G29aMNYF343+vvU4UAIkhM0utPH6GDOq22VlOMYy8yznvi2J0qO8WAo1NvNqMz9S2PIj
         LUnOMURKxkDktvltYx+FUC/CmUuJ6IMzqgMxip4+5fLmD9bTGVOO2hMuqOVDu5zLwRu5
         QrhJ+bZ0WH1jonBAv/523/YfRnDk13FpMpdvtA2wmgwl94D+DaI3gpCrnKZYiUxaPqZa
         bf8msp8IxrX7v3tty1wNnxzycjbMSJsJeHdVN0RGVcrSpezSXW5Jt0X1WUF53L8NoC/d
         ZD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TSzGjUy5r8/JGNRZAvsaU0ZiOLuGPTmx6supYiah4ck=;
        b=nFj3YdqKMJuao27A/yOEiLTJpf4k+SLiLPUSB7YMG8StNsNr7RHpujuV8OEk+D/wGJ
         JZsAT46IwOYL7NwoLVm74Z6A72VK57LMwDkGOZabb0iFTNrHtQWsK71ePXqzcgc9FUHO
         7YZm4cOJK7V1H3TVdcweTh4xJ29+TExrmB5np/5kHqyjn/gi2rb9IxrOZrpG0sCrbakW
         cpzL/mOZW2fHPpnkkl0BnVp4O22tviR1VGaKdSOdiOgFYUguy455wnKHw+naEHjWZ8O8
         /47Vw7J64M4USfl0RUmNHFlC+pL5SZMY6hWhwIGsaus9GgAHlEHaZLcS3W7M8iylKMh7
         S5VA==
X-Gm-Message-State: AOAM531IHkolVsSlu/KYZvYinWxhWRjtiT279JdfjxKBs7JZT3w5SZWo
        au9Jf9UUme0LLApdyHgndBY2zg==
X-Google-Smtp-Source: ABdhPJwWWURCB6s+Y6ZKNtF6dnc78mMFj3au1gNTf1yPSDC4Z3lMD7McGEb69p3B7h/OhFVLB1fYRw==
X-Received: by 2002:a63:9043:0:b0:3ab:18b:474e with SMTP id a64-20020a639043000000b003ab018b474emr15252467pge.544.1651610735718;
        Tue, 03 May 2022 13:45:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y22-20020a170902b49600b0015e8d4eb2d6sm6727504plr.288.2022.05.03.13.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 13:45:35 -0700 (PDT)
Date:   Tue, 3 May 2022 20:45:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Cc:     kvm@vger.kernel.org
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
Message-ID: <YnGUazEgCJWgB6Yw@google.com>
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
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

On Sun, May 01, 2022, Arnabjyoti Kalita wrote:
> Hello all,
> 
> I intend to run a kernel module inside my guest VM. The kernel module
> sets kprobes on a couple of functions in the linux kernel. After
> registering the kprobes successfully, I can see that the kprobes are
> being hit repeatedly.
> 
> I would like to cause a VMEXIT when these kprobes are hit. I know that
> kprobes use a breakpoint instruction (INT 3) to successfully execute
> the pre and post handlers. This would mean that the execution of the
> instruction INT 3 should technically cause a VMEXIT.

No, it should cause #BP.  KVM doesn't intercept #BP by default because there's no
reason to do so.

> However, I do not get any software exception type VMEXITs when these kprobes
> are hit.
> 
> I have used the commands "perf kvm stat record" and "perf kvm stat
> report --event=vmexit" to try and observe the VMEXIT reasons and I do
> not see any VMEXIT of type "EXCEPTION_NMI" being returned in the
> period that the kprobe was being hit.
> 
> My host uses a modified Linux kernel 5.8.0 while my guest runs a 4.4.0
> Linux kernel. Both the guest and the host use the x86_64 architecture.
> I am using QEMU version 5.0.1. What changes are needed in the Linux
> kernel to make sure that I get an exception in the form of a VMEXIT
> whenever the kprobes are hit?

This can be done entirely from userspace by enabling KVM_GUESTDBG_USE_SW_BP, e.g.

	struct kvm_guest_debug debug;

	memset(&debug, 0, sizeof(debug));
	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
	ioctl(vcpu->fd, KVM_SET_GUEST_DEBUG, &debug);

That will intercept #BP and exit to userspace with KVM_EXIT_DEBUG.  Note, it's
userspace's responsibility to re-inject the #BP if userspace wants to forward the
#BP to the guest.

There's a bit more info in Documentation/virt/kvm/api.rst under KVM_SET_GUEST_DEBUG.
