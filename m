Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5714D3B4AF5
	for <lists+kvm@lfdr.de>; Sat, 26 Jun 2021 01:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFYXiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 19:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFYXiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 19:38:04 -0400
Received: from forward105o.mail.yandex.net (forward105o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4FDC061574
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 16:35:43 -0700 (PDT)
Received: from myt6-de4b83149afa.qloud-c.yandex.net (myt6-de4b83149afa.qloud-c.yandex.net [IPv6:2a02:6b8:c12:401e:0:640:de4b:8314])
        by forward105o.mail.yandex.net (Yandex) with ESMTP id 393FF42026AD;
        Sat, 26 Jun 2021 02:35:37 +0300 (MSK)
Received: from myt5-aad1beefab42.qloud-c.yandex.net (myt5-aad1beefab42.qloud-c.yandex.net [2a02:6b8:c12:128:0:640:aad1:beef])
        by myt6-de4b83149afa.qloud-c.yandex.net (mxback/Yandex) with ESMTP id lsokDwzOVO-ZbHGjH0o;
        Sat, 26 Jun 2021 02:35:37 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624664137;
        bh=bowLc6+ohzqHutWRExd2XBigpxHCOb+6enlSvXoKGDY=;
        h=In-Reply-To:To:From:Subject:Message-ID:Cc:Date:References;
        b=dq3xd5RJDdrz6F/P0LI948qFIUctiXFbrCLkLc6CmUVB8nWqVb4/cV02YW0vwrBUZ
         Qlges9d2MJtyStoU9KfwGDemFN9d7LSgSDNpmx2YjbyCoJ7IKjoHCAgCb/yQzBoTmi
         8ny75iphruMp4XZATrsaVsvq8yAvyAoVlcKHXhxk=
Authentication-Results: myt6-de4b83149afa.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt5-aad1beefab42.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id KMTZqYtZzq-Za2SOXug;
        Sat, 26 Jun 2021 02:35:36 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: exception vs SIGALRM race on core2 CPUs (with fix!)
From:   stsp <stsp2@yandex.ru>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
 <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <4f40a6e8-07ce-ba12-b3e6-5975ad19a2ff@yandex.ru>
 <cbaa0b83-fc3a-5732-4246-386a0a0ff9b8@yandex.ru>
 <60ae8b9f-89af-e8b3-13c4-99ddea1ced90@yandex.ru>
 <19022e7d-e1f5-06b5-f059-27172ca50011@yandex.ru>
Message-ID: <f09d851d-bda1-7a99-41cb-a14ea51e1237@yandex.ru>
Date:   Sat, 26 Jun 2021 02:35:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <19022e7d-e1f5-06b5-f059-27172ca50011@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

OK, I've finally found that this
fixes the race:

--- x86.c.old   2021-03-20 12:51:14.000000000 +0300
+++ x86.c       2021-06-26 02:28:37.082919492 +0300
@@ -9176,8 +9176,10 @@
                 if (__xfer_to_guest_mode_work_pending()) {
                         srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
                         r = xfer_to_guest_mode_handle_work(vcpu);
-                       if (r)
+                       if (r) {
+kvm_clear_exception_queue(vcpu);
                                 return r;
+}
                         vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
                 }
         }



This is where it returns to user
with the PF exception still pending.
So... any ideas?

