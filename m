Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9B1120147
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 10:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfLPJff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 04:35:35 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:42492 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726881AbfLPJff (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 04:35:35 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1igmmr-0002J4-NM; Mon, 16 Dec 2019 10:35:33 +0100
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 3/3] kvm/arm: Standardize kvm exit reason field
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Dec 2019 09:35:33 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <paulus@ozlabs.org>,
        <jhogan@kernel.org>, <drjones@redhat.com>
In-Reply-To: <87r214aazb.fsf@vitty.brq.redhat.com>
References: <20191212024512.39930-4-gshan@redhat.com>
 <2e960d77afc7ac75f1be73a56a9aca66@www.loen.fr>
 <f101e4a6-bebf-d30f-3dfe-99ded0644836@redhat.com>
 <30c0da369a898143246106205cb3af59@www.loen.fr>
 <b7b6b18c-1d51-b0c2-32df-95e0b7a7c1e5@redhat.com>
 <87r214aazb.fsf@vitty.brq.redhat.com>
Message-ID: <e1765768e2cd51f28211335e96fa3a31@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: vkuznets@redhat.com, gshan@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, paulus@ozlabs.org, jhogan@kernel.org, drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-12-16 09:14, Vitaly Kuznetsov wrote:
> Gavin Shan <gshan@redhat.com> writes:
>
>> On 12/13/19 8:47 PM, Marc Zyngier wrote:
>>> On 2019-12-13 00:50, Gavin Shan wrote:
>>>>
>>>> Yeah, I think it is ABI change unfortunately, but I'm not sure how
>>>> many applications are using this filter.
>>>
>>> Nobody can tell. The problem is that someone will write a script 
>>> that
>>> parses this trace point based on an older kernel release (such as
>>> what the distros are shipping today), and two years from now will
>>> shout at you (and me) for having broken their toy.
>>>
>>
>> Well, I would like to receive Vitaly's comments here. Vitaly, it 
>> seems it's
>> more realistic to fix the issue from kvm_stat side according to the 
>> comments
>> given by Marc?
>>
>
> Sure, if we decide to treat tracepoints as ABI then fixing users is
> likely the way to go. Personally, I think that we should have certain
> freedom with them and consider only tools which live in linux.git 
> when
> making changes (and changing the tool to match in the same patch 
> series
> is OK from this PoV, no need to support all possible versions of the
> tool).

So far, the approach has been a pretty conservative one, and there was
countless discussions (including a pretty heated one at KS two years 
ago,
see [1] which did set the tone for the whole of the discussion).

So as far as I have something to say about this, we're not renaming 
fields
in existing tracepoints.

> Also, we can be a bit more conservative and in this particular case
> instead of renaming fields just add 'exit_reason' to all 
> architectures
> where it's missing. For ARM, 'esr_ec' will then stay with what it is 
> and
> 'exit_reason' may contain something different (like the information 
> why
> the guest exited actually). But I don't know much about ARM specifics
> and I'm not sure how feasible the suggestion would be.

It should be possible to /extend/ tracepoints without breaking 
compatibility,
and I don't have any issue with that. This could either report the 
unmodified
'ret' value, or something more synthetic. It really depends on what you 
want
this information for.

         M.

[1] https://lwn.net/Articles/737532/
-- 
Jazz is not dead. It just smells funny...
