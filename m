Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F66D2DB789
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgLPAA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbgLOXUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:20:14 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2026AC0611E4
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:19:34 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id x13so21150166oto.8
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4jKKLYnW6eM47hkIEoFIJgwOeY9tD0FuXauIYvNdRQM=;
        b=QT+aFmhuTvTXmlOS6vXlQJ0Inh41nvmR8cY6LPDr4QNwHkOz/dIgnRSVx17pZza8GO
         aPKkiS45tazm1rZfYAH0kp15EJF9t5cxgOmqQBwti5N38MJNwpGobw6etIBsNMR+oZsl
         /vVCXeFaVEINdSkQAZF8JNaqzNn5fDmnZuj2F32fmJZxYJFozqlXsSi5elNy+kgN0X6a
         qWFLEmPCwxI/jdH+jx87WRUeV8xMjYbl6RWKf+zPf6y9zOpI90nWf7uiDGoisuw779q/
         MxYVXrZGiGr29tuC67+ZASHO11FCSOnke/G9knSzRWpWjrg1iNDm5gFyJ9QALy7EUJgs
         jnCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4jKKLYnW6eM47hkIEoFIJgwOeY9tD0FuXauIYvNdRQM=;
        b=Lt9mcQisEa/vvDh1RAEXqKUANnaUrrKmNkFnhmtIthI95FAor1dv5Tf4ELbYaJe9jN
         o2m74LWaclvKanjcyx9tg7w4dGOheM0VK8eWc4Uo58WpnB9u4QAW6yCvSYHwTJvmAlFi
         twoV2Rm6ifw1qSFd9Ud+9cLT8Drwv3etEA/OeOlJ8FNymNJTqUf4ecKXkFFklKK+S4eN
         G9OR9DmaNpVq8aiKuRqXhxEy+tUya81l7bh12U+iiFPdLNHHGuMUrCM5/9uHu6mfO67H
         T2qsLalzHFoeRNK/sZk50BhNFNgbAYC8V7dZqT05M5Df88JlvMRkCaJSXjNt+qiqll3B
         kwug==
X-Gm-Message-State: AOAM530HtsgH+tDCbnTxFmBuItCPOq1Nmaudn97IrnkIb4LiOBCNfXwN
        NsT7mhHVz5Ub5ZfjkeeQF5vKiw==
X-Google-Smtp-Source: ABdhPJzAMX9IYWAzIVmdR6ws3mXW/eii9EP8/sfhz6rcQHemp3E1iJJnjeLSbsRr8Q++COTbwkTeaw==
X-Received: by 2002:a05:6830:572:: with SMTP id f18mr2976078otc.109.1608074373585;
        Tue, 15 Dec 2020 15:19:33 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id v17sm48306oou.41.2020.12.15.15.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:19:33 -0800 (PST)
Subject: Re: [PATCH v2 22/24] target/mips: Introduce decodetree helpers for
 MSA LSA/DLSA opcodes
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-23-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <937ba112-7706-73e7-7ae1-6a07f6ef64f8@linaro.org>
Date:   Tue, 15 Dec 2020 17:19:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-23-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
> Add the LSA opcode to the MSA32 decodetree config, add DLSA
> to a new config for the MSA64 ASE, and call decode_msa64()
> in the main decode_opc() loop.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/mod-msa32.decode    |  4 ++++
>  target/mips/mod-msa64.decode    | 17 +++++++++++++++++
>  target/mips/mod-msa_translate.c | 14 ++++++++++++++
>  target/mips/meson.build         |  2 ++
>  4 files changed, 37 insertions(+)
>  create mode 100644 target/mips/mod-msa64.decode

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
