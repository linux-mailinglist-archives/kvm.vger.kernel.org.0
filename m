Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686DB2CFB83
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 15:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgLEOBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 09:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgLEM6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 07:58:53 -0500
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247CCC09424D
        for <kvm@vger.kernel.org>; Sat,  5 Dec 2020 04:46:04 -0800 (PST)
Received: by mail-oo1-xc44.google.com with SMTP id l10so2075009ooh.1
        for <kvm@vger.kernel.org>; Sat, 05 Dec 2020 04:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9IsfdIjFimgTASaoEYrYzbBL1NGFPt1y7Sd6YBjA43E=;
        b=wuGO4YTC+kWREOy1d4sUSKgZkZkxpcGpyMeeaMkRQR65jHTo8HBt52Sll8PgX0e5Ex
         NU4ajyMEmCfPlR2O3bbMEBWt5bVAsoE+hWdSa2p12tiR1d/3OrubGXipf3ZDsv2oarl4
         p0/dXqWrJA6rgzYhQ1UspuiUuheUw5tx8XgLG/2qqHXzzcX3hF6rPVT7s7GKtEHwR8ox
         OLYoTJPu6x4Yyd8nn8Whjk1EYkGhRTYRtH6rq8awP005mqnN0ak88XSudPqk0WWTAPOi
         ZC1Zo/Yz4w9qfsY+qrz/xOdvE6pa8nyVA42pIvE2w9XU+l1LJKUArXCf7k0DQFzUOyDq
         4kJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9IsfdIjFimgTASaoEYrYzbBL1NGFPt1y7Sd6YBjA43E=;
        b=WLsKGm0iJh3rZlv8j1MwfscwzDJ4MGt0EkUaMqiItKqDor8vvqKpoZ1RbqFF/p9ij6
         4Ywk63vOr0ct4stBu7OJPXMdNsIZbUao+6gIzxfhX5pXULe2xdhhHFL9kJZCV3hyV4+A
         Y4J9fLx3LuvplsY70z8GmTA+IHAPViDfRHavi4ebMowrb5sFvHkVYjCRD2MnM4uWDZAF
         f0QojzaYyHvsJc4sphWFlehw3Z7uWhMRrg33h1TuGrvXRapjMhkXvmllu3DiB8lQMige
         SRkhtiSt9EnSm2JAgdcHYDnchA2xRuMjYRpbrFqc375YvrtRjcF/YK+DDkEJXq7w3qNK
         h/nQ==
X-Gm-Message-State: AOAM532tXhyhSQ0qtZX4MhdUdnE8080md89u/ka/davSbUJjPDsAHMxa
        vMXAQpppODGeRb2KWgU1NI58Rwa6Hv0ht5iV
X-Google-Smtp-Source: ABdhPJzsUdE6/jQtqRRXmdJdORXzCA0oeWcK2d/AlbkLS+gDFmR0L553O+PjWxTcCq9I7fL7lLrMEg==
X-Received: by 2002:a4a:a444:: with SMTP id w4mr6784530ool.5.1607172363452;
        Sat, 05 Dec 2020 04:46:03 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id 2sm1384668oir.40.2020.12.05.04.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 04:46:02 -0800 (PST)
Subject: Re: [PATCH 9/9] target/mips: Explode gen_msa_branch() as
 gen_msa_BxZ_V/BxZ()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-10-f4bug@amsat.org>
 <42cae1ae-46aa-1207-dac7-1076b3422a7f@linaro.org>
 <c314aed2-9f39-89f7-c4f7-6b3e7c094996@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <27bbd279-b8be-4f82-5100-930caf142f4b@linaro.org>
Date:   Sat, 5 Dec 2020 06:46:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c314aed2-9f39-89f7-c4f7-6b3e7c094996@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 4:53 PM, Philippe Mathieu-Daudé wrote:
> Yes, will follow. I'm tempted to inline gen_check_zero_element (actually
> move gen_msa_BxZ as gen_check_zero_element prologue/epilogue). Not sure
> gen_check_zero_element() can be reused later though.

The other thing that could happen is that gen_check_zero_element could grow a
TCGCond argument (or boolean) for the setcond at the end, so that we generate
the correct sense of the test in the first place.


r~
