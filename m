Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235694FE77F
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354985AbiDLR4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiDLR4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:56:37 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274F66465
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:54:19 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t4so17942832pgc.1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g/wkfqACAO1R6swGFiX5nmXcMTqZOKO9AQAJHkwa6Yw=;
        b=Wyi6GlmOv6SCb15h1hHMmawDej03rLQGj8tm+MM1gNExlxevz5zy3nG6NqtSX5dMLY
         o0GPLv/gNUI+uypOTtJ4v3mkbxiAaj0hIe2FpOhQ5v33iFzbWz9bCXoMYDiD0+rv8inD
         7zwE5VbVWzq5NBIAQ5hvXRZombD21rM4yBf+AzpcXtxheWJqC1iQTgbIYC/XamQQW3ci
         IX+t4jSob5vv4PPadlRhsGh9Tt3R3ViEDqgerLcGMx5v/bUjnUb/t6rzh77S0LGliyS2
         HEVvhKOhWQ/t9hWCQLhtV8AjRYtmixTBfhHNGJQi8nuDqOkGPU7zB92m+4DT9x6UPkCD
         UGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g/wkfqACAO1R6swGFiX5nmXcMTqZOKO9AQAJHkwa6Yw=;
        b=3lq4OLGbXvciUqjUmIsbYuddYtuCKPsN9NKEUeWAIYUKF7NxC26wR2TL6dr2GiC6hN
         QiItt2kbvoG7FIrZl53xRpn8xZwAPuabcslSwCB6nm+ijlulz1JCfUAw/+zggAuGp8nU
         GrMYeFPDspu6971qHsntsZDicVXuFwb7HR6UDSZNrMqEez16kjRX7hfu3ZWZFOQSYiKK
         saZjkEJjsXbMmjfEoqp7DKKNGkahGluu2J75kgV/UpzE62udymnFcV4QiVLLVu0PV0m9
         KaodmERIEFU6IluN4AkY02zsXkkhqZtgXfxj0DSf4g4eNiKRNiejUel7DPNXO3XSjdDR
         Cpqg==
X-Gm-Message-State: AOAM532D7zgD/L4DLWwKmek0U3c3ViogFOHJX0bfrt3HzcCL2VBztDFO
        gvblKnrqDdln9BEJFAFYHw6tgg==
X-Google-Smtp-Source: ABdhPJxC3qAvnQwz7E+luTSIs+vtI3r9OV9g+oYs3RNcQcviCeKYBgNXNo/OdMyXBVCyHNajsJZVOA==
X-Received: by 2002:a63:c51:0:b0:39c:c5ac:9f3b with SMTP id 17-20020a630c51000000b0039cc5ac9f3bmr23602561pgm.257.1649786058500;
        Tue, 12 Apr 2022 10:54:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00230d00b004f427ffd485sm43049232pfh.143.2022.04.12.10.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:54:17 -0700 (PDT)
Date:   Tue, 12 Apr 2022 17:54:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 07/10] KVM: x86/MMU: Allow NX huge pages to be
 disabled on a per-vm basis
Message-ID: <YlW8xkay+EuM/c3M@google.com>
References: <20220411211015.3091615-1-bgardon@google.com>
 <20220411211015.3091615-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411211015.3091615-8-bgardon@google.com>
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

On Mon, Apr 11, 2022, Ben Gardon wrote:
> @@ -6079,6 +6080,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> +	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +		kvm->arch.disable_nx_huge_pages = true;

It's probably worth requiring cap->args[0] to be zero, KVM has been burned too many
times by lack of extensibility.

> +		kvm_update_nx_huge_pages(kvm);

Is there actually a use case to do this while the VM is running?  Given that this
is a one-way control, i.e. userspace can't re-enable the mitigation, me thinks the
answer is no.  And logically, I don't see why userspace would suddenly decide to
trust the guest at some random point in time.

So, require this to be done before vCPUs are created, then there's no need to
zap SPTEs because there can't be any SPTEs to zap.  Then the previous patch also
goes away.  Or to be really draconian, disallow the cap if memslots have been
created, though I think created_vcpus will be sufficient now and in the future.

We can always lift the restriction if someone has a use case for toggling this
while the VM is running, but we can't do the reverse.
