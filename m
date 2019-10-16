Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03595D89CF
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 09:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390800AbfJPHfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 03:35:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731712AbfJPHfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 03:35:53 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68074368E2
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 07:35:53 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id l12so11296603wrm.6
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 00:35:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aUXJNZ56uDHpmR3Fqr2a3QUcW9MnHGC8oqVaiGxbnxg=;
        b=VcsdDaV+ZykJlZLCRt9I9AVrgTOxHYZJChD1YBfjivCB6x4/4z5DlyrpwBmGYQ77Su
         JjNcA49NxEzZftf0y3qyQdgHTr7jzCSlKYpwsZrS4LNjn71pgFRjZhjGvReCCspRR+gf
         MuskWgcwt1U13inHSYySIE8fV9oHJuLnhNYFGBsOtjKuVxGiCs4uWPHvSS9ZGZ8eSXsI
         2KwDIhsG9gGdZbYdvrqRKkVxMpZB1Iuav0M+M8x4NPINUhHXrPJvP3ExNr41LTQWc66q
         lwJDyzMnPfqWDeKoQR59EhdgyJ/PHmeXqLj/7X2WSNjqU+tLDIvoxKjLCRTf0T973MVz
         SGTA==
X-Gm-Message-State: APjAAAVeWjdADXuXtM+ksNuij/KxVvizKyhlFQ3WazfoeIkwJ32XrpiW
        FBP7mno7+Ub3JkIpmgot/Nd2+7Ug9OtUACbA21dBLdsYyNLOBhP3IRWQ5iFEt0i6FdoqDBm2ePX
        wknh/sZ10r8hs
X-Received: by 2002:a5d:490e:: with SMTP id x14mr1455262wrq.340.1571211352075;
        Wed, 16 Oct 2019 00:35:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxVESOIpGmDYbT+E/ZmD/y+tEKXgRYk+koZUWFQ+1lzfxFmsQ9uc1tZvxNWkaCqI4f6sHLF6w==
X-Received: by 2002:a5d:490e:: with SMTP id x14mr1455234wrq.340.1571211351806;
        Wed, 16 Oct 2019 00:35:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id e9sm7079487wme.3.2019.10.16.00.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 00:35:51 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
 <d14d22e2-d74c-ed73-b5bb-3ed5eb087deb@redhat.com>
 <6cc430c1-5729-c2d3-df11-3bf1ec1272f8@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <245dcfe2-d167-fdec-a371-506352d3c684@redhat.com>
Date:   Wed, 16 Oct 2019 09:35:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6cc430c1-5729-c2d3-df11-3bf1ec1272f8@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 03:52, Xiaoyao Li wrote:
>>
>> user_fpu could be made percpu too...  That would save a bit of memory
>> for each vCPU.  I'm holding on Xiaoyao's patch because a lot of the code
>> he's touching would go away then.
> 
> Sorry, I don't get clear your attitude.
> Do you mean the generic common function is not so better that I'd better
> to implement the percpu solution?

I wanted some time to give further thought to the percpu user_fpu idea.
 But kvm_load_guest_fpu and kvm_put_guest_fpu are not part of vcpu_load,
so it would not be so easy.  I'll just apply your patch now.

Paolo
