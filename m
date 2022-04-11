Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA654FC366
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 19:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244070AbiDKRcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 13:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348913AbiDKRcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 13:32:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9440D2982C
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 10:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649698185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+eb72OximgDdsK1I3iUsdEwiwb2gnGfSCXqFzmEXJg=;
        b=FeirZt3yl1Wyuwp7w5QLqA9fvlNxb0fJuSW52wbanDGneRqOinRYHhpf/UoqGr0PP3wriC
        qh2sFdNxKO3+1rsRGO8uWjBFLo6pFXLSDulfJqH+etkzdDEcSEOu7MdWaZUmBoXq2SSgNp
        tmC+F+mBizIqNNKdaNnJ5+NI8Yi3IFc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-WFqDGfVhMaCmuypy5pWitA-1; Mon, 11 Apr 2022 13:29:44 -0400
X-MC-Unique: WFqDGfVhMaCmuypy5pWitA-1
Received: by mail-wm1-f71.google.com with SMTP id r83-20020a1c4456000000b0038ebc45dbfcso642131wma.2
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 10:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J+eb72OximgDdsK1I3iUsdEwiwb2gnGfSCXqFzmEXJg=;
        b=ZuDvJ/wh2VbAHByE9WnMnGKh4151tazd7EXI2HRp1mHah8uZatj6VrBvFUruVUPpCr
         3MvooG5b9ZqZbFf9/BwMi5xh85417JCntTkliyCNMs0uNlbZBYAvbsijyivpJVpb2fd8
         YdjLX0fY2z3RUYP+KemtN9fqEFKvxyVsBVkDsnJLdooBGWKP52dZgD7y/xdpK3RfdF3A
         Z6i55Zv+wpb8Zq8igrs7MTMuRcoHUg4iMO+8JZyWUoojR5iuMys96uhmnZYwv+T4OacH
         O56McpD9Fv8abu+dHr755DXgMTWq2wrBWwjnMMbESTUi6jL6jbY9JGfGFJUKRucMNNEn
         54OQ==
X-Gm-Message-State: AOAM533J6oU9CYjLc8fc4UlBDhFIIAJheEgLbXQgl9rAQ2dnUzXBH0Lg
        GCb9ylH3N5gRsPn/KRf0PTvC05QbLw+X8F2itcIK91d/lDfzZiHe/tRGCvUdlp0zB18g2dnZfQm
        gVyRVh45GPOYt
X-Received: by 2002:a5d:5447:0:b0:206:102b:9e77 with SMTP id w7-20020a5d5447000000b00206102b9e77mr25456402wrv.240.1649698182582;
        Mon, 11 Apr 2022 10:29:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuhJtdFdqO8feZdVRGloeDpJqsLDQRdwz2FLAUrP4Boh1i2NAKsQfE7++7KAJiAPZmimuQqg==
X-Received: by 2002:a5d:5447:0:b0:206:102b:9e77 with SMTP id w7-20020a5d5447000000b00206102b9e77mr25456382wrv.240.1649698182305;
        Mon, 11 Apr 2022 10:29:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id w5-20020a7bc105000000b0038eb9932dacsm86677wmi.48.2022.04.11.10.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 10:29:41 -0700 (PDT)
Message-ID: <b410d5fb-8d69-1d46-44f1-d0fcf0236934@redhat.com>
Date:   Mon, 11 Apr 2022 19:29:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [GIT PULL] KVM/riscv fixes for 5.18, take #1
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>
References: <CAAhSdy3RJpcYNS9NN=hNw=14O9e6=hqoF10fi1vT=No2cT0jWQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy3RJpcYNS9NN=hNw=14O9e6=hqoF10fi1vT=No2cT0jWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/22 06:30, Anup Patel wrote:
>    https://github.com/kvm-riscv/linux.git  tags/kvm-riscv-fixes-5.18-1

Pulled, thanks.

Paolo

