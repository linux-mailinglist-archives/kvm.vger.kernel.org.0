Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570B76DB519
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 22:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjDGURx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 16:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjDGURt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 16:17:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9817CC169
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 13:17:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c193-20020a25c0ca000000b00b868826cdfeso18093841ybf.0
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 13:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680898650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GQuRZgPGJuitZmRAmEtDKVZTfZ/GI8B6WfCH2oCyJ+I=;
        b=ZZ3hqBxL9WVZAvP90AtF0BooyPBWkw2PZ8Y09ncxA3vHcu6fouEUcK87ddDFl0co0h
         T3UHrMGzgIuXAigPIiYpmAg72GsT60rODXzTKnHWWBgFkbkEB93gMF7UczHwGDODlzQo
         2DquEVw9OOnmuZ5CN62zSh4X0qV1bLFFZF8vDQc6/r6QChWWSCUavUZu85yESCaZWV13
         SA/BG+R/TVsQlSD5V+6H7DNnldRkNP/bCux0R6KMyzHcxhoVNwwqTG4Dn4VVtZuaX9N0
         SPulOGt3IgyLTEYMBZ/T6qbkbwn+I08u7V+RA8CcwDkhCcN2GthhJ6kW5RNWwDOwBtAG
         ExZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680898650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GQuRZgPGJuitZmRAmEtDKVZTfZ/GI8B6WfCH2oCyJ+I=;
        b=nnBJX6wij38P/iGTbs6vjfNmO5u+60pvMHbO7w5BbiYShdheT7Io1uXHyqcQ6rkDpm
         sviehZ0WHKe/OlS/q9hPtu9euy/7Q6SNzjL2uYFQlPw210i5CuEGxsLaOoLQpY3N7/Ui
         E2wI7SW7vBgCgZPTokHosg/1/cYe5g/XYWe3zwB5anMRmJKBzU5mtp6UXqbK+uGCkMFF
         fWQzkFETEQG3Hg3n9vETs1mcKpL7gcHSSzxBjfA9Sl3Xyqtduk8/U9CEqVtH1oVvKZyw
         i2N1IIuwsSnDnZCtEUo53XJOhKOaUXKo5m/PVZLEeA/MCezb5mhPxOzYjW2TxEhXGXSG
         H6Og==
X-Gm-Message-State: AAQBX9fUeSHadZ0x5xaze4mIOgAVZYiDICbzI251abik5fzSqTVGGdho
        MFIrI8YOhWBVX8DrIIkpkJol+mwZufw=
X-Google-Smtp-Source: AKy350ZWV2a/5GlWKI7vC948ULh+ZhhIsFkaZ7AayvqB83aRn4iAdoyo6h5iYZVHBZ3Bxmet3ID/x7RFsuI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:909:b0:a27:3ecc:ffe7 with SMTP id
 bu9-20020a056902090900b00a273eccffe7mr5154367ybb.3.1680898650818; Fri, 07 Apr
 2023 13:17:30 -0700 (PDT)
Date:   Fri, 7 Apr 2023 13:17:29 -0700
In-Reply-To: <20230307141400.1486314-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com> <20230307141400.1486314-6-aaronlewis@google.com>
Message-ID: <ZDB6WWhpl6b4/2M9@google.com>
Subject: Re: [PATCH v3 5/5] KVM: selftests: Test the PMU event "Instructions retired"
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        like.xu.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023, Aaron Lewis wrote:
> @@ -71,6 +86,16 @@ static const uint64_t event_list[] = {
>  	AMD_ZEN_BR_RETIRED,
>  };
>  
> +struct perf_results {
> +	union {
> +		uint64_t raw;
> +		struct {
> +			uint64_t br_count:32;
> +			uint64_t ir_count:32;
> +		};
> +	};
> +};
> +
>  /*
>   * If we encounter a #GP during the guest PMU sanity check, then the guest
>   * PMU is not functional. Inform the hypervisor via GUEST_SYNC(0).
> @@ -102,13 +127,20 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
>  
>  static uint64_t test_guest(uint32_t msr_base)
>  {
> +	struct perf_results r;
>  	uint64_t br0, br1;
> +	uint64_t ir0, ir1;
>  
>  	br0 = rdmsr(msr_base + 0);
> +	ir0 = rdmsr(msr_base + 1);
>  	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
>  	br1 = rdmsr(msr_base + 0);
> +	ir1 = rdmsr(msr_base + 1);
>  
> -	return br1 - br0;
> +	r.br_count = br1 - br0;
> +	r.ir_count = ir1 - ir0;

The struct+union is problematic on 2+ fronts.  I don't like that it truncates
a 64-bit MSR value into a 32-bit field.  And this test now ends up with two
structs (perf_results and perf_counter) that serve the same purpose, but count
different events, and without any indiciation in the name _what_ event(s) the
struct tracks.

The existing "struct perf_count" has the same truncation problem.  It _shouldn't_
cause problems, but unless I'm missing something, it means that, very theoretically,
the test could have false passes, e.g. if KVM manages to corrupt the upper 32 bits.

There's really no reason to limit ourselves to 64 bits of data, as the selftests
framework provides helpers to copy arbitrary structs to/from the guest.  If we
throw all of the counts into a single struct, then we solve the naming issue and
can provide a helper to do the copies to/from the guest.

I have all of this typed up and it appears to work.  I'll post a new version of
just the selftests patches.
