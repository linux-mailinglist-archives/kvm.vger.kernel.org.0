Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD17C18C9FD
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 10:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgCTJRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 05:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgCTJRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 05:17:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18EB320739;
        Fri, 20 Mar 2020 09:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584695852;
        bh=zsT/U58gg36/Uj1CBfv4DlLvkJ01kHhfUVbHRubrzTo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y6AVOYnW9tiHmtVZ9MVy83Nhq+E8DkwcAnBBy0JfLhTHNp9Ltl+RsgKfnhEwRb9WG
         X12/cWpMptvQNyfIzoKAdWWwgJ5NwIdFBabRJFSGMvy+EPreSyCHzQkslphTWNmKY0
         Ki/zXZ7G5LUWyWnYhBDLDwMUkgwkZj1PTMqfDLHI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFDmU-00EC7b-9Z; Fri, 20 Mar 2020 09:17:30 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Mar 2020 09:17:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@marvell.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 19/23] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
In-Reply-To: <9fb8c267-5483-f260-6e37-5e8734b38928@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-20-maz@kernel.org>
 <8a6cf87a-7eee-5502-3b54-093ea0ab5e2d@redhat.com>
 <877ba4711c6b9456314ea580b9c4718c@kernel.org>
 <9fb8c267-5483-f260-6e37-5e8734b38928@redhat.com>
Message-ID: <46802b9895a72c374b86399ca008b89a@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, kvm@vger.kernel.org, suzuki.poulose@arm.com, linux-kernel@vger.kernel.org, rrichter@marvell.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, yuzenghui@huawei.com, tglx@linutronix.de, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020-03-19 20:13, Auger Eric wrote:
> Hi Marc,
> 
> On 3/19/20 8:52 PM, Marc Zyngier wrote:
>> The assumption here is that we're coming vgic_v4_configure_vsgis(),
>> which starts
>> by stopping the whole guest. My guess is that it should be safe 
>> enough, but
>> maybe you are thinking of something else?
> I don't have a specific case in mind. Just preferred asking to make
> sure. Usually when touching those fields we take the lock (that's also
> the case in vgic_debug_show for instance).

Ah, good thing you mention the debug interface. I think it is the only
thing that can run behind our back... Fair enough, I'll add the locking.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
