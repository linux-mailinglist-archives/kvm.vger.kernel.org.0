Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FF351B974
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 09:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346005AbiEEHvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 03:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241934AbiEEHvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 03:51:43 -0400
X-Greylist: delayed 302 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 May 2022 00:48:04 PDT
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 757FA32ED1
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 00:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651736883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iImyyWJeXSKqwvAOGyL0QZeKnk1NDA9mP6GMZtxX0sQ=;
        b=Bd623sN9L/pnfNluPhwcgyb+fBz0bkPD5qjPLg8zSuTkUB6K9f6kNrM0wRqnVYrSWQewlq
        l3U1mJSxg9QX5O4ESUsq7pQi8en74wgl7WAgmtaScIAzw+L0BQKHccbHXiAo/iTBaSmaUF
        LYLZnRkJbadY+pBbtsvsIgSP8STY/44=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-P5fG9w1HO_m135HFEmNUPQ-1; Thu, 05 May 2022 03:41:16 -0400
X-MC-Unique: P5fG9w1HO_m135HFEmNUPQ-1
Received: by mail-lj1-f200.google.com with SMTP id l16-20020a2e5710000000b0024f0c34eff1so1127904ljb.10
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 00:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iImyyWJeXSKqwvAOGyL0QZeKnk1NDA9mP6GMZtxX0sQ=;
        b=Z/nHJ0NnoxvTF5mNkIsx4yBRz+z0TQhpSFU9C0XtUz2HrLoTz71dDLY9o+whwFzRzO
         uXTeGkLWXrDdvuZqymZWafYNHaLfuQFasqTq/8mZOCXE35cFjWCK4d5wwW8EgRC7Cu43
         Wb0g6AU4bBsJ7H9612vUSvz/aFtsrmPCVhHTH1e+eh29s60OTiNoWGvhvGWjSNXMzNZo
         o+Fh+dEATqR+AaDe1XQpMmqEgadpawUZg+Y7e9xRft9G7O5j137+iH6JGqCToZB+NPD2
         550lowCmoaKqWbN1gdDErP8+KWBclftet//AMK9BOsdTpeNozbPwlYcTOSb1RC141rg3
         N1/A==
X-Gm-Message-State: AOAM530zhIVU5TWu7EcsPESwXooa+8l4h7rS5KBzXt70xapcAms4850W
        aWGYe7ll/E1o3IUc/vYgILTg2Q16mTvKjDDFusd0vUjZSw21k2jN4JZ+6d1B9vjuatHdXTBRJWv
        qYdyeQHkUXBlZ9+rmHDnzblkrSqay
X-Received: by 2002:a05:651c:89:b0:250:87c9:d4e6 with SMTP id 9-20020a05651c008900b0025087c9d4e6mr3462465ljq.315.1651736474582;
        Thu, 05 May 2022 00:41:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpnQn0feimHP2UoZ+5XWkNS4nxvIlMmfwO3DobMPr/iVBIJU4hpeTmpZe4KvBJMKq4OORdzsy7jTTiTjtnkXE=
X-Received: by 2002:a05:651c:89:b0:250:87c9:d4e6 with SMTP id
 9-20020a05651c008900b0025087c9d4e6mr3462441ljq.315.1651736474362; Thu, 05 May
 2022 00:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
 <20220428211351.3897-5-joao.m.martins@oracle.com> <CACGkMEug0zW0pWCSEtHQ5KE5KRpXyWvgJmPZm-yvJnCLmocAYg@mail.gmail.com>
 <f90a8126-7805-be8d-e378-f129196e753d@oracle.com> <Ymwsl5G/TCuRFja2@xz-m1.local>
 <62f26667-5ccd-619d-2e0f-eb3a3f304984@oracle.com>
In-Reply-To: <62f26667-5ccd-619d-2e0f-eb3a3f304984@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 5 May 2022 15:41:03 +0800
Message-ID: <CACGkMEtVVmz7fLYSSE+OWA6VsjUO8R4EOHDH-0o=97ZJkXDJuw@mail.gmail.com>
Subject: Re: [PATCH RFC 04/10] intel_iommu: Second Stage Access Dirty bit support
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Peter Xu <peterx@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 4, 2022 at 4:47 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 4/29/22 19:21, Peter Xu wrote:
> > On Fri, Apr 29, 2022 at 10:12:01AM +0100, Joao Martins wrote:
> >> On 4/29/22 03:26, Jason Wang wrote:
> >>> On Fri, Apr 29, 2022 at 5:14 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> >>>> @@ -3693,7 +3759,8 @@ static void vtd_init(IntelIOMMUState *s)
> >>>>
> >>>>      /* TODO: read cap/ecap from host to decide which cap to be exposed. */
> >>>>      if (s->scalable_mode) {
> >>>> -        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
> >>>> +        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS |
> >>>> +                   VTD_ECAP_SLADS;
> >>>>      }
> >>>
> >>> We probably need a dedicated command line parameter and make it compat
> >>> for pre 7.1 machines.
> >>>
> >>> Otherwise we may break migration.
> >>
> >> I can gate over an 'x-ssads' option (default disabled). Which reminds me that I probably
> >> should rename to the most recent mnemonic (as SLADS no longer exists in manuals).
> >>
> >> If we all want by default enabled I can add a separate patch to do so.
> >
> > The new option sounds good.
> >
>
> OK, I'll fix it then for the next iteration.
>
> Also, perhaps I might take the emulated iommu patches out of the iommufd stuff into a
> separate series. There might be a place for them in the realm of testing/prototyping.

That would be better.

>
> > Jason, per our previous discussion, shall we not worry about the
> > compatibility issues per machine-type until the whole feature reaches a
> > mostly-complete stage?
> >
> > There seems to have a bunch of sub-features for scalable mode and it's a
> > large project as a whole.  I'm worried trying to maintain compatibilities
> > for all the small sub-features could be an unnessary burden to the code
> > base.

My understanding, if it's not too hard, it looks better for each
sub-features to try its best for compatibility. For this case, having
a dedicated option might help for debugging as well.

> Perhaps best to see how close we are to spec is to check what we support in intel-iommu
> in terms of VT-d revision versus how many buckets we fill in. I think SLADS/SSADS was in
> 3.0 IIRC.
>
> I can take the compat stuff out if it's too early for that -- But I take it
> these are questions for Jason.
>

There's probably no need for the compat stuff, having a dedicated
option and making it disabled by default should be fine.

Thanks

