Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9DF631CD3
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 10:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiKUJ1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 04:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKUJ0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 04:26:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D924905B6
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 01:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669022752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pOeRIj2wUWsVu+A3oTjGt2cxbVeBzE1q43m542O69sM=;
        b=DaS1G2dUP7Jm6ysBWzC0Y87Gf1Mr3EAAxvTB3RCRBtRoi2A347OX85o3Qmtxf8tEDwf/vU
        y9uoL+M2hOEnJ83EL/amuuRXOOGdy+Zb3XnQY0VJ+jlj6ahfUF7kfTDkl6Ck3SLY+FXzHE
        SQMRkVmBQzmx0o6tIPSnitv9V+HCSqM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-tjTimfPAM5mjaJPyQaCTXg-1; Mon, 21 Nov 2022 04:25:50 -0500
X-MC-Unique: tjTimfPAM5mjaJPyQaCTXg-1
Received: by mail-ed1-f71.google.com with SMTP id q13-20020a056402518d00b00462b0599644so6544050edd.20
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 01:25:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pOeRIj2wUWsVu+A3oTjGt2cxbVeBzE1q43m542O69sM=;
        b=2UPL0280QsqK2Ls9Qdq04h32PlfBzK5u/hDZUQVqLRpBEm96983vQpPH/Hk/tdLQHo
         fPp1duhSsSgCHLKL+r82R9WB+XhN/7QKygZSJY/5tYZeFktYTqUIM2SVdWf3xkNYdcgS
         YmGzGs/zjIPPNW1h1GYJdfeOhFdP/I1KI13Rn7ZnFD4vJdPJDAqP7cfro+eLaZ4RAPa8
         sZACbx/X6cxKogpG/xsxTHPD/GMF7+DJuVLNFjjb8OXn0nFdHbEE94Q1nvuHg+IlZh9h
         pIRZH5n5gAzsUy11Q9GodRB83mluU7KXzrqJE7+Kl0PXEmCCupw2Viiju5p5gFQxG9hb
         4rHA==
X-Gm-Message-State: ANoB5plUWMn3IIav6SxN7xAvVLaRzkdxhwk2IUUN1h5IFpZ85qdVU2XD
        4Id3WA8h/wlm8vhwMLf/kp+pUY4UoRQpeYLRx/XkVm2UNrKLIYe84QSTh1jsokn8Y70l9/4ad8g
        nNA3XNll4pJg0
X-Received: by 2002:a50:f602:0:b0:469:4e4f:4827 with SMTP id c2-20020a50f602000000b004694e4f4827mr7260255edn.214.1669022749416;
        Mon, 21 Nov 2022 01:25:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf70eFrQAjEE0T0SyoIyvYOtqxR8yduQFLe/PPoY7FfbHsw4PZ4sZwC4ppS/8tIYffYYy+4XEQ==
X-Received: by 2002:a50:f602:0:b0:469:4e4f:4827 with SMTP id c2-20020a50f602000000b004694e4f4827mr7260245edn.214.1669022749257;
        Mon, 21 Nov 2022 01:25:49 -0800 (PST)
Received: from ovpn-194-185.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k21-20020a17090632d500b007ae32daf4b9sm4776969ejk.106.2022.11.21.01.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 01:25:48 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vipin Sharma <vipinsh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: KVM 6.2 state
In-Reply-To: <CAHVum0cMOzWvG7-OyRbZDrd+Q_VQk44rf-88fee4TBPuwnx2eA@mail.gmail.com>
References: <89e2e3f9-ad89-3581-4460-f87f552d08a5@redhat.com>
 <CAHVum0cMOzWvG7-OyRbZDrd+Q_VQk44rf-88fee4TBPuwnx2eA@mail.gmail.com>
Date:   Mon, 21 Nov 2022 10:25:47 +0100
Message-ID: <877czomzfo.fsf@ovpn-194-185.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vipin Sharma <vipinsh@google.com> writes:

> Hi Paolo,
>
> On Fri, Nov 18, 2022 at 10:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>>
>> These are the patches that are still on my list:
>>
>> * https://patchew.org/linux/20221105045704.2315186-1-vipinsh@google.com/
>> [PATCH 0/6] Add Hyper-v extended hypercall support in KVM
>>
>
> I will be sending a v2 for this series. I am waiting for Vitaly's
> https://lore.kernel.org/kvm/20221101145426.251680-1-vkuznets@redhat.com/
> to appear on KVM queue.

"The stuff" has landed, please go ahead with v2!

-- 
Vitaly

