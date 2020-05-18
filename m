Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEC71D78AA
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 14:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgERMcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 08:32:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40146 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726682AbgERMcA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 08:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589805118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSwYOVViRmho7SQfsfACP8dXKwqAgv5XuIjfF821PSU=;
        b=hoyvxbOlXky1wnDbrX6jMt2qm58vX5BLcULP2RfWStKOeG0/dfL7qENbYU8mo4hz1dVbk/
        LC/Ki9w2zmitNlD9CfevHCXMxuzB7h6qbxDCmRMfJvReVZUkz7n1FmTQ0wjbo0IuFI51se
        lK+5Ncs17vcJPS96t5RCTLin2q432jI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-yN9rH3jfOxWUS1KMd63KFg-1; Mon, 18 May 2020 08:31:57 -0400
X-MC-Unique: yN9rH3jfOxWUS1KMd63KFg-1
Received: by mail-wr1-f71.google.com with SMTP id h12so5574035wrr.19
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 05:31:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JSwYOVViRmho7SQfsfACP8dXKwqAgv5XuIjfF821PSU=;
        b=E8lGmw1hsWpG8e8CP8qcZnGlUHkw0HtHOfJaO0PaMRR+MxIe8vbjKhOKR2wWKRHz02
         L+dkjxxr1Jua1RmwrBw+V1ywcEVm5i24r685oTgz8tXihehOOacufbKkOt9WKBnQknVC
         MfTh7uFnWuMRcKZwcQOI1yyv298hPEPKo6RY5zNqx4GCo2GDZI+dbQfiFafaIyNDOjOr
         ZjZyPqxXtOR9A30NDbysV96Tecpgo12UGgMEG6PBABB72pmvTvDExuKE26t4QRD5Vr+0
         0wuC9k98oij0Pw+VKzfENNVxU1W98l0KbGfl0Wu+kBK7ULqUrPka/doXyr/E+xoFDpbk
         nJIg==
X-Gm-Message-State: AOAM532h0uYD0F3FKQUhB5s4EnFVVzttETZhw66tYv+rBZkWgShSvg7u
        82ssczZC4T8VU6/v0Bw9o8sBoWiwmFN+3qRoGACscNxe08zwSOc5cPItJ8MOdIBijteSSvi+1RL
        9GN6b1sOgVwb4
X-Received: by 2002:a1c:c2c6:: with SMTP id s189mr20300111wmf.25.1589805115984;
        Mon, 18 May 2020 05:31:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeeGxVDfzc+aC9AYtRchJxAqaRHN553hwC8AKlTRhhdZrmctqO5FrFE9595gxCNWK9MUNt4w==
X-Received: by 2002:a1c:c2c6:: with SMTP id s189mr20300085wmf.25.1589805115732;
        Mon, 18 May 2020 05:31:55 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
        by smtp.gmail.com with ESMTPSA id b12sm16992464wmj.0.2020.05.18.05.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 05:31:55 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Use KVM CPU capabilities to determine CR4
 reserved bits
To:     Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jmattson@google.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200506094436.3202-1-pbonzini@redhat.com>
 <6a4daca4-6034-901a-261f-215df7d606a6@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <09cb27f8-fa02-4b37-94de-1a4d86b9bdbd@redhat.com>
Date:   Mon, 18 May 2020 14:31:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6a4daca4-6034-901a-261f-215df7d606a6@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/20 06:52, Xiaoyao Li wrote:
> On 5/6/2020 5:44 PM, Paolo Bonzini wrote:
>> Using CPUID data can be useful for the processor compatibility
>> check, but that's it.  Using it to compute guest-reserved bits
>> can have both false positives (such as LA57 and UMIP which we
>> are already handling) and false negatives: 
> 
>> in particular, with
>> this patch we don't allow anymore a KVM guest to set CR4.PKE
>> when CR4.PKE is clear on the host.
> 
> A common question about whether a feature can be exposed to guest:
> 
> Given a feature, there is a CPUID bit to enumerate it, and a CR4 bit to
> turn it on/off. Whether the feature can be exposed to guest only depends
> on host CR4 setting? I.e., if CPUID bit is not cleared in cpu_data in
> host but host kernel doesn't set the corresponding CR4 bit to turn it
> on, we cannot expose the feature to guest. right?

It depends.  The most obvious case is that the host kernel doesn't use
CR4.PSE but we even use 4MB pages to emulate paging disabled mode when
the processor doesn't support unrestricted guests.

Basically, the question is whether we are able to save/restore any
processor state attached to the CR4 bit on vmexit/vmentry.  In this case
there is no PKRU field in the VMCS and the RDPKRU/WRPKRU instructions
require CR4.PKE=1; therefore, we cannot let the guest enable CR4.PKE
unless it's also enabled on the host.

Paolo

