Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A443400685
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350319AbhICUYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350293AbhICUYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:24:53 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B62C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:23:53 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u16so337937wrn.5
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wXBwe+C96NVMAw/WVJPmEePxSXgR8UnAw4mAKidy+Uc=;
        b=QHLQ3rMDWNB/26AcEt/tmQB5kk5HXskxmUCeZxjWkZY+/+gmxKxtLYBbUrbEJ9IIVl
         TXxNm1cMDVlWjjJE1EL8SyZCs1686ubATja87bAh8hUlCMrmrU+p/h2HnsSi4f6M2VVv
         ZijvBz00fTjJ0Pey6nM7GppsZ7HFYqOWG62UIeKnTBmuInsYh9s3ltuexL+iuerhbSSN
         uMg0jOQeNSsrtwUY8ODf5A01NMcBOal5Wp3/QlINZyEPfodQvP1VTMgezqqMzuZLU7iB
         OiJNsnH57C+xyoKu+8wTdisD8sJn3vaHgIGWHGCi7wCCfdTlsvskKx4OEy1NR1/zo36u
         mnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wXBwe+C96NVMAw/WVJPmEePxSXgR8UnAw4mAKidy+Uc=;
        b=C3vOY/8y5Ne22Bv2wJIe0pfp5cA8LQ66edzHSoQnTIcFLxjUQnZICIaU91mlbCHiTI
         E2LG58oDXhH75V0h+7ld+b5lyQam4FcEYnqxypmXin4ENZwEFYHKaYMnWnoXHek9NkBi
         5P6Gqv4ixWm/Lop0aOgpSzPnMszXQFGi0WlQC0GXEyUGxsR0cLPuKY13ezy4GgWdn/kj
         iA5/YSZrKltmN6H8X7GnaNdn/8G6i28KrQY+rA7zJspgMl6u8d38PeaWuccNJXuO8t5m
         OrPUWdhs9eGeLVxEY3ep24zPzTCmf3sUobMZpAsFd8NVfhF1jPVEhWAIaTe3/xoadbBJ
         Uv2g==
X-Gm-Message-State: AOAM532WeVji7sBJNYaKDMJQvZFkRR9awACq+0n05zFIE26UR704ARUL
        MDMIUInnUNJg0JhmOKShi4plU9npwvoUSSR6+RQ=
X-Google-Smtp-Source: ABdhPJz826d62i3FadVITpOZWzNuXjQqqxILWUC/72776fLbfHJdkqtyjig/TilRLtZ8efOdunSk1g==
X-Received: by 2002:a5d:5262:: with SMTP id l2mr839408wrc.190.1630700631792;
        Fri, 03 Sep 2021 13:23:51 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id j20sm258635wrb.5.2021.09.03.13.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:23:51 -0700 (PDT)
Subject: Re: [PATCH v3 14/30] target/i386: Restrict has_work() handler to
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
 <20210902161543.417092-15-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <b2796bcf-8358-1faf-cf30-0ad87cd0ac08@linaro.org>
Date:   Fri, 3 Sep 2021 22:23:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-15-f4bug@amsat.org>
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
>   target/i386/cpu.c         | 6 ------
>   target/i386/tcg/tcg-cpu.c | 8 +++++++-
>   2 files changed, 7 insertions(+), 7 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
