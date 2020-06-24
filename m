Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177A0206D45
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 09:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389430AbgFXHHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 03:07:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389349AbgFXHHJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jun 2020 03:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592982428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vuoo9Wk/qRlj5IesQ7i9MM7vgq2ZkA6l9+chYSUsDoU=;
        b=K22e0jNMwAdaBbY4YokC3eZShbX1md+RaPddvYPBfP7BjRTQHlW0FYGnRvUkOe3LwDiqlD
        ZXRnE2dt9znyywCQMkakkZWiGJv60FuRiEjlfi2m9o04+QsRVG3dh7iKMGgS8U9Xi5hg2y
        gEHXwydKPLu+i9UCEzAdDbiW4e4AUUg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-ZV4iU5pCMhaB_Q7W4Oka8w-1; Wed, 24 Jun 2020 03:07:04 -0400
X-MC-Unique: ZV4iU5pCMhaB_Q7W4Oka8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96B22800C60;
        Wed, 24 Jun 2020 07:07:01 +0000 (UTC)
Received: from gondolin (ovpn-113-3.ams2.redhat.com [10.36.113.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1654A100238C;
        Wed, 24 Jun 2020 07:06:50 +0000 (UTC)
Date:   Wed, 24 Jun 2020 09:06:48 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        pasic@linux.ibm.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200624090648.6bdf82bd.cohuck@redhat.com>
In-Reply-To: <2fa7c84a-6929-ef04-1d61-f76a4cac35f5@de.ibm.com>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
        <2fa7c84a-6929-ef04-1d61-f76a4cac35f5@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Jun 2020 16:27:28 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 19.06.20 04:05, David Gibson wrote:
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> > 
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.
> > 
> > The current code (committed or draft) for these features has each
> > platform's version configured entirely differently.  That doesn't seem
> > ideal for users, or particularly for management layers.
> > 
> > AMD SEV introduces a notionally generic machine option
> > "machine-encryption", but it doesn't actually cover any cases other
> > than SEV.
> > 
> > This series is a proposal to at least partially unify configuration
> > for these mechanisms, by renaming and generalizing AMD's
> > "memory-encryption" property.  It is replaced by a
> > "host-trust-limitation" property pointing to a platform specific
> > object which configures and manages the specific details.
> > 
> > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > can be extended to cover the Intel and s390 mechanisms as well,
> > though.  
> 
> Let me try to summarize what I understand what you try to achieve:
> one command line parameter for all platforms that 
> 
> common across all platforms:
> - disable KSM
> - by default enables iommu_platform
> 
> 
> per platform:
> - setup the necessary encryption scheme when appropriate
> - block migration
> -....
> 
> 
> The tricky part is certainly the per platform thing. For example on
> s390 we just have a cpumodel flag that provides interfaces to the guest
> to switch into protected mode via the ultravisor. This works perfectly
> fine with the host model, so no need to configure anything.  The platform
> code then disables KSM _on_switchover_ and not in general. Because the 
> guest CAN switch into protected, but it does not have to.
> 
> So this feels really hard to do right. Would a virtual BoF on KVM forum
> be too late? We had a BoF on protected guests last year and that was
> valuable.

Maybe we can do some kind of call to discuss this earlier? (Maybe in
the KVM call slot on Tuesdays?) I think it would be really helpful if
everybody would have at least a general understanding about how
encryption/protection works on the different architectures.

