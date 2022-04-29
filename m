Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D831A515392
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379992AbiD2SYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236995AbiD2SYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:24:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BB1BC8653
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651256476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/stkcvJjykGRYHDCQBNH7PAqqEJypDF4kYoHuS+OVKA=;
        b=gLGGpaHugbBBzMN+di8QpYyiGltIrc6KzqTnknPkVYZ4EFv8bsqSNFYe7rzPdiSzEg/Yae
        gY6Tb+UZKSQYztTWbY9yOUGzQh4VhXtlemEWj/1GeJI3dU2F1Ec4TKA2R+5JK7bmjt8acT
        N2rNcA6jylCx55xy5g7IV/6IReTqWnA=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-CljRLPyrPc-slNRIOyOhzw-1; Fri, 29 Apr 2022 14:21:14 -0400
X-MC-Unique: CljRLPyrPc-slNRIOyOhzw-1
Received: by mail-il1-f197.google.com with SMTP id j5-20020a056e020ee500b002cbc90840ecso4024531ilk.23
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/stkcvJjykGRYHDCQBNH7PAqqEJypDF4kYoHuS+OVKA=;
        b=JI2h1+DmuaiBPaFTmrvNbUVmlyauX8pCaJ1D1Qz99Z/oG7fiIjj2mHyB+fv3TrdDgk
         8PZZu0WKQQciZWgCWaEeqEqAg9SSfB8zIQkG1UuNn0yva80icKi8ED6/rBP2g8OkoLiG
         qnB5V6fEIS6dNSo8vxgu/HWKt1dswZMeMKPE8uZAPpNDv+vm/woFOqFdTk9Qaw92ctRF
         i289b7To2ezHE/wXTLBB7NMVal2IFnGTLZd5DSZC8LXvdO9SnDEcCKrBbAG/iHLhKcdZ
         B71+e5euRzqwWAPvo7raP4kXBykYdj6+qRA2rZmeNZZKjtPmDuIZdRVYkdYs/gBKbL4h
         D+Fg==
X-Gm-Message-State: AOAM531QM8Zt6pDYJOnUBLHsEtGiqKWBXRDA4yUL7zgFVlZSVEKj8gmt
        8AU/oMTzN7oZ04Ap61lIxzWqCiCKiJhKRUD5lUS2ooRB1I9s5nTu7uoj7MO88riIa+F9b0ilvJH
        PEraNG2U6rZKt
X-Received: by 2002:a05:6e02:1809:b0:2cc:507a:acfa with SMTP id a9-20020a056e02180900b002cc507aacfamr266306ilv.114.1651256474186;
        Fri, 29 Apr 2022 11:21:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMQe01BrdjkQTGSc8GhfcNnSFwj4USJ8BqMV1n3p5cbt4caHClRYCCsnFmYOxhkaUoVr9wpg==
X-Received: by 2002:a05:6e02:1809:b0:2cc:507a:acfa with SMTP id a9-20020a056e02180900b002cc507aacfamr266282ilv.114.1651256473927;
        Fri, 29 Apr 2022 11:21:13 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id 70-20020a6b1449000000b00657b4130f57sm1184609iou.25.2022.04.29.11.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 11:21:13 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:21:11 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
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
Subject: Re: [PATCH RFC 04/10] intel_iommu: Second Stage Access Dirty bit
 support
Message-ID: <Ymwsl5G/TCuRFja2@xz-m1.local>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
 <20220428211351.3897-5-joao.m.martins@oracle.com>
 <CACGkMEug0zW0pWCSEtHQ5KE5KRpXyWvgJmPZm-yvJnCLmocAYg@mail.gmail.com>
 <f90a8126-7805-be8d-e378-f129196e753d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f90a8126-7805-be8d-e378-f129196e753d@oracle.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 10:12:01AM +0100, Joao Martins wrote:
> On 4/29/22 03:26, Jason Wang wrote:
> > On Fri, Apr 29, 2022 at 5:14 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> >> @@ -3693,7 +3759,8 @@ static void vtd_init(IntelIOMMUState *s)
> >>
> >>      /* TODO: read cap/ecap from host to decide which cap to be exposed. */
> >>      if (s->scalable_mode) {
> >> -        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
> >> +        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS |
> >> +                   VTD_ECAP_SLADS;
> >>      }
> > 
> > We probably need a dedicated command line parameter and make it compat
> > for pre 7.1 machines.
> > 
> > Otherwise we may break migration.
> 
> I can gate over an 'x-ssads' option (default disabled). Which reminds me that I probably
> should rename to the most recent mnemonic (as SLADS no longer exists in manuals).
> 
> If we all want by default enabled I can add a separate patch to do so.

The new option sounds good.

Jason, per our previous discussion, shall we not worry about the
compatibility issues per machine-type until the whole feature reaches a
mostly-complete stage?

There seems to have a bunch of sub-features for scalable mode and it's a
large project as a whole.  I'm worried trying to maintain compatibilities
for all the small sub-features could be an unnessary burden to the code
base.

Thanks,

-- 
Peter Xu

