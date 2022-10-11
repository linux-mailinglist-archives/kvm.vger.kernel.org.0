Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9415FBB72
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 21:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiJKTk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 15:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiJKTks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 15:40:48 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F057895E3
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:40:46 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id i3so14453188pfk.9
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+WmqL8qyiSi+QRhUOFf3zGACo+9+iiKete6ei7NIsw=;
        b=Kkz3CcU8vqdpzZaQJ6AJAO2aByoCbf+TkBinLRtonahF5skgudOcI3PJa1yfk7o2mH
         a+vOTAvzYj55n2NZ4v6DBlQIwaP1dIF+Wjj1ursqRxo5nI7vvuTxSbYrAcPQXCxmg4Zy
         fQdLP2AiTN0ZnrAkrtzXYz+2GQHkGTHhLW3BCAiKrUfiTnf7ZDlPTMafNxx3KnWkGTP2
         5IxsbGrL0oIsEmy1aIvf+nEwz7IV1A3CdLO4fvTb3dZBi9YaAaRGGPZdkpSLw2+TvJ4U
         86O09D5VJFWqIH0C8hlcJx5s2jH0Hn/JZYMTumW72E1zvbJGfjDBaCXD/WHqcxi7/yoS
         OMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+WmqL8qyiSi+QRhUOFf3zGACo+9+iiKete6ei7NIsw=;
        b=RIsiBJ+mL3yk5MtiId7zye/P7EgezUjOcw1HjlAwXpsyJQg5+/qRFaOY3WoaIFepZ4
         L4lfZq61KWldCfYzUl88zkR0FaIZOEI4uU6eFfvYNT+zdDDYVaD5jHawU5n2xs9/v9IH
         DZTWhEe8KNwA5oy2JxSQcNsRHtrLvq9xfYjXky/BmOu1rqefDEdEnLRgrszhLNNMd+bn
         /0DLTSQIjLmuOtJWWZNWi3MTOkdpcs3EqgDR/UxK1D/Pf/InHbtD1A5Ix2GcLfsvhPok
         yJladR3m3s225nuSt8Zgi5nLZ7HNL5iIuSVpY2kFCNkb5V6Nre8CIs1zZLpJjcCKgsy8
         Rh9A==
X-Gm-Message-State: ACrzQf0UJzTcQeNxZJf18AjabnwWrLQqDwjVvfct9K8NfOaMqbPD9YAx
        FSe/UjAas8XqZLeJfKP+hmISKw==
X-Google-Smtp-Source: AMsMyM64f+NFKxf1tDoi0nap3U6KmALvuJGthnMyT0RYeWibVpcoOSnmAAYg59GPJMR33XKaz5kkew==
X-Received: by 2002:a05:6a00:1707:b0:563:235:769b with SMTP id h7-20020a056a00170700b005630235769bmr18577422pfc.19.1665517246042;
        Tue, 11 Oct 2022 12:40:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bc8-20020a656d88000000b0043a1c0a0ab1sm8067623pgb.83.2022.10.11.12.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:40:45 -0700 (PDT)
Date:   Tue, 11 Oct 2022 19:40:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/6] KVM: selftests: Test Hyper-V invariant TSC control
Message-ID: <Y0XGuk4vwJBTU9oN@google.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
 <20220922143655.3721218-7-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922143655.3721218-7-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, Vitaly Kuznetsov wrote:
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index d4bd18bc580d..18b44450dfb8 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -46,20 +46,33 @@ struct hcall_data {
>  
>  static void guest_msr(struct msr_data *msr)
>  {
> -	uint64_t ignored;
> +	uint64_t msr_val = 0;
>  	uint8_t vector;
>  
>  	GUEST_ASSERT(msr->idx);
>  
> -	if (!msr->write)
> -		vector = rdmsr_safe(msr->idx, &ignored);
> -	else
> +	if (!msr->write) {
> +		vector = rdmsr_safe(msr->idx, &msr_val);

This is subtly going to do weird things if the RDMSR faults.  rdmsr_safe()
overwrites @val with whatever happens to be in EDX:EAX if the RDMSR faults, i.e.
this may yield garbage instead of '0'.  Arguably rdmsr_safe() is a bad API, but
at the same time the caller really shouldn't consume the result if RDMSR faults
(though aligning with the kernel is also valuable).

Aha!  Idea.  Assuming none of the MSRs are write-only, what about adding a prep
patch to rework this code so that it verifies RDMSR returns what was written when
a fault didn't occur.

	uint8_t vector = 0;
	uint64_t msr_val;

	GUEST_ASSERT(msr->idx);

	if (msr->write)
		vector = wrmsr_safe(msr->idx, msr->write_val);

	if (!vector)
		vector = rdmsr_safe(msr->idx, &msr_val);

	if (msr->fault_expected)
		GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
	else
		GUEST_ASSERT_2(!vector, msr->idx, vector);

	if (vector)
		goto done;

	GUEST_ASSERT_2(msr_val == msr->write_val, msr_val, msr->write_val);

done:
	GUEST_DONE();


and then this patch can just slot in the extra check:

	uint8_t vector = 0;
	uint64_t msr_val;

	GUEST_ASSERT(msr->idx);

	if (msr->write)
		vector = wrmsr_safe(msr->idx, msr->write_val);

	if (!vector)
		vector = rdmsr_safe(msr->idx, &msr_val);

	if (msr->fault_expected)
		GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
	else
		GUEST_ASSERT_2(!vector, msr->idx, vector);

	if (vector)
		goto done;

	GUEST_ASSERT_2(msr_val == msr->write_val, msr_val, msr->write_val);

	/* Invariant TSC bit appears when TSC invariant control MSR is written to */
	if (msr->idx == HV_X64_MSR_TSC_INVARIANT_CONTROL) {
		if (!this_cpu_has(HV_ACCESS_TSC_INVARIANT))
			GUEST_ASSERT(this_cpu_has(X86_FEATURE_INVTSC));
		else
			GUEST_ASSERT(this_cpu_has(X86_FEATURE_INVTSC) ==
				     !!(msr_val & HV_INVARIANT_TSC_EXPOSED));
	}

done:
	GUEST_DONE();
