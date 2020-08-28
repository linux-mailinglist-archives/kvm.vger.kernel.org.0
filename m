Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251CC25555F
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 09:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgH1He3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 03:34:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46610 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726500AbgH1He0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 03:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598600065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3X6zZzgz30Lv7DvDfYgUaDlSmQcnM7orJWNHFC2szzI=;
        b=XKvg/7dA/yW0sX2cqIiyuqIF+zeAPEKoOaLr9PfyYkYNBvPOxQQvaPRGIMHoyfwENP3yKx
        Yr7jppMZCs6WkZmF1EyXAPu/X677W4+Zk8WdJvO6E6LEq/klkiSwh3NplZTNWG344/JAN6
        FxuHRvcrjSCYvdnpwHOeV8gHs2qY6dc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-_4LLFritPAGQqnQcSMBTGA-1; Fri, 28 Aug 2020 03:34:23 -0400
X-MC-Unique: _4LLFritPAGQqnQcSMBTGA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FDCF10ABDBF;
        Fri, 28 Aug 2020 07:34:22 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-79.ams2.redhat.com [10.36.112.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AB696198B;
        Fri, 28 Aug 2020 07:34:21 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 6/7] configure: Add an option to specify
 getopt
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kvm@vger.kernel.org, Cameron Esfahani <dirty@apple.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-7-r.bolshakov@yadro.com>
 <ebccbbb2-dc9b-9ff4-c89c-8fdd6f463a50@redhat.com>
 <20200828071236.GB54274@SPB-NB-133.local>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <3142052b-b905-6296-2655-9c708d689c77@redhat.com>
Date:   Fri, 28 Aug 2020 09:34:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200828071236.GB54274@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/08/2020 09.12, Roman Bolshakov wrote:
> On Fri, Aug 28, 2020 at 07:55:53AM +0200, Thomas Huth wrote:
>> On 10/08/2020 15.06, Roman Bolshakov wrote:
>>> macOS is shipped with an old non-enhanced version of getopt and it
>>> doesn't support options used by run_tests.sh. Proper version of getopt
>>> is available from homebrew but it has to be added to PATH before invoking
>>> run_tests.sh. It's not convenient because it has to be done in each
>>> shell instance and there could be many if a multiplexor is used.
>>>
>>> The change provides a way to override getopt and halts ./configure if
>>> enhanced getopt can't be found.
>>>
>>> Cc: Cameron Esfahani <dirty@apple.com>
>>> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
>>> ---
>>>  configure    | 13 +++++++++++++
>>>  run_tests.sh |  2 +-
>>>  2 files changed, 14 insertions(+), 1 deletion(-)
>>
>> Is this still required with a newer version of bash? The one that ships
>> with macOS is just too old...
>>
>> I assume that getopt is a builtin function in newer versions of the bash?
>>
> 
> Except it has `s` at the end. There's a getopts built-in in bash.
> I'll try to replace external getopt with getopts.

Ouch, ok, I wasn't aware of the difference between getopt and getopts. I
guess your patch here is ok in that case.

Or maybe we should simply revert d4d34e6484825ee5734b042c215c06
("run_tests: fix command line options handling") and state in the docs
that options have to be given before the tests on the command line...

 Thomas

