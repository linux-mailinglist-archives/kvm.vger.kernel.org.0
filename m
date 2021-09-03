Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6767C400695
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350418AbhICU10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350304AbhICU1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 16:27:25 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F00C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 13:26:25 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id e26so93036wmk.2
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 13:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9EhQsb/ACMR+ZUYvfsQ8sm7Iu0dalRztguOzy6Crcdk=;
        b=QYSXBDXbshWafmBVS2xgefEvLphaKwA0sQfPQhGCg4AdEMozIzMcXqiXVGYB7CIewz
         jGF6cmCkebhdq+OE+6RWrDO4qTxvTVl4BSUMt65GZglcAtMPB7hoGF8O6DZlqsExbX4s
         XAzARgy5lmbAjguMkMH9lOvN2ERwa8Zk1z1kUQwdBWqSZWZPNk39la+7ZY1kN/pV4gyV
         RBRSsHPMZGhaBmnt8AGJWS+r15xgowV56WK1jX05FsVJKFg3NVzyfEkg92ZjiSGXwFOY
         XPliUy/Mwpe/M5POTE0+dgsKNGe4w2JH0ejOk5iEpYzt1oiH6GsVpGrvEbVnBC4nn0nZ
         rJzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9EhQsb/ACMR+ZUYvfsQ8sm7Iu0dalRztguOzy6Crcdk=;
        b=cHDdnOGi3L9iEwyPnWXcRxuDJ+Lwauz/PaWqvJbKLmZeP7NF1tBgbjukJHznFdu9HL
         x6o0+6BBfmW8OXTr+qcwFJ2YBNoRsY1pKwsunrnOJLfxeZOvNfzlzmxeZSwl1QEnuzNW
         ElT0auOjs0QYHfGMEF4c4RhcUteTTEHc4WlDhusNb+Ol/C3XdiqKG25VVCYLeiLrJyZW
         ++4eXC/isPqgJhjloPznR0a1Pa8TupH1cJFKCQTlGodOe6EYuLQQmAJD5x/aJmqLEqQN
         7r3nmql7E48+r61DXSJ0ou+hDEcS6HlmZCCI3C72FvF3ZaZr+aLCE7GVcYBgUzvyL211
         cWJg==
X-Gm-Message-State: AOAM530UonkpSflbvR6M1BinC6GeCJtOlmOqVaRZvuq1IXbXh8Kqmgff
        C0vt9CUrCMDJMU7hnaIZ2pS3wSSDLiC6on4n7Fw=
X-Google-Smtp-Source: ABdhPJxBhvIh1VZtcwLHBRW/mfjmLMhAmkSWajrXDW4E0STizvGidXuGiX92vd10z3qXEwsTB/9ddw==
X-Received: by 2002:a1c:202:: with SMTP id 2mr456635wmc.122.1630700783750;
        Fri, 03 Sep 2021 13:26:23 -0700 (PDT)
Received: from [192.168.8.107] (190.red-2-142-216.dynamicip.rima-tde.net. [2.142.216.190])
        by smtp.gmail.com with ESMTPSA id c24sm245010wrb.57.2021.09.03.13.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:26:23 -0700 (PDT)
Subject: Re: [PATCH v3 17/30] target/mips: Restrict has_work() handler to
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
 <20210902161543.417092-18-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <f24d9add-497c-8342-f37b-3d299a383d73@linaro.org>
Date:   Fri, 3 Sep 2021 22:26:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902161543.417092-18-f4bug@amsat.org>
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
>   target/mips/cpu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
