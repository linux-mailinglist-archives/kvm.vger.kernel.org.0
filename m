Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F897618BD
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 14:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjGYMsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 08:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjGYMs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 08:48:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E672116
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690289232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sBEuv0tCJc8eX/yOWjLEnalpSx9cpWx5eKvD+ap8VqU=;
        b=B6Gfmnzc7aw0je267cAEXFfz1s27uEoy+Kyf2mDyVPCQzQnnDE35y1RXfh9aNm2s+7FWaR
        XYKX2rEHx1XqaPW/A+gXoSX2j9z6YGoPh1E6r4/v2Ou/LbXGrT9xV9GsdEr/h8Hfd1MIqH
        ugu59WR6vf9iT0zDi0It4Qyqe+PArds=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-n4qtUsOhOveR17eNknqC9w-1; Tue, 25 Jul 2023 08:47:11 -0400
X-MC-Unique: n4qtUsOhOveR17eNknqC9w-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3176eb6babbso209605f8f.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:47:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690289228; x=1690894028;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sBEuv0tCJc8eX/yOWjLEnalpSx9cpWx5eKvD+ap8VqU=;
        b=IHVxdocQT1ocHydTeQ1vqyN5//yKKVQTWxG3zO2Tg9g2lJRB9BEq0twMW2MnSr/FCH
         GicHDZlT3VYQcRhp3iL33ayKua7EoTXiUUqeLQYfWNxPT+YbQsEtqThwL/ugjQDRUvnM
         dHaUCEt0QS7YrsvWUe7mszMF4oOpWn2df7ed3DUDHrAqB0FFQ6VqkWxb1qdTIL4o64BX
         u9x5QTrz6L/5xDvRd1ItGXQ6vFjWaZlcdJPwrUXF0c/igc7WcNIDWyWaSRseHxHISCc3
         eJ9zwGI1nd/dxjbDQT1Q/JfsduoT/dx0EDiwc89RttQpBloDBRh7wUuI9MbqX1ea6RMF
         cVDg==
X-Gm-Message-State: ABy/qLaHEgq+t2KsMQVwnJbVcxf6IjN06OLm2ZRMy1GovnJ3Uy0HfMPK
        ElDAoUQL2MH4uWwvfyRzr+SqlS8IeQ9ku0ZWslFWsVVUNdo7CkaoGjUyF7FQykyvNhRtX456Cyo
        Z3zW93r5//inp
X-Received: by 2002:a05:6000:180d:b0:317:5cfb:44c7 with SMTP id m13-20020a056000180d00b003175cfb44c7mr2171605wrh.30.1690289228483;
        Tue, 25 Jul 2023 05:47:08 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGws8+iJA5HUpqpH8sJjGYyiFtDyrmgt+CEXjGtjovyt3xTI1TY9JR2KSaiv+5w65EYPrya9A==
X-Received: by 2002:a05:6000:180d:b0:317:5cfb:44c7 with SMTP id m13-20020a056000180d00b003175cfb44c7mr2171593wrh.30.1690289228225;
        Tue, 25 Jul 2023 05:47:08 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-31.web.vodafone.de. [109.43.177.31])
        by smtp.gmail.com with ESMTPSA id f12-20020a7bcc0c000000b003fc0062f0f8sm13346012wmh.9.2023.07.25.05.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 05:47:07 -0700 (PDT)
Message-ID: <c6c1e1da-f5f1-1535-9b9d-88278c050cb9@redhat.com>
Date:   Tue, 25 Jul 2023 14:47:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2] kvm: Remove KVM_CREATE_IRQCHIP support assumption
Content-Language: en-US
To:     Andrew Jones <ajones@ventanamicro.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, peter.maydell@linaro.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        dbarboza@ventanamicro.com, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, qemu-s390x@nongnu.org
References: <20230725122601.424738-2-ajones@ventanamicro.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230725122601.424738-2-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/07/2023 14.26, Andrew Jones wrote:
> Since Linux commit 00f918f61c56 ("RISC-V: KVM: Skeletal in-kernel AIA
> irqchip support") checking KVM_CAP_IRQCHIP returns non-zero when the
> RISC-V platform has AIA. The cap indicates KVM supports at least one
> of the following ioctls:
> 
>    KVM_CREATE_IRQCHIP
>    KVM_IRQ_LINE
>    KVM_GET_IRQCHIP
>    KVM_SET_IRQCHIP
>    KVM_GET_LAPIC
>    KVM_SET_LAPIC
> 
> but the cap doesn't imply that KVM must support any of those ioctls
> in particular. However, QEMU was assuming the KVM_CREATE_IRQCHIP
> ioctl was supported. Stop making that assumption by introducing a
> KVM parameter that each architecture which supports KVM_CREATE_IRQCHIP
> sets. Adding parameters isn't awesome, but given how the
> KVM_CAP_IRQCHIP isn't very helpful on its own, we don't have a lot of
> options.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
> 
> While this fixes booting guests on riscv KVM with AIA it's unlikely
> to get merged before the QEMU support for KVM AIA[1] lands, which
> would also fix the issue. I think this patch is still worth considering
> though since QEMU's assumption is wrong.
> 
> [1] https://lore.kernel.org/all/20230714084429.22349-1-yongxuan.wang@sifive.com/
> 
> v2:
>    - Move the s390x code to an s390x file. [Thomas]
>    - Drop the KVM_CAP_IRQCHIP check from the top of kvm_irqchip_create(),
>      as it's no longer necessary.

Looks good now!

Reviewed-by: Thomas Huth <thuth@redhat.com>


