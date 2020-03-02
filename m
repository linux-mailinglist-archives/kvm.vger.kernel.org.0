Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 707A0175F1D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgCBQFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:05:10 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52307 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727401AbgCBQFK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Mar 2020 11:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583165109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TzjWFgUV0o3WEpqZfCi50NLB5vc0uNlHzWOpvHJh3Xc=;
        b=CQVcwnC1SDOIsDTjWqMecSreaEj7JK80W62mBtSeUNDHUFWSHU7BnC0o++abHV1jKeH/on
        wDwEbXgqzPOP1lRYo1/nLBQASR90c0H+Fpn6FlqQr61a6XM3TdxWB6N4Fz5I5gIP25FmFw
        c1vNK8LYo1kO4ukZLEuK3Nlm9DJwYZ4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-lf9ViT4zOku2GAeWLZFi2Q-1; Mon, 02 Mar 2020 11:05:05 -0500
X-MC-Unique: lf9ViT4zOku2GAeWLZFi2Q-1
Received: by mail-wr1-f72.google.com with SMTP id w11so1804717wrp.20
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 08:05:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TzjWFgUV0o3WEpqZfCi50NLB5vc0uNlHzWOpvHJh3Xc=;
        b=c1Kx8dMH5xnNz9wFyCMbuuLzMQVzbBO4fUwQKNBKIKEie7sk1NxcMH67ZS0Uer01ZD
         WXIURTLA+Aqqp1liMjQReIZKBp7U3LMAvMbB+M8i9Ad3G/500AATuQqlb/F0MKIrxwu1
         4M+9tDo/3SGbMJaC032MaKr3S2otkdCxNAjxSKPwIFugF7cEuCYZ3NByqbB+lYz5Z9Hh
         flXhd7N9aUDxNlXWhkDp0CIDAfjzuJsAF3Me13Vnd0IBrZz57pl/d+O4Dsvqg81i01ou
         88kvX4tTF02yPOQLDyXk4s/IUDRSbh218Bmhyq77i+SGyw5VxRhx3p0j76WnrZZCKGI0
         HlGA==
X-Gm-Message-State: ANhLgQ0TwXJCRqlROLjO7LczJ+HOPD3BCY4KWTFjgNYGqaA1oZqgbXxD
        V3xHdjNhn74Xz62leVcHU3HOLja5Fq5AdHO0ngP1pnSzI72HJt3T0C/gQ+ZYBmB9ITG4TiTQddZ
        /ua5kCIqz4Gn/
X-Received: by 2002:adf:a304:: with SMTP id c4mr303062wrb.186.1583165104345;
        Mon, 02 Mar 2020 08:05:04 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtLyS9ziQmq5CsqnaVCSE9YqCiD2HQdZUHo0h02SGMzzZ+cx57J7O9ZVp26aGR7xFTPnsIEeA==
X-Received: by 2002:adf:a304:: with SMTP id c4mr303047wrb.186.1583165104112;
        Mon, 02 Mar 2020 08:05:04 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id u8sm16865895wmm.15.2020.03.02.08.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 08:05:03 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Fix svm the vmexit error_code of WRMSR
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     hpa@zytor.com, bp@alien8.de, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joro@8bytes.org" <joro@8bytes.org>, jmattson@google.com,
        wanpengli@tencent.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, x86@kernel.org
References: <CAB5KdOZwZUvgmHX5C53SBU0WttEF4wBFpgqiGahD2OkojQJZ-Q@mail.gmail.com>
 <87o8tehq88.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30830ba4-d8d3-df58-f039-57e750ae90a7@redhat.com>
Date:   Mon, 2 Mar 2020 17:05:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87o8tehq88.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 13:54, Vitaly Kuznetsov wrote:
>>          enum exit_fastpath_completion *exit_fastpath)
>>   {
>>          if (!is_guest_mode(vcpu) &&
>> -               to_svm(vcpu)->vmcb->control.exit_code ==
>> EXIT_REASON_MSR_WRITE)
> There is an extra newline here (in case it's not just me).

Yes, the whole patch has broken newlines.  I fixed it up and applied.

>> +               (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR) &&
>> +               (to_svm(vcpu)->vmcb->control.exit_info_1 & 1))
>
> Could we add defines for '1' and '0', like
> SVM_EXITINFO_MSR_WRITE/SVM_EXITINFO_MSR_READ maybe?

We can eliminate "& 1" completely since that's what msr_interception does.

Paolo

