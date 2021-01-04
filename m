Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6332E9C63
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 18:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbhADRwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 12:52:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727623AbhADRwS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 12:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609782652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EyPd+qpzU+/10OSeEC3y3BOPpK2qGL3ApwiEekrWJOI=;
        b=ItvWawdpsJBHolSGIhmfeeSJbjiKG2gteUH3n30hD8B9Cfkds0pXYH0QegZyGB7nbO1RfV
        2pFDtwdksFAB0b823GRYzun59s/7Sb0TIL8wdYYSnfoj/CNyaqZlg19f1PyJjVpexkzQ1F
        ZGj5TSqUb6brSEbNXDR5BnJFgIF9CKY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-_zRrKkzcPb-JCQLMo-0AHQ-1; Mon, 04 Jan 2021 12:50:50 -0500
X-MC-Unique: _zRrKkzcPb-JCQLMo-0AHQ-1
Received: by mail-wm1-f69.google.com with SMTP id h21so10940285wmq.7
        for <kvm@vger.kernel.org>; Mon, 04 Jan 2021 09:50:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EyPd+qpzU+/10OSeEC3y3BOPpK2qGL3ApwiEekrWJOI=;
        b=X8qcvm3Z7NJPID5Uz9ePvAassMnHP2oQJh8BHfj86hTB3ViMNhSuZtQj+uN5kSIlo7
         xWBvQk4zaB/431trjX4qg0QzK3G6hmAbHreK+6XnbtCE6PFaRFYMNgUkmTY3lIddHf7l
         Q78LJUrbpYXOeo4TMhcSojzF34o5gwZxJ0ETTgjzZzJnXBpOoat0JFk+RWAI6N1SO+z6
         JiK38YCAdEDVtpNQz/0jFnQNsyzLqQAF+PPd0nUk6XQIcYw0+z/zZJgkFt9kmuwxM8rN
         JHW1L0CzzyJfGHu27h69hoZKZ9J1nNXm73x5R48vO8KkiqYAtwuwwl48hi948VknZxYp
         O/Gg==
X-Gm-Message-State: AOAM531vgIWtS6HT6OIricG14i+Nsfl7m4KOmoClTSb8Yvx5SKHkmWSR
        00rC72ZoUhO4JnJMH5EU5DSMTO29LZR5nuhhIXd679LMyRvPhWzP8mRz99vL7QUrwDBSLTAuPEx
        1g+0iC7hlu+kc
X-Received: by 2002:a5d:4112:: with SMTP id l18mr80442671wrp.116.1609782649395;
        Mon, 04 Jan 2021 09:50:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzwhWcj4/2hOH3p5+AnFtCBEv1VKsACzYx5d2Pg+R8scgY1DHbRQL0PAgven2/ITKBXm+uRyw==
X-Received: by 2002:a5d:4112:: with SMTP id l18mr80442648wrp.116.1609782649205;
        Mon, 04 Jan 2021 09:50:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u205sm28871wme.42.2021.01.04.09.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 09:50:48 -0800 (PST)
Subject: Re: [PATCH v5 27/34] KVM: SVM: Add support for booting APs for an
 SEV-ES guest
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
 <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
 <8ed48a0f-d490-d74d-d10a-968b561a4f2e@redhat.com>
 <2fd11067-a04c-7ce6-3fe1-79a4658bdfe7@amd.com>
 <620a7760-2c4b-c8b9-51e1-8008bf29221d@amd.com>
 <d411beab-b8b2-a7c9-af5b-3722db037910@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1433c219-ef19-aa19-7f5c-e872beff7356@redhat.com>
Date:   Mon, 4 Jan 2021 18:50:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <d411beab-b8b2-a7c9-af5b-3722db037910@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/01/21 18:38, Tom Lendacky wrote:
>>
>> Paolo, is this something along the lines of what you were thinking, or am
>> I off base? I created kvm_emulate_ap_reset_hold() to keep the code
>> consolidated and remove the duplication, but can easily make those 
>> changes
>> local to sev.c. I'd also like to rename SVM_VMGEXIT_AP_HLT_LOOP to
>> SVM_VMGEXIT_AP_RESET_HOLD to more closely match the GHBC document, but
>> that can be done later (if possible, since it is already part of the uapi
>> include file).
> 
> Paolo, a quick ping after the holidays as to whether this is the 
> approach you were thinking. I think there are a couple of places in 
> x86.c to update (vcpu_block() and kvm_arch_vcpu_ioctl_get_mpstate()), also.

Yes, this is the basic idea.

Paolo

