Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7DA5187D5
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237797AbiECPIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237777AbiECPIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:08:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 820DF3A1BD
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 08:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651590285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q8KRyeOIJowwgq1LjuL92i0OyzQpFO6OlQ5jrqBwiaQ=;
        b=Rovcr81/5KAo4tVSPx96XPu2Xw4AQ7rQUc9sSTnkkisFAeIH9EHPb/u0ofh3JlKe/Nzpci
        36RjBjOAXp3XZLfGJbn6UyQn+ZWuFNDMLeQd+M31cncjVEvXoRcPgvtbxjkZwjgRuf0ajr
        rubaR0lRe4nCUncNU+xBewFQyKtFB04=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-UWXjStHVNZ29L_w4hTKO6g-1; Tue, 03 May 2022 11:01:23 -0400
X-MC-Unique: UWXjStHVNZ29L_w4hTKO6g-1
Received: by mail-wr1-f69.google.com with SMTP id s8-20020adf9788000000b0020adb01dc25so6440596wrb.20
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 08:01:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=q8KRyeOIJowwgq1LjuL92i0OyzQpFO6OlQ5jrqBwiaQ=;
        b=sq8HO2bKc6BaNqnOSV0sfv3EfHra82XsBAiKUSSarRsotls8CZmWkB0FGryz5fSN7Y
         d913gk6vsyRhwKbiOa42VwHeFdxH4wKQTNuQRr/r/BWEt8dTutqa9PoPusrMWusWF9M2
         L/G1uG66fsHozysLMIdyXwaShkzR8uX4uROvuM/NCqPCr1TZa1TKya2awoivnGgZ458T
         zcVPWlEA4llftiNNQn7zprAOhkBfsr7oz8Dbg6ixj3GG3HKmUOAcb9ybYJy7mQutQdzK
         uII2OTHs9aBh/9YAaGY4zX0CXkC9a9WlPeWUNc1qRlhY7w47bRIpksEAyI2uUBnn5kLo
         JiTg==
X-Gm-Message-State: AOAM533IXBoz79xnJGgJRfLTj2XGk651l2/KpgvK5vSy8RhHcLkCOqI/
        5YfY1AqARMAfv8wR0zMIsyPSNGwzRkIS8W2CQmqGjs06wLRLsLl/PFj6kOMhC0cl5C5QGJH8oY8
        CPE9UIxljd7mm
X-Received: by 2002:a5d:64c1:0:b0:20c:6ff9:3a61 with SMTP id f1-20020a5d64c1000000b0020c6ff93a61mr4770683wri.709.1651590080935;
        Tue, 03 May 2022 08:01:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFddadb0RhMqbED3cKhIrdL1UAliMUxLFrwK6VNOQYuEXW0q5ELPbxKJShs+8DVKmBmOBFgQ==
X-Received: by 2002:a5d:64c1:0:b0:20c:6ff9:3a61 with SMTP id f1-20020a5d64c1000000b0020c6ff93a61mr4770661wri.709.1651590080743;
        Tue, 03 May 2022 08:01:20 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t1-20020adfba41000000b0020c6fa5a797sm3344358wrg.91.2022.05.03.08.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:01:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/34] KVM: x86: hyper-v: Fine-grained TLB flush + L2
 TLB flush feature
In-Reply-To: <20220414132013.1588929-1-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
Date:   Tue, 03 May 2022 17:01:19 +0200
Message-ID: <87bkwe3bk0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Changes since v1:

This should've beed 'since v2', obviously.

...

>
> Currently, KVM handles HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} requests
> by flushing the whole VPID and this is sub-optimal. This series introduces
> the required mechanism to make handling of these requests more 
> fine-grained by flushing individual GVAs only (when requested). On this
> foundation, "Direct Virtual Flush" Hyper-V feature is implemented. The 
> feature allows L0 to handle Hyper-V TLB flush hypercalls directly at
> L0 without the need to reflect the exit to L1. This has at least two
> benefits: reflecting vmexit and the consequent vmenter are avoided + L0
> has precise information whether the target vCPU is actually running (and
> thus requires a kick).

FWIW, patches still apply cleanly to kvm/queue so probably there's no
need to resend.

-- 
Vitaly

