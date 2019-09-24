Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002B1BC19A
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 08:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438657AbfIXGLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 02:11:23 -0400
Received: from ozlabs.org ([203.11.71.1]:52737 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388254AbfIXGLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 02:11:23 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46crRY3Lxhz9sPJ; Tue, 24 Sep 2019 16:11:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1569305481; bh=+d6v8WYT+viMPFD2AWLGwcmMQ+4R+NXR5ZEghf3P1oQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aU6IZvHX7peJwFrvLpLb4d4Rq7NOx4C3Xfu5QMsFWUDXrPDzRxrR2xjsTGADYl0K8
         MnaReMA1X0jD+ZyOKngJg4BXWfuS9k9w4+9nkxdM2Pt3RHPfUA4lcYGSF60z1z1m0o
         4QKFtHjQb0zy/Uxqd89j9jTTobsIJqBO6c/uGSw7JNk2fjpdhUpHYSD/U1nbhJQri7
         406r/sWU8/2YHhrmPYydnf8amrpG2UAy97Kv6LDfF7bBUe816SOdsb4IfXlQPaLHcS
         pWYOEgJmja/x5psdPesNoZc59khZeuGEfvnwJ1y4C1utFwgVNWNCrmlbav5P6etkxB
         ppyMrfzVUWFYQ==
Date:   Tue, 24 Sep 2019 15:33:28 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Greg Kurz <groug@kaod.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/6] KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already
 in use
Message-ID: <20190924053328.GB7950@oak.ozlabs.ibm.com>
References: <156925341155.974393.11681611197111945710.stgit@bahia.lan>
 <156925342885.974393.4930571278578115883.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156925342885.974393.4930571278578115883.stgit@bahia.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 05:43:48PM +0200, Greg Kurz wrote:
> We currently prevent userspace to connect a new vCPU if we already have
> one with the same vCPU id. This is good but unfortunately not enough,
> because VP ids derive from the packed vCPU ids, and kvmppc_pack_vcpu_id()
> can return colliding values. For examples, 348 stays unchanged since it
> is < KVM_MAX_VCPUS, but it is also the packed value of 2392 when the
> guest's core stride is 8. Nothing currently prevents userspace to connect
> vCPUs with forged ids, that end up being associated to the same VP. This
> confuses the irq layer and likely crashes the kernel:
> 
> [96631.670454] genirq: Flags mismatch irq 4161. 00010000 (kvm-1-2392) vs. 00010000 (kvm-1-348)

Have you seen a host kernel crash?  How hard would it be to exploit
this, and would it just be a denial of service, or do you think it
could be used to get a use-after-free in the kernel or something like
that?

Also, does this patch depend on the patch 2 in this series?

Paul.
