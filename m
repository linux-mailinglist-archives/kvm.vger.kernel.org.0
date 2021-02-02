Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9225330C7EE
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbhBBRgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:36:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23551 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234194AbhBBReE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:34:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612287159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xDLoqFXJnyWYsI4MjhMkfY1XcxzM75c7CRhYvFGAKo=;
        b=bUAZeU36oXGuo66PXFza/qo1avxlcLsqqkO4fIqFwBDDcjxWgkvYLiq54qMpMNGV44prpb
        dJPFpuxNz3qFXX4HyW4B9LMMLR6ICU7wyxEs/qdFkRQBIK9Bhim6lpEJtoxk5Trfal/rrl
        zP7gC+OaiZJ1ixD/MWROV2q9cu1Sn8E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-ZkTFiz8gNkq_oOv3ndTEvQ-1; Tue, 02 Feb 2021 12:32:38 -0500
X-MC-Unique: ZkTFiz8gNkq_oOv3ndTEvQ-1
Received: by mail-ed1-f69.google.com with SMTP id f4so9926671eds.5
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 09:32:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5xDLoqFXJnyWYsI4MjhMkfY1XcxzM75c7CRhYvFGAKo=;
        b=UwSJJjs/Pog3aactw+/xemyw0Bo7sKxmymRNLA82Krqywt3z8ct4pz+bz8zII9iJdh
         +OwWx3BihJBEsfSC8JuXtSZ9uIKTnKFww+XvsKk3tG8HNZYIBt1YCorgTqqPAL4sQHSV
         6eHfOrAnNhFqPzjLj+XUWr3ws94bu4SUFsXg1w8xxFPgiVlQUkGrbu1U16cqu99eR5pQ
         xPWIF5UObNs5F/ReyNuO/ZhrFCGVjaWpwzq84IaC6lkwJFdiRW09FzFpdYQSiX5oRkIg
         QJBvtu4Mm4R8h2o6GthdzS0gzZAGvUfGqTrtT/UZQ91s7dVckpxduSWfifvUwJDzyrnN
         LssA==
X-Gm-Message-State: AOAM532wlzYO5LGubkLK40UosUwm5XLoOzilw2O+COIzSXfJM/YDRp8r
        RZSqQAL0/h2s6QsxEZRZe3k7PV4T6VBC6jVeNc3FtUWIUdITLw+ely0VdW97cd42Y+IrjEECXst
        9W/lHstf0LHJS
X-Received: by 2002:a17:906:8a59:: with SMTP id gx25mr15904090ejc.310.1612287156696;
        Tue, 02 Feb 2021 09:32:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyxdr9tXVjSGSY8Z18kK8M0fX2Y4E1fTIs2+vtrLnxj2RqkiIr7nT+YUWnd2gPVlnNcZErnQ==
X-Received: by 2002:a17:906:8a59:: with SMTP id gx25mr15904076ejc.310.1612287156547;
        Tue, 02 Feb 2021 09:32:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hr31sm9559435ejc.125.2021.02.02.09.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 09:32:35 -0800 (PST)
Subject: Re: [PATCH v3 1/3] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210105143749.557054-1-michael.roth@amd.com>
 <20210105143749.557054-2-michael.roth@amd.com> <X/Sfw15OWarseivB@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e3faa02d-e7b2-5ab7-22a8-fc625245ad00@redhat.com>
Date:   Tue, 2 Feb 2021 18:32:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/Sfw15OWarseivB@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/21 18:20, Sean Christopherson wrote:
> This VMLOAD needs the "handle fault on reboot" goo.  Seeing the code, I think
> I'd prefer to handle this in C code, especially if Paolo takes the svm_ops.h
> patch[*].  Actually, I think with that patch it'd make sense to move the
> existing VMSAVE+VMLOAD for the guest into svm.c, too.  And completely unrelated,
> the fault handling in svm/vmenter.S can be cleaned up a smidge to eliminate the
> JMPs.
> 
> Paolo, what do you think about me folding these patches into my series to do the
> above cleanups?  And maybe sending a pull request for the end result?  (I'd also
> like to add on a patch to use the user return MSR mechanism for MSR_TSC_AUX).

I have queued that part already, so Mike can rebase on top of kvm/queue.

Paolo

> [*]https://lkml.kernel.org/r/20201231002702.2223707-8-seanjc@google.com
> 

