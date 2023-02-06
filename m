Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE3D68C085
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 15:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjBFOvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 09:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjBFOvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 09:51:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED05425E1C
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 06:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675695055;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7fP2miinui2Jt6d6tQALquvb388gwt/ufvkswo0l0I=;
        b=b4u8ikx0h2tT6TXRTDqQGXal26GRZd9ctJ2k2KGyPjyeRagbdKKR3VfSmJyCQHUYK2uEeQ
        RUM3nAIQXH5zW7jP46cELrVqf016qov0eKeML0AzsRkCGDHFKCn/VeBsKEkvDZWLcz0wsl
        XBJ92w9htG78ytQEf9UAWtX5O65vjMM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-24t3nkexP8aISjHQG-iYig-1; Mon, 06 Feb 2023 09:50:52 -0500
X-MC-Unique: 24t3nkexP8aISjHQG-iYig-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD362100F911;
        Mon,  6 Feb 2023 14:50:51 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15C31492C3C;
        Mon,  6 Feb 2023 14:50:47 +0000 (UTC)
Date:   Mon, 6 Feb 2023 14:50:45 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     armbru@redhat.com, Michael Roth <michael.roth@amd.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, clg@kaod.org
Subject: Re: [PATCH v15 09/11] machine: adding s390 topology to query-cpu-fast
Message-ID: <Y+ETxSadUGC/UJGY@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-10-pmorel@linux.ibm.com>
 <a7a235d5-4ded-b83d-dcb6-2cf81ad5f283@redhat.com>
 <Y+D3PH0EkUPshIMO@redhat.com>
 <e1828071-551a-b5cb-8da5-cea91f075548@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1828071-551a-b5cb-8da5-cea91f075548@redhat.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 02:09:57PM +0100, Thomas Huth wrote:
> On 06/02/2023 13.49, Daniel P. Berrangé wrote:
> > On Mon, Feb 06, 2023 at 01:41:44PM +0100, Thomas Huth wrote:
> > > On 01/02/2023 14.20, Pierre Morel wrote:
> > > > S390x provides two more topology containers above the sockets,
> > > > books and drawers.
> > > > 
> > > > Let's add these CPU attributes to the QAPI command query-cpu-fast.
> > > > 
> > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > ---
> > > >    qapi/machine.json          | 13 ++++++++++---
> > > >    hw/core/machine-qmp-cmds.c |  2 ++
> > > >    2 files changed, 12 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/qapi/machine.json b/qapi/machine.json
> > > > index 3036117059..e36c39e258 100644
> > > > --- a/qapi/machine.json
> > > > +++ b/qapi/machine.json
> > > > @@ -53,11 +53,18 @@
> > > >    #
> > > >    # Additional information about a virtual S390 CPU
> > > >    #
> > > > -# @cpu-state: the virtual CPU's state
> > > > +# @cpu-state: the virtual CPU's state (since 2.12)
> > > > +# @dedicated: the virtual CPU's dedication (since 8.0)
> > > > +# @polarity: the virtual CPU's polarity (since 8.0)
> > > >    #
> > > >    # Since: 2.12
> > > >    ##
> > > > -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
> > > > +{ 'struct': 'CpuInfoS390',
> > > > +    'data': { 'cpu-state': 'CpuS390State',
> > > > +              'dedicated': 'bool',
> > > > +              'polarity': 'int'
> > > 
> > > I think it would also be better to mark the new fields as optional and only
> > > return them if the guest has the topology enabled, to avoid confusing
> > > clients that were written before this change.
> > 
> > FWIW, I would say that the general expectation of QMP clients is that
> > they must *always* expect new fields to appear in dicts that are
> > returned in QMP replies. We add new fields at will on a frequent basis.
> 
> Did we change our policy here? I slightly remember I've been told
> differently in the past ... but I can't recall where this was, it's
> certainly been a while.
> 
> So a question to the QAPI maintainers: What's the preferred handling for new
> fields nowadays in such situations?

I think you're mixing it up with policy for adding new fields to *input*
parameters. You can't add a new mandatory field to input params of a
command because no existing client will be sending that. Only optional
params are viable, without a deprecation cycle. For output parameters
such as this case, there's no compatibilty problem.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

