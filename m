Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE1D2781
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 12:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbfJJKur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 06:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732332AbfJJKur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 06:50:47 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B87483D955
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 10:50:46 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id l3so2433189wmf.8
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 03:50:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2JdVNcJHcx/QcdzRfb4YJuuCrnXrMcDI8HLU35hMmQI=;
        b=BAz/pbgnPBD+RimHXPdiL+4Ix8v8CPc7+S2uH6y5FUjfoTiMh1FLPr+0jxCN+CTZaG
         tuO0xQkCdL17AjlLChxbqejoDeufHSyCsyMPJiacxT+/kWvA+0oAPdSlKBc/1r+Pn/lf
         p8m6cvSbwny1UWMSuKAm4m9SFeTLDXMgOreccu6LL1qPvDdagReXEWv95kIbB240Cycu
         pmL9Wvudz6vt+VExFWtvMlJ/UB7S7t3tAV+nj0orSWPXBFqDDJwGV0O4zxLvknzQvISM
         3W5cC8ja94BfvsnxQcMq+voWl1TLs5sAgbH1e8ZqGE3BpRpb7FZ3OFBX//KOyNUwds8U
         3cRA==
X-Gm-Message-State: APjAAAU5LEp5Da/WqBaL4VRHgBOFrrfmiM7qONXtq9guGshvPMbfpO/S
        oK/bf5ihM2GEpyuLHC2ZiVLPukWpvcQiUnl2S6VUnZZtGxn/J5dK/cME+Q2vkmPgWHZPfVYWhA1
        0QU0Sv6i1SedY
X-Received: by 2002:a5d:49c4:: with SMTP id t4mr7614242wrs.242.1570704645362;
        Thu, 10 Oct 2019 03:50:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyAUpvDxsejwxKs/FKoQEGqKcCFjQ2DOCIheMbyTXCS7dsfl/Lhw3da0uewQazR2XTE22w4PQ==
X-Received: by 2002:a5d:49c4:: with SMTP id t4mr7614227wrs.242.1570704645151;
        Thu, 10 Oct 2019 03:50:45 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u11sm4393311wmd.32.2019.10.10.03.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2019 03:50:44 -0700 (PDT)
Subject: Re: [RFC v2 1/2] kvm: Mechanism to copy host timekeeping parameters
 into guest.
To:     Suleiman Souhlal <suleiman@google.com>, rkrcmar@redhat.com,
        tglx@linutronix.de
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ssouhlal@freebsd.org, tfiga@chromium.org, vkuznets@redhat.com
References: <20191010073055.183635-1-suleiman@google.com>
 <20191010073055.183635-2-suleiman@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e436f19b-8ff9-9442-897d-07fed3b424a4@redhat.com>
Date:   Thu, 10 Oct 2019 12:50:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191010073055.183635-2-suleiman@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/19 09:30, Suleiman Souhlal wrote:
>  	kvmclock_reset(vcpu);
>  
> +	if (vcpu->arch.pv_timekeeper_enabled)
> +		atomic_dec(&pv_timekeepers_nr);
> +

Please make the new MSR systemwide, there's no need to have one copy per
vCPU.  Also, it has to be cleared on reset.  I have just sent a patch
"[PATCH] kvm: clear kvmclock MSR on reset" and CCed you, you can add the
clearing to kvmclock_reset with that patch applied.

Paolo
