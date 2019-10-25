Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E96E4A45
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 13:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502243AbfJYLqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 07:46:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbfJYLqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 07:46:55 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E37594E832
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 11:46:54 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id u17so842480wmd.3
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 04:46:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JFxVTkuWS3kQBWJGbndYa5A8WjnfR9HWKV7Q51mjf4g=;
        b=Ltjy8TIY6WeTUSVZPak/1MC2HAYBTMexqmMDeolMvNXs/obQ+eC2uGe1vk8MT5yLpn
         KOnUXKMoUSxPrDFQQATAUOpOqTcLlr7RNBFEKG06xv0HKQVCxb7bBRlWcgIw4AdfcNw4
         cSTm3G/k6czsvePC1AhO/q4LMemSlxRhFPf80f4mSTaek+URCYpGBAbRSdPFYMdVuyJo
         qKbJtshUl4STNCzx2t7YGuQBRdPf5H3al7RYq3C8HRt3DKvdD24QFFNy3kqlwX9BnhDh
         py5fTK/DcyXXne8t2OT6wJxqpljNBJL2fdVmF2RyNEyIQAVXQBn9/0WonBObPuCmsGs0
         YC4w==
X-Gm-Message-State: APjAAAXjTPp3uVPd/9CQz+98h/v+JF9a5Cdl+UQscXIKZCD+TbutmGdq
        i2ezMKBS9rPFEGMdOtfSiLugPgcJTdwCFy5ZxwiBABzGfQAwiZpcyOISKSkmnvkYAQkKA7sYedK
        +PBlsXtbOFHT8
X-Received: by 2002:adf:fcc7:: with SMTP id f7mr2682960wrs.345.1572004013391;
        Fri, 25 Oct 2019 04:46:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx0N+07IZUEvJWWb7N83GBppYgQj1HmvMn6Q1GmAwZLzX0L4MctCmq7ANIVvVFt7HSefCOVbg==
X-Received: by 2002:adf:fcc7:: with SMTP id f7mr2682929wrs.345.1572004013107;
        Fri, 25 Oct 2019 04:46:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9c7b:17ec:2a40:d29? ([2001:b07:6468:f312:9c7b:17ec:2a40:d29])
        by smtp.gmail.com with ESMTPSA id o73sm1723689wme.34.2019.10.25.04.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 04:46:52 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: get rid of odd out jump label in
 pdptrs_changed
To:     Miaohe Lin <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1572000874-28259-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <365321df-2f66-95ef-4bf3-4e250f0a99a7@redhat.com>
Date:   Fri, 25 Oct 2019 13:46:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1572000874-28259-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks (but it likely won't be on git.kernel.org until after the
end of KVM Forum, sorry about that).

Paolo

On 25/10/19 12:54, Miaohe Lin wrote:
> The odd out jump label is really not needed. Get rid of
> it by return true directly while r < 0 as suggested by
> Paolo. This further lead to var changed being unused.
> Remove it too.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ff395f812719..8b0d594a3b90 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -721,7 +721,6 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
>  bool pdptrs_changed(struct kvm_vcpu *vcpu)
>  {
>  	u64 pdpte[ARRAY_SIZE(vcpu->arch.walk_mmu->pdptrs)];
> -	bool changed = true;
>  	int offset;
>  	gfn_t gfn;
>  	int r;
> @@ -738,11 +737,9 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
>  	r = kvm_read_nested_guest_page(vcpu, gfn, pdpte, offset, sizeof(pdpte),
>  				       PFERR_USER_MASK | PFERR_WRITE_MASK);
>  	if (r < 0)
> -		goto out;
> -	changed = memcmp(pdpte, vcpu->arch.walk_mmu->pdptrs, sizeof(pdpte)) != 0;
> -out:
> +		return true;
>  
> -	return changed;
> +	return memcmp(pdpte, vcpu->arch.walk_mmu->pdptrs, sizeof(pdpte)) != 0;
>  }
>  EXPORT_SYMBOL_GPL(pdptrs_changed);
>  
> 

