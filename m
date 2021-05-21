Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7432338C2E0
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235995AbhEUJTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:19:00 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:43171 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235988AbhEUJS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 05:18:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1621588658; x=1653124658;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=qP5rIrggqubBpYoJjMi9a5/TgC6a6gG6fXhPrFiU3mM=;
  b=Hf33LtSYLB+dOAKg4RQvvicf+2V5d0wbC3RNpzWN55sx4Sac1zV0Sa2u
   wgkTywcW/vsQlUGk5vB1Es2pq3gEmB6wG6D6/sO7DClivHod3Pk78VuUE
   pMwIcxoZwNLi58L9OV8I5yNeZP5WUcjvo0Y80zmGBqeIf6j4/z2fehLpn
   I=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="110834211"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 21 May 2021 09:17:29 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 31662A1C8C;
        Fri, 21 May 2021 09:17:28 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.161.63) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 09:17:23 +0000
Date:   Fri, 21 May 2021 11:17:19 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Windows fails to boot after rebase to QEMU master
Message-ID: <20210521091451.GA6016@u366d62d47e3651.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.63]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After a rebase to QEMU master, I am having trouble booting windows VMs.
Git bisect indicates commit f5cc5a5c1686 ("i386: split cpu accelerators
from cpu.c, using AccelCPUClass") to have introduced the issue. I spent
some time looking at into it yesterday without much luck.

Steps to reproduce:

    $ ./configure --enable-kvm --disable-xen --target-list=x86_64-softmmu --enable-debug
    $ make -j `nproc`
    $ ./build/x86_64-softmmu/qemu-system-x86_64 \
        -cpu host,hv_synic,hv_vpindex,hv_time,hv_runtime,hv_stimer,hv_crash \
        -enable-kvm \
        -name test,debug-threads=on \
        -smp 1,threads=1,cores=1,sockets=1 \
        -m 4G \
        -net nic -net user \
        -boot d,menu=on \
        -usbdevice tablet \
        -vnc :3 \
        -machine q35,smm=on \
        -drive if=pflash,format=raw,readonly=on,unit=0,file="../OVMF_CODE.secboot.fd" \
        -drive if=pflash,format=raw,unit=1,file="../OVMF_VARS.secboot.fd" \
        -global ICH9-LPC.disable_s3=1 \
        -global driver=cfi.pflash01,property=secure,value=on \
        -cdrom "../Windows_Server_2016_14393.ISO" \
        -drive file="../win_server_2016.qcow2",format=qcow2,if=none,id=rootfs_drive \
        -device ahci,id=ahci \
        -device ide-hd,drive=rootfs_drive,bus=ahci.0

If the issue is not obvious, I'd like some pointers on how to go about
fixing this issue.

~ Sid.




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



