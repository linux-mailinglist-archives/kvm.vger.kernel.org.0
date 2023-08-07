Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FF3771ADD
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 08:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjHGGz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 02:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjHGGz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 02:55:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB2B10C2
        for <kvm@vger.kernel.org>; Sun,  6 Aug 2023 23:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691391311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ho4TOU4xYIxDlaPGJbh5CdW3AQ8AoyQ6uWHEuuD2FN8=;
        b=EtdXRM4yeC78nWtoSOjY7HKWOJs0LUIYE+RYB6WK83f16gVrLAZ3TaC7TEyj1upFP2C8sL
        C90m6osz6c6pmxm6IS2km9S+nYOgxLUf6o7PnsXI6DJrshgr2MLJf/6/VddvyssgBqDCau
        m0n3LlIvVOM4K+OnMkTmofxUyk+/ARo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-BdHuYztnOb2dHiXsmcMfTQ-1; Mon, 07 Aug 2023 02:55:10 -0400
X-MC-Unique: BdHuYztnOb2dHiXsmcMfTQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-317c8fbbd4fso1990899f8f.3
        for <kvm@vger.kernel.org>; Sun, 06 Aug 2023 23:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691391309; x=1691996109;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ho4TOU4xYIxDlaPGJbh5CdW3AQ8AoyQ6uWHEuuD2FN8=;
        b=fntjBgUiXRthPffXof5SQGiK2px2EZ0fptsEGWOHcIdi1wSrliOdSkZHbey6JObSa+
         NOsDUjzbLQIbbgiFeUcg13raYhLBuECKQ7QtbI0vvAH74791YxGlU6Lh3Yu0LBok3zYi
         YHMTSOgZTsTTxNB1pD+j/uSWpP55RMR06NAlXXICmRbnG3/O6Qf9zc2VwXsaziu/26p8
         1xjGHNtpQpH0dtXf8bEiSZtxYuPEmiBQIDUyFTISJEbko31O00xZ9dO6LKVv4zFsizsR
         QOVJghlT0ZOEy7oqMEn19HuOqvuBP/XUzOI0I5dRo5YUD6dSAk6GYn6wlEbrEbHg3oxQ
         cd7g==
X-Gm-Message-State: AOJu0YxXwyZC6z0zAyjUgKdNDxUddv5guyPO/omxztZW7MPWQSJUGgfR
        yVaRnQmtxa+eF4WE6621fWdg6lewyOPHS0/1O6ZFrhEcXh/Kop1Zw56J63FH/v7Iv1QgN3pzcYf
        bXOauJ/kM9YoF
X-Received: by 2002:a7b:c3c1:0:b0:3fa:96ad:5d2e with SMTP id t1-20020a7bc3c1000000b003fa96ad5d2emr6236055wmj.19.1691391309012;
        Sun, 06 Aug 2023 23:55:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbqsyRD6exvzZaZpz4Zzq7W+cysAHnnx6rDqQMGoLvuKnifa+ME2mPeuNFLtkftztRZe1Otg==
X-Received: by 2002:a7b:c3c1:0:b0:3fa:96ad:5d2e with SMTP id t1-20020a7bc3c1000000b003fa96ad5d2emr6236048wmj.19.1691391308715;
        Sun, 06 Aug 2023 23:55:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id z10-20020a05600c220a00b003fba6a0c881sm14113789wml.43.2023.08.06.23.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Aug 2023 23:55:07 -0700 (PDT)
Message-ID: <763f3b3f-861e-1716-f65f-1b4f256590c5@redhat.com>
Date:   Mon, 7 Aug 2023 08:55:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        chao.gao@intel.com, binbin.wu@linux.intel.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-5-weijiang.yang@intel.com>
 <ZM1C+ILRMCfzJxx7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZM1C+ILRMCfzJxx7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 20:27, Sean Christopherson wrote:
> I think my preference is to enforce guest CPUID for host accesses to 
> XSS, XFD, XFD_ERR, etc I'm pretty sure I've advocated for the exact 
> opposite in the past, i.e. argued that KVM's ABI is to not enforce 
> ordering between KVM_SET_CPUID2 and KVM_SET_MSR. But this is becoming
> untenable, juggling the dependencies in KVM is complex and is going
> to result in a nasty bug at some point.

Fortunately, you are right now.  Well, almost :) but the important part 
is that indeed the dependencies are too complex.

While host-side accesses must be allowed, they should only allow the 
default value if the CPUID bit is not set.

Paolo

