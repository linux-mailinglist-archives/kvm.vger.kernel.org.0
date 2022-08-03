Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382565891A5
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 19:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbiHCRoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 13:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbiHCRoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 13:44:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A7B15244F
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 10:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659548658;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f07pmX2X/9ezSJkmLyBsCE9o6iaqy47R2T+lPh6txxg=;
        b=hizVWvUqumSKrfpJBPsyhFLchS1ULGp8AJt/w6APX2W6LfAuCfrrgwR9eyzBZZqgWIlsg1
        zhL8IOiwR3W1Cvp9erKYCKBggU/ADT7+XzSmXY8Ti0fiep1Gj5gbw8WM99xTeuWPVWrO7/
        icNkvt2qk1NtFCabMSFJptnd1nH0IqY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-cSXMfVP3OPW6xfrU-kXlJg-1; Wed, 03 Aug 2022 13:44:15 -0400
X-MC-Unique: cSXMfVP3OPW6xfrU-kXlJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE61B85A585;
        Wed,  3 Aug 2022 17:44:14 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4777D2026D4C;
        Wed,  3 Aug 2022 17:44:12 +0000 (UTC)
Date:   Wed, 3 Aug 2022 18:44:10 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
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
Subject: Re: [PATCH v1 00/40] TDX QEMU support
Message-ID: <Yuqz6nPIIqzrlxP1@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <YujzOUjMbBZRi/e6@redhat.com>
 <db14e4f1-6090-7f97-f690-176ba828500c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db14e4f1-6090-7f97-f690-176ba828500c@intel.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 06:55:48PM +0800, Xiaoyao Li wrote:
> On 8/2/2022 5:49 PM, Daniel P. Berrangé wrote:
> > On Tue, Aug 02, 2022 at 03:47:10PM +0800, Xiaoyao Li wrote:
> 
> > > - CPU model
> > > 
> > >    We cannot create a TD with arbitrary CPU model like what for non-TDX VMs,
> > >    because only a subset of features can be configured for TD.
> > >    - It's recommended to use '-cpu host' to create TD;
> > >    - '+feature/-feature' might not work as expected;
> > > 
> > >    future work: To introduce specific CPU model for TDs and enhance +/-features
> > >                 for TDs.
> > 
> > Which features are incompatible with TDX ?
> 
> TDX enforces some features fixed to 1 (e.g., CPUID_EXT_X2APIC,
> CPUID_EXT_HYPERVISOR)and some fixed to 0 (e.g., CPUID_EXT_VMX ).
> 
> Details can be found in patch 8 and TDX spec chapter "CPUID virtualization"
> 
> > Presumably you have such a list, so that KVM can block them when
> > using '-cpu host' ?
> 
> No, KVM doesn't do this. The result is no error reported from KVM but what
> TD OS sees from CPUID might be different what user specifies in QEMU.
> 
> > If so, we should be able to sanity check the
> > use of these features in QEMU for the named CPU models / feature
> > selection too.
> 
> This series enhances get_supported_cpuid() for TDX. If named CPU models are
> used to boot a TDX guest, it likely gets warning of "xxx feature is not
> available"

If the  ',check=on' arg is given to -cpu, does it ensure that the
guest fails to startup with an incompatible feature set ? That's
really the key thing to protect the user from mistakes.


> We have another series to enhance the "-feature" for TDX, to warn out if
> some fixed1 is specified to be removed. Besides, we will introduce specific
> named CPU model for TDX. e.g., TDX-SapphireRapids which contains the maximum
> feature set a TDX guest can have on SPR host.

I don't know if this is the right approach or not, but we should at least
consider making use of CPU versioning here.  ie have a single "SapphireRapids"
alias, which resolves to a suitable specific CPU version depending on whether
TDX is used or not.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

