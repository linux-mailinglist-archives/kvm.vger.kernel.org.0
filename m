Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C59157E04
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 15:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBJO7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 09:59:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23507 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727029AbgBJO7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 09:59:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581346778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ObcJMF9eHWDHZwvar2hIIvlhGKtrGFkhpaN5+VqsSf4=;
        b=UcUK0OvGD9QI+hMZw9nL5ybVhRACikGYqKVTi6Or1hQMm+mreLCmUueAtp/NioIBTq97sO
        Kd2+4N5IX0bvuELI/xKQL467KAZJMDCxuwjhtJ3nALf7FtVB/ac5PXuWfBd4ampvJpPMOE
        h3c8Z7EvO3a2sDV88kJWTVD+yTsFoQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-Cvox3QXjMWOsgoSU9E01hA-1; Mon, 10 Feb 2020 09:59:35 -0500
X-MC-Unique: Cvox3QXjMWOsgoSU9E01hA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FBB3190B2A6
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 14:59:34 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-219.ams2.redhat.com [10.36.116.219])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8942786E0D;
        Mon, 10 Feb 2020 14:59:31 +0000 (UTC)
Subject: Re: [kvm-unit-tests v2 PATCH] Fixes for the umip test
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200210143514.5347-1-thuth@redhat.com>
 <8701a05c-21cd-e13b-c94b-4d78b7cfefaf@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cc9d2b0f-6cea-20ba-3f01-84c9f6cdf12e@redhat.com>
Date:   Mon, 10 Feb 2020 15:59:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8701a05c-21cd-e13b-c94b-4d78b7cfefaf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/2020 15.56, Paolo Bonzini wrote:
> On 10/02/20 15:35, Thomas Huth wrote:
>>  #define GP_ASM(stmt, in, clobber)                  \
>> -     asm ("mov" W " $1f, %[expected_rip]\n\t"      \
>> +    asm volatile (                                 \
>> +          "mov" W " $1f, %[expected_rip]\n\t"      \
>>            "movl $2f-1f, %[skip_count]\n\t"         \
>>            "1: " stmt "\n\t"                        \
>>            "2: "                                    \
>> @@ -159,7 +160,7 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
>>  		  : [ret] "=&a" (ret)
>>  		  : [user_ds] "i" (USER_DS),
>>  		    [user_cs] "i" (USER_CS),
>> -		    [user_stack_top]"m"(user_stack[sizeof user_stack]),
>> +		    [user_stack_top]"m"(user_stack[sizeof(user_stack) - 2]),
> 
> This should be "- sizeof(long)" in order to keep the stack aligned.
> 
> I can fix this when I apply.

Thanks!

 Thomas

