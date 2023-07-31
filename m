Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB5276A30C
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 23:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjGaVhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 17:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjGaVhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 17:37:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD66519AF
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690839405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FxwBtWb2NqDjMd/Gm9nSEVdpJkuNP2kDTv/kmcJ88Js=;
        b=Vus3eM7CcS5emnUo77Db0vayWKh6CO8+df7mzQbIzrGEnuA/5suiqPbRAPJTfARHoSz4mT
        49lAq+PIOiBiiDPqWvqd3c8CoJygFTVAm6H6BnXoORDw8AHfpmAhR2rvWyzwH16yPrSIw3
        KYJ0bL51QsxInMshxCIMmdY+X8fsmVg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-YZ6NrpHsNzaLeqmleDJtWw-1; Mon, 31 Jul 2023 17:36:44 -0400
X-MC-Unique: YZ6NrpHsNzaLeqmleDJtWw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fa8cd898e0so32228375e9.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690839403; x=1691444203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxwBtWb2NqDjMd/Gm9nSEVdpJkuNP2kDTv/kmcJ88Js=;
        b=RGkzq00se8uxzJPXaQ7yddK5CmqHKjXPOZ0mSMgCLEPJVo6pv6QXcghp201piaEn0k
         Gr0AV159n76ErkXSrwt6cuSA79ePAY47PcOyUHhUMONJ5ilp1IRUgba1RLf+YEmwjM4t
         fppl0gk6a/m6tQhHx3KZwlKtZGS+eWElDjFnWWD3FaGGpO7DMiOcvDBdLtgcueFHJ6yh
         6sw8N5OIlG1lxeEs2qh6ig8TN+s9kTdcUnNjTr45iimboqQ9hhLsjP2dkLCQFUW/vil7
         KJaFZLkgX2MTRMx2ybvPsFqrr1536th9ggoNDLgqaSSA8KoOdzaubYRxKr1tN8C4zG0o
         gGPQ==
X-Gm-Message-State: ABy/qLb/jEAcTDYdI0QWjQ5TxueMo4R22dUtAKrenW2ia1Te+j712kfl
        iV1jcwZB1K7dHoO/jps/Oaki8lROtqorq4Do1CVRR/cMsDvmp/fe930QwRu7LGJJVfB5DvEzsvY
        unGiPvGLHPPLo
X-Received: by 2002:a7b:c846:0:b0:3fc:d5:dc14 with SMTP id c6-20020a7bc846000000b003fc00d5dc14mr852172wml.5.1690839403237;
        Mon, 31 Jul 2023 14:36:43 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF7RG8Yb4RDMpMwdBG53sHWSQe2vNDzyN1XUD3Ta5ran1L6plqz/LKwn/wWJeuUE2ENowVk3w==
X-Received: by 2002:a7b:c846:0:b0:3fc:d5:dc14 with SMTP id c6-20020a7bc846000000b003fc00d5dc14mr852165wml.5.1690839402951;
        Mon, 31 Jul 2023 14:36:42 -0700 (PDT)
Received: from redhat.com ([2.52.21.81])
        by smtp.gmail.com with ESMTPSA id b9-20020a05600c11c900b003fc01f7a42dsm12341696wmi.8.2023.07.31.14.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 14:36:42 -0700 (PDT)
Date:   Mon, 31 Jul 2023 17:36:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 04/19] memory: Introduce
 memory_region_can_be_private()
Message-ID: <20230731173607-mutt-send-email-mst@kernel.org>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-5-xiaoyao.li@intel.com>
 <ZMgma0cRi/lkTKSz@x1n>
 <ZMgo3mGKtoQ7QsB+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMgo3mGKtoQ7QsB+@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 02:34:22PM -0700, Sean Christopherson wrote:
> On Mon, Jul 31, 2023, Peter Xu wrote:
> > On Mon, Jul 31, 2023 at 12:21:46PM -0400, Xiaoyao Li wrote:
> > > +bool memory_region_can_be_private(MemoryRegion *mr)
> > > +{
> > > +    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
> > > +}
> > 
> > This is not really MAP_PRIVATE, am I right?  If so, is there still chance
> > we rename it (it seems to be also in the kernel proposal all across..)?
> 
> Yes and yes.
> 
> > I worry it can be very confusing in the future against MAP_PRIVATE /
> > MAP_SHARED otherwise.
> 
> Heh, it's already quite confusing at times.  I'm definitely open to naming that
> doesn't collide with MAP_{PRIVATE,SHARED}, especially if someone can come with a
> naming scheme that includes a succinct way to describe memory that is shared
> between two or more VMs, but is accessible to _only_ those VMs.

Standard solution is a technology specific prefix.
protect_shared, encrypt_shared etc.

-- 
MST

