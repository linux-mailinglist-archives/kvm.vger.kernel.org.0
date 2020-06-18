Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AA91FF014
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 12:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgFRK7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 06:59:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29479 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727805AbgFRK7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 06:59:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592477972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B4ymCPVOrzD26cLd7e7ZxsUEn02gLoqcQg/EGZ48yLQ=;
        b=fC4dHPWzXCUt7uUZKyzJkioVtANlzcw/roPKo/2gE+SaPB2FDXnQo6scg4X/ElyzlcLzUy
        wjlOo6oZAqtIu1d10cplasDOeI/0Nvg7a/ZpIIXpaq/JBcRlRoDb/38fEsKf0PvRUTibjc
        u027Eat5LOa2tLl6s0vlzmyVvDzCBgw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-bnFDiFS7NYuiMmVJU4c7wA-1; Thu, 18 Jun 2020 06:59:30 -0400
X-MC-Unique: bnFDiFS7NYuiMmVJU4c7wA-1
Received: by mail-wr1-f69.google.com with SMTP id a4so2649849wrp.5
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 03:59:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B4ymCPVOrzD26cLd7e7ZxsUEn02gLoqcQg/EGZ48yLQ=;
        b=fpNACc7Smy/0s3Iu+hV7rnBgtlv2ZrG6OK6PWT1Z6hefaH+QJS4Hg49i9PFyu4b046
         DzOw4ULiXe84Y+QuA0ZiQO6XHUHqiWYyFJMr4Lnf0syzB1rWqaKUHt9T80dpcT4M8D22
         7uHctGB+2Ufx8ROuHPbM8IbznLGnvTy9rvgIqJHdt6rfQ8G1wklWpW4+1iztsrOEXl3F
         MdElnAKPW8pEH2rAWwzLcqaN44M2bkiYWIiqlR//BE++jilz74j7Of3pPT/qgiYcrsHN
         7JIkbZg8RhDqgq2jnleH0sYrEpASF+Q3S4XwD+24JFjk4buUS+0B9Mwk06rMFZ9ci/fS
         Yeow==
X-Gm-Message-State: AOAM532AiIlXvpOEz1BycWMOzYJPM7axuq4ADH7qgiUtPWZLPV3lk7x+
        7HsManq1aFwCZpnAIosEF0aaJ/4A6+AcZezjv9sX11dJu0beqXuTROg4coCmEjkdZ2m+FtMeLFW
        SRnEgFNZcEJPG
X-Received: by 2002:a1c:7e52:: with SMTP id z79mr3603192wmc.104.1592477969200;
        Thu, 18 Jun 2020 03:59:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZojsPun+QYWlisetTv5WpaznMjr4VlzHf9HSBejwt4olGv5Jk/r425yF3VyrRhnGksxZcOw==
X-Received: by 2002:a1c:7e52:: with SMTP id z79mr3603173wmc.104.1592477969038;
        Thu, 18 Jun 2020 03:59:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id e5sm187714wrs.33.2020.06.18.03.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 03:59:28 -0700 (PDT)
Subject: Re: [PATCH] target/arm/kvm: Check supported feature per accelerator
 (not per vCPU)
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Haibo Xu <haibo.xu@linaro.org>
References: <20200617130800.26355-1-philmd@redhat.com>
 <20200618092208.nn67fgre4h7yjcnt@kamzik.brq.redhat.com>
 <8729ee44-77dd-ab25-b400-859e59ced160@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3b0dd59d-40d1-745a-d083-cfdfc4a246c5@redhat.com>
Date:   Thu, 18 Jun 2020 12:59:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <8729ee44-77dd-ab25-b400-859e59ced160@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/20 12:17, Philippe Mathieu-Daudé wrote:
>>>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_SVE;
>>>      }
>>>  
>>> -- 
>>> 2.21.3
>>>
>>>
>> At all callsites we pass current_accel() to the kvm_arm_<feat>_supported()
>> functions. Is there any reason not to drop their input parameter and just
>> use current_accel() internally?
> Clever idea :)

Or just the kvm_state global.

Paolo

