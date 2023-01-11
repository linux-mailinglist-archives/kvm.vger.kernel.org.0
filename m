Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B952666068
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 17:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjAKQ1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 11:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbjAKQ0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 11:26:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD4F39F8D
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 08:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673454187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bAzX0I8qhNQFozyjHTOv5miI6bc1TzOt0NGHpESsMAQ=;
        b=Rpc2H4zbMZ9lrVT2TNyW8YFfb8f8SvPGwwRxjxDfo4ywItxSQUI+Yp1yfMv0arhb0M7XTw
        hOQ38JdYPrpq0NQC+hS2GJhPvfd10olrUsgWCEn1TxyDK8GhGj0O6WOq3fliVhMDr3L9ND
        8EnBUnZGQaqRDsX4x2uFWehUAL0qi7Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-672-zt_H5V1dMyaZ37STa6ZDcg-1; Wed, 11 Jan 2023 11:23:06 -0500
X-MC-Unique: zt_H5V1dMyaZ37STa6ZDcg-1
Received: by mail-wr1-f70.google.com with SMTP id y5-20020adfc7c5000000b002bc02b72d2dso2134301wrg.19
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 08:23:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bAzX0I8qhNQFozyjHTOv5miI6bc1TzOt0NGHpESsMAQ=;
        b=L2DXr8V/cl5L2fOwMj7UJl6T/WlxW6i9EEAoNGWFSuL+bRtkf/KcoRXHbPDE0tjgB8
         WA8YzWMVz5sz5sm0PAir7Ikq18/KWkpCo4/hZ1KTp9vaxmNI4Pag+uM6/98A/PViSpnK
         y6Czvw0OAxO7zxlINeIW6vZcrlvc5K7n6lSR8mrPrlhqgtAJ/6lTElC0nU9nXJumuOeq
         VWokcRqtFjRtf/YCihDxOC5Tbs/HYOwNYZH6fIwWVNUgOnfw5uC/MSZEQ4gC+3jI3+62
         +X1Tts2S028Pd61lTaMo+PxFd/IfjGTQH9oZ9SQJ8frH9ysXgM+EdnFrYCvWagCMVI2n
         V0aA==
X-Gm-Message-State: AFqh2kpcWHm6+2uy15tw6aEZrEKzytcPVqddz/k/I0u8PWo4x2XTjAVf
        dDrrKHJCP6FXzi4GLv4uTyiW+Z5xyMahPamfMUVHiqhYgnRe+MEXCZIIOsf4HhjFFi68j18Fwom
        l82xvLHLNYohg
X-Received: by 2002:a7b:ce06:0:b0:3cf:a483:3100 with SMTP id m6-20020a7bce06000000b003cfa4833100mr52806211wmc.3.1673454185097;
        Wed, 11 Jan 2023 08:23:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtLvuQHiCtmyqnm4CLAs4LBNQIvAx3luYBZ9kZsu5kzE6A6u6fOimphXyAb5WqlrOBkfqsJsQ==
X-Received: by 2002:a7b:ce06:0:b0:3cf:a483:3100 with SMTP id m6-20020a7bce06000000b003cfa4833100mr52806198wmc.3.1673454184874;
        Wed, 11 Jan 2023 08:23:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id v10-20020a05600c444a00b003d998412db6sm25266750wmn.28.2023.01.11.08.23.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 08:23:04 -0800 (PST)
Message-ID: <8333e62b-8bb6-981f-ba07-d867ec61657e@redhat.com>
Date:   Wed, 11 Jan 2023 17:23:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 11/14] KVM: selftests: Disable
 "gnu-variable-sized-type-not-at-end" warning
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-12-seanjc@google.com>
 <CAKwvOdnRQQb9YbH=MgDymBmmjYgajc8tkyjbJVxjpA5zDZpNTQ@mail.gmail.com>
 <Y5ffxebJ/eRzEXh+@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5ffxebJ/eRzEXh+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/22 03:13, Sean Christopherson wrote:
> AFAICT, gcc stopped treating unknown "-Wno" flags as unconditional errors starting
> with gcc-4.4, and the kernel's min supported version is 5.1.  gcc-4.4 through
> gcc-9.5 all print a mild warning if there's a different error, but otherwise
> silently ignore the uknown "-Wno".
> 
>    cc1: warning: unrecognized command line option '-Wno-gnu-variable-sized-type-not-at-end'

scripts/Makefile.compiler has cc-disable-warning for this, we can copy 
it to tools/.

Paolo

