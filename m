Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B625D165EAA
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgBTNYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:24:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39624 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727996AbgBTNYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:24:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582205045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MHg/5UrUaWqOGPMbBFxMDVDMQH9eo1mTFc5tISJLXMw=;
        b=Ia+ozEhhF3eUCi/ug6FgFDqKx0ACSKfdqlnwoC1648FeKBIFg33tpj65HDqZ49X+7vXOEq
        8C60UPDxzFtCz2elSPe6YBZDmV6oK1169V/48KSH0fXh2R4BjX58+gT9Q6Xw+dGTav9MPt
        CMl4bNd4rSus1RiexYAj2hmt1g1hoDc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-QCmmPJqaN9KOUb0RuWwslA-1; Thu, 20 Feb 2020 08:24:04 -0500
X-MC-Unique: QCmmPJqaN9KOUb0RuWwslA-1
Received: by mail-ed1-f70.google.com with SMTP id m21so2674606edp.14
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:24:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MHg/5UrUaWqOGPMbBFxMDVDMQH9eo1mTFc5tISJLXMw=;
        b=nbOo/rIZ/DGEKFyV0ELGBTIBEsFhUuDRzQ2pTdpisjmJi3unkkKg2jId4iqECg+2b5
         4hvwwLmSnb93dmdjNEPiksM69pYRf3t4GknWtKdrp7Gtkk4aUt39XLsVQ/ZBdFY/E2O9
         mCUWwH429dJnJkrh5iKrs1fVlr9J2TgvpyZo/eV17bTmLStB9fz0BRuGGBvOAXm3av8Z
         PV8eemC8SJ16pEQxWZoIY92GYBtv4Bmylvg35gG8CNcy5iTkSmIY3NCIqnYhdhlhA8UJ
         gZP5E7AW1b1oEFip75gFbOm1TaCQ/iyoQjl0nzKJglxL0Vvzc/gbfVvK3H8/jOFjWoXc
         W+NQ==
X-Gm-Message-State: APjAAAXB7BeYbjN7qCvMVeyEmTN9evxp3FojSNNVvbp1ohGle9aLetfR
        xDoF8e7aY1Rx/uOMnPdOPeVZiImOKuMPxm5hKRf/e0TNlP2LFGXLhN1CnWrNgWXYwex+FePgDRW
        3pXAkz9CiomDg
X-Received: by 2002:a50:fc05:: with SMTP id i5mr29170790edr.343.1582205042921;
        Thu, 20 Feb 2020 05:24:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqznBcBibxmOR37VsiYJJjL+jelcdk8lkiHN5SpgVrHqzRKo/B7Z+Qf6ZCdlOSA+ufQfA3o7ew==
X-Received: by 2002:a50:fc05:: with SMTP id i5mr29170765edr.343.1582205042706;
        Thu, 20 Feb 2020 05:24:02 -0800 (PST)
