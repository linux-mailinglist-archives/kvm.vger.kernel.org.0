Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C29F1A49F8
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 20:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgDJSoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 14:44:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30480 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726177AbgDJSoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 14:44:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586544241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muV+cJsdsOKsLWWU/F5WJmj/GF+e031GyF6t6y1qNfQ=;
        b=RhcMe8RxIeWZT8jpoFMVLiQWmqNrxFvkLEP6CCsoXmO/6X0X2NgS0Iqi57h+yzC774D7LA
        Kqfhj0sJtD0SXJsedJAv8WhFtfzMciRYuAAbFnvY0FYHa5l7oFA5B1Rnd9DET+W0krGa0N
        ZyDV9RjayqpPjd/70szANx3t0eOYBWs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-e4xwk7cuOX6Ts7iMu8_iFg-1; Fri, 10 Apr 2020 14:43:56 -0400
X-MC-Unique: e4xwk7cuOX6Ts7iMu8_iFg-1
Received: by mail-wr1-f70.google.com with SMTP id m15so1771048wrb.0
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 11:43:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=muV+cJsdsOKsLWWU/F5WJmj/GF+e031GyF6t6y1qNfQ=;
        b=GCz83XV5z3qQktST9gD4UE7xvsza2vont58BshkuQgOHrR78FkMrStqC4PcYHzYqXS
         8LYx1G91IVWG8sL0Srf/jVd6gG8DyoQ9bdBVXl8LGkZ2GShFNM/RTYlBZ6plh4UIIl5z
         lx/XZ+W8CHUBW4+0ECH1UpqbkjqK+0lILXMqcy8AqAi79dAoQSzJoVRtXgvwI3FWYiK+
         WmxLXkjRkrr8pQhLYdfE+Z8rtK2l3ubiyT/vnbDOtynH7IiLReX2RuARnvFSlykcfT+H
         8aOs4OYv1GU9nuF/WVuIeh20b27becfizEuq9tJEVakYtjpK5oTHS1CZqyzb8dkkQ7j/
         pZlQ==
X-Gm-Message-State: AGi0Pua6mlEFkRzZzpq6/mtIaZoQUTxjHFlJ8JTfpWKUV5hGPbDkAdB9
        UniYmH+gARZzIdPTTsuqNtuP9AH6mlxfn9LR4UV5SIdAZTyTlD0tBFhj/vMpBShhHrSBSCmqT3f
        CY0qIDRCupIwi
X-Received: by 2002:adf:fc45:: with SMTP id e5mr5496595wrs.427.1586544235733;
        Fri, 10 Apr 2020 11:43:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypKRX6u3Awun5ouqjbkGartZIXgkX3B2/ELx/x4dsaREKRdnRPWG6TGFHO1CznRrhFt8aqSIWg==
X-Received: by 2002:adf:fc45:: with SMTP id e5mr5496570wrs.427.1586544235489;
        Fri, 10 Apr 2020 11:43:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c938:f991:b948:b0ca? ([2001:b07:6468:f312:c938:f991:b948:b0ca])
        by smtp.gmail.com with ESMTPSA id v7sm3908396wrs.96.2020.04.10.11.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 11:43:54 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: X86: Ultra fast single target IPI fastpath
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Haiwei Li <lihaiwei@tencent.com>
References: <f51251cc-885e-2f7a-b18d-faa76db15b87@redhat.com>
 <20200410174703.1138-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a7530d71-dd57-5a22-ee34-da65caa3eea8@redhat.com>
Date:   Fri, 10 Apr 2020 20:43:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200410174703.1138-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/04/20 19:47, Sean Christopherson wrote:
> If that's open-coded in vmx_vcpu_run(), I'm ok with doing the
> fast-IPI handler immediately after the failure checks.
> 
> And fast-IPI aside, the code could use a bit of optimization to
> prioritize successful VM-Enter, which would slot in nicely as a prep
> patch.

Yes, I agree with these.

Paolo

