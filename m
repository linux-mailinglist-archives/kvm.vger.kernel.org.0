Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC992CDC0B
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgLCRLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgLCRLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 12:11:55 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC82AC061A55
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 09:10:49 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id j21so2426108otp.8
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 09:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JPPNUp8ipWsWAexZlipoUMJzkuZiXqBMqIoHxwBPwdU=;
        b=M+wzzlj/kAeU/xpmtdZ4Tg95yS6OYatcG4YPHEHL7aYZWJo++b6CWyalPwkHn8qmz5
         XoIcKVbNVlnRDFjdgAdEKJjeT/XlCHZr3HoCjS4cgc3jNkMXd7XSLRRCAuhoLA/EA9a9
         iQKx+AEn3n1ZlLKAW8+Z9YMlK4ZDebR2l0WTVwCHC3lXNZxY8H5S868tjrDdx67cKzQP
         h0xdj5bissL12yAzdIUxwjAyfR40V0XphV6UY7T9u+CesD8+S+4mY74sBlKUuYqEglh3
         m5JWPx6p8H+CnQZwvN7+PZu/Z7WPRzspQPI2FL/itVyPzaONDqEUiSQCv/ubRSWi4hbp
         URwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JPPNUp8ipWsWAexZlipoUMJzkuZiXqBMqIoHxwBPwdU=;
        b=XPx+P8Q3H6qGtEHOspmvLciL8tCoJMveRmFbV0Tb0CC0ZoTFrEaBIOPV9EGwbLn8vW
         5VDObgg4mMs9xmyxqTpQkxeM3006RncsOz/TLjCpCEzmYd6xNXAMSDBO4Im8HW7DyoOK
         RI9MCAj/xsqlawDIe2h1dp2Dr1Mz0iDg7ncNdDviwTk1HbLMc51k0xt0S8K6/es9+pWe
         ayGmDsw5nL3ZCxh0eFDGUCDfhQ/JmNxpkBdyjilk1r9fByI0OEnRwsf3LgoU2olyxAY0
         h4v5K7i7Zu9WTSgWdmPTrwNDs9KirsLlOSa6oY0ZoggYJTI69mtsz5Uc0EfqZZV+MgAj
         ja2g==
X-Gm-Message-State: AOAM530IQcSRLMnBCEnVPv/PvxnnOss6ada67fRtEH2EJJHBMQm/Vpz6
        A7VAt+I9WnhxxbY1wIQwIm5Zzg==
X-Google-Smtp-Source: ABdhPJwVg9zuB8t8KHOn6UojPPtk+I9rXG9IER8xQKaBXO9P1UfJ+eFM5ep7TXAyG9kJ0A27BkyJcA==
X-Received: by 2002:a9d:7c99:: with SMTP id q25mr100207otn.157.1607015449201;
        Thu, 03 Dec 2020 09:10:49 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id v15sm356437otj.8.2020.12.03.09.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:10:48 -0800 (PST)
Subject: Re: [PATCH 3/9] target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-4-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <904ce358-d0bf-1787-216c-c71545e7c870@linaro.org>
Date:   Thu, 3 Dec 2020 11:10:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-4-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
> MSA presence is expressed by the MSAP bit of CP0_Config3.
> We don't need to check anything else.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/internal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

