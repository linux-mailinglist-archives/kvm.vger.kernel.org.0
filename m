Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6F84347B8
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 11:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhJTJTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 05:19:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhJTJTQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 05:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634721422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2cIO8Hc42HozvhMPklSUyUokIMVdEYaAydNCUHSDJDM=;
        b=cI08faLXYvpVwbE3M8y0nM9Kp+wwtPcsiMAYQWJ2LKrEldd+vDy9VOU/3zQSFD0Mh9Z9Kf
        A9nta9rCZip0mbpI8L6OmzM7sE9qShf7LP5YCl0vSWQKA0CdI2sRgPBrdXdvsrV12a7PxY
        erIo8WYjCngPu0q4GKegzAuJK3Y1WUk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-V5dKviO_PAyKD0jJlEK5OA-1; Wed, 20 Oct 2021 05:17:01 -0400
X-MC-Unique: V5dKviO_PAyKD0jJlEK5OA-1
Received: by mail-wm1-f72.google.com with SMTP id s22-20020a1ca916000000b0030dcdcd37c5so2299300wme.8
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 02:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2cIO8Hc42HozvhMPklSUyUokIMVdEYaAydNCUHSDJDM=;
        b=CX1n0Doa/0lBtkORzWvGhY1adIClgyenqgokzkaE0AzLcCz9tXAVxGIstiUqJG5Y5u
         Nnc4n4hfCQfqmhXOvA2SFO9I3XuAIShrdEbzzxnZbTu8xPGAHAefDJm5mWXlEN5DxrDW
         gkwjK9X6Zstljgm0i0IBZ1ayO1hx4Sn7s/1+W8tqwSxfdEqHayR6u2NFJsByoQQ7RsaQ
         goccs01JJ22zHQTzxeDaFmNq8oHkmviybczP0OJsS6raUV7D0xf3M15UTbNHgsVCOS4U
         +LEqHQjLHpRWNUEDWoUpeaoTl+DkQu/oeBUDoXjllj3k7nH+m+6QpQ/bjsz4n9862rlY
         eMCQ==
X-Gm-Message-State: AOAM533Lvjzuf6hsCpmhEJVkEKZu8Eb3Z9Gu+0qalyf+pg6mePg0CQ2I
        ip4FjL6gMk5xGO6Wg4YvwFShpbGoAflya65DIm+TZU+c2U+V9NAv+/sUzTL+wd7qOxlJ31XkIvY
        xmbRhKUawN2Xh
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr52480061wrr.386.1634721420011;
        Wed, 20 Oct 2021 02:17:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZgR7JyfR+vXNM1CCUTVc7GHmmvM9/kVBj+rEYWhITsY5A109Mr5QMUx2eVTKjTAzooUSn6g==
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr52480035wrr.386.1634721419757;
        Wed, 20 Oct 2021 02:16:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id y8sm1358940wmi.43.2021.10.20.02.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 02:16:59 -0700 (PDT)
Message-ID: <d3705090-88bf-da34-1d87-6719433c56e8@redhat.com>
Date:   Wed, 20 Oct 2021 11:16:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3] kvm: x86: mmu: Make NX huge page recovery period
 configurable
Content-Language: en-US
To:     Junaid Shahid <junaids@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, bgardon@google.com,
        dmatlack@google.com
References: <20211020010627.305925-1-junaids@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211020010627.305925-1-junaids@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 03:06, Junaid Shahid wrote:
> +			If the value is 0 (the default), KVM will pick a period based
> +			on the ratio such that the entire set of pages can be zapped
> +			in approximately 1 hour on average.

"such that *a* page will be zapped after approximately 1 hour on average".
The time needed to zap all the pages is actually infinite (ignoring the
effect of rounding, of course), because the number of zapped pages decreases
as the list becomes smaller.

> +	if (!period && ratio)
> +		period = 60 * 60 * 1000 / ratio;
> +

Let's also bound this to one second:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a43bcd478194..f9f228963088 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6232,8 +6232,11 @@ static long get_nx_lpage_recovery_timeout(u64 start_time)
  	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
  	uint period = READ_ONCE(nx_huge_pages_recovery_period_ms);
  
-	if (!period && ratio)
+	if (!period && ratio) {
+		/* Make sure the period is not less than one second.  */
+		ratio = min(ratio, 3600u);
  		period = 60 * 60 * 1000 / ratio;
+	}
  
  	return READ_ONCE(nx_huge_pages) && ratio
  		? start_time + msecs_to_jiffies(period) - get_jiffies_64()

Queued with this change, thanks.

Paolo

