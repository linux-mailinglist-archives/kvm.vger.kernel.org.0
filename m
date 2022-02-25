Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756F24C4F93
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbiBYUY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiBYUY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:24:27 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5872118E0
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:23:53 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id i1so5206780ila.7
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DUxCicXLFH9yMaoN8+JktIFPw23w0zKYqWMiWNjhmuk=;
        b=pyPfdS2bRbhNU6NsYpIhE3mu/4p+RBEdcHfBlVbnzzqlhHA6Dq042ied82oQeepM/U
         QsbYT2cKn/8E3QcdMzGeis4OV7YiEmknuhaPAGslbkyq7qEfemlFUCB2409Rv8d3hX8h
         89M3TeVamk3jjsnchsB2QbsCzNwlBnOWqb8FMalPfjasHyM2KghElUbN2N7TwoNGjvTD
         zsbBOMZGQVLWQKD04WllqgGQwSgiTasvwbYxBNaJWFAl9u/CBTBsNk+pTP39rT64aUbU
         erWKg/zEhQfTH0LliNxfWBcnx4PkYwnMrGOLPzXXxxcgRv7bxw+xrHpmDMqKBC8jSsjV
         9JYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DUxCicXLFH9yMaoN8+JktIFPw23w0zKYqWMiWNjhmuk=;
        b=x18VkSqEHA3NU91+pSZByMCsKWWOBI3+B6mPM6MuVQYg4efqcqke95m9mnqOvM7ETV
         ItwYQ8jJg4lLshOuDea5+ip1ZXRn+lG/SPdhovm2oh0zys+ZU1YDNO6bfw+kgl9p3whx
         0VI9QQNTGIAd+yqQswzP/dNb8w+rNsNxPJlUNdCHEupLmwYulauNecnwGi6P6oyMQe/U
         Q6yzLgSYQAzH40Etsm2JgheXYOt3HcuhT+YHuIkFuNCiAN0RcPGtrtZnTMcEpJ5MSuCN
         Unl87AuOZ50siZOQtWV2DdVoRD9tjVNHPgcMO/mM02+8fpeLZxErg7Qhf3fZQrvemGqo
         osrg==
X-Gm-Message-State: AOAM531sVNxp2lII/apHVpqgTqbAOUqvhjoZ1b5z5naZ3W4qFjrOevBE
        tffG2Vav32NS/VnfRs2L6KIi6UzHwCvBVg==
X-Google-Smtp-Source: ABdhPJyb3ztWMmbJKNQzFUgOKfe4sjkXHQyGeNXGFT0QQfEgOkWrV+7Ost0MzUdQLTgTRn+nJabFjw==
X-Received: by 2002:a05:6e02:1543:b0:2be:d7b4:49b3 with SMTP id j3-20020a056e02154300b002bed7b449b3mr8194217ilu.97.1645820632339;
        Fri, 25 Feb 2022 12:23:52 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id u15-20020a056e021a4f00b002c27332ef9dsm2341555ilv.47.2022.02.25.12.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 12:23:51 -0800 (PST)
Date:   Fri, 25 Feb 2022 20:23:48 +0000
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v3 2/6] KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL
 ctrl bits across MSR write
Message-ID: <Yhk61JzOkTxAioig@google.com>
References: <20220225200823.2522321-1-oupton@google.com>
 <20220225200823.2522321-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225200823.2522321-3-oupton@google.com>
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

On Fri, Feb 25, 2022 at 08:08:19PM +0000, Oliver Upton wrote:
> Since commit 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
> VM-{Entry,Exit} control"), KVM has taken ownership of the "load
> IA32_PERF_GLOBAL_CTRL" VMX entry/exit control bits. The ABI is that
> these bits will be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs if
> the guest's CPUID exposes a vPMU that supports the IA32_PERF_GLOBAL_CTRL
> MSR (CPUID.0AH:EAX[7:0] > 1), and clear otherwise.
> 
> However, KVM will only do so if userspace sets the CPUID before writing
> to the corresponding MSRs. Of course, there are no ordering requirements
> between these ioctls. Uphold the ABI regardless of ordering by
> reapplying KVMs tweaks to the VMX control MSRs after userspace has
> written to them.
> 
> Note that older kernels without commit c44d9b34701d ("KVM: x86: Invoke
> vendor's vcpu_after_set_cpuid() after all common updates") still require
> that the entry/exit controls be updated from kvm_pmu_refresh(). Leave
> the benign call in place to allow for cleaner backporting and punt the
> cleanup to a later change.
> 
> Uphold the old ABI by reapplying KVM's tweaks to the BNDCFGS bits after
> an MSR write from userspace.
>

typo: s/BNDCFGS/"load IA32_PERF_GLOBAL_CTRL"/

I'll adopt this if I need to send another spin of the series. Otherwise,
do you mind fixing the typo when applying Paolo?

--
Oliver

