Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61198530CAF
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbiEWJJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiEWJJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:09:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2804146161
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653296981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iiJoNC4cyHvx2BKnLiDMM9HSl7HykCHmZB46fRqGBtQ=;
        b=JJ625QRqsBVsFUf4uWFM5jIoz/X9vmNkB9MQVem6u7sqNhwgjYzvo9Hans6x82idSBRGMZ
        3EKRHPHhBg6IW5dVawE2bM3mANIOIKdQ2Gl+60uScYhFJ7sFiH6FRCF65VdaJsh8P6rHsO
        1289JWhUwjRhsd3M7LjwwmdYdZjlGOI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-n83HsdIMNBGBsCm9f6bh_A-1; Mon, 23 May 2022 05:09:40 -0400
X-MC-Unique: n83HsdIMNBGBsCm9f6bh_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B24EC29ABA13;
        Mon, 23 May 2022 09:09:39 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8E0540D2820;
        Mon, 23 May 2022 09:09:38 +0000 (UTC)
Message-ID: <8df9e80a53765fb339bff8e228f6f7d0a9993a94.camel@redhat.com>
Subject: Re: [Bug 216017] New: KVM: problem virtualization from kernel 5.17.9
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     bugzilla-daemon@kernel.org, kvm@vger.kernel.org
Date:   Mon, 23 May 2022 12:09:37 +0300
In-Reply-To: <bug-216017-28872@https.bugzilla.kernel.org/>
References: <bug-216017-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-23 at 08:48 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216017
> 
>             Bug ID: 216017
>            Summary: KVM: problem virtualization from kernel 5.17.9
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 5.17.9-arch1-1
>           Hardware: AMD
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Keywords: opw
>           Severity: high
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: ne-vlezay80@yandex.ru
>         Regression: No
> 
> Qemu periodically chaches width:
> 
> [root@router ne-vlezay80]# qemu-system-x86_64 -enable-kvm
> qemu-system-x86_64: error: failed to set MSR 0xc0000104 to 0x100000000
> qemu-system-x86_64: ../qemu-7.0.0/target/i386/kvm/kvm.c:2996: kvm_buf_set_msrs:
> Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> Aborted (core dumped)

This is my fault. You can either revert the commit you found in qemu,
or update the kernel to 5.18.

> 
> Also if running virtual pachine width type -cpu host, system is freezez from
> kernel panic. 

Can you check if this happens with 5.18 as well? If so, try to capture the panic message.


Best regards,
	Maxim Levitsky

> 
> Kernel version: 5.17.9
> Distribution: Arch Linux
> QEMU: 7.0
> CPU: AMD Phenom X4
> Arch: x86_64
> 


