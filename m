Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC47C544F28
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 16:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbiFIOcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 10:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243469AbiFIOcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 10:32:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 945F97223B
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 07:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654785121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yyBQlUeeoBduR7JhY4CL4tsX2MNk3eyYarhXHreOnQc=;
        b=GMI+e03xNRyvGSnq2/vIFLXuDRY2kAMgqArHhGZ+n9c7SHgCEriNryVVwltmP6SszGzHrM
        da2uMzTPWyUq2bdFKohMHTXhu242qkBhK71D/BcwyABFznVDiSIm53TbjgwKDKdSi0KeQ0
        Tnu4mmgsxKPvqdURxdxnaXMbRizvsFw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-BcifdhhBNIGTNwXIgotKSg-1; Thu, 09 Jun 2022 10:32:00 -0400
X-MC-Unique: BcifdhhBNIGTNwXIgotKSg-1
Received: by mail-ej1-f70.google.com with SMTP id n2-20020a170906724200b006fed87ccbb8so11128419ejk.7
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 07:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yyBQlUeeoBduR7JhY4CL4tsX2MNk3eyYarhXHreOnQc=;
        b=4P1nh72DMF2zBPQa9u8btkMIPPAIjeE0/jBtMTuHX4aY7ZfQPY+08Eyy6OnEmHGQRm
         5l/NWb2xpeeFYgeyXstVQA5S6EWMFylJN3EuFaXDPqodFi3kob7UyCk4ueC5zVjBGPMF
         6IvN+JEUAp+R504TF6UblLYm/8WaAxP3MPH5NJZrVmc6YEb7gOQ5sxEqBEZLe27QbQlA
         PKsWYpeMOMjxWOMhfR6cpP1JdCuL39vUdyhBUYTpwex9zerBzKrIB0i+cOAdHnCC9t/u
         zjSmHsfP7s0+xwyKq5VAEjNkOW4dvkciOX7kDEHUYMN//ATY+VRZaA9NiperU66PlaQ2
         KFiA==
X-Gm-Message-State: AOAM531rUDj/Yp8NA2FEPDONfznxWqJizsJYnIGmxc6268q5BSn7+4wR
        FpZyi52HqxPKOe8OvenZ0fgHvQrcRL7aUmf5vaJIJfud31YeuGlP0hXErLCEopxiD0ttf89tiW0
        9QM8kicJlnrXq
X-Received: by 2002:a05:6402:2694:b0:42d:e05d:3984 with SMTP id w20-20020a056402269400b0042de05d3984mr45048173edd.419.1654785119489;
        Thu, 09 Jun 2022 07:31:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjKIDr06Ob8RUhbWgv5oIhFuMymqzsjg5w/CWS5+EBMFZvCWCH4hGdAZjOA3AlQIOofjXZxA==
X-Received: by 2002:a05:6402:2694:b0:42d:e05d:3984 with SMTP id w20-20020a056402269400b0042de05d3984mr45048155edd.419.1654785119282;
        Thu, 09 Jun 2022 07:31:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id vf5-20020a170907238500b007066283fdfesm10065131ejb.111.2022.06.09.07.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 07:31:58 -0700 (PDT)
Message-ID: <f9437202-9a80-7dbe-e6b1-b831a0c50b0a@redhat.com>
Date:   Thu, 9 Jun 2022 16:31:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.19, take #1
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        sunliming <sunliming@kylinos.cn>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oupton@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20220609141731.1197304-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220609141731.1197304-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/22 16:17, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.19-1

Pulled, thanks.

Paolo

