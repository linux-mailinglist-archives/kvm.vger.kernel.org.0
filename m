Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DF53A24D2
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 08:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFJG46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 02:56:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhFJG45 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 02:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623308101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/GOWHlANnDBXMOgWQ7qYUSqp48aMNk3hEFsxwtf6GI4=;
        b=TO8jILrxWW5ZGj/hlrnDofkeMp9hHJch6CSji+/btUu+SAqNYwdL1qea6RTHEOLC9E9RL0
        ay2TyInr75okGqI9hOSOoM6DqhzycBnsQu7N6W2txFmflg5/3k9nICUSN+ko/kP/UCfqbI
        M7/fjBwQxR3fCy1OcHNCZQP2q5FmOEI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-gJw4L1oJPz-zn9kA4T73Hg-1; Thu, 10 Jun 2021 02:54:59 -0400
X-MC-Unique: gJw4L1oJPz-zn9kA4T73Hg-1
Received: by mail-wr1-f70.google.com with SMTP id d5-20020a0560001865b0290119bba6e1c7so416502wri.20
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 23:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/GOWHlANnDBXMOgWQ7qYUSqp48aMNk3hEFsxwtf6GI4=;
        b=TrR6KjN70u3HuCzr3yTypv0/gC46NPN6VLkcGYHq00wSC/Hpu/fQRqXql8r8XEWM6U
         HhBxUISToPkdUX7zU8WqOaNTE7h/o76UDEPgdF1fC9qyKA9PXnPQIGTNH86y3q3odOgM
         ulsnBDKuKri7pPfwZSMJv3k2OunAc58twTdQNxicLIyqf4UOlcvGg8BG2+Yr+jc+iVas
         9K9Tkh3iSa9ixlSCri/pc7Qe7v7T6wRyfCQyZsNSOEEYjaRsmgikK1nF+WB6jB/x2Hif
         zMtLi4b1e+lDeUbndMvMXYZkVr6WtA37Rtt7Q8feRsBfFJfzmCHlcFlK0+PKyeJApe9h
         6yVA==
X-Gm-Message-State: AOAM532QStbx8ztbrf5fjGjFcR8OmPXjBqlk85/c+3oOOJSbiwAfwyJQ
        DGjqDVAnhQ9c5TSIKjUdV3dlAc8GzOAv+vAZGqy3CA+VVFMT5GPhlImTs+mHzeJ+7pc/bQUnZQA
        RnmbEKsEKqr/N
X-Received: by 2002:a5d:64c7:: with SMTP id f7mr3541369wri.36.1623308098544;
        Wed, 09 Jun 2021 23:54:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHulzoaGG46GCG3Zz8U85n2skBqB8M0q5MPNAlPWi9ft6Enx/RPu1WvPDXG/UOusNXSWsxiQ==
X-Received: by 2002:a5d:64c7:: with SMTP id f7mr3541358wri.36.1623308098404;
        Wed, 09 Jun 2021 23:54:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id l3sm2026815wmh.2.2021.06.09.23.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 23:54:57 -0700 (PDT)
Subject: Re: [PATCH 02/10] KVM: arm64: Implement initial support for
 KVM_CAP_SYSTEM_COUNTER_STATE
To:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>
Cc:     kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20210608214742.1897483-1-oupton@google.com>
 <20210608214742.1897483-3-oupton@google.com> <877dj3z68p.wl-maz@kernel.org>
 <CAOQ_QsgobctkqS5SQdqGaM-vjH7685zGPdDXZpcOCS8xWJxegA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <624ab379-b7f1-9753-81f7-d813faa25978@redhat.com>
Date:   Thu, 10 Jun 2021 08:54:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsgobctkqS5SQdqGaM-vjH7685zGPdDXZpcOCS8xWJxegA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 16:51, Oliver Upton wrote:
>> - You seem to allow each vcpu to get its own offset. I don't think
>>    that's right. The architecture defines that all PEs have the same
>>    view of the counters, and an EL1 guest should be given that
>>    illusion.
> Agreed. I would have preferred a VM-wide ioctl to do this, but since
> x86 explicitly allows for drifted TSCs that can't be the case in a
> generic ioctl. I can do the same broadcasting as we do in the case of
> a VMM write to CNTVCT_EL0.
> 

If you use VM-wide GET/SET_DEVICE_ATTR, please make it retrieve the host 
CLOCK_REALTIME and counter at the same time.

Paolo

