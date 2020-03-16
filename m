Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33633186696
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 09:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgCPId6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 04:33:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43952 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730048AbgCPIdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 04:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584347635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Dg7qn9jAmmQ+Q4EHBQ5doPvYZxhBs48JydmR2W4pa0=;
        b=XO4UNBaOYWhDQsk9uEEx7W0hsIHIjPQSYSqQnbgsX1iu9CPIly5QLB5wAyTaW/eHbmMpCl
        /AndA2WILei8SqsvZIodGDPRFl45miNEeeGWrdRXvixvlaH4O+f8ewibQbbE+N61nDG1PH
        VSEE4CLNE2R093bOE210fyZU1qDndOg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-PayTqAoPM3iIDIopeNt6wQ-1; Mon, 16 Mar 2020 04:33:53 -0400
X-MC-Unique: PayTqAoPM3iIDIopeNt6wQ-1
Received: by mail-wm1-f71.google.com with SMTP id n188so5495786wmf.0
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 01:33:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4Dg7qn9jAmmQ+Q4EHBQ5doPvYZxhBs48JydmR2W4pa0=;
        b=WXQ8Uxr4ysWffgqn872SE0zZ47n+F4uDe+ayI7jcGJLBOlzM7SQU6uZrWyr/qjp4qq
         ZQuLQguKn/kM/rBlXhYqdjiQSAuz/C7VAjB+cNKCDcVKhfhS4Je+9KCKjtrSQo6CXS0F
         TsKi9wL850sCBK8vuQrFvS8e88fXVB47LJAGVbV43rB1NIAmQF/9D6urGU9VDiKJBKR6
         9qlB3l6ileZO+T4Fy+z+wurf7L7dSxyY1dnWY2IiRorfJkM8lvlmQku/Y2oSCZezsjiP
         JfXUhpzQplOMYPf8K2GrZ9VtFUfcTGJMujF80gbRLjB9wdAitQ5M1QlkBglNqLe3xCG6
         Xwzw==
X-Gm-Message-State: ANhLgQ3ri4AIO27snt3sNyqjBTnBdT8Blc5/vVolg8O4YmNjkWNlgKP+
        l8X1aFo3igPBfKDuI71ECltulwA2gzpzKeewAlqN8elY7ppctUWZ8xmz0YIM/U1UDgBArwiYgzT
        eoiKLY1uJtHz2
X-Received: by 2002:a1c:6387:: with SMTP id x129mr26739575wmb.58.1584347631923;
        Mon, 16 Mar 2020 01:33:51 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsBK9XwYLhjvpKzVGJjmbGp9jcF+cp/eYqWwn2d+jEyZvqCLcknP0FBYuAncJ7EVmcWPeU6PQ==
X-Received: by 2002:a1c:6387:: with SMTP id x129mr26739557wmb.58.1584347631712;
        Mon, 16 Mar 2020 01:33:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 31sm8703050wrr.5.2020.03.16.01.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 01:33:51 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: correct meaningless kvm_apicv_activated() check
In-Reply-To: <1584185480-3556-1-git-send-email-pbonzini@redhat.com>
References: <1584185480-3556-1-git-send-email-pbonzini@redhat.com>
Date:   Mon, 16 Mar 2020 09:33:50 +0100
Message-ID: <878sk0n1g1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> After test_and_set_bit() for kvm->arch.apicv_inhibit_reasons, we will
> always get false when calling kvm_apicv_activated() because it's sure
> apicv_inhibit_reasons do not equal to 0.
>
> What the code wants to do, is check whether APICv was *already* active
> and if so skip the costly request; we can do this using cmpxchg.
>
> Reported-by: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a7cb85231330..49efa4529662 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8049,19 +8049,26 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>   */
>  void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  {
> +	unsigned long old, new, expected;
> +
>  	if (!kvm_x86_ops->check_apicv_inhibit_reasons ||
>  	    !kvm_x86_ops->check_apicv_inhibit_reasons(bit))
>  		return;
>  
> -	if (activate) {
> -		if (!test_and_clear_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
> -		    !kvm_apicv_activated(kvm))
> -			return;
> -	} else {
> -		if (test_and_set_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
> -		    kvm_apicv_activated(kvm))
> -			return;
> -	}
> +	old = READ_ONCE(kvm->arch.apicv_inhibit_reasons);
> +	do {
> +		expected = new = old;
> +		if (activate)
> +			__clear_bit(bit, &new);
> +		else
> +			__set_bit(bit, &new);
> +		if (new == old)
> +			break;
> +		old = cmpxchg(&kvm->arch.apicv_inhibit_reasons, expected, new);
> +	} while (old != expected);

'expected' here is a bit confusing as it's not what we expect to get as
the result but rather what we expect to see pre-change. I don't have a
better suggestion though.

> +
> +	if ((old == 0) == (new == 0))
> +		return;

This is a very laconic expression I personally find hard to read :-)

	/* Check if WE actually changed APICv state */
        if ((!old && !new) || (old && new))
		return;

would be my preference (not strong though, I read yours several times
and now I feel like I understand it just fine :-)

>  
>  	trace_kvm_apicv_update_request(activate, bit);
>  	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

