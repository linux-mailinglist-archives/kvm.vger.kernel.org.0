Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7BC76B820
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 16:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbjHAO6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 10:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjHAO6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 10:58:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0263B122
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 07:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690901872;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=56ag8D23N3D5V0yxKxxXalTgQPrSfiJDhLX6VgqQOGE=;
        b=UdcNf6PtJ8gRp2pg7h/OKRLvBVCSAEelv+g2ZdyU+9zolTPAYYN/g1lveuqOD3vfQk0+Es
        v98LMDFaPxgA/Bnvanh2asVP/vJ+BhF7URI2r9VS/QmldH0bey+SKuSHW+twk2j6+QPhQl
        wl7VaDjzQozPEqvBbF2nFkDDQmomI+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-RoTO5reeNJaZMOmI1rknFQ-1; Tue, 01 Aug 2023 10:57:48 -0400
X-MC-Unique: RoTO5reeNJaZMOmI1rknFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D87FA881B26;
        Tue,  1 Aug 2023 14:57:46 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CDB540C2063;
        Tue,  1 Aug 2023 14:57:44 +0000 (UTC)
Date:   Tue, 1 Aug 2023 15:57:42 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 08/19] HostMem: Add private property to indicate to
 use kvm gmem
Message-ID: <ZMkdZkQipZUIUicN@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-9-xiaoyao.li@intel.com>
 <87o7js808y.fsf@pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87o7js808y.fsf@pond.sub.org>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 07:22:05PM +0200, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> [...]
> 
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index 7f92ea43e8e1..e0b2044e3d20 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -605,6 +605,9 @@
> >  # @reserve: if true, reserve swap space (or huge pages) if applicable
> >  #     (default: true) (since 6.1)
> >  #
> > +# @private: if true, use KVM gmem private memory
> > +#           (default: false) (since 8.1)
> > +#
> 
> Please format like
> 
>    # @private: if true, use KVM gmem private memory (default: false)
>    #     (since 8.1)

Also QEMU 8.1.0 is in freeze right now, so there's no chance
of these patches making 8.1.0. IOW, use "since 8.2" as the
next release you might achieve merge for.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

