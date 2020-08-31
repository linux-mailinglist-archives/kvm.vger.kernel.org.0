Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDDF2582A4
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 22:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgHaUdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 16:33:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728402AbgHaUdr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Aug 2020 16:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598906025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m3cKrjvQhFjHcifbaqqBNvln0dNqMfwhsC9L9HrsOGk=;
        b=XOZ3tivZaa0pwaS+31oldnJliYw3jOur4mXoTvOphJ7ro22MojEmMaLXbKlHbcnn3ggpI7
        PASHp7Q9/+uyztG64xVkoGT8vH39jn3X6e96It0ZbudHM1rBhISNp/IlvTyxBCnFAzTxIc
        pqzYS8oqKdD/X+jiPwU8wyUyuhJiUyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-6kGUkn2XPGiws4-jgvepSQ-1; Mon, 31 Aug 2020 16:33:41 -0400
X-MC-Unique: 6kGUkn2XPGiws4-jgvepSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7192B801FDE;
        Mon, 31 Aug 2020 20:33:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-174.ams2.redhat.com [10.36.112.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D894614F9;
        Mon, 31 Aug 2020 20:33:39 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/7] x86: Makefile: Allow division on
 x86_64-elf binutils
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kvm@vger.kernel.org, Cameron Esfahani <dirty@apple.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-2-r.bolshakov@yadro.com>
 <ee81540c-9064-4650-8784-d4531eec042c@redhat.com>
 <20200831173058.GA22344@SPB-NB-133.local>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <576be614-b69f-ba68-9a9e-e66ca195286e@redhat.com>
Date:   Mon, 31 Aug 2020 22:33:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200831173058.GA22344@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/08/2020 19.30, Roman Bolshakov wrote:
> On Fri, Aug 28, 2020 at 07:00:19AM +0200, Thomas Huth wrote:
>> On 10/08/2020 15.06, Roman Bolshakov wrote:
>>> +
>>> +COMMON_CFLAGS += -Wa,--divide
>>
>> Some weeks ago, I also played with an elf cross compiler and came to the
>> same conclusion, that we need this option there. Unfortunately, it does
>> not work with clang:
>>
>>  https://gitlab.com/huth/kvm-unit-tests/-/jobs/707986800#L1629
>>
>> You could try to wrap it with "cc-option" instead ... or use a proper
>> check in the configure script to detect whether it's needed or not.
>>
> 
> Hi Thomas,
> 
> I've wrapped it but clang can't deal with another option:
> -Woverride-init
> 
> Even if I wrap it with cc-option and add wrapped clang's
> -Winitializer-overrides, the build fails with:
> 
> x86/vmexit.c:577:5: error: no previous prototype for function 'main'
>       [-Werror,-Wmissing-prototypes]
> int main(int ac, char **av)
>     ^
> 1 error generated.
> <builtin>: recipe for target 'x86/vmexit.o' failed
> 
> I'm puzzled with this one.
> 
> CI log (ubuntu focal + clang 10):
> https://travis-ci.com/github/roolebo/kvm-unit-tests/jobs/379561410
> 
> Now I wonder if wrong clang is used... Perhaps I should try
> --cc=clang-10 in .travis.yml instead of --cc=clang.

 Hi Roman,

yes, if you see the "no previous prototype for function 'main'" warning,
your Clang is too old, you really need the latest and greatest version
for the kvm-unit-tests. IIRC version 10 should be fine.

 Thomas

