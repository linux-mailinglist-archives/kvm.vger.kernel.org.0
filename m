Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068625FCB75
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 21:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiJLT01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 15:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJLT0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 15:26:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE1610253C
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:26:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so2915306pjs.0
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yKhd77aE9FxKmDeyge745PTZfH7Tfb3ksdLKanaCShs=;
        b=CP72G6Nr3eYtKfWKx5+L3V/sQ5ZQ5/NEy0Fr78bWzoT7X75m1k7iC9a1R4SmOFmzLk
         w3qZ5Zn7Nt9NEGB83O4K8JbyuZhm+jDZLV+sHShXEv+JdHDvcvXlkxIG7UpTisSS6gH3
         +3hpyeNTpnS+wQiYk4zfVVEUbywUg5QniFBqz9jOStucegShUf04L+J2WuEsmNgQbR9I
         5wanyc0Zax4ySc0T008EcFSf8Flx0oQOaPq8vZ0+LXMBE4MX2+mcJQirVLPZqSczjklE
         aPH2il5PdxYATiZKZZPFu3h64szHF3cOqoGudlIFkFpo4668WgQqrPn1VPRxdWuOCYC/
         07Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKhd77aE9FxKmDeyge745PTZfH7Tfb3ksdLKanaCShs=;
        b=sB1PsEWHcBcD36PR0S65KqqPaIuGZtpIp4KVJJpQRdq3f6hraMs/cc7974a3VGc6XB
         H7yt7ReSfNi3rtVfqoJwYpPgljP1VJutq81e8X0MB/cJsvJZ1ukrjTOcUHc0JOHNTXtj
         HSZ83bOkjNq6GOWf18HqriWNDwNrTLRYQxQpwyKQCXOmD3pjc4N/HbBPL0Av3NQvv6g2
         iiYOlZEVEi6hMm69LH1XY1Y1Jj6N2iGvhGTlxBtWCjjLeEbmzKTLLk/uUi/RINN1Kl37
         e3ox2OvqGOC6APNl93bqQ4rqaF6m2dp/ib+5tIlNy6w7LDjeh5yZ7QiVxzUObqFZ5iGF
         VYhA==
X-Gm-Message-State: ACrzQf0VvMuNRjL8HUyxWcGPnMG3U2GsUPvVThyoUiVxdKr7Jh6NwK/L
        ML96eFqaTgj7i9XuMbkqOc9tZA==
X-Google-Smtp-Source: AMsMyM5SnhzolXIM1saAHHUOsn8tvu5a8FJZUC9dMOqmvWJUcVzQfCfCBInGJkUL2JC4qzj67bFZTQ==
X-Received: by 2002:a17:90b:388c:b0:20a:9c33:dd2b with SMTP id mu12-20020a17090b388c00b0020a9c33dd2bmr6615228pjb.225.1665602781542;
        Wed, 12 Oct 2022 12:26:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bn22-20020a056a02031600b00460ea630c1bsm7028759pgb.46.2022.10.12.12.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 12:26:21 -0700 (PDT)
Date:   Wed, 12 Oct 2022 19:26:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Rename perf_test_util symbols to
 memstress
Message-ID: <Y0cU2WBlWNzuLl9n@google.com>
References: <20221012165729.3505266-1-dmatlack@google.com>
 <20221012165729.3505266-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012165729.3505266-4-dmatlack@google.com>
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

On Wed, Oct 12, 2022, David Matlack wrote:
> Replace the perf_test_ prefix on symbol names with memstress_ to match
> the new file name.
> 
> "memstress" better describes the functionality proveded by this library,
> which is to provide functionality for creating and running a VM that
> stresses VM memory by reading and writing to guest memory on all vCPUs
> in parallel.
> 
> "memstress" also contains the same number of chracters as "perf_test",
> making it a drop-in replacement in symbols, e.g. function names, without
> impacting line lengths. Also the lack of underscore between "mem" and
> "stress" makes it clear "memstress" is a noun.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
