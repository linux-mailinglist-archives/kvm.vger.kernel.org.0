Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8ED54A6BE
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 18:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfFRQZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 12:25:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50741 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbfFRQZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 12:25:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so4012557wmf.0
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 09:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tGklFCGoDLJYWsL26YwJkMM1hbfoTY+/k9hjDQivqgk=;
        b=lVRW8BM/RQGTu/Tu+Bf2F2/LhLmciACKbSP0yWwwhISVTVB8peu+vgUeRXQSl4KR8G
         bJwUgmJiAaPktR7eaxBUTrWXpXRaRl0Gm8sHPJeXeAQ4+8K8Vvwkr3Q/r8eXORpIeyIG
         qLZT5Z5ceGEEVgd7217cgTF9Rj2tIHph7Un/uiw5bnstSRRtOQtr9FufcTrn+KeCH9Ml
         rXu6/JQ13KDeXaZH5xDxZuayKhsjccN8AcToz35UBMNNGYvX0+i2OAMLu/ih6aGiw3Ww
         83MydcA6tZ7XHqI+PdVz27FgmO5R1GijyyXQXnu3YJ1OsCTCxHq+5xQG78gt5QONIqmd
         mU2A==
X-Gm-Message-State: APjAAAWrVDJw0eXCRSd0Dn72/eq4kgEw18SHKkdae2+jfK5lN130+uXg
        Z6vpJXDvseF2Mhnj/c9AKcyxeg==
X-Google-Smtp-Source: APXvYqxRZjG7MV7QQxYq24OQ/IJnIS4uy+7SvSx96WMpwMQ9NYVBKLVvDRhfcXtxvJfts9zQXXdfOw==
X-Received: by 2002:a1c:65c3:: with SMTP id z186mr4615715wmb.116.1560875105473;
        Tue, 18 Jun 2019 09:25:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id 11sm3233483wmd.23.2019.06.18.09.25.00
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:25:04 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Modify struct kvm_nested_state to have explicit
 fields for data
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     jmattson@google.com, maran.wilson@oracle.com
References: <20190616120310.128373-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c740c43c-1dc0-e7e3-851a-9b0cdc496892@redhat.com>
Date:   Tue, 18 Jun 2019 18:25:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190616120310.128373-1-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/19 14:03, Liran Alon wrote:
> Improve the KVM_{GET,SET}_NESTED_STATE structs by detailing the format
> of VMX nested state data in a struct.
> 
> In order to avoid changing the ioctl values of
> KVM_{GET,SET}_NESTED_STATE, there is a need to preserve
> sizeof(struct kvm_nested_state). This is done by defining the data
> struct as "data.vmx[0]". It was the most elegant way I found to
> preserve struct size while still keeping struct readable and easy to
> maintain. It does have a misfortunate side-effect that now it has to be
> accessed as "data.vmx[0]" rather than just "data.vmx".
> 
> Because we are already modifying these structs, I also modified the
> following:
> * Define the "format" field values as macros.
> * Rename vmcs_pa to vmcs12_pa for better readability.
> * Add stub structs for AMD SVM.

I'm not sure it makes sense to add stub structs for SVM yet.  But as
noted in the QEMU patch review we should definitely add VMCS12_SIZE (or
better, a synonym of it that follows the KVM_NESTED_STATE_VMX_* naming).

I have just sent a v2 and I plan to queue it pretty soon.

Paolo
