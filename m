Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7479749B307
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 12:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355992AbiAYLlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 06:41:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356607AbiAYLgS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 06:36:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643110572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HdAh07n39LkLkBs/H9oheuevBjaeT4FvPn+TzmQfVY8=;
        b=S6Usuai4x7/zm6h537AK5U3GyV3xRDcORvlyIKEUz7+EBw+jx2MqurFN6ZWn1jhfdXI6Pt
        pwksGgU6AsAWWQv2a1lAvC7PdjQwesbD56/Shgib2CI5RraGkJ74FCZnQHmZXuxcEZvpIa
        H4Inb9HIF2/Bm8pHzYV6eHkF+PL3oFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-A4R6AmTLN2yXGDSH9ZebpQ-1; Tue, 25 Jan 2022 06:36:10 -0500
X-MC-Unique: A4R6AmTLN2yXGDSH9ZebpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D27D100C661;
        Tue, 25 Jan 2022 11:36:09 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-112-10.ams2.redhat.com [10.36.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FB34106C064;
        Tue, 25 Jan 2022 11:36:09 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id F3A9E113864A; Tue, 25 Jan 2022 12:36:07 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: KVM call for agenda for 2022-01-25
References: <87y2355xe8.fsf@secure.mitica>
Date:   Tue, 25 Jan 2022 12:36:07 +0100
In-Reply-To: <87y2355xe8.fsf@secure.mitica> (Juan Quintela's message of "Mon,
        24 Jan 2022 09:51:59 +0100")
Message-ID: <87mtjk2gk8.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juan Quintela <quintela@redhat.com> writes:

> Hi
>
> Please, send any topic that you are interested in covering.
>
> This week we have a continuation of 2 weeks ago call to discuss how to
> enable creation of machines from QMP sooner on the boot.
>
> There was already a call about this 2 weeks ago where we didn't finished
> everything.
> I have been on vacation last week and I haven't been able to send a
> "kind of resume" of the call.
>
> Basically what we need is:
> - being able to create machines sooner that we are today
> - being able to change the devices that are in the boards, in
>   particular, we need to be able to create a board deciding what devices
>   it has and how they are connected without recompiling qemu.
>   This means to launch QMP sooner that we do today.
> - Several options was proposed:
>   - create a new binary that only allows QMP machine creation.
>     and continue having the old command line
>   - create a new binary, and change current HMP/command line to just
>     call this new binary.  This way we make sure that everything can be
>     done through QMP.
>   - stay with only one binary but change it so we can call QMP sooner.
> - There is agreement that we need to be able to call QMP sooner.
> - There is NO agreement about how the best way to proceed:
>   * We don't want this to be a multiyear effort, i.e. we want something
>     that can be used relatively soon (this means that using only one
>     binary can be tricky).
>   * If we start with a new binary that only allows qmp and we wait until
>     everything has been ported to QMP, it can take forever, and during
>     that time we have to maintain two binaries.
>   * Getting a new binary lets us to be more agreessive about what we can
>     remove/change. i.e. easier experimentation.
>   * Management Apps will only use QMP, not the command line, or they
>     even use libvirt and don't care at all about qemu.  So it appears
>     that HMP is only used for developers, so we can be loose about
>     backwards compatibility. I.e. if we allow the same functionality,
>     but the syntax is different, we don't care.
>
> Discussion was longer, but it was difficult to take notes and as I said,
> the only thing that appears that everybody agrees is that we need an
> agreement about what is the plan to go there.
>
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.
>
>  Call details:
>
> By popular demand, a google calendar public entry with it
>
>   https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
>
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).

https://wiki.qemu.org/Contribute claims the call is at

    $ date -d 'TZ="America/New_York" Tuesday 10:00 am'
    Tue Jan 25 16:00:00 CET 2022

Is that correct?

> If you need phone number details,  contact me privately
>
> Thanks, Juan.

