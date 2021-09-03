Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB22240067A
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350305AbhICUW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350293AbhICUWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:22:25 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5658AC061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:21:25 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i6so344700wrv.2
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q+SSfq4073OmWN5SjfGpr2ImvdVTltAm2Ap93b1Y88E=;
        b=PZ2KiViiXR0yMgtsi9ubJd49eXX8m7kgtJ7JWAf0xocPcQ4Oxw4avSPsHVo9QZcW0N
         BByueunHxBruDfx2gZo+Ix58peWhu5wGIHIMCSjfvS8XdfqDnHodPv7hZLnIQBhld9/a
         y0lWLp8aIQKnuXGpPmhHwQpf/DGQHqb2SPZDygfQELNsjREPaTcvh71MJU4d2M9P2WuC
         AZHX/t3lV1bfa8h49PxfG8kq4e5hCt+9BPtVsMQjLzebnh3VaBZTuTGJBK+rNkK7BCfW
         EvnOQKajlmpMw2NfupoVnEo8oI6UDgZtiqq4mNRFKiSDClkKz+9ZYBjtDFyqInTaIFO/
         szhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q+SSfq4073OmWN5SjfGpr2ImvdVTltAm2Ap93b1Y88E=;
        b=N2QKQh8aaF0gRUvpco2/8SdfdUgbw29HFaRp3RNeEnI/aVKCS4aYrYcve/skBYUwXo
         OYXg1a4UCIPKsv3W+S16N/aq3AZpzjDbv89t3wtRlyuDtrzgg74nJZwprdqRN8CqMPhb
         6UqtU1n5JPOZq1iAFnaO6H0SMcbYpf7WJdheZum+Ooi+8lV1o0VqU3K7RO25q49L+Yja
         +IXoqhJ/7BhzOFIM3Ukvxlc/Pgmh75i2/rF0CYkBrmzGTtkZxVWBzDC7Nnc1yEKGKHsR
         lJD4GkjpvKxhvZ+maajdAJ2n1RnZoGmI7+a/CQ9H8Sq4NWGMNG0Wb7G+FOk+eWQJbDZZ
         BGxw==
X-Gm-Message-State: AOAM533H2O7Veif7W9xyAva0e8ebSAwv0v9ZPXXHpAPqwPdRVBmzZWwh
        MslAnnXHkYONuwHEJVIvn4oSB4S0qnVN2ALOcBU=
X-Google-Smtp-Source: ABdhPJyd1De7PuFzuLP4i8MhbWXrBu0OhprhhfEXRkHThwdYNyCL8/AmxbAlET5sIL14xwjI9QRBeg==
X-Received: by 2002:adf:c149:: with SMTP id w9mr804955wre.127.1630700483905;
        Fri, 03 Sep 2021 13:21:23 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id s15sm232969wrb.22.2021.09.03.13.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:21:23 -0700 (PDT)
Subject: Re: [PATCH v3 11/30] target/cris: Restrict has_work() handler to
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
 <20210902161543.417092-12-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <51e42a3f-6064-be49-26b2-20eafd1106a2@linaro.org>
Date:   Fri, 3 Sep 2021 22:21:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-12-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 6:15 PM, Philippe Mathieu-Daudé wrote:
> +#if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
>   static bool cris_cpu_has_work(CPUState *cs)

No CONFIG_TCG for cris.  Otherwise,

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
