Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F125A657A
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiH3Nt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiH3NtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:49:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA6425CC
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661867221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xSYsGT+JuRUnE0x8Uu6rvpfH2JA8fm0UMDh7oy78WJU=;
        b=iYFRrTUSsHmXd1Xmy2vgR5SJ6VVFsnD+J42GWk7CJfvfjPz9tWZjW6aGevQV2IsNNMlUto
        uLwaE8LM1xkOwLTugCC5Ykt5jxLmwrYezZxJ1LiniZA7sdIaI3U2Jw87hQzyLwnZhhfJ5F
        HPi0Tia2u9jBTTE9RWv9tSsqWnwcBYY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-216-YKWDRl1QO0ylJCCxC6JrvA-1; Tue, 30 Aug 2022 09:43:45 -0400
X-MC-Unique: YKWDRl1QO0ylJCCxC6JrvA-1
Received: by mail-wr1-f70.google.com with SMTP id t12-20020adfa2cc000000b00224f577fad1so1763741wra.4
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=xSYsGT+JuRUnE0x8Uu6rvpfH2JA8fm0UMDh7oy78WJU=;
        b=VpUHm4YXoaeCXNIjdMXyUe8JBCrIwXtkiUTKXCLzhxRw1E9qBpeUy44KHZaJEVFy93
         E0+slIm6ye74cWeBF3qYQqUuzN66yIhdeAg2QvdZuDlo9Zyn9q6r8FK4dvc4UivqNxB+
         RpACyxTrJEFNLuCdn/Aq0Xiesjk8ETR6wIbi9kv1N4ufBaXbTn4JcC5CmZSjtuKZe6fO
         b+Ah3L/mgW1NbNr6zWGHlnO7owtB0NAmmZhcf5d66dHyKXQuyo+0/bnZszk73dnezILo
         m6VLeLFUFwsQQ6C9gIXf8HX8HT8x+6x5PYtQfeKZr9ixYV1jDaS7idHxDFB4JhPkWB8I
         ruQw==
X-Gm-Message-State: ACgBeo3GoH5x99yVrVTp2jK7qdClOTghMX2VJMgvFKo9fk9umsuaIBhM
        6kDqOKu5oPmerXdB99X9jG1J97ow1xxGaVXxQdASX8WybmOjIr2DE84EGf9dm0llcy2jOMTQ2jX
        NxCgPCqg6r0mvBdOM3A9tuEtL1QgETf1bsIq+anRAv0b580sSSLWiXRw331TIz39E
X-Received: by 2002:a05:600c:418a:b0:3a5:168e:a918 with SMTP id p10-20020a05600c418a00b003a5168ea918mr9782010wmh.31.1661867023783;
        Tue, 30 Aug 2022 06:43:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7J7amscRJ3WfZNYVzhrBCLo4tjoSRLTzgx5nbx4QzFf31AtfhlXNT2cljEHY97bXhWh+p3lQ==
X-Received: by 2002:a05:600c:418a:b0:3a5:168e:a918 with SMTP id p10-20020a05600c418a00b003a5168ea918mr9781989wmh.31.1661867023521;
        Tue, 30 Aug 2022 06:43:43 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i20-20020a05600c2d9400b003a604a29a34sm11680851wmg.35.2022.08.30.06.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 06:43:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v9 00/40] KVM: x86: hyper-v: Fine-grained TLB flush + L2
 TLB flush features
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
Date:   Tue, 30 Aug 2022 15:43:41 +0200
Message-ID: <8735ddvoc2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Changes since v8:
> - Rebase to the current kvm/queue (93472b797153)
> - selftests: move Hyper-V test pages to a dedicated struct untangling from 
>  vendor-specific (VMX/SVM) pages allocation [Sean].

Sean, Paolo,

I've jsut checked and this series applies cleanly on top of the latest
kvm/queue [372d07084593]. I also don't seem to have any feedback to
address.

Any chance this can be queued?

-- 
Vitaly

