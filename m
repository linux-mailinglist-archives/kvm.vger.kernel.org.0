Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50214ED656
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 11:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiCaJCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 05:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbiCaJCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 05:02:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E037167CF
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 02:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648717250;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BuqkkGgGXCxzRL6yOlBr2HGJjk2midZHSoM5E+pGFME=;
        b=dAtQT5abGm32wrLAajIuI0tShlmngp0BuR+NsflFW9Rce024lZ/tQYBG/GggfSdKENb09r
        6y61IzAhVX5tOTG0q+d7UPwaluoEO3OorGDCGBnyeh5uwyYh7o0MwBawFL+q3//uHzrdzf
        1W0FQCtY3wxbW+fFST2o4fPkjGX8SlM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-o3KpGjjbMPSV2wJwlq0-0g-1; Thu, 31 Mar 2022 05:00:48 -0400
X-MC-Unique: o3KpGjjbMPSV2wJwlq0-0g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6020E3C11C81;
        Thu, 31 Mar 2022 09:00:47 +0000 (UTC)
Received: from redhat.com (unknown [10.39.194.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B71D1400C2B;
        Thu, 31 Mar 2022 09:00:44 +0000 (UTC)
Date:   Thu, 31 Mar 2022 10:00:41 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Message-ID: <YkVtuRNherKV1kJC@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
 <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
 <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
 <YjmWhMVx80/BFY8z@redhat.com>
 <1d5b0192-75ef-49ad-dc47-cfc0c3c63455@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d5b0192-75ef-49ad-dc47-cfc0c3c63455@intel.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 04:51:27PM +0800, Xiaoyao Li wrote:
> On 3/22/2022 5:27 PM, Daniel P. Berrangé wrote:
> ...
> > IMHO the AmdSev build for OVMF gets this right by entirely disabling
> > the split OVMF_CODE.fd vs OVMF_VARS.fd, and just having a single
> > OVMF.fd file that is exposed read-only to the guest.
> > 
> > This is further represented in $QEMU.git/docs/interop/firmware.json
> > by marking the firmware as 'stateless', which apps like libvirt will
> > use to figure out what QEMU command line to pick.
> 
> Hi Daniel,
> 
> I don't play with AMD SEV and I'm not sure if AMD SEV requires only single
> OVMF.fd. But IIUC, from edk2
> 
> commit 437eb3f7a8db ("OvmfPkg/QemuFlashFvbServicesRuntimeDxe: Bypass flash
> detection with SEV-ES")
> 
> , AMD SEV(-ES) does support NVRAM via proactive VMGEXIT MMIO
> QemuFlashWrite(). If so, AMD SEV seems to be able to support split OVMF,
> right?

Note that while the traditional OvmfPkg build can be used with
SEV/SEV-ES, this is not viable for measured boot, as it uses
the NVRAM whose content is not measured.

I was specifically referring to the OvmfPkg/AmdSev build which
doesn't use seprate NVRAM, and has no variables persistence.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

