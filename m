Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F63189E4E
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 15:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgCROxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 10:53:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:28563 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbgCROxZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 10:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584543204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8WKtJ0NoeW5X7Z6TZZcRE25TjkVLqGWMqe9mT+XKLH4=;
        b=jInc0BllTbgebH2Aky6WemvNc+NNAh3bL18w929C91V3DNliei3t3pzUztd1BpO9b6J3FQ
        vEo4HloaFzl8oDC1Cj3gmX25f4+MejbkTptu/rWPQ+3Ho61Nrs4FA8ZW50EYP/hTsfkqd4
        CvG2m6rK3vHJKCeibYb4RISaTuZQaUA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-pvmeZAx-Nq2Za3MDJPyCyg-1; Wed, 18 Mar 2020 10:53:22 -0400
X-MC-Unique: pvmeZAx-Nq2Za3MDJPyCyg-1
Received: by mail-wr1-f71.google.com with SMTP id v6so12362229wrg.22
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 07:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8WKtJ0NoeW5X7Z6TZZcRE25TjkVLqGWMqe9mT+XKLH4=;
        b=El4/3K2Rl81Uf58dMX53LMZYymNWZFq1kIrOQuSms1UG/VoPG9NZpWAThOod0TTH9k
         9yUqzsYX34I3EEfR1Ve6d3lH7qPMMetFNRIEaWY8p6lnJUugt2E6uvEjR/fDMvLcdmz/
         1/CFR4lHS1xFdSl/W9i9eqBhXYglhjta/57zqlDTkf3xGdaTvQRPeN06QpTsWxqy+5wN
         FFcOqPLnXASXQtirXFEQNSYe54F5fcdcJsYVfduCRKetdJKfXTtF3Zjec7h20m/RaFWU
         dIPcpWtcoUfKFuqhRVF2ABZkARMyFRdeVt2HvFQ8NsYyjJkV/duidNV47ANCsEuQyHCD
         9wkA==
X-Gm-Message-State: ANhLgQ1b/F2E/1dqBk9tjN8jPAmRd6nchyWfTmoVU2cmlCjnI3+mZCol
        ZlA8hyeNoj1Qr7mrMOZZZieTZ+nmcVXMRfiKtRRhMV8/zu1XrdcZalXm5+M9OpLaTrg1ZFhNUOk
        bf5adjjz8/cyd
X-Received: by 2002:a1c:2701:: with SMTP id n1mr5686046wmn.180.1584543201138;
        Wed, 18 Mar 2020 07:53:21 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsEFavcmZ92zPR5GFapmD2k6UNbKOWgwr1iImA3etdVN9BHmNhPJHNXPkEEJZIZmcDqYJmUaA==
X-Received: by 2002:a1c:2701:: with SMTP id n1mr5686021wmn.180.1584543200952;
        Wed, 18 Mar 2020 07:53:20 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q10sm9326043wrx.12.2020.03.18.07.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 07:53:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nSVM: check for EFER.SVME=1 before entering guest
In-Reply-To: <1584535300-6571-1-git-send-email-pbonzini@redhat.com>
References: <1584535300-6571-1-git-send-email-pbonzini@redhat.com>
Date:   Wed, 18 Mar 2020 15:53:19 +0100
Message-ID: <877dzh3eao.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> EFER is set for L2 using svm_set_efer, which hardcodes EFER_SVME to 1 and hides
> an incorrect value for EFER.SVME in the L1 VMCB.  Perform the check manually
> to detect invalid guest state.
>
> Reported-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 08568ae9f7a1..2125c6ae5951 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3558,6 +3558,9 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  
>  static bool nested_vmcb_checks(struct vmcb *vmcb)
>  {
> +	if ((vmcb->save.efer & EFER_SVME) == 0)
> +		return false;
> +
>  	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
>  		return false;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

