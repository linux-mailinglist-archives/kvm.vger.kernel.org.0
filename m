Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C074C4A3E
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 17:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242689AbiBYQOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 11:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237566AbiBYQOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 11:14:05 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231CF14FFCB
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 08:13:33 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id i1so5218921plr.2
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 08:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=AOmvrkfJdSOt4B+8w91ON8dJooZf1Q4JMpVsgKimWBM=;
        b=QeIbOEbY69mEiBFOWAa2Phv4vkerSxfhOVuOtHUkjrfC8BMToPkvFr51DnundDP9MC
         iRbXt3eg274Iu2IZqiAbt0CSRKIwYzESdeh8wNFmXu05RzX9deKg0KT1H/yLdfBtKQAp
         Z2HJ+eVFW4itd6aGWCkrKqisO0ASv19B/i6j8x0S/bhkJ0y9N7QIaHhhIfnsE16rZVYT
         SPjLad6jbFW1P0q3EDPurkvkK2cwkM3SEvx97U5QF/7twCxY+JPnuYaKtbyHZiawQFHN
         FVNIUH0iUqwbk35WGVu12/qRHOgJXTKp1eDRf5Vl/6LYG/9JBxPLMGEHHTFJi6KStjHs
         PAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AOmvrkfJdSOt4B+8w91ON8dJooZf1Q4JMpVsgKimWBM=;
        b=UUNvAi9EqrOhli4nBm1aoNxc+3bIidlFDfT2FEgfPYCUJDc+pDLYNImpW470+uUTyw
         bN2wEljSnBYC64Z7dVQL3ckbpQ5ew7ABS5JlOH+f/kaXmR199S/gldWEHsMLtI2Uhrof
         YJCGhgZZ36DlX7D2lwL0WCdy4pp5s3rN4FIgfCaBWaceh+gfT677gSI5X8nDHFFolNYu
         cmIHMN5Oxp08OmDNFQlMX+4WgGuR32yYPQJACwjS83ZStC2NcB6sKemUGLCv3wlDYvoc
         ylb9W1Vrg8f8M4RCJCM7t/nNL+onCcx/uPMQ7JYoWQcA5cy0sr2adYpfpywDnkLEeAGW
         hKEg==
X-Gm-Message-State: AOAM530+WXMgOuCn5SOTmPlVbmeKYUpxqsSPa7uzk5Vmk27RHArfFAKE
        Pk6rEuQko6OfOSyUneS1ZU3dwQ==
X-Google-Smtp-Source: ABdhPJyBxq/6L6qxqJiCyuw83piyxlv2doR7gLQDeYgclfDunUEzXHwr6mQZafrkPMIM2MNjUtzxhQ==
X-Received: by 2002:a17:902:ab4c:b0:14f:bb61:ef0a with SMTP id ij12-20020a170902ab4c00b0014fbb61ef0amr8079545plb.84.1645805612386;
        Fri, 25 Feb 2022 08:13:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n22-20020a056a0007d600b004f3ba7c23e2sm3841458pfu.37.2022.02.25.08.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 08:13:31 -0800 (PST)
Date:   Fri, 25 Feb 2022 16:13:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Woodhouse, David" <dwmw@amazon.co.uk>
Cc:     "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: Don't actually set a request when evicting vCPUs
 for GFN cache invd
Message-ID: <YhkAJ+nw2lCzRxsg@google.com>
References: <20220223165302.3205276-1-seanjc@google.com>
 <2547e9675d855449bc5cc7efb97251d6286a377c.camel@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2547e9675d855449bc5cc7efb97251d6286a377c.camel@amazon.co.uk>
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

On Fri, Feb 25, 2022, Woodhouse, David wrote:
> On Wed, 2022-02-23 at 16:53 +0000, Sean Christopherson wrote:
> > Don't actually set a request bit in vcpu->requests when making a request
> > purely to force a vCPU to exit the guest.  Logging a request but not
> > actually consuming it would cause the vCPU to get stuck in an infinite
> > loop during KVM_RUN because KVM would see the pending request and bail
> > from VM-Enter to service the request.
> 
> Hm, it might be that we *do* want to do some work.
> 
> I think there's a problem with the existing kvm_host_map that we
> haven't yet resolved with the new gfn_to_pfn_cache.
> 
> Look for the calls to 'kvm_vcpu_unmap(…, true)' in e.g. vmx/nested.c
> 
> Now, what if a vCPU is in guest mode, doesn't vmexit back to the L1,
> its userspace thread takes a signal and returns to userspace.
> 
> The pages referenced by those maps may have been written, but because
> the cache is still valid, they haven't been marked as dirty in the KVM
> dirty logs yet.
> 
> So, a traditional live migration workflow once it reaches convergence
> would pause the vCPUs, copy the final batch of dirty pages to the
> destination, then destroy the VM on the source.
> 
> And AFAICT those mapped pages don't actually get marked dirty until
> nested_vmx_free_cpu() calls vmx_leave_nested(). Which will probably
> trigger the dirty log WARN now, since there's no active vCPU context
> for logging, right?
> 
> And the latest copy of those pages never does get copied to the
> destination.
> 
> Since I didn't spot that problem until today, the pfn_to_gfn_cache
> design inherited it too. The 'dirty' flag remains set in the GPC until
> a subsequent revalidate or explicit unmap.
> 
> Since we need an active vCPU context to do dirty logging (thanks, dirty
> ring)... and since any time vcpu_run exits to userspace for any reason
> might be the last time we ever get an active vCPU context... I think
> that kind of fundamentally means that we must flush dirty state to the
> log on *every* return to userspace, doesn't it?

I would rather add a variant of mark_page_dirty_in_slot() that takes a vCPU, which
we whould have in all cases.  I see no reason to require use of kvm_get_running_vcpu().
