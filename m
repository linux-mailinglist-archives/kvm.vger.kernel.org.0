Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438F158515C
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 16:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiG2OPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 10:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbiG2OPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 10:15:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84D1D6BD6B
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 07:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659104103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VLmoxPjTF613oNOA3Psl0qHB0kkbJHX6uvP3gaTWm5o=;
        b=iKXN521Q74fQdYsyKERrQLlydNdabBIByR1pCUzB6y0rdLSzgwE58eGoUJFmRd2FCTk6Xw
        tp7nFTSadKCzuKLDgENyMLeXuj6LUHgYhyTKk348M+RZGky62xG+DyvdR//ZCwlweSNLWf
        4XYTwKJZFxq8oyBbYAdlRfiyTfkB8T8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-jRYbXcIVO9eYRbJpRW7OBw-1; Fri, 29 Jul 2022 10:15:01 -0400
X-MC-Unique: jRYbXcIVO9eYRbJpRW7OBw-1
Received: by mail-ed1-f72.google.com with SMTP id w15-20020a056402268f00b0043be4012ea9so2983301edd.4
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 07:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VLmoxPjTF613oNOA3Psl0qHB0kkbJHX6uvP3gaTWm5o=;
        b=Lu06v0/UKiPCGaVuveXqhquMhxZFcLugltRZLd+ayAH9qwVcY3XqxydZi78qQp+iiU
         e/DLYtQToaMcpzxEcSH5zQswjSs20WVfughh+NBKswZdNYAzr3I23ldGE1qXx+Yh7hxw
         K0Nh/b5pWf1Z9RHRKnpRQlao+RQeBPrRlFFF9+pK3wbTJP2wH5RKJv8sd6pnHcOgpv8x
         60DYk9Iv9DmuNEHwjDRFXR5EWFmGc8KmA1y1xVCGys7LrdI+uteR+nLWaLS+HSm5sObd
         ZBPglAdG/qHrfsnDK+t7urY5RpZpjsGo6fEpptOMZshjOgmkg74rG0ehvvwx9p5sgDFj
         /7Ew==
X-Gm-Message-State: AJIora81GcfKqGvXTS+deIdx7khZ/5PWla3dOPpn68aWtLfTRd47g39j
        cBxiC0M5azQ1JwihgyyfOaUNYb4yvqY+cvMH7HNk6iav9QgryOtgSVHhcRSjxTcAgwCDdCsy4rH
        LiZL3oLQFe0Xg
X-Received: by 2002:a05:6402:42cb:b0:43b:e8eb:cbc1 with SMTP id i11-20020a05640242cb00b0043be8ebcbc1mr3702648edc.414.1659104100492;
        Fri, 29 Jul 2022 07:15:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vUJOgt2w6+0Q5Jaq5HwRHoU+9HQJ7tv7rOc0xdWVP8kM+f15P1mKwXqY/YUj6dgr4mhcfjNw==
X-Received: by 2002:a05:6402:42cb:b0:43b:e8eb:cbc1 with SMTP id i11-20020a05640242cb00b0043be8ebcbc1mr3702624edc.414.1659104100238;
        Fri, 29 Jul 2022 07:15:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id s21-20020aa7cb15000000b0043cfda1368fsm2215428edt.82.2022.07.29.07.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 07:14:59 -0700 (PDT)
Message-ID: <0f5c4c7e-55dd-1042-ed44-0208b8483690@redhat.com>
Date:   Fri, 29 Jul 2022 16:14:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.20
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Fuad Tabba <tabba@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
References: <20220729084308.1881661-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220729084308.1881661-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/22 10:43, Marc Zyngier wrote:
> Paolo,
> 
> Here's the bulk of the KVM/arm64 updates for 5.20. Major feature is
> the new unwinder for the nVHE modes. The rest is mostly rewriting some
> unloved aspects of the arm64 port (sysregs, flags). Further details in
> the tag description.
> 
> Note that this PR contains a shared branch with the arm64 tree
> containing some of the stacktrace updates. There is also a minor
> conflict with your tree in one of the selftests, already resolved in
> -next.
> 
> Please pull,
> 
> 	M.

Pulled, thanks.  Because it's Friday and the RISC-V pull brought in all 
the new x86 RETbleed stuff, it may be a couple days before I finish 
retesting and do push it out to kvm.git.

Paolo

