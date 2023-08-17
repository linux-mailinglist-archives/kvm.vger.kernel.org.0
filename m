Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AF878017A
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355970AbjHQXFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356010AbjHQXEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:04:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4216F2112
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:04:53 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589b0bbc290so3999247b3.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692313492; x=1692918292;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hS1zBff4CJqQpKtGoFuM9RpGEari+VKEFDh4dUpgboM=;
        b=s4J6qYsVz0J2xQZkaXuMZImQpXQ7CPB0achUXpAbHqN4dGRHvpb7ZZYuPyvXsjtWY9
         dx7ilbFHek6yGLM51YrtLWpfHagVFx1UAF6fKj8FSyJmXFZHsBK/qNBN3UjDmIRg9Hqa
         zPLrgroMVWQoq+is4OF7N0ZtEB+Gf9afhpMGEq0V4wNVq1LSijkVK3Ic9D70tD6KuNPC
         SDM5hjWkYjwX8deQ6Z+IiF8MBPp3qKyAyynaXuYNZsatSoDmmrC1G1OYjGjIOr3yMGn8
         49H5ReDHqoJhANUeqSJURQDiZaRKc0Px+1gkQpifPJEm4vd6Zzbj+79a5phZoSttuNXN
         Gyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692313492; x=1692918292;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hS1zBff4CJqQpKtGoFuM9RpGEari+VKEFDh4dUpgboM=;
        b=CjlKFj/E+cmwlrq4l5nojmwERxBcMFfDncp9cYSm1pYNCbNT6ZdcYO9T79WmeOaXya
         Vab9FnEoAoN+tnD96vpx/jbQrHx2lDRQJk/s3g73s08S6kdwVQFr3f4P3ZaoFOEM3KDj
         sqD2QJEbZpdhfTboq54jliLzk6NydbgxopI14uANCnlPMW9oF1xWqZg+v8s36VmGoHeb
         NR8/YRhd+DfuzFYgDkgX/vyfxOIAGi7Yh6pFzZRBFAvCRxZSzyqzJ0zAKsEXpVdo2qLO
         7CtILeVM/Q6Kw0Px0FHxYi4LhnGYicpXy+zWj6gHKIS+Y2r2MYSc6Pe726IHrNBqNkm7
         76tw==
X-Gm-Message-State: AOJu0YwJypTLgb8qFquab9pIZ+ulRVJ0w041Ts5+sgDrLhyutTTJBvIA
        LBaagHBdGShrJTT7Ce5u09XEk9oAAC4=
X-Google-Smtp-Source: AGHT+IFVjzPu9bwWZynt8tGrMum+4+Vgkq5DJnwOx8y+2Me6QX9EXbE7NI7V7scAdmY748LFNaNxA+9V2e8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad01:0:b0:d74:347:1da with SMTP id
 y1-20020a25ad01000000b00d74034701damr11495ybi.2.1692313492569; Thu, 17 Aug
 2023 16:04:52 -0700 (PDT)
Date:   Thu, 17 Aug 2023 16:04:50 -0700
In-Reply-To: <20230814115108.45741-7-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230814115108.45741-1-cloudliang@tencent.com> <20230814115108.45741-7-cloudliang@tencent.com>
Message-ID: <ZN6nkkZ7D/baOp+f@google.com>
Subject: Re: [PATCH v3 06/11] KVM: selftests: Test consistency of CPUID with
 num of fixed counters
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023, Jinrong Liang wrote:
> @@ -239,6 +272,14 @@ static void intel_test_counters_num(void)
>  		if (!perf_caps[i])
>  			test_oob_gp_counter(0, 2, perf_caps[i], 0);
>  	}
> +
> +	for (ecx = 0;
> +	     ecx <= kvm_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK) + 1;

This is the perfect time to use a local variable:

	for (ecx = 0; ecx <= fixed_counters_bitmask; ecx++)

> +	     ecx++) {
> +		intel_test_oob_fixed_ctr(0, ecx, GP_VECTOR);
> +		intel_test_oob_fixed_ctr(nr_fixed_counters, ecx, GP_VECTOR);
> +		intel_test_oob_fixed_ctr(nr_fixed_counters + 1, ecx, GP_VECTOR);
> +	}
>  }
>  
>  int main(int argc, char *argv[])
> -- 
> 2.39.3
> 
