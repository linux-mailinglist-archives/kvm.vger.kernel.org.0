Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805FA4ECF49
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 00:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351448AbiC3WBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 18:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbiC3WBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 18:01:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB14D28E29
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 14:59:27 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b13so18224745pfv.0
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 14:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pDli6+hXKC5s9n1yl7hKexNUnpgD/mpYIhN4/2AX5LU=;
        b=Gc2pDpTunHkktjornaePqzCCgmOxkEvSJzLj7EEubIMjrBvHn3RSRu4y5Qv67AVdzo
         SVCXaeFUgPAbKgal6d4L1Y3MbeJaMiNFdU70/mxN20GMw9oSk0/dUBlJ76VAek5Gk7Wx
         btapBOJgOgS2Q1HXBEh4DnZ5tRUYpE48oOt+Dl8lovxojKPyLdl9uoRmJ5T8SKLTZkGm
         VMIHP3vrO2SlafqSHsNLiwF/T99xTdqwmkqIPEJOF69wCmLOWBRTYF/DSVmIAeKemcpW
         IOBjnNjeKnEKjZ2P23B64COvNr9CfHiFafff2FrknHawfHzmtd18JR6bsyVeuovIuhS4
         QyBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pDli6+hXKC5s9n1yl7hKexNUnpgD/mpYIhN4/2AX5LU=;
        b=wbUSoi295uSTNM2d8q7HG9UADaSHYnW/6bqPSPwPXZtgOp4hO/JEDYQzCwFeUaqA8r
         Jb0MSfbtMNjribRw3usF4CurRYJzrEuRPA2wpaYie15Fk9Wy96ehJw1kDECWfvkTyN0x
         3DCIQ3yHq8kbi77g0xIZxBHCiLhOUE0b2KaaaqMJgmGpMQcs0yOouztWjU6njUG1cPa/
         V9UuGPpRZVxUYUyiFitaMna5zNdAiu7LESQz50x5fEgzJUpBN9kqONNs40gjr2G8WQfq
         Y2uOG9R0TFvP9/6ax2fRXvHv5rdVcRoTzCjxvqwUUYfaM6w9sapjMv66vMATyBu77nEh
         sqOA==
X-Gm-Message-State: AOAM532QLdI6fz9mz5yuDIoB8KA7CjewMcMituweDYuA00ViGIGmg1lI
        HPSQnE4AuPyCi8DIYGVuUg0eFA==
X-Google-Smtp-Source: ABdhPJxxd83aMw81ffo9S+PVRWOuyN4iX3CWmeMqXWj9BHgs6Jz1dI869Hf+NQhCZfAXBOqoUTvZIA==
X-Received: by 2002:a62:7b97:0:b0:4fa:7a9a:6523 with SMTP id w145-20020a627b97000000b004fa7a9a6523mr1667883pfc.80.1648677567059;
        Wed, 30 Mar 2022 14:59:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id cn9-20020a056a00340900b004fad845e9besm22785110pfb.57.2022.03.30.14.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 14:59:26 -0700 (PDT)
Date:   Wed, 30 Mar 2022 21:59:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
Message-ID: <YkTSul0CbYi/ae0t@google.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
 <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
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

On Thu, Mar 10, 2022, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> In SVM synthetic software interrupts or INT3 or INTO exception that L1
> wants to inject into its L2 guest are forgotten if there is an intervening
> L0 VMEXIT during their delivery.
> 
> They are re-injected correctly with VMX, however.
> 
> This is because there is an assumption in SVM that such exceptions will be
> re-delivered by simply re-executing the current instruction.
> Which might not be true if this is a synthetic exception injected by L1,
> since in this case the re-executed instruction will be one already in L2,
> not the VMRUN instruction in L1 that attempted the injection.
> 
> Leave the pending L1 -> L2 event in svm->nested.ctl.event_inj{,err} until
> it is either re-injected successfully or returned to L1 upon a nested
> VMEXIT.
> Make sure to always re-queue such event if returned in EXITINTINFO.
> 
> The handling of L0 -> {L1, L2} event re-injection is left as-is to avoid
> unforeseen regressions.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---

...

> @@ -3627,6 +3632,14 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>  	if (!(exitintinfo & SVM_EXITINTINFO_VALID))
>  		return;
>  
> +	/* L1 -> L2 event re-injection needs a different handling */
> +	if (is_guest_mode(vcpu) &&
> +	    exit_during_event_injection(svm, svm->nested.ctl.event_inj,
> +					svm->nested.ctl.event_inj_err)) {
> +		nested_svm_maybe_reinject(vcpu);

Why is this manually re-injecting?  More specifically, why does the below (out of
sight in the diff) code that re-queues the exception/interrupt not work?  The
re-queued event should be picked up by nested_save_pending_event_to_vmcb12() and
propagatred to vmcb12.
