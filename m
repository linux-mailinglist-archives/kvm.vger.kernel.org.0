Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17233E5A61
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 14:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240854AbhHJMuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 08:50:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240831AbhHJMuW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 08:50:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628599800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CrJJsbAkLGNgRBl30mWJDu4C6R0HhYbl466l69qWuNo=;
        b=fx/xkC8VzAb1I4cFNXVRR77w4zZ6D+Tyq0yMfCPiv6t15C+qh7L/S3/bx07tMahujVr/Ej
        e/TqYaOD4XMTjibxWGksm9tKhK9RJ8TdGR5KaOP7tmX0KfenMgX4wlXDJIHpqOZ2ehYCgj
        QWkcNDJzSIC+sAicVaLTrJlxrIslKfU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-rCTnVPNeP5CZmC0ECoRRTQ-1; Tue, 10 Aug 2021 08:49:59 -0400
X-MC-Unique: rCTnVPNeP5CZmC0ECoRRTQ-1
Received: by mail-ed1-f70.google.com with SMTP id e3-20020a50ec830000b02903be5be2fc73so4673566edr.16
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 05:49:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CrJJsbAkLGNgRBl30mWJDu4C6R0HhYbl466l69qWuNo=;
        b=kIIqt6LQJFUKxeiThZWkTr5dFXf5Ktc3ExLNafGYWDw1ZjHWa5ZoHvnPt+rtSCNNGG
         O46En90a9dEJw/GMu3/RLEQe04OmRBqIonwKCQ+badyE5dl3dK4f4RPb/i3n8XvY8A7B
         K9n1nRcc2sqSvbLkGEP4wDrQtXSMboGn7fmfSiYDvyv45Wq6WZq4nx1bRTYJrw0InnEU
         kJHTborzyy3wMFH1/xpXkl0Q60t8oT+HbmLTn1GBeK30HstpEXTH+QqpBGM2WAF2pTMy
         Av+8vtlGcg/gwXfnNRLZSEKCujXu4nJgAuv4YNmCbmyASskmjMFUJeHtSs7aDFrfFHZE
         yPuQ==
X-Gm-Message-State: AOAM533oln0l2gLyOddPVFkUZtBUGbUbQEZEWi/b+maPKkLNNU3W5cR+
        hzO217WPjzAuIKKxPDxlXKyYJwbVIxWEbMzY4V55TS4DZo9EJqnYbcGTBKbBLBIRuN2V7f5+ywk
        lgWr+5t0+8lZHIjq7Oqp/+NoDvhuti69/ZEJMqcj1Ryb3aF84uzMAhcfD0VZ1BQkH
X-Received: by 2002:a17:906:3fd7:: with SMTP id k23mr10765219ejj.176.1628599797978;
        Tue, 10 Aug 2021 05:49:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFLHW5kax97qIP8ewfDh6uPQkc89girs1g1d7+ETW92PSAenZdEwjl94gWbyXPERUKhx8NjQ==
X-Received: by 2002:a17:906:3fd7:: with SMTP id k23mr10765194ejj.176.1628599797728;
        Tue, 10 Aug 2021 05:49:57 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id cb4sm6818998ejb.72.2021.08.10.05.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 05:49:57 -0700 (PDT)
Subject: Re: [PATCH V2 2/3] KVM: X86: Set the hardware DR6 only when
 KVM_DEBUGREG_WONT_EXIT
To:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <YRFdq8sNuXYpgemU@google.com>
 <20210809174307.145263-1-jiangshanlai@gmail.com>
 <20210809174307.145263-2-jiangshanlai@gmail.com>
 <68ed0f5c-40f1-c240-4ad1-b435568cf753@redhat.com>
 <45fef019-8bd9-2acb-bd53-1243a8a07c4e@linux.alibaba.com>
 <f5967e16-3910-5604-7890-9a1741045ce8@redhat.com>
 <7f86316b-5010-5250-4223-5a4d62f942c8@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ffbc18d0-aeca-ce0e-5bb8-612e7f5800d1@redhat.com>
Date:   Tue, 10 Aug 2021 14:49:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7f86316b-5010-5250-4223-5a4d62f942c8@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/21 12:46, Lai Jiangshan wrote:
> I'm OK with it. But I don't think the sketched idea would cause DR6 to 
> be marked uselessly as dirty in SVM. It doesn't mark it dirty if the 
> value is unchanged, and the value is always DR6_ACTIVE_LOW except when 
> it just clears KVM_DEBUGREG_WONT_EXIT.

It would be marked dirty if it is not DR6_ACTIVE_LOW, because it would 
be set first to DR6_ACTIVE_LOW in svm_handle_exit and then set back to 
the guest value on the next entry.

Paolo

