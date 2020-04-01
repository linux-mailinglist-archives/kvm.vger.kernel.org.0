Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3166319A2F6
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 02:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731480AbgDAAfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 20:35:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729514AbgDAAfj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 20:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585701338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nUYw2tAk2ElDzMusCcbVaLfYkke7kPKvnnUATst9aPY=;
        b=IYWNwQolZeY1nXPeZ1lzMZMh28aEcAst8reDWvsLBdDX4GqZBIVLMrXQHQxpUXXFVXv1ra
        oWhNw4dK/KGcr4c7LwpeXTAQiwVyzRLWXK5H5H2IenYDus/hfHkoExPqZpngMnskCBNMSq
        M9LLJL9v7okPYM/MbxJQV9E1bPuLTXA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-9QWqrRO-NYGvVPnuCs5M1w-1; Tue, 31 Mar 2020 20:35:36 -0400
X-MC-Unique: 9QWqrRO-NYGvVPnuCs5M1w-1
Received: by mail-wm1-f71.google.com with SMTP id l13so984012wme.7
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 17:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nUYw2tAk2ElDzMusCcbVaLfYkke7kPKvnnUATst9aPY=;
        b=PiMHpPzR4dj1PSmvenIouhW3gznpWIG7XOPU9XP9JKUse0Af/aUclSFwZr23LevdUy
         Cd6KQ33ZaB2GDkW3Je11N/HCM709LzWEQMkDUCzKuOqDn2MT9eyqFx6WiveSo13dDgH6
         lYrUGIzBdqcsuHGrLWXlX8b90/4fpUwBbIAyyWECKUy7ddwwWxjSc4ofcrhJJZSqt1dO
         nqkPIslBbedwOxefUfTGwsLksXmS6HVF4oyWwfk0dIN4zbkm9YW1B8kt9BgKxOosfHzc
         FGBd6gob11nmepLJNUpQy7PqEKqv2X8O+kNjPiH7wsDLwODDvjkz7xCtupSWsuFSVi1e
         3aTw==
X-Gm-Message-State: ANhLgQ3TUIzoQ0zQXdFFDlFjjnHJhN03jTYEwWqfPq72NnxneFd/ImQB
        L61z6SREyXjNEbHo6opwzFFkDkrJnVnDNZbXcFr6Ppde14wwy1xekf7LRpjk76AvMYMf+3Ps7Dq
        tP+T+3ynLWnil
X-Received: by 2002:a5d:6045:: with SMTP id j5mr22859752wrt.401.1585701335109;
        Tue, 31 Mar 2020 17:35:35 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsu1SKpiUOGspGol9SelarOc4faOore5cmYKuXnJXLQ8H5FnAv74R3mri0v4DKf1Dgdrl2WkQ==
X-Received: by 2002:a5d:6045:: with SMTP id j5mr22859728wrt.401.1585701334854;
        Tue, 31 Mar 2020 17:35:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id i21sm400563wmb.23.2020.03.31.17.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 17:35:34 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] KVM: LAPIC: Don't need to clear IPI delivery
 status in x2apic mode
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1585700362-11892-1-git-send-email-wanpengli@tencent.com>
 <1585700362-11892-2-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6de1a454-60fc-2bda-841d-f9ceb606d4c6@redhat.com>
Date:   Wed, 1 Apr 2020 02:35:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1585700362-11892-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/20 02:19, Wanpeng Li wrote:
> -		/* No delay here, so we always clear the pending bit */
> -		val &= ~(1 << 12);
> +		/* Immediately clear Delivery Status in xAPIC mode */
> +		if (!apic_x2apic_mode(apic))
> +			val &= ~(1 << 12);

This adds a conditional, and the old behavior was valid according to the
SDM: "software should not assume the value returned by reading the ICR
is the last written value".

Paolo

