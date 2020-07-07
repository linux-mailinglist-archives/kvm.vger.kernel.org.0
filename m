Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B78A216776
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 09:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgGGH3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 03:29:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23124 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725825AbgGGH3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 03:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594106943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=dm0oGfERmrVOcNk9u8P2EaF1rmLiov/jnk9P0m6RbO0=;
        b=WNjh3cWiiRQL/fAm81lIxizZq1XSniRxV+V2LYNe73qQk5Ch6cTepA8+wWSMTiGnrYaW6z
        efiDWqGus0wuUrYM8TcsB5RqdR2JZfyNyN7a1yg1fonLulN/IIgKhE4mhYAaLBoTK6ymK2
        2R6jBI067VUyx78O1cXElxAgGcB1xnA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180--jR94u85OpOEpoQkWSzzSA-1; Tue, 07 Jul 2020 03:29:01 -0400
X-MC-Unique: -jR94u85OpOEpoQkWSzzSA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C41F18015F5;
        Tue,  7 Jul 2020 07:29:00 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-77.ams2.redhat.com [10.36.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D81AA7890F;
        Tue,  7 Jul 2020 07:28:56 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x/cpumodel: The missing DFP facility
 on TCG is expected
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200707055619.6162-1-thuth@redhat.com>
 <20200707092229.20ca019e.cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2b290410-2aad-7b90-bdba-4b2713ad285f@redhat.com>
Date:   Tue, 7 Jul 2020 09:28:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200707092229.20ca019e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/2020 09.22, Cornelia Huck wrote:
> On Tue,  7 Jul 2020 07:56:19 +0200
> Thomas Huth <thuth@redhat.com> wrote:
> 
>> When running the kvm-unit-tests with TCG on s390x, the cpumodel test
>> always reports the error about the missing DFP (decimal floating point)
>> facility. This is kind of expected, since DFP is not required for
>> running Linux and thus nobody is really interested in implementing
>> this facility in TCG. Thus let's mark this as an expected error instead,
>> so that we can run the kvm-unit-tests also with TCG without getting
>> test failures that we do not care about.
> 
> Checking for tcg seems reasonable.
> 
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  s390x/cpumodel.c | 51 ++++++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 45 insertions(+), 6 deletions(-)
>>
>> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
>> index 5d232c6..4310b92 100644
>> --- a/s390x/cpumodel.c
>> +++ b/s390x/cpumodel.c
>> @@ -11,6 +11,7 @@
>>   */
>>  
>>  #include <asm/facility.h>
>> +#include <alloc_page.h>
>>  
>>  static int dep[][2] = {
>>  	/* from SA22-7832-11 4-98 facility indications */
>> @@ -38,6 +39,49 @@ static int dep[][2] = {
>>  	{ 155,  77 },
>>  };
>>  
>> +/*
>> + * A hack to detect TCG (instead of KVM): QEMU uses "TCGguest" as guest
>> + * name by default when we are running with TCG (otherwise it's "KVMguest")
> 
> The guest name can be overwritten; I think it would be better to check
> for something hardcoded.
> 
> Maybe the manufacturer name in SYSIB 1.1.1? When running under tcg,
> it's always 'QEMU' (it's 'IBM' when running under KVM).

OK, I'll have a try.

>> + */
>> +static bool is_tcg(void)
>> +{
>> +	bool ret = false;
>> +	uint8_t *buf;
>> +
>> +	buf = alloc_page();
>> +	if (!buf)
>> +		return false;
>> +
>> +	if (stsi(buf, 3, 2, 2)) {
>> +		goto out;
>> +	}
>> +
>> +	/* Does the name start with "TCG" in EBCDIC? */
>> +	if (buf[2048] == 0x54 && buf[2049] == 0x43 && buf[2050] == 0x47)
>> +		ret = true;
>> +
>> +out:
>> +	free_page(buf);
>> +	return ret;
>> +}
>> +
>> +static void check_dependency(int dep1, int dep2)
> 
> <bikeshed>
> Can we find more speaking parameter names? facility/implied?
> </bikeshed>

That makes sense, indeed.

 Thanks,
  Thomas

