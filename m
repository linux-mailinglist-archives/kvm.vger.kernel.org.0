Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598FC5AD814
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 19:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiIERI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 13:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiIERI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 13:08:27 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451505E652;
        Mon,  5 Sep 2022 10:08:26 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id bz13so8722360wrb.2;
        Mon, 05 Sep 2022 10:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/ciryf8KmN21qOu4f8QcUm2dMJRaMEjVT+du8U+TPyQ=;
        b=zpXWbHCEl3RCUl6ec2eei06NDuKUHZtz9+ApiSa0/thTlfGVJyZDo4Wb+4Jx/MWO2t
         db8vPYDMMsC8RXjavtSZBjWN6fcTD0BAB4vSiPk2KEH5SQ07B+6ICdPn/P9MPDbp0LCQ
         pEatOvv3NAQLjmK4o4vebtaQp0r/TlUoZ7wQqwA2mi4d0tedGZC+bXqyv7IWXV+cNIMZ
         ClskvXU2aB+5HXcnVRLN6av//YEoi2JxPhDDL0Y6CGoMgtKzZWiiceQ0SdB8Acr8BcmO
         M6vzhq72fmzehkJg8AGLdsgJnrvXXumxp8Juob455/DD0VNGS8ciIy30RIF+NkgCMs1T
         tDDw==
X-Gm-Message-State: ACgBeo3E36nRrnDK8rb7tWV6rQbexV3QDcQRx3S66uTpKcf6MhUpiTwF
        08tJgqGZzoR2TqOlQEqhSSo=
X-Google-Smtp-Source: AA6agR5HVWdK8tKcRbiNCcmb3AW06ynUo8cFY3mVxiuLC8hMFA/JDzXQmgW3FnlETt28s4SDYB9dKQ==
X-Received: by 2002:adf:f642:0:b0:226:d4b1:8502 with SMTP id x2-20020adff642000000b00226d4b18502mr23753732wrp.553.1662397704895;
        Mon, 05 Sep 2022 10:08:24 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id m18-20020adff392000000b00228b3ff1f5dsm2787331wro.117.2022.09.05.10.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:08:24 -0700 (PDT)
Date:   Mon, 5 Sep 2022 17:08:20 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v6 04/33] KVM: x86: Check for existing Hyper-V vCPU in
 kvm_hv_vcpu_init()
Message-ID: <20220905170820.yivhrivabsixj3ca@liuwe-devbox-debian-v2>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
 <20220830133737.1539624-5-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830133737.1539624-5-vkuznets@redhat.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 03:37:08PM +0200, Vitaly Kuznetsov wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When potentially allocating/initializing the Hyper-V vCPU struct, check
> for an existing instance in kvm_hv_vcpu_init() instead of requiring
> callers to perform the check.  Relying on callers to do the check is
> risky as it's all too easy for KVM to overwrite vcpu->arch.hyperv and
> leak memory, and it adds additional burden on callers without much
> benefit.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
