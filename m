Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2B5263638
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 20:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIISop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 14:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgIISoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 14:44:44 -0400
X-Greylist: delayed 447 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Sep 2020 11:44:44 PDT
Received: from forward101j.mail.yandex.net (forward101j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E58C061573
        for <kvm@vger.kernel.org>; Wed,  9 Sep 2020 11:44:43 -0700 (PDT)
Received: from mxback22j.mail.yandex.net (mxback22j.mail.yandex.net [IPv6:2a02:6b8:0:1619::222])
        by forward101j.mail.yandex.net (Yandex) with ESMTP id 27FE71BE0708;
        Wed,  9 Sep 2020 21:37:11 +0300 (MSK)
Received: from iva8-6403930b9beb.qloud-c.yandex.net (iva8-6403930b9beb.qloud-c.yandex.net [2a02:6b8:c0c:2c9a:0:640:6403:930b])
        by mxback22j.mail.yandex.net (mxback/Yandex) with ESMTP id uqoZ0BfNPW-bAfihGPL;
        Wed, 09 Sep 2020 21:37:10 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1599676630;
        bh=qwqt/UpSDFIEXvLC1mjyKgT8ExdvZ07gy2oFqPZQous=;
        h=In-Reply-To:Cc:To:From:Subject:Date:References:Message-ID;
        b=TUI5K8zpv+d4PG0fm19zlVzUVbu4R1ZEnx13VfAe9Xe8xNH6hbY028eTChZs9WVmS
         46U4oLWARY8v1mkw7qp+Q0cj8tPsdM945tvAiy+UASMAt8XsVmLqVk0LRWSxtTyHJm
         yDivkihn6FzRLpsGvO3+6BEyvaLOZIk4V43FT5xE=
Authentication-Results: mxback22j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva8-6403930b9beb.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 840Z6gnz2C-bAH0HEe7;
        Wed, 09 Sep 2020 21:37:10 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: KVM_SET_SREGS & cr4.VMXE problems
From:   stsp <stsp2@yandex.ru>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
References: <8f0d9048-c935-bccf-f7bd-58ba61759a54@yandex.ru>
 <20200909163023.GA11727@sjchrist-ice>
 <fdeb1ecb-abee-2197-4449-88d33480c5fe@yandex.ru>
Message-ID: <4b019c3e-e880-1409-c907-0dc2a3742813@yandex.ru>
Date:   Wed, 9 Sep 2020 21:37:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <fdeb1ecb-abee-2197-4449-88d33480c5fe@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A bit of update.

09.09.2020 21:04, stsp пишет:
> As for the original problem: there are at least
> 2 problems.
>
> On OLD intel:
> - KVM fails with invalid guest state unless
> you set VMXE in guest's cr4, and do it from
> the very first attempt!

This happens only on nested execution!
Under qemu/kvm.


> On any CPU:
> - If you set VMXE in guest's cr4, then guest
> works in non-VME mode, as if cr4.VME was
> cleared. But I didn't clear it - KVM did! 
I tried to read them back with
KVM_GET_SREGS.
So if I initially set VMXE|VME, then I
indeed read back plain 0.
If I initially set just VMXE, then I read
back also 0.
If I initially set VME, then I read back
1 (VME - correct)
