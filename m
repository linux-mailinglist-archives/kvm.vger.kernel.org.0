Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4CB28DB8B
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 10:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgJNI3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 04:29:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728325AbgJNI3e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 04:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602664175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ay2KiFfdQQ+ULyuVIu9EMCKBauoiTeJO7YqRn+3s6dY=;
        b=TGnXIbhWrHL284tqBREYU7Tlm0+NCDL5pTOmhCOdxq9gAyIl0HDsmNrIDx2NhR1hTyBnLj
        kW4cteozbjSa/dTgVEXqs9+71fOmB8R4Nhmqc79ut5Y1j7wkQo6VqWjvziw/GBHLQ9j15a
        Ewep7uF7k9S/QgkS5fwd9s49AtD1bLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-GaK5RsY_NDu5mWnq1vJ9EQ-1; Wed, 14 Oct 2020 04:29:34 -0400
X-MC-Unique: GaK5RsY_NDu5mWnq1vJ9EQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC47D879528;
        Wed, 14 Oct 2020 08:29:32 +0000 (UTC)
Received: from starship (unknown [10.35.206.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF131610F3;
        Wed, 14 Oct 2020 08:29:24 +0000 (UTC)
Message-ID: <a4f3816dab09f4e28e33c66b8ff8273147415567.camel@redhat.com>
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     harry harry <hiharryharryharry@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     qemu-devel@nongnu.org, mathieu.tarral@protonmail.com,
        stefanha@redhat.com, libvir-list@redhat.com, kvm@vger.kernel.org
Date:   Wed, 14 Oct 2020 11:29:23 +0300
In-Reply-To: <CA+-xGqOMKRh+_5vYXeLOiGnTMw4L_gUccqdQ+HGSOzuTosp6tw@mail.gmail.com>
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
         <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
         <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
         <20201012165428.GD26135@linux.intel.com>
         <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
         <20201013045245.GA11344@linux.intel.com>
         <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
         <CA+-xGqMMa-DB1SND5MRugusDafjNA9CVw-=OBK7q=CK1impmTQ@mail.gmail.com>
         <a163c2d8-d8a1-dc03-6230-a2e104e3b039@redhat.com>
         <CA+-xGqOMKRh+_5vYXeLOiGnTMw4L_gUccqdQ+HGSOzuTosp6tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-10-13 at 16:36 -0400, harry harry wrote:
> Hi Paolo and Sean,
> 
> Thanks much for your prompt replies and clear explanations.
> 
> On Tue, Oct 13, 2020 at 2:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > No, the logic to find the HPA with a given HVA is the same as the
> > hardware logic to translate HVA -> HPA.  That is it uses the host
> > "regular" page tables, not the nested page tables.
> > 
> > In order to translate GPA to HPA, instead, KVM does not use the nested
> > page tables.
> 
> I am curious why KVM does not directly use GPAs as HVAs and leverage
> nested page tables to translate HVAs (i.e., GPAs) to HPAs? Is that
> because 1) the hardware logic of ``GPA -> [extended/nested page
> tables] -> HPA[*]'' is different[**] from the hardware logic of ``HVA
> -> [host regular page tables] -> HPA''; 2) if 1) is true, it is
> natural to reuse Linux's original functionality to translate HVAs to
> HPAs through regular page tables.
I would like to emphisise again. The HVA space is not fully free when a guest starts,
since it contains qemu's heap, code, data, and whatever qemu needs. However guest't
GPA address space must be allocated fully. E.g if qemu heap starts at 0x40000,
then guest can't have physical memory at 0x40000 following your suggestion, which
is wrong. It can be in theory done by blacklisting these areas via ACPI/BIOS provided
memory map, but that would be very very difficult to maintain and not worth it.

Best regards,
	Maxim Levitsky

> 
> [*]: Here, the translation means the last step for MMU to translate a
> GVA's corresponding GPA to an HPA through the extended/nested page
> tables.
> [**]: To my knowledge, the hardware logic of ``GPA -> [extended/nested
> page tables] -> HPA'' seems to be the same as the hardware logic of
> ``HVA -> [host regular page tables] -> HPA''. I appreciate it if you
> could point out the differences I ignored. Thanks!
> 
> Best,
> Harry
> 


