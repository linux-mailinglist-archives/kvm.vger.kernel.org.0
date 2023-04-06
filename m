Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810976D907C
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 09:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbjDFHeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 03:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbjDFHeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 03:34:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559C4128
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 00:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680766395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FGcMaVMekhgpd5yPO3QDrWmoN7l5XN+HbxVx0pd1LbY=;
        b=JZmSYqhXupiIoBzwBnfb4DirLWeNcIddY2nECdw/HHNy9c/WecXALNqmAk1LkV1PW3D1dO
        jT4DNU5OeX2Y5fTsHKZw9BB+4hnBlSiJoQfIHsWPG/FRNPxEFQjDW6uaXx5ZP0v9ulv3fJ
        6jdKZO8IZVjftxGtO7xoF7sMeFGqRTw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-eZOmJI2AP5Wnt8oiCV8Eag-1; Thu, 06 Apr 2023 03:33:11 -0400
X-MC-Unique: eZOmJI2AP5Wnt8oiCV8Eag-1
Received: by mail-ed1-f72.google.com with SMTP id b6-20020a509f06000000b005029d95390aso15585444edf.2
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 00:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680766390; x=1683358390;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FGcMaVMekhgpd5yPO3QDrWmoN7l5XN+HbxVx0pd1LbY=;
        b=sLE81A+QDJCsoiodx6evCDCv9YSN20lGt+wgdI90+Bpn8MhTAeOLPjpwMvGU5M60H4
         9XW9kjBAawA92ljVbxkcfGR0U/6Hs6uB5o/Aw2VeXaKRLBQpJximblF/bryBiqgTij+n
         E6UuSgRI8oOCWKuyYSQ5D8CuC4AZGQ8Cgf7Dz0bYNUrjpn1Tiq98fLBkzHInHkJ3UnEp
         sNtm1Ri5h4u/bEYcyts6VxO3fLBbxOYNnApabxb6p6AQpgQk6poXSUmd+9U7tUJYnW3W
         iYFWwNAf7xo2bErNEE6WYQcySczboboJ6v5/pmiFcIsL1+A+qx3AhxJ4uXI9DtOq7hr/
         e6vA==
X-Gm-Message-State: AAQBX9d2X2pt8vn1/xyvvojzozfPcJ968FlBPEv+YzxSvNw2u9QbpHjV
        Bwq+ch9OzDuoMs4ZWpdoHuXysPF/cfqJllVN3xui1YUoHgDkRB0E04p9XJkA2rfY9qNmiuQ4YDw
        nvAczeupKq5MY
X-Received: by 2002:a17:906:8049:b0:948:6e9c:273e with SMTP id x9-20020a170906804900b009486e9c273emr5409510ejw.62.1680766390420;
        Thu, 06 Apr 2023 00:33:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350a7FMioLe6qJwNFHQ3vJ6xBmSCjYoYt/8+eBg+msX4f0msHTuexuO6WVulPbRvqpkZjwjVuog==
X-Received: by 2002:a17:906:8049:b0:948:6e9c:273e with SMTP id x9-20020a170906804900b009486e9c273emr5409493ejw.62.1680766390085;
        Thu, 06 Apr 2023 00:33:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id op14-20020a170906bcee00b0093408d33875sm438558ejb.49.2023.04.06.00.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 00:33:09 -0700 (PDT)
Message-ID: <2e57ad5d-d17a-98b7-d4f9-912bdb23c843@redhat.com>
Date:   Thu, 6 Apr 2023 09:33:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Content-Language: en-US
To:     "Yao, Yuan" <yuan.yao@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Li, Xin3" <xin3.li@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
 <ZC4hdsFve9hUgWJO@google.com>
 <BYAPR11MB37173810AE3328B5E28A18D795919@BYAPR11MB3717.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BYAPR11MB37173810AE3328B5E28A18D795919@BYAPR11MB3717.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/23 08:37, Yao, Yuan wrote:
> It's definitely broken for nested case if the exception Is injected
> by L1 in the first place, but if it's injected after interception (by
> L1) for same exception, and it's trap, it can be regenerated by
                                    ^^^^

if it's a fault

> re-execute the L2 code.

You cannot know why L1 injected an exception.  For example L1 could have 
injected a MCE just to test the code in L1.

This is a scary change, in a scary area of code, with unclear benefits. 
It's going to be hard to convince people. :)

Paolo

