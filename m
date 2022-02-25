Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1733E4C4A85
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 17:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbiBYQWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 11:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242906AbiBYQWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 11:22:01 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F3877ABD
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 08:21:29 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j10-20020a17090a94ca00b001bc2a9596f6so5215376pjw.5
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 08:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dCkOofuT+eKplJpKUyxcU7JCwWPLhe5vZbRj/rqU7Ek=;
        b=CiXw6wJ/i76/Cqk2SEPO6Cr+eb1PpfDFsRw3P1RxPdQbc28gtVEPA6ayCEW8VwXr/7
         pEWf6Vm9WSDlkfazp/KdPafVywfXQotF7wVnCX46tMiSAfpZaCb5pWk8gn3fv4Hvj5bw
         yO8yUxO/H7Jatt2uh3HilCq12Ek1TXGRAZ6SXI8p5bh2EpuxoUH8vm2855cqiG1IfWf0
         yFx8ObVlHVRzDwFSPzt7a2Wd7GeXtf8ITf+j1bA3wrjgCwGi4fdbbVEHFxdqz2HVz/Fr
         /VJA86nEqwgTZab7UWS1IFrWSJDxyVFSd7t7YQSnCH7RE434PHReO618rqpxw1FVVUJy
         mllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dCkOofuT+eKplJpKUyxcU7JCwWPLhe5vZbRj/rqU7Ek=;
        b=6rNfpOXW0BQ7cCprSIT1KGAStRignvTR1Z8oNwK8kwM4v8e5eIYuiWqC8nQ4oQcvqt
         UV6dLIOmorWIsB52GMW923bKuf1GDA7gJyyYm3cFgUP1YuurquHAR39R1C4VYRJio+ms
         0KDbJu3bRDeTeAUekybXIiCuyQTx8P945LLYuuwtR4se1R+B1FO1eap8NKRdDaaPl9Hb
         ojY5uc4Sc2CVfyYSrZydF+4ePD3ZLMIzVD5780UOeldA/ESvk7CdEdSxTzcOayL6uJMA
         G040soUBYFqtyqB+ECwVlswXQuvOffLQVwto6Cd89dDUj3ch4hKXwazgRBnpQlck5tpF
         sKCw==
X-Gm-Message-State: AOAM532yd1oEB2QKP6yAuN7isds/i4A39VJOif2f97JPJ36Cqmgxheiw
        L5MoxvbztNDFgeHzPE3cBIxEAA==
X-Google-Smtp-Source: ABdhPJx6OzZS+uLCUucPfcMPVbrXAeG1bsgoQvkUHxAV2WgwiZRVRbwww1JV+0eel38i6XP0m75ELQ==
X-Received: by 2002:a17:902:e8d7:b0:149:3b5d:2b8b with SMTP id v23-20020a170902e8d700b001493b5d2b8bmr7990890plg.162.1645806088619;
        Fri, 25 Feb 2022 08:21:28 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7982d000000b004cb98a2ca35sm4097321pfl.211.2022.02.25.08.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 08:21:27 -0800 (PST)
Date:   Fri, 25 Feb 2022 16:21:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Anton Romanov <romanton@google.com>
Subject: Re: [PATCH] KVM: x86: Don't snapshot "max" TSC if host TSC is
 constant
Message-ID: <YhkCBH9fsqrJYMca@google.com>
References: <20220225013929.3577699-1-seanjc@google.com>
 <609de7ff-92e2-f96e-e6f5-127251f6e16d@redhat.com>
 <7086443d5e1e21d72a3d5c386c16f0c07d37a0a8.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7086443d5e1e21d72a3d5c386c16f0c07d37a0a8.camel@infradead.org>
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

On Fri, Feb 25, 2022, David Woodhouse wrote:
> On Fri, 2022-02-25 at 13:10 +0100, Paolo Bonzini wrote:
> > 
> > Queued, but I'd rather have a subject that calls out that max_tsc_khz 
> > needs a replacement at vCPU creation time.  In fact, the real change 
> > (and bug, and fix) is in kvm_arch_vcpu_create(), while the subject 
> > mentions only the change in kvm_timer_init().
> 
> In
> https://lore.kernel.org/kvm/e7be32b06676c7ebf415d9deea5faf50aa8c0785.camel@infradead.org/T/
> last night I was coming round to the idea that we might want a KVM-wide 
> default frequency which is settable from userspace and is used instead
> of max_tsc_khz anyway.
> 
> I also have questions about the use case for the above patch.... if
> this is a clean boot and you're just starting to host guests, surely we
> can wait for the time it takes for the TSC synchronization to complete?

KVM is built into the kernel in their case, the vmx_init() => kvm_init() gets
automatically called during boot.  The VMs aren't started until well after
synchronization has completed, but KVM has already snapshotted the "bad" value.
