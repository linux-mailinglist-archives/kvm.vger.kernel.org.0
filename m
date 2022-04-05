Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373DB4F49B9
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444559AbiDEWVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446275AbiDEPob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:44:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBF1BF3A49
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 07:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649168077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1FajxbgsqVMCBu63jXGn1+aPvj2NTsHX4bAwRMuwJA=;
        b=JE+V071sEq+VTQUEc6Kabvq+H1BYIw6/9vS42lBqTneEkxnjyGsBBltMDGrm5wRAXd2WLn
        rvS03+p40uXxeerQcFvG+xJPCDLu7sN55bSUcajXe9qU30kzJ16jHfQMURCbXJPiBydLFG
        nOwgSyuvGHpsW4WcRtLmgjmRv+zb2nI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-4gvOGSmMPG-bH1-YkV3nOw-1; Tue, 05 Apr 2022 10:14:36 -0400
X-MC-Unique: 4gvOGSmMPG-bH1-YkV3nOw-1
Received: by mail-wm1-f72.google.com with SMTP id x8-20020a7bc768000000b0038e73173886so1306693wmk.6
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 07:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s1FajxbgsqVMCBu63jXGn1+aPvj2NTsHX4bAwRMuwJA=;
        b=TDjRXDWmViEWWAHzbBnEDjwYXu0W5j4kOyyHuGPrv7tyItSqcC0cV6dFm5cwjDweL/
         dSsRqK1vWojwXclXh4I7mix1xoLRa6nVRucyqaby78u0goImFyNRbA10UJFEsLPLIXtu
         LzG1OHLYYc1wTQYuUviJ0jjPIzOS5wigPe+ni4ksDeSohJ1qxKPWPnbH+mW8WEBMYvyE
         k/aFM6PFIoJUBx4KTWVfcpE/f3r86xYMX3hsffLMc592ipPmyo8ZxoJO9YSXCsil/XkZ
         XoJV+1EW29Qoi+QfUhNkbnQlDBh0E3D/+WneWCg7mXhxnay3jihBvZyhOW1bu+cCyWC+
         0L8Q==
X-Gm-Message-State: AOAM533tckMmMylr/L9Ny4N/+n9auxJXJZliaxYa+rkjXshRKjYrsjbM
        c2bGKyhN9UIoghPXgrdZJRiKL7ZgqU1XgpLS8isxslJySsZ1DjF1xoVALcl3VZR7TAuzSA/GW1A
        89Ojqj1VUhe92
X-Received: by 2002:a1c:770e:0:b0:38e:75d3:16f2 with SMTP id t14-20020a1c770e000000b0038e75d316f2mr3273394wmi.204.1649168075043;
        Tue, 05 Apr 2022 07:14:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0i/G3vVj9aCvUeJLCdQgkQJ/EXqzINMACk7vhYKQRAW/kztpNzYQEiPpBmVYpnzcHKHvbew==
X-Received: by 2002:a1c:770e:0:b0:38e:75d3:16f2 with SMTP id t14-20020a1c770e000000b0038e75d316f2mr3273377wmi.204.1649168074862;
        Tue, 05 Apr 2022 07:14:34 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id g6-20020a5d5406000000b001f049726044sm11960422wrv.79.2022.04.05.07.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:14:34 -0700 (PDT)
Message-ID: <1474e665-c619-1a01-3a28-51894161e316@redhat.com>
Date:   Tue, 5 Apr 2022 16:14:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 037/104] KVM: x86/mmu: Allow non-zero init value
 for shadow PTE
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b74b3660f9d16deafe83f2670539a8287bef988f.1646422845.git.isaku.yamahata@intel.com>
 <968de4765e63d8255ae1b3ac7062ffdca64706e4.camel@intel.com>
 <3cfffe9a29e53ae58dc59d0af3d52128babde79f.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3cfffe9a29e53ae58dc59d0af3d52128babde79f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/22 09:13, Kai Huang wrote:
> Btw, I think the relevant part of TDP MMU change should be included in this
> patch too otherwise TDP MMU is broken with this patch.

I agree.

Paolo

> Actually in this series legacy MMU is not supported to work with TDX, so above
> change to legacy MMU doesn't matter actually.  Instead, TDP MMU change should be
> here.

