Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C7C6D9EEF
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 19:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbjDFRgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 13:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239619AbjDFRgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 13:36:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA2EAF21
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 10:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680802510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FVq6vuqCUvv437Ye4jb4CJk28rz37KbFIJLyeie7Yy0=;
        b=Ayu0W3PZXpnn1OpXTbOi4EAz7Gq5L5MG5hKbYwO7Hecofos0oa5Yt9LvCM3GsZvhRfic6x
        4d4pzLnyJ6KIXesjb3g6ZZaT3OLxNHHCGw9fJSdtjuPN0ge+pAmhWsrHkAwG2Ehw5Mc4PS
        wzqqco9PIbBliGtTj4nA6lUjhZhw578=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-PrFYZcGpMTGPHh8Yj9uxxg-1; Thu, 06 Apr 2023 13:35:09 -0400
X-MC-Unique: PrFYZcGpMTGPHh8Yj9uxxg-1
Received: by mail-ej1-f71.google.com with SMTP id j1-20020a170906830100b009497c250e96so543598ejx.15
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 10:35:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680802507; x=1683394507;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FVq6vuqCUvv437Ye4jb4CJk28rz37KbFIJLyeie7Yy0=;
        b=SvQsTZkcmn02kwTGyj1U8IwC6zZ01fg1OKIhYXTM8rQrD+pjnTiG7EppB03ijKIMk2
         HG/bflgM94Czh+XyYPMXpkYUyStqyznxvJ0AANZjMNyutsONpx569eISm8Ixe7CgApa/
         ToCic8R+oklBdciEPWEIud3F+vC8bkfgv1bmKqrdiw6mgvf6HjtLYlJJ46qWgMaNDJw+
         nacklmrKFwEjdfAH8QUp+Yo7AXmc/+ZLPF7Yy/AxY9PcD5SuJHZ/MaA9JYkyHCfhJo8j
         3UymM2qm8jl90ZoG1IPNMIj4Fn7pEd+t0EsXJ4/TkJx0n2/k32DWz1Q2I7K0ecDAXgUA
         IQNA==
X-Gm-Message-State: AAQBX9eSU5B+OeoP6+x3XjZ3I7iAn6dEt874IrQgOJ5jgQq+Sm8Du8yY
        dRc5hEcibWt7DJTbsTnqkXrr/Vke2c37IkRaDnreLCxgbnMT4ANrlnweIxQCbfO6AWc0vC5sjTG
        ybelv3wrVcoAYOgi9XoX6
X-Received: by 2002:a17:906:9383:b0:948:d1af:3afb with SMTP id l3-20020a170906938300b00948d1af3afbmr5583614ejx.13.1680802507620;
        Thu, 06 Apr 2023 10:35:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350YdZ23vTC3jb6Q4OZMvCq+v951UYx7wh1E9GCULBeCPXKfyfGJdz8NaX5Do6DoIVSdjPKIWMA==
X-Received: by 2002:a17:906:9383:b0:948:d1af:3afb with SMTP id l3-20020a170906938300b00948d1af3afbmr5583592ejx.13.1680802507340;
        Thu, 06 Apr 2023 10:35:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id i24-20020a170906a29800b00948021c1629sm1049160ejz.182.2023.04.06.10.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 10:35:06 -0700 (PDT)
Message-ID: <bfab2767-0b31-4dce-c077-b72cac4bcb2e@redhat.com>
Date:   Thu, 6 Apr 2023 19:35:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.3, part #3
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
References: <ZC2eAXc9UE7Vesmn@thinky-boi>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZC2eAXc9UE7Vesmn@thinky-boi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 18:12, Oliver Upton wrote:
> Hi Paolo,
> 
> Sending out what is likely the last batch of fixes for 6.3. Most
> noteworthy is the PMU fix, as Reiji found that events counting in guest
> userspace stopped working after live migration on VHE systems.
> Additionally, Fuad found that pKVM was underselling the Spectre/Meltdown
> mitigation state to protected VMs, so we have a fix for that too.
> 
> Also, FYI, Marc will reprise his role for the 6.4 kernel. Nothing is
> set in stone but the working model is that we'll alternate the
> maintainer duties each kernel release.

Pulled, thanks.

Paolo

