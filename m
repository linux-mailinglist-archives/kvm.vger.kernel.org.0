Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A84F78C252
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 12:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbjH2K3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 06:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjH2K3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 06:29:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1F7F9
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 03:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693304898;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Ansp3Hjkbc6ROjIpMGRwpf5SEHqiAhx3ZomjWv7LQ8=;
        b=DCl3JfCGmuCSuqrut0z3D2ESwLUS8eo31WhJeAhxrHwFFAuXs15YBI9lAV90N5FGkGPg1N
        3TSXuzNuFwPXaxZ39hAclxsjJ0CE4QxpCOgclQ7SHPEDrQ+1YY7DJ/GleOeZsVu+jICoQE
        cZe13y1rZ5sFZtiT5pk8wZvHVqHloWY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-Hwj9SWYpNG62EPjel7razw-1; Tue, 29 Aug 2023 06:28:15 -0400
X-MC-Unique: Hwj9SWYpNG62EPjel7razw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3346585CBE7;
        Tue, 29 Aug 2023 10:28:14 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39DE8492C13;
        Tue, 29 Aug 2023 10:28:11 +0000 (UTC)
Date:   Tue, 29 Aug 2023 11:28:09 +0100
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
Subject: Re: [PATCH v2 47/58] i386/tdx: Wire REPORT_FATAL_ERROR with
 GuestPanic facility
Message-ID: <ZO3IOax8bF0NpgnU@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-48-xiaoyao.li@intel.com>
 <ZOM1Qk4wjNczWEf2@redhat.com>
 <00b88ec1-675c-9384-3a93-16b15e666126@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b88ec1-675c-9384-3a93-16b15e666126@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 28, 2023 at 09:14:41PM +0800, Xiaoyao Li wrote:
> On 8/21/2023 5:58 PM, Daniel P. Berrangé wrote:
> > On Fri, Aug 18, 2023 at 05:50:30AM -0400, Xiaoyao Li wrote:
> > > Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > ---
> > >   qapi/run-state.json   | 17 +++++++++++++--
> > >   softmmu/runstate.c    | 49 +++++++++++++++++++++++++++++++++++++++++++
> > >   target/i386/kvm/tdx.c | 24 ++++++++++++++++++++-
> > >   3 files changed, 87 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/qapi/run-state.json b/qapi/run-state.json
> > > index f216ba54ec4c..506bbe31541f 100644
> > > --- a/qapi/run-state.json
> > > +++ b/qapi/run-state.json
> > > @@ -499,7 +499,7 @@
> > >   # Since: 2.9
> > >   ##
> > >   { 'enum': 'GuestPanicInformationType',
> > > -  'data': [ 'hyper-v', 's390' ] }
> > > +  'data': [ 'hyper-v', 's390', 'tdx' ] }

