Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA822A4BE0
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 17:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgKCQsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 11:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgKCQsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 11:48:19 -0500
X-Greylist: delayed 543 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Nov 2020 08:48:19 PST
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B18EC0613D1;
        Tue,  3 Nov 2020 08:48:19 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C69BA128003B;
        Tue,  3 Nov 2020 08:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604421554;
        bh=HGUTyhqFV7T0x144FbiJ+dIW4PRgOPfbbL2emrIeZSI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=JV5wydhVcXN14b9so+1nEsuOqf/5654vfvCb3lKpcdvyNBGgNCjRZKR10SdqBr0zJ
         ZWHyYISVZXNaOIX7U/vHlBX3vhZn1ppqUUUAemdXH7gs1LjXrGnB4mcr1mhjCIX2BQ
         xIdn8A920w3BZhKsFhf9SsMnD1NHOkCYO8XZe3os=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q32PP5ReTDhX; Tue,  3 Nov 2020 08:39:14 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 9FFF5128002F;
        Tue,  3 Nov 2020 08:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604421554;
        bh=HGUTyhqFV7T0x144FbiJ+dIW4PRgOPfbbL2emrIeZSI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=JV5wydhVcXN14b9so+1nEsuOqf/5654vfvCb3lKpcdvyNBGgNCjRZKR10SdqBr0zJ
         ZWHyYISVZXNaOIX7U/vHlBX3vhZn1ppqUUUAemdXH7gs1LjXrGnB4mcr1mhjCIX2BQ
         xIdn8A920w3BZhKsFhf9SsMnD1NHOkCYO8XZe3os=
Message-ID: <c0ee04a93a8d679f5e9ee7eea6467b32bb7063d6.camel@HansenPartnership.com>
Subject: Re: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com,
        pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com,
        joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dionna Glaze <dionnaglaze@google.com>,
        Erdem Aktas <erdemaktas@google.com>
Date:   Tue, 03 Nov 2020 08:39:12 -0800
In-Reply-To: <20200922012227.GA26483@linux.intel.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
         <20200922004024.3699923-2-vipinsh@google.com>
         <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
         <20200922012227.GA26483@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-09-21 at 18:22 -0700, Sean Christopherson wrote:
> On Mon, Sep 21, 2020 at 06:04:04PM -0700, Randy Dunlap wrote:
> > Hi,
> > 
> > On 9/21/20 5:40 PM, Vipin Sharma wrote:
> > > diff --git a/init/Kconfig b/init/Kconfig
> > > index d6a0b31b13dc..1a57c362b803 100644
> > > --- a/init/Kconfig
> > > +++ b/init/Kconfig
> > > @@ -1101,6 +1101,20 @@ config CGROUP_BPF
> > >  	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path
> > > of
> > >  	  inet sockets.
> > >  
> > > +config CGROUP_SEV
> > > +	bool "SEV ASID controller"
> > > +	depends on KVM_AMD_SEV
> > > +	default n
> > > +	help
> > > +	  Provides a controller for AMD SEV ASIDs. This controller
> > > limits and
> > > +	  shows the total usage of SEV ASIDs used in encrypted VMs on
> > > AMD
> > > +	  processors. Whenever a new encrypted VM is created using SEV
> > > on an
> > > +	  AMD processor, this controller will check the current limit
> > > in the
> > > +	  cgroup to which the task belongs and will deny the SEV ASID
> > > if the
> > > +	  cgroup has already reached its limit.
> > > +
> > > +	  Say N if unsure.
> > 
> > Something here (either in the bool prompt string or the help text)
> > should let a reader know w.t.h. SEV means.
> > 
> > Without having to look in other places...
> 
> ASIDs too.  I'd also love to see more info in the docs and/or cover
> letter to explain why ASID management on SEV requires a cgroup.  I
> know what an ASID is, and have a decent idea of how KVM manages ASIDs
> for legacy VMs, but I know nothing about why ASIDs are limited for
> SEV and not legacy VMs.

Well, also, why would we only have a cgroup for ASIDs but not MSIDs?

For the reader at home a Space ID (SID) is simply a tag that can be
placed on a cache line to control things like flushing.  Intel and AMD
use MSIDs which are allocated per process to allow fast context
switching by flushing all the process pages using a flush by SID. 
ASIDs are also used by both Intel and AMD to control nested/extended
paging of virtual machines, so ASIDs are allocated per VM.  So far it's
universal.

AMD invented a mechanism for tying their memory encryption technology
to the ASID asserted on the memory bus, so now they can do encrypted
virtual machines since each VM is tagged by ASID which the memory
encryptor sees.  It is suspected that the forthcoming intel TDX
technology to encrypt VMs will operate in the same way as well.  This
isn't everything you have to do to get an encrypted VM, but it's a core
part of it.

The problem with SIDs (both A and M) is that they get crammed into
spare bits in the CPU (like the upper bits of %CR3 for MSID) so we
don't have enough of them to do a 1:1 mapping of MSID to process or
ASID to VM.  Thus we have to ration them somewhat, which is what I
assume this patch is about?

James


