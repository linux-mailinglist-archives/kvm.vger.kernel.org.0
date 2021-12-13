Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F43D473012
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 16:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhLMPGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 10:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbhLMPGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 10:06:30 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20228C061574;
        Mon, 13 Dec 2021 07:06:30 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x15so53969582edv.1;
        Mon, 13 Dec 2021 07:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=05MSUOX7QKlZHM76FG8mrj5dNi0SySsL9hwhrZB90/w=;
        b=qTSuFPTLolLl3YBOOOIP13LOXuzcr7aLCbRrc9Cu5Qk1rJsS80JIIkNZQlxR8r88yk
         yTSKFnKR5/7y7VCElgHukPP7SuRsw9E0nRe9UvfpIq/DigZxR9Y7EoaSRwilAtDOhmgi
         qTi3Zhga/7Yo+hFEYJnHTVAXMoxsWi4WiKMI8Ese0l5tscopSIqJX1k1libg+lieDCLG
         ZzbT4VaEuqXrdfNWdA6a5tFWoY/VkQya0ITI+4mCc+ghqtd9EvTUTh5WzNOKxpbP9nvy
         61TVgRyIUteS6mkLcPKr7zGES8lMvbqcjGkf6c06AGMDnsUoIvJfdrJagfP/D0FtwBe4
         0r0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=05MSUOX7QKlZHM76FG8mrj5dNi0SySsL9hwhrZB90/w=;
        b=0U0KYc2EqWcWrbWTj2lRI+qahcrub1PJWukOscIyS+YDb0o5x79/Uu780BNYtgnCSr
         qc6cyNkcQa95IirvKGi0+Ng0amYgzAxjSwi0KlN7TO5/7u+Ytak2h4+6uiOdFenQxjqg
         kWaSbLBUStNQsAqvvDwHYKXctJNjU3cjk8qPIgUYeiDJD2mEvCnHjxCzhuzGZNmu+wGk
         xyJfwcK27tHrWSEWIGhwWeZGNJlWcoeRShyUbPXiGxspRoe3S0ZWdg3zDzMWvwMH5Avq
         IVFZ9E6xDpwbUaSAy4+7HvomSvAi/hn/c1bUXR6kZarQs8iu2Tmzrrxgs5C8KrZozadY
         aEpA==
X-Gm-Message-State: AOAM531BTTXKtYBjnH1YtAmzio72Lds3j1jbPRrVV544TnLCrCG2DEHh
        KZwBUn2lBo8Bver2DLdhNfM=
X-Google-Smtp-Source: ABdhPJxlFPQxAhtEOPHZcRPWluXeSwT2vPHNvpF32tXtYU6hX4CPmtvP3EiGpZdyS65qG74mYattkw==
X-Received: by 2002:a17:906:eda3:: with SMTP id sa3mr45390200ejb.51.1639407985274;
        Mon, 13 Dec 2021 07:06:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ar4sm5799601ejc.52.2021.12.13.07.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 07:06:24 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <022620db-13ad-8118-5296-ae2913d41f1f@redhat.com>
Date:   Mon, 13 Dec 2021 16:06:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-11-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
> +		/*
> +		 * Update IA32_XFD to the guest value so #NM can be
> +		 * raised properly in the guest. Instead of directly
> +		 * writing the MSR, call a helper to avoid breaking
> +		 * per-cpu cached value in fpu core.
> +		 */
> +		fpregs_lock();
> +		current->thread.fpu.fpstate->xfd = data;

This is wrong, it should be written in vcpu->arch.guest_fpu.

> +		xfd_update_state(current->thread.fpu.fpstate);

This is okay though, so that KVM_SET_MSR will not write XFD and WRMSR will.

That said, I think xfd_update_state should not have an argument. 
current->thread.fpu.fpstate->xfd is the only fpstate that should be 
synced with the xfd_state per-CPU variable.

Paolo

> +		fpregs_unlock();

