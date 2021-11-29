Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A224624D8
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhK2WbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhK2WbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:31:18 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91634C0698E6
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:28:00 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id r130so18498290pfc.1
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eS0xBQSNpWM8rifaE/0iM5kGD78qcIWMWAK2A3ymkdA=;
        b=PWdoqGdu4TF8dO7Kpd7AP7ISxaGSg6Cu4pA3K4SoRCDZiAnpuuGsd+hBmdl3/y/naO
         P18oIBNf556ugqw/0t7NygXXx8s8lA9vJRn3/apF26Zz7pFmmZD+xWkdn3rsLAm4lX3K
         rWKi3zQC40NfUZ1wlGfeYTNRv4XTxe2E1hN2272GTwui5BVLBik2TYvD1in6YTKiNc5Y
         zjxWQqZLNE1qfkOPOD11c/Yrhzia1RavRjri00C6i2bav1BHxGauGTIae5RlbuUSqGlO
         7C/3lfQF17wkXpScoAAAGvbnMldkgTXjEz74eVZxiFBSGIE5Lve9fKBlxE5VCyN68Xlt
         lkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eS0xBQSNpWM8rifaE/0iM5kGD78qcIWMWAK2A3ymkdA=;
        b=xn7h2/TOKab5C8VCr4zEXGGjlT+WpeqIsF94QiTYEl01V+xsE9l2cRtB/LacSE5avU
         4/7KUpltUuJOucrSWqKS2BmaIqeCFWCvgchkNUhlIJGBXez1MCvjsauY5d8OWHlIr8Lg
         P5OuJUK7/vTyOmqbcgqninuka82wbf3F8xH3jW8GxhXuNDvJH6JIHE535FGJQkt9YkBj
         4BkXvOylaa3lJZyWmoNTxi6wZq0RlplnNXCTf29bX/0lJSniclrLlEii6Zbq4gT0OxuW
         ank2O4EQ6M0akYBkj7KBmmcGvThnwDwYLlsTnH3PCZd47V/wkJ9XmcpyyxYqPjqKQyuX
         HA6w==
X-Gm-Message-State: AOAM53259u+vFTFAi3QY0TmETMzeM6TtYrql1flcfGo6MJ6WDW6AISwF
        /y5L2aYGZX/On9OmSm24ctGdRA==
X-Google-Smtp-Source: ABdhPJzaVzvyLzh0ispHWCx0+vAn/2fDXv42xJJZ6n6j2Jk1cI+5pyPsP4sgJd34CptCRfBxcxrpag==
X-Received: by 2002:a05:6a00:178c:b0:4a2:f71e:36aa with SMTP id s12-20020a056a00178c00b004a2f71e36aamr42059423pfg.68.1638224879958;
        Mon, 29 Nov 2021 14:27:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c3sm19414634pfv.67.2021.11.29.14.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 14:27:59 -0800 (PST)
Date:   Mon, 29 Nov 2021 22:27:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pgonda@google.com
Subject: Re: [PATCH 04/12] KVM: SEV: do not use list_replace_init on an empty
 list
Message-ID: <YaVT638kTtgF64/i@google.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
 <20211123005036.2954379-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123005036.2954379-5-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Paolo Bonzini wrote:
> list_replace_init cannot be used if the source is an empty list,
> because "new->next->prev = new" will overwrite "old->next":
> 
> 				new				old
> 				prev = new, next = new		prev = old, next = old
> new->next = old->next		prev = new, next = old		prev = old, next = old
> new->next->prev = new		prev = new, next = old		prev = old, next = new
> new->prev = old->prev		prev = old, next = old		prev = old, next = old
> new->next->prev = new		prev = old, next = old		prev = new, next = new
> 
> The desired outcome instead would be to leave both old and new the same
> as they were (two empty circular lists).  Use list_cut_before, which
> already has the necessary check and is documented to discard the
> previous contents of the list that will hold the result.
> 
> Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 21ac0a5de4e0..75955beb3770 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1613,8 +1613,7 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>  	src->handle = 0;
>  	src->pages_locked = 0;
>  
> -	INIT_LIST_HEAD(&dst->regions_list);
> -	list_replace_init(&src->regions_list, &dst->regions_list);
> +	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);

Yeesh, that is tricky.  A list_move_all() helper in list.h to do 

	list_cut_before(dst, src, src);

would be nice.

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  }
>  
>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
> -- 
> 2.27.0
> 
> 
