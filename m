Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C64A57D04B
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 17:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbiGUPv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 11:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiGUPv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 11:51:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C79FA371AF
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 08:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658418685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g9Gr/xLPA3UpCIhasuYlmf5Lpml6E3tDbA9cQ5VBFXI=;
        b=GypMI3U0sbRLVIaYVJZSxsay9zlNDu67RHnzACXPDJODhsfrqxdmeruuGDzFLyiM8nM/ps
        GZTxS33FYyGILo1ZM8O7vMFw1feRMeTkItl0yQVZ7qXnXEflTc/FKelMC/nfkzFtOYGfZE
        JnSPErYEQK4C0Vj/REiWOGxiqJO2Z6Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-euG-bPILNcWIUfTzfaw7CA-1; Thu, 21 Jul 2022 11:51:15 -0400
X-MC-Unique: euG-bPILNcWIUfTzfaw7CA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A235E811E7A;
        Thu, 21 Jul 2022 15:51:13 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D4612166B29;
        Thu, 21 Jul 2022 15:51:11 +0000 (UTC)
Message-ID: <8ac992205e740722160f770821a49278bfa12b0a.camel@redhat.com>
Subject: Re: Guest reboot issues since QEMU 6.0 and Linux 5.11
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Fabian Ebner <f.ebner@proxmox.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Cc:     Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Mira Limbeck <m.limbeck@proxmox.com>
Date:   Thu, 21 Jul 2022 18:51:10 +0300
In-Reply-To: <eb0e0c7e-5b6f-a573-43f6-bd58be243d6b@proxmox.com>
References: <eb0e0c7e-5b6f-a573-43f6-bd58be243d6b@proxmox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 14:49 +0200, Fabian Ebner wrote:
> Hi,
> since about half a year ago, we're getting user reports about guest
> reboot issues with KVM/QEMU[0].
> 
> The most common scenario is a Windows Server VM (2012R2/2016/2019,
> UEFI/OVMF and SeaBIOS) getting stuck during the screen with the Windows
> logo and the spinning circles after a reboot was triggered from within
> the guest. Quitting the kvm process and booting with a fresh instance
> works. The issue seems to become more likely, the longer the kvm
> instance runs.
> 
> We did not get such reports while we were providing Linux 5.4 and QEMU
> 5.2.0, but we do with Linux 5.11/5.13/5.15 and QEMU 6.x.
> 
> I'm just wondering if anybody has seen this issue before or might have a
> hunch what it's about? Any tips on what to look out for when debugging
> are also greatly appreciated!
> 
> We do have debug access to a user's test VM and the VM state was saved
> before a problematic reboot, but I can't modify the host system there.
> AFAICT QEMU just executes guest code as usual, but I'm really not sure
> what to look out for.
> 
> That VM has CPU type host, and a colleague did have a similar enough CPU
> to load the VM state, but for him, the reboot went through normally. On
> the user's system, it triggers consistently after loading the VM state
> and rebooting.
> 
> So unfortunately, we didn't manage to reproduce the issue locally yet.
> With two other images provided by users, we ran into a boot loop, where
> QEMU resets the CPUs and does a few KVM_RUNs before the exit reason is
> KVM_EXIT_SHUTDOWN (which to my understanding indicates a triple fa
> ult)
> and then it repeats. It's not clear if the issues are related.


Does the guest have HyperV enabled in it (that is nested virtualization?)

Intel or AMD?

Does the VM uses secure boot / SMM?

Best regards,
	Maxim Levitsky

> 
> There are also a few reports about non-Windows VMs, mostly Ubuntu 20.04
> with UEFI/OVMF, but again, it's not clear if the issues are related.
> 
> [0]: https://forum.proxmox.com/threads/100744/
> (the forum thread is a bit chaotic unfortunately).
> 
> Best Regards,
> Fabi
> 
> 


