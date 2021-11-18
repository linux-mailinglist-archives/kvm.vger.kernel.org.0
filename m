Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D76455E6C
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhKROqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:46:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230400AbhKROqn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 09:46:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637246623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mrOJGErhxZOtoWKRFb9YDv+hKHOMe8md4BUqSHKryko=;
        b=P7cw58ApI+jXIF3LVwjgtd6bnBH5fQS83ZfeZ4n3pFKBYqbtZjimid1jCmPEILC3RMgSc9
        N5F+3cSZE3gCiN9p0lUeEBS0RYuSe2Fw6TroGA5QpWv+WgbQq06HqbkqsAdiMbNi3PRrfb
        ZfpX0LSCvEmWhUZavvKrUzYkH7mIQ7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-J69538a9P9WIjgFJ12Pn6Q-1; Thu, 18 Nov 2021 09:43:41 -0500
X-MC-Unique: J69538a9P9WIjgFJ12Pn6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72D9810144E0;
        Thu, 18 Nov 2021 14:43:39 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E3DA5D9DE;
        Thu, 18 Nov 2021 14:43:37 +0000 (UTC)
Message-ID: <3ee8d23b-c7c1-94ab-d625-662072760373@redhat.com>
Date:   Thu, 18 Nov 2021 15:43:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/4] KVM: x86/pmu: Reuse find_perf_hw_id() and drop
 find_fixed_event()
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211116122030.4698-1-likexu@tencent.com>
 <20211116122030.4698-4-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211116122030.4698-4-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 13:20, Like Xu wrote:
> +	/* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
> +	if (pmc_is_fixed(pmc))
> +		return PERF_COUNT_HW_MAX;
> +

This should have a WARN_ON, since reprogram_fixed_counter will never see 
an enabled fixed counter on AMD.

Paolo

