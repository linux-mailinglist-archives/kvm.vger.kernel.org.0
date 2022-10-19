Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8193F6052D8
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 00:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiJSWMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 18:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJSWMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 18:12:17 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BA31793A4
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:12:16 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so1504610pji.1
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zZDs+e1tEDSMDXlDBKyOmGP89CEFOInZ+U8nAdsCuEE=;
        b=j1dakIi1iaKRZtMmnvX1D9Kmxsc6ZHpVNV9DE90BDd4F66ePn6V6aTnueWQjRvgQCw
         B2NuPYsptjPdRHUX7ymf5cYiCrn0wnoUezJ5vNQAJp2xbkwXoWfDfLwA/qstHFKXbbMt
         Z2RgJUzXulnGact8b1OgHqQSugpFtaWSWbPTSF+JsYzcfNlmaS+QYqoRo2gB/goBTiNG
         d5AT7KGzZWV5g6quUAZXr6fuvo9ptvicHEJa8dfdAxNO5UVJX8Cxf20K26Clt0W7ZnK1
         1HCXCTZbJNuueBnABeMWYQFpBC7dOC2lhWBjRLVLBtvNwJjsJlRnUufh4H2Zz9DH+fhv
         kRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZDs+e1tEDSMDXlDBKyOmGP89CEFOInZ+U8nAdsCuEE=;
        b=X/T3T6eWTFLFuDMuVTP0QzDofFZLaYEdOjTsJtkE1688JixbJ67cs19M6SdhN2h0Yc
         4XNngx6Vsu4suIU5/BHkZZ6ied/T2J4l0SxvkFhw3hmo156gOahQHPT2lpHDMhH2C3XH
         uYDmFCwb0PEH9kd2OCGbT3P7drUULQW/MnfIOHGesgbYbVS2M0F4MjW8iPIzb0ERrGuI
         NZaAR+CMNrCKxSxnGAYX1omdckHd5rpH/KOU5LZ2nlF0f/HePu9J4tyMTk5iPMb2I9ko
         QMNvfvwG6DUA0F2BOGzYxUWaiRyfdAB2ZUC+T8rf/y+rjiL6b3t9+neEROEt5GQ+83Tp
         TtGw==
X-Gm-Message-State: ACrzQf2HU0P70Z+69rhWSxOOrFWhr6dl2sh8QcDT/QKWyJtRxmEexGog
        t699n2qJcRnLFhGxSkjCOITF2A==
X-Google-Smtp-Source: AMsMyM6L/PGjPtkcMdIGqeJkmX7cnb7wWT3a81geGEN3ptnDQfA5XicnzE/kfC7aYvJNXjEqAnAq1A==
X-Received: by 2002:a17:90a:354:b0:20a:6867:4a2b with SMTP id 20-20020a17090a035400b0020a68674a2bmr47829614pjf.157.1666217535953;
        Wed, 19 Oct 2022 15:12:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u15-20020a17090341cf00b0017f93a4e330sm11206871ple.193.2022.10.19.15.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 15:12:15 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:12:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 37/46] KVM: selftests: Hyper-V PV TLB flush selftest
Message-ID: <Y1B2OwzbkHdZwS4k@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <20221004123956.188909-38-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004123956.188909-38-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022, Vitaly Kuznetsov wrote:
> +static void *vcpu_thread(void *arg)
> +{
> +	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)arg;
> +	struct ucall uc;
> +	int old;
> +	int r;
> +	unsigned int exit_reason;
> +
> +	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_setcanceltype failed on vcpu_id=%u with errno=%d",
> +		    vcpu->id, r);

If possible,

	TEST_ASSERT(!r, pthread_setcanceltype() failed on vcpu_id=%u, vcpu->id);

> +
> +	vcpu_run(vcpu);
> +	exit_reason = vcpu->run->exit_reason;
> +
> +	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
> +		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
> +		    vcpu->id, exit_reason, exit_reason_str(exit_reason));
> +
> +	if (get_ucall(vcpu, &uc) == UCALL_ABORT) {
> +		TEST_ASSERT(false,
> +			    "vCPU %u exited with error: %s.\n",
> +			    vcpu->id, (const char *)uc.args[0]);

REPORT_GUEST_ASSERT_N?

> +	}
> +
> +	return NULL;
> +}
> +
> +static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu *vcpu)
> +{
> +	void *retval;
> +	int r;
> +
> +	r = pthread_cancel(thread);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_cancel on vcpu_id=%d failed with errno=%d",
> +		    vcpu->id, r);
> +
> +	r = pthread_join(thread, &retval);
> +	TEST_ASSERT(r == 0,
> +		    "pthread_join on vcpu_id=%d failed with errno=%d",
> +		    vcpu->id, r);

Same assert/errno comment here.

> +	while (true) {
> +		r = _vcpu_run(vcpu[0]);
> +		exit_reason = vcpu[0]->run->exit_reason;
> +
> +		TEST_ASSERT(!r, "vcpu_run failed: %d", r);

Just use vcpu_run().

> +		TEST_ASSERT(exit_reason == KVM_EXIT_IO,
> +			    "unexpected exit reason: %u (%s)",
> +			    exit_reason, exit_reason_str(exit_reason));
> +
> +		switch (get_ucall(vcpu[0], &uc)) {
> +		case UCALL_SYNC:
> +			TEST_ASSERT(uc.args[1] == stage,
> +				    "Unexpected stage: %ld (%d expected)\n",
> +				    uc.args[1], stage);
> +			break;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			/* NOT REACHED */
> +		case UCALL_DONE:
> +			return 0;
> +		}
> +
> +		stage++;
> +	}
> +
> +	cancel_join_vcpu_thread(threads[0], vcpu[1]);
> +	cancel_join_vcpu_thread(threads[1], vcpu[2]);
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
> -- 
> 2.37.3
> 
