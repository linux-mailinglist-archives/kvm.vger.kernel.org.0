Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20C5784498
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 16:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbjHVOm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 10:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbjHVOm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 10:42:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9158C10B
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 07:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692715334;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fibOIifOIoCYjZF01dSrqWuwFTP4vh92xbvCgHNrUfI=;
        b=R10feiXqZ4lXbEM4A8TMX1hQ9Pi5lInzGjeT45bIkjvZ/KwLYHWj+Yag4vcM171EiMyXen
        oB8O18vGzoKR+Bxh1iza1hKKMn/rENmY77fGZmIv/DYDyN8AcMxTE//Ei73RjyjQtoWxgJ
        VHvihQgcSQujg0aeQc+jm7wUcOlSeto=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-x8Mv49SCOw2_F7ayOxTfzQ-1; Tue, 22 Aug 2023 10:42:11 -0400
X-MC-Unique: x8Mv49SCOw2_F7ayOxTfzQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B84E68D40D9;
        Tue, 22 Aug 2023 14:42:10 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDA314A9004;
        Tue, 22 Aug 2023 14:42:07 +0000 (UTC)
Date:   Tue, 22 Aug 2023 15:42:05 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 18/58] i386/tdx: Validate TD attributes
Message-ID: <ZOTJPUPtYnBMI0W9@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-19-xiaoyao.li@intel.com>
 <ZOMrd6f0URDYp/0r@redhat.com>
 <c1ad3974-876a-9d29-9a59-f54ae4f8b09e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1ad3974-876a-9d29-9a59-f54ae4f8b09e@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

On Tue, Aug 22, 2023 at 10:30:47PM +0800, Xiaoyao Li wrote:
> On 8/21/2023 5:16 PM, Daniel P. Berrangé wrote:
> > On Fri, Aug 18, 2023 at 05:50:01AM -0400, Xiaoyao Li wrote:
> > > Validate TD attributes with tdx_caps that fixed-0 bits must be zero and
> > > fixed-1 bits must be set.
> > > 
> > > Besides, sanity check the attribute bits that have not been supported by
> > > QEMU yet. e.g., debug bit, it will be allowed in the future when debug
> > > TD support lands in QEMU.
> > > 
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> > > ---
> > >   target/i386/kvm/tdx.c | 27 +++++++++++++++++++++++++--
> > >   1 file changed, 25 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> > > index 629abd267da8..73da15377ec3 100644
> > > --- a/target/i386/kvm/tdx.c
> > > +++ b/target/i386/kvm/tdx.c
> > > @@ -32,6 +32,7 @@
> > >                                        (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
> > >                                        (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
> > > +#define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
> > >   #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
> > >   #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
> > >   #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
> > > @@ -462,13 +463,32 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
> > >       return 0;
> > >   }
> > > -static void setup_td_guest_attributes(X86CPU *x86cpu)
> > > +static int tdx_validate_attributes(TdxGuest *tdx)
> > > +{
> > > +    if (((tdx->attributes & tdx_caps->attrs_fixed0) | tdx_caps->attrs_fixed1) !=
> > > +        tdx->attributes) {
> > > +            error_report("Invalid attributes 0x%lx for TDX VM (fixed0 0x%llx, fixed1 0x%llx)",
> > > +                          tdx->attributes, tdx_caps->attrs_fixed0, tdx_caps->attrs_fixed1);
> > > +            return -EINVAL;
> > > +    }
> > > +
> > > +    if (tdx->attributes & TDX_TD_ATTRIBUTES_DEBUG) {
> > > +        error_report("Current QEMU doesn't support attributes.debug[bit 0] for TDX VM");
> > > +        return -EINVAL;
> > > +    }
> > 
> > Use error_setg() in both cases, passing in a 'Error **errp' object,
> > and 'return -1' instead of returning an errno value.
> > 
> 
> why return -1 instead of -EINVAL?

Returning errno values is useful if the method isn't providing an
"Error **errp" parameter, because it lets the caller report a
more detailed error message via strerror(). Once you add a Error **
parameter though, there is almost never any reason for the caller
to care about the original errno value, and so we use 0 / -1 as
success/fail indicators.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

