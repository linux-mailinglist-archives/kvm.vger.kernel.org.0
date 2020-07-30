Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FC7233622
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 17:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgG3P7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 11:59:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42485 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbgG3P7A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 11:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596124738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=yvixA7AnuX+SIl1eVGj6Lt/rHsyqN1zKTYG6L6GtgFY=;
        b=ivduR8Q1O5pW2dy5zLVJ5OtJ5KG86npwdYn7hdDOQpzQYk4PZBWs+uLMA3ITdHajV4zwSV
        mrU61WA8gN2fcdCCpNiVBNyMb0AHnfrAodD0WpK4n1SCNBk706fa7pzAVcYuILjN23qT6x
        a7OJhCFKGxTdm9RxCSaqu3+LHQkSoBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-7kPf4hY3MiOEn1K890EMag-1; Thu, 30 Jul 2020 11:58:56 -0400
X-MC-Unique: 7kPf4hY3MiOEn1K890EMag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 863DC8015CE;
        Thu, 30 Jul 2020 15:58:55 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00D0269324;
        Thu, 30 Jul 2020 15:58:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
To:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20200727095415.494318-1-frankja@linux.ibm.com>
 <20200727095415.494318-4-frankja@linux.ibm.com>
 <20200730131617.7f7d5e5f.cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1a407971-0b43-879e-0aac-65c7f9e29606@redhat.com>
Date:   Thu, 30 Jul 2020 17:58:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200730131617.7f7d5e5f.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/2020 13.16, Cornelia Huck wrote:
> On Mon, 27 Jul 2020 05:54:15 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Test the error conditions of guest 2 Ultravisor calls, namely:
>>      * Query Ultravisor information
>>      * Set shared access
>>      * Remove shared access
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>  lib/s390x/asm/uv.h  |  68 +++++++++++++++++++
>>  s390x/Makefile      |   1 +
>>  s390x/unittests.cfg |   3 +
>>  s390x/uv-guest.c    | 159 ++++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 231 insertions(+)
>>  create mode 100644 lib/s390x/asm/uv.h
>>  create mode 100644 s390x/uv-guest.c
>>
> 
> (...)
> 
>> +static inline int uv_call(unsigned long r1, unsigned long r2)
>> +{
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
>> +		"		brc	3,0b\n"
>> +		"		ipm	%[cc]\n"
>> +		"		srl	%[cc],28\n"
>> +		: [cc] "=d" (cc)
>> +		: [r1] "a" (r1), [r2] "a" (r2)
>> +		: "memory", "cc");
>> +	return cc;
>> +}
> 
> This returns the condition code, but no caller seems to check it
> (instead, they look at header.rc, which is presumably only set if the
> instruction executed successfully in some way?)
> 
> Looking at the kernel, it retries for cc > 1 (presumably busy
> conditions), and cc != 0 seems to be considered a failure. Do we want
> to look at the cc here as well?

It's there - but here it's in the assembly code, the "brc 3,0b".

Patch looks ok to me (but I didn't do a full review):

Acked-by: Thomas Huth <thuth@redhat.com>

