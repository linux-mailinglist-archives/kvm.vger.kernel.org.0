Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D121D0F6D
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 12:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732972AbgEMKLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 06:11:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24044 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732382AbgEMKLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 06:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589364704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=oXYc2UsolkTtCHbD9NEB9wSlqyw3jDJxCDg4nrdXm3w=;
        b=QZw0elh8y8t5sF+T73rMzmIGjdxMGJ/AjfkERNDmlxYhbGtw11pzXbD4RVhNxgW0LcJGpw
        elkmmf57eTa3iFu56fbAmWqH+JsR/aUWdjkG+TdXiW7DDhQbwmdDbW/wpoRQdeiOLlBfg/
        pVHFHmKVtJ7L3VQlSyamyLXUWb//nNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-AQOHtbnMM8ijAEMwRPGzAw-1; Wed, 13 May 2020 06:11:42 -0400
X-MC-Unique: AQOHtbnMM8ijAEMwRPGzAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13633835BE1
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 10:11:42 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-100.ams2.redhat.com [10.36.114.100])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB1E45C1C3;
        Wed, 13 May 2020 10:11:40 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] Always compile the kvm-unit-tests with
 -fno-common
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     dgilbert@redhat.com
References: <20200512095546.25602-1-thuth@redhat.com>
 <a87824f4-354a-3fb8-f91d-501e2fc5ece4@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d1fa1aae-f648-f734-e7e4-82deb8a60db6@redhat.com>
Date:   Wed, 13 May 2020 12:11:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a87824f4-354a-3fb8-f91d-501e2fc5ece4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2020 12.05, Thomas Huth wrote:
> On 12/05/2020 11.55, Thomas Huth wrote:
>> The new GCC v10 uses -fno-common by default. To avoid that we commit
>> code that declares global variables twice and thus fails to link with
>> the latest version, we should also compile with -fno-common when using
>> older versions of the compiler.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 754ed65..3ff2f91 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -49,7 +49,7 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
>>  cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
>>                > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
>>  
>> -COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing
>> +COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
> 
> Oh, wait, this breaks the non-x86 builds due to "extern-less" struct
> auxinfo auxinfo in libauxinfo.h !
> Drew, why isn't this declared in auxinfo.c instead?

Oh well, it's there ... so we're playing tricks with the linker here? I
guess adding a "__attribute__((common, weak))" to auxinfo.h will be ok
to fix this issue?

 Thomas

