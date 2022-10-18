Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CE8602CA6
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 15:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiJRNPt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 18 Oct 2022 09:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiJRNPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 09:15:31 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCB79C20B
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 06:15:28 -0700 (PDT)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MsDny6p2hz688Kq;
        Tue, 18 Oct 2022 21:13:42 +0800 (CST)
Received: from lhrpeml100004.china.huawei.com (7.191.162.219) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 15:15:25 +0200
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100004.china.huawei.com (7.191.162.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 14:15:25 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.031;
 Tue, 18 Oct 2022 14:15:25 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     "quintela@redhat.com" <quintela@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: RE: KVM Call for 2022-10-18
Thread-Topic: KVM Call for 2022-10-18
Thread-Index: AQHY37VkOnBjdkxbIUaY587Mhc9eLa4UJvhQ
Date:   Tue, 18 Oct 2022 13:15:25 +0000
Message-ID: <6834adc6bf3a4921b69f1513f642d2e6@huawei.com>
References: <871qran29t.fsf@secure.mitica>
In-Reply-To: <871qran29t.fsf@secure.mitica>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Qemu-devel
> [mailto:qemu-devel-bounces+shameerali.kolothum.thodi=huawei.com@nong
> nu.org] On Behalf Of Juan Quintela
> Sent: 14 October 2022 11:11
> To: kvm-devel <kvm@vger.kernel.org>; qemu-devel@nongnu.org
> Subject: KVM Call for 2022-10-18
> 
> 
> 
> Hi
> 
> Please, send any topic that you are interested in covering.
> 
> For next week, we have a topic:
> 
> - VFIO and migration
> 
> We are going to discuss what to do with vfio devices that support
> migration.  See my RFC on the list, so far we are discussing:
> 
> - we need a way to know the size of the vfio device state
>   (In the cases we are discussing, they require that the guest is
>   stopped, so I am redoing how we calculate pending state).
> 
> - We need an estimate/exact sizes.
>   Estimate can be the one calculated last time.  This is supposed to be
>   fast, and needs to work with the guest running.
>   Exact size is just that, we have stopped the guest, and we want to
>   know how big is the state for this device, to know if we can complete
>   migration ore we will continue in iterative stage.
> 
> - We need to send the state asynchronously.
>   VFIO devices are very fast at doing whatever they are designed to do.
>   But copying its state to memory is not one of the things that they do
>   fast.  So I am working in an asynchronous way to copy that state in
>   parallel.  The particular setup that caused this problem was using 4
>   network vfio cards in the guest.  Current code will:
> 
>   for i in network cards:
>      copy the state from card i into memory
>      send the state from memory from card i to destination
> 
>   what we want is something like:
> 
>   for i in network cards:
>      start asyrchronous copy the state from card i into memory
> 
>   for i in network cards:
>      wait for copy the state from card i into memory to finish
>      send the state from memory from card i to destination
> 
> So the cards can tranfer its state to memory in parallel.
> 
> 
> At the end of Monday I will send an email with the agenda or the
> cancellation of the call, so hurry up.
> 
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.
> 
>  Call details:
> 
> By popular demand, a google calendar public entry with it
> 
> 
> https://calendar.google.com/calendar/u/0?cid=ZWdlZDdja2kwNWxtdTF0bm
> d2a2wzdGhpZHNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
> 
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
Hi,

Just wondering did this call happen? Tried joining in as it was showing
14:00-15:00 in my google calendar(BST), but no luck.

Thanks,
Shameer

> 
> If you need phone number details,  contact me privately
> 
> Thanks, Juan.
> 

