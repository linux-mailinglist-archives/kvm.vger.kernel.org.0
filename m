Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261912CECC5
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 12:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgLDLJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 06:09:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727365AbgLDLJv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 06:09:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607080105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51Ta8qG1IJwa9FMhdW7Zn/PZ+B+58uhGmZ7f+I3PgHQ=;
        b=G2cAzR3TjPli7PM4v2tlSj95HPKpGMnAKiLCgXfQCwz90y/OA2WpAFNfGQjeCzBoBRDK3F
        3TLnVz1z9fVy2e0HiVzpCnjw6/MQW/NG0TV9N6kqxQkbfIh1HOcn0pEx9iE1nf1Lg50pXk
        mKRn+FS6oNs0PEFv8p4Lh8RpH9Bmf6Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-ywXqg6rrN3Wg9Lzkvmx1pg-1; Fri, 04 Dec 2020 06:08:23 -0500
X-MC-Unique: ywXqg6rrN3Wg9Lzkvmx1pg-1
Received: by mail-wr1-f71.google.com with SMTP id b1so2376014wrc.14
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 03:08:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=51Ta8qG1IJwa9FMhdW7Zn/PZ+B+58uhGmZ7f+I3PgHQ=;
        b=oHxhaK4DOptQxa/z/mGrOS2mkdjjsuTQauv/QytojWvJGBYVooVZGq5TCH7fsWPGpm
         zFM1VcAZCl4PKEC6U55iOeupCvvaFmYQSILdw0jF8RVjtQmnLsYxW8mBLQtPJahWkuLA
         6Jpi9006TNm3pZl44LfvlJ28i+QRH97Z1+iD/zNVbp2Ks35SP8utw8dBtjbff9Nv1vn+
         7/uSnldGa7lmVB9eTtldvFQKXUndMSconNmVEwo4A32MAvHnqIHsY+13HRzSvHYyGezd
         U+eduNASwitPbh9hjs7gNsHETSyrEGHUlTUghI+LfId6TfG2DrQjUftHhXxkbUNGltGT
         XsSw==
X-Gm-Message-State: AOAM532V20okIlc3maOfAHmjISSMqILCg+pAOy6vurBGs5XLghE6bl+Q
        iHnRcS/TMa6SSsIXeDwRo/+aKNCSW8TlPxAayg6gYSkCBVFBmeWs/LgJqmn+1spq7Awr/4aj9Kg
        B4yp75Qt/fDTR
X-Received: by 2002:a7b:cb82:: with SMTP id m2mr3540694wmi.75.1607080102592;
        Fri, 04 Dec 2020 03:08:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaSpQbJ4PCf7tY/VAwGU9ugjT37tjEuse2PP6trdypYVGMkqe9JgB5jOkELb4bTR9auHQTnQ==
X-Received: by 2002:a7b:cb82:: with SMTP id m2mr3540670wmi.75.1607080102413;
        Fri, 04 Dec 2020 03:08:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b17sm2245212wrv.10.2020.12.04.03.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 03:08:21 -0800 (PST)
Subject: Re: [PATCH v8 12/18] KVM: SVM: Add support for static allocation of
 unified Page Encryption Bitmap.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <17c14245a404ff679253313ffe899c5f4e966717.1588711355.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <617d3cba-cbe0-0f18-bdf2-e73a70e472d6@redhat.com>
Date:   Fri, 4 Dec 2020 12:08:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <17c14245a404ff679253313ffe899c5f4e966717.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 23:18, Ashish Kalra wrote:
> Add support for static 
> allocation of the unified Page encryption bitmap by extending 
> kvm_arch_commit_memory_region() callack to add svm specific x86_ops 
> which can read the userspace provided memory region/memslots and 
> calculate the amount of guest RAM managed by the KVM and grow the bitmap 
> based on that information, i.e. the highest guest PA that is mapped by a 
> memslot.

Hi Ashish,

the commit message should explain why this is needed or useful.

Paolo

