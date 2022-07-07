Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B7B56A906
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 19:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbiGGRDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 13:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbiGGRDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 13:03:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A178E11824
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 10:03:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b9so4589860pfp.10
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 10:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jdkazbKvIFn4Jz/6v29YhvwJkF9JTs0ep9OvO8uwzZw=;
        b=N0CM8QiRbgYAqv4mnG0Q//Nd70wvkpdSBcs/o1QeevPtmsy6GkIYZyrt0nyJpoIjyo
         mBbhCowPn7YKyxi7TqVfY9UsKjW9hehlGJ/7JomE1jVp2gN3K016tPCQDZYcqysuDNjR
         CUrR+GxcEG1RrJtq2JDASR7sr5DcRLdw5rCa0HucNJOe5uRTPbvNgvDgvDpecGTZNaA1
         g5T4ii3KvgJfk4LlRsZ7/R2t5ipHLKeq8tVHxNRQsf/do8vqtL5+9itZw9ydbS2Ewv1C
         vtqeoFztqN8eLpkRN77ya+w2bBhVeX+3Lq18bp52MsDsO9UpF8lgeFJHAVBNe1C7XuLC
         NkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jdkazbKvIFn4Jz/6v29YhvwJkF9JTs0ep9OvO8uwzZw=;
        b=YQAxJonyDw6IqnW9J5gV7mRazCdCJJz79KXLwV3k2M1C+V05tqddVmv4t5jPEHBc20
         Rms0V3shgB1ITHkbLUP56zUb9mYWwuT5VOZG85OBbKdeuIaFnhQGa7RLfU2mEox1s0Sg
         fBnnFYUZhlg0IGo9Kz4kVfiSX/9FSx8vfj41yc9J0yWkr+X/49JGSpoqF2eeCxYmQibc
         X/c+8sJ1f7Xx+C8Ic5jz9VJ3A+k77X5lVd+rLmnfoe+yJABpOL94W57ZFFa2XbiB74W6
         8/NjQdMTPDkAW0u52nYL8GW+fj8YZ1XaELC2UnWXQ1VT87SJAIOnmEJwIuZ5C96MW7a8
         9epQ==
X-Gm-Message-State: AJIora+9qXOSu6Ma3aoSslo0dMaJHWR1LF3knYk35r7Bre+fZtFfMAnh
        pxFtfa1+MyQOl9gy3ordGZBhGw==
X-Google-Smtp-Source: AGRyM1vUihakMU54VitrtPssiq1aoNSN+6mpi/eQjWCFi0db0vQyZ2C+pNgEH9oxgg+AlurugWRk+Q==
X-Received: by 2002:a17:902:d48a:b0:16b:f101:b28b with SMTP id c10-20020a170902d48a00b0016bf101b28bmr16815249plg.148.1657213423882;
        Thu, 07 Jul 2022 10:03:43 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id np18-20020a17090b4c5200b001efa35356besm5291311pjb.28.2022.07.07.10.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 10:03:43 -0700 (PDT)
Date:   Thu, 7 Jul 2022 17:03:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Kyle Meyer <kyle.meyer@hpe.com>, bp@alien8.de,
        dave.hansen@linux.intel.com, dmatlack@google.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        mingo@redhat.com, payton@hpe.com, russ.anderson@hpe.com,
        steve.wahl@hpe.com, tglx@linutronix.de, wanpengli@tencent.com,
        x86@kernel.org
Subject: Re: [PATCH v2] KVM: x86: Increase KVM_MAX_VCPUS to 4096
Message-ID: <YscR673z61Z/VW7F@google.com>
References: <YqthQ6QmK43ZPfkM@google.com>
 <20220629203824.150259-1-kyle.meyer@hpe.com>
 <87r136shcc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r136shcc.fsf@redhat.com>
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

On Thu, Jun 30, 2022, Vitaly Kuznetsov wrote:
> Kyle Meyer <kyle.meyer@hpe.com> writes:
> 
> > Increase KVM_MAX_VCPUS to 4096 when the maximum number of supported CPUs
> > (NR_CPUS) is greater than 1024.

Changelog says "greater than 1024", code says "at least 1024". 

> > The Hyper-V TLFS doesn't allow more than 64 sparse banks, which allows a
> > maximum of 4096 virtual CPUs. Limit KVM's maximum number of virtual CPUs
> > to 4096 to avoid exceeding that limit.
> 
> In theory, it's just TLB flush and IPI hypercalls which have this
> limitation. Strictly speaking, guest can have more than 4096 vCPUs,
> it'll just have to do IPIs/TLB flush in a different way.

Yeah, I don't see any reason to arbitrarily limit this to 4096.  And conversely,
I don't see any reason to force it to 4096 if NR_CPUS < 4096, it seems highly
unlikely that there's a use case for oversubscribing vCPUs in a single VM when
there are more than 1024 pCPUs.
