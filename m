Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CD63254ED
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 18:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhBYRzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 12:55:01 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:45900 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230459AbhBYRyM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 12:54:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 91A011280420;
        Thu, 25 Feb 2021 09:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1614275607;
        bh=9ED/xEUPHnxMMI/+cLRr2qpX8Y0fccwW3J6zaIUl+wI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:From;
        b=MGgD9OeYTSD/mN1Vup6+lAyzi7dyOP46XlfuEnXOsQI6uvuWya46DblDLfIoE3aLC
         ns/iecYTNAZx690gUiKUI5ZsgheNieLuIobhwwhPCU0hOmIRACKbvSZvqtyhuNw3DE
         q89/huI4uswV5kxxT+hzXG+6FqOPO7Sh70sXrJ6g=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6IDE53itTMSn; Thu, 25 Feb 2021 09:53:27 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id CAB2B12803F7;
        Thu, 25 Feb 2021 09:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1614275607;
        bh=9ED/xEUPHnxMMI/+cLRr2qpX8Y0fccwW3J6zaIUl+wI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:From;
        b=MGgD9OeYTSD/mN1Vup6+lAyzi7dyOP46XlfuEnXOsQI6uvuWya46DblDLfIoE3aLC
         ns/iecYTNAZx690gUiKUI5ZsgheNieLuIobhwwhPCU0hOmIRACKbvSZvqtyhuNw3DE
         q89/huI4uswV5kxxT+hzXG+6FqOPO7Sh70sXrJ6g=
Message-ID: <7cb132ce522728f7689618832a65e31e37788201.camel@HansenPartnership.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     natet@google.com
Cc:     Ashish.Kalra@amd.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rientjes@google.com, seanjc@google.com, srutherford@google.com,
        thomas.lendacky@amd.com, x86@kernel.org,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        DOV MURIK <Dov.Murik1@il.ibm.com>
Date:   Thu, 25 Feb 2021 09:53:26 -0800
In-Reply-To: <20210224085915.28751-1-natet@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Add a capability for userspace to mirror SEV encryption context from
> one vm to another. On our side, this is intended to support a
> Migration Helper vCPU, but it can also be used generically to support
> other in-guest workloads scheduled by the host. The intention is for
> the primary guest and the mirror to have nearly identical memslots.

So this causes a cloned VM that you can boot up another CPU into but
the boot path must have been already present?  In essence we've already
been thinking about something like this to get migration running inside
OVMF:

https://lore.kernel.org/qemu-devel/8b824c44-6a51-c3a7-6596-921dc47fea39@linux.ibm.com/

It sounds like this mechanism can be used to boot a vCPU through a
mirror VM after the fact, which is very compatible with the above whose
mechanism is  simply to steal a VCPU to hold in reset until it's
activated.  However, you haven't published how you activate the entity
inside the VM ... do you have patches for this so we can see the
internal capture mechanism and mirror VM boot path?

> The primary benefits of this are that:
> 1) The VMs do not share KVM contexts (think APIC/MSRs/etc), so they
> can't accidentally clobber each other.
> 2) The VMs can have different memory-views, which is necessary for
> post-copy migration (the migration vCPUs on the target need to read
> and write to pages, when the primary guest would VMEXIT).
> 
> This does not change the threat model for AMD SEV. Any memory
> involved is still owned by the primary guest and its initial state is
> still attested to through the normal SEV_LAUNCH_* flows. If userspace
> wanted to circumvent SEV, they could achieve the same effect by
> simply attaching a vCPU to the primary VM.
> This patch deliberately leaves userspace in charge of the memslots
> for the mirror, as it already has the power to mess with them in the
> primary guest.

Well it does alter the threat model in that previously the
configuration, including the CPU configuration, was fixed after launch
and attestation.  Now the CSP can alter the configuration via a mirror.
I'm not sure I have a threat for this, but it definitely alters the
model.

> This patch does not support SEV-ES (much less SNP), as it does not
> handle handing off attested VMSAs to the mirror.

One of the reasons for doing the sequestered vcpu is that -ES and -SNP
require the initial CPU state to be part of the attestation, so with
them you can't add CPU state after the fact.  I think you could use
this model if you declare the vCPU in the mirror in the initial
attested VMSA, but that's conjecture at this stage.

> For additional context, we need a Migration Helper because SEV PSP
> migration is far too slow for our live migration on its own. Using an
> in-guest migrator lets us speed this up significantly.

We have the same problem here at IBM, hence the RFC referred to above.

James


