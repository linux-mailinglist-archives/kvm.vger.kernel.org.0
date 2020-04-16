Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400FD1AC099
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634719AbgDPMA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 08:00:57 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:51192 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2634832AbgDPMAs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 08:00:48 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id BD3642E147C;
        Thu, 16 Apr 2020 15:00:42 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id IpE4HdXFAY-0fMKexYY;
        Thu, 16 Apr 2020 15:00:42 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1587038442; bh=OPbvbs0rpfZc9Ltpaqr9ziZqO4I5EH8m8TIzMZ+0icA=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=aCQs92riaaa0+guQ10US9WR3ORgOv0PjgkeVjYu37kWHJN7HhHXBkjqvFwWMxdUuu
         qH1iK9sniy13iaqLKmIaMtFIZzCsVWJgPYVNyWC/aBUNl8FfCVszNhs2nCqWhTbKFw
         +vIKEJEHJL2mhXFkQAG8pCeOq1vQWTU2T5Xr+SFQ=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:7205::1:11])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 3Rt6THPRTv-0fWePLa0;
        Thu, 16 Apr 2020 15:00:41 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Thu, 16 Apr 2020 15:00:40 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200416120040.GA3745197@rvkaganb>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
References: <20200416083847.1776387-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416083847.1776387-1-arilou@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 11:38:46AM +0300, Jon Doron wrote:
> According to the TLFS:
> "A write to the end of message (EOM) register by the guest causes the
> hypervisor to scan the internal message buffer queue(s) associated with
> the virtual processor.
> 
> If a message buffer queue contains a queued message buffer, the hypervisor
> attempts to deliver the message.
> 
> Message delivery succeeds if the SIM page is enabled and the message slot
> corresponding to the SINTx is empty (that is, the message type in the
> header is set to HvMessageTypeNone).
> If a message is successfully delivered, its corresponding internal message
> buffer is dequeued and marked free.
> If the corresponding SINTx is not masked, an edge-triggered interrupt is
> delivered (that is, the corresponding bit in the IRR is set).
> 
> This register can be used by guests to poll for messages. It can also be
> used as a way to drain the message queue for a SINTx that has
> been disabled (that is, masked)."

Doesn't this work already?

> So basically this means that we need to exit on EOM so the hypervisor
> will have a chance to send all the pending messages regardless of the
> SCONTROL mechnaisim.

I might be misinterpreting the spec, but my understanding is that
SCONTROL {en,dis}ables the message queueing completely.  What the quoted
part means is that a write to EOM should trigger the message source to
push a new message into the slot, regardless of whether the SINT was
masked or not.

And this (I think, haven't tested) should already work.  The userspace
just keeps using the SINT route as it normally does, posting
notifications to the corresponding irqfd when posting a message, and
waiting on the resamplerfd for the message slot to become free.  If the
SINT is masked KVM will skip injecting the interrupt, that's it.

Roman.
