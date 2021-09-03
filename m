Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C7B4006D8
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350982AbhICUoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350971AbhICUoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:44:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C0EC061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:43:38 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x6so358247wrv.13
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OCS3x2IM2IhJ7L7NOzo3OsfaFZSDUFR4VR+0j8dzaJ0=;
        b=H8ozIcixUveIbw9k7stg4KdS0gx7rTV2e5s41Gx6botMrAh8hYIIWhIu+AvbtT54dW
         Tl8+brbL8I6gSbmldeLB6TkvxB9mAloeVrSwAdDFUCxAz3A9ONWLJnZnRcf7/3YYCKiI
         mKw5CM9pdGmfYUyVULTwZdtG4Zo2cC0TJu5c2IH8dI7SsNAjx2c3JA5uxkgkaF3syZYO
         bS8qs1qwUmnUfdlgL3bsdR1L8kzzDcc0saGHUOJA/DshHL9WLii6vhGNcqmBnmKhwPEJ
         E/skqUuaJ6aFM7UfknaO/MQDQsX7XIC1JB3/bhICCmdu8qPCP1VV/4dZA8n9iYUOsjZI
         4+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OCS3x2IM2IhJ7L7NOzo3OsfaFZSDUFR4VR+0j8dzaJ0=;
        b=iQy8LZNeuVBgA8GcAqD3eZRzVHAe0n1fgfvfQm00h+RXDHYsnQLQ4faWHatWFkI3OL
         Rn2xO2swqE66d2cv+ZcasAR+CIbAIz3cra2OpF72QHq1g2TX2CCypEqnWAz0Vs+HCWp6
         RiYoRD9O7TFFMDenEWP+11MDWzKN6/hWW7Euz+LoQdtI5/3I3DqYq+YHPXsE7YLubv/F
         +cF4KusfXyZ89oHqouOUiYP0/W4isX8DKvVUbzk6Dk7cV14dKd8oNaD8RrAoJSqxWAqw
         FP+uvSpC/99VKNA5aFVIKPDnRBJ72Edc1TYrCvpLX3OKI9rYJF0wyGtRbLutjF91kVU6
         SH8A==
X-Gm-Message-State: AOAM530KqUzerhVb8jUNdMT2ENogEzSZQxxKvAbbJ/Irnrdrn1svwnb9
        1j8JLnoCcu6QtBkK3fZ3gCZlxHvMuqpTx+YcB+k=
X-Google-Smtp-Source: ABdhPJzDzA0nqf/Zf1bg1Haee/zHM2hXytKc0QH8nIr2MjWxDRi+4jQmQKWadcbSkZgCEwSPJcyooA==
X-Received: by 2002:adf:eac3:: with SMTP id o3mr939918wrn.60.1630701816896;
        Fri, 03 Sep 2021 13:43:36 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id d7sm274068wrs.39.2021.09.03.13.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:43:36 -0700 (PDT)
Subject: Re: [PATCH v3 23/30] target/riscv: Restrict has_work() handler to
 sysemu and TCG
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kurz <groug@kaod.org>, haxm-team@intel.com,
        Kamil Rytarowski <kamil@netbsd.org>, qemu-ppc@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Michael Rolnik <mrolnik@gmail.com>, qemu-riscv@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Chris Wulff <crwulff@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, qemu-s390x@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Paul Durrant <paul@xen.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        xen-devel@lists.xenproject.org, Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Stafford Horne <shorne@gmail.com>,
        Reinoud Zandijk <reinoud@netbsd.org>, kvm@vger.kernel.org
References: <20210902161543.417092-1-f4bug@amsat.org>
 <20210902161543.417092-24-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <56180d64-090a-1f6f-5c0a-22387c8a2af5@linaro.org>
Date:   Fri, 3 Sep 2021 22:43:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-24-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> Restrict has_work() to TCG sysemu.
> 
> Signed-off-by: Philippe Mathieu-Daudé<f4bug@amsat.org>
> ---
>   target/riscv/cpu.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
