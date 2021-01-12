Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9912F379B
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404611AbhALRtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 12:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731303AbhALRtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 12:49:17 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C2D23107;
        Tue, 12 Jan 2021 17:48:36 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kzNmU-0072aN-89; Tue, 12 Jan 2021 17:48:34 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 12 Jan 2021 17:48:34 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 8/9] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for
 userspace
In-Reply-To: <fe0a3415-0c7b-be13-6438-89e82fe4c281@arm.com>
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-9-eric.auger@redhat.com>
 <fe0a3415-0c7b-be13-6438-89e82fe4c281@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <1a06be3153927f1051fcbc87f0e52e98@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, eric.auger@redhat.com, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-12 17:28, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 12/12/20 6:50 PM, Eric Auger wrote:
>> Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
>> reporting of GICR_TYPER.Last for userspace") temporarily fixed
>> a bug identified when attempting to access the GICR_TYPER
>> register before the redistributor region setting but dropped
>> the support of the LAST bit. This patch restores its
>> support (if the redistributor region was set) while keeping the
>> code safe.
> 
> If I understand your patch correctly, it is possible for the 
> GICR_TYPER.Last bit
> to be transiently 1 if the register is accessed before all the 
> redistributors
> regions have been configured.
> 
> Arm IHI 0069F states that accesses to the GICR_TYPER register are RO. I 
> haven't
> found exactly what RO means (please point me to the definition if you 
> find it in
> the architecture!), but I assume it means read-only and I'm not sure 
> how correct
> (from an architectural point of view) it is for two subsequent reads of 
> this
> register to return different values. Maybe Marc can shed some light on 
> this.

RO = Read-Only indeed. Not sure that's documented anywhere in the 
architecture,
but this is enough of a well known acronym that even the ARM ARM doesn't 
feel
the need to invent a new definition for it.

As for your concern, I don't think it is a problem to return different 
values
if the HW has changed in between. This may need to be documented though.

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny...
