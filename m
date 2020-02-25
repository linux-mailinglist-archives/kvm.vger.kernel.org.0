Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C64616C406
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgBYOgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:36:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53864 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730638AbgBYOgJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 09:36:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582641367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qQkKAh+IMe5D8qRJbmj17S6Uf0KPiGWejl7b1aEjsRI=;
        b=f1YFCBIDfvaDIaC6g7gxGuvxYcLu27DDupV7QY6o1FYKIhuUZl+Ag8ufO9MXA+2f5+fAcv
        5T0Aemd03lL2bXU6v8vgFo3EjffIEYVywl1Y1zecQKC1tfmg7PT2v60MD+548NBh/zfARS
        YzsljLVVQqSuoiFnW2GCIjNBm24K8Bw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-FwCusIvhNdSnNBS-JP5Rgg-1; Tue, 25 Feb 2020 09:36:05 -0500
X-MC-Unique: FwCusIvhNdSnNBS-JP5Rgg-1
Received: by mail-wr1-f71.google.com with SMTP id 90so7400052wrq.6
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:36:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qQkKAh+IMe5D8qRJbmj17S6Uf0KPiGWejl7b1aEjsRI=;
        b=mUDLSIx7+ehfaEtuSLkTu0EFhQ65MTH1H+tYTpHzsAfI5dI6JqWGhq8u7u1mQDqMB/
         HstuE9BaqChgqCLVorPFWOK9NqOHEUnWC3xxyK9T8rTopyUKnGAiogNDPRXQmBbROv75
         8GyLQZ3ULVVdOcG0czG/u3MfT6heiA7CsflPDu2fhAjrg3Uhp2ohC+CuaWk3XGpI6GM8
         cGQmMRbs0P12VODDaEgSLXBcF9gdQUvxH0y5msk5tuXKpADiPE95SqcHSpKVTfGxmFIk
         L4sMzOKN8sNY/CKS7UOee4Cn7+Lk2p91ZrRNaEyDw0Ah4vV+zsMH+7LW5Hg+iHo0Mmjw
         RndQ==
X-Gm-Message-State: APjAAAXCQ23N2A5Vy71l2YjovhAYy3/3/e1r6qfgqDhq5ltmcgajq0vZ
        DiikYh8wHUb2VDAyqd50v0b9n0cS4zXYxm+H3o7prXE+RuasIgvj8sxON3a/eBAJSkc3++2HlSH
        chpvc2m3Dw4wo
X-Received: by 2002:adf:f84a:: with SMTP id d10mr3391693wrq.208.1582641364779;
        Tue, 25 Feb 2020 06:36:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqxwNMJ2AmbkFH/U1r8SRcgK5A6QxWJZNkOjGHc8bd23bJs1LK+l3gqPf3Nnw3QaxqcOOSxbRw==
X-Received: by 2002:adf:f84a:: with SMTP id d10mr3391670wrq.208.1582641364511;
        Tue, 25 Feb 2020 06:36:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id y17sm24108400wrs.82.2020.02.25.06.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:36:03 -0800 (PST)
Subject: Re: [PATCH 01/61] KVM: x86: Return -E2BIG when
 KVM_GET_SUPPORTED_CPUID hits max entries
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-2-sean.j.christopherson@intel.com>
 <87mu9zomnn.fsf@vitty.brq.redhat.com>
 <20200203155903.GA19638@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <70f9ef36-b180-79d4-7d9a-8df8d6219122@redhat.com>
Date:   Tue, 25 Feb 2020 15:36:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203155903.GA19638@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/20 16:59, Sean Christopherson wrote:
> 
>> In particular, here the change is both the
>> return value and the fact that we don't do copy_to_user() anymore so I
>> think it's possible to meet a userspace which is going to get broken by
>> the change.
> Ugh, yeah, it would be possible.  Qemu (retries), CrosVM (hardcoded to
> 256 entries) and Firecracker (doesn't use the ioctl()) are all ok,
> hopefully all other VMMs used in production environments follow suit.
> 

Also: lkvm and selftests both hardcode the limit to 100.

Both would be broken by this change, but as long as the limit is < 100
now it is fine to change.

Paolo