Received: from [192.168.1.35] (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id l11sm99933edi.28.2020.02.20.05.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 05:24:02 -0800 (PST)
Subject: Re: [PATCH v3 03/20] exec: Let qemu_ram_*() functions take a const
 pointer argument
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
 <20200220130548.29974-4-philmd@redhat.com>
 <fce0956e-e542-e8a5-bd02-a7941a9db627@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <34fc1b00-4e95-6235-3e82-294b572a209b@redhat.com>
Date:   Thu, 20 Feb 2020 14:23:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fce0956e-e542-e8a5-bd02-a7941a9db627@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/20 2:21 PM, Paolo Bonzini wrote:
> On 20/02/20 14:05, Philippe Mathieu-Daudé wrote:
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   include/exec/cpu-common.h     | 6 +++---
>>   include/sysemu/xen-mapcache.h | 4 ++--
>>   exec.c                        | 8 ++++----
>>   hw/i386/xen/xen-mapcache.c    | 2 +-
>>   4 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
>> index 81753bbb34..05ac1a5d69 100644
>> --- a/include/exec/cpu-common.h
>> +++ b/include/exec/cpu-common.h
>> @@ -48,11 +48,11 @@ typedef uint32_t CPUReadMemoryFunc(void *opaque, hwaddr addr);
>>   
>>   void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
>>   /* This should not be used by devices.  */
>> -ram_addr_t qemu_ram_addr_from_host(void *ptr);
>> +ram_addr_t qemu_ram_addr_from_host(const void *ptr);
> 
> This is a bit ugly, because the pointer _can_ be modified via
> qemu_map_ram_ptr.

OK.

> Is this needed for the rest of the series to apply?

No!

> Paolo
> 
>>   RAMBlock *qemu_ram_block_by_name(const char *name);
>> -RAMBlock *qemu_ram_block_from_host(void *ptr, bool round_offset,
>> +RAMBlock *qemu_ram_block_from_host(const void *ptr, bool round_offset,
>>                                      ram_addr_t *offset);
>> -ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host);
>> +ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, const void *host);
>>   void qemu_ram_set_idstr(RAMBlock *block, const char *name, DeviceState *dev);
>>   void qemu_ram_unset_idstr(RAMBlock *block);
>>   const char *qemu_ram_get_idstr(RAMBlock *rb);
>> diff --git a/include/sysemu/xen-mapcache.h b/include/sysemu/xen-mapcache.h
>> index c8e7c2f6cf..81e9aa2fa6 100644
>> --- a/include/sysemu/xen-mapcache.h
>> +++ b/include/sysemu/xen-mapcache.h
>> @@ -19,7 +19,7 @@ void xen_map_cache_init(phys_offset_to_gaddr_t f,
>>                           void *opaque);
>>   uint8_t *xen_map_cache(hwaddr phys_addr, hwaddr size,
>>                          uint8_t lock, bool dma);
>> -ram_addr_t xen_ram_addr_from_mapcache(void *ptr);
>> +ram_addr_t xen_ram_addr_from_mapcache(const void *ptr);
>>   void xen_invalidate_map_cache_entry(uint8_t *buffer);
>>   void xen_invalidate_map_cache(void);
>>   uint8_t *xen_replace_cache_entry(hwaddr old_phys_addr,
>> @@ -40,7 +40,7 @@ static inline uint8_t *xen_map_cache(hwaddr phys_addr,
>>       abort();
>>   }
>>   
>> -static inline ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
>> +static inline ram_addr_t xen_ram_addr_from_mapcache(const void *ptr)
>>   {
>>       abort();
>>   }
>> diff --git a/exec.c b/exec.c
>> index 8e9cc3b47c..02b4e6ea41 100644
>> --- a/exec.c
>> +++ b/exec.c
>> @@ -2614,7 +2614,7 @@ static void *qemu_ram_ptr_length(RAMBlock *ram_block, ram_addr_t addr,
>>   }
>>   
>>   /* Return the offset of a hostpointer within a ramblock */
>> -ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host)
>> +ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, const void *host)
>>   {
>>       ram_addr_t res = (uint8_t *)host - (uint8_t *)rb->host;
>>       assert((uintptr_t)host >= (uintptr_t)rb->host);
>> @@ -2640,11 +2640,11 @@ ram_addr_t qemu_ram_block_host_offset(RAMBlock *rb, void *host)
>>    * pointer, such as a reference to the region that includes the incoming
>>    * ram_addr_t.
>>    */
>> -RAMBlock *qemu_ram_block_from_host(void *ptr, bool round_offset,
>> +RAMBlock *qemu_ram_block_from_host(const void *ptr, bool round_offset,
>>                                      ram_addr_t *offset)
>>   {
>>       RAMBlock *block;
>> -    uint8_t *host = ptr;
>> +    const uint8_t *host = ptr;
>>   
>>       if (xen_enabled()) {
>>           ram_addr_t ram_addr;
>> @@ -2705,7 +2705,7 @@ RAMBlock *qemu_ram_block_by_name(const char *name)
>>   
>>   /* Some of the softmmu routines need to translate from a host pointer
>>      (typically a TLB entry) back to a ram offset.  */
>> -ram_addr_t qemu_ram_addr_from_host(void *ptr)
>> +ram_addr_t qemu_ram_addr_from_host(const void *ptr)
>>   {
>>       RAMBlock *block;
>>       ram_addr_t offset;
>> diff --git a/hw/i386/xen/xen-mapcache.c b/hw/i386/xen/xen-mapcache.c
>> index 5b120ed44b..432ad3354d 100644
>> --- a/hw/i386/xen/xen-mapcache.c
>> +++ b/hw/i386/xen/xen-mapcache.c
>> @@ -363,7 +363,7 @@ uint8_t *xen_map_cache(hwaddr phys_addr, hwaddr size,
>>       return p;
>>   }
>>   
>> -ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
>> +ram_addr_t xen_ram_addr_from_mapcache(const void *ptr)
>>   {
>>       MapCacheEntry *entry = NULL;
>>       MapCacheRev *reventry;
>>
> 

