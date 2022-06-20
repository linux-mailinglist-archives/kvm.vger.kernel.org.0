Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334F855182C
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 14:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242374AbiFTMFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 08:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242269AbiFTME7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 08:04:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72D1D19F92
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 05:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655726647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3fWG6f9+wPyZUdKpzq6SUM1FvIBmD72g2Gxfy7zPec8=;
        b=dRwY5VDDBDHsFGzABSg0ZHQJQf/0K6G89yufHd/cc6ecWuwrkSmKOtbQZtw2ooojbH8+Z6
        Okriva/0xWYGqosNB4QvPhZQxGFPdSjqEqXhlynEwxxNh+hyLzyoN8XvmUuyQgeoJ3IVCW
        P0FOGIfyUBbwe8fJwonIyioPZDuPlWI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-lu3RHyPcNwO74V137f68_g-1; Mon, 20 Jun 2022 08:04:06 -0400
X-MC-Unique: lu3RHyPcNwO74V137f68_g-1
Received: by mail-ed1-f72.google.com with SMTP id b7-20020a056402350700b004355e4d1e36so6694377edd.10
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 05:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3fWG6f9+wPyZUdKpzq6SUM1FvIBmD72g2Gxfy7zPec8=;
        b=7tEMbrzCCXV+J4wowUVxazfQfZON2f6dG6Xtsi5sDz89MqhwXKZqpkym5dIDDGLWN3
         yuyQxssLYhu78l2/vUJ2qT1MOTP40n5wCux4TFsFRmiwVcsyksAsBhLPV16XQjiHDFhp
         DDOUab+oZ/rZvY5QyudYJG2gU50xb8h36hgIV761IxnHyA9odiDr0L6PsWL5oE8giOxQ
         gwVKJURzlMpXNtVrAXq3ugQuF7ThHTHdgxSs/PaTHxGu5+DwE8okYBSRWlbzT10GJoba
         GzWxNYKr7CLHDm80WErGQsc89ioTh1FDjDp4Bq+FxTD8uxTwNegXzdyWJswlHnAoRelc
         gp2w==
X-Gm-Message-State: AJIora82vgxPH2eZvqojYuEJprwJ4V8lfNxJlP9zNTlaxN6SetisUw1J
        VLCpb2FLLvieO8FEDhuR/o33ksHz2p7nxM0q1+eoQ+2e3XP0fDnZ2vlFiWoL9p71V/bMhbXBHpS
        gb8EZZv6AN6eq
X-Received: by 2002:a05:6402:11:b0:431:680c:cca1 with SMTP id d17-20020a056402001100b00431680ccca1mr29443299edu.420.1655726645158;
        Mon, 20 Jun 2022 05:04:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u9VhJ+ObuyZNUvGoEylbYK2DQSNd9ckf8bXsZN3l2pKVlgkfhq7FwfxpWwysL4rM30ugQ6lg==
X-Received: by 2002:a05:6402:11:b0:431:680c:cca1 with SMTP id d17-20020a056402001100b00431680ccca1mr29443254edu.420.1655726644932;
        Mon, 20 Jun 2022 05:04:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id u20-20020a17090657d400b00712134a676asm5894961ejr.93.2022.06.20.05.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 05:04:01 -0700 (PDT)
Message-ID: <19bba1a0-8fb7-2aae-a65a-1111e29b92d3@redhat.com>
Date:   Mon, 20 Jun 2022 14:03:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/3] KVM: selftests: Consolidate ucall code
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20220618001618.1840806-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220618001618.1840806-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/18/22 02:16, Sean Christopherson wrote:
> Consolidate the code for making and getting ucalls.  All architectures pass
> the ucall struct via memory, so filling and copying the struct is 100%
> generic.  The only per-arch code is sending and receiving the address of
> said struct.
> 
> Tested on x86 and arm, compile tested on s390 and RISC-V.

I'm not sure about doing this yet.  The SEV tests added multiple 
implementations of the ucalls in one architecture.  I have rebased those 
recently (not the SEV part) to get more familiar with the new kvm_vcpu 
API for selftests, and was going to look at your old review next...

Paolo

