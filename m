Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABAE6A83AF
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 14:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCBNkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 08:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjCBNkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 08:40:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8E43B64C
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 05:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677764368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8UnfSbMYNNgzoZGawsXpWGkv+4jmC6nkFsLTYDbxsTI=;
        b=JPCVteBBveJAFKPUxSYUIR65N7ucVurpCC6W9/2BOMwr0nH1n2cE5fq9dCxWr4Wq55bmEq
        6mmvNHdmKtJMXe5VscaCMUY2tO0PdKnceZCoCZ4MHI7NjjqzuFaNHMJV2Fn/Q6goxDnimj
        ikbAANnRz7/2sysEKUDoIjKULzaOzOs=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-501-zIcdtO-aMoWpttjH99ticw-1; Thu, 02 Mar 2023 08:39:27 -0500
X-MC-Unique: zIcdtO-aMoWpttjH99ticw-1
Received: by mail-pj1-f71.google.com with SMTP id ls3-20020a17090b350300b0023a55f445ebso361121pjb.6
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 05:39:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8UnfSbMYNNgzoZGawsXpWGkv+4jmC6nkFsLTYDbxsTI=;
        b=Fdma0U+5hOe+vTCKfYcrW13gJKlpK/kb1Q0X4AaqIV9l1YlPLQSpmjL+IruC/zjrDh
         npcRxS3Qfty6YL4i/bsjDoLWqmwN6soZ2V4ZpQRUfuEy4iJTkmOadmX7ageM08i9D01v
         E/hbrWtthb4TDyvMfNYhP2fL6mH6SnrfdHUtBVaIf7itbKQ4vZhv+kqsU8TruKeIEBQd
         JYw8NaI91zfqubT3Hz9ujwodGiONB7rD7kfCdLWR/OJt95t6oFVTHUPQZxPlLWiWz3Aj
         7vM+gMh0ZhsR1LIZ8gcCBnsnHaHGiE9OvxqpmspNXs/J8BJbl6tW66xyPfixVUnyaGvd
         t9Pg==
X-Gm-Message-State: AO0yUKVFPjsOQlQYSaPhThb9IDNCsvBcxV0G2F3GXqC8rbg+nJXhtWIA
        ei2bBvBDViMNKVNT0y82Vv5gFp+qjIhAsuvt8ia4mSn5TV9iSOFPDHpR34qKU+Q+6SLdSYYICwI
        bF53q1wxZxzZnjls8mlGn0uWPeoyB
X-Received: by 2002:a62:8281:0:b0:5df:9809:6220 with SMTP id w123-20020a628281000000b005df98096220mr4033079pfd.3.1677764366151;
        Thu, 02 Mar 2023 05:39:26 -0800 (PST)
X-Google-Smtp-Source: AK7set+a/fgG1sDJY0Wg8HtsQNqmWTjIiDBcdwXGiUihFqPgAS6qxO7QGc+qdB4z1VCvahkPJUDsTDuwl9pcbHRIcSE=
X-Received: by 2002:a62:8281:0:b0:5df:9809:6220 with SMTP id
 w123-20020a628281000000b005df98096220mr4033067pfd.3.1677764365873; Thu, 02
 Mar 2023 05:39:25 -0800 (PST)
Received: from 744723338238 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 2 Mar 2023 05:39:25 -0800
From:   Andrea Bolognani <abologna@redhat.com>
References: <20230228150216.77912-1-cohuck@redhat.com> <20230228150216.77912-2-cohuck@redhat.com>
 <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
 <874jr4dbcr.fsf@redhat.com> <CABJz62MQH2U1QM26PcC3F1cy7t=53_mxkgViLKjcUMVmi29w+Q@mail.gmail.com>
 <87sfeoblsa.fsf@redhat.com> <CABJz62PbzFMB3ifg7OvTXe34TS5b3xDHJk8XGs-inA5t5UEAtA@mail.gmail.com>
 <87fsanmgi9.fsf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <87fsanmgi9.fsf@redhat.com>
Date:   Thu, 2 Mar 2023 05:39:25 -0800
Message-ID: <CABJz62OMj+ahAKWcyd5xKFnQ9g2ODoKyi2AvAtxe_bYWLXKUOQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 02, 2023 at 02:26:06PM +0100, Cornelia Huck wrote:
> On Wed, Mar 01 2023, Andrea Bolognani <abologna@redhat.com> wrote:
> > Note that, from libvirt's point of view, there's no advantage to
> > doing things that way instead of what you already have. Handling the
> > additional machine property is a complete non-issue. But it would
> > make things nicer for people running QEMU directly, I think.
>
> I'm tempted to simply consider this to be another wart of the QEMU
> command line :)

Fine by me! Papering over such idiosyncrasies is part of libvirt's
core mission after all :)

-- 
Andrea Bolognani / Red Hat / Virtualization

