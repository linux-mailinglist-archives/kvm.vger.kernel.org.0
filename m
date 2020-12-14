Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3342D9B54
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 16:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406208AbgLNPnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 10:43:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729007AbgLNPnb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 10:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607960525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5MqMQKzQOSdZrk041m8eNtC5s8c67cMYU3gn9o6WzOQ=;
        b=dYKm10ZGzsZaRh42IPxmTJljk6I+e/VyxZSuSQeQD/kDP/wd2+hXiCEvqcZ9ddUpNeyLaG
        /Ra+SkC6J+QofUMq9uceghRgVUzm90Kl6hB/ox9CpYx69+nYeWFw9z3f08eXuhirxGi5A3
        z1MIq9H8VjXGg8QKV9mU9sf2nXiMzbw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-AzGlCtzrPEejEx8IXXmT-w-1; Mon, 14 Dec 2020 10:42:02 -0500
X-MC-Unique: AzGlCtzrPEejEx8IXXmT-w-1
Received: by mail-wr1-f72.google.com with SMTP id w8so6775452wrv.18
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 07:42:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5MqMQKzQOSdZrk041m8eNtC5s8c67cMYU3gn9o6WzOQ=;
        b=QO5wBROKxxI1HD8QKGpZWSzbgZp07V4jESt+cPyD3OzOx8uwLfIgtynPxVqRGPJLdK
         Kpk/3q3NrmE86FJhl4WdroqNjrsy6/xXTKxaFblCSNqsva6OhucaaUwIyXnDI2VmLXQw
         9bx6SS8Xd9XGpzJLcc20CDW0N/goi0lwMDCb9Fxxq9BNMSLuZf2zBVH2i7e+fU0HA2li
         kmYGwq0hDNIvjnOL5nZwXi3mB30tvvOEONkajo+0l7ttZBMqt6anHXu0SIhQvn70PLxe
         HSlEUjKgEsrLPdg2MDMkoT0wmwt5N1hf8IASbLGvo1vrQvmvF1uIhcHJd4I/hvzZMWkT
         zK4w==
X-Gm-Message-State: AOAM532/8Dd+be9x5RX609e8xN7bP9HWy6TBxdBXUr8hkIL8M5yCDvdY
        tetluA8qOXaRQUZ5XSk0Vd855lDn5Uu9+nN/AejxZldCx/+riHv99XNcCqrn3dooYACumen0bqY
        KK9atSLrBvkbd
X-Received: by 2002:a5d:504b:: with SMTP id h11mr29476554wrt.337.1607960521216;
        Mon, 14 Dec 2020 07:42:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxyJIp+lTZTT9sR0NCGPoEVoSmk9zQ5BbMRL/noLXCJ1EZncZsE/or2kVQEcH2swnRjb31WKw==
X-Received: by 2002:a5d:504b:: with SMTP id h11mr29476538wrt.337.1607960521046;
        Mon, 14 Dec 2020 07:42:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c4sm34435771wrw.72.2020.12.14.07.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 07:41:59 -0800 (PST)
Subject: Re: [PATCH v5 08/34] KVM: SVM: Prevent debugging under SEV-ES
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <8db966fa2f9803d6454ce773863025d0e2e7f3cc.1607620209.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da080e02-7921-1b67-2b3b-a480d38cfcb5@redhat.com>
Date:   Mon, 14 Dec 2020 16:41:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <8db966fa2f9803d6454ce773863025d0e2e7f3cc.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/20 18:09, Tom Lendacky wrote:
> Additionally, an SEV-ES guest must only and always intercept DR7 reads and
> writes. Update set_dr_intercepts() and clr_dr_intercepts() to account for
> this.

I cannot see it, where is this documented?

Paolo

