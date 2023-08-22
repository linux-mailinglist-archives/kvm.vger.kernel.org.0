Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74B8783BB3
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 10:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbjHVIZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 04:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbjHVIZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 04:25:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93BD12C
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 01:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692692674;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=G+UhjRSc4uGDnZt8D24zxuBh56uHAwZ4HjsOGQ/jcLg=;
        b=QB5yJhRvUrdF55uLS+XuF8G8tcW0jUIvxfqahsNhAB6ni1y9Vqh/P6feLXK0cfYXxRB8OR
        ax91fsQI3ZGjbI+pYwCfByw2nAI8rHyVCYxJlq8XFRTxLXKBkVBTRnLoWqxPP+CxV2K+is
        Dl+y/44pXhTFy8VJBHI3qmK80xL4HvI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-kqubxfVbPCa-bIBqxx9-4Q-1; Tue, 22 Aug 2023 04:24:32 -0400
X-MC-Unique: kqubxfVbPCa-bIBqxx9-4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5539101A528;
        Tue, 22 Aug 2023 08:24:31 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A0C640C6F4C;
        Tue, 22 Aug 2023 08:24:23 +0000 (UTC)
Date:   Tue, 22 Aug 2023 09:24:19 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 41/58] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <ZORws2GWRwIGAaJE@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-42-xiaoyao.li@intel.com>
 <87wmxn6029.fsf@pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87wmxn6029.fsf@pond.sub.org>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 22, 2023 at 08:52:30AM +0200, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > For GetQuote, delegate a request to Quote Generation Service.  Add property
> > of address of quote generation server and On request, connect to the
> > server, read request buffer from shared guest memory, send the request
> > buffer to the server and store the response into shared guest memory and
> > notify TD guest by interrupt.
> >
> > "quote-generation-service" is a property to specify Quote Generation
> > Service(QGS) in qemu socket address format.  The examples of the supported
> > format are "vsock:2:1234", "unix:/run/qgs", "localhost:1234".
> >
> > command line example:
> >   qemu-system-x86_64 \
> >     -object 'tdx-guest,id=tdx0,quote-generation-service=localhost:1234' \
> >     -machine confidential-guest-support=tdx0
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > ---
> >  qapi/qom.json         |   5 +-
> >  target/i386/kvm/tdx.c | 380 ++++++++++++++++++++++++++++++++++++++++++
> >  target/i386/kvm/tdx.h |   7 +
> >  3 files changed, 391 insertions(+), 1 deletion(-)
> >
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index 87c1d440f331..37139949d761 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -879,13 +879,16 @@
> >  #
> >  # @mrownerconfig: MROWNERCONFIG SHA384 hex string of 48 * 2 length (default: 0)
> >  #
> > +# @quote-generation-service: socket address for Quote Generation Service(QGS)
> > +#
> >  # Since: 8.2
> >  ##
> >  { 'struct': 'TdxGuestProperties',
> >    'data': { '*sept-ve-disable': 'bool',
> >              '*mrconfigid': 'str',
> >              '*mrowner': 'str',
> > -            '*mrownerconfig': 'str' } }
> > +            '*mrownerconfig': 'str',
> > +            '*quote-generation-service': 'str' } }
> 
> Why not type SocketAddress?

Yes, the code uses SocketAddress internally when it eventually
calls qio_channel_socket_connect_async(), so we should directly
use SocketAddress in the QAPI from the start.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

