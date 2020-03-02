Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1506C175AE2
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 13:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgCBMyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 07:54:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52209 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727595AbgCBMyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 07:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583153659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uio7FC4gUy07vPE5jHOFetkzB5/dTbCYvaj0gXJ70aY=;
        b=X44uuMWFSWiXHKgy9yxdtsIAgPCNO2GYBXseyHYYZXZl81AxtYIV3iWFKc+f6n89CK1fH0
        HAuBIWTRXr+RmoR+VsVViwaBBzJ06b5jTQFvlEkTR1vO4yOzwBqbhW2o3xBLAPVe8MkMM2
        mSgNZxQ4VioiEFDwvUnIRfMVYfFObn8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-2xYC-nkFPXOOOotAD5HiJg-1; Mon, 02 Mar 2020 07:54:18 -0500
X-MC-Unique: 2xYC-nkFPXOOOotAD5HiJg-1
Received: by mail-wr1-f69.google.com with SMTP id n12so5745176wrp.19
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 04:54:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uio7FC4gUy07vPE5jHOFetkzB5/dTbCYvaj0gXJ70aY=;
        b=s9oNMLqjBX8JCYbyuHx0I8kHAe4XSur0U/e++NXILm+TzAWmwqxDvGWtpTDHCsAirH
         8A4ssQDrEy7Wp4tgLR/9SH5FN4wwDlNW4841AB74a13SZ6tvnOvb36RQl9MrzAVlX7H1
         JuxG5GGkpMQTo8WV0BKFXWhKnBJP66CELMGv6+xw5LiVYH45F8gaAB47shro7o0lGFyp
         XoJ6rGnpLDiQh+3UXNaRRibpe1E2uapavwug2SDumxJfbpzwSdh5hLOtBhrzV5tLRwn1
         UW+Fas51XkN3lbdSGNLz6AqRw60ZBERwbZZeP/rt0ancOI0mc3f/SJRziv2OCQXZuKR3
         8MIg==
X-Gm-Message-State: ANhLgQ2swYXLa6ZBPxcp113MV3NdDIGENch6KFp9zGD7V5+zTLdcuYDz
        +ZDtUJvtfwOCAnRR1oOKyQAJnVZx9E7giPxCN3mhRLySZLDWuK3ZrGMubWM0lMGlkW9h+DulQGr
        uOcMXpJlserq/
X-Received: by 2002:a05:600c:351:: with SMTP id u17mr6272759wmd.22.1583153657284;
        Mon, 02 Mar 2020 04:54:17 -0800 (PST)
X-Google-Smtp-Source: ADFU+vu04jKN+g6wcSyVSSwVKb7MS+iuJ47n+yTcTQbU+MMAorQDO+ZNDo97ikUeXVPR3pW0sjgjCA==
X-Received: by 2002:a05:600c:351:: with SMTP id u17mr6272735wmd.22.1583153657057;
        Mon, 02 Mar 2020 04:54:17 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l17sm7282334wmi.10.2020.03.02.04.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 04:54:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     hpa@zytor.com, bp@alien8.de,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "joro\@8bytes.org" <joro@8bytes.org>, jmattson@google.com,
        wanpengli@tencent.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: SVM: Fix svm the vmexit error_code of WRMSR
In-Reply-To: <CAB5KdOZwZUvgmHX5C53SBU0WttEF4wBFpgqiGahD2OkojQJZ-Q@mail.gmail.com>
References: <CAB5KdOZwZUvgmHX5C53SBU0WttEF4wBFpgqiGahD2OkojQJZ-Q@mail.gmail.com>
Date:   Mon, 02 Mar 2020 13:54:15 +0100
Message-ID: <87o8tehq88.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Haiwei Li <lihaiwei.kernel@gmail.com> writes:

>  From 1f755f75dfd73ad7cabb0e0f43e9993dd9f69120 Mon Sep 17 00:00:00 2001
> From: Haiwei Li <lihaiwei@tencent.com>
> Date: Mon, 2 Mar 2020 19:19:59 +0800
> Subject: [PATCH] KVM: SVM: Fix svm the vmexit error_code of WRMSR
>
> In svm, exit_code of write_msr is not EXIT_REASON_MSR_WRITE which
> belongs to vmx.

EXIT_REASON_MSR_WRITE is '32', in SVM this corresponds to
SVM_EXIT_READ_DR0. There were issues I guess. Or did you only detect
that the fastpath is not working?

>
> According to amd manual, SVM_EXIT_MSR(7ch) is the exit_code of VMEXIT_MSR
> due to RDMSR or WRMSR access to protected MSR. Additionally, the processor
> indicates in the VMCB's EXITINFO1 whether a RDMSR(EXITINFO1=0) or
> WRMSR(EXITINFO1=1) was intercepted.
>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>

Fixes: 1e9e2622a149 ("KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath")

> ---
>   arch/x86/kvm/svm.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index fd3fc9f..ef71755 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6296,7 +6296,8 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu
> *vcpu,
>          enum exit_fastpath_completion *exit_fastpath)
>   {
>          if (!is_guest_mode(vcpu) &&
> -               to_svm(vcpu)->vmcb->control.exit_code ==
> EXIT_REASON_MSR_WRITE)

There is an extra newline here (in case it's not just me).

> +               (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR) &&
> +               (to_svm(vcpu)->vmcb->control.exit_info_1 & 1))

Could we add defines for '1' and '0', like
SVM_EXITINFO_MSR_WRITE/SVM_EXITINFO_MSR_READ maybe?

>                  *exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
>   }
>
> --
> 1.8.3.1
>

-- 
Vitaly

