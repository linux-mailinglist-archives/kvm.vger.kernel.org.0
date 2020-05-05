Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF581C5236
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 11:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgEEJyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 05:54:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24226 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725766AbgEEJyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 05:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588672458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TlhlzZcZdCKqn6uGJjCk/Di1gwjV8y+RUYlK2OkS3b4=;
        b=NULRXHdPgHgWBPkEnVjyBg1y7v6TnFSBOK+TgvU0O2hRMFimRq7fVnTgRIGigSLrmwycHk
        z4C4IAmybf5f8t25v0UeWknrH6uBUNAUCRMRe0lo7lFaFYLqcidZIgYrGAg/mtRGsUQJR+
        e43ehBVghsvbslcyBg6j06wpNzgPCxA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-tfs41hNZMvuqSFzarWfXqg-1; Tue, 05 May 2020 05:54:16 -0400
X-MC-Unique: tfs41hNZMvuqSFzarWfXqg-1
Received: by mail-wm1-f71.google.com with SMTP id f17so614194wmm.5
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 02:54:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TlhlzZcZdCKqn6uGJjCk/Di1gwjV8y+RUYlK2OkS3b4=;
        b=qRJ/4CalKNLL8G1DtEfvgReXMxXXLbyUzIyWFZ1I8fqTQ6YJRMmrwagYUFvj7kxHs9
         IMqrb2EExiArcNYLKpW50lLukEKDCarbbjur6viKMOKdxTeWtSRkCohL1DD7fGAMsTYq
         7uvA9aOkWKUjElM/kdxjXcAtiMkhuPBTLYiA50DyJ4RkoL9a91T75aRAwNOx+ml06AFH
         yAPOWeam28wfkZyrbNhTOiJb6/aoVumCshopErnS/kkUISkUrWTeShqP/bjU8I+YWetI
         WeJ+YFLUgVwJDSeMDnh3vqtpaI1t2FbCjgiITiQ57u5l5RCPmhiiET3gkKHcQvzvMeFk
         Bpgg==
X-Gm-Message-State: AGi0PuY64rLv0DSunIqpYBADkGDXtatjsXIN2hTwLQ/avkAuaV8ke0dM
        yZC1vJEJUnmJvn8odXUVI3gAkkGZzAJBfRsk3u0ar175RRGoFDCIybCfFq/0GzwKFnGHZ+RTwBg
        bQIEhIHt5jxtt
X-Received: by 2002:a1c:770f:: with SMTP id t15mr2334149wmi.178.1588672455602;
        Tue, 05 May 2020 02:54:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypLwWpFo/EZANuablSCEtbPe77SC3Q23ygQMJ3/l0rAGmnTrMl4z0V4JetgLFE2GKMi+iRoCOg==
X-Received: by 2002:a1c:770f:: with SMTP id t15mr2334116wmi.178.1588672455367;
        Tue, 05 May 2020 02:54:15 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id y3sm2506687wrm.64.2020.05.05.02.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 02:54:14 -0700 (PDT)
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Gavin Shan <gshan@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-5-vkuznets@redhat.com>
 <bdd3fba1-72d6-9096-e63d-a89f2990a26d@redhat.com>
 <87y2q6dcfm.fsf@vitty.brq.redhat.com>
 <f7e76889-a8fc-a348-90c2-2c27f3706585@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0a48d7f-a71d-ab72-dccc-4fa1445c854d@redhat.com>
Date:   Tue, 5 May 2020 11:54:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <f7e76889-a8fc-a348-90c2-2c27f3706585@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 10:51, Gavin Shan wrote:
>> How does the guest know if host has any pending events or not?
> 
> One way would be through struct kvm_vcpu_pv_apf_data, which is visible
> to host and guest. In the host, the workers that have completed their
> work (GUP) are queued into vcpu->async_pf.done. So we need a bit in
> struct kvm_vcpu_pv_apf_data, written by host while read by guest to
> see if there pending work. I even don't think the writer/reader need
> to be synchronized.

No, this cannot work.  The problem is that you need a way to tell the
host "you can give me another ready page", and a memory location is not
enough for that.

Paolo

