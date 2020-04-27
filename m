Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DA61BAD8E
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 21:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgD0TJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 15:09:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726315AbgD0TJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 15:09:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588014585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQf0JdKn9fSmRfZbYIguzX8UAvoKyiiMf06OglslXog=;
        b=NpwnMS8Ka/M0/qMumYd8zdwuw3KYblvQaWyjeL1AX5BqCcRJ8so1hzGlz/C6ez4YQUNUbB
        lEsQ2+FcWkHRwjsJRBrBv9jX0Urv1m0z5u7vXSFp17iuzRXRjS9jdUmW8WmZ58tgdlchuH
        kpFbsjJL61PwpXbI/iNtkOq9wMLLATY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-LDvJRRWINn-HgTiitsRcUg-1; Mon, 27 Apr 2020 15:09:43 -0400
X-MC-Unique: LDvJRRWINn-HgTiitsRcUg-1
Received: by mail-wr1-f71.google.com with SMTP id f15so11053659wrj.2
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 12:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fQf0JdKn9fSmRfZbYIguzX8UAvoKyiiMf06OglslXog=;
        b=Tb3kQa8GhiVDuuPVEVAn7bddMkXavYWrMSaRwhEpwAmbo58ACt9OUEfAvI3lsq0jJy
         KU+4T5qFTEhfcaLgbjBvAFPx1AKvmwaceV7tFT1mQ9+W7h9VPbbfzLIr5W6FKUbkiDEs
         YWFIT9m+PiHhfrAnjsSEfKf9C0H6ZTBDpacqm+Pf98jLkLBE0LEuVBye9n5Z8xNSnUZP
         IHAw52MbdxLhr2p2tLo/UHE/aEHo20vSb/mYhWsMv2CbqJqFHKtQWDi2z7QkJPMGdEiM
         rsQ8sXWBbutiv4PJOAbcbTQpXUl0roNdaFH7ynQ+OLyFFNhWeXVCahB/VD724qtRsnL1
         118w==
X-Gm-Message-State: AGi0PubSB0wXnXRbiLH+UDedewvMhC9Xo89WP36p0dLglpaQTLJxuh3o
        56+S4DAKm2GUzwTQ0caUODgVHgwSwE9kyXslSenMn3hVJN+r/4UWc4nSFnJiG0pUvSu8gdMtGtk
        bm47ljMpA1Q8D
X-Received: by 2002:a1c:dc55:: with SMTP id t82mr219659wmg.12.1588014582461;
        Mon, 27 Apr 2020 12:09:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypIZYNBAaiKQGOrg9835xWa2K0IRaCFS4dqVqf5n883HYptUYcWCRGPxH1I/rZd0YeqpukeqPA==
X-Received: by 2002:a1c:dc55:: with SMTP id t82mr219645wmg.12.1588014582249;
        Mon, 27 Apr 2020 12:09:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id n2sm22714476wrq.74.2020.04.27.12.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 12:09:41 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Use accessor to read vmcs.INTR_INFO when
 handling exception
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200427171837.22613-1-sean.j.christopherson@intel.com>
 <8123dc4b-a449-a92c-85a1-c255fa2bbbca@redhat.com>
 <20200427173241.GJ14870@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3bad600c-71e6-c094-59a4-f82144adddb4@redhat.com>
Date:   Mon, 27 Apr 2020 21:09:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200427173241.GJ14870@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/20 19:32, Sean Christopherson wrote:
> No, I missed this case in the original patch, and the other fix was for
> incorrect sizing of an exit_qual variable.

Nevermind, I applied it twice and I got an "Already applied" message on
the second invocation.

