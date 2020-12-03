Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CC02CDBFA
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501871AbgLCRLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgLCRLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 12:11:08 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C271FC061A4E
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 09:10:28 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id j21so2424983otp.8
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 09:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8ryNOAktagrJ7Tg3Tg77kn0s+R1SHkWLPi0JKyvY+n8=;
        b=TiykxljfXN2pTbhBmmLtkZfDhzNZblt68qTDig06qPYwyumc6UMT1dOZnuYDxex83z
         Sft3tRQ+BKVg5hLcTFpUQPKFYFWDY28rr1suHxejslL2w8uMmSI+uWWwWIMcC3mAi8d8
         Av5jacXNsa7xjHjlCV8kyrK3Fk9vkFUc1L/nCgZlgE8WFV860+1mWffw34tQjby3nC78
         L/vhR0d7Lt2aGBh+lYxjDqyHq6Kx3dNo/VXRudQcDpzeCbi1BWT+fdJZAxxV4JW4RV/+
         DLZKDD/Hdt+VVaeRwjdMJ9oQni4dhKzLtjBrV6/9nmpEKiPSxhZr1oZL+K9DisnxmdS1
         pCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ryNOAktagrJ7Tg3Tg77kn0s+R1SHkWLPi0JKyvY+n8=;
        b=FaUXeyS+MhLy1m3KGKK4W5JzapxqaG9NfjbdClALoFbeTOAMQEoaxtlo1er+W28OsN
         tNveQLtJOPFvA8+uq9D8FzXcr+ASVUolrCLirSSCFEF0QD588b+qTjrmnJg491UhPIjU
         ujK6GIOhl5CopoehJiYPTN9OqOW1+vyzvnjhZwaERpow0wOKyrqKvbodVMztW3Xt4ENY
         oZWZ8iBlYauv8q3sjLxVYi6i3SHf3DM+ZIsX4Tqg3yyusjZrmAvZAav/exkDtwLJynE9
         /lovMz2rRjeVagZjGM/kuTiuNrfGK8d4WalD/+XAcV2RfWP6fXcn4MvaiP/ZgreObHzC
         pgiA==
X-Gm-Message-State: AOAM532kxN4t5p/dV0HNFQox4pRzBgYxkZhsXig/LjSSraflk8NI4pjD
        3UYVTPGdkihp81y0hjif6n4k6A==
X-Google-Smtp-Source: ABdhPJz6q4JgjeQ3DOv3qqVcxmpv5Nc/V94ZxVPHoTc9/9f04FXSYjns8g51LPmTl/sNqF7t+dIhKw==
X-Received: by 2002:a05:6830:18eb:: with SMTP id d11mr128317otf.208.1607015427789;
        Thu, 03 Dec 2020 09:10:27 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id x66sm316179oig.56.2020.12.03.09.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:10:27 -0800 (PST)
Subject: Re: [PATCH 2/9] target/mips: Simplify msa_reset()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-3-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <dfb36b79-f65d-1ae7-0b35-7f3aaf985f17@linaro.org>
Date:   Thu, 3 Dec 2020 11:10:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-3-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
> Call msa_reset() inconditionally, but only reset

unconditionally.

> the MSA registers if MSA is implemented.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
> Maybe not very useful.

Yeah, it's marginal, especially given one user.
But whichever way you prefer.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
