Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48F44F925A
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 11:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiDHKAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiDHKA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:00:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F81D1667F8
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 02:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649411862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mH2i018ZLKeROXjPydLg+JwdBsSW5UIxuPk6RCgVY6A=;
        b=gAxqJB+PQ1RFR/MHUhL/+/YY3u3e5ai4M+shJ8tYdFU81nXdxQuEhNMKm4H1BzjlbNhZtE
        Pk0AH0nfAUtANXPuRkNsMB6hokFctuEcoYUKjQY6WsKAeIqLbBxxbGW998To1raZGa3Jy8
        Pgv/nX3lJxJYkNBsRb8rkUI74Rqbiys=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-hP8bqqkSMpS3NIkQuOhHLw-1; Fri, 08 Apr 2022 05:57:41 -0400
X-MC-Unique: hP8bqqkSMpS3NIkQuOhHLw-1
Received: by mail-wr1-f72.google.com with SMTP id a14-20020adfc44e000000b002079930e9f5so240732wrg.23
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 02:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mH2i018ZLKeROXjPydLg+JwdBsSW5UIxuPk6RCgVY6A=;
        b=sEJaQaCYCtFMlBxAWbnwR+7788681eOUQ8pNPaLR7OwQXhjZrk0TUTdtE4sKzvDi04
         zDZ9O22a/5Zu+VatCo9byERp+6yzTiGSC+fAMhih3q67QdCsLBnJTqgxQz1p1SAhHulH
         x2Cvrv0PkoQxV0yfErL6nNx68qdNW3PKFwsU4baB9R95BTOGsQZzJRm/YKlKj+7v4ayb
         l47Eg4qoqmCFA6wXRUClOkJnMsn4IhK1vmZlhYxAwCTTOPGpYfoyIG7cHMhTT0fgLG5f
         usXv2tMvuhSiONuYPnhDyj8JMqQBxPxCq8aZljASOUf3pWSdks0fmQvcOSJb1KtWZONU
         5m1g==
X-Gm-Message-State: AOAM533i+LU84qagWlIV3kb4+727waDuuDQ001YjxK1Jc18ma5UsP+GB
        tzGouyNXNttYmwBQUc0d17aPa0vT11slYeXnhdpP047vXyminoWSrVB5gvQH0Il/kRr7PXSeNYs
        d5+MwcfaqDfN3
X-Received: by 2002:a5d:430c:0:b0:206:1c68:fd05 with SMTP id h12-20020a5d430c000000b002061c68fd05mr13859430wrq.364.1649411860290;
        Fri, 08 Apr 2022 02:57:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyohjhMmNdnUYaKuavZd9Ta0r0z7JtR69qqk7n9Q6SmG2ATtU9i78tWm66dyMtAfNBM7jTZng==
X-Received: by 2002:a5d:430c:0:b0:206:1c68:fd05 with SMTP id h12-20020a5d430c000000b002061c68fd05mr13859416wrq.364.1649411860011;
        Fri, 08 Apr 2022 02:57:40 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id v8-20020a1cf708000000b0034d7b5f2da0sm9946894wmh.33.2022.04.08.02.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 02:57:39 -0700 (PDT)
Message-ID: <27a59f1a-ea74-2d75-0739-5521e7638c68@redhat.com>
Date:   Fri, 8 Apr 2022 11:57:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 092/104] KVM: TDX: Handle TDX PV HLT hypercall
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
 <282d4cd1-d1f7-663c-a965-af587f77ee5a@redhat.com>
 <Yk79A4EdiZoVQMsV@google.com>
 <8e0280ab-c7aa-5d01-a36f-93d0d0d79e25@redhat.com>
 <20220408045842.GI2864606@ls.amr.corp.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220408045842.GI2864606@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/22 06:58, Isaku Yamahata wrote:
> On Thu, Apr 07, 2022 at 05:56:05PM +0200,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
>> You didn't answer the other question, which is "Where is R12 documented for
>> TDG.VP.VMCALL<Instruction.HLT>?" though...  Should I be worried? :)
> 
> It's publicly documented.
> 
> Guest-Host-Communication Interface(GHCI) spec, 344426-003US Feburary 2022.
> 3.8 TDG.VP.VMCALL<Instruction.HLT>
> R12 Interrupt Blocked Flag.
>      The TD is expected to clear this flag iff RFLAGS.IF == 1 or the TDCALL instruction
>      (that invoked TDG.VP.TDVMCALL(Instruction.HLT)) immediately follows an STI
>      instruction, otherwise this flag should be set.

Oh, Google doesn't know about this version of the spec...  It can be 
downloaded from 
https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html 
though.

I also found VCPU_STATE_DETAILS in 
https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1.0-public-spec-v0.931.pdf:

   Bit 0: VMXIP, indicates that a virtual interrupt is pending
   delivery, i.e. VMCS.RVI[7:4] > TDVPS.VAPIC.VPPR[7:4]

It also documents how it has to be used.  So this looks more or less 
okay, just rename "vmxip" to "interrupt_pending_delivery".

The VCPU_STATE_DETAILS being "non-architectural" is still worrisome.

Paolo

