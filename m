Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FA23DA04C
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 11:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbhG2Jdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 05:33:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232663AbhG2Jdj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 05:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627551216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=md6Oc7TeV7HG+jATakLwy9ixrHl66kXuQgl0GJ9Fitg=;
        b=EWCjkcYLpQOt6uWHhfWl98hE6jiEyC9qHTVj0ewXg3XEX6r7qLPw38UlbsYcniPsGycedg
        kHCFp2AXwl5nLEX4pVUVrOrZ9doiXreIPHPFC7EyrWhm/PjPDKLPHtsReEHkvrxJrd62mu
        U+dn/YAnM+R5d1L8u86ASRUr9XHNwMQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-eVq5d8C_O_iyC-LdpFMKWg-1; Thu, 29 Jul 2021 05:33:35 -0400
X-MC-Unique: eVq5d8C_O_iyC-LdpFMKWg-1
Received: by mail-ej1-f70.google.com with SMTP id kq12-20020a170906abccb0290591922761bdso501451ejb.7
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 02:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=md6Oc7TeV7HG+jATakLwy9ixrHl66kXuQgl0GJ9Fitg=;
        b=Y1NvZgkXwN8WjdmzkcHg3hgbKII+9jdvG1hZO1HHDhmgX4AbnYvibksqK6g1bHqm90
         X3VAOxYVj5k2qvdrM+mBWEZnlnzkV593cpOMxis+RggBnXbvLz8pqmOy4v9WdR/d8U/3
         bXUUyBbjZmuhs5CA7hARyut9QUwjVvzdPGeh69RUMoLdd1LXzs/Ph9USMnJAe/2mlsyF
         sOjkFmplIhP7Po+BnTKBb2+Qwei5g26Y2L+XfvmK6xXTflDvXzz/m3C/3Xt1fHVkLw6N
         fG4RmrG/7hNjwdxvSMYEXXU50tze/mnksQ5V3RbMcO4xKzjaznO+zsxpxcav/XgLeOOl
         d38A==
X-Gm-Message-State: AOAM531LZzSYaspqyTK2NWoKGZZtAX8mr/jeduDsG2ueunjD++CV79ZK
        PcZvweRLlvZZ3UmoZLyThTVjg01RzFeJM4guui8BEN9W5e8XBd0t5+ITOsavo/Yluyu/rhea+eR
        qMAhiZcwJvfyW
X-Received: by 2002:a05:6402:221c:: with SMTP id cq28mr4957590edb.115.1627551214266;
        Thu, 29 Jul 2021 02:33:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWtYyeEsKK8QG2q57jEd8WiiG65QrD/ajD03X4+P7WkyzcEeGdZ/zqOSInTNjlj7S2BmXcEg==
X-Received: by 2002:a05:6402:221c:: with SMTP id cq28mr4957587edb.115.1627551214144;
        Thu, 29 Jul 2021 02:33:34 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id i11sm951152eds.72.2021.07.29.02.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 02:33:33 -0700 (PDT)
Subject: Re: [PATCH v2 8/9] KVM: X86: Optimize pte_list_desc with per-array
 counter
To:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153415.43620-1-peterx@redhat.com> <YQHGXhOc5gO9aYsL@google.com>
 <YQHRV/uEZ4LqPVNI@t490s>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc9eb6da-59ce-2dd3-c39c-8348088cadcb@redhat.com>
Date:   Thu, 29 Jul 2021 11:33:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQHRV/uEZ4LqPVNI@t490s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/21 23:51, Peter Xu wrote:
> Reasonable.  Not sure whether this would change the numbers a bit in the commit
> message; it can be slightly better but also possible to be non-observable.
> Paolo, let me know if you want me to repost/retest with the change (along with
> keeping the comment in the other patch).

Yes, feel free please start from the patches in kvm/queue (there were 
some conflicts, so it will save you the rebasing work) and send v3 
according to Sean's callbacks.

Paolo

