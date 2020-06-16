Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B311FB178
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 15:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgFPNCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 09:02:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53780 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728489AbgFPNCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 09:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592312554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=wIOR77JDMY5v3PKdoDMr+SATH6lIHJUsaneUyJY4ZhY=;
        b=WZambqQB3SFf1JEq5x9YjwEDZ3z6Eftg7ei2MrqZABFkoFUYwUZnv+8fsy/vzvUbu+v052
        VuL4bOqM1tEVDnhU5Yt6Mr8R1pNtn/I835yM+/lPEfp0rHwSp+IsbSZworr4uquuUhO2mj
        CaD2JNfxZ5xeQ6ckgo8ezkOursiqkbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-3bE2nKfvP-CxhdodudfwMg-1; Tue, 16 Jun 2020 09:02:28 -0400
X-MC-Unique: 3bE2nKfvP-CxhdodudfwMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF378101635A
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 13:02:27 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D32A860C47;
        Tue, 16 Jun 2020 13:02:24 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] x86: always set up SMP
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     cavery@redhat.com
References: <20200608160033.392059-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <630b9d53-bac2-378f-aa0a-99f45a0e80d5@redhat.com>
Date:   Tue, 16 Jun 2020 15:02:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200608160033.392059-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 18.00, Paolo Bonzini wrote:
> Currently setup_vm cannot assume that it can invoke IPIs, and therefore
> only initializes CR0/CR3/CR4 on the CPU it runs on.  In order to keep the
> initialization code clean, let's just call smp_init (and therefore
> setup_idt) unconditionally.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/access.c              | 2 --
>  x86/apic.c                | 1 -
>  x86/asyncpf.c             | 1 -
>  x86/cmpxchg8b.c           | 1 -
>  x86/cstart.S              | 6 +++---
>  x86/cstart64.S            | 6 +++---
>  x86/debug.c               | 1 -
>  x86/emulator.c            | 1 -
>  x86/eventinj.c            | 1 -

 Hi Paolo,

this patch broke the eventinj test on i386 on gitlab:

 https://gitlab.com/huth/kvm-unit-tests/-/jobs/597447047#L1933

if I revert the patch, the test works again:

 https://gitlab.com/huth/kvm-unit-tests/-/jobs/597455720#L1934

Any ideas how to fix that?

 Thanks,
  Thomas

