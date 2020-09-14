Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853742693EC
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 19:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgINRph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 13:45:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52107 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbgINMFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 08:05:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600085072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k2l6ayUzFIexzXgZyZrDYGU+vmfRTf0Myc4Tfjg1GY4=;
        b=fUdOTABWMh/el1+YKHgoN7utDNTNoHQ7LTie0XKNhhOHtjLET52eX2jLWKNloIUwbjrS9j
        D5QFOpZT4lN/2HQA4ql+8ykoR4laXbx0vvmVu8GaHkl85vEaEBkjzzCj1ed3dypelbFN7L
        u2Huox+qkwtm3lO+X1mkNYQHS6nAJvI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-4Xu0dODrPnSHssiTKNzGtg-1; Mon, 14 Sep 2020 08:04:30 -0400
X-MC-Unique: 4Xu0dODrPnSHssiTKNzGtg-1
Received: by mail-wr1-f70.google.com with SMTP id k13so6852720wrl.4
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 05:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=k2l6ayUzFIexzXgZyZrDYGU+vmfRTf0Myc4Tfjg1GY4=;
        b=VnVOXwNFGjhSZPrzv8BtIZP7MG9DWc0LJQrPRYgG54MlAQresg0pfpJ22cWhC25F5x
         X314VkJCPoec/DVI9SkhtgEXkxTo+UmOifjqV8ofVIU4Pj6T3qbmouEDTgJ5XYMEl/PD
         7YIpapyG/UA0uqaE+AetUqbCPakNfI/X1HT8LOPGOyKv6FABeUHZS6gSqbQHX2Q7BLbW
         uR39BijFUiKOcJ2DKty/JPvNbVlHK1DygXosN4Rr8AHQFwlhWILKX1WWnivEEtR6r3F5
         PpLAtJ5fk+B0BlylVWlGVImxDdpYf/tiSnj95yTh+GaXZ+gOT1vwLdmcdIVM9Y1jyezP
         hdUg==
X-Gm-Message-State: AOAM531car1gR1oRSBuBsdP3Bv7KYf/nPeFwV+9lZE4/4LL8NHyZ/ajE
        LhCa4yj5jcAhcPm5d/EfqOqqVGmuF5uy/4Cz/Z3HtFXsISWm2KJrdAV6po9JsbLg5G9uNNKIAnn
        ba9XyXtMlD79q
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr15751980wrs.107.1600085069699;
        Mon, 14 Sep 2020 05:04:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5dFUfXVi1ValFuUi29yDku2JryIRpBccE+ZpLUxwUnqB/dPBjOun5C5L8TZH7NJeJ95gSXQ==
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr15751952wrs.107.1600085069498;
        Mon, 14 Sep 2020 05:04:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 8sm20940521wrl.7.2020.09.14.05.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 05:04:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Colin King <colin.king@canonical.com>
Subject: Re: [PATCH -tip] KVM: SVM: nested: Initialize on-stack pointers in svm_set_nested_state()
In-Reply-To: <20200914115129.10352-1-joro@8bytes.org>
References: <20200914115129.10352-1-joro@8bytes.org>
Date:   Mon, 14 Sep 2020 14:04:27 +0200
Message-ID: <87ft7klg38.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> From: Joerg Roedel <jroedel@suse.de>
>
> The save and ctl pointers need to be initialized to NULL because there
> is a way through the function in which there is no memory allocated
> for the pointers but where they are freed in the end.
>
> This involves the 'goto out_set_gif' before the memory for the
> pointers is allocated.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures on stack")
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kvm/svm/nested.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 598a769f1961..72a3d6f87107 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1062,8 +1062,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	struct vmcb *hsave = svm->nested.hsave;
>  	struct vmcb __user *user_vmcb = (struct vmcb __user *)
>  		&user_kvm_nested_state->data.svm[0];
> -	struct vmcb_control_area *ctl;
> -	struct vmcb_save_area *save;
> +	struct vmcb_control_area *ctl = NULL;
> +	struct vmcb_save_area *save = NULL;
>  	int ret;
>  	u32 cr0;

Hi Joerg,

this was previously reported by Colin:
https://lore.kernel.org/kvm/20200911110730.24238-1-colin.king@canonical.com/

the fix itself looks good, however, I had an alternative suggestion on how
to fix this:
https://lore.kernel.org/kvm/87o8mclei1.fsf@vitty.brq.redhat.com/

-- 
Vitaly

