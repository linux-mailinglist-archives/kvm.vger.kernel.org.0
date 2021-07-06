Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6C73BD7C2
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 15:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhGFN2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 09:28:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231718AbhGFN16 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 09:27:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625577919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1B57ANHjAVcLhsuPRM1Y0QCiMQTnaCSGKrd9jRLx20=;
        b=eRZvtAmeQuhBGa3xVgf7F4g7YG+vUUkKfjiupEENA0xfO0RhZAOfCNsB1D6+q7YFLsAe//
        ii4wj0PuJPOnTo9OYec+RNxu3GdmKJSZU9/0wqb/QpKcBmVNB2/35epBy3DwEuyWpiztAK
        SHLy5APTAaPR5sa4W3z6/hza+twp4Lc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-RPCwRXyzMNaYD4jq1kHe6A-1; Tue, 06 Jul 2021 09:25:17 -0400
X-MC-Unique: RPCwRXyzMNaYD4jq1kHe6A-1
Received: by mail-ed1-f71.google.com with SMTP id o8-20020aa7dd480000b02903954c05c938so10810695edw.3
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:25:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C1B57ANHjAVcLhsuPRM1Y0QCiMQTnaCSGKrd9jRLx20=;
        b=YVLMlaaxm78pDvYlRTnOTqOezWL4g/j96dUQeiQvYD7nFu3yPrcbjBehUEBvYHvM1X
         5kC0E+QkWIpfM5QOjQSVBPBs/5QM7L6W0yeQN2kM1Ya3jkZNzLZdNs5DzR8I5zI7R+n4
         wvHt2QvrVF6JNZRGmsZ0ouV7t2cmunNUDIKTJAosx7/wrEKFoLr4e4f/78IcjrKhP+IN
         0xOjgroS0mymbejudKRLanuaoGAWoxSed7ai1N0nMdkHTc1JyXMM5UwB8MGqf5Ci/s2a
         gouS8B6+GqV08MGlZe9Nn586FwiKXjoYG5XFmWrCVamCwEb1NBo0vzOOfRkrbrsXeepM
         BJAA==
X-Gm-Message-State: AOAM5308C+0uRviyfV55zMCBvSD6ajIhJ7NJCSXmMfKHlOkWC8NJZA+q
        OHBY/JG7ls+mQctUAZiGaqUjN78ralqyParlysWR2TdjcPaHa/dw2FftPwW+Q0+SIyyQsHMaymq
        EcsHWZVKmqfcY
X-Received: by 2002:a17:907:2ce1:: with SMTP id hz1mr18090468ejc.376.1625577913297;
        Tue, 06 Jul 2021 06:25:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCtSyy3u5ljkzgyVxAxYf8T/FFmYNUqZm5zTvUNc0dO7fNIv/sQ7Iu9O+LJl/9DMIgIAXOWQ==
X-Received: by 2002:a17:907:2ce1:: with SMTP id hz1mr18090134ejc.376.1625577909447;
        Tue, 06 Jul 2021 06:25:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gl26sm5713802ejb.72.2021.07.06.06.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:25:08 -0700 (PDT)
Subject: Re: [RFC PATCH v2 09/69] KVM: TDX: Add C wrapper functions for TDX
 SEAMCALLs
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <96e4e50feee62f476f2dcf170d20f9267c7d7d6a.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <597dcaf4-19c0-3507-ebfa-e07cb32f784c@redhat.com>
Date:   Tue, 6 Jul 2021 15:25:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <96e4e50feee62f476f2dcf170d20f9267c7d7d6a.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> +static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
> +{
> +	return seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, 0, NULL);
> +}
> +

Since you have wrappers anyway, I don't like having an extra macro level 
just to remove the SEAMCALL_ prefix.  It messes up editors that look up 
the symbols.

Paolo

