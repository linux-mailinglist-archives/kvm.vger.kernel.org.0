Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9FE6E07BB
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbfJVPo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:44:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58559 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731491AbfJVPo5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 11:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571759096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QABzq2oUgKUElQCrTF2ej71YCTL0kfY3HQ1syVli3QA=;
        b=WVHdsd24Zx2fU4GBZP8f8VtQnSeRSUpyHbQzPn1YT8Gb1aVaMp80m0qduDKNJnQXOBPmrl
        XQ5K6oQmKqx/qpx1OHAAVHezw75RAv5cyLU/6QdyZ+NYk+ctJ3bXvplK8/DTyrtw9mwNDW
        u/Dpkj1ZzI6aEoJrarb5ozq+OJeJ01o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-XW3aRrH8Mpm9B2NRSIdgNA-1; Tue, 22 Oct 2019 11:44:52 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79699476;
        Tue, 22 Oct 2019 15:44:51 +0000 (UTC)
Received: from [10.36.116.248] (ovpn-116-248.ams2.redhat.com [10.36.116.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CA205C222;
        Tue, 22 Oct 2019 15:44:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 3/5] s390x: sclp: expose ram_size and
 max_ram_size
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com
References: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
 <1571741584-17621-4-git-send-email-imbrenda@linux.ibm.com>
 <4123dae6-bc6c-6177-3465-828f2cca086d@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <685ba0c1-8e23-81c5-5cf9-2fb50769a4f9@redhat.com>
Date:   Tue, 22 Oct 2019 17:44:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <4123dae6-bc6c-6177-3465-828f2cca086d@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: XW3aRrH8Mpm9B2NRSIdgNA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.10.19 14:16, Thomas Huth wrote:
> On 22/10/2019 12.53, Claudio Imbrenda wrote:
>> Expose ram_size and max_ram_size through accessor functions.
>>
>> We only use get_ram_size in an upcoming patch, but having an accessor
>> for the other one does not hurt.
>>
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>   lib/s390x/sclp.h | 2 ++
>>   lib/s390x/sclp.c | 9 +++++++++
>>   2 files changed, 11 insertions(+)
>>
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index f00c3df..6d40fb7 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -272,5 +272,7 @@ void sclp_console_setup(void);
>>   void sclp_print(const char *str);
>>   int sclp_service_call(unsigned int command, void *sccb);
>>   void sclp_memory_setup(void);
>> +uint64_t get_ram_size(void);
>> +uint64_t get_max_ram_size(void);
>>  =20
>>   #endif /* SCLP_H */
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 56fca0c..a57096c 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -167,3 +167,12 @@ void sclp_memory_setup(void)
>>  =20
>>   =09mem_init(ram_size);
>>   }
>> +
>> +uint64_t get_ram_size(void)
>> +{
>> +=09return ram_size;
>> +}
>> +uint64_t get_max_ram_size(void)
>> +{
>> +=09return max_ram_size;
>> +}
>=20
> In case you respin, please add an empty line between the two functions.
>

Indeed

Reviewed-by: David Hildenbrand <david@redhat.com>

> Reviewed-by: Thomas Huth <thuth@redhat.com>
>=20

--=20

Thanks,

David / dhildenb

