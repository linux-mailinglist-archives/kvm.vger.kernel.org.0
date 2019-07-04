Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276765F907
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 15:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGDNTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 09:19:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37255 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfGDNTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 09:19:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id v14so6629033wrr.4
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2019 06:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cb7K86i4xSjnh5aO2/GCpQl2NYXJ9GZdRLXhfhoypnU=;
        b=tr4Ep7iaacYBY851O73mK2sRlhVcG12asB8fyDLn3B+jhCNX4AsiBBDsA9ZZ2FxI26
         O6iVXjnzervB/40h5+PLSKy/i0CaeFJN92eVK9z9npEADvmAmY8RNkhEZki/9eyfUpfC
         lxeKfh4wur+p/aXs9Vw88163h2qv6LJ2lneLmGp+CvjgAg7B9Ux35KM5rvKv99Gp6aak
         hauyTvH2ZNRwZ7L5cHmlGum2Z5vSmcnqJlvePcSvwv7U5BkzMW2/dK22PdnF8Gmtms9u
         79C1sDMEYPXWqday8dUoeJPIREfedsH0q4c7s2yjs50RukSVN0rnf/4N0k3EZteekp9j
         WMUQ==
X-Gm-Message-State: APjAAAW/9xszgL12P6JngS9iIGhTa91aXSg4t8Sx1UbHCLQ67LZQ/ZzX
        DDPLcxBA6IsVVqFHtdZXQLcV5w==
X-Google-Smtp-Source: APXvYqwnnWTvg4XiNApaaKbLCKKQnP2Dttz0Wp5dirkAI4GqqKYrAYZTEHuEKyVf9YNKab5gwyCQUA==
X-Received: by 2002:a5d:6190:: with SMTP id j16mr35368415wru.49.1562246350384;
        Thu, 04 Jul 2019 06:19:10 -0700 (PDT)
Received: from [10.201.49.68] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id l13sm121009wrt.16.2019.07.04.06.19.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 06:19:09 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
 <760164a0-589d-d9fa-fb63-79b5e0899c00@suse.de>
 <aaa344bf-af29-0485-4e83-5442331a2c9c@redhat.com>
Message-ID: <afea12a1-47b3-0ebe-a3c2-6adc615bbddf@redhat.com>
Date:   Thu, 4 Jul 2019 15:19:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <aaa344bf-af29-0485-4e83-5442331a2c9c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/19 12:31, Paolo Bonzini wrote:
>> I'm a bit unsure if 'bd->last' is always set; it's quite obvious that
>> it's present if set, but what about requests with 'bd->last == false' ?
>> Is there a guarantee that they will _always_ be followed with a request
>> with bd->last == true?
>> And if so, is there a guarantee that this request is part of the same batch?
> It's complicated.  A request with bd->last == false _will_ always be
> followed by a request with bd->last == true in the same batch.  However,
> due to e.g. errors it may be possible that the last request is not sent.
>  In that case, the block layer sends commit_rqs, as documented in the
> comment above, to flush the requests that have been sent already.
> 
> So, a driver that obeys bd->last (or SCMD_LAST) but does not implement
> commit_rqs is bound to have bugs, which is why this patch was not split
> further.
> 
> Makes sense?

Hannes, can you provide your Reviewed-by?

Thanks,

Paolo
