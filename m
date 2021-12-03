Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB89E467921
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 15:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381354AbhLCOM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 09:12:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352539AbhLCOM5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 09:12:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638540572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Th3/AwwdNWFRMVyXQbUB5Zn699vPcry9PjQt24tDZNs=;
        b=BnvbZmSxAKuvvWFBMi779uHrkQGll0hXImSlHmkSWpO7ywlwSlsIBz6Kj5TGGYEcqZt+Ws
        1EKfjkacukyWiUhKPTrWxTecZc1X4Dgjgm5kwpcHdAXK9vAbKkpY+WyWSaAvdKDHI3nlDq
        ESj7hRUa5t32cu+XiS1ieiPE9Q5u/nA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-uY2Buk0JMayWCLSef6KRlg-1; Fri, 03 Dec 2021 09:09:31 -0500
X-MC-Unique: uY2Buk0JMayWCLSef6KRlg-1
Received: by mail-wr1-f70.google.com with SMTP id v17-20020adfedd1000000b0017c5e737b02so647175wro.18
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 06:09:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Th3/AwwdNWFRMVyXQbUB5Zn699vPcry9PjQt24tDZNs=;
        b=DUdUkOvUhm05TEL7ax/IFz4+QNY7gLtzNgcNK2dOq7wZtAL6C5Ia+c4d86cijX2/ph
         NdYz3ZwDAqBeTqY7ozHSPO14p8NvdUgqoWTtj2VBwcEhx/0nUd+bQQ2OxYCErcjrM2mw
         JNQXMjNvPaSmy+6nkV+0CymCRfTXEoi5esI/Y6ZhQhzZoHbURYSAXGMYP9WGkpnNOjK4
         8WLzSbAF1oRk3DmYAHYDAHvCYlbGtlYQjwiZqcSJxUNj344txjLBWBidUF4khejfSAjW
         azBnnuvz9bjeMyKkdL8NhLkRkQsP2toU+ZE97JSSqfbdhpLgfI1S9PsudDVsN/YQ1KdB
         q3qw==
X-Gm-Message-State: AOAM533078s/jGkQKj/OUtvuxvN8HsFELqZ/s6WD1K4Hr7dOgvlq1rN5
        dSXsnsFOxSN09pxTnU0H7uBDGfZxy1zND8sSKZSyjGgPKKBtwcA1qGu27ovOfJnBmGSIofoyhw4
        8NVGxa7E0Ge1e
X-Received: by 2002:adf:e2c5:: with SMTP id d5mr21726919wrj.338.1638540569911;
        Fri, 03 Dec 2021 06:09:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwn8SCemCKl3G0iSjXXF2Z8BcbWnjoIe4SW0+H1SuKLyllcsxQUH/Bt1H7vpADvQabw8WfPDw==
X-Received: by 2002:adf:e2c5:: with SMTP id d5mr21726875wrj.338.1638540569626;
        Fri, 03 Dec 2021 06:09:29 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f15sm3497480wmg.30.2021.12.03.06.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 06:09:29 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ajay Garg <ajaygargnsit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: ** POTENTIAL FRAUD ALERT - RED HAT ** RE: [PATCH v2 8/8] KVM:
 x86: Add checks for reserved-to-zero Hyper-V hypercall fields
In-Reply-To: <MWHPR21MB1593E284E412873C64B54A32D7699@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211030000800.3065132-1-seanjc@google.com>
 <20211030000800.3065132-9-seanjc@google.com>
 <87v91cjhch.fsf@vitty.brq.redhat.com> <YagrxIknF9DX8l8L@google.com>
 <MWHPR21MB1593E284E412873C64B54A32D7699@MWHPR21MB1593.namprd21.prod.outlook.com>
Date:   Fri, 03 Dec 2021 15:09:27 +0100
Message-ID: <87o85x7pbc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Michael Kelley (LINUX)" <mikelley@microsoft.com> writes:

> From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, December 1, 2021 6:13 PM
>> 
>> On Mon, Nov 01, 2021, Vitaly Kuznetsov wrote:
>> > Sean Christopherson <seanjc@google.com> writes:
>> >
>> > > Add checks for the three fields in Hyper-V's hypercall params that must
>> > > be zero.  Per the TLFS, HV_STATUS_INVALID_HYPERCALL_INPUT is returned if
>> > > "A reserved bit in the specified hypercall input value is non-zero."
>> > >
>> > > Note, the TLFS has an off-by-one bug for the last reserved field, which
>> > > it defines as being bits 64:60.  The same section states "The input field
>> > > 64-bit value called a hypercall input value.", i.e. bit 64 doesn't
>> > > exist.
>> >
>> > This version are you looking at? I can't see this issue in 6.0b
>> 
>> It's the web-based documentation, the 6.0b PDF indeed does not have the same bug.
>> 
>> https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/hypercall-interface#hypercall-inputs
>
> Did you (or Vitaly) file a bug report on this doc issue?  If not, I can do so.
>

Done, https://github.com/MicrosoftDocs/Virtualization-Documentation/pull/1682

-- 
Vitaly

