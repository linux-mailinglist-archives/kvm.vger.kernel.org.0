Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919E73B2433
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 02:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFXAN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 20:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFXAN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 20:13:29 -0400
Received: from forward100j.mail.yandex.net (forward100j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3D7C061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 17:11:10 -0700 (PDT)
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id C05CB50E1B30;
        Thu, 24 Jun 2021 03:11:08 +0300 (MSK)
Received: from vla1-4c700811e81f.qloud-c.yandex.net (vla1-4c700811e81f.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:371c:0:640:4c70:811])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id B902A61E0002;
        Thu, 24 Jun 2021 03:11:08 +0300 (MSK)
Received: from vla3-3dd1bd6927b2.qloud-c.yandex.net (vla3-3dd1bd6927b2.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:3dd1:bd69])
        by vla1-4c700811e81f.qloud-c.yandex.net (mxback/Yandex) with ESMTP id mU4JnxPrUo-B8HCFb2Q;
        Thu, 24 Jun 2021 03:11:08 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624493468;
        bh=q6gyZnXzCWgExf6NgX3DtoSs8Np+fIcRa+P7iToN5SI=;
        h=In-Reply-To:To:From:Subject:Message-ID:Cc:Date:References;
        b=C0GfhDVXf+VvKY6fr+FbY3bXvHs/yDE7Dx84Zmh7OsJDM2Nlw1G1b57rnszbJr/Sr
         DXFmR0hCsx8ijMWEj4u5XY9JyKuKTYL/WQ/+mUhICR7xE/GAJGmflCc5QiYa9QJc1H
         wGg/ZCfMl3REKTyK1M0clWZwgpJlSKnU9Osby96s=
Authentication-Results: vla1-4c700811e81f.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-3dd1bd6927b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id SVNDCeaBpU-B8miA5hx;
        Thu, 24 Jun 2021 03:11:08 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: exception vs SIGALRM race (with test-case now!)
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
Message-ID: <cbaa0b83-fc3a-5732-4246-386a0a0ff9b8@yandex.ru>
Date:   Thu, 24 Jun 2021 03:11:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4f40a6e8-07ce-ba12-b3e6-5975ad19a2ff@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

24.06.2021 02:38, stsp пишет:
> The test-case:
> https://github.com/dosemu2/dosemu2/issues/1500#issuecomment-867215291 
URL was off 1 comment.
The right one is:
https://github.com/dosemu2/dosemu2/issues/1500#issuecomment-867214782

Direct link to the test-case:
https://github.com/dosemu2/dosemu2/files/6705274/a.exe.gz
