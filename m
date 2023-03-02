Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF586A7BCF
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 08:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjCBH0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 02:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCBH0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 02:26:24 -0500
Received: from devnull.tasossah.com (devnull.tasossah.com [IPv6:2001:41d0:1:e60e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD57211C1
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 23:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=devnull.tasossah.com; s=vps; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:References:Cc:To:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zFu00YnTI076g2gszzfpRL62zhxywpnDjcmgcEwJGw8=; b=V/9TDqazzpczA7+sFKVVgLjGwo
        6J8n3M030QfRpkmZ0p38xap3QSFnI1e69YPbPfT6zNEPnuhA8lBcFQ2DEZkLoa1BMQep27JoK8+zM
        aSioNLNwBgv9a7VIDaDCpD6r6O8vgHyKolccIkgQeXZ4EHUQ8TpmKH2G+kh2oPXJIvkc=;
Received: from [2a02:587:6a02:3a00::298]
        by devnull.tasossah.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <tasos@tasossah.com>)
        id 1pXdKV-00CKar-7x; Thu, 02 Mar 2023 09:26:19 +0200
Message-ID: <4e738059-08af-c59d-a277-9b9d39cbfe98@tasossah.com>
Date:   Thu, 2 Mar 2023 09:26:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Tasos Sahanidis <tasos@tasossah.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
 <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
 <20230228114606.446e8db2.alex.williamson@redhat.com>
 <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
 <80a7c60e-3c55-e920-e974-7b80868a6c53@nvidia.com>
Content-Language: en-US
Subject: Re: Bug: Completion-Wait loop timed out with vfio
In-Reply-To: <80a7c60e-3c55-e920-e974-7b80868a6c53@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-03-01 13:53, Abhishek Sahu wrote:
> On 3/1/2023 4:04 PM, Tasos Sahanidis wrote:
>> On 2023-02-28 20:46, Alex Williamson wrote:
>>> Can you do the same for the root port to the GPU, ex. use lspci -t to
>>> find the parent root port.  Since the device doesn't seem to be
>>> achieving D3cold (expected on a desktop system), the other significant
>>> change of the identified commit is that the root port will also enter a
>>> low power state.  Prior to that commit the device would enter D3hot, but
>>> we never touched the root port.  Perhaps confirm the root port now
>>> enters D3hot and compare lspci for the root port when using
>>> disable_idle_d3 to that found when trying to use the device without
>>> disable_idle_d3. Thanks,
>>>
>>> Alex
>>>
>>
>> I seem to have trouble understanding the lspci tree.
>>
> 
>  Can you please try following way to confirm the path
> 
>  ls -l /sys/bus/pci/devices
> 
>  It generally displays the full path like
> 
>  0000:03:00.0 -> ../../../devices/pci0000:00/0000:00:1c.5/0000:02:00.0/0000:03:00.0

Thanks! I had the wrong device (as Alex pointed out), but this helped
verify that it is in fact 0000:03:02.0.

$ ls -l /sys/bus/pci/devices/ | grep 06:
0000:06:00.0 -> ../../../devices/pci0000:00/0000:00:01.2/0000:02:00.0/0000:03:02.0/0000:06:00.0
0000:06:00.1 -> ../../../devices/pci0000:00/0000:00:01.2/0000:02:00.0/0000:03:02.0/0000:06:00.1

>  Also, Can you please print the runtime PM control entry as well
> 
>  /sys/bus/pci/devices/<root_port B:D:F>/power/control

I now printed it in my reply to your other message, and I also did so
while collecting information in response to Alex's email. Hope it helps.

>  Thanks,
>  Abhishek

--
Tasos

