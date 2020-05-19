Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9991D91B2
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 10:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgESIGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 04:06:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56859 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728237AbgESIGb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 May 2020 04:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589875589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zTmYRJOomIgyr1GJva/MlpDq9Augv2jVYca4cwH5sKk=;
        b=YhIF0KchQHRFZ34W3s4GuP96CLoXaQUHTT1OCs+c2dcWRd0ewN4pVImXGcEPNI77YEh8PA
        6VcZsKGdxE+3g9oV5oa8RKAdkwPfRT3prbOye/gHM0BLfmBMDjpbalp5rBTgXzhS5AgK1I
        WUJzbUonmuHzekxmK0rm4QPNWBREdc8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-kKb3Q5h_MJqEk_S8S6G7Hg-1; Tue, 19 May 2020 04:06:26 -0400
X-MC-Unique: kKb3Q5h_MJqEk_S8S6G7Hg-1
Received: by mail-wm1-f69.google.com with SMTP id 202so639648wmb.8
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 01:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zTmYRJOomIgyr1GJva/MlpDq9Augv2jVYca4cwH5sKk=;
        b=ltnFrOL4Xedl9IBT/BXHI+d4qJfiL4ohHnpfeHPPmwOzdjFA+4xW5tm44sfBdY8b34
         tXsckuf/eU77RdSpSbMdWScpH2UVqC3LgZZzBxpuv15skHMhabxaUu4L0Vou0/Fvqpa+
         NuE/cMwV2L/KtbeovZtN7L/yZ/82gw08C1DbFa43+xO53mzFdLzprWXNkdp/DxtMOq0Z
         9zBoSgzTMdduJT1KpXgNId1JxFpmqm9kuFZ9y9nBcedf9ellNKWQ6DeH8MflQ9fKEgcX
         MLMUUTe91V5x3bPtY4Suov77D97sU1d5+w2upFwk9y0iMDbqUWKlhV0Oi6lpH3BNOPT6
         Xb+A==
X-Gm-Message-State: AOAM531UWpdgL6eEyrjMXr0LMIkEl40XMTkjVYA2Jziq/QgUwb39aFRD
        ie5Fp+/KbIEWWfCjS6YwUC9Y9JEQO8v1V+S9NmYbmBIZaOjC1dmrRqNzam3trQyx8csvzCweyOJ
        ArNq/AQRrNAEN
X-Received: by 2002:a5d:6412:: with SMTP id z18mr23601140wru.290.1589875585442;
        Tue, 19 May 2020 01:06:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVAwBqypNVb4EjZNBJe4pBgTmmFmS0JdNUPvJrHnft87IHXaujmvYBQ95BfBP1tYlNKUignw==
X-Received: by 2002:a5d:6412:: with SMTP id z18mr23601118wru.290.1589875585187;
        Tue, 19 May 2020 01:06:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:80b4:c788:c2c5:81c2? ([2001:b07:6468:f312:80b4:c788:c2c5:81c2])
        by smtp.gmail.com with ESMTPSA id r2sm20095577wrg.84.2020.05.19.01.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 01:06:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: emulate reserved nops from 0f/18 to 0f/1f
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200515161919.29249-1-pbonzini@redhat.com>
 <20200518160720.GB3632@linux.intel.com>
 <57d9da9b-00ec-3fe0-c69a-f7f00c68a90d@redhat.com>
 <20200519060156.GB4387@linux.intel.com>
 <60c2c33c-a316-86d2-118a-96b9f4770559@redhat.com>
 <20200519075523.GE5189@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be7fa327-51b9-1f95-454d-f4f9c15a1b63@redhat.com>
Date:   Tue, 19 May 2020 10:06:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200519075523.GE5189@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/20 09:55, Sean Christopherson wrote:
>> Running arbitrary code under the emulator is problematic anyway with
>> CET, since you won't be checking ENDBR markers or updating the state
>> machine.  So perhaps in addition to what you say we should have a mode
>> where, unless unrestricted guest is disabled, the emulator only accepts
>> I/O, MOV and ALU instructions.
>
> Doh, I forgot all about those pesky ENDBR markers.  I think a slimmed down
> emulator makes sense?

Or just slimmed down opcode tables.

> Tangentially related, isn't the whole fastop thing doomed once CET kernel
> support lands?

Why?  You do need to add endbr markers and some of the fastop handlers
won't fit in 8 bytes, but that should be it.

Paolo

