Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430B02FF81E
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 23:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbhAUWlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 17:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbhAUWk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 17:40:59 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B5DC06174A
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 14:40:19 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id p15so2570687pjv.3
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 14:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZM0IqfylJQO8fpBkI77F1H1VKg6hQFLtrN7oyrrKYhM=;
        b=brYcVyxMXMhRtAQg4ywy6K+79u14opqTKuDEHgYANxh/TTAWAlvwzSflTL6QXquP2c
         kTFcYFzLXkLTfin10lkDaT9NffnfcYLGHTpEXSbdbhh9821bdTyp/tJzJv3+JUbWQtiC
         nVXFvytHBFqfc6DcJ6SW2Z0b9vBYlthVLo2NKlwhKVYkes1NOeBuDpFkugJ5NtjtTpFp
         eT6AST3K8DdHsOjvNA/1wnsf0cPbMVkM35Xp92N3jvFzRGxf4212xhmYPrI4qg1q1Mc+
         xaaekxOIrbLNXUiYgvc8I5EXWEDCJTZO3vcvVz3obKst+dCxoaRLQltTKJ+3pHxTXI53
         uJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZM0IqfylJQO8fpBkI77F1H1VKg6hQFLtrN7oyrrKYhM=;
        b=KOcI2LQpfB0BjqaeGe0ieaFEXxmmLLZmh8KhzcfRbO/8uUV8TVCY5XiIC35WqHwf74
         CULMGzYjNkpuMRU1JowKKKwDKOjY1dcBLI+5pbZqip53JrKk/TO4Qbocj1buqD5UdroH
         /XloABf8iUKdpLaEkZwVBdgoq642ypRUzxDZiDcBQ3afDwOT0VoXob7/4eoIDOqLkP+M
         1V0DbqbRaEoYYwaGuj1f8a1dLhBoIyO3aDpPHlTrU3KqrirhE+DO4lYttcZ4OWstP6Ma
         hdSri2SrA2em7UFG/K7XeodCiYF16xg3MMK0nqWXuL/NhkOhmEaSMTOlLEiyIpkgy/5f
         8Eeg==
X-Gm-Message-State: AOAM532jIbL2spDynBB+x/cFsO0S8E+msjK16HQKMeA0pMR5WnglOOl3
        4vgbV0eJhuWhnqd8EWQIMuRYTg==
X-Google-Smtp-Source: ABdhPJydkXtTMozhDBPCHpRtvPfWauKZlpKXCN2rkk13/rERJFSNQ7GCWR+2mOdv4w4m/QVIM9UJww==
X-Received: by 2002:a17:90b:11cb:: with SMTP id gv11mr1898532pjb.4.1611268818901;
        Thu, 21 Jan 2021 14:40:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id k9sm6858083pjj.8.2021.01.21.14.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 14:40:18 -0800 (PST)
Date:   Thu, 21 Jan 2021 14:40:11 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Wei Huang <whuang2@amd.com>, Wei Huang <wei.huang2@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
Subject: Re: [PATCH v2 2/4] KVM: SVM: Add emulation support for #GP triggered
 by SVM instructions
Message-ID: <YAoCy5C0Zj97iSjN@google.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
 <20210121065508.1169585-3-wei.huang2@amd.com>
 <cc55536e913e79d7ca99cbeb853586ca5187c5a9.camel@redhat.com>
 <c77f4f42-657a-6643-8432-a07ccf3b221e@amd.com>
 <cd4e3b9a5d5e4b47fa78bfb0ce447e856b18f8c8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd4e3b9a5d5e4b47fa78bfb0ce447e856b18f8c8.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021, Maxim Levitsky wrote:
> BTW, on unrelated note, currently the smap test is broken in kvm-unit tests.
> I bisected it to commit 322cdd6405250a2a3e48db199f97a45ef519e226
> 
> It seems that the following hack (I have no idea why it works,
> since I haven't dug deep into the area 'fixes', the smap test for me)
> 
> -#define USER_BASE      (1 << 24)
> +#define USER_BASE      (1 << 25)

https://lkml.kernel.org/r/20210121111808.619347-2-imbrenda@linux.ibm.com
