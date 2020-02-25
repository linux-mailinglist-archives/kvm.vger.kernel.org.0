Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A14D16C1D4
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbgBYNLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:11:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35344 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729813AbgBYNLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 08:11:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582636282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SrvIza9mOSZ4BvN1tdCV2aqsL8mIKXTuoDQsYHobl7Q=;
        b=Vd1xhohznY+H6CvmmarDoVjDGRUV8DErLPZ8IBDzqLJ0jMcz310Ai62SmtjbFWkKpKk8IH
        9NBJ2qcTqvhhyoadezhS4nUFT9qMgMQYWEwl3Z6eYUve2WSmv455kCWzeaD/OlKZ4qpqXF
        3QjroLxtP5C76QT7sfhg0+tmJgzYnQU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-dVjCpZamO1C5zIHwWZCL-g-1; Tue, 25 Feb 2020 08:11:20 -0500
X-MC-Unique: dVjCpZamO1C5zIHwWZCL-g-1
Received: by mail-wm1-f70.google.com with SMTP id p2so1006129wmi.8
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 05:11:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SrvIza9mOSZ4BvN1tdCV2aqsL8mIKXTuoDQsYHobl7Q=;
        b=sAH6UoPCYcTcMbN8hKJpz6okS/0vjvhbRg39/73DMgHtITXEUBXpea8q9q1SHyLPi9
         1Nm0KcTf1Oc15ytTFtZxXfn7vo8JzZr3DAKDlN3H6OVMsE55weurvHgd/TXF6rV2PQ4P
         swBJprqnuYhsp2mC/qjZVRnjYsxaA4qgJDrp++1oIQoJbCN8XT3WQoFVL3WFxOcazfl7
         oU1K0Cxam2tWQ9mqA7SMhtZWr2L35l6PuuHKmcai/uXOndy0/qaIdo7jRPbCG87QaZDj
         zQjaWcmJfyNnjkmMSwPx8Ng4EayQykUuV0k9bgykf1+Zi75n8Qa8zMPr4bj7TS2fbZbj
         JwRQ==
X-Gm-Message-State: APjAAAVq44x5nKRWP7t3RDRAkyrbgDPAaJblbaJyk9xWoU6r2sYPgKSz
        JhcmBMhJxFm4GTPYg4F6nwmDN61CrTAj1Zut60T7zrFrmNPVgj95c2Ko0D2BMalKlUZP4mo8coV
        vyDkLOXdypwzA
X-Received: by 2002:adf:ecc2:: with SMTP id s2mr74647037wro.263.1582636279021;
        Tue, 25 Feb 2020 05:11:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqxpadiCu4wJadbmfz9YW8gpthFBOSPDdgS5RXo5AREoIYALFfuLJhgF1HiTZB17D3Z3e8IlUg==
X-Received: by 2002:adf:ecc2:: with SMTP id s2mr74647024wro.263.1582636278846;
        Tue, 25 Feb 2020 05:11:18 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a26sm4057339wmm.18.2020.02.25.05.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:11:17 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] kvm: vmx: Use basic exit reason to check if it's the specific VM EXIT
In-Reply-To: <716806df-c0e4-43d5-b082-627d2c312f53@oracle.com>
References: <20200224020751.1469-1-xiaoyao.li@intel.com> <20200224020751.1469-2-xiaoyao.li@intel.com> <87lfosp9xs.fsf@vitty.brq.redhat.com> <d9744594-4a66-d867-f785-64ce4d42b848@intel.com> <716806df-c0e4-43d5-b082-627d2c312f53@oracle.com>
Date:   Tue, 25 Feb 2020 14:11:16 +0100
Message-ID: <877e0an763.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:

>
> We have a macro for bit 31,
>
>      VMX_EXIT_REASONS_FAILED_VMENTRY                0x80000000
>
>
> Does it make sense to define a macro like that instead ? Say,
>
>      VMX_BASIC_EXIT_REASON        0x0000ffff
>

0xffffU ?

> and then we do,
>
>      u32 exit_reason = vmx->exit_reason;
>      u16 basic_exit_reason = exit_reason & VMX_BASIC_EXIT_REASON;
>

Just a naming suggestion: if we decide to go down this road, let's name
it e.g. VMX_BASIC_EXIT_REASON_MASK to make it clear this is *not* an
exit reason.  

-- 
Vitaly

