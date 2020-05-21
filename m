Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60031DC8DD
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 10:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgEUIk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 04:40:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58650 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbgEUIk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 04:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590050425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dOW7B8nLICvI2QSpCheBsPrgf3sHzyca7R6p70npClk=;
        b=hivjN41fD7uoNuRV4HGhG29XzIFbdXd6EwQRjKt8cVYkunMLzRDbFUPhaTqnfGUxz3etVz
        JAmAsDyem8X8U3CerNmz1YBA1KqER9NoVzGnAsuRxHA3/k9iWTvwDOvjUN/be1jUHRAMd0
        MD7VoDjjIRbRaJCrsXM7ttyKAhs5f10=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-UAmjcDq2OCygFEmYNiza6Q-1; Thu, 21 May 2020 04:40:23 -0400
X-MC-Unique: UAmjcDq2OCygFEmYNiza6Q-1
Received: by mail-wr1-f70.google.com with SMTP id r14so2618791wrw.8
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 01:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dOW7B8nLICvI2QSpCheBsPrgf3sHzyca7R6p70npClk=;
        b=p5VKwtAyWmrhN2pgwcMpcDcLORMVqb/5GDUVFUaCxakJKlGXJktrZeOddlvG5FkVGc
         GZrUXj/jqF8H01NxQsNUx/DL4EiXOprTvBujNE0srhgd7yMagF1LZWfm2+N5BMTeSrwq
         95CMbz6PxSXrvlbnigQa99GtPxjXhozW22wYVBWcg8H08poywrpfg5OX6AIIFCmIBQb9
         sHLp5TFgG6d+6rmOauIomXy0mgCBhsCutn0cgqxbBQOOfXTQ2S/tNufHDVW19+k95a3a
         kYQqozyX8y0Q3W2nEdzj44BTicOhdz6RcgDJg7J/YYY9IaUWwjGuO9YaecBQwpNOB8Fw
         WogA==
X-Gm-Message-State: AOAM532ku6hWUHgCNG6AZRw20g3Spd3PN1gA7pSJp5mIlDAy08CvIk7/
        /6WbUNWiIVEh4X9YQkMrw4u7oLlAAoMiRWvfl61mZsraoEkoCHPEf2oKTa0S4ufBo9fzR07tWkx
        A2YtEM+weKSJ1
X-Received: by 2002:a7b:c193:: with SMTP id y19mr7935734wmi.158.1590050422639;
        Thu, 21 May 2020 01:40:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxukfKVUk2qDd/EsYglDEd1qglHM6q51pYRYREmlhXPiE9KQzqCcOX8bFxDroTR47/pAlGPuw==
X-Received: by 2002:a7b:c193:: with SMTP id y19mr7935709wmi.158.1590050422401;
        Thu, 21 May 2020 01:40:22 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.94.134])
        by smtp.gmail.com with ESMTPSA id x18sm5169145wru.72.2020.05.21.01.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 01:40:21 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
To:     Tao Xu <tao3.xu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200520160740.6144-1-mlevitsk@redhat.com>
 <20200520160740.6144-3-mlevitsk@redhat.com>
 <b8ca9ea1-2958-3ab4-2e86-2edbee1ca9d9@redhat.com>
 <81228a0e-7797-4f34-3d6d-5b0550c10a8f@intel.com>
 <c1cbcfe4-07a1-a166-afaf-251cc0319aad@intel.com>
 <ad6c9663-2d9d-cfbd-f10d-5745731488fa@intel.com>
 <6c99b807-fe67-23b5-3332-b7200bf5d639@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3642373d-8d1d-de80-d3db-e835a8f29449@redhat.com>
Date:   Thu, 21 May 2020 10:40:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6c99b807-fe67-23b5-3332-b7200bf5d639@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/20 08:44, Tao Xu wrote:
> 
> I am sorry, I mean:
> By default, we don't expose WAITPKG to guest. For QEMU, we can use
> "-overcommit cpu-pm=on" to use WAITPKG.

But UMONITOR, UMWAIT and TPAUSE are not NOPs on older processors (which
I should have checked before committing your patch, I admit).  So you
have broken "-cpu host -overcommit cpu-pm=on" on any processor that
doesn't have WAITPKG.  I'll send a patch.

Paolo

