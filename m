Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E24E4D9D5D
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349278AbiCOOXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349186AbiCOOXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:23:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C39C51313
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 07:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647354105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7o+dVXIRX3PUfrylBhmOJ1IjtNvLAddRpzAp+y2JIUg=;
        b=WOhyh8XP1l/hjKfz5hdopSnGBkyV1QY274NVD2veHhDkvg9Ufb6BaXDy67/JpyrUKbnyt7
        utPpM68+g/n4PpPoaoBUKwDhmEY2Z1Rs3NP5WiNWYjlodtIUMZapSo8znwdvFe2pWwnfFe
        YCfY3qNpdxNMMUACMgSxVbYoVT5nXXs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-ecvwVdxYO6KG1ovqVhjznA-1; Tue, 15 Mar 2022 10:21:43 -0400
X-MC-Unique: ecvwVdxYO6KG1ovqVhjznA-1
Received: by mail-wm1-f70.google.com with SMTP id k41-20020a05600c1ca900b00389a2b983efso6696788wms.4
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 07:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7o+dVXIRX3PUfrylBhmOJ1IjtNvLAddRpzAp+y2JIUg=;
        b=bihxrSSKm9CkkyPsoW6cjmRDmTA0awlrE4Cr42QOmJ7RutJMhxvwqo0yr+tOuRDEku
         lPzqjf+78t2EoZCjv0dTDx2tBJQd4s5fJ32xNeRc3ryQa6/JSd4Asexk7Tq48/uKpKWV
         /9PjyVjCqRXRVjhLnBl4aAajpeCYaz1j7O+0c06+xZBMt4wxcKj5cCAz8FtCKhgB5xwP
         qr7WK+CkGt0WHqkGtv0E8K8xeXEOVcL7eCAULfrnS4BTlDXQQLD0XHb2l4cDhUoGosZx
         GYM1/cwdtA6Zb4Uwp6A+cqC3dm6tK2bRZSgrPTzyHrWJn2YgTUrmJTGUwBj4SQ3wLIfE
         mKWA==
X-Gm-Message-State: AOAM533IWVA2o9om7u3M3RBAaqnui0avBH/ZywQSExjDcZSFz7UVFzI5
        p1Bgk1yvvUhtRj4JkNZdWBmPDuEHjyt6Ahucu2O5SJtXKEpXtChjKQzMVSTf/7hA+X3f8tg7cz2
        z9zFXslDqR/ie
X-Received: by 2002:a05:600c:4296:b0:38c:1b43:1562 with SMTP id v22-20020a05600c429600b0038c1b431562mr1352864wmc.122.1647354102767;
        Tue, 15 Mar 2022 07:21:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK6Yb1VdEQLbeaGqI3HGFeG6+S8T9reHNHXB33jwMdYCBjxnxNe7ZZesEpwCLsV4703roQaw==
X-Received: by 2002:a05:600c:4296:b0:38c:1b43:1562 with SMTP id v22-20020a05600c429600b0038c1b431562mr1352843wmc.122.1647354102505;
        Tue, 15 Mar 2022 07:21:42 -0700 (PDT)
Received: from [192.168.8.104] (tmo-098-218.customers.d1-online.com. [80.187.98.218])
        by smtp.gmail.com with ESMTPSA id c24-20020a7bc018000000b0038a18068cf5sm2363742wmb.15.2022.03.15.07.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 07:21:41 -0700 (PDT)
Message-ID: <b1d5e4b7-c07c-0e34-ef6d-58aab19a41b2@redhat.com>
Date:   Tue, 15 Mar 2022 15:21:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
        drjones@redhat.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     suzuki.poulose@arm.com, mark.rutland@arm.com
References: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/2022 14.33, Alexandru Elisei wrote:
> Hi,
> 
> Arm is planning to upstream tests that are being developed as part of the
> Confidential Compute Architecture [1]. Some of the tests target the
> attestation part of creating and managing a confidential compute VM, which
> requires the manipulation of messages in the Concise Binary Object
> Representation (CBOR) format [2].
> 
> I would like to ask if it would be acceptable from a license perspective to
> include the QCBOR library [3] into kvm-unit-tests, which will be used for
> encoding and decoding of CBOR messages.
> 
> The library is licensed under the 3-Clause BSD license, which is compatible
> with GPLv2 [4]. Some of the files that were created inside Qualcomm before
> the library was open-sourced have a slightly modified 3-Clause BSD license,
> where a NON-INFRINGMENT clause is added to the disclaimer:
> 
> "THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
> WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
> ARE DISCLAIMED" (emphasis by me on the added clause).
> 
> The files in question include the core files that implement the
> encode/decode functionality, and thus would have to be included in
> kvm-unit-tests. I believe that the above modification does not affect the
> compatibility with GPLv2.

IANAL, but I think it should be ok to add those files to the kvm-unit-tests. 
With regards to the "non-infringement" extension, it seems to be the one 
mentioned here: https://enterprise.dejacode.com/licenses/public/bsd-x11/ ... 
and on the "license condition" tab they mention that it is compatible with 
the GPL. On gnu.org, they list e.g. the 
https://www.gnu.org/licenses/license-list.html#X11License which also 
contains a "non-infringement" statement, so that should really be compatible.

  Thomas

