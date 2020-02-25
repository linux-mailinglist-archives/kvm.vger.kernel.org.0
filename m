Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8BCF16C2C8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgBYNxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:53:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25504 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729065AbgBYNxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 08:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582638818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g+dtmvyyQhltLoB4R7/151zB27mnUy9MkrZ7W6Tc+tY=;
        b=f/vklw3JwoSJvULPOhYxFv20lkqJqifSgu7qLx/SySWZ6+iUCr9yEcYpFG7AKcRWmRMvre
        dU8osrG3Brh5ecc9kjzgU6ckqJLLeAKrlMnBb6EnwAvlJmzmzeEhxqWBhT5ODLeNyyJL9J
        Dx2+DlE0ZBfeP7N+n2XTIRV0WSTC5Qg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-nWbsA-YeNjaiHTy3V4S8uA-1; Tue, 25 Feb 2020 08:53:37 -0500
X-MC-Unique: nWbsA-YeNjaiHTy3V4S8uA-1
Received: by mail-wr1-f71.google.com with SMTP id m15so7291024wrs.22
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 05:53:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=g+dtmvyyQhltLoB4R7/151zB27mnUy9MkrZ7W6Tc+tY=;
        b=XHJgkY8rpQ+MjhEL0Kb5E0SMkXs3xT7bcIVG+mUwVEUD+z74eN9He0HdSqyBztZl2O
         T17PXIeIsLLJJ2wwVfUNHxzuateauKJ63BJfcCk/sbiBB4AB9jJSQC8EXBUxpwT0RvVp
         qlIsd8FXkE3RxeQA/c3GT46TQRi97Y2Uy4FrjIqvgcDFioApVx3y26NtoxmoejHiljbr
         265CEthtivWOGamOOdzKyB4somknWKre89LAypwoIeYcfl7tGqZMsUPI0P5yWqOeEXHY
         urOhnzj2aVkGGKtt0hIbySesoye3T+UXPrXCQtc2KUSeKXuNU4QCeC8Bzi81tvcbjhwC
         M7aQ==
X-Gm-Message-State: APjAAAUhae2wGRMTV8NTbHFyhdPoyADuTaR+lp/jdWmLZ0a7IVKgxvV3
        9ZqJf/8ZYJIZ0ukGp8pBYRSV+m+tG2JvxDIs4s2hGVxGT/nYeWtJD1YKF2l04FmCazUgptTZ2k/
        JxE38GMaCAJ1I
X-Received: by 2002:a1c:238e:: with SMTP id j136mr5509866wmj.33.1582638816067;
        Tue, 25 Feb 2020 05:53:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqzRNrbfqdLfP2T/8HWo4yZpAbcqoVoybvQCuR0Yz6CzqeiveSd65IOm+ITqUFo0QoJK9tyE0w==
X-Received: by 2002:a1c:238e:: with SMTP id j136mr5509791wmj.33.1582638814949;
        Tue, 25 Feb 2020 05:53:34 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o2sm4218045wmh.46.2020.02.25.05.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:53:34 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 48/61] KVM: x86: Do host CPUID at load time to mask KVM cpu caps
In-Reply-To: <20200224233119.GS29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-49-sean.j.christopherson@intel.com> <87o8tnmwni.fsf@vitty.brq.redhat.com> <20200224233119.GS29865@linux.intel.com>
Date:   Tue, 25 Feb 2020 14:53:33 +0100
Message-ID: <871rqin57m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Feb 24, 2020 at 11:46:09PM +0100, Vitaly Kuznetsov wrote:
>> 
>> If we don't really believe that masking will actually mask anything,
>> maybe we should move it under '#ifdef CONFIG_KVM_CPUID_AUDIT'? And/or 
>> add a WARN_ON()?
>
> I'm not opposed to trying that, but I'd definitely want to do it as a
> separate patch, or maybe even let it stew separately in kvm/queue for a
> few cycles.
>

Sounds like a good idea)

-- 
Vitaly

