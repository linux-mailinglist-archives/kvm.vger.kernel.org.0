Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECBE6E8CC0
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 10:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbjDTI2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 04:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbjDTI2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 04:28:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68D93AA6
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 01:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681979290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTDSYPbnwlYvYfAM1Oq9HYr46x4MyYy/YhuRhYjz+G4=;
        b=gsp9zypevPgAyY3p2lFzL5P93bvqGOREdj2ib/w7lJA1GomVi62BNLJC6vYoHe1jvOOOGg
        UsMKqQ4Qoh0OHAOpRajjdYvwaowxxUidAUIvLTL6EQrJeUuDDsmf18SrtUJaesXgytV3xi
        ml86Oh6flkEM3R0cdLlodq/Tqc1+gwI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-nCQAmjxaPW2BEG0k6xsq4w-1; Thu, 20 Apr 2023 04:28:08 -0400
X-MC-Unique: nCQAmjxaPW2BEG0k6xsq4w-1
Received: by mail-wm1-f71.google.com with SMTP id fl8-20020a05600c0b8800b003f16fe94249so1867716wmb.9
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 01:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681979287; x=1684571287;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTDSYPbnwlYvYfAM1Oq9HYr46x4MyYy/YhuRhYjz+G4=;
        b=agZJQwG4pyKli9R8Agx53iWr02qSM7SzV6PtHWhWDl0omgkSKjVtkL9STjlIl0TsBc
         sDM7BKebp1DO0rsvka//fPfbXTqvzwfboqWT2Fj3ISk+LOLUyjw16JO2PffSXrBUALzM
         g+m3Cq5zWvUu830LFucP6jfffw5dnofaQryCPZ03Yi/sXXf5AgFI+OhkfVA11gMJ+lnk
         qRw30DNq/IxjGKduW/CENsorShMQoCtH4R8/2fK6V4RpsBiR+IpSV4frdU8iiMIYiTkr
         wB0UOcnYcC92gct9yRDTx2Pfa5Hoge8DA9uttw7kj2X0/OXoZS7rvLIq97ryRZRZ6af7
         Mskw==
X-Gm-Message-State: AAQBX9deUaE5YfOJp9h03MV1wsDJ8oi8t+9z8V9fjXjN9IVvNZqZKE1D
        kF6VAZvDNw1oIyIYrA2Itnw7VRK51bCEyVdIVVegNqBdKjvEVeY9O8nxRxHORCNFNJ6/gXxB4g7
        7TN+oqYppsZri
X-Received: by 2002:a1c:7414:0:b0:3f1:795d:8f00 with SMTP id p20-20020a1c7414000000b003f1795d8f00mr647875wmc.23.1681979287406;
        Thu, 20 Apr 2023 01:28:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350a4h3rjRuVu4u2iNxa0BsKCCZtNln8D8avNEAlTJLmF42EJEmT3E33abaHmG3IOLVBQ429JJQ==
X-Received: by 2002:a1c:7414:0:b0:3f1:795d:8f00 with SMTP id p20-20020a1c7414000000b003f1795d8f00mr647856wmc.23.1681979287098;
        Thu, 20 Apr 2023 01:28:07 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-20.web.vodafone.de. [109.43.178.20])
        by smtp.gmail.com with ESMTPSA id m18-20020a7bcb92000000b003f182973377sm1266750wmi.32.2023.04.20.01.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 01:28:06 -0700 (PDT)
Message-ID: <2e770feb-59d6-4b67-12ff-a2646ccc2079@redhat.com>
Date:   Thu, 20 Apr 2023 10:28:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Improve stack pretty printing
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>
Cc:     kvm@vger.kernel.org
References: <20230404185048.2824384-1-nsg@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230404185048.2824384-1-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/04/2023 20.50, Nina Schoetterl-Glausch wrote:
> I noticed some bugs/deficiencies in the pretty_print_stacks script.
> Namely, it doesn't cope with 0 addresses, which might occur on s390x
> when backtracing through a interrupt stack frame. Since an interrupt is
> not a function call, the calling convention doesn't apply and we cannot
> tell where the stack is.
> 
> Additionally, the script stops printing the stack if addr2line cannot
> determine the line number, instead of skipping the printing of the
> source.
> 
> Lastly, the file path determination was broken for me because I use git
> worktrees and there being symlinks in the paths.
> The proposed change works for me and fixes the issue.

Thanks! Since there were no objections or other suggestions, I went ahead 
and pushed the three patches now.

  Thomas


