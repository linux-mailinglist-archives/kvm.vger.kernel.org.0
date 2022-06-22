Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC430554A64
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 15:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348980AbiFVNAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 09:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiFVNAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 09:00:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09A002F66E
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 06:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655902831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hN8tIIBWtCk+CeOF1uirY9J55+TzIaWvcTnvh7BRfH0=;
        b=egBQLDf8TYQgV95AniZTva2Q6FQomkmLR8nRNMFEK/LR4F1sKInhlrvkECotDspJKog8Kf
        JuOx5Oq+HFVKc1aohALyBdSwafGUR8ZqOJBF+FHvwgHt1ESLxiaLa4mF8w/3yvlfCQ9qkr
        TbylUDze6b+Rjjv5PauxXScEyd9bfRY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-rr_xVzlvM22rFCY91Of8UQ-1; Wed, 22 Jun 2022 09:00:30 -0400
X-MC-Unique: rr_xVzlvM22rFCY91Of8UQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D58AC2932483;
        Wed, 22 Jun 2022 13:00:29 +0000 (UTC)
Received: from starship (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1936940CF8EF;
        Wed, 22 Jun 2022 13:00:28 +0000 (UTC)
Message-ID: <e9a8dd7e8bf44678db4456fcac98bad358138348.camel@redhat.com>
Subject: Re: [Bug 213781] KVM: x86/svm: The guest (#vcpu>1) can't boot up
 with QEMU "-overcommit cpu-pm=on"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     bugzilla-daemon@kernel.org, kvm@vger.kernel.org
Date:   Wed, 22 Jun 2022 16:00:28 +0300
In-Reply-To: <bug-213781-28872-Xt10WwYFfk@https.bugzilla.kernel.org/>
References: <bug-213781-28872@https.bugzilla.kernel.org/>
         <bug-213781-28872-Xt10WwYFfk@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-06-22 at 12:49 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=213781
> 
> Like Xu (like.xu.linux@gmail.com) changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>      Kernel Version|5.14.0-rc1+                 |5.19.0-rc1+
> 
> --- Comment #4 from Like Xu (like.xu.linux@gmail.com) ---
> The issue still exits on the AMD after we revert the commit in 31c25585695a.
> 
> Just confirmed that it's caused by non-atomic accesses to memslot:
> - __do_insn_fetch_bytes() from the prot32 code page #NPF;
> - kvm_vm_ioctl_set_memory_region() from user space;
> 
> Considering the expected result [selftests::test_zero_memory_regions on x86_64]
> is that the guest will trigger an internal KVM error due to the initial code
> fetch encountering a non-existent memslot and resulting in an emulation
> failure.
> 
> More similar cases will gradually emerge. I'm not sure if KVM has documentation
> pointing out this restriction on memslot updates (fix one application QEMU may
> be one-sided), or any need to add something unwise like check
> gfn_to_memslot(kvm, gpa_to_gfn(cr2_or_gpa)) in the x86_emulate_instruction().
> 
> Any other suggestions ?
> 

Yep, agree. This has to be fixed on qemu and kvm level (kvm needs new API to upload
atomaically a set of memslot changes (easy part), and the qemu needs code to
batch the memslot updates when it does SMM related memslot updates.

Best regards,
	Maxim Levitsky

