Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8708D50E1C2
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 15:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242090AbiDYNdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 09:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240542AbiDYNdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 09:33:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DD0F26559
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 06:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650893402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ysjpn5GurDC9K04LZuM1iXJthxfVvp1YJZ3HYeR+zo=;
        b=dn30iG6bZ+sG85PGWjE8fiqIV6v5eH3Gq654DlrczaWRo1g3pLmDpKjlA05kxIM8UM00TD
        wlJsKfyyL+Jk31srMdkyhUlGwGtyW6iaDgqNy7spzyzo/zpw8oAYaHOvHmqlaSDKOfpyuT
        ySvsjIzZEyxyGGAQyshx9JE0c1Gh6XA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-4yDbiNSaMRCPeqGLskkRWw-1; Mon, 25 Apr 2022 09:30:01 -0400
X-MC-Unique: 4yDbiNSaMRCPeqGLskkRWw-1
Received: by mail-wm1-f70.google.com with SMTP id n186-20020a1c27c3000000b00392ae974ca1so3074wmn.0
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 06:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2ysjpn5GurDC9K04LZuM1iXJthxfVvp1YJZ3HYeR+zo=;
        b=IDGBolGkCyGr8BzXtpKIHCyVXY/fY27Fs7sMrQ1aVnz6WhYfEqnH2QDU/ouZlG1GfI
         H2vCGfrTqPsnM3/2O80zQL4JyuZPnSbDlHUTEH9xyH1FLAJIjbwi0gw/FgH91a2OVKVQ
         IGwj2UFdul9FDEQ+ujDBvCDZUbwlmMvhiuuiNzTCXgl1bIkJ0voQNPCxR7wn2ZiqxB2W
         S+ZBwQjU6j26nCSuwi5t/qmRTyabaTa1Cc5K3rnRQ0bvI46/HHc6KMCsd5nJn2/w89L8
         Im9QDhIpH0LMz8FO884glfI3QPsjNnssFnVkemd6NJ1/R3dfODec9Nl8qo8D+PnxWKRY
         FlJQ==
X-Gm-Message-State: AOAM5325O3eZZ5+lMhoo3E6bHUGFsvnqzUv2FsqOGkrx7fdTQ7yq/ar8
        LFKbDyQ4EKbFIaIHmslxSHDqnbl8uOe68E5jR2/BIhtEtT/3u2UI+fs6vaudT8h7mFa/x54nm1M
        rRsHdv0GG+paD
X-Received: by 2002:a5d:584f:0:b0:20a:83aa:ad2a with SMTP id i15-20020a5d584f000000b0020a83aaad2amr14778251wrf.610.1650893400056;
        Mon, 25 Apr 2022 06:30:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyB26ThkGATvZ4h88Pq1rEn0Bl6acuGFnadbKgKghFn8mGUwtq7J8BvXFzA83LeFHXja0gk1A==
X-Received: by 2002:a5d:584f:0:b0:20a:83aa:ad2a with SMTP id i15-20020a5d584f000000b0020a83aaad2amr14778234wrf.610.1650893399876;
        Mon, 25 Apr 2022 06:29:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id l6-20020a1c2506000000b0038e6fe8e8d8sm10873123wml.5.2022.04.25.06.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 06:29:59 -0700 (PDT)
Message-ID: <d87652a4-660b-ce49-005c-adfda0537d29@redhat.com>
Date:   Mon, 25 Apr 2022 15:29:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests RESEND PATCH v3 8/8] x86: nSVM: Correct
 indentation for svm_tests.c part-2
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org
References: <20220425114417.151540-1-manali.shukla@amd.com>
 <20220425114417.151540-9-manali.shukla@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220425114417.151540-9-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/22 13:44, Manali Shukla wrote:
> +			if (r->rip == (u64) & vmrun_rip) {

This reindentation is wrong (several instances below).

Paolo

