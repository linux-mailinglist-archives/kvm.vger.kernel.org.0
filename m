Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25724D1D20
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348337AbiCHQ12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240938AbiCHQ10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:27:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55A644F9EA
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646756789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T2AL3azyXwS+YdQGr7WwE+BEYV704EZWT30IdZo6h2w=;
        b=V6rFats5XsE/TJxAFohm5pkoVrSogEXmHPo6whP1WcMKvy6TfneSX+ScVRlH2+EYa5zhft
        ZzX+N1EcKeww3ioR3E8YlrmnWjHVU3XsCoOd09lQN/MH8PqJPqJwJdVZfTuTxDdBZYTV8n
        07fozxAAZGTjFHE3syTZiz/mfmT9U3E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-7XLkbshfPTGgTm8MNE432w-1; Tue, 08 Mar 2022 11:26:25 -0500
X-MC-Unique: 7XLkbshfPTGgTm8MNE432w-1
Received: by mail-wr1-f71.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so5650694wrg.20
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 08:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T2AL3azyXwS+YdQGr7WwE+BEYV704EZWT30IdZo6h2w=;
        b=EVnymL5wII+Fugqpc0bI1lEbUU3GwE+//Zq03meTf+4fbnTLBdOZ+Ro/FrMDW8ND5I
         oK7YoBotlsGqUvruZPOxPKC3r5WcHEm4uFsB7Aip66Cpp4SWariMIMTzF541B0eldl2X
         jsWdoTHD6k3eLwAY+7YB8Scl+o09oK9AOLDP6A+Gqbu4Nxc+LZuijhw8mIRp+NH2/uvE
         /2Rio0Ped4aXBnAMwuNFSYQWOD2eIG57/l56eOQ6T5fl11LHxd0gdNNQ65SVDJpSrwqA
         kwHWxMnN8aeLEnujq5yKe9XUQMrRacP7/Wpdc149W30UAQay5xbqMGg3zxbo9E+Kc0vl
         rdww==
X-Gm-Message-State: AOAM533vTUJRAB56Qki30uUEXT42CZa2w+ckkyiQbJBnDbN7pwZV3eV5
        XRn2dMDvrtuqMWaIz4OLlawQYEiCzcrpZkGnvFQ3f0npwojxeVSneEqeV9SdThhj9y607PJZqhb
        luXlkWOWCXdTs
X-Received: by 2002:adf:eb45:0:b0:1ef:6070:7641 with SMTP id u5-20020adfeb45000000b001ef60707641mr13354532wrn.301.1646756784447;
        Tue, 08 Mar 2022 08:26:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhnyFnkO7umByqQJsfdzQVHFeLrYMLRMWEEu3NiZVMI6SXrE3spWUAqmE+Oa2Azw0YWMSP3w==
X-Received: by 2002:adf:eb45:0:b0:1ef:6070:7641 with SMTP id u5-20020adfeb45000000b001ef60707641mr13354522wrn.301.1646756784232;
        Tue, 08 Mar 2022 08:26:24 -0800 (PST)
Received: from redhat.com ([2.55.24.184])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d6243000000b001e33760776fsm14270303wrv.10.2022.03.08.08.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 08:26:23 -0800 (PST)
Date:   Tue, 8 Mar 2022 11:26:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, lei he <helei.sig11@bytedance.com>,
        Gonglei <arei.gonglei@huawei.com>
Subject: Re: [mst-vhost:vhost 28/60] nios2-linux-ld:
 virtio_crypto_akcipher_algs.c:undefined reference to `rsa_parse_pub_key'
Message-ID: <20220308112417-mutt-send-email-mst@kernel.org>
References: <202203090014.ulENdnAQ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202203090014.ulENdnAQ-lkp@intel.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 09, 2022 at 12:10:30AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> head:   c5f633abfd09491ae7ecbc7fcfca08332ad00a8b
> commit: 8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9 [28/60] virtio-crypto: implement RSA algorithm
> config: nios2-randconfig-p002-20220308 (https://download.01.org/0day-ci/archive/20220309/202203090014.ulENdnAQ-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9
>         git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>         git fetch --no-tags mst-vhost vhost
>         git checkout 8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    nios2-linux-ld: drivers/crypto/virtio/virtio_crypto_akcipher_algs.o: in function `virtio_crypto_rsa_set_key':
>    virtio_crypto_akcipher_algs.c:(.text+0x4bc): undefined reference to `rsa_parse_priv_key'
>    virtio_crypto_akcipher_algs.c:(.text+0x4bc): relocation truncated to fit: R_NIOS2_CALL26 against `rsa_parse_priv_key'
> >> nios2-linux-ld: virtio_crypto_akcipher_algs.c:(.text+0x4e8): undefined reference to `rsa_parse_pub_key'
>    virtio_crypto_akcipher_algs.c:(.text+0x4e8): relocation truncated to fit: R_NIOS2_CALL26 against `rsa_parse_pub_key'

I guess we need to select CRYPTO_RSA  ?

> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

