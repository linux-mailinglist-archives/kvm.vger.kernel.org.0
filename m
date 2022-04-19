Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697C05075F1
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 19:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344483AbiDSRHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 13:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355708AbiDSRGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 13:06:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4482FD2A
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 10:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650387606;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=CPh3w3hKI2YNhFyyQIqNZY395zB4wSTp9TpWnENHY40=;
        b=bs4zRTY9zL2nEnOsg42459PQOnjJ2kKG+Noad1369TmhkhUO4WMC8rOemxRP6/Yp892xtv
        1AT/9tFM+a5SOu2MlU5CtBnx0KlWWye9tHZ8LHTuptD8/eyDy4YLFhJfYfYXNjZN0ca3ZV
        IX+WXCq1I3o+CVC6Ya4rqMJvtRYS/Qg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-zaQqgLs1NkyOICYDuudO3g-1; Tue, 19 Apr 2022 13:00:04 -0400
X-MC-Unique: zaQqgLs1NkyOICYDuudO3g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67C093801FF5;
        Tue, 19 Apr 2022 17:00:04 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91B95C53527;
        Tue, 19 Apr 2022 17:00:00 +0000 (UTC)
Date:   Tue, 19 Apr 2022 17:59:55 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Cole Robinson <crobinso@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: adding 'official' way to dump SEV VMSA
Message-ID: <Yl7qiySOgljonWSR@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <a713533d-c4c5-2237-58d0-57b812a56ba4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a713533d-c4c5-2237-58d0-57b812a56ba4@redhat.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022 at 09:36:23AM -0400, Cole Robinson wrote:
> Hi all,
> 
> SEV-ES and SEV-SNP attestation require a copy of the initial VMSA to
> validate the launch measurement. For developers dipping their toe into
> SEV-* work, the easiest way to get sample VMSA data for their machine is
> to grab it from a running VM.
> 
> There's two techniques I've seen for that: patch some printing into
> kernel __sev_launch_update_vmsa, or use systemtap like danpb's script
> here: https://gitlab.com/berrange/libvirt/-/blob/lgtm/scripts/sev-vmsa.stp
> 
> Seems like this could be friendlier though. I'd like to work on this if
> others agree.
> 
> Some ideas I've seen mentioned in passing:
> 
> - debugfs entry in /sys/kernel/debug/kvm/.../vcpuX/
> - new KVM ioctl
> - something with tracepoints
> - some kind of dump in dmesg that doesn't require a patch

The problem with all the approaches of dumping / extracting a VMSA
is that the VMSA contains a register whose value contains CPU model,
family, stepping. IOW, over time there are large number of possible
valid VMSA blobs, one for each possible CPU variant that is relevant
to SEV.

Given that, I came to the conclusion that dumping / extracting a VMSA
is only useful for the purpose of debugging. We should still have such
a mechanism, but it isn't sufficient on its own.

For actual launch measurement validation, we need to be able to
construct an expected VMSA from technical specs & knowledge of QEMU's
SEV impl, such that we can plug in variable field values.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

