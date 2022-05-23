Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19821530E44
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiEWJHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiEWJGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:06:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C233324976
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653296795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qZg53IBR8AfCf90VyG8/6MKIqqzJRH/xbpj5id+MOvw=;
        b=jRAS19iTAsFZDRIASG7/p3cxVdXBKvNmbc8NEXgfgLnEvWL0NvJgE3Qohi8c+CMPGKDSu1
        DuPca+nZrheGXkPZ/p5+Vxq0+ITPFDoO5vcPcY3fD8IiMm+X0FJJfOfdmCGcRGeLWhZvJn
        SdJ6PAdroxsW6daMSPLe0Wm6e6SqLpM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-2QYcrr3BO8iGvLMfTa7uJw-1; Mon, 23 May 2022 05:06:32 -0400
X-MC-Unique: 2QYcrr3BO8iGvLMfTa7uJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEF561857F0E;
        Mon, 23 May 2022 09:06:31 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A0B592026D6A;
        Mon, 23 May 2022 09:06:31 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id B276918000B4; Mon, 23 May 2022 11:06:29 +0200 (CEST)
Date:   Mon, 23 May 2022 11:06:29 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 10/36] i386/kvm: Move architectural CPUID leaf
 generation to separate helper
Message-ID: <20220523090629.ggirqapc6jcn24nb@sirius.home.kraxel.org>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-11-xiaoyao.li@intel.com>
 <20220512174814.GE2789321@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512174814.GE2789321@ls.amr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 10:48:14AM -0700, Isaku Yamahata wrote:
> On Thu, May 12, 2022 at 11:17:37AM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
> > diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> > index b434feaa6b1d..5c7972f617e8 100644
> > --- a/target/i386/kvm/kvm_i386.h
> > +++ b/target/i386/kvm/kvm_i386.h
> > @@ -24,6 +24,10 @@
> >  #define kvm_ioapic_in_kernel() \
> >      (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
> >  
> > +#define KVM_MAX_CPUID_ENTRIES  100
> 
> In Linux side, the value was bumped to 256.  Opportunistically let's make it
> same.

When doing so use a separate patch please.  A patch like this -- moving
around code without functional changes -- should not be mixed with other
changes.

take care,
  Gerd

