Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F245636FEC
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 02:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiKXBkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 20:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKXBkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 20:40:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4861CFEA8
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 17:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669253954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GpT4IKp2tig5wLkDxQENWP9ZjtyYFOaMkkF58EqTLMQ=;
        b=VpjGQGXUpS14eOeU20ntH88JU/QssjFhA8ByqV9Ndy43ksfy6Gt0FX2tRWUuMVQE9H4Efw
        4O/4efnzTuo8pca0nfLXOAH9axavvrniAzf1SbWkEZpqGvn/YUc2hRzWR/J7zd2HjoIRoI
        CK3U9fS4W2B53r7jj3bp4FFQyuDd4G4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-205-vGeSiO43Pki8DmKpg4C_Tg-1; Wed, 23 Nov 2022 20:39:10 -0500
X-MC-Unique: vGeSiO43Pki8DmKpg4C_Tg-1
Received: by mail-wm1-f70.google.com with SMTP id l42-20020a05600c1d2a00b003cf8e70c1ecso1865201wms.4
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 17:39:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GpT4IKp2tig5wLkDxQENWP9ZjtyYFOaMkkF58EqTLMQ=;
        b=70Dn4dlU6f5r9SLApZXu8ORNMxsNocN9+pRJEaUVxXWAXQadcubNsXvZY/IGLqkGc0
         6TO6E4XQI8/q/VyayzxnXdFLFUgSZypDPU6YG8TX89Zwk8/tSIuCNU12dQjSGrlw9bgH
         +5f1GiuNyTwXbvqtDzVS6LGIXZPeaRILaBmPo4yirifpi/P49JVoEo8t6lhHaPl+FGPt
         77BIpH0Z34MoRY1nyi/siPK/cvtvWY2CiQyAcn5f4hnzNlltaW95sprUx/XwrMw20x1r
         nRa+RiwCWPobpJLBwMhayJdD59zkb1DNre4v5iHKgS0IhYgYDOacZN7MZX9lO/sZKVwb
         An9A==
X-Gm-Message-State: ANoB5pn/lrV/o9jiY4S6QRYb+lWjoWHriJJ/4Yh6LKtMKMSekYC6IzES
        iWYu06Xj7nQb+Ub2vcmY1dUXZNUeYc3bWQxny0upgIkq/tR94sLyeSXO7NmCoNi6c6+nZM5MKXs
        NVZ/l4sl54FUI
X-Received: by 2002:a05:600c:12ca:b0:3cf:98e8:3e48 with SMTP id v10-20020a05600c12ca00b003cf98e83e48mr25698915wmd.56.1669253948506;
        Wed, 23 Nov 2022 17:39:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Ca2QLMzCyjoSiqU6sdUFz8cl3yE/BfbCp0abhxM35eRzb0HlxCR8IPIV2zBE35JoA0FadQg==
X-Received: by 2002:a05:600c:12ca:b0:3cf:98e8:3e48 with SMTP id v10-20020a05600c12ca00b003cf98e83e48mr25698908wmd.56.1669253948246;
        Wed, 23 Nov 2022 17:39:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id j13-20020a5d604d000000b00236695ff94fsm17920189wrt.34.2022.11.23.17.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 17:39:07 -0800 (PST)
Message-ID: <df01b973-d56c-7ba9-866f-9ca47dccd123@redhat.com>
Date:   Thu, 24 Nov 2022 02:39:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: Nvidia GPU PCI passthrough and kernel commit
 #5f33887a36824f1e906863460535be5d841a4364
Content-Language: en-US
To:     "Ashish Gupta (SJC)" <ashish.gupta1@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        John Levon <john.levon@nutanix.com>
References: <PH0PR02MB84228844F6176836E8C86B1BA40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <PH0PR02MB84228844F6176836E8C86B1BA40F9@PH0PR02MB8422.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/22 01:56, Ashish Gupta (SJC) wrote:
> Nutanix uses KVM based hypervisor, which is called AHV (Acropolis 
> Hypervisor).
> 
> latest AHV release is based on kernel v5.10.117. where we found that 
> Nvidia GPU cards (10/A30/A40 etc) stopped working.
> 
> Guest VM (based on centos7 or Ubuntu 16.10) were able to identify card 
> but after installing Nvidia Grid driver we were seeing following logs in 
> guest vm.
> 

Have you tested with a more recent version than 5.10.x, to see if the 
bug is still there?

Paolo

