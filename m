Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6B52DB787
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgLPAA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbgLOXWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:11 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD97C0619D2
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:21:30 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id h18so21133166otq.12
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dI47DBQGgI2A5TAy6heUuzqewByjC3y+XRHFRtARr9I=;
        b=gk7oNcrptK8znmuIFENdnTd2PoIaAF0jpJ139NLa9vpOfYjvdtRO+/J9aV6i23Pujc
         W8WeI+LSNJnlQpyVBp5KNZTmMB4TsHfpM6f9luQ30O/r2+VvYvrSMJuZY7Id7CXFCIDu
         6ag+gsm9KPYv3QdbbkH7gV9rAvTCe2nabdPJeg03t8lOTBinnkBX+yz+D7rX9UheqhCu
         MfvydwFwV2/J0D61DwC01zcbYWwwS7oSLNA8/ht7irbAi5j7djFROGrUlolbIKd2hBKF
         q5VsC+w8lRjcn+vSv4yRhIRmWb3B5/+EUkveZdzJwgOwQyjU0on5YAJE0P7SSykNXRLM
         No0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dI47DBQGgI2A5TAy6heUuzqewByjC3y+XRHFRtARr9I=;
        b=ilQCScmGXuSLoRY0bxZumH0NQS5X2pZBv07l6gaaA8LbXvpw23VCT83VqgVnfRV46X
         IHa8fKtJYBHCUMFaz8KzUe97oCvxYef3GvFLtYoEY1aOgjoX74cNh9ZbI8WAUUImHowZ
         A9HZCSXJ/d3JwJ4MC6Tlfx1ZkrHKVnVX5HqX/g6/ixWhLul9/uYJa6vMr3540syV/aW4
         bf8oCKvi0P78kzaBPA9tFnZRwcegTxKKlRRNyb5ho23ozCD8F+2uElY5NZTs2eDoY/AX
         LAUiDQodl23nbjLd2O8TSIudfgQ9zX5dwv+3DqcG67YrGnrLRcCwfadlnuTMO04WdDGe
         4+GA==
X-Gm-Message-State: AOAM531JthAaxcjzhoXfrvK1Re/7ulq6wGLxI1+7NRlTYQy2ynigPGEU
        fTvXmoHGyLvBkmHWYV66w1Q4vQ==
X-Google-Smtp-Source: ABdhPJw31FDXeEzmj1nxbRnvp0hjIy48xla69UciM78qrekoigOv4tIJyQcvc5Dig1WjHu/7QO5E3w==
X-Received: by 2002:a9d:37c4:: with SMTP id x62mr23987807otb.87.1608074490316;
        Tue, 15 Dec 2020 15:21:30 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id w4sm4181otj.3.2020.12.15.15.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:21:29 -0800 (PST)
Subject: Re: [PATCH v2 23/24] target/mips: Introduce decodetree helpers for
 Release6 LSA/DLSA opcodes
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-24-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <f57948c7-f68e-0921-42a5-f41280372096@linaro.org>
Date:   Tue, 15 Dec 2020 17:21:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-24-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
> LSA and LDSA opcodes are also available with MIPS release 6.
> Introduce the decodetree config files and call the decode()
> helpers in the main decode_opc() loop.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h               |  1 +
>  target/mips/isa-mips32r6.decode       | 17 ++++++++++++
>  target/mips/isa-mips64r6.decode       | 17 ++++++++++++
>  target/mips/isa-mips_rel6_translate.c | 37 +++++++++++++++++++++++++++
>  target/mips/translate.c               |  5 ++++
>  target/mips/meson.build               |  3 +++
>  6 files changed, 80 insertions(+)
>  create mode 100644 target/mips/isa-mips32r6.decode
>  create mode 100644 target/mips/isa-mips64r6.decode
>  create mode 100644 target/mips/isa-mips_rel6_translate.c

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
