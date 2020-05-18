Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B00A1D7DC9
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgERQGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgERQGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 12:06:48 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A0AC061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 09:06:48 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 50so12478922wrc.11
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 09:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nc8u+kw9xx6d2Me7r51tf/V+eAZD6omt37yF0+esBOU=;
        b=nwelkd6DaiyrhP+y/Sh3h2z+sz7nNgkPtzL/5ouRJgDmM6W5CLFfkaEOmuqA6ZZVE4
         5QrFSh4APyYT7Uuch6qdKxbz4EQZ9FNJHb5XniqTdO205iIjM6Oj0qAPAWmiBpaS6Ult
         bhbXNFVUxzKpTtys56H9Er9+CwvzhShqqyAD4VT8rcnbgPE9frM7B/fVU5m+QQO4MNTL
         hXb14KTX+pBZ5E0i4uKJFHRmQl14kK6EdEqte9jpFdVaCnFfk8rmONqonPSv9x1WmDH3
         6KxzwuopypOvexNbMclX0fFe1al4plMoHTIjHfc46WRcS28p3OcDMDDnKCbn+nqpoEL9
         LGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nc8u+kw9xx6d2Me7r51tf/V+eAZD6omt37yF0+esBOU=;
        b=Gc5UTKPkLOKXQ02is2cAQVuh83vX+gsxZJSbFTBCmA33uO8nJ4UQWsfhuD2vqMv5dF
         VM0B2cd82dm05H/noqH91OSjyH4cJONAJRXkY2KtNdxKyU8jRFCF1NBCQM89/815Xz9e
         OT1+IsASntLui2tIwIZTSArYpmTCIqHJo0hR3pxCxWmh1BaheqhggI4pWNm3nMOLQcYv
         kttRZzFJP1xWA2pOeUEM2VpAJmLLo3fIeKF64dW0uHmdU8g1ycNfTyU6np8j4HAc5NlT
         oiOxP1sDJkQiX3sZO7vOiakuJqjya42yixzhDMZjTYNQbXb9ObxchLZuGO+Rgp2M+mH6
         iA0Q==
X-Gm-Message-State: AOAM530GWGgwYOJt+jz50c+DuUiS2RbSz8bfBnRBDmHuYAvJ2eGmN+7i
        4hSp61d7Jm07QsoMjPyrZJ8=
X-Google-Smtp-Source: ABdhPJxsOzhpGs/wB9rpTeByAK7JRmjeM1quaMEPq9P38KIonawmz2fBMN+SSOvDQLJ2X7MR+PqsJg==
X-Received: by 2002:adf:e74a:: with SMTP id c10mr20962424wrn.109.1589818006872;
        Mon, 18 May 2020 09:06:46 -0700 (PDT)
Received: from [192.168.1.38] (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id g6sm17164529wrp.75.2020.05.18.09.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 09:06:46 -0700 (PDT)
Subject: Re: [RFC PATCH v2 6/7] accel/kvm: Let KVM_EXIT_MMIO return error
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
References: <20200518155308.15851-1-f4bug@amsat.org>
 <20200518155308.15851-7-f4bug@amsat.org>
 <CAFEAcA8tGgyYgHXT5LVGz675JMq6VWR56H++XO5gtTrcaZiDQQ@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <b86345bc-2fd7-12d9-cb58-3ae92a6b5681@amsat.org>
Date:   Mon, 18 May 2020 18:06:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA8tGgyYgHXT5LVGz675JMq6VWR56H++XO5gtTrcaZiDQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/20 6:01 PM, Peter Maydell wrote:
> On Mon, 18 May 2020 at 16:53, Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>>
>> Give the hypervisor a possibility to catch any error
>> occuring during KVM_EXIT_MMIO.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>> RFC because maybe we simply want to ignore this error instead
> 
> The "right" answer is that the kernel should enhance the KVM_EXIT_MMIO
> API to allow userspace to say "sorry, you got a bus error on that
> memory access the guest just tried" (which the kernel then has to
> turn into an appropriate guest exception, or ignore, depending on
> what the architecture requires.) You don't want to set ret to
> non-zero here, because that will cause us to VM_STOP, and I
> suspect that x86 at least is relying on the implict RAZ/WI
> behaviour it currently gets.

OK, similar to the worst case I expected here.
Thank you for the clear explanation :)

> 
> thanks
> -- PMM
> 
