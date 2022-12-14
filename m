Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F0A64CF05
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 18:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbiLNR65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 12:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237499AbiLNR6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 12:58:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357D19FEA
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 09:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671040680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VUZqITjZteMvPI9KMJW3nUAiu5YmiAlbLdGTrkuXAqs=;
        b=AoMKpcJJSSp2jEkWd8OAJe8g5TpZ7xQ1LdxJhuRk+eYT7iEZXnlStuoqmHYEulRcJcwKgk
        QW2wtp8Hnw3RpLAMOtwDQAnlrYrOSYbU3+7Vs4ryf9OTYRuiX8PgwzQ93rJp7YI6kVE/Aa
        QLlAlXPuyQmEoiGg/ht6YLZ8HfFJCrY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-5iBR3g8wPNyZorywUAU2UA-1; Wed, 14 Dec 2022 12:57:58 -0500
X-MC-Unique: 5iBR3g8wPNyZorywUAU2UA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B28FF101A52E
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 17:57:58 +0000 (UTC)
Received: from starship (ovpn-192-71.brq.redhat.com [10.40.192.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2205F2166B29
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 17:57:57 +0000 (UTC)
Message-ID: <9c7d86d5fd56aa0e35a9a1533a23c90853382227.camel@redhat.com>
Subject: RFC: few questions about hypercall patching in KVM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date:   Wed, 14 Dec 2022 19:57:57 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!


Recently I had to debug a case of KVM's hypercall patching failing in a special case of running qemu under valgrind.
 
In nutshell what is happening is that qemu uses 'cpuid' instruction to gather some
info about the host and some of it
is passed to the guest cpuid, and that includes the vendor string.
 
Under valgrind it emulates the CPU (aka TCG), so qemu sees virtual cpu, with virtual cpuid which
has hardcoded vendor string
the 'GenuineIntel', so when your run qemu with KVM on AMD host, the guest will see Intel's vendor string regardless of other
'-cpu' settings (even -cpu host)
 
This ensures
that the guest uses the wrong hypercall instruction (vmcall instead of vmmcall), and sometimes it will use it after the guest kernel write protects its memory. 
This will lead to a failure of the
hypercall patching as the kvm writes to the guest memory
as if the instruction wrote to it, and this checks the permissions in the guest paging.

So the VMCALL instruction gets totally unexpected #PF.
 
 
1. Now I suggest that when hypercall patching fails, can we do kvm_vm_bugged() instead of forwarding the hypercall?
I know that vmmcall can be executed from ring 3 as well, so I can limit this to hypercall patching that happens when guest
ring is 0.


2. Why can't we just emulate the VMCALL/VMMCALL instruction in this case instead of patching? Any technical reasons for not doing this?
Few guests use it so the perf impact should be very small.


I can send a patch for either of two options if you agree with me.

Best regards,
	Maxim Levitsky

