Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F4A62393C
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiKJBx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiKJBxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:53:52 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F655FA5
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:53:51 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id io19so316239plb.8
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xZdzpZw/ENWxCqA4wlnghR1lTnm3T7o1w8LSdyqeUPk=;
        b=UPkpteuWjTrqlV3M5V4vaPe9d6OavmhLwikc4tWfiwKfNaZiBFfi2Csm1ku7MY8H7J
         etYkc1QOpDv5M3I2m7CaIQaPTSAjtZjJ1+4FecEorAglf6qbBU4PwGaHsNsA6CU27KMj
         r36PtKU7hLfM2xTm3+dD9ROUl1J2y3eI4wc6x6DV2F5KnNWYWAXNvlE6AHlrz49FixPk
         aS6rM/xac+GtY/4zzaLMzNQCnL1T/fjzBNpCqzxH0wGIgo2UhYgGV/BW4o88ZLxumsy9
         590PrOqT54KiDdHsDWrsQljP9vn5yKgIMvj1gRu84glTTQ/9PvSkIZWWk/cJauVobT9T
         9M2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZdzpZw/ENWxCqA4wlnghR1lTnm3T7o1w8LSdyqeUPk=;
        b=vsZLaWBotsLRd04H8Haz6o27LY6qm/l0tDR1BRLKgQ0/0OBzr/nkD7ApB7VJ1m3NBS
         aEgFYyZ4QQVI3bzeMKaahO6UmsHFYFuYLCRcliN1Xk1WrZhJm2KzbNfWNTLmXq/t0ZT1
         Hevn9a/uXezN9BGD/xBVP8PXGoLIpTMs5rdHD0d7EIC3DDSfIASw0QMGE38lzY1lZv0U
         Vzvu6HdBaIu879bo6mG5u21cY871eN4RGwefHT6xZvYYT4FXR8rHDrQspKjR0s63We+3
         PUvnVhrACvwGEfhLMxEovBrwysCb8JayRzzdKKYH4Dk+MZ5ZQP0aIwHsV0aVo7TNra1R
         5kiA==
X-Gm-Message-State: ACrzQf3BOKTkHv1FPhid8TPS3d6aHRXCLOwrBso4AgrMz2y4OJKqapYB
        ijeGp/I68nE5TMKVZFB+qbitLA==
X-Google-Smtp-Source: AMsMyM6bFJovHbW/ieNf3ywfnz9QlzCJ2EdGSnCZT3CdD0YZxRb6o0ucoGNEwDnq375jB4W31r6Hfg==
X-Received: by 2002:a17:902:bc83:b0:187:85a:28b4 with SMTP id bb3-20020a170902bc8300b00187085a28b4mr61860660plb.96.1668045230870;
        Wed, 09 Nov 2022 17:53:50 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s5-20020a170903200500b00172cb8b97a8sm9792882pla.5.2022.11.09.17.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 17:53:50 -0800 (PST)
Date:   Thu, 10 Nov 2022 01:53:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: do not prepare new memslot for KVM_MR_DELETE
Message-ID: <Y2xZq8Xn0Bk4de+R@google.com>
References: <20221110012204.3919-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110012204.3919-1-yan.y.zhao@intel.com>
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

On Thu, Nov 10, 2022, Yan Zhao wrote:
> kvm_prepare_memory_region() is not useful for KVM_MR_DELETE,
> and each kvm_arch_prepare_memory_region() does nothing more than returning
> 0 for KVM_MR_DELETE.

This is not true, s390 has an error path that fires in the DELETE case.

	/* When we are protected, we should not change the memory slots */
	if (kvm_s390_pv_get_handle(kvm))
		return -EINVAL;

	if (change == KVM_MR_DELETE || change == KVM_MR_FLAGS_ONLY)
		return 0;


> So, just don't call into kvm_prepare_memory_region() to avoid unnecessary
> error handling for KVM_MR_DELETE.

Even if the s390 case didn't exit, I would still prefer keeping the code as is.
I agree that a "dummy" call is somewhat confusing, but skipping the arch call
for one operation is equally confusing and could easily lead to future bugs,
e.g. if the order of changes were reversed and an s390 developer wasn't aware
that s390's arch hook would be bypassed on memslot deletion.
