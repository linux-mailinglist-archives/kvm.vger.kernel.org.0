Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB131EB3DA
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFBDl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgFBDl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:41:26 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22619C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:41:26 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x22so119936pfn.3
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=18PjvpBvSRFINqo26hMwWXabctIYaLUjgZxMJeJ8oos=;
        b=nh85xS/jOfs88spkBMWMknsA8QnbyEIzRTx5mOUanNRFkrVcrKEAt4k2aVHCJoGCES
         Cca6K7kUKgK+H5sbkXxXlvyrWQ0KY6fs9FBtJAMOhfPGN63jXmBekcKDf/5pk2OQen06
         h5d69+8CYHBOmlnO4pwY0qh2929+HC1FV3zlURCdCbcyI8ClQWCJIM73MtFbyxoqBV6g
         fQRTZjvJgYNIm4huhaaZ8haOurZVCPNLS+KSVGqJRYHdGxL93vbEhTHvKOlsQ7AWqJpE
         PiVYa1/1pml2YR0iSwI7OzPYCPeevs0RHw6wMnXkEdsqJJZUGwD9cYvHQgS3b2Q587wm
         ZCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=18PjvpBvSRFINqo26hMwWXabctIYaLUjgZxMJeJ8oos=;
        b=dVwGJKG3XoCpxxbtz3xjesj5rPQxo5ovxS4mHxTRHSt59kEgexv74SN9KXKKcNdDGC
         xolvQsI9Xb6Ec/MCXEpT6iqG5l3jg0tihkc0gs8m526DU2Er2NjgjGOQZ9NisSIu1Wvz
         YVRp4jnHxGwJFLlxthjgQ/t15EnA4kq/bikkJBOhJgR8ChDCqZNQQY3IxTSK6nVQ+8M/
         aa1fv52PFrcMfXnYMgPEesIVnT2Dr0+s8Qk8l5VR6QVgU/g2M9hOj8log1YRiJICsQua
         FmWyMWTOEbKxnX6xA6GPiOiFySJBZOkaCyRgl5gErXto4/h8tiXKzSQ72BwMR2iBUrBe
         pxkQ==
X-Gm-Message-State: AOAM531CXCLKimU34oa+0ayKIZtgE55mvk8qjMlN9/YMh2boZ88dFNZ/
        LkkzIw0W1eNHh9TJ/7QEdpMXZg==
X-Google-Smtp-Source: ABdhPJyqwBKsVS4JT12+c/ue6jKjq4BqQGl3IV/nDOd8YsTNsAVqxl51uPlWXMCwLvZx7eXkW+1Agw==
X-Received: by 2002:a63:ec0c:: with SMTP id j12mr3788513pgh.255.1591069285547;
        Mon, 01 Jun 2020 20:41:25 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id x2sm790090pfr.186.2020.06.01.20.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:41:24 -0700 (PDT)
Subject: Re: [RFC v2 13/18] guest memory protection: Move side effect out of
 machine_set_memory_encryption()
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-14-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <7af2f786-d1be-c77b-08db-cdf2dd513aa8@linaro.org>
Date:   Mon, 1 Jun 2020 20:41:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-14-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> When the "memory-encryption" property is set, we also disable KSM
> merging for the guest, since it won't accomplish anything.
> 
> We want that, but doing it in the property set function itself is
> thereoretically incorrect, in the unlikely event of some configuration
> environment that set the property then cleared it again before
> constructing the guest.
> 
> But more important, it makes some other cleanups we want more
> difficult.  So, instead move this logic to machine_run_board_init()
> conditional on the final value of the property.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/core/machine.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

