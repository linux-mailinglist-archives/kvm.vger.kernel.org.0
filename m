Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294A15E6FB8
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 00:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiIVWar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 18:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIVWap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 18:30:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D8CC996F
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 15:30:44 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so3882747pjq.3
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 15:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=3LeR1nT269sJJcUYveoa1HiOHt1+I3ptf4yRadnEJ3c=;
        b=X4K8xYQuTvq5xqR/zxD6UhmlyTduBgObz4I7dTr77R7HYBaXJP5d4aYRCmVqph8LMB
         3F2kmXhKSYUk5vAKT8+BjJ2muHQnUSkIZu8xSpvc8ckn1Re1kz2+bgC6a6Rh7yAGWo8r
         jvM7TL8rmQckHxFvF5WfxKiHHBt8ItMiBaUrN/srKeJitbkw5JkBm6QGNO2xPsCBcJA3
         iOwxzgWwrxoYU5vg8kce963V4vS4m9dP7n7F18rXaHivdZFVScqDz8+97/8fkwhMyAPA
         4LeZETx6S6f4a8jeBnY+l1y67liAdB4ffoPMFo96iXadTnPiDlXoWE0ZzL75rNtYUulr
         YNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=3LeR1nT269sJJcUYveoa1HiOHt1+I3ptf4yRadnEJ3c=;
        b=SoisRrhMiJGvZCbIWqDeo/51L7Qlte4ltAsnO2jZZhTM2EdI89tKZj4FB11cTovFq4
         /f78PUZzn0R7WtewIRIOffOcTw3oKAsrrbiN0bfrh3QItlG2FnTpdw8wEidnGK3fWpIo
         x/oVLqJ4Y3ILYfV+1M0xJ2kTjB8keaxFpaSQK6nSGbaRKMEHIvbNzailt0s+H5WszLIb
         m8JKHcLi78MTjoJD/mNHyOFoQ1ikZEp6V+KHhXKbdHP/Eo5uHBhUCzdU58z3vbX4Kx/P
         GZiEK7DV3GlmNF7CdTYEnqjFT1A64019HdTclkjxlNxBAVgF4MKVeBpZeHW8nFGNrbVX
         O+tw==
X-Gm-Message-State: ACrzQf27Tn+Hk3vizuoF2Pi6dxYyL7S+WwTcwCtuhCIeHYlA01WS7GKB
        1pZhRWJ2sW1umCnE9soVILHfAw==
X-Google-Smtp-Source: AMsMyM7Z89ZblA+Ate/tCp6mDGk+6FIFqvGtcQotvms/+O/VSwQUTb6PoHIhP5sCCLVDhi+dqSjZJQ==
X-Received: by 2002:a17:90b:390e:b0:202:affa:1c91 with SMTP id ob14-20020a17090b390e00b00202affa1c91mr17901398pjb.233.1663885843892;
        Thu, 22 Sep 2022 15:30:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f17-20020a17090aa79100b00203125b6394sm269723pjq.40.2022.09.22.15.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 15:30:43 -0700 (PDT)
Date:   Thu, 22 Sep 2022 22:30:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] KVM: x86/pmu: Avoid setting BIT_ULL(-1) to
 pmu->host_cross_mapped_mask
Message-ID: <YyziD28RXkBugT8e@google.com>
References: <20220831085328.45489-1-likexu@tencent.com>
 <20220831085328.45489-2-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831085328.45489-2-likexu@tencent.com>
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

On Wed, Aug 31, 2022, Like Xu wrote:
> +		hw_idx = pmc->perf_event->hw.idx;
> +		/* make it a little less dependent on perf's exact behavior */

Reworded this to explain how a negative value can be encountered.

> +		if (hw_idx != pmc->idx && hw_idx > -1)
> +			pmu->host_cross_mapped_mask |= BIT_ULL(hw_idx);
>  	}
>  }
