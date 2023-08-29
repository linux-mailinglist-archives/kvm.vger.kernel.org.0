Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948BD78C24F
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 12:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbjH2K0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 06:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjH2K0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 06:26:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7515ED8
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 03:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693304728;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Imf3oRto5d7iXBP5N0pbVoVSN8oKk5GrcXbKxL+4wY0=;
        b=fN2fK7tBCsMyS5AU4GsGb3mRYdf/FiMsPnwYhrv4O5bNYRGTh3oamL6vKVUzfHSrkuJh6S
        qBR7Csqx2g3Ceb4WX47PEheXJVIEE7XgRH/LPWlpupGzm5DZeSdGbWru+/i+5Q7qZui1ic
        +4NkYjmwXzzcLUcq24ojUX33cpF0zbE=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-1UpNLowdOQGIaPenz8jVTA-1; Tue, 29 Aug 2023 06:25:23 -0400
X-MC-Unique: 1UpNLowdOQGIaPenz8jVTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7886338025E8;
        Tue, 29 Aug 2023 10:25:22 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA8AD40C2070;
        Tue, 29 Aug 2023 10:25:19 +0000 (UTC)
Date:   Tue, 29 Aug 2023 11:25:17 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
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
        erdemaktas@google.com
Subject: Re: [PATCH v2 41/58] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <ZO3HjRp1pk5Qd51j@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-42-xiaoyao.li@intel.com>
 <87wmxn6029.fsf@pond.sub.org>
 <ZORws2GWRwIGAaJE@redhat.com>
 <d6fbacab-d7e4-9992-438d-a8cb58e179ae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6fbacab-d7e4-9992-438d-a8cb58e179ae@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023 at 01:31:37PM +0800, Chenyi Qiang wrote:
> 
> 
> On 8/22/2023 4:24 PM, Daniel P. Berrangé wrote:
> > On Tue, Aug 22, 2023 at 08:52:30AM +0200, Markus Armbruster wrote:
> >> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> >>
> >>> From: Isaku Yamahata <isaku.yamahata@intel.com>
> >>>
> >>> For GetQuote, delegate a request to Quote Generation Service.  Add property
> >>> of address of quote generation server and On request, connect to the
> >>> server, read request buffer from shared guest memory, send the request
> >>> buffer to the server and store the response into shared guest memory and
> >>> notify TD guest by interrupt.
> >>>
> >>> "quote-generation-service" is a property to specify Quote Generation
> >>> Service(QGS) in qemu socket address format.  The examples of the supported
> >>> format are "vsock:2:1234", "unix:/run/qgs", "localhost:1234".
> >>>
> >>> command line example:
> >>>   qemu-system-x86_64 \
> >>>     -object 'tdx-guest,id=tdx0,quote-generation-service=localhost:1234' \
> >>>     -machine confidential-guest-support=tdx0
> >>>
> >>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >>> ---
> >>>  qapi/qom.json         |   5 +-
> >>>  target/i386/kvm/tdx.c | 380 ++++++++++++++++++++++++++++++++++++++++++
> >>>  target/i386/kvm/tdx.h |   7 +
> >>>  3 files changed, 391 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/qapi/qom.json b/qapi/qom.json
> >>> index 87c1d440f331..37139949d761 100644
> >>> --- a/qapi/qom.json
> >>> +++ b/qapi/qom.json
> >>> @@ -879,13 +879,16 @@
> >>>  #
> >>>  # @mrownerconfig: MROWNERCONFIG SHA384 hex string of 48 * 2 length (default: 0)
> >>>  #
> >>> +# @quote-generation-service: socket address for Quote Generation Service(QGS)
> >>> +#
> >>>  # Since: 8.2
> >>>  ##
> >>>  { 'struct': 'TdxGuestProperties',
> >>>    'data': { '*sept-ve-disable': 'bool',
> >>>              '*mrconfigid': 'str',
> >>>              '*mrowner': 'str',
> >>> -            '*mrownerconfig': 'str' } }
> >>> +            '*mrownerconfig': 'str',
> >>> +            '*quote-generation-service': 'str' } }
> >>
> >> Why not type SocketAddress?
> > 
> > Yes, the code uses SocketAddress internally when it eventually
> > calls qio_channel_socket_connect_async(), so we should directly
> > use SocketAddress in the QAPI from the start.
> 
> Any benefit to directly use SocketAddress?

We don't want whatever code consumes the configuration to
do a second level of parsing to convert the 'str' value
into the 'SocketAddress' object it actually needs.

QEMU has a long history of having a second round of ad-hoc
parsing of configuration and we've found it to be a serious
maintenence burden. Thus we strive to have everything
represented in QAPI using the desired final type, and avoid
the second round of parsing.

> "quote-generation-service" here is optional, it seems not trivial to add
> and parse the SocketAddress type in QEMU command. After I change 'str'
> to 'SocketAddress' and specify the command like "-object
> tdx-guest,type=vsock,cid=2,port=1234...", it will report "invalid
> parameter cid".

The -object parameter supports JSON syntax for this reason

   -object '{"qom-type":"tdx-guest","quote-generation-service":{"type": "vsock", "cid":"2","port":"1234"}}'

libvirt will always use the JSON syntax for -object with a new enough
QEMU.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

