Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF07B108C56
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfKYKzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:55:06 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:40554 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727278AbfKYKzF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Nov 2019 05:55:05 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iZC1G-0007GU-5V; Mon, 25 Nov 2019 11:55:02 +0100
To:     Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2] kvm: arm: VGIC: Fix interrupt group enablement
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 Nov 2019 10:55:01 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>
In-Reply-To: <20191122185142.65477-1-andre.przywara@arm.com>
References: <20191122185142.65477-1-andre.przywara@arm.com>
Message-ID: <e2426986ebc9be4e14eb99028b28a43e@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-11-22 18:51, Andre Przywara wrote:
> Hi Marc,
>
> this is still a bit rough, and only briefly tested, but I wanted to
> hear your opinion on the general approach (using a second list in
> addition to the ap_list). Some ugly bits come from the fact that the
> two lists are not that different, so we have to consider both of them
> at times. This is what I wanted to avoid with just one list that gets
> filtered on the fly.
> Or I am just stupid and don't see how it can be done properly ;-)

I don't know about that, but I think there is a better way.

You have essentially two sets of pending interrupts:

1) those that are enabled and group-enabled, that end up in the AP list
2) those that are either disabled and/or group-disabled

Today, (2) are not on any list. What I'm suggesting is that we create
a list for these interrupts that cannot be forwarded.

Then enabling an interrupt or a group is a matter of moving pending
interrupts from one list to another. And I think most of the logic
can be hidden in vgic_queue_irq_unlock().

         M.
-- 
Jazz is not dead. It just smells funny...
