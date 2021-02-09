Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABEE3153B3
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 17:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbhBIQUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 11:20:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232561AbhBIQUo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 11:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612887559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rs1U26YidrsL9SDdBBzeFvyIeFC5YMnTPS33wvzZgOY=;
        b=NYXF3U97Y0vTtMNOfk7FVVb+9+4VqZ1CPOLQEGxH8Aa24S7ZGXHp/adUa/DEQgn03XxubW
        s4lXB8O76GwQEWckTsuOB5Gm6K+ZnMieAyOIL0EnaFi47wcz/96TgPnTkk5sR0zfxIYiBn
        pzED8qxLSAXUmGI9CkPO62Qmf2CBpQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-QEcwZ5tpOYCF3PFLRISnBg-1; Tue, 09 Feb 2021 11:19:15 -0500
X-MC-Unique: QEcwZ5tpOYCF3PFLRISnBg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EA11C7440;
        Tue,  9 Feb 2021 16:19:13 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-56.ams2.redhat.com [10.36.114.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46DDA171F4;
        Tue,  9 Feb 2021 16:19:09 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: Workaround smp stop and store
 status race
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com
References: <20210209141554.22554-1-frankja@linux.ibm.com>
 <20210209170804.75d1fc9d@ibm-vm>
 <a361e674-fa78-8c06-0583-29f8989d5493@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f0aa4cc7-03dd-5761-8cc5-ceeb834526f8@redhat.com>
Date:   Tue, 9 Feb 2021 17:19:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <a361e674-fa78-8c06-0583-29f8989d5493@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/2021 17.14, Janosch Frank wrote:
> On 2/9/21 5:08 PM, Claudio Imbrenda wrote:
>> On Tue,  9 Feb 2021 09:15:54 -0500
>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>
>>> KVM and QEMU handle a SIGP stop and store status in two steps:
>>> 1) Stop the CPU by injecting a stop request
>>> 2) Store when the CPU has left SIE because of the stop request
>>>
>>> The problem is that the SIGP order is already considered completed by
>>> KVM/QEMU when step 1 has been performed and not once both have
>>> completed. In addition we currently don't implement the busy CC so a
>>> kernel has no way of knowing that the store has finished other than
>>> checking the location for the store.
>>>
>>> This workaround is based on the fact that for a new SIE entry (via the
>>> added smp restart) a stop with the store status has to be finished
>>> first.
>>>
>>> Correct handling of this in KVM/QEMU will need some thought and time.
>>
>> do I understand correctly that you are here "fixing" the test by not
>> triggering the KVM bug? Shouldn't we try to trigger as many bugs as
>> possible instead?
> 
> This is not a bug, it's missing code :-)
> 
> We trigger a higher number of bugs by running tests and this workaround
> does exactly that by letting Thomas use the smp test in the CI again.

Alternatively, we could use report_xfail here to make the test pass, but 
still have the problem reported so that we do not forget to fix it later.

  Thomas

