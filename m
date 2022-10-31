Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23953613D18
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJaSIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJaSH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:07:58 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C3D13E38
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:07:47 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f9so11378523pgj.2
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J/H/KPFBQMF1K00PNMTQs6+outctdzSdAedN66au0Qs=;
        b=X4Oaf5bQUDXcZ9TRaEAXOE3Tl/ht/UfRSGTR5z434eiPbsmM6aLcVJbjoiYKvr5HLX
         /3brcFgEEiXe2my2Bazlwa1jmewSH7uZP02/2QEcj1Oi7u4mcMspiEsoHJ5ccEj1IUE0
         L0W2d1Hq2JuGdRViif/i6itMmouMfQZpsB/GP5+ggc6gptKhXRH/u+h++exLplqZPJuk
         9G5M9+aHMLtCuF/jx4w+cNIgUI/z4TdW532DahAz+qZv65Zlnmn1n0I1b+Z1dWXsst33
         elnc7STCAf/+iRKTJYF9VvRy2sg/6z95D4ddJ5y/PQpUqK2CiCf/MA65FFMqBL5HaOTO
         RtDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/H/KPFBQMF1K00PNMTQs6+outctdzSdAedN66au0Qs=;
        b=t97uLM6eGLwBoXM1Pc9O9XLmlOVMQ00MbCn8nBf8EgVJlJlsIf00Qdwob/1pqvIKRh
         PRmardqyVN+FcouDX0/sUo5vvAzSjREh4wl9jK5O5irzJbfXlsedyH02CUA4JG2DYx40
         ESJYEsbeoh4n4KgZp/PrLRd0L4viR8fHrtbxaXPJLXX2Gh14RCW/kUnrxFmYxRqY66hT
         d5uSnrszfG3IjcpV92rRVOXCeLfJJAvDVciwdA5MA6Vtrvgwt3c5wsEoQOQFm4rMUSRL
         nkZREtVOX/b0iNLYXCymr6j1sdEuAIwBkLyG3ys2S4bhTb6MeU4SlqVz57fwoTAs951n
         v86w==
X-Gm-Message-State: ACrzQf08FLiGX65AXGp/Ex/DGYppEv+OLY7TsTfqDiIXivL5pLpLmK6s
        TyKirAK92QpL6e3P/2U8P5jqbQ==
X-Google-Smtp-Source: AMsMyM7Vo1be2QUfyYXVHUFIk4S4fv7z1XGz3xFHWZ6bZY9k3I3iv3YgaplOU6vGdBoaHgTSaOE9iQ==
X-Received: by 2002:a63:2c8:0:b0:46e:9da9:8083 with SMTP id 191-20020a6302c8000000b0046e9da98083mr13427288pgc.186.1667239666794;
        Mon, 31 Oct 2022 11:07:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s5-20020a170903200500b00186616b8fbasm4765534pla.10.2022.10.31.11.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:07:46 -0700 (PDT)
Date:   Mon, 31 Oct 2022 18:07:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 09/10] KVM: selftests: Expect #PF(RSVD) when TDP is
 disabled
Message-ID: <Y2AO7v5puszylEvv@google.com>
References: <20221031180045.3581757-1-dmatlack@google.com>
 <20221031180045.3581757-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031180045.3581757-10-dmatlack@google.com>
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

On Mon, Oct 31, 2022, David Matlack wrote:
> -static void guest_code(void)
> +static void guest_code(bool tdp_enabled)
>  {
> -	flds(MEM_REGION_GVA);
> +	uint64_t error_code;
> +	uint64_t vector;
> +
> +	vector = kvm_asm_safe_ec(FLDS_MEM_EAX, error_code, "a"(MEM_REGION_GVA));
> +
> +	/*
> +	 * When TDP is disabled, no instruction emulation is required so flds
> +	 * should generate #PF(RSVD).
> +	 */
> +	if (!tdp_enabled) {
> +		GUEST_ASSERT_EQ(vector, PF_VECTOR);
> +		GUEST_ASSERT(error_code & PFERR_RSVD_MASK);
> +	}

Probably worth adding

	} else {
		GUEST_ASSERT(!vector);
	}

to verify no fault occurs in the emulation case?  Or to avoid the inverted check,

	if (tdp_enabled) {
		GUEST_ASSERT(!vector);
	} else {
		GUEST_ASSERT_EQ(vector, PF_VECTOR);
		GUEST_ASSERT(error_code & PFERR_RSVD_MASK);
	}

It's mostly redundant with assert_exit_for_flds_emulation_failure(), but at worst
it'll help docuemnts the expected behavior in the TDP case.
