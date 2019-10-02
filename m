Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CCDC8E21
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 18:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfJBQSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 12:18:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfJBQSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 12:18:37 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06BF93DE31
        for <kvm@vger.kernel.org>; Wed,  2 Oct 2019 16:18:37 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id b6so7754167wrx.0
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 09:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6ZhITsPneL94qWoRluv41le5MvhMUSrgfy0ZbZ3MNWY=;
        b=IwFgRDvyPDFfJ6mLRT7OEtzXoWgPhoh0FNGoDCOOEPjwCd9RkjjVwv011YEGhv/NbA
         e6nOs4nPV/ef8HmkYDDnTGi+psuQ4Wy9wNuctV6pTxkHRk8hmPYyhiQVNZOXAVKUrb5P
         Z8hEbElivZehfCwfz0UDFSqXUyTcXwXBwEhwEmt3BYGC2KXLjBBRbvrhqoRkmVEOSDai
         J7UXKHw3c/AiW8J/i9pqIRibhcsihcoJQp+9aGrBUeETT89LPjAjvzgW7rgmVngmCccJ
         kqguGFDjFHluj5cl/IjAANS7ce811gC1637RHMZaeBTRxo8qUjt2BMwte+GVrU4u/AUF
         D+LA==
X-Gm-Message-State: APjAAAUDnzHzuo/wm3npZjpQwo3122y/szsBDAWP5C+9y1EStJ/rwAf4
        BUFhKcXsDahwKcwocQrb42vA3MhUaow069cPe4WFfn6jZJk/M78PivIyavbb2CmpQg7M/yNl5UC
        bDuUfCVgY0E0f
X-Received: by 2002:a1c:f30d:: with SMTP id q13mr3275212wmq.60.1570033115585;
        Wed, 02 Oct 2019 09:18:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwxhi8AW/TlHHusqE7QUZP3nNGuJAIE/3gdUje0swYiiC/Z/59HcyM8JyxdUXcsXbx3NseHOw==
X-Received: by 2002:a1c:f30d:: with SMTP id q13mr3275192wmq.60.1570033115335;
        Wed, 02 Oct 2019 09:18:35 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 79sm9828724wmb.7.2019.10.02.09.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 09:18:34 -0700 (PDT)
Subject: Re: [PULL 09/12] kvm: clear dirty bitmaps from all overlapping
 memslots
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Kevin Wolf <kwolf@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, Peter Xu <peterx@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        qemu-s390x <qemu-s390x@nongnu.org>, kvm@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Richard Henderson <rth@twiddle.net>
References: <20190930131955.101131-1-borntraeger@de.ibm.com>
 <20190930131955.101131-10-borntraeger@de.ibm.com>
 <20191002160120.GC5819@localhost.localdomain>
 <9e483c65-0ce8-e8cf-6a98-532d82105cfc@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7bb4a1aa-9a34-da98-325f-b3ff78142a3b@redhat.com>
Date:   Wed, 2 Oct 2019 18:18:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9e483c65-0ce8-e8cf-6a98-532d82105cfc@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/19 18:13, Christian Borntraeger wrote:
> Does 
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index aabe097c410f..e2605da22e7e 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -712,7 +712,7 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
>      KVMState *s = kvm_state;
>      uint64_t start, size, offset, count;
>      KVMSlot *mem;
> -    int ret, i;
> +    int ret = 0, i;
>  
>      if (!s->manual_dirty_log_protect) {
>          /* No need to do explicit clear */
> 
> 
> fix the message?
> 

Yes, I'm sending shortly a pull request.

Paolo
