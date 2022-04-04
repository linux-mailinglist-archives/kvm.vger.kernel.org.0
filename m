Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1634F155C
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 15:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348305AbiDDNDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 09:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbiDDNDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 09:03:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A5983D1DB
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 06:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649077299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q0Bise5O6TSz+7qyEtLzRJH+KELzO9rApp6TJMkatIk=;
        b=IaawcgTBQb7MJtNawLeA4BSvGU4EUlZtwaCy8/UM04rCCQesbElrW5dyhIAUCQrxKtu68X
        ftBPw+etfnPQLlS3zSf8KlJeXBswch3JhfnLJzDuF0a6zt7o/6QaPt3KGVaTBhWmBqg6vc
        g8YC0ftjlqWJAoQu2+yDFCprFY+hfBM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-p03AlNOoOnCoNA8uzehHLQ-1; Mon, 04 Apr 2022 09:01:36 -0400
X-MC-Unique: p03AlNOoOnCoNA8uzehHLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A897899EC5;
        Mon,  4 Apr 2022 13:01:35 +0000 (UTC)
Received: from lacos-laptop-7.usersys.redhat.com (unknown [10.39.193.80])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EA21C54FB0;
        Mon,  4 Apr 2022 13:01:31 +0000 (UTC)
Subject: Re: General KVM/QEMU VM debugging techniques
To:     Igor Mammedov <imammedo@redhat.com>,
        "Kallol Biswas [C]" <kallol.biswas@nutanix.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gerd Hoffmann <kraxel@redhat.com>
References: <SJ0PR02MB886210F928C7CD01DFAD5FD0FEE09@SJ0PR02MB8862.namprd02.prod.outlook.com>
 <SJ0PR02MB8862328DCA089E7B5699B927FEE09@SJ0PR02MB8862.namprd02.prod.outlook.com>
 <20220404143630.02992ea4@redhat.com>
From:   Laszlo Ersek <lersek@redhat.com>
Message-ID: <2819c230-5470-c707-27c0-573d817b6db0@redhat.com>
Date:   Mon, 4 Apr 2022 15:01:30 +0200
MIME-Version: 1.0
In-Reply-To: <20220404143630.02992ea4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/04/22 14:36, Igor Mammedov wrote:
> On Fri, 1 Apr 2022 23:50:16 +0000
> "Kallol Biswas [C]" <kallol.biswas@nutanix.com> wrote:
> 
>> Hi,
>>     We are observing a problem with CPU hotplug.
>>
>> If secureboot option is enabled under UEFI  and then if we try to do CPU hotplug the VM crashes/just reboots.
>>
>> No crash dump is generated, no panic message, just VM restarts. Issue seems like: 
>> https://bugzilla.redhat.com/show_bug.cgi?id=1834250
> 
> CPU hotplug with SMM (for q35) was merged in QEMU-5.2
> and unplug part in 6.0, you also need a matching OVMF build
> to make it work. Later upto 6.2 (included) there were minor
> fixes dealing with incorrect configs.
> 
>> What are the debugging techniques we can apply to halt the VM and examine what's going on?
>> VM has been configured with crash dump.
> 
> I'd start with https://www.linux-kvm.org/page/Tracing
> 
> to find out when it goes south.
> 
>> Nucleodyne at Nutanix
>> 408-718-8164
>>
> 

Also don't forget to build OVMF with DEBUG_VERBOSE (set
gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel to 0x8040004F), and to
capture the OVMF debug log (-debugcon file:debug.log -global
isa-debugcon.iobase=0x402).

Laszlo

