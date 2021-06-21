Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234513AE30E
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 08:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhFUGVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 02:21:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhFUGVb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 02:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624256357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dux2cUFImLRKn85ybuSPa/zW6LP/oKBWsPIgHV1K8bU=;
        b=Rud4fGuSMPeJMtrjYdPIozec4noWwm5Asp6pDLLA3gtaMXZ88Musi9Z9ZwyXWUiXBFv1do
        xe4sTP+HRYx6orHWIStC62LJtDFrSnTNPAB4I5QVY+/Z1gN3m/zxzdrP7iY/7JnFLzAwnc
        ompO6p42Prk0Mz7J+weMeucOVDHR4M0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-sgUYmBzuPcKDNihrjFxmDQ-1; Mon, 21 Jun 2021 02:19:15 -0400
X-MC-Unique: sgUYmBzuPcKDNihrjFxmDQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 877C2C740D;
        Mon, 21 Jun 2021 06:19:13 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-112-99.ams2.redhat.com [10.36.112.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10FCF60BD9;
        Mon, 21 Jun 2021 06:19:13 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 93888112D587; Mon, 21 Jun 2021 08:19:11 +0200 (CEST)
From:   Markus Armbruster <armbru@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Denis Lunev <den@openvz.org>, Eric Blake <eblake@redhat.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
        <87im2d6p5v.fsf@dusky.pond.sub.org>
        <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
        <87a6no3fzf.fsf@dusky.pond.sub.org>
        <790d22e1-5de9-ba20-6c03-415b62223d7d@suse.de>
        <877dis1sue.fsf@dusky.pond.sub.org>
        <20210617153949.GA357@dhcp-172-16-24-191.sw.ru>
        <e69ea2b4-21cc-8203-ad2d-10a0f4ffe34a@suse.de>
        <20210617165111.eu3x2pvinpoedsqj@habkost.net>
        <87sg1fwwgg.fsf@dusky.pond.sub.org>
        <20210618204006.k6krwuz2lpxvb6uh@habkost.net>
Date:   Mon, 21 Jun 2021 08:19:11 +0200
In-Reply-To: <20210618204006.k6krwuz2lpxvb6uh@habkost.net> (Eduardo Habkost's
        message of "Fri, 18 Jun 2021 16:40:06 -0400")
Message-ID: <8735tb68ps.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> On Fri, Jun 18, 2021 at 07:52:47AM +0200, Markus Armbruster wrote:
>> Eduardo Habkost <ehabkost@redhat.com> writes:
>> 
>> > On Thu, Jun 17, 2021 at 05:53:11PM +0200, Claudio Fontana wrote:
>> >> On 6/17/21 5:39 PM, Valeriy Vdovin wrote:
>> >> > On Thu, Jun 17, 2021 at 04:14:17PM +0200, Markus Armbruster wrote:
>> >> >> Claudio Fontana <cfontana@suse.de> writes:
>> >> >>
>> >> >>> On 6/17/21 1:09 PM, Markus Armbruster wrote:
>> 
>> [...]
>> 
>> >> >>>> If it just isn't implemented for anything but KVM, then putting "kvm"
>> >> >>>> into the command name is a bad idea.  Also, the commit message should
>> >> >>>> briefly note the restriction to KVM.
>> >> >>
>> >> >> Perhaps this one is closer to reality.
>> >> >>
>> >> > I agree.
>> >> > What command name do you suggest?
>> >> 
>> >> query-exposed-cpuid?
>> >
>> > Pasting the reply I sent at [1]:
>> >
>> >   I don't really mind how the command is called, but I would prefer
>> >   to add a more complex abstraction only if maintainers of other
>> >   accelerators are interested and volunteer to provide similar
>> >   functionality.  I don't want to introduce complexity for use
>> >   cases that may not even exist.
>> >
>> > I'm expecting this to be just a debugging mechanism, not a stable
>> > API to be maintained and supported for decades.  (Maybe a "x-"
>> > prefix should be added to indicate that?)
>> >
>> > [1] https://lore.kernel.org/qemu-devel/20210602204604.crsxvqixkkll4ef4@habkost.net
>> 
>> x-query-x86_64-cpuid?
>> 
>
> Unless somebody wants to spend time designing a generic
> abstraction around this (and justify the extra complexity), this
> is a KVM-specific command.  Is there a reason to avoid "kvm" in
> the command name?

I can't see what's specific to KVM in the interface (it's implemented
only for KVM, but that's just a restriction).  The doc comment looks
like the command returns whatever the guest's cpuid instruction will
write to registers.  Can you help me understand the interface's KVM
dependence?

