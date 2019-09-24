Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA80BC165
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 07:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407865AbfIXF3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 01:29:05 -0400
Received: from ozlabs.org ([203.11.71.1]:42677 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405894AbfIXF3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 01:29:05 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46cqVk6xkmz9sPD; Tue, 24 Sep 2019 15:29:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1569302942; bh=cWBrw3Zi/RPCvFYg3Lc2bR5LpJV2EEerbQDk5nDnjws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lsHOd319ouBslKv0bWFJtvzzImr1S6O0NLCnWmG+GyWfg2pTck+2Y3NuS4E0CVwlP
         kXnqT54F182pmLGxgIx4KytqAGY9jUNTPe5EzqWqmxnSyNHHTM9AsFCIZLbpP9A2Of
         BaoUHhbor8++OsLNA3sKLw8wlXZ/DUSlSPUKsl0BUauUVKt3pXiXEgG4E/sLU64La1
         7gMYQXc2E7YBc8pw86aNwenMwogFvwLRNtjp82e7bc6jd+ViH2ATx6e1JljlZWZbMY
         Rh9TJ1f7sqd+kU3mxQCJzKBjqXHnZDUTJSUMVDTCdEU4uNIvNnbyi07wdFgtVVGxcS
         OUTB74fxWWagQ==
Date:   Tue, 24 Sep 2019 15:28:55 +1000
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
Subject: Re: [PATCH 1/6] KVM: PPC: Book3S HV: XIVE: initialize private
 pointer when VPs are allocated
Message-ID: <20190924052855.GA7950@oak.ozlabs.ibm.com>
References: <156925341155.974393.11681611197111945710.stgit@bahia.lan>
 <156925341736.974393.18379970954169086891.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <156925341736.974393.18379970954169086891.stgit@bahia.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 05:43:37PM +0200, Greg Kurz wrote:
> From: Cédric Le Goater <clg@kaod.org>
> 
> Do not assign the device private pointer before making sure the XIVE
> VPs are allocated in OPAL and test pointer validity when releasing
> the device.
> 
> Fixes: 5422e95103cf ("KVM: PPC: Book3S HV: XIVE: Replace the 'destroy' method by a 'release' method")
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> Signed-off-by: Greg Kurz <groug@kaod.org>

What happens in the case where the OPAL allocation fails?  Does the
host crash, or hang, or leak resources?  I presume that users can
trigger the allocation failure just by starting a suitably large
number of guests - is that right?  Is there an easier way?  I'm trying
to work out whether this is urgently needed in 5.4 and the stable
trees or not.

Paul.