> 
> > > +#
> > > +# Since: 8.2
> > > +##
> > > +{'struct': 'GuestPanicInformationTdx',
> > > + 'data': {'error-code': 'uint64',
> > > +          'gpa': 'uint64',
> > > +          'message': 'str'}}
> > > +
> > >   ##
> > >   # @MEMORY_FAILURE:
> > >   #
> > > diff --git a/softmmu/runstate.c b/softmmu/runstate.c
> > > index f3bd86281813..cab11484ed7e 100644
> > > --- a/softmmu/runstate.c
> > > +++ b/softmmu/runstate.c
> > > @@ -518,7 +518,56 @@ void qemu_system_guest_panicked(GuestPanicInformation *info)
> > >                             S390CrashReason_str(info->u.s390.reason),
> > >                             info->u.s390.psw_mask,
> > >                             info->u.s390.psw_addr);
> > > +        } else if (info->type == GUEST_PANIC_INFORMATION_TYPE_TDX) {
> > > +            char *buf = NULL;
> > > +            bool printable = false;
> > > +
> > > +            /*
> > > +             * Although message is defined as a json string, we shouldn't
> > > +             * unconditionally treat it as is because the guest generated it and
> > > +             * it's not necessarily trustable.
> > > +             */
> > > +            if (info->u.tdx.message) {
> > > +                /* The caller guarantees the NUL-terminated string. */
> > > +                int len = strlen(info->u.tdx.message);
> > > +                int i;
> > > +
> > > +                printable = len > 0;
> > > +                for (i = 0; i < len; i++) {
> > > +                    if (!(0x20 <= info->u.tdx.message[i] &&
> > > +                          info->u.tdx.message[i] <= 0x7e)) {
> > > +                        printable = false;
> > > +                        break;
> > > +                    }
> > > +                }
> > > +
> > > +                /* 3 = length of "%02x " */
> > > +                buf = g_malloc(len * 3);
> > > +                for (i = 0; i < len; i++) {
> > > +                    if (info->u.tdx.message[i] == '\0') {
> > > +                        break;
> > > +                    } else {
> > > +                        sprintf(buf + 3 * i, "%02x ", info->u.tdx.message[i]);
> > > +                    }
> > > +                }
> > > +                if (i > 0)
> > > +                    /* replace the last ' '(space) to NUL */
> > > +                    buf[i * 3 - 1] = '\0';
> > > +                else
> > > +                    buf[0] = '\0';
> > 
> > You're building this escaped buffer but...
> > 
> > > +            }
> > > +
> > > +            qemu_log_mask(LOG_GUEST_ERROR,
> > > +                          //" TDX report fatal error:\"%s\" %s",
> > > +                          " TDX report fatal error:\"%s\""
> > > +                          "error: 0x%016" PRIx64 " gpa page: 0x%016" PRIx64 "\n",
> > > +                          printable ? info->u.tdx.message : "",
> > > +                          //buf ? buf : "",
> > 
> > ...then not actually using it
> > 
> > Either delete the 'buf' code, or use it.
> 
> Sorry for posting some internal testing version.
> Does below look good to you?
> 
> @@ -518,7 +518,56 @@ void qemu_system_guest_panicked(GuestPanicInformation
> *info)
>                            S390CrashReason_str(info->u.s390.reason),
>                            info->u.s390.psw_mask,
>                            info->u.s390.psw_addr);
> +        } else if (info->type == GUEST_PANIC_INFORMATION_TYPE_TDX) {
> +            bool printable = false;
> +            char *buf = NULL;
> +            int len = 0, i;
> +
> +            /*
> +             * Although message is defined as a json string, we shouldn't
> +             * unconditionally treat it as is because the guest generated
> it and
> +             * it's not necessarily trustable.
> +             */
> +            if (info->u.tdx.message) {
> +                /* The caller guarantees the NUL-terminated string. */
> +                len = strlen(info->u.tdx.message);
> +
> +                printable = len > 0;
> +                for (i = 0; i < len; i++) {
> +                    if (!(0x20 <= info->u.tdx.message[i] &&
> +                          info->u.tdx.message[i] <= 0x7e)) {
> +                        printable = false;
> +                        break;
> +                    }
> +                }
> +            }
> +
> +            if (!printable && len) {
> +                /* 3 = length of "%02x " */
> +                buf = g_malloc(len * 3);
> +                for (i = 0; i < len; i++) {
> +                    if (info->u.tdx.message[i] == '\0') {
> +                        break;
> +                    } else {
> +                        sprintf(buf + 3 * i, "%02x ",
> info->u.tdx.message[i]);
> +                    }
> +                }
> +                if (i > 0)
> +                    /* replace the last ' '(space) to NUL */
> +                    buf[i * 3 - 1] = '\0';
> +                else
> +                    buf[0] = '\0';
> +            }
> +
> +            qemu_log_mask(LOG_GUEST_ERROR,
> +                          " TDX guest reports fatal error:\"%s\""
> +                          " error code: 0x%016" PRIx64 " gpa page: 0x%016"
> PRIx64 "\n",
> +                          printable ? info->u.tdx.message : buf,
> +                          info->u.tdx.error_code,
> +                          info->u.tdx.gpa);
> +            g_free(buf);
>          }


Ok that makes more sense now. BTW, probably a nice idea to create a
separate helper method that santizes the guest provided JSON into
the safe 'buf' string.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

