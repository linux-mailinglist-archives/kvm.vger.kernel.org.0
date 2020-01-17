Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DC61407F1
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 11:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgAQK3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 05:29:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56999 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726085AbgAQK3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 05:29:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579256956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=PMWDPnJBobkxIlXLC91KDzXsOyrhs8751trToJX9l5E=;
        b=KoJI9XtZa7d/VyUzII6IskXo7XxHFnAn5AxUgyBoNoHk8qyUhChqljp8ELjpF7Ju0hyHy+
        UZ4IMjLaJLbg7R42FHm5Biob1aXancQuKJEm805x5OtX0XoC1mdeHgUe22ZPK+vNisV0S6
        zV6U1CRT3UcO+i9CfMm3667oUtx2aik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-8yHHzf8yPeayvUUmCe0mKQ-1; Fri, 17 Jan 2020 05:29:13 -0500
X-MC-Unique: 8yHHzf8yPeayvUUmCe0mKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D461107ACC7;
        Fri, 17 Jan 2020 10:29:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-212.ams2.redhat.com [10.36.116.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6108C5D9CD;
        Fri, 17 Jan 2020 10:29:08 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 7/7] s390x: smp: Dirty fpc before
 initial reset test
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        cohuck@redhat.com
References: <20200116120513.2244-1-frankja@linux.ibm.com>
 <20200116120513.2244-8-frankja@linux.ibm.com>
 <0ddfb1ce-16e4-017f-078b-80146bfa29a6@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3f034419-2342-0571-ea68-0474d45ba552@redhat.com>
Date:   Fri, 17 Jan 2020 11:29:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0ddfb1ce-16e4-017f-078b-80146bfa29a6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/01/2020 11.20, David Hildenbrand wrote:
> On 16.01.20 13:05, Janosch Frank wrote:
>> Let's dirty the fpc, before we test if the initial reset sets it to 0.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  s390x/smp.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/s390x/smp.c b/s390x/smp.c
>> index ce3215d..97a9dda 100644
>> --- a/s390x/smp.c
>> +++ b/s390x/smp.c
>> @@ -179,6 +179,9 @@ static void test_emcall(void)
>>  /* Used to dirty registers of cpu #1 before it is reset */
>>  static void test_func_initial(void)
>>  {
>> +	asm volatile(
>> +		"	sfpc	%0\n"
>> +		: : "d" (0x11) : );
> 
> FWIW, I'd make this one easier to read
> 
> asm volatile("sfpc %0\n" :: "d" (0x11));

By the way, since it's only one line, you can also drop the \n here.

 Thomas

