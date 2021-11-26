Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D4645F365
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 19:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhKZSI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 13:08:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238318AbhKZSG1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 13:06:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637949794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R6RN18CQhAYJxES1BH8GkFYIM3w48w5BHDz3O4or3Zw=;
        b=MHRJaEHD0NCzifdN0pJ8s4QQ/NiD+D3I7S/ccz3FcAkCVwyKov2CC+UjhvcABwfbHBCRP7
        nO0eU6W625qA0Os2T9BLje98G90gJuENlznYVkjOG1dMKJJdC6apZhR4e1XQ54ySd8NGi/
        TqI9p+UKQS/zogAsexVian8WRgvJPao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-L0WgGGWcMpmKg1nJOD6wSA-1; Fri, 26 Nov 2021 13:03:13 -0500
X-MC-Unique: L0WgGGWcMpmKg1nJOD6wSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBDB92F25;
        Fri, 26 Nov 2021 18:03:11 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37D8F1000051;
        Fri, 26 Nov 2021 18:03:10 +0000 (UTC)
Message-ID: <0966da8f-1083-9978-6cc7-9b119357bde5@redhat.com>
Date:   Fri, 26 Nov 2021 19:03:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 05/39] x86/access: Refactor so called "page
 table pool" logic
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20211125012857.508243-1-seanjc@google.com>
 <20211125012857.508243-6-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211125012857.508243-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 02:28, Sean Christopherson wrote:
>   static _Bool ac_test_enough_room(ac_pool_t *pool)
>   {
> -	return pool->pt_pool_current + 5 * PAGE_SIZE <= pool->pt_pool_size;
> +	/* '120' is completely arbitrary. */
> +	return (pool->pt_pool_current + 5) < 120;

Since the initialization was:

	pool->pt_pool_size = 120 * 1024 * 1024 - pool->pt_pool;

This should be 120 * 2^20 / 2^12 = 120 * 256 = 30720, which
is also arbitrary of course.

At this point I'm not sure there's a huge improvement, but I'll trust 
you and go on reviewing...

Paolo

>   }
>   
>   static void ac_test_reset_pt_pool(ac_pool_t *pool)

