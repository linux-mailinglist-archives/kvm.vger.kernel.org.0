Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC3B21BA3D
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGJQCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:02:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726820AbgGJQCm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 12:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594396961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zl45dVHmDZx6IEfEZafVPCqEImSVzPw+lTIq9OVS82A=;
        b=FHPQyvg5CkBJfOpKRBadqCr4dTbK/AZXgpqsrhMBUcxlG478uHTjxms9YQP4uXpbnCRtSb
        Smik2zkj0whhVDsFiLSd/HLgFctpeZXKQKwtVHW0qA6XW2HmZebeTkpcY+ld/x3azhK2il
        vbpznpTyoS12R23xrpfr6FO+emzTcrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-PwVCdYqgM2SKbaDCfeWZqw-1; Fri, 10 Jul 2020 12:02:34 -0400
X-MC-Unique: PwVCdYqgM2SKbaDCfeWZqw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0B44800FF1;
        Fri, 10 Jul 2020 16:02:32 +0000 (UTC)
Received: from localhost (ovpn-116-140.rdu2.redhat.com [10.10.116.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93AD81002382;
        Fri, 10 Jul 2020 16:02:20 +0000 (UTC)
Date:   Fri, 10 Jul 2020 12:02:19 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        mtosatti@redhat.com,
        Pedro Principeza <pedro.principeza@canonical.com>,
        kvm list <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        qemu-devel@nongnu.org, Mohammed Gamal <mgamal@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, fw@gpiccoli.net,
        rth@twiddle.net
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
Message-ID: <20200710160219.GQ780932@habkost.net>
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
 <20200708171621.GA780932@habkost.net>
 <20200708172653.GL3229307@redhat.com>
 <20200709094415.yvdh6hsfukqqeadp@sirius.home.kraxel.org>
 <CALMp9eQnrdu-9sZhW3aXpK4pizOW=8G=bj1wkumSgHVNfG=CbQ@mail.gmail.com>
 <20200709191307.GH780932@habkost.net>
 <79aa7955-6bc1-d8b2-fed0-48a0990d9dea@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79aa7955-6bc1-d8b2-fed0-48a0990d9dea@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 09:22:42AM +0200, Paolo Bonzini wrote:
> On 09/07/20 21:13, Eduardo Habkost wrote:
> >> Doesn't this require intercepting MOV-to-CR3 when the guest is in PAE
> >> mode, so that the hypervisor can validate the high bits in the PDPTEs?
> > If the fix has additional overhead, is the additional overhead
> > bad enough to warrant making it optional?  Most existing
> > GUEST_MAXPHYADDR < HOST_MAXPHYADDR guests already work today
> > without the fix.
> 
> The problematic case is when host maxphyaddr is 52.  That case wouldn't
> work at all without the fix.

What can QEMU do to do differentiate "can't work at all without
the fix" from "not the best idea, but will probably work"?

-- 
Eduardo

