Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69000263378
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgIIPpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 11:45:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43022 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730438AbgIIPom (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Sep 2020 11:44:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599666256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Z+yPEMCTmeMzDKoGBf7peDSr8BK2RKJoBhQ4aH3NRo=;
        b=UkbxbeN1us4Uvyq8uj28efWND51RqtBytxvkuEb+RllQUsBQvLJ9pcZNhOzqvHKVzpSBsQ
        5DIAfuZpVExU4xrcizJDbF1dQF+2WyjjQVM+2CdkBwDs+T4wi2ydX7NHT/WqALR/BweH2/
        xhfQJfYZxoKP87bDIU8LpIx245av9Bo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-ek1SMh84NSq0ZRU3QtpJbQ-1; Wed, 09 Sep 2020 09:24:29 -0400
X-MC-Unique: ek1SMh84NSq0ZRU3QtpJbQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1053C100746A;
        Wed,  9 Sep 2020 13:24:26 +0000 (UTC)
Received: from lacos-laptop-7.usersys.redhat.com (ovpn-114-82.ams2.redhat.com [10.36.114.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA0C15D9E8;
        Wed,  9 Sep 2020 13:24:20 +0000 (UTC)
Subject: Re: [PATCH v7 71/72] x86/efi: Add GHCB mappings when SEV-ES is active
From:   Laszlo Ersek <lersek@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        brijesh.singh@amd.com
Cc:     Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-72-joro@8bytes.org> <20200908174616.GJ25236@zn.tnic>
 <CAMj1kXHbePrDYXGbVG0fHfH5=M19ZpCLm9YVTs-yKTuR_jFLDg@mail.gmail.com>
 <e3911fe6-84e8-cb50-d95d-e33f8ae005f8@redhat.com>
Message-ID: <0524c7fa-2fe2-ab6a-01f9-a04dacf86f6d@redhat.com>
Date:   Wed, 9 Sep 2020 15:24:19 +0200
MIME-Version: 1.0
In-Reply-To: <e3911fe6-84e8-cb50-d95d-e33f8ae005f8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/20 14:44, Laszlo Ersek wrote:

> To summarize: for QemuFlashFvbServicesRuntimeDxe to allocate UEFI
> Runtime Services Data type memory, for its own runtime GHCB, two
> permissions are necessary (together), at OS runtime:
> 
> - QemuFlashFvbServicesRuntimeDxe must be allowed to swap MSR_SEV_ES_GHCB
>   temporarily (before executing VMGEXIT),
> 
> - QemuFlashFvbServicesRuntimeDxe must be allowed to change the OS-owned
>   PTE temporarily (for remapping the GHCB as plaintext, before writing
>   to it).

Condition#2 gets worse:

If the firmware-allocated runtime GHCB happens to be virt-mapped by the
OS using a 2MB page (covering other UEFI runtime data areas, perhaps?),
then simply flipping the encryption bit in
QemuFlashFvbServicesRuntimeDxe would mark more runtime memory than just
the GHCB as "plaintext". (2MB-4KB specifically.)

This could result in:
- firmware read accesses outside of the GHCB returning garbage
- firmware write accesses ouside of the GHCB leaking information to the
hypervisor, and reading back later as garbage

In order to prevent those symptoms, the firmware would have to split the
2MB page to 4KB pages, and decrypt just the one (GHCB) page.

But page splitting requires additional memory (for the finer granularity
page table), and fw memory cannot be allocated at OS runtime. So that
extra memory too would have to be pre-allocated by the firmware. Nasty.

I'd recommend sticking with this kernel patch.

Thanks,
Laszlo

