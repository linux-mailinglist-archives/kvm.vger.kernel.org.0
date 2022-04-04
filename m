Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560214F1810
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 17:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377978AbiDDPRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 11:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377924AbiDDPRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 11:17:15 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B822C137
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 08:15:18 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k14so8627096pga.0
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 08:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=HE2EGesAzfkG+XPG66mRg3LJsnfX0L4pyOaQFv0oeTM=;
        b=IRO1hrqOZE+ZZPujBKMmBOtb7a9oy3eR+10yqmt1PUXow2DKvqj65SrZkA3s+prhhF
         ZiL6Js1gPJ0tlTPokLDtlBCA+o56KHCsvcGJkhBQV+8Yon5KMy4pAXvd49TsMLkFzkVv
         3fEjqA1zKwAQKpxHFOYbmykWaq0lry1zA/QH6UGQv+/ENqWkD3/vz9gcxsIcGISA6MC4
         CD7pEHei1OErNdftl+HmvogPPfg5ER1oSOAenVEnH98y+N/S3YmB6ztn4SKhtQnZg1yp
         Sw/Lir49XT1W0ltkvJY5bu0brkQnvQudaLVq5Mw60Bm24Z2t1gvcHO5jQ97NjRK5K/3X
         5V7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HE2EGesAzfkG+XPG66mRg3LJsnfX0L4pyOaQFv0oeTM=;
        b=dkdHSElR4ufqMj9oBIiwX0HZp6bSKL4QwptPDEndTiuWCGOm4ZoNLBbA0xi8b56rd5
         ylD3FXJp1emJhSWuxXCrItAFpWd8ywMuBIadmC0FXvxjsqDS0GTkUS2Fo0JrLrDRq1X1
         O5Ic36+UZ0pPTjPQGpNkCO0/6ha2zyPTxazTTUKz85wJGl0LLbIaKJSCkjsFYrhL2/1k
         W9I2mJ3a4uqt/i8UBVx/rp4eaA63dBIxb4wsVfI+ISpXaYdmqgO/71sWJ1oykJvszMw+
         PUH+vGRtIEPHrnJUQ80uyaF0xXxsvU6e35O5mAKBVnwRjghMWt0Vp/PB9//E4BUjPmbd
         Jsvw==
X-Gm-Message-State: AOAM5338xnexYJrdvy9l+nK5jNIFlZwrd6IjviZfTfr20l2jNIrE8W4N
        Cv1J2A5UJxkjwNPqVf7hg9Qvig==
X-Google-Smtp-Source: ABdhPJxqTrWvFH4n2ufrMe4V4grxK47YHIqUueBwWYr2mXHZSunxQ1BFUWU3ArqPpXE6vMNPc3GR+w==
X-Received: by 2002:a63:35c1:0:b0:386:3620:3c80 with SMTP id c184-20020a6335c1000000b0038636203c80mr273939pga.327.1649085317855;
        Mon, 04 Apr 2022 08:15:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a11-20020a63cd4b000000b00378b9167493sm11029851pgj.52.2022.04.04.08.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 08:15:16 -0700 (PDT)
Date:   Mon, 4 Apr 2022 15:15:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH] KVM: VMX: optimize
 pi_wakeup_handler
Message-ID: <YksLgfrKuX78e0ja@google.com>
References: <1648872113-24329-1-git-send-email-lirongqing@baidu.com>
 <e7896b4e-0b29-b735-88b8-34dd3b266d3d@redhat.com>
 <d63acc4d9ac24a48b49415a45238e907@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d63acc4d9ac24a48b49415a45238e907@baidu.com>
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

On Sat, Apr 02, 2022, Li,Rongqing wrote:
> > 发件人: Paolo Bonzini <paolo.bonzini@gmail.com> 代表 Paolo Bonzini
> > On 4/2/22 06:01, Li RongQing wrote:
> > > pi_wakeup_handler is used to wakeup the sleep vCPUs by posted irq
> > > list_for_each_entry is used in it, and whose input is other function
> > > per_cpu(), That cause that per_cpu() be invoked at least twice when
> > > there is one sleep vCPU
> > >
> > > so optimize pi_wakeup_handler it by reading once which is safe in
> > > spinlock protection

There's no need to protect reading the per-cpu variable with the spinlock, only
walking the list needs to be protected.  E.g. the code can be compacted to:

	int cpu = smp_processor_id();
	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
	struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
	struct vcpu_vmx *vmx;

	raw_spin_lock(spinlock);
	list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
		if (pi_test_on(&vmx->pi_desc))
			kvm_vcpu_wake_up(&vmx->vcpu);
	}
	raw_spin_unlock(spinlock);

> > >
> > > and same to per CPU spinlock
> > 
> > What's the difference in the generated code?
> > 
> 
> This reduces one fifth asm codes

...

> these is a similar patch 031e3bd8986fffe31e1ddbf5264cccfe30c9abd7

Is there a measurable performance improvement though?  I don't dislike the patch,
but it probably falls into the "technically an optimization but no one will ever
notice" category.
