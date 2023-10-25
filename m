Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7FD7D78FC
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 01:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjJYXzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 19:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjJYXzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 19:55:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E26182
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 16:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698278087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=TIintWgJTfboQO5OTuPzrdngusig1vFIFKO8N+OxmI8=;
        b=Fg2zdr50+OdrAklbHX8huujXmn1kgaJkQh2iJt295Uc8Ka9W15tO7s1qZB0FQPlvbG/pUF
        l355gPTeIp9or0xNZCD7NY/WP+dChD4bv9xRoY62gm7uJN2mgzcf1VYagx2O26Wo3JRMBP
        wkL376xoxBm8S1hwrhr/y0Wj73+PpLw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-BpREMdv1OXKCCxnEPcUsmA-1; Wed, 25 Oct 2023 19:54:46 -0400
X-MC-Unique: BpREMdv1OXKCCxnEPcUsmA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-778a32da939so44014185a.0
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 16:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698278086; x=1698882886;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TIintWgJTfboQO5OTuPzrdngusig1vFIFKO8N+OxmI8=;
        b=glkEJmr29z1wPiWtCUMCNp644hHaCCOcpNBMDZiUYmaFPl5lwLni+wYborIEurvXVk
         X3pc1H555mXb7xMmX3EzsiqL4QPP89z0hAIt2LkCqsufcTy7KalD4B8H4DIlRnZpFo+c
         WDPp+d79Q/sMEXSKWYqQnL30Cm6n09wd0tPuyLgsLnZhGQRilAXHwRvgxINoIWp/TyFL
         09DZWin4hw6GR0lfbxev4+bGxjGTFlo4G5CY572Se3kjZiwNdiS56d2H2cfze+t34oWe
         XvOzhvFGA4/zVtiI7hKn7lXdgw9Wth/r+cFkBwRmPOkPhe+GAuHdg1Ptewnbd/7zthg1
         zvRw==
X-Gm-Message-State: AOJu0YzxpAegKrBLjd4fCFkbGwCQs+9Eu7/gCLfHPWpZ3x9siSruEjKc
        a9zc/xxe/TV7P01SLF2wR0rsbWbHJpNqxfOW+vXL3MSLJDBOApM9EJLtuCJCobIegSI2IPxPpej
        2cPSjPwIEawGe
X-Received: by 2002:a05:620a:5627:b0:778:91f0:e559 with SMTP id vv7-20020a05620a562700b0077891f0e559mr14623233qkn.78.1698278086026;
        Wed, 25 Oct 2023 16:54:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEG8buWnXa1t3csI9uuGtHq1Kkfm/iFDo8HA+qc6SHQk1q5HQs4phEeyxxaDi4lZR9R6mmHJA==
X-Received: by 2002:a05:620a:5627:b0:778:91f0:e559 with SMTP id vv7-20020a05620a562700b0077891f0e559mr14623224qkn.78.1698278085713;
        Wed, 25 Oct 2023 16:54:45 -0700 (PDT)
Received: from [172.19.0.201] ([192.80.84.35])
        by smtp.googlemail.com with ESMTPSA id qp8-20020a05620a388800b0077423f849c3sm4600064qkn.24.2023.10.25.16.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 16:54:45 -0700 (PDT)
Message-ID: <791d3b77-8a4d-4c5e-88db-f38843d37098@redhat.com>
Date:   Thu, 26 Oct 2023 01:54:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.7
To:     Huacai Chen <chenhuacai@kernel.org>,
        Huacai Chen <chenhuacai@loongson.cn>
Cc:     kvm@vger.kernel.org, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20231005091825.3207300-1-chenhuacai@loongson.cn>
 <CAAhV-H7VN_r-SzEMK6LHqXzVbNemZYuYYLb2mri=EGZ7qb3C3A@mail.gmail.com>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <CAAhV-H7VN_r-SzEMK6LHqXzVbNemZYuYYLb2mri=EGZ7qb3C3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/23 04:10, Huacai Chen wrote:
> Hi, Paolo, Excuse me, but this is just a gentle reminder. The 6.7 merge 
> window is coming soon, have you missed this PR mail? Or should I rebase 
> to 6.6-rc7 to send a new PR (a randconfig build error is fixed in 6.6-rc7)?

Hi,

I am expecting some changes to Kconfig for 6.7 and wanted to pull this 
second, to solve the conflicts.

There is no need to rebase, but it would be useful to point me to the 
fix in 6.6-rc7.

Paolo

