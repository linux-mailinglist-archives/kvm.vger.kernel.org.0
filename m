Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF91865599B
	for <lists+kvm@lfdr.de>; Sat, 24 Dec 2022 10:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiLXJT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 04:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLXJT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 04:19:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB05DED9
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 01:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671873520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QxublDXwR8D5DtOHl7/e/B0PH3ei1t0qPkoztnwEfr0=;
        b=YhKgv7ArEmsLS3tM3IOIS99lwy/ZTJdMA5eRTU6Oc8wM+J+alNp38wVAvmfODlsNouRja9
        6iX85jLUjCokTljlVeNbwNPYRjN/WgFM9Ro849ZOQHC6+ebX0FvxGukd+3zIaoKHIcp9v1
        j9f/SZqd0XurqBomshGixqYSQFrorS8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-172-kjsBQYJGMPyRAGf1IU6IZg-1; Sat, 24 Dec 2022 04:18:39 -0500
X-MC-Unique: kjsBQYJGMPyRAGf1IU6IZg-1
Received: by mail-ed1-f69.google.com with SMTP id b16-20020a056402279000b0046fb99731e6so4896757ede.1
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 01:18:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QxublDXwR8D5DtOHl7/e/B0PH3ei1t0qPkoztnwEfr0=;
        b=W3qXs+vhdXohCneEpzJTf17oiH9pfZ+O2yuB90lcXUx1vENjX/WplH8WZG0tEdAj5+
         uf3tW8eAQ0roUjJgAKJHTkNk5UFXs8uALQu64xpHDMlFKDRbcUlzZJBvADMTd+Xx8HmJ
         VBAyeWDSAPQfe4ywdjoPKFF1Iuff38q0/uXAWfPKBjfND/8InKmwiwHm9yyYrqp2oKp+
         FvEdPwLnhyZZ6DLlMl4WaKfNSUtAORPkzQkNE9sLtB//4pfgbjODFDGgvFEFxskp5wFs
         0zUOE30Itk4DWCid6CGZfXXuPO3S3uqrZpWQVAncFn3Nuielxdg+/aM6imzFmz0/oApd
         bNtg==
X-Gm-Message-State: AFqh2kruc7eZYrLaWVyyJqVc8lgoNA0Zk4qNzw9GaqK4mZ14PQkg43WC
        xKX+fDVL2AJLJqeCgPVryjns+g6fbf191CIlapl6mkmEDIXlAEcJKv1/AKwj3HfkaeffGVu37kI
        ywm7Tbf2zH5P2
X-Received: by 2002:a17:907:20b0:b0:7d3:8159:f361 with SMTP id pw16-20020a17090720b000b007d38159f361mr10353238ejb.36.1671873517897;
        Sat, 24 Dec 2022 01:18:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuzaX4Vch7tXx6y3KWiTjg6uUOEDxqKJ4lnD0J2K3STImlt9Y+l7L7jqIYGtkrdkVnkKuq68w==
X-Received: by 2002:a17:907:20b0:b0:7d3:8159:f361 with SMTP id pw16-20020a17090720b000b007d38159f361mr10353228ejb.36.1671873517691;
        Sat, 24 Dec 2022 01:18:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id kx20-20020a170907775400b0078d3f96d293sm2338931ejc.30.2022.12.24.01.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Dec 2022 01:18:37 -0800 (PST)
Message-ID: <4f789996-28aa-1d9c-f918-03de663d28b8@redhat.com>
Date:   Sat, 24 Dec 2022 10:18:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 10/14] KVM: selftests: Include lib.mk before consuming
 $(CC)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
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
 <20221213001653.3852042-11-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221213001653.3852042-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/22 01:16, Sean Christopherson wrote:
> Include lib.mk before consuming $(CC) and document that lib.mk overwrites
> $(CC) unless make was invoked with -e or $(CC) was specified after make
> (which apparently makes the environment override the Makefile?!?!).

Yes, it does.  In projects that don't use configure or similar, you 
might have seen

CFLAGS = -O2 -g

to be overridden with "make CFLAGS=-g" if optimization is undesirable.

Paolo

> Including lib.mk after using it for probing, e.g. for -no-pie, can lead
> to weirdness.

